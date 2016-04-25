
rm(list=ls())

load("AllModelAICs.RData")
load("totVir.glm.RData")
require(mgcv)

lr = function(lbl, x, fn, ...) {
    ## Poisson version
    g = gam(x, data=hp3ap, family=poisson, ...)
    sg = summary(g)
    
        a = data.frame(
            Model = lbl, Error="Poisson",
            AIC=AIC(g),
            Rank = g$rank,
            t( c(sg$s.table[,'p-value'], sg$pTerms.pv ) )
            )
    return(a)
}

sf = meb$formula[ meb$dAIC < 2]


save(sf, lr, hp3ap, file="totVir.CalcPval.RData")

cat(" fn = NULL \n",
    " require(MASS) \n",
    " require(mgcv) \n", 
    "load('totVir.CalcPval.RData') \n\n",
    "p = data.frame(Model='null') \n",
    paste("p = merge(p, ", sf,",all=TRUE ) ",
          sep="", collapse="\n "),
    "\n\n",
    "p = p[ !(p$Model=='null'), ]", 
    "\n\n","save(p,file='totVir.pval.RData')\n\n",
    "\n\n","write.csv(p,file='totVir.pval.csv')\n\n",
    file = "genPval.R",
    sep="")


source("genPval.R",echo=T, max=Inf)

