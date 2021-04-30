library(data.table); library(magrittr)

MESES <- c("JAN" = "01", "FEV" = "02", "MAR" = "03", "ABR" = "04",
           "MAI" = "05", "JUN" = "06", "JUL" = "07", "AGO" = "08",
           "SET" = "09", "OUT" = "10", "NOV" = "11", "DEZ" = "12")

all_duplicated <- function(x) {
  duplicated(x, fromLast = TRUE) | duplicated(x, fromLast = FALSE)
}

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
  write.csv2(x, output, fileEncoding = "CP1252", row.names = FALSE, quote = FALSE)
}

clean_headers_cbmmg <- function(x) {
  cols <- readxl::read_excel(x, col_names = paste0("v", 1:34), n_max = 2)
  
  col_names <- cols %>% 
    t() %>% 
    tibble::as_tibble() %>% 
    tidyr::fill(V1) %>% 
    dplyr::mutate(col_names = ifelse(is.na(V2), V1, V2)) %>% 
    dplyr::pull(col_names) %>% 
    janitor::make_clean_names()
  
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

read_remuneracao_raw <- function(path) {
  
  result <- data.table::fread(path, sep = ";", colClasses = "character", encoding = "UTF-8")
  
  result
}

rm_masp_hyphen <- function(dt) {
  
  dt[, masp := stringr::str_replace(masp, "(\\d)-(\\d$)", "\\1\\2")]
    
  dt[]
}

rm_extra_empty_columns <- function(dt) {
  col_names <- jsonlite::read_json("schema.json")$fields %>% purrr::map_chr("name")
  
  extra_cols_to_exclude <- setdiff(names(dt), col_names)
  
  # colunas sao retornadas na ordem em que estao listadas no schema.json
  dt[, ..col_names]
}

read_remuneracao <- function(path) {
  
  resource_id <- "servidores-2020-01"
  
  resource <- get_resource(resource_id)
  
  col_names <- get_col_names(resource_id)
  
  file_ext <- tools::file_ext(path)
  
  if(file_ext == "csv") {
    col_types <- get_col_types(resource_id) %>% col_types_mapping(to = "readr")
    result <- readr::read_csv2(path, locale = readr::locale(decimal_mark = ",", grouping_mark = "."))
  } else if(file_ext == "xlsx") {
    col_types <- get_col_types(resource_id) %>% col_types_mapping(to = "readxl")
    infer_cols_spec <- names(readxl::read_excel(path, n_max = 1))
    
    stopifnot(all(infer_cols_spec == col_names))
    
    result <- readxl::read_xlsx(path, col_types = col_types)
    
  } else {
    stop(glue::glue("Extensão do arquivo {file_ext} não reconhecida."))
  }
  
  
  
  #stop_for_problems(result)
  
  data.table::as.data.table(result)
}

col_types_mapping <- function(x, to) {
  
  if(to == "readr") {
    mapping <- c("string" = "c", 
                 "number" = "n", 
                 "integer" = "i", 
                 "boolean" = "l", 
                 "date" = "D", 
                 "year" = "i")
  } else if (to == "readxl") {
    mapping <- c("string" = "text", 
                 "number" = "numeric", 
                 "integer" = "numeric", 
                 "boolean" = "logical", 
                 "date" = "date", 
                 "year" = "numeric")
  } else {
    stop(glue::glue("Valor {to} para argumento to desconhecido."))
  }
  
  result <- unname(mapping[x])
  
  if(anyNA(result)) {
    stop("Não foi possível encontrar o tipo da variável.")
  }
  
  if(to == "readr") {
    paste0(result, collapse = "")
  } else {
    result
  }
}

mask_descunid_pcmg <- function(dt) {
  dt[
    descinst == "POLICIA CIVIL",
    descunid := "INF. SIGILOSA"
  ]
  
  dt[]
}

mask_descunid_pmmg <- function(dt) {
  dt[
    descinst == "POLICIA MILITAR DE MINAS GERAIS",
    descunid := "INF. SIGILOSA"
  ]
  
  dt[]
}

mask_descunid_gmg <- function(dt) {
  
  dt[
    descinst == "GABINETE MILITAR", 
    descunid := "INF. SIGILOSA"
  ]
  
  dt[]
}


mask_descunid_sejusp <- function(dt) {

  setor_seguranca <- c("DEFESA SOCIAL", # Secretaria de Estado de Defesa Social de Minas Gerais - SEDS
                       "ADMINISTRACAO PRISIONAL", # Secretaria de Estado de Administração Prisional - SEAP - 2016
                       "SEGURANCA PUBLICA", # Secretaria de Estado de Segurança Pública - SESP - 2016
                       "SECRETARIA DE JUSTICA E SEGURANCA PUBLICA") # Secretaria de Estado de Justiça e Segurança Pública - SEJUSP - 2019

  dt[
    descinst %in% setor_seguranca,
    descunid := "INF. SIGILOSA"
  ]
    
  dt[]
  
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

coerce_verbas_remun_to_numeric <- function(dt) {
  
  id <- "servidores-2020-01"
  
  numeric_cols <- c("remuner", "teto", "ferias", "decter", "premio", "feriasprem", 
                    "jetons", "eventual", "ir", "prev", "rem_pos", "bdmg", "cemig", 
                    "codemig", "cohab", "copasa", "emater", "epamig", "funpemg", 
                    "gasmig", "mgi", "mgs", "prodemge", "prominas", "emip", "codemge", 
                    "emc")
  
  for (col in numeric_cols) {
    data.table::set(dt, j = col, value = tidyr::replace_na(as_numeric(dt[[col]]), 0))
  }
  
  dt[]
  
}

fix_jetons <- function(dt) {
  
  col_names <- jsonlite::read_json("schema.json")$fields %>% purrr::map_chr("name")
  
  if(!"funpemg" %in% names(dt)) {
    dt[, funpemg := "0"]
  }
  
  if(!"codemig" %in% names(dt)) {
    dt[, codemig := "0"]
  }
  
  # if("codemge" %in% names(dt)) {
  #   data.table::setnames(dt, "codemge", "codemig")
  # }
  
  # emc e codemge são excluídas em rm_extra_empty_columns()
  
  dt
}

as_numeric <- function(x) {

  # se x nao for caracter readr::parse_number lanca um erro
  result <- readr::parse_number(x, locale = readr::locale(decimal_mark = ",", grouping_mark = "."))

  result
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


normalize_text_basic <- function(x) {
  result <- x %>% 
    stringr::str_squish() %>% # espacos iniciais, finais e multiplos espacos
    stringr::str_to_upper() %>% # caixa alta
    stringi::stri_trans_general("latin-ascii") # acentos
  
  result
}

normalize_text_full <- function(x) {
  result <- x %>% 
    normalize_text_basic() %>% 
    stringr::str_replace_all("[[:punct:]]", " ") %>% # pontuacao
    textclean::replace_non_ascii() # caracters fora nao ASCI
  
  result
}

normalize_text_descunid <- function(dt) {
  
  data.table::set(dt, j = "descunid", value = normalize_text_basic(dt[["descunid"]]))
  
  dt[]
  
}

normalize_text_descinst <- function(dt) {
  
  data.table::set(dt, j = "descinst", value = normalize_text_full(dt[["descinst"]]))
  
  dt[]
  
}

rm_header_row_from_data_content <- function(dt) {
  nrows <- nrow(dt)
  
  dt <- dt[!masp %in% c("MASP", "masp")]
  dt <- dt[!bdmg %in% c("BDMG", "masp")]
  
  if(nrows != nrow(dt)) {
    warning("Foi removido um cabeçalho das linhas do arquivo.")
  }
  
  dt[]
}

normalize_text_designado_ao_servico_ativo <- function(dt) {
  
  regex <- "DESIGNADO (P/ O|PARA O) SER.+ ATIVO"
  
  dt[stringr::str_detect(descsitser, regex), descsitser := "DESIGNADO AO SERVICO ATIVO"]
  
  data.table::set(dt, j = "descsitser", value = normalize_text_basic(dt[["descsitser"]]))
  
  dt[]
  
}

impute_value_rem_pos_cbmmg <- function(dt) {
  
  dt[
    descinst == "CBMMG", 
    rem_pos := remuner - teto + ferias + decter + premio + feriasprem + jetons + eventual - ir - prev
  ]
  
  dt[]
}

is_rem_pos_valid <- function(dt) {
  rem_post_derived <- dt[, 
    round(remuner - teto + ferias + decter + premio + feriasprem + jetons + eventual - ir - prev, 2)
  ]
  
  # result <- waldo::compare(round(dt$rem_pos, 2), rem_post_derived)
  
  result <- round(dt$rem_pos, 2) == rem_post_derived
  
  result
}

is_rem_pos_equal <- function(dt_ref, dt) {
  round(dt_ref$rem_pos, 2) == round(dt$rem_pos, 2)
}

clean_resource <- function(dt) {
  
  dt <- dt %>% rm_header_row_from_data_content() %>% 
    rm_masp_hyphen() %>% 
    fix_jetons() %>% 
    rm_extra_empty_columns() %>% 
    coerce_verbas_remun_to_numeric() %>% 
    normalize_text_descinst() %>% 
    normalize_text_descunid() %>% 
    mask_descunid_gmg() %>% 
    mask_descunid_sejusp() %>% 
    mask_descunid_pcmg() %>% 
    mask_descunid_pmmg() %>% 
    impute_value_rem_pos_cbmmg() %>% 
    normalize_text_designado_ao_servico_ativo()
  
  dt[]
}

add_column <- function(x, column_name, values) {
  if(column_name %in% names(x)) {
    stop(glue::glue("Coluna {column_name} já existente."))
  }
  
  x[[column_name]] <- values
  
  x
}

conform_pmmg <- function(path, resource_name) {
  
  result <- data.table::as.data.table(readxl::read_xlsx(path))
  
  result <- result %>% 
    add_column("tem_apost", NA_character_) %>% 
    add_column("judic", NA_character_) %>% 
    add_column("jetons", 0) %>% 
    add_column("bdmg", 0) %>% 
    add_column("cemig", 0) %>% 
    add_column("codemig", 0) %>% 
    add_column("cohab", 0) %>% 
    add_column("copasa", 0) %>% 
    add_column("emater", 0) %>% 
    add_column("epamig", 0) %>% 
    add_column("funpemg", 0) %>% 
    add_column("gasmig", 0) %>% 
    add_column("mgi", 0) %>% 
    add_column("mgs", 0) %>% 
    add_column("prodemge", 0) %>% 
    add_column("prominas", 0) %>% 
    add_column("emip", 0) %>% 
    add_column("codemge", 0) %>% 
    add_column("emc", 0)
  
  expected_cols <- get_col_names(resource_name)
  
  result[, ..expected_cols]
  
  data.table::fwrite(result, file = gsub(".xlsx$", ".csv", path), sep = ";", dec = ",", bom = TRUE)
}

conform_cbmmg <- function(path, resource_name) {
  
  expected_cols <- c("masp", "nome", "situacao_do_servidor", "cargo_efetivo", "apostila", 
                     "cargo_em_comissao", "orgao_entidade", "unidade_administrativa", 
                     "carga_horaria", "remuneracao_basica_bruta", "abate_teto", "dec_judicial", 
                     "ferias", "gratificacao_natal", "premio_de_produtividade", "ferias_premio", 
                     "jetons_pagos_seplag", "outros_eventuais", "irrf", "contribuicao_previdenciaria", 
                     "remuneracao_apos_deducoes_obrigatorias", "bdmg", "cemig", "codemig", 
                     "cohab", "copasa", "emater", "epamig", "funpemg", "gasmig", "mgi", 
                     "mgs", "prodemge", "prominas")
  
  if(!identical(expected_cols, clean_headers_cbmmg(path))) {
    stop("Não foi possível intepretar o cabeçalho da planilha do CBMMG.")
  }
  
  schema_cols <- c("masp" = "masp",
                   "nome" = "nome",
                   "situacao_do_servidor" = "descsitser",
                   "cargo_efetivo" = "nmefet",
                   "apostila" = "tem_apost",
                   "cargo_em_comissao" = "desccomi",
                   "orgao_entidade" = "descinst",
                   "unidade_administrativa" = "descunid",
                   "carga_horaria" = "carga_hora",
                   "remuneracao_basica_bruta" = "remuner",
                   "abate_teto" = "teto",
                   "dec_judicial" = "judic",
                   "ferias" = "ferias",
                   "gratificacao_natal" = "decter",
                   "premio_de_produtividade" = "premio",
                   "ferias_premio" = "feriasprem",
                   "jetons_pagos_seplag" = "jetons",
                   "outros_eventuais" = "eventual",
                   "irrf" = "ir",
                   "contribuicao_previdenciaria" = "prev",
                   "remuneracao_apos_deducoes_obrigatorias" = "rem_pos",
                   "bdmg" = "bdmg",
                   "cemig" = "cemig",
                   "codemig" = "codemig",
                   "cohab" = "cohab",
                   "copasa" = "copasa",
                   "emater" = "emater",
                   "epamig" = "epamig",
                   "funpemg" = "funpemg",
                   "gasmig" = "gasmig",
                   "mgi" = "mgi",
                   "mgs" = "mgs",
                   "prodemge" = "prodemge",
                   "prominas" = "prominas")
  
  col_names <- unname(schema_cols[expected_cols])
  
  if(anyNA(col_names)) {
    stop("Não foi possível fazer o mapeamento de colunas da planilha do CBMMG.")
  }
  
  result <- readxl::read_excel(path, skip = 2, col_names = FALSE)
  
  result <- result %>% 
    dplyr::select(1:34) %>% 
    purrr::set_names(col_names) %>% 
    data.table::as.data.table() %>% 
    rm_masp_hyphen() %>% 
    add_column("emip", 0) %>% 
    add_column("codemge", 0) %>% 
    add_column("emc", 0)
  
  data.table::fwrite(result, file = gsub(".xlsx$", ".csv", path), sep = ";", dec = ",", bom = TRUE)
  
}

check_raw_files_checksum <- function(resource_name) {
  resource_exists(resource_name)
  resource <- get_resource(resource_name)
  
  # https://jennybc.github.io/purrr-tutorial/ls01_map-name-position-shortcuts.html#extract_multiple_values
  sources <- purrr::map_df(resource$sources, extract, c("path", "name", "hash"))
  
  files <- googledrive::drive_get(id = sources$path)
  
  files <- dplyr::mutate(files, 
                         filename = file.path("data-raw", glue::glue("{sources$name}.{purrr::map_chr(drive_resource, 'fullFileExtension')}")))
  
  checksum_googledrive <- data.frame(resource = sources$name, 
                                     checksum = purrr::map_chr(files$drive_resource, "md5Checksum"))
  
  checksum_filesystem <- data.frame(resource = sources$name, 
                                    checksum = purrr::map_chr(files$filename, digest::digest, algo = "md5", file = TRUE))
  
  checksum_datapackage <- data.frame(resource = sources$name, 
                                     checksum = sources$hash)
  
  #waldo::compare(checksum_googledrive, checksum_filesystem)
  #waldo::compare(checksum_googledrive, checksum_datapackage)
  
  stopifnot(identical(checksum_googledrive, checksum_filesystem))
  stopifnot(identical(checksum_googledrive, checksum_datapackage))
  
  TRUE
}