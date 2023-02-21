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
cls
ta caste year, col nofreq
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
replace assets_total=assets_total/1000
replace annualincome_HH=annualincome_HH/1000

tabstat HHsize HH_count_child head_age, stat(mean) long by(year)

tabstat assets_total annualincome_HH shareform if year==2010, stat(mean cv p50) long
tabstat assets_total annualincome_HH shareform if year==2016, stat(mean cv p50) long
tabstat assets_total annualincome_HH shareform if year==2020, stat(mean cv p50) long



****************************************
* END












****************************************
* Drivers
****************************************
use"panel_v7", clear

xtset panelvar time


********** Macro
global finance assets_total_std annualincome_HH_std ownland shareform loanamount_HH_std

global family caste_2 caste_3 HHsize HH_count_child stem

global head head_female head_age head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried

global other dummymarriage dummydemonetisation village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10


********** Miss?
mdesc $family
mdesc $finance
mdesc $head
mdesc $other



********** OLS
reg fvi $finance $family $head $other, base
est store ols



********** At least, fixed effects model (Wooldridge, 2010)
xtreg fvi $finance $family $head $other, base fe
est store fe
/*
pvalue higher than .05, we do not reject H0
-> No fixed effect
*/


********** Random effects?
* BP LM test
xtreg fvi $finance $family $head $other, base re
est store re
xttest0
/*
pvalue higher than .05, we do not reject H0
-> No RE
*/



********** CRE to take into account time-invariant variables
xthybrid fvi $finance $family $head $other,  clusterid(panelvar) cre test full
est store cre

/*
preserve
keep HHID_panel panelvar time year fvi $finance $family $head $other
xtset panelvar time
foreach x in ownland dummymarriage HHsize HH_count_child head_age dummydemonetisation shareform stem head_female head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried loanamount_HH_std annualincome_HH_std assets_total_std {
bysort HHID_panel: egen mean_`x'=mean(`x')
}
xtreg fvi $finance $family $head $other mean_ownland mean_dummymarriage mean_HHsize mean_HH_count_child mean_head_age mean_dummydemonetisation mean_shareform mean_stem mean_head_female mean_head_occ1 mean_head_occ2 mean_head_occ4 mean_head_occ5 mean_head_occ6 mean_head_occ7 mean_head_educ2 mean_head_educ3 mean_head_nonmarried mean_loanamount_HH_std mean_annualincome_HH_std mean_assets_total_std, vce(robust) 
restore
*/

********** Table
esttab ols fe re cre


esttab fe re cre using "reg.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N r2 r2_a F p, fmt(0 2 2 2) ///
	labels(`"Observations"' `"\(R^{2}\)"' `"Adjusted \(R^{2}\)"' `"F-stat"' `"p-value"'))


****************************************
* END
