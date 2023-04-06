library(igraph)
library(netplot)
library(igraphdata)

data("UKfaculty")

# col <- V(UKfaculty)$Group

ans <- nplot(UKfaculty, 
      vertex.color = "white", 
      # edge.color = col,
      edge.line.breaks = 10,
      bg.col = "black")

png("netplotfig.png", width = 1024, height = 789)
print(ans)
dev.off()

saveRDS(ans, file = "netplotfig.rds")