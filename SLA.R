# Script to process Specific Leaf Area data at SERC
# Created 06-13-2019

sla <- read.csv("SLA Data.csv")
print(sla)
print(summary(sla))

library(ggplot2)

#ggplot properties
p <- ggplot(data = sla, aes(n_Leaves, Leaf.Area..cm2.))+
geom_point()

#rename ggplot with black and white theme
bwp <- p + theme_bw()

print(bwp)

