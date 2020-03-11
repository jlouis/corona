library(tidyverse)
library(fs)

# Where to grab from the COVID-19 data set.
data_dir <- "../COVID-19/csse_covid_19_data/csse_covid_19_daily_reports"

# List all files in the target directory
csv_files <- fs::dir_ls(data_dir, regexp = "\\.csv$")

# Raw data. Read in those CSV files, mutate each line to contain a date based on the file name.
raw <- csv_files %>% set_names() %>%
  map_dfr(read_csv, .id = "source") %>%
  mutate(source = basename(source)) %>%
  mutate(source = as.POSIXct(gsub('.*([0-9]{4}-[0-9]{2}-[0-9]{2})+.*','\\1',source), format='%m-%d-%y', tz='UTC'))

# Next step, tidy up the data set. There is a concept of tidy data, which is the kind of data
# one should strive to have. Thus, use the raw data set as a base for creation of the tidy data set





