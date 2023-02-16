*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*November 19, 2022
*-----
gl link = "measuringdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\measuringdebt.do"
*-------------------------











****************************************
* Stat desc
****************************************
use"panel_v7", clear

xtset panelvar time

*** Verif dummies
ta head_mocc_occupation
sum head_occ1 head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7

ta head_edulevel
sum head_educ1 head_educ2 head_educ3


*** Stat quali
ta dalits year, col nofreq
ta stem year, col nofreq
ta head_female year, col nofreq
ta head_mocc_occupation year, col nofreq
ta head_edulevel year, col nofreq
ta head_nonmarried year, col nofreq
ta ownland year, col nofreq
ta dummymarriage year, col nofreq
ta dummydemonetisation year, col nofreq
ta vill year, col nofreq


*** Stat quanti
tabstat HHsize HH_count_child head_age assets_total_std annualincome_HH shareform, stat(n mean cv p50) by(year)


****************************************
* END












****************************************
* Drivers
****************************************
use"panel_v7", clear

xtset panelvar time



********** OLS
reg fvi dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried ownland assets_total_std annualincome_HH_std shareform dummymarriage dummydemonetisation village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10, base



********** At least, fixed effects model (Wooldridge, 2010)
xtreg fvi dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried ownland assets_total_std annualincome_HH_std shareform dummymarriage dummydemonetisation village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10, base fe
/*
pvalue higher than .05, we do not reject H0
-> No fixed effect
*/


********** Random effects?
* BP LM test
xtreg fvi dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried ownland assets_total_std annualincome_HH_std shareform dummymarriage dummydemonetisation village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10, base re
xttest0
/*
pvalue higher than .05, we do not reject H0
-> No RE
*/



********** CRE to take into account time-invariant variables
xthybrid fvi dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried ownland assets_total_std annualincome_HH_std shareform dummymarriage dummydemonetisation village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10, clusterid(panelvar) cre

xthybrid fvi dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried ownland assets_total_std annualincome_HH_std shareform dummymarriage dummydemonetisation village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10,  clusterid(panelvar) cre test full


****************************************
* END
