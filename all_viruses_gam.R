library(mgcv)
library(MASS)
library(dplyr)
library(stringi)
library(parallel)
library(purrr)
source('R/model_reduction.R')
set.seed(0)

# Source the processed data
source("preprocess_data.R")

# Set up the model
data_set = hosts %>% 
  filter(hMarOTerr == "Terrestrial",
         hWildDomFAO == "wild") 

outcome_variable = "TotVirusPerHost"

model_family = poisson

## Create data.frame of all possible models
terms_grid = expand.grid(
  s1 = "s(LnAreaHost, bs='cs', k = 7)",
  s2 = "s(hMassGramsPVR, bs='cs', k = 7)",
  s3 = c(
    "s(S100, bs='cs', k = 7)",
    "s(S80, bs='cs', k = 7)",
    "s(S50, bs='cs', k = 7)",
    "s(S40, bs='cs', k = 7)",
    "s(S20, bs='cs', k = 7)",
    "s(S, bs='cs', k = 7)"
    ),
  f1 = c("RedList_status", "Population_trend", ""),
  pdo = c("hOrder", "" ),
  bias = c(
    "s(hDiseaseZACitesLn, bs='cs', k = 7)",
    "s(hAllZACitesLn, bs='cs',k = 7)"),
  stringsAsFactors = FALSE)

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

#plyr::llply(models$formula, fit_gam, .progress="time")

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
  mutate(model = mclapply(model, reduce_model))

models_reduced = models_reduced %>% 
  mutate(aic = map_dbl(model, AIC),
         daic = aic - min(aic),
         weight = exp(-daic/2),
         terms = shortform(map(model, ~ rearrange_formula(.$formula))),
         relweight = ifelse(daic > 2, 0, weight/sum(weight[daic < 2])),
         relweight_all = weight/sum(weight),
         cumweight = cumsum(relweight_all)) %>%
  arrange(aic)

models_reduced %>% filter(daic < 5) %>% select(terms, daic, relweight, relweight_all, cumweight) %>% print
plot(models_reduced$model[[1]], all.terms=TRUE, pages=1)
