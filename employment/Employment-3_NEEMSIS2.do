*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*September 11, 2024
*-----
gl link = "employment"
*Prepa database
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------








****************************************
* NEEMSIS-2 with kindofwork
****************************************
use"NEEMSIS2-occupations", clear

*
keep HHID2020 INDID2020 occupationid occupationname hoursayear kindofwork annualincome

* Merge age and sex
merge m:1 HHID2020 INDID2020 using "NEEMSIS2-HH", keepusing(age sex)
keep if _merge==3
drop _merge

* Merge HHID_panel
merge m:m HHID2020 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

* Merge INDID_panel
tostring INDID2020, replace
merge m:m HHID2020 INDID2020 using "keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Merge caste
gen year=2020
merge m:1 HHID_panel year using "JatisCastePanel"
keep if _merge==3
drop _merge
rename casten caste
rename jatisn jatis

* Save
order HHID_panel INDID_panel HHID2020 INDID2020 year occupationid, first
sort HHID_panel INDID_panel occupationid
save"NEEMSIS21", replace
****************************************
* END










****************************************
* NEEMSIS-2 with occupation
****************************************
use"NEEMSIS2-occupnew", clear

keep HHID2020 INDID2020 occupationid occupationname kindofwork annualincome profession sector occupation dummymainoccupation_indiv

* Merge age and sex
merge m:1 HHID2020 INDID2020 using "NEEMSIS2-HH", keepusing(age sex)
keep if _merge==3
drop _merge

* Merge HHID_panel
merge m:m HHID2020 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

* Merge INDID_panel
tostring INDID2020, replace
merge m:m HHID2020 INDID2020 using "keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Merge caste
gen year=2020
merge m:1 HHID_panel year using "JatisCastePanel"
keep if _merge==3
drop _merge
rename casten caste
rename jatisn jatis

* Save
order HHID_panel INDID_panel HHID2020 INDID2020 year occupationid, first
sort HHID_panel INDID_panel occupationid
save"NEEMSIS22", replace
****************************************
* END











****************************************
* NEEMSIS-2 individuals
****************************************
use"NEEMSIS2-HH", clear

* Selection
drop if livinghome==3
drop if livinghome==4
drop if dummylefthousehold==1

*
keep HHID2020 INDID2020 name age sex village_new relationshiptohead ///
dummyworkedpastyear currentlyatschool reasonnotworkpastyear workpastsixmonth 

* Merge HHID_panel
merge m:m HHID2020 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

* Merge INDID_panel
tostring INDID2020, replace
merge m:m HHID2020 INDID2020 using "keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Merge caste
gen year=2020
merge m:1 HHID_panel year using "JatisCastePanel"
keep if _merge==3
drop _merge
rename casten caste
rename jatisn jatis

* Save
order HHID_panel INDID_panel HHID2020 INDID2020 year, first
sort HHID_panel INDID_panel
save"NEEMSIS23", replace
****************************************
* END










****************************************
* NEEMSIS-2 egos
****************************************
use"NEEMSIS2-ego", clear

*
keep HHID2020 INDID2020 egoid ///
everwork workpastsevendays searchjob startbusiness reasondontsearchjob startbusiness searchjobsince15 businessafter15 reasondontsearchjobsince15 nbermonthsearchjob readystartjob

* Merge HHID_panel
merge m:m HHID2020 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

* Merge INDID_panel
tostring INDID2020, replace
merge m:m HHID2020 INDID2020 using "keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Merge caste
gen year=2020
merge m:1 HHID_panel year using "JatisCastePanel"
keep if _merge==3
drop _merge
rename casten caste
rename jatisn jatis

* Save
order HHID_panel INDID_panel HHID2020 INDID2020 year, first
sort HHID_panel INDID_panel
save"NEEMSIS24", replace
****************************************
* END
