library(validate); library(dplyr); library(data.table)

purrr::walk(list.files(here::here("scripts", "lib"), full.names = TRUE, pattern = ".R"), source)

resource_name <- "servidores-2021-10"

dt <- read_remuneracao(here::here("data", paste0(resource_name, ".csv.gz")))
