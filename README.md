# HP3 Analysis files

Here is the description from Parviez:

I’ve created a directory on aegypti, /home/hosseini/HP3.PRH/ForGitHubApril2016. In it there are two subdirectories, one “Clean”, one “Run”. 

The Clean directory has all the files I’ve written myself, plus Kevin’s v41 data files and some code, with none of the excess files needed, and hopefully a clear enough logic. The “Run” directory is the same exact files, but I’ve run the “Clean” files. 

Essentially the order operations is, for allGam, allGamStringent, totVir, and totVirStringent: 
1) nice R —vanilla < host.human.share.data.R 
— ) this produces the initial data files 
2) nice R —vanilla < host.human.share.fit.R 
— ) this produces lr.auto files (code, coded by code) and runs it, producing the AIC files 
— ) this takes a couple hours for allGam(Stringent), but only minutes for totVir. 
3) nice R —vanilla < everything.R 
— ) basically figures out what is the best model, what is within 2 AIC, and produces a summary file. 
— ) inside it checkAIC.R produces collates all AIC values into one file/dataframe 
— ) inside it pval.R produces AIC + coefficient estimates matrix for models within 2 AIC of best 

these three steps are more or less documented in the everything.R file. 

4) createFigures.R is the file I used to create figure 6 in the original Nature submission. But it would need to be edited substantially depending on best models. 

totVir and totVirStringent seem fine, but I haven’t had a chance to edit createFigures.R for totVirStringent. It is edited and produces the right figures for totVir (although I didn’t clean up the layout). 

allGam and allGamStringent have an issue however where a large number of the models have NA for an AIC value, but I haven’t figured out why. The model runs are packed in try( … , silent=TRUE) so that things run and then I can debug, but it may take running specific models without the error trapping and meta-coding to figure out what is happening. It might also be worth seeing if it relates to specific variables. 