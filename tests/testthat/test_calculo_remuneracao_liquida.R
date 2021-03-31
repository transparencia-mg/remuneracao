context("Cálculo remuneração líquida")

test_that("Cálculo remuneração líquida", {
  rule <- validator(remuner - teto + ferias + decter + premio + feriasprem + jetons + eventual - ir - prev - rem_pos == 0)
  report <- confront(dt, rule)
  
  expect_equal(summary(report)[["fails"]], expected = 0)
  
  # summary(report)
  # violating(dt, report) %>% select(masp, nome, descinst) -> dt_errors
})

