*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*January 21, 2025
*-----
gl link = "debttrap"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------













****************************************
* RUME (2010)
****************************************
use"raw/RUME-loans_mainloans_new.dta", replace

keep HHID2010 loanreasongiven loanlender loansettled loanamount lender_cat reason_cat lender4 dummyml loanamount2 loanbalance2 interestpaid2 totalrepaid2 principalpaid2 effective_repa       

merge m:m HHID2010 using "raw/keypanel-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2010

save"_temp_RUME-loans.dta", replace
****************************************
* END













****************************************
* NEEMSIS-1 (2016-17)
****************************************
use"raw/NEEMSIS1-loans_mainloans_new.dta", replace

ta loan_database
drop if loan_database=="MARRIAGE"
keep HHID2016 INDID2016 loanreasongiven loanlender loansettled loanamount lender_cat reason_cat lender4 dummyml loanamount2 loanbalance2 interestpaid2 totalrepaid2 principalpaid2 effective_repa loan_database

merge m:m HHID2016 using "raw/keypanel-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2016

tostring INDID2016, replace
merge m:m HHID_panel INDID2016 using "raw/keypanel-Indiv_wide.dta", keepusing(INDID_panel)
keep if _merge==3
drop _merge
drop INDID2016

ta loanreasongiven effective_repa


save"_temp_NEEMSIS1-loans.dta", replace
****************************************
* END













****************************************
* NEEMSIS-2 (2020-21)
****************************************
use"raw/NEEMSIS2-loans_mainloans_new.dta", replace

drop effective_*
ta loaneffectivereason loan_database, m
ta loaneffectivereason, gen(effective_)
rename effective_1 effective_agri
rename effective_2 effective_fami
rename effective_3 effective_heal
rename effective_4 effective_repa
rename effective_5 effective_hous
rename effective_6 effective_inve
rename effective_7 effective_cere
rename effective_8 effective_marr
rename effective_9 effective_educ
rename effective_10 effective_rela
rename effective_11 effective_deat
rename effective_12 effective_nore
rename effective_13 effective_othe

fre loaneffectivereason2
gen effective_repa2=effective_repa
replace effective_repa2=1 if loaneffectivereason2==4 & effective_repa2!=. & effective_repa2!=1
ta effective_repa2

keep HHID2020 INDID2020 loanreasongiven loanlender loansettled loanamount lender_cat reason_cat lender4 dummyml loanamount2 loanbalance2 interestpaid2 totalrepaid2 principalpaid2 effective_repa loan_database

merge m:m HHID2020 using "raw/keypanel-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2020

tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw/keypanel-Indiv_wide.dta", keepusing(INDID_panel)
keep if _merge==3
drop _merge
drop INDID2020

* How many HH?
preserve
keep if effective_repa==1
keep HHID_panel effective_repa
duplicates drop
restore


save"_temp_NEEMSIS2-loans.dta", replace
****************************************
* END











****************************************
* Append
****************************************
use"_temp_NEEMSIS2-loans", replace

append using "_temp_NEEMSIS1-loans"
append using "_temp_RUME-loans"

gen test=loanamount-loanamount2
ta test
drop test loanamount

foreach x in loanamount loanbalance interestpaid totalrepaid principalpaid {
rename `x'2 `x'
}

drop HHID2010 HHID2016 HHID2020

order HHID_panel year loanamount loansettled loanreasongiven loanlender 


********** Selection of the 6 households
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV67" & year==2020
drop if HHID_panel=="GOV65" & year==2020



*** Deflate and round
foreach x in loanamount loanbalance interestpaid totalrepaid principalpaid {
replace `x'=`x'*(100/54) if year==2010
replace `x'=`x'*(100/86) if year==2016
replace `x'=round(`x',1)
replace `x'=`x'/1000
}



* New cat for lenders
ta loanlender lender_cat
fre lender4
gen lender4cat=.
replace lender4cat=1 if lender4==1
replace lender4cat=1 if lender4==2
replace lender4cat=1 if lender4==3
replace lender4cat=1 if lender4==4
replace lender4cat=1 if lender4==5
replace lender4cat=2 if lender4==6
replace lender4cat=1 if lender4==7
replace lender4cat=2 if lender4==8
replace lender4cat=2 if lender4==9
replace lender4cat=1 if lender4==10

label define lender4cat 1"Informal" 2"Formal"
label values lender4cat lender4cat


ta lender_cat lender4cat
drop lender_cat

order HHID_panel INDID_panel year

* Given pour repayer
fre loanreasongiven
gen given_repa=1 if loanreasongiven==4
recode given_repa (.=0)

ta effective_repa year, col
ta loanreasongiven effective_repa if year==2016
ta loanreasongiven effective_repa if year==2020

*
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV67" & year==2020
drop if HHID_panel=="GOV65" & year==2020



save"panel_loans_v0", replace
****************************************
* END











****************************************
* HH level
****************************************
use"panel_loans_v0", clear

* Total
bysort HHID_panel year: egen lamount_HH=sum(loanamount)
bysort HHID_panel year: egen lbalance_HH=sum(loanbalance)
bysort HHID_panel year: egen lnb_HH=sum(1)

* Given
gen loanamount_givenrepa=loanamount if given_repa==1
bysort HHID_panel year: egen lamountgivenrepa_HH=sum(loanamount_givenrepa)
drop loanamount_givenrepa

gen loanbalance_givenrepa=loanbalance if given_repa==1
bysort HHID_panel year: egen lbalancegivenrepa_HH=sum(loanbalance_givenrepa)
drop loanbalance_givenrepa

bysort HHID_panel year: egen lnbgivenrepa_HH=sum(given_repa)


* Effective
gen loanamount_effectiverepa=loanamount if effective_repa==1
bysort HHID_panel year: egen lamounteffectiverepa_HH=sum(loanamount_effectiverepa)
drop loanamount_effectiverepa

gen loanbalance_effectiverepa=loanbalance if effective_repa==1
bysort HHID_panel year: egen lbalanceeffectiverepa_HH=sum(loanbalance_effectiverepa)
drop loanbalance_effectiverepa

bysort HHID_panel year: egen lnbeffectiverepa_HH=sum(effective_repa)

keep HHID_panel year lamount_HH lbalance_HH lnb_HH lamountgivenrepa_HH lbalancegivenrepa_HH lnbgivenrepa_HH lamounteffectiverepa_HH lbalanceeffectiverepa_HH lnbeffectiverepa_HH

duplicates drop
save"_temp_trap_HH", replace
****************************************
* END



















****************************************
* Indiv level
****************************************
use"panel_loans_v0", clear

drop if year==2010

* Total
bysort HHID_panel INDID_panel year: egen lamount_indiv=sum(loanamount)
bysort HHID_panel INDID_panel year: egen lbalance_indiv=sum(loanbalance)
bysort HHID_panel INDID_panel year: egen lnb_indiv=sum(1)

* Given
gen loanamount_givenrepa=loanamount if given_repa==1
bysort HHID_panel INDID_panel year: egen lamountgivenrepa_indiv=sum(loanamount_givenrepa)
drop loanamount_givenrepa

gen loanbalance_givenrepa=loanbalance if given_repa==1
bysort HHID_panel INDID_panel year: egen lbalancegivenrepa_indiv=sum(loanbalance_givenrepa)
drop loanbalance_givenrepa

bysort HHID_panel INDID_panel year: egen lnbgivenrepa_indiv=sum(given_repa)


* Effective
gen loanamount_effectiverepa=loanamount if effective_repa==1
bysort HHID_panel INDID_panel year: egen lamounteffectiverepa_indiv=sum(loanamount_effectiverepa)
drop loanamount_effectiverepa

gen loanbalance_effectiverepa=loanbalance if effective_repa==1
bysort HHID_panel INDID_panel year: egen lbalanceeffectiverepa_indiv=sum(loanbalance_effectiverepa)
drop loanbalance_effectiverepa

bysort HHID_panel INDID_panel year: egen lnbeffectiverepa_indiv=sum(effective_repa)

keep HHID_panel INDID_panel year lamount_indiv lbalance_indiv lnb_indiv lamountgivenrepa_indiv lbalancegivenrepa_indiv lnbgivenrepa_indiv lamounteffectiverepa_indiv lbalanceeffectiverepa_indiv lnbeffectiverepa_indiv

duplicates drop
save"_temp_trap_indiv", replace
****************************************
* END




