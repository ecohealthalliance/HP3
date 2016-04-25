## Auto generate formulae
options( stringsAsFactors=FALSE)

## Create data.frame of all possible models
f = expand.grid(
  s0 = c( "s(hMassGramsPVR,bs='tp',k=7) +", ""),
  s1 = c( "s(LnAreaHost,bs='tp',k=7) +", ""),
  s2 = c( "s(PrcntCrop,bs='tp',k=7) +", ""),
  s3 = c( "s(PrcntGrass,bs='tp',k=7) + ", ""),
  s4 = c( "s(PrcntUrban,bs='tp',k=7) + ", "" ),
  s5 = c( "s(PrcntChngCrop,bs='tp',k=7) +", ""),
  s6 = c( "s(PrcntChngGrass,bs='tp',k=7) + ", ""),
  s7 = c( "s(PrcntChngUrban,bs='tp',k=7) + ", "" ),
  pdo = c(
    "hOrder + ",
    "s(PdHoSa.cbCst, bs='tp',k=7) + ",
    # "s(PdHoSa.cbCst, bs='tp',k=7) + hOrder +",
    "s(PdHoSaSTPD,bs='tp',k=7) + ",
    "PdHoSaSTPDf + ",
    "" ),
  f1 = c( "hHuntedIUCN + ", ""),
  f2 = c( "hArtfclHbttUsrIUCN + ", ""),
  f3 = c( "RedList_status + ", ""),
  pop =  c(
    "s(mean.pop,bs='tp',k=7) + ",
    "s(median.pop,bs='tp',k=7) + ",
    "s(max.pop,bs='tp',k=7) +",
    "s(TotHumPopLn, bs='tp',k=7) +",
    "s(TotHumPopAEG, bs='tp',k=7) +",
    "s(TotHumPopLn, bs='tp',k=7) + s(TotHumPopAEG, bs='tp',k=7) +",
    "s(RurHumPopAEG, bs='tp',k=7) +",
    "s(RurHumPopLn, bs='tp',k=7) +",
    "s(RurHumPopLn, bs='tp',k=7) + s(RurHumPopAEG, bs='tp',k=7) +",
    "s(UrbHumPopAEG, bs='tp',k=7) +",
    "s(UrbHumPopLn, bs='tp',k=7) +",
    "s(UrbHumPopLn, bs='tp',k=7) + s(UrbHumPopAEG, bs='tp',k=7) +",
    ""),
  bias = c(
    "s(hDiseaseZACitesLn,bs='tp',k=7) + ",
    "s(hAllZACitesLn,bs='tp',k=7) + ",
    ""),
  stringsAsFactors=FALSE)

## Paste together into Right Hand Side
f$rhs = with(f, paste( s0, s1, s2, s3, s4, s5, s6, s7,
  pdo, f1, f2, f3, pop, bias, sep = " ") )

## Select only unique ones
e = data.frame(rhs = unique( c(f$rhs, " " ) ) )

e$nchar = nchar(e$rhs)

e = e[ order( e$nchar ), ]

l = length(e$rhs)
e$lbl = sprintf("M%08d",1:l)

e$formula = with(e, paste( " lr( \"",lbl,"\" ,NSharedWithHoSa ~ LnTotNumVirus + ",rhs," 1,fn )", sep=""))

## Load Balance
nc =  15
e$core = rep( 1:nc, length.out = length(e$formula) )

sf = split(e$formula, e$core)


for( i in 1:nc) {
    cat(" fn = sprintf('aic%04d.csv',", i ," ) \n",
        " require(MASS) \n require(mgcv) \n", 
        " cat( 'Label, AIC \n',file = fn ) \n", 
        "load('nshared.glm.RData') \n\n",
        paste( "try( ", sf[[i]]," , silent=TRUE) ",
              collapse="\n "), "\n\n",
        file = sprintf("lr.auto%04d.R",i ),sep="")

    system( sprintf(" nice R --vanilla < lr.auto%04d.R &> /dev/null ",i ), wait=FALSE)
}
    
save(e, file="mdls.nshared.RData")
