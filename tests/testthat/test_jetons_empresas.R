context("Pagamento jetons empresas")

test_that("Pagamento jetons CEMIG", {
  rule <- validator(sum(cemig) > 0)
  report <- confront(dt, rule)
  
  expect_equal(summary(report)[["fails"]], expected = 0)
})

test_that("Pagamento jetons BDMG", {
  rule <- validator(sum(bdmg) > 0)
  report <- confront(dt, rule)
  
  expect_equal(summary(report)[["fails"]], expected = 0)
})

test_that("Pagamento nulo empresas extintas", {
  rule <- validator(sum(codemig + funpemg + prominas + emip) == 0)
  report <- confront(dt, rule)
  
  expect_equal(summary(report)[["fails"]], expected = 0)
})

