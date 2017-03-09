library(dplyr)
library(mgcv)
library(tibble)
library(readr)
P <- rprojroot::find_rstudio_root_file

all_viruses_gam <- readRDS(P("intermediates", "all_viruses_models.rds"))$model[[1]]
zoo_viruses_gam <- readRDS(P("intermediates", "all_zoonoses_models.rds"))$model[[1]]
hp3_hosts <- readRDS(P("intermediates", "postprocessed_database.rds"))$hosts
hp3_all = as_tibble(left_join(all_viruses_gam$model, hp3_hosts))
hp3_all = as_tibble(left_join(hp3_all, zoo_viruses_gam$model))
hp3_all_pred = mutate(hp3_all,
                      hDiseaseZACitesLn = max(hDiseaseZACitesLn),
                      hAllZACitesLn = max(hDiseaseZACitesLn))

hp3_all = hp3_all %>%
  mutate(viral_richness_base_predict = as.vector(unname(predict(all_viruses_gam, hp3_all, type="response"))),
         viral_richness_max_predict = as.vector(unname(predict(all_viruses_gam, hp3_all_pred, type="response"))))

hp3_all_pred = mutate(hp3_all_pred, LnTotNumVirus = log(hp3_all$viral_richness_max_predict))

hp3_all =  hp3_all %>%
  mutate(zoonotic_richness_base_predict = as.vector(unname(predict(zoo_viruses_gam, hp3_all, type="response"))),
         zoonotic_richness_max_predict = as.vector(unname(predict(zoo_viruses_gam, hp3_all_pred, type="response"))),
         missing_viruses = viral_richness_max_predict - TotVirusPerHost,
         missing_zoonoses = zoonotic_richness_max_predict - NSharedWithHoSa,
         hHostNameFinal = as.character(hHostNameFinal)) %>%
  select(hHostNameFinal, hOrder, TotVirusPerHost, NSharedWithHoSa, viral_richness_base_predict,
         viral_richness_max_predict, zoonotic_richness_base_predict,
         zoonotic_richness_max_predict, missing_viruses, missing_zoonoses) %>%
  rename(host_species = hHostNameFinal, host_order = hOrder,
         viral_richness_observed = TotVirusPerHost,
         zoonotic_richness_observed = NSharedWithHoSa) %>%
  mutate(host_order = as.character(host_order)) %>%
  arrange(host_species)

write_csv(hp3_all, "figures/SuppTable1-observed-predicted-missing.csv")
