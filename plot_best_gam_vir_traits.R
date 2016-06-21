# Zoonoses plot

partials_theme = theme(text = element_text(family="Helvetica", size=7),
                       panel.border=element_blank(),
                       panel.background=element_blank(),
                    #   axis.title.y = element_blank(),
                       panel.grid = element_blank(),
                       axis.ticks.x = element_line(size=0.3),
                       axis.ticks.y = element_blank(),
                       axis.text.y = element_text(color="black"),
                       legend.position="none")

bgam = vtraits$model[[1]]

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

smooth_titles = c("max PHB (log Myr)", "genome length (log BP)", "PubMed citations (log)")
names(smooth_titles) = names(smooth_data)
smooth_plots = map(names(smooth_data), function(smooth_term) {
  pl =  ggplot() +
    #  geom_hline(yintercept = (intercept), size=0.5, col="red") +
    geom_point(mapping = aes(x=model_data[[smooth_term]], y = (partials[[smooth_term]])),
               shape=21, fill=viridis(4)[1], col="black", alpha=0.25, size=1, stroke=0.3) +
    geom_ribbon(mapping = aes(x = smooth_ranges[[smooth_term]],
                              ymin = (smooth_preds$fit[[smooth_term]] - 2 * smooth_preds$se.fit[[smooth_term]]),
                              ymax = (smooth_preds$fit[[smooth_term]] + 2 * smooth_preds$se.fit[[smooth_term]])),
                alpha = 0.75, fill=ifelse(smooth_term=="vGenomeAveLengthLn", "grey", viridis(5)[4])) +
    geom_line(mapping = aes(x = smooth_ranges[[smooth_term]], y = (smooth_preds$fit[[smooth_term]])), size=0.3) +
    #  geom_rug(mapping = aes(x =model_data[[smooth_term]]), alpha=0.3) +
    xlab(smooth_titles[smooth_term]) + 
    scale_y_continuous(limits=c(-10,10), oob=scales::rescale_none) +
    theme_bw() + partials_theme
  return(pl)
  
})

smooth_plots[[1]] = smooth_plots[[1]] + ylab("Strength of Effect")
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
bin_data$labels = c("enveloped", "cytoplasmic\nreplication", "vector-\nborne")
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
bin_plot = ggplot() + 
  #  geom_hline(yintercept = (intercept), size=0.5, col="red") +
  geom_point(data=bin_partials, mapping=aes(x=no, y=(partial)), position=position_jitter(width=0.8), shape=21, fill=viridis(4)[1], col="black", alpha=0.55, size=1, stroke=0.3) +
  geom_rect(data = bin_data, mapping=aes(xmin = no - 0.45, xmax  = no + 0.45, ymin=(response-2*se), ymax=(response+2*se), fill=signif), alpha = 0.75) +
  geom_segment(data = bin_data, mapping=aes(x=no - 0.45, xend = no + 0.45, y=(response), yend=(response)), col="black", size=0.3) +
  
  # geom_text(data = bin_data, mapping=aes(x=no, y=(response+se) + 0.1 , label = labels), color="black", family="Lato", size=3, angle =90, hjust=0, vjust =0.5) +
  scale_fill_manual(breaks = c(FALSE, TRUE), values=c("grey", viridis(5)[4])) +
  scale_x_continuous(breaks = bin_data$no, labels = bin_data$labels) +
  noamtools::theme_nr +
  scale_y_continuous(limits=c(-10,10), oob=scales::rescale_none, name="") +
  partials_theme + theme(axis.title.x=element_blank(), axis.ticks.x=element_blank(),
                         axis.text.x = element_text(color="black", lineheight = 1.2,
                                                    vjust=0.5, margin=margin(t=0), family="Helvetica", size=7),
                         axis.text.y = element_text(family="Helvetica", size=7))

 

