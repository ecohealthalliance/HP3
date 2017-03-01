# Supplementary Information: GAM Models





# Zoonoses GAM - All Associations



Terms in models with ΔAIC < 2.  All continuous terms effects are represented
as splines, all discrete terms as random effects:


     ΔAIC  Terms in Model                                                                                                                                                                                                               
---------  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 0.000000  offset(LnTotNumVirus) + hDiseaseZACitesLn + hHuntedIUCN + hOrderCETARTIODACTYLA + hOrderCHIROPTERA + hOrderDIPROTODONTIA + hOrderPERAMELEMORPHIA + hOrderPERISSODACTYLA + hOrderSCANDENTIA + PdHoSa.cbCst + UrbRurPopRatioLn 
 1.650939  offset(LnTotNumVirus) + hDiseaseZACitesLn + hHuntedIUCN + hOrderCETARTIODACTYLA + hOrderCHIROPTERA + hOrderDIPROTODONTIA + hOrderPERAMELEMORPHIA + hOrderPERISSODACTYLA + hOrderSCANDENTIA + PdHoSaSTPD + UrbRurPopRatioLn   

Partial effect plots of all terms in top model:

![](gam_supp_info_files/figure-html/all-zoo-plot-1.png)<!-- -->

Summary of top model:


```
## 
## Family: poisson 
## Link function: log 
## 
## Formula:
## NSharedWithHoSa ~ s(hDiseaseZACitesLn, bs = "tp", k = 7) + s(hHuntedIUCN, 
##     bs = "re") + s(hOrderCETARTIODACTYLA, bs = "re") + s(hOrderCHIROPTERA, 
##     bs = "re") + s(hOrderDIPROTODONTIA, bs = "re") + s(hOrderPERAMELEMORPHIA, 
##     bs = "re") + s(hOrderPERISSODACTYLA, bs = "re") + s(hOrderSCANDENTIA, 
##     bs = "re") + s(PdHoSa.cbCst, bs = "tp", k = 7) + s(UrbRurPopRatioLn, 
##     bs = "tp", k = 7) + offset(LnTotNumVirus)
## 
## Parametric coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  -0.3381     0.0408  -8.288   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Approximate significance of smooth terms:
##                             edf Ref.df Chi.sq  p-value    
## s(hDiseaseZACitesLn)     1.1892      6  5.652  0.01821 *  
## s(hHuntedIUCN)           0.3661      1  0.769  0.16501    
## s(hOrderCETARTIODACTYLA) 0.8847      1 27.207 8.99e-08 ***
## s(hOrderCHIROPTERA)      0.7063      1  4.438  0.01491 *  
## s(hOrderDIPROTODONTIA)   0.4302      1  0.728  0.19303    
## s(hOrderPERAMELEMORPHIA) 0.7790      1  0.760  0.32327    
## s(hOrderPERISSODACTYLA)  0.7632      1  3.279  0.03866 *  
## s(hOrderSCANDENTIA)      0.7877      1  0.808  0.31102    
## s(PdHoSa.cbCst)          1.8802      6 12.634  0.00197 ** 
## s(UrbRurPopRatioLn)      1.2494      6 10.007  0.00201 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## R-sq.(adj) =  0.891   Deviance explained =   33%
## UBRE = -0.59936  Scale est. = 1         n = 584
```

Relative fraction of deviance explained by each variable in the top model:


Term                     Relative Deviance Explained
----------------------  ----------------------------
hDiseaseZACitesLn                              7.53%
hHuntedIUCN                                    1.33%
hOrderCETARTIODACTYLA                          36.4%
hOrderCHIROPTERA                               6.59%
hOrderDIPROTODONTIA                            1.74%
hOrderPERAMELEMORPHIA                           4.8%
hOrderPERISSODACTYLA                           6.36%
hOrderSCANDENTIA                               5.34%
PdHoSa.cbCst                                   16.8%
UrbRurPopRatioLn                               13.1%

10-fold cross-validation.  Good fit indicated by *non*-significant p-values:


Fold    Observations Fit   Observations Held Out   P-value   Mean Error
-----  -----------------  ----------------------  --------  -----------
1                    525                      59     0.776   -0.0334547
2                    525                      59     0.845    0.0270573
3                    525                      59     0.292    0.1052307
4                    525                      59     0.403   -0.0801936
5                    526                      58     0.606    0.0587951
6                    526                      58     0.082    0.1875158
7                    526                      58     0.085   -0.1922741
8                    526                      58     0.123   -0.2221036
9                    526                      58     0.437    0.0701885
10                   526                      58     0.640   -0.0564995

# Zoonoses GAM - Strict Associations



Terms in models with ΔAIC < 2.  All continuous terms effects are represented
as splines, all discrete terms as random effects:


 ΔAIC  Terms in Model                                                                                                                                                                                                          
-----  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    0  offset(LnTotNumVirus) + hDiseaseZACitesLn + hMassGramsPVR + hOrderCETARTIODACTYLA + hOrderDIPROTODONTIA + hOrderLAGOMORPHA + hOrderPERISSODACTYLA + hOrderPRIMATES + HumPopDensLnChg + PdHoSa.cbCst + UrbRurPopRatioChg 

Partial effect plots of all terms in top model:

![](gam_supp_info_files/figure-html/all-zoo-strict-plot-1.png)<!-- -->

Summary of top model:


```
## 
## Family: poisson 
## Link function: log 
## 
## Formula:
## NSharedWithHoSa_strict ~ s(hDiseaseZACitesLn, bs = "tp", k = 7) + 
##     s(hMassGramsPVR, bs = "tp", k = 7) + s(hOrderCETARTIODACTYLA, 
##     bs = "re") + s(hOrderDIPROTODONTIA, bs = "re") + s(hOrderLAGOMORPHA, 
##     bs = "re") + s(hOrderPERISSODACTYLA, bs = "re") + s(hOrderPRIMATES, 
##     bs = "re") + s(HumPopDensLnChg, bs = "tp", k = 7) + s(PdHoSa.cbCst, 
##     bs = "tp", k = 7) + s(UrbRurPopRatioChg, bs = "tp", k = 7) + 
##     offset(LnTotNumVirus)
## 
## Parametric coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -1.34951    0.05957  -22.66   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Approximate significance of smooth terms:
##                             edf Ref.df Chi.sq  p-value    
## s(hDiseaseZACitesLn)     1.2094      6  5.034  0.01426 *  
## s(hMassGramsPVR)         0.1155      6  0.122  0.29403    
## s(hOrderCETARTIODACTYLA) 0.9429      1 22.929 7.48e-07 ***
## s(hOrderDIPROTODONTIA)   0.7079      1  2.388  0.06601 .  
## s(hOrderLAGOMORPHA)      0.4215      1  0.704  0.19560    
## s(hOrderPERISSODACTYLA)  0.8255      1  0.859  0.30760    
## s(hOrderPRIMATES)        0.2845      1  0.621  0.09683 .  
## s(HumPopDensLnChg)       1.4738      6  3.164  0.13164    
## s(PdHoSa.cbCst)          2.3586      6 56.125 8.67e-06 ***
## s(UrbRurPopRatioChg)     4.0467      6 16.880  0.00208 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## R-sq.(adj) =  0.654   Deviance explained = 23.6%
## UBRE = -0.15735  Scale est. = 1         n = 576
```

Relative fraction of deviance explained by each variable in the top model:


Term                     Relative Deviance Explained
----------------------  ----------------------------
hDiseaseZACitesLn                              3.82%
hMassGramsPVR                                   1.1%
hOrderCETARTIODACTYLA                            28%
hOrderDIPROTODONTIA                            2.75%
hOrderLAGOMORPHA                              0.876%
hOrderPERISSODACTYLA                           5.01%
hOrderPRIMATES                                0.103%
HumPopDensLnChg                                 4.3%
PdHoSa.cbCst                                   34.5%
UrbRurPopRatioChg                              19.5%

10-fold cross-validation.  Good fit indicated by *non*-significant p-values:


Fold    Observations Fit   Observations Held Out   P-value   Mean Error
-----  -----------------  ----------------------  --------  -----------
1                    518                      58     0.060    0.2070057
2                    518                      58     0.751    0.0328970
3                    518                      58     0.131   -0.1400915
4                    518                      58     0.491   -0.0535195
5                    518                      58     0.452    0.0852502
6                    518                      58     0.100   -0.1517403
7                    519                      57     0.850   -0.0224318
8                    519                      57     0.964    0.0086410
9                    519                      57     0.210    0.1272233
10                   519                      57     0.651   -0.1506230

# Zoonoses GAM - All Associations without Reverse Zoonoses



Terms in models with ΔAIC < 2.  All continuous terms effects are represented
as splines, all discrete terms as random effects:


      ΔAIC  Terms in Model                                                                                                                                                                                                                               
----------  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 0.0000000  offset(LnTotNumVirus) + hDiseaseZACitesLn + hHuntedIUCN + hOrderCETARTIODACTYLA + hOrderCHIROPTERA + hOrderDIPROTODONTIA + hOrderPERAMELEMORPHIA + hOrderPERISSODACTYLA + hOrderSCANDENTIA + HumPopDensLnChg + PdHoSaSTPD + UrbRurPopRatioLn 
 0.7056058  offset(LnTotNumVirus) + hDiseaseZACitesLn + hHuntedIUCN + hOrderCETARTIODACTYLA + hOrderCHIROPTERA + hOrderDIPROTODONTIA + hOrderPERAMELEMORPHIA + hOrderPERISSODACTYLA + hOrderSCANDENTIA + PdHoSa.cbCst + UrbRurPopRatioLn                 

Partial effect plots of all terms in top model:

![](gam_supp_info_files/figure-html/all-zoo-norev-plot-1.png)<!-- -->

Summary of top model:


```
## 
## Family: poisson 
## Link function: log 
## 
## Formula:
## NSharedWithHoSa_norev ~ s(hDiseaseZACitesLn, bs = "tp", k = 7) + 
##     s(hHuntedIUCN, bs = "re") + s(hOrderCETARTIODACTYLA, bs = "re") + 
##     s(hOrderCHIROPTERA, bs = "re") + s(hOrderDIPROTODONTIA, bs = "re") + 
##     s(hOrderPERAMELEMORPHIA, bs = "re") + s(hOrderPERISSODACTYLA, 
##     bs = "re") + s(hOrderSCANDENTIA, bs = "re") + s(HumPopDensLnChg, 
##     bs = "tp", k = 7) + s(PdHoSaSTPD, bs = "tp", k = 7) + s(UrbRurPopRatioLn, 
##     bs = "tp", k = 7) + offset(LnTotNumVirus)
## 
## Parametric coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -0.35023    0.04169    -8.4   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Approximate significance of smooth terms:
##                             edf Ref.df Chi.sq p-value    
## s(hDiseaseZACitesLn)     1.2482      6  6.122 0.01524 *  
## s(hHuntedIUCN)           0.2941      1  0.654 0.15257    
## s(hOrderCETARTIODACTYLA) 0.8799      1 27.211 1.2e-07 ***
## s(hOrderCHIROPTERA)      0.7103      1  5.358 0.00911 ** 
## s(hOrderDIPROTODONTIA)   0.8395      1  3.445 0.03841 *  
## s(hOrderPERAMELEMORPHIA) 0.8029      1  0.739 0.33730    
## s(hOrderPERISSODACTYLA)  0.7513      1  3.197 0.04001 *  
## s(hOrderSCANDENTIA)      0.7902      1  0.799 0.31460    
## s(HumPopDensLnChg)       0.6123      6  1.062 0.16953    
## s(PdHoSaSTPD)            2.0388      6 12.011 0.05483 .  
## s(UrbRurPopRatioLn)      1.0733      6  9.358 0.00153 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## R-sq.(adj) =   0.88   Deviance explained = 31.5%
## UBRE = -0.5744  Scale est. = 1         n = 583
```

Relative fraction of deviance explained by each variable in the top model:


Term                     Relative Deviance Explained
----------------------  ----------------------------
hDiseaseZACitesLn                              10.3%
hHuntedIUCN                                    1.29%
hOrderCETARTIODACTYLA                          33.1%
hOrderCHIROPTERA                                5.2%
hOrderDIPROTODONTIA                            5.43%
hOrderPERAMELEMORPHIA                          6.42%
hOrderPERISSODACTYLA                           6.18%
hOrderSCANDENTIA                               5.78%
HumPopDensLnChg                                3.34%
PdHoSaSTPD                                     14.5%
UrbRurPopRatioLn                               8.44%

10-fold cross-validation.  Good fit indicated by *non*-significant p-values:


Fold    Observations Fit   Observations Held Out   P-value   Mean Error
-----  -----------------  ----------------------  --------  -----------
1                    524                      59     0.636   -0.0657058
2                    524                      59     0.116   -0.2195015
3                    524                      59     0.261    0.1546401
4                    525                      58     0.770    0.0250976
5                    525                      58     0.979   -0.0029883
6                    525                      58     0.924    0.0101716
7                    525                      58     0.019    0.1646305
8                    525                      58     0.361   -0.1337026
9                    525                      58     0.260    0.0810766
10                   525                      58     0.606   -0.0539774

# All Viruses GAM - All Associations



Terms in models with ΔAIC < 2.  All continuous terms effects are represented
as splines, all discrete terms as random effects:


 ΔAIC  Terms in Model                                                                                                                                                                
-----  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    0  hDiseaseZACitesLn + hMassGramsPVR + hOrderCETARTIODACTYLA + hOrderCHIROPTERA + hOrderEULIPOTYPHLA + hOrderPERISSODACTYLA + hOrderPRIMATES + hOrderRODENTIA + LnAreaHost + S20 

Partial effect plots of all terms in top model:

![](gam_supp_info_files/figure-html/all-vir-plot-1.png)<!-- -->


Summary of top model:


```
## 
## Family: poisson 
## Link function: log 
## 
## Formula:
## TotVirusPerHost ~ s(hDiseaseZACitesLn, bs = "cs", k = 7) + s(hMassGramsPVR, 
##     bs = "cs", k = 7) + s(hOrderCETARTIODACTYLA, bs = "re") + 
##     s(hOrderCHIROPTERA, bs = "re") + s(hOrderEULIPOTYPHLA, bs = "re") + 
##     s(hOrderPERISSODACTYLA, bs = "re") + s(hOrderPRIMATES, bs = "re") + 
##     s(hOrderRODENTIA, bs = "re") + s(LnAreaHost, bs = "cs", k = 7) + 
##     s(S20, bs = "cs", k = 7)
## 
## Parametric coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  0.51842    0.06969   7.439 1.01e-13 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Approximate significance of smooth terms:
##                             edf Ref.df   Chi.sq  p-value    
## s(hDiseaseZACitesLn)     5.5484      6 1847.372  < 2e-16 ***
## s(hMassGramsPVR)         3.8209      6  216.724 0.008534 ** 
## s(hOrderCETARTIODACTYLA) 0.9366      1   24.340 0.000235 ***
## s(hOrderCHIROPTERA)      1.0000      1  154.883 2.53e-16 ***
## s(hOrderEULIPOTYPHLA)    0.8481      1    5.870 0.008921 ** 
## s(hOrderPERISSODACTYLA)  1.0000      1    9.946 0.001320 ** 
## s(hOrderPRIMATES)        0.9435      1   34.387 1.54e-05 ***
## s(hOrderRODENTIA)        0.9933      1   95.293 8.40e-09 ***
## s(LnAreaHost)            3.5804      6   18.950 0.024870 *  
## s(S20)                   5.1613      6  299.708 7.02e-15 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## R-sq.(adj) =  0.494   Deviance explained = 49.3%
## UBRE = 0.36401  Scale est. = 1         n = 576
```

Relative fraction of deviance explained by each variable in the top model:


Term                     Relative Deviance Explained
----------------------  ----------------------------
hDiseaseZACitesLn                              64.9%
hMassGramsPVR                                   1.9%
hOrderCETARTIODACTYLA                          1.84%
hOrderCHIROPTERA                               9.92%
hOrderEULIPOTYPHLA                             1.08%
hOrderPERISSODACTYLA                           1.41%
hOrderPRIMATES                                 2.51%
hOrderRODENTIA                                  4.8%
LnAreaHost                                      1.6%
S20                                              10%

10-fold cross-validation.  Good fit indicated by *non*-significant p-values:


Fold    Observations Fit   Observations Held Out   P-value   Mean Error
-----  -----------------  ----------------------  --------  -----------
1                    518                      58     0.054    0.8392413
2                    518                      58     0.341   -0.2544546
3                    518                      58     0.719   -0.0961621
4                    518                      58     0.233    0.5595995
5                    518                      58     0.440    0.2562939
6                    518                      58     0.010   -0.7324828
7                    519                      57     0.469   -0.2631538
8                    519                      57     0.236   -0.3085747
9                    519                      57     0.111   -0.4106184
10                   519                      57     0.152    0.5007197

# All Viruses GAM - Strict Associations



Terms in models with ΔAIC < 2.  All continuous terms effects are represented
as splines, all discrete terms as random effects:


 ΔAIC  Terms in Model                                                                                                                                                                              
-----  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    0  hDiseaseZACitesLn + hMassGramsPVR + hOrderCHIROPTERA + hOrderCINGULATA + hOrderEULIPOTYPHLA + hOrderPERAMELEMORPHIA + hOrderPRIMATES + hOrderRODENTIA + hOrderSCANDENTIA + LnAreaHost + S20 

Partial effect plots of all terms in top model:

![](gam_supp_info_files/figure-html/all-vir-strict-plot-1.png)<!-- -->

Summary of top model:


```
## 
## Family: poisson 
## Link function: log 
## 
## Formula:
## TotVirusPerHost_strict ~ s(hDiseaseZACitesLn, bs = "cs", k = 7) + 
##     s(hMassGramsPVR, bs = "cs", k = 7) + s(hOrderCHIROPTERA, 
##     bs = "re") + s(hOrderCINGULATA, bs = "re") + s(hOrderEULIPOTYPHLA, 
##     bs = "re") + s(hOrderPERAMELEMORPHIA, bs = "re") + s(hOrderPRIMATES, 
##     bs = "re") + s(hOrderRODENTIA, bs = "re") + s(hOrderSCANDENTIA, 
##     bs = "re") + s(LnAreaHost, bs = "cs", k = 7) + s(S20, bs = "cs", 
##     k = 7)
## 
## Parametric coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -0.46816    0.08818  -5.309  1.1e-07 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Approximate significance of smooth terms:
##                             edf Ref.df  Chi.sq  p-value    
## s(hDiseaseZACitesLn)     4.9779      6 923.024  < 2e-16 ***
## s(hMassGramsPVR)         3.5116      6   9.646 0.035625 *  
## s(hOrderCHIROPTERA)      0.9999      1 109.230 5.11e-14 ***
## s(hOrderCINGULATA)       0.7633      1   0.868 0.286385    
## s(hOrderEULIPOTYPHLA)    0.5887      1   1.210 0.150553    
## s(hOrderPERAMELEMORPHIA) 0.7049      1   0.737 0.306647    
## s(hOrderPRIMATES)        0.9998      1  85.119 4.92e-14 ***
## s(hOrderRODENTIA)        0.9766      1 129.283 8.62e-15 ***
## s(hOrderSCANDENTIA)      0.4108      1   0.941 0.130105    
## s(LnAreaHost)            2.6550      6  11.138 0.078928 .  
## s(S20)                   4.6935      6  44.963 0.000481 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## R-sq.(adj) =  0.419   Deviance explained = 35.8%
## UBRE =   0.38  Scale est. = 1         n = 575
```

Relative fraction of deviance explained by each variable in the top model:


Term                     Relative Deviance Explained
----------------------  ----------------------------
hDiseaseZACitesLn                              53.6%
hMassGramsPVR                                  2.76%
hOrderCHIROPTERA                               12.2%
hOrderCINGULATA                               0.563%
hOrderEULIPOTYPHLA                             0.37%
hOrderPERAMELEMORPHIA                         0.362%
hOrderPRIMATES                                 11.8%
hOrderRODENTIA                                 12.6%
hOrderSCANDENTIA                              0.286%
LnAreaHost                                     1.53%
S20                                             3.9%

10-fold cross-validation.  Good fit indicated by *non*-significant p-values:


Fold    Observations Fit   Observations Held Out   P-value   Mean Error
-----  -----------------  ----------------------  --------  -----------
1                    517                      58     0.986   -0.0030748
2                    517                      58     0.602   -0.0857512
3                    517                      58     0.308    0.2679808
4                    517                      58     0.091   -0.3216970
5                    517                      58     0.666   -0.0903830
6                    518                      57     0.643    0.1230466
7                    518                      57     0.663    0.1210772
8                    518                      57     0.370    0.2459483
9                    518                      57     0.735   -0.0596712
10                   518                      57     0.114   -0.4076403

# Viral Traits GAM - All Associations



Terms in models with ΔAIC < 2.  All continuous terms effects are represented
as splines, all discrete terms as random effects:


 ΔAIC  Terms in Model                                                                              
-----  --------------------------------------------------------------------------------------------
    0  cb_dist_noHoSa_maxLn + Envelope + vCytoReplicTF + Vector + vGenomeAveLengthLn + vWOKcitesLn 

Partial effect plots of all terms in top model:

![](gam_supp_info_files/figure-html/vtraits-plot-1.png)<!-- -->

Summary of top model:


```
## 
## Family: binomial 
## Link function: logit 
## 
## Formula:
## IsZoonotic ~ s(cb_dist_noHoSa_maxLn, bs = "tp", k = 7) + s(Envelope, 
##     bs = "re") + s(vCytoReplicTF, bs = "re") + s(Vector, bs = "re") + 
##     s(vGenomeAveLengthLn, bs = "tp", k = 7) + s(vWOKcitesLn, 
##     bs = "tp", k = 7)
## 
## Parametric coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  -1.5864     0.2786  -5.693 1.24e-08 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Approximate significance of smooth terms:
##                             edf Ref.df Chi.sq  p-value    
## s(cb_dist_noHoSa_maxLn) 2.94210      6 44.910 7.48e-10 ***
## s(Envelope)             0.45964      1  0.884 0.166460    
## s(vCytoReplicTF)        0.85868      1 10.956 0.000854 ***
## s(Vector)               0.75131      1  4.901 0.014258 *  
## s(vGenomeAveLengthLn)   0.09239      6  0.117 0.265718    
## s(vWOKcitesLn)          3.28464      6 35.828 3.98e-07 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## R-sq.(adj) =  0.313   Deviance explained = 27.2%
## UBRE = 0.002481  Scale est. = 1         n = 464
```

Relative fraction of deviance explained by each variable in the top model:


Term                    Relative Deviance Explained
---------------------  ----------------------------
cb_dist_noHoSa_maxLn                          45.6%
Envelope                                      2.32%
vCytoReplicTF                                 9.15%
Vector                                        4.61%
vGenomeAveLengthLn                           0.946%
vWOKcitesLn                                   37.4%

10-fold cross-validation.  Good fit indicated by *non*-significant p-values:


Fold    Observations Fit   Observations Held Out   P-value   Mean Error
-----  -----------------  ----------------------  --------  -----------
1                    417                      47     0.628    0.0284356
2                    417                      47     0.432   -0.0415209
3                    417                      47     0.894   -0.0087683
4                    417                      47     0.991    0.0007085
5                    418                      46     0.039    0.1382797
6                    418                      46     0.985    0.0012093
7                    418                      46     0.578    0.0327128
8                    418                      46     0.702   -0.0232710
9                    418                      46     0.175   -0.0936072
10                   418                      46     0.482   -0.0374536


# Viral Traits GAM - Strict Associations




Terms in models with ΔAIC < 2.  All continuous terms effects are represented
as splines, all discrete terms as random effects:


     ΔAIC  Terms in Model                                                           
---------  -------------------------------------------------------------------------
 0.000000  cb_dist_noHoSa_max.stringentLn + vCytoReplicTF + Vector + vWOKcitesLn    
 1.715608  cb_dist_noHoSa_mean.stringentLn + vCytoReplicTF + Vector + vWOKcitesLn   
 1.742713  cb_dist_noHoSa_median.stringentLn + vCytoReplicTF + Vector + vWOKcitesLn 

Partial effect plots of all terms in top model:

![](gam_supp_info_files/figure-html/vtraits-strict-plot-1.png)<!-- -->

Summary of top model:


```
## 
## Family: binomial 
## Link function: logit 
## 
## Formula:
## IsZoonotic.stringent ~ s(cb_dist_noHoSa_max.stringentLn, bs = "tp", 
##     k = 7) + s(vCytoReplicTF, bs = "re") + s(Vector, bs = "re") + 
##     s(vWOKcitesLn, bs = "tp", k = 7)
## 
## Parametric coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  -2.2312     0.2969  -7.514 5.72e-14 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Approximate significance of smooth terms:
##                                      edf Ref.df Chi.sq  p-value    
## s(cb_dist_noHoSa_max.stringentLn) 2.5254      6 15.750 0.000556 ***
## s(vCytoReplicTF)                  0.8781      1 10.328 0.001101 ** 
## s(Vector)                         0.6035      1  1.873 0.085405 .  
## s(vWOKcitesLn)                    2.6374      6 29.513  4.3e-07 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## R-sq.(adj) =  0.225   Deviance explained = 21.1%
## UBRE = -0.092089  Scale est. = 1         n = 408
```

Relative fraction of deviance explained by each variable in the top model:


Term                              Relative Deviance Explained
-------------------------------  ----------------------------
cb_dist_noHoSa_max.stringentLn                          25.5%
vCytoReplicTF                                           17.5%
Vector                                                  3.88%
vWOKcitesLn                                             53.1%

10-fold cross-validation.  Good fit indicated by *non*-significant p-values:


Fold    Observations Fit   Observations Held Out   P-value   Mean Error
-----  -----------------  ----------------------  --------  -----------
1                    367                      41     0.530   -0.0392634
2                    367                      41     0.831    0.0140749
3                    367                      41     0.245    0.0730734
4                    367                      41     0.830   -0.0118296
5                    367                      41     0.566    0.0403362
6                    367                      41     0.357   -0.0488821
7                    367                      41     0.322   -0.0667731
8                    367                      41     0.275    0.0664279
9                    368                      40     0.876    0.0092493
10                   368                      40     0.307   -0.0601761

# Zoonoses in Domestic Animals GAM - All Associations



Terms in models with ΔAIC < 2.  All continuous terms effects are represented
as splines, all discrete terms as random effects:


      ΔAIC  Terms in Model                                                                        
----------  --------------------------------------------------------------------------------------
 0.0000000  offset(LnTotNumVirus) + domestic_category2 + hOrderCETARTIODACTYLA                    
 0.0413592  offset(LnTotNumVirus) + domestic_category2 + hOrderCETARTIODACTYLA + hOrderLAGOMORPHA 

Partial effect plots of all terms in top model:

![](gam_supp_info_files/figure-html/dom-plot-1.png)<!-- -->

Summary of top model:


```
## 
## Family: poisson 
## Link function: log 
## 
## Formula:
## NSharedWithHoSa ~ s(domestic_category2, bs = "re") + s(hOrderCETARTIODACTYLA, 
##     bs = "re") + offset(LnTotNumVirus)
## 
## Parametric coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -0.60693    0.09325  -6.509 7.58e-11 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Approximate significance of smooth terms:
##                             edf Ref.df Chi.sq p-value   
## s(domestic_category2)    0.8861      1  68.07 0.00439 **
## s(hOrderCETARTIODACTYLA) 0.9999      1  97.22 0.00205 **
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## R-sq.(adj) =   0.96   Deviance explained =   38%
## UBRE = -0.17089  Scale est. = 1         n = 32
```

Relative fraction of deviance explained by each variable in the top model:


Term                     Relative Deviance Explained
----------------------  ----------------------------
domestic_category2                               43%
hOrderCETARTIODACTYLA                            57%

10-fold cross-validation.  Good fit indicated by *non*-significant p-values:


Fold    Observations Fit   Observations Held Out   P-value   Mean Error
-----  -----------------  ----------------------  --------  -----------
1                     28                       4     0.748    0.3897941
2                     28                       4     0.876    0.0413904
3                     29                       3     0.500   -0.2523949
4                     29                       3     0.250    0.5501736
5                     29                       3     0.000    1.9905346
6                     29                       3     0.749    1.5312558
7                     29                       3     0.249   -1.4689101
8                     29                       3     0.498   -0.8212953
9                     29                       3     0.254   -2.6681889
10                    29                       3     0.000   -0.8835657


# Zoonoses in Domestic Animals GAM - Strict Associations



Terms in models with ΔAIC < 2.  All continuous terms effects are represented
as splines, all discrete terms as random effects:


      ΔAIC  Terms in Model                                                                                                                    
----------  ----------------------------------------------------------------------------------------------------------------------------------
 0.0000000  offset(LnTotNumVirus) + hOrderLAGOMORPHA + hOrderPROBOSCIDEA + hOrderRODENTIA                                                     
 0.0005550  offset(LnTotNumVirus) + hOrderLAGOMORPHA + hOrderPROBOSCIDEA                                                                      
 0.3074961  offset(LnTotNumVirus) + hOrderLAGOMORPHA + hOrderRODENTIA                                                                         
 0.3115803  offset(LnTotNumVirus) + hOrderLAGOMORPHA                                                                                          
 0.6164310  offset(LnTotNumVirus) + hOrderPROBOSCIDEA + hOrderRODENTIA                                                                        
 0.6978756  offset(LnTotNumVirus) + hOrderPROBOSCIDEA                                                                                         
 0.7057037  offset(LnTotNumVirus) + domestic_categoryOther + hOrderPROBOSCIDEA                                                                
 0.7983515  offset(LnTotNumVirus) + domestic_category3 + hOrderLAGOMORPHA + hOrderRODENTIA + LnDOMYearBP                                      
 0.8305375  offset(LnTotNumVirus) + domestic_category3 + hOrderRODENTIA + LnDOMYearBP                                                         
 0.9613857  offset(LnTotNumVirus) + domestic_category3 + hOrderLAGOMORPHA + hOrderRODENTIA + LnDOMYearBP + PdHoSa.cbCst                       
 1.0015364  offset(LnTotNumVirus) + hOrderRODENTIA                                                                                            
 1.0485809  offset(LnTotNumVirus) + domestic_category3 + hOrderRODENTIA + LnDOMYearBP + PdHoSa.cbCst                                          
 1.0494122  offset(LnTotNumVirus) + domestic_category3 + hDiseaseZACitesLn + hOrderRODENTIA + LnDOMYearBP                                     
 1.0649989  offset(LnTotNumVirus) + domestic_category3 + hDiseaseZACitesLn + hMassGramsPVR + hOrderRODENTIA + LnDOMYearBP                     
 1.0738794  +offset(LnTotNumVirus)                                                                                                            
 1.0738794  offset(LnTotNumVirus)                                                                                                             
 1.0741740  offset(LnTotNumVirus) + domestic_categoryOther                                                                                    
 1.0936712  offset(LnTotNumVirus) + domestic_category3 + hDiseaseZACitesLn + hOrderLAGOMORPHA + hOrderRODENTIA + LnDOMYearBP                  
 1.1123648  offset(LnTotNumVirus) + domestic_category2 + domestic_category3 + hOrderRODENTIA + LnDOMYearBP                                    
 1.4523096  offset(LnTotNumVirus) + domestic_category2 + domestic_category3 + hOrderRODENTIA + LnDOMYearBP + PdHoSa.cbCst                     
 1.6298513  offset(LnTotNumVirus) + domestic_category2 + domestic_category3 + hMassGramsPVR + hOrderRODENTIA + LnDOMYearBP + PdHoSa.cbCst     
 1.6412275  offset(LnTotNumVirus) + domestic_category2 + domestic_category3 + hDiseaseZACitesLn + hOrderRODENTIA + LnDOMYearBP + PdHoSa.cbCst 
 1.6436877  offset(LnTotNumVirus) + domestic_category2 + domestic_category3 + hMassGramsPVR + hOrderRODENTIA + LnDOMYearBP                    
 1.7870691  offset(LnTotNumVirus) + domestic_category3 + hDiseaseZACitesLn + hOrderLAGOMORPHA + hOrderRODENTIA + LnDOMYearBP + PdHoSa.cbCst   
 1.7917253  offset(LnTotNumVirus) + domestic_category3 + domestic_categoryOther + hOrderLAGOMORPHA + LnDOMYearBP                              
 1.9147085  offset(LnTotNumVirus) + domestic_category3 + domestic_categoryOther + LnDOMYearBP                                                 

Partial effect plots of all terms in top model:

![](gam_supp_info_files/figure-html/dom-strict-plot-1.png)<!-- -->

Summary of top model:


```
## 
## Family: poisson 
## Link function: log 
## 
## Formula:
## NSharedWithHoSa_strict ~ offset(LnTotNumVirus) + s(hOrderLAGOMORPHA, 
##     bs = "re") + s(hOrderPROBOSCIDEA, bs = "re") + s(hOrderRODENTIA, 
##     bs = "re")
## 
## Parametric coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  -1.8331     0.1126  -16.27   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Approximate significance of smooth terms:
##                         edf Ref.df Chi.sq p-value
## s(hOrderLAGOMORPHA)  0.7495      1  0.766   0.312
## s(hOrderPROBOSCIDEA) 0.3688      1  0.759   0.152
## s(hOrderRODENTIA)    0.2521      1  0.343   0.243
## 
## R-sq.(adj) =  0.907   Deviance explained = 12.6%
## UBRE = 0.065353  Scale est. = 1         n = 32
```

Relative fraction of deviance explained by each variable in the top model:


Term                 Relative Deviance Explained
------------------  ----------------------------
hOrderLAGOMORPHA                           56.8%
hOrderPROBOSCIDEA                          28.8%
hOrderRODENTIA                             14.5%

10-fold cross-validation.  Good fit indicated by *non*-significant p-values:


Fold    Observations Fit   Observations Held Out   P-value   Mean Error
-----  -----------------  ----------------------  --------  -----------
1                     28                       4     0.626    0.2418309
2                     28                       4     0.252    0.5708533
3                     29                       3     0.252   -0.8245980
4                     29                       3     0.750   -0.5787268
5                     29                       3     0.000    1.9934697
6                     29                       3     0.000   -1.0237261
7                     29                       3     0.000   -0.4910065
8                     29                       3     0.499   -0.3241519
9                     29                       3     0.498   -0.6561722
10                    29                       3     0.251    0.8110239

# All Viruses in Domestic Animals GAM - All Associations




Terms in models with ΔAIC < 2.  All continuous terms effects are represented
as splines, all discrete terms as random effects:


      ΔAIC  Terms in Model                                                                                                           
----------  -------------------------------------------------------------------------------------------------------------------------
 0.0000000  domestic_category2 + hDiseaseZACitesLn + hOrderLAGOMORPHA + hOrderPERISSODACTYLA                                         
 0.6207944  domestic_category2 + hDiseaseZACitesLn + hMassGramsPVR + hOrderLAGOMORPHA + hOrderPERISSODACTYLA                         
 1.1453550  domestic_category2 + hDiseaseZACitesLn + hMassGramsPVR + hOrderCETARTIODACTYLA + hOrderLAGOMORPHA + hOrderPERISSODACTYLA 

Partial effect plots of all terms in top model:

![](gam_supp_info_files/figure-html/dom-vir-plot-1.png)<!-- -->

Summary of top model:


```
## 
## Family: poisson 
## Link function: log 
## 
## Formula:
## TotVirusPerHost ~ s(domestic_category2, bs = "re") + s(hDiseaseZACitesLn, 
##     bs = "tp", k = 7) + s(hOrderLAGOMORPHA, bs = "re") + s(hOrderPERISSODACTYLA, 
##     bs = "re")
## 
## Parametric coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  1.95531    0.08373   23.35   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Approximate significance of smooth terms:
##                            edf Ref.df   Chi.sq  p-value    
## s(domestic_category2)   0.9656      1   82.575 2.71e-13 ***
## s(hDiseaseZACitesLn)    2.4410      6 8094.770  < 2e-16 ***
## s(hOrderLAGOMORPHA)     0.8752      1    6.812  0.00636 ** 
## s(hOrderPERISSODACTYLA) 1.0000      1  137.226  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## R-sq.(adj) =  0.953   Deviance explained = 94.2%
## UBRE = 0.47854  Scale est. = 1         n = 32
```

Relative fraction of deviance explained by each variable in the top model:


Term                    Relative Deviance Explained
---------------------  ----------------------------
domestic_category2                            9.98%
hDiseaseZACitesLn                             72.4%
hOrderLAGOMORPHA                              1.61%
hOrderPERISSODACTYLA                            16%

10-fold cross-validation.  Good fit indicated by *non*-significant p-values:


Fold    Observations Fit   Observations Held Out   P-value   Mean Error
-----  -----------------  ----------------------  --------  -----------
1                     28                       4     0.248   -1.3068071
2                     28                       4     0.000    4.0357625
3                     29                       3     0.000   -8.8075012
4                     29                       3     0.499   -3.8318981
5                     29                       3     0.000    9.6955876
6                     29                       3     0.750   -1.1155114
7                     29                       3     0.000   -4.7601992
8                     29                       3     0.498    0.9179496
9                     29                       3     0.501    0.3652101
10                    29                       3     0.748    0.3792041

# All Viruses in Domestic Animals GAM - Stringent Associations




Terms in models with ΔAIC < 2.  All continuous terms effects are represented
as splines, all discrete terms as random effects:


     ΔAIC  Terms in Model                                                                                          
---------  --------------------------------------------------------------------------------------------------------
 0.000000  domestic_category2 + domestic_categoryOther + hDiseaseZACitesLn + hOrderPERISSODACTYLA + hOrderRODENTIA 
 1.374724  domestic_category2 + hDiseaseZACitesLn + hOrderPERISSODACTYLA + hOrderRODENTIA                          

Partial effect plots of all terms in top model:

![](gam_supp_info_files/figure-html/dom-vir-strict-plot-1.png)<!-- -->

Summary of top model:


```
## 
## Family: poisson 
## Link function: log 
## 
## Formula:
## TotVirusPerHost_strict ~ s(domestic_category2, bs = "re") + s(domestic_categoryOther, 
##     bs = "re") + s(hDiseaseZACitesLn, bs = "tp", k = 7) + s(hOrderPERISSODACTYLA, 
##     bs = "re") + s(hOrderRODENTIA, bs = "re")
## 
## Parametric coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept)    1.090      0.141   7.731 1.07e-14 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Approximate significance of smooth terms:
##                              edf Ref.df    Chi.sq  p-value    
## s(domestic_category2)     1.0000      1    110.64 3.81e-09 ***
## s(domestic_categoryOther) 0.9336      1    214.34 0.016014 *  
## s(hDiseaseZACitesLn)      3.5543      6 760224.93 7.98e-07 ***
## s(hOrderPERISSODACTYLA)   0.9789      1     81.35 1.57e-15 ***
## s(hOrderRODENTIA)         1.0000      1    427.47 0.000549 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## R-sq.(adj) =  0.908   Deviance explained = 91.8%
## UBRE = 0.62949  Scale est. = 1         n = 32
```

Relative fraction of deviance explained by each variable in the top model:


Term                      Relative Deviance Explained
-----------------------  ----------------------------
domestic_category2                              11.3%
domestic_categoryOther                          1.85%
hDiseaseZACitesLn                               68.4%
hOrderPERISSODACTYLA                              15%
hOrderRODENTIA                                  3.47%

10-fold cross-validation.  Good fit indicated by *non*-significant p-values:


Fold    Observations Fit   Observations Held Out   P-value   Mean Error
-----  -----------------  ----------------------  --------  -----------
1                     28                       4     0.749   -0.0889347
2                     28                       4     0.876    0.4056110
3                     29                       3     0.251   -6.6005473
4                     29                       3     0.249    1.3773346
5                     29                       3     0.499   -0.8342990
6                     29                       3     0.000    1.1021046
7                     29                       3     0.750    0.9422361
8                     29                       3     0.000   12.5596416
9                     29                       3     0.502    4.1044873
10                    29                       3     0.749   -0.0981216

<!-- # Publication plots -->


