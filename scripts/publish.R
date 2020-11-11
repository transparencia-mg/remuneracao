library(magrittr); library(purrr)

source("scripts/lib/utils.R")

dataset_id <- "13902bdb-f846-4c06-8a0b-7998df6d9e4b"
resource_id <- "servidores_05_20"

dataset <- create_dataset()

res <- jsonlite::read_json("datapackage.json")$resources %>% 
  map("name") %>% 
  map(create_resource, dataset$id)
