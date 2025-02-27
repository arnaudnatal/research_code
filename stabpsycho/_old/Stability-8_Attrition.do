*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*December 9, 2023
*-----
gl link = "stabpsycho"
*Attrition des égos
*-----
do "C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------





****************************************
* Raison absence
****************************************
use"panel_stab_v2", clear

***** Selection
keep if year==2016


***** Raison 2020
preserve
use"raw/NEEMSIS2-HH", clear
keep HHID2020 INDID2020 dummylefthousehold reasonlefthome reasonlefthomeother lefthomedurationlessoneyear lefthomedurationmoreoneyear lefthomedestination lefthomereason livinghome lefthomedurationlessoneyear lefthomedurationmoreoneyear lefthomedestination lefthomereason

merge m:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

save"_tempattr", replace
restore

merge 1:1 HHID_panel INDID_panel using "_tempattr", force
drop if _merge==2
drop _merge


* Attrition
keep HHID_panel INDID_panel panel dummylefthousehold reasonlefthome reasonlefthomeother livinghome lefthomereason

foreach x in reasonlefthome lefthomereason {
decode `x', gen(n1)
drop `x'
rename n1 `x'
}

gen reason=""
replace reason=reasonlefthome if reason==""
replace reason=lefthomereason if reason==""
replace reason="" if panel==1
drop reasonlefthome reasonlefthomeother lefthomereason

sort panel
ta reason panel, m col nofreq

save"attrition", replace
****************************************
* END










****************************************
* Stat
****************************************
use"panel_stab_v2", clear

***** Var
keep HHID_panel INDID_panel HHID2016 INDID2016 HHID2020 INDID2020 year egoid name sex age jatiscorr caste edulevel villageid mainocc_occupation_indiv annualincome_indiv annualincome_HH assets_total1000 assets_totalnoland1000 HHsize maritalstatus HHsize typeoffamily ars ars2 ars3 lit_tt raven_tt num_tt cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit panel

***** Selection
keep if year==2016


***** Merge reason
merge 1:1 HHID_panel INDID_panel using "attrition"
keep if _merge==3
drop _merge

***** Clean
replace annualincome_indiv=annualincome_indiv/1000
replace annualincome_HH=annualincome_HH/1000

***** Merge
* Land
merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-HH", keepusing(dummyeverhadland ownland)
keep if _merge==3
drop _merge

* Factors
merge 1:1 HHID_panel INDID_panel using "_temp_2016"
drop _merge



********** Qui sont les attritions ?
preserve
keep if panel==0
ta reason
ta reason sex, row nofreq
restore


********** Comparison
cls
* Quali
foreach x in sex caste edulevel mainocc_occupation_indiv {
dis "`x'"
ta `x' panel, col chi2
}

cls
* Quanti
foreach x in annualincome_indiv annualincome_HH assets_total1000 HHsize lit_tt raven_tt num_tt f1_2016 f2_2016 f3_2016 f4_2016 f5_2016 {
dis "`x'"
qui reg `x' panel
est store reg1
esttab reg1, drop(_cons)
}


***** Robustess
global var i.sex i.caste i.edulevel i.mainocc_occupation_indiv annualincome_indiv f1_2016 f2_2016 f3_2016 f4_2016 f5_2016 assets_total1000
psmatch2 panel $var, n(1)
pstest $var, treated(panel) both graph



***** Base
keep if panel==1
drop panel
ta _support
keep if _support==1

keep HHID_panel INDID_panel
gen keeptotestattrition=1


save"keepattrition", replace
****************************************
* END













****************************************
* Merge
****************************************
use "panel_stab_wide_v5", clear

merge 1:1 HHID_panel INDID_panel using "keepattrition"
keep if _merge==3

save"analysis_attrition", replace
****************************************
* END






