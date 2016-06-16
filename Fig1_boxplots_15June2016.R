rm(list=ls()) 
options(stringsAsFactors=F)
require(ggplot2)
library(dplyr)
set.seed(0)

asc <- read.csv("data/HP3.assocV41_FINAL.csv", header=T, strip.white = T)
h <- read.csv("data/HP3.hostv42_FINAL.csv", header=T, strip.white = T)
v <- read.csv("data/HP3.virus_v45.csv", header=T, strip.white = T)
asc_noHoSa <- asc[asc$hHostNameFinal!="Homo_sapiens", ]

h <- h[h$hHostNameFinal != "Homo_sapiens",]  #drop humans

### NEW FIG 1, HP3, revised from code from 14 Dec 2014
head(h)
#to calculate proportion shared and order new plot
#h$hOrder <- as.factor(h$hOrder) #doesn't work without this

#order boxplot
#create ordered box plot, based on mean proportion shared with humans
h$prop_human <- h$vHoSaRich/h$vir_rich

hw <- h[h$hWildDomFAO=="wild", ] 
hd <- h[h$hWildDomFAO=="domestic", ] 

order_propshared <- h %>% 
  group_by(hOrder) %>% 
  summarize(prop_human_mean_order = mean(prop_human)) %>%
  arrange(desc(prop_human_mean_order))
  
h2 <- merge(h, order_propshared, by="hOrder")

h2 <- h2 %>% 
  arrange(desc(prop_human_mean_order))  # arrange by mean proportion zoonotic by order

order_propshared
h2$hOrder <- ordered(h2$hOrder, levels=c( "CINGULATA", "PILOSA","DIDELPHIMORPHIA", "EULIPOTYPHLA", 
                "CHIROPTERA", "PRIMATES", "RODENTIA", "CARNIVORA", "LAGOMORPHA", "PROBOSCIDEA", "DIPROTODONTIA",
                 "CETARTIODACTYLA", "PERISSODACTYLA",  "PERAMELEMORPHIA", "SCANDENTIA"))

h2w <- h2[h2$hWildDomFAO=="wild", ] 
h2d <- h2[h2$hWildDomFAO=="domestic", ] 

unique(h2w$hOrder)
unique(h2d$hOrder)

h3w <- subset(h2, hWildDomFAO=="wild", drop=F) 
h3d <- subset(h2, hWildDomFAO=="domestic", drop=F)
?subset
levels(h3w$hOrder)
unique(h3w$hOrder)  
unique(h3d$hOrder)  #NOT WORKING, still dropping levels

#par(mfrow=c(2, 1))
#par(mar=c(10,3,3,3))
## FIG 1A
par(mar=c(14,4.2,4,2))
boxplot(vir_rich ~ h2Order, data=h2, vertical = TRUE, ylab="Viral richness per species",
        col="lightgray", main="", outcol=NA, las=3)
#one stripchart for wild values
stripchart(vir_rich ~ hOrder, data=h3w, 
           vertical = TRUE, method = "jitter", jitter=0.15,
           pch = 21, col = "black", bg = "lightgrey", 
           add = T, cex=1.2) 
#another for domestic
stripchart(vir_rich ~ hOrder, data=h3d, 
           vertical = TRUE, method = "jitter", jitter=0.15,
           pch = 21, col = "black", bg = "red", 
           add = T, cex=1.2) 
#mtext("1A", 2, adj=5, las=1) #not set right

##FIG 1B
par(mar=c(14,4,4,2)+0.1)

boxplot(propHoSa ~ hOrder, data=h, vertical = TRUE, ylab="Proportion human viruses",
        col="lightgray", main="", outcol=NA, las=3)

stripchart(propHoSa ~ hOrder, data=hw, 
           vertical = TRUE, method = "jitter", jitter=0.15,
           pch = 21, col = "black", bg = "lightgrey", 
           add = T, cex=1.2) 

stripchart(propHoSa ~ hOrder, data=hd, 
           vertical = TRUE, method = "jitter", jitter=0.15,
           pch = 21, col = "black", bg = col, 
           add = T, cex=1.2) 

## Viral richness with wild and dom stripplot, ordered by proportion shared - 15 Dec 2014

## post hoc test of significance for proportion zoonotic viruses

a2 <- aov(propHoSa ~ hOrder, data=h)
summary(a2) #hOrder is signif
pairwise.t.test(h$propHoSa, h$hOrder, p.adj = "bonf")
TukeyHSD(a2)


#### END HP3 FIG 1