
## First run these:

## source("host.human.share.data.R")
## source("host.human.share.fit.R")

## wait for completion then run this file.

source("checkAIC.R")
source("pval.R")

load("AllModelAICs.RData")
load("nshared.glm.RData")
load("nshared.pval.RData")

p$dAIC = p$AIC - min(p$AIC)

bm = p[ p$dAIC < 0.1 ,]           ## Low AIC models
lr = p[ p$Rank == min(p$Rank), ]  ## Lowest Rank within 2 AIC of minimum

bm = rbind(lr,bm)
bm = bm[ order( bm$Rank), ]

bms = na.omit( meb[ meb$lbl %in% bm$Model, ] )
bms = bms[ order( nchar(bms$rhs) ),  ]

fn = unlist( strsplit( getwd(), "/") )
fn = fn[ length(fn) ] 

cat( "cat('Model with min AIC is ", bms$lbl[ bms$dAIC == 0 ], "\n', rep('~',30),sep='')\n",
    "require('mgcv')\n require(MASS) \n\n",
    "bgams = list() \n",
    "options(digits=10)\n",
    paste(
        "\n\n bgams$", bms$lbl," = g = gam( NSharedWithHoSa ~  LnTotNumVirus + \n",
        bms$rhs, " 1 , \n",
        "data=hp3ap, family=poisson )\n\n",
        "cat('\nModel: ", bms$lbl, "\t Rank = ',g$rank,'\t AIC = ',AIC(g),'\n')\n\n",
        "print(summary(g))\n",
        "cat('\n\n',rep('~',30),'\n\n',sep='')\n\n",
        sep=""),
    sep = "", file="bestSummary.R" )

capture.output( source("bestSummary.R"), file=paste0( fn, ".BestModelSummary.txt") )

save( bgams, file="bestAllGam.RData")
