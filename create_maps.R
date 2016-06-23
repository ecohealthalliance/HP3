library(sp)
library(rgdal)
library(stringr)
library(dplyr)
library(raster)
library(classInt)
library(rasterVis)
library(plyr)
library(maptools)


rm(list=ls())
# Load the Mammals' shapefile TERRESTRIAL_MAMMALS

unzip('~/dropbox/repos/Mammals/IUCN2013/MAMMTERR.zip', exdir = '~/Documents/hp3/data/')

terr1 = shapefile('data/Mammals_Terrestrial.shp', verbose = T)
terr@data$BINOMIAL = str_replace(terr@data$BINOMIAL, " ", "_")

# select only extant species
terr = subset(terr, PRESENCE == 1)

# Read HP3 results
# all viruses
hp3_all = read.csv('~/dropbox/tmp_dbox/gam_prediction/all_viruses_gam_predictions.csv')
hp3_all = hp3_all %>%
    mutate(pred_obs_all = prediction - TotVirusPerHost,
           pred_all = prediction) %>%
           select(-prediction, obs_all = TotVirusPerHost)

# just zoonotic viruses
hp3_zoo = read.csv('~/dropbox/tmp_dbox/gam_prediction/all_zoonoses_gam_predictions.csv')

hp3_zoo = hp3_zoo %>%
  mutate(pred_obs_zoo = prediction - NSharedWithHoSa,
         pred_zoo = prediction) %>%
  select(-prediction, -hOrder, obs_zoo = NSharedWithHoSa)


# Join tables

#terr@data = semi_join(terr@data, hp3_all, by = c("binomial" = 'hHostNameFinal'))

terr@data = data.frame(terr@data, hp3_all[match(terr@data[, "BINOMIAL"], hp3_all[, 'hHostNameFinal']),])

terr@data = data.frame(terr@data, hp3_zoo[match(terr@data[, "BINOMIAL"], hp3_zoo[, 'hHostNameFinal']),])

# Remove NA (i.e., species with no data available)
data.hp3 = terr[!is.na(terr$hHostNameFinal),]



# Auxilliary functions
# get world administrative borders. Requires maptools
data(wrld_simpl)

wrld_simpl = subset(wrld_simpl, NAME != 'Antarctica')

# Create color palette. Requires rasterVis and RColorBrewer
myTheme = rasterTheme(region = rev(brewer.pal(11, 'RdYlGn')))

# Function to create a png. xlim & ylim removes Antarctica
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


# Read .tif files from directory and create maps. Needs maptools data(wrld_simpl) to draw the global borders
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


# Function to create viral species richness maps. Resolution can be defined as 1/6

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
        tmp_pol = subset(shapefile, hOrder == j)
        print(dim(tmp_pol))
        for(i in colname){
          out_file = paste0(out_dir, j, '_', i)
          extension(out_file) = 'tif'
          print(paste('Processing', j, i, sep = ' '))
          temp0 = raster()
          temp0 = rasterize(tmp_pol, template, i, fun = 'sum', silent = F)
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
      tmp_pol = subset(shapefile, hOrder == j)
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


# Zoonoses
spp_rich_virus(data.hp3, list_vars_zoo, NULL, 1/6, 'output/tif/zoonoses/')
spp_rich_virus(data.hp3, list_vars_zoo, list_orders, 1/6, 'output/tif/zoonoses/')

# All viruses
spp_rich_virus(data.hp3, list_vars_all, NULL, 1/6, 'output/tif/all_viruses/')
spp_rich_virus(data.hp3, list_vars_all, list_orders, 1/6, 'output/tif/all_viruses/')

# Species richness maps for data in database

spp_rich_host(data.hp3, NULL, 'spp_richness', 1/6,'output/tif/host/')
spp_rich_host(data.hp3, list_orders, 'spp_richness', 1/6,'output/tif/host/')

# Species richness maps for ALL mammals

spp_rich_host(terr, NULL, 'all_spp_richness', 1/6,'output/tif/host/')
spp_rich_host(terr, list_orders, 'all_spp_richness', 1/6,'output/tif/host/')

read_print('output/tif/host/', 'output/png/host/', 200, myTheme)



# Read all viruses tif rasters and create png's.
read_print('output/tif/all_viruses/', 'output/png/all_viruses/', 200, myTheme)

# Read zoonoses tif rasters and create png's.
read_print('output/tif/zoonoses/', 'output/png/zoonoses/', 200, myTheme)



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



svglite('output/png/zoo_viruses_obs.svg')
print(levelplot(zoo_viruses_obs, layers = 1, par.settings = myTheme, margin = F, ylab = '', xlab = '', maxpixels = ncell(zoo_viruses_obs)))
dev.off()

png('output/png/zoo_viruses_pred.png', width = ncol(zoo_viruses_obs), height = nrow(zoo_viruses_obs), res = 200)
print(levelplot(zoo_viruses_pred, layers = 1, par.settings = myTheme, margin = F, ylab = '', xlab = '', maxpixels = ncell(zoo_viruses_obs)))
dev.off()

png('output/png/zoo_viruses_pred_obs.png', width = ncol(zoo_viruses_obs), height = nrow(zoo_viruses_obs), res = 200)
print(levelplot(zoo_viruses_pred_obs, layers = 1, par.settings = myTheme, margin = F, ylab = '', xlab = '', maxpixels = ncell(zoo_viruses_obs)))
dev.off()

# Create maps by order







png('output/png/zoo_RODENTIA_pred_obs.png', width = ncol(tmp_ras), height = nrow(tmp_ras), res = 200)
print(levelplot(tmp_ras, layers = 1, par.settings = myTheme, margin = F, ylab = '', xlab = '', maxpixels = ncell(tmp_ras)))
dev.off()







all_viruses_pred = rasterize(data.hp3, template, 'NShared.pfln', fun = 'sum', silent = F )

writeRaster(map.shared.pred, filename = "map_shared_pred.tif", format = "GTiff", overwrite = T)

map.res.all = rasterize(data.hp3, template, 'PredictedMinusReal', fun = 'sum', silent = F )

writeRaster(map.res.all, filename = "map_res_all.tif", format = "GTiff", overwrite = T)

map.rich = rasterize(data.hp3, template, 1, fun = 'sum', silent = F )

writeRaster(map.rich, filename = "map_richness.tif", format = "GTiff", overwrite = T)


#data.hp3 = data[data$hMassGramsLn > 0 & !is.na(data$hMassGramsLn),]


data.hp3_pos = data.hp3[data.hp3$PredictedMinusReal > 0, ]

map.res.pos = rasterize(data.hp3_pos, template, 'PredictedMinusReal', fun = 'sum', silent = F )

writeRaster(map.res.pos, filename = "map_res_pos.tif", format = "GTiff", overwrite = T)

data.hp3_neg = data.hp3[data.hp3$PredictedMinusReal < 0, ]

map.res.neg = rasterize(data.hp3_neg, template, 'PredictedMinusReal', fun = 'sum', silent = F )

writeRaster(map.res.neg, filename = "map_res_neg.tif", format = "GTiff", overwrite = T)














cl <- classIntervals(map.res.all[], style='kmeans')
cl
breaks <- cl$brks




#myTheme = rasterTheme(region = spectral)

levelplot(res_all, par.settings=myTheme)


levelplot(map1, par.settings=my, contour=TRUE)


unique.host = unique(data.hp3$BINOMIAL)


tmp <- readOGR(dsn = dire
               
               # Observe that "MAMMTERR" is an argument specific for this file we are using (it represents the layer's name). You can usually rename this argument with the name of the file you are loading.
               
               # Ok, we need to choose what we want to separate. Type:
               
               names(data)
               
               
               # Add a unique ID to
               
               curr.obs = spCbind(curr.obs, rep(3, nrow(curr.obs)))
               
               # rename the new column
               curr.obs = rename(curr.obs, c(rep.3..nrow.curr.obs.. = 'Value'))
               
               
               
               
               # As we want to create one shapefile for each species, we will choose the 'BINOMIAL' vector. In that way, we first determine the names and the number of species we are using.
               
               un = unique(data@data$BINOMIAL)
               
               
               z = as.data.frame(data) %>%
                 select(order_name, family_nam, binomial) %>%
                 distinct() %>%
                 group_by(order_name) %>%
                 summarise(species = n()) %>%
                 mutate(freq = species / sum(species))
               
               mutate(percent_rank(species))
               
               
               filter(family_nam == 'CHIROPTERA') %>%
                 n_distinct()
               
               # Finally, we use a loop to save shapefiles for each species. It will take a lot of time to generate files, so do not type this now, just observe:
               
               
               for (i in 1:length(unique)) {
                 tmp <- data[data$BINOMIAL == unique[i], ] 
                 writeOGR(tmp, dsn=getwd(), unique[i], driver="ESRI Shapefile",
                          overwrite_layer=TRUE)
               }
               