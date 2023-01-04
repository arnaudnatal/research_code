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

* Amount
bysort HHID2020 INDID2020: egen s_loanamount=sum(loanamount)

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
* Macro
*************************************
use"panel_wide_v3", clear

label var female "Female"
label var dalits "Dalits"

*** Macro
global PTCS base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std i.female i.dalits

global PTCSma base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std

global XIndiv age dummyhead cat_mainocc_occupation_indiv_1 cat_mainocc_occupation_indiv_2 cat_mainocc_occupation_indiv_4 cat_mainocc_occupation_indiv_5 cat_mainocc_occupation_indiv_6 cat_mainocc_occupation_indiv_7 dummyedulevel maritalstatus2

global XHH assets1000 HHsize incomeHH1000

global Xrest villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 shock covsellgoods_none

global intfem c.base_f1_std##i.female c.base_f2_std##i.female c.base_f3_std##i.female c.base_f5_std##i.female c.base_raven_tt_std##i.female c.base_num_tt_std##i.female c.base_lit_tt_std##i.female i.dalits

global intdal c.base_f1_std##i.dalits c.base_f2_std##i.dalits c.base_f3_std##i.dalits c.base_f5_std##i.dalits c.base_raven_tt_std##i.dalits c.base_num_tt_std##i.dalits c.base_lit_tt_std##i.dalits i.female

global inttot c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits

*************************************
* END




*************************************
* Recourse
*************************************

probit s_indebt2020 indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest, cluster(HHID)
est store pr0

probit s_indebt2020 indebt_indiv $PTCS $XIndiv $XHH $Xrest, cluster(HHID) 
est store pr1
qui margins, dydx($PTCSma) atmeans post
est store marg1

probit s_indebt2020 indebt_indiv $intfem $XIndiv $XHH $Xrest, cluster(HHID) 
est store pr2
qui margins, dydx($PTCSma) at(female=(0 1)) atmeans post
est store marg2

qui probit s_indebt2020 indebt_indiv $intdal $XIndiv $XHH $Xrest, cluster(HHID) 
est store pr3
qui margins, dydx($PTCSma) at(dalits=(0 1)) atmeans post
est store marg3

qui probit s_indebt2020 indebt_indiv $inttot $XIndiv $XHH $Xrest, cluster(HHID) 
est store pr4
qui margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg4

esttab pr0 pr1 pr2 pr3 pr4 using "Reco.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($Xrest _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 2 2 2 2) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\upchi^2$"' `"p-value"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "Reco_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		
	
est clear
*************************************
* END















*************************************
* Negotiation
*************************************

qui probit s_borrservices_none2020 indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest sharesex sharecaste, cluster(HHID)
est store pr0

qui probit s_borrservices_none2020 indebt_indiv $PTCS $XIndiv $XHH $Xrest sharesex sharecaste, cluster(HHID) 
est store pr1
qui margins, dydx($PTCSma) atmeans post
est store marg1


qui probit s_borrservices_none2020 indebt_indiv $intfem $XIndiv $XHH $Xrest sharesex sharecaste, cluster(HHID) 
est store pr2
qui margins, dydx($PTCSma) at(female=(0 1)) atmeans post
est store marg2

qui probit s_borrservices_none2020 indebt_indiv $intdal $XIndiv $XHH $Xrest sharesex sharecaste, cluster(HHID) 
est store pr3
qui margins, dydx($PTCSma) at(dalits=(0 1)) atmeans post
est store marg3

qui probit s_borrservices_none2020 indebt_indiv $inttot $XIndiv $XHH $Xrest sharesex sharecaste, cluster(HHID) 
est store pr4
qui margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg4

esttab pr0 pr1 pr2 pr3 pr4 using "Nego.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($Xrest sharesex sharecaste _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 2 2 2 2) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\upchi^2$"' `"p-value"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "Nego_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		
	

est clear
*************************************
* END









*************************************
* Management
*************************************

qui probit s_dummyproblemtorepay2020 indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest, cluster(HHID)
est store pr0

qui probit s_dummyproblemtorepay2020 indebt_indiv $PTCS $XIndiv $XHH $Xrest, cluster(HHID) 
est store pr1
qui margins, dydx($PTCSma) atmeans post
est store marg1

qui probit s_dummyproblemtorepay2020 indebt_indiv $intfem $XIndiv $XHH $Xrest, cluster(HHID) 
est store pr2
qui margins, dydx($PTCSma) at(female=(0 1)) atmeans post
est store marg2

qui probit s_dummyproblemtorepay2020 indebt_indiv $intdal $XIndiv $XHH $Xrest, cluster(HHID) 
est store pr3
qui margins, dydx($PTCSma) at(dalits=(0 1)) atmeans post
est store marg3

qui probit s_dummyproblemtorepay2020 indebt_indiv $inttot $XIndiv $XHH $Xrest, cluster(HHID) 
est store pr4
qui margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg4

esttab pr0 pr1 pr2 pr3 pr4 using "Mana.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($Xrest _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 2 2 2 2) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\upchi^2$"' `"p-value"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	

esttab marg1 marg2 marg3 marg4 using "Mana_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		


est clear	
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

*/






*************************************
* Recourse
*************************************

overfit: probit s_indebt2020 indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest, cluster(HHID)

overfit: probit s_indebt2020 indebt_indiv $PTCS $XIndiv $XHH $Xrest, cluster(HHID) 

overfit: probit s_indebt2020 indebt_indiv $intfem $XIndiv $XHH $Xrest, cluster(HHID) 

overfit: probit s_indebt2020 indebt_indiv $intdal $XIndiv $XHH $Xrest, cluster(HHID) 

overfit: probit s_indebt2020 indebt_indiv $inttot $XIndiv $XHH $Xrest, cluster(HHID) 

*************************************
* END















*************************************
* Negotiation
*************************************

overfit: probit s_borrservices_none2020 indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest sharesex sharecaste, cluster(HHID)

overfit: probit s_borrservices_none2020 indebt_indiv $PTCS $XIndiv $XHH $Xrest sharesex sharecaste, cluster(HHID) 

overfit: probit s_borrservices_none2020 indebt_indiv $intfem $XIndiv $XHH $Xrest sharesex sharecaste, cluster(HHID) 

overfit: probit s_borrservices_none2020 indebt_indiv $intdal $XIndiv $XHH $Xrest sharesex sharecaste, cluster(HHID) 

overfit: probit s_borrservices_none2020 indebt_indiv $inttot $XIndiv $XHH $Xrest sharesex sharecaste, cluster(HHID) 

*************************************
* END









*************************************
* Management
*************************************

overfit: probit s_dummyproblemtorepay2020 indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest, cluster(HHID)

overfit: probit s_dummyproblemtorepay2020 indebt_indiv $PTCS $XIndiv $XHH $Xrest, cluster(HHID) 

overfit: probit s_dummyproblemtorepay2020 indebt_indiv $intfem $XIndiv $XHH $Xrest, cluster(HHID) 

overfit: probit s_dummyproblemtorepay2020 indebt_indiv $intdal $XIndiv $XHH $Xrest, cluster(HHID) 

overfit: probit s_dummyproblemtorepay2020 indebt_indiv $inttot $XIndiv $XHH $Xrest, cluster(HHID) 
*************************************
* END
