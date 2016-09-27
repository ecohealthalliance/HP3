cv_gam_by<-function(model, hp3_hosts, region_vector){
  df <- data.frame()
  for(i in 1:length(region_vector)){
    temp <- cale_whale(model, hp3_hosts, region_vector[i])
    df <- rbind(df, temp)
  }
  df
}

#given model and data, removes any non complete cases (using model terms)
filter_down<-function(model, data){}



cale_whale<- function(model, data, region){
  response_var <- names(model$model)[attributes(terms(model))$response]
  data$region_present = eval(parse(text = paste0("data$",region)))
  regional <- filter(data, region_present == 1)
  world <- filter(data, region_present == 0)
  zero_terms = names(world)[map_lgl(world, ~length(unique(.x)) == 1)]
  new_formula = rm_terms(model, zero_terms)
  new_model = gam(formula=as.formula(new_formula), data = world, family=model$family, select = TRUE)
  preds = as.vector(predict(new_model, newdata = regional, type="response"))
  actuals = regional[, response_var]
  diffs = actuals - preds
  mean_diff = abs(mean(diffs))
  rand_diff = abs(replicate(100000, mean(sample(c(-1,1), length(preds), replace=TRUE)*diffs)))
  perm_p = sum(rand_diff > mean_diff)/100000
  perm_p_adj = stats::p.adjust(perm_p, method="none")
  return(data_frame(fold=as.character(region),
                    n_fit = nrow(world),
                    n_validate = length(preds),
                    p_value=perm_p_adj))


}

regions <- c("africa", "americas", "australia", "eurussia", "asia")


cv_gam_by(allz_gam, spatial_join, regions) %>%
  mutate(p_value = round(p_value, digits =3)) %>%
  rename(`Region Removed` = fold, `Observations Fit` = n_fit, `Observations Held Out` = n_validate,
         `P-value` = p_value) %>%
  kable()
