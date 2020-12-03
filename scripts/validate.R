library(purrr)

purrr::walk(list.files("scripts/lib/", full.names = TRUE, pattern = ".R$"), source)

resources <- jsonlite::read_json("datapackage.json")$resources %>% 
              map("name") %>% 
              keep(stringr::str_detect, "2013-07|2013-12|2015-10|2017-12")

# val <- resources %>% map(validate_resource)
# val <- set_names(val, resources)

val <- readRDS("cached/validation.rds") # cached validation results

fail <- val %>% keep(~ .x$valid == FALSE)

names(fail)
