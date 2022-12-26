*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*May 13, 2021
*-----
gl link = "psychodebt"
*EFA + panel 2016
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
merge m:m HHID2020 using "raw\ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw\ODRIIS-Indiv_wide", keepusing(INDID_panel)
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
merge m:m HHID2016 using "raw\ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
tostring INDID2016, replace
merge m:m HHID_panel INDID2016 using "raw\ODRIIS-Indiv_wide", keepusing(INDID_panel)
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











****************************************
* EFA 2016
**************************************** 
use"raw\\$wave2", clear

* Indiv
tostring INDID2016, replace
merge m:m HHID2016 INDID2016 using "panel_indiv"
keep if _merge==3
drop _merge
destring INDID2016, replace

keep if panel_indiv==1
keep if egoid>0
keep if egoid2020>0

*keep if egoid!=0 & egoid!=.


********** Imputation for non corrected one
global big5cr cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking

foreach x in $big5cr{
gen im`x'=`x'
}


forvalues j=1(1)3{
forvalues i=1(1)2{
foreach x in $big5cr{
qui sum im`x' if sex==`i' & caste==`j' & egoid!=0 & egoid!=.
replace im`x'=r(mean) if im`x'==. & sex==`i' & caste==`j' & egoid!=0 & egoid!=.
}
}
}


global imcor imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm 


/*
********** Without grit
minap $imcor
factor $imcor, pcf fa(5) 
rotate, oblimin
putexcel set "EFA_2016.xlsx", modify sheet(imcor)
putexcel (E2)=matrix(e(r_L))
*/

********** Omega with Laajaj approach for factor analysis and Cobb Clark
** F1
global f1 imcr_easilyupset imcr_nervous imcr_worryalot imcr_feeldepressed imcr_changemood imcr_easilydistracted imcr_shywithpeople imcr_putoffduties imcr_rudetoother imcr_repetitivetasks
** F2
global f2 imcr_makeplans imcr_appointmentontime imcr_completeduties imcr_enthusiastic imcr_organized imcr_workhard imcr_workwithother
** F3
global f3 imcr_liketothink imcr_activeimagination imcr_expressingthoughts imcr_sharefeelings imcr_newideas imcr_inventive imcr_curious imcr_talktomanypeople imcr_talkative imcr_interestedbyart imcr_understandotherfeeling
** F4
global f4 imcr_staycalm imcr_managestress
** F5
global f5 imcr_forgiveother imcr_toleratefaults imcr_trustingofother imcr_enjoypeople imcr_helpfulwithothers

/*
*** Omega
omega $f1
omega $f2
omega $f3
alpha $f4
omega $f5
*/

*** Score
egen f1_2016=rowmean($f1)
egen f2_2016=rowmean($f2)
egen f3_2016=rowmean($f3)
egen f4_2016=rowmean($f4)
egen f5_2016=rowmean($f5)


keep $imcorwith HHID_panel INDID_panel f1_2016 f2_2016 f3_2016 f4_2016 f5_2016

save"$wave2~_ego.dta", replace
****************************************
* END













****************************************
* Prepa 2016
****************************************
use"raw\\$wave2", clear

* Indiv
tostring INDID2016, replace
merge m:m HHID2016 INDID2016 using "panel_indiv"
keep if _merge==3
drop _merge
destring INDID2016, replace

* Caste / jatis
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-caste"
drop _merge

* Education
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-education"
drop _merge

* Occupation
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-occup_indiv", keepusing(mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv nboccupation_indiv)
drop _merge

* Assets
merge m:1 HHID2016 using "raw\NEEMSIS1-assets", keepusing(assets_sizeownland assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland assets_totalnoprop)
drop _merge

* Income
merge m:1 HHID2016 using "raw\NEEMSIS1-occup_HH", keepusing(incomeagri_HH incomenonagri_HH annualincome_HH shareincomeagri_HH shareincomenonagri_HH nbworker_HH nbnonworker_HH)
drop _merge

* Family
merge m:1 HHID2016 using "raw\NEEMSIS1-family", keepusing(nbmale nbfemale age_group HHsize typeoffamily waystem dummypolygamous)
drop _merge

* Villages
merge m:1 HHID2016 using "raw\NEEMSIS1-villages", keepusing(livingarea villagename2016_club)
drop _merge
rename villagename2016_club villageid2016

* Indiv debt
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-loans_indiv", keepusing(nbloans_indiv loanamount_indiv)
drop _merge

* Only ego
fre egoid
drop if egoid==0
keep if panel_indiv==1


* Macro for rename
global charactindiv maritalstatus edulevel relationshiptohead sex age name mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv nboccupation_indiv nbloans_indiv loanamount_indiv

global wealth assets_sizeownland assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland assets_totalnoprop incomeagri_HH incomenonagri_HH annualincome_HH shareincomeagri_HH shareincomenonagri_HH nbworker_HH nbnonworker_HH
 
global characthh villageid jatis caste dummymarriage dummydemonetisation nbmale nbfemale age_group HHsize typeoffamily waystem dummypolygamous villageid2016 livingarea

keep HHID_panel INDID_panel egoid $charactindiv $characthh $wealth 

* Rename
foreach x in $all {
rename `x' `x'_1
}

order HHID_panel INDID_panel

preserve
duplicates drop HHID_panel, force
tab caste_1
*Tous les HH ont un égo donc je suis censé en avoir plus car 485 HH en panel avec un peu de chance, 483 sinon minimum !
restore



* Merge factor
merge 1:1 HHID_panel INDID_panel using "$wave2~_ego.dta"
keep if _merge==3
drop _merge

foreach x in f1 f2 f3 f4 f5 {
rename `x'_2016 `x'_1
}

gen indebt_indiv_1=0
replace indebt_indiv_1=1 if loanamount_indiv_1>0 & loanamount_indiv_1!=.

save"$wave2~panel", replace
****************************************
* END
