library(dplyr); library(waldo)

purrr::walk(list.files("scripts/lib/", full.names = TRUE), source)

con <- DBI::dbConnect(RSQLite::SQLite(), "cached/remuneracao.sqlite")
remuneracao_db <- tbl(con, "remuneracao")

result <- remuneracao_db %>% 
            distinct(data, descinst, descunid) %>% 
            collect()

result <- result %>% 
  mutate(descinst_normalized = normalize_text(descinst), 
         descunid_normalized = normalize_text(descunid))

result %>% distinct(descinst) %>% nrow
result %>% distinct(descinst_normalized) %>% nrow

instituicao <- result %>% distinct(descinst, descinst_normalized)
  


result %>% 
  distinct(descunid, descunid_normalized) %>% 
  filter(descunid != descunid_normalized) %>% 
  arrange(descunid_normalized) %>% 
  View()


result$descinst_normalized %>% 
  unique() %>% 
  stringr::str_split("") %>% 
  purrr::map(unique) %>% 
  unlist() %>% 
  unique() %>% 
  sort()

result$descunid_normalized %>% 
  unique() %>% 
  stringr::str_split("") %>% 
  purrr::map(unique) %>% 
  unlist() %>% 
  unique() %>% 
  sort() %>% textclean::replace_non_ascii() %>% unique()
