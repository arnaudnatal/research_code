*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*April 29, 2026
*-----
gl link = "debttrap"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------









****************************************
* 2016-17
****************************************
use"raw/NEEMSIS1-HH", clear

* To keep
keep HHID2016 INDID2016 name sex age relationshiptohead maritalstatus livinghome

* Education
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-education", keepusing(edulevel)
drop _merge

* Occupation
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-occup_indiv", keepusing(dummyworkedpastyear working_pop mainocc_occupation_indiv annualincome_indiv nboccupation_indiv hoursayear_indiv)
drop _merge

* Debt
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-loans_indiv", keepusing(nbloans_indiv loanamount_indiv imp1_ds_tot_indiv imp1_is_tot_indiv)
drop _merge

* Add loanbalance
preserve
use"raw/NEEMSIS1-loans_mainloans_new", clear
keep HHID2016 INDID2016 loanbalance2
rename loanbalance2 loanbalance
bys HHID2016 INDID2016: egen loanbalance_indiv=sum(loanbalance)
keep HHID2016 INDID2016 loanbalance_indiv
duplicates drop
save"_temp", replace
restore
merge 1:1 HHID2016 INDID2016 using "_temp"
drop _merge

* Transferts
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-transferts_indiv", keepusing(remreceived_indiv remsent_indiv remittnet_indiv)
drop _merge

* Panel HH
merge m:m HHID2016 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

* Panel indiv
tostring INDID2016, replace
merge 1:m HHID2016 INDID2016 using"raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Rename
rename HHID2016 HHID
rename INDID2016 INDID
order HHID_panel INDID_panel

*Year
gen year=2016

* Selection
drop if livinghome==3
drop if livinghome==4
drop livinghome

save"_temp_NEEMSIS1indiv", replace
****************************************
* END











****************************************
* 2020-21
****************************************
use"raw/NEEMSIS2-HH", clear

* To keep
keep HHID2020 INDID2020 name sex age relationshiptohead maritalstatus livinghome dummylefthousehold
duplicates drop

* Education
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-education", keepusing(edulevel)
drop _merge

* Occupation
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-occup_indiv", keepusing(dummyworkedpastyear working_pop mainocc_occupation_indiv annualincome_indiv nboccupation_indiv hoursayear_indiv)
drop _merge

* Debt
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-loans_indiv", keepusing(nbloans_indiv loanamount_indiv imp1_ds_tot_indiv imp1_is_tot_indiv)
drop _merge

* Add loanbalance
preserve
use"raw/NEEMSIS2-loans_mainloans_new", clear
keep HHID2020 INDID2020 loanbalance2
rename loanbalance2 loanbalance
bys HHID2020 INDID2020: egen loanbalance_indiv=sum(loanbalance)
keep HHID2020 INDID2020 loanbalance_indiv
duplicates drop
save"_temp", replace
restore
merge 1:1 HHID2020 INDID2020 using "_temp"
drop _merge

* Transferts
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-transferts_indiv", keepusing(remreceived_indiv remsent_indiv remittnet_indiv)
drop _merge

* Panel HH
merge m:m HHID2020 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

* Panel indiv
tostring INDID2020, replace
merge 1:m HHID2020 INDID2020 using"raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Rename
rename HHID2020 HHID
rename INDID2020 INDID
order HHID_panel INDID_panel

*Year
gen year=2020

* Selection
drop if livinghome==3
drop if livinghome==4
drop if dummylefthousehold==1
drop livinghome dummylefthousehold

save"_temp_NEEMSIS2indiv", replace
****************************************
* END











****************************************
* Panel
****************************************
use"_temp_NEEMSIS2indiv", clear

***
append using "_temp_NEEMSIS1indiv"

*
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV67" & year==2020
drop if HHID_panel=="GOV65" & year==2020


*** Dummy panel HH
bysort HHID_panel: gen n=_N
recode n (1=0) (2=0) (3=1)
rename n dummypanel_HH

*** Dummy panel indiv
bysort HHID_panel INDID_panel: gen n=_N
recode n (1=0) (2=0) (3=1)
rename n dummypanel_indiv
order HHID_panel HHID dummypanel_HH INDID_panel INDID dummypanel_indiv year  
sort HHID_panel INDID_panel year

* Time
gen time=0
replace time=1 if year==2016
replace time=2 if year==2020

label define time 1"2016-2017" 2"2020-2021"
label values time time
order time, after(year)


*** Quanti 
global quanti annualincome_indiv loanamount_indiv imp1_ds_tot_indiv imp1_is_tot_indiv remreceived_indiv remsent_indiv remittnet_indiv loanbalance_indiv

*** Deflate and round
foreach x in $quanti {
replace `x'=`x'*(100/86) if year==2016
replace `x'=round(`x',1)
}


********** Merge HH charact
merge m:1 HHID_panel year using "panel_HH_v0", keepusing(ownland dummymarriage village HHsize HH_count_child assets_totalnoland1000 ownland goldquantity_HH remittnet_HH secondlockdownexposure dummydemonetisation caste annualincome_HH nbworker_HH nbnonworker_HH)
drop if _merge==2
drop _merge


*** Drop kids
ta year
ta age
drop if age<18

save"panel_indiv_v0", replace
****************************************
* END
