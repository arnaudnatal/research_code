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
* Social class
****************************************
use"panel_v3", clear

*** Var to use
/*
- Educ
- MOC
- Income
- Assets
*/

** Categorize assets and income 
/*
by year to take into account the
increasing level of consumption
see ref on conspicuous consumption
*/
tabstat assets_total, stat(q) by(year)
foreach i in 2010 2016 2020 {
xtile assets_`i'=assets_total if year==`i', n(5) 
}
gen assets_cat=.
replace assets_cat=assets_2010 if year==2010
replace assets_cat=assets_2016 if year==2016
replace assets_cat=assets_2020 if year==2020
drop assets_2010 assets_2016 assets_2020
ta assets_cat
label define assets_cat 1"Ass: Poor" 2"Ass: Low mid" 3"Ass: Mid" 4"Ass: Up mid" 5"Ass: Rich"
label values assets_cat assets_cat

tabstat annualincome_HH, stat(q) by(year)
foreach i in 2010 2016 2020 {
xtile income_`i'=annualincome_HH if year==`i', n(5) 
}
gen income_cat=.
replace income_cat=income_2010 if year==2010
replace income_cat=income_2016 if year==2016
replace income_cat=income_2020 if year==2020
drop income_2010 income_2016 income_2020
ta income_cat
label define income_cat 1"Inc: Poor" 2"Inc: Low mid" 3"Inc: Mid" 4"Inc: Up mid" 5"Ass: Rich"
label values income_cat income_cat

*** MCA
fre head_mocc_occupation head_edulevel income_cat assets_cat
mca head_mocc_occupation head_edulevel income_cat assets_cat, method (indicator) normal(princ)





****************************************
* END

