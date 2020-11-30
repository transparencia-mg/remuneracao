library(magrittr); library(purrr)

purrr::walk(list.files("scripts/lib/", full.names = TRUE, pattern = ".R"), source)

dataset <- create_dataset()

res <- jsonlite::read_json("datapackage.json")$resources %>% 
  map("name") %>% 
  map(create_resource, dataset$id)
