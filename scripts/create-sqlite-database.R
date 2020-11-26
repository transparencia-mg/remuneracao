library(DBI); library(purrr)

source("scripts/lib/utils.R")

mydb <- dbConnect(RSQLite::SQLite(), "data/remuneracao.sqlite")

dbExecute(mydb, readr::read_file("scripts/remuneracao.sql"))

resources <- jsonlite::read_json("datapackage.json")$resources %>% map("name")

lst <- resources %>% 
  purrr::map(insert_remuneracao_sqlite, conn = mydb, table = "remuneracao")

dbDisconnect(mydb)

