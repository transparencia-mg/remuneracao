library(tidyverse); library(stringr)

source("scripts/lib/utils.R")

# numero de arquivos que serao alterados
length(2013:2018)*12+length(6:12)
# os arquivos de jan-maio 2012 do CBMMG devem ser excluidos

files_cbmmg <- list.files("data/cbmmg", full.names = TRUE)

file <- files_cbmmg[73]


for(file in files_cbmmg) {
  
  file_servidores <- str_replace(file, "data/cbmmg/CBMMG_", "data-raw/servidores/Servidores_")
  file_output <- str_replace(file_servidores, "data-raw/servidores/", "data/")
  
  dt_cbmmg <- read(file)
  dt_servidores <- read(file_servidores)
  
  dt_servidores <- dt_servidores %>% 
                      filter(descunid != "CBMMG")
  
  dt <- bind_rows(dt_servidores, dt_cbmmg) %>% 
            arrange(nome)
  
  fwrite(dt, file_output, sep = ";", dec = ",", bom = TRUE)   
}
