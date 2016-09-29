cv_gam <- function(mod, k=10, B=100000) {
  dat = mod$model
  dat$fold = base::sample(rep(1:k, length.out=nrow(dat)), nrow(dat))

  terms <- attributes(mod$terms)
  offset_name = stri_replace_first_regex(names(dat)[terms$offset], "offset\\(([^\\)]+)\\)", "$1")

  formula_chr <- as.character(formula(mod))
  rhs <- formula_chr[3]
  lhs <- formula_chr[2]

 # null_formula = paste(lhs, "~ 1")
#  if(length(offset_name) ==1 ) null_formula = paste0(null_formula, " + offset(", offset_name, ")")
  # null_model = gam(formula = as.formula(null_formula),
  #                  data=setNames(dat,stri_replace_all_regex(names(dat), "offset\\(([^\\)]+)\\)", "$1")),
  #                  family=mod$family)




  cv_out=map_df(1:k , function(x) {
    dat2 = dat[dat$fold != x, ]
    names(dat2) <- stri_replace_all_regex(names(dat2), "offset\\(([^\\)]+)\\)", "$1")
    zero_terms = names(dat2)[map_lgl(dat2, ~length(unique(.x)) == 1)]
    new_formula = rm_terms(mod, zero_terms)
    new_mod = gam(formula=as.formula(new_formula), data = dat2, family=mod$family)
  #  null_mod = gam(formula = as.formula(null_formula), data = dat2, family = mod$family)
    preds = as.vector(predict(new_mod, newdata = dat[dat$fold == x, ], type="response"))
   # null_preds = as.vector(predict(null_mod, newdata = dat[dat$fold == x, ], type="response"))
    actuals = dat[dat$fold == x, names(dat)[attributes(terms(mod))$response]]

    diffs = actuals - preds
    error_term = mean(diffs)
    mean_diff = abs(mean(diffs))
    rand_diff = abs(replicate(B, mean(sample(c(-1,1), length(preds), replace=TRUE)*diffs)))
    perm_p = sum(rand_diff > mean_diff)/B

  #  deviance <- sum(mod$family$dev.resids(actuals, preds, 1))
  #  null_deviance <- sum(mod$family$dev.resids(actuals, null_preds, 1))
  #  deviance_explained = (null_deviance-deviance)/null_deviance


    return(data_frame(fold=as.character(x),
                      n_fit = nrow(dat) - length(preds),
                      n_validate = length(preds),
                      p_value=perm_p,
                      mean_error=error_term))
  })
  cv_out$p_value = stats::p.adjust(cv_out$p_value, method="none")
  return(cv_out)
}
