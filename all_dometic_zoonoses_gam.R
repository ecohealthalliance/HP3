library(mgcv)
library(dplyr)
library(tidyr)
library(stringi)
library(parallel)
library(readxl)
library(purrr)
source('R/model_reduction.R')
set.seed(0)

# Source the processed data
source("preprocess_data.R")

# Set up the model

domestics = read_excel('data/HP3_domestic-categories.xlsx') %>% 
  select(hHostNameFinal, domestic_category)
data_set = hosts %>% 
  filter(hMarOTerr == "Terrestrial",
         hWildDomFAO == "domestic")
data_set = left_join(data_set, domestics, by = "hHostNameFinal") %>% 
  mutate(hHostNameFinal = as.factor(hHostNameFinal)) %>% 
  mutate(domestic_category = ifelse(is.na(domestic_category), "Other", domestic_category)) %>% 
  droplevels()

outcome_variable = "NSharedWithHoSa"



model_family = poisson

#  Create dummy variables for orders to use as random effects
dummys = as.data.frame(with(data_set, model.matrix(~hOrder))[,-1])
dummys2 = as.data.frame(with(data_set, model.matrix(~domestic_category))[,-1])
data_set = cbind(data_set, dummys, dummys2)
dummy_terms = as.list(paste0("s(", c(names(dummys), names(dummys2)), ", bs = 're')")) %>% 
  map(~ c(., ""))
names(dummy_terms) <- c(names(dummys), names(dummys2))

## Create data.frame of all possible models
terms = list(
  mass = c("s(hMassGramsPVR, bs = 'tp', k = 7)", ""),
  domestication = c("s(LnDOMYearBP, bs = 'tp', k = 7)",""),
  cont = c("s(hContinents, bs = 'tp', k = 7)", ""),
  #cont = c("s(domestic_category, bs = 're')", ""),
  phylo_distance = c("s(PdHoSa.cbCst, bs = 'tp', k = 7)", ""), #, "s(PdHoSaSTPD, bs = 're')"),
  bias = c("s(hAllZACitesLn, bs = 'tp', k = 7)", "s(hDiseaseZACitesLn, bs = 'tp', k = 7)", ""),
  offset = "offset(LnTotNumVirus)",
  stringsAsFactors=FALSE)

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
n_cores_use = max(round(nrow(models) / (nrow(models) %/% n_cores + 1)), 1)
options(mc.cores = n_cores_use)
message("Using ", n_cores_use, " cores to fit ", nrow(models), " models")


fit_gam = function(frm) {
  try(gam(formula=as.formula(frm), model_family, data_set, select=TRUE))
}
#lapply(models$formula, fit_gam)

models_vec = mclapply(models$formula, fit_gam) 

models = models %>% 
  mutate(model = models_vec)

# models_try %>%
#   filter(map_lgl(model, ~ ("try-error" %in% class(.)))) %>%
#   use_series(model) %>%
#   sapply(identity) %>%
#   table

# Calculate models
#models_try = models
models = data_frame(model=models_vec) %>%  
  filter(map_lgl(model, ~ !("try-error" %in% class(.) | is.null(.)))) %>% 
  mutate(aic = map_dbl(model,  MuMIn::AICc),
         daic = aic - min(aic),
         weight = exp(-daic/2)) %>% 
  arrange(aic)

# Remove unused terms from models and reduce to unique ones
models_reduced = models %>% 
  select(model) %>% 
  mutate(formula = map_chr(model, ~ rearrange_formula(rm_low_edf(.)))) %>% 
  distinct(formula)

n_cores_use = max(round(nrow(models_reduced) / (nrow(models_reduced) %/% n_cores + 1)), 1)
options(mc.cores = n_cores_use)
message("Using ", n_cores_use, " cores to fit ", nrow(models_reduced), " reduced models")

# Reduce the remaining models
models_reduced = models_reduced %>% 
  mutate(model = mclapply(model, reduce_model))

models_reduced = models_reduced %>% 
  mutate(form = map_chr(model, ~ rearrange_formula(formula(.)))) %>% 
  distinct(form) %>% 
  mutate(aic = map_dbl(model,  MuMIn::AICc)) %>% 
  arrange(aic) %>% 
  mutate(daic = aic - min(aic),
         weight = exp(-daic/2),
         terms = shortform(map(model, ~ rearrange_formula(.$formula))),
         relweight = ifelse(daic > 2, 0, weight/sum(weight[daic < 2])),
         relweight_all = weight/sum(weight),
         cumweight = cumsum(relweight_all))

models_reduced %>% select(terms, daic, relweight) %>% print(n=15)
plot(models_reduced$model[[1]], all.terms=TRUE, pages=1, scale=0, residuals = TRUE)
summary(models_reduced$model[[1]])
coefs = coef(models_reduced$model[[1]])
order_coefs = coefs[stri_detect_regex(names(coefs), "(hOrder|domestic)")]
coefs.se = diag(vcov(models_reduced$model[[1]]))
edfs = pen.edf(models_reduced$model[[1]])
order_coefs.se = sqrt(coefs.se[stri_detect_regex(names(coefs.se), "(hOrder|domestic)")])
#order_edfs.se = edfs[stri_detect_regex(names(edfs), "(hOrder|domestic)")]
data_frame(order = names(order_coefs), coef=order_coefs, se=order_coefs.se)


#----

# Cross validation

# topmod = models_reduced$model[[1]]
# newdat =topmod$model %>% 
#   rename(LnTotNumVirus=`offset(LnTotNumVirus)`)
# newdat_names <- names(newdat)
# attributes(newdat) <- NULL
# names(newdat) <- newdat_names
# newdat <- as.data.frame(newdat)
# 
# n_folds = 7
# newdat = newdat %>% 
#   mutate(fold = sample(rep_len(1:n_folds, length.out = n()))) %>% 
#   group_by(fold) %>% 
#   tidyr::nest(.key = "fold_data") %>% 
#   mutate(new_mod = map(fold_data, ~refit(topmod, .)))
# 
# 
# refit <- function(model, data) {
#   blank_cols = map_lgl(data, ~ all(. ==0))
#   orig_names = names(data)
#   if(length(blank_cols) > 0) {
#     data <- data[!blank_cols]
#     form = as.character(topmod$formula)
#     vars_regex = paste0("(", paste(orig_names[blank_cols], collapse="|"), ")")
#     new_rhs = stri_replace_all_regex(form[3], paste0("\\s*s\\(", vars_regex, "\\,[^\\)]+\\)\\s*\\+?"), "")
#     new_rhs= stri_replace_all_fixed(new_rhs, "+, k = 7) ", "")
#     form = as.formula(paste(form[2], form[1], new_rhs))
#     newmod = update(model, formula=as.formula(form), data=data)
#   } else {
#     newmod = update(model, data=data)
#   }
#   return(newmod)
# }
#   
# }
# update(topmod, data = newdat$fold_data[[1]])
# twelve = NULL
