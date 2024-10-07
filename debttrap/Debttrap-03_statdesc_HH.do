*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*October 7, 2024
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
use"panel_HH_v3", clear

*
ta dummyloans_HH year, m
ta dummyloans_HH year, col
keep if dummyloans_HH==1

* Given
ta dumHH_given_repa year, col
tabstat totHH_givenamt_repa if dumHH_given_repa==1, stat(n mean q) by(year)
tabstat gtdr if dumHH_given_repa==1, stat(n mean q) by(year)




* Effective
ta dumHH_effective_repa year, col
tabstat totHH_effectiveamt_repa if dumHH_effective_repa==1, stat(n mean q) by(year)
tabstat etdr if dumHH_effective_repa==1, stat(n mean q) by(year)


****************************************
* END
