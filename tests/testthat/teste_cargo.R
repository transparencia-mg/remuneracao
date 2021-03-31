context("Nomeação em cargo efetivo ou cargo em comissão")

test_that("Nomeação em cargo efetivo ou cargo em comissão", {
  rule <- validator(if(descsitser != "INATIVO") !is.na(nmefet) | !is.na(desccomi))
  report <- confront(dt, rule)
  
  expect_equal(summary(report)[["fails"]], expected = 0)
  
  # summary(report)
  # violating(dt, report) -> dt_errors
  # viewxl:::view_in_xl(dt_errors)
})