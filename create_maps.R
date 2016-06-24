library(sp)
library(readr)
library(rgdal)
library(stringr)
library(dplyr)
library(raster)
library(classInt)
library(rasterVis)
library(plyr)
library(maptools)


rm(list=ls())
# Load the Mammals' shapefile TERRESTRIAL_MAMMALS, downloaded from: http://www.iucnredlist.org/technical-documents/spatial-data#mammals

terr = shapefile('data/iucn_data/Mammals_Terrestrial.shp', verbose = T)
terr@data$BINOMIAL = str_replace(terr@data$BINOMIAL, " ", "_")

# select only extant species
terr = subset(terr, PRESENCE == 1)

# Read taxonomic information.
taxa = read_csv('data/IUCN_taxonomy_23JUN2016.csv') %>%
  dplyr::select(-c(7:23), spp_ID = `Species ID`)

# Join taxonomic information to spatial data
terr@data = left_join(terr@data, taxa, by = c("ID_NO" = 'spp_ID'))

# Read HP3 results
# all viruses
hp3_all = read_csv('data/all_viruses_gam_predictions.csv') %>%
  mutate(pred_obs_all = prediction - TotVirusPerHost,
         pred_all = prediction) %>%
  dplyr::select(-prediction, -hOrder, obs_all = TotVirusPerHost)

# just zoonotic viruses
hp3_zoo = read_csv('data/all_zoonoses_gam_predictions.csv') %>%
  mutate(pred_obs_zoo = prediction - NSharedWithHoSa,
         pred_zoo = prediction) %>%
  dplyr::select(-prediction, -hOrder, obs_zoo = NSharedWithHoSa)

# Read HP3 database
hp3 = read_csv('data/HP3.hostv42_FINAL.csv') %>%
  filter(hWildDomFAO == 'wild', hMarOTerr == 'Terrestrial') %>%
  dplyr::select(hHostNameFinal) %>%
  mutate(hp3 = 1)

# Create spatial polygons for all_viruses & all_zoonoses
data_hp3_all <- terr
data_hp3_zoo <- terr
data_host <- terr

# Join spatial polygons and hp3 data frames
data_hp3_all@data = full_join(data_hp3_all@data, hp3_all, by = c("BINOMIAL" = 'hHostNameFinal'))
data_hp3_zoo@data = full_join(data_hp3_zoo@data, hp3_zoo, by = c("BINOMIAL" = 'hHostNameFinal'))
data_host@data = left_join(data_host@data, hp3, by = c("BINOMIAL" = 'hHostNameFinal')) %>%
  subset(hp3 == 1)

# Remove NAs (i.e., species with no data available)
data_hp3_all = data_hp3_all[!is.na(data_hp3_all$obs_all),]
data_hp3_zoo = data_hp3_zoo[!is.na(data_hp3_zoo$obs_zoo),]

# Auxilliary functions
# get world administrative borders. Requires maptools
data(wrld_simpl)
wrld_simpl = subset(wrld_simpl, NAME != 'Antarctica')

# Create color palette. Requires rasterVis and RColorBrewer
myTheme = rasterTheme(region = rev(brewer.pal(11, 'RdYlGn')))

# Function to create .png maps from 'in memory' rasters. The xlim & ylim removes Antarctica
plot_png = function(raster, out_dir, res, theme){
  require(stringr)
  require(rasterVis)
  name = deparse(substitute(raster))
  out_file = paste0(out_dir, name, '.png')
  png(out_file, width = ncol(raster), height = nrow(raster), res = res)
  print(levelplot(raster, layers = 1, par.settings = theme, margin = F, ylab = '', xlab = '', maxpixels = ncell(raster), xlim = c(-180, 180), ylim = c(-58, 90)) +
          layer(sp.polygons(wrld_simpl, lwd = 0.5, col = 'gray50')))
  dev.off()
}

# Read .tif files from directory and create .png maps. Requires maptools data(wrld_simpl) to draw the global borders
read_print = function(in_dir, out_dir, res, theme){
  require(stringr)
  require(rasterVis)
  list_tif = dir(in_dir, '.tif')
  for (i in list_tif) {
    raster = raster(paste0(in_dir, i))
    out_file = paste0(out_dir, str_sub(i, 1, -4), 'png')
    png(out_file, width = ncol(raster), height = nrow(raster), res = res)
    print(levelplot(raster, layers = 1, par.settings = theme, margin = F, ylab = '', xlab = '', maxpixels = ncell(raster), xlim = c(-180, 180), ylim = c(-58, 90)) +
            layer(sp.polygons(wrld_simpl, lwd = 0.5, col = 'gray50')))
    dev.off()
    print(paste('Done!!', i))
  }
}


# Function to create the missing zoonoses maps. Resolution can be defined as 1/6
spp_rich_virus = function(shapefile, colname, order = NULL, res, out_dir, ...) {
  require(rgdal)
  template <- raster(resolution = res)
  if (is.null(order)){
    for(i in colname){
      out_file = paste0(out_dir, i)
      extension(out_file) = 'tif'
      print(paste('Processing', i, sep = ' '))
      temp = raster()
      temp = rasterize(shapefile, template, i, fun = 'sum', silent = F, progress = 'text')
      writeRaster(temp, filename = out_file, format = "GTiff", overwrite = T, progress = 'text')
    }
  } else {
    template <- raster(resolution = res)
    for(j in order){
      tmp_pol = subset(shapefile, Order == j)
      print(dim(tmp_pol))
      for(i in colname){
        out_file = paste0(out_dir, j, '_', i)
        extension(out_file) = 'tif'
        print(paste('Processing', j, i, sep = ' '))
        temp0 = raster()
        temp0 = rasterize(tmp_pol, template, i, fun = 'sum', silent = F, progress ='text')
        writeRaster(temp0, filename = out_file, format = "GTiff", overwrite = T, progress = 'text')
      }
    }
  }
}


# Function to calculate host species richness

spp_rich_host = function(shapefile, order = NULL, file_name, res, out_dir, ...) {
  require(rgdal)
  template <- raster(resolution = res)
  if (is.null(order)){
    out_file = paste0(out_dir, file_name)
    extension(out_file) = 'tif'
    print(paste('Processing ALL mammals'))
    temp = raster()
    temp = rasterize(shapefile, template, 1, fun = 'sum', silent = F, progress = 'text')
    writeRaster(temp, filename = out_file, format = "GTiff", overwrite = T, progress = 'text')
  } else {
    for(j in order){
      tmp_pol = subset(shapefile, Order == j)
      print(dim(tmp_pol))
      out_file = paste0(out_dir, j, '_', file_name)
      extension(out_file) = 'tif'
      print(paste('Processing just', j, sep = ' '))
      temp0 = raster()
      temp0 = rasterize(tmp_pol, template, 1, fun = 'sum', silent = F, progress = 'text')
      writeRaster(temp0, filename = out_file, format = "GTiff", overwrite = T, progress = 'text')
    }
  }
}




##########
# Generate the tif files for all mammals and by order
list_vars_all = c('obs_all', 'pred_all', 'pred_obs_all')
list_vars_zoo = c('obs_zoo', 'pred_zoo', 'pred_obs_zoo')
list_orders = c('CARNIVORA', 'CETARTIODACTYLA', 'CHIROPTERA', 'PRIMATES', 'RODENTIA')

# Create all_viruses .tif rasters 
spp_rich_virus(data_hp3_all, list_vars_all, NULL, 1/6, 'output/tif/all_viruses/')
spp_rich_virus(data_hp3_all, list_vars_all, list_orders, 1/6, 'output/tif/all_viruses/')

# Create all_zoonoses .tif rasters 
spp_rich_virus(data_hp3_zoo, list_vars_zoo, NULL, 1/6, 'output/tif/zoonoses/')
spp_rich_virus(data_hp3_zoo, list_vars_zoo, list_orders, 1/6, 'output/tif/zoonoses/')

# Species richness maps for data in database
spp_rich_host(data_host, NULL, 'hp3', 1/6,'output/tif/host/')
spp_rich_host(data_host, list_orders, 'hp3', 1/6,'output/tif/host/')

# Species richness maps for ALL mammals
spp_rich_host(terr, NULL, 'hosts', 1/6,'output/tif/host/')
spp_rich_host(terr, list_orders, 'hosts', 1/6,'output/tif/host/')

# Generate beatiful maps
# Read all_viruses .tif rasters and create .png maps.
read_print('output/tif/all_viruses/', 'output/png/all_viruses/', 200, myTheme)

# Read all_zoonoses .tif rasters and create .png maps.
read_print('output/tif/zoonoses/', 'output/png/zoonoses/', 200, myTheme)

# Read all host .tif rasters and create .png maps
read_print('output/tif/host/', 'output/png/host/', 200, myTheme)



####

tif_path = function(direc, ext){
  list_files = dir(direc, ext)
  for(i in list_files){
    s = paste0(direc, list_files)
    return(s)
  }
  
}

miss_zoo = stack(str_subset(s, 'pred_obs'))

#s0 = stack(s)
nl <- nlayers(miss_zoo)
m <- matrix(1:nl, nrow=3)

png('output/png/panel_res.png', width = ncol(miss_zoo), height = nrow(miss_zoo), res = 200)
for (i in 1:nl){
  p <- levelplot(miss_zoo, layers = i, 
                 par.settings = myTheme, 
                 margin = F, 
                 ylab = '', 
                 xlab = '', 
                 maxpixels = ncell(miss_zoo), 
                 xlim=c(-180,180), ylim=c(-56,90),
                 scales=list(draw=FALSE)) +
    layer(sp.polygons(wrld_simpl, lwd = 0.5, col = 'gray50'))
  print(p, split = c(col(m)[i], row(m)[i], ncol(m), nrow(m)), more=(i<nl))
}
dev.off()

pl = levelplot(miss_zoo,
               par.settings = myTheme,
               col.regions = myTheme, 
               colorkey = list(space = "bottom"), 
               margin = F, 
               ylab = '', 
               xlab = '', 
               xlim = c(-180,180), 
               ylim = c(-56,90),
               scales = list(draw=FALSE)) +
  layer(sp.polygons(wrld_simpl, lwd = 0.5, col = 'gray50'))


png('output/png/panel_res.png', width = ncol(miss_zoo), height = nrow(miss_zoo), res = 200)
print(levelplot(miss_zoo, par.settings = myTheme, xlim=c(-180,180), ylim=c(-60,90), names.attr = letters[seq(1:6)]) +
        layer(sp.polygons(wrld_simpl, lwd = 0.5, col = 'gray50')))
dev.off()

levelplot(s0, layers = 1, par.settings = myTheme, margin = F, ylab = '', xlab = '', maxpixels = ncell(s0), xlim=c(-180,180), ylim=c(-56,90)) +
  layer(sp.polygons(wrld_simpl, lwd = 0.5, col = 'gray50'))

grid.arrange(p1, p2, p3, p4, ncol=2)

p <- levelplot(miss_zoo, layers = i,
               par.settings=myTheme,
               margin=FALSE,
               #between = list(x=0, y=0),
               xlab='',
               ylab='',
               scales=list(draw=FALSE)
)
c(p1, p2, merge.legends = T, layout = 1:2)

####

read_print('output/tif/zoonones/', 'output/png/zoonoses/', 200, myTheme)




# As we want to create one shapefile for each species, we will choose the 'BINOMIAL' vector. In that way, we first determine the names and the number of species we are using.

un = unique(data@data$BINOMIAL)


z = as.data.frame(data) %>%
  select(order_name, family_nam, binomial) %>%
  distinct() %>%
  group_by(order_name) %>%
  summarise(species = n()) %>%
  mutate(freq = species / sum(species))

mutate(percent_rank(species))



for (i in 1:length(unique)) {
  tmp <- data[data$BINOMIAL == unique[i], ] 
  writeOGR(tmp, dsn=getwd(), unique[i], driver="ESRI Shapefile",
           overwrite_layer=TRUE)
}



temp = rasterize(data_host, template, 1, fun = 'sum', silent = F, progress = 'text')
