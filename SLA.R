

sla <- read.csv("SLA Data.csv")
print(sla)

library(ggplot2)
p <- qplot(n_Leaves, Leaf.Area..cm2., data = sla)
print(p)