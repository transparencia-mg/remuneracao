library(tidyverse)

source("scripts/lib/utils.R")

jsonlite::read_json("datapackage.json")$resources %>% 
  map("name") %>% 
  map(validate_resource)
  
validate_resource("servidores_01_20")