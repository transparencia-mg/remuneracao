purrr::walk(list.files("scripts/lib/", full.names = TRUE, pattern = ".R"), source)

arg <- commandArgs(trailingOnly = TRUE)

resource_exists(arg)

file <- file.path("data-raw", glue::glue("{arg}.csv"))

remuneracao_raw <- read_remuneracao_raw(file)
  
remuneracao <- clean_resource(remuneracao_raw)
  
output <- get_resource(arg)$path
  
write_remuneracao(remuneracao, output)
  
print(paste0("Done: ", output))
