library(mgcv)
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
         hWildDomFAO == "wild",
         !is.na(PdHoSa.cbCst_order))

outcome_variable = "TotVirusPerHost"

model_family = poisson

#  Create dummy variables for orders to use as random effects
dummys = as.data.frame(with(data_set, model.matrix(~hOrder))[,-1])
#dummys = dummys[, colSums(dummys) > 1]
data_set = cbind(data_set, dummys)
dummy_terms = paste0("s(", names(dummys), ", bs = 're')")
names(dummy_terms) <- names(dummys)

## Create data.frame of all possible models
terms = list(
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
   bias = c("s(hAllZACitesLn, bs='cs',k = 7)", "s(hDiseaseZACitesLn, bs='cs', k=7)"),
  stringsAsFactors = FALSE)

terms = c(dummy_terms, terms)

terms_grid = do.call(expand.grid, terms)

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
  gam(formula=as.formula(frm), model_family, data_set, select=TRUE) 
}
#lapply(models$formula, fit_gam)

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
  mutate(aic = map_dbl(model, AIC)) %>% 
  arrange(aic) %>% 
  mutate(daic = aic - min(aic),
         weight = exp(-daic/2),
         terms = shortform(map(model, ~ rearrange_formula(.$formula))),
         relweight = ifelse(daic > 2, 0, weight/sum(weight[daic < 2])),
         relweight_all = weight/sum(weight),
         cumweight = cumsum(relweight_all))

models_reduced %>% select(daic, relweight, relweight_all, cumweight) %>% print(n=20)
plot(models_reduced$model[[1]], all.terms=TRUE, pages=1, scale=-1)
summary(models_reduced$model[[1]])
coefs = coef(models_reduced$model[[1]])
order_coefs = coefs[stri_detect_regex(names(coefs), "hOrder")]
coefs.se = diag(vcov(models_reduced$model[[1]]))
order_coefs.se = sqrt(coefs.se[stri_detect_regex(names(coefs.se), "hOrder")])
edfs = pen.edf(models_reduced$model[[1]])
edfs = edfs[stri_detect_regex(names(edfs), "hOrder")]
data_frame(order = names(order_coefs), coef=order_coefs, se=order_coefs.se, edf=edfs)
