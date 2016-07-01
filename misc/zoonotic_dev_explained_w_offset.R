P <- rprojroot::find_rstudio_root_file
library(mgcv)

# Calculate the deviance explained when including the offset of the zoonotic model
# Normally null deviance is calculated using the offset, so here we do it manually

zoo_model <- readRDS(P("model_fitting/all_zoonoses_model.rds"))
null_model <- gam(formula = NSharedWithHoSa ~ 1, data=zoo_model$model, family=poisson)
(null_model$deviance -  zoo_model$deviance) / null_model$deviance

#result (2016-06-28): 0.8198646
