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
codebook sex
label define sex 1"- Men" 2"- Women", replace

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
codebook caste
label define caste 1"- Dalits" 2"- Middle" 3"- Upper", replace

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
codebook sex
label define sex 1"- Men" 2"- Women", replace

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
codebook caste
label define caste 1"- Dalits" 2"- Middle" 3"- Upper", replace

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
codebook sex
label define sex 1"- Men" 2"- Women", replace

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
codebook caste
label define caste 1"- Dalits" 2"- Middle" 3"- Upper", replace

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
codebook caste
label define caste 1"- Dalits" 2"- Middle" 3"- Upper", replace

* Save
order HHID_panel INDID_panel HHID2016 INDID2016 year, first
sort HHID_panel INDID_panel
save"NEEMSIS14", replace
****************************************
* END



















****************************************
* Employment NEEMSIS-1
****************************************
use"NEEMSIS11", clear

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
save"_temp2", replace

use"NEEMSIS13", clear
merge 1:1 HHID_panel INDID_panel using "_temp2", keepusing(paidemployment unpaidemployment paidemployment2 unpaidemployment2 income)
drop _merge
gen dummyworkedpastyear2=0 if income==.
replace dummyworkedpastyear2=1 if income!=.

* Clean
drop villageid_new relationshiptohead HHID2016 INDID2016
gen student=.
replace student=0 if currentlyatschool==0
replace student=1 if currentlyatschool==1
drop currentlyatschool

*
save"NEEMSIS13_v2", replace
****************************************
* RUME













****************************************
* Characteristics egos
****************************************
use"NEEMSIS14", clear
keep HHID_panel INDID_panel everwork workpastsevendays searchjob startbusiness searchjobsince15 businessafter15 nbermonthsearchjob readystartjob
save "_tempego1", replace

*
use"NEEMSIS13_v2", clear
merge 1:1 HHID_panel INDID_panel using"_tempego1"
drop _merge
save"NEEMSIS13_v3", replace
****************************************
* END












****************************************
* Occupations en ligne pour avoir tout bien complet
****************************************
use"NEEMSIS12", clear


keep HHID_panel INDID_panel year occupationid kindofwork occupation occupationname dummymainoccupation_indiv annualincome

gen occupationid2=1 if dummymainoccupation_indiv==1

* Only moc
preserve
keep if occupationid2==1
drop dummymainoccupation_indiv occupationid
save"_tempmoc2", replace
restore

* Other
drop if occupationid2==1
drop dummymainoccupation_indiv occupationid occupationid2
bysort HHID_panel INDID_panel: gen occupationid2=_n+1

* Append
append using "_tempmoc2"
rename occupationid2 occupationid
order HHID_panel INDID_panel year occupationid
sort HHID_panel INDID_panel year occupationid

* Clean
decode kindofwork, gen(kow)
drop kindofwork

* Reshape

reshape wide occupationname annualincome occupation kow, i(HHID_panel INDID_panel year) j(occupationid)

save"NEEMSIS12_v2", replace
****************************************
* RUME