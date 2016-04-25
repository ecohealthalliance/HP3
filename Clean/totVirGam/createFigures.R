rm(list=ls())
load("totVir.glm.RData")
load("bestAllGam.RData")

a = sapply( bgams, AIC)
bestAllGam = bgams[[ which( a == min(a) ) ]]

base = data.frame(
    hOrder = unique(hp3ap$hOrder[ hp3ap$hOrder == "CHIROPTERA"]),
    hPopulation_trend = unique(hp3ap$hPopulation_trend[ hp3ap$hPopulation_trend == "stable"]),
    LnAreaHost = mean(hp3ap$LnAreaHost),
    hMassGramsPVR = mean(hp3ap$hMassGramsPVR),
    S20 =mean(hp3ap$S20),
    hDiseaseZACitesLn = mean(hp3ap$hDiseaseZACitesLn)
    )

numps = function(n, b, length=201, ylim=NA, polyCol="grey80", ...) {
    b[[ n ]] = NULL
    z = hp3ap[[ n ]] 
    y = data.frame(seq(min(z), max(z), length=length ) )
    names(y) = n
    y = cbind(y, b)
    
    p = predict(bestAllGam, y, type="response", se.fit=TRUE)
    ci = data.frame( lo = p$fit - 1.96*p$se.fit, hi= p$fit + 1.96*p$se.fit)
    
    if( is.na( ylim ) )
        ylim  = c(0, max(ci) )

    plot( y[[n]], p$fit, xlab = "", type="l", ylim =ylim, axes=F, ylab = "", ...)
         
    polygon( c(rev(y[[n]]), y[[n]] ), c( rev(ci$lo), ci$hi ), col = polyCol, border = NA)
 
 	lines( y[[n]], p$fit, xlab = "", ylim =ylim, lwd=2, 
         ylab = "Expected Number of Shared Viruses", ...)
   
         
    lines( y[[n]], ci$lo, lty="32", lwd=2)
    lines( y[[n]], ci$hi, lty="32", lwd=2)
    
    
    ## abline( v=mean(y[[n]]), col="grey40", lty="dotted")
    box()
    
    y = cbind(y,p,ci)
    invisible(y)
}

res = list()

oldPar = par(no.readonly=TRUE)

par(mar=c(5,3,0,0)+0.5)
## A, alternate, Tot Num Virus Log-Arith Scale
y = res$LnAreaHost = numps("LnAreaHost", base)
title(xlab="Total Number of Viruses per Host Species")
i = c(0,1,2,4,7,12,22)
axis(1, log(i), i)
axis(2,las=2)

pdf( "totVirPanelFigure.pdf",width=7.2,height=9.4)
par(mar=c(5,3,0,0)+0.5)

## Layout
l = 20
l = layout( matrix( c(10,10,10,7,1,2,8,3,4,9,5,6), ncol=3, byrow=TRUE),
		widths=c(1,l,l), heights=c(0.15,3,3,3) )

## A,  Cites  #######################################
y = res$hDiseaseZACitesLn = numps("hDiseaseZACitesLn", base, polyCol="darkseagreen3" )
axis(1, 0, 1) 
axis(2,las=2)
i = c(1, 5, 50,500,4000)
axis(1, log(i), i)
title(xlab="Number of Pathogen-related Citations for Focal Host Mammal")
mtext("a", font=2, xpd=NA, adj=-0.12, cex=1)

## B, S20 ####################################### 
y = res$S20 = numps("S20", base, polyCol="darkseagreen3",xlim=c(0,250) )
axis(1, c(1,50,100,150,200,250) ) 
axis(2,las=2)
title(xlab="S20" )
mtext("b", font=2, xpd=NA, adj=-0.12, cex=1)

## C, hMassGramsPVR ########################################
y = res$hMassGramsPVR = numps("hMassGramsPVR", base, polyCol="darkseagreen3")
axis(1); axis(2, las=2)
title(xlab="Phylogenetically Corrected Mass" )
mtext("c", font=2, xpd=NA, adj=-0.12, cex=1)

## D, LnAreaHost########################################
y = res$LnAreaHost = numps("LnAreaHost", base, xlim=log(c(10^9,10^14)) )
title(xlab="Log of Focal Mammal Host Range Area ")
a = seq(9,14,by=1)
for(i in a)
    axis(1, log(10^i), substitute( 10^x, list(x=i) ) )
axis(1, 0, 1) 
axis(2,las=2)

mtext("d", font=2, xpd=NA, adj=-0.12, cex=1)


for(i in 1:3){
	par(mar=rep(0,4))
	plot(0,0,type="n",axes=F,xlab="",ylab="")
	mtext("Total Number of Virus Shared",side=2,line=-2, adj=0.75, xpd=NA,cex=0.75)
}


dev.off()
graphics.off()




