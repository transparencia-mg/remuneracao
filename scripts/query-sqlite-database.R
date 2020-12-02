library(dplyr); library(DBI); library(stringr); library(data.table)

con <- DBI::dbConnect(RSQLite::SQLite(), "cached/remuneracao.sqlite")

remuneracao_db <- tbl(con, "remuneracao")

resultset <- remuneracao_db %>% 
  distinct(masp) %>% 
  collect()

resultset <- as.data.table(resultset)

nchar(resultset$masp) %>% unique


resultset[nchar(masp) == 1]

resultset[nchar(masp) == 4]


null_masp <- remuneracao_db %>% 
  filter(masp == "") %>% 
  collect()



null_masp <- as.data.table(null_masp)


null_masp[, .N, data]


null_masp[data != "2013-12-01",]


null_masp[data == "2013-12-01",]
