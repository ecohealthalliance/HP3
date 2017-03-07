.PHONY: shapefiles models intermediate_data maps extended_maps figures all clean

all: documents/model_summaries.html documents/geographic_cross_validation.html figures figures/SuppTable1-observed-predicted-missing.csv figures/ExtendedTable01-models.docx README.txt
# Major groupings of files
FUNCTIONS := $(wildcard R/*.R)
HP3_DATA := data/hosts.csv data/viruses.csv data/associations.csv
SHAPEFILES := shapefiles/mam/mam.shp shapefiles/host_zg_area/host_zg_area.shp shapefiles/Mammals_Terrestrial/Mammals_Terrestrial.shp
MODELS := intermediates/all_viruses_models.rds  intermediates/all_viruses_strict_models.rds  intermediates/all_zoonoses_models.rds  intermediates/all_zoonoses_norev_models.rds  intermediates/all_zoonoses_strict_models.rds  intermediates/domestic_viruses_models.rds  intermediates/domestic_viruses_strict_models.rds  intermediates/domestic_zoonoses_models.rds  intermediates/domestic_zoonoses_strict_models.rds intermediates/vtraits_models.rds  intermediates/vtraits_strict_models.rds
INTERMEDIATE_DATA := data/intermediate/PVR_cytb_hostmass.csv data/intermediate/HP3-ST_PDmatrix.csv data/intermediate/HP3-cytb_PDmatrix.csv
MAPNAMES_FILE := figures/maps/map_names.txt
MAPS := $(shell cat ${MAPNAMES_FILE})
EXTENDED_MAPS := figures/ExtendedFigure04-ALL.png figures/ExtendedFigure05-CARNIVORA.png figures/ExtendedFigure06-CETARTIODACTYLA.png figures/ExtendedFigure07-CHIROPTERA.png figures/ExtendedFigure08-PRIMATES.png figures/ExtendedFigure09-RODENTIA.png
FIGURES := figures/Figure01A-boxplots.pdf figures/Figure01B-boxplots.pdf figures/Figure03-missing-zoo-maps.png figures/Figure04-viral-traits.svg

shapefiles: $(SHAPEFILES)
models: $(MODELS)
intermediate_data: $(INTERMEDIATE_DATA)
maps: $(MAP_NAMES)
extended_maps: $(EXTENDED_MAPS)
figures: $(FIGURES)

.PHONY: shapefiles models intermediate_data maps extended_maps figures all clean

#shapefiles/mam/mam.shp shapefiles/host_zg_area/host_zg_area.shp shapefiles/Mammals_Terrestrial/Mammals_Terrestrial.shp: scripts/01-download-shapefiles.R
$(SHAPEFILES): scripts/01-download-shapefiles.R
	Rscript $<
	touch shapefiles/*/*.*

$(INTERMEDIATE_DATA): scripts/02-generate_phylogenetic_intermediate_data.R data/cytb_supertree.tree data/supertree_mammals.tree $(HP3_DATA)
	Rscript $<

intermediates/postprocessed_database.rds: scripts/03-preprocess_data.R $(HP3_DATA) $(INTERMEDIATE_DATA)
	Rscript $<

$(MODELS): scripts/04-fit-models.R $(FUNCTIONS) intermediates/postprocessed_database.rds
	Rscript $<

documents/model_summaries.html: documents/model_summaries.Rmd $(FUNCTIONS) $(MODELS)
	Rscript -e "rmarkdown::render('$<')"

documents/geographic_cross_validation.html: documents/geographic_cross_validation.Rmd $(FUNCTIONS) $(MODELS) data/region_names.rds intermediates/postprocessed_database.rds $(SHAPEFILES)
	Rscript -e "rmarkdown::render('$<')"

figures/Figure01A-boxplots.pdf Figure01B-boxplots.pdf: scripts/05-make-Figure01-boxplots.R intermediates/postprocessed_database.rds
	Rscript $<

figures/Figure02-all-gams.svg: scripts/06-make-Figure02-all-all-gams.R $(FUNCTIONS) $(MODELS)
	Rscript $<

$(MAPS): 07-make-maps.R $(MODELS) $(SHAPEFILES)
	Rscript $<

figures/Figure03-missing-zoo-maps.png $(EXTENDED_MAPS): scripts/08-make-Figure03-ExtendedFigs-stitch-maps.R $(MAP_NAMES)
	Rscript $<

figures/Figure04-viral-traits.svg: scripts/09-make-Figure04-viral-traits.R $(MODELS)
	Rscript $<

figures/ExtendedTable01-models.docx: scripts/11-make-ExtendedTable01-models.R $(MODELS)
	Rscript $<

figures/SuppTable1-observed-predicted-missing.csv: scripts/12-make-SuppTable01-predictions.R $(MODELS)
	Rscript $<

README.txt: README.md
	cp README.md README.txt

clean:
	rm shapefiles/*.*
	rm data/intermediate/*.*
	rm intermediates/*.*
	rm figures/maps/*.png
	rm figures/*.png figures/*.svg figures/*.pdf figures/*.docx
	rm -r documents/*cache/


