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

* Miss
fre s_indebt
recode s_indebt (.=0)

* Cluster
drop HHID
encode HHID_panel, gen(HHID)

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

* Cluster
drop HHID
encode HHID_panel, gen(HHID)

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

* Cleaning PT
foreach x in OP CO EX AG ES Grit {
gen `x'=.
}
foreach x in OP CO EX AG ES Grit {
replace `x'=`x'_2016 if year==2016
replace `x'=`x'_2020 if year==2020
}

* Cleaning debt measures
foreach x in s_indebt s_borrservices_none s_dummyproblemtorepay {
gen `x'=.
}
foreach x in s_indebt s_borrservices_none s_dummyproblemtorepay {
replace `x'=`x'2016 if year==2016
replace `x'=`x'2020 if year==2020
}


ta s_indebt year, m
ta s_borrservices_none year, m
ta s_dummyproblemtorepay year, m

* Panel var
drop INDID
egen INDID=concat(HHID_panel INDID_panel)
encode INDID, gen(INDID2)
drop INDID
rename INDID2 INDID
ta INDID

save"base_panel", replace



* Gen income and assets chocs
use"base_panel", clear

keep HHID_panel year incomeHH1000 assets1000
rename incomeHH1000 income
rename assets1000 assets
duplicates drop
reshape wide income assets, i(HHID_panel) j(year)

replace assets2016=assets2016*(100/158)
replace assets2020=assets2020*(100/184)
replace income2016=income2016*(100/158)
replace income2020=income2020*(100/184)

foreach x in income assets {
gen dummyshock_`x'=0
}
foreach x in income assets {
replace dummyshock_`x'=1 if `x'2020<`x'2016 & `x'2020!=. & `x'2020!=0 & `x'2016!=. & `x'2016!=0
}

fre dummyshock*

keep HHID_panel dummy*

label define yesno 0"No" 1"Yes"
label values dummyshock_income yesno
label values dummyshock_assets yesno

fre dummyshock*

save"base_shock", replace
****************************************
* END







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

* Merge shock
merge m:1 HHID_panel using "base_shock"
keep if _merge==3
drop _merge

save "base_panel_lag", replace
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

* Merge shock
merge m:1 HHID_panel using "base_shock"
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




