cv_gam <- function(mod, k) {
  dat = mod$model
  dat$fold = base::sample(rep(1:k, length.out=nrow(dat)), nrow(dat))
  
  terms <- attributes(mod$terms)
  offset_name = stri_replace_first_regex(names(dat)[terms$offset], "offset\\(([^\\)]+)\\)", "$1")
  
  formula_chr <- as.character(formula(mod))
  rhs <- formula_chr[3]
  lhs <- formula_chr[2]
  
  null_formula = paste(lhs, "~ 1")
  if(length(offset_name) ==1 ) null_formula = paste0(null_formula, " + offset(", offset_name, ")")
  null_model = gam(formula = as.formula(null_formula), 
                   data=setNames(dat,stri_replace_all_regex(names(dat), "offset\\(([^\\)]+)\\)", "$1")),
                   family=mod$family)
  
  
  
 
  cv_out=map_df(1:k , function(x) {
    dat2 = dat[dat$fold != x, ]
    names(dat2) <- stri_replace_all_regex(names(dat2), "offset\\(([^\\)]+)\\)", "$1")
    zero_terms = names(dat2)[map_lgl(dat2, ~length(unique(.x)) == 1)]
    new_formula = rm_terms(mod, zero_terms)
    new_mod = update(mod, formula=as.formula(new_formula), data = dat2, family=mod$family)
    preds = as.vector(predict(new_mod, newdata = dat[dat$fold == x, ], type="response"))
    null_preds = as.vector(predict(null_model, newdata = dat[dat$fold == x, ], type="response"))
    actuals = dat[dat$fold == x, names(dat)[attributes(terms(mod))$response]]
    
    res <- mod$family$dev.resids(actuals, preds, 1)
    null_res = mod$family$dev.resids(actuals, null_preds, 1)
    s <- attr(res, "sign")
    if (is.null(s))
      s <- sign(actuals - preds)
      res <- sqrt(pmax(res, 0, na.rm=TRUE)) * s
    deviance <- sum(res^2)
    s2 <- attr(null_res, "sign")
    if (is.null(s2))
      s <- sign(actuals - null_preds)
    res <- sqrt(pmax(null_res, 0, na.rm=TRUE)) * s
    null_deviance <- sum(null_res^2)
    
    
    df = length(actuals) - sum(new_mod$edf)
    p = pchisq(deviance, df, lower.tail=FALSE)
    return(data_frame(fold=as.character(x), residual_deviance=null_deviance-deviance, degrees_of_freedom=df, p_value=p))
    #return(data_frame(fold=as.character(x), deviance_explained = (null_deviance - deviance)/null_deviance))
  })
  rbind(cv_out, 
        data_frame(fold="mean",
                   residual_deviance = mean(cv_out$residual_deviance),
                   degrees_of_freedom = max(cv_out$degrees_of_freedom),
                   p_value=pchisq(residual_deviance, degrees_of_freedom, lower.tail=FALSE)))
  return(cv_out)
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



