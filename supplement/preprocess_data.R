#  Preprocess all data for input to models

library(dplyr)
library(magrittr)
library(readr)
library(assertr)
library(readxl)
library(tidyr)
library(purrr)
P <- rprojroot::find_rstudio_root_file
## Read the data files
associations = read_csv(P("data/HP3.assoc_v50.csv"))
hosts  = read_csv(P("data/HP3.hostv42_FINAL.csv"))
viruses = read_csv(P("data/HP3.virus_v51.csv"))

# Temporary fix
hosts = hosts %>%
  filter(hHostNameFinal != "Felis_concolor")
associations = associations %>%
  filter(hHostNameFinal != "Felis_concolor")

## Add viruses per host (total and strict) to host data
hosts = associations %>%
  group_by(hHostNameFinal) %>%
  summarise(TotVirusPerHost = n(),
            TotVirusPerHost_strict = sum(DetectionQuality == 2)) %>%
  full_join(hosts, by="hHostNameFinal")# %>%
  #verify(TotVirusPerHost == vir_rich)  # check against prev values

## Add viruses shared with humans to host data
human_viruses = associations %>%
  filter(hHostNameFinal == "Homo_sapiens") %>%
  use_series("vVirusNameCorrected")

human_viruses_strict = associations %>%
  filter(hHostNameFinal == "Homo_sapiens", DetectionQuality == 2) %>%
  use_series("vVirusNameCorrected")

human_viruses_no_rev = associations %>%
  filter(hHostNameFinal == "Homo_sapiens") %>%
  filter(!(vVirusNameCorrected %in% viruses$vVirusNameCorrected[viruses$ReverseZoonoses==1])) %>%
  use_series("vVirusNameCorrected")

hosts = associations %>%
  group_by(hHostNameFinal) %>%
  summarise(NSharedWithHoSa = sum(vVirusNameCorrected %in% human_viruses),
            NSharedWithHoSa_strict = sum(vVirusNameCorrected[DetectionQuality ==2] %in% human_viruses_strict),
            NSharedWithHoSa_norev = sum(vVirusNameCorrected %in% human_viruses_no_rev)) %>%
  full_join(hosts, by="hHostNameFinal") %>% # check against prev values
  #hosts %>%
 # verify(NSharedWithHoSa == vHoSaRich) %>%
  #verify(NSharedWithHoSa_strict == vHoSaRich.stringent |
  #       is.na(vHoSaRich.stringent) & NSharedWithHoSa_strict == 0) %>%
  verify(NSharedWithHoSa_norev <= NSharedWithHoSa)

# Add additional host fields from other data files

#phylo-corrected mass
hosts = read_csv(P("data/PVR_cytb_hostmass.csv")) %>%
  select(-hMassGramsLn) %>%
  rename(hMassGramsPVR = PVRcytb_resid) %>%
  full_join(hosts, by="hHostNameFinal")

#phylo-dist to humans via cyt-b
hosts = read.csv(P("data/HP3-cytb_PDmatrix-12Mar2016.csv"),
             as.is=T, row.names = 1, stringsAsFactors = FALSE) %>%
    add_rownames("hHostNameFinal") %>%
    select(hHostNameFinal, Homo_sapiens) %>%
    rename(PdHoSa.cbCst = Homo_sapiens) %>%
    full_join(hosts, by="hHostNameFinal")

#phylo-dist to humans via mammallian supertree
hosts = read.csv(P("data/HP3-ST_PDmatrix-12Mar2016.csv"),
                 as.is=T, row.names = 1, stringsAsFactors = FALSE) %>%
  add_rownames("hHostNameFinal") %>%
  select(hHostNameFinal, Homo_sapiens) %>%
  rename(PdHoSaSTPD = Homo_sapiens) %>%
  full_join(hosts, by="hHostNameFinal") %>%
  arrange(hHostNameFinal)

## Transform and derive variables

logp = function(x){   # Fn to take log but make zeros less 10x less than min
  # x[is.na(x)] <- 0
  m = min(x[ x > 0], na.rm=T)
  x = log( x + m )
  return(x)
}

is_real <- function(x) {
  !(is.nan(x) | is.na(x) | is.infinite(x))
}

# Add variable for order-normalized host phylogenetic distance to humans
hosts = hosts %>%
  group_by(hOrder) %>%
  mutate(PdHoSa.cbCst_order = PdHoSa.cbCst - mean(PdHoSa.cbCst, na.rm =TRUE))
#TODO: add some suffix to calculated variables to designated them, make easier
#for verification calls.

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

   #      TotHumPopChgPct    = (popc_2005AD - popc_1970AD)/(popc_1970AD + 1),
   #      RurTotHumPopChgPct = (rurc_2005AD - rurc_1970AD)/(rurc_1970AD + 1),
   #      UrbTotHumPopChgPct = (urbc_2005AD - urbc_1970AD)/(urbc_1970AD + 1),

         UrbRurPopRatioLn = logp((urbc_2005AD)/(rurc_2005AD)),
         UrbRurPopRatioChg = logp((urbc_2005AD)/(rurc_2005AD)) - logp((urbc_1970AD)/(rurc_1970AD)),

         HumPopDensLn      = logp(popc_2005AD/AreaHost),
         HumPopDensLnChg   = logp(popc_2005AD/AreaHost) - logp(popc_1970AD/AreaHost),

         HabAreaCropLn     = logp(p_crop2005  * AreaHost/100),
         HabAreaGrassLn    = logp(p_grass2005 * AreaHost/100),
         HabAreaUrbanLn    = logp(p_uopp2005  * AreaHost/100),
         HabInhabitedLn    = logp((p_crop2005 + p_grass2005 + p_uopp2005)/100),


         HabAreaCropChgLn     = logp(p_crop2005  * AreaHost/100) - logp(p_crop1970  * AreaHost/100),
         HabAreaGrassChgLn    = logp(p_grass2005 * AreaHost/100) - logp(p_grass1970 * AreaHost/100),
         HabAreaUrbanChgLn    = logp(p_uopp2005  * AreaHost/100) - logp(p_uopp1970  * AreaHost/100),
         HabInhabitedChgLn    = logp((p_crop2005 + p_grass2005 + p_uopp2005) * AreaHost/100) -
                                  logp((p_crop1970 + p_grass1970 + p_uopp1970) * AreaHost/100),
         Population_trend = factor(Population_trend,
                                   levels=sort(unique(Population_trend),decreasing = T))) %>%
         # assert(is_real,
         #        LnTotNumVirus,
         #        hDiseaseZACitesLn,
         #        hAllZACitesLn,
         #        LnAreaHost,
         #        TotHumPopLn,
         #        RurTotHumPopLn,
         #        UrbTotHumPopLn,
         #        TotHumPopChgLn,
         #        RurTotHumPopChgLn,
         #        UrbTotHumPopChgLn,
         #        HabAreaCropLn,
         #        HabAreaGrassLn,
         #        HabAreaUrbanLn,
         #        HabAreaCropChgLn,
         #        HabAreaGrassChgLn,
         #        HabAreaUrbanChgLn) %>%
        lapply(function(x) if(is.character(x)) as.factor(x) else x) %>%
        as.data.frame %>% tbl_df

# Calculate non-human phylogenetic distances

trees <- list(
  super = read_csv(P("data/HP3-ST_PDmatrix-12Mar2016.csv")),
  cytb = read_csv(P("data/HP3-cytb_PDmatrix-12Mar2016.csv")))
trees <- map(trees, function(tree) {
  names(tree)[1] <- "species1"
  tree <- gather(tree, "species2", "distance", -species1)
  tree <- filter(tree, species1 != "Homo_sapiens" & species2 != "Homo_sapiens", species1 != species2)
  return(tree)
})

super_species = unique(trees$super$species1)
cytb_species = unique(trees$cytb$species1)

dists = associations %>%
  filter(hHostNameFinal != "Homo_sapiens") %>%
  group_by(vVirusNameCorrected) %>%
  summarise(n_noHoSa_hosts = n(),
            n_noHoSa_hosts_super = sum(hHostNameFinal %in% super_species),
            n_noHoSa_hosts_cytb = sum(hHostNameFinal %in% cytb_species),
            st_dist_noHoSa = list(trees$super$distance[trees$super$species1 %in% hHostNameFinal & trees$super$species2 %in% hHostNameFinal]),
            cb_dist_noHoSa = list(trees$cytb$distance[trees$cytb$species1 %in% hHostNameFinal  & trees$cytb$species2 %in% hHostNameFinal])) %>%
  mutate_each(funs(max=map_dbl(., max), mean=map_dbl(., mean), median = map_dbl(., median)), -vVirusNameCorrected, -n_noHoSa_hosts, -n_noHoSa_hosts_super, -n_noHoSa_hosts_cytb) %>%
  select(-st_dist_noHoSa, -cb_dist_noHoSa) %>%
  mutate_each(funs(ifelse(is.infinite(.) | is.na(.) | is.nan(.), 0, .)), -vVirusNameCorrected, -n_noHoSa_hosts, -n_noHoSa_hosts_super, -n_noHoSa_hosts_cytb) %>%
  mutate_each(funs(ifelse(n_noHoSa_hosts > 1 & n_noHoSa_hosts_cytb == 1, NA, .)), starts_with("cb_"))

dists_strict = associations %>%
  filter(DetectionQuality == 2) %>%
  filter(hHostNameFinal != "Homo_sapiens") %>%
  group_by(vVirusNameCorrected) %>%
  summarise(n_noHoSa_hosts = n(),
            n_noHoSa_hosts_super = sum(hHostNameFinal %in% super_species),
            n_noHoSa_hosts_cytb = sum(hHostNameFinal %in% cytb_species),
            st_dist_noHoSa = list(trees$super$distance[trees$super$species1 %in% hHostNameFinal & trees$super$species2 %in% hHostNameFinal]),
            cb_dist_noHoSa = list(trees$cytb$distance[trees$cytb$species1 %in% hHostNameFinal  & trees$cytb$species2 %in% hHostNameFinal])) %>%
  mutate_each(funs(max=map_dbl(., max), mean=map_dbl(., mean), median = map_dbl(., median)), -vVirusNameCorrected, -n_noHoSa_hosts, -n_noHoSa_hosts_super, -n_noHoSa_hosts_cytb) %>%
  select(-st_dist_noHoSa, -cb_dist_noHoSa) %>%
  mutate_each(funs(ifelse(is.infinite(.) | is.na(.) | is.nan(.), 0, .)), -vVirusNameCorrected, -n_noHoSa_hosts, -n_noHoSa_hosts_super, -n_noHoSa_hosts_cytb) %>%
  mutate_each(funs(ifelse(n_noHoSa_hosts > 1 & n_noHoSa_hosts_cytb == 1, NA, .)), starts_with("cb_"))

names(dists_strict)[-1] <- paste0(names(dists_strict)[-1], ".stringent")

viruses = viruses %>%
  dmap(function(x) {
    if (is.integer(x) & all(x %in% c(0,1) | is.na(x))) {
      return(as.logical(x))
    } else {
      return(x)
    }
  }) %>%
  mutate(NumHostsLn = logp(NumHosts),
         NumHostsLn.stringent = logp(NumHosts.stringent),
         vPubMedCitesLn = logp(vPubMedCites),
         vWOKcitesLn = logp(vWOKcites),
         RNA = as.numeric(vDNAoRNA == "RNA"),
         SS = as.numeric(vSSoDS == "SS"),
         Vector = as.numeric(vVectorYNna == "Y"),
         Envelope = as.numeric(vEnvelope == "enveloped"),
         vCytoReplicTF = as.numeric(vCytoReplicTF),
         vGenomeAveLengthLn = logp(vGenomeAveLength)
  )

viruses <- left_join(viruses, dists, by ="vVirusNameCorrected")
viruses <- left_join(viruses, dists_strict, by ="vVirusNameCorrected")

log2 <- function(x) {
  ifelse(x == 0 | is.na(x), NA, log(x))
}

