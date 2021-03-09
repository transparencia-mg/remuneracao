purrr::walk(list.files("scripts/lib/", full.names = TRUE, pattern = ".R"), source)

arg <- commandArgs(trailingOnly = TRUE)

resource_exists(arg)

path_cbmmg <- file.path("data-raw", glue::glue("{arg}-cbmmg.xlsx"))
path_pmmg <- file.path("data-raw", glue::glue("{arg}-pmmg.xlsx"))
path_civis <- file.path("data-raw", glue::glue("{arg}-civis.csv"))
  
cbmmg <- read_remuneracao(path_cbmmg)
pmmg <- read_remuneracao(path_pmmg)
civis <- read_remuneracao(path_civis)
  
result <- rbindlist(list(cbmmg, pmmg, civis), fill = TRUE)
  
result <- result %>% dplyr::arrange(nome)

data.table::fwrite(result, file.path("data-raw", glue::glue("{arg}.csv")), sep = ";", dec = ",")