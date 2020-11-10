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
