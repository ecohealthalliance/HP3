P <- rprojroot::find_rstudio_root_file
library(mgcv)
library(stringi)
library(dplyr)
library(purrr)
library(ReporteRs)
source(P("R/relative_contributions.R"))
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
                       Value = round(summ$p.table[,1], 2),
                       `Z statistic` = round(summ$p.table[,3], 2),
                       `Chi-sq statistic` = NA,
                       `P-value` = ifelse(summ$p.table[,4] > 0.001, as.character(round(summ$p.table[,4], digits=3)), "<0.001"),
                       `Effective Degrees of Freedom` = NA,
                       `Percent Dev. Explained` = as.character(NA),
                       model = model_name),
            data_frame(Term = stri_extract_first_regex(rownames(summ$s.table), "(?<=s\\()[^\\)]+(?=\\))"),
                       Value = NA,
                       `Z statistic` = NA,
                       `Chi-sq statistic` = round(summ$s.table[,3], 2),
                       `P-value` = ifelse(summ$s.table[,4] > 0.001, as.character(round(summ$s.table[,4], digits=3)), "<0.001"),
                       `Effective Degrees of Freedom` = round(summ$s.table[,1], 2),
                       `Percent Dev. Explained`= paste0(round(100*rel_dev$rel_deviance_explained, 2), "%"),
                       model=model_name))

})

model_rows = map_int(model_tables, nrow)
model_tables2 = model_tables %>%
  map(~ rbind(.[1,], .)) %>%
  map(function(x) {
    x$model = c(x$model[1], rep(NA, nrow(x) -1))
    return(x)
  }) %>%
  bind_rows %>%
  mutate_each(funs(as.character), -Term, -model) %>%
  #arrange(model, Term !="Intercept") %>%
  select(8, 1:7)

names(model_tables2)[1] <- ""

word_table <- vanilla.table(model_tables2) %>%
  spanFlexTableColumns(i = which(!is.na(model_tables2[[1]])), from = 1, to = ncol(model_tables2)) %>%
  setFlexTableWidths(widths = c( .1, 2.1, .65,.65,.65,.65, 1, 1))
word_table[] <- parProperties(text.align="right", padding.bottom=0, padding.top=0)
word_table[] <- textProperties(font.size = 10)
word_table[which(!is.na(model_tables2[[1]])),] <- textBold()
word_table[which(as.numeric(model_tables2$`P-value`) < 0.05 | is.na(as.numeric(model_tables2$`P-value`))), 6] <- textBold()
#word_table[] <- cellProperties(padding.top=0, padding.bottom = 0)
# word_table[] <- cellProperties(padding.top=0, padding.bottom = 0)
word_table[, to = "header"] <- parCenter(padding.left=2)
word_table[,2] <- parLeft()
word_table[,1] <- parLeft()


# print in the viewer
#print(word_table)

# create word file
docx() %>%
  addFlexTable(word_table) %>%
  writeDoc(file = P("figures/ExtendedTable01-models.docx"))


