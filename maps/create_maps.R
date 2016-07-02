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
P <- rprojroot::find_rstudio_root_file

# Load the Mammals' shapefile TERRESTRIAL_MAMMALS, downloaded from: http://www.iucnredlist.org/technical-documents/spatial-data#mammals
if(!file.exists(P("maps/TERRESTRIAL_MAMMALS.zip"))) {
  download.file("http://spatial-data.s3.amazonaws.com/groups/TERRESTRIAL_MAMMALS.zip",
                destfile = P("maps/TERRESTRIAL_MAMMALS.zip"))
}

if(file.exists(P("maps/TERRESTRIAL_MAMMALS.zip")) &
   !dir.exists(P("maps/iucn_data"))) {
  unzip(P("maps/TERRESTRIAL_MAMMALS.zip"), exdir=P("maps/iucn_data/"))
}

terr = shapefile(P("maps/iucn_data/TERRESTRIAL_MAMMALS.shp"), verbose = T)
terr@data$binomial = str_replace(terr@data$binomial, " ", "_")

# select only extant species
terr = subset(terr, presence == 1)

# Read taxonomic information.
taxa = read_csv(P("data/IUCN_taxonomy_23JUN2016.csv")) %>%
  dplyr::select(-c(7:23), spp_ID = `Species ID`)

# Join taxonomic information to spatial data
terr@data = left_join(terr@data, taxa, by = c("id_no" = 'spp_ID'))


# Read HP3 results
# Get HP3 all virus predictions
all_viruses_gam <- readRDS(P("model_fitting/all_viruses_model.rds"))
hp3_hosts <- readRDS(P("model_fitting/postprocessed_database.rds"))$hosts
hp3_all = left_join(all_viruses_gam$model, hp3_hosts)
hp3_all = mutate(hp3_all, prediction = as.vector(unname(predict(all_viruses_gam, hp3_all, type="response"))),
                 hHostNameFinal = as.character(hHostNameFinal)) %>%
  dplyr::select(hHostNameFinal, hOrder, TotVirusPerHost, prediction) %>%
  mutate(pred_obs_all = prediction - TotVirusPerHost,
         pred_all = prediction) %>%
  dplyr::select(-prediction, -hOrder, obs_all = TotVirusPerHost)

# just zoonotic viruses
zoo_viruses_gam <- readRDS(P("model_fitting/all_zoonoses_model.rds"))
hp3_zoo = left_join(zoo_viruses_gam$model, hp3_hosts) %>%
  dplyr::rename(LnTotNumVirus=`offset(LnTotNumVirus)`)
hp3_zoo = mutate(hp3_zoo, prediction = as.vector(unname(predict(zoo_viruses_gam, hp3_zoo, type="response"))),
                 hHostNameFinal = as.character(hHostNameFinal)) %>%
  dplyr::select(hHostNameFinal, hOrder, NSharedWithHoSa, prediction) %>%
  mutate(pred_obs_zoo = prediction - NSharedWithHoSa,
         pred_zoo = prediction) %>%
  dplyr::select(-prediction, -hOrder, obs_zoo = NSharedWithHoSa)

hp3 = read_csv(P('data/hosts.csv')) %>%
  filter(hWildDomFAO == 'wild', hMarOTerr == 'Terrestrial') %>%
  dplyr::select(hHostNameFinal) %>%
  mutate(hp3 = 1)

# Create spatial polygons for all_viruses & all_zoonoses
data_hp3_all <- terr
data_hp3_zoo <- terr
data_host <- terr

# Join spatial polygons and hp3 data frames
data_hp3_all@data = full_join(data_hp3_all@data, hp3_all, by = c("binomial" = 'hHostNameFinal'))

data_hp3_zoo@data = full_join(data_hp3_zoo@data, hp3_zoo, by = c("binomial" = 'hHostNameFinal'))

data_host@data = left_join(data_host@data, hp3, by = c("binomial" = 'hHostNameFinal')) %>%
  subset(hp3 == 1)

# Remove NAs (i.e., species with no data available)
data_hp3_all@data = data_hp3_all@data[!is.na(data_hp3_all@data$obs_all),]
data_hp3_zoo@data = data_hp3_zoo@data[!is.na(data_hp3_zoo@data$obs_zoo),]

# Auxilliary functions
# get world administrative borders. Requires maptools
data(wrld_simpl)
wrld_simpl = subset(wrld_simpl, NAME != 'Antarctica')

# Create color palette. Requires rasterVis and RColorBrewer
myTheme = rasterTheme(region = rev(brewer.pal(11, 'RdYlGn')))
myTheme$fontsize$text <- 5.6
myTheme$axis.line$lwd <- 0.2

myTheme2 = RdBuTheme()
myTheme2$fontsize$text <- 5.6
myTheme2$axis.line$lwd <- 0.2

# Function to create .png maps from 'in memory' rasters. The xlim & ylim removes Antarctica
plot_png = function(raster, out_dir, res, theme){
  require(stringr)
  require(rasterVis)
  name = deparse(substitute(raster))
  out_file = paste0(out_dir, name, '.png')
  png(out_file, width = ncol(raster), height = nrow(raster), res = res, )
  print(levelplot(raster, layers = 1,
                  par.settings = theme,
                  margin = F,
                  ylab = '',
                  xlab = '',
                  scales = list(draw=FALSE),
                  maxpixels = ncell(raster),
                  xlim = c(-180, 180),
                  ylim = c(-58, 90)) +
          layer(sp.polygons(wrld_simpl, lwd = 0.5, col = 'gray50')))
  dev.off()
}

# Read .tif files from directory and create .png maps.
# Requires maptools::data(wrld_simpl) to draw the global borders
read_print = function(in_dir, out_dir, res, theme){
  require(stringr)
  require(rasterVis)
  list_tif = dir(in_dir, '.tif')
  for (i in list_tif) {
    raster = raster(paste0(in_dir, i))
    out_file = paste0(out_dir, str_sub(i, 1, -4), 'png')
    png(out_file, width = ncol(raster), height = nrow(raster), res = res)
    print(levelplot(raster, layers = 1,
                    par.settings = myTheme,
                    margin = F,
                    ylab = '',
                    xlab = '',
                    scales = list(draw=FALSE),
                    colorkey=list(width = 1,
                                  axis.text = list(fontfamily="Helvetica", fontsize=5.6)),
                    maxpixels = ncell(raster),
                    xlim = c(-180, 180),
                    ylim = c(-58, 90)) +
            layer(sp.polygons(wrld_simpl, lwd = 0.2, col = 'gray50')))
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


# Calculate residuals and write tif files

res_pred_obs = function(prediction, observed, in_dir, out_dir, file_name){
  out_file = paste0(out_dir, file_name)
  extension(out_file) = 'tif'
  cat('Processing', out_file)
  pred = raster(paste0(in_dir, prediction, '.tif'))
  obs = raster(paste0(in_dir, observed, '.tif'))
  temp = pred - obs
  writeRaster(temp, filename = out_file, format = "GTiff", overwrite = T, progress = 'text')
}

# Function to list all files in directory with a given extension
tif_path = function(directory, ext){
  list_files = dir(directory, ext)
  for(i in list_files){
    s = paste0(directory, list_files)
    return(s)
  }
}


# Function to create maps from a raster stack

png_maps = function(raster_stack, out_dir, res, theme){
  nl = nlayers(raster_stack)
  for (i in 1:nl){
    png(paste0(out_dir, names(raster_stack)[i], '.png'), width = ncol(raster_stack), height = nrow(raster_stack), res = res)
    p <- levelplot(raster_stack, layers = i,
                   par.settings = myTheme2,
                   margin = F,
                   ylab = '',
                   xlab = '',
                   scales = list(draw=FALSE),
                   colorkey=list(width = 1,
                                 axis.text = list(fontfamily="Helvetica", fontsize=5.6)),
                   maxpixels = ncell(raster_stack),
                   xlim = c(-180, 180),
                   ylim = c(-58, 90)) +
      layer(sp.polygons(wrld_simpl, lwd = 0.2,
                        col = 'gray50'))
    print(p)
    cat('Printed', names(raster_stack)[i], sep="\n")
    dev.off()
  }
}

##########
# Generate .tif files for all mammals and by order
list_vars_all = c('obs_all', 'pred_all', 'pred_obs_all')
list_vars_zoo = c('obs_zoo', 'pred_zoo', 'pred_obs_zoo')
list_orders = c('CARNIVORA', 'CETARTIODACTYLA', 'CHIROPTERA', 'PRIMATES', 'RODENTIA')

# Create all_viruses .tif rasters
spp_rich_virus(data_hp3_all, list_vars_all, NULL, 1/6, P('maps/output/tif/all_viruses/'))
spp_rich_virus(data_hp3_all, list_vars_all, list_orders, 1/6, P('maps/output/tif/all_viruses/'))

# Create all_zoonoses .tif rasters
spp_rich_virus(data_hp3_zoo, list_vars_zoo, NULL, 1/6, P('maps/output/tif/zoonoses/'))
spp_rich_virus(data_hp3_zoo, list_vars_zoo, list_orders, 1/6, P('maps/output/tif/zoonoses/'))

# Species richness .tif files for species in HP3 database
spp_rich_host(data_hp3_all, NULL, 'hp3_viruses', 1/6, P('maps/output/tif/host/'))
spp_rich_host(data_hp3_all, list_orders, 'hp3_viruses', 1/6, P('maps/output/tif/host/'))

# Species richness maps for ALL mammals
spp_rich_host(terr, NULL, 'all_mammals', 1/6, P('maps/output/tif/host/'))
spp_rich_host(terr, list_orders, 'all_mammals', 1/6, P('maps/output/tif/host/'))

# Generate beatiful maps
# Read all_viruses .tif rasters and create .png maps.
read_print(P('maps/output/tif/all_viruses/'), P('maps/output/png/all_viruses/'), 900, myTheme)

# Read all_zoonoses .tif rasters and create .png maps.
read_print(P('maps/output/tif/zoonoses/'), P('maps/output/png/zoonoses/'), 900, myTheme)

# Read all host .tif rasters and create .png maps
read_print(P('maps/output/tif/host/'), P('maps/output/png/host/'), 900, rev(myTheme))


# Calculate residuals (pred - obs) for mammals vs hp3 mammals data
res_pred_obs('CARNIVORA_hp3_viruses', 'CARNIVORA_hosts', P('maps/output/tif/host/'), P('maps/output/tif/host/'), 'CARNIVORA_pred_obs_richness' )
res_pred_obs('RODENTIA_hp3_viruses', 'RODENTIA_hosts', P('maps/output/tif/host/'), P('maps/output/tif/host/'), 'RODENTIA_pred_obs_richness' )
res_pred_obs('CHIROPTERA_hp3_viruses', 'CHIROPTERA_hosts', P('maps/output/tif/host/'), P('maps/output/tif/host/'), 'CHIROPTERA_pred_obs_richness' )
res_pred_obs('CETARTIODACTYLA_hp3_viruses', 'CETARTIODACTYLA_hosts', P('maps/output/tif/host/'), P('maps/output/tif/host/'), 'CETARTIODACTYLA_pred_obs_richness' )
res_pred_obs('PRIMATES_hp3_viruses', 'PRIMATES_hosts', P('maps/output/tif/host/'), P('maps/output/tif/host/'), 'PRIMATES_pred_obs_richness' )
res_pred_obs('hp3_viruses', 'hp3', P('maps/output/tif/host/'), P('maps/output/tif/host/'), 'mammals_pred_obs_richness' )

# get list of files with .tif extension
mammals = tif_path(P('maps/output/tif/host/'), 'tif')

# Create raster stack for those files that onclude the words 'pred_obs'
mammals = stack(str_subset(mammals, 'pred_obs'))


# Create residual maps for species with different color palette
png_maps(mammals, P('maps/output/png/host/'), 900,  MyTheme2)

