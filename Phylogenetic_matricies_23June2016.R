## 23 June 2016 - KJO
# Phylogenetic matrix code, from  Cleaning_v41.r
rm(list=ls()) 
#require(dplyr)
#library(geiger)
#require(picante) 
require(ape)

asc <- read.csv("data/HP3.assocV41_FINAL.csv", header=T, strip.white = T)
h <- read.csv("data/HP3.hostv42_FINAL.csv", header=T, strip.white = T)
v <- read.csv("data/HP3.virus_v45.csv", header=T, strip.white = T)

#check that host, virus, and asc files all match up with unique viruses and hosts included
names(asc)
va <- unique(asc$vVirusNameCorrected)
ha <- unique(asc$hHostNameFinal)

setdiff(ha, h$hHostNameFinal) #all spp in asc file are in h file, 
setdiff(va, v$vVirusNameCorrected) #all viruses in asc file are in v file,

#load in phylogenetic trees, cytb and Supertree (ST)
cytb <- read.tree("data/phylo/665spp-RaxML-constrained_STtopol-FINAL-4June2014.tree") 
ST <- read.tree("data/phylo/ST_HP3_woutg-3April2014-7taxaADDED.tree") #improved ST, fixed all taxa plus added monotremes 3 april 2014 (NEW ST w/outg)

#drop tips from trees for hosts dropped from most recent host-virus association file
cytb$tip.label[sort.list(cytb$tip.label)] #665 spp in original cytb
cytb_drop <- setdiff (cytb$tip.label, h$hHostNameFinal) #21 spp in cytb tree, not in h file
cytb2 <- drop.tip(cytb, which(cytb$tip.label %in% cytb_drop)) #new tree, drop all tips in cytb not in h

ST$tip.label[sort.list(ST$tip.label)] #770 spp in original ST tree
ST_drop <- setdiff (ST$tip.label, h$hHostNameFinal) #17 spp in ST tree, not in h file
ST2 <- drop.tip(ST, which(ST$tip.label %in% ST_drop)) #new tree, drop all tips in ST not in h

## Calculate sp to sp maxtrix of phylo distance (cophenetic)
vSTphylodist <- as.data.frame(cophenetic(ST2)) #calculate Supertree phylo distance matrix, 753 spp.
#write.csv(vSTphylodist, "HP3-ST_PDmatrix-12Mar2016.csv") #write ST PD matrix to file
vCYTBphylodist <- as.data.frame(cophenetic(cytb2)) #calculate cytb phylo distance matrix, #644 spp.
#write.csv(vCYTBphylodist, "HP3-cytb_PDmatrix-12Mar2016.csv") #write cytb PD matrix to file