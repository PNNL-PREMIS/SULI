# Read the SERC storm surge experiment inventory, and randomly sample
# to produce a list of trees for SLA sampling
# 11 June 2019

library(readr)
library(dplyr)

read_csv("ss-inventory.csv") %>% 
  filter(!is.na(Plot), Alive == "Yes") ->
  inv


# Ensures you get the same random sampling data set order every time
set.seed(12345)

# Randomly arrange the inventory data
inv %>%
  mutate(Species = substr(Species, 1, 4)) %>% 
  select(-Date, -JS_codes) %>% 
  group_by(Plot, Species) %>% 
  # sample_frac()'s default is to sample all data = randomly resample rows
  sample_frac() ->
  random_inv

# write_csv(random_inv, "~/Desktop/random_inv.csv")
