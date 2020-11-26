library(data.table); library(magrittr)

MESES <- c("JAN" = "01", "FEV" = "02", "MAR" = "03", "ABR" = "04",
           "MAI" = "05", "JUN" = "06", "JUL" = "07", "AGO" = "08",
           "SET" = "09", "OUT" = "10", "NOV" = "11", "DEZ" = "12")

read_cbmmg <- function(x) {
  result <- read_excel(x, skip = 2, col_names = FALSE)
  
  col_names <- c("masp", "nome", "descsitser", "nmefet",
                 "tem_apost", "desccomi", "descinst",
                 "carga_hora", "remuner", "teto",
                 "judic", "ferias", "decter",
                 "premio", "feriasprem", "jetons",
                 "eventual", "ir", "prev", "rem_pos",
                 "bdmg", "cemig", "codemig", "cohab",
                 "copasa", "emater", "epamig", "funpemg",
                 "gasmig", "mgi", "mgs", "prodemge", "prominas")
  
  result <- result %>% 
    select(1:33) %>% 
    set_names(col_names)
  
  result
}

recode_cbmmg <- function(x) {
  return <- x %>% 
              mutate(masp = str_replace(masp, pattern = "-", replacement = "")) %>% 
              mutate(masp = as.integer(masp))
  
  return
}

enrich_cbmmg <- function(x) {
  
  return <- x %>% 
    mutate(emip = 0) %>% 
    add_column(descunid = NA_character_, .after = "descinst")
  
  return
}

write_remuneracao <- function(x, output) {
  data.table::fwrite(x, file = output, sep = ";", dec = ",", bom = TRUE, na = "NA")
}

clean_headers_cbmmg <- function(x) {
  cols <- read_excel(x, col_names = FALSE, n_max = 2)
  
  col_names <- cols %>% 
    t() %>% 
    as_tibble() %>% 
    fill(V1) %>% 
    mutate(col_names = paste0(V2, "_", V1)) %>% 
    pull(col_names) %>% 
    stri_trans_general("latin-ascii") %>% 
    str_remove_all(" ") %>% 
    str_remove_all("^NA_") %>% 
    str_remove_all("_NA$") %>% 
    str_remove_all("_DEDUCOESOBRIGATORIAS$") %>% 
    str_remove_all("_JETONS$") %>% 
    str_remove_all("_REMUNERACAOEVENTUAL")
  
  col_names
}


make_names_output_files_cbmmg <- function(x) {
  result <- x %>% 
    str_remove("201\\d/\\d\\d? ") %>% 
    str_replace("data-raw/cbmmg/", "data-raw/cbmmg/cbmmg_") %>% 
    str_replace(" ", "_") %>% 
    str_remove("20") %>% 
    str_replace_all(MESES) %>% 
    str_replace(".xlsx", ".csv") %>% 
    str_replace("data-raw", "data") %>% 
    convert_filename_to_yyyy_mm() %>% 
    str_replace("_", "-")
    
  
  result
}

read_remuneracao_raw <- function(path, clean = TRUE) {
  
  result <- data.table::fread(path, sep = ";", colClasses = "character", encoding = "UTF-8")
  
  if(clean == TRUE) {
    result <- clean_remuneracao(result)
  }
  
  result
}

clean_remuneracao <- function(x) {
  result <- x %>% 
              clean_remove_extra_columns() 
  #%>% clean_coerce_masp_to_integer()
  
  result[]
}

clean_coerce_masp_to_integer <- function(x) {
  
  result <- data.table::copy(x)
  
  result[, masp := stringr::str_replace(masp, "(\\d)-(\\d$)", "\\1\\2")]
  
  if(!identical(x$masp, result$masp)) {
    diff <- waldo::compare(x$masp, result$masp)
    warning(diff)
  }
  
  result[]
}

clean_remove_extra_columns <- function(x) {
  col_names <- jsonlite::read_json("schema.json")$fields %>% purrr::map_chr("name")
  
  extra_cols_to_exclude <- setdiff(names(x), col_names)
  
  # if (length(extra_cols_to_exclude > 0)) {
  #   
  #   unique_values <- extra_cols_to_exclude %>% 
  #     purrr::map(~ unique(x[[.x]])) %>% 
  #     purrr::set_names(extra_cols_to_exclude)
  #   
  #   
  #   extra_cols_to_exclude %>% 
  #   purrr::map(~ glue::glue("Coluna {.x} com valores únicos ({paste0(unique_values[[.x]], collapse = ", ")}) removida.")) %>% 
  #   purrr::map(warning)
  #   
  # }
  
  x[, ..col_names]
}

read_remuneracao <- function(resource_id) {
  
  resource <- get_resource(resource_id)
  
  col_names <- get_col_names(resource_id)
  
  col_types <- get_col_types(resource_id) %>% col_types_mapping()
  
  result <- readr::read_csv2(resource$path, col_names = col_names, skip = 1, col_types = col_types, locale = readr::locale(decimal_mark = ",", grouping_mark = "."))
  
  #stop_for_problems(result)
  
  result
}

col_types_mapping <- function(x) {
  
  mapping <- c("string" = "c", 
               "number" = "n", 
               "integer" = "i", 
               "boolean" = "l", 
               "date" = "D", 
               "year" = "i")
  
  result <- unname(mapping[x])
  
  if(anyNA(result)) {
    stop("Não foi possível encontrar o tipo da variável.")
  }
  
  paste0(result, collapse = "")
}


mask_unidades_administrativas <- function(x) {
  
  unidades <- readxl::read_excel("data-raw/classificacao_unidades_SEJUSP.xlsx") %>% 
    dplyr::select(descunid, texto_exibicao) %>% 
    unique()
  
  
  result <- dplyr::left_join(x, unidades, by = "descunid")
  
  result <- as.data.table(result)
  
  result[!is.na(texto_exibicao), descunid := texto_exibicao]
  
  result[, texto_exibicao := NULL]
  
  result[]
  
}

convert_filename_to_yyyy_mm <- function(x) {
  
  mm_yyyy <- x %>% 
    str_extract("_\\d{2}_\\d{2}") %>% 
    str_remove("^_") %>% 
    str_replace("_", "_20")
  
  yyyy_mm <- paste(str_sub(mm_yyyy, 4, 7), str_sub(mm_yyyy, 1, 2), sep = "-") 
  
  result <- x %>% 
    str_replace("\\d{2}_\\d{2}", yyyy_mm)
  
  result
}

summarize_servidores_ <- function(x) {
  
  path <- file.path(glue::glue("data/{x}.csv"))
  
  yyyy_mm <- stringr::str_sub(x, 12, 18)
  yyyy <- as.integer(stringr::str_sub(x, 12, 15))
  mm <- as.integer(stringr::str_sub(x, 17, 18))
  yyyy_mm_dd <- as.Date(paste0(yyyy_mm, "-01"))
  
  
  numeric_cols <- c("rem_pos", "remuner", "teto", "ferias", "decter", "premio",
                    "feriasprem", "jetons", "eventual", "ir", "prev", "bdmg",
                    "cemig", "codemig", "cohab", "copasa", "emater", "epamig",
                    "funpemg", "gasmig", "mgi", "mgs", "prodemge", "prominas", "emip")
  
  dt <- fread(path, sep2 = ";", colClasses = "character")
  
  for (col in numeric_cols) {
    set(dt, j = col, value = as_numeric(dt[[col]]))
  }
  
  result <- dt[, lapply(.SD, sum), by = c("descinst", "descunid"), .SDcols = numeric_cols]
  
  result[, DATA := yyyy_mm_dd]
  result[, ANO := yyyy]
  result[, MES := mm]
  result[, PERIODO := yyyy_mm]
  
  result[]
  
}

summarize_servidores <- purrr::safely(summarize_servidores_)

as_numeric <- function(x) {
  return <- readr::parse_number(x, locale = locale(decimal_mark = ",", grouping_mark = "."))
  stop_for_problems(return)
  return
}

insert_remuneracao_sqlite <- function(resource_id, conn, table) {
  
  resource <- get_resource(resource_id)
  
  dt <- read_remuneracao_raw(resource$path, clean = TRUE)
  
  yyyy_mm <- stringr::str_extract(resource_id, "\\d{4}-\\d{2}")
  dt$year <- stringr::str_sub(yyyy_mm, 1, 4)
  dt$month <- stringr::str_sub(yyyy_mm, 6, 7)
  dt$data <- paste0(yyyy_mm, "-01")
  
  # new code should prefer dbCreateTable() and dbAppendTable()
  # wait fix for https://github.com/r-dbi/RSQLite/issues/306
  result <- dbWriteTable(conn, table, dt, append = TRUE)
  
  print(resource_id, result)
  
  result
}

is_wholenumber <- function(x, tol = .Machine$double.eps^0.5) {
  # vide seção exemplos da documentação help("is.integer")
  abs(x - round(x)) < tol
} 