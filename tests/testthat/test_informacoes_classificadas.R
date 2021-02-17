context("Unidades administrativas classificadas")

test_that("Unidades administrativas classificadas", {
  
  instituicoes <- c("DEFESA SOCIAL", # Secretaria de Estado de Defesa Social de Minas Gerais - SEDS
                       "ADMINISTRACAO PRISIONAL", # Secretaria de Estado de Administração Prisional - SEAP - 2016
                       "SEGURANCA PUBLICA", # Secretaria de Estado de Segurança Pública - SESP - 2016
                       "SECRETARIA DE JUSTICA E SEGURANCA PUBLICA", # Secretaria de Estado de Justiça e Segurança Pública - SEJUSP - 2019
                       "POLICIA CIVIL",
                       "POLICIA MILITAR DE MINAS GERAIS",
                       "GABINETE MILITAR")
  
  rule <- validator(if(descinst %in% instituicoes) descunid == "INF. SIGILOSA")
  report <- confront(dt, rule)
  
  expect_lt(summary(report)$fails, expected = 1)
})

