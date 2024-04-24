library(validate); library(dplyr); library(data.table)

purrr::walk(list.files(here::here("scripts", "lib"), full.names = TRUE, pattern = ".R"), source)

<<<<<<< HEAD
resource_name <- "servidores-2024-03"
=======
resource_name <- "servidores-2024-02"
>>>>>>> 58f0537c1a98ed40ec2d280a96020f976964835a

dt <- read_remuneracao(here::here("data", paste0(resource_name, ".csv.gz")))
