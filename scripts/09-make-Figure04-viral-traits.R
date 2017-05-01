library(ggplot2)
library(tidyr)
library(purrr)
library(stringi)
library(cowplot)
library(viridis)
library(dplyr)
library(svglite)
library(mgcv)
library(magrittr)
set.seed(0)
P <- rprojroot::find_rstudio_root_file
source(P("R", "relative_contributions.R"))

partials_theme = theme(text = element_text(family="Helvetica", size=9),
                       panel.border=element_blank(),
                       panel.background=element_blank(),
                       #   axis.title.y = element_blank(),
                       panel.grid = element_blank(),
                       axis.ticks.x = element_line(size=0.3),
                       axis.ticks.y = element_blank(),
                       axis.text.y = element_text(color="black"),
                       axis.title.x = element_text(lineheight=1.2),
                       legend.position="none")

bgam = readRDS(P("intermediates", "vtraits_models.rds"))$model[[1]]
viruses <- readRDS(P("intermediates", "postprocessed_database.rds"))$viruses

de_bgam =  get_relative_contribs(bgam) %>%
  mutate(dev_explained = rel_deviance_explained * summary(bgam)$dev.expl) %>%
  mutate(dev_explained = paste0(stri_trim_both(formatC(dev_explained*100, format = "fg", digits=2)), "%"))


binary_vars = c("Envelope", "vCytoReplicTF", "Vector")

preds <- predict(bgam, type="iterms", se.fit=TRUE)
intercept <- attributes(preds)$constant

preds = preds %>% map(as.data.frame) %>%
  map(~setNames(., stri_replace_first_regex(names(.) ,"s\\(([^\\)]+)\\)", "$1")))
model_data = bgam$model
gterms = attributes(terms(bgam))
ilfun <- bgam$family$linkinv
lfun <- bgam$family$linkfun

binary_terms = which(stri_detect_regex(names(model_data), paste0("(", paste0(binary_vars, collapse="|"), ")")))

smooth_data = model_data[, -c(binary_terms, gterms$response, gterms$offset)]
smooth_ranges = dmap(smooth_data, ~seq(min(.), max(.), length.out = 100))

binary_data = model_data[, binary_terms, drop=FALSE]
binary_ranges = setNames(as.data.frame(diag(length(binary_terms))), names(model_data)[binary_terms])

offset_name = stri_replace_first_regex(names(model_data)[gterms$offset], "offset\\(([^\\)]+)\\)", "$1")

smooth_ranges = cbind(smooth_ranges,
                      setNames(as.data.frame(lapply(c(names(binary_data), offset_name), function(x) rep(0, nrow(smooth_ranges)))), c(names(binary_data), offset_name)))
binary_ranges = cbind(binary_ranges,
                      setNames(as.data.frame(lapply(c(names(smooth_data), offset_name), function(x) rep(0, nrow(binary_ranges)))), c(names(smooth_data), offset_name)))

smooth_preds <- predict(bgam, newdata=smooth_ranges, type="iterms", se.fit=TRUE)  %>% map(as.data.frame) %>%
  map(~setNames(., stri_replace_first_regex(names(.) ,"s\\(([^\\)]+)\\)", "$1")))
binary_preds <- predict(bgam, newdata=binary_ranges, type="iterms", se.fit=TRUE) %>% map(as.data.frame) %>%
  map(~setNames(., stri_replace_first_regex(names(.) ,"s\\(([^\\)]+)\\)", "$1")))

partials <- as.data.frame(lapply(1:ncol(preds$fit), function(cl) {
  x = bgam$residuals - rowSums(preds$fit[,-cl]) - intercept
  # (rowSums(preds$fit[,-cl]))
  # x = (lfun(model_data[[gterms$response]]) - model_data[[gterms$offset]])
  #  x = model_data[[gterms$response]]
  x
}))
names(partials) <- names(preds$fit)

smooth_titles = c("max phylogenetic\nhost breadth (log)", "genome length (log)", "PubMed citations (log)")
names(smooth_titles) = names(smooth_data)
smooth_plots = map(names(smooth_data), function(smooth_term) {
  pl =  ggplot() +
    #  geom_hline(yintercept = (intercept), size=0.5, col="red") +
    geom_hline(yintercept = 0, size=0.1, col="grey50") +
    geom_point(mapping = aes(x=model_data[[smooth_term]], y = (partials[[smooth_term]])),
               shape=21, fill=viridis(4)[1], col="black", alpha=0.25, size=1.25, stroke=0.3) +
    geom_ribbon(mapping = aes(x = smooth_ranges[[smooth_term]],
                              ymin = (smooth_preds$fit[[smooth_term]] - 2 * smooth_preds$se.fit[[smooth_term]]),
                              ymax = (smooth_preds$fit[[smooth_term]] + 2 * smooth_preds$se.fit[[smooth_term]])),
                alpha = 0.75, fill=ifelse(smooth_term=="vGenomeAveLengthLn", "grey", viridis(5)[4])) +
    geom_line(mapping = aes(x = smooth_ranges[[smooth_term]], y = (smooth_preds$fit[[smooth_term]])), size=0.3) +
#    annotate("label", x = max(model_data[[smooth_term]]), y = -7.5, label = paste0("DE = ", de_bgam$dev_explained[de_bgam$term == smooth_term]), hjust = 1, size=1.5,  label.size=0, fill="#FFFFFF8C") +
    #  geom_rug(mapping = aes(x =model_data[[smooth_term]]), alpha=0.3) +
    xlab(smooth_titles[smooth_term]) +
    scale_y_continuous(limits=c(-10,10), oob=scales::rescale_none) +
    theme_bw() + partials_theme
  return(pl)

})

smooth_plots[[1]] = smooth_plots[[1]] + ylab("")
smooth_plots[[2]] = smooth_plots[[2]] + ylab("")
smooth_plots[[3]] = smooth_plots[[3]] + ylab("Strength of Effect")
bin_data = binary_preds %>% map(function(x) {
  x = x[, stri_detect_regex(names(x), paste0("(", paste0(binary_vars, collapse="|"), ")")), drop=FALSE]
  n = names(x)
  x = rowSums(x)
  data_frame(response=x, variable=n)
})



bin_data$fit$se = bin_data$se.fit$response
bin_data = bin_data$fit
bin_data$response = bin_data$response
bin_data$labels = c(" envelope", "cytoplasmic \nreplication ", "vector- \nborne ")
#bin_data$labels = stri_replace_first_regex(bin_data$labels, "hHuntedIUCN", "Hunted")
bin_data$signif = summary(bgam)$s.table[stri_detect_regex(rownames(summary(bgam)$s.table), paste0("(", paste0(binary_vars, collapse="|"), ")")), "p-value"] < 0.05
bin_data = bin_data %>%
  arrange(desc(signif), response) %>%
  mutate(no = 1:nrow(bin_data))

bin_partials = lapply(binary_terms, function(x) {
  vals = partials[as.logical(model_data[[x]]), x-1]
  variable = names(model_data)[x]
  data_frame(variable=variable, partial=vals, no=bin_data$no[bin_data$variable == variable])
}) %>% bind_rows

bin_partials %<>%
  filter(variable %in% bin_data$variable[bin_data$signif])
bin_data %<>%
  filter(signif) %>%
  left_join(de_bgam, by=c('variable'='term'))


bin_plot = ggplot() +
  geom_hline(yintercept = 0, size=0.1, col="grey50") +
  geom_point(data=bin_partials, mapping=aes(x=no, y=(partial)), position=position_jitter(width=0.35), shape=21, fill=viridis(4)[1], col="black", alpha=0.25, size=1.25, stroke=0.3) +
  geom_rect(data = bin_data, mapping=aes(xmin = no - 0.45, xmax  = no + 0.45, ymin=(response-2*se), ymax=(response+2*se)), fill = viridis(5)[4], alpha = 0.75) +
  geom_segment(data = bin_data, mapping=aes(x=no - 0.45, xend = no + 0.45, y=(response), yend=(response)), col="black", size=0.3) +
#  geom_label(data = bin_data, mapping=aes(x=no, y = response + 2*se + 4, label=paste0("DE = ", dev_explained)), color="black", family="Lato", size=1.5, label.size=0, fill="#FFFFFF8C") +
  # geom_text(data = bin_data, mapping=aes(x=no, y=(response+se) + 0.1 , label = labels), color="black", family="Lato", size=3, angle =90, hjust=0, vjust =0.5) +
  #scale_fill_manual(breaks = c(FALSE, TRUE), values=c("grey", viridis(5)[4])) +
  scale_x_continuous(breaks = bin_data$no, labels = bin_data$labels) +
  scale_y_continuous(limits=c(-10,10), oob=scales::rescale_none, name="") +
  partials_theme + theme(axis.title.x=element_blank(), axis.ticks.x=element_blank(),
                         axis.text.x = element_text(color="black", lineheight = 1.2,
                                                    vjust=0.5, margin=margin(t=0), family="Helvetica", size=9),
                         axis.text.y = element_text(family="Helvetica", size=5.6),
                         panel.border = element_blank(), axis.line.x=element_blank(), axis.line.y=element_blank(),
                         panel.background = element_rect(fill = "transparent", colour = NA),
                         plot.background = element_rect(fill = "transparent", colour = NA))


#svglite(file="rplot.svg", width = convertr::convert(113, "mm", "in"), convertr::convert(180, "mm", "in"), pointsize=7)

vir_plotdata = viruses %>%
  filter(!is.na(vFamily), vFamily != "Unassigned") %>%
  mutate(st_dist_noHoSa_max2 = ifelse(IsHoSa & !IsZoonotic, NA, st_dist_noHoSa_max)) %>%
  group_by(vFamily) %>%
  mutate(prop_fam_zoonotic = sum(IsZoonotic) / n(),
         arr = max(st_dist_noHoSa_max2, na.rm=TRUE),
         n_in_fam = n()) %>%
  group_by() %>%
  mutate(vHostType = ifelse(IsHoSa & IsZoonotic, "Zoonotic", ifelse(IsHoSa, "Human Only", "Non-Human Only"))) %>%
  mutate(st_dist_noHoSa_max = ifelse(is.na(st_dist_noHoSa_max), 0, st_dist_noHoSa_max)) %>%
  arrange(prop_fam_zoonotic) %>%
  mutate(vFamily = factor(vFamily, unique(vFamily))) %>%
  droplevels() %>%
  mutate(jitter_fams= as.numeric(vFamily) + (rnorm(n(), mean=0, sd=0.075))*as.numeric(n_in_fam != 1))

famnames = vir_plotdata %>%
  group_by(vFamily) %>%
  summarize(Family = vFamily[1],
            labloc = max(st_dist_noHoSa_max, na.rm=TRUE) + 10)

n_families = length(levels(vir_plotdata$vFamily))
jitter_vals = rnorm(nrow(vir_plotdata), mean=0, sd=0.1)

legendpts = data_frame(fill=c(viridis(5)[5], viridis(5)[4], "#1F7DDC"), x = 2:4 + 0.4, y = rep(233,3), vFamily = 1,
                       label = c("Human", "Non-human", "Zoonotic"))

vir_fam_plot = ggplot(vir_plotdata, aes(x=as.numeric(vFamily) + jitter_vals, y=st_dist_noHoSa_max, group=vFamily)) +
  annotate("rect", xmin=1.7, xmax=5, ymin=217, ymax=349, fill=NA, col="black", size=.1) +
  geom_boxplot(mapping=aes(fill=prop_fam_zoonotic, x=as.numeric(vFamily), y=st_dist_noHoSa_max2), outlier.shape=NA, width=0.7, size=0.3) +
  geom_point(mapping=aes(col=vHostType, x = jitter_fams), shape=21, size = 1.25, fill="#1F7DDC", col="black", stroke=0.3,
             data = filter(vir_plotdata, vHostType == "Non-Human Only")) +
  geom_point(mapping=aes(col=vHostType, x = jitter_fams), shape=21, size = 1.25, fill=viridis(5)[5], col="black", stroke=0.3,
             data = filter(vir_plotdata, vHostType == "Zoonotic")) +
  geom_point(mapping=aes(col=vHostType, x = jitter_fams), shape=21, size = 1.25, fill=viridis(5)[4], col="black", stroke=0.3,
             data = filter(vir_plotdata, vHostType == "Human Only")) +
  geom_point(mapping=aes(x=x,y=y), data = legendpts, shape=21, size = 1, stroke=0.3, fill = c(viridis(5)[4], "#1F7DDC", viridis(5)[5])) +
  geom_text(mapping=aes(x=x,y=y + 10, label=label), data = legendpts, size=1.6, hjust =0, family="Helvetica") +

  scale_fill_viridis(option="inferno", begin=.9, end=0.3, breaks=c(0.03,0.97), expand=c(0,0), name="Proportion Family Zoonotic",
                     labels = c("0", "1"),
                     guide = guide_colorbar(ticks=FALSE, title.position = "top", direction = "horizontal",
                                            label.position = "bottom",  label.vjust = -4.5,
                                            barheight=unit(3, "mm"), barwidth = unit(25, "mm"), raster=TRUE)) +
  scale_x_continuous(breaks=1:n_families, labels = levels(vir_plotdata$vFamily),
                     limits=c(1, n_families), expand=c(0.05,0), oob=scales::rescale_none, name="") +
  scale_y_continuous(breaks=seq(0,300,by=100), expand=c(0,0), limits=c(-5, 350),
                     name ="max phylogenetic\nhost breadth", oob=scales::rescale_none) +
  theme_bw() +
  theme(text = element_text(family="Helvetica", size=7), panel.grid=element_blank(),
        legend.position=c(0.6, 0.1),
        legend.title.align = 0.5,
        legend.text = element_text(color="black"),
        legend.title = element_text(size = 4.5),
        legend.background = element_blank(),
        panel.border=element_blank(), panel.background=element_blank(),
        axis.ticks.y=element_blank(), axis.ticks.x = element_line(size=0.3),
        axis.title.x=element_text(size=9, hjust=0.5, lineheight = 1.2), # margin=margin(t=8), debug=FALSE),
        axis.text.y = element_text(hjust=1, debug=FALSE)) +
  coord_flip()

grobs <- ggplotGrob(vir_fam_plot)$grobs
legend <- grobs[[which(sapply(grobs, function(x) x$name) == "guide-box")]]
vir_fam_plot = cowplot::ggdraw(vir_fam_plot + theme(legend.position = "none"))

gamplots_top = cowplot::plot_grid(plotlist = smooth_plots[c(1,3)], nrow=1, labels=c("b", "c"), label_size=7, align="hv")
gamplots_all = cowplot::plot_grid(gamplots_top, bin_plot, nrow = 2, labels = c("", "d"), label_size=7)
allplots = cowplot::ggdraw() +
  cowplot::draw_plot(vir_fam_plot, 0, 0, 0.61, 1) +
  cowplot::draw_grob(legend, x=-0.5, y=-0.06) +
 # cowplot::draw_plot(smooth_plots[[1]], 13/33, 0.5, 10/33, 0.5) +
  #cowplot::draw_plot(smooth_plots[[3]], 23/33, 0.5, 10/33, 0.5) +
  cowplot::draw_plot(cowplot::plot_grid(smooth_plots[[1]], smooth_plots[[3]], nrow=2, align="hv"), 0.61, 0.333, 0.39, 0.666) +
  cowplot::draw_plot(bin_plot, 0.61, 0,  0.39, 0.3333) +
  cowplot::draw_plot_label(c("a", "b", "c", "d"), x = c(0, .66, .66, .66),
                           y = c(1, 1, .6666, 0.3333), size = 8, fontface = "bold")

#  cowplot::plot_grid(vir_fam_plot, gamplots_all, nrow=1, rel_widths=c(1.3, 2), labels=c("a", ""), label_size=7)  + cowplot::draw_grob(legend, x=-0.5, y=-0.06)
# svglite(file=P("figures/Figure04-viral-traits.svg"), width =4.65, height = 4.61, pointsize=7)
# allplots
# dev.off()

pdf(file=P("figures/Figure04-viral-traits.pdf"), width = convertr::convert(118, "mm", "in"), convertr::convert(106, "mm", "in"), pointsize=7)
allplots
dev.off()


# library(rsvg)
# bitmap <- rsvg(P("figures/Figure04-viral-traits.svg"), width=3600)
# png::writePNG(bitmap, P("figures/Figure04-viral-traits2.png"), dpi=600)

#
# png(file=P("figures", "Figure04-viral-traits.png"), width = convertr::convert(118, "mm", "in")*300, convertr::convert(117, "mm", "in")*300, pointsize=7, res=300)
# allplots
# dev.off()




