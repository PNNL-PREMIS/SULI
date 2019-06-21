# Script to process Specific Leaf Area data at SERC
# Created 06-13-2019

# Read in the SLA csv
sla <- read.csv("SLA Data.csv")
print(sla)
print(summary(sla))

# Remove rows with NA Species
sla <- sla[!is.na(sla$Tag), ]

# Plot comparing number of leaves to corresponding leaf area, colored by date
library(ggplot2)
leaves_v_area <- ggplot(data = sla, aes(n_Leaves, Leaf_Area_cm2, color = Date)) +
  geom_point() +
  labs(title = "Number of Leaves vs. Leaf Area", subtitle = "Lillie Haddock 6/17/2019", 
       x = "Number of Leaves Per Sample", y = "Leaf Area (cm2)")
print(leaves_v_area)

# Plot comparing number of leaves to corresponding leaf area, facet wrapped by date
split_by_date <- ggplot(data = sla, aes(n_Leaves, Leaf_Area_cm2, color = Date)) + 
  geom_point() +
  labs(title = "Number of Leaves vs. Leaf Area by Date", subtitle = "Lillie Haddock 6/17/2019", 
       x = "Number of Leaves Per Sample", y = "Leaf Area (cm2)") +
  facet_wrap(~Date)
print(split_by_date)

# Compute specific leaf area
library(dplyr)
sla %>% 
  mutate(sl_area = Leaf_Area_cm2/Leaf_Mass_g) -> sla

# Read in species data
library(readr)
read_csv("ss-inventory.csv") -> inventory

# Join the species data with sla data
left_join(sla, inventory, by = "Tag") -> full_data

# Plot species SLA values
library(ggrepel)
Position <- full_data$Position
species_SLA <- ggplot(data = full_data, aes(Species, sl_area, color = Position)) +
  geom_boxplot() +
  geom_point() +
  geom_text_repel(label = full_data$Tag) +
  labs(title = "Specific Leaf Area by Species and Canopy Position", x = "Species",
       y = "Specific Leaf Area (cm2)")
print(species_SLA)

# Summarize species data
summarize(species)

# Group the species data
species %>% 
  group_by(Plot, Species = "ACRU") %>% 
  summarize(mean = mean(DBH),
                   sd = sd(DBH)) -> grouped_maple

# Select plot, species, and tag columns
inventory_small <- inventory[ -c(2,4:5, 7:10) ]

# Join the inventory small data with sla data
left_join(sla, inventory_small, by = "Tag") -> joined_inventory

# Plot species SLA values and facet by species
library(ggrepel)
plot_facet <- ggplot(data = joined_inventory, aes(Species, sl_area, color = Position)) +
  geom_point() +
  geom_text_repel(label = full_data$Tag) +
  labs(title = "Specific Leaf Area by Species, Plot, and Canopy Position", x = "Species",
       y = "Specific Leaf Area (cm2)")
print(plot_facet)
plot_facet + facet_wrap(~Plot)
print(species_facet)