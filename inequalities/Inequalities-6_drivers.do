*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 8, 2024
*-----
gl link = "inequalities"
*Drivers
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\inequalities.do"
*-------------------------








****************************************
* Stat desc
****************************************
use"panel_v5", clear

* Selection
fre grpHH2
drop if grpHH2==.



********** Macro
global livelihood log_annualincome_HH log_assets_totalnoland remittnet_HH ownland housetitle 

global family HHsize HH_count_child sexratio nonworkersratio stem

global head head_female head_age head_occ1 head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ1 head_educ2 head_educ3 head_nonmarried 

global invar caste_1 caste_2 caste_3 

tabstat $livelihood $family $head $invar, stat(mean) by(year)


****************************************
* END

















****************************************
* Multi probit M, W, E
****************************************
use"panel_v5", clear

* Selection
fre grpHH2
drop if grpHH2==.
fre grpHH2
recode grpHH2 (1=3) (3=1)


********** Macro
global livelihood ///
log_annualincome_HH mean_log_annualincome_HH ///
log_assets_totalnoland mean_log_assets_totalnoland ///
remittnet_HH mean_remittnet_HH ///
ownland mean_ownland ///
housetitle mean_housetitle

global family ///
HHsize mean_HHsize ///
HH_count_child mean_HH_count_child ///
sexratio mean_sexratio ///
nonworkersratio mean_nonworkersratio ///
stem mean_stem

global head ///
head_female mean_head_female ///
head_age mean_head_age ///
head_occ1 mean_head_occ1 ///
head_occ2 mean_head_occ2 ///
head_occ4 mean_head_occ4 ///
head_occ5 mean_head_occ5 ///
head_occ6 mean_head_occ6 ///
head_occ7 mean_head_occ7 ///
head_educ2 mean_head_educ2 ///
head_educ3 mean_head_educ3 ///
head_nonmarried mean_head_nonmarried

global invar ///
caste_2 caste_3 ///
village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10

global time ///
year2016 mean_year2016 ///
year2020 mean_year2020 ///
nobs2 nobs3

global marg log_annualincome_HH log_assets_totalnoland remittnet_HH ownland housetitle HHsize HH_count_child sexratio nonworkersratio stem head_female head_age head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried caste_2 caste_3




*
fre grpHH2
mlogit grpHH2 $livelihood $family $head $invar $time, baselevel baseoutcome(2)
est store mp1
predict p
sort p


esttab mp1 using "mprobit.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	keep($marg) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star) se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
	
****************************************
* END



















****************************************
* Drivers of intra-
****************************************
use"panel_v5", clear

* Selection
fre grpHH2
drop if grpHH2==.
drop if grpHH2==2
fre grpHH2

* Remettre en share
replace absdiff_mshare=absdiff_mshare/100


********** Macro
global livelihood ///
log_annualincome_HH mean_log_annualincome_HH ///
log_assets_totalnoland mean_log_assets_totalnoland ///
remittnet_HH mean_remittnet_HH ///
ownland mean_ownland ///
housetitle mean_housetitle

global family ///
HHsize mean_HHsize ///
HH_count_child mean_HH_count_child ///
sexratio mean_sexratio ///
nonworkersratio mean_nonworkersratio ///
stem mean_stem

global head ///
head_female mean_head_female ///
head_age mean_head_age ///
head_occ1 mean_head_occ1 ///
head_occ2 mean_head_occ2 ///
head_occ4 mean_head_occ4 ///
head_occ5 mean_head_occ5 ///
head_occ6 mean_head_occ6 ///
head_occ7 mean_head_occ7 ///
head_educ2 mean_head_educ2 ///
head_educ3 mean_head_educ3 ///
head_nonmarried mean_head_nonmarried

global invar ///
caste_2 caste_3 ///
village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10

global time ///
year2016 mean_year2016 ///
year2020 mean_year2020 ///
nobs2 nobs3

ta grpHH2

********** Econo
glm absdiff_mshare $livelihood $family $head $invar $time, family(binomial) link(probit) cluster(panelvar)
margins, dydx($livelihood $family $head $invar $time) post
est store mar1

glm absdiff_mshare $livelihood $family $head $invar $time if grpHH2==3, family(binomial) link(probit) cluster(panelvar)
margins, dydx($livelihood $family $head $invar $time) post
est store mar2

glm absdiff_mshare $livelihood $family $head $invar $time if grpHH2==1, family(binomial) link(probit) cluster(panelvar)
margins, dydx($livelihood $family $head $invar $time) post
est store mar3


esttab mar1 mar2 mar3 using "Margins.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(mean_* village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10 $time) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star) se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

	
****************************************
* END
