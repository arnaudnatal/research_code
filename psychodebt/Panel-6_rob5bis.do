*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*March 29, 2023
*-----
gl link = "psychodebt"
*Rob 1
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------




/*
Rob5:
Loan level
*/



****************************************
* Loan level
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


*** Merge with 2016-17
merge m:1 HHID_panel INDID_panel using "panel_wide_v2"


*** Second selection
ta loan_database
ta dummyml
keep if dummyml==1
drop dummyml
ta _merge
keep if _merge==3
drop _merge


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


* Combien d'indiv diff ?
duplicates report INDID
dis (280/2)+(684/3)  // 368 individuals with at least 2 loans
dis 280+684  // 964 prêts


save"panel_loanlevel_rob5", replace
*************************************
* END












cls
*************************************
* Negotiation
*************************************
use"panel_loanlevel_rob5", clear


*** Macro
global PTCS base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std i.female i.dalits

global PTCSma base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std

global XIndiv age dummyhead cat_mainocc_occupation_indiv_1 cat_mainocc_occupation_indiv_2 cat_mainocc_occupation_indiv_4 cat_mainocc_occupation_indiv_5 cat_mainocc_occupation_indiv_6 cat_mainocc_occupation_indiv_7 dummyedulevel maritalstatus2

global XHH assets1000 HHsize incomeHH1000

global Xrest villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 shock

global intfem c.base_f1_std##i.female c.base_f2_std##i.female c.base_f3_std##i.female c.base_f5_std##i.female c.base_raven_tt_std##i.female c.base_num_tt_std##i.female c.base_lit_tt_std##i.female i.dalits

global intdal c.base_f1_std##i.dalits c.base_f2_std##i.dalits c.base_f3_std##i.dalits c.base_f5_std##i.dalits c.base_raven_tt_std##i.dalits c.base_num_tt_std##i.dalits c.base_lit_tt_std##i.dalits i.female

global inttot c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits

global contloan i.lender4 c.imp1_interest_service i.reason_cat c.loanamount i.dummyguarantee
* i.lenderscaste i.lendersex i.termsofrepayment

global suppcont i.dummyssex i.dummyscaste i.dummysell




********** Analysis

qui probit borrservices_none indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest $contloan, cluster(INDID)
est store pr0

qui probit borrservices_none indebt_indiv $PTCS $XIndiv $XHH $Xrest $contloan, cluster(INDID) 
est store pr1
qui margins, dydx($PTCSma) atmeans post
est store marg1

qui probit borrservices_none indebt_indiv $intfem $XIndiv $XHH $Xrest $contloan, cluster(INDID) 
est store pr2
qui margins, dydx($PTCSma) at(female=(0 1)) atmeans post
est store marg2

qui probit borrservices_none indebt_indiv $intdal $XIndiv $XHH $Xrest $contloan, cluster(INDID) 
est store pr3
qui margins, dydx($PTCSma) at(dalits=(0 1)) atmeans post
est store marg3

qui probit borrservices_none indebt_indiv $inttot $XIndiv $XHH $Xrest $contloan, cluster(INDID) 
est store pr4
qui margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg4


********** Robustness
qui probit borrservices_none indebt_indiv $inttot $XIndiv $XHH $Xrest $contloan $suppcont, cluster(INDID) 
est store pr5
margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg5



********** Overfit

*overfit: probit borrservices_none indebt_indiv $inttot $XIndiv $XHH $Xrest $contloan, cluster(INDID) 



********** Format

esttab pr0 pr1 pr2 pr3 pr4 using "Nego_rob5.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($Xrest _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 2 2 2 2) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\chi^2$"' `"p-value"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "Nego_margin_rob5.csv", ///
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
use"panel_loanlevel_rob5", clear


*** Macro
global PTCS base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std i.female i.dalits

global PTCSma base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std

global XIndiv age dummyhead cat_mainocc_occupation_indiv_1 cat_mainocc_occupation_indiv_2 cat_mainocc_occupation_indiv_4 cat_mainocc_occupation_indiv_5 cat_mainocc_occupation_indiv_6 cat_mainocc_occupation_indiv_7 dummyedulevel maritalstatus2

global XHH assets1000 HHsize incomeHH1000

global Xrest villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 shock

global intfem c.base_f1_std##i.female c.base_f2_std##i.female c.base_f3_std##i.female c.base_f5_std##i.female c.base_raven_tt_std##i.female c.base_num_tt_std##i.female c.base_lit_tt_std##i.female i.dalits

global intdal c.base_f1_std##i.dalits c.base_f2_std##i.dalits c.base_f3_std##i.dalits c.base_f5_std##i.dalits c.base_raven_tt_std##i.dalits c.base_num_tt_std##i.dalits c.base_lit_tt_std##i.dalits i.female

global inttot c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits

global contloan i.lender4 c.imp1_interest_service i.reason_cat c.loanamount i.dummyguarantee
* i.lenderscaste i.lendersex i.termsofrepayment

global suppcont i.dummyssex i.dummyscaste i.dummysell


********** Analysis

qui probit dummyproblemtorepay indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest $contloan, cluster(HHID)
est store pr0

qui probit dummyproblemtorepay indebt_indiv $PTCS $XIndiv $XHH $Xrest $contloan, cluster(HHID) 
est store pr1
qui margins, dydx($PTCSma) atmeans post
est store marg1

qui probit dummyproblemtorepay indebt_indiv $intfem $XIndiv $XHH $Xrest $contloan, cluster(HHID) 
est store pr2
qui margins, dydx($PTCSma) at(female=(0 1)) atmeans post
est store marg2

qui probit dummyproblemtorepay indebt_indiv $intdal $XIndiv $XHH $Xrest $contloan, cluster(HHID) 
est store pr3
qui margins, dydx($PTCSma) at(dalits=(0 1)) atmeans post
est store marg3

qui probit dummyproblemtorepay indebt_indiv $inttot $XIndiv $XHH $Xrest $contloan, cluster(HHID) baselevel
est store pr4
qui margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg4


********** Robustness

qui probit dummyproblemtorepay indebt_indiv $inttot $XIndiv $XHH $Xrest $contloan $suppcont, cluster(HHID) baselevel
est store pr5
margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg5




********** Overfit
*overfit: probit dummyproblemtorepay indebt_indiv $inttot $XIndiv $XHH $Xrest $contloan, cluster(HHID) baselevel


********** Format
esttab pr0 pr1 pr2 pr3 pr4 using "Mana_rob5.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($Xrest _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 2 2 2 2) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\chi^2$"' `"p-value"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	

esttab marg1 marg2 marg3 marg4 using "Mana_margin_rob5.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		


est clear	
*************************************
* END
