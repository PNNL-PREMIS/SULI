## Script to process Specific Leaf Area data at SERC
# Created 06-13-2019

# Read in libraries 
library(ggplot2)
library(readr)
library(dplyr)
library(tidyr)
library(ggrepel)

## Read in the SLA csv
sla <- read.csv("SLA Data.csv")
print(sla)
print(summary(sla))

# Simple plot comparing number of leaves to the corresponding leaf area
p <- qplot(n_Leaves, Leaf_Area_cm2, data = sla)
print(p)

# Plot comparing number of leaves to corresponding leaf area but pretty!
leaves_v_area <- ggplot(data = sla, aes(n_Leaves, Leaf_Area_cm2, color = Date)) +
  geom_point() +
  labs(title = "Number of Leaves vs. Leaf Area", subtitle = "Lillie Haddock 6/17/2019", 
       x = "Number of Leaves Per Sample", y = "Leaf Area (cm2)")
print(leaves_v_area)

# Plot comparing number of leaves to corresponding leaf area but pretty and separated by date!
split_by_date <- ggplot(data = sla, aes(n_Leaves, Leaf_Area_cm2, color = Date)) + 
  geom_point() +
  labs(title = "Number of Leaves vs. Leaf Area by Date", subtitle = "Lillie Haddock 6/17/2019", 
       x = "Number of Leaves Per Sample", y = "Leaf Area (cm2)") +
  facet_wrap(~Date)
print(split_by_date)

## Create an SLA column
sla <- sla %>% 
  mutate(specific_leaf_area = (Leaf_Area_cm2 / Leaf_Mass_g)) 
head(sla)

## Read in the inventory data
inventory <- read.csv("ss-inventory.csv")
summary(inventory)
# Get rid of points where Tag is NA (look for row "by 1802", and don't include it)
sla <- sla[!is.na(sla$Tag),]

## Table of mean and sd DBH for alive maples 
ACRU_alive <- inventory %>%
  filter(Species == "ACRU", Alive == "Yes") %>% 
  group_by(Plot, Species) %>% 
  summarize(mn = mean(DBH), sd = sd(DBH))

# Create new dataset with plot, species, and tag columns
# JOIN!!! sla and inventory_small
inventory_small <- inventory %>% 
  select(Plot, Species, Tag) 
sla_joined <- left_join(sla, inventory_small)

## SLA by Plot
sla_plot1 <- sla_joined %>% 
  ggplot(aes(Species, specific_leaf_area, color = Position)) +
  geom_point() +
  geom_jitter() +
  theme_bw() +
  facet_wrap(~Plot) +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "Specific Leaf Area by Plot", y = "Specific Leaf Area", 
       subtitle = "Lillie Haddock 6/21/19")
print(sla_plot1)

## SLA by species
sla_plot2 <- sla_joined %>%
  ggplot(aes(Species, specific_leaf_area, label = Tag, color = Position)) +
  geom_boxplot() +
  geom_text_repel() +
  geom_point() + 
  theme_bw() +
  labs(title = "Specific Leaf Area by Species and Tag Number", y = "Specific Leaf Area")
print(sla_plot2)

## SLA by species faceting by plot
sla_plot3 <- sla_joined %>%
  ggplot(aes(Species, specific_leaf_area, label = Tag, color = Position)) +
  geom_boxplot() +
  geom_text_repel() +
  geom_point() + 
  theme_bw() +
  facet_wrap(~Plot) +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "Specific Leaf Area by Species, Plot, and Tag Number", y = "Specific Leaf Area")
print(sla_plot3)

## SLA faceted by species!!!
sla_plot4 <- sla_joined %>%
  ggplot(aes(Plot, specific_leaf_area, color = Position)) +
  geom_point() + 
  geom_jitter() +
  theme_bw() +
  facet_wrap(~Species) +
  labs(title = "Specific Leaf Area by Species and Plot", y = "Specific Leaf Area")
print(sla_plot4)