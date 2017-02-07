# HP3: Zoogeographical Cross-Validation




# Zoogeographic Cross-Validation

In addition to randomly-selected k-fold cross-validation, we evaluated the robustness of our models via non-random geographic cross-validation: we systematically removed all observations from a zoogeographical region, re-fit the model using all observations from outside the region, then performed a non-parametric permutation test comparing the predicted values to the observed values for that region.

In order to meaningfully organize geographic areas, we utilized mammalian zoogeographic regions from [*Holt et al (2013)*](http://dx.doi.org/10.1126/science.1228282) which are defined by distributions of and phylogenetic relationships between species. Using QGIS, a mammal-specific zoogeographical shapefile provided by [Holt's group](http://macroecology.ku.dk/resources/wallace) at the University of Copenhagen was intersected (using QGIS Vector > Geoprocessing Tools > Intersect) with a shapefile of IUCN's host ranges. Areas of these intersections were then calculated using an equal-area projection, and each host was assigned to only the region which contained the greatest proportion of its range. Results of the non-parametric permutation test are shown below; non-significant results indicate that model predictions are unbiased.



# Zoonoses GAM - All Associations

![](geo_cross_files/figure-html/all-zoo-1.png)<!-- -->

Dark green indicates unbiased regions, while dark red indicates regions with evidence of biased predictions. Light green and light red represent the same distinction, but these regions contain very few (less than ten) assigned species; blank areas were not assigned any hosts. 


Table: Biased Predictions Regions (n > 10)

Region                        Observations Fit   Observations Held Out   P-value   Mean Prediction Difference
---------------------------  -----------------  ----------------------  --------  ---------------------------
Southeastern South America                 562                      22    0.0020                       0.2929
Central African Band                       550                      34    0.0120                      -0.4762
Northern Eurussia                          548                      36    0.0131                       0.3392
Southeastern China                         569                      15    0.0000                       0.4007



Table: Unbiased Prediction Regions (n > 10)

Region                             Observations Fit   Observations Held Out   P-value   Mean Prediction Difference
--------------------------------  -----------------  ----------------------  --------  ---------------------------
Northern America                                525                      59    0.9064                      -0.0134
Southwestern North America                      563                      21    0.8563                      -0.0209
Central / Eastern North America                 562                      22    0.1389                       0.2515
Southern Central America                        567                      17    0.5767                       0.1131
Northern South America                          485                      99    0.6268                      -0.0404
West Central Africa                             551                      33    0.2802                       0.0999
Europe                                          546                      38    0.0558                      -0.3289
South Africa                                    523                      61    0.1907                      -0.1695
India                                           563                      21    0.7440                      -0.0991
Southeast Asia                                  550                      34    0.6887                      -0.0746
Southern Australia                              573                      11    0.2839                      -0.2837

## Biased Region Details -- Zoonoses GAM: 

### Southeastern South America:

Common Name                                                                                                                        Species                       Predicted Zoonoses   Observed Zoonoses   Difference Between Observed and Predicted
---------------------------------------------------------------------------------------------------------------------------------  ---------------------------  -------------------  ------------------  ------------------------------------------
South American Water Rat                                                                                                           Nectomys squamipes                        4.6740                   6                                      1.3260
Brazilian Free-tailed Bat, Mexican Free-tailed Bat                                                                                 Tadarida brasiliensis                     3.8978                   5                                      1.1022
Black-footed Pygmy Rice Rat, Delta Pygmy Rice Rat                                                                                  Oligoryzomys nigripes                     3.2415                   4                                      0.7585
Coypu, Nutria                                                                                                                      Myocastor coypus                          2.2854                   3                                      0.7146
Azara's Grass Mouse                                                                                                                Akodon azarae                             2.4571                   3                                      0.5429
Yellow Pygmy Rice Rat                                                                                                              Oligoryzomys flavescens                   2.4622                   3                                      0.5378
Brown Brocket, Gray Brocket                                                                                                        Mazama gouazoubira                        0.4317                   0                                     -0.4317
Small Vesper Mouse                                                                                                                 Calomys laucha                            1.6822                   2                                      0.3178
Montane Akodont                                                                                                                    Akodon montensis                          1.6844                   2                                      0.3156
Dark Bolo Mouse                                                                                                                    Necromys obscurus                         3.3088                   3                                     -0.3088
Geoffroy's Marmoset, Geoffroy's Tufted-ear Marmoset, Geoffroys Tufted-ear Marmoset, White-faced Marmoset, White-fronted Marmoset   Callithrix geoffroyi                      0.7152                   1                                      0.2848
Large-headed Rice Rat                                                                                                              Hylaeamys laticeps                        3.7341                   4                                      0.2659
Paraguayan rice rat                                                                                                                Sooretamys angouya                        3.2245                   3                                     -0.2245
Chacoan Pygmy Rice Rat                                                                                                             Oligoryzomys chacoensis                   0.7780                   1                                      0.2220
Lesser Grison                                                                                                                      Galictis cuja                             0.7841                   1                                      0.2159
Golden-headed Lion Tamarin                                                                                                         Leontopithecus chrysomelas                0.7925                   1                                      0.2075
Azara's Fox, Azaras Fox, Azara's Zorro, Pampas Fox                                                                                 Pseudalopex gymnocercus                   0.7993                   1                                      0.2007
Ihering's Spiny Rat                                                                                                                Trinomys iheringi                         0.8271                   1                                      0.1729
Red Hocicudo                                                                                                                       Oxymycterus rufus                         0.8550                   1                                      0.1450
Fringed Fruit-eating Bat                                                                                                           Artibeus fimbriatus                       0.9067                   1                                      0.0933
Diminutive Serotine                                                                                                                Eptesicus diminutus                       1.0072                   1                                     -0.0072
Yellowish Myotis                                                                                                                   Myotis levis                              1.0065                   1                                     -0.0065

### Central African Band:

Common Name                                                                                     Species                     Predicted Zoonoses   Observed Zoonoses   Difference Between Observed and Predicted
----------------------------------------------------------------------------------------------  -------------------------  -------------------  ------------------  ------------------------------------------
Kemp's Gerbil                                                                                   Gerbilliscus kempi                      4.5547                   1                                     -3.5547
African Grass Rat                                                                               Arvicanthis niloticus                   7.1123                   4                                     -3.1123
Natal Mastomys, Natal Multimammate Mouse                                                        Mastomys natalensis                     6.2811                   4                                     -2.2811
Angolan Free-tailed Bat                                                                         Tadarida condylura                      4.7948                   3                                     -1.7948
Spotted Hyaena                                                                                  Crocuta crocuta                         3.4975                   2                                     -1.4975
African Lion, Lion                                                                              Panthera leo                            4.4949                   3                                     -1.4949
Cape Warthog, Desert Warthog, Somali Warthog                                                    Phacochoerus aethiopicus                0.6715                   2                                      1.3285
Thomson's Gazelle                                                                               Eudorcas thomsonii                      2.2573                   1                                     -1.2573
Green Monkey                                                                                    Chlorocebus sabaeus                     2.1553                   1                                     -1.1553
Guinea Baboon                                                                                   Papio papio                             2.1002                   3                                      0.8998
Green Monkey, Grivet Monkey, Malbrouk Monkey, Tantalus, Vervet Monkey                           Chlorocebus aethiops                    6.8028                   6                                     -0.8028
Egyptian Fruit Bat, Egyptian Rousette, EGYPTIAN ROUSETTE                                        Rousettus aegyptiacus                   6.2123                   7                                      0.7877
Typical Lemniscomys, Typical Striped Grass Mouse                                                Lemniscomys striatus                    2.7259                   2                                     -0.7259
Somali Grass Rat                                                                                Arvicanthis neumanni                    0.7108                   0                                     -0.7108
White-tailed Mongoose                                                                           Ichneumia albicauda                     1.3923                   2                                      0.6077
Ethiopian Wolf, Simien Fox, Simien Jackal                                                       Canis simensis                          2.5942                   2                                     -0.5942
Eloquent Horseshoe Bat                                                                          Rhinolophus eloquens                    1.5659                   1                                     -0.5659
Gambian Epauletted Fruit Bat                                                                    Epomophorus gambianus                   1.5571                   1                                     -0.5571
Hamadryas Baboon, Sacred Baboon                                                                 Papio hamadryas                         3.4983                   4                                      0.5017
Guinea Multimammate Mouse, Reddish-white Mastomys                                               Mastomys erythroleucus                  3.4148                   3                                     -0.4148
Geoffroy's Ground Squirrel, Striped Ground Squirrel                                             Xerus erythropus                        1.4084                   1                                     -0.4084
Lesser Bushbaby, Lesser Galago, Northern Lesser Galago, Senegal Galago, Senegal Lesser Galago   Galago senegalensis                     0.6346                   1                                      0.3654
Common Genet, Ibiza Common Genet, Ibiza Genet                                                   Genetta genetta                         0.6546                   1                                      0.3454
Oribi                                                                                           Ourebia ourebi                          0.3431                   0                                     -0.3431
Peter's Dwarf Epauletted Fruit Bat                                                              Micropteropus pusillus                  2.3337                   2                                     -0.3337
Anubis Baboon, Olive Baboon                                                                     Papio anubis                            3.3222                   3                                     -0.3222
Slender Mongoose                                                                                Herpestes sanguineus                    0.6974                   1                                      0.3026
Lesser Kudu                                                                                     Tragelaphus imberbis                    0.7003                   1                                      0.2997
Gelada Baboon                                                                                   Theropithecus gelada                    0.7041                   1                                      0.2959
Aba Roundleaf Bat                                                                               Hipposideros abae                       0.8033                   1                                      0.1967
Hubert's Mastomys, Huberts Mastomys                                                             Mastomys huberti                        2.0968                   2                                     -0.0968
Grant's Gazelle                                                                                 Nanger granti                           1.0780                   1                                     -0.0780
Waterbuck                                                                                       Kobus ellipsiprymnus                    3.0219                   3                                     -0.0219
Roan Antelope                                                                                   Hippotragus equinus                     0.9990                   1                                      0.0010

### Northern Eurussia:

Common Name                                                                                                 Species                     Predicted Zoonoses   Observed Zoonoses   Difference Between Observed and Predicted
----------------------------------------------------------------------------------------------------------  -------------------------  -------------------  ------------------  ------------------------------------------
Striped Field Mouse                                                                                         Apodemus agrarius                       2.8245                   5                                      2.1755
Cross Fox, Red Fox, Silver Fox                                                                              Vulpes vulpes                           3.0962                   5                                      1.9038
Brown Rat                                                                                                   Rattus norvegicus                      11.5943                  10                                     -1.5943
Northern Red-backed Vole, RED VOLE                                                                          Myodes rutilus                          3.4984                   5                                      1.5016
Racoon Dog                                                                                                  Nyctereutes procyonoides                1.6933                   3                                      1.3067
Bank Vole                                                                                                   Myodes glareolus                       10.8588                  12                                      1.1412
Field Vole                                                                                                  Microtus agrestis                       6.0765                   7                                      0.9235
Eurasian Lynx                                                                                               Lynx lynx                               1.0999                   2                                      0.9001
Root Vole, Tundra Vole                                                                                      Microtus oeconomus                      3.1097                   4                                      0.8903
Polar Bear                                                                                                  Ursus maritimus                         1.8409                   1                                     -0.8409
European Mink                                                                                               Mustela lutreola                        1.2346                   2                                      0.7654
Particoloured Bat                                                                                           Vespertilio murinus                     3.7201                   3                                     -0.7201
Narrow-headed Vole                                                                                          Microtus gregalis                       1.3087                   2                                      0.6913
Dzeren, Mongolian Gazelle                                                                                   Procapra gutturosa                      0.3490                   1                                      0.6510
Siberian Chipmunk                                                                                           Tamias sibiricus                        0.6509                   0                                     -0.6509
Maximowicz's Vole                                                                                           Microtus maximowiczii                   0.6368                   0                                     -0.6368
Black-bellied Hamster, Common Hamster                                                                       Cricetus cricetus                       0.6283                   0                                     -0.6283
Gray Red-backed Vole, Grey Red-backed Vole, GREY-SIDED VOLE                                                 Myodes rufocanus                        1.3873                   2                                      0.6127
Daubenton's Bat, Daubenton's Myotis                                                                         Myotis daubentonii                      2.4396                   3                                      0.5604
Eurasian Water Vole, European Water Vole, Water Vole                                                        Arvicola amphibius                      1.4569                   2                                      0.5431
Arctic Wolf, Common Wolf, Gray Wolf, Grey Wolf, Mexican Wolf, Plains Wolf, Timber Wolf, Tundra Wolf, Wolf   Canis lupus                             1.5293                   1                                     -0.5293
Brown Bear, Grizzly Bear, Mexican Grizzly Bear                                                              Ursus arctos                            0.5171                   1                                      0.4829
Common Otter, Eurasian Otter, European Otter, European River Otter, Old World Otter                         Lutra lutra                             0.5215                   1                                      0.4785
Eurasian Beaver                                                                                             Castor fiber                            0.5971                   1                                      0.4029
Eurasian Harvest Mouse, Harvest Mouse                                                                       Micromys minutus                        0.6011                   1                                      0.3989
Common Shrew, Eurasian Shrew                                                                                Sorex araneus                           0.6053                   1                                      0.3947
Arctic Fox, Polar Fox                                                                                       Alopex lagopus                          0.6069                   1                                      0.3931
Korean Field Mouse                                                                                          Apodemus peninsulae                     0.6298                   1                                      0.3702
Long-tailed Ground Squirrel                                                                                 Spermophilus undulatus                  0.6908                   1                                      0.3092
Herb Field Mouse, Pygmy Field Mouse, Ural Field Mouse                                                       Apodemus uralensis                      0.6915                   1                                      0.3085
Arctic Hare, Mountain Hare                                                                                  Lepus timidus                           1.2944                   1                                     -0.2944
Reed Vole                                                                                                   Microtus fortis                         1.2666                   1                                     -0.2666
Pond Bat, Pond Myotis                                                                                       Myotis dasycneme                        1.7406                   2                                      0.2594
Eurasian Red Squirrel, Red Squirrel                                                                         Sciurus vulgaris                        3.1157                   3                                     -0.1157
Big-footed Myotis                                                                                           Myotis macrodactylus                    0.9171                   1                                      0.0829
Asian Particolored Bat                                                                                      Vespertilio sinensis                    0.9610                   1                                      0.0390

### Southeastern China:

Common Name                                                                          Species                     Predicted Zoonoses   Observed Zoonoses   Difference Between Observed and Predicted
-----------------------------------------------------------------------------------  -------------------------  -------------------  ------------------  ------------------------------------------
Gem-faced Civet, Masked Palm Civet                                                   Paguma larvata                          1.2339                   2                                      0.7661
Bear Macaque, Stump-tailed Macaque, Stumptail Macaque                                Macaca arctoides                        1.3411                   2                                      0.6589
Great Himalayan Leaf-nosed Bat, Great Leaf-nosed Bat, Great Roundleaf Bat            Hipposideros armiger                    1.3984                   2                                      0.6016
Chinese Horseshoe Bat, Chinese Rufous Horseshoe Bat, Little Nepalese Horseshoe Bat   Rhinolophus sinicus                     1.4221                   2                                      0.5779
Francois's Langur                                                                    Trachypithecus francoisi                1.4518                   2                                      0.5482
Chinese Ferret-badger, Small-toothed Ferret-badger                                   Melogale moschata                       0.6327                   1                                      0.3673
Lesser Rice-field Rat, Losea Rat                                                     Rattus losea                            0.6488                   1                                      0.3512
Chinese White-bellied Rat, Confucian Niviventer                                      Niviventer confucianus                  0.6544                   1                                      0.3456
Oriental House Rat, Tanezumi Rat                                                     Rattus tanezumi                         0.6567                   1                                      0.3433
Big-eared Horseshoe Bat                                                              Rhinolophus macrotis                    0.6985                   1                                      0.3015
Pearson's Horseshoe Bat                                                              Rhinolophus pearsonii                   0.7167                   1                                      0.2833
Intermediate Horseshoe Bat, Intermediat Horseshoe Bat                                Rhinolophus affinis                     0.7271                   1                                      0.2729
Rickett's Big-footed Bat, Rickett's Big-footed Myotis                                Myotis pilosus                          0.7434                   1                                      0.2566
Formosan Rock Macaque, Taiwanese Macaque, Taiwan Macaque                             Macaca cyclopis                         1.8221                   2                                      0.1779
Japanese Pipistrelle, Japanese Pipistrelle                                           Pipistrellus abramus                    0.8425                   1                                      0.1575


# All Viruses GAM - All Associations

![](geo_cross_files/figure-html/all-viruses-1.png)<!-- -->

Dark green indicates unbiased regions, while dark red indicates regions with evidence of biased predictions. Light green and light red represent the same distinction, but these regions contain very few (less than ten) assigned species; blank areas were not assigned any hosts. 


Table: Biased Predictions Regions (n > 10)

Region                  Observations Fit   Observations Held Out   P-value   Mean Prediction Difference
---------------------  -----------------  ----------------------  --------  ---------------------------
Central African Band                 542                      34    0.0265                       0.9722
Europe                               539                      37    0.0004                      -1.5026
South Africa                         515                      61    0.0094                       0.8337
Southeastern China                   562                      14    0.0008                      -1.5621



Table: Unbiased Prediction Regions (n > 10)

Region                             Observations Fit   Observations Held Out   P-value   Mean Prediction Difference
--------------------------------  -----------------  ----------------------  --------  ---------------------------
Northern America                                517                      59    0.8139                      -0.0525
Southwestern North America                      555                      21    0.8171                       0.0851
Central / Eastern North America                 554                      22    0.2976                       1.0545
Southern Central America                        560                      16    0.5848                      -0.4242
Northern South America                          477                      99    0.2181                       0.3873
Southeastern South America                      555                      21    0.3842                      -0.2899
West Central Africa                             545                      31    0.7902                       0.0921
India                                           555                      21    0.2203                       1.1181
Northern Eurussia                               540                      36    0.5090                      -0.3578
Southeast Asia                                  542                      34    0.8073                      -0.1238
Southern Australia                              565                      11    0.4133                       0.6797

## Biased Region Details -- All Viruses GAM: 

### Central African Band:

Common Name                                                                                     Species                     Predicted Viruses   Observed Viruses   Difference Between Observed and Predicted
----------------------------------------------------------------------------------------------  -------------------------  ------------------  -----------------  ------------------------------------------
Green Monkey, Grivet Monkey, Malbrouk Monkey, Tantalus, Vervet Monkey                           Chlorocebus aethiops                   1.7590                 10                                      8.2410
Waterbuck                                                                                       Kobus ellipsiprymnus                   3.2123                  9                                      5.7877
African Grass Rat                                                                               Arvicanthis niloticus                  6.0740                 11                                      4.9260
Thomson's Gazelle                                                                               Eudorcas thomsonii                     1.3289                  6                                      4.6711
NA                                                                                              Gerbilliscus kempi                     1.8065                  6                                      4.1935
Angolan Free-tailed Bat                                                                         Tadarida condylura                     2.3613                  6                                      3.6387
Ethiopian Wolf, Simien Fox, Simien Jackal                                                       Canis simensis                         1.0018                  4                                      2.9982
Spotted Hyaena                                                                                  Crocuta crocuta                        3.4809                  6                                      2.5191
Hamadryas Baboon, Sacred Baboon                                                                 Papio hamadryas                        2.7993                  5                                      2.2007
Egyptian Fruit Bat, Egyptian Rousette, EGYPTIAN ROUSETTE                                        Rousettus aegyptiacus                  6.8997                  9                                      2.1003
Lesser Bushbaby, Lesser Galago, Northern Lesser Galago, Senegal Galago, Senegal Lesser Galago   Galago senegalensis                    3.0520                  1                                     -2.0520
Natal Mastomys, Natal Multimammate Mouse                                                        Mastomys natalensis                   12.0392                 10                                     -2.0392
Roan Antelope                                                                                   Hippotragus equinus                    5.0192                  3                                     -2.0192
Grant's Gazelle                                                                                 Nanger granti                          1.3317                  3                                      1.6683
Anubis Baboon, Olive Baboon                                                                     Papio anubis                           6.6514                  5                                     -1.6514
Hubert's Mastomys, Huberts Mastomys                                                             Mastomys huberti                       1.4821                  3                                      1.5179
Green Monkey                                                                                    Chlorocebus sabaeus                    1.5337                  3                                      1.4663
Aba Roundleaf Bat                                                                               Hipposideros abae                      2.3218                  1                                     -1.3218
Guinea Baboon                                                                                   Papio papio                            4.2399                  3                                     -1.2399
Common Genet, Ibiza Common Genet, Ibiza Genet                                                   Genetta genetta                        2.1250                  1                                     -1.1250
White-tailed Mongoose                                                                           Ichneumia albicauda                    1.0932                  2                                      0.9068
Gelada Baboon                                                                                   Theropithecus gelada                   1.8951                  1                                     -0.8951
Oribi                                                                                           Ourebia ourebi                         1.8424                  1                                     -0.8424
Guinea Multimammate Mouse, Reddish-white Mastomys                                               Mastomys erythroleucus                 4.1793                  5                                      0.8207
Lesser Kudu                                                                                     Tragelaphus imberbis                   1.3357                  2                                      0.6643
Somali Grass Rat                                                                                Arvicanthis neumanni                   1.5488                  1                                     -0.5488
Cape Warthog, Desert Warthog, Somali Warthog                                                    Phacochoerus aethiopicus               2.5321                  2                                     -0.5321
Typical Lemniscomys, Typical Striped Grass Mouse                                                Lemniscomys striatus                   4.4165                  4                                     -0.4165
Eloquent Horseshoe Bat                                                                          Rhinolophus eloquens                   2.4120                  2                                     -0.4120
Peter's Dwarf Epauletted Fruit Bat                                                              Micropteropus pusillus                 2.6320                  3                                      0.3680
Gambian Epauletted Fruit Bat                                                                    Epomophorus gambianus                  2.2665                  2                                     -0.2665
Geoffroy's Ground Squirrel, Striped Ground Squirrel                                             Xerus erythropus                       2.1684                  2                                     -0.1684
African Lion, Lion                                                                              Panthera leo                           8.1502                  8                                     -0.1502
Slender Mongoose                                                                                Herpestes sanguineus                   0.9541                  1                                      0.0459

### Europe:

Common Name                                                                           Species                      Predicted Viruses   Observed Viruses   Difference Between Observed and Predicted
------------------------------------------------------------------------------------  --------------------------  ------------------  -----------------  ------------------------------------------
Badger, Eurasian Badger                                                               Meles meles                             8.7279                  1                                     -7.7279
Common Vole                                                                           Microtus arvalis                       12.4455                  6                                     -6.4455
Brown Hare, European Brown Hare, European Hare                                        Lepus europaeus                         7.2132                  2                                     -5.2132
Long-tailed Field Mouse, Wood Mouse                                                   Apodemus sylvaticus                    12.8986                 18                                      5.1014
Alpine Chamois, Balkan Chamois, Chamois, Northern Chamois                             Rupicapra rupicapra                     6.0797                  1                                     -5.0797
Greater Mouse-eared Bat, Large Mouse-eared Bat, Mouse-eared Bat, Mouse-eared Myotis   Myotis myotis                           6.3885                  2                                     -4.3885
European Roe Deer, Roe Deer, Western Roe Deer                                         Capreolus capreolus                    13.2571                  9                                     -4.2571
Common Bentwing Bat, Schreiber's Bent-winged Bat, Schreiber's Long-fingered Bat       Miniopterus schreibersii                4.8034                  9                                      4.1966
Brown Big-eared Bat, Brown Long-eared Bat                                             Plecotus auritus                        5.1273                  2                                     -3.1273
Serotine                                                                              Eptesicus serotinus                     5.7628                  3                                     -2.7628
Whiskered Bat, Whiskered Myotis, WHISKERED MYOTIS                                     Myotis mystacinus                       4.5630                  2                                     -2.5630
Common Pine Vole, European Pine Vole                                                  Microtus subterraneus                   3.4785                  1                                     -2.4785
Common Pipistrelle                                                                    Pipistrellus pipistrellus               5.2791                  3                                     -2.2791
Iberian Wild Goat, Pyrenean Ibex, Spanish Ibex                                        Capra pyrenaica                         2.7461                  1                                     -1.7461
Natterer's Bat                                                                        Myotis nattereri                        3.6852                  2                                     -1.6852
Beech Marten, Pallas's Cat, Stone Marten, STONE MARTEN                                Martes foina                            2.6643                  1                                     -1.6643
European Bison, Wisent                                                                Bison bonasus                           3.4744                  2                                     -1.4744
European Ground Squirrel, European Souslik, European Squirrel                         Spermophilus citellus                   3.3277                  2                                     -1.3277
Barbastelle, Western Barbastelle                                                      Barbastella barbastellus                3.2752                  2                                     -1.2752
Alpine Ibex, Ibex                                                                     Capra ibex                              4.2659                  3                                     -1.2659
Yellow-necked Field Mouse                                                             Apodemus flavicollis                   10.1955                  9                                     -1.1955
Mediterranean Horseshoe Bat                                                           Rhinolophus euryale                     2.0607                  1                                     -1.0607
Nathusius' Pipistrelle                                                                Pipistrellus nathusii                   2.0137                  1                                     -1.0137
Greater Horseshoe Bat                                                                 Rhinolophus ferrumequinum               7.0878                  8                                      0.9122
Iberian Lynx, Pardel Lynx, Spanish Lynx                                               Lynx pardinus                           1.9098                  1                                     -0.9098
European Free-tailed Bat                                                              Tadarida teniotis                       1.9049                  1                                     -0.9049
Kuhl's Pipistrelle                                                                    Pipistrellus kuhlii                     1.8737                  1                                     -0.8737
Abruzzo Chamois, Apennine Chamois, Pyrenean Chamois, Southern Chamois                 Rupicapra pyrenaica                     2.7835                  2                                     -0.7835
Northern Hedgehog, Western European Hedgehog, Western Hedgehog                        Erinaceus europaeus                     1.7418                  1                                     -0.7418
Algerian Mouse, Western Mediterranean Mouse, WESTERN MEDITERRANEAN MOUSE              Mus spretus                             2.6185                  2                                     -0.6185
Montane Water Vole                                                                    Arvicola scherman                       1.4801                  2                                      0.5199
Broad-toothed Field Mouse, Eastern Broad-toothed Field Mouse                          Apodemus mystacinus                     1.5034                  1                                     -0.5034
Mound-building Mouse, Steppe Mouse                                                    Mus spicilegus                          1.3946                  1                                     -0.3946
Golden Hamster                                                                        Mesocricetus auratus                    8.3066                  8                                     -0.3066
Greater White-toothed Shrew, White-toothed Shrew                                      Crocidura russula                       1.1794                  1                                     -0.1794
Noctule                                                                               Nyctalus noctula                        6.1169                  6                                     -0.1169
Bicolored Shrew, Bicoloured White-toothed Shrew                                       Crocidura leucodon                      0.9635                  1                                      0.0365

### South Africa:

Common Name                                                               Species                     Predicted Viruses   Observed Viruses   Difference Between Observed and Predicted
------------------------------------------------------------------------  -------------------------  ------------------  -----------------  ------------------------------------------
Burchell's Zebra, Common Zebra, Painted Zebra, Plains Zebra               Equus quagga                           1.0514                  7                                      5.9486
Yellow Baboon                                                             Papio cynocephalus                     6.4216                 12                                      5.5784
Wildcat, Wild Cat                                                         Felis silvestris                       1.6130                  7                                      5.3870
Chacma Baboon                                                             Papio ursinus                          4.7684                 10                                      5.2316
Blue & White-bearded Wildebeest, Blue Wildebeest, Common Wildebeest       Connochaetes taurinus                  3.8097                  9                                      5.1903
Black-faced Impala, Impala                                                Aepyceros melampus                     4.2103                  9                                      4.7897
Straw-coloured Fruit Bat                                                  Eidolon helvum                         5.2675                 10                                      4.7325
Common Reedbuck, Southern Reedbuck                                        Redunca arundinum                      1.3217                  6                                      4.6783
Northern White Rhinoceros, Square-lipped Rhinoceros, White Rhinoceros     Ceratotherium simum                    0.7548                  5                                      4.2452
Southern African Mastomys, Southern Multimammate Mouse                    Mastomys coucha                        5.2159                  1                                     -4.2159
Greater Cane Rat                                                          Thryonomys swinderianus                5.1253                  1                                     -4.1253
Hartebeest, Swayne's Hartebeest                                           Alcelaphus buselaphus                  3.0814                  7                                      3.9186
Greater Kudu                                                              Tragelaphus strepsiceros               3.2447                  7                                      3.7553
Common Eland, Eland                                                       Tragelaphus oryx                       3.6240                  7                                      3.3760
Springbok                                                                 Antidorcas marsupialis                 2.1187                  5                                      2.8813
Giraffe                                                                   Giraffa camelopardalis                 3.4002                  6                                      2.5998
Tiang, Topi, Tsessebe                                                     Damaliscus lunatus                     1.5701                  4                                      2.4299
Gemsbok                                                                   Oryx gazella                           2.5978                  5                                      2.4022
Egyptian Slit-faced Bat                                                   Nycteris thebaica                      3.4007                  1                                     -2.4007
Black Rhinoceros, Hook-lipped Rhinoceros                                  Diceros bicornis                       1.6848                  4                                      2.3152
Four-striped Grass Mouse, Four-striped Grass Rat                          Rhabdomys pumilio                      3.1838                  1                                     -2.1838
Southern African Vlei Rat, Vlei Rat                                       Otomys irroratus                       2.9766                  1                                     -1.9766
Black-backed Jackal                                                       Canis mesomelas                        3.0618                  5                                      1.9382
Giant House Bat, Schreber's Yellow Bat                                    Scotophilus nigrita                    2.9320                  1                                     -1.9320
Giant Sable Antelope, Sable Antelope                                      Hippotragus niger                      3.2046                  5                                      1.7954
Vervet                                                                    Chlorocebus pygerythrus                1.3809                  3                                      1.6191
Bushbuck                                                                  Tragelaphus scriptus                   3.5857                  2                                     -1.5857
Hildebrandt's Horseshoe Bat                                               Rhinolophus hildebrandti               2.5199                  1                                     -1.5199
African Wild Dog, Cape Hunting Dog, Painted Hunting Dog                   Lycaon pictus                          2.5701                  4                                      1.4299
Leopard                                                                   Panthera pardus                        3.4033                  2                                     -1.4033
Wahlberg's Epauletted Fruit Bat                                           Epomophorus wahlbergi                  2.3950                  1                                     -1.3950
Little Free-tailed Bat                                                    Tadarida pumila                        2.7175                  4                                      1.2825
Side-striped Jackal                                                       Canis adustus                          1.9138                  3                                      1.0862
Highveld Gerbil                                                           Gerbilliscus brantsii                  2.0501                  1                                     -1.0501
Black Wildebeest, White-tailed Gnu                                        Connochaetes gnou                      1.0047                  2                                      0.9953
Central African Large-spotted Genet, Panther Genet, Rusty-spotted Genet   Genetta maculata                       1.0607                  2                                      0.9393
Bushveld Gerbil                                                           Gerbilliscus leucogaster               1.8824                  1                                     -0.8824
Kaiser's Rock Rat                                                         Aethomys kaiseri                       1.7732                  1                                     -0.7732
African Marsh Rat, Common Dasymys                                         Dasymys incomtus                       2.7667                  2                                     -0.7667
Sundevall's Roundleaf Bat                                                 Hipposideros caffer                    2.7622                  2                                     -0.7622
Single-striped Grass Mouse, Single-striped Lemniscomys                    Lemniscomys rosalia                    1.6373                  1                                     -0.6373
Blue Duiker                                                               Philantomba monticola                  1.4074                  2                                      0.5926
Nyala                                                                     Tragelaphus angasii                    1.4362                  2                                      0.5638
Cape Porcupine                                                            Hystrix africaeaustralis               1.5325                  1                                     -0.5325
Bat-eared Fox                                                             Otocyon megalotis                      1.4649                  1                                     -0.4649
Sharpe's Grysbok                                                          Raphicerus sharpei                     1.4513                  1                                     -0.4513
Namaqua Rock Rat                                                          Aethomys namaquensis                   2.4137                  2                                     -0.4137
Common Warthog, Eritrean Warthog, Warthog                                 Phacochoerus africanus                 1.3941                  1                                     -0.3941
Savannah Hare, Scrub Hare                                                 Lepus saxatilis                        1.3885                  1                                     -0.3885
Mountain Reedbuck, Western Mountain Reedbuck                              Redunca fulvorufula                    1.6165                  2                                      0.3835
Aardwolf                                                                  Proteles cristata                      1.2697                  1                                     -0.2697
Cheetah, Hunting Leopard                                                  Acinonyx jubatus                       6.2428                  6                                     -0.2428
Honey Badger                                                              Mellivora capensis                     0.7688                  1                                      0.2312
South African Ground Squirrel                                             Xerus inauris                          1.2167                  1                                     -0.2167
Yellow Mongoose                                                           Cynictis penicillata                   1.2036                  1                                     -0.2036
Banded Mongoose                                                           Mungos mungo                           1.2012                  1                                     -0.2012
Meerkat, Slender-tailed Meerkat, Suricate                                 Suricata suricatta                     0.8141                  1                                      0.1859
Cape Short-eared Gerbil                                                   Desmodillus auricularis                1.1713                  1                                     -0.1713
Common Duiker, Grey Duiker                                                Sylvicapra grimmia                     3.1009                  3                                     -0.1009
Blesbok/bontebok, Bontebok                                                Damaliscus pygargus                    0.9187                  1                                      0.0813
Marsh Mongoose, Water Mongoose                                            Atilax paludinosus                     1.0679                  1                                     -0.0679

### Southeastern China:

Common Name                                                                          Species                     Predicted Viruses   Observed Viruses   Difference Between Observed and Predicted
-----------------------------------------------------------------------------------  -------------------------  ------------------  -----------------  ------------------------------------------
Lesser Rice-field Rat, Losea Rat                                                     Rattus losea                           5.8260                  1                                     -4.8260
Oriental House Rat, Tanezumi Rat                                                     Rattus tanezumi                        4.2119                  1                                     -3.2119
Bear Macaque, Stump-tailed Macaque, Stumptail Macaque                                Macaca arctoides                       4.8412                  2                                     -2.8412
Intermediate Horseshoe Bat, Intermediat Horseshoe Bat                                Rhinolophus affinis                    3.7211                  1                                     -2.7211
Great Himalayan Leaf-nosed Bat, Great Leaf-nosed Bat, Great Roundleaf Bat            Hipposideros armiger                   4.5664                  2                                     -2.5664
Pearson's Horseshoe Bat                                                              Rhinolophus pearsonii                  2.5161                  1                                     -1.5161
Big-eared Horseshoe Bat                                                              Rhinolophus macrotis                   2.4300                  1                                     -1.4300
Gem-faced Civet, Masked Palm Civet                                                   Paguma larvata                         3.2982                  2                                     -1.2982
Japanese Pipistrelle, Japanese Pipistrelle                                           Pipistrellus abramus                   1.6795                  1                                     -0.6795
Francois's Langur                                                                    Trachypithecus francoisi               1.4515                  2                                      0.5485
Formosan Rock Macaque, Taiwanese Macaque, Taiwan Macaque                             Macaca cyclopis                        2.4794                  2                                     -0.4794
Rickett's Big-footed Bat, Rickett's Big-footed Myotis                                Myotis pilosus                         1.3788                  1                                     -0.3788
Chinese Ferret-badger, Small-toothed Ferret-badger                                   Melogale moschata                      1.2474                  1                                     -0.2474
Chinese Horseshoe Bat, Chinese Rufous Horseshoe Bat, Little Nepalese Horseshoe Bat   Rhinolophus sinicus                    2.2213                  2                                     -0.2213

# Zoonoses GAM - Strict Associations

![](geo_cross_files/figure-html/strict-zoo-1.png)<!-- -->

Dark green indicates unbiased regions, while dark red indicates regions with evidence of biased predictions. Light green and light red represent the same distinction, but these regions contain very few (less than ten) assigned 
species; blank areas were not assigned any hosts.  


Table: Biased Predictions Regions (n > 10)

Region                        Observations Fit   Observations Held Out   P-value   Mean Prediction Difference
---------------------------  -----------------  ----------------------  --------  ---------------------------
Northern America                           517                      59    0.0440                      -0.1885
Southern Central America                   560                      16    0.0000                      -0.3820
Northern South America                     477                      99    0.0357                      -0.2044
Southeastern South America                 555                      21    0.0038                       0.6149
West Central Africa                        545                      31    0.0046                       0.8319
Central African Band                       542                      34    0.0395                       0.3685
Northern Eurussia                          540                      36    0.0181                       0.2888
Southeast Asia                             542                      34    0.0075                      -0.5020


Table: Unbiased Prediction Regions (n > 10)

Region                             Observations Fit   Observations Held Out   P-value   Mean Prediction Difference
--------------------------------  -----------------  ----------------------  --------  ---------------------------
Southwestern North America                      555                      21    0.7628                      -0.0347
Central / Eastern North America                 554                      22    0.1219                      -0.3529
Europe                                          539                      37    0.9494                       0.0091
South Africa                                    515                      61    0.7743                      -0.0244
India                                           555                      21    0.7854                       0.0468
Southeastern China                              562                      14    0.6229                       0.0876
Southern Australia                              565                      11    0.7047                      -0.0988

## Biased Region Details -- Strict Zoonoses GAM: 

### Northern America:

Common Name                                                                                 Species                          Predicted Zoonoses   Observed Zoonoses   Difference Between Observed and Predicted
------------------------------------------------------------------------------------------  ------------------------------  -------------------  ------------------  ------------------------------------------
North American Otter, North American River Otter, Northern River Otter                      Lontra canadensis                            1.7121                   0                                     -1.7121
California Ground Squirrel                                                                  Spermophilus beecheyi                        1.6565                   0                                     -1.6565
Amargosa Vole, California Vole                                                              Microtus californicus                        1.5624                   0                                     -1.5624
Chihuahua Vole, Meadow Vole                                                                 Microtus pennsylvanicus                      1.5391                   0                                     -1.5391
Pinyon Mouse                                                                                Peromyscus truei                             1.2747                   0                                     -1.2747
Deer Mouse, North American Deermouse                                                        Peromyscus maniculatus                       1.9884                   3                                      1.0116
Yellow-bellied Marmot                                                                       Marmota flaviventris                         0.9855                   0                                     -0.9855
Fisher                                                                                      Martes pennanti                              0.9452                   0                                     -0.9452
Little Brown Bat, Little Brown Myotis                                                       Myotis lucifugus                             1.9204                   1                                     -0.9204
Southern Marsh Harvest Mouse, Western Harvest Mouse                                         Reithrodontomys megalotis                    0.8950                   0                                     -0.8950
Muskox, Musk Ox                                                                             Ovibos moschatus                             0.1220                   1                                      0.8780
Heermann's Kangaroo Rat, Morro Bay Kangaroo-rat, Morro Bay Kangaroo Rat                     Dipodomys heermanni                          0.8495                   0                                     -0.8495
Big Brown Bat                                                                               Eptesicus fuscus                             1.8423                   1                                     -0.8423
Mountain Weasel, Mount Graham Red Squirrel, Red Squirrel                                    Tamiasciurus hudsonicus                      1.1729                   2                                      0.8271
Northern Myotis                                                                             Myotis septentrionalis                       1.8164                   1                                     -0.8164
Northern Raccoon                                                                            Procyon lotor                                2.2403                   3                                      0.7597
Snowshoe Hare, Snowshoe Rabbit, Varying Hare                                                Lepus americanus                             0.7274                   0                                     -0.7274
Striped Skunk                                                                               Mephitis mephitis                            1.2803                   2                                      0.7197
Yellow-pine Chipmunk                                                                        Tamias amoenus                               0.2968                   1                                      0.7032
Golden Mantled Ground Squirrel, Green River Basin Golden-mantled Ground Squirrel            Spermophilus lateralis                       0.3020                   1                                      0.6980
Hidden Forest Chipmunk, Uinta Chipmunk                                                      Tamias umbrinus                              0.3068                   1                                      0.6932
Least Chipmunk, New Mexico Least Chipmunk, Pe_asco Least Chipmunk, Selkirk Least Chipmunk   Tamias minimus                               0.3109                   1                                      0.6891
American Black Bear                                                                         Ursus americanus                             0.6859                   0                                     -0.6859
American Bison                                                                              Bison bison                                  0.6758                   0                                     -0.6758
Big Horn Thirteen-lined Ground Squirrel, Spotted Skunk, Thirteen-lined Ground Squirrel      Spermophilus tridecemlineatus                0.6712                   0                                     -0.6712
California Myotis, Californian Myotis                                                       Myotis californicus                          0.3358                   1                                      0.6642
Dusky-footed Woodrat, San Joaquin Valley Woodrat                                            Neotoma fuscipes                             0.6623                   0                                     -0.6623
Brush Mouse                                                                                 Peromyscus boylii                            0.6522                   0                                     -0.6522
Columbian Ground Squirrel                                                                   Spermophilus columbianus                     0.3663                   1                                      0.6337
Silver-haired Bat                                                                           Lasionycteris noctivagans                    0.3822                   1                                      0.6178
Long-eared Myotis                                                                           Myotis evotis                                0.4364                   1                                      0.5636
Woodchuck                                                                                   Marmota monax                                1.5109                   2                                      0.4891
Black-tailed Deer, Cedros Island Black-tailed Deer, Cedros Island Mule Deer, Mule Deer      Odocoileus hemionus                          0.4780                   0                                     -0.4780
Spotted Bat                                                                                 Euderma maculatum                            0.5300                   1                                      0.4700
Desert Woodrat                                                                              Neotoma lepida                               0.5311                   1                                      0.4689
Key Deer, Key Deer Toy Deer, White-tailed Deer                                              Odocoileus virginianus                       0.5586                   1                                      0.4414
North American Porcupine                                                                    Erethizon dorsatum                           0.5741                   1                                      0.4259
Bay Lynx, Bobcat                                                                            Lynx rufus                                   0.4004                   0                                     -0.4004
Northern Pocket Gopher, Vancouver Pocket Gopher                                             Thomomys talpoides                           0.3908                   0                                     -0.3908
Great Basin Pocket Mouse                                                                    Perognathus parvus                           0.3847                   0                                     -0.3847
Bushy-tailed Woodrat, Bushy-talied Woodrat, Packrat, Woodrat                                Neotoma cinerea                              0.6259                   1                                      0.3741
Mexican Pronghorn, Pronghorn                                                                Antilocapra americana                        0.3686                   0                                     -0.3686
Long-legged Myotis                                                                          Myotis volans                                0.3383                   0                                     -0.3383
Fringed Myotis                                                                              Myotis thysanodes                            0.3252                   0                                     -0.3252
Mountain Cottontail, Nuttall's Cottontail                                                   Sylvilagus nuttallii                         0.3229                   0                                     -0.3229
Yuma Myotis                                                                                 Myotis yumanensis                            0.6911                   1                                      0.3089
Arctic Ground Squirrel                                                                      Spermophilus parryii                         0.2993                   0                                     -0.2993
Prairie Vole                                                                                Microtus ochrogaster                         0.2783                   0                                     -0.2783
Bighorn Sheep, Mountain Sheep                                                               Ovis canadensis                              0.2534                   0                                     -0.2534
Northern Grasshopper Mouse                                                                  Onychomys leucogaster                        0.2496                   0                                     -0.2496
Keen's Myotis                                                                               Myotis keenii                                1.2463                   1                                     -0.2463
Black-footed Ferret                                                                         Mustela nigripes                             0.2425                   0                                     -0.2425
American Badger                                                                             Taxidea taxus                                0.2243                   0                                     -0.2243
Mountain Goat, Rocky Mountain Goat                                                          Oreamnos americanus                          0.2115                   0                                     -0.2115
Dall's Sheep, Thinhorn Sheep                                                                Ovis dalli                                   0.2098                   0                                     -0.2098
American Jackal, Brush Wolf, Coyote, Prairie Wolf                                           Canis latrans                                1.1463                   1                                     -0.1463
Hawaiian Hoary Bat, Hoary Bat                                                               Lasiurus cinereus                            1.1321                   1                                     -0.1321
Revillagigedo Island Red-backed Vole, Southern Red-backed Vole                              Myodes gapperi                               0.8850                   1                                      0.1150
Richardson's Ground Squirrel                                                                Spermophilus richardsonii                    1.0950                   1                                     -0.0950

### Southern Central America:

Common Name                                                                                                                                                                             Species                      Predicted Zoonoses   Observed Zoonoses   Difference Between Observed and Predicted
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  --------------------------  -------------------  ------------------  ------------------------------------------
Black Howling Monkey, Guatemalan Black Howler Monkey, Guatemalan Howler, Guatemalan Howling Monkey, Lawrences Howler Monkey, Mexican Black Howler Monkey, Yucat_n Black Howler Monkey   Alouatta pigra                           0.7182                   0                                     -0.7182
Mexican Deer Mouse                                                                                                                                                                      Peromyscus mexicanus                     0.5959                   0                                     -0.5959
Coues's Rice Rat                                                                                                                                                                        Oryzomys couesi                          0.5675                   0                                     -0.5675
Black-handed Spider Monkey, Central American Spider Monkey, Geoffroy's Spider Monkey, Geoffroys Spider Monkey, Mono Colorado                                                            Ateles geoffroyi                         0.5386                   0                                     -0.5386
Ecuadorian Mantled Howling Monkey, Mantled Howler Monkey, South Pacific Blackish Howling Monkey                                                                                         Alouatta palliata                        0.5325                   0                                     -0.5325
Panamanian Spiny Pocket Mouse                                                                                                                                                           Liomys adspersus                         0.4173                   0                                     -0.4173
Geoffroy's Tamarin, Geoffroys Tamarin, Red Crested Bare-face Tamarin                                                                                                                    Saguinus geoffroyi                       0.4161                   0                                     -0.4161
Peter's Climbing Rat, Peters's Climbing Rat                                                                                                                                             Tylomys nudicaudus                       0.3262                   0                                     -0.3262
Armored Rat                                                                                                                                                                             Hoplomys gymnurus                        0.3160                   0                                     -0.3160
Central American Woolly Opossum                                                                                                                                                         Caluromys derbianus                      0.2973                   0                                     -0.2973
Toltec Cotton Rat                                                                                                                                                                       Sigmodon toltecus                        0.2692                   0                                     -0.2692
Alfaro's Rice Rat                                                                                                                                                                       Handleyomys alfaroi                      0.2649                   0                                     -0.2649
Gray Short-tailed Bat                                                                                                                                                                   Carollia subrufa                         0.2634                   0                                     -0.2634
Gorgona White-fronted Capuchin, White-throated Capuchin                                                                                                                                 Cebus capucinus                          0.2423                   0                                     -0.2423
Mexican Harvest Mouse                                                                                                                                                                   Reithrodontomys mexicanus                0.2334                   0                                     -0.2334
Jamaican Fruit-eating Bat                                                                                                                                                               Artibeus jamaicensis                     3.1138                   3                                     -0.1138

### Northern South America:

Common Name                                                                                 Species                     Predicted Zoonoses   Observed Zoonoses   Difference Between Observed and Predicted
------------------------------------------------------------------------------------------  -------------------------  -------------------  ------------------  ------------------------------------------
Great Fruit-eating Bat                                                                      Artibeus lituratus                      5.4904                   2                                     -3.4904
Little Yellow-shouldered Bat                                                                Sturnira lilium                         2.9511                   0                                     -2.9511
Cayenne Spiny Rat                                                                           Proechimys guyannensis                  4.2566                   7                                      2.7434
Geoffroy's Tailless Bat                                                                     Anoura geoffroyi                        2.1655                   0                                     -2.1655
Seba's Short-tailed Bat                                                                     Carollia perspicillata                  4.1313                   2                                     -2.1313
Greater Spear-nosed Bat                                                                     Phyllostomus hastatus                   4.1136                   2                                     -2.1136
Common Mustached Bat, Parnell's Mustached Bat                                               Pteronotus parnellii                    1.9397                   0                                     -1.9397
Pallas's Long-tongued Bat                                                                   Glossophaga soricina                    2.7510                   1                                     -1.7510
Black Mastiff Bat                                                                           Molossus rufus                          2.7203                   1                                     -1.7203
Gervais's Fruit-eating Bat                                                                  Artibeus cinereus                       1.6999                   0                                     -1.6999
Gray Four-eyed Opossum, Guaiki                                                              Philander opossum                       1.5123                   0                                     -1.5123
Trinidadian Funnel-eared Bat                                                                Natalus tumidirostris                   1.4954                   0                                     -1.4954
Tent-making Bat                                                                             Uroderma bilobatum                      1.6722                   3                                      1.3278
Black-eared Opossum, Common Opossum, Southern Opossum                                       Didelphis marsupialis                   2.7760                   4                                      1.2240
Brazilian Agouti, Red-rumped Agouti                                                         Dasyprocta leporina                     1.1883                   0                                     -1.1883
Heller's Broad-nosed Bat                                                                    Platyrrhinus helleri                    1.1632                   0                                     -1.1632
Large-headed rice rat                                                                       Hylaeamys megacephalus                  3.8524                   5                                      1.1476
Caribbean Spiny Pocket Mouse, Trinidad Spiny Pocket Mouse                                   Heteromys anomalus                      1.8534                   3                                      1.1466
Large Vesper Mouse                                                                          Calomys callosus                        2.1414                   1                                     -1.1414
Black-capped Capuchin, Guianan/margarita Island Brown Capuchin, Margarita Island Capuchin   Cebus apella                            0.8913                   2                                      1.1087
Black-and-gold Howler Monkey, Black Howler Monkey, Black Howling Monkey                     Alouatta caraya                         1.0627                   0                                     -1.0627
Common Squirrel Monkey, South American Squirrel Monkey                                      Saimiri sciureus                        1.9792                   3                                      1.0208
Short-tailed Cane Mouse                                                                     Zygodontomys brevicauda                 4.0307                   5                                      0.9693
Common Marmoset, White-tufted-ear Marmoset                                                  Callithrix jacchus                      2.0541                   3                                      0.9459
Collared Anteater, Lesser Anteater, Northern Tamandua, Southern Tamandua, Tamandua          Tamandua tetradactyla                   0.8972                   0                                     -0.8972
Red-bellied Tamarin, Red-chested Mustached Tamarin                                          Saguinus labiatus                       0.1203                   1                                      0.8797
Pale Spear-nosed Bat                                                                        Phyllostomus discolor                   0.8765                   0                                     -0.8765
Bicolored Arboreal Rice Rat                                                                 Oecomys bicolor                         0.7652                   0                                     -0.7652
Black Myotis                                                                                Myotis nigricans                        1.2407                   2                                      0.7593
Common Long-nosed Armadillo, Nine-banded Armadillo                                          Dasypus novemcinctus                    0.7290                   0                                     -0.7290
White-throated Round-eared Bat                                                              Lophostoma silvicolum                   0.7081                   0                                     -0.7081
Big Free-tailed Bat                                                                         Nyctinomops macrotis                    0.2975                   1                                      0.7025
Brown Four-eyed Opossum                                                                     Metachirus nudicaudatus                 0.7025                   0                                     -0.7025
Wagner's Bonneted Bat                                                                       Eumops glaucinus                        0.2976                   1                                      0.7024
Northern Ghost Bat                                                                          Diclidurus albus                        0.3056                   1                                      0.6944
Davy's Naked-backed Bat                                                                     Pteronotus davyi                        1.6905                   1                                     -0.6905
Hairy-legged Vampire Bat                                                                    Diphylla ecaudata                       0.3232                   1                                      0.6768
Bare-tailed Woolly Opossum                                                                  Caluromys philander                     1.6665                   1                                     -0.6665
Broad-eared Bat, Broad-eared Free-tailed Bat                                                Nyctinomops laticaudatus                0.3344                   1                                      0.6656
Greater Bonneted Bat, Western Bonneted Bat                                                  Eumops perotis                          0.3491                   1                                      0.6509
Cinnamon Dog-faced Bat                                                                      Cynomops abrasus                        0.3516                   1                                      0.6484
Geoffroy's Monk Saki, Miller's Monk Saki                                                    Pithecia monachus                       0.3578                   1                                      0.6422
White-winged Vampire Bat                                                                    Diaemus youngi                          0.3639                   1                                      0.6361
Big-eared Wooly Bat, Woolly False Vampire Bat                                               Chrotopterus auritus                    0.3690                   1                                      0.6310
White-lined Bat, White-lined Broad-nosed Bat                                                Platyrrhinus lineatus                   0.3855                   1                                      0.6145
Linn_'s Two-toed Sloth, Southern Two-toed Sloth                                             Choloepus didactylus                    0.6060                   0                                     -0.6060
Pygmy Fruit-eating Bat                                                                      Artibeus phaeotis                       1.6041                   1                                     -0.6041
Cotton-headed Tamarin, Cotton-top Tamarin                                                   Saguinus oedipus                        0.3968                   1                                      0.6032
Hoary Fox, Hoary Zorro, Small-toothed Dog                                                   Pseudalopex vetulus                     0.4095                   1                                      0.5905
Tomes's Rice Rat                                                                            Nephelomys albigularis                  0.5730                   0                                     -0.5730
Flat-faced Fruit-eating Bat                                                                 Artibeus planirostris                   0.4287                   1                                      0.5713
Douroucouli, Night Monkey, Northern Night Monkey, Northern Owl Monkey, Owl Monkey           Aotus trivirgatus                       2.4297                   3                                      0.5703
Kinkajou                                                                                    Potos flavus                            0.5702                   0                                     -0.5702
Cougar, Deer Tiger, Mountain Lion, Puma, Red Tiger                                          Puma concolor                           1.5496                   1                                     -0.5496
Argentine Brown Bat, Argentinian Brown Bat                                                  Eptesicus furinalis                     0.4572                   1                                      0.5428
Delicate Vesper Mouse                                                                       Calomys tener                           0.4611                   1                                      0.5389
Orange Nectar Bat                                                                           Lonchophylla robusta                    0.5345                   0                                     -0.5345
Riparian Myotis                                                                             Myotis riparius                         0.4661                   1                                      0.5339
Marsh Rat                                                                                   Holochilus sciureus                     0.4665                   1                                      0.5335
Ocelot                                                                                      Leopardus pardalis                      0.5294                   0                                     -0.5294
Great Stripe-faced Bat                                                                      Vampyrodes caraccioli                   0.5144                   0                                     -0.5144
Hairy-tailed Bolo Mouse                                                                     Necromys lasiurus                       0.4882                   1                                      0.5118
Golden-handed Tamarin, Midas Tamarin, Red-handed Tamarin, Yellow-handed Tamarin             Saguinus midas                          0.5086                   0                                     -0.5086
Fulvous Pygmy Rice Rat                                                                      Oligoryzomys fulvescens                 0.5447                   1                                      0.4553
Silver-tipped Myotis                                                                        Myotis albescens                        0.4476                   0                                     -0.4476
Linnaeus's Mouse Opossum, Murine Mouse Opossum                                              Marmosa murina                          0.4439                   0                                     -0.4439
Water Opossum, Yapok                                                                        Chironectes minimus                     0.4208                   0                                     -0.4208
Tilda Yellow-shouldered Bat                                                                 Sturnira tildae                         0.4032                   0                                     -0.4032
Greater Round-eared Bat                                                                     Tonatia bidens                          0.3945                   0                                     -0.3945
Brazilian Porcupine                                                                         Coendou prehensilis                     0.3904                   0                                     -0.3904
Southern Yellow Bat                                                                         Lasiurus ega                            0.6220                   1                                      0.3780
Brazilian Arboreal Rice Rat                                                                 Oecomys paricola                        0.3741                   0                                     -0.3741
Azara's Night Monkey, Azaras Night Monkey                                                   Aotus azarae                            0.3705                   0                                     -0.3705
Maned Wolf                                                                                  Chrysocyon brachyurus                   0.3594                   0                                     -0.3594
Guiana Bristly Mouse                                                                        Neacomys guianae                        0.3518                   0                                     -0.3518
Bristly Mouse                                                                               Neacomys spinosus                       0.3498                   0                                     -0.3498
Striped Hairy-nosed Bat                                                                     Mimon crenulatum                        0.3491                   0                                     -0.3491
Little Big-eared Bat                                                                        Micronycteris megalotis                 0.3459                   0                                     -0.3459
Miller's Long-tongued Bat                                                                   Glossophaga longirostris                0.3298                   0                                     -0.3298
Southern Long-nosed bat                                                                     Leptonycteris curasoae                  0.3274                   0                                     -0.3274
Commissaris's Long-tongued Bat                                                              Glossophaga commissarisi                0.3125                   0                                     -0.3125
Alston's Cotton Rat                                                                         Sigmodon alstoni                        1.3089                   1                                     -0.3089
Proboscis Bat                                                                               Rhynchonycteris naso                    0.3003                   0                                     -0.3003
Black-chested Mustached Tamarin, Moustached Tamarin, Spix's Moustached Tamarin              Saguinus mystax                         0.2838                   0                                     -0.2838
Bolivian Three-toed Sloth, Brown-throated Sloth, Brown-throated Three-toed Sloth            Bradypus variegatus                     1.2800                   1                                     -0.2800
Colombian Red Howler Monkey, Colombian Red Howling Monkey                                   Alouatta seniculus                      0.2746                   0                                     -0.2746
Giant Anteater                                                                              Myrmecophaga tridactyla                 0.2564                   0                                     -0.2564
Bushy-tailed Olingo, Olingo                                                                 Bassaricyon gabbii                      0.2446                   0                                     -0.2446
Highland Yellow-shouldered Bat                                                              Sturnira ludovici                       0.2427                   0                                     -0.2427
Common Woolly Monkey, Humboldt's Woolly Monkey, Woolly Monkey                               Lagothrix lagotricha                    0.2395                   0                                     -0.2395
Black Mantle Tamarin, Hern_ndez-camacho's Black Mantle Tamarin                              Saguinus nigricollis                    0.2264                   0                                     -0.2264
Pallas's Mastiff Bat                                                                        Molossus molossus                       1.7989                   2                                      0.2011
Pale-throated Sloth, Pale-throated Three-toed Sloth                                         Bradypus tridactylus                    0.8131                   1                                      0.1869
Small-eared Pygmy Rice Rat                                                                  Oligoryzomys microtis                   0.8528                   1                                      0.1472
Marsh Deer                                                                                  Blastocerus dichotomus                  0.0883                   0                                     -0.0883
Fornes Colilargo                                                                            Oligoryzomys fornesi                    0.9158                   1                                      0.0842
Common Vampire Bat, Vampire Bat                                                             Desmodus rotundus                       1.9426                   2                                      0.0574
Silky Short-tailed Bat                                                                      Carollia brevicauda                     1.0130                   1                                     -0.0130
Golden-white Bare-ear Marmoset                                                              Mico leucippe                           0.0002                   0                                     -0.0002

### Southeastern South America:

Common Name                                                                                                                        Species                       Predicted Zoonoses   Observed Zoonoses   Difference Between Observed and Predicted
---------------------------------------------------------------------------------------------------------------------------------  ---------------------------  -------------------  ------------------  ------------------------------------------
Large-headed Rice Rat                                                                                                              Hylaeamys laticeps                        1.4235                   4                                      2.5765
South American Water Rat                                                                                                           Nectomys squamipes                        1.5031                   4                                      2.4969
Dark Bolo Mouse                                                                                                                    Necromys obscurus                         1.2976                   3                                      1.7024
Montane Akodont                                                                                                                    Akodon montensis                          0.7367                   2                                      1.2633
Brazilian Free-tailed Bat, Mexican Free-tailed Bat                                                                                 Tadarida brasiliensis                     0.7858                   2                                      1.2142
Yellow Pygmy Rice Rat                                                                                                              Oligoryzomys flavescens                   0.9690                   2                                      1.0310
Coypu, Nutria                                                                                                                      Myocastor coypus                          0.8250                   0                                     -0.8250
Golden-headed Lion Tamarin                                                                                                         Leontopithecus chrysomelas                0.2317                   1                                      0.7683
Fringed Fruit-eating Bat                                                                                                           Artibeus fimbriatus                       0.2508                   1                                      0.7492
Chacoan Pygmy Rice Rat                                                                                                             Oligoryzomys chacoensis                   0.2650                   1                                      0.7350
Ihering's Spiny Rat                                                                                                                Trinomys iheringi                         0.2757                   1                                      0.7243
Black-footed Pygmy Rice Rat, Delta Pygmy Rice Rat                                                                                  Oligoryzomys nigripes                     1.2773                   2                                      0.7227
Diminutive Serotine                                                                                                                Eptesicus diminutus                       0.5375                   1                                      0.4625
Yellowish Myotis                                                                                                                   Myotis levis                              0.4414                   0                                     -0.4414
Small Vesper Mouse                                                                                                                 Calomys laucha                            0.6408                   1                                      0.3592
Azara's Grass Mouse                                                                                                                Akodon azarae                             0.7096                   1                                      0.2904
Lesser Grison                                                                                                                      Galictis cuja                             0.2671                   0                                     -0.2671
Red Hocicudo                                                                                                                       Oxymycterus rufus                         0.2564                   0                                     -0.2564
Azara's Fox, Azaras Fox, Azara's Zorro, Pampas Fox                                                                                 Pseudalopex gymnocercus                   0.2098                   0                                     -0.2098
Geoffroy's Marmoset, Geoffroy's Tufted-ear Marmoset, Geoffroys Tufted-ear Marmoset, White-faced Marmoset, White-fronted Marmoset   Callithrix geoffroyi                      0.1057                   0                                     -0.1057
Brown Brocket, Gray Brocket                                                                                                        Mazama gouazoubira                        0.0767                   0                                     -0.0767

### West Central Africa:

Common Name                                                                                                        Species                      Predicted Zoonoses   Observed Zoonoses   Difference Between Observed and Predicted
-----------------------------------------------------------------------------------------------------------------  --------------------------  -------------------  ------------------  ------------------------------------------
Chimpanzee, Common Chimpanzee, Robust Chimpanzee                                                                   Pan troglodytes                          5.8700                  17                                     11.1300
Bonobo, Dwarf Chimpanzee, Gracile Chimpanzee, Pygmy Chimpanzee                                                     Pan paniscus                             2.2869                   6                                      3.7131
Lowland Gorilla, Western Gorilla                                                                                   Gorilla gorilla                          4.0418                   7                                      2.9582
Franquet's Epauletted Fruit Bat                                                                                    Epomops franqueti                        0.8108                   3                                      2.1892
Rusty-bellied Brush-furred Rat                                                                                     Lophuromys sikapusi                      0.5533                   2                                      1.4467
Eastern Black-and-white Colobus, Guereza, Magistrate Colobus                                                       Colobus guereza                          0.7810                   2                                      1.2190
Peter's Duiker, Peters' Duiker                                                                                     Cephalophus callipygus                   0.0949                   1                                      0.9051
Gray-cheeked Mangabey, Grey-cheeked Mangabey, White-cheeked Mangabey                                               Lophocebus albigena                      1.1002                   2                                      0.8998
Little Collared Fruit Bat                                                                                          Myonycteris torquata                     0.1922                   1                                      0.8078
Peter's Mouse                                                                                                      Mus setulosus                            0.2028                   1                                      0.7972
Greater Spot-nosed Guenon, Greater White-nosed Monkey, Putty-nosed Monkey, Spot-nosed Guenon, White-nosed Guenon   Cercopithecus nictitans                  1.2139                   2                                      0.7861
Tropical Vlei Rat                                                                                                  Otomys tropicalis                        0.6726                   0                                     -0.6726
Greater Long-fingered Bat                                                                                          Miniopterus inflatus                     0.3385                   1                                      0.6615
Collared Mangabey, Red-capped Mangabey, Sooty Mangabey, White-collared Mangabey                                    Cercocebus torquatus                     0.3464                   1                                      0.6536
Jackson's Praomys, Jackson's Soft-furred Mouse                                                                     Praomys jacksoni                         0.6112                   0                                     -0.6112
Yellow-spotted Brush-furred Rat                                                                                    Lophuromys flavopunctatus                0.4127                   1                                      0.5873
African Buffalo                                                                                                    Syncerus caffer                          0.4768                   0                                     -0.4768
Mona Guenon, Mona Monkey                                                                                           Cercopithecus mona                       1.4674                   1                                     -0.4674
Drill                                                                                                              Mandrillus leucophaeus                   0.5351                   1                                      0.4649
Mandrill                                                                                                           Mandrillus sphinx                        1.5938                   2                                      0.4062
King Colobus, Ursine Black-and-white Colobus, Western Black-and-white Colobus, Western Pied Colobus                Colobus polykomos                        0.2491                   0                                     -0.2491
Crab-eating Mongoose, Isabelline Red-legged Sun Squirrel, Red-legged Sun Squirrel                                  Heliosciurus rufobrachium                0.2293                   0                                     -0.2293
Forest Giant Pouched Rat, Giant Rat                                                                                Cricetomys emini                         0.2104                   0                                     -0.2104
White-bellied Duiker                                                                                               Cephalophus leucogaster                  0.2002                   0                                     -0.2002
Bay Duiker                                                                                                         Cephalophus dorsalis                     0.1866                   0                                     -0.1866
Weyn's Duiker, Weyns' Duiker                                                                                       Cephalophus weynsi                       0.1765                   0                                     -0.1765
Black-fronted Duiker                                                                                               Cephalophus nigrifrons                   0.1508                   0                                     -0.1508
Pygmy Hippopotamus                                                                                                 Choeropsis liberiensis                   0.0926                   0                                     -0.0926
Bongo                                                                                                              Tragelaphus eurycerus                    0.0582                   0                                     -0.0582
Red River Hog                                                                                                      Potamochoerus porcus                     0.0560                   0                                     -0.0560
African Elephant                                                                                                   Loxodonta africana                       1.9983                   2                                      0.0017

### Central African Band:

Common Name                                                                                     Species                     Predicted Zoonoses   Observed Zoonoses   Difference Between Observed and Predicted
----------------------------------------------------------------------------------------------  -------------------------  -------------------  ------------------  ------------------------------------------
Egyptian Fruit Bat, Egyptian Rousette, EGYPTIAN ROUSETTE                                        Rousettus aegyptiacus                   1.8852                   6                                      4.1148
Guinea Baboon                                                                                   Papio papio                             0.7804                   3                                      2.2196
White-tailed Mongoose                                                                           Ichneumia albicauda                     0.3787                   2                                      1.6213
African Lion, Lion                                                                              Panthera leo                            1.4989                   3                                      1.5011
Angolan Free-tailed Bat                                                                         Tadarida condylura                      1.4412                   0                                     -1.4412
Peter's Dwarf Epauletted Fruit Bat                                                              Micropteropus pusillus                  0.5636                   2                                      1.4364
Anubis Baboon, Olive Baboon                                                                     Papio anubis                            1.2420                   0                                     -1.2420
Guinea Multimammate Mouse, Reddish-white Mastomys                                               Mastomys erythroleucus                  0.8714                   2                                      1.1286
Slender Mongoose                                                                                Herpestes sanguineus                    0.1882                   1                                      0.8118
Common Genet, Ibiza Common Genet, Ibiza Genet                                                   Genetta genetta                         0.1902                   1                                      0.8098
Aba Roundleaf Bat                                                                               Hipposideros abae                       0.2013                   1                                      0.7987
Kemp's Gerbil                                                                                   Gerbilliscus kempi                      1.7747                   1                                     -0.7747
Hamadryas Baboon, Sacred Baboon                                                                 Papio hamadryas                         1.3275                   2                                      0.6725
Gelada Baboon                                                                                   Theropithecus gelada                    0.3548                   1                                      0.6452
Natal Mastomys, Natal Multimammate Mouse                                                        Mastomys natalensis                     1.4418                   2                                      0.5582
Eloquent Horseshoe Bat                                                                          Rhinolophus eloquens                    0.4437                   1                                      0.5563
Waterbuck                                                                                       Kobus ellipsiprymnus                    0.5492                   0                                     -0.5492
Thomson's Gazelle                                                                               Eudorcas thomsonii                      0.5258                   0                                     -0.5258
Green Monkey, Grivet Monkey, Malbrouk Monkey, Tantalus, Vervet Monkey                           Chlorocebus aethiops                    2.4749                   3                                      0.5251
Hubert's Mastomys, Huberts Mastomys                                                             Mastomys huberti                        0.5531                   1                                      0.4469
Gambian Epauletted Fruit Bat                                                                    Epomophorus gambianus                   0.3759                   0                                     -0.3759
Geoffroy's Ground Squirrel, Striped Ground Squirrel                                             Xerus erythropus                        0.3724                   0                                     -0.3724
Typical Lemniscomys, Typical Striped Grass Mouse                                                Lemniscomys striatus                    0.6773                   1                                      0.3227
African Grass Rat                                                                               Arvicanthis niloticus                   1.7148                   2                                      0.2852
Grant's Gazelle                                                                                 Nanger granti                           0.2589                   0                                     -0.2589
Ethiopian Wolf, Simien Fox, Simien Jackal                                                       Canis simensis                          0.7550                   1                                      0.2450
Lesser Bushbaby, Lesser Galago, Northern Lesser Galago, Senegal Galago, Senegal Lesser Galago   Galago senegalensis                     0.2344                   0                                     -0.2344
Somali Grass Rat                                                                                Arvicanthis neumanni                    0.2280                   0                                     -0.2280
Green Monkey                                                                                    Chlorocebus sabaeus                     0.7727                   1                                      0.2273
Roan Antelope                                                                                   Hippotragus equinus                     0.1711                   0                                     -0.1711
Lesser Kudu                                                                                     Tragelaphus imberbis                    0.1451                   0                                     -0.1451
Cape Warthog, Desert Warthog, Somali Warthog                                                    Phacochoerus aethiopicus                0.1085                   0                                     -0.1085
Spotted Hyaena                                                                                  Crocuta crocuta                         0.9017                   1                                      0.0983
Oribi                                                                                           Ourebia ourebi                          0.0675                   0                                     -0.0675

### Northern Eurussia:

Common Name                                                                                                 Species                     Predicted Zoonoses   Observed Zoonoses   Difference Between Observed and Predicted
----------------------------------------------------------------------------------------------------------  -------------------------  -------------------  ------------------  ------------------------------------------
Eurasian Red Squirrel, Red Squirrel                                                                         Sciurus vulgaris                        1.1694                   3                                      1.8306
Gray Red-backed Vole, Grey Red-backed Vole, GREY-SIDED VOLE                                                 Myodes rufocanus                        0.3669                   2                                      1.6331
Eurasian Water Vole, European Water Vole, Water Vole                                                        Arvicola amphibius                      0.5018                   2                                      1.4982
Racoon Dog                                                                                                  Nyctereutes procyonoides                0.5587                   2                                      1.4413
Pond Bat, Pond Myotis                                                                                       Myotis dasycneme                        0.8036                   2                                      1.1964
Root Vole, Tundra Vole                                                                                      Microtus oeconomus                      0.9835                   2                                      1.0165
Daubenton's Bat, Daubenton's Myotis                                                                         Myotis daubentonii                      1.0825                   2                                      0.9175
Field Vole                                                                                                  Microtus agrestis                       2.1100                   3                                      0.8900
Northern Red-backed Vole, RED VOLE                                                                          Myodes rutilus                          1.1183                   2                                      0.8817
Eurasian Beaver                                                                                             Castor fiber                            0.1907                   1                                      0.8093
Arctic Fox, Polar Fox                                                                                       Alopex lagopus                          0.2160                   1                                      0.7840
Long-tailed Ground Squirrel                                                                                 Spermophilus undulatus                  0.2527                   1                                      0.7473
Polar Bear                                                                                                  Ursus maritimus                         0.6832                   0                                     -0.6832
Narrow-headed Vole                                                                                          Microtus gregalis                       0.3355                   1                                      0.6645
Arctic Wolf, Common Wolf, Gray Wolf, Grey Wolf, Mexican Wolf, Plains Wolf, Timber Wolf, Tundra Wolf, Wolf   Canis lupus                             0.4669                   1                                      0.5331
Bank Vole                                                                                                   Myodes glareolus                        3.4645                   3                                     -0.4645
Asian Particolored Bat                                                                                      Vespertilio sinensis                    0.4228                   0                                     -0.4228
European Mink                                                                                               Mustela lutreola                        0.4057                   0                                     -0.4057
Eurasian Lynx                                                                                               Lynx lynx                               0.3980                   0                                     -0.3980
Particoloured Bat                                                                                           Vespertilio murinus                     2.6204                   3                                      0.3796
Arctic Hare, Mountain Hare                                                                                  Lepus timidus                           0.3775                   0                                     -0.3775
Reed Vole                                                                                                   Microtus fortis                         0.3628                   0                                     -0.3628
Brown Rat                                                                                                   Rattus norvegicus                       3.6700                   4                                      0.3300
Striped Field Mouse                                                                                         Apodemus agrarius                       0.7105                   1                                      0.2895
Big-footed Myotis                                                                                           Myotis macrodactylus                    0.2632                   0                                     -0.2632
Cross Fox, Red Fox, Silver Fox                                                                              Vulpes vulpes                           1.2435                   1                                     -0.2435
Herb Field Mouse, Pygmy Field Mouse, Ural Field Mouse                                                       Apodemus uralensis                      0.2307                   0                                     -0.2307
Black-bellied Hamster, Common Hamster                                                                       Cricetus cricetus                       0.2306                   0                                     -0.2306
Maximowicz's Vole                                                                                           Microtus maximowiczii                   0.2217                   0                                     -0.2217
Korean Field Mouse                                                                                          Apodemus peninsulae                     0.2077                   0                                     -0.2077
Common Shrew, Eurasian Shrew                                                                                Sorex araneus                           0.2017                   0                                     -0.2017
Siberian Chipmunk                                                                                           Tamias sibiricus                        0.1897                   0                                     -0.1897
Eurasian Harvest Mouse, Harvest Mouse                                                                       Micromys minutus                        0.1779                   0                                     -0.1779
Common Otter, Eurasian Otter, European Otter, European River Otter, Old World Otter                         Lutra lutra                             0.1604                   0                                     -0.1604
Brown Bear, Grizzly Bear, Mexican Grizzly Bear                                                              Ursus arctos                            0.1582                   0                                     -0.1582
Dzeren, Mongolian Gazelle                                                                                   Procapra gutturosa                      0.0461                   0                                     -0.0461

### Southeast Asia:

Common Name                                                                                                                   Species                      Predicted Zoonoses   Observed Zoonoses   Difference Between Observed and Predicted
----------------------------------------------------------------------------------------------------------------------------  --------------------------  -------------------  ------------------  ------------------------------------------
Bornean Orangutan                                                                                                             Pongo pygmaeus                          11.0451                   1                                    -10.0451
Javan Gibbon, Moloch Gibbon, Owa Jawa, Silvery Gibbon, Silvery Javan Gibbon                                                   Hylobates moloch                         0.9623                   0                                     -0.9623
Least Horseshoe Bat                                                                                                           Rhinolophus pusillus                     0.9092                   0                                     -0.9092
Black-bearded Tomb Bat                                                                                                        Taphozous melanopogon                    0.8391                   0                                     -0.8391
Horsfield's Leaf-nosed Bat, Intermediate Leaf-nosed Bat, Intermediate Roundleaf Bat, Intermediat Roundleaf Bat                Hipposideros larvatus                    0.1943                   1                                      0.8057
Common Gibbon, Lar Gibbon, White-handed Gibbon                                                                                Hylobates lar                            0.7629                   0                                     -0.7629
Bare-rumped Sheathtail-bat, Naked-rumped Pouched Bat, Pouch-bearing Bat, Pouched Bat                                          Saccolaimus saccolaimus                  0.2598                   1                                      0.7402
Crab-eating Macaque, Cynomolgus Monkey, Long-tailed Macaque                                                                   Macaca fascicularis                      5.6802                   5                                     -0.6802
Red-shanked Douc, Red-shanked Douc Langur                                                                                     Pygathrix nemaeus                        0.3256                   1                                      0.6744
Malayan Field Rat, Malaysian Field Rat                                                                                        Rattus tiomanicus                        0.6695                   0                                     -0.6695
Polynesian Rat                                                                                                                Rattus exulans                           0.6125                   0                                     -0.6125
Northern Treeshrew, Northern Tree Shrew                                                                                       Tupaia belangeri                         0.5710                   0                                     -0.5710
Mitred Leaf Monkey, Sumatran Surili                                                                                           Presbytis melalophos                     0.5331                   0                                     -0.5331
Northern White-cheeked Gibbon, White-cheeked Gibbon                                                                           Nomascus leucogenys                      0.5002                   1                                      0.4998
Large Flying-fox, Large Flying Fox                                                                                            Pteropus vampyrus                        0.5135                   1                                      0.4865
Andersen's Leaf-nosed Bat, Pomona Leaf-nosed Bat, Pomona Roundleaf Bat                                                        Hipposideros pomona                      0.4430                   0                                     -0.4430
Common Rousette, Geoffroy's Rousette                                                                                          Rousettus amplexicaudatus                0.4263                   0                                     -0.4263
Leopard Cat                                                                                                                   Prionailurus bengalensis                 0.4098                   0                                     -0.4098
Savile's Bandicoot Rat, Saviles Bandicoot Rat                                                                                 Bandicota savilei                        0.4029                   0                                     -0.4029
Asiatic Lesser Yellow House Bat, Lesser Asian House Bat, Lesser Asiatic Yellow Bat, Lesser Asiatic Yellow House Bat           Scotophilus kuhlii                       1.3526                   1                                     -0.3526
Bicolored Leaf-nosed Bat, Bicolored Roundleaf Bat                                                                             Hipposideros bicolor                     0.3323                   0                                     -0.3323
Silvered Langur, Silvered Leaf Monkey, Silvered Monkey, Silvery Lutung                                                        Trachypithecus cristatus                 1.3058                   1                                     -0.3058
Greater Slow Loris, Slow Loris, Sunda Slow Loris                                                                              Nycticebus coucang                       0.2724                   0                                     -0.2724
Common Short-nosed Fruit Bat, Lesser Dog-faced Fruit Bat, Lesser Short-nosed Fruit Bat                                        Cynopterus brachyotis                    1.7328                   2                                      0.2672
Lyle's Flying Fox                                                                                                             Pteropus lylei                           1.2467                   1                                     -0.2467
Diadem Horseshoe-bat, Diadem Leafnosed-bat, Diadem Leaf-nosed Bat, Diadem Roundleaf Bat                                       Hipposideros diadema                     0.2403                   0                                     -0.2403
Ashy Roundleaf Bat, Least Leaf-nosed Bat                                                                                      Hipposideros cineraceus                  0.2290                   0                                     -0.2290
Pig-tailed Macaque, Pigtail Macaque, Southern Pig-tailed Macaque, Sundaland Pigtail Macaque, Sunda Pig-tailed Macaque         Macaca nemestrina                        1.2188                   1                                     -0.2188
Sumatran Orangutan                                                                                                            Pongo abelii                             0.8488                   1                                      0.1512
Java Mousedeer, Javan Chevrotain, Javan Mousedeer, Kanchil, Lesser Mouse Deer                                                 Tragulus javanicus                       0.1079                   0                                     -0.1079
Barking Deer, Bornean Red Muntjac, Indian Muntjac, Red Muntjac, Southern Red Muntjac, Sundaland Red Muntjac                   Muntiacus muntjak                        0.0980                   0                                     -0.0980
Asian Buffalo, Asiatic Buffalo, Indian Buffalo, Indian Water Buffalo, Water Buffalo, Wild Asian Buffalo, Wild Water Buffalo   Bubalus arnee                            0.0740                   0                                     -0.0740
Capped Gibbon, Crowned Gibbon, Pileated Gibbon                                                                                Hylobates pileatus                       0.9508                   1                                      0.0492
Common Dawn Bat, Common Nectar Bat, Dawn Bat, Lesser Dawn Bat                                                                 Eonycteris spelaea                       0.9969                   1                                      0.0031


# All Viruses GAM - Strict Associations

![](geo_cross_files/figure-html/strict-viruses-1.png)<!-- -->

Dark green indicates unbiased regions, while dark red indicates regions with evidence of biased predictions. Light green and light red represent the same distinction, but these regions contain very few (less than ten) assigned species; blank areas were not assigned any hosts. 


Table: Biased Predictions Regions (n > 10)

Region                      Observations Fit   Observations Held Out   P-value   Mean Prediction Difference
-------------------------  -----------------  ----------------------  --------  ---------------------------
Northern America                         516                      59    0.0006                      -0.3823
Southern Central America                 559                      16    0.0009                      -1.0621
West Central Africa                      545                      30    0.0300                       0.5590
Central African Band                     541                      34    0.0069                       0.9742
Southeastern China                       561                      14    0.0047                      -0.5791



Table: Unbiased Prediction Regions (n > 10)

Region                             Observations Fit   Observations Held Out   P-value   Mean Prediction Difference
--------------------------------  -----------------  ----------------------  --------  ---------------------------
Southwestern North America                      554                      21    0.4882                      -0.1670
Central / Eastern North America                 553                      22    0.6846                      -0.3282
Northern South America                          476                      99    0.2950                      -0.2083
Southeastern South America                      554                      21    0.4198                       0.3042
Europe                                          538                      37    0.2504                       0.3711
South Africa                                    514                      61    0.7942                      -0.0413
India                                           554                      21    0.5050                       0.5320
Northern Eurussia                               539                      36    0.6909                      -0.1171
Southeast Asia                                  541                      34    0.5390                      -0.1818
Southern Australia                              564                      11    0.3557                       0.5891

## Biased Region Details -- Strict Viruses:

### Northern America

Common Name                                                                                 Species                          Predicted Viruses   Observed Viruses   Difference Between Observed and Predicted
------------------------------------------------------------------------------------------  ------------------------------  ------------------  -----------------  ------------------------------------------
Deer Mouse, North American Deermouse                                                        Peromyscus maniculatus                      7.1392                  5                                     -2.1392
American Jackal, Brush Wolf, Coyote, Prairie Wolf                                           Canis latrans                               3.1383                  1                                     -2.1383
Dusky-footed Woodrat, San Joaquin Valley Woodrat                                            Neotoma fuscipes                            1.9822                  0                                     -1.9822
Prairie Vole                                                                                Microtus ochrogaster                        1.9432                  0                                     -1.9432
Big Horn Thirteen-lined Ground Squirrel, Spotted Skunk, Thirteen-lined Ground Squirrel      Spermophilus tridecemlineatus               1.5391                  0                                     -1.5391
Northern Grasshopper Mouse                                                                  Onychomys leucogaster                       1.5083                  0                                     -1.5083
Woodchuck                                                                                   Marmota monax                               2.5297                  4                                      1.4703
Mountain Goat, Rocky Mountain Goat                                                          Oreamnos americanus                         0.7383                  2                                      1.2617
Brush Mouse                                                                                 Peromyscus boylii                           1.2085                  0                                     -1.2085
Bay Lynx, Bobcat                                                                            Lynx rufus                                  1.1069                  0                                     -1.1069
Big Brown Bat                                                                               Eptesicus fuscus                            3.0849                  2                                     -1.0849
Northern Pocket Gopher, Vancouver Pocket Gopher                                             Thomomys talpoides                          1.0819                  0                                     -1.0819
Southern Marsh Harvest Mouse, Western Harvest Mouse                                         Reithrodontomys megalotis                   2.0587                  1                                     -1.0587
Yuma Myotis                                                                                 Myotis yumanensis                           0.9528                  2                                      1.0472
Chihuahua Vole, Meadow Vole                                                                 Microtus pennsylvanicus                     3.0344                  2                                     -1.0344
Snowshoe Hare, Snowshoe Rabbit, Varying Hare                                                Lepus americanus                            1.0323                  0                                     -1.0323
California Ground Squirrel                                                                  Spermophilus beecheyi                       2.0127                  1                                     -1.0127
American Badger                                                                             Taxidea taxus                               0.9840                  0                                     -0.9840
Long-legged Myotis                                                                          Myotis volans                               0.9754                  0                                     -0.9754
Mexican Pronghorn, Pronghorn                                                                Antilocapra americana                       0.9402                  0                                     -0.9402
Fringed Myotis                                                                              Myotis thysanodes                           0.9018                  0                                     -0.9018
North American Porcupine                                                                    Erethizon dorsatum                          1.8767                  1                                     -0.8767
Mountain Weasel, Mount Graham Red Squirrel, Red Squirrel                                    Tamiasciurus hudsonicus                     2.1423                  3                                      0.8577
Great Basin Pocket Mouse                                                                    Perognathus parvus                          0.8375                  0                                     -0.8375
Key Deer, Key Deer Toy Deer, White-tailed Deer                                              Odocoileus virginianus                      5.2106                  6                                      0.7894
Pinyon Mouse                                                                                Peromyscus truei                            1.7477                  1                                     -0.7477
Black-tailed Deer, Cedros Island Black-tailed Deer, Cedros Island Mule Deer, Mule Deer      Odocoileus hemionus                         3.2583                  4                                      0.7417
Yellow-bellied Marmot                                                                       Marmota flaviventris                        0.7340                  0                                     -0.7340
Heermann's Kangaroo Rat, Morro Bay Kangaroo-rat, Morro Bay Kangaroo Rat                     Dipodomys heermanni                         0.7332                  0                                     -0.7332
Northern Raccoon                                                                            Procyon lotor                               4.2869                  5                                      0.7131
Golden Mantled Ground Squirrel, Green River Basin Golden-mantled Ground Squirrel            Spermophilus lateralis                      1.6563                  1                                     -0.6563
Desert Woodrat                                                                              Neotoma lepida                              1.5889                  1                                     -0.5889
Bushy-tailed Woodrat, Bushy-talied Woodrat, Packrat, Woodrat                                Neotoma cinerea                             1.5871                  1                                     -0.5871
Amargosa Vole, California Vole                                                              Microtus californicus                       1.5072                  2                                      0.4928
North American Otter, North American River Otter, Northern River Otter                      Lontra canadensis                           0.4893                  0                                     -0.4893
Silver-haired Bat                                                                           Lasionycteris noctivagans                   1.4838                  1                                     -0.4838
American Black Bear                                                                         Ursus americanus                            1.4453                  1                                     -0.4453
Little Brown Bat, Little Brown Myotis                                                       Myotis lucifugus                            2.4117                  2                                     -0.4117
Richardson's Ground Squirrel                                                                Spermophilus richardsonii                   1.3850                  1                                     -0.3850
Fisher                                                                                      Martes pennanti                             0.6352                  1                                      0.3648
Mountain Cottontail, Nuttall's Cottontail                                                   Sylvilagus nuttallii                        0.3459                  0                                     -0.3459
Black-footed Ferret                                                                         Mustela nigripes                            0.6625                  1                                      0.3375
American Bison                                                                              Bison bison                                 2.3092                  2                                     -0.3092
Keen's Myotis                                                                               Myotis keenii                               0.7270                  1                                      0.2730
Striped Skunk                                                                               Mephitis mephitis                           2.2543                  2                                     -0.2543
Columbian Ground Squirrel                                                                   Spermophilus columbianus                    0.7467                  1                                      0.2533
Hawaiian Hoary Bat, Hoary Bat                                                               Lasiurus cinereus                           1.7508                  2                                      0.2492
Hidden Forest Chipmunk, Uinta Chipmunk                                                      Tamias umbrinus                             0.7954                  1                                      0.2046
Revillagigedo Island Red-backed Vole, Southern Red-backed Vole                              Myodes gapperi                              0.7964                  1                                      0.2036
Bighorn Sheep, Mountain Sheep                                                               Ovis canadensis                             2.2014                  2                                     -0.2014
Dall's Sheep, Thinhorn Sheep                                                                Ovis dalli                                  0.8048                  1                                      0.1952
Arctic Ground Squirrel                                                                      Spermophilus parryii                        0.8082                  1                                      0.1918
Least Chipmunk, New Mexico Least Chipmunk, Pe_asco Least Chipmunk, Selkirk Least Chipmunk   Tamias minimus                              0.8639                  1                                      0.1361
Long-eared Myotis                                                                           Myotis evotis                               0.8666                  1                                      0.1334
Yellow-pine Chipmunk                                                                        Tamias amoenus                              0.8669                  1                                      0.1331
Muskox, Musk Ox                                                                             Ovibos moschatus                            0.9212                  1                                      0.0788
California Myotis, Californian Myotis                                                       Myotis californicus                         0.9411                  1                                      0.0589
Spotted Bat                                                                                 Euderma maculatum                           0.9607                  1                                      0.0393
Northern Myotis                                                                             Myotis septentrionalis                      1.0237                  1                                     -0.0237

### Southern Central America""

Common Name                                                                                                                                                                             Species                      Predicted Viruses   Observed Viruses   Difference Between Observed and Predicted
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  --------------------------  ------------------  -----------------  ------------------------------------------
Gorgona White-fronted Capuchin, White-throated Capuchin                                                                                                                                 Cebus capucinus                         2.7655                  0                                     -2.7655
Ecuadorian Mantled Howling Monkey, Mantled Howler Monkey, South Pacific Blackish Howling Monkey                                                                                         Alouatta palliata                       2.1108                  0                                     -2.1108
Geoffroy's Tamarin, Geoffroys Tamarin, Red Crested Bare-face Tamarin                                                                                                                    Saguinus geoffroyi                      1.7406                  0                                     -1.7406
Toltec Cotton Rat                                                                                                                                                                       Sigmodon toltecus                       1.6642                  0                                     -1.6642
Jamaican Fruit-eating Bat                                                                                                                                                               Artibeus jamaicensis                    2.5044                  4                                      1.4956
Peter's Climbing Rat, Peters's Climbing Rat                                                                                                                                             Tylomys nudicaudus                      1.2966                  0                                     -1.2966
Alfaro's Rice Rat                                                                                                                                                                       Handleyomys alfaroi                     1.2633                  0                                     -1.2633
Mexican Deer Mouse                                                                                                                                                                      Peromyscus mexicanus                    1.2381                  0                                     -1.2381
Armored Rat                                                                                                                                                                             Hoplomys gymnurus                       1.1750                  0                                     -1.1750
Black Howling Monkey, Guatemalan Black Howler Monkey, Guatemalan Howler, Guatemalan Howling Monkey, Lawrences Howler Monkey, Mexican Black Howler Monkey, Yucat_n Black Howler Monkey   Alouatta pigra                          1.1746                  0                                     -1.1746
Coues's Rice Rat                                                                                                                                                                        Oryzomys couesi                         1.1038                  0                                     -1.1038
Gray Short-tailed Bat                                                                                                                                                                   Carollia subrufa                        1.0744                  0                                     -1.0744
Panamanian Spiny Pocket Mouse                                                                                                                                                           Liomys adspersus                        0.9951                  0                                     -0.9951
Central American Woolly Opossum                                                                                                                                                         Caluromys derbianus                     0.4753                  0                                     -0.4753
Black-handed Spider Monkey, Central American Spider Monkey, Geoffroy's Spider Monkey, Geoffroys Spider Monkey, Mono Colorado                                                            Ateles geoffroyi                        2.4573                  2                                     -0.4573
Mexican Harvest Mouse                                                                                                                                                                   Reithrodontomys mexicanus               0.9542                  1                                      0.0458

### West Central Africa:

Common Name                                                                                                        Species                      Predicted Viruses   Observed Viruses   Difference Between Observed and Predicted
-----------------------------------------------------------------------------------------------------------------  --------------------------  ------------------  -----------------  ------------------------------------------
Bonobo, Dwarf Chimpanzee, Gracile Chimpanzee, Pygmy Chimpanzee                                                     Pan paniscus                            1.7815                  6                                      4.2185
Lowland Gorilla, Western Gorilla                                                                                   Gorilla gorilla                         4.9016                  8                                      3.0984
Greater Spot-nosed Guenon, Greater White-nosed Monkey, Putty-nosed Monkey, Spot-nosed Guenon, White-nosed Guenon   Cercopithecus nictitans                 1.1528                  4                                      2.8472
African Buffalo                                                                                                    Syncerus caffer                         3.1433                  1                                     -2.1433
Gray-cheeked Mangabey, Grey-cheeked Mangabey, White-cheeked Mangabey                                               Lophocebus albigena                     0.9044                  3                                      2.0956
Franquet's Epauletted Fruit Bat                                                                                    Epomops franqueti                       1.0211                  3                                      1.9789
Mandrill                                                                                                           Mandrillus sphinx                       1.2146                  3                                      1.7854
Mona Guenon, Mona Monkey                                                                                           Cercopithecus mona                      1.4797                  3                                      1.5203
Yellow-spotted Brush-furred Rat                                                                                    Lophuromys flavopunctatus               0.8932                  2                                      1.1068
Jackson's Praomys, Jackson's Soft-furred Mouse                                                                     Praomys jacksoni                        0.9501                  2                                      1.0499
Crab-eating Mongoose, Isabelline Red-legged Sun Squirrel, Red-legged Sun Squirrel                                  Heliosciurus rufobrachium               0.9847                  0                                     -0.9847
King Colobus, Ursine Black-and-white Colobus, Western Black-and-white Colobus, Western Pied Colobus                Colobus polykomos                       0.9433                  0                                     -0.9433
Rusty-bellied Brush-furred Rat                                                                                     Lophuromys sikapusi                     1.0677                  2                                      0.9323
Drill                                                                                                              Mandrillus leucophaeus                  1.1336                  2                                      0.8664
African Elephant                                                                                                   Loxodonta africana                      1.1880                  2                                      0.8120
Forest Giant Pouched Rat, Giant Rat                                                                                Cricetomys emini                        0.6914                  0                                     -0.6914
Eastern Black-and-white Colobus, Guereza, Magistrate Colobus                                                       Colobus guereza                         2.3203                  3                                      0.6797
Peter's Duiker, Peters' Duiker                                                                                     Cephalophus callipygus                  0.4723                  1                                      0.5277
Bay Duiker                                                                                                         Cephalophus dorsalis                    0.4972                  0                                     -0.4972
Weyn's Duiker, Weyns' Duiker                                                                                       Cephalophus weynsi                      0.4931                  0                                     -0.4931
Red River Hog                                                                                                      Potamochoerus porcus                    0.5072                  1                                      0.4928
White-bellied Duiker                                                                                               Cephalophus leucogaster                 0.4841                  0                                     -0.4841
Black-fronted Duiker                                                                                               Cephalophus nigrifrons                  0.4719                  0                                     -0.4719
Pygmy Hippopotamus                                                                                                 Choeropsis liberiensis                  0.4542                  0                                     -0.4542
Bongo                                                                                                              Tragelaphus eurycerus                   0.5597                  1                                      0.4403
Peter's Mouse                                                                                                      Mus setulosus                           1.2277                  1                                     -0.2277
Tropical Vlei Rat                                                                                                  Otomys tropicalis                       1.2095                  1                                     -0.2095
Little Collared Fruit Bat                                                                                          Myonycteris torquata                    1.1086                  1                                     -0.1086
Collared Mangabey, Red-capped Mangabey, Sooty Mangabey, White-collared Mangabey                                    Cercocebus torquatus                    0.8964                  1                                      0.1036
Greater Long-fingered Bat                                                                                          Miniopterus inflatus                    1.0784                  1                                     -0.0784

### Central African Band:

Common Name                                                                                     Species                     Predicted Viruses   Observed Viruses   Difference Between Observed and Predicted
----------------------------------------------------------------------------------------------  -------------------------  ------------------  -----------------  ------------------------------------------
Green Monkey, Grivet Monkey, Malbrouk Monkey, Tantalus, Vervet Monkey                           Chlorocebus aethiops                   1.1200                  7                                      5.8800
Egyptian Fruit Bat, Egyptian Rousette, EGYPTIAN ROUSETTE                                        Rousettus aegyptiacus                  2.4347                  8                                      5.5653
African Grass Rat                                                                               Arvicanthis niloticus                  2.8486                  8                                      5.1514
Kemp's Gerbil                                                                                   Gerbilliscus kempi                     0.9767                  6                                      5.0233
Anubis Baboon, Olive Baboon                                                                     Papio anubis                           4.2415                  1                                     -3.2415
Thomson's Gazelle                                                                               Eudorcas thomsonii                     0.3697                  3                                      2.6303
Guinea Multimammate Mouse, Reddish-white Mastomys                                               Mastomys erythroleucus                 1.6755                  4                                      2.3245
Green Monkey                                                                                    Chlorocebus sabaeus                    1.0392                  3                                      1.9608
Angolan Free-tailed Bat                                                                         Tadarida condylura                     1.1100                  3                                      1.8900
Peter's Dwarf Epauletted Fruit Bat                                                              Micropteropus pusillus                 1.1796                  3                                      1.8204
Lesser Bushbaby, Lesser Galago, Northern Lesser Galago, Senegal Galago, Senegal Lesser Galago   Galago senegalensis                    1.6255                  0                                     -1.6255
White-tailed Mongoose                                                                           Ichneumia albicauda                    0.3897                  2                                      1.6103
Hubert's Mastomys, Huberts Mastomys                                                             Mastomys huberti                       0.7428                  2                                      1.2572
Roan Antelope                                                                                   Hippotragus equinus                    1.0617                  0                                     -1.0617
Geoffroy's Ground Squirrel, Striped Ground Squirrel                                             Xerus erythropus                       0.9920                  2                                      1.0080
Spotted Hyaena                                                                                  Crocuta crocuta                        1.0074                  2                                      0.9926
Gambian Epauletted Fruit Bat                                                                    Epomophorus gambianus                  0.9380                  0                                     -0.9380
Eloquent Horseshoe Bat                                                                          Rhinolophus eloquens                   1.1053                  2                                      0.8947
Hamadryas Baboon, Sacred Baboon                                                                 Papio hamadryas                        2.1528                  3                                      0.8472
Cape Warthog, Desert Warthog, Somali Warthog                                                    Phacochoerus aethiopicus               0.7780                  0                                     -0.7780
Waterbuck                                                                                       Kobus ellipsiprymnus                   0.7088                  0                                     -0.7088
Ethiopian Wolf, Simien Fox, Simien Jackal                                                       Canis simensis                         0.3425                  1                                      0.6575
Lesser Kudu                                                                                     Tragelaphus imberbis                   0.3563                  1                                      0.6437
Natal Mastomys, Natal Multimammate Mouse                                                        Mastomys natalensis                    6.4832                  7                                      0.5168
Slender Mongoose                                                                                Herpestes sanguineus                   0.5389                  1                                      0.4611
Guinea Baboon                                                                                   Papio papio                            2.5429                  3                                      0.4571
Oribi                                                                                           Ourebia ourebi                         0.4308                  0                                     -0.4308
Grant's Gazelle                                                                                 Nanger granti                          0.4016                  0                                     -0.4016
African Lion, Lion                                                                              Panthera leo                           2.6356                  3                                      0.3644
Typical Lemniscomys, Typical Striped Grass Mouse                                                Lemniscomys striatus                   1.7239                  2                                      0.2761
Common Genet, Ibiza Common Genet, Ibiza Genet                                                   Genetta genetta                        0.7322                  1                                      0.2678
Gelada Baboon                                                                                   Theropithecus gelada                   1.1527                  1                                     -0.1527
Aba Roundleaf Bat                                                                               Hipposideros abae                      1.1270                  1                                     -0.1270
Somali Grass Rat                                                                                Arvicanthis neumanni                   0.9104                  1                                      0.0896

### Southeastern China:

Common Name                                                                          Species                     Predicted Viruses   Observed Viruses   Difference Between Observed and Predicted
-----------------------------------------------------------------------------------  -------------------------  ------------------  -----------------  ------------------------------------------
Lesser Rice-field Rat, Losea Rat                                                     Rattus losea                           2.8739                  1                                     -1.8739
Intermediate Horseshoe Bat, Intermediat Horseshoe Bat                                Rhinolophus affinis                    1.5112                  0                                     -1.5112
Rickett's Big-footed Bat, Rickett's Big-footed Myotis                                Myotis pilosus                         0.8954                  0                                     -0.8954
Bear Macaque, Stump-tailed Macaque, Stumptail Macaque                                Macaca arctoides                       2.8798                  2                                     -0.8798
Japanese Pipistrelle, Japanese Pipistrelle                                           Pipistrellus abramus                   0.8753                  0                                     -0.8753
Oriental House Rat, Tanezumi Rat                                                     Rattus tanezumi                        1.8399                  1                                     -0.8399
Great Himalayan Leaf-nosed Bat, Great Leaf-nosed Bat, Great Roundleaf Bat            Hipposideros armiger                   1.7694                  1                                     -0.7694
Formosan Rock Macaque, Taiwanese Macaque, Taiwan Macaque                             Macaca cyclopis                        1.3903                  2                                      0.6097
Chinese Ferret-badger, Small-toothed Ferret-badger                                   Melogale moschata                      0.4542                  0                                     -0.4542
Pearson's Horseshoe Bat                                                              Rhinolophus pearsonii                  1.3539                  1                                     -0.3539
Big-eared Horseshoe Bat                                                              Rhinolophus macrotis                   1.1620                  1                                     -0.1620
Chinese Horseshoe Bat, Chinese Rufous Horseshoe Bat, Little Nepalese Horseshoe Bat   Rhinolophus sinicus                    1.1610                  1                                     -0.1610
Francois's Langur                                                                    Trachypithecus francoisi               0.9694                  1                                      0.0306
Gem-faced Civet, Masked Palm Civet                                                   Paguma larvata                         0.9708                  1                                      0.0292


#Conclusions
	
The reviewer articulated concerns about our models' ability to make out-of-sample predictions, arguing that cross-validation based on random folds does not adequately address this issue. This analysis shows that our models (especially *Zoonoses*, *Viruses*, and *Strict Viruses*) are robust to a systematic cross-validation that creates folds based on geographical/phylogenetic region ~ a non-random method to approximate out-of-sample testing. For each of these three models, only 4-5 substantial (n > 10) folds show evidence of bias, while 10-11 substantial folds are well-predicted. For the *Strict Zoonoses* model the evidence is more equivocal, with 8 substantial regions that show evidence of bias and 7 substantial regions which are well-predicted. 

