library(tidyverse)
library(stringr)
library(sp)
library(rgdal)
library(raster)
library(classInt)
library(rasterVis)
library(maptools)
library(mgcv)
library(parallel)


P <- rprojroot::find_rstudio_root_file

# Load the Mammals' shapefile TERRESTRIAL_MAMMALS, downloaded from: http://www.iucnredlist.org/technical-documents/spatial-data#mammals
# This study uses version 2015-2, which we provide via Amazon S3 storage.
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

# select only extant species
terr = subset(terr, PRESENCE == 1)

# Read taxonomic information.
taxa = read_csv(P("data/IUCN_taxonomy_23JUN2016.csv")) %>%
  dplyr::select(-c(7:23), spp_ID = `Species ID`)

# Join taxonomic information to spatial data
terr@data = left_join(terr@data, taxa, by = c("ID_NO" = 'spp_ID'))

hp3_orders = c('CARNIVORA', 'CETARTIODACTYLA', 'CHIROPTERA', 'PRIMATES', 'RODENTIA')
# Read HP3 results
# Get HP3 all virus predictions
all_viruses_gam <- readRDS(P("model_fitting/all_viruses_model.rds"))
hp3_hosts <- readRDS(P("model_fitting/postprocessed_database.rds"))$hosts
hp3_all = as_tibble(left_join(all_viruses_gam$model, hp3_hosts))
hp3_all_pred = within(hp3_all, {hDiseaseZACitesLn = max(hDiseaseZACitesLn)})
hp3_all = mutate(hp3_all,
                 observed = TotVirusPerHost,
                 predicted = as.vector(unname(predict(all_viruses_gam, hp3_all, type="response"))),
                 predicted_max = as.vector(unname(predict(all_viruses_gam, hp3_all_pred, type="response"))),
                 resid = predicted - observed,
                 missing = predicted_max - observed,
                 hHostNameFinal = as.character(hHostNameFinal))

# just zoonotic viruses
zoo_viruses_gam <- readRDS(P("model_fitting/all_zoonoses_model.rds"))
hp3_zoo = left_join(zoo_viruses_gam$model, hp3_hosts) %>%
  left_join(dplyr::select(hp3_all, hHostNameFinal, predicted_max)) %>%
  dplyr::rename(vir_prediction_max = predicted_max) %>%
  as_tibble()
hp3_zoo_pred =  within(hp3_zoo, {hDiseaseZACites = max(hDiseaseZACites)
LnTotNumVirus = log(vir_prediction_max)})

hp3_zoo = mutate(hp3_zoo,
                 observed = NSharedWithHoSa,
                 predicted = as.vector(unname(predict(zoo_viruses_gam, hp3_zoo, type="response"))),
                 predicted_max = as.vector(unname(predict(zoo_viruses_gam, hp3_zoo_pred, type="response"))),
                 resid = predicted - observed,
                 missing = predicted_max - observed,
                 hHostNameFinal = as.character(hHostNameFinal))


hp3_hosts = read_csv(P('data/hosts.csv')) %>%
  filter(hWildDomFAO == 'wild', hMarOTerr == 'Terrestrial') %>%
  dplyr::select(hHostNameFinal) %>%
  mutate(hp3 = 1)


# Create spatial polygons for all_viruses & all_zoonoses
data_hp3_all <- terr
data_hp3_zoo <- terr
data_host <- terr

# Join spatial polygons and hp3 data frames
data_hp3_all@data = full_join(data_hp3_all@data, hp3_all, by = c("BINOMIAL" = 'hHostNameFinal')) %>%
  mutate(order_group = if_else(Order %in% hp3_orders, Order, "OTHER"))

data_hp3_zoo@data = full_join(data_hp3_zoo@data, hp3_zoo, by = c("BINOMIAL" = 'hHostNameFinal')) %>%
  mutate(order_group = if_else(Order %in% hp3_orders, Order, "OTHER"))

data_host@data <- left_join(data_host@data, hp3_hosts, by = c("BINOMIAL" = 'hHostNameFinal')) %>%
  mutate(observed = hp3) %>%
  mutate(predicted = 1) %>%
  mutate(missing = if_else(is.na(hp3) & predicted == 1, 1, 0)) %>%
  mutate(order_group = if_else(Order %in% hp3_orders, Order, "OTHER"))

# Remove NAs (i.e., species with no data available)
data_hp3_all = data_hp3_all[!is.na(data_hp3_all$observed),]
data_hp3_zoo = data_hp3_zoo[!is.na(data_hp3_zoo$observed),]
# Auxilliary functions


# Create color palette. Requires rasterVis and RColorBrewer
myTheme = rasterTheme(region = rev(brewer.pal(11, 'RdYlGn')))
myTheme$fontsize$text <- 5.6
myTheme$axis.line$lwd <- 0.2

myTheme2 = RdBuTheme()
myTheme2$fontsize$text <- 5.6
myTheme2$axis.line$lwd <- 0.2

myTheme3 <- rasterTheme(region = viridis::viridis(11))
myTheme3$fontsize$text <- 5.6
myTheme3$axis.line$lwd <- 0.2

data(wrld_simpl)
wrld_simpl = subset(wrld_simpl, NAME != 'Antarctica')
world_layer <- layer(sp.polygons(wrld_simpl, lwd=0.2, col='gray50'))

make_map <- function(model, orders, data_type, colors, filename, raster_res, png_res) {
  if(model == 'hosts') {
    sp_data_frame = data_host
  } else if (model == 'zoonoses') {
    sp_data_frame = data_hp3_zoo
  } else if (model == 'viruses') {
    sp_data_frame = data_hp3_all
  }
  if(colors == "redgreen") {
    theme = myTheme
  } else {
    theme = myTheme2
  }
  template <- raster(resolution = raster_res)
  subsetted_shapes <- subset(sp_data_frame, (order_group %in% orders))
  my_raster = raster()
  my_raster = rasterize(subsetted_shapes, template, data_type, fun = 'sum', silent = TRUE)
  #make_png(my_raster, theme, filename, png_res)
  return(my_raster)
}

make_png <- function(my_raster, theme, filename, png_res) {
  png(filename, width = ncol(my_raster), height = nrow(my_raster), res = png_res)
  print(levelplot(my_raster, layers = 1,
                  par.settings = theme,
                  margin = FALSE,
                  ylab = '',
                  xlab = '',
                  scales = list(draw=FALSE),
                  colorkey=list(width = 1,
                                axis.text = list(fontfamily="Helvetica", fontsize=5.6)),
                  maxpixels = ncell(my_raster),
                  xlim = c(-180, 180),
                  ylim = c(-58, 90)) +
          world_layer)
  dev.off()
}

rasters = crossing(orders=c(hp3_orders,"OTHER"),
                   model=c('hosts', 'zoonoses', 'viruses'),
                   data_type = c('observed', 'predicted', 'missing', 'resid')
) %>%
  filter(!(model == 'hosts' & data_type == 'resid')) %>%
  mutate(colors = if_else(data_type %in% c("missing", "resid"), "bluered", "redgreen")) %>%
  mutate(filename = paste0(orders, "_", model, "_", data_type, ".png")) %>%
  mutate(raster_res = 1/6, png_res=900)

# rs <- make_map(
#   model = rasters$model[1],
#   orders = rasters$orders[1],
#   data_type = rasters$data_type[1],
#   colors = rasters$colors[1],
#   filename=P("maps", "output", rasters$filename)[1],
#   raster_res = 100/60,
#   png_res = rasters$png_res
# )
start_time <- Sys.time()
rasters$raster <- mcmapply(make_map,
                          model = rasters$model,
                          orders = rasters$orders,
                          data_type = rasters$data_type,
                          colors = rasters$colors,
                          filename=P("maps", "output", rasters$filename),
                          raster_res = rasters$raster_res,
                          png_res = rasters$png_res,
                          mc.preschedule = FALSE, mc.cores = 20, mc.silent= TRUE)
stop_time <- Sys.time()

print(stop_time - start_time)
capture.output(print(stop_time - start_time), file="time_elapsed.txt")
saveRDS(rasters, "rasters.rds")
 rasters <- readRDS("rasters.rds")

# rasters %>%
#   group_by(model, data_type) %>%
#   do({
#     new_row = .[1,]
#     new_rows$orders <- "ALL"
#     new_row$Raster = Reduce
#     bind_rows(.,
#               )
#   })
#  #
# bias_raster = rasters$raster[[11]]/rasters$raster[[10]]
# plot(bias_raster)
#
#
# miat = seq(from=-1, to=1, by = 0.25)
# make_png_pct <- function(my_raster, theme, filename, png_res) {
#   png(filename, width = ncol(my_raster), height = nrow(my_raster), res = png_res)
#   print(levelplot(my_raster, layers = 1,
#                   par.settings = theme,
#                   margin = FALSE,
#                   ylab = '',
#                   xlab = '',
#                   scales = list(draw=FALSE),
#                   colorkey=list(width = 1,
#                                 axis.text = list(fontfamily="Helvetica", fontsize=5.6),
#                                 labels = scales::percent_format()(miat),
#                                 at = miat + 0.125),
#                   at = miat,
#                   maxpixels = ncell(my_raster),
#                   xlim = c(-180, 180),
#                   ylim = c(-58, 90)) +
#           world_layer)
#   dev.off()
# }
#
# make_png_pct(bias_raster,theme = myTheme3, filename = "bias_test.png", png_res = 900)
# Function to create .png maps from 'in memory' rasters. The xlim & ylim removes Antarctica
#
# plot_png = function(raster, out_dir, res, theme){
#   name = deparse(substitute(raster))
#   out_file = paste0(out_dir, name, '.png')
#   png(out_file, width = ncol(raster), height = nrow(raster), res = res)
#   print(levelplot(raster, layers = 1,
#                   par.settings = theme,
#                   margin = F,
#                   ylab = '',
#                   xlab = '',
#                   scales = list(draw=FALSE),
#                   maxpixels = ncell(raster),
#                   xlim = c(-180, 180),
#                   ylim = c(-58, 90)) +?
#           layer(sp.polygons(wrld_simpl, lwd = 0.5, col = 'gray50')))
#   dev.off()
# }
#
# # Read .tif files from directory and create .png maps.
# # Requires maptools::data(wrld_simpl) to draw the global borders
# read_print = function(in_dir, out_dir, res, theme){
#
#   list_tif = dir(in_dir, '.tif')
#   for (i in list_tif) {
#     raster = raster(paste0(in_dir, i))
#     out_file = paste0(out_dir, str_sub(i, 1, -4), 'png')
#     png(out_file, width = ncol(raster), height = nrow(raster), res = res)
#     print(levelplot(raster, layers = 1,
#                     par.settings = myTheme,
#                     margin = F,
#                     ylab = '',
#                     xlab = '',
#                     scales = list(draw=FALSE),
#                     colorkey=list(width = 1,
#                                   axis.text = list(fontfamily="Helvetica", fontsize=5.6)),
#                     maxpixels = ncell(raster),
#                     xlim = c(-180, 180),
#                     ylim = c(-58, 90)) +
#             layer(sp.polygons(wrld_simpl, lwd = 0.2, col = 'gray50')))
#     dev.off()
#     print(paste('Done!!', i))
#   }
# }
#
#
# # Function to create the missing zoonoses maps. Resolution can be defined as 1/6
# spp_rich_virus = function(shapefile, colname, order = NULL, res, out_dir, ...) {
#   template <- raster(resolution = res)
#   if (is.null(order)){
#     for(i in colname){
#       out_file = paste0(out_dir, i)
#       extension(out_file) = 'tif'
#       print(paste('Processing', i, sep = ' '))
#       temp = raster()
#       temp = rasterize(shapefile, template, i, fun = 'sum', silent = F, progress = 'text')
#       writeRaster(temp, filename = out_file, format = "GTiff", overwrite = T, progress = 'text')
#     }
#   } else {
#     template <- raster(resolution = res)
#     for(j in order){
#       tmp_pol = subset(shapefile, Order == j)
#       print(dim(tmp_pol))
#       for(i in colname){
#         out_file = paste0(out_dir, j, '_', i)
#         extension(out_file) = 'tif'
#         print(paste('Processing', j, i, sep = ' '))
#         temp0 = raster()
#         temp0 = rasterize(tmp_pol, template, i, fun = 'sum', silent = F, progress ='text')
#         writeRaster(temp0, filename = out_file, format = "GTiff", overwrite = T, progress = 'text')
#       }
#     }
#   }
# }
#
#
# # Function to calculate host species richness
#
# spp_rich_host = function(shapefile, order = NULL, file_name, res, out_dir, ...) {
#   require(rgdal)
#   template <- raster(resolution = res)
#   if (is.null(order)){
#     out_file = paste0(out_dir, file_name)
#     extension(out_file) = 'tif'
#     print(paste('Processing ALL mammals'))
#     temp = raster()
#     temp = rasterize(shapefile, template, 1, fun = 'sum', silent = F, progress = 'text')
#     writeRaster(temp, filename = out_file, format = "GTiff", overwrite = T, progress = 'text')
#   } else {
#     mclapply(colname, function(j) {
#       tmp_pol = subset(shapefile, Order == j)
#       print(dim(tmp_pol))
#       out_file = paste0(out_dir, j, '_', file_name)
#       extension(out_file) = 'tif'
#       print(paste('Processing just', j, sep = ' '))
#       temp0 = raster()
#       temp0 = rasterize(tmp_pol, template, 1, fun = 'sum', silent = F, progress = 'text')
#       writeRaster(temp0, filename = out_file, format = "GTiff", overwrite = T, progress = 'text')
#       return(NULL)
#     })
#   }
#   return(invisible(NULL))
# }
#
#
# # Calculate residuals and write tif files
#
# res_pred_obs = function(prediction, observed, in_dir, out_dir, file_name){
#   out_file = paste0(out_dir, file_name)
#   extension(out_file) = 'tif'
#   cat('Processing', out_file)
#   pred = raster(paste0(in_dir, prediction, '.tif'))
#   obs = raster(paste0(in_dir, observed, '.tif'))
#   temp = pred - obs
#   writeRaster(temp, filename = out_file, format = "GTiff", overwrite = T, progress = 'text')
# }
#
# # Function to list all files in directory with a given extension
# tif_path = function(directory, ext){
#   list_files = dir(directory, ext)
#   for(i in list_files){
#     s = paste0(directory, list_files)
#     return(s)
#   }
# }
#
#
# # Function to create maps from a raster stack
#
# png_maps = function(raster_stack, out_dir, res, theme){
#   nl = nlayers(raster_stack)
#   mclapply(1:nl, function(i) {
#     png(paste0(out_dir, names(raster_stack)[i], '.png'), width = ncol(raster_stack), height = nrow(raster_stack), res = res)
#     p <- levelplot(raster_stack, layers = i,
#                    par.settings = myTheme2,
#                    margin = F,
#                    ylab = '',
#                    xlab = '',
#                    scales = list(draw=FALSE),
#                    colorkey=list(width = 1,
#                                  axis.text = list(fontfamily="Helvetica", fontsize=5.6)),
#                    maxpixels = ncell(raster_stack),
#                    xlim = c(-180, 180),
#                    ylim = c(-58, 90)) +
#       layer(sp.polygons(wrld_simpl, lwd = 0.2,
#                         col = 'gray50'))
#     print(p)
#     # cat('Printed', names(raster_stack)[i], sep="\n")
#     dev.off()
#   })
# }
#
# ##########
# # Generate .tif files for all mammals and by order
# beginCluster(n = 40)
#
# list_vars_all = c('obs_all', 'pred_all', 'pred_obs_all')
# list_vars_zoo = c('obs_zoo', 'pred_zoo', 'pred_obs_zoo')
# list_orders = c('CARNIVORA', 'CETARTIODACTYLA', 'CHIROPTERA', 'PRIMATES', 'RODENTIA')
#
# group1 <- alist(
#   # Create all_viruses .tif rasters
#   spp_rich_virus(data_hp3_all, list_vars_all, NULL, 1/6, P('maps/output/tif/all_viruses/')),
#   spp_rich_virus(data_hp3_all, list_vars_all, list_orders, 1/6, P('maps/output/tif/all_viruses/')),
#
#   # Create all_zoonoses .tif rasters
#   spp_rich_virus(data_hp3_zoo, list_vars_zoo, NULL, 1/6, P('maps/output/tif/zoonoses/')),
#   spp_rich_virus(data_hp3_zoo, list_vars_zoo, list_orders, 1/6, P('maps/output/tif/zoonoses/'))
# )
#
# mclapply(group1, eval, mc.allow.recursive = TRUE)
#
# group2 <- alist(
#   # Species richness .tif files for species in HP3 database
#   spp_rich_host(data_hp3_all, NULL, 'hp3_viruses', 1/6, P('maps/output/tif/host/')),
#   spp_rich_host(data_hp3_all, list_orders, 'hp3_viruses', 1/6, P('maps/output/tif/host/')),
#
#   # Species richness maps for ALL mammals
#   spp_rich_host(terr, NULL, 'all_mammals', 1/6, P('maps/output/tif/host/')),
#   spp_rich_host(terr, list_orders, 'all_mammals', 1/6, P('maps/output/tif/host/'))
# )
#
# mclapply(group2, eval, mc.allow.recursive = TRUE)
# # Generate beatiful maps
# # Read all_viruses .tif rasters and create .png maps.
# read_print(P('maps/output/tif/all_viruses/'), P('maps/output/png/all_viruses/'), 900, myTheme)
#
# # Read all_zoonoses .tif rasters and create .png maps.
# read_print(P('maps/output/tif/zoonoses/'), P('maps/output/png/zoonoses/'), 900, myTheme)
#
# # Read all host .tif rasters and create .png maps
# read_print(P('maps/output/tif/host/'), P('maps/output/png/host/'), 900, rev(myTheme))
#
#
# #Calculate residuals (pred - obs) for mammals vs hp3 mammals data
#
# group3 <- alist(
#   res_pred_obs('CARNIVORA_hp3_viruses', 'CARNIVORA_all_mammals', P('maps/output/tif/host/'), P('maps/output/tif/host/'), 'CARNIVORA_pred_obs_richness' ),
#   res_pred_obs('RODENTIA_hp3_viruses', 'RODENTIA_all_mammals', P('maps/output/tif/host/'), P('maps/output/tif/host/'), 'RODENTIA_pred_obs_richness' ),
#   res_pred_obs('CHIROPTERA_hp3_viruses', 'CHIROPTERA_all_mammals', P('maps/output/tif/host/'), P('maps/output/tif/host/'), 'CHIROPTERA_pred_obs_richness' ),
#   res_pred_obs('CETARTIODACTYLA_hp3_viruses', 'CETARTIODACTYLA_all_mammals', P('maps/output/tif/host/'), P('maps/output/tif/host/'), 'CETARTIODACTYLA_pred_obs_richness' ),
#   res_pred_obs('PRIMATES_hp3_viruses', 'PRIMATES_all_mammals', P('maps/output/tif/host/'), P('maps/output/tif/host/'), 'PRIMATES_pred_obs_richness' ),
#   res_pred_obs('hp3_viruses', 'all_mammals', P('maps/output/tif/host/'), P('maps/output/tif/host/'), 'mammals_pred_obs_richness' )
# )
# mclapply(group3, eval)
# # get list of files with .tif extension
# mammals = tif_path(P('maps/output/tif/host/'), 'tif')
#
# # Create raster stack for those files that onclude the words 'pred_obs'
# mammals = stack(str_subset(mammals, 'pred_obs'))
#
#
# # Create residual maps for species with different color palette
# png_maps(mammals, P('maps/output/png/host/'), 900,  MyTheme2)
#
