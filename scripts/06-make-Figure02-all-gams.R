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
source(P('R/relative_contributions.R'))

SHOW_DEV_EXPL = FALSE

partials_theme = theme(text = element_text(family="Helvetica", size=7),
                       panel.border=element_blank(),
                       panel.background=element_blank(),
                       axis.title.y = element_blank(),
                       panel.grid = element_blank(),
                       axis.ticks.x = element_line(size=0.3),
                       axis.ticks.y = element_blank(),
                       axis.text.y = element_text(color="black"),
                       axis.title.x = element_text(lineheight = 1.2),
                       legend.position="none"
                       #plot.margin=margin(l=0)
                      )

blankPlot <- ggplot()+geom_blank(aes(1,1)) +
  cowplot::theme_nothing()

bgam = readRDS(P("intermediates", "all_viruses_models.rds"))$model[[1]]

de_bgam =  get_relative_contribs(bgam) %>%
  mutate(dev_explained = rel_deviance_explained * summary(bgam)$dev.expl) %>%
  mutate(dev_explained = paste0(stri_trim_both(formatC(dev_explained*100, format = "fg", digits=2)), "%"))

# All Viruses Plot
binary_vars = c("hOrder")

preds <- predict(bgam, type="iterms", se.fit=TRUE)
intercept <- attributes(preds)$constant

preds = preds %>% map(as.data.frame) %>%
  map(~setNames(., stri_replace_first_regex(names(.) ,"s\\(([^\\)]+)\\)", "$1")))
model_data_vir = bgam$model
gterms = attributes(terms(bgam))
ilfun <- bgam$family$linkinv
lfun <- bgam$family$linkfun

binary_terms = which(stri_detect_regex(names(model_data_vir), paste0("(", paste0(binary_vars, collapse="|"), ")")))

smooth_data_vir = model_data_vir[, -c(binary_terms, gterms$response, gterms$offset)]
smooth_ranges = dmap(smooth_data_vir, ~seq(min(.), max(.), length.out = 100))

binary_data = model_data_vir[, binary_terms]
binary_ranges = setNames(as.data.frame(diag(length(binary_terms))), names(model_data_vir)[binary_terms])

offset_name = stri_replace_first_regex(names(model_data_vir)[gterms$offset], "offset\\(([^\\)]+)\\)", "$1")

smooth_ranges = cbind(smooth_ranges,
                      setNames(as.data.frame(lapply(c(names(binary_data), offset_name), function(x) rep(0, nrow(smooth_ranges)))), c(names(binary_data), offset_name)))
binary_ranges = cbind(binary_ranges,
                      setNames(as.data.frame(lapply(c(names(smooth_data_vir), offset_name), function(x) rep(0, nrow(binary_ranges)))), c(names(smooth_data_vir), offset_name)))

smooth_preds <- predict(bgam, newdata=smooth_ranges, type="iterms", se.fit=TRUE)  %>% map(as.data.frame) %>%
  map(~setNames(., stri_replace_first_regex(names(.) ,"s\\(([^\\)]+)\\)", "$1")))
binary_preds <- predict(bgam, newdata=binary_ranges, type="iterms", se.fit=TRUE) %>% map(as.data.frame) %>%
  map(~setNames(., stri_replace_first_regex(names(.) ,"s\\(([^\\)]+)\\)", "$1")))

partials <- as.data.frame(lapply(1:ncol(preds$fit), function(cl) {
  x = lfun(model_data_vir[[gterms$response]]) - rowSums(preds$fit[,-cl]) - intercept
  # (rowSums(preds$fit[,-cl]))
  # x = (lfun(model_data_vir[[gterms$response]]) - model_data_vir[[gterms$offset]])
  #  x = model_data_vir[[gterms$response]]
  x
}))
names(partials) <- names(preds$fit)

smooth_titles = list("disease\ncitations (log)", "PVR body mass", bquote('range (log' ~ km^{2} ~ ')'), "mammal\nsympatry")
names(smooth_titles) = names(smooth_data_vir)
smooth_plots_vir = map(names(smooth_data_vir), function(smooth_term_vir) {
  pl =  ggplot() +
    geom_hline(yintercept = 0, size=0.1, col="grey50") +
    geom_point(mapping = aes(x=model_data_vir[[smooth_term_vir]], y = (partials[[smooth_term_vir]])),
               shape=21, fill="#DA006C", col="black", alpha=0.15, size=0.5, stroke=0.1) +
    geom_ribbon(mapping = aes(x = smooth_ranges[[smooth_term_vir]],
                              ymin = (smooth_preds$fit[[smooth_term_vir]] - 2 * smooth_preds$se.fit[[smooth_term_vir]]),
                              ymax = (smooth_preds$fit[[smooth_term_vir]] + 2 * smooth_preds$se.fit[[smooth_term_vir]])),
                alpha = 0.5, fill=viridis(5)[4]) +
    geom_line(mapping = aes(x = smooth_ranges[[smooth_term_vir]], y = (smooth_preds$fit[[smooth_term_vir]])), size=0.3) +
    xlab(smooth_titles[[smooth_term_vir]]) +
    scale_y_continuous(limits=c(-2.2,2.2), oob=scales::rescale_none) +
    theme_bw() + partials_theme

#if (SHOW_DEV_EXPL) pl <- pl + annotate("label", x = max(model_data_vir[[smooth_term_vir]]), y = -2, label = paste0("DE = ", de_bgam$dev_explained[de_bgam$term == smooth_term_vir]), hjust = 1, size=1.5,  label.size=0, fill="#FFFFFF8C")
    #  geom_rug(mapping = aes(x =model_data_vir[[smooth_term]]), alpha=0.3) +

  return(pl)

})

smooth_plots_vir[[1]] = smooth_plots_vir[[1]] + ylab("strength of effect on\nviruses per host") +
  theme(axis.title.y=element_text(angle=90, lineheight=1.2, margin=margin(r=3)))
smooth_plots_vir[[2]] = smooth_plots_vir[[2]] + theme(axis.title.y = element_blank())
smooth_plots_vir[[3]] = smooth_plots_vir[[3]] + theme(axis.title.y = element_blank())
smooth_plots_vir[[4]] = smooth_plots_vir[[4]] + theme(axis.title.y = element_blank())
bin_vir_data = binary_preds %>% map(function(x) {
  x = x[, stri_detect_regex(names(x), paste0("(", paste0(binary_vars, collapse="|"), ")"))]
  n = names(x)
  x = rowSums(x)
  data_frame(response=x, variable=n)
})



bin_vir_data$fit$se = bin_vir_data$se.fit$response
bin_vir_data = bin_vir_data$fit
bin_vir_data$response = bin_vir_data$response
bin_vir_data$labels = stri_replace_first_regex(bin_vir_data$variable, "hOrder", "")
#bin_vir_data$labels = stri_replace_first_regex(bin_vir_data$labels, "hHuntedIUCN", "Hunted")
bin_vir_data$signif = summary(bgam)$s.table[stri_detect_regex(rownames(summary(bgam)$s.table), paste0("(", paste0(binary_vars, collapse="|"), ")")), "p-value"] < 0.05
bin_vir_data = bin_vir_data %>%
  arrange(desc(signif), response) %>%
  mutate(no = 1:nrow(bin_vir_data))

bin_vir_partials = lapply(binary_terms, function(x) {
  vals = partials[as.logical(model_data_vir[[x]]), x-1]
  variable = names(model_data_vir)[x]
  data_frame(variable=variable, partial=vals, no=bin_vir_data$no[bin_vir_data$variable == variable])
}) %>% bind_rows

bin_vir_data = bin_vir_partials %>%
  group_by(variable) %>%
  summarize(minval = min(partial)) %>%
  inner_join(bin_vir_data, by="variable") %>%
  mutate(minval = pmin(minval, response - 2*se)) %>%
  left_join(de_bgam, by=c('variable' = 'term'))

bin_plot_vir = ggplot() +
  geom_hline(yintercept = 0, size=0.1, col="grey50") +
  geom_point(data=bin_vir_partials, mapping=aes(x=no, y=(partial)), position=position_jitter(width=0.5),
             shape=21, fill="#DA006C", col="black", alpha=0.1, size=0.5, stroke=0.1) +
  geom_rect(data = bin_vir_data, mapping=aes(xmin = no - 0.35, xmax  = no + 0.35, ymin=(response-2*se), ymax=(response+2*se), fill=signif), alpha = 0.5) +
  geom_segment(data = bin_vir_data, mapping=aes(x=no - 0.35, xend = no + 0.35, y=(response), yend=(response)), col="black", size=0.3) +

  geom_text(data = bin_vir_data, mapping=aes(x=no, y=(minval - 0.4), label = stri_trans_totitle(labels)),
            color="black", family="Lato", size=1.5, angle =90, hjust=1, vjust =0.5) +
  scale_fill_manual(breaks = c(TRUE, FALSE), values=c(viridis(5)[4]), "grey") +
  scale_x_continuous(breaks = bin_vir_data$no, labels = stri_trans_totitle(bin_vir_data$labels)) +
  scale_y_continuous(limits=c(-3.8,2.2), breaks=seq(-2,2, by=1), oob=scales::rescale_none, name="") +
  theme_bw() + partials_theme +
  theme(axis.ticks.x=element_blank(), axis.title.x=element_blank(), axis.text.x = element_blank(), legend.position="none",
        axis.title.y=element_blank())

#if (SHOW_DEV_EXPL) bin_plot_vir = bin_plot_vir + geom_label(data = bin_vir_data, mapping=aes(x=no, y = response + 2*se + 0.4, label=dev_explained), color="black", family="Lato", size=1.5, label.size=0, fill="#FFFFFF8C") +


vir_plots <- plot_grid(plot_grid(plotlist = smooth_plots_vir, nrow=1, align="h", rel_widths = c(1.22,1,1,1),
                                 labels=c("a", "b", "c", "d"), label_size=7, hjust=0),
                       bin_plot_vir, nrow=1, rel_widths = c(4.22,1.3), labels=c("", "e"), label_size=7, hjust=0)

#---

# Zoonoses plot
bgam = readRDS(P("intermediates", "all_zoonoses_models.rds"))$model[[1]]
de_bgam =  get_relative_contribs(bgam) %>%
  mutate(dev_explained = rel_deviance_explained * summary(bgam)$dev.expl) %>%
  mutate(dev_explained = paste0(stri_trim_both(formatC(dev_explained*100, format = "fg", digits=2)), "%"))


binary_vars = c("hOrder", "hHuntedIUCN")

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

binary_data = model_data[, binary_terms]
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
  x = lfun(model_data[[gterms$response]]) - model_data[[gterms$offset]] - rowSums(preds$fit[,-cl]) - intercept
  # (rowSums(preds$fit[,-cl]))
  # x = (lfun(model_data[[gterms$response]]) - model_data[[gterms$offset]])
  #  x = model_data[[gterms$response]]
  x
}))
names(partials) <- names(preds$fit)

smooth_titles = c("disease\ncitations (log)", "phylogenetic dist.\nto humans (log)", "range urban/rural\npopulation (log)")
names(smooth_titles) = names(smooth_data)
smooth_plots_zoo = map(names(smooth_data), function(smooth_term) {
  pl =  ggplot() +
    geom_hline(yintercept = 0, size=0.1, col="grey50") +
    geom_point(mapping = aes(x=model_data[[smooth_term]], y = (partials[[smooth_term]])),
               shape=21, fill=viridis(4)[2], col="black", alpha=0.1, size=0.5, stroke=0.1) +
    geom_ribbon(mapping = aes(x = smooth_ranges[[smooth_term]],
                              ymin = (smooth_preds$fit[[smooth_term]] - 2 * smooth_preds$se.fit[[smooth_term]]),
                              ymax = (smooth_preds$fit[[smooth_term]] + 2 * smooth_preds$se.fit[[smooth_term]])),
                alpha = 0.5, fill="#FD9825") +
    geom_line(mapping = aes(x = smooth_ranges[[smooth_term]], y = (smooth_preds$fit[[smooth_term]])), size=0.3) +
    #  geom_rug(mapping = aes(x =model_data[[smooth_term]]), alpha=0.3) +
    xlab(smooth_titles[smooth_term]) + #ylim(0,2.2) +
    theme_bw() + partials_theme

#  if (SHOW_DEV_EXPL) pl = pl + annotate("label", x = max(model_data[[smooth_term]]), y = -2, label = paste0("DE = ", de_bgam$dev_explained[de_bgam$term == smooth_term]), hjust = 1, size=1.5,  label.size=0, fill="#FFFFFF8C")

  return(pl)

})

smooth_plots_zoo[[1]] = smooth_plots_zoo[[1]] + ylab("strength of effect on\nfraction zoonotic") +
  theme(axis.title.y=element_text(angle=90, lineheight=1.2, margin=margin(r=3)))
smooth_plots_zoo[[2]] = smooth_plots_zoo[[2]] + theme(axis.title.y = element_blank())
smooth_plots_zoo[[3]] = smooth_plots_zoo[[3]] + theme(axis.title.y = element_blank())
bin_zoo_data = binary_preds %>% map(function(x) {
  x = x[, stri_detect_regex(names(x), paste0("(", paste0(binary_vars, collapse="|"), ")"))]
  n = names(x)
  x = rowSums(x)
  data_frame(response=x, variable=n)
})



bin_zoo_data$fit$se = bin_zoo_data$se.fit$response
bin_zoo_data = bin_zoo_data$fit
bin_zoo_data$response = bin_zoo_data$response
bin_zoo_data$labels = stri_replace_first_regex(bin_zoo_data$variable, "hOrder", "")
bin_zoo_data$labels = stri_replace_first_regex(bin_zoo_data$labels, "hHuntedIUCN", "Hunted")
bin_zoo_data$signif = summary(bgam)$s.table[stri_detect_regex(rownames(summary(bgam)$s.table), paste0("(", paste0(binary_vars, collapse="|"), ")")), "p-value"] < 0.05
bin_zoo_data = bin_zoo_data %>%
  arrange(desc(signif), response) %>%
  mutate(no = 1:nrow(bin_zoo_data))

bin_zoo_partials = lapply(binary_terms, function(x) {
  vals = partials[as.logical(model_data[[x]]), x-2]
  variable = names(model_data)[x]
  data_frame(variable=variable, partial=vals, no=bin_zoo_data$no[bin_zoo_data$variable == variable])
}) %>% bind_rows

bin_zoo_data = bin_zoo_partials %>%
  group_by(variable) %>%
  summarize(minval = min(partial[!is.infinite(partial)])) %>%
  mutate(minval = ifelse(is.infinite(minval), -1, minval)) %>%
  inner_join(bin_zoo_data, by="variable")

# Remove non-significant binary variables
bin_zoo_partials %<>%
  filter(variable %in% bin_zoo_data$variable[bin_zoo_data$signif])
bin_zoo_data %<>%
  filter(signif) %>%
  left_join(de_bgam, by=c('variable'='term'))

bin_plot_zoo = ggplot() +
  geom_point(data=bin_zoo_partials, mapping=aes(x=no, y=(partial)), position=position_jitter(width=0.5),
             shape=21, fill=viridis(4)[2], col="black", alpha=0.15, size=0.5, stroke=0.1) +
  geom_rect(data = bin_zoo_data, mapping=aes(xmin = no - 0.35, xmax  = no + 0.35, ymin=(response-2*se), ymax=(response+2*se)), fill = "#FD9825", alpha = 0.5) +
  geom_hline(yintercept = 0, size=0.1, col="grey50") +
  geom_segment(data = bin_zoo_data, mapping=aes(x=no - 0.35, xend = no + 0.35, y=(response), yend=(response)), col="black", size=0.3) +

  geom_text(data = bin_zoo_data, mapping=aes(x=no, y=(minval - 0.5), label = stri_trans_totitle(labels)),
            color="black", family="Lato", size=1.5, angle =90, hjust=1, vjust =0.5) +
#  scale_fill_manual(values=c("grey", "#FD9825")) +
  scale_x_continuous(breaks = bin_zoo_data$no, labels = stri_trans_totitle(bin_zoo_data$labels)) +
  scale_y_continuous(limits=c(-4,1), name="", oob=scales::rescale_none, breaks = -3:1) + #
  theme_bw() + partials_theme +
  theme(axis.ticks.x=element_blank(), axis.title.x=element_blank(), axis.text.x=element_blank(), legend.position="none",
        axis.title.y=element_blank())

#if (SHOW_DEV_EXPL) bin_plot_zoo = bin_plot_zoo + geom_label(data = bin_zoo_data, mapping=aes(x=no, y = response + 2*se + 0.4, label=dev_explained), color="black", family="Lato", size=1.5, label.size=0, fill="#FFFFFF8C")


zoo_plots <- plot_grid(plot_grid(plotlist = smooth_plots_zoo, nrow=1, align="h", rel_widths = c(1.22,1,1),
                                 labels=c("f", "g", "h"), label_size=7, hjust=0),
                                    bin_plot_zoo, blankPlot, nrow=1, rel_widths = c(3.22,1.35, 1),
                       labels = c("", "i"), label_size = 7, hjust=0)
allplots = cowplot::plot_grid(vir_plots, zoo_plots, nrow=2, rel_widths = c(5.3, 4.35))
#gdtools::match_family("Helvetica")
svglite(file=P("figures", "Figure02-all-gams.svg"), width = convertr::convert(183, "mm", "in"), convertr::convert(100, "mm", "in"), pointsize=7)
allplots
dev.off()


png(file=P("figures", "figures/Figure02-all-gams.png"), width = convertr::convert(183, "mm", "in")*300, convertr::convert(100, "mm", "in")*300, pointsize=7, res=300)
allplots
dev.off()

