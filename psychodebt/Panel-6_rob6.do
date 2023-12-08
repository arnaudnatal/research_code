*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*March 29, 2023
*-----
gl link = "psychodebt"
*Rob6
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------




/*
Rob6:
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
probit borrservices_none indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest $contloan, cluster(INDID)
est store pr0a
xtreg borrservices_none indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest $contloan, fe
est store pr0b


probit borrservices_none indebt_indiv $PTCS $XIndiv $XHH $Xrest $contloan, cluster(INDID)
est store pr1a
margins, dydx($PTCSma) atmeans post
est store marg1a
xtreg borrservices_none indebt_indiv $PTCS $XIndiv $XHH $Xrest $contloan, fe
est store pr1b
margins, dydx($PTCSma) atmeans post
est store marg1b


probit borrservices_none indebt_indiv $intfem $XIndiv $XHH $Xrest $contloan, cluster(INDID)
est store pr2a
margins, dydx($PTCSma) at(female=(0 1)) atmeans post
est store marg2a
xtreg borrservices_none indebt_indiv $intfem $XIndiv $XHH $Xrest $contloan, fe
est store pr2b
margins, dydx($PTCSma) at(female=(0 1)) atmeans post
est store marg2b


probit borrservices_none indebt_indiv $intdal $XIndiv $XHH $Xrest $contloan, cluster(INDID)
est store pr3a
margins, dydx($PTCSma) at(dalits=(0 1)) atmeans post
est store marg3a
xtreg borrservices_none indebt_indiv $intdal $XIndiv $XHH $Xrest $contloan, fe
est store pr3b
margins, dydx($PTCSma) at(dalits=(0 1)) atmeans post
est store marg3b


probit borrservices_none indebt_indiv $inttot $XIndiv $XHH $Xrest $contloan, cluster(INDID)
est store pr4a
margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) post
est store marg4a
xtreg borrservices_none indebt_indiv $inttot $XIndiv $XHH $Xrest $contloan, fe
est store pr4b
margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) post
est store marg4b


********** Format

esttab pr0a pr0b pr1a pr1b pr2a pr2b pr3a pr3b pr4a pr4b using "Nego_rob6.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($Xrest _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 2 2 2 2) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\chi^2$"' `"p-value"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1a marg2a marg3a marg4a using "Nego_margin_rob6a.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace
	
esttab marg1b marg2b marg3b marg4b using "Nego_margin_rob6b.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	

est clear
*************************************
* END




global inttot c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits

global XIndiv age dummyhead cat_mainocc_occupation_indiv_1 cat_mainocc_occupation_indiv_2 cat_mainocc_occupation_indiv_4 cat_mainocc_occupation_indiv_5 cat_mainocc_occupation_indiv_6 cat_mainocc_occupation_indiv_7 dummyedulevel maritalstatus2

global XHH assets1000 HHsize incomeHH1000

global Xrest villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 shock

global contloan i.lender4 i.reason_cat c.loanamount i.dummyguarantee


*xtreg  indebt_indiv $inttot $XIndiv $XHH $Xrest $contloan, fe


*borrservices_none

*imp1_interest_service


reg imp1_interest_service $inttot $XIndiv $XHH $Xrest $contloan, robust
predict y1_hat
ivreg2 borrservices_none $inttot $XIndiv $XHH $Xrest $contloan (imp1_interest_service = y1_hat), robust first endog(imp1_interest_service)
drop y1_hat
margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) post













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

probit dummyproblemtorepay indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest $contloan, cluster(INDID)
est store pr0a
xtreg dummyproblemtorepay indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest $contloan, fe
est store pr0b


probit dummyproblemtorepay indebt_indiv $PTCS $XIndiv $XHH $Xrest $contloan, cluster(INDID)
est store pr1a
margins, dydx($PTCSma) atmeans post
est store marg1a
xtreg dummyproblemtorepay indebt_indiv $PTCS $XIndiv $XHH $Xrest $contloan, fe 
est store pr1b
margins, dydx($PTCSma) atmeans post
est store marg1b


probit dummyproblemtorepay indebt_indiv $intfem $XIndiv $XHH $Xrest $contloan, cluster(INDID)
est store pr2a
margins, dydx($PTCSma) at(female=(0 1)) atmeans post
est store marg2a
xtreg dummyproblemtorepay indebt_indiv $intfem $XIndiv $XHH $Xrest $contloan, fe
est store pr2b
margins, dydx($PTCSma) at(female=(0 1)) atmeans post
est store marg2b


probit dummyproblemtorepay indebt_indiv $intdal $XIndiv $XHH $Xrest $contloan, cluster(INDID)
est store pr3a
margins, dydx($PTCSma) at(dalits=(0 1)) atmeans post
est store marg3a
xtreg dummyproblemtorepay indebt_indiv $intdal $XIndiv $XHH $Xrest $contloan, fe
est store pr3b
margins, dydx($PTCSma) at(dalits=(0 1)) atmeans post
est store marg3b


probit dummyproblemtorepay indebt_indiv $inttot $XIndiv $XHH $Xrest $contloan, cluster(INDID)
est store pr4a
margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg4a
xtreg dummyproblemtorepay indebt_indiv $inttot $XIndiv $XHH $Xrest $contloan, fe
est store pr4b
margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg4b



********** Format
esttab pr0a pr0b pr1a pr1b pr2a pr2b pr3a pr3b pr4a pr4b using "Mana_rob6.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($Xrest _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 2 2 2 2) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\chi^2$"' `"p-value"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	

esttab marg1a marg2a marg3a marg4a using "Mana_margin_rob6a.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		

esttab marg1b marg2b marg3b marg4b using "Mana_margin_rob6b.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	

est clear	
*************************************
* END
