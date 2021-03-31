library(googledrive); library(purrr); library(dplyr); library(magrittr); library(glue); library(digest)

purrr::walk(list.files(here::here("scripts/lib"), full.names = TRUE, pattern = ".R"), source)

resource <- get_resource("servidores-2021-02")

# https://jennybc.github.io/purrr-tutorial/ls01_map-name-position-shortcuts.html#extract_multiple_values
sources <- map_df(resource$sources, extract, c("path", "name"))

files <- drive_get(id = sources$path)

files <- mutate(files, 
                filename = file.path("data-raw", glue("{sources$name}.{map_chr(drive_resource, 'fullFileExtension')}")))

walk2(files$id, files$filename, ~drive_download(as_id(.x), path = .y))

identical(map_chr(files$drive_resource, "md5Checksum"), map_chr(files$filename, digest, file = TRUE))
