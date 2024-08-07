*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*May 13, 2021
*-----
gl link = "psychodebt"
*New var
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------








*************************************
* Stat desc HH
*************************************

cls
********** Base panel indiv
use"base_panel_lag", clear

duplicates drop HHID_panel, force
count

ta shock dalits, col nofreq
ta dummysell dalits, col nofreq

tabstat HHsize assets1000 incomeHH1000, stat(n mean cv p50) by(dalits)





cls
********** Base panel loan
use"base_loanlevel_lag", clear

duplicates drop HHID_panel, force
count

ta shock dalits, col nofreq chi2
ta dummysell dalits, col nofreq chi2

tabstat HHsize assets1000 incomeHH1000, stat(n mean cv p50) by(dalits)
reg HHsize i.dalits
reg assets1000 i.dalits
reg incomeHH1000 i.dalits



*************************************
* END












*************************************
* Stat desc indiv
*************************************

cls
********** Base panel indiv
use"base_panel_lag", clear

ta dalits female, col nofreq
ta dummyhead female, col nofreq
ta maritalstatus2 female, col nofreq
ta dummyedulevel female, col nofreq
ta mainocc_occupation_indiv female, col nofreq
ta dummymultipleoccupation_indiv female, col nofreq

tabstat annualincome_indiv, stat(n mean cv p50) by(female)

*** Stat desc Y
/*
preserve
replace s_loanamount=. if s_loanamount==0
tabstat s_indebt2020 s_loanamount s_borrservices_none2020 s_dummyproblemtorepay2020, stat(n mean cv p50)
tabstat s_indebt2020 s_loanamount s_borrservices_none2020 s_dummyproblemtorepay2020 if female==0, stat(n mean cv p50)
tabstat s_indebt2020 s_loanamount s_borrservices_none2020 s_dummyproblemtorepay2020 if female==1, stat(n mean cv p50)
restore
*/


*** Stat desc ptcs
set graph off
twoway ///
(kdensity base_f1_std if female==0, lp(solid) lcolor(black)) ///
(kdensity base_f1_std if female==1, lp(dash) lcolor(black)) ///
, ytitle("Density") xtitle("ES (std)") legend(order(1 "Men" 2 "Women") pos(6) col(2) off) name(gph1, replace)

twoway ///
(kdensity base_f2_std if female==0, lp(solid) lcolor(black)) ///
(kdensity base_f2_std if female==1, lp(dash) lcolor(black)) ///
, ytitle("Density") xtitle("CO (std)") name(gph2, replace)

twoway ///
(kdensity base_f3_std if female==0, lp(solid) lcolor(black)) ///
(kdensity base_f3_std if female==1, lp(dash) lcolor(black)) ///
, ytitle("Density") xtitle("OP-EX (std)") name(gph3, replace)

twoway ///
(kdensity base_f5_std if female==0, lp(solid) lcolor(black)) ///
(kdensity base_f5_std if female==1, lp(dash) lcolor(black)) ///
, ytitle("Density") xtitle("AG (std)") name(gph4, replace)

twoway ///
(kdensity base_raven_tt_std if female==0, lp(solid) lcolor(black)) ///
(kdensity base_raven_tt_std if female==1, lp(dash) lcolor(black)) ///
, ytitle("Density") xtitle("Rav (std)") name(gph5, replace)

twoway ///
(kdensity base_num_tt_std if female==0, lp(solid) lcolor(black)) ///
(kdensity base_num_tt_std if female==1, lp(dash) lcolor(black)) ///
, ytitle("Density") xtitle("Num (std)") name(gph6, replace)

twoway ///
(kdensity base_lit_tt_std if female==0, lp(solid) lcolor(black)) ///
(kdensity base_lit_tt_std if female==1, lp(dash) lcolor(black)) ///
, ytitle("Density") xtitle("Lit (std)") name(gph7, replace)

grc1leg gph1 gph2 gph3 gph4 gph5 gph6 gph7, col(4) name(ptcs, replace)
set graph on
*graph export "ptcs.pdf", as(pdf) replace






cls
********** Base panel loan
use"base_loanlevel_lag", clear

duplicates drop HHID_panel INDID_panel, force
count


cls
* By sex
ta dalits female, col nofreq chi2
ta dummyhead female, col nofreq chi2
ta maritalstatus2 female, col nofreq chi2
ta dummyedulevel female, col nofreq chi2
ta mainocc_occupation_indiv female, col nofreq chi2
ta dummymultipleoccupation_indiv female, col nofreq chi2
tabstat age annualincome_indiv, stat(n mean cv p50) by(female)
reg age i.female
reg annualincome_indiv i.female

* PTCS
set graph off
twoway ///
(kdensity base_f1_std if female==0, lp(solid) lcolor(black)) ///
(kdensity base_f1_std if female==1, lp(dash) lcolor(black)) ///
, ytitle("Density") xtitle("ES (std)") legend(order(1 "Men" 2 "Women") pos(6) col(2) off) name(gph1s, replace)

twoway ///
(kdensity base_f2_std if female==0, lp(solid) lcolor(black)) ///
(kdensity base_f2_std if female==1, lp(dash) lcolor(black)) ///
, ytitle("Density") xtitle("CO (std)") name(gph2s, replace)

twoway ///
(kdensity base_f3_std if female==0, lp(solid) lcolor(black)) ///
(kdensity base_f3_std if female==1, lp(dash) lcolor(black)) ///
, ytitle("Density") xtitle("OP-EX (std)") name(gph3s, replace)

twoway ///
(kdensity base_f5_std if female==0, lp(solid) lcolor(black)) ///
(kdensity base_f5_std if female==1, lp(dash) lcolor(black)) ///
, ytitle("Density") xtitle("AG (std)") name(gph4s, replace)

twoway ///
(kdensity base_raven_tt_std if female==0, lp(solid) lcolor(black)) ///
(kdensity base_raven_tt_std if female==1, lp(dash) lcolor(black)) ///
, ytitle("Density") xtitle("Raven (std)") legend(order(1 "Men" 2 "Women") pos(6) col(2) off) name(gph5s, replace)

twoway ///
(kdensity base_num_tt_std if female==0, lp(solid) lcolor(black)) ///
(kdensity base_num_tt_std if female==1, lp(dash) lcolor(black)) ///
, ytitle("Density") xtitle("Num (std)") name(gph6s, replace)

twoway ///
(kdensity base_lit_tt_std if female==0, lp(solid) lcolor(black)) ///
(kdensity base_lit_tt_std if female==1, lp(dash) lcolor(black)) ///
, ytitle("Density") xtitle("Lit (std)") name(gph7s, replace)

set graph on
grc1leg gph1s gph2s gph3s gph4s gph5s gph6s gph7s, col(4) name(ptcs, replace)
*graph export "ptcs_sex_v2.pdf", as(pdf) replace





cls
* By caste
ta dalits dalits, col nofreq chi2
ta dummyhead dalits, col nofreq chi2
ta maritalstatus2 dalits, col nofreq chi2
ta dummyedulevel dalits, col nofreq chi2
ta mainocc_occupation_indiv dalits, col nofreq chi2
ta dummymultipleoccupation_indiv dalits, col nofreq chi2
tabstat age annualincome_indiv, stat(n mean cv p50) by(dalits)
reg age i.dalits
reg annualincome_indiv i.dalits

* PTCS
set graph off
twoway ///
(kdensity base_f1_std if dalits==1, lp(solid) lcolor(gs8)) ///
(kdensity base_f1_std if dalits==0, lp(dash) lcolor(gs8)) ///
, ytitle("Density") xtitle("ES (std)") legend(order(1 "Dalits" 2 "Non-dalits") pos(6) col(2) off) name(gph1c, replace)

twoway ///
(kdensity base_f2_std if dalits==1, lp(solid) lcolor(gs8)) ///
(kdensity base_f2_std if dalits==0, lp(dash) lcolor(gs8)) ///
, ytitle("Density") xtitle("CO (std)") name(gph2c, replace)

twoway ///
(kdensity base_f3_std if dalits==1, lp(solid) lcolor(gs8)) ///
(kdensity base_f3_std if dalits==0, lp(dash) lcolor(gs8)) ///
, ytitle("Density") xtitle("OP-EX (std)") name(gph3c, replace)

twoway ///
(kdensity base_f5_std if dalits==1, lp(solid) lcolor(gs8)) ///
(kdensity base_f5_std if dalits==0, lp(dash) lcolor(gs8)) ///
, ytitle("Density") xtitle("AG (std)") name(gph4c, replace)

twoway ///
(kdensity base_raven_tt_std if dalits==1, lp(solid) lcolor(gs8)) ///
(kdensity base_raven_tt_std if dalits==0, lp(dash) lcolor(gs8)) ///
, ytitle("Density") xtitle("Raven (std)") legend(order(1 "Dalits" 2 "Non-dalits") pos(6) col(2) off) name(gph5c, replace)

twoway ///
(kdensity base_num_tt_std if dalits==1, lp(solid) lcolor(gs8)) ///
(kdensity base_num_tt_std if dalits==0, lp(dash) lcolor(gs8)) ///
, ytitle("Density") xtitle("Num (std)") name(gph6c, replace)

twoway ///
(kdensity base_lit_tt_std if dalits==1, lp(solid) lcolor(gs8)) ///
(kdensity base_lit_tt_std if dalits==0, lp(dash) lcolor(gs8)) ///
, ytitle("Density") xtitle("Lit (std)") name(gph7c, replace)

set graph on
grc1leg gph1c gph2c gph3c gph4c gph5c gph6c gph7c, col(4) name(ptcs, replace)
*graph export "ptcs_caste_v2.pdf", as(pdf) replace



***** Personality traits
grc1leg gph1s gph2s gph3s gph4s, col(4) name(pts, replace)
grc1leg gph1c gph2c gph3c gph4c, col(4) name(ptc, replace)
*
graph combine pts ptc, col(1) name(pt, replace)
graph export "pt.pdf", as(pdf) replace
graph export "pt.png", as(png) replace


***** Cognitive skills
grc1leg gph5s gph6s gph7s, col(3) name(css, replace)
grc1leg gph5c gph6c gph7c, col(4) name(csc, replace)
*
graph combine css csc, col(1) name(cs, replace)
graph export "cs.pdf", as(pdf) replace
graph export "cs.png", as(png) replace

*************************************
* END













*************************************
* Stat desc loan
*************************************
use"base_loanlevel_lag", clear

cls
* By sex
tabstat loanamount, stat(n mean cv p50) by(female) 
ta lender_cat female, col nofreq chi2
ta reason_cat female, col nofreq chi2 
ta dummyinterest female, col nofreq chi2
ta dummyssex female, col nofreq chi2
ta dummyscaste female, col nofreq chi2
tabstat sloanamount, stat(n mean cv p50) by(female)

ta borrservices_none female, col nofreq chi2
ta dummyproblemtorepay female, col nofreq chi2

reg loanamount i.female
reg sloanamount i.female


cls
* By caste
tabstat loanamount, stat(n mean cv p50) by(dalits) 
ta lender_cat dalits, col nofreq chi2
ta reason_cat dalits, col nofreq chi2
ta dummyinterest dalits, col nofreq chi2
ta dummyssex dalits, col nofreq chi2
ta dummyscaste dalits, col nofreq chi2
tabstat sloanamount, stat(n mean cv p50) by(dalits)

ta borrservices_none dalits, col nofreq chi2
ta dummyproblemtorepay dalits, col nofreq chi2

reg loanamount i.dalits
reg sloanamount i.dalits

*************************************
* END












*************************************
* All main loans
*************************************
use"raw\NEEMSIS2-loans_mainloans_new", clear

********** Prepa
* Indiv level loanamount
drop if loanamount==.
drop if loanamount==0
bysort HHID2020 INDID2020: egen sloanamount=sum(loanamount)

* To keep
keep HHID2020 INDID2020 loanid loanamount2 lenderscaste lendersex dummyproblemtorepay borrservices_none lenderfirsttime loanduration_month loan_database loanreasongiven lender4 dummyinterest imp1_interest_service lender_cat reason_cat guarantee_none termsofrepayment sloanamount

* Recode/rename var
fre guarantee_none
rename guarantee_none dummyguarantee
recode dummyguarantee (0=1) (1=0)
fre dummyguarantee
rename loanamount2 loanamount

* Gen ML
gen dummyml=0
replace dummyml=1 if lenderfirsttime!=.
ta dummyml

* Selection
drop if loanduration_month>48

* Merge charact
merge m:1 HHID2020 INDID2020 using "raw\NEEMSIS2-HH", keepusing(name age sex caste egoid)
drop if _merge==2
drop _merge

* Supp sex for nego
fre lendersex
gen dummyssex=1
replace dummyssex=2 if lendersex==1 & sex==1
replace dummyssex=2 if lendersex==2 & sex==2
replace dummyssex=3 if lendersex==.
label define yesnonanew 1"No" 2"Yes" 3"N/A"
label values dummyssex yesnonanew
fre dummyssex

* Supp caste for nego
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

* Order
order HHID2020 INDID2020 dummyproblemtorepay borrservices_none
drop lenderfirsttime loanduration_month

* Label
label var age "Age"
label var borrservices_none "No need to provide service (=1)"
label var dummyproblemtorepay "Problem to repay (=1)"
label var imp1_interest_service "Interest rate (%)"
label var loanamount "Loan amount (INR)"
label var sloanamount "Individual's total debt (INR)"
fre dummyinterest
label define dummyinterest 0"Interest: No" 1"Interest: Yes", replace
label values dummyinterest dummyinterest
fre reason_cat
label define reason_cat 1"Reason: Economic" 2"Reason: Current" 3"Reason: Human capital" 4"Reason: Social" 5"Reason: Housing", replace
label values reason_cat reason_cat
fre lender4
label define lender4 1"Lender: WKP" 2"Lender: Relatives" 3"Lender: Labour" 4"Lender: Pawn broker" 6"Lender: Moneylenders" 7"Lender: Friends" 8"Lender: Microcredit" 9"Lender: Bank" , replace
label values lender4 lender4
fre lender_cat
recode lender_cat (2=1) (3=2)
label define lender_cat 1"Lender: Informal" 2"Lender: Formal", replace
label values lender_cat lender_cat
fre dummyguarantee
label define dummyguarantee 0"Guarantee: No" 1"Guarantee: Yes", replace
label values dummyguarantee dummyguarantee
fre dummyssex 
label define dummyssex 1"Same sex: No" 2"Same sex: Yes" 3"Same sex: N/A", replace
label values dummyssex dummyssex
fre dummyscaste
label define dummyscaste 1"Same caste: No" 2"Same caste: Yes" 3"Same caste: N/A", replace
label values dummyscaste dummyscaste
fre borrservices_none
label define borrservices_none 0"Services" 1"No services", replace
label values borrservices_none borrservices_none

* Merge ID
merge m:m HHID2020 using "raw\keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw\keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge
order HHID_panel INDID_panel

* Merge panel
preserve
use"raw/NEEMSIS1-HH", clear
keep HHID2016 INDID2016 egoid
drop if egoid==0
merge m:m HHID2016 using "raw\keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
tostring INDID2016, replace
merge m:m HHID_panel INDID2016 using "raw\keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge HHID2016 INDID2016
order HHID_panel INDID_panel
gen indiv2016=1
save"_temp", replace
restore

merge m:m HHID_panel INDID_panel using "_temp", keepusing(indiv2016)
drop if _merge==2
drop _merge
recode indiv2016 (.=0)
rename indiv2016 panel






********** Selection
ta dummyml
ta egoid
ta panel

ta egoid if dummyml==1
ta panel if dummyml==1
ta egoid if dummyml==1 & panel==1

preserve
keep if dummyml==1
drop if egoid==0
keep if panel==1
keep HHID_panel INDID_panel
duplicates drop
count
restore



********** Stat
* Selection
keep if dummyml==1

fre lender_cat 
fre dummyinterest 
fre reason_cat 
tabstat loanamount, stat(n mean sd p50) by(sex) 
fre dummyssex 
fre dummyscaste


*** Y var
fre borrservices_none
fre dummyproblemtorepay



*************************************
* END




