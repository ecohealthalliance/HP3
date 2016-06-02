fit_gam = function(frm) {
  try(gam(formula=as.formula(frm), model_family, data_set, select=TRUE), silent=TRUE)
}

fit_all_gams <- function(data_set, outcome_variable, model_family, terms) {
  terms_grid = do.call(expand.grid, terms)
  
  #Create model forumulas from the grid
  formulas = apply(as.matrix(terms_grid), 1, function(row) paste(row, collapse = " + ")) %>% 
    stri_replace_all_regex("\\s[\\+\\s]+\\s", " + ") %>% 
    {paste(outcome_variable, "~", .)} %>% 
    rearrange_formula %>% 
    unique
  
  
  
  models = data_frame(formula = formulas)
  
  n_cores = detectCores()
  n_cores_use = round(nrow(models) / ceiling(nrow(models) / (n_cores - 1)))
  options(mc.cores = n_cores_use)
  message("Using ", n_cores_use, " cores to fit ", nrow(models), " models")
  
  models_vec = mclapply(models$formula, fit_gam) 
  
  models = models %>% 
    mutate(model = models_vec)  
  
  # Calculate models
  models = models %>% 
    filter(map_lgl(model, ~ !("try-error" %in% class(.) | is.null(.)))) %>% 
    mutate(aic = map_dbl(model, MuMIn::AICc),
           daic = aic - min(aic),
           weight = exp(-daic/2)) %>% 
    arrange(aic)
  
  # Remove unused terms from models and reduce to unique ones
  models_reduced = models %>% 
    select(model) %>% 
    mutate(formula = map_chr(model, ~rearrange_formula(rm_low_edf(.)))) %>% 
    distinct(formula)
  
  n_cores_use = round(nrow(models_reduced) / ceiling(nrow(models_reduced) / (n_cores - 1)))
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
  
  return(models_reduced)
  
}