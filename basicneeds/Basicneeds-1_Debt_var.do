*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*March 22, 2024
*-----
gl link = "basicneeds"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\basicneeds.do"
*-------------------------





****************************************
* RUME
****************************************
use"raw\RUME-loans_mainloans_new.dta", clear

*
drop if loansettled==1

* Merge
merge m:m HHID2010 using "raw/keypanel-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge

* To keep
global vartokeep loanreasongiven given_agri given_fami given_heal given_repa given_hous given_inve given_cere given_marr given_educ given_rela given_deat loanamount2 loanlender dummyinterest lender_cat reason_cat lender4 loanbalance2 interestpaid2 totalrepaid2 principalpaid2 interestloan2 loanduration_month loan_months yratepaid monthlyinterestrate debt_service interest_service imp1_debt_service imp1_interest_service lender_WKP lender_rela lender_empl lender_mais lender_coll lender_pawn lender_shop lender_fina lender_frie lender_SHG lender_bank lender_coop lender_suga lender4_WKP lender4_rela lender4_labo lender4_pawn lender4_shop lender4_mone lender4_frie lender4_micr lender4_bank lender4_neig lendercat_info lendercat_semi lendercat_form lenderamt_WKP lenderamt_rela lenderamt_empl lenderamt_mais lenderamt_coll lenderamt_pawn lenderamt_shop lenderamt_fina lenderamt_frie lenderamt_SHG lenderamt_bank lenderamt_coop lenderamt_suga lender4amt_WKP lender4amt_rela lender4amt_labo lender4amt_pawn lender4amt_shop lender4amt_mone lender4amt_frie lender4amt_micr lender4amt_bank lender4amt_neig lendercatamt_info lendercatamt_semi lendercatamt_form givenamt_agri givenamt_fami givenamt_heal givenamt_repa givenamt_hous givenamt_inve givenamt_cere givenamt_marr givenamt_educ givenamt_rela givenamt_deat givencat_econ givencat_curr givencat_huma givencat_soci givencat_hous givencatamt_econ givencatamt_curr givencatamt_huma givencatamt_soci givencatamt_hous effective_agri effective_fami effective_heal effective_repa effective_hous effective_inve effective_cere effective_marr effective_educ effective_rela effective_deat effectiveamt_agri effectiveamt_fami effectiveamt_heal effectiveamt_repa effectiveamt_hous effectiveamt_inve effectiveamt_cere effectiveamt_marr effectiveamt_educ effectiveamt_rela effectiveamt_deat

keep HHID_panel loanid $vartokeep
gen year=2010
order HHID_panel year loanid

save"_tempRUME", replace
*************************************
* END











****************************************
* NEEMSIS-1
****************************************
use"raw\NEEMSIS1-loans_mainloans_new.dta", clear

*
drop if loansettled==1

* Merge
merge m:m HHID2016 using "raw/keypanel-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2016, replace
tostring loanid, replace
merge m:m HHID2016 INDID2016 using "raw/keypanel-Indiv_wide.dta", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* To keep
keep HHID_panel INDID_panel loanid $vartokeep
gen year=2016
order HHID_panel INDID_panel year loanid

save"_tempNEEMSIS1", replace
*************************************
* END












****************************************
* NEEMSIS-2
****************************************
use"raw\NEEMSIS2-loans_mainloans_new.dta", clear

*
drop if loansettled==1
gen year=2020

* Merge
merge m:m HHID2020 using "raw/keypanel-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
tostring loanid, replace
merge m:m HHID2020 INDID2020 using "raw/keypanel-Indiv_wide.dta", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* To keep
keep HHID_panel INDID_panel loanid $vartokeep
gen year=2020
order HHID_panel INDID_panel year loanid

save"_tempNEEMSIS2", replace
*************************************
* END














****************************************
* Append
****************************************
use"_tempRUME", clear

append using "_tempNEEMSIS1"
append using "_tempNEEMSIS2"

* Deflate
foreach x in loanamount2 loanbalance2 interestpaid2 totalrepaid2 principalpaid2 monthlyinterestrate debt_service interest_service imp1_debt_service imp1_interest_service {
replace `x'=`x'*(100/158) if year==2016
replace `x'=`x'*(100/184) if year==2020
}


save"all_loans", replace
*************************************
* END











****************************************
* Desc
****************************************
use"all_loans", clear

*
ta loanreasongiven year
ta loanreasongiven year, col nofreq
tabstat loanamount2 if year==2010, stat(mean) by(loanreasongiven)
tabstat loanamount2 if year==2016, stat(mean) by(loanreasongiven)
tabstat loanamount2 if year==2020, stat(mean) by(loanreasongiven)

cls
* % of household using it
fre loanreasongiven
forvalues i=1/12 {
preserve
bysort HHID_panel year: gen n=1 if loanreasongiven==`i'
keep HHID_panel year n
duplicates drop
ta n year
restore
}
preserve
bysort HHID_panel year: gen n=1 if loanreasongiven==77
keep HHID_panel year n
duplicates drop
ta n year
restore


* % of the dsr
bysort HHID_panel year: egen imp1_debt_service_HH=sum(imp1_debt_service)
recode loanreasongiven (77=13)
forvalues i=1/13 {
gen dsr_`i'=imp1_debt_service if loanreasongiven==`i'
bysort HHID_panel year : egen sum_dsr_`i'=sum(dsr_`i')
gen share_dsr_`i'=sum_dsr_`i'*100/imp1_debt_service_HH
drop dsr_`i' sum_dsr_`i'
}
egen test=rowtotal(share_dsr_1 share_dsr_2 share_dsr_3 share_dsr_4 share_dsr_5 share_dsr_6 share_dsr_7 share_dsr_8 share_dsr_9 share_dsr_10 share_dsr_11 share_dsr_12 share_dsr_13)
ta test
sort test
drop test

tabstat share_dsr_1 share_dsr_2 share_dsr_3 share_dsr_4 share_dsr_5 share_dsr_6 share_dsr_7 share_dsr_8 share_dsr_9 share_dsr_10 share_dsr_11 share_dsr_12 share_dsr_13, stat(mean) by(year)


***** Qui finance ?
fre loanreasongiven
keep if loanreasongiven==2 | loanreasongiven==3 | loanreasongiven==9

ta loanreasongiven

ta lender_cat loanreasongiven, exp cchi2 chi2
ta lender_cat loanreasongiven, nofreq col

ta lender4 loanreasongiven, exp cchi2 chi2
ta lender4 loanreasongiven, nofreq col


*************************************
* END






