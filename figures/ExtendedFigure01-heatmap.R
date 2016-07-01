#load mvpd data from Parviez (number shared for all host combos and PD)
#Revised from code-26april2013.R and Heatmap-20March2016.R

#15 June 2016 revision for just main Heatmap figure, plus a couple other figures not used (can delete before making public)
options(stringsAsFactors=F)
require(ggplot2)
#library(gplots)
#library(scales)
require(reshape)
require(graphics)
require(grDevices)
require(RColorBrewer)
require(pheatmap)
#require(gtools)
P <- rprojroot::find_rstudio_root_file

set.seed(0)

asc <- read.csv(P("data/associations.csv"), header=T, strip.white = T)
h <- read.csv(P("data/hosts.csv"), header=T, strip.white = T)
v <- read.csv(P("data/viruses.csv"), header=T, strip.white = T)
asc_noHoSa <- asc[asc$hHostNameFinal!="Homo_sapiens", ]


## Get matrix with nubmer of viruses infecting each host family by viral family
# For Heatmap, using asc without humans
vfam <- unique(v$vFamily)
hfam <- unique(h$hFamily)
hord <- unique(h$hOrder)
hfam <- unique(h$hFamily)

sort(hord)
names(h)
v2 <- v[, c("vVirusNameCorrected","vFamily")]
h2 <- h[, c("hHostNameFinal","hOrder" ,"hFamily" )]
#merging in Family level viral taxonomy and host order taxonomy to asc file
asc2 <- merge(asc_noHoSa, v2, by.x="vVirusNameCorrected", by.y="vVirusNameCorrected")
asc2 <- merge(asc2, h2, by.x="hHostNameFinal", by.y="hHostNameFinal")
x <- tapply(asc2$vVirusNameCorrected, asc2$vFamily, length)
xu <- tapply(asc2$vVirusNameCorrected, asc2$vFamily, function (x) length(unique(x)))
xu2 <- tapply(asc2$vVirusNameCorrected, asc2$hOrder, function (x) length(unique(x)))
#virus family, host order table, showing total count on asc records for each (not unique)
vfho_table <- tapply(asc2$vVirusNameCorrected, list(asc2$vFamily,asc2$hOrder), length)
#unique viruses by host order and virus family matrix below = z
z <- tapply(asc2$vVirusNameCorrected, list(asc2$vFamily,asc2$hOrder), function (x) length(unique(x)))
# making new matrix without NA, changed to 0
z2 <-z
z2[is.na(z2)] <- 0

vricho <- apply(z2, 2,sum) #getting # of unique viruses by order, minus human records
vricho <- as.data.frame(vricho)


#15 June 2016 - Extended Data Figure 1, Unique viral richness by host Order and viral Family heatmap
pheatmap(z2, col=c("white", col=brewer.pal(9, "YlOrRd")),
         breaks=c(0, 0.5,1,2,5,10,15,20,30,50), cluster_rows=T, cluster_cols=T,
         clustering_method = "complete", scale="none", fontsize_row = 12, display_numbers=T, number_format = "%.0f",
         treeheight_col=0, treeheight_row=0,
         fontsize_col = 12, fontsize_number=10, margins=c(13,5))
## Different picutre when scale="row" vs. scale="none"
## Different clustering methods give different picture than above. e.g. "centroid" vs "complete"
## Different clustering_distance methods give different picture than above.
  #e.g. "correlation" vs. "euclidean" vs. "manhattan" v. "maximum"

