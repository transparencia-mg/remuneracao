library(googledrive); library(purrr); library(dplyr)

# obter lista dos arquivos csv na pasta Layout_Novo_Planilhas_atualizadas_20201103

files <- drive_get(as_id("1Tk8jW6Ml0rZnsZ52X98iMCTD6I7WWVy2")) %>% 
            drive_ls(type = "csv", recursive = TRUE)

files <- files %>% mutate(output = file.path("data-raw/servidores", name))


# download dos arquivos

walk2(files$id, files$output, ~drive_download(as_id(.x), .y))
