library(sp)
library(readr)
library(rgdal)
library(stringr)
library(raster)
library(classInt)
library(dplyr)
library(rasterVis)
library(maptools)
library(tibble)
library(mgcv)
library(rgeos)

P <- rprojroot::find_rstudio_root_file

# Load the Mammals' shapefile TERRESTRIAL_MAMMALS, originally downloaded from: http://www.iucnredlist.org/technical-documents/spatial-data#mammals
# This study uses version 2015-2, which is stored on AWS S3.
if(!file.exists(P("maps/TERRESTRIAL_MAMMALS.zip"))) {
  download.file("https://s3.amazonaws.com/hp3-shapefiles/TERRESTRIAL_MAMMALS.zip",
                destfile = P("maps/TERRESTRIAL_MAMMALS.zip"))
}

if(file.exists(P("maps/TERRESTRIAL_MAMMALS.zip")) &
   !dir.exists(P("maps/iucn_data"))) {
  unzip(P("maps/TERRESTRIAL_MAMMALS.zip"), exdir=P("maps/iucn_data/"))
}

terr = shapefile(P("maps/iucn_data/Mammals_Terrestrial.shp"), verbose = T)
terr@data$BINOMIAL = str_replace(terr@data$BINOMIAL, " ", "_")
terr = subset(terr, PRESENCE == 1)

hp3 = read_csv(P('data/hosts.csv')) %>%
  filter(hWildDomFAO == 'wild', hMarOTerr == 'Terrestrial') %>%
  dplyr::select(hHostNameFinal) %>%
  mutate(hp3 = 1)

spatial_host <- terr

# Join spatial polygons and hp3 data frames
spatial_host@data = left_join(spatial_host@data, hp3, by = c("BINOMIAL" = 'hHostNameFinal')) %>%
  subset(hp3 == 1)

#output shape file for QGIS
writeOGR(obj=spatial_host, dsn=P("maps/"), driver = "ESRI Shapefile", layer = "hosts")

#   Complete host file generated from QGIS spatial joins
host_complete = shapefile(P("maps/hosts-complete.shp"), verbose = T)

host_complete@data <- host_complete@data %>%
  select(OBJECTID, ID_NO, BINOMIAL, PRESENCE, ORIGIN, SEASONAL, SHAPE_area, SHAPE_len, Kingdom, Phylum, Class, Order, Family, hp3, Africa, Eurussia, Americas, Asia, Australia)

hostdf<-data.frame(host_complete@data)

hostdf[is.na(hostdf)] <- 0

host_cont <- hostdf %>%
  group_by(BINOMIAL) %>%
  summarise(africa = max(Africa), eurussia = max(Eurussia), asia = max(Asia), australia = max(Australia), americas = max(Americas)) %>%
  mutate(total = africa + eurussia + asia + australia + americas)

#nothing is un-linked to a continent
unident <- host_cont %>%
  filter(total < 1)

#There are 2 hosts left out due to naming issues between iucn and hp3
hp3hostnames <- hp3$hHostNameFinal
iucnhostnames <- host_cont$BINOMIAL
setdiff(hp3hostnames, iucnhostnames)

#cleaning names
host_cont <- host_cont %>%
  rename(africa = maxAfrica, eurussia = maxEurussia, asia = maxAsia,americas = maxAmericas,  australia = maxAustralia)

saveRDS(host_cont, P("maps/host_continental.rds"))


##This section used for continent-wide cross-validation, no longer used

# Get World boundaries and figure out continents
#data("wrld_simpl")
#wrld_simpl@data
#table(wrld_simpl@data$REGION)
#table(wrld_simpl@data$SUBREGION)

# Define and save continent-specific layers for joining in QGIS
#vAfrica <- subset(wrld_simpl,wrld_simpl@data$REGION ==2)
#vAfrica@data$Africa <- 1
#writeOGR(obj=vAfrica, dsn=P("maps/"), driver ="ESRI Shapefile", layer = "Africa")

#vEurussia <- subset(wrld_simpl, wrld_simpl@data$REGION == 150)
#vEurussia@data$Eurussia <- 1
#plot(vEurussia)
#writeOGR(obj = vEurussia, dsn=P("maps/"), driver = "ESRI Shapefile", layer = "Eurussia")

#vAmericas <- subset(wrld_simpl, wrld_simpl@data$REGION == 19)
#vAmericas@data$Americas <- 1
#plot(vAmericas)
#writeOGR(obj = vAmericas, dsn=P("maps/"), driver = "ESRI Shapefile", layer = "Americas")

#vAsia <- subset(wrld_simpl, wrld_simpl@data$REGION == 142)
#vAsia@data$Asia <- 1
#plot(vAsia)
#writeOGR(obj = vAsia, dsn=P("maps/"), driver = "ESRI Shapefile", layer = "Asia")

#vAustralia <- subset(wrld_simpl,wrld_simpl@data$REGION == 9)
#vAustralia@data$Australia <- 1
#plot(vAustralia)
#writeOGR(obj = vAustralia, dsn=P("maps/"), driver = "ESRI Shapefile", layer = "Australia")


