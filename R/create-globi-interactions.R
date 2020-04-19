# Merge into GloBi format 
library(dplyr)
# read in datasheets
asc <- read.csv(file = "data/associations.csv")
ref <- read.csv(file = "data/references.csv")
# merge the two datasets
asc <- left_join(asc, ref, by = "referencekey")

# select columns for interactions sheet 
asc <- dplyr::select(asc, vVirusNameCorrected, hHostNameFinal, Reference)
# rename columns 

# create in empty interactions sheet
globi_df = data.frame("sourceOccurrenceId" = rep("", nrow(asc)),
       "sourceTaxonId" = 	rep("", nrow(asc)),
       "sourceTaxonName" = asc$vVirusNameCorrected,
       "sourceBodyPartId" = rep("", nrow(asc)),
       "sourceBodyPartName"	= rep("", nrow(asc)), 
       "sourceLifeStageId" = rep("", nrow(asc)),
       "sourceLifeStageName" = rep("", nrow(asc)),
       "interactionTypeId" = rep("http://purl.obolibrary.org/obo/RO_0002444", nrow(asc)),
       "interactionTypeName" = rep("parasite of", nrow(asc)),
       "targetOccurrenceId" = rep("", nrow(asc)),
       "targetTaxonId" =	rep("", nrow(asc)), 
       "targetTaxonName" =	asc$hHostNameFinal,
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