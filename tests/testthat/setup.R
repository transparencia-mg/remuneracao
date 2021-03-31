library(validate); library(dplyr); library(data.table)

purrr::walk(list.files(here::here("scripts", "lib"), full.names = TRUE, pattern = ".R"), source)

dt <- read_remuneracao(here::here("data", "servidores-2021-02.csv"))
