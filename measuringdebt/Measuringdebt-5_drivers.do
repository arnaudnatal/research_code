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
* FE vs RE?
****************************************
use"panel_v5", clear

xtset panelvar time

*Land owner

********** FE
xtreg fvi dalits stem shareform HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_total_std annualincome_HH i.vill, base fe
/*
pvalue higher than .05, we do not reject H0
-> No fixed effect
*/


********** RE
* BP LM test
xtreg fvi dalits stem shareform HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_total_std annualincome_HH i.vill, base re
xttest0
/*
pvalue higher than .05, we do not reject H0
-> No random effect
*/


****************************************
* END
