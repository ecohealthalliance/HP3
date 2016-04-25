rm(list=ls())

options(stringsAsFactors=FALSE)

## Read in assocation file
a = read.csv("~/HP3.PRH/March2016nshared/v41dataKJO/HP3.assocV41_FINAL.csv", as.is=T)

## Limit to Hi Quality detection method, i.e., Stringent data
## Remove NAs as well (turn to -1) as they mess up >= operator
a$DetectionQuality02 = ifelse( is.na(a$DetectionQuality02), -1, a$DetectionQuality02 )

a = a[ a$DetectionQuality02 >= 2, ]
## Calculate total num virus per host.
a$TotVirusPerHost = 1
x = aggregate( TotVirusPerHost ~ hHostNameFinal, data=a, sum, na.rm=T)

b = a[,2:3]   	## Select just host and virus name for data frame
d = b			## duplicate that dataframe

names(d)[2] = "hHostNameAgain"		## rename second host name

m = merge(b,d,all=TRUE)  ## merge two dataframes by virus name

mt = with(m, table(hHostNameFinal,hHostNameAgain) )		## turn it into a table

u = data.frame(mt, stringsAsFactors=FALSE) ## automatically reshapes!

v = u[ u$hHostNameFinal != u$hHostNameAgain, ]

v$hHostNameFinal = as.character(v$hHostNameFinal)
v$hHostNameAgain = as.character(v$hHostNameAgain)

h = v[ v$hHostNameAgain=="Homo_sapiens", ]
h = h[ h$hHostNameFinal!="Homo_sapiens", ]

h = h[,-2]
names(h)[2] = "NSharedWithHoSa"

hx = merge(h,x)

## Read in Host data
b = read.csv("~/HP3.PRH/March2016nshared/v41dataKJO/HP3.hostv41_FINAL.csv", as.is=T)

## Delete fields useless to analysis, and memory hogging for merges
b$Authority = b$Synonyms = b$HoSaPDcytb = NULL
b$Common.names_Spa = b$Common_names_Eng = b$Common_names_Fre = NULL

## Read in separate host data
p = read.csv("~/HP3.PRH/v30data/hp3_pop.csv",as.is=T)
m = read.csv("~/HP3.PRH/March2016nshared/v41dataKJO/PVR_cytb_hostmass.csv", as.is=T)

pm = merge(p,m, by="hHostNameFinal")
bp = merge(b,pm, by="hHostNameFinal")
hb = merge(bp,hx, by="hHostNameFinal")

## Exclude marine from analysis
hb = hb[ with(hb, ("Terrestrial" == hMarOTerr) ), ]

## Wild only
hb = hb[ with(hb, ("wild" == hWildDomFAO) ), ]

## No longer standardizing, easiest to change function
Z = function(x) {
 return(x)
}
hh = hb[, 1:3]

hh$TotNumVirus = hb$TotVirusPerHost ## Is Dependent variable

hh$hDiseaseZACitesLn = Z( log(hb$hDiseaseZACites +1) ) # num 2.3 2.4 0 5.21
hh$hAllZACitesLn = Z( log(hb$hAllZACites) ) # num 3.97 4.08 2.2 6.72
hh$hAllZACites = Z( hb$hAllZACites )
hh$hDiseaseZACites = Z( hb$hDiseaseZACites )

hh$hOrder = as.factor(hb$hOrder)
hh$hWildDomFAO = as.factor(hb$hWildDomFAO)
hh$hHuntedIUCN = as.factor(hb$hHuntedIUCN)
hh$hArtfclHbttUsrIUCN = as.factor(hb$hArtfclHbttUsrIUCN)
hh$RedList_status = as.factor(hb$RedList_status)
hh$hPopulation_trend = factor(hb$Population_trend, 
                                 levels=sort(unique(hb$Population_trend),decreasing = T))

hh$hMassGramsPVR = hb$PVRcytb_resid
  
hh$S100 = Z( hb$S100 )
hh$S80  = Z( hb$S80 )
hh$S50  = Z( hb$S50 )
hh$S40  = Z( hb$S40 )
hh$S20  = Z( hb$S20 )
hh$S    = Z( hb$S )

logp = function(x){
    m = min(x[ x > 0], na.rm=T)/10
    x = log( x + m )
    return(x)
}

hh$LnAreaHost = Z( logp( hb$AreaHost ) )


save(hh, file="FullData.RData")

hp3ap = na.omit( hh )

## Model fitting function
lr = function(lbl, x, fn, ...) {
    cat("\n ~~ Running model :",lbl,"\n\n")
    
    ## Poisson version
    b = gam(x, data=hp3ap, family=poisson, ...)
    a = AIC(b)
    names(a) = paste( lbl, ".Psn", sep="")
    write.table(a,fn,sep=",",append=T, col.names=F)

    ## Negative binomial version
##    b = try( glm.nb(x, data=hp3ap, control=glm.control(maxit=1000), ... ) )
##    a = ifelse( exists("converged",b), ifelse(b$converged, AIC(b), Inf) , NA)
##    names(a) = paste( lbl, ".NB", sep="")
##    write.table(a,fn,sep=",",append=T, col.names=F)
}

save(hp3ap, lr, file='totVir.glm.RData')
