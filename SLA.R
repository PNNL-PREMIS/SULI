# Script to process Specific Leaf Area data at SERC
# Created 06-13-2019
# Call necessary libraries
library(dplyr)
library(tidyr)
library(readr)
library(ggrepel)
library(ggplot2)

# Reading in the SLA csv
sla <- read.csv("SLA Data.csv")
print(sla)
print(summary(sla))

# Create new column with specific leaf area
sla %>%
  mutate(specific_leaf_area=Leaf_Area_cm2/Leaf_Mass_g) -> sla

# Read in tree inventory file
ss_inv <- read_csv('ss-inventory.csv')

# Table of mean and standard devation of live maple trees
ss_inv %>% 
  filter(Alive=='Yes',Species=='ACRU') %>% 
  group_by(Plot,Species) %>% 
  summarise(mean_DBH=mean(DBH),standard_dev_DBH=sd(DBH)) -> alive_maple
print(summary(alive_maple))

# Create inventory with just Plot, Species, Tag, and DBH columns
inventory_small <- ss_inv %>% 
  select(Plot, Species, Tag, DBH)

# Remove line where there is no tag number and can't be matched with a species to avoid
# having a facet wrap with an NA plot
sla <- sla[!is.na(sla$Tag),]

# Join together SLA data and Species and Plot data, joining by tag
sla <- left_join(sla, inventory_small)

# Create a box plot of SLA values by species
sla_box <- ggplot(data=sla, aes(Species, specific_leaf_area,label=Tag,color=Position)) +
  geom_boxplot() +
  geom_point() +
  geom_text_repel(angle=35,size=3) +
  labs(y='Specific Leaf Area', title='SLA by Species and Position')
  
print(sla_box)

# Create a plot of SLA by species, with a new plot for each Plot
sla_plot <- ggplot(data=sla,aes(Species, specific_leaf_area,color=Position,size=DBH)) + 
  geom_point() +
  facet_wrap(~Plot) +
  labs(y='Specific Leaf Area', title='SLA by Species and Plot') +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

print(sla_plot)
