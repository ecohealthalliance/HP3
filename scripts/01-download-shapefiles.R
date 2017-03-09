#Download shapefiles which are stored on S3, which are too large to store in git
P <- rprojroot::find_rstudio_root_file

shapefiles <- c("Mammals_Terrestrial", "mam", "host_zg_area")

lapply(shapefiles, function(shapefile) {
  download.file(paste0("https://s3.amazonaws.com/hp3-shapefiles/", shapefile, ".zip"),
                destfile = P("shapefiles", paste0(shapefile, ".zip")))
  unzip(P("shapefiles", paste0(shapefile, ".zip")),
        exdir = "shapefiles")
  unlink(paste0(P("shapefiles", "shapefile", ".zip")))
})


