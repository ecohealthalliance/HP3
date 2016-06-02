library(readr)
library(dplyr)
library(mgcv)
library(purrr)
library(stringi)
library(parallel)
source('R/model_reduction.R')
source("preprocess_data.R")


#PD_centers = names(viruses)[stri_detect_regex(names(viruses), "vBrdth\\.(mean|median|max)PD\\..*(?<!stringent)$")]
#PD_centers = names(viruses)[stri_detect_regex(names(viruses), "vBrdth\\.(mean|median|max)PD\\..*stringent$")]
#PD_centers = names(viruses)[stri_detect_regex(names(viruses), "^(cb|st)_.*(?<!stringent)$")]
PD_centers = names(viruses)[stri_detect_regex(names(viruses), "^(cb|st)_.*stringent$")]

data_set = viruses %>% 
  mutate_each_(funs("logp"), vars=PD_centers)
names(data_set)[names(data_set) %in% PD_centers] <- paste0(PD_centers, "Ln")
PD_centers <- paste0(PD_centers, "Ln")

outcome_variable = "IsZoonotic.stringent"
model_family = binomial


dummys = as.data.frame(with(viruses, model.matrix(~vFamily))[,-1])
data_set = cbind(data_set, dummys)
dummy_terms = paste0("s(", names(dummys), ", bs = 're')")
names(dummy_terms) <- names(dummys)

#data_set = data_set %>% filter(NumHosts > 1)

terms = list(
  PD     = paste0("s(", PD_centers, ", bs='tp', k=7)"),
  bias   = c("s(vPubMedCitesLn, bs='tp', k=7)", "s(vWOKcitesLn, bs='tp', k=7)"),
  strand = c("s(RNA, bs='re')", "s(SS, bs='re')", "s(vCytoReplicTF, bs='re')"),
  vector = "s(Vector, bs='re')",
  env = "s(Envelope, bs='re')",
  genome = "s(vGenomeAveLengthLn, bs='tp', k=7)",
  stringsAsFactors=FALSE)

#terms = c(dummy_terms, terms)
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
  mutate(aic = map_dbl(model,  MuMIn::AICc),
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
  mutate(aic = map_dbl(model, MuMIn::AICc)) %>% 
  arrange(aic) %>% 
  mutate(daic = aic - min(aic),
         weight = exp(-daic/2),
         terms = shortform(map(model, ~ rearrange_formula(.$formula))),
         relweight = ifelse(daic > 2, 0, weight/sum(weight[daic < 2])),
         relweight_all = weight/sum(weight),
         cumweight = cumsum(relweight_all))

models_reduced %>% select(terms, daic, relweight, relweight_all, cumweight) %>% print(n=20)
plot(models_reduced$model[[1]], all.terms=TRUE, pages=1, scale=0)
summary(models_reduced$model[[1]])
coefs = coef(models_reduced$model[[1]])
order_coefs = coefs[stri_detect_regex(names(coefs), "hOrder")]
coefs.se = diag(vcov(models_reduced$model[[1]]))
order_coefs.se = sqrt(coefs.se[stri_detect_regex(names(coefs.se), "hOrder")])
edfs = pen.edf(models_reduced$model[[1]])
edfs = edfs[stri_detect_regex(names(edfs), "hOrder")]
data_frame(order = names(order_coefs), coef=order_coefs, se=order_coefs.se, edf=edfs)

viruses %>% select(vBrdth.maxPD.ST, st_dist_noHoSa_max, IsZoonotic) %>% 
  gather("variable", "value", -IsZoonotic) %>% 
  mutate(IsZoonotic = ifelse(IsZoonotic, "Zoonotic", "Not Zoonotic")) %>% 
  mutate(variable = ifelse(variable == "vBrdth.maxPD.ST", "With Humans", "Without Humans")) %>% 
  mutate(value = logp(value)) %>% 
  ggplot(aes(x=value, fill=IsZoonotic)) + geom_histogram(position="stack", alpha=0.5) + xlab("Log Supertree Max Host Breadth") +
  facet_wrap(~variable, ncol=1) + ggtitle("The Problem With Humans")