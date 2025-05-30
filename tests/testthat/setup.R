library(validate); library(dplyr); library(data.table)

purrr::walk(list.files(here::here("scripts", "lib"), full.names = TRUE, pattern = ".R"), source)

<<<<<<< HEAD
resource_name <- "servidores-2025-04"
=======
resource_name <- "servidores-2025-03"
>>>>>>> 617fa131073861f26cee3dc0d0676175c06533c5

dt <- read_remuneracao(here::here("data", paste0(resource_name, ".csv")))
