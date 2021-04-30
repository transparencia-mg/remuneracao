library(googledrive); library(purrr); library(dplyr); library(magrittr); library(glue); library(digest)

purrr::walk(list.files(here::here("scripts/lib"), full.names = TRUE, pattern = ".R"), source)

# para depuração em modo interativo inicialize no console do R a variável arg (ie. arg = "servidores-2021-03")
arg <- commandArgs(trailingOnly = TRUE)

resource_exists(arg)

resource <- get_resource(arg)

# https://jennybc.github.io/purrr-tutorial/ls01_map-name-position-shortcuts.html#extract_multiple_values
sources <- map_df(resource$sources, extract, c("path", "name"))

files <- drive_get(id = sources$path)

files <- mutate(files, 
                filename = file.path("data-raw", glue("{sources$name}.{map_chr(drive_resource, 'fullFileExtension')}")))

walk2(files$id, files$filename, ~drive_download(as_id(.x), path = .y))
