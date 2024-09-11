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
* NEEMSIS-1 with kindofwork
****************************************
use"NEEMSIS1-occupations", clear

*
keep HHID2016 INDID2016 occupationid occupationname hoursayear kindofwork annualincome

* Merge age and sex
merge m:1 HHID2016 INDID2016 using "NEEMSIS1-HH", keepusing(age sex)
keep if _merge==3
drop _merge

* Merge HHID_panel
merge m:m HHID2016 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

* Merge INDID_panel
tostring INDID2016, replace
merge m:m HHID2016 INDID2016 using "keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Merge caste
gen year=2016
merge m:1 HHID_panel year using "JatisCastePanel"
keep if _merge==3
drop _merge
rename casten caste
rename jatisn jatis

* Save
order HHID_panel INDID_panel HHID2016 INDID2016 year occupationid, first
sort HHID_panel INDID_panel occupationid
save"NEEMSIS11", replace
****************************************
* END










****************************************
* NEEMSIS-1 with occupation
****************************************
use"NEEMSIS1-occupnew", clear

*
keep HHID2016 INDID2016 occupationid occupationname kindofwork annualincome profession sector occupation dummymainoccupation_indiv

* Merge age and sex
merge m:1 HHID2016 INDID2016 using "NEEMSIS1-HH", keepusing(age sex)
keep if _merge==3
drop _merge

* Merge HHID_panel
merge m:m HHID2016 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

* Merge INDID_panel
tostring INDID2016, replace
merge m:m HHID2016 INDID2016 using "keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Merge caste
gen year=2016
merge m:1 HHID_panel year using "JatisCastePanel"
keep if _merge==3
drop _merge
rename casten caste
rename jatisn jatis

* Save
order HHID_panel INDID_panel HHID2016 INDID2016 year occupationid, first
sort HHID_panel INDID_panel occupationid
save"NEEMSIS12", replace
****************************************
* END











****************************************
* NEEMSIS-1 individuals
****************************************
use"NEEMSIS1-HH", clear

* Selection
drop if livinghome==3
drop if livinghome==4

*
keep HHID2016 INDID2016 name age sex villageid_new relationshiptohead ///
dummyworkedpastyear currentlyatschool reasonnotworkpastyear

* Merge HHID_panel
merge m:m HHID2016 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

* Merge INDID_panel
tostring INDID2016, replace
merge m:m HHID2016 INDID2016 using "keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Merge caste
gen year=2016
merge m:1 HHID_panel year using "JatisCastePanel"
keep if _merge==3
drop _merge
rename casten caste
rename jatisn jatis

* Save
order HHID_panel INDID_panel HHID2016 INDID2016 year, first
sort HHID_panel INDID_panel
save"NEEMSIS13", replace
****************************************
* END













****************************************
* NEEMSIS-1 egos
****************************************
use"NEEMSIS1-ego", clear

*
keep HHID2016 INDID2016 egoid ///
workedpastyear everwork workpastsevendays searchjob startbusiness reasondontsearchjob searchjobsince15 businessafter15 reasondontsearchjobsince15 nbermonthsearchjob readystartjob

* Merge HHID_panel
merge m:m HHID2016 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

* Merge INDID_panel
tostring INDID2016, replace
merge m:m HHID2016 INDID2016 using "keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Merge caste
gen year=2016
merge m:1 HHID_panel year using "JatisCastePanel"
keep if _merge==3
drop _merge
rename casten caste
rename jatisn jatis

* Save
order HHID_panel INDID_panel HHID2016 INDID2016 year, first
sort HHID_panel INDID_panel
save"NEEMSIS14", replace
****************************************
* END
