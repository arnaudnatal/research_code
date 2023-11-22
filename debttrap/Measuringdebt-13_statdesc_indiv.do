*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*November 20, 2023
*-----
gl link = "debttrap"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------









****************************************
* Stat desc
****************************************
use"panel_indiv_v3", clear

ta dummyloans_indiv year, m
keep if dummyloans_indiv==1

* 
ta dumindiv_given_repa year, col nofreq
ta dumindiv_effective_repa year, col nofreq

tabstat totindiv_givenamt_repa if dumindiv_given_repa==1, stat(n mean q) by(year)

tabstat totindiv_effectiveamt_repa if dumindiv_effective_repa==1, stat(n mean q) by(year)

probit dumindiv_given_repa i.year i.caste i.sex i.panelvar



****************************************
* END
