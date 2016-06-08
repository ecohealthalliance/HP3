library(readr)
library(dplyr)
library(tidyr)
library(mgcv)
library(visdat)
library(plotly)
library(htmlwidgets)
library(purrr)
library(stringi)
library(parallel)
source('R/model_reduction.R')
source("preprocess_data.R")
viruses = read_csv('data/HP3.virus_v45.csv') %>% 
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

#Calculate phylogenetic host distance *without humans*

associations <- read_csv("data/HP3.assocV41_FINAL.csv")

