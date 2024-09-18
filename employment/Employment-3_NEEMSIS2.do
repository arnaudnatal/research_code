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
codebook sex
label define sex 1"- Men" 2"- Women", replace

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
codebook caste
label define caste 1"- Dalits" 2"- Middle" 3"- Upper", replace

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
codebook sex
label define sex 1"- Men" 2"- Women", replace

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
codebook caste
label define caste 1"- Dalits" 2"- Middle" 3"- Upper", replace

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
codebook sex
label define sex 1"- Men" 2"- Women", replace

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
codebook caste
label define caste 1"- Dalits" 2"- Middle" 3"- Upper", replace

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
codebook caste
label define caste 1"- Dalits" 2"- Middle" 3"- Upper", replace

* Save
order HHID_panel INDID_panel HHID2020 INDID2020 year, first
sort HHID_panel INDID_panel
save"NEEMSIS24", replace
****************************************
* END
















****************************************
* Employment NEEMSIS-2
****************************************
use"NEEMSIS21", clear

*
count if annualincome==0
gen paidemployment=1 if annualincome>0
gen unpaidemployment=1 if annualincome==0
bysort HHID_panel INDID_panel: egen paidemployment_indiv=sum(paidemployment)
bysort HHID_panel INDID_panel: egen unpaidemployment_indiv=sum(unpaidemployment)
bysort HHID_panel INDID_panel: egen income_indiv=sum(annualincome)

*
fre kindofwork
gen paidemployment2=1 if kindofwork==1
replace paidemployment2=1 if kindofwork==2
replace paidemployment2=1 if kindofwork==3
replace paidemployment2=1 if kindofwork==4
gen unpaidemployment2=1 if kindofwork==5
replace unpaidemployment2=1 if kindofwork==6
replace unpaidemployment2=1 if kindofwork==7
replace unpaidemployment2=1 if kindofwork==8
bysort HHID_panel INDID_panel: egen paidemployment2_indiv=sum(paidemployment2)
bysort HHID_panel INDID_panel: egen unpaidemployment2_indiv=sum(unpaidemployment2)

* Keep
keep HHID_panel INDID_panel year paidemployment_indiv unpaidemployment_indiv paidemployment2_indiv unpaidemployment2_indiv income_indiv
rename paidemployment_indiv paidemployment
rename unpaidemployment_indiv unpaidemployment
rename paidemployment2_indiv paidemployment2
rename unpaidemployment2_indiv unpaidemployment2
rename income_indiv income
replace paidemployment=1 if paidemployment>1
replace unpaidemployment=1 if unpaidemployment>1
replace unpaidemployment=0 if paidemployment==1
replace paidemployment2=1 if paidemployment2>1
replace unpaidemployment2=1 if unpaidemployment2>1
replace unpaidemployment2=0 if paidemployment2==1
duplicates drop

save"_temp3", replace

use"NEEMSIS23", clear
merge 1:1 HHID_panel INDID_panel using "_temp3", keepusing(paidemployment unpaidemployment paidemployment2 unpaidemployment2 income)
drop _merge
gen dummyworkedpastyear2=0 if income==.
replace dummyworkedpastyear2=1 if income!=.

* Clean
drop village_new relationshiptohead HHID2020 INDID2020
gen student=.
replace student=0 if currentlyatschool==0
replace student=1 if currentlyatschool==1
drop currentlyatschool

*
save"NEEMSIS23_v2", replace
****************************************
* END











****************************************
* Characteristics egos
****************************************
use"NEEMSIS24", clear
keep HHID_panel INDID_panel everwork workpastsevendays searchjob startbusiness searchjobsince15 businessafter15 nbermonthsearchjob readystartjob
save "_tempego2", replace

*
use"NEEMSIS23_v2", clear
merge 1:1 HHID_panel INDID_panel using"_tempego2"
drop if _merge==2
drop _merge
save"NEEMSIS23_v3", replace

****************************************
* END












****************************************
* Occupations en ligne pour avoir tout bien complet
****************************************
use"NEEMSIS22", clear


keep HHID_panel INDID_panel year occupationid kindofwork occupation occupationname dummymainoccupation_indiv annualincome

gen occupationid2=1 if dummymainoccupation_indiv==1

* Only moc
preserve
keep if occupationid2==1
drop dummymainoccupation_indiv occupationid
save"_tempmoc3", replace
restore

* Other
drop if occupationid2==1
drop dummymainoccupation_indiv occupationid occupationid2
bysort HHID_panel INDID_panel: gen occupationid2=_n+1

* Append
append using "_tempmoc3"
rename occupationid2 occupationid
order HHID_panel INDID_panel year occupationid
sort HHID_panel INDID_panel year occupationid

* Clean
decode kindofwork, gen(kow)
drop kindofwork

* Reshape

reshape wide occupationname annualincome occupation kow, i(HHID_panel INDID_panel year) j(occupationid)

save"NEEMSIS22_v2", replace
****************************************
* RUME
