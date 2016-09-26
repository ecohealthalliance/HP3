cv_gam_by<-function(model, hp3_hosts, region_vector){
  df <- data.frame()
  for(i in 1:length(region_vector)){
    temp <- cv_gam_each(model, hp3_hosts, region_vector[i])
    df <- rbind(df, temp)
  }
  df
}

cv_gam_each<-function(model, hp3_hosts, Continent){
  response_var <- names(model$model)[attributes(terms(model))$response]
  dat <- left_join(hp3_hosts, model$model) %>%
    filter(!(BINOMIAL == "Cervus_timorensis")) #this is the one animal left un-filtered that we do not have spatial data for
  dat$fold = eval(parse(text = paste0("dat$",Continent)))
  terms <- attributes(model$terms)
  offset_name = stri_replace_first_regex(names(dat)[terms$offset], "offset\\(([^\\)]+)\\)", "$1")
  formula_chr <- as.character(formula(model))
  dat2 = dat[dat$fold != 1, ]
  names(dat2) <- stri_replace_all_regex(names(dat2), "offset\\(([^\\)]+)\\)", "$1")
  zero_terms = names(dat2)[map_lgl(dat2, ~length(unique(.x)) == 1)]
  new_formula = rm_terms(model, zero_terms)
  new_model = gam(formula=as.formula(new_formula), data = dat2, family=model$family)
  preds = as.vector(predict(new_model, newdata = dat[dat$fold == 1, ], type="response"))
  actuals = dat[dat$fold == 1, response_var]
  diffs = actuals - preds
  mean_diff = abs(mean(diffs))
  rand_diff = abs(replicate(100000, mean(sample(c(-1,1), length(preds), replace=TRUE)*diffs)))
  perm_p = sum(rand_diff > mean_diff)/100000
  perm_p_adj = stats::p.adjust(perm_p, method="none")
  return(data_frame(fold=as.character(Continent),
                      n_fit = nrow(dat) - length(preds),
                      n_validate = length(preds),
                      p_value=perm_p_adj))
  }


