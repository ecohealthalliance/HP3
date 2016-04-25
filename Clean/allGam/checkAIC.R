rm(list=ls())

load("mdls.nshared.RData")

print(  dim(e) )

a = NULL

fns =  dir(patt="aic[0-9]+.csv")

for( fn in fns )
    a = rbind( read.csv(fn), a )

a = na.omit(a) 

b = unique(a)

x = as.character(b$Label)
x = substr(x,2, nchar(x)-3)
x = as.integer(x)

b$lbl = sprintf("M%08d",x)

meb = merge(e,b, by="lbl", all=TRUE)

meb$dAIC = meb$AIC - min( meb$AIC,na.rm=T)

o = order(meb$dAIC)
meb = meb[o,]

meb$lkli = exp( -0.5*meb$dAIC)
m = sum(meb$lkli)
meb$wgt = meb$lkli/sum(meb$lkli,na.rm=T)
meb$cml.wgt = cumsum(meb$wgt)

save(meb,file="AllModelAICs.RData")

