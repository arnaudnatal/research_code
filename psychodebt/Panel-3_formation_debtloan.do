*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*March 29, 2023
*-----
gl link = "psychodebt"
*Loan level database creation
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------




****************************************
* Loan level 2020-21
****************************************
use"raw\NEEMSIS2-loans_mainloans_new", clear


*** Indiv level loanamount
drop if loanamount==.
drop if loanamount==0
bysort HHID2020 INDID2020: egen sloanamount=sum(loanamount)


*** To keep
keep HHID2020 INDID2020 loanamount2 lenderscaste lendersex dummyproblemtorepay borrservices_none lenderfirsttime loanduration_month loan_database loanreasongiven lender4 dummyinterest imp1_interest_service lender_cat reason_cat guarantee_none termsofrepayment sloanamount


*** Recode/rename var
fre guarantee_none
rename guarantee_none dummyguarantee
recode dummyguarantee (0=1) (1=0)
fre dummyguarantee

rename loanamount2 loanamount


*** Gen ML
gen dummyml=0
replace dummyml=1 if lenderfirsttime!=.
ta dummyml


*** Selection
drop if loanduration_month>48


*** Merge charact
merge m:1 HHID2020 INDID2020 using "raw\NEEMSIS2-HH", keepusing(name age sex caste egoid)
drop _merge


*** Merge covid
merge m:1 HHID2020 using "raw\NEEMSIS2-covid", keepusing(dummysell)
drop _merge


*** Supp cont for nego
* Sex
fre lendersex
gen dummyssex=1
replace dummyssex=2 if lendersex==1 & sex==1
replace dummyssex=2 if lendersex==2 & sex==2
replace dummyssex=3 if lendersex==.
label define yesnonanew 1"No" 2"Yes" 3"N/A"
label values dummyssex yesnonanew
fre dummyssex

* Caste
fre lenderscaste
rename lenderscaste lendersjatis
gen lenderscaste=.
replace lenderscaste=2 if lendersjatis==1
replace lenderscaste=1 if lendersjatis==2
replace lenderscaste=3 if lendersjatis==4
replace lenderscaste=2 if lendersjatis==5
replace lenderscaste=3 if lendersjatis==6
replace lenderscaste=3 if lendersjatis==9
replace lenderscaste=2 if lendersjatis==10
replace lenderscaste=3 if lendersjatis==11
replace lenderscaste=2 if lendersjatis==12
replace lenderscaste=3 if lendersjatis==13
replace lenderscaste=3 if lendersjatis==14
replace lenderscaste=2 if lendersjatis==15
replace lenderscaste=2 if lendersjatis==16
replace lenderscaste=88 if lendersjatis==88

gen dummyscaste=1
replace dummyscaste=2 if caste==1 & lenderscaste==1
replace dummyscaste=2 if caste==2 & lenderscaste==2
replace dummyscaste=2 if caste==3 & lenderscaste==3
replace dummyscaste=3 if lenderscaste==.
label values dummyscaste yesnonanew
fre dummyscaste


*** Merge ID
merge m:m HHID2020 using "raw\keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw\keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge


*** Order
order HHID_panel INDID_panel HHID2020 INDID2020 dummyproblemtorepay borrservices_none
drop lenderfirsttime loanduration_month


*** Gen FE
* Indiv
egen HHINDID=concat(HHID_panel INDID_panel)
order HHID_panel INDID_panel HHINDID
encode HHINDID, gen(INDID)
drop HHINDID
order HHID_panel INDID_panel INDID
preserve
duplicates drop INDID, force
count
restore

* HH
encode HHID_panel, gen(HHID)
preserve
duplicates drop HHID, force
count
restore


* Keep egos and main loans
ta dummyml
ta egoid
drop if egoid==0
keep if dummyml==1

*
gen year=2020

save"base_loanlevel_2020", replace
*************************************
* END












****************************************
* Loan level 2016-17
****************************************
use"raw\NEEMSIS1-loans_mainloans_new", clear


*** Indiv level loanamount
drop if loanamount==.
drop if loanamount==0
bysort HHID2016 INDID2016: egen sloanamount=sum(loanamount)


*** To keep
keep HHID2016 INDID2016 loanamount2 lenderscaste lendersex dummyproblemtorepay borrservices_none lendername loanduration_month loan_database loanreasongiven lender4 dummyinterest imp1_interest_service lender_cat reason_cat guarantee_none termsofrepayment sloanamount


*** Recode/rename var
fre guarantee_none
rename guarantee_none dummyguarantee
recode dummyguarantee (0=1) (1=0)
fre dummyguarantee

rename loanamount2 loanamount


*** Gen ML
gen dummyml=0
replace dummyml=1 if lendername!=""
ta dummyml


*** Selection
*drop if loanduration_month>48


*** Merge charact
merge m:1 HHID2016 INDID2016 using "raw\NEEMSIS1-HH", keepusing(name age sex egoid)
drop if _merge==2
drop _merge

merge m:1 HHID2016 INDID2016 using "raw\NEEMSIS1-caste", keepusing(caste)
drop if _merge==2
drop _merge



*** Supp cont for nego
* Sex
fre lendersex
gen dummyssex=1
replace dummyssex=2 if lendersex==1 & sex==1
replace dummyssex=2 if lendersex==2 & sex==2
replace dummyssex=3 if lendersex==.
label define yesnonanew 1"No" 2"Yes" 3"N/A"
label values dummyssex yesnonanew
fre dummyssex

* Caste
fre lenderscaste
rename lenderscaste lendersjatis
gen lenderscaste=.
replace lenderscaste=2 if lendersjatis==1
replace lenderscaste=1 if lendersjatis==2
replace lenderscaste=3 if lendersjatis==4
replace lenderscaste=2 if lendersjatis==5
replace lenderscaste=3 if lendersjatis==6
replace lenderscaste=3 if lendersjatis==9
replace lenderscaste=2 if lendersjatis==10
replace lenderscaste=3 if lendersjatis==11
replace lenderscaste=2 if lendersjatis==12
replace lenderscaste=3 if lendersjatis==13
replace lenderscaste=3 if lendersjatis==14
replace lenderscaste=2 if lendersjatis==15
replace lenderscaste=2 if lendersjatis==16
replace lenderscaste=88 if lendersjatis==88

gen dummyscaste=1
replace dummyscaste=2 if caste==1 & lenderscaste==1
replace dummyscaste=2 if caste==2 & lenderscaste==2
replace dummyscaste=2 if caste==3 & lenderscaste==3
replace dummyscaste=3 if lenderscaste==.
label values dummyscaste yesnonanew
fre dummyscaste


*** Merge ID
merge m:m HHID2016 using "raw\keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2016, replace
merge m:m HHID_panel INDID2016 using "raw\keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge


*** Order
order HHID_panel INDID_panel HHID2016 INDID2016 dummyproblemtorepay borrservices_none
drop lendername loanduration_month


*** Gen FE
* Indiv
egen HHINDID=concat(HHID_panel INDID_panel)
order HHID_panel INDID_panel HHINDID
encode HHINDID, gen(INDID)
drop HHINDID
order HHID_panel INDID_panel INDID
preserve
duplicates drop INDID, force
count
restore

* HH
encode HHID_panel, gen(HHID)
preserve
duplicates drop HHID, force
count
restore

* Keep egos and main loans
ta dummyml
ta egoid
drop if egoid==0
keep if dummyml==1

*
gen year=2016

save"base_loanlevel_2016", replace
*************************************
* END
