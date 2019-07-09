# litter_data.R

# Process the litter data

files <- list.files("litter_data/", pattern = "*.csv", full.names = TRUE)

library(dplyr)
library(readr)

# TODO: what does this do?
lapply(files, read_csv) %>% bind_rows() -> ld

# Change the 'Date_collected' column into a datetime object
library(lubridate)
ld$Date_collected <- mdy(ld$Date_collected)

# We want to produce a graph of cumulative leaf litter over time. Each plot should be
# in a separate facet, and each band a separate species (using geom_area)

# TODO: we need to reshape the data so that all the 'leaf' columns are
# in a long format (remember tidyr::gather)
library(tidyr)
ld %>% 
  select(Plot, Trap, Date_collected, contains("leaf")) 

# TODO: now a call to gather()
# TODO: now a call to separate() to get at species name
# TODO: now group_by() and mutate() calls to compute the cumulative sum
# Probably first want to sum by date and plot; then do the cumulative sum 


# Plot!
p <- ggplot(ld, aes(Date_collected, Mass_g, fill = Species)) + geom_area()
print(p)
