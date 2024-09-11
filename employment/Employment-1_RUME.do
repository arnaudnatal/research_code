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
* RUME with kindofwork
****************************************
use"RUME-occupations", clear

*
keep HHID2010 INDID2010 occupationid occupationname kindofwork annualincome

* Merge age and sex
merge m:1 HHID2010 INDID2010 using "RUME-HH", keepusing(age sex)
keep if _merge==3
drop _merge

* Merge HHID_panel
merge m:m HHID2010 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

* Merge INDID_panel
merge m:m HHID2010 INDID2010 using "keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Merge caste
gen year=2010
merge m:1 HHID_panel year using "JatisCastePanel"
keep if _merge==3
drop _merge
rename casten caste
rename jatisn jatis

* Save
order HHID_panel INDID_panel HHID2010 INDID2010 year occupationid, first
sort HHID_panel INDID_panel occupationid
save"RUME1", replace
****************************************
* END










****************************************
* RUME with occupation
****************************************
use"RUME-occupnew", clear

*
keep HHID2010 INDID2010 occupationid occupationname kindofwork annualincome profession sector occupation dummymainoccupation_indiv

* Merge age and sex
merge m:1 HHID2010 INDID2010 using "RUME-HH", keepusing(age sex)
keep if _merge==3
drop _merge

* Merge HHID_panel
merge m:m HHID2010 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

* Merge INDID_panel
merge m:m HHID2010 INDID2010 using "keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Merge caste
gen year=2010
merge m:1 HHID_panel year using "JatisCastePanel"
keep if _merge==3
drop _merge
rename casten caste
rename jatisn jatis

* Save
order HHID_panel INDID_panel HHID2010 INDID2010 year occupationid, first
sort HHID_panel INDID_panel occupationid
save"RUME2", replace
****************************************
* END











****************************************
* RUME individuals
****************************************
use"RUME-HH", clear

*
keep HHID2010 INDID2010 name age sex villagename relationshiptohead ///
dummyworkedpastyear studentpresent

* Merge HHID_panel
merge m:m HHID2010 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

* Merge INDID_panel
merge m:m HHID2010 INDID2010 using "keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Merge caste
gen year=2010
merge m:1 HHID_panel year using "JatisCastePanel"
keep if _merge==3
drop _merge
rename casten caste
rename jatisn jatis

* Save
order HHID_panel INDID_panel HHID2010 INDID2010 year, first
sort HHID_panel INDID_panel
save"RUME3", replace
****************************************
* END
