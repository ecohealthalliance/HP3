# HP3 Analysis files

This repository contains code and data to replicate analyses in Olival et. al.
(2016) *Host and Viral Traits Predict Zoonotic Spillover from Mammals.*

-  `documents` contains two  R markdown documents in both raw and readable HTML
    form which give more detail than in the main paper or supplemental methods
    on our model-fitting and validation process: `model_summaries.R`d/html`
    and `geographic_cross_validation.Rmd/html'.
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
        distance matrices and PVR-corrected host mass)
    -   A `metadata.csv` file that describes variables in our database and derived
        variables used in model-fitting
    -   `IUCN_taxonomy_23JUN2016.csv`, data from IUCN used to harmonize our data with IUCN spatial data (see Supplementary Methods)
    -   `Genbank_accession_cytb.csv`,two Genbank accession numbers used in constructing the Cyt-B constrained tree
    -   `region_names.rds`, a list of zoogeographical region names used to describe cross-validation regions. 
-  `figures/` contains figures and tables in the paper and extended data and
    the scripts to generate them, including a `maps/` subdirectory with individual
    maps that are stitched together for the main and extended figures.
-   `scripts/` contains all the scripts used to fit the models and generate outputs
-   `R/` contains files with functions used in other scripts.    
-   `misc/` contains small scripts used for other calculations
-   `intermediates/` contains all the models in the analysis in compressed
     `*.rds` R data form.
-   `shapefiles/` is an empty holding directory.  Large shapefiles used to generate
    maps and in analyses are stored separately on AWS to limit the size of this
    repository.  They are downloaded to this folder by the scripts when needed.

The `Makefile` in this repository holds the project workflow. Running
`make all` in this directory will re-build the project. `make clean` will
remove shapefiles, intermediate data, fit models, and all figures and maps.
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
│   ├── region_names.rds                              | R object of zoogeographical region names for cross-validation
│   ├── supertree_mammals.tree                        | tree file for mammal supertree
│   ├── viruses.csv                                   | viruses database
│   └── Genbank_accession_cytb.csv                    | Genbank accession numbers used for calculating the Cyt-b constrained tree
│   └── intermediate                                  | 
│       ├── generate_phylogenetic_intermediate_data.R | Script to generate intermediate data failes
│       ├── HP3-cytb_PDmatrix-12Mar2016.csv           | distance matrix generated from Cyt-b constrained mammal supertree (generated)
│       ├── HP3-ST_PDmatrix-12Mar2016.csv             | distance matrix generated from mammal supertree (generated)
│       └── PVR_cytb_hostmass.csv                     | Phylogenetically-corrected host biomass values (generated)
├── figures                                           | 
│   ├── ExtendedFigure01-heatmap.R                    | Script to generate Extended Figure 2 heatmap
│   ├── ExtendedTable01-models.docx                   | Tables for Extented Data Tables 1 and 2 (generated)
│   ├── ExtendedTable01-models.R                      | Script to generate Extended Data Tables 1 and 2
│   ├── Figure01A-boxplots.pdf                        | Boxplot used in Extended Figure 1A (generated)
│   ├── Figure01B-boxplots.pdf                        | Boxplot used in Extended Data Figure 1B (generated)
│   ├── Figure01-boxplots.R                           | Script to generate boxplots for Figure 1
│   ├── Figure02-all-gams.R                           | Script to generate Figure 2
│   ├── Figure02-all-gams.svg                         | Figure 2 (generated)
│   ├── Figure04-viral-traits.R                       | Script to generate Figure 4
│   ├── Figure04-viral-traits.svg                     | Figure 4 (generated)
|   └── SuppTable1-observed-predicted-missing.csv     | Supplemental Table 1 (generated)
├── maps                                              | 
│   └── create_maps.R                                 | Script to create maps for Figure 3 and Extended Data panels
├── misc                                              | 
│   ├── calc-bat-special.R                            | Script to calculate difference between bat and other family order effects
│   └── zoonotic_dev_explained_w_offset.R             | Script to calculate deviance explained on zoonotic GAM when including offset
│   └── generate_prediction_table.R                   | Script to generate Supplemental Table 1
├── model_fitting                                     | 
│   ├── gam_supp_info.Rmd                             | R-markdown document fitting all GAM models, reporting models within 2 AIC, summaries, and diagnostics
│   ├── gam_supp_info.md                              | Output of R-markdown document in markdown format (generated)
│   ├── gam_supp_info.html                            | Output of R-markdown document in HTML format (generated)
│   ├── gam_supp_info_files/figure-html/              | Image files of figures in R-markdown document (generated)
│   ├── geo-cross.Rmd                                 | R-markdown document performing all zoogeographical cross-validations
│   ├── geo-cross.md                                  | Output of R-markdown document in markdown format (generated)
│   ├── geo-cross.html                                | Output of R-markdown document in HTML format (generated)
│   ├── geo_cross_files/figure-html/                  | Image files of figures in R-markdown document (generated)
│   ├── postprocessed_database.rds                    | Saved R object of data including all calulated variables (generated)
│   ├── preprocess_data.R                             | Script to calculate derived variables from raw data
│   ├── all_viruses_model.rds                         | Saved R object of all viruses GAM model (generated)
│   ├── all_zoonoses_model.rds                        | Saved R object of all zoonoses GAM model (generated)
│   ├── top_models.rds                                | Saved R object of list of all top models (generated)
│   ├── viral_traits_model.rds                        | Saved R object of viral traits GAM model (generated)
│   └── virus_data_processed.rds                      | Saved R object of virus data processed for creating Figure 4 (generated)
└── R                                                 | 
    ├── cross_validation.R                            | R functions for cross-validation
    ├── cv_gam_by.R                                   | R functions for zoogeographical cross-validation
    ├── fit_gam.R                                     | R functions for fitting and selecting from a group of GAMS
    ├── model_reduction.R                             | R functions for reducing GAM models low-edf variables
    └── relative_contributions.R                      | R function for calculating relative contributions of variables in GAMs
```
