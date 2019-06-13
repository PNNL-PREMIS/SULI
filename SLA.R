

sla <- read.csv("SLA Data.csv")
print(sla)

library(ggplot2)
p <- ggplot(data = sla, aes(n_Leaves, Leaf.Area..cm2.))+
geom_point()

bwp <- p + theme_bw()

print(bwp)

