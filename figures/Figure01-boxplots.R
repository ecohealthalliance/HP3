require(ggplot2)
library(dplyr)
library(svglite)
options(stringsAsFactors=F)
set.seed(0)
P <- rprojroot::find_rstudio_root_file

asc <- read.csv(P("data/HP3.assoc_v50.csv"), header=T, strip.white = T)
h <- read.csv("data/HP3.hostv42_FINAL.csv", header=T, strip.white = T)
v <- read.csv("data/HP3.virus_v50.csv", header=T, strip.white = T)
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


h3w <- subset(h2, hWildDomFAO=="wild")
h3d <- subset(h2, hWildDomFAO=="domestic")

#par(mfrow=c(2, 1))
#par(mar=c(10,3,3,3))
## FIG 1A
par(mar=c(14,4.2,4,2))
boxplot(vir_rich ~ hOrder, data=h2, vertical = TRUE, ylab="Total Viral Richness",
        col="lightgray", main="", outcol=NA, las=3,cex.axis=1.3, cex.lab=1.3)
#one stripchart for wild values
stripchart(vir_rich ~ hOrder, data=h3w,
           vertical = TRUE, method = "jitter", jitter=0.15,
           pch = 21, col = "black", bg = "lightgrey",
           add = T, cex=1.3)
#another for domestic
stripchart(vir_rich ~ hOrder, data=h3d,
           vertical = TRUE, method = "jitter", jitter=0.15,
           pch = 21, col = "black", bg = "red",
           add = T, cex=1.3)
#mtext("1A", 2, adj=5, las=1) #not set right

##FIG 1B
par(mar=c(14,4,4,2)+0.1)

boxplot(prop_human ~ hOrder, data=h2, vertical = TRUE, ylab="Proportion Zoonotic Viruses",
        col="lightgray", main="", outcol=NA, las=3, cex.axis=1.3, cex.lab=1.3)

stripchart(prop_human ~ hOrder, data=h3w,
           vertical = TRUE, method = "jitter", jitter=0.15,
           pch = 21, col = "black", bg = "lightgrey",
           add = T, cex=1.3)

stripchart(prop_human ~ hOrder, data=h3d,
           vertical = TRUE, method = "jitter", jitter=0.15,
           pch = 21, col = "black", bg = "red",
           add = T, cex=1.3)

## Viral richness with wild and dom stripplot, ordered by proportion shared - 15 Dec 2014

## post hoc test of significance for proportion zoonotic viruses

a2 <- aov(prop_human ~ hOrder, data=h2)
summary(a2) #hOrder is signif
pairwise.t.test(h$propHoSa, h$hOrder, p.adj = "bonf")
TukeyHSD(a2)
