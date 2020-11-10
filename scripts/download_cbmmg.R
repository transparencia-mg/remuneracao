


# download esta corrompendo o arquivo
# url <- "https://1drv.ms/u/s!AmhpFSd6g4aGg7Y03ZRvtkh12Z_V0A?e=JRF75t"
# download.file(url, destfile = "data-raw/planilhas_2012_2018_cbmmg_20190730.zip")

# o arquivo "2 FEV 2017.xlsx" precisa de adequacao manual nas ultimas colunas
unzip("data-raw/planilhas_2012_2018_cbmmg_20190730.zip", exdir = file.path("data-raw", "cbmmg"))
