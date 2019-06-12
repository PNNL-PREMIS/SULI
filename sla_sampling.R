# Read the SERC storm surge experiment inventory, and randomly sample
# to produce a list of trees for SLA sampling
# 11 June 2019

library(readr)
library(dplyr)

read_csv("SERC storm surge inventory.csv") %>% 
  filter(!is.na(Plot)) ->
  inv


# This is REALLY IMPORTANT
set.seed(951063)

# Randomly arrange the inventory data
inv %>%
  filter(Alive == "Yes") %>% 
  group_by(Plot, Species) %>% 
  # sample_frac()'s default is to sample all data = randomly resample rows
  sample_frac() ->
  random_inv

# write_csv(random_inv, "~/Desktop/random.inv.csv")
