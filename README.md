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
        variables used in model-fitting.
-  `model_fitting/` contains an R markdown document which fits all the GAMs in
    the paper, and its output HTML document which includes tables comparing model
    AIC, plot and summaries of top models, relative influence of variables, and
    cross-validation results. Compiling this document runs all the
    models referred to in the paper, and saves the R objects needed for the 
    figures in `figures/`.
-  `figures/` contains figures and tables in the paper and extended data and
    the scripts to generate them. 
-   `R/` contains files with functions used in other scripts.    
-   `misc/` contains small scripts used for other calculations
