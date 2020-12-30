library(dplyr); library(DBI); library(stringr); library(data.table)

purrr::walk(list.files("scripts/lib/", full.names = TRUE, pattern = ".R"), source)

con <- DBI::dbConnect(RSQLite::SQLite(), "cached/remuneracao.sqlite")

remuneracao_db <- tbl(con, "remuneracao")

cols_jetons <- c(
  "bdmg",
  "cemig",
  "codemig",
  "cohab",
  "copasa",
  "emater",
  "epamig",
  "funpemg",
  "gasmig",
  "mgi",
  "mgs",
  "prodemge",
  "prominas",
  "emip")

resultset <- remuneracao_db %>% 
  distinct(data, bdmg,cemig,codemig,cohab,copasa,emater,epamig,funpemg,gasmig,mgi,mgs,prodemge,prominas,emip) %>% 
  collect()

dt <- as.data.table(resultset)

for(j in cols_jetons) {
  set(dt, j = j, value = tidyr::replace_na(as_numeric(dt[[j]]), 0))
}

dt[, jetons_empresas := bdmg + cemig + codemig + cohab + copasa + emater + epamig + funpemg + gasmig + mgi + mgs + prodemge + prominas + emip]

melt(dt, id.vars = "data")

