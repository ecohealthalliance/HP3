library(dplyr)
library(magrittr)
library(readr)

# Notes:
# Felis_concolor is an incorrect species name and is largely empty. It should be Puma_concolor.

## Read the data files
associations = read_csv("data/HP3.assocV41_FINAL.csv")
hosts  = read_csv("data/HP3.hostv41_FINAL.csv"); hosts[[1]] <- NULL
viruses = read_csv("data/HP3.virusv41_FINAL_withRevZoon.csv")

## Add viruses per host to host data
hosts = associations %>% 
  group_by(hHostNameFinal) %>% 
  summarise(TotVirusPerHost = n()) %>% 
  full_join(hosts, by="hHostNameFinal")

## Add viruses shared with humans to host data

human_viruses = associations %>% 
  filter(hHostNameFinal == "Homo_sapiens") %>% 
  use_series("vVirusNameCorrected")

hosts = associations %>% 
  group_by(hHostNameFinal) %>% 
  summarise(NSharedWithHoSa = sum(vVirusNameCorrected %in% human_viruses)) %>% 
  full_join(hosts, by="hHostNameFinal")

# Add additional host fields from other data files

#phylo-corrected mass
hosts = read_csv("data/PVR_cytb_hostmass.csv") %>%  
  select(-hMassGramsLn) %>% 
  rename(hMassGramsPVR = PVRcytb_resid) %>% 
  full_join(hosts, by="hHostNameFinal")

#phylo-dist to humans via cyt-b
hosts = read.csv("data/phylo/HP3-cytb_PDmatrix-12Mar2016.csv", 
             as.is=T, row.names = 1, stringsAsFactors = FALSE) %>%
    add_rownames("hHostNameFinal") %>% 
    select(hHostNameFinal, Homo_sapiens) %>% 
    rename(PdHoSa.cbCst = Homo_sapiens) %>% 
    full_join(hosts, by="hHostNameFinal")

#phylo-dist to humans via mammallian supertree
hosts = read.csv("data/phylo/HP3-ST_PDmatrix-12Mar2016.csv", 
                 as.is=T, row.names = 1, stringsAsFactors = FALSE) %>%
  add_rownames("hHostNameFinal") %>% 
  select(hHostNameFinal, Homo_sapiens) %>% 
  rename(PdHoSaSTPD = Homo_sapiens) %>% 
  full_join(hosts, by="hHostNameFinal")

## Transform and derive variables

logp = function(x){   # Fn to take log but make zeros less 10x less than min
  x[is.na(x)] <- 0
  m = min(x[ x > 0], na.rm=T)
  x[x==0] <- m
  x = log(x)
  return(x)
}


hosts = hosts %>% 
  mutate(LnTotNumVirus     = log(TotVirusPerHost),     # for poisson offset
         hDiseaseZACitesLn = log(hDiseaseZACites + 1), # num 2.3 2.4 0 5.21
         hAllZACitesLn     = log(hAllZACites + 1),         # num 3.97 4.08 2.2 6.72
         LnAreaHost        = logp(AreaHost),
         
         TotHumPopLn       = logp(popc_2005AD),
         RurTotHumPopLn    = logp(rurc_2005AD),
         UrbTotHumPopLn    = logp(urbc_2005AD),
         
         TotHumPopChgLn    = logp(popc_2005AD) - logp(popc_1970AD),
         RurTotHumPopChgLn = logp(rurc_2005AD) - logp(rurc_1970AD),
         UrbTotHumPopChgLn = logp(urbc_2005AD) - logp(urbc_1970AD),

         HabAreaCropLn     = logp(p_crop2005  * AreaHost), 
         HabAreaGrassLn    = logp(p_grass2005 * AreaHost), 
         HabAreaUrbanLn    = logp(p_uopp2005  * AreaHost),

         HabAreaCropChgLn  = logp(p_crop2005  * AreaHost) - logp(p_crop1970  * AreaHost), 
         HabAreaGrassChgLn = logp(p_grass2005 * AreaHost) - logp(p_grass1970 * AreaHost), 
         HabAreaUrbanChgLn = logp(p_uopp2005  * AreaHost) - logp(p_uopp1970  * AreaHost),
         
         hOrder            = as.factor(hOrder),
         hHuntedIUCN       = as.factor(hHuntedIUCN),
         hArtfclHbttUsrIUCN= as.factor(hArtfclHbttUsrIUCN),
         RedList_status    = as.factor(RedList_status)
  )