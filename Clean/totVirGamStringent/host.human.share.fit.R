## Auto generate formulae
options( stringsAsFactors=FALSE)

## Create data.frame of all possible models
f = expand.grid(
  s1 = c( "s(LnAreaHost,bs='cs',k=7) +", ""),
  s2 = c( "s(hMassGramsPVR,bs='cs',k=7) +", ""),
  s3 = c(
    "s(S100,bs='cs',k=7) + ",
    "s(S80,bs='cs',k=7) + ",
    "s(S50,bs='cs',k=7) + ",
    "s(S40,bs='cs',k=7) + ",
    "s(S20,bs='cs',k=7) + ",
    "s(S,bs='cs',k=7) + ",
    ""),
  f1 = c( "RedList_status + ","hPopulation_trend + ", ""),
  pdo = c("hOrder + ", "" ),
  bias = c(
    "s(hDiseaseZACitesLn,bs='cs',k=7) + ",
    "s(hAllZACitesLn,bs='cs',k=7) + ",
    ""),
  stringsAsFactors=FALSE)

## Paste together into Right Hand Side
f$rhs = with(f, paste( s1, s2, s3, f1,  
  pdo, bias, sep = " ") )

## Select only unique ones
e = data.frame(rhs = unique( c(f$rhs, " " ) ) )

e$nchar = nchar(e$rhs)

e = e[ order( e$nchar ), ]

l = length(e$rhs)
e$lbl = sprintf("M%08d",1:l)

e$formula = with(e, paste( " lr( \"",lbl,"\" ,TotNumVirus ~  ",rhs," 1,fn )", sep=""))

## Load Balance
nc =  15
e$core = rep( 1:nc, length.out = length(e$formula) )

sf = split(e$formula, e$core)


for( i in 1:nc) {
    cat(" fn = sprintf('aic%04d.csv',", i ," ) \n",
        " require(MASS) \n require(mgcv) \n", 
        " cat( 'Label, AIC \n',file = fn ) \n", 
        "load('totVir.glm.RData') \n\n",
        paste( "try( ", sf[[i]]," , silent=TRUE) ",
              collapse="\n "), "\n\n",
        file = sprintf("lr.auto%04d.R",i ),sep="")

    system( sprintf(" nice R --vanilla < lr.auto%04d.R &> /dev/null ",i ), wait=FALSE)
}
    
save(e, file="mdls.totVir.RData")
