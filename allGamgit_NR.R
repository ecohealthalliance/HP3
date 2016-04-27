library(mgcv)
library(MASS)
library(dplyr)
library(stringi)
library(parallel)
set.seed(0)

# model_search_setup = list(
#   linear_terms =
#   random_effects =
#   smooth_terms = c('LnAreaHost', 'PrcntCrop', 'PrcntGrass', 'PrcntUrban', 'PrcentChngCrop', 'PrcntChngGrass', 'PrcntChangUrban'),
#   smooth_alternates = list(
#     phylo_distance = 
#     population = 
#     population_change = 
#     bias = c('hDiseaseZACitesLn', 'hAllZACitesLn')
#   )


load("nshared.glm.RData")

## Create data.frame of all possible models
f = expand.grid(
  s0 = c( "s(hMassGramsPVR, bs = 'ts', k=7) +"),
  s1 = c( "s(LnAreaHost, bs = 'ts', k=7) +"),
  s2 = c( "s(PrcntCrop, bs = 'ts', k=7) +"),
  s3 = c( "s(PrcntGrass, bs = 'ts', k=7) +"),
  s4 = c( "s(PrcntUrban, bs = 'ts', k=7) +"),
  s5 = c( "s(PrcntChngCrop, bs = 'ts', k=7) +"),
  s6 = c( "s(PrcntChngGrass, bs = 'ts', k=7) +"),
  s7 = c( "s(PrcntChngUrban, bs = 'ts', k=7) +"),
  pdo = c(
    "s(hOrder, bs ='re') +",
    "s(PdHoSa.cbCst, bs = 'ts', k=7) +",
    "s(PdHoSa.cbCst, bs = 'ts', k=7) +",
    "s(PdHoSaSTPD, bs = 'ts', k=7) +"),
  f1 = c( "hHuntedIUCN +", ""),
  f2 = c( "hArtfclHbttUsrIUCN +", ""),
  f3 = c( "RedList_status +", ""),
  pop1 =  "s(RurTotHumPopAEG, bs = 'ts', k=7) +",
  pop2 = "s(RurTotHumPopLn, bs = 'ts', k=7) +",
  pop3 = "s(UrbTotHumPopAEG, bs = 'ts', k=7) +",
  pop4 = "s(UrbTotHumPopLn, bs = 'ts', k=7) +",
  bias = c(
    "s(hDiseaseZACitesLn, bs = 'ts', k=7) +",
    "s(hAllZACitesLn, bs = 'ts', k=7) +"),
  intercept = "1",
  stringsAsFactors=FALSE)

f$rhs = with(f, paste( s0, s1, s2, s3, s4, s5, s6, s7,
                       pdo, f1, f2, f3, pop1, pop2, pop3, pop4, bias, intercept, sep = " ") )
e = data_frame(rhs = unique(c(f$rhs, "1" ) ) )# %>% 
  #sample_n(nrow(f) + 1)

e$lbl = sprintf("M%03d",1:nrow(e))

e$formula = with(e, paste0("NSharedWithHoSa ~ LnTotNumVirus + ", rhs))
e$formula[2]

fit_mod = function(mod_form) {
  gam(as.formula(e$formula[mod_form]), data = hp3ap, family=poisson)
}

#library(doMC)
#registerDoMC(20)
#models = plyr::alply(1:nrow(e), 1, fit_mod, .progress="time", .parallel=FALSE)

models = mclapply(1:nrow(e), fit_mod, mc.cores=20, mc.set.seed=TRUE)

modeltab = plyr::ldply(models, function(m) data_frame(aic=AIC(m), formula=as.character(m$formula)[3])) %>% 
  mutate(model = models) %>% 
  tbl_df %>% 
  arrange(aic) %>% 
  mutate(daic = aic - min(aic)) %>% 
  mutate(weight = exp(-daic/2))

rm_low_edf <- function(mod) {
  fr = as.character(formula(mod))
  lhs = fr[2]
  rhs = fr[3]
  edfs = pen.edf(mod)
  low_edfs = edfs[edfs < 0.001]
  vars_to_remove = stri_extract_first_regex(names(low_edfs), "(?<=s\\()[\\w]+(?=\\))")
  vars_regex = paste0("(", paste(vars_to_remove, collapse="|"), ")")
  new_rhs = stri_replace_all_regex(rhs, paste0("\\s*s\\(", vars_regex, "\\,[^\\)]+\\)\\s*\\+"), "")
  new_formula = paste(lhs, "~", new_rhs)
  return(new_formula)
}

rearrange_formula = function(formula) {
  lhs = stri_extract_first_regex(formula, "^[^\\s~]+")
  rhs = stri_replace_first_regex(formula, "[^~]+~\\s+", "")
  terms = stri_split_regex(rhs, "[\\s\\n]+\\+[\\s\\n]+")
  terms = lapply(terms, sort)
  new_formula = mapply(function(lhs, terms) {paste(lhs, "~", paste(terms, collapse = " + "))}, lhs, terms)
  names(new_formula) <- NULL
  return(new_formula)
}


modeltab$pruned_formula = rearrange_formula(sapply(modeltab$model, rm_low_edf))

modeltab_pruned = modeltab %>% 
  distinct(pruned_formula)

modeltab_pruned$pmodel = mclapply(modeltab_pruned$pruned_formula, function(pf) gam(as.formula(pf), data=hp3ap, family=poisson),
                                  mc.cores=20, mc.set.seed=TRUE)

modeltab_pruned = modeltab_pruned %>% 
  mutate(aic_2 = sapply(pmodel, AIC)) %>% 
  mutate(daic_2 = aic_2 - min(aic_2)) %>% 
  mutate(weight_2 = exp(-daic_2/2)) %>% 
  filter(daic < 2) %>% 
  mutate(relweight = weight / sum(weight))

shortform = function(formula) {
  rhs = stri_replace_first_regex(formula, "[^~]+~\\s+", "")
  rhs = stri_replace_all_regex(rhs, "s\\(([^\\,]+)\\,[^\\)]+\\)", "s($1)")
  stri_replace_all_fixed(rhs, "1 + ", "")
}

modeltab_pruned$shortform = shortform(modeltab_pruned$pruned_formula)

modeltab_pruned %>% select(daic_2, relweight, shortform)
#summary(topmod)
#plot(topmod, all.terms = TRUE, pages=1)




new_formulas = sapply(models, rm_low_edf)
new_formulas = rearrange_formula(new_formulas)
new_formulas = unique(sort(new_formulas))




Map(rm_low_edf, )
