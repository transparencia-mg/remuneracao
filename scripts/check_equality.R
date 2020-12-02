library(data.table); library(waldo); library(dplyr); library(purrr)

purrr::walk(list.files("scripts/lib/", full.names = TRUE, pattern = ".R"), source)

schema <- get_schema("servidores-2020-01")$fields
numeric_cols <- map_chr(schema, "name")[map_chr(schema, "type") == "number"]

log <- log_file_checksum("data-raw/servidores")

readr::write_csv2(log, path = "CHECKSUM-4.csv")

dt_portal <- read_remuneracao("data-raw/servidores/ServidoresMG_0420.csv")
dt <- read_remuneracao("data-raw/servidores/Servidores_04_20.csv")
dt1 <- read_remuneracao("data-raw/servidores/Servidores_04_20 (1).csv")[, 1:35]

dt[, map(.SD, sum, na.rm = TRUE), .SDcols = numeric_cols]
dt1[, map(.SD, sum, na.rm = TRUE), .SDcols = numeric_cols]
dt_portal[, map(.SD, sum, na.rm = TRUE), .SDcols = numeric_cols]

anti_join(dt1, dt_portal, by = "masp")
anti_join(dt_portal, dt1, by = "masp")

names(dt1)

val <- "masp"


check_unique_values(dt1[[val]], dt_portal[[val]])



check_equal_unique_values <- function(x, y) {
  unique_x <- sort(unique(x))
  unique_y <- sort(unique(y))
  
  check <- all(unique_x == unique_y)
  
  check
}
