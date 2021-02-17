context("Pagamento jetons empresas")

test_that("Pagamento jetons CEMIG", {
  rule <- validator(sum(cemig) > 0)
  report <- confront(dt, rule)
  
  expect_lt(summary(report)$fails, expected = 1)
})

test_that("Pagamento jetons BDMG", {
  rule <- validator(sum(bdmg) > 0)
  report <- confront(dt, rule)
  
  expect_lt(summary(report)$fails, expected = 1)
})
