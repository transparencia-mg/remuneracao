log_file_checksum <- function(path) {
  files <- list.files(path, full.names = T, pattern = ".csv$")
  
  checksum <- purrr::map(files, digest::digest, algo = "sha256", file = TRUE)
  
  result <- data.frame(file = basename(files), checksum = unlist(checksum))

  result
}


  

