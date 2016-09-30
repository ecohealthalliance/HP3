# HP3: Zoogeographical Cross-Validation




# Zoogeographic Cross-Validation

In addition to randomly-selected k-fold cross-validation, we evaluated the robustness of our models via non-random geographic cross-validation: we systematically removed all observations from a zoogeographical region, re-fit the model using all observations from outside the region, then performed a non-parametric permutation test comparing the predicted values to the real values for that region.

In order to meaningfully organize geographic areas, we utilized mammalian zoogeographic regions from *Holz et al (2013)*, which are defined by distributions of and phylogenetic relationships between species. Using QGIS, a shapefile of these regions was intersected with IUCN's host ranges, and each host was assigned to only the region which contained the greatest proportion of its range. Results of the non-parametric permutation test are shown below; non-significant results indicate that model predictions are unbiased.



# Zoonoses GAM - All Associations

![](geo_cross_files/figure-html/all-zoo-1.png)<!-- -->

Dark green indicates unbiased regions, while dark red indicates regions with evidence of biased predictions. Light green and light red represent the same distinction, but these regions contain very few (less than ten) assigned species; blank areas were not assigned any hosts. 


Table: Biased Predictions Regions (n > 10)

 fold   n_fit   n_validate   p_value    mean_diff
-----  ------  -----------  --------  -----------
   10     562           22   0.00204    0.2929411
   14     550           34   0.01195   -0.4762261
   25     548           36   0.01309    0.3391528
   27     569           15   0.00000    0.4006503



Table: Unbiased Prediction Regions (n > 10)

 fold   n_fit   n_validate   p_value    mean_diff
-----  ------  -----------  --------  -----------
    1     525           59   0.90648   -0.0133606
    2     563           21   0.85646   -0.0208640
    4     562           22   0.13890    0.2514676
    5     567           17   0.57670    0.1131187
    9     485           99   0.62678   -0.0403560
   13     551           33   0.28016    0.0998548
   15     546           38   0.05577   -0.3288683
   16     523           61   0.19072   -0.1695227
   22     563           21   0.74397   -0.0990603
   26     550           34   0.68871   -0.0745897
   33     573           11   0.28392   -0.2836694

# All Viruses GAM - All Associations

![](geo_cross_files/figure-html/all-viruses-1.png)<!-- -->

Dark green indicates unbiased regions, while dark red indicates regions with evidence of biased predictions. Light green and light red represent the same distinction, but these regions contain very few (less than ten) assigned species; blank areas were not assigned any hosts. 


Table: Biased Predictions Regions (n > 10)

 fold   n_fit   n_validate   p_value    mean_diff
-----  ------  -----------  --------  -----------
   14     542           34   0.02693    0.9721444
   15     539           37   0.00039   -1.5026007
   16     515           61   0.00892    0.8336724
   27     562           14   0.00075   -1.5620484



Table: Unbiased Prediction Regions (n > 10)

 fold   n_fit   n_validate   p_value    mean_diff
-----  ------  -----------  --------  -----------
    1     517           59   0.81468   -0.0525084
    2     555           21   0.81989    0.0850285
    4     554           22   0.34162    0.9864253
    5     560           16   0.58294   -0.4241775
    9     477           99   0.21720    0.3872965
   10     555           21   0.38281   -0.2898189
   13     545           31   0.79006    0.0922787
   22     555           21   0.21781    1.1180907
   25     540           36   0.50059   -0.3674582
   26     542           34   0.80541   -0.1238044
   33     565           11   0.41377    0.6797741

# Zoonoses GAM - Strict Associations

![](geo_cross_files/figure-html/strict-zoo-1.png)<!-- -->

Dark green indicates unbiased regions, while dark red indicates regions with evidence of biased predictions. Light green and light red represent the same distinction, but these regions contain very few (less than ten) assigned 
species; blank areas were not assigned any hosts.  


Table: Biased Predictions Regions (n > 10)

 fold   n_fit   n_validate   p_value    mean_diff
-----  ------  -----------  --------  -----------
    1     517           59   0.04321   -0.1884559
    5     560           16   0.00000   -0.3820274
    9     477           99   0.03561   -0.2044080
   10     555           21   0.00374    0.6149406
   13     545           31   0.00440    0.8319298
   14     542           34   0.03829    0.3685310
   25     540           36   0.01817    0.2887942
   26     542           34   0.00744   -0.5019819


Table: Unbiased Prediction Regions (n > 10)

 fold   n_fit   n_validate   p_value    mean_diff
-----  ------  -----------  --------  -----------
    2     555           21   0.76253   -0.0348445
    4     554           22   0.12342   -0.3528833
   15     539           37   0.94864    0.0090656
   16     515           61   0.77754   -0.0243799
   22     555           21   0.78485    0.0467531
   27     562           14   0.62062    0.0876137
   33     565           11   0.70569   -0.0988195

# All Viruses GAM - Strict Associations

![](geo_cross_files/figure-html/strict-viruses-1.png)<!-- -->

Dark green indicates unbiased regions, while dark red indicates regions with evidence of biased predictions. Light green and light red represent the same distinction, but these regions contain very few (less than ten) assigned species; blank areas were not assigned any hosts. 


Table: Biased Predictions Regions (n > 10)

 fold   n_fit   n_validate   p_value    mean_diff
-----  ------  -----------  --------  -----------
    1     516           59   0.00094   -0.3823173
    5     559           16   0.00097   -1.0620662
   13     545           30   0.03082    0.5589708
   14     541           34   0.00602    0.9742460
   27     561           14   0.00466   -0.5790510



Table: Unbiased Prediction Regions (n > 10)

 fold   n_fit   n_validate   p_value    mean_diff
-----  ------  -----------  --------  -----------
    2     554           21   0.48814   -0.1669841
    4     553           22   0.68681   -0.3282123
    9     476           99   0.29357   -0.2082912
   10     554           21   0.41621    0.3041615
   15     538           37   0.24750    0.3711080
   16     514           61   0.79504   -0.0413395
   22     554           21   0.50259    0.5320988
   25     539           36   0.68994   -0.1171410
   26     541           34   0.53885   -0.1817830
   33     564           11   0.35462    0.5890869
