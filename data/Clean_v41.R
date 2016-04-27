## Check new asc, v, and h files v41 to clean
## 12 March 2016 - KJO

rm(list=ls())
options(stringsAsFactors=F)
setwd("/Users/KJO/Dropbox (EHA)/HP3/v40/PhyloSig")

require(dplyr)
library(geiger)
require(picante) 
require(ape)

asc <- read.csv(file="HP3.assocV41_FINAL.csv", header=T, strip.white = T)
h <- read.csv(file="HP3.hostV40_ARW_tomerge.csv", header=T, strip.white = T)
v <- read.csv(file="HP3.virusv40.csv", header=T, strip.white = T)

m <- read.csv(file="HP3.SimplifiedHostMass.csv", header=T)
m$hMassGramsLn <- log(m$hMassGrams) #add in log of mass
h <- merge(h,m, by="hHostNameFinal", all.x=T, all.y=F) #merge mass into host datafile

c <- read.csv(file="hp3_decadal_complete_13MAR2016.csv", header=T) #new global contact data from Carlos 5 March 2016
names(h)
names(c) #keep subset of carlos with new spatial data
c2<- c[, c(1,27:45, 48:78)] #subet with just new variables from Carlos
h<-merge(h,c2, by = "hHostNameFinal", all.x=T, all.y=F)
names(h)

### 
names(asc)
va <- unique(asc$vVirusNameCorrected)
ha <- unique(asc$hHostNameFinal)

setdiff(ha, h$hHostNameFinal) #all spp in asc file are in h file, fixed one spelling error
h_drop <- setdiff(h$hHostNameFinal, ha)  #15 species no longer in asc file, still in h file (deleted no ref or detection method)
h <- h[!h$hHostNameFinal %in% h_drop, ] #drop 15 spp from h file

setdiff(va, v$vVirusNameCorrected) #all viruses in asc file are in v file,
v_drop <- setdiff(v$vVirusNameCorrected, va) # 3 viruses now removed from asc file due to poor support,"Hughes_virus" "Ovine_adenovirus_B" "Ovine_adenovirus_C"
v <- v[!v$vVirusNameCorrected %in% v_drop, ] #drop 3 viruses from v file

#### Re Calculate Phylogenetic Host Breadth measures for each virus
#load in phylogenetic trees, cytb and Supertree (ST)
cytb <- read.tree(file = "665spp-RaxML-constrained_STtopol-FINAL-4June2014.tree") 
ST <- read.tree("ST_HP3_woutg-3April2014-7taxaADDED.tree") #improved ST, fixed all taxa plus added monotremes 3 april 2014 (NEW ST w/outg)

#drop tips from trees for 15 hosts dropped from asc
cytb$tip.label[sort.list(cytb$tip.label)] #665 spp in original cytb
cytb_drop <- setdiff (cytb$tip.label, h$hHostNameFinal) #21 spp in cytb tree, not in h file
cytb2 <- drop.tip(cytb, which(cytb$tip.label %in% cytb_drop)) #new tree, drop all tips in cytb not in h

ST$tip.label[sort.list(ST$tip.label)] #770 spp in original ST tree
ST_drop <- setdiff (ST$tip.label, h$hHostNameFinal) #17 spp in ST tree, not in h file
ST2 <- drop.tip(ST, which(ST$tip.label %in% ST_drop)) #new tree, drop all tips in ST not in h

### Code to calculate PHB  - Lines 56-135

## First calculate sp to sp maxtrix of phylo distance (cophenetic)
vSTphylodist <- as.data.frame(cophenetic(ST2)) #calculate ST PD #753 spp.
#write.csv(vSTphylodist, "HP3-ST_PDmatrix-12Mar2016.csv") #write PD matrix to file
vCYTBphylodist <- as.data.frame(cophenetic(cytb2)) #calculate cytb PD #644 spp.
#write.csv(vCYTBphylodist, "HP3-cytb_PDmatrix-12Mar2016.csv") #write PD matrix to file

### CODE below from Parviez, 2013 to get PHB at different levels, and mean, max, etc.
## Simplify to just association portion
## Replace VirusName_corrected with other virus taxonomy to aggregate higher on viruses
## Replace Final_name with other host taxonomy to aggregate higher on hosts
## KJO - can also calculate PHB for "stringent data" by first selecting in asc file
table(asc$DetectionQuality02) #just over half of data are stringent. 
asc_stringent <- asc[asc$DetectionQuality02==2, ]
  
tree <- vCYTBphylodist
hp3 <- asc_stringent

as = match( c( "vVirusNameCorrected","hHostNameFinal" ), names(hp3) )
as = hp3[,as]
names(as) = c("Virus","Host")

vn = unique(as$Virus)
hn = unique(as$Host)

## Function to return distance between host pair
## If a host species isn't in tree, we can get either NULL or NA
## Always return NA
f = function(x){
  y = tree[ x["B"], x["A"] ]
  if( is.null(y) ) y = NA
  return(y)
}

## Function to get distance dataframe for host pairs of virus
g = function(z) {
  ## get host list for that virus
  b = as$Host[ as$Virus==z ]
  if( length(b) < 2 ) {
    ## special code for viruses with unique host
    a = data.frame(vVirusNameCorrected = z, 
                   vBrdth.medianPD.cytb.stringent = 000.00, 
                   vBrdth.meanPD.cytb.stringent =  000.00, 
                   vBrdth.minPD.cytb.stringent =  000.00, 
                   vBrdth.maxPD.cytb.stringent =  000.00,
                   vBrdth.iqrPD.cytb.stringent =  NA, 
                   vBrdth.sdPD.cytb.stringent  = NA  )
    
    return( a )
  }
  ## Generates all unique combinations of host pairs for given virus
  b = combn(  b, 2) 
  ## Format it nicely as a sensible data frame
  b = data.frame( A = b[1,], B = b[2,] )
  
  ## apply distance function f to each pair, using apply
  ## attach to data frame as new column
  b$Dist = apply(b,1,f)
  
  a = data.frame(vVirusNameCorrected = z, 
                 vBrdth.medianPD.cytb.stringent = median(b$Dist, na.rm=TRUE), 
                 vBrdth.meanPD.cytb.stringent = mean(b$Dist, na.rm=TRUE),
                 vBrdth.minPD.cytb.stringent = min(b$Dist, na.rm=TRUE),  
                 vBrdth.maxPD.cytb.stringent = max(b$Dist, na.rm=TRUE),
                 vBrdth.iqrPD.cytb.stringent = IQR(b$Dist, na.rm=TRUE, type=8),
                 vBrdth.sdPD.cytb.stringent  = sd(b$Dist, na.rm=TRUE)
  )
  
  return(a)
}

## unfortunately could get an apply function to work with returned data frames
## so manual looping
res = g(vn[1])
for( i in 2:length(vn) ){
  cat("\n - - Running virus ", i," which is ", vn[i] , "\n")
  res = rbind(res, g(vn[i]) )
}

## Make sure all non-finite values are NAs.
for( i in 2:length( names(res) ) )
  res[,i] = ifelse( is.finite( res[,i] ), res[,i], NA) 

rm(as); rm(res)
#write.csv(res,"vBrdth.cytb.stringent_12Mar2016.csv",row.names=FALSE)

### Now merge in cytb and ST viral PHB to v dataframe
cytbPHB <- read.csv(file="vBrdth.cytb_12Mar2016.csv", header=T)
stPHB <- read.csv(file="vBrdth.ST_12Mar2016.csv", header=T)
st.stringentPHB <- read.csv(file="vBrdth.ST.stringent_12Mar2016.csv", header=T)
cytb.stringentPHB <- read.csv(file="vBrdth.cytb.stringent_12Mar2016.csv", header=T)

names(cytbPHB)
v <- merge(v, cytbPHB, by.all=v$vVirusNameCorrected, all=T)
v <- merge(v, stPHB, by.all=v$vVirusNameCorrected, all=T)
v <- merge(v, st.stringentPHB, by.all=v$vVirusNameCorrected, all=T)
v <- merge(v, cytb.stringentPHB, by.all=v$vVirusNameCorrected, all=T)

#Calculate Is Human Virus? and Is Zoonotic? for each VIRUS
hvs <- asc[asc$hHostNameFinal=="Homo_sapiens", 2]
ishuman <- data.frame(vVirusNameCorrected=hvs, IsHoSa=1) #new dataframe with is human = 1
v <- merge(ishuman, v, by="vVirusNameCorrected", all=T)
v$IsHoSa = ifelse(is.na(v$IsHoSa), 0, 1) #or could use v_isHoSa$IsHoSa instead of 1

visHoSaOnly = v[ , c(1,2)] #create df with only is human virus variable
ascIsHoSa <- merge(asc, visHoSaOnly, by="vVirusNameCorrected", all=T)
names(visHoSaOnly)

IsHoSarich <- tapply(ascIsHoSa$IsHoSa, ascIsHoSa$hHostNameFinal, sum)
IsHoSarich <- data.frame(hHostNameFinal=names(IsHoSarich), vHoSaRich=IsHoSarich) #make a two variable df
row.names(IsHoSarich) <- NULL #to erase row names and replace with default numbers
head(IsHoSarich)

#merge back in with h
h <- merge(h,IsHoSarich, by="hHostNameFinal" )

## KJO trying to calculate # zoonotic and check against # human only 1 Nov 2014
hvmatrix <- with(asc, table(vVirusNameCorrected, hHostNameFinal)) 
numhost <- as.data.frame(rowSums(hvmatrix))
colnames(numhost) <- "NumHosts"  #rename matrix sum column

#merge by rownames
v <- merge(v, numhost, by.x="vVirusNameCorrected", by.y="row.names")  ## worked
names(v)

#now sort out which Is Human, are exclusively human, vs. zoonotic
HoSaOnly <- v[(v$IsHoSa==1) & (v$NumHosts==1), ]  #93 human only prev; now 75 (March 2016)
Zoonotic <- v[(v$IsHoSa==1) & (v$NumHosts>1), ] #165 zoonotic prev; now 188 (March 2016)
Zoonotic$IsZoonotic <- 1
names(Zoonotic)
Zoonotic2 <- Zoonotic[, c("vVirusNameCorrected","IsZoonotic")]
v <- merge(v, Zoonotic2, by="vVirusNameCorrected", all=T)
v$IsZoonotic = ifelse(is.na(v$IsZoonotic), 0, 1)


######## Same as above, but for stringent data, Is Zoonotic, Is HoSa, and NumHosts
#Calculate Is Human Virus? and Is Zoonotic? for each VIRUS

hvs <- asc_stringent[asc_stringent$hHostNameFinal=="Homo_sapiens", 2]
ishuman <- data.frame(vVirusNameCorrected=hvs, IsHoSa.stringent=1) #new dataframe with is human = 1
v <- merge(ishuman, v, by="vVirusNameCorrected", all=T)
v$IsHoSa.stringent = ifelse(is.na(v$IsHoSa.stringent), 0, 1) #or could use v_isHoSa$IsHoSa instead of 1

visHoSaOnly.stringent = v[ , c(1,2)] #create df with only is human virus variable
asc_stringentIsHoSa <- merge(asc_stringent, visHoSaOnly.stringent, by="vVirusNameCorrected", all=T)
names(visHoSaOnly.stringent)

IsHoSarich.stringent <- tapply(asc_stringentIsHoSa$IsHoSa.stringent, asc_stringentIsHoSa$hHostNameFinal, sum)
IsHoSarich.stringent <- data.frame(hHostNameFinal=names(IsHoSarich.stringent), vHoSaRich.stringent=IsHoSarich.stringent) #make a two variable df
row.names(IsHoSarich.stringent) <- NULL #to erase row names and replace with default numbers
head(IsHoSarich.stringent)

#merge back in with h
h <- merge(h,IsHoSarich.stringent, by="hHostNameFinal", all.x=T, all.y=F )

## KJO trying to calculate # zoonotic and check against # human only 1 Nov 2014
hvmatrix.stringent <- with(asc_stringent, table(vVirusNameCorrected, hHostNameFinal)) 
numhost.stringent <- as.data.frame(rowSums(hvmatrix.stringent))
colnames(numhost.stringent) <- "NumHosts.stringent"  #rename matrix sum column

#merge by rownames
v <- merge(v, numhost.stringent, by.x="vVirusNameCorrected", by.y="row.names", all.x=T, all.y=F)  ## worked
names(v)

#now sort out which Is Human, are exclusively human, vs. zoonotic
HoSaOnly.stringent <- v[(v$IsHoSa.stringent==1) & (v$NumHosts.stringent==1), ]  #93 stringent
Zoonotic.stringent <- v[(v$IsHoSa.stringent==1) & (v$NumHosts.stringent>1), ]  #108 stringent
Zoonotic.stringent$IsZoonotic.stringent <- 1
Zoonotic2.stringent <- Zoonotic.stringent[, c("vVirusNameCorrected","IsZoonotic.stringent")]
v <- merge(v, Zoonotic2.stringent, by="vVirusNameCorrected", all.x = T, all.y=F)
v$IsZoonotic.stringent = ifelse(is.na(v$IsZoonotic.stringent), 0, 1)


#write.csv(v, file="HP3.virusv41_FINAL.csv")

#calculate viral richness (vir_rich) per HOST from asc dataset
vrich <- tapply(asc$vVirusNameCorrected, asc$hHostNameFinal, length)
vrich <- data.frame(hHostNameFinal=names(vrich), vir_rich=vrich) #make a two variable df
head(vrich)
row.names(vrich) <- NULL #to erase row names and replace with default numbers
h <- merge(vrich, h, by="hHostNameFinal") #merge in viral richness per host

#merge back in with h
h <- merge(h,IsHoSarich.stringent, by="hHostNameFinal", all.x=T, all.y=F )
#write.csv(h, file="HP3.hostv41_FINAL.csv")
