*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*March 29, 2023
*-----
gl link = "psychodebt"
*Rob5
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------


/*
Rob5:
Cross section evidences
*/







*************************************
* Cross section
*************************************
use"base2016", clear


*** Macro
global PTCS base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std i.female i.dalits

global PTCSma base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std

global XIndiv age dummyhead cat_mainocc_occupation_indiv_1 cat_mainocc_occupation_indiv_2 cat_mainocc_occupation_indiv_4 cat_mainocc_occupation_indiv_5 cat_mainocc_occupation_indiv_6 cat_mainocc_occupation_indiv_7 dummyedulevel maritalstatus2

global XHH assets1000 HHsize incomeHH1000

global Xrest villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 shock

global intfem c.base_f1_std##i.female c.base_f2_std##i.female c.base_f3_std##i.female c.base_f5_std##i.female c.base_raven_tt_std##i.female c.base_num_tt_std##i.female c.base_lit_tt_std##i.female i.dalits

global intdal c.base_f1_std##i.dalits c.base_f2_std##i.dalits c.base_f3_std##i.dalits c.base_f5_std##i.dalits c.base_raven_tt_std##i.dalits c.base_num_tt_std##i.dalits c.base_lit_tt_std##i.dalits i.female

global inttot c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits

********** Recourse
*
qui probit s_indebt2016 $PTCS $XIndiv $XHH $Xrest, cluster(HHID)
margins, dydx($PTCSma) atmeans post
est store marg1
*
qui probit s_indebt $intfem $XIndiv $XHH $Xrest, cluster(HHID)
margins, dydx($PTCSma) at(female=(0 1)) atmeans post
est store marg2
*
qui probit s_indebt $intdal $XIndiv $XHH $Xrest, cluster(HHID)
margins, dydx($PTCSma) at(dalits=(0 1)) atmeans post
est store marg3
*
qui probit s_indebt $inttot $XIndiv $XHH $Xrest, cluster(HHID)
margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg4


esttab marg1 marg2 marg3 marg4 using "Reco_margin_rob5.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace
est clear



********** Negotiation

qui probit s_borrservices_none $PTCS $XIndiv $XHH $Xrest, cluster(HHID)
margins, dydx($PTCSma) atmeans post
est store marg1
*
qui probit s_borrservices_none $intfem $XIndiv $XHH $Xrest, cluster(HHID)
margins, dydx($PTCSma) at(female=(0 1)) atmeans post
est store marg2
*
qui probit s_borrservices_none $intdal $XIndiv $XHH $Xrest, cluster(HHID)
margins, dydx($PTCSma) at(dalits=(0 1)) atmeans post
est store marg3
*
qui probit s_borrservices_none $inttot $XIndiv $XHH $Xrest, cluster(HHID)
margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg4

esttab marg1 marg2 marg3 marg4 using "Nego_margin_rob5.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace
est clear



********** Management
*
qui probit s_dummyproblemtorepay $PTCS $XIndiv $XHH $Xrest, cluster(HHID)
margins, dydx($PTCSma) atmeans post
est store marg1
*
qui probit s_dummyproblemtorepay $intfem $XIndiv $XHH $Xrest, cluster(HHID)
margins, dydx($PTCSma) at(female=(0 1)) atmeans post
est store marg2
*
qui probit s_dummyproblemtorepay $intdal $XIndiv $XHH $Xrest, cluster(HHID)
margins, dydx($PTCSma) at(dalits=(0 1)) atmeans post
est store marg3
*
qui probit s_dummyproblemtorepay $inttot $XIndiv $XHH $Xrest, cluster(HHID)
margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg4

esttab marg1 marg2 marg3 marg4 using "Mana_margin_rob5.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace
est clear

*************************************
* END
