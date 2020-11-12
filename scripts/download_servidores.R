library(googledrive); library(purrr); library(dplyr)

source("scripts/lib/utils.R")

# obter lista dos arquivos csv na pasta Layout_Novo_Planilhas_atualizadas_20201103

files <- drive_get(as_id("1Tk8jW6Ml0rZnsZ52X98iMCTD6I7WWVy2")) %>% 
            drive_ls(type = "csv", recursive = TRUE)

output <- files$name %>% 
  convert_filename_to_yyyy_mm() %>% 
  str_to_lower() %>% 
  str_replace("_", "-")

files <- files %>% mutate(output = file.path("data-raw/servidores", output))

# download dos arquivos

walk2(files$id, files$output, ~drive_download(as_id(.x), .y))
