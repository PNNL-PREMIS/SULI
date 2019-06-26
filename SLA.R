## Script to process Specific Leaf Area data at SERC
# Created 06-13-2019
# Call necessary libraries
library(dplyr)
library(tidyr)
library(readr)
library(ggrepel)
library(ggplot2)

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

# Plot comparing number of leaves to corresponding leaf area, color by date but pretty!
leaves_v_area <- ggplot(data = sla, aes(n_Leaves, Leaf_Area_cm2, color = Date)) +
  geom_point() +
  geom_jitter()+
  labs(title = "Number of Leaves vs. Leaf Area", subtitle = paste("Lillie Haddock", date()), 
       x = "Number of Leaves Per Sample", y = "Leaf Area (cm2)")
print(leaves_v_area)

# Plot comparing number of leaves to corresponding leaf area but pretty, faceted by date!
split_by_date <- ggplot(data = sla, aes(n_Leaves, Leaf_Area_cm2, color = Date)) + 
  geom_point() +
  labs(title = "Number of Leaves vs. Leaf Area by Date", subtitle = paste("Lillie Haddock", date()), 
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
  select(Plot, Species, Tag, DBH) 
sla_joined <- left_join(sla, inventory_small)

## SLA by Plot
sla_by_plot <- sla_joined %>% 
  ggplot(aes(Species, specific_leaf_area, color = Position)) +
  geom_point() +
  geom_jitter() +
  facet_wrap(~Plot) +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "Specific Leaf Area by Plot", y = "Specific Leaf Area", 
       subtitle = paste("Lillie Haddock", date()))
print(sla_by_plot)

## SLA by species box plot
sla_with_tag <- sla_joined %>%
  ggplot(aes(Species, specific_leaf_area, label = Tag, color = Position)) +
  geom_boxplot() +
  geom_text_repel() +
  geom_point() + 
  labs(title = "Specific Leaf Area by Species and Tag Number", y = "Specific Leaf Area")
print(sla_with_tag)

## SLA by species faceting by plot
sla_with_tag_by_plot <- sla_joined %>%
  ggplot(aes(Species, specific_leaf_area, label = Tag, color = Position)) +
  geom_boxplot() +
  geom_text_repel() +
  geom_point() +
  facet_wrap(~Plot) +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "Specific Leaf Area by Species, Plot, and Tag Number", y = "Specific Leaf Area")
print(sla_with_tag_by_plot)

## SLA faceted by species
sla_by_species <- sla_joined %>%
  ggplot(aes(Plot, specific_leaf_area, color = Position)) +
  geom_point() + 
  geom_jitter() +
  facet_wrap(~Species) +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "Specific Leaf Area by Species and Plot", y = "Specific Leaf Area")
print(sla_by_species)

## DBH vs sla colored by species
sla_vs_dbh <- sla_joined %>% 
  ggplot(aes(DBH, specific_leaf_area, color = Species)) +
  geom_point() + 
  facet_wrap(~Species) +
  geom_smooth(method = "lm") +
  labs(title = "Specific Leaf Area vs. DBH", y = "Specific Leaf Area")
print(sla_vs_dbh)

## leaves vs mass
leaves_vs_mass <- sla_joined %>% 
  ggplot(aes(n_Leaves, Leaf_Mass_g, color = Species)) +
  geom_point() +
  facet_wrap(~Species) +
  geom_smooth(method = lm) +
  labs(title = "Number of Leaves vs. Leaf Dry Mass")
print(leaves_vs_mass)

## leaves vs area
leaves_vs_area <- sla_joined %>% 
  ggplot(aes(n_Leaves, Leaf_Area_cm2, color = Species)) +
  geom_point() +
  facet_wrap(~Species) +
  geom_smooth(method = lm) + 
  labs(title = "Number of Leaves vs. Leaf Area")
print(leaves_vs_area)

## sla vs position by species
sla_vs_position <- sla_joined %>% 
  ggplot(aes(Position, specific_leaf_area, color = Species)) +
  geom_point() +
  geom_jitter() +
  labs(title = "Specific Leaf Area vs. Canopy Position", x = "Canopy Position", y = "Specific Leaf Area")
print(sla_vs_position)

## average sla of each species
sla_averages <- sla_joined %>%
  group_by(Species) %>%
  summarise(sla_mean_species = mean(specific_leaf_area))
sla_averages_plot <- sla_averages %>% 
  ggplot(aes(Species, sla_mean_species)) +
  geom_point()
print(sla_averages_plot)

sla_joined %>% 
  ggplot(aes(Species, specific_leaf_area, color = Position)) +
  geom_violin()


print(sla_plot)
