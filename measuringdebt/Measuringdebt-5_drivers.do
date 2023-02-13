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
use"panel_v7", clear

xtset panelvar time

/*
Share of formal
*/


********** RE
* BP LM test
xtreg newindex1 dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_pc dailyincome_pc i.vill, base re
xttest0
/*
pvalue higher than .05, we do not reject H0
-> No random effect
*/



********** FE
xtreg newindex1 dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_pc dailyincome_pc i.vill, base fe
/*
pvalue higher than .05, we do not reject H0
-> No fixed effect
*/


****************************************
* END











****************************************
* FE vs CRE?
****************************************
use"panel_v7", clear



********** CRE to have FE with constant terms as caste
global mean stem_mean HHsize_mean HH_count_child_mean head_female_mean head_age_mean head_occ2_mean head_occ3_mean head_occ4_mean head_occ5_mean head_occ6_mean head_occ7_mean head_educ2_mean head_educ3_mean head_nonmarried_mean dummymarriage_mean dailyincome_pc_mean assets_cat2_mean assets_cat3_mean


/*
The between R2 is "How much of the variance between seperate panel units does my model account for"
The within R2 is "How much of the variance within the panel units does my model account for"
and the R2 overall is a weighted average of these two.
*/


xtreg newindex1 i.caste stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_cat2 assets_cat3 dailyincome_pc i.vill $mean, base re


****************************************
* END
