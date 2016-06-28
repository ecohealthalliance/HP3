P <- rprojroot::find_rstudio_root_file
library(mgcv)
library(stringi)
library(dplyr)
library(ztable)
library(purrr)
library(htmlwidgets)
library(htmlTable)
top_models <- readRDS(P("supplement/top_models.rds"))

model_names = c("Zoonoses Model",
                "Zoonoses Model (strict)",
                "Viral Richness Model",
                "Viral Richness Model (strict)",
                "Viral Traits Model",
                "Viral Traits Model (strict)")

model_tables = map2(top_models, model_names, function(modd, model_name) {
  summ = summary(modd)
  summ$p.table
  summ$s.table
  rel_dev = get_relative_contribs(modd)

  bind_rows(data_frame(Term = stri_extract_first_regex(rownames(summ$p.table), "(?<=\\()[^\\)]+(?=\\))"),
                       Value = summ$p.table[,1],
                       `Z statistic` = summ$p.table[,3],
                       `Chi-sq statistic` = NA,
                       `P-value` = summ$p.table[,4],
                       `Effective Degrees of Freedom` = NA,
                       `Relative Deviance Explained` = NA,
                       model = model_name),
            data_frame(Term = stri_extract_first_regex(rownames(summ$s.table), "(?<=s\\()[^\\)]+(?=\\))"),
                       Value = NA,
                       `Z statistic` = NA,
                       `Chi-sq statistic` = summ$s.table[,3],
                       `P-value` = summ$s.table[,4],
                       `Effective Degrees of Freedom` = summ$s.table[,1],
                       `Relative Deviance Explained`= rel_dev$rel_deviance_explained,
                       model=model_name))

})

model_rows = map_int(model_tables, nrow)
model_tables2 = model_tables %>%
  bind_rows %>%
  mutate_each(funs(signif(., digits=3)), -Term, -model) %>%
  #arrange(model, Term !="Intercept") %>%
  select(-model)



tables = ztable(model_tables2) %>%
  addrgroup(rgroup = model_names, n.rgroup = model_rows)

htmlTable(model_tables2, rnames=FALSE, rgroup = model_names, n.rgroup=model_rows,
          align = "lcccccc") %>%
  cat(file=P("figures/ExtendedTable01-models.html"))


