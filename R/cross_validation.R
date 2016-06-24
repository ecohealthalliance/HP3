cv_gam <- function(mod, k=7) {
  dat = mod$model
  dat$fold = base::sample(rep(1:k, length.out=nrow(dat)), nrow(dat))

  terms <- attributes(mod$terms)
  offset_name = stri_replace_first_regex(names(dat)[terms$offset], "offset\\(([^\\)]+)\\)", "$1")

  formula_chr <- as.character(formula(mod))
  rhs <- formula_chr[3]
  lhs <- formula_chr[2]

  null_formula = paste(lhs, "~ 1")
  if(length(offset_name) ==1 ) null_formula = paste0(null_formula, " + offset(", offset_name, ")")
  null_model = gam(formula = as.formula(null_formula),
                   data=setNames(dat,stri_replace_all_regex(names(dat), "offset\\(([^\\)]+)\\)", "$1")),
                   family=mod$family)




  cv_out=map_df(1:k , function(x) {
    dat2 = dat[dat$fold != x, ]
    names(dat2) <- stri_replace_all_regex(names(dat2), "offset\\(([^\\)]+)\\)", "$1")
    zero_terms = names(dat2)[map_lgl(dat2, ~length(unique(.x)) == 1)]
    new_formula = rm_terms(mod, zero_terms)
    new_mod = update(mod, formula=as.formula(new_formula), data = dat2, family=mod$family)
    preds = as.vector(predict(new_mod, newdata = dat[dat$fold == x, ], type="response"))
    null_preds = as.vector(predict(null_model, newdata = dat[dat$fold == x, ], type="response"))
    actuals = dat[dat$fold == x, names(dat)[attributes(terms(mod))$response]]

    res <- mod$family$dev.resids(actuals, preds, 1)
    null_res = mod$family$dev.resids(actuals, null_preds, 1)
    s <- attr(res, "sign")
    if (is.null(s))
      s <- sign(actuals - preds)
      res <- sqrt(pmax(res, 0, na.rm=TRUE)) * s
    deviance <- sum(res^2)
    s2 <- attr(null_res, "sign")
    if (is.null(s2))
      s <- sign(actuals - null_preds)
    res <- sqrt(pmax(null_res, 0, na.rm=TRUE)) * s
    null_deviance <- sum(null_res^2)


    df = length(actuals) - sum(new_mod$edf)
    summ = summary(new_mod)
    p = pchisq(deviance, df, lower.tail=FALSE)
    return(data_frame(fold=as.character(x),
                      #residual_deviance=null_deviance-deviance,
                      n = summ$n,
                      deviance_explained = summ$dev.expl
                      #degrees_of_freedom=df,
                      #p_value=p)
                      ))
    #return(data_frame(fold=as.character(x), deviance_explained = (null_deviance - deviance)/null_deviance))
  })
  rbind(cv_out,
        data_frame(fold="mean",
                   #residual_deviance = mean(cv_out$residual_deviance),
                   n = NA,
                   deviance_explained = mean(cv_out$deviance_explained)
                   #degrees_of_freedom = max(cv_out$degrees_of_freedom),
                   #p_value=pchisq(residual_deviance, degrees_of_freedom, lower.tail=FALSE)
                   ),
        data_frame(fold = "original", n = summary(mod)$n,
                     deviance_explained = summary(mod)$dev.expl)
  )
}
