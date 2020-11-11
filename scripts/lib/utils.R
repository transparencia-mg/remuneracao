library(data.table)

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

write_cbmmg <- function(x, output) {
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
    str_replace("data-raw/cbmmg/", "data-raw/cbmmg/CBMMG_") %>% 
    str_replace(" ", "_") %>% 
    str_remove("20") %>% 
    str_replace_all(MESES) %>% 
    str_replace(".xlsx", ".csv") %>% 
    str_replace("data-raw", "data")
  
  result
}

read <- function(x) {
  
  schema <- jsonlite::read_json("schema.json")$fields
  
  col_names <- schema %>% map_chr("name")
  
  col_types <- schema %>% 
    map_chr("type") %>% 
    col_types_mapping()
  
  result <- readr::read_csv2(x, col_names = col_names, skip = 1, col_types = col_types, locale = locale(decimal_mark = ",", grouping_mark = "."))
  
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
  
  stopifnot(!anyNA(result))
  
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

validate_resource <- function(x) {
  
  datapackage <- jsonlite::read_json("datapackage.json")
  
  # recurso deve existir no datapackage.json para ser validado
  
  if(!x %in% map_chr(datapackage$resources, "name")) {
    stop(glue::glue("Recurso {x} não encontrado no arquivo datapackage.json"))
  }
  
  resource <- rlist::list.filter(datapackage$resources, x %in% name)[[1]]
  
  jsonlite::write_json(resource, path = "_resource.json", auto_unbox = TRUE, pretty = TRUE)
  
  system("frictionless validate --source-type resource _resource.json")
  
  file.remove("_resource.json")
}

create_resource <- function(dataset_id, resource_id) {
  
  datapackage <- jsonlite::read_json("datapackage.json")
  
  # recurso deve existir no datapackage.json para ser validado
  
  if(!resource_id %in% purrr::map_chr(datapackage$resources, "name")) {
    stop(glue::glue("Recurso {resource_id} não encontrado no arquivo datapackage.json"))
  }
  
  resource <- rlist::list.filter(datapackage$resources, resource_id %in% name)[[1]]
  
  res <- ckanr::resource_create(package_id = dataset_id,
                                name = resource$title,
                                description = resource$description,
                                upload = resource$path,
                                url = Sys.getenv("DADOSMG_DEV_HOST"), 
                                key = Sys.getenv("DADOSMG_DEV"))
  res
  
}