*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*May 13, 2021
*-----
gl link = "psychodebt"
*Individuals in panel
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------







****************************************
* Panel
****************************************

********** 2020-21
use"raw\\$wave3", clear
gen year2020=2020
rename egoid egoid2020
keep HHID2020 INDID2020 egoid2020 year2020
merge m:m HHID2020 using "raw\keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw\keypanel-Indiv_wide", keepusing(INDID_panel)
destring INDID2020, replace
keep if _merge==3
drop _merge
order HHID2020 INDID2020 HHID_panel INDID_panel
save"$wave3~_temp", replace


********** 2016-17
use"raw\\$wave2", clear
gen year2016=2016
rename egoid egoid2016
keep HHID2016 INDID2016 egoid2016 year2016
merge m:m HHID2016 using "raw\keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
tostring INDID2016, replace
merge m:m HHID_panel INDID2016 using "raw\keypanel-Indiv_wide", keepusing(INDID_panel)
destring INDID2016, replace
keep if _merge==3
drop _merge
order HHID2016 INDID2016 HHID_panel INDID_panel
save"$wave2~_temp", replace



********** Merge
use"$wave3~_temp", clear

merge 1:1 HHID_panel INDID_panel using "$wave2~_temp"

gen panel_indiv=0
replace panel_indiv=1 if _merge==3
drop _merge

save"panel_indiv", replace

****************************************
* END
