# A quick script to check if bats are special

P <- rprojroot::find_rstudio_root_file
library(mgcv)
library(dplyr)
library(MASS)
gam_model <- readRDS(P("intermediates/all_viruses_models.rds"))$model[[1]]
#gam(formula = formula(gam_model), sp = gam_model$sp, data=, family=gam_model$family, select=FALSE)

library(MASS)
samps = mvrnorm(1e6, mu=coef(gam_model), Sigma=vcov(gam_model))
samps <- tbl_df(as.data.frame(samps))
results <- samps %>%
  mutate(bats_vs_orders = `s(hOrderCHIROPTERA).1` > pmax(`s(hOrderCETARTIODACTYLA).1`, `s(hOrderRODENTIA).1`, `s(hOrderPRIMATES).1`)) %>%
  mutate(bats_vs_perissodactyla = `s(hOrderCHIROPTERA).1` > `s(hOrderPERISSODACTYLA).1`) %>%
  summarise_each(funs(1 - sum(.)/length(.)), bats_vs_orders, bats_vs_perissodactyla)
results
