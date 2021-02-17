context("Carga horaria servidores em atividade")

test_that("Carga horaria servidores em atividade", {
  rule <- validator(if(descsitser != "INATIVO") carga_hora > 0)
  report <- confront(dt, rule)
  
  expect_lt(summary(report)$fails, expected = 1)
  
  # summary(report)
  # violating(dt, report) %>% select(masp, nome, descinst)
})
