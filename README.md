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
-  `model_fitting/` contains an R markdown document which fits all the GAMs in
    the paper, and its output HTML document which includes tables comparing model
    AIC, plot and summaries of top models, relative influence of variables, and
    cross-validation results. Compiling this document runs all the
    models referred to in the paper, and saves the R objects needed for the 
    figures in `figures/` and `maps/`.
-  `figures/` contains figures and tables in the paper and extended data and
    the scripts to generate them, except for maps.
-  `maps` contains a script to generate the map outputs in the paper and extended
    data.
-   `R/` contains files with functions used in other scripts.    
-   `misc/` contains small scripts used for other calculations

---

### Listing of all files

```
├── data
│   ├── associations.csv
│   ├── cytb_supertree.tree
│   ├── hosts.csv
│   ├── intermediate
│   │   ├── generate_phylogenetic_intermediate_data.R
│   │   ├── HP3-cytb_PDmatrix-12Mar2016.csv
│   │   ├── HP3-ST_PDmatrix-12Mar2016.csv
│   │   └── PVR_cytb_hostmass.csv
│   ├── IUCN_taxonomy_23JUN2016.csv
│   ├── metadata.csv
│   ├── references.txt
│   ├── supertree_mammals.tree
│   └── viruses.csv
├── figures
│   ├── ExtendedFigure01-heatmap.R
│   ├── ExtendedTable01-models.docx
│   ├── ExtendedTable01-models.R
│   ├── Figure01A-boxplots.pdf
│   ├── Figure01B-boxplots.pdf
│   ├── Figure01-boxplots.R
│   ├── Figure02-all-gams.R
│   ├── Figure02-all-gams.svg
│   ├── Figure04-viral-traits.R
│   └── Figure04-viral-traits.svg
├── HP3.Rproj
├── maps
│   ├── create_maps.R
│   └── output
│   │   └── png
│           ├── all_viruses
│           │   ├── CARNIVORA_obs_all.png
│           │   ├── CARNIVORA_pred_all.png
│           │   ├── CARNIVORA_pred_obs_all.png
│           │   ├── CETARTIODACTYLA_obs_all.png
│           │   ├── CETARTIODACTYLA_pred_all.png
│           │   ├── CETARTIODACTYLA_pred_obs_all.png
│           │   ├── CHIROPTERA_obs_all.png
│           │   ├── CHIROPTERA_pred_all.png
│           │   ├── CHIROPTERA_pred_obs_all.png
│           │   ├── obs_all.png
│           │   ├── pred_all.png
│           │   ├── pred_obs_all.png
│           │   ├── PRIMATES_obs_all.png
│           │   ├── PRIMATES_pred_all.png
│           │   ├── PRIMATES_pred_obs_all.png
│           │   ├── RODENTIA_obs_all.png
│           │   ├── RODENTIA_pred_all.png
│           │   └── RODENTIA_pred_obs_all.png
│           ├── host
│           │   ├── all_mammals.png
│           │   ├── CARNIVORA_all_mammals.png
│           │   ├── CARNIVORA_hosts.png
│           │   ├── CARNIVORA_hp3_viruses.png
│           │   ├── CARNIVORA_pred_obs_richness.png
│           │   ├── CETARTIODACTYLA_all_mammals.png
│           │   ├── CETARTIODACTYLA_hosts.png
│           │   ├── CETARTIODACTYLA_hp3_viruses.png
│           │   ├── CETARTIODACTYLA_pred_obs_richness.png
│           │   ├── CHIROPTERA_all_mammals.png
│           │   ├── CHIROPTERA_hosts.png
│           │   ├── CHIROPTERA_hp3_viruses.png
│           │   ├── CHIROPTERA_pred_obs_richness.png
│           │   ├── hp3.png
│           │   ├── hp3_viruses.png
│           │   ├── mammals_pred_obs_richness.png
│           │   ├── PRIMATES_all_mammals.png
│           │   ├── PRIMATES_hosts.png
│           │   ├── PRIMATES_hp3_viruses.png
│           │   ├── PRIMATES_pred_obs_richness.png
│           │   ├── RODENTIA_all_mammals.png
│           │   ├── RODENTIA_hosts.png
│           │   ├── RODENTIA_hp3_viruses.png
│           │   └── RODENTIA_pred_obs_richness.png
│           └── zoonoses
│               ├── CARNIVORA_obs_zoo.png
│               ├── CARNIVORA_pred_obs_zoo.png
│               ├── CARNIVORA_pred_zoo.png
│               ├── CETARTIODACTYLA_obs_zoo.png
│               ├── CETARTIODACTYLA_pred_obs_zoo.png
│               ├── CETARTIODACTYLA_pred_zoo.png
│               ├── CHIROPTERA_obs_zoo.png
│               ├── CHIROPTERA_pred_obs_zoo.png
│               ├── CHIROPTERA_pred_zoo.png
│               ├── obs_zoo.png
│               ├── pred_obs_zoo.png
│               ├── pred_zoo.png
│               ├── PRIMATES_obs_zoo.png
│               ├── PRIMATES_pred_obs_zoo.png
│               ├── PRIMATES_pred_zoo.png
│               ├── RODENTIA_obs_zoo.png
│               ├── RODENTIA_pred_obs_zoo.png
│               └── RODENTIA_pred_zoo.png
├── misc
│   ├── calc-bat-special.R
│   └── zoonotic_dev_explained_w_offset.R
├── model_fitting
│   ├── gam_supp_info.Rmd
│   ├── gam_supp_info.md
│   ├── gam_supp_info.html
│   ├── gam_supp_info_files/figure-html/
│   ├── postprocessed_database.rds
│   ├── preprocess_data.R
│   ├── all_viruses_model.rds
│   ├── all_zoonoses_model.rds
│   ├── top_models.rds
│   ├── viral_traits_model.rds
│   └── virus_data_processed.rds
├── R
│   ├── avg_gam_vis.R
│   ├── cross_validation.R
│   ├── fit_gam.R
│   ├── model_reduction.R
│   └── relative_contributions.R
└── README.md
```
