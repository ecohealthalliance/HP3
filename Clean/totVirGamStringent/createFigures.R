
load("bestAllGam.RData")
load("nshared.glm.RData")
a = sapply( bgams, AIC)
bestAllGam = bgams[[ which( a == min(a) ) ]]

base = data.frame(
    LnTotNumVirus = log(10),
    urban.perc = mean(hp3ap$urban.perc),
    hMassGramsLn = mean(hp3ap$hMassGramsLn),
    PdHoSa.cbCst =mean(hp3ap$PdHoSa.cbCst),
    median.pop = mean(hp3ap$median.pop),
    hAllZACitesLn = mean(hp3ap$hAllZACitesLn)
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

## Layout plan
l = 20
l = layout( matrix( c(7,1,2,7,3,4,7,5,6), ncol=3, byrow=TRUE),
		widths=c(1,l,l), heights=c(3,3,3) )
layout.show(l)
layout( matrix(1:3,ncol=1) )
title( ylab="ylab",col="red" )

graphics.off()

par(mar=c(5,3,0,0)+0.5)
## A, alternate, Tot Num Virus Log-Arith Scale
y = res$LnTotNumVirus = numps("LnTotNumVirus", base)
title(xlab="Total Number of Viruses per Host Species")
i = c(0,1,2,4,7,12,22)
axis(1, log(i), i)
axis(2,las=2)

pdf( "Nature6panel.pdf",width=7.2,height=9.4)
par(mar=c(5,3,0,0)+0.5)

## Layout
l = 20
l = layout( matrix( c(10,10,10,7,1,2,8,3,4,9,5,6), ncol=3, byrow=TRUE),
		widths=c(1,l,l), heights=c(0.15,3,3,3) )

## A,alternate, Tot Num Virus Log-Arith Scale
plot( exp(y[[1]]), y$fit, type="n",  xlab="Total Number of Viruses per Host Species", 
	ylab="", las=1, ylim = range( c(y$lo,y$hi,20) ),  xlim=c(0,23))

polygon( exp( c(rev(y[[1]]), y[[1]] ) ), c( rev(y$lo), y$hi ),
	col = 'darkseagreen3', border = NA)

lines( exp(y[[1]]), y$fit,lwd=2)

lines( exp(y[[1]]), y$lo, lty="32", lwd=2)
lines( exp(y[[1]]), y$hi, lty="32", lwd=2)

mtext("a", font=2, xpd=NA, adj=-0.12, cex=1)

## B,  PD  #######################################
y = res$PdHoSa.cbCst = numps("PdHoSa.cbCst", base, polyCol="darkseagreen3" )
axis(1); axis(2, las=2)
title(xlab="Phylogenetic Distance, CytB constrained by SuperTree")
#text(-.2, 28, "b", xpd=NA, font=2)
mtext("b", font=2, xpd=NA, adj=-0.12, cex=1)

## C, Mass ####################################### 
y = res$hMassGramsLn = numps("hMassGramsLn", base, polyCol="darkseagreen3" )
axis(2, las=2 )
axis(1, log(10^(1:6)), 10^(-2:3) )
title(xlab="Mass in Kilograms" )
mtext("c", font=2, xpd=NA, adj=-0.12, cex=1)

## D, Urban Percent ########################################
y = res$urban.perc = numps("urban.perc", base)
axis(1); axis(2, las=2)
title(xlab="Percent of Focal Mammal Host Range Percent Urban" )
mtext("d", font=2, xpd=NA, adj=-0.12, cex=1)

## E, Median Population ########################################
y = res$median.pop = numps("median.pop", base)
title(xlab="Median Human Population ")
a = c(-6,-4,-2,2) 
for(i in a)
    axis(1, log(10^i), substitute( 10^x, list(x=i) ) )
axis(1, 0, 1) 
axis(2,las=2)
mtext("e", font=2, xpd=NA, adj=-0.12, cex=1)

## F, Cites ######################################
y = res$hAllZACitesLn = numps("hAllZACitesLn", base )
title(xlab="Number of Citations for Focal Host Mammal")
axis(1, 0, 1) 
axis(2,las=2)
i = c(1, 5, 50,500,4000)
axis(1, log(i), i)
mtext("f", font=2, xpd=NA, adj=-0.12, cex=1)

for(i in 1:3){
	par(mar=rep(0,4))
	plot(0,0,type="n",axes=F,xlab="",ylab="")
	mtext("Total Number of Virus Shared",side=2,line=-2, adj=0.75, xpd=NA,cex=0.75)
}


dev.off()
graphics.off()




