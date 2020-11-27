library(tidyverse)

purrr::walk(list.files("scripts/lib/", full.names = TRUE, pattern = ".R$"), source)

jsonlite::read_json("datapackage.json")$resources %>% 
  map("name") %>% 
  map(validate_resource)


report$valid

report$tables[[1]]$errors %>% map("message")

  
validate_resource("servidores-2012-06") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL em carga_hora 2) Licença INSS em remuner para servidor CARLOS MAGNO PEREIRA DE SOUZA masp 600064
validate_resource("servidores-2012-07") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL em carga_hora 2) digito no masp
validate_resource("servidores-2012-08") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL em carga_hora 2) cabecalho na ultima linha
validate_resource("servidores-2012-09") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL 2) digito no masp
validate_resource("servidores-2012-10") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL 2) digito no masp 3) OK|ok na coluna teto 4) - como zero nas colunas de jetons das empresas
validate_resource("servidores-2012-11") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL 2) digito no masp 3) AFASTADO INSS na coluna remuner para DANIELE MERCÊS DIAS DA SILVA masp 600043 4) OK na coluna teto
validate_resource("servidores-2012-12") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL 2) digito no masp 3) Afastado INSS na coluna rem_pos para DANIELE MERCÊS DIAS DA SILVA masp 600043
validate_resource("servidores-2013-01") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL 2) digito no masp 3) Afastado INSS na coluna rem_pos para DANIELE MERCÊS DIAS DA SILVA masp 600043
validate_resource("servidores-2013-02") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL 2) digito no masp 3) Afastado INSS na coluna rem_pos para DANIELE MERCÊS DIAS DA SILVA masp 600043
validate_resource("servidores-2013-03") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL 2) digito no masp
validate_resource("servidores-2013-04") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL 2) digito no masp 3) Afastado INSS na coluna rem_pos para DANIELE MERCÊS DIAS DA SILVA masp 600043
validate_resource("servidores-2013-05") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL 2) digito no masp 3) Afastado INSS na coluna rem_pos para DANIELE MERCÊS DIAS DA SILVA masp 600043
validate_resource("servidores-2013-06") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL 2) digito no masp
validate_resource("servidores-2013-07") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL 2) digito no masp
validate_resource("servidores-2013-08") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL
validate_resource("servidores-2013-09") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL
validate_resource("servidores-2013-10") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL
validate_resource("servidores-2013-11") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL
validate_resource("servidores-2013-12") # 1) carga_hora vazia para CBMMG e PMMG
validate_resource("servidores-2014-01") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL 2) #REF! na coluna rem_pos para AMERICO GOMES NETO masp 190
validate_resource("servidores-2014-02") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL
validate_resource("servidores-2014-03") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL
validate_resource("servidores-2014-04") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL
validate_resource("servidores-2014-05") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL
validate_resource("servidores-2014-06") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL
validate_resource("servidores-2014-07") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL
validate_resource("servidores-2014-08") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL
validate_resource("servidores-2014-09") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL
validate_resource("servidores-2014-10") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL
validate_resource("servidores-2014-11") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL
validate_resource("servidores-2014-12") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL
validate_resource("servidores-2015-01") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL
validate_resource("servidores-2015-02") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL
validate_resource("servidores-2015-03") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL 2) digito no masp
validate_resource("servidores-2015-04") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL
validate_resource("servidores-2015-05") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL
validate_resource("servidores-2015-06") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL em carga_hora 2) . na coluna emip masp 8719
validate_resource("servidores-2015-07") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL em carga_hora
validate_resource("servidores-2015-08") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL em carga_hora
validate_resource("servidores-2015-09") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL em carga_hora
validate_resource("servidores-2015-10") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL em carga_hora
validate_resource("servidores-2015-11") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL em carga_hora
validate_resource("servidores-2015-12") # 1) DEDICACAO EXCLUSIVA e TEMPO INTEGRAL em carga_hora 2) cabecalho na linha 279210
validate_resource("servidores-2016-01") # ok
validate_resource("servidores-2016-02") # ok
validate_resource("servidores-2016-03") # ok
validate_resource("servidores-2016-04") # ok
validate_resource("servidores-2016-05") # ok
validate_resource("servidores-2016-06") # ok
validate_resource("servidores-2016-07") # ok
validate_resource("servidores-2016-08") # ok
validate_resource("servidores-2016-09") # ok
validate_resource("servidores-2016-10") # ok
validate_resource("servidores-2016-11") # ok
validate_resource("servidores-2016-12") # ok
validate_resource("servidores-2017-01") # ok
validate_resource("servidores-2017-02") # ok
validate_resource("servidores-2017-03") # 1) coluna 36 e 37
validate_resource("servidores-2017-04") # 1) coluna 36 e 37
validate_resource("servidores-2017-05") # 1) coluna 36 e 37
validate_resource("servidores-2017-06") # 1) coluna 36 e 37
validate_resource("servidores-2017-07") # 1) coluna 36 e 37
validate_resource("servidores-2017-08") # 1) coluna 36 e 37
validate_resource("servidores-2017-09") # 1) coluna 36 e 37
validate_resource("servidores-2017-10") # 1) coluna 36 e 37
validate_resource("servidores-2017-11") # 1) coluna 36 e 37
validate_resource("servidores-2017-12") # 1) coluna 36 e 37
validate_resource("servidores-2018-01") # 1) coluna 36 e 37
validate_resource("servidores-2018-02") # ok
validate_resource("servidores-2018-03") # 1) coluna 36 e 37
validate_resource("servidores-2018-04") # 1) coluna 36 e 37
validate_resource("servidores-2018-05") # 1) coluna 36 e 37
validate_resource("servidores-2018-06") # 1) coluna 36 e 37
validate_resource("servidores-2018-07") # 1) coluna 36 e 37 2) #REF! na coluna rem_pos para EUCLIDES SANTANA ALVES masp 6001153
validate_resource("servidores-2018-08") # 1) coluna 36 e 37 2) digito no masp
validate_resource("servidores-2018-09") # 1) coluna 36
validate_resource("servidores-2018-10") # 1) coluna 36
validate_resource("servidores-2018-11") # 1) coluna 36 e 37
validate_resource("servidores-2018-12") # 1) coluna 36 e 37
validate_resource("servidores-2019-01") # 1) coluna 36
validate_resource("servidores-2019-02") # 1) coluna 36
validate_resource("servidores-2019-03") # 1) coluna 36
validate_resource("servidores-2019-04") # 1) coluna 36
validate_resource("servidores-2019-05") # ok
validate_resource("servidores-2019-06") # 1) coluna 36
validate_resource("servidores-2019-07") # 1) coluna 36
validate_resource("servidores-2019-08") # 1) coluna 36
validate_resource("servidores-2019-09") # ok
validate_resource("servidores-2019-10") # 1) coluna 36
validate_resource("servidores-2019-11") # ok
validate_resource("servidores-2019-12") # ok
