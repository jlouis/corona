library(tidyverse)
library(lubridate)
library(fs)

# Where to grab from the COVID-19 data set.
data_dir <- "../COVID-19/csse_covid_19_data/csse_covid_19_daily_reports"

# List all files in the target directory
csv_files <- fs::dir_ls(data_dir, regexp = "\\.csv$")

# Raw data. Read in those CSV files, mutate each line to contain a date based on the file name.
# While here, also fix variable names so they are a bit easier to work with
raw <- csv_files %>% set_names() %>%
  map_dfr(read_csv, .id = "date") %>%
  mutate(date = basename(date)) %>%
  mutate(date = as.POSIXct(gsub('.*([0-9]{4}-[0-9]{2}-[0-9]{2})+.*','\\1',date), format='%m-%d-%y', tz='UTC')) %>%
  rename(province = `Province/State`, country = `Country/Region`, last_update = `Last Update`,
    confirmed = `Confirmed`, deaths = `Deaths`, recovered = `Recovered`, lat = `Latitude`, lng = `Longitude`)

# Note the data is already tidy. So we don't have to do anything ekstra with the data.
dk <- raw %>% filter(country == "Denmark") %>% filter(is.na(province) | province == "Denmark")

p <- ggplot(dk, aes(x=as_date(date)-today(), y=confirmed))
p + geom_point() +
    geom_smooth(method="loess", formula = (y ~ x)) +
    scale_y_log10()

ggsave("dk.pdf", height=5, width=8)





