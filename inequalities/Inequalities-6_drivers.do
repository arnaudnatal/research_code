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
* Multi probit M, W, E
****************************************
use"panel_v6", clear

/*
Voir comment gérer les données de panel
Réponse: Wooldridge, comme les autres CRE
*/

/*
global headX ///
head_femaleXage mean_head_femaleXage ///
head_femaleXocc1 mean_head_femaleXocc1 ///
head_femaleXocc2 mean_head_femaleXocc2 ///
head_femaleXocc4 mean_head_femaleXocc4 ///
head_femaleXocc5 mean_head_femaleXocc5 ///
head_femaleXocc6 mean_head_femaleXocc6 ///
head_femaleXocc7 mean_head_femaleXocc7 ///
head_femaleXeduc2 mean_head_femaleXeduc2 ///
head_femaleXeduc3 mean_head_femaleXeduc3 ///
head_femaleXnonmarried mean_head_femaleXnonmarried
*/

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

global shock ///
dummymarriage mean_dummymarriage ///
dummydemonetisation mean_dummydemonetisation ///
lock_2 mean_lock_2 ///
lock_3 mean_lock_3

global invar ///
caste_2 caste_3 ///
village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10

global time ///
year2016 mean_year2016 ///
year2020 mean_year2020 ///
nobs2 nobs3

global marg log_annualincome_HH log_assets_totalnoland remittnet_HH ownland housetitle HHsize HH_count_child sexratio nonworkersratio stem head_female head_age head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage dummydemonetisation lock_2 lock_3 caste_2 caste_3 village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10




*
fre type
mlogit type $livelihood $family $head $shock $invar $time, baselevel baseoutcome(2)
est store mp1


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

global shock ///
dummymarriage mean_dummymarriage ///
dummydemonetisation mean_dummydemonetisation ///
lock_2 mean_lock_2 ///
lock_3 mean_lock_3

global invar ///
caste_2 caste_3 ///
village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10

global time ///
year2016 mean_year2016 ///
year2020 mean_year2020 ///
nobs2 nobs3


********** Econo
glm absdiffshare $livelihood $family $head $shock $invar $time, family(binomial) link(probit) cluster(panelvar)
margins, dydx($livelihood $family $head $shock $invar $time) post
est store mar1

glm absdiffshare $livelihood $family $head $shock $invar $time if type==1, family(binomial) link(probit) cluster(panelvar)
margins, dydx($livelihood $family $head $shock $invar $time) post
est store mar2

glm absdiffshare $livelihood $family $head $shock $invar $time if type==3, family(binomial) link(probit) cluster(panelvar)
margins, dydx($livelihood $family $head $shock $invar $time) post
est store mar3

esttab mar1 mar2 mar3 using "Margins.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(mean_* $time) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star) se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))



/*
Plus le ménage est riche, plus la diffénce de revenu relatif augmente.
La composition du ménage n'a pas d'effet sur le niveau d'inégalité intra ménage (sex ratio, non workers ratio, taille du ménage, nombre d'enfants, type de famille)
Chez les castes élevés, il y a plus d'inégalités de revenu.

Dans les ménages riches ou de castes élevés, les femmes n'ont pas besoin de travailler
Tandis que chez les Dalits, les femmes ont besoin de travailler pour vivre, donc moins d'inégalités au sein du ménage.

Donc forte inégalités intra chez les riches, faibles chez les pauvres.
*/


********** Overfitting
overfit: glm absdiffshare $livelihood $family $head $shock $invar $time, family(binomial) link(probit) cluster(panelvar)

overfit: glm absdiffshare $livelihood $family $head $shock $invar $time if type==1, family(binomial) link(probit) cluster(panelvar)

overfit: glm absdiffshare $livelihood $family $head $shock $invar $time if type==3, family(binomial) link(probit) cluster(panelvar)




****************************************
* END























