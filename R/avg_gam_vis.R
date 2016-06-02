#' @import purrr
avg_gam_vis <- function(gams, daic_cutoff = 2, sims = 1000) {
  aic = map_dbl(gams, AIC)
  gams = gams[(aic - min(aic)) < 2]
  aic = aic[(aic - min(aic)) < 2]
  weights = exp(min(aic) - aic)
  weights = weights/sum(weights)
  coefs = map2_df(gams, weights, function(one_gam, weight) {
    range_data = as.data.frame(
      map(one_gam$model[,-attr(terms(one_gam$model), "response")],
          function(var) {
            if(is.factor(var)) {
              outvar = factor(levels(var), levels = levels(var))
              outvar = rep(outvar, ceiling(100/length(outvar)))[1:100]
            } else if (is.numeric(var)) {
              outvar = seq(from = min(var), to = max(var), length.out = 100)
            }
          }))
    names(range_data) = stri_replace_first_regex(names(range_data),
                                                 "(?:offset(?:\\(|\\.))?(\\w+)(?:\\.$|\\)$)", "$1")
    coef_samps = rmvn(n = round(sims*weight), mu=coef(one_gam),
                      V = vcov(one_gam))
    #   predict_mat = predict(one_gam, type="lpmatrix")
    predict_mat_range = predict(one_gam, newdata = range_data, type="lpmatrix")
    terms = stri_replace_all_regex(colnames(predict_mat_range), "([^\\.]+)\\.\\d+", "$1")
    term_nums = as.numeric(factor(terms, levels = unique(terms)))
    factor_nums = which(map_lgl(range_data, is.factor))
    term_names = unique(terms)
    term_predictions = map(unique(term_nums), function(i) {
      p = unname(tcrossprod(predict_mat_range[, term_nums == i],
                            coef_samps[, term_nums == i]))
      p = plyr::alply(p, 1, identity)
      #xvar = range_data[names(range_data) == stri_replace_first_regex(term_names[i], "(?:s\\()?([^\\)]+)\\)?", "$1") |
      #                    map_lgl(names(range_data), ~ stri_detect_fixed(term_names[i], .))]
      #if(ncol(xvar) == 0) xvar = 1 else xvar = xvar[[1]]
      #p$xvar = xvar
      #num_cols = na.omit(stri_match_first_regex(names(p), "\\d+")[,1])
      # p = tidyr::gather_(p, "sample", "prediction", gather_cols=num_cols)
      #  p$varname = term_names[i]
    })
   names(term_predictions) <- term_names
   term_predictions = as_data_frame(term_predictions)
  }, .id="model")
 
  
  pad_zeros = function(x, n=sims) {
    c(x, rep(0, max(0, n - length(x))))
  } 
  coef2 = coefs %>%
    group_by(model) %>% 
    mutate(x_id = 1:n()) %>% 
    group_by(x_id) %>% 
    summarize_each(funs(list(do.call(c, .))), -model) %>% 
    mutate_each(funs(map(., pad_zeros)), -x_id)
  

  coef2 %>% 
    mutate_each
  
  tidyr::gather(coef2, "var", "val", -x_id)
  library(noamtools)
  library(ggplot2)
  ggplot(filter(coefs2, varname == "s(PdHoSa.cbCst)"),
         aes(x=xvar, y=prediction, group=paste0(model,sample))) +
    geom_line(col="slateblue", alpha=0.02) +
    theme_nr
  
  
}

