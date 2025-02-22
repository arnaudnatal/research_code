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

*
drop if loansettled==1
drop loansettled

*
gen dummymainloan=0
replace dummymainloan=1 if borrowerservices!=.
ta dummymainloan

keep HHID2010 loanid loanreasongiven loanlender loanamount lender_cat reason_cat lender4 loanamount2 loanbalance2 interestpaid2 totalrepaid2 principalpaid2 effective_repa plantorep_* dummymainloan imp1_debt_service imp1_interest_service loandate

merge m:m HHID2010 using "raw/keypanel-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2010

* Loan date
gen date="01mar2010"
gen submissiondate=date(date, "DMY")
format submissiondate %td
gen between=submissiondate-loandate
ta between
replace between=3 if between<3
ta between
gen deltadate=.
label define deltadate 1"Less than 6m" 2"6m to 1y" 3"1y to 2y" 4"2y and 4y" 5"More than 4y"
label values deltadate deltadate
replace deltadate=1 if between<182
replace deltadate=2 if between>=182 & between<365
replace deltadate=3 if between>=365 & between<730
replace deltadate=4 if between>=730 & between<1460
replace deltadate=5 if between>=1460
ta deltadate

save"_temp_RUME-loans.dta", replace
****************************************
* END







****************************************
* NEEMSIS-1 (2016-17)
****************************************
use"raw/NEEMSIS1-loans_mainloans_new.dta", replace

* Loan settled
drop if loansettled==1
drop loansettled

* Interview date
preserve
use"raw/NEEMSIS1-HH", clear
keep HHID2016 submissiondate
duplicates drop
save"_temp", replace
restore
merge m:1 HHID2016 using "_temp"
keep if _merge==3
drop _merge
order HHID2016 INDID2016 year submissiondate
sort HHID2016 INDID2016 loanid

*
gen dummymainloan=0
replace dummymainloan=1 if borrowerservices!=""
ta dummymainloan

ta loan_database
drop if loan_database=="MARRIAGE"
keep HHID2016 INDID2016 loanid submissiondate loanreasongiven loanlender loanamount lender_cat reason_cat lender4 loanamount2 loanbalance2 interestpaid2 totalrepaid2 principalpaid2 effective_repa loan_database plantorep_* settlestrat_* dummymainloan imp1_debt_service imp1_interest_service loandate

merge m:m HHID2016 using "raw/keypanel-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2016

tostring INDID2016, replace
merge m:m HHID_panel INDID2016 using "raw/keypanel-Indiv_wide.dta", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Loanid
tostring loanid, replace

* Loan date
gen between=submissiondate-loandate
ta between
replace between=3 if between<3
ta between
gen deltadate=.
label define deltadate 1"Less than 6m" 2"6m to 1y" 3"1y to 2y" 4"2y and 4y" 5"More than 4y"
label values deltadate deltadate
replace deltadate=1 if between<182
replace deltadate=2 if between>=182 & between<365
replace deltadate=3 if between>=365 & between<730
replace deltadate=4 if between>=730 & between<1460
replace deltadate=5 if between>=1460
ta deltadate

save"_temp_NEEMSIS1-loans.dta", replace
****************************************
* END













****************************************
* NEEMSIS-2 (2020-21)
****************************************
use"raw/NEEMSIS2-loans_mainloans_new.dta", replace

*
drop if loansettled==1
drop loansettled

* Interview date
preserve
use"raw/NEEMSIS2-HH", clear
keep HHID2020 submissiondate
duplicates drop
save"_temp", replace
restore
merge m:1 HHID2020 using "_temp"
keep if _merge==3
drop _merge
order HHID2020 INDID2020 year submissiondate
sort HHID2020 INDID2020 loanid

*
drop dummymainloan
gen dummymainloan=0
replace dummymainloan=1 if borrowerservices!=""
ta dummymainloan

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

keep HHID2020 INDID2020 loanid submissiondate loanreasongiven loanlender loanamount lender_cat reason_cat lender4 loanamount2 loanbalance2 interestpaid2 totalrepaid2 principalpaid2 effective_repa loan_database plantorep_* settlestrat_* dummymainloan imp1_debt_service imp1_interest_service loandate

merge m:m HHID2020 using "raw/keypanel-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2020

tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw/keypanel-Indiv_wide.dta", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Loanid
tostring loanid, replace

* How many HH?
preserve
keep if effective_repa==1
keep HHID_panel effective_repa
duplicates drop
restore


* Loan date
gen between=submissiondate-loandate
ta between
replace between=3 if between<3
ta between
gen deltadate=.
label define deltadate 1"Less than 6m" 2"6m to 1y" 3"1y to 2y" 4"2y and 4y" 5"More than 4y"
label values deltadate deltadate
replace deltadate=1 if between<182
replace deltadate=2 if between>=182 & between<365
replace deltadate=3 if between>=365 & between<730
replace deltadate=4 if between>=730 & between<1460
replace deltadate=5 if between>=1460
ta deltadate


save"_temp_NEEMSIS2-loans.dta", replace
****************************************
* END











****************************************
* Append
****************************************
use"_temp_NEEMSIS2-loans", replace

append using "_temp_NEEMSIS1-loans"
append using "_temp_RUME-loans"

* Loan date 2
gen submissionyear=year(submissiondate)
gen loanyear=year(loandate)
replace loanyear=2021 if loanyear>2021
ta submissionyear
ta loanyear

gen deltayear1=.
replace deltayear1=1 if submissionyear==2010 & loanyear<=2009
replace deltayear1=1 if submissionyear==2016 & loanyear<=2015
replace deltayear1=1 if submissionyear==2017 & loanyear<=2016
replace deltayear1=1 if submissionyear==2020 & loanyear<=2019
replace deltayear1=1 if submissionyear==2021 & loanyear<=2020
recode deltayear1 (.=0)
ta deltayear1 year

gen deltayear2=.
replace deltayear2=1 if submissionyear==2010 & loanyear<=2008
replace deltayear2=1 if submissionyear==2016 & loanyear<=2014
replace deltayear2=1 if submissionyear==2017 & loanyear<=2015
replace deltayear2=1 if submissionyear==2020 & loanyear<=2018
replace deltayear2=1 if submissionyear==2021 & loanyear<=2019
recode deltayear2 (.=0)
ta deltayear2


* Souci label lender4
fre lender4
label define lender4 1"WKP" 2"Relatives" 3"Labour" 4"Pawn broker" 5"Shop keeper" 6"Moneylenders" 7"Friends" 8"Microcredit" 9"Bank" 10"Neighbor"
label values lender4 lender4
fre lender4


gen test=loanamount-loanamount2
ta test
drop test loanamount

foreach x in loanamount loanbalance interestpaid totalrepaid principalpaid {
rename `x'2 `x'
}

order HHID_panel year loanamount loanreasongiven loanlender 


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

* Supprimer les morts et les migrants en 2016-17
destring INDID2016, replace
merge m:1 HHID2016 INDID2016 using "raw/NEEMSIS1-HH", keepusing(livinghome)
drop if _merge==2
drop _merge
drop if livinghome==3
drop if livinghome==4
drop livinghome

* Supprimer les morts et les migrants en 2020-21
destring INDID2020, replace
merge m:1 HHID2020 INDID2020 using "raw/NEEMSIS2-HH", keepusing(dummylefthousehold livinghome)
drop if _merge==2
drop _merge
drop if dummylefthousehold==1
drop if livinghome==3
drop if livinghome==4
drop dummylefthousehold livinghome

* INDID
drop HHID2010 HHID2016 HHID2020 INDID2016 INDID2020
order HHID_panel INDID_panel year loanid loanamount loanreasongiven loanlender dummymainloan

* Dummy trap one year
gen trapdelta1year=1 if given_repa==1 & deltayear1==1
ta trapdelta1year year

* Dummy trap two year
gen trapdelta2year=1 if given_repa==1 & deltayear2==1
ta trapdelta2year year


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

* Given by year
foreach x in trapdelta1year trapdelta2year {
bysort HHID_panel year: egen `x'_HH=sum(`x')
}
foreach x in trapdelta1year trapdelta2year {
replace `x'_HH=1 if `x'_HH>1
}

* Effective
gen loanamount_effectiverepa=loanamount if effective_repa==1
bysort HHID_panel year: egen lamounteffectiverepa_HH=sum(loanamount_effectiverepa)
drop loanamount_effectiverepa

gen loanbalance_effectiverepa=loanbalance if effective_repa==1
bysort HHID_panel year: egen lbalanceeffectiverepa_HH=sum(loanbalance_effectiverepa)
drop loanbalance_effectiverepa

bysort HHID_panel year: egen lnbeffectiverepa_HH=sum(effective_repa)

keep HHID_panel year lamount_HH lbalance_HH lnb_HH lamountgivenrepa_HH lbalancegivenrepa_HH lnbgivenrepa_HH lamounteffectiverepa_HH lbalanceeffectiverepa_HH lnbeffectiverepa_HH trapdelta1year_HH trapdelta2year_HH
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


do"$dofile\Debttrap-02_prepa_HH"
