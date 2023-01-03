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







****************************************
* Formation var 2020
****************************************
use"raw\NEEMSIS2-loans_mainloans_new", clear

keep HHID2020 INDID2020 loanamount lenderscaste lendersex dummyproblemtorepay borrservices_none lenderfirsttime loanduration_month loan_database
ta loanduration_month

* Id ML
gen dummyml=0
replace dummyml=1 if lenderfirsttime!=.
ta dummyml

* Selection
drop if loanduration_month>48

* Merge charact
merge m:1 HHID2020 INDID2020 using "raw\NEEMSIS2-HH", keepusing(name age sex caste egoid covsellgoods covsellgoods_none)
drop _merge

* Same caste, same sex
fre lendersex
gen dummyssex=0
replace dummyssex=1 if lendersex==1 & sex==1
replace dummyssex=1 if lendersex==2 & sex==2

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

gen dummyscaste=0
replace dummyscaste=1 if caste==1 & lenderscaste==1
replace dummyscaste=1 if caste==2 & lenderscaste==2
replace dummyscaste=1 if caste==3 & lenderscaste==3


* Indiv scale
gen indebt=1 if loanamount!=0 & loanamount!=.

foreach x in indebt dummyproblemtorepay borrservices_none dummyscaste dummyssex dummyml {
bysort HHID2020 INDID2020: egen s_`x'=sum(`x')
}

* Recode var
gen nb_loans=s_indebt
foreach x in s_indebt s_borrservices_none s_dummyproblemtorepay s_dummyml {
replace `x'=1 if `x'>1
}
foreach x in s_borrservices_none s_dummyproblemtorepay {
replace `x'=. if s_dummyml==0
}

* Share sex/caste
gen sharesex=s_dummyssex/nb_loans
gen sharecaste=s_dummyscaste/nb_loans
ta sharesex
ta sharecaste

* Indiv level
drop loanamount dummyproblemtorepay lendersjatis lendersex borrservices_none dummyssex lenderscaste dummyscaste indebt loanduration_month loan_database lenderfirsttime dummyml
duplicates drop


* Merge ID
merge m:m HHID2020 using "raw\ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw\ODRIIS-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Clean
drop egoid name sex age caste HHID2020 INDID2020
foreach x in s_indebt s_dummyproblemtorepay s_borrservices_none s_dummyscaste s_dummyssex nb_loans s_dummyml {
rename `x' `x'2020
}

* Merge with 2016-17
merge 1:1 HHID_panel INDID_panel using "panel_wide_v2"
drop if _merge==1
drop _merge


* Check consistency compared to before
ta s_indebt2020
ta s_dummyml
ta s_borrservices_none2020
ta s_dummyproblemtorepay2020

ta s_indebt2020 sex, col nofreq
ta s_borrservices_none2020 sex, col nofreq
ta s_dummyproblemtorepay2020 sex, col nofreq


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

*** Shock COVID
ta covsellgoods
ta covsellgoods_none


save"panel_wide_v3", replace
*************************************
* END












*************************************
* Indiv level
*************************************
use"panel_wide_v3", clear

*** Macro
global PT base_f1_std base_f2_std base_f3_std base_f5_std 

global CS  base_raven_tt_std base_num_tt_std base_lit_tt_std

global PTCS $PT $CS

global XIndiv female dalits age agesq dummyhead maritalstatus2 dummyedulevel cat_mainocc_occupation_indiv_1 cat_mainocc_occupation_indiv_2 cat_mainocc_occupation_indiv_4 cat_mainocc_occupation_indiv_5 cat_mainocc_occupation_indiv_6 cat_mainocc_occupation_indiv_7 indebt_indiv

global XHH HHsize assets1000 incomeHH1000 shock covsellgoods_none

global XVillages villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10

mdesc $PT $CS $XLoan $XIndiv $XHH $XVillages



*** Recourse
probit s_indebt2020 c.base_f1_std c.base_f2_std c.base_f3_std c.base_f5_std c.base_raven_tt_std c.base_num_tt_std c.base_lit_tt_std $XIndiv $XHH $XVillages, cluster(HHID)
overfit: probit s_indebt2020 c.base_f1_std c.base_f2_std c.base_f3_std c.base_f5_std c.base_raven_tt_std c.base_num_tt_std c.base_lit_tt_std $XIndiv $XHH $XVillages, cluster(HHID)
margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) atmeans


*** Negotiation
probit s_borrservices_none2020 c.base_f1_std c.base_f2_std c.base_f3_std c.base_f5_std c.base_raven_tt_std c.base_num_tt_std c.base_lit_tt_std $XIndiv $XHH $XVillages, cluster(HHID)
overfit: probit s_borrservices_none2020 c.base_f1_std c.base_f2_std c.base_f3_std c.base_f5_std c.base_raven_tt_std c.base_num_tt_std c.base_lit_tt_std $XIndiv $XHH $XVillages, cluster(HHID)
margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) atmeans


*** Management
probit s_dummyproblemtorepay2020 c.base_f1_std c.base_f2_std c.base_f3_std c.base_f5_std c.base_raven_tt_std c.base_num_tt_std c.base_lit_tt_std $XIndiv $XHH $XVillages, cluster(HHID)
overfit: probit s_dummyproblemtorepay2020 c.base_f1_std c.base_f2_std c.base_f3_std c.base_f5_std c.base_raven_tt_std c.base_num_tt_std c.base_lit_tt_std $XIndiv $XHH $XVillages, cluster(HHID)
margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) atmeans


*************************************
* END





probit s_indebt2020 i.female##i.dalits##c.base_f1_std i.female##i.dalits##c.base_f2_std i.female##i.dalits##c.base_f3_std i.female##i.dalits##c.base_f5_std i.female##i.dalits##c.base_raven_tt_std i.female##i.dalits##c.base_num_tt_std i.female##i.dalits##c.base_lit_tt_std $XIndiv $XHH $XVillages, cluster(HHID)
overfit: probit s_indebt2020 i.female##i.dalits##c.base_f1_std i.female##i.dalits##c.base_f2_std i.female##i.dalits##c.base_f3_std i.female##i.dalits##c.base_f5_std i.female##i.dalits##c.base_raven_tt_std i.female##i.dalits##c.base_num_tt_std i.female##i.dalits##c.base_lit_tt_std $XIndiv $XHH $XVillages, cluster(HHID)



probit s_borrservices_none2020 i.female##i.dalits##c.base_f1_std i.female##i.dalits##c.base_f2_std i.female##i.dalits##c.base_f3_std i.female##i.dalits##c.base_f5_std i.female##i.dalits##c.base_raven_tt_std i.female##i.dalits##c.base_num_tt_std i.female##i.dalits##c.base_lit_tt_std $XIndiv $XHH $XVillages, cluster(HHID)


probit s_dummyproblemtorepay2020 i.female##i.dalits##c.base_f1_std i.female##i.dalits##c.base_f2_std i.female##i.dalits##c.base_f3_std i.female##i.dalits##c.base_f5_std i.female##i.dalits##c.base_raven_tt_std i.female##i.dalits##c.base_num_tt_std i.female##i.dalits##c.base_lit_tt_std $XIndiv $XHH $XVillages, cluster(HHID)






*************************************
* Debt negotiation
*************************************
use"panel_wide_v3", clear

***** Clean
drop if lenderscaste==.


drop if base_lit_tt_std==.

fre borrservices_none
ta borrservices_none if dalits==1
ta borrservices_none if dalits==0
ta borrservices_none if female==1
ta borrservices_none if female==0
ta borrservices_none if dalits==1 & female==1
ta borrservices_none if dalits==1 & female==0
ta borrservices_none if dalits==0 & female==1
ta borrservices_none if dalits==0 & female==0





*************************************
* END













*************************************
* Debt management
*************************************
use"panel_wide_v3", clear







*************************************
* END



/*

***** Multivel probit
* Step 1: Intercept only model (IOM)
melogit dummyproblemtorepay || HHID:  || INDID:
est store IOM
estat icc

* Step 2: Constrained intermerdiate model (CIM)
melogit dummyproblemtorepay $PTCS $XIndiv $XHH $XVillages || HHID:  || INDID:
est store CIM
*estat icc
*melogit dummyproblemtorepay $PTCS $XIndiv $XHH $XVillages || HHID:  || INDID:, or
*est store CIMor



* Step 3: Augmented intermediate model (AIM)
/*
foreach x in $PTCS $XIndiv {
melogit dummyproblemtorepay $PTCS $XIndiv $XHH $XVillages || HHID:  || INDID: `x'
est store AIM_`x'
estat icc
melogit dummyproblemtorepay $PTCS $XIndiv $XHH $XVillages || HHID:  || INDID: `x', or
est store AIMor_`x'
}
*/

* Step 4: Compare CIM with AIM
*lrtest CIM AIM



* Step 5: Interaction terms
set maxiter 16000
global PTCS base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std

global XIndiv age agesq maritalstatus2 dummyhead dummyedulevel cat_mainocc_occupation_indiv_1 cat_mainocc_occupation_indiv_2 cat_mainocc_occupation_indiv_4 cat_mainocc_occupation_indiv_5 cat_mainocc_occupation_indiv_6 cat_mainocc_occupation_indiv_7

* No int
melogit dummyproblemtorepay c.base_f1_std c.base_f2_std c.base_f3_std c.base_f5_std c.base_raven_tt_std c.base_num_tt_std c.base_lit_tt_std female caste $XIndiv $XHH $XVillages || HHID:  || INDID:
est store mana1

