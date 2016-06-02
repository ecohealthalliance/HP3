
# Returns a model formula from a GAM with the low_edf terms removed
rm_low_edf <- function(mod, edf_cutoff = 0.001) {
  fr = as.character(formula(mod))
  lhs = fr[2]
  rhs = fr[3]
  edfs = pen.edf(mod)
  low_edfs = edfs[edfs < edf_cutoff]
  vars_to_remove = stri_replace_all_fixed(unique(stri_extract_first_regex(names(low_edfs), "(?<=s\\()[^\\)]+(?=\\))")), ",",", ")
  vars_regex = paste0("(", paste(vars_to_remove, collapse="|"), ")")
  new_rhs = stri_replace_all_regex(rhs, paste0("\\s*s\\(", vars_regex, "\\,[^\\)]+\\)\\s*\\+?"), "")
  new_rhs= stri_replace_all_fixed(new_rhs, "+, k = 7) ", "")
  new_rhs= stri_replace_all_fixed(new_rhs, "+ +s", "+ s")
  new_formula = paste(lhs, "~", new_rhs)
  new_formula = stri_replace_all_regex(new_formula, "[\\s\\n]+", " ")
  new_formula = stri_replace_all_regex(new_formula, "[+\\s]*$", "")
  return(new_formula)
}

rm_terms <- function(mod, terms) {
  fr = as.character(formula(mod))
  lhs = fr[2]
  rhs = fr[3]
  vars_regex = paste0("(", paste(terms, collapse="|"), ")")
  new_rhs = stri_replace_all_regex(rhs, paste0("\\s*s\\(", vars_regex, "\\,[^\\)]+\\)\\s*\\+?"), "")
  new_rhs= stri_replace_all_fixed(new_rhs, "+, k = 7) ", "")
  new_rhs= stri_replace_all_fixed(new_rhs, "+ +s", "+ s")
  new_formula = paste(lhs, "~", new_rhs)
  new_formula = stri_replace_all_regex(new_formula, "[\\s\\n]+", " ")
  new_formula = stri_replace_all_regex(new_formula, "[+\\s]*$", "")
  return(new_formula)
}

#' Alphabetizes the right-hand side of a formula so as to compare formulas across models
rearrange_formula = function(formula) {
  if(class(formula) == "formula") {
    formula = as.character(formula)
    formula = paste(formula[2], "~", formula[3], collapse=" ")
  }
  lhs = stri_extract_first_regex(formula, "^[^\\s~]+")
  rhs = stri_replace_first_regex(formula, "[^~]+~\\s+", "")
  terms = stri_split_regex(rhs, "[\\s\\n]+\\+[\\s\\n]+")
  terms = lapply(terms, sort)
  new_formula = mapply(function(lhs, terms) {paste(lhs, "~", paste(terms, collapse = " + "))}, lhs, terms)
  new_formula = stri_replace_all_regex(new_formula, "[\\s\\n]+", " ")
  new_formula = stri_replace_all_fixed(new_formula, "+ +s", "+ s")
  new_formula = stri_replace_all_fixed(new_formula, "+ +", "+")
  names(new_formula) <- NULL
  return(stri_trim(new_formula))
}

# Re-fits a gam model, dropping terms that have been selected out
reduce_model <- function(mod, edf_cutoff = 0.001, recursive=TRUE) {
  low_edf_vars = any(pen.edf(mod) < edf_cutoff)
  if(recursive) {
    while(low_edf_vars) {
      mod = update(mod, formula = as.formula(rm_low_edf(mod, edf_cutoff)))
      low_edf_vars = any(pen.edf(mod) < edf_cutoff)
    }
  } else {
    if(low_edf_vars) {
      mod = update(mod, formula = as.formula(rm_low_edf(mod, edf_cutoff)))
    }
  }
  return(mod)
}

# Makes a reduced version of the RHS of a formula
shortform = function(formula) {
  rhs = stri_replace_first_regex(formula, "[^~]+~\\s+", "")
  rhs = stri_replace_all_regex(rhs, "s\\(([^\\,]+)\\,[^\\)]+\\)", "s($1)")
  rhs= stri_replace_all_fixed(rhs, "+ +s", "+ s")
  stri_replace_all_fixed(rhs, "(1 + | + 1)", "")
}

check_vals <- function(x) {
  w = which(is.nan(x) | is.na(x) | is.infinite(x))
  z = x[w]
  names(z) = w
  return(z)
}