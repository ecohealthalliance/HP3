# HP3 Analysis files

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.596810))](https://doi.org/10.5281/zenodo.596810))

This repository contains code, data, documentation, metadata and figure source files used
in Olival et. al. (2017) "Host and Viral Traits Predict Zoonotic Spillover from Mammals."
_Nature_ https://dx.doi.org/10.1038/nature22975

### Repo Structure

-  `documents` contains two  R markdown documents in both raw and readable HTML
    form which give more detail than in the main paper or supplemental methods
    on our model-fitting and validation process: `model_summaries.Rmd/html`
    and `geographic_cross_validation.Rmd/html`.
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
-   `intermediates/` is a holding directory for
     intermediate data files and fitted model objects in
     `*.rds` R data form. These are re-created when the project is built
-   `shapefiles/` is an empty holding directory.  Large shapefiles used to generate
    maps and in analyses are stored separately on AWS to limit the size of this
    repository.  They are downloaded to this folder by the scripts when needed.

---

### Listing of files

```
├── README.md                                          | This file in .md format
├── README.txt                                         | This file in .txt format
├── HP3.Rproj                                          | Rstudio project organization file
├── Makefile                                           | Makefile for building project
├── .zenodo.json                                       | Metadata file for ZENODO repository
├── data/
│   ├── associations.csv                               | associations database
│   ├── cytb_supertree.tree                            | tree file for Cyt-b constrained version of mammal supertree
│   ├── Genbank_accession_cytb.csv                     | Genbank accession numbers used for calculating the Cyt-b constrained tree
│   ├── hosts.csv                                      | hosts database
│   ├── IUCN_taxonomy_23JUN2016.csv                    | IUCN taxonomy to harmonize IUCN spatial data with hosts database
│   ├── metadata.csv                                   | listing of variables in hosts, viruses, and associations databases
│   ├── references.txt                                 | listing of reference sources for associations database
│   ├── region_names.rds                               | R object of zoogeographical region names for cross-validation
│   ├── supertree_mammals.tree                         | tree file for mammal supertree
│   ├── viruses.csv                                    | viruses database
│   └── intermediate/                                  | Intermediate data files calculated by scripts, primarily phylogenetic distance matrices
│
├── documents/
│   ├── model_summaries.Rmd                            | R-markdown document of GAM model summaries and diagnostics
│   ├── model_summaries.html                           | Compiled HTML of above
│   ├── geographic_cross_validation.Rmd                | R-markdown geospatial diagnostics of models
│   └── geographic_cross_validation.html               | Compiled HTML of above
│
├── figures                                            | Figures and tables for  manuscript and supplements
│   ├── Figure01A-boxplots.pdf                         |
│   ├── Figure01B-boxplots.pdf                         |
│   ├── Figure02-all-gams.svg                          |
│   ├── Figure03-missing-zoo-maps.png                  |
│   ├── Figure04-viral-traits.svg                      |
│   ├── ExtendedFigure03-ALL.png                       |
│   ├── ExtendedFigure04-CARNIVORA.png                 |
│   ├── ExtendedFigure05-CETARTIODACTYLA.png           |
│   ├── ExtendedFigure06-CHIROPTERA.png                |
│   ├── ExtendedFigure07-PRIMATES.png                  |
│   ├── ExtendedFigure08-RODENTIA.png                  |
│   ├── ExtendedTable01-models.docx                    |
│   ├── SuppTable1-observed-predicted-missing.csv      |
│   └── maps/                                          | Individual maps stiched together for figures.
│
├── misc/                                              | Assorted side-analyses
│   ├── calc-bat-special.R                             | Calculates significance of bat order effect in GAM
│   ├── gen_host_spatial_data.R                        | Used for generating host zoogeographies shapefile
│   ├── phylo-primates.Rmd                             | Examination of phylogenetic effects specific to primates
│   ├── calc-pred-obs-correlation.R                    | Alternative measures of model fit
│   └── zoonotic_dev_explained_w_offset.R              | For calculating deviance explained in models with offsets
│
├── R/                                                 | Functions used in scripts and R markdown documents
│   ├── avg_gam_vis.R                                  | Functions for visualizing the average GAM of an ense
│   ├── cross_validation.R                             | Cross validation
│   ├── cv_gam_by.R                                    | Zoogeographical cross-validation
│   ├── fit_gam.R                                      | Fitting ensembles of gam models
│   ├── logp.R                                         | Log function with offset for zeros
│   ├── model_reduction.R                              | Dropping non-predictive variables from models
│   ├── relative_contributions.R                       | Calculating the explained deviance from different variables in a model
│   └── utils.R                                        | Miscelaneuous utility functions
│
├── scripts/                                           | Scripts to build project outputs
│   ├── 01-download-shapefiles.R                       | Fetch shapefiles from storage on Amazon AWS
│   ├── 02-generate_phylogenetic_intermediate_data.R   | Calculate phylogenetic distance matrices and PVD-adjusted body mass
│   ├── 03-preprocess_data.R                           | Data cleaning and merging
│   ├── 04-fit-models.R                                | Fit the GAMs in the paper
│   ├── 05-make-Figure01-boxplots.R                    | Generate boxplots in Figure 1
│   ├── 06-make-Figure02-all-gams.R                    | Generate Figure 2
│   ├── 07-make_maps.R                                 | Generate all maps
│   ├── 08-make-Figure03-ExtendedFigs-stitch-maps.R    | Assemble maps together into Figure 3 and Extended Figures
│   ├── 09-make-Figure04-viral-traits.R                | Generate Figure 4
│   ├── 10-make-ExtendedFigure02-heatmap.R             | Generate heat map for Extended Figure 2
│   ├── 11-make-ExtendedTable01-models.R               | Generate Extended Table 1 of model summaries
│   └── 12-make-SuppTable01-predictions.R              | Generate supplemental table of oberved and predicted viruses and zoonoses by species
│
├── intermediates/                                     | Holds intermediate fitted model objects when project is built
├── shapefiles/                                        | Holds large shapefiles downloaded when project is built
├── packrat/                                           | Holds all R package dependencies
└── .Rprofile                                          | Configures R to use packrat dependencies
```
---

### Reproducing the analysis

The `Makefile` in this repository holds the project workflow. Running
`make all` in the directory will re-build the project. `make clean` will
remove shapefiles, intermediate data, fit models, and all figures and maps.
If this project is opened in RStudio, this can also be accomplished with the
"Build All" and "Clean" buttons in the Build tab.

This project uses [packrat](https://github.com/rstudio/packrat/) to manage
R package dependencies.  Running `packrat::restore()` will unpack the versions
of packages used in this project.  In addition, these packages have
the following system requirements: `cairo`, `gdal`, `GEOS`, `libmagick++-`,
`jave`, `libcurl`, `libpng`, `libxml2`, `OpenSSL`, and `pandoc`. All analyses
were performed using R 3.3.2 under Ubuntu 14.04. Complete build takes approximately
1 hour with 40 cores and 256GB of memory, or approximately 8 hours on a 2-core
Macbook Pro with 16GB of memory.
