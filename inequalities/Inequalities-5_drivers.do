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
* Drivers of inter-
****************************************
use"panel_v5", clear


********** Macro
global livelihood ///
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
dalits ///
village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10

global time ///
year2016 mean_year2016 ///
year2020 mean_year2020 ///
nobs2 nobs3


********** Econo
reg annualincome_HH $livelihood $family $head $shock $invar $time
margins, dydx($livelihood $family $head $shock $invar) post


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
dalits ///
village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10

global time ///
year2016 mean_year2016 ///
year2020 mean_year2020 ///
nobs2 nobs3


********** Econo
glm absdiffshare $livelihood $family $head $shock $invar $time, family(binomial) link(probit) cluster(panelvar)
margins, dydx($livelihood $family $head $shock $invar) post



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




****************************************
* END























