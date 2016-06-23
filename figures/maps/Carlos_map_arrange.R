#arrange Carlos maps for extended data figure
#21 June 2016

require(png)
require(ggplot2)
require(gridExtra)

p1 <- readPNG("maps/all_viruses_maps/all_CARNIVORA_TotVirusPerHost.png", native = FALSE, info = FALSE)
p2 <- readPNG("maps/all_viruses_maps/all_CARNIVORA_prediction.png", native = FALSE, info = FALSE)
p3 <- readPNG("maps/all_viruses_maps/all_CARNIVORA_pred_obs.png", native = FALSE, info = FALSE)
p4 <- readPNG("maps/zoonoses_maps/CARNIVORA_obs_zoo.png", native = FALSE, info = FALSE)
p5 <- readPNG("maps/zoonoses_maps/CARNIVORA_pred_zoo.png", native = FALSE, info = FALSE)
p6 <- readPNG("maps/zoonoses_maps/CARNIVORA_pred_obs_zoo.png", native = FALSE, info = FALSE)

Carnivora <- arrangeGrob(p1, p2, p3, p4, p5, p6, nrow=2, ncol=3) # Write the grid.arrange in the file
ggsave(file="Carnivora_map_test.pdf", Carnivora)

dev.off() # Close the file