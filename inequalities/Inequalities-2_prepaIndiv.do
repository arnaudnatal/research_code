*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 8, 2024
*-----
gl link = "inequalities"
*Prepa Indiv
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\inequalities.do"
*-------------------------








****************************************
* 2010
****************************************
use"raw\RUME-HH.dta", clear

* Selection
keep HHID2010 INDID2010 name sex age relationshiptohead religion

* Merge income
merge m:1 HHID2010 using "raw\RUME-occup_HH", keepusing(annualincome_HH)
drop _merge

merge 1:1 HHID2010 INDID2010 using "raw\RUME-occup_indiv"
drop _merge

* Panel
merge m:m HHID2010 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

merge 1:m HHID2010 INDID2010 using"raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge HHID2010 INDID2010

gen year=2010
order HHID_panel INDID_panel year

* Merge inequalities
merge 1:1 HHID_panel INDID_panel year using "ineqindiv", keepusing(shareindiv annualincome_indiv2 dayinc dayinc_usd_ppp poor_indiv sopl_indiv)
keep if _merge==3
drop _merge

save"temp1",replace
****************************************
* END











****************************************
* 2016
****************************************
use"raw\NEEMSIS1-HH.dta", clear

* Selection
ta livinghome egoid
drop if livinghome>=3
keep HHID2016 INDID2016 name sex age relationshiptohead

* Merge income
merge m:1 HHID2016 using "raw\NEEMSIS1-occup_HH", keepusing(annualincome_HH)
drop _merge

merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-occup_indiv", keepusing(working_pop mainocc_occupation_indiv mainocc_annualincome_indiv annualincome_indiv nboccupation_indiv)
keep if _merge==3
drop _merge

* Ego
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-ego", keepusing(everwork workpastsevendays searchjob startbusiness reasondontsearchjob searchjobsince15 businessafter15 reasondontsearchjobsince15 nbermonthsearchjob readystartjob methodfindjob jobpreference moveoutsideforjob moveoutsideforjobreason aspirationminimumwage kindofworkfirstjob unpaidinbusinessfirstjob agestartworking agestartworkingpaidjob methodfindfirstjob monthstofindjob beforemainoccup otherbeforemainoccup mainoccuptype dummypreviouswagejob previousjobcontract reasonstoppedwagejob)
drop _merge

* Panel
merge m:m HHID2016 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2016, replace
merge 1:m HHID2016 INDID2016 using"raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge HHID2016 INDID2016

gen year=2016
order HHID_panel INDID_panel year

* Merge inequalities
merge 1:1 HHID_panel INDID_panel year using "ineqindiv", keepusing(shareindiv annualincome_indiv2 dayinc dayinc_usd_ppp poor_indiv sopl_indiv)
keep if _merge==3
drop _merge

save"temp2",replace
****************************************
* END











****************************************
* 2020
****************************************
use"raw\NEEMSIS2-HH.dta", clear

* Selection
drop if dummylefthousehold==1
drop if livinghome>=3
keep HHID2020 INDID2020 name sex age relationshiptohead

* Merge income
merge m:1 HHID2020 using "raw\NEEMSIS2-occup_HH", keepusing(annualincome_HH)
drop _merge

merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-occup_indiv", keepusing(working_pop mainocc_occupation_indiv mainocc_annualincome_indiv annualincome_indiv nboccupation_indiv)
keep if _merge==3
drop _merge

* Ego
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-ego", keepusing(everwork workpastsevendays searchjob startbusiness reasondontsearchjob searchjobsince15 businessafter15 reasondontsearchjobsince15 nbermonthsearchjob readystartjob methodfindjob jobpreference moveoutsideforjob moveoutsideforjobreason aspirationminimumwage kindofworkfirstjob unpaidinbusinessfirstjob agestartworking agestartworkingpaidjob methodfindfirstjob monthstofindjob beforemainoccup otherbeforemainoccup mainoccuptype dummypreviouswagejob previousjobcontract reasonstoppedwagejob respect workmate useknowledgeatwork satisfyingpurpose schedule takeholiday agreementatwork1 agreementatwork2 agreementatwork3 agreementatwork4 changework happywork satisfactionsalary executionwork1 executionwork2 executionwork3 executionwork4 executionwork5 executionwork6 executionwork7 executionwork8 executionwork9 accidentalinjury losswork lossworknumber mostseriousincident mostseriousinjury seriousinjuryother physicalharm problemwork1 problemwork2 problemwork4 problemwork5 problemwork6 problemwork7 problemwork8 problemwork9 problemwork10 workexposure1 workexposure2 workexposure3 workexposure4 workexposure5 professionalequipment break retirementwork verbalaggression physicalagression sexualharassment sexualaggression discrimination1 discrimination2 discrimination3 discrimination4 discrimination5 discrimination6 discrimination7 discrimination8 discrimination9 resdiscrimination1 resdiscrimination2 resdiscrimination3 resdiscrimination4 resdiscrimination5 rurallocation lackskill)
drop _merge

* Panel
merge m:m HHID2020 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge 1:m HHID2020 INDID2020 using"raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge HHID2020 INDID2020

gen year=2020
order HHID_panel INDID_panel year

* Merge inequalities
merge 1:1 HHID_panel INDID_panel year using "ineqindiv", keepusing(shareindiv annualincome_indiv2 dayinc dayinc_usd_ppp poor_indiv sopl_indiv)
keep if _merge==3
drop _merge

save"temp3",replace
****************************************
* END











****************************************
* Panel
****************************************
use"temp1", clear

append using "temp2"
append using "temp3"

ta year

* Dummy panel
bysort HHID_panel INDID_panel: gen n=_N
recode n (1=0) (2=0) (3=1)
rename n dummypanel
ta dummypanel
order HHID_panel INDID_panel year dummypanel
sort HHID_panel INDID_panel year


save"panelindiv_v0", replace
****************************************
* END




