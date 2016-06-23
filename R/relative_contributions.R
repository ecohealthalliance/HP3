
get_relative_contribs <- function(gam_model) {

  terms <- attributes(gam_model$terms)
  offset <- attributes(gam_model$terms)$offset

  formula_chr <- as.character(formula(gam_model))
  model_data <- gam_model$model
  offset_name = stri_replace_first_regex(names(model_data)[terms$offset], "offset\\(([^\\)]+)\\)", "$1")
  names(model_data) <- stri_replace_all_regex(names(model_data), "offset\\(([^\\)]+)\\)", "$1")
  gam_model = gam(formula(gam_model), data=model_data, family=gam_model$family, select=FALSE)

  y = model_data[,terms$response]
   preds = predict(gam_model, type="iterms")
  intercept = attributes(preds)$constant
  smooth_pars  <- gam_model$sp
  rhs <- formula_chr[3]
  lhs <- formula_chr[2]
  devs <- map_dbl(terms$term.labels, function(term) {
    # sub_preds <- rowSums(preds[, !stri_detect_fixed(colnames(preds), term), drop=FALSE]) + intercept
    # if(length(offset_name) ==1 ) sub_preds = sub_preds + model_data[, offset]
    # sub_preds <- gam_model$family$linkinv(sub_preds)
    # res <- gam_model$family$dev.resids(y, sub_preds, 1)
    # s <- attr(res, "sign")
    # if (is.null(s))
    #   s <- sign(y - sub_preds)
    # res <- sqrt(pmax(res, 0, na.rm=TRUE)) * s
    # dev <- sum(res^2)
    term = c(terms$term.labels[terms$term.labels != term], offset_name)
    term_regex= paste0("(", paste(term, collapse="|"), ")")
    new_formula <- stri_extract_all_regex(rhs, paste0("(s|offset)\\(", term_regex, "[^\\)]*\\)"))[[1]] %>%
      paste(collapse = " + ") %>%
      {paste(lhs, "~", .)} %>%
      as.formula()
    smooth_par <- smooth_pars[stri_detect_regex(names(smooth_pars), term_regex)]
    smooth_par <- smooth_par[!stri_detect_regex(names(smooth_par), "\\)[23456789]+$")]
    new_model <- gam(formula = new_formula, sp=smooth_par, data=model_data, family=gam_model$family, select=FALSE)
    dev = deviance(new_model)
    return(dev)
  })
  null_formula = paste(lhs, "~ 1")
  if(length(offset_name) ==1 ) null_formula = paste0(null_formula, "+ offset(", offset_name, ")")
  null_model = gam(formula = as.formula(null_formula), data=model_data, family=gam_model$family, select=FALSE)
  null_model_dev = deviance(null_model)
  orig_dev<- deviance(gam_model)
  dev_expl = (devs - orig_dev)
  dev_expl = dev_expl/sum(dev_expl)
  data_frame(term = terms$term.labels, rel_deviance_explained = dev_expl)

}

