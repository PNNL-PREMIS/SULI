

sla <- read.csv("SLA Data/SLA Data.csv")
print(sla)

library(ggplot2)
qplot(n_Leaves, Leaf.Area..cm2., data = sla)
