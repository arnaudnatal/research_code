*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*October 07, 2024
*-----
gl link = "debttrap"
*Stat desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------







****************************************
* Stat desc
****************************************
use"panel_indiv_v3", clear

*
ta dummyloans_indiv year, m
ta dummyloans_indiv year, col
keep if dummyloans_indiv==1

* Given
ta dumindiv_given_repa year, col
tabstat totindiv_givenamt_repa if dumindiv_given_repa==1, stat(n mean q) by(year)
tabstat gtdr_indiv if dumindiv_given_repa==1, stat(n mean q) by(year)


* Effective
ta dumindiv_effective_repa year, col
tabstat totindiv_effectiveamt_repa if dumindiv_effective_repa==1, stat(n mean q) by(year)
tabstat etdr_indiv if dumindiv_effective_repa==1, stat(n mean q) by(year)


****************************************
* END








****************************************
* Stat share
****************************************
use"panel_indiv_v3", clear





****************************************
* END






