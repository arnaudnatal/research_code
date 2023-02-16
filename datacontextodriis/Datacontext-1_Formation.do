*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 1, 2022
*-----
gl link = "datacontextodriis"
*Prepa database
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------









****************************************
* RUME
****************************************
use"$directory\RUME-HH", clear

*** Family
merge m:1 HHID2010 using "RUME-family"
drop _merge

*** Asset
merge m:1 HHID2010 using "RUME-assets"
drop _merge

*** Income HH
merge m:1 HHID2010 using "RUME-occup_HH"
drop _merge

*** Income indiv
merge 1:1 HHID2010 INDID2010 using "RUME-occup_indiv"
drop _merge

*** Edu indiv
merge 1:1 HHID2010 INDID2010 using "RUME-education"
drop _merge

*** Debt
merge m:1 HHID2010 using "RUME-loans_HH"
drop _merge

*** Transferts
merge m:1 HHID2010 using "RUME-transferts_HH"
drop _merge

*** keypanel HH
merge m:m HHID2010 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

*** keypanel indiv
tostring INDID2010, replace
merge 1:m HHID_panel INDID2010 using "keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

*** Save
save"RUME_v0", replace

****************************************
* END







****************************************
* NEEMSIS-1
****************************************
use"$directory\NEEMSIS1-HH", clear

*** Family
merge m:1 HHID2016 using "NEEMSIS1-family"
drop _merge

*** Asset
merge m:1 HHID2016 using "NEEMSIS1-assets"
drop _merge

*** Income HH
merge m:1 HHID2016 using "NEEMSIS1-occup_HH"
drop _merge

*** Income indiv
merge 1:1 HHID2016 INDID2016 using "NEEMSIS1-occup_indiv"
drop _merge

*** Edu indiv
merge 1:1 HHID2016 INDID2016 using "NEEMSIS1-education"
drop _merge

*** Debt
merge m:1 HHID2016 using "NEEMSIS1-loans_HH"
drop _merge

*** Transferts
merge m:1 HHID2016 using "NEEMSIS1-transferts_HH"
drop _merge

*** Village
merge m:1 HHID2016 using "NEEMSIS1-villages"
drop _merge

*** keypanel HH
merge m:m HHID2016 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

*** keypanel indiv
tostring INDID2016, replace
merge 1:m HHID_panel INDID2016 using "keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

*** Save
save"NEEMSIS1_v0", replace

****************************************
* END









****************************************
* NEEMSIS-2
****************************************
use"$directory\NEEMSIS2-HH", clear

*** Family
merge m:1 HHID2020 using "NEEMSIS2-family"
drop _merge

*** Asset
merge m:1 HHID2020 using "NEEMSIS2-assets"
drop _merge

*** Income HH
merge m:1 HHID2020 using "NEEMSIS2-occup_HH"
drop _merge

*** Income indiv
merge 1:1 HHID2020 INDID2020 using "NEEMSIS2-occup_indiv"
drop _merge

*** Edu indiv
merge 1:1 HHID2020 INDID2020 using "NEEMSIS2-education"
drop _merge

*** Debt
merge m:1 HHID2020 using "NEEMSIS2-loans_HH"
drop _merge

*** Transferts
merge m:1 HHID2020 using "NEEMSIS2-transferts_HH"
drop _merge

*** Village
merge m:1 HHID2020 using "NEEMSIS2-villages"
drop _merge

*** keypanel HH
merge m:m HHID2020 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

*** keypanel indiv
tostring INDID2020, replace
merge 1:m HHID_panel INDID2020 using "keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

*** Save
save"NEEMSIS2_v0", replace

****************************************
* END









****************************************
* Panel HH
****************************************

********** RUME
use"$directory\RUME_v0", clear

* Keep
keep HHID_panel village villagearea ///
house housetitle ///
HHsize family typeoffamily nbgeneration waystem dummypolygamous head_sex head_age head_edulevel dependencyratio dummyheadfemale sexratio ///
assets_sizeownland assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland ///
incomeagri_HH incomenonagri_HH annualincome_HH shareincomeagri_HH shareincomenonagri_HH ///
ownland sizeownland ///
loanamount_HH nbloans_HH totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous ///
remittnet_HH nonworkersratio

* Level
gen year=2010
duplicates drop


* Save
order HHID_panel year
sort HHID_panel
save"RUME_v1", replace


********** NEEMSIS-1
use"$directory\NEEMSIS1_v0", clear

* Keep
keep HHID_panel villageid villagearea ///
house housetitle ///
HHsize family typeoffamily nbgeneration waystem dummypolygamous head_sex head_age head_edulevel dependencyratio dummyheadfemale sexratio ///
assets_sizeownland assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland ///
incomeagri_HH incomenonagri_HH annualincome_HH shareincomeagri_HH shareincomenonagri_HH ///
ownland sizeownland ///
loanamount_HH nbloans_HH totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous ///
remittnet_HH nonworkersratio

* Level
gen year=2016
duplicates drop

* Save
order HHID_panel year
sort HHID_panel
save"NEEMSIS1_v1", replace




********** NEEMSIS-2
use"$directory\NEEMSIS2_v0", clear

* Keep
keep HHID_panel villageid villagearea ///
house housetitle ///
HHsize family typeoffamily nbgeneration waystem dummypolygamous head_sex head_age head_edulevel dependencyratio dummyheadfemale sexratio ///
assets_sizeownland assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland ///
incomeagri_HH incomenonagri_HH annualincome_HH shareincomeagri_HH shareincomenonagri_HH ///
ownland sizeownland ///
loanamount_HH nbloans_HH totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous ///
remittnet_HH nonworkersratio

* Level
gen year=2020
duplicates drop

* Destring
destring ownland house housetitle, replace

* Save
order HHID_panel year
sort HHID_panel
save"NEEMSIS2_v1", replace


********** Panel
use"RUME_v1", clear

append using "NEEMSIS1_v1"
append using "NEEMSIS2_v1"

*** Villages

*** Land
recode ownland (.=0)

*** Panel
encode HHID_panel, gen(panelvar)
gen time=.
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time

order HHID_panel panelvar year time

*** Deflate
foreach x in assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total incomeagri_HH incomenonagri_HH annualincome_HH loanamount_HH totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous remittnet_HH assets_totalnoland {
replace `x'=`x'*(100/158) if year==2016
replace `x'=`x'*(100/184) if year==2020
}

*** Tof
gen tof=0
replace tof=1 if typeoffamily=="nuclear"
replace tof=2 if typeoffamily=="stem"
replace tof=3 if typeoffamily=="joint-stem"

label define tof 1"ToF: Nuclear" 2"ToF: Stem" 3"ToF: Joint-stem"
label values tof tof

*** Caste
preserve
use"RUME-caste", clear
keep HHID_panel caste jatiscorr
gen year=2010
append using "NEEMSIS1-caste"
keep HHID_panel year caste jatiscorr
replace year=2016 if year==.
append using "NEEMSIS2-caste"
keep HHID_panel year caste jatiscorr
replace year=2020 if year==.
encode jatiscorr, gen(jatis)
drop jatiscorr
collapse (mean) jatis caste, by(HHID_panel year)
label values jatis jatis
ta caste year
save"castetemp", replace
restore

merge 1:1 HHID_panel year using "castetemp"
drop _merge

label define caste 1"Dalits" 2"Middle" 3"Upper"
label values caste caste

*** Caste2 Caste
gen caste2=caste
recode caste2 (3=2)

label define caste2 1"Dalits" 2"Non-Dalits"
label values caste2 caste2

*** Year
label define year 2010"2010" 2016"2016-17" 2020"2020-21"
label values year year

*
label values jatis jatis

save"panel_v0", replace
****************************************
* END









****************************************
* Panel Indiv
****************************************

********** RUME
use"$directory\RUME_v0", clear

keep HHID_panel INDID_panel sex age name ///
edulevel ///
working_pop ///
mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv

gen year=2010

save "RUME_indiv_v0", replace



********** NEEMSIS1
use"$directory\NEEMSIS1_v0", clear

drop if livinghome==3
drop if livinghome==4

keep HHID_panel INDID_panel sex age name ///
edulevel ///
working_pop ///
mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv

gen year=2016

save "NEEMSIS1_indiv_v0", replace




********** NEEMSIS2
use"$directory\NEEMSIS2_v0", clear

drop if dummylefthousehold==1
drop if livinghome==3
drop if livinghome==4

keep HHID_panel INDID_panel sex age name ///
edulevel ///
working_pop ///
mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv

gen year=2020

save "NEEMSIS2_indiv_v0", replace




********** Panel indiv
use"RUME_indiv_v0", replace

append using "NEEMSIS1_indiv_v0"
append using "NEEMSIS2_indiv_v0"

order HHID_panel INDID_panel year
sort HHID_panel INDID_panel year


*** Deflate
foreach x in mainocc_annualincome_indiv annualincome_indiv {
replace `x'=`x'*(100/158) if year==2016
replace `x'=`x'*(100/184) if year==2020
}

*** Caste
merge m:1 HHID_panel year using "panel_v0", keepusing(caste jatis)
drop _merge

save"panel_indiv_v0", replace
****************************************
* END
