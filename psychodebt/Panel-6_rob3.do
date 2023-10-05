*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*March 29, 2023
*-----
gl link = "psychodebt"
*Rob3
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------


/*
Rob3:
Indiv level with HH FE (instead of HH cluster)
*/










*************************************
* Recourse
*************************************
use"base_panel_lag", clear


*** Macro
global PTCS base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std i.female i.dalits

global PTCSma base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std

global XIndiv age dummyhead cat_mainocc_occupation_indiv_1 cat_mainocc_occupation_indiv_2 cat_mainocc_occupation_indiv_4 cat_mainocc_occupation_indiv_5 cat_mainocc_occupation_indiv_6 cat_mainocc_occupation_indiv_7 dummyedulevel maritalstatus2

global XHH assets1000 HHsize incomeHH1000

global Xrest villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 shock

global intfem c.base_f1_std##i.female c.base_f2_std##i.female c.base_f3_std##i.female c.base_f5_std##i.female c.base_raven_tt_std##i.female c.base_num_tt_std##i.female c.base_lit_tt_std##i.female i.dalits

global intdal c.base_f1_std##i.dalits c.base_f2_std##i.dalits c.base_f3_std##i.dalits c.base_f5_std##i.dalits c.base_raven_tt_std##i.dalits c.base_num_tt_std##i.dalits c.base_lit_tt_std##i.dalits i.female

global inttot c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits



**********
qui probit s_indebt2020 indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest, cluster(HHID)
est store pr0a
qui reg s_indebt2020 indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest i.HHID
est store pr0b


qui probit s_indebt2020 indebt_indiv $PTCS $XIndiv $XHH $Xrest, cluster(HHID) 
est store pr1a
qui margins, dydx($PTCSma) atmeans post
est store marg1a
qui reg s_indebt2020 indebt_indiv $PTCS $XIndiv $XHH $Xrest i.HHID 
est store pr1b
qui margins, dydx($PTCSma) atmeans post
est store marg1b


qui probit s_indebt2020 indebt_indiv $intfem $XIndiv $XHH $Xrest, cluster(HHID) 
est store pr2a
qui margins, dydx($PTCSma) at(female=(0 1)) atmeans post
est store marg2a
qui reg s_indebt2020 indebt_indiv $intfem $XIndiv $XHH $Xrest i.HHID 
est store pr2b
qui margins, dydx($PTCSma) at(female=(0 1)) atmeans post
est store marg2b


qui probit s_indebt2020 indebt_indiv $intdal $XIndiv $XHH $Xrest, cluster(HHID) 
est store pr3a
qui margins, dydx($PTCSma) at(dalits=(0 1)) atmeans post
est store marg3a
qui reg s_indebt2020 indebt_indiv $intdal $XIndiv $XHH $Xrest i.HHID 
est store pr3b
qui margins, dydx($PTCSma) at(dalits=(0 1)) atmeans post
est store marg3b


qui probit s_indebt2020 indebt_indiv $inttot $XIndiv $XHH $Xrest, cluster(HHID) 
est store pr4a
qui margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg4a
qui reg s_indebt2020 indebt_indiv $inttot $XIndiv $XHH $Xrest i.HHID 
est store pr4b
qui margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg4b


esttab pr0a pr0b pr1a pr1b pr2a pr2b pr3a pr3b pr4a pr4b using "Reco_rob3.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop(*.HHID _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 2 2 2 2) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\chi^2$"' `"p-value"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1a marg2a marg3a marg4a using "Reco_margin_rob3a.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace
	
esttab marg1b marg2b marg3b marg4b using "Reco_margin_rob3b.csv", ///
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
use"base_panel_lag", clear


*** Macro
global PTCS base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std i.female i.dalits

global PTCSma base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std

global XIndiv age dummyhead cat_mainocc_occupation_indiv_1 cat_mainocc_occupation_indiv_2 cat_mainocc_occupation_indiv_4 cat_mainocc_occupation_indiv_5 cat_mainocc_occupation_indiv_6 cat_mainocc_occupation_indiv_7 dummyedulevel maritalstatus2

global XHH assets1000 HHsize incomeHH1000

global Xrest villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 shock

global intfem c.base_f1_std##i.female c.base_f2_std##i.female c.base_f3_std##i.female c.base_f5_std##i.female c.base_raven_tt_std##i.female c.base_num_tt_std##i.female c.base_lit_tt_std##i.female i.dalits

global intdal c.base_f1_std##i.dalits c.base_f2_std##i.dalits c.base_f3_std##i.dalits c.base_f5_std##i.dalits c.base_raven_tt_std##i.dalits c.base_num_tt_std##i.dalits c.base_lit_tt_std##i.dalits i.female

global inttot c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits


**********

qui probit s_borrservices_none2020 indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest, cluster(HHID)
est store pr0a
qui reg s_borrservices_none2020 indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest i.HHID
est store pr0b


qui probit s_borrservices_none2020 indebt_indiv $PTCS $XIndiv $XHH $Xrest, cluster(HHID) 
est store pr1a
qui margins, dydx($PTCSma) atmeans post
est store marg1a
qui reg s_borrservices_none2020 indebt_indiv $PTCS $XIndiv $XHH $Xrest i.HHID 
est store pr1b
qui margins, dydx($PTCSma) atmeans post
est store marg1b


qui probit s_borrservices_none2020 indebt_indiv $intfem $XIndiv $XHH $Xrest, cluster(HHID) 
est store pr2a
qui margins, dydx($PTCSma) at(female=(0 1)) atmeans post
est store marg2a
qui reg s_borrservices_none2020 indebt_indiv $intfem $XIndiv $XHH $Xrest i.HHID 
est store pr2b
qui margins, dydx($PTCSma) at(female=(0 1)) atmeans post
est store marg2b


qui probit s_borrservices_none2020 indebt_indiv $intdal $XIndiv $XHH $Xrest, cluster(HHID) 
est store pr3a
qui margins, dydx($PTCSma) at(dalits=(0 1)) atmeans post
est store marg3a
qui reg s_borrservices_none2020 indebt_indiv $intdal $XIndiv $XHH $Xrest i.HHID
est store pr3b
qui margins, dydx($PTCSma) at(dalits=(0 1)) atmeans post
est store marg3b


qui probit s_borrservices_none2020 indebt_indiv $inttot $XIndiv $XHH $Xrest, cluster(HHID) 
est store pr4a
qui margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg4a
qui reg s_borrservices_none2020 indebt_indiv $inttot $XIndiv $XHH $Xrest i.HHID 
est store pr4b
qui margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg4b


esttab pr0a pr0b pr1a pr1b pr2a pr2b pr3a pr3b pr4a pr4b using "Nego_rob3.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop(*.HHID _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 2 2 2 2) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\chi^2$"' `"p-value"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1a marg2a marg3a marg4a using "Nego_margin_rob3a.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace
	
esttab marg1b marg2b marg3b marg4b using "Nego_margin_rob3b.csv", ///
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
use"base_panel_lag", clear


*** Macro
global PTCS base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std i.female i.dalits

global PTCSma base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std

global XIndiv age dummyhead cat_mainocc_occupation_indiv_1 cat_mainocc_occupation_indiv_2 cat_mainocc_occupation_indiv_4 cat_mainocc_occupation_indiv_5 cat_mainocc_occupation_indiv_6 cat_mainocc_occupation_indiv_7 dummyedulevel maritalstatus2

global XHH assets1000 HHsize incomeHH1000

global Xrest villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 shock

global intfem c.base_f1_std##i.female c.base_f2_std##i.female c.base_f3_std##i.female c.base_f5_std##i.female c.base_raven_tt_std##i.female c.base_num_tt_std##i.female c.base_lit_tt_std##i.female i.dalits

global intdal c.base_f1_std##i.dalits c.base_f2_std##i.dalits c.base_f3_std##i.dalits c.base_f5_std##i.dalits c.base_raven_tt_std##i.dalits c.base_num_tt_std##i.dalits c.base_lit_tt_std##i.dalits i.female

global inttot c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits


**********

qui probit s_dummyproblemtorepay2020 indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest, cluster(HHID)
est store pr0a
qui reg s_dummyproblemtorepay2020 indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest i.HHID
est store pr0b


qui probit s_dummyproblemtorepay2020 indebt_indiv $PTCS $XIndiv $XHH $Xrest, cluster(HHID) 
est store pr1a
qui margins, dydx($PTCSma) atmeans post
est store marg1a
qui reg s_dummyproblemtorepay2020 indebt_indiv $PTCS $XIndiv $XHH $Xrest i.HHID 
est store pr1b
qui margins, dydx($PTCSma) atmeans post
est store marg1b


qui probit s_dummyproblemtorepay2020 indebt_indiv $intfem $XIndiv $XHH $Xrest, cluster(HHID) 
est store pr2a
qui margins, dydx($PTCSma) at(female=(0 1)) atmeans post
est store marg2a
qui reg s_dummyproblemtorepay2020 indebt_indiv $intfem $XIndiv $XHH $Xrest i.HHID 
est store pr2b
qui margins, dydx($PTCSma) at(female=(0 1)) atmeans post
est store marg2b


qui probit s_dummyproblemtorepay2020 indebt_indiv $intdal $XIndiv $XHH $Xrest, cluster(HHID) 
est store pr3a
qui margins, dydx($PTCSma) at(dalits=(0 1)) atmeans post
est store marg3a
qui reg s_dummyproblemtorepay2020 indebt_indiv $intdal $XIndiv $XHH $Xrest i.HHID 
est store pr3b
qui margins, dydx($PTCSma) at(dalits=(0 1)) atmeans post
est store marg3b

qui probit s_dummyproblemtorepay2020 indebt_indiv $inttot $XIndiv $XHH $Xrest, cluster(HHID) 
est store pr4a
qui margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg4a
qui reg s_dummyproblemtorepay2020 indebt_indiv $inttot $XIndiv $XHH $Xrest i.HHID 
est store pr4b
qui margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg4b


esttab pr0a pr0b pr1a pr1b pr2a pr2b pr3a pr3b pr4a pr4b using "Mana_rob3.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop(*.HHID _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 2 2 2 2) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\chi^2$"' `"p-value"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1a marg2a marg3a marg4a using "Mana_margin_rob3a.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	

esttab marg1b marg2b marg3b marg4b using "Mana_margin_rob3b.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace

est clear	
*************************************
* END
