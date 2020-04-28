# Merge into GloBi format 
library(dplyr)
# read in datasheets
asc <- read.csv(file = "data/associations.csv")
ref <- read.csv(file = "data/references.csv")
host <- read.csv(file = "data/hosts.csv")
virus <- read.csv(file = "data/viruses.csv")

# merge sheets
asc <- left_join(asc, ref, by = "referencekey") # merge in the references 
asc <- left_join(asc, host, by = "hHostNameFinal") # merge in the host taxonomy
asc <- left_join(asc, virus, by = "vVirusNameCorrected") # merge in the virus taxonomy

# select columns for interactions sheet 
asc <- dplyr::select(asc, vVirusNameCorrected, vOrder, vFamily, vGenus, hHostNameFinal, hOrder, hFamily, hGenus, Reference)


# create globi interactions sheet
globi_df = data.frame("sourceOccurrenceId" = rep("", nrow(asc)),
       "sourceTaxonId" = 	rep("", nrow(asc)),
       "sourceTaxonName" = asc$vVirusNameCorrected,
       "sourceTaxonOrder" = asc$vOrder,
       "sourceTaxonFamily" = asc$vFamily, 
       "sourceTaxonGenus" = asc$vGenus,
       "sourceBodyPartId" = rep("", nrow(asc)),
       "sourceBodyPartName"	= rep("", nrow(asc)), 
       "sourceLifeStageId" = rep("", nrow(asc)),
       "sourceLifeStageName" = rep("", nrow(asc)),
       "interactionTypeId" = rep("http://purl.obolibrary.org/obo/RO_0002556", nrow(asc)),
       "interactionTypeName" = rep("pathogen of", nrow(asc)),
       "targetOccurrenceId" = rep("", nrow(asc)),
       "targetTaxonId" =	rep("", nrow(asc)), 
       "targetTaxonName" =	asc$hHostNameFinal,
       "targetTaxonOrder" = asc$hOrder,
       "targetTaxonFamily" = asc$hFamily,
       "targetTaxonGenus" = asc$hGenus,
       "targetBodyPartId" =	rep("", nrow(asc)),
       "targetBodyPartName" =	rep("", nrow(asc)),
       "targetLifeStageId" =	rep("", nrow(asc)),
       "targetLifeStageName" =	rep("", nrow(asc)),
       "localityId" =	rep("", nrow(asc)),
       "localityName" =	rep("", nrow(asc)),
       "decimalLatitude" =	rep("", nrow(asc)),
       "decimalLongitude" =	rep("", nrow(asc)),
       "observationDateTime" =	rep("", nrow(asc)),
       "referenceDoi" =	rep("", nrow(asc)),
       "referenceUrl" =	rep("", nrow(asc)),
       "referenceCitation" =	asc$Reference )

# remove underscore from host name and virus name 
globi_df$sourceTaxonName <- gsub("_"," ",globi_df$sourceTaxonName)
globi_df$targetTaxonName <- gsub("_"," ",globi_df$targetTaxonName)

# save merged file 
write.csv(globi_df, file = "data/globi_interactions.csv")