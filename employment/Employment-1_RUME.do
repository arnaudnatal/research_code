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
codebook sex
label define sex 1"- Men" 2"- Women", replace

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
codebook caste
label define caste 1"- Dalits" 2"- Middle" 3"- Upper", replace

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
codebook sex
label define sex 1"- Men" 2"- Women", replace

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
codebook caste
label define caste 1"- Dalits" 2"- Middle" 3"- Upper", replace

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
codebook sex
label define sex 1"- Men" 2"- Women", replace

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
codebook caste
label define caste 1"- Dalits" 2"- Middle" 3"- Upper", replace

* Save
order HHID_panel INDID_panel HHID2010 INDID2010 year, first
sort HHID_panel INDID_panel
save"RUME3", replace
****************************************
* END
















****************************************
* Employment RUME
****************************************
use"RUME1", clear

fre kindofwork
drop if kindofwork==9
*drop if kindofwork==5

*
count if annualincome==0
gen paidemployment=1 if annualincome>0
gen unpaidemployment=1 if annualincome==0
bysort HHID_panel INDID_panel: egen paidemployment_indiv=sum(paidemployment)
bysort HHID_panel INDID_panel: egen unpaidemployment_indiv=sum(unpaidemployment)
bysort HHID_panel INDID_panel: egen income_indiv=sum(annualincome)

* Keep
keep HHID_panel INDID_panel year paidemployment_indiv unpaidemployment_indiv income_indiv
rename paidemployment_indiv paidemployment
rename unpaidemployment_indiv unpaidemployment
rename income_indiv income
replace paidemployment=1 if paidemployment>1
replace unpaidemployment=1 if unpaidemployment>1
replace unpaidemployment=0 if paidemployment==1
duplicates drop
save"_temp1", replace

use"RUME3", clear
merge 1:1 HHID_panel INDID_panel using "_temp1", keepusing(paidemployment unpaidemployment income)
drop _merge
gen dummyworkedpastyear2=0 if income==.
replace dummyworkedpastyear2=1 if income!=.

* Clean
drop villagename relationshiptohead HHID2010 INDID2010
gen student=.
replace student=0 if studentpresent==0
replace student=1 if studentpresent==1
drop studentpresent

*
save"RUME3_v2", replace
****************************************
* RUME








****************************************
* Occupations en ligne pour avoir tout bien complet
****************************************
use"RUME2", clear


keep HHID_panel INDID_panel year occupationid kindofwork occupation occupationname dummymainoccupation_indiv annualincome

gen occupationid2=1 if dummymainoccupation_indiv==1

* Only moc
preserve
keep if occupationid2==1
drop dummymainoccupation_indiv occupationid
save"_tempmoc1", replace
restore

* Other
drop if occupationid2==1
drop dummymainoccupation_indiv occupationid occupationid2
bysort HHID_panel INDID_panel: gen occupationid2=_n+1

* Append
append using "_tempmoc1"
rename occupationid2 occupationid
order HHID_panel INDID_panel year occupationid
sort HHID_panel INDID_panel year occupationid

* Clean
decode kindofwork, gen(kow)
drop kindofwork

* Reshape

reshape wide occupationname annualincome occupation kow, i(HHID_panel INDID_panel year) j(occupationid)

save"RUME2_v2", replace
****************************************
* RUME
