# HP3 Analysis files

This repository contains code and data to replicate analyses in Olival et. al.
(2016) *Host and Viral Traits Predict Zoonotic Spillover from Mammals.*

-  `data/` contains data used in these analyses, including
    -   our primary database of host-viral associations (`associations.csv`)
    -   databases of host (`hosts.csv`) and viral (`viruses.csv`) traits
    -   2 phylogenetic tree files in Newick format (`*.tree`) format. One (`supertree_mammals.tree`) is a
        pruned version of the mammallian supertree (Bininda-Emonds et. al. 2007), for the
        subset of mammals in our database.  The other (`cytb-supertree.tree`) is a custom-built
        cytochrome-B phylogeny constrained to the order-level topology of the mammalian supertree
        (see supplementary methods).
    -   full references for all associations in our database (`references.txt`)
    -   An `intermediates/` directory with derived data (species phylogenetic
        distance matrices and PVR-corrected host mass), and a script to generate
        these values
    -   A `metadata.csv` file that describes variables in our database and derived
        variables used in model-fitting
    -   `IUCN_taxonomy_23JUN2016.csv` is data from IUCN used to harmonize our data with IUCN spatial data (see Supplementary Methods)
-  `model_fitting/` contains an R markdown document which fits all the GAMs in
    the paper, and its output HTML document which includes tables comparing model
    AIC, plot and summaries of top models, relative influence of variables, and
    cross-validation results. Compiling this document runs all the
    models referred to in the paper, and saves the R objects needed for the 
    figures in `figures/` and `maps/`.
-  `figures/` contains figures and tables in the paper and extended data and
    the scripts to generate them, except for maps.
-  `maps/` contains a script to generate the map outputs in the paper and extended
    data, and the final outputs of all maps used in multi-panel map figures in the paper and Extended Data.
-   `R/` contains files with functions used in other scripts.    
-   `misc/` contains small scripts used for other calculations

---

### Listing of all files

```
├── README.md                                         | This file
├── HP3.Rproj                                         | Rstudio project organization file
├── data                                              | 
│   ├── associations.csv                              | associations database
│   ├── cytb_supertree.tree                           | tree file for Cyt-b constrained version of mammal supertree
│   ├── hosts.csv                                     | hosts database
│   ├── IUCN_taxonomy_23JUN2016.csv                   | IUCN taxonomy to harmonize IUCN spatial data with hosts database
│   ├── metadata.csv                                  | listing of variables in hosts, viruses, and associations databases
│   ├── references.txt                                | listing of reference sources for associations database
│   ├── supertree_mammals.tree                        | tree file for mammal supertree
│   └── viruses.csv                                   | viruses database
│   └── intermediate                                  | 
│       ├── generate_phylogenetic_intermediate_data.R | Script to generate intermediate data failes
│       ├── HP3-cytb_PDmatrix-12Mar2016.csv           | distance matrix generated from Cyt-b constrained mammal supertree (generated)
│       ├── HP3-ST_PDmatrix-12Mar2016.csv             | distance matrix generated from mammal supertree (generated)
│       └── PVR_cytb_hostmass.csv                     | Phylogeneticall-corrected host biomass values (generated)
├── figures                                           | 
│   ├── ExtendedFigure01-heatmap.R                    | Script to generate Extended Figure 2 heatmap
│   ├── ExtendedTable01-models.docx                   | Tables for Extented Data Tables 1 and 2 (generated)
│   ├── ExtendedTable01-models.R                      | Script to generate Extended Data Tables 1 and 2
│   ├── Figure01A-boxplots.pdf                        | Boxplot used in Exented Figure 1A (generated)
│   ├── Figure01B-boxplots.pdf                        | Boxplot used in Extended Data Figure 1B (generated)
│   ├── Figure01-boxplots.R                           | Script to generate boxplots for Figure 1
│   ├── Figure02-all-gams.R                           | Script to generate Figure 2
│   ├── Figure02-all-gams.svg                         | Figure 2 (generated)
│   ├── Figure04-viral-traits.R                       | Script to generate Figure 4
│   └── Figure04-viral-traits.svg                     | Figure 4 (generated)
├── maps                                              | 
│   ├── create_maps.R                                 | Script to create maps
│   └── output                                        | 
│       └── png                                       | 
│           ├── all_viruses/                          | Maps of viral richness by host family and for all  mammals (observed/predicted/residuals)
│           ├── host/                                 | Maps of host richness by host family and for all  mammals (observed/predicted/residuals)
│           └── zoonoses/                             | Maps of zoonotic viral richness by host family and for all  mammals (observed/predicted/residuals)
├── misc                                              | 
│   ├── calc-bat-special.R                            | Script to calculate difference between bat and other family order effects
│   └── zoonotic_dev_explained_w_offset.R             | Script to calculate deviance explained on zoonotic GAM when including offset
├── model_fitting                                     | 
│   ├── gam_supp_info.Rmd                             | R-markdown document fitting all GAM models and reporting results
│   ├── gam_supp_info.md                              | Output of R-markdown document in markdown format
│   ├── gam_supp_info.html                            | Output of R-markdown document in HTML format
│   ├── gam_supp_info_files/figure-html/              | Image files of figres in R-markdown document
│   ├── postprocessed_database.rds                    | Saved R object of data including all calulated variables (generated)
│   ├── preprocess_data.R                             | Script to calculate derived variables from raw data
│   ├── all_viruses_model.rds                         | Saved R object of all viruses GAM model (generated)
│   ├── all_zoonoses_model.rds                        | Saved R object of all zoonoses GAM model (generated)
│   ├── top_models.rds                                | Saved R object of list of all top models (generated)
│   ├── viral_traits_model.rds                        | Saved R object of viral traits GAM model
│   └── virus_data_processed.rds                      | Saved R object of virus data processed for creating Figure 4
└── R                                                 | 
    ├── cross_validation.R                            | R functions for cross-validation
    ├── fit_gam.R                                     | R functions for fitting and selecting from a group of GAMS
    ├── model_reduction.R                             | R functions for reducing GAM models low-edf variables
    └── relative_contributions.R                      | R function for calculating relative contributions of variables in GAMs
```
