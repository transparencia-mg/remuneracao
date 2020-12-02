library(data.table); library(tidyverse); library(daff)

purrr::walk(list.files("scripts/lib/", full.names = TRUE, pattern = ".R"), source)

#======================================================================
# leitura

mes <- "2017-06"

raw <- read_remuneracao(glue::glue("data-raw/servidores/servidores-{mes}.csv"))[descinst == "CBMMG"][order(masp)]
fix_cbmmg <- read_remuneracao(glue::glue("data/cbmmg/cbmmg-{mes}.csv"))[order(masp)]
fix_cge <- read_remuneracao(glue::glue("data/servidores-{mes}.csv"))[descinst == "CBMMG"][order(masp)]

#======================================================================
# confirmar se servidores sao iguais em termos de masp e quantitativo

raw[all_duplicated(masp)]
waldo::compare(raw$masp, fix_cbmmg$masp)

waldo::compare(raw$masp, fix_cge$masp) # nao pode dar diferenca

# em caso de diferencas

anti_join(raw, fix_cbmmg, by = "masp") # servidores excluidos durante a correcao
anti_join(fix_cbmmg, raw, by = "masp") # servidores incluidos durante a correcao

#======================================================================
# confirmar se remuneracao pos deducoes respeita a memoria de calculo

is_rem_pos_valid_fix_cbmmg <- is_rem_pos_valid(fix_cbmmg)
all(is_rem_pos_valid_fix_cbmmg)
fix_cbmmg[!is_rem_pos_valid_fix_cbmmg]

is_rem_pos_valid_fix_cge <- is_rem_pos_valid(fix_cge)
all(is_rem_pos_valid_fix_cge)

#======================================================================
# confirmar se a remuneracao pos deducoes é igual na correcao do CBMMG e da CGE (via memoria de calculo)

problems_check_rem_pos <- !is_rem_pos_equal(fix_cbmmg, fix_cge)

any(problems_check_rem_pos)

daff::diff_data(fix_cbmmg[problems_check_rem_pos], fix_cge[problems_check_rem_pos]) %>% 
  render_diff()




