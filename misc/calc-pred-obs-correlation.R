### Luis et al 2013 model evaluation:
### correlating predictions with observations
### Not considered a valid method of model evaluation:
### see CJ Willmott 1981 among others
### Squaring these R values to describe "percent of
### variance explained" is not appropriate.

P <- rprojroot::find_rstudio_root_file
library(mgcv)

get_corr <- function(model_rds){
  models <- readRDS(model_rds)
  top_model <- models$model[[1]]
  predictions <- predict(top_model, top_model$model, type = "response")
  corr <- cor(top_model$y, predictions)
  return(corr)
}

get_corr(P("intermediates/all_zoonoses_models.rds"))
# 0.94
get_corr(P("intermediates/all_viruses_models.rds"))
# 0.72
get_corr(P("intermediates/all_zoonoses_strict_models.rds"))
# 0.81
get_corr(P("intermediates/all_viruses_strict_models.rds"))
# 0.67
