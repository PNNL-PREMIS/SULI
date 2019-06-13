# Script to process Specific Leaf Area data at SERC
# Created 06-13-2019

sla <- read.csv("SLA Data.csv")
print(sla)
print(summary(sla))

library(ggplot2)
p <- ggplot(data = sla, aes(n_Leaves, Leaf.Area..cm2.))+
geom_point()

bwp <- p + theme_bw()

print(bwp)

