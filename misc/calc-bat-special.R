# A quick script to check if bats are special

P <- rprojroot::find_rstudio_root_file
library(mgcv)
library(dplyr)
library(MASS)
gam_model <- readRDS(P("supplement/all_zoonoses_model.rds"))
gam(formula = formula(gam_model), sp = gam_model$sp, data=model_data, family=gam_model$family, select=FALSE)

library(MASS)
samps = mvrnorm(1e7, mu=coef(modd), Sigma=vcov(modd))
samps <- tbl_df(as.data.frame(samps))
samps %>%
  mutate(bats_special = `s(hOrderCHIROPTERA).1` > pmax(`s(hOrderCETARTIODACTYLA).1`, `s(hOrderRODENTIA).1`, `s(hOrderPRIMATES).1`)) %>%
  mutate(bats_special2 = `s(hOrderCHIROPTERA).1` > `s(hOrderPERISSODACTYLA).1`) %>%
  summarise_each(funs(1 - sum(.)/length(.)), bats_special, bats_special2)
names(coef(modd))
