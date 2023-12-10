*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*December 9, 2023
*-----
gl link = "psychodebt"
*New var
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------






****************************************
* Merger les bases
****************************************
********** NEEMSIS-1
use"raw/NEEMSIS1-loans_indiv", clear

* Selection
keep HHID2016 INDID2016 nbindiv_lender_SHG dumindiv_lender_SHG totindiv_lenderamt_SHG

* Creation
gen year=2016

* Merge panel
merge m:m HHID2016 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
tostring INDID2016, replace
merge 1:m HHID_panel INDID2016 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge
order HHID_panel INDID_panel year

save"_temp1", replace


********** NEEMSIS-2
use"raw/NEEMSIS2-loans_indiv", clear

* Selection
keep HHID2020 INDID2020 nbindiv_lender_SHG dumindiv_lender_SHG totindiv_lenderamt_SHG

* Creation
gen year=2020

* Merge panel
merge m:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
tostring INDID2020, replace
merge 1:m HHID_panel INDID2020 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge
drop HHID2020 INDID2020
order HHID_panel INDID_panel year

save"_temp2", replace



********** Append
use"_temp1", clear

append using "_temp2"
reshape wide HHID2016 INDID2016 nbindiv_lender_SHG dumindiv_lender_SHG totindiv_lenderamt_SHG, i(HHID_panel INDID_panel) j(year)

drop HHID20162020 INDID20162020
rename HHID20162016 HHID2016
rename INDID20162016 INDID2016


save"_tempanel", replace
****************************************
* 






****************************************
* Cognition en 2016
****************************************
use"$wave2~_ego.dta", clear

* To keep
keep HHID_panel INDID_panel raven_tt num_tt lit_tt f1_2016 f2_2016 f3_2016 f4_2016 f5_2016
drop f4_2016

* Merge
merge 1:1 HHID_panel INDID_panel using "_tempanel"
drop if _merge==2
drop _merge

* Rename
rename f1_2016 ES2016
rename f2_2016 CO2016
rename f3_2016 OPEX2016
rename f5_2016 AG2016

* Merge sex, age caste
destring INDID2016, replace
merge m:1 HHID2016 INDID2016 using "raw/NEEMSIS1-HH", keepusing(sex age)
drop if _merge==2
drop _merge



save"cognition_shg", replace
****************************************
* END










****************************************
* Stat
****************************************
use"cognition_shg", clear

cls
foreach y in ES2016 CO2016 OPEX2016 AG2016 raven_tt num_tt lit_tt {
foreach x in dumindiv_lender_SHG2016 dumindiv_lender_SHG2020 {
reg `y' `x'
}
}


****************************************
* END




