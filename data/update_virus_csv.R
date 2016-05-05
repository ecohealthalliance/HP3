library(readr)
library(dplyr)

viruses_41 <- read_csv('data/HP3.virusv41_FINAL_withRevZoon.csv')
viruses_43 <- read_csv('data/HP3.virus_v43.csv')

viruses_44 <- full_join(viruses_41, viruses_43) %>% 
  filter(!is.na(vVirusNameCorrected)) %>% 
  select(-1)

write_csv(viruses_44, "data/HP3.virus_v44.csv")
