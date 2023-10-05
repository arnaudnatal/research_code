*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*March 29, 2023
*-----
gl link = "psychodebt"
*Rob4
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------




/*
Rob4:
Loan level with Indiv FE (instead of Indiv cluster)
*/








cls
*************************************
* Negotiation
*************************************
use"base_loanlevel_lag", clear

*** panel dimension
bysort INDID: gen loanid=_n
egen uniqueloanid=concat(INDID loanid)
destring uniqueloanid, replace
xtset INDID uniqueloanid


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
reg borrservices_none indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest $contloan i.INDID
est store pr0

reg borrservices_none indebt_indiv $PTCS $XIndiv $XHH $Xrest $contloan i.INDID
est store pr1
margins, dydx($PTCSma) atmeans post
est store marg1

reg borrservices_none indebt_indiv $intfem $XIndiv $XHH $Xrest $contloan i.INDID
est store pr2
margins, dydx($PTCSma) at(female=(0 1)) atmeans post
est store marg2

reg borrservices_none indebt_indiv $intdal $XIndiv $XHH $Xrest $contloan i.INDID
est store pr3
margins, dydx($PTCSma) at(dalits=(0 1)) atmeans post
est store marg3

reg borrservices_none indebt_indiv $inttot $XIndiv $XHH $Xrest $contloan i.INDID
est store pr4
margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) post
est store marg4


********** Robustness
reg borrservices_none indebt_indiv $inttot $XIndiv $XHH $Xrest $contloan $suppcont i.INDID
est store pr5
margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg5



********** Overfit

*overfit: reg borrservices_none indebt_indiv $inttot $XIndiv $XHH $Xrest $contloan i.INDID 



********** Format

esttab pr0 pr1 pr2 pr3 pr4 using "Nego_rob3.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($Xrest _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 2 2 2 2) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\chi^2$"' `"p-value"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "Nego_margin_rob3.csv", ///
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
use"base_loanlevel_lag", clear

*** panel dimension
bysort INDID: gen loanid=_n
egen uniqueloanid=concat(INDID loanid)
destring uniqueloanid, replace
xtset INDID uniqueloanid



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

xtreg dummyproblemtorepay indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest $contloan, fe
est store pr0

xtreg dummyproblemtorepay indebt_indiv $PTCS $XIndiv $XHH $Xrest $contloan, fe 
est store pr1
margins, dydx($PTCSma) atmeans post
est store marg1

xtreg dummyproblemtorepay indebt_indiv $intfem $XIndiv $XHH $Xrest $contloan, fe
est store pr2
margins, dydx($PTCSma) at(female=(0 1)) atmeans post
est store marg2

xtreg dummyproblemtorepay indebt_indiv $intdal $XIndiv $XHH $Xrest $contloan, fe
est store pr3
margins, dydx($PTCSma) at(dalits=(0 1)) atmeans post
est store marg3

xtreg dummyproblemtorepay indebt_indiv $inttot $XIndiv $XHH $Xrest $contloan, fe
est store pr4
margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg4


********** Robustness

xtreg dummyproblemtorepay indebt_indiv $inttot $XIndiv $XHH $Xrest $contloan $suppcont, fe
est store pr5
margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg5




********** Overfit
*overfit: reg dummyproblemtorepay indebt_indiv $inttot $XIndiv $XHH $Xrest $contloan, cluster(HHID) baselevel


********** Format
esttab pr0 pr1 pr2 pr3 pr4 using "Mana_rob3.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($Xrest _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 2 2 2 2) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\chi^2$"' `"p-value"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	

esttab marg1 marg2 marg3 marg4 using "Mana_margin_rob3.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		


est clear	
*************************************
* END
