remove_var_terms = function(model, vars) {
  
}


cv_gam <- function(mod, k) {
  dat = mod$model
  dat$fold = base::sample(rep(1:k, length.out=nrow(dat)), nrow(dat))
  cv_out=map_df(1:k , function(x) {
      dat2 = dat[dat$fold != x, ]
      zero_terms = names(dat2)[map_lgl(dat2, ~length(unique(.x)) == 1)]
      new_formula = rm_terms(model, zero_terms)
      new_mod = update(model, formula=new_formula, data = dat2)
      preds = as.vector(predict(new_mod, newdata = dat[dat$fold == x, ], type="response"))
      actuals = dat[dat$fold == x, names(dat)[attributes(terms(mod))$response]]
      deviance = ifelse(actuals==0, 0, actuals*log(actuals/preds) )
      deviance = 2*sum(deviance - (actuals-preds) )
      df = length(actuals)-1
      p = pchisq(deviance, length(actuals)-1, lower.tail=FALSE)
      return(data_frame(fold=as.character(x), `residual deviance`=deviance, `degrees of freedom`=df, `p-value`=p))
    })
  rbind(cv_out, data_frame(fold="mean",
                           `residual_deviance` = mean(cv_out$`residual deviance`),
                            `degrees of freedom` = min(cv_out$`degrees of freedom`)))
}
require(mgcv)
require(dplyr)
setwd("~/HP3.PRH/curNshared/allGam/")

load("FullData.RData")

hp3f = na.omit( select(hh,  hOrder, NSharedWithHoSa, LnTotNumVirus, urban.perc, hMassGramsLn,
                       PdHoSa.cbCst, median.pop, hAllZACitesLn, hHostNameFinal) )

hp3f$TwelveFold = sample( rep(1:12,49) )
hp3f$SevenFold = sample( rep(1:7,84) )

twelve = NULL

for(i in 1:12) { 
  x = hp3f[ hp3f$TwelveFold!=i, ]
  bm = gam( NSharedWithHoSa ~  LnTotNumVirus + 
              s(urban.perc,bs='cs',k=7) +  s(hMassGramsLn,bs='cs',k=7) +
              s(PdHoSa.cbCst, bs='cs',k=7) + s(median.pop,bs='cs',k=7) +
              s(hAllZACitesLn,bs='cs',k=7) +  1 , 
            data=x, family=poisson )
  
  
  e = as.vector( predict( bm, newdata=hp3f[ hp3f$TwelveFold==i, ], type="response") )
  o = as.vector( hp3f$NSharedWithHoSa[ hp3f$TwelveFold==i ])
  d = ifelse(o==0, 0, o*log(o/e) )
  d = 2*sum(d - (o-e) )
  
  twelve = rbind(twelve, cbind(fold=i, res.deviance = d, df = length(o)-1,
                               p = pchisq(d, length(o)-1, lower.tail=FALSE) ) )
}

twelve = data.frame(twelve)
twelve$fold = as.character(twelve$fold)
d = mean(twelve$res.deviance)
twelve = rbind(twelve, data.frame(fold="mean", res.deviance = d, df = length(o)-1,
                                  p = pchisq(d, length(o)-1, lower.tail=FALSE) ) )

w = strsplit( getwd(), "/")[[1]]
w = w[ length(w) ]
w = paste("TwelveFoldCrossValid",w,"csv",sep=".")

write.csv(twelve, w, row.names=FALSE)

seven = NULL
for(i in 1:7) { 
  x = hp3f[ hp3f$SevenFold!=i, ]
  bm = gam( NSharedWithHoSa ~  LnTotNumVirus + 
              s(urban.perc,bs='cs',k=7) +  s(hMassGramsLn,bs='cs',k=7) +
              s(PdHoSa.cbCst, bs='cs',k=7) + s(median.pop,bs='cs',k=7) +
              s(hAllZACitesLn,bs='cs',k=7) +  1 , 
            data=x, family=poisson )
  
  
  e = as.vector( predict( bm, newdata=hp3f[ hp3f$SevenFold==i, ], type="response") )
  o = as.vector( hp3f$NSharedWithHoSa[ hp3f$SevenFold==i ])
  d = ifelse(o==0, 0, o*log(o/e) )
  d = 2*sum(d -(o-e))
  
  seven = rbind(seven, cbind(fold=i, res.deviance = d, df = length(o)-1,
                             p = pchisq(d, length(o)-1, lower.tail=FALSE) ) )
}

seven = data.frame(seven)
seven$fold = as.character(seven$fold)
d = mean(seven$res.deviance)
seven = rbind(seven, data.frame(fold="mean", res.deviance = d, df = length(o)-1,
                                p = pchisq(d, length(o)-1, lower.tail=FALSE) ) )

w = strsplit( getwd(), "/")[[1]]
w = w[ length(w) ]
w = paste("SevenFoldCrossValid",w,"csv",sep=".")

write.csv(seven, w, row.names=FALSE)



