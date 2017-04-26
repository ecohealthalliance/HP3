P <- rprojroot::find_rstudio_root_file

library(magick)
hp3_orders <- c("ALL", "CARNIVORA", "CETARTIODACTYLA", "CHIROPTERA", "PRIMATES", "RODENTIA")
for(ORDER in hp3_orders) {

  image_files <- P("figures", "maps", paste0(ORDER, "_",
                                             c("viruses_observed", "viruses_predicted_max", "viruses_missing",
                                               "zoonoses_observed", "zoonoses_predicted_max", "zoonoses_missing",
                                               "hosts_observed", "hosts_predicted", "hosts_missing"),
                                             ".png"))

  my_images <- lapply(image_files, image_read)
  labeled_images <- mapply(image_annotate, image=my_images, text=letters[1:9], MoreArgs = list(font="Helvetica-Bold", location="+200+770", size=175), SIMPLIFY = FALSE)

  comb_image <- image_append(stack=TRUE, image = c(
    image_append(c(labeled_images[[1]], labeled_images[[2]], labeled_images[[3]])),
    image_append(c(labeled_images[[4]], labeled_images[[5]], labeled_images[[6]])),
    image_append(c(labeled_images[[7]], labeled_images[[8]], labeled_images[[9]]))))
  image_write(comb_image, P("figures", paste0("ExtendedFigure0", 2 + which(ORDER == hp3_orders), "-", ORDER, ".png")))
}

# missing_images <- lapply(list.files(P("figures", "maps/"), pattern =paste0("zoonoses_missing.png"), full.names = TRUE), image_read)
# labeled_images <- mapply(image_annotate, image=missing_images, text=letters[1:6], MoreArgs = list(font="Helvetica-Bold", location="+200+770", size=175), SIMPLIFY = FALSE)
# comb_image2 <- image_append(stack=TRUE, image = c(
#   image_append(c(labeled_images[[1]], labeled_images[[2]])),
#   image_append(c(labeled_images[[3]], labeled_images[[4]])),
#   image_append(c(labeled_images[[5]], labeled_images[[6]]))))
# image_write(comb_image2, P("figures", "Figure03-missing-zoo-maps.png"))


