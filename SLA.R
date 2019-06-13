# Script to process Specific Leaf Area data at SERC
# Created 06-13-2019

sla <- read.csv("SLA Data.csv")
print(sla)

library(ggplot2)
p <- qplot(N_Leaves, Leaf_area_cm2, data = sla)
print(p)
