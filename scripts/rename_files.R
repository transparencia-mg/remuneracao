library(stringr)

source("scripts/lib/utils.R")

source_files <- list.files("data", full.names = TRUE, pattern = "csv")

target_files <- source_files %>% 
  convert_filename_to_yyyy_mm() %>% 
  str_to_lower() %>% 
  str_replace("_", "-")

file.rename(from = source_files, target_files)
