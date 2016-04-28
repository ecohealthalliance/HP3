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

# Source the processed data
source("preprocess_allgam.R")

# Set up the model
data_set = hosts %>% 
  filter(hMarOTerr == "Terrestrial",
         hWildDomFAO == "wild")

outcome_variable = "NSharedWithHoSa"

model_family = poisson

## Create data.frame of all possible models
terms_grid = expand.grid(
  s0 = "s(hMassGramsPVR, bs = 'ts', k=7)",
  s1 = "s(LnAreaHost, bs = 'ts', k=7)",
  s2 = "s(HabAreaCropLn, bs = 'ts', k=7)",
  s3 = "s(HabAreaGrassLn, bs = 'ts', k=7)",
  s4 = "s(HabAreaUrbanLn, bs = 'ts', k=7)",
  s5 = "s(HabAreaCropChgLn, bs = 'ts', k=7)",
  s6 = "s(HabAreaGrassChgLn, bs = 'ts', k=7)",
  s7 = "s(HabAreaUrbanChgLn, bs = 'ts', k=7)",
  order = c("hOrder", ""), 
  pdo = c(
    "s(PdHoSa.cbCst, bs = 'ts', k=7)",
    "s(PdHoSaSTPD, bs = 'ts', k=7)"),
  f1 = c( "hHuntedIUCN +", ""),
  f2 = c( "hArtfclHbttUsrIUCN", ""),
 # f3 = c( "RedList_status", ""),
  pop1 =  "s(RurTotHumPopChgLn, bs = 'ts', k=7)",
  pop2 = "s(RurTotHumPopLn, bs = 'ts', k=7)",
  pop3 = "s(UrbTotHumPopChgLn, bs = 'ts', k=7)",
  pop4 = "s(UrbTotHumPopLn, bs = 'ts', k=7)",
  bias = c(
    "s(hDiseaseZACitesLn, bs = 'ts', k=7)",
    "s(hAllZACitesLn, bs = 'ts', k=7)" ),
  vir = "LnTotNumVirus",
  stringsAsFactors=FALSE)

#Create model forumulas from the grid
formulas = apply(as.matrix(terms_grid), 1, function(row) paste(row, collapse = " + ")) %>% 
  stri_replace_all_regex("\\s[\\+\\s]+\\s", " + ") %>% 
  {paste(outcome_variable, "~", .)} %>% 
  rearrange_formula %>% 
  unique

models = data_frame(formula = formulas)

n_cores = detectCores()
n_cores_use = round(nrow(models) / (nrow(models) %/% n_cores + 1))
options(mc.cores = n_cores_use)
message("Using ", n_cores_use, " cores to fit ", nrow(models), " models")


fit_gam = function(frm) {
  gam(formula=as.formula(frm), model_family, data_set) 
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



n_cores_use = round(nrow(models_reduced) / (nrow(models) %/% n_cores + 1))
options(mc.cores = n_cores_use)
message("Using ", n_cores_use, " cores to fit ", nrow(models_reduced), " reduced models")

# Reduce the remaining models
models_reduced = models_reduced %>% 
  mutate(model = mclapply(model, function(x) reduce_model(x)))

models_reduced = models_reduced %>% 
  mutate(aic = map_dbl(model, AIC),
         daic = aic - min(aic),
         weight = exp(-daic/2),
         terms = shortform(map(model, ~ rearrange_formula(.$formula)))) %>%
  arrange(aic) %>% 
  filter(daic < 2) %>% 
  mutate(relweight = weight/sum(weight))

models_reduced %>% select(terms) %>% print

hosts %>% filter(hHostNameFinal=="Puma_concolor") %>% as.data.frame
