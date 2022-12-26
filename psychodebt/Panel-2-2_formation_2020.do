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
* Loans
****************************************
use"raw\NEEMSIS2-loans_mainloans_new", clear


* Id
merge m:m HHID2020 using "raw\ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw\ODRIIS-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

order HHID_panel INDID_panel HHID2020 INDID2020



********** Only keep loan contract after the measure of personality traits
drop if loanduration_month>48
drop if loansettled==1


********** Id for ML
gen dummymainloan=0
replace dummymainloan=1 if lenderfirsttime!=.
tab dummymainloan
/*
1630 ML
How much indiv with ML?
*/
bysort HHID_panel INDID_panel: egen dummyml_indiv=sum(dummymainloan)
replace dummyml_indiv=1 if dummyml_indiv>1
fre dummyml_indiv
preserve
duplicates drop HHID_panel INDID_panel, force
ta dummyml_indiv
restore



********** Others dummies
ta dummyproblemtorepay
ta dummyhelptosettleloan
ta dummyrecommendation
ta dummyguarantor



********** Individual scale
foreach x in dummyproblemtorepay borrservices_none {
bysort HHID_panel INDID_panel: egen s_`x'=sum(`x')
replace s_`x'=1 if s_`x'>1 & s_`x'!=. & s_`x'!=0
replace s_`x'=. if dummyml_indiv==0
}


*** Keep
keep if dummyml==1
keep if loan_database=="FINANCE"
drop if dummyproblemtorepay==.
sort borrowerservices
keep HHID_panel INDID_panel dummyproblemtorepay borrservices_none s_dummyproblemtorepay s_borrservices_none loanamount2 loanlender lender4 monthlyinterestrate lenderscaste lendersex loanreasongiven loanduration lender_cat

rename loanamount2 loanamount

save"NEEMSIS2_debt.dta", replace
*************************************
* END








*************************************
* To keep
*************************************
use"NEEMSIS2_debt.dta", clear

merge m:1 HHID_panel INDID_panel using "panel_wide_v2"
drop if _merge==1
drop _merge

*** RE
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


*** Charact of the lender
fre lendersex lenderscaste
drop if lenderscaste==.

* Sex
fre lendersex
gen dummyssex=0
replace dummyssex=1 if lendersex==1 & female==0
replace dummyssex=1 if lendersex==2 & female==1

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

fre dummyscaste dummyssex


save"panel_wide_v3", replace
*************************************
* END











log using "C:\Users\Arnaud\Downloads\MLanalysis.log", replace
*************************************
* Debt negociation
*************************************
use"panel_wide_v3", clear

global PTCS base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std

global XLoan loanamount dummyssex dummyscaste

global XIndiv age agesq female maritalstatus2 dummyhead dummyedulevel cat_mainocc_occupation_indiv_1 cat_mainocc_occupation_indiv_2 cat_mainocc_occupation_indiv_4 cat_mainocc_occupation_indiv_5 cat_mainocc_occupation_indiv_6 cat_mainocc_occupation_indiv_7

global XHH dalits HHsize assets1000 incomeHH1000 shock

global XVillages villageid_1 villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 villageid_12 villageid_13 villageid_14 villageid_15 villageid_16 villageid_17

mdesc $PTCS $XLoan $XIndiv $XHH $XVillages

drop if base_lit_tt_std==.

fre borrservices_none

***** LPM
reg borrservices_none $PTCS $XLoan $XIndiv $XHH $XVillages

***** Probit
probit borrservices_none $PTCS $XIndiv $XHH $XVillages
est store PBM



***** Multivel probit
* Step 1: Intercept only model (IOM)
melogit borrservices_none || HHID:  || INDID:
est store IOM
estat icc

* Step 2: Constrained intermerdiate model (CIM)
melogit borrservices_none $PTCS $XIndiv $XHH $XVillages || HHID:  || INDID:
est store CIM
estat icc
melogit borrservices_none $PTCS $XIndiv $XHH $XVillages || HHID:  || INDID:, or
est store CIMor


* Step 3: Augmented intermediate model (AIM)
foreach x in $PTCS $XIndiv {
melogit borrservices_none $PTCS $XIndiv $XHH $XVillages || HHID:  || INDID: `x'
est store AIM_`x'
estat icc
melogit borrservices_none $PTCS $XIndiv $XHH $XVillages || HHID:  || INDID: `x', or
est store AIMor_`x'
}

* Step 4: Compare CIM with AIM
*lrtest 

*************************************
* END
log close







