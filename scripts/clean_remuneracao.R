purrr::walk(list.files("scripts/lib/", full.names = TRUE, pattern = ".R"), source)

files <- list.files("data-raw/servidores", full.names = TRUE, pattern = ".csv$")


for (file in files) {
  remuneracao_raw <- read_remuneracao_raw(file)
  
  remuneracao <- clean_resource(remuneracao_raw)
  
  output <- stringr::str_replace(file, "data-raw/servidores", "data")
  
  write_remuneracao(remuneracao, output)
  
  print(paste0("Done ", output))
}




  