library(googledrive); library(purrr); library(dplyr); library(jsonlite)

arg <- commandArgs(trailingOnly = TRUE)

# # se necessario depuração e modo interativo descomentar a linha abaixo
# # para inicializar variavel arg
# arg <- "1dDdvkf-ku8bJTI-gEJ27JBRu7H7z1q_h"

source_info <- drive_get(as_id(arg)) %>%
               drive_ls(recursive = FALSE) %>% 
               transmute(filename = name, 
                         path =  paste0("https://drive.google.com/file/d/", id), 
                         hash = map_chr(drive_resource, "md5Checksum")) %>% 
               toJSON(pretty = TRUE)

cat(source_info)
