*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*May 13, 2021
*-----
gl link = "psychodebt"
*New var
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------







****************************************
* Formation base indiv lag
****************************************
use"$wave2~panel", clear

* Merge with debt in 2020-21
merge 1:1 HHID_panel INDID_panel using "$wave3~debt"
drop _merge

* Keep egos
drop if egoid2020==0
drop if egoid2020==.
drop if egoid==0
drop if egoid==.

* Label
label var indebt_indiv "Indebted in 2016-17"
label var female "Female"
label var dalits "Dalits"

save "base_panel_lag", replace
****************************************
* END





****************************************
* Formation base indiv 2016
****************************************
use"$wave2~panel", clear

* Merge with debt
merge 1:1 HHID_panel INDID_panel using "$wave2~debt"
drop _merge

* Keep egos
drop if egoid==0
drop if egoid==.

* Label
label var indebt_indiv "Indebted in 2016-17"
label var female "Female"
label var dalits "Dalits"

save "base2016.dta", replace
****************************************
* END







****************************************
* Formation base indiv 2020
****************************************
use"$wave3~panel", clear

* Merge with debt
merge 1:1 HHID_panel INDID_panel using "$wave3~debt"
drop _merge

* Keep egos
drop if egoid==0
drop if egoid==.

* Label
label var indebt_indiv "Indebted in 2016-17"
label var female "Female"
label var dalits "Dalits"

save "base2020.dta", replace
****************************************
* END












****************************************
* Formation base panel
****************************************
use"base2016", clear

* Append
append using "base2020"

* Panel
drop panel_indiv
bysort HHID_panel INDID_panel: gen n=_N

* Order
order HHID_panel INDID_panel egoid year n
ta n year

* Cleaning
foreach x in OP CO EX AG ES Grit {
gen `x'=.
}
foreach x in OP CO EX AG ES Grit {
replace `x'=`x'_2016 if year==2016
replace `x'=`x'_2020 if year==2020
}


save"base_panel", replace
****************************************
* END











****************************************
* Formation base lag loan level
****************************************
use"base_loanlevel_2020", clear


*** Merge with 2016-17
merge m:1 HHID_panel INDID_panel using "$wave2~panel"
keep if _merge==3
drop _merge

save"base_loanlevel_lag", replace
****************************************
* END











****************************************
* Formation base loan level 2016
****************************************
use"base_loanlevel_2016", clear

drop INDID2016

*** Merge with 2016-17
merge m:1 HHID_panel INDID_panel using "$wave2~panel"
keep if _merge==3
drop _merge

save"base_loanlevel_2016_comp", replace
****************************************
* END











****************************************
* Formation base loan level 2020
****************************************
use"base_loanlevel_2020", clear

drop INDID2020

*** Merge with 2020-21
merge m:1 HHID_panel INDID_panel using "$wave3~panel"
keep if _merge==3
drop _merge

save"base_loanlevel_2020_comp", replace
****************************************
* END




