# HP3: Zoogeographical Cross-Validation




# Zoogeographic Cross-Validation

In addition to randomly-selected k-fold cross-validation, we evaluated the robustness of our models via non-random geographic cross-validation: we systematically removed all observations from a zoogeographical region, re-fit the model using all observations from outside the region, then performed a non-parametric permutation test comparing the predicted values to the observed values for that region.

In order to meaningfully organize geographic areas, we utilized mammalian zoogeographic regions from [*Holt et al (2013)*](http://dx.doi.org/10.1126/science.1228282) which are defined by distributions of and phylogenetic relationships between species. Using QGIS, a mammal-specific zoogeographical shapefile provided by [Holt's group](http://macroecology.ku.dk/resources/wallace) at the University of Copenhagen was intersected (using QGIS Vector > Geoprocessing Tools > Intersect) with a shapefile of IUCN's host ranges. Areas of these intersections were then calculated using an equal-area projection, and each host was assigned to only the region which contained the greatest proportion of its range. Results of the non-parametric permutation test are shown below; non-significant results indicate that model predictions are unbiased.



## Zoonoses GAM - All Associations

![](geo_cross_files/figure-html/all-zoo-1.png)<!-- -->

Dark green indicates unbiased regions, while dark red indicates regions with evidence of biased predictions. Light green and light red represent the same distinction, but these regions contain very few (less than ten) assigned species; blank areas were not assigned any hosts. 


Table: Biased Predictions Regions (n > 10)

Region                        Observations Fit   Observations Held Out   P-value   Mean Prediction Difference (Number of Zoonoses)
---------------------------  -----------------  ----------------------  --------  ------------------------------------------------
Southeastern South America                 562                      22    0.0020                                            0.2929
Central African Band                       550                      34    0.0120                                           -0.4762
Northern Eurussia                          548                      36    0.0131                                            0.3392
Southeastern China                         569                      15    0.0000                                            0.4007



Table: Unbiased Prediction Regions (n > 10)

Region                             Observations Fit   Observations Held Out   P-value   Mean Prediction Difference (Number of Zoonoses)
--------------------------------  -----------------  ----------------------  --------  ------------------------------------------------
Northern America                                525                      59    0.9064                                           -0.0134
Southwestern North America                      563                      21    0.8563                                           -0.0209
Central / Eastern North America                 562                      22    0.1389                                            0.2515
Southern Central America                        567                      17    0.5767                                            0.1131
Northern South America                          485                      99    0.6268                                           -0.0404
West Central Africa                             551                      33    0.2802                                            0.0999
Europe                                          546                      38    0.0558                                           -0.3289
South Africa                                    523                      61    0.1907                                           -0.1695
India                                           563                      21    0.7440                                           -0.0991
Southeast Asia                                  550                      34    0.6887                                           -0.0746
Southern Australia                              573                      11    0.2839                                           -0.2837


## All Viruses GAM - All Associations

![](geo_cross_files/figure-html/all-viruses-1.png)<!-- -->

Dark green indicates unbiased regions, while dark red indicates regions with evidence of biased predictions. Light green and light red represent the same distinction, but these regions contain very few (less than ten) assigned species; blank areas were not assigned any hosts. 


Table: Biased Predictions Regions (n > 10)

Region                  Observations Fit   Observations Held Out   P-value   Mean Prediction Difference (Number of Viruses)
---------------------  -----------------  ----------------------  --------  -----------------------------------------------
Central African Band                 542                      34    0.0265                                           0.9722
Europe                               539                      37    0.0004                                          -1.5026
South Africa                         515                      61    0.0094                                           0.8337
Southeastern China                   562                      14    0.0008                                          -1.5621



Table: Unbiased Prediction Regions (n > 10)

Region                             Observations Fit   Observations Held Out   P-value   Mean Prediction Difference (Number of Viruses)
--------------------------------  -----------------  ----------------------  --------  -----------------------------------------------
Northern America                                517                      59    0.8139                                          -0.0525
Southwestern North America                      555                      21    0.8171                                           0.0851
Central / Eastern North America                 554                      22    0.2976                                           1.0545
Southern Central America                        560                      16    0.5848                                          -0.4242
Northern South America                          477                      99    0.2181                                           0.3873
Southeastern South America                      555                      21    0.3842                                          -0.2899
West Central Africa                             545                      31    0.7902                                           0.0921
India                                           555                      21    0.2203                                           1.1181
Northern Eurussia                               540                      36    0.5090                                          -0.3578
Southeast Asia                                  542                      34    0.8073                                          -0.1238
Southern Australia                              565                      11    0.4133                                           0.6797



## Zoonoses GAM - Strict Associations

![](geo_cross_files/figure-html/strict-zoo-1.png)<!-- -->

Dark green indicates unbiased regions, while dark red indicates regions with evidence of biased predictions. Light green and light red represent the same distinction, but these regions contain very few (less than ten) assigned 
species; blank areas were not assigned any hosts.  


Table: Biased Predictions Regions (n > 10)

Region                        Observations Fit   Observations Held Out   P-value   Mean Prediction Difference (Number of Zoonoses)
---------------------------  -----------------  ----------------------  --------  ------------------------------------------------
Northern America                           517                      59    0.0440                                           -0.1885
Southern Central America                   560                      16    0.0000                                           -0.3820
Northern South America                     477                      99    0.0357                                           -0.2044
Southeastern South America                 555                      21    0.0038                                            0.6149
West Central Africa                        545                      31    0.0046                                            0.8319
Central African Band                       542                      34    0.0395                                            0.3685
Northern Eurussia                          540                      36    0.0181                                            0.2888
Southeast Asia                             542                      34    0.0075                                           -0.5020


Table: Unbiased Prediction Regions (n > 10)

Region                             Observations Fit   Observations Held Out   P-value   Mean Prediction Difference (Number of Zoonoses)
--------------------------------  -----------------  ----------------------  --------  ------------------------------------------------
Southwestern North America                      555                      21    0.7628                                           -0.0347
Central / Eastern North America                 554                      22    0.1219                                           -0.3529
Europe                                          539                      37    0.9494                                            0.0091
South Africa                                    515                      61    0.7743                                           -0.0244
India                                           555                      21    0.7854                                            0.0468
Southeastern China                              562                      14    0.6229                                            0.0876
Southern Australia                              565                      11    0.7047                                           -0.0988


## All Viruses GAM - Strict Associations

![](geo_cross_files/figure-html/strict-viruses-1.png)<!-- -->

Dark green indicates unbiased regions, while dark red indicates regions with evidence of biased predictions. Light green and light red represent the same distinction, but these regions contain very few (less than ten) assigned species; blank areas were not assigned any hosts. 


Table: Biased Predictions Regions (n > 10)

Region                      Observations Fit   Observations Held Out   P-value   Mean Prediction Difference (Number of Viruses)
-------------------------  -----------------  ----------------------  --------  -----------------------------------------------
Northern America                         516                      59    0.0006                                          -0.3823
Southern Central America                 559                      16    0.0009                                          -1.0621
West Central Africa                      545                      30    0.0300                                           0.5590
Central African Band                     541                      34    0.0069                                           0.9742
Southeastern China                       561                      14    0.0047                                          -0.5791



Table: Unbiased Prediction Regions (n > 10)

Region                             Observations Fit   Observations Held Out   P-value   Mean Prediction Difference (Number of Viruses)
--------------------------------  -----------------  ----------------------  --------  -----------------------------------------------
Southwestern North America                      554                      21    0.4882                                          -0.1670
Central / Eastern North America                 553                      22    0.6846                                          -0.3282
Northern South America                          476                      99    0.2950                                          -0.2083
Southeastern South America                      554                      21    0.4198                                           0.3042
Europe                                          538                      37    0.2504                                           0.3711
South Africa                                    514                      61    0.7942                                          -0.0413
India                                           554                      21    0.5050                                           0.5320
Northern Eurussia                               539                      36    0.6909                                          -0.1171
Southeast Asia                                  541                      34    0.5390                                          -0.1818
Southern Australia                              564                      11    0.3557                                           0.5891

##Cross-validation Interpretation
The reviewer articulated concerns about our models' ability to make out-of-sample predictions, arguing that cross-validation based on random folds does not adequately address this issue. Accordingly, we performed a non-random cross-validation using zoogeography to determine folds. The results of this procedure show that for the *All Zoonoses*, *All Viruses*, and *Strict Viruses* models, most regions do not show evidence of bias (that is, a systematic over- or under-prediction of model outcome greater than what one would expect due to chance). For each of these three models, only 4-5 substantial (n > 10) folds show evidence of bias, while 10-11 substantial folds do not. The mean size of these prediction differences are measured in units of each model outcome: for the All Zoonoses GAM in Zoonoses and in the Viruses GAMs in Viruses. It is important to note that the significance tests in this type of cross-validation are subject to multiple comparison concerns, just like those in the random cross-validation, so the occasional significant finding should not be over-interpreted. Nevertheless, to be conservative in the performance evaluation of our model we have made no correction for the many comparisons being made at the 5% significance level. 

For the *Strict Zoonoses* model the evidence is more equivocal, with 8 substantial regions that show evidence of bias and 7 substantial regions which show no evidence of bias. This suggests that there might be some unaccounted-for association between zoogeographical region and number of strictly-defined zoonoses present in animals. We took a closer look at each biased region for each model, examining the over- or under-prediction patterns on a species-by-species level; however, no clear interpretable pattern (besides their region) was evident. 

The presence of biased regions across the models suggested the possibility that there is some association between zoogeographical region and our outcomes of interest, but the cross-validation procedure is not the appropriate way to assess this relationship. To that end, we added zoogeographical region as a categorical random effect to the best-fit models for each of our four outcomes.

#Region as Random Effect

Below we add zoographical region as a categorical random effect to each of our best-fit GAMs. The model fit and variable relative deviance explained comparisons for each model follow:

## All Zoonoses GAM
Adding zoogeographical region as a categorical random effect to our best-fit All Zoonoses GAM does not improve the model fit, as seen in the tables below:


Table: All Zoonoses Model Comparison

                      Original Model   Region Model
-------------------  ---------------  -------------
AICs                       1517.5834      1517.5836
Deviance Explained            0.3368         0.3368



Table: All Zoonoses: Original vs. Region Model Relative Deviance Explained

Term                     Original Model Relative Deviance Explained   Region Model Relative Deviance Explained
----------------------  -------------------------------------------  -----------------------------------------
hAllZACitesLn                                                0.1078                                     0.1078
hHuntedIUCN                                                  0.0075                                     0.0075
hOrderCETARTIODACTYLA                                        0.3454                                     0.3454
hOrderCHIROPTERA                                             0.0591                                     0.0591
hOrderDIPROTODONTIA                                          0.0224                                     0.0224
hOrderPERAMELEMORPHIA                                        0.0458                                     0.0458
hOrderPERISSODACTYLA                                         0.0555                                     0.0555
hOrderSCANDENTIA                                             0.0482                                     0.0482
PdHoSa.cbCst                                                 0.1869                                     0.1869
UrbRurPopRatioLn                                             0.1213                                     0.1213
zg_region                                                        NA                                     0.0000
  
  
## All Viruses GAM  
Adding zoogeographical region as a categorical random effect to our best-fit All Viruses GAM improves the model, as seen by the decrease in AIC and the increase in deviance explained.


Table: All Viruses Model Comparison

                      Original Model   Region Model
-------------------  ---------------  -------------
AICs                       2330.1757      2301.8910
Deviance Explained            0.4918         0.5254



Table: All Viruses: Original vs. Region Model Relative Deviance Explained

Term                     Original Model Relative Deviance Explained   Region Model Relative Deviance Explained
----------------------  -------------------------------------------  -----------------------------------------
hDiseaseZACitesLn                                            0.6481                                     0.6512
hMassGramsPVR                                                0.0191                                     0.0207
hOrderCETARTIODACTYLA                                        0.0186                                     0.0112
hOrderCHIROPTERA                                             0.0994                                     0.1174
hOrderEULIPOTYPHLA                                           0.0108                                     0.0072
hOrderPERISSODACTYLA                                         0.0141                                     0.0147
hOrderPRIMATES                                               0.0252                                     0.0196
hOrderRODENTIA                                               0.0479                                     0.0498
LnAreaHost                                                   0.0158                                     0.0112
S20                                                          0.1009                                     0.0092
zg_region                                                        NA                                     0.0879
  

## Strict Zoonoses GAM
Adding zoogeographical region as a categorical random effect to our best-fit Strict Zoonoses GAM improves the model, as seen by the decrease in AIC and the increase in deviance explained.


Table: Strict Zoonoses Model Comparison

                      Original Model   Region Model
-------------------  ---------------  -------------
AICs                        1092.285      1080.4189
Deviance Explained             0.236         0.2858



Table: Strict Zoonoses: Original vs. Region Model Relative Deviance Explained

Term                     Original Model Relative Deviance Explained   Region Model Relative Deviance Explained
----------------------  -------------------------------------------  -----------------------------------------
hDiseaseZACitesLn                                            0.0376                                     0.0199
hMassGramsPVR                                                0.0112                                     0.0191
hOrderCETARTIODACTYLA                                        0.2802                                     0.2367
hOrderDIPROTODONTIA                                          0.0275                                     0.0348
hOrderLAGOMORPHA                                             0.0088                                     0.0049
hOrderPERISSODACTYLA                                         0.0500                                     0.0394
hOrderPRIMATES                                               0.0010                                     0.0105
HumPopDensLnChg                                              0.0434                                     0.0012
PdHoSa.cbCst                                                 0.3448                                     0.2243
UrbRurPopRatioChg                                            0.1955                                     0.1586
zg_region                                                        NA                                     0.2506
  

##Strict Viruses GAM
Adding zoogeographical region as a categorical random effect to our best-fit Strict Viruses GAM improves the model, as seen by the decrease in AIC and the increase in deviance explained.


Table: Strict Viruses Model Comparison

                      Original Model   Region Model
-------------------  ---------------  -------------
AICs                       1730.9954       1703.647
Deviance Explained            0.3585          0.399



Table: Strict Viruses: Original vs. Region Model Relative Deviance Explained

Term                     Original Model Relative Deviance Explained   Region Model Relative Deviance Explained
----------------------  -------------------------------------------  -----------------------------------------
hDiseaseZACitesLn                                            0.5363                                     0.4892
hMassGramsPVR                                                0.0276                                     0.0247
hOrderCHIROPTERA                                             0.1223                                     0.1219
hOrderCINGULATA                                              0.0056                                     0.0048
hOrderEULIPOTYPHLA                                           0.0037                                     0.0041
hOrderPERAMELEMORPHIA                                        0.0036                                     0.0045
hOrderPRIMATES                                               0.1178                                     0.1062
hOrderRODENTIA                                               0.1258                                     0.1177
hOrderSCANDENTIA                                             0.0029                                     0.0039
LnAreaHost                                                   0.0153                                     0.0000
S20                                                          0.0390                                     0.0079
zg_region                                                        NA                                     0.1152
  

## Random Effect Model Interpretation  
For three of our best-fit GAMS (*All Viruses*, *Strict Zoonoses*, and *Strict Viruses*) the addition of zoogeographical region as a categorical random effect decreased the model AIC and increased the deviance explained by 3-5%. These results support the reviewer's suggestion that there might be a stronger relationship between geography and our outcomes of interest than was previously accounted for in these models. The *All Zoonoses* model, which is used to create the series of maps in the main manuscript, does not improve with the inclusion of zoogeographical region.

Taking a closer look at the change in relative deviance explained when we add zoogeographical region, we see most of the variables with substantial decreases in deviance explained when region is included are closely connected to geography: LnAreaHost (host area), S20 (species range 20% overlap), HumPopDensLnChg (human population density change). This is not surprising, since the inclusion of another (likely non-independent) geographic variable might be expected to siphon away the relative effect of these variables, although over-interpreting the specific changes in deviance explained by competing terms is inappropriate. We might have more deeply investigated the details of this zoogeographical variable by separating out the effect of each region during our model selection process (as we did with taxonomic Order); however, we felt that the improved predictive power of a model using region-specific terms was offset by the decreased interpretability of these terms -- especially when compared to the pre-existing geographical variables, such as host area or overlapping species range. The association between variables like host range or human population density change and our outcomes of interest are interpretable in relevant, biologically plausible ways; in pursuing our goal to both predict and understand, we choose to trade off some gains in prediction for interpretability in the case of zoogeographical region. 

# Conclusion
The zoogeographical cross-validation procedure and the subsequent inclusion of region into our GAMs reveals that for the *All Viruses*, *Strict Zoonoses*, and *Strict Viruses* models, the addition of a region term would improve deviance explained by 3-5%. However, this modest increase in predictive power does come with some cost in interpretation, so we decided not to include zoogeographical region in our final models. 

It is evident that at the core of the reviewer's astute questions regarding these models is an important concern about the translation of GAM predictions, whose parameter estimates' uncertainty and deviance explained can be clearly stated or visualized, into layered raster maps, whose uncertainty is more difficult to convey to readers. This point is well-taken, and we do not wish to invite over-interpretation of the regions identified by our maps: they are a result of imperfect models that only explain a portion of deviance in the data. In order to more explicitly express this fact, we have included additional maps that illustate this uncertainty. 
