library(mgcv)
library(dplyr)
library(stringi)
library(parallel)
library(purrr)
library(ggplot2)
library(viridis)
library(knitr)
library(svglite)
P <- rprojroot::find_rstudio_root_file
source(P("R/model_reduction.R"))
source(P("R/fit_gam.R"))
source(P("R/relative_contributions.R"))
source(P("R/cross_validation.R"))
source(P("R/logp.R"))
set.seed(0)

db <- readRDS(P("intermediates", "postprocessed_database.rds"))
hosts <- db$hosts
viruses <- db$viruses
associations <- db$associations
rm(db)

#---- All zoonoses ----

data_set = hosts %>%
  filter(hMarOTerr == "Terrestrial",
         hWildDomFAO == "wild",
         !is.na(PdHoSa.cbCst_order))

outcome_variable = "NSharedWithHoSa"

model_family = poisson

#  Create dummy variables for orders to use as random effects
dummys = as.data.frame(with(data_set, model.matrix(~hOrder))[,-1])
data_set = cbind(data_set, dummys)
dummy_terms = paste0("s(", names(dummys), ", bs = 're')")
names(dummy_terms) <- names(dummys)

## Create data.frame of all possible models
terms = list(
  mass = "s(hMassGramsPVR, bs = 'tp', k=7)",
  interaction = c(
    "s(HabAreaCropLn, bs = 'tp', k=7)   + s(HabAreaCropChgLn, bs = 'tp', k=7)",
    "s(HabAreaGrassLn, bs = 'tp', k=7)  + s(HabAreaGrassChgLn, bs = 'tp', k=7)",
    "s(HabAreaUrbanLn, bs = 'tp', k=7)  + s(HabAreaUrbanChgLn, bs = 'tp', k=7)",
    "s(HabInhabitedLn, bs = 'tp', k=7)  + s(HabInhabitedChgLn, bs = 'tp', k=7)",
    "s(TotHumPopLn, bs = 'tp', k=7) + s(TotHumPopChgLn, bs = 'tp', k=7) + s(UrbRurPopRatioLn, bs = 'tp', k=7) + s(UrbRurPopRatioChg, bs = 'tp', k=7)",
    "s(HumPopDensLn, bs = 'tp', k=7) + s(HumPopDensLnChg, bs = 'tp', k=7) + s(UrbRurPopRatioLn, bs = 'tp', k=7) + s(UrbRurPopRatioChg, bs = 'tp', k=7)"),
  interaction2 = "s(hHuntedIUCN, bs='re')",
  interaction3 = "s(hArtfclHbttUsrIUCN, bs='re')",
  phylo_distance = c("s(PdHoSa.cbCst, bs = 'tp', k=7)", "s(PdHoSaSTPD, bs = 'tp', k=7)"),
  bias = c("s(hDiseaseZACitesLn, bs = 'tp', k=7)"),
  offset = "offset(LnTotNumVirus)",
  stringsAsFactors=FALSE)

terms = c(dummy_terms, terms)

all_zoonoses = fit_all_gams(data_set,
                            outcome_variable,
                            poisson,
                            terms)

saveRDS(all_zoonoses, P("intermediates", "all_zoonoses_models.rds"))

#---- Strict Zoonoses ----

model_family = poisson

all_zoonoses_strict = fit_all_gams(data_set,
                                   outcome_variable = "NSharedWithHoSa_strict",
                                   poisson,
                                   terms)

saveRDS(all_zoonoses_strict, P("intermediates", "all_zoonoses_strict_models.rds"))

#---- Zoonoses GAM - All Associations without Reverse Zoonoses ----

data_set = hosts %>% #
  filter(hMarOTerr == "Terrestrial",
         hWildDomFAO == "wild",
         !is.na(PdHoSa.cbCst_order))

outcome_variable = "NSharedWithHoSa_norev"

model_family = poisson

#  Create dummy variables for orders to use as random effects
dummys = as.data.frame(with(data_set, model.matrix(~hOrder))[,-1])
data_set = cbind(data_set, dummys)
dummy_terms = paste0("s(", names(dummys), ", bs = 're')")
names(dummy_terms) <- names(dummys)

model_family = poisson


## Create data.frame of all possible models
terms = list(
  mass = "s(hMassGramsPVR, bs = 'tp', k=7)",
  interaction = c(
    "s(HabAreaCropLn, bs = 'tp', k=7)   + s(HabAreaCropChgLn, bs = 'tp', k=7)",
    "s(HabAreaGrassLn, bs = 'tp', k=7)  + s(HabAreaGrassChgLn, bs = 'tp', k=7)",
    "s(HabAreaUrbanLn, bs = 'tp', k=7)  + s(HabAreaUrbanChgLn, bs = 'tp', k=7)",
    "s(HabInhabitedLn, bs = 'tp', k=7)  + s(HabInhabitedChgLn, bs = 'tp', k=7)",
    "s(TotHumPopLn, bs = 'tp', k=7) + s(TotHumPopChgLn, bs = 'tp', k=7) + s(UrbRurPopRatioLn, bs = 'tp', k=7) + s(UrbRurPopRatioChg, bs = 'tp', k=7)",
    "s(HumPopDensLn, bs = 'tp', k=7) + s(HumPopDensLnChg, bs = 'tp', k=7) + s(UrbRurPopRatioLn, bs = 'tp', k=7) + s(UrbRurPopRatioChg, bs = 'tp', k=7)"),
  interaction2 = "s(hHuntedIUCN, bs='re')",
  interaction3 = "s(hArtfclHbttUsrIUCN, bs='re')",
  phylo_distance = c("s(PdHoSa.cbCst, bs = 'tp', k=7)", "s(PdHoSaSTPD, bs = 'tp', k=7)"),
  bias = c("s(hDiseaseZACitesLn, bs = 'tp', k=7)"),
  offset = "offset(LnTotNumVirus)",
  stringsAsFactors=FALSE)

terms = c(dummy_terms, terms)

all_zoonoses_norev = fit_all_gams(data_set,
                                  outcome_variable,
                                  poisson,
                                  terms)

saveRDS(all_zoonoses_norev, P("intermediates", "all_zoonoses_norev_models.rds"))

####---- All Viruses GAM - All Associations ----

data_set = hosts %>%
  filter(hMarOTerr == "Terrestrial",
         hWildDomFAO == "wild",
         !is.na(PdHoSa.cbCst_order))

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
  bias = c("s(hDiseaseZACitesLn, bs='cs', k=7)"),
  stringsAsFactors = FALSE)

terms = c(dummy_terms, terms)

all_viruses = fit_all_gams(data_set,
                           outcome_variable = "TotVirusPerHost",
                           poisson,
                           terms)

saveRDS(all_viruses, P("intermediates", "all_viruses_models.rds"))

####---- All Viruses GAM - Strict Associations ----

model_family = poisson

all_viruses_strict = fit_all_gams(data_set,
                                  outcome_variable = "TotVirusPerHost_strict",
                                  poisson,
                                  terms)

saveRDS(all_viruses_strict, P("intermediates", "all_viruses_strict_models.rds"))

#---- Viral Traits GAM - All Associations ----

PD_centers = names(viruses)[stri_detect_regex(names(viruses), "^(cb|st)_.*(?<!stringent)$")]

model_family = binomial


data_set = viruses %>%
  mutate_each_(funs("logp"), vars=PD_centers)
names(data_set)[names(data_set) %in% PD_centers] <- paste0(PD_centers, "Ln")
PD_centers <- paste0(PD_centers, "Ln")

dummys = as.data.frame(with(viruses, model.matrix(~vFamily))[,-1])
data_set = cbind(data_set, dummys)
dummy_terms = paste0("s(", names(dummys), ", bs = 're')")
names(dummy_terms) <- names(dummys)


terms = list(
  PD     = paste0("s(", PD_centers, ", bs='tp', k=7)"),
  bias   = c("s(vPubMedCitesLn, bs='tp', k=7)", "s(vWOKcitesLn, bs='tp', k=7)"),
  strand = c("s(RNA, bs='re')", "s(SS, bs='re')", "s(vCytoReplicTF, bs='re')"),
  vector = "s(Vector, bs='re')",
  env = "s(Envelope, bs='re')",
  genome = "s(vGenomeAveLengthLn, bs='tp', k=7)",
  stringsAsFactors=FALSE)

vtraits = fit_all_gams(data_set,
                       outcome_variable = "IsZoonotic",
                       model_family = binomial,
                       terms)

saveRDS(vtraits, P("intermediates", "vtraits_models.rds"))

#---- Viral Traits GAM - Strict Associations ----

PD_centers = names(viruses)[stri_detect_regex(names(viruses), "^(cb|st)_.*stringent$")]

data_set = viruses %>%
  mutate_each_(funs("logp"), vars=PD_centers)
names(data_set)[names(data_set) %in% PD_centers] <- paste0(PD_centers, "Ln")
PD_centers <- paste0(PD_centers, "Ln")

dummys = as.data.frame(with(viruses, model.matrix(~vFamily))[,-1])
data_set = cbind(data_set, dummys)
dummy_terms = paste0("s(", names(dummys), ", bs = 're')")
names(dummy_terms) <- names(dummys)

model_family = binomial

#data_set = data_set %>% filter(NumHosts > 1)

terms = list(
  PD     = paste0("s(", PD_centers, ", bs='tp', k=7)"),
  bias   = c("s(vPubMedCitesLn, bs='tp', k=7)", "s(vWOKcitesLn, bs='tp', k=7)"),
  strand = c("s(RNA, bs='re')", "s(SS, bs='re')", "s(vCytoReplicTF, bs='re')"),
  vector = "s(Vector, bs='re')",
  env = "s(Envelope, bs='re')",
  genome = "s(vGenomeAveLengthLn, bs='tp', k=7)",
  stringsAsFactors=FALSE)

vtraits_strict = fit_all_gams(data_set,
                              outcome_variable = "IsZoonotic.stringent",
                              binomial,
                              terms)

saveRDS(vtraits_strict, P("intermediates", "vtraits_strict_models.rds"))

#---- Zoonoses in Domestic Animals GAM - All Associations ----

data_set = hosts %>%
  filter(hMarOTerr == "Terrestrial",
         hWildDomFAO == "domestic") %>%
  mutate(hHostNameFinal = as.factor(hHostNameFinal)) %>%
  mutate(domestic_category = ifelse(is.na(domestic_category), "Other", domestic_category)) %>%
  droplevels()

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
  category = c("s(domestic_category, bs = 're')", ""),
  phylo_distance = c("s(PdHoSa.cbCst, bs = 'tp', k = 7)", ""), #, "s(PdHoSaSTPD, bs = 're')"),
  bias = c("s(hDiseaseZACitesLn, bs = 'tp', k = 7)", ""),
  offset = "offset(LnTotNumVirus)",
  stringsAsFactors=FALSE)

terms = c(dummy_terms, terms)

domestic_zoonoses = fit_all_gams(data_set,
                                 outcome_variable = "NSharedWithHoSa",
                                 poisson,
                                 terms)

saveRDS(domestic_zoonoses, P("intermediates", "domestic_zoonoses_models.rds"))

#---- Zoonoses in Domestic Animals GAM - Strict Associations ----

model_family = poisson
domestic_zoonoses_strict = fit_all_gams(data_set,
                                        outcome_variable = "NSharedWithHoSa_strict",
                                        poisson,
                                        terms)

saveRDS(domestic_zoonoses_strict, P("intermediates", "domestic_zoonoses_strict_models.rds"))

#---- All Viruses in Domestic Animals GAM - All Associations ----

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
  category = c("s(domestic_category, bs = 're')", ""),
  bias = c("s(hDiseaseZACitesLn, bs = 'tp', k = 7)", ""),
  stringsAsFactors=FALSE)

terms = c(dummy_terms, terms)

domestic_viruses = fit_all_gams(data_set,
                                outcome_variable = "TotVirusPerHost",
                                poisson,
                                terms)

saveRDS(domestic_viruses, P("intermediates", "domestic_viruses_models.rds"))

#---- All Viruses in Domestic Animals GAM - Stringent Associations ----

model_family = poisson
domestic_viruses_strict = fit_all_gams(data_set,
                                       outcome_variable = "TotVirusPerHost_strict",
                                       poisson,
                                       terms)

saveRDS(domestic_viruses_strict, P("intermediates", "domestic_viruses_strict_models.rds"))







