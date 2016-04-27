library(mgcv)
library(MASS)
library(dplyr)
library(stringi)
library(parallel)
set.seed(0)
load("nshared.glm.RData")
tbl_df(hp3ap)

## Create data.frame of all possible models
f = expand.grid(
  s0 = c( "s(hMassGramsPVR,bs='tp',k=7) +"),
  s1 = c( "s(LnAreaHost,bs='tp',k=7) +"),
  s2 = c( "s(PrcntCrop,bs='tp',k=7) +"),
  s3 = c( "s(PrcntGrass,bs='tp',k=7) +"),
  s4 = c( "s(PrcntUrban,bs='tp',k=7) +"),
  s5 = c( "s(PrcntChngCrop,bs='tp',k=7) +"),
  s6 = c( "s(PrcntChngGrass,bs='tp',k=7) +"),
  s7 = c( "s(PrcntChngUrban,bs='tp',k=7) +"),
  pdo = c(
    "s(hOrder, bs='re') +",
    "s(PdHoSa.cbCst, bs='tp',k=7) +",
    "s(PdHoSa.cbCst, bs='tp',k=7) + s(hOrder, bs='re') +",
    "s(PdHoSaSTPD,bs='tp',k=7) +",
    "PdHoSaSTPDf +"),
  f1 = c( "hHuntedIUCN +"),
  f2 = c( "hArtfclHbttUsrIUCN +"),
  f3 = c( "RedList_status +"),
  pop =  c(
    "s(TotHumPopLn, bs='tp',k=7) +",
    "s(TotHumPopAEG, bs='tp',k=7) +",
    "s(TotHumPopLn, bs='tp',k=7) + s(TotHumPopAEG, bs='tp',k=7) +",
    "s(RurTotHumPopAEG, bs='tp',k=7) +",
    "s(RurTotHumPopLn, bs='tp',k=7) +",
    "s(RurTotHumPopLn, bs='tp',k=7) + s(RurTotHumPopAEG, bs='tp',k=7) +",
    "s(UrbTotHumPopAEG, bs='tp',k=7) +",
    "s(UrbTotHumPopLn, bs='tp',k=7) +",
    "s(UrbTotHumPopLn, bs='tp',k=7) + s(UrbTotHumPopAEG, bs='tp',k=7) +"),
  bias = c(
    "s(hDiseaseZACitesLn,bs='tp',k=7) +",
    "s(hAllZACitesLn,bs='tp',k=7) +"),
  intercept = "1",
  stringsAsFactors=FALSE)

f$rhs = with(f, paste( s0, s1, s2, s3, s4, s5, s6, s7,
                       pdo, f1, f2, f3, pop, bias, intercept, sep = " ") )
e = data_frame(rhs = unique(c(f$rhs, "1" ) ) )# %>% 
  #sample_n(nrow(f) + 1)

e$lbl = sprintf("M%03d",1:nrow(e))

e$formula = with(e, paste0("NSharedWithHoSa ~ LnTotNumVirus + ", rhs))
e$formula[2]

fit_mod = function(mod_form) {
  gam(as.formula(e$formula[mod_form]), data = hp3ap, family=poisson, select=TRUE)
}

models = plyr::alply(1:nrow(e), 1, fit_mod, .progress="time")

#models = mclapply(e$formula, fit_mod, mc.cores=20, mc.set.seed=TRUE)

modeltab = plyr::ldply(models, function(m) data_frame(AIC=AIC(m), formula=as.character(m$formula)[3])) %>% 
  mutate(number = 1:length(models)) %>% 
  arrange(AIC) %>% 
  mutate(dAIC = AIC - min(AIC)) %>% 
  mutate(weight = exp(-dAIC/2)) %>% 
  filter(dAIC <= 2)

topmod = models[[which.min(sapply(models, AIC))]]

summary(topmod)
plot(topmod, all.terms = TRUE, pages=1)

