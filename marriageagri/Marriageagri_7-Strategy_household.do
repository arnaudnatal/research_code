*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*February 22, 2023
*-----
gl link = "marriageagri"
*Analysis NEEMSIS-2 marriage
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\marriageagri.do"
*-------------------------








****************************************
* Contextual elements
****************************************
/*
- What is the evolution over time of agriculture?
- What about the volatility of non-agricultural income?
- What about the investment in education?
- What about the investment in the house?
*/

cls
use"panel_HH.dta", clear


********** Declining share of agriculture
* Share
ta caste year
ta ownland year, col nofreq

* Amount
tabstat shareincomeagri_HH, stat(n mean p50) by(year)




********** Volatility of non-agricultural income
preserve
replace incomenonagri_HH=incomenonagri_HH/1000
replace incomeagri_HH=incomeagri_HH/1000
tabstat incomenonagri_HH incomeagri_HH, stat(n mean cv) by(year) long
restore




********** Investment in education
* Share
ta dumeducexp_male_HH year, col nofreq

ta dumeducexp_female_HH year, col nofreq

* Amount
preserve
replace educexp_male_HH=educexp_male_HH/1000
tabstat educexp_male_HH if dumeducexp_male_HH==1, stat(n mean p50) by(year) long
restore

preserve
replace educexp_female_HH=educexp_female_HH/1000
tabstat educexp_female_HH if dumeducexp_female_HH==1, stat(n mean p50) by(year) long
restore

* Tests
ttest educexp_male_HH==educexp_female_HH
ttest educexp_male_HH==educexp_female_HH, unpaired
ttest educexp_male_HH==educexp_female_HH, unpaired unequal



********** Dépenses d'habitation
* Share
ta dumHH_given_hous year, col nofreq

ta dumHH_effective_hous year, col nofreq


* Absolut
preserve
replace totHH_givenamt_hous=totHH_givenamt_hous/1000
tabstat totHH_givenamt_hous if totHH_givenamt_hous!=0, stat(n mean p50) by(year) long
restore

preserve
replace totHH_effectiveamt_hous=totHH_effectiveamt_hous/1000
tabstat totHH_effectiveamt_hous if totHH_effectiveamt_hous!=0, stat(n mean p50) by(year) long
restore


* Relative
preserve
replace totHH_givenamt_hous=(totHH_givenamt_hous/annualincome_HH)*100
tabstat totHH_givenamt_hous if totHH_givenamt_hous!=0, stat(n mean p50) by(year) long
restore

preserve
replace totHH_effectiveamt_hous=(totHH_effectiveamt_hous/annualincome_HH)*100
tabstat totHH_effectiveamt_hous if totHH_effectiveamt_hous!=0, stat(n mean p50) by(year) long
restore


****************************************
* END




