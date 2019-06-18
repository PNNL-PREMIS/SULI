# Script to process Specific Leaf Area data at SERC
# Created 06-13-2019

# Reading in the SLA csv
sla <- read.csv("SLA Data.csv")
print(sla)
print(summary(sla))


# Plot comparing number of leaves to the corresponding leaf area
library(ggplot2)

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


