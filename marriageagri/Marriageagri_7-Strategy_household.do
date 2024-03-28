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
* Investment in education
****************************************

********** Stat
cls
use"panel_HH.dta", clear

ta dummymarriage year, col
ta dummymarriage_male year
ta dummymarriage_female year

* Selection
drop if year==2010
recode educexp_male_HH educexp_female_HH (0=.)
replace educexp_male_HH=educexp_male_HH/1000
replace educexp_female_HH=educexp_female_HH/1000


* Share
ta dumeducexp_male_HH year, col nofreq
ta dumeducexp_male_HH year if caste==1, col nofreq
ta dumeducexp_male_HH year if caste==2, col nofreq
ta dumeducexp_male_HH year if caste==3, col nofreq

ta dumeducexp_female_HH year, col nofreq
ta dumeducexp_female_HH year if caste==1, col nofreq
ta dumeducexp_female_HH year if caste==2, col nofreq
ta dumeducexp_female_HH year if caste==3, col nofreq


* Amount
tabstat educexp_male_HH educexp_female_HH, stat(n mean q min max) by(year) long
tabstat educexp_male_HH educexp_female_HH if caste==1, stat(n mean) by(year) long
tabstat educexp_male_HH educexp_female_HH if caste==2, stat(n mean) by(year) long
tabstat educexp_male_HH educexp_female_HH if caste==3, stat(n mean) by(year) long



****************************************
* END










****************************************
* Investment in housing
****************************************
cls
use"panel_HH.dta", clear

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


