context("Existência de unidade administrativa de exercício")

test_that("Existência de unidade administrativa de exercício", {
  rule <- validator(if(descsitser != "INATIVO") !is.na(descunid))
  report <- confront(dt, rule)
  
  expect_equal(summary(report)[["fails"]], expected = 0)
  
  # summary(report)
  # violating(dt, report) -> dt_errors
  # viewxl:::view_in_xl(dt_errors)
})