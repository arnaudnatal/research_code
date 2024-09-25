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
use"panel_HH_v3", clear

ta dummyloans_HH year, m
keep if dummyloans_HH==1

* 
ta dumHH_given_repa year, col nofreq

tabstat totHH_givenamt_repa if dumHH_given_repa==1, stat(n mean q) by(year)


tabstat tdr if dumHH_given_repa==1, stat(n mean q) by(year)


probit dumHH_given_repa i.year i.caste

reg totHH_givenamt_repa i.year i.caste i.panelvar


****************************************
* END
