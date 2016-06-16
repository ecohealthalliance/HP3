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

terr = shapefile('data/Mammals_Terrestrial.shp', verbose = T)
terr@data$BINOMIAL = str_replace(terr@data$BINOMIAL, " ", "_")

# select only extant areas

terr = subset(terr, PRESENCE == 1)
#al = subset(terr, BINOMIAL == 'Miniopterus_fuliginosus')

# Read HP3 results
# all viruses
hp3_all = read.csv('~/dropbox/tmp_dbox/gam_prediction/all_viruses_gam_predictions.csv')
hp3_all = mutate(hp3_all, pred_obs = prediction - TotVirusPerHost)

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

# Create richness maps
template <- raster(resolution = 1/6)

all_viruses_obs = rasterize(data.hp3, template, 'TotVirusPerHost', fun = 'sum', silent = F)
writeRaster(all_viruses_obs, filename = "all_viruses_obs.tif", format = "GTiff", overwrite = T)

all_viruses_pred = rasterize(data.hp3, template, 'prediction', fun = 'sum', silent = F, na.rm=T )
writeRaster(all_viruses_pred, filename = "all_viruses_pred.tif", format = "GTiff", overwrite = T)

all_viruses_pred_obs = rasterize(data.hp3, template, 'pred_obs', fun = 'sum', silent = F )
writeRaster(all_viruses_pred_obs, filename = "all_viruses_pred_obs.tif", format = "GTiff", overwrite = T)


# Zoonotic viruses

zoo_viruses_obs = rasterize(data.hp3, template, 'obs_zoo', fun = 'sum', silent = F)
writeRaster(zoo_viruses_obs, filename = "output/tif/zoo_viruses_obs.tif", format = "GTiff", overwrite = T)

zoo_viruses_pred = rasterize(data.hp3, template, 'pred_zoo', fun = 'sum', silent = F, na.rm=T )
writeRaster(zoo_viruses_pred, filename = "output/tif/zoo_viruses_pred.tif", format = "GTiff", overwrite = T)

zoo_viruses_pred_obs = rasterize(data.hp3, template, 'pred_obs_zoo', fun = 'sum', silent = F )
writeRaster(zoo_viruses_pred_obs, filename = "output/tif/zoo_viruses_pred_obs.tif", format = "GTiff", overwrite = T)

# Auxilliary functions
# get world administrative borders. Requires maptools
data(wrld_simpl)

# Create color palette. Requires rasterVis and RColorBrewer
myTheme = rasterTheme(region = rev(brewer.pal(11, 'RdYlGn')))

# Function to create a png. raster::trim removes Antarctica region
plot_png = function(raster, out_dir, res, theme){
  require(rasterVis)
  name = deparse(substitute(raster))
  out_file = paste0(out_dir, name, '.png')
  raster = trim(raster)
  png(out_file, width = ncol(raster), height = nrow(raster), res = res)
  print(levelplot(raster, layers = 1, par.settings = theme, margin = F, ylab = '', xlab = '', maxpixels = ncell(raster)) +
          layer(sp.polygons(wrld_simpl, lwd = 0.5, col = 'gray50')))
  dev.off()
}


# Read .tif files from directory and create maps. Needs maptools data(wrld_simpl) to draw the global borders
read_print = function(in_dir, out_dir, res, theme){
  list_tif = dir(in_dir, '.tif')
  for (i in list_tif) {
    raster = raster(paste0(in_dir, i))
    raster = trim(raster)
    out_file = paste0(out_dir, str_sub(i, 1, -4), 'png')
    png(out_file, width = ncol(raster), height = nrow(raster), res = res)
    print(levelplot(raster, layers = 1, par.settings = theme, margin = F, ylab = '', xlab = '', maxpixels = ncell(raster)) +
          layer(sp.polygons(wrld_simpl, lwd = 0.5, col = 'gray50')))
    dev.off()
    print(paste('Done!!', i))
  }
}

2
# Function to create species richness maps. in this case viral species richness. Resolution can be defined as 1/6

spp_rich = function(shapefile, colname, order = NULL, res, out_dir, ...) {
  template <- raster(resolution = res)
  if (is.null(order)){
    for(i in colname){
      out_file = paste0(out_dir, i)
      extension(out_file) = 'grd'
      print(paste('Processing', i, sep = ' '))
      temp = raster()
      temp = rasterize(shapefile, template, i, fun = 'sum', silent = F)
      writeRaster(temp, filename = out_file, format = "raster", overwrite = T, progress = 'text')
      }
    } else {
      for(j in order){
        tmp_pol = subset(shapefile, hOrder == j)
        for(i in colname){
          #tmp_pol =  subset(shapefile, hOrder == order)
          out_file = paste0(out_dir, j, '_', colname)
          extension(out_file) = 'grd'
          print(paste('Processing', j, i, sep = ' '))
          #temp = rasterize(tmp_pol, template, i, fun = 'sum', silent = F)
          #writeRaster(temp, filename = out_file, overwrite = T, progress = 'text')
          temp = raster()
          temp = rasterize(shapefile, template, i, fun = 'sum', silent = F)
          writeRaster(temp, filename = out_file, format = "raster", overwrite = T, progress = 'text')
        }
      }
    }
}



# print

plot_png(all_viruses_obs, 'output/png/all_viruses/', 200, myTheme)
plot_png(all_viruses_pred, 'output/png/all_viruses/', 200, myTheme)
plot_png(all_viruses_pred_obs, 'output/png/all_viruses/', 200, myTheme)


# Zoonotic only

list_vars_zoo = c('obs_zoo', 'pred_zoo', 'pred_obs_zoo')

list_orders = c('CARNIVORA', 'CETARTIODACTYLA', 'CHIROPTERA', 'PRIMATES', 'RODENTIA')

spp_rich(data.hp3, list_vars_zoo, NULL, 1/6, 'output/tif/zoonoses/')

spp_rich(data.hp3, list_vars_zoo, list_orders, 1/6, 'output/tif/zoonoses/')




png('output/png/zoo_viruses_obs.png', width = ncol(zoo_viruses_obs), height = nrow(zoo_viruses_obs), res = 200)
print(levelplot(zoo_viruses_obs, layers = 1, par.settings = myTheme, margin = F, ylab = '', xlab = '', maxpixels = ncell(zoo_viruses_obs)))
dev.off()

png('output/png/zoo_viruses_pred.png', width = ncol(zoo_viruses_obs), height = nrow(zoo_viruses_obs), res = 200)
print(levelplot(zoo_viruses_pred, layers = 1, par.settings = myTheme, margin = F, ylab = '', xlab = '', maxpixels = ncell(zoo_viruses_obs)))
dev.off()

png('output/png/zoo_viruses_pred_obs.png', width = ncol(zoo_viruses_obs), height = nrow(zoo_viruses_obs), res = 200)
print(levelplot(zoo_viruses_pred_obs, layers = 1, par.settings = myTheme, margin = F, ylab = '', xlab = '', maxpixels = ncell(zoo_viruses_obs)))
dev.off()

# Create maps by order

list_vars = c('TotVirusPerHost', 'prediction', 'pred_obs')

list_vars_zoo = c('obs_zoo', 'pred_zoo', 'pred_obs_zoo')

list_orders = c('CARNIVORA', 'CETARTIODACTYLA', 'CHIROPTERA', 'PRIMATES', 'RODENTIA')

list_vars_zoo = c('obs_zoo', 'pred_zoo', 'pred_obs_zoo')

i = c('RODENTIA')



for (i in list_orders) {
  tmp_pol =  subset(data.hp3, hOrder == i)
  #tmp_pol = data.hp3[data.hp3$hOrder == i,]
  for (j in list_vars_zoo){
    print(paste('Processing', i, j, sep = ' '))
    tmp_ras = rasterize(tmp_pol, template, j, fun = 'sum', silent = F )
    assign("output/png/tmp_name", paste(i, j, sep = '_'))
    png(tmp_name, width = ncol(tmp_ras), height = nrow(tmp_ras), res = 200)
    print(levelplot(tmp_ras, layers = 1, par.settings = myTheme, margin = F, ylab = '', xlab = '', maxpixels = ncell(tmp_ras)))
    dev.off()
    writeRaster(tmp_ras, tmp_name, format = "GTiff", overwrite = T)
    print(paste('Writing', tmp_name, sep = ' '))
  }
}


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
               