purrr::walk(list.files("scripts/lib/", full.names = TRUE, pattern = ".R"), source)

arg <- commandArgs(trailingOnly = TRUE)

resource_exists(arg)

path_cbmmg_raw <- file.path("data-raw", glue::glue("{arg}-cbmmg.xlsx"))
conform_cbmmg(path_cbmmg_raw, arg)

path_pmmg_raw <- file.path("data-raw", glue::glue("{arg}-pmmg.xlsx"))
conform_pmmg(path_pmmg_raw, resource_name = arg)

path_civis_raw <- file.path("data-raw", glue::glue("{arg}-civis.csv"))
conform_civis(path_civis_raw, resource_name = arg)

path_cbmmg <- file.path("data-raw", glue::glue("{arg}-cbmmg-conformed.csv"))
path_pmmg <- file.path("data-raw", glue::glue("{arg}-pmmg-conformed.csv"))
path_civis <- file.path("data-raw", glue::glue("{arg}-civis-conformed.csv"))
  
cbmmg <- read_remuneracao_raw(path_cbmmg)
pmmg <- read_remuneracao_raw(path_pmmg)
civis <- read_remuneracao_raw(path_civis)
  
result <- rbindlist(list(cbmmg, pmmg, civis))
  
result <- result %>% dplyr::arrange(nome)

data.table::fwrite(result, file.path("data-raw", glue::glue("{arg}.csv")), sep = ";", dec = ",")
