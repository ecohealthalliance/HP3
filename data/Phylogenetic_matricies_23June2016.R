## 23 June 2016 - KJO
# Phylogenetic matrix code, from  Cleaning_v41.r
#require(dplyr)
#library(geiger)
#require(picante)
P <- rprojroot::find_rstudio_root_file

require(ape)

asc <- read.csv(P("data/HP3.assocV41_FINAL.csv"), header=T, strip.white = T)
h <- read.csv(P("data/HP3.hostv42_FINAL.csv"), header=T, strip.white = T)
v <- read.csv(P("data/HP3.virus_v45.csv"), header=T, strip.white = T)

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



#Phylogenetic Eigenvector Regression - calculate PVR Body Mass


##### Phylogenetic Eigenvector Regression (PVR), 18 Mar 2016 on body mass for HP3
require (PVR)
#supertree PVR calculations failed, used cytB PVR calculations only

names(h)
mass <- h[, c("hHostNameFinal","hMassGrams")]
mass2 <- mass[complete.cases(mass),] #remove spp. with no mass

#new cytb tree without missing body mass

cytb$tip.label[sort.list(cytb$tip.label)] #show taxon tip names and call in alphabetical order
mass2$hHostNameFinal[sort.list(mass2$hHostNameFinal)] #sort order of HP3host alphabetically=default
missingcytb <- setdiff (cytb$tip.label, mass2$hHostNameFinal)
missingcytb2 <- missingcytb[missingcytb!="Ornithorhynchus_anatinus"] #keep root

as.vector(missingcytb)
as.vector(missingcytb2)
cytb_mass <- drop.tip(cytb, missingcytb) #new tree with only cytb tips with mass values

cytb_mass_root <- drop.tip(cytb, missingcytb2)
cytb_mass_root <- root(cytb_mass_root, c("Ornithorhynchus_anatinus" ) )
#write.tree(cytb_mass_root, file="Cytb_mass.newick" )

#new ST tree without missing body mass
ST$tip.label[sort.list(ST$tip.label)] #show taxon tip names and call in alphabetical order
mass2$hHostNameFinal[sort.list(mass2$hHostNameFinal)] #sort order of HP3host alphabetically=default
missingST <- setdiff (ST$tip.label, mass2$hHostNameFinal)
as.vector(missingST)
ST_mass <- drop.tip(ST, missingST) #new ST with only tips with mass values

#first decomp phylgoeny matrix
ST_PVR <- PVRdecomp (ST_mass, type="newick")
cytb_PVR <- PVRdecomp (cytb_mass, type="newick")

#Phylogenetic signal-representation PSR
#first create trait vector in order of cytb tips for mass only
cytb_mass$tip.label #show taxon tip names in order they appear in tree (no root on tree), 637 taxa w mass
mdrop <- setdiff ( mass2$hHostNameFinal, cytb_mass$tip.label)
mass2_cytb <- mass2[!(mass2$hHostNameFinal %in% mdrop), ]
#str(cytb_mass) #number of tip labels matches mass2_cytb df now

ST_mass$tip.label #show taxon tip names in order they appear in tree (no root on tree), 637 taxa w mass
STmdrop <- setdiff ( mass2$hHostNameFinal, ST_mass$tip.label)
mass2_ST <- mass2[!(mass2$hHostNameFinal %in% STmdrop), ]

x <- mass2_cytb[match(cytb_mass$tip.label, mass2_cytb$hHostNameFinal),] ## worked, sorted df by tip label names
head(x)
x2 <- x$hMassGramsLn  #take just vector of body mass, in correct order of phy tree above

STx <- mass2_ST[match(ST_mass$tip.label, mass2_ST$hHostNameFinal),] ## worked, sorted df by tip label names
head(STx)
STx2 <- STx$hMassGramsLn

cytbPSR <- PSR(cytb_PVR, trait=x2) #way of showing phylo sig using PSR
PSRplot(cytbPSR, info="null")

PVRcytb <- PVR(cytb_PVR, phy=cytb_mass, trait=x2, method="moran") #PVR calculation - may take time

PVRcytb_resid <- PVRcytb@PVR$Residuals

mass3_cytb <- data.frame(x,PVRcytb_resid) #merged residuals with cytb mass in correct order of tree
names(mass3_cytb)
plot(mass3_cytb$hMassGramsLn, mass3_cytb$PVRcytb_resid)
#write.csv(mass3_cytb, file="PVR_cytb_hostmass.csv")  #write new PVR body mass file, calculated with cytb tree
