library(dplyr); library(DBI); library(stringr)

con <- DBI::dbConnect(RSQLite::SQLite(), "cached/remuneracao.sqlite")

remuneracao_db <- tbl(con, "remuneracao")

resultset <- remuneracao_db %>% 
  group_by(data) %>% 
  count() %>% 
  collect()
