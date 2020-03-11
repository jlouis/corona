library(tidyverse)
library(fs)

data_dir <- "../COVID-19/csse_covid_19_data/csse_covid_19_daily_reports"

csv_files <- fs::dir_ls(data_dir, regexp = "\\.csv$")

raw <- csv_files %>%
  map_dfr(read_csv, col_types = cols(`Last Update` = col_date(format = "")))
