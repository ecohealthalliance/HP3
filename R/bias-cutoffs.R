library(tidyverse)
library(stringr)
library(parallel)
library(ggplot2)
P <- rprojroot::find_rstudio_root_file

#All Viruses data setup
all_viruses_gam <- readRDS(P("model_fitting/all_viruses_model.rds"))
hp3_hosts <- readRDS(P("model_fitting/postprocessed_database.rds"))$hosts
hp3_all = as_tibble(left_join(all_viruses_gam$model, hp3_hosts))
hp3_all_pred = within(hp3_all, {hDiseaseZACitesLn = max(hDiseaseZACitesLn)})
hp3_all = mutate(hp3_all,
                 observed = TotVirusPerHost,
                 predicted = as.vector(unname(predict(all_viruses_gam, hp3_all, type="response"))),
                 predicted_max = as.vector(unname(predict(all_viruses_gam, hp3_all_pred, type="response"))),
                 resid = predicted - observed,
                 missing = predicted_max - observed,
                 hHostNameFinal = as.character(hHostNameFinal))

reduced <- select(hp3_all, observed, predicted, resid, hHostNameFinal)

##FUNCTIONS

#sim function
sims <- function(resid_df, n){
  s <- sample_n(resid_df, n)
  resid_sum <- sum(s$resid)
  pred_sum <- sum(s$predicted)
  q <- resid_sum/pred_sum
  return(q)
}

#creates a single distro
create_distro <- function(resid_df, n){
  r <- replicate(1000,sims(resid_df,n))
  return(r)
}

#creates a list of distros
create_distro_list <- function(upper_bound, resid_df){
  nums <- c(1:upper_bound)
  distros <- lapply(nums,function(x) create_distro(resid_df, x))
  return(distros)
}

create_cutoffs <- function(distributions, sig_level){
  distro_df <- tibble(num_species = 1:length(distributions), lb = sapply(distributions, function(x) quantile(x, sig_level/2)), ub = sapply(distributions, function(x) quantile(x, 1 - sig_level/2)))
  return(distro_df)
}

#creates the dataframe

d_list <- create_distro_list(100, reduced)
cutoff_df <- create_cutoffs(d_list, 0.05)

#graphing
ggplot(data = cutoff_df, aes(x = num_species)) +
  geom_line(aes(y = lb)) +
  geom_line(aes(y = ub)) +
  theme_minimal() +
  labs(title = "All Viruses Model: Upper and Lower Cutoffs for Bias by Number of Species", x = "Number of Species", y = "Sum of Residuals / Sum of Predictions")

