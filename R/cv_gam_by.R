filter_down<-function(model, data, region){
  variable_names <- stri_replace_first_regex(names(model$model), "offset\\(([^\\)]+)\\)", "$1")
  variable_names <- c(variable_names, "hHostNameFinal", region)
  reduced <- data %>%
    select_if(colnames(.) %in% variable_names)
  reduced <- reduced[complete.cases(reduced),]
  reduced
}

cv_gam_by_zg<-function(model, hp3_hosts, region_vector){
  df <- data.frame()
  for(i in 1:length(region_vector)){
    temp <- cv_gam_each_zg(model, hp3_hosts, region_vector[i])
    df <- rbind(df, temp)
  }
  df
}

cv_gam_each_zg<- function(model, data, region){
  data <- filter_down(model,data, "mam_upgma_")
  response_var <- names(model$model)[attributes(terms(model))$response]
  regional <- filter(data, mam_upgma_ == region)
  world <- filter(data, mam_upgma_ != region)
  zero_terms = names(world)[map_lgl(world, ~length(unique(.x)) == 1)]
  new_formula = rm_terms(model, zero_terms)
  new_model = gam(formula=as.formula(new_formula), data = world, family=model$family, select = TRUE)
  preds = as.vector(predict(new_model, newdata = regional, type="response"))
  actuals = regional[, response_var]
  diffs = actuals - preds
  directional = mean(diffs)
  mean_diff = abs(mean(diffs))
  rand_diff = abs(replicate(100000, mean(sample(c(-1,1), length(preds), replace=TRUE)*diffs)))
  perm_p = sum(rand_diff > mean_diff)/100000
  perm_p_adj = stats::p.adjust(perm_p, method="none")
  return(data_frame(fold=region,
                    n_fit = nrow(world),
                    n_validate = length(preds),
                    p_value=perm_p_adj,
                    mean_diff=directional))
}



