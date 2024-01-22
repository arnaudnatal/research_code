*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 1, 2023
*-----
gl link = "labourdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------





****************************************
* RUME
****************************************
use"raw\RUME-loans_mainloans_new.dta", clear

*
drop if loansettled==1

********** Drop economic investment
fre effective_repa
drop if effective_agri==1
drop if effective_inve==1



*** HH level
bysort HHID2010: egen nbloans_HH=sum(1)
bysort HHID2010: egen loanamount_HH=sum(loanamount2)
bysort HHID2010: egen loanbalance_HH=sum(loanbalance2)




*** Services
bysort HHID2010: egen imp1_ds_tot_HH=sum(imp1_debt_service)
bysort HHID2010: egen imp1_is_tot_HH=sum(imp1_interest_service)


********** HH level for dummies
foreach x in lendercat_info lendercat_semi lendercat_form given_repa effective_repa {
bysort HHID2010: egen nbHH_`x'=sum(`x')
gen dumHH_`x'=0
replace dumHH_`x'=1 if nbHH_`x'>0
drop `x'
}


foreach x in lendercatamt_info lendercatamt_semi lendercatamt_form givenamt_repa givencatamt_econ givencatamt_curr givencatamt_huma givencatamt_soci givencatamt_hous effectiveamt_repa {
bysort HHID2010: egen totHH_`x'=sum(`x')
drop `x'
}



*HH
foreach x in imp1_is_tot_HH imp1_ds_tot_HH loanamount_HH nbloans_HH loanbalance_HH totHH_givenamt_repa nbHH_lendercat_info dumHH_lendercat_info nbHH_lendercat_semi dumHH_lendercat_semi nbHH_lendercat_form dumHH_lendercat_form nbHH_given_repa dumHH_given_repa nbHH_effective_repa dumHH_effective_repa totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givenamt_repa totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous totHH_effectiveamt_repa {
label var `x' "No investment"
}

keep HHID2010 imp1_is_tot_HH imp1_ds_tot_HH loanamount_HH nbloans_HH loanbalance_HH totHH_givenamt_repa nbHH_lendercat_info dumHH_lendercat_info nbHH_lendercat_semi dumHH_lendercat_semi nbHH_lendercat_form dumHH_lendercat_form nbHH_given_repa dumHH_given_repa nbHH_effective_repa dumHH_effective_repa totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givenamt_repa totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous totHH_effectiveamt_repa
duplicates drop HHID2010, force

* Merge HHID_panel
merge m:m HHID2010 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2010
order HHID_panel year

save"RUME-loans_HH_noinvest.dta", replace
*************************************
* END











****************************************
* NEEMSIS-1
****************************************
use"raw\NEEMSIS1-loans_mainloans_new.dta", clear

*
drop if loansettled==1

********** Drop economic investment
fre effective_repa
drop if effective_agri==1
drop if effective_inve==1


*** HH level
bysort HHID2016: egen nbloans_HH=sum(1)
bysort HHID2016: egen loanamount_HH=sum(loanamount2)
bysort HHID2016: egen loanbalance_HH=sum(loanbalance2)




*** Services
bysort HHID2016: egen imp1_ds_tot_HH=sum(imp1_debt_service)
bysort HHID2016: egen imp1_is_tot_HH=sum(imp1_interest_service)
bysort HHID2016 INDID2016: egen imp1_ds_tot_ind=sum(imp1_debt_service)
bysort HHID2016 INDID2016: egen imp1_is_tot_ind=sum(imp1_interest_service)




********** HH level for dummies
foreach x in lendercat_info lendercat_semi lendercat_form given_repa effective_repa {
bysort HHID2016: egen nbHH_`x'=sum(`x')
gen dumHH_`x'=0
replace dumHH_`x'=1 if nbHH_`x'>0
drop `x'
}


foreach x in lendercatamt_info lendercatamt_semi lendercatamt_form givenamt_repa givencatamt_econ givencatamt_curr givencatamt_huma givencatamt_soci givencatamt_hous effectiveamt_repa {
bysort HHID2016: egen totHH_`x'=sum(`x')
drop `x'
}


foreach x in imp1_is_tot_HH imp1_ds_tot_HH loanamount_HH nbloans_HH loanbalance_HH totHH_givenamt_repa nbHH_lendercat_info dumHH_lendercat_info nbHH_lendercat_semi dumHH_lendercat_semi nbHH_lendercat_form dumHH_lendercat_form nbHH_given_repa dumHH_given_repa nbHH_effective_repa dumHH_effective_repa totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givenamt_repa totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous totHH_effectiveamt_repa {
label var `x' "No investment"
}


***** HH
preserve
keep HHID2016 imp1_is_tot_HH imp1_ds_tot_HH loanamount_HH nbloans_HH loanbalance_HH totHH_givenamt_repa nbHH_lendercat_info dumHH_lendercat_info nbHH_lendercat_semi dumHH_lendercat_semi nbHH_lendercat_form dumHH_lendercat_form nbHH_given_repa dumHH_given_repa nbHH_effective_repa dumHH_effective_repa totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givenamt_repa totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous totHH_effectiveamt_repa
duplicates drop HHID2016, force

* Merge HHID_panel
merge m:m HHID2016 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2016
order HHID_panel year

save"NEEMSIS1-loans_HH_noinvest.dta", replace
restore 


***** Indiv
gen share_dsr=imp1_ds_tot_ind*100/imp1_ds_tot_HH

keep HHID2016 INDID2016 share_dsr

* Merge HHID_panel
merge m:m HHID2016 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge


* Merge INDID_panel
tostring INDID2016, replace
merge m:m HHID2016 INDID2016 using "raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

gen year=2016
order HHID_panel INDID_panel year

tabstat share_dsr, stat(n mean q)

duplicates drop

save"NEEMSIS1-sharedsr_indiv.dta", replace
*************************************
* END












****************************************
* NEEMSIS-2
****************************************
use"raw\NEEMSIS2-loans_mainloans_new.dta", clear

*
drop if loansettled==1

********** Drop economic investment
fre effective_repa
drop if effective_agri==1
drop if effective_inve==1



*** HH level
bysort HHID2020: egen nbloans_HH=sum(1)
bysort HHID2020: egen loanamount_HH=sum(loanamount2)
bysort HHID2020: egen loanbalance_HH=sum(loanbalance2)




*** Services
bysort HHID2020: egen imp1_ds_tot_HH=sum(imp1_debt_service)
bysort HHID2020: egen imp1_is_tot_HH=sum(imp1_interest_service)
bysort HHID2020 INDID2020: egen imp1_ds_tot_ind=sum(imp1_debt_service)
bysort HHID2020 INDID2020: egen imp1_is_tot_ind=sum(imp1_interest_service)




********** HH level for dummies
foreach x in lendercat_info lendercat_semi lendercat_form given_repa effective_repa {
bysort HHID2020: egen nbHH_`x'=sum(`x')
gen dumHH_`x'=0
replace dumHH_`x'=1 if nbHH_`x'>0
drop `x'
}


foreach x in lendercatamt_info lendercatamt_semi lendercatamt_form givenamt_repa givencatamt_econ givencatamt_curr givencatamt_huma givencatamt_soci givencatamt_hous effectiveamt_repa {
bysort HHID2020: egen totHH_`x'=sum(`x')
drop `x'
}


foreach x in imp1_is_tot_HH imp1_ds_tot_HH loanamount_HH nbloans_HH loanbalance_HH totHH_givenamt_repa nbHH_lendercat_info dumHH_lendercat_info nbHH_lendercat_semi dumHH_lendercat_semi nbHH_lendercat_form dumHH_lendercat_form nbHH_given_repa dumHH_given_repa nbHH_effective_repa dumHH_effective_repa totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givenamt_repa totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous totHH_effectiveamt_repa {
label var `x' "No investment"
}

***** HH
preserve
keep HHID2020 imp1_is_tot_HH imp1_ds_tot_HH loanamount_HH nbloans_HH loanbalance_HH totHH_givenamt_repa nbHH_lendercat_info dumHH_lendercat_info nbHH_lendercat_semi dumHH_lendercat_semi nbHH_lendercat_form dumHH_lendercat_form nbHH_given_repa dumHH_given_repa nbHH_effective_repa dumHH_effective_repa totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givenamt_repa totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous totHH_effectiveamt_repa
duplicates drop HHID2020, force


* Merge HHID_panel
merge m:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2020
order HHID_panel year

save"NEEMSIS2-loans_HH_noinvest.dta", replace
restore



***** Indiv
gen share_dsr=imp1_ds_tot_ind*100/imp1_ds_tot_HH

keep HHID2020 INDID2020 share_dsr

* Merge HHID_panel
merge m:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge


* Merge INDID_panel
tostring INDID2020, replace
merge m:m HHID2020 INDID2020 using "raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

gen year=2020
order HHID_panel INDID_panel year

tabstat share_dsr, stat(n mean q)

duplicates drop

save"NEEMSIS2-sharedsr_indiv.dta", replace

*************************************
* END











****************************************
* Append
****************************************

***** RUME
use"raw/keypanel-HH_long", clear
*
drop if HHID==""
keep HHID_panel year
ta year
destring year, replace
keep if year==2010
merge 1:1 HHID_panel using "RUME-loans_HH_noinvest.dta"
rename _merge seldebt
save "_tempRUME", replace


***** NEEMSIS-1
use"raw/keypanel-HH_long", clear
*
drop if HHID==""
keep HHID_panel year
ta year
destring year, replace
keep if year==2016
merge 1:1 HHID_panel using "NEEMSIS1-loans_HH_noinvest.dta"
rename _merge seldebt
save "_tempNEEMSIS1", replace


***** NEEMSIS-2
use"raw/keypanel-HH_long", clear
*
drop if HHID==""
keep HHID_panel year
ta year
destring year, replace
keep if year==2020
merge 1:1 HHID_panel using "NEEMSIS2-loans_HH_noinvest.dta"
rename _merge seldebt
save "_tempNEEMSIS2", replace



***** Append
use"_tempRUME", clear

append using "_tempNEEMSIS1"
append using "_tempNEEMSIS2"

ta year

* Share form
gen shareform=totHH_lendercatamt_form*100/loanamount_HH
replace shareform=0 if shareform==.


*** Deflate and round
foreach x in loanamount_HH loanbalance_HH imp1_ds_tot_HH imp1_is_tot_HH totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givenamt_repa totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous totHH_effectiveamt_repa {
replace `x'=`x'*1.85 if year==2010
replace `x'=`x'*1.16 if year==2016
replace `x'=round(`x',1)
}

ta year

save"panel_debt_noinvest", replace



***** Indiv
use"NEEMSIS1-sharedsr_indiv.dta", clear

append using "NEEMSIS2-sharedsr_indiv.dta"

ta year

save "panel_sharedsr", replace
*************************************
* END



















****************************************
* Lag
****************************************

********** DSR 2010 en 2016 
* Sample
preserve
use"raw/keypanel-HH_wide", clear
keep HHID_panel HHID2010 HHID2016
drop if HHID2010!="" & HHID2016==""
drop if HHID2010=="" & HHID2016!=""
gen panel=0
replace panel=1 if HHID2010!="" & HHID2016!=""
ta panel
reshape long HHID, i(HHID_panel) j(year)
ta year
drop if HHID==""
drop HHID
ta year
save"_temp388", replace
restore

* Selection
use"panel_debt_noinvest", clear
ta year
drop HHID2010 HHID2016 HHID2020

merge 1:1 HHID_panel year using "_temp388"
keep if _merge==3
drop _merge
ta panel
ta year

drop if year==2016
recode year (2010=2016)

foreach x in nbloans_HH loanamount_HH loanbalance_HH imp1_ds_tot_HH imp1_is_tot_HH nbHH_lendercat_info dumHH_lendercat_info nbHH_lendercat_semi dumHH_lendercat_semi nbHH_lendercat_form dumHH_lendercat_form nbHH_given_repa dumHH_given_repa nbHH_effective_repa dumHH_effective_repa totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givenamt_repa totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous totHH_effectiveamt_repa shareform {
rename `x' lag_`x'
}
save "_temp_lag1", replace



********** DSR 2016 en 2020
* Sample
preserve
use"raw/keypanel-HH_wide", clear
keep HHID_panel HHID2016 HHID2020
drop if HHID2016!="" & HHID2020==""
drop if HHID2016=="" & HHID2020!=""
gen panel=0
replace panel=1 if HHID2016!="" & HHID2020!=""
ta panel
reshape long HHID, i(HHID_panel) j(year)
ta year
drop if HHID==""
drop HHID
ta year
save"_temp485", replace
restore

* Selection
use"panel_debt_noinvest", clear
ta year
drop HHID2010 HHID2016 HHID2020

merge 1:1 HHID_panel year using "_temp485"
keep if _merge==3
drop _merge
ta panel
ta year

drop if year==2020
recode year (2016=2020)

foreach x in nbloans_HH loanamount_HH loanbalance_HH imp1_ds_tot_HH imp1_is_tot_HH nbHH_lendercat_info dumHH_lendercat_info nbHH_lendercat_semi dumHH_lendercat_semi nbHH_lendercat_form dumHH_lendercat_form nbHH_given_repa dumHH_given_repa nbHH_effective_repa dumHH_effective_repa totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givenamt_repa totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous totHH_effectiveamt_repa shareform {
rename `x' lag_`x'
}
save "_temp_lag2", replace



********** Merger le lag
use"_temp_lag1", clear

*
append using "_temp_lag2"
ta year
save "_templag", replace

*
use"panel_debt_noinvest", clear
merge 1:1 HHID_panel year using "_templag"
drop _merge 
drop HHID2010 HHID2016 HHID2020

ta year
ta imp1_ds_tot_HH year

save"panel_debt_noinvest_v2", replace



***** Indiv
use"panel_sharedsr", clear

* Creation du lag
preserve
drop if year==2020
ta year
recode year (2016=2020) (2010=2016)
ta year

rename share_dsr lag_share_dsr

drop HHID2016 INDID2016 HHID2020 INDID2020

save "_temp_lag", replace
restore


* Merge lag
merge 1:1 HHID_panel INDID_panel year using "_temp_lag"
drop _merge 
drop HHID2016 INDID2016 HHID2020 INDID2020

tabstat share_dsr lag_share_dsr, stat(n mean q)

label var lag_share_dsr "Lag share DSR (%)"
label var share_dsr "Share DSR (%)"

save"panel_sharedsr_v2", replace

*************************************
* END






