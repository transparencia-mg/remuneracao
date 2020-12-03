purrr::walk(list.files("scripts/lib/", full.names = TRUE, pattern = ".R"), source)

files <- list.files("data-raw/servidores", full.names = TRUE, pattern = ".csv$")


for (file in files) {
  remuneracao_raw <- read_remuneracao_raw(file)
  
  remuneracao <- remuneracao_raw %>% 
    rm_header_row_from_data_content() %>% 
    rm_masp_hyphen() %>% 
    fix_jetons() %>% 
    rm_extra_empty_columns() %>% 
    coerce_verbas_remun_to_numeric() %>% 
    normalize_text_descinst() %>% 
    normalize_text_descunid() %>% 
    mask_descunid_gmg() %>% 
    mask_descunid_sejusp() %>% 
    mask_descunid_pcmg() %>% 
    mask_descunid_pmmg() %>% 
    impute_value_rem_pos_cbmmg() %>% 
    normalize_text_designado_ao_servico_ativo()
  
  output <- stringr::str_replace(file, "data-raw/servidores", "data")
  
  write_remuneracao(remuneracao, output)
  
  print(paste0("Done ", output))
}




  