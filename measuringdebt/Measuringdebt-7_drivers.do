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
* Drivers
****************************************
use"panel_v7", clear

xtset panelvar time


********** OLS
reg fvi dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried ownland assets_total_std annualincome_HH shareform dummymarriage dummydemonetisation village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10, base



********** At least, fixed effects model
xtreg fvi dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried ownland assets_total_std annualincome_HH shareform dummymarriage dummydemonetisation village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10, base fe
/*
pvalue higher than .05, we do not reject H0
-> No fixed effect
*/


********** Random effects?
* BP LM test
xtreg fvi dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried ownland assets_total_std annualincome_HH shareform dummymarriage dummydemonetisation village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10, base re
xttest0
/*
pvalue higher than .05, we do not reject H0
-> No RE
*/



********** CRE to take into account time-invariant variables
xthybrid fvi dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried ownland assets_total_std annualincome_HH shareform dummymarriage dummydemonetisation village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10, clusterid(panelvar) cre

xthybrid fvi dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried ownland assets_total_std annualincome_HH shareform dummymarriage dummydemonetisation village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10,  clusterid(panelvar) cre test full


****************************************
* END
