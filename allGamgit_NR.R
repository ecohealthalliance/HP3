library(mgcv)
library(MASS)
library(dplyr)
library(stringi)
library(parallel)
library(purrr)
source('R/model_reduction.R')
set.seed(0)

# TODO:
# Make area, pop, and change in area and pop variables (including those in rural, urb, etc) on sensible scales
# Check co-linearity of rural/urban values and change.
# Use both order and one measure of phylogenetic distiance
# Make order a categorical variable (plot order-level effects)
# Get some nice viz going.

# Setup the model
load("nshared.glm.RData")
data_set = hp3ap
model_family = poisson
outcome_variable = "NSharedWithHoSa"

## Create data.frame of all possible models
terms_grid = expand.grid(
  s0 = "s(hMassGramsPVR, bs = 'ts', k=7)",
  s1 = "s(LnAreaHost, bs = 'ts', k=7)",
  s2 = "s(PrcntCrop, bs = 'ts', k=7)",
  s3 = "s(PrcntGrass, bs = 'ts', k=7)",
  s4 = "s(PrcntUrban, bs = 'ts', k=7)",
  s5 = "s(PrcntChngCrop, bs = 'ts', k=7)",
  s6 = "s(PrcntChngGrass, bs = 'ts', k=7)",
  s7 = "s(PrcntChngUrban, bs = 'ts', k=7)",
  pdo = c(
    "s(hOrder, bs ='re')",
    "s(PdHoSa.cbCst, bs = 'ts', k=7)",
    "s(PdHoSa.cbCst, bs = 'ts', k=7)",
    "s(PdHoSaSTPD, bs = 'ts', k=7)"),
  f1 = c( "hHuntedIUCN +", ""),
  f2 = c( "hArtfclHbttUsrIUCN", ""),
  f3 = c( "RedList_status", ""),
  pop1 =  "s(RurTotHumPopAEG, bs = 'ts', k=7)",
  pop2 = "s(RurTotHumPopLn, bs = 'ts', k=7)",
  pop3 = "s(UrbTotHumPopAEG, bs = 'ts', k=7)",
  pop4 = "s(UrbTotHumPopLn, bs = 'ts', k=7)",
  bias = c(
    "s(hDiseaseZACitesLn, bs = 'ts', k=7)",
    "s(hAllZACitesLn, bs = 'ts', k=7)"),
  vir = "LnTotNumVirus",
  stringsAsFactors=FALSE)

#Create model forumulas from the grid
formulas = apply(as.matrix(terms_grid), 1, function(row) paste(row, collapse = " + ")) %>% 
  stri_replace_all_regex("\\s[\\+\\s]+\\s", " + ") %>% 
  {paste(outcome_variable, "~", .)} %>% 
  rearrange_formula %>% 
  unique

models = data_frame(formula = formulas)

options(mc.cores = round(nrow(models) / (nrow(models) %/% detectCores() + 1)))

fit_gam = function(frm) {
  gam(formula=as.formula(frm), data=data_set, family=model_family) 
}

models = models %>% 
  mutate(model = mclapply(formula, fit_gam))


# Calculate models
models = models %>% 
  mutate(aic = map_dbl(model, AIC),
         daic = aic - min(aic),
         weight = exp(-daic/2)) %>% 
  arrange(aic)

# Remove unused terms from models and reduce to unique ones
models_reduced = models %>% 
  select(model) %>% 
  mutate(formula = map_chr(model, ~ rearrange_formula(rm_low_edf(.)))) %>% 
  distinct(formula)

# Reduce the remaining models
models_reduced = models_reduced %>% 
  mutate(model = mclapply(model, reduce_model))

models_reduced = models_reduced %>% 
  mutate(aic = map_dbl(model, AIC),
         daic = aic - min(aic),
         weight = exp(-daic/2),
         terms = shortform(map(model, ~ rearrange_formula(.$formula)))) %>%
  arrange(aic) %>% 
  filter(daic < 2) %>% 
  mutate(relweight = weight/sum(weight))

models_reduced %>% select(relweight, terms) %>% print