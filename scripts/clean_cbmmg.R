library(tidyverse); library(readxl); library(stringi)

source("scripts/lib/utils.R")

input <- list.files("data-raw/cbmmg", full.names = TRUE, recursive = TRUE, pattern = ".xlsx$")

headers <- map(input, clean_headers_cbmmg)

# confirma que cabecalhos de todos os arquivos sao iguais
stopifnot(length(unique(headers)) == 1)

output <- make_names_output_files_cbmmg(input)

dir.create("data/cbmmg")

input %>% map(read_cbmmg) %>% 
                map(recode_cbmmg) %>% 
                map(enrich_cbmmg) %>% 
                walk2(output, write_remuneracao)
