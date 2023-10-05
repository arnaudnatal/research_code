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
True panel model with indiv FE
*/










*************************************
* All Y with EFA
*************************************
use"base_panel", clear


*** Panel
xtset INDID year


*** Macro
global PTCS base_f1 base_raven_tt base_num_tt base_lit_tt i.female i.dalits

global PTCSma base_f1 base_raven_tt base_num_tt base_lit_tt

global XIndiv age dummyhead cat_mainocc_occupation_indiv_1 cat_mainocc_occupation_indiv_2 cat_mainocc_occupation_indiv_4 cat_mainocc_occupation_indiv_5 cat_mainocc_occupation_indiv_6 cat_mainocc_occupation_indiv_7 dummyedulevel maritalstatus2

global XHH assets1000 HHsize incomeHH1000

global Xrest villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 shock

global intfem c.base_f1##i.female c.base_raven_tt##i.female c.base_num_tt##i.female c.base_lit_tt##i.female i.dalits

global intdal c.base_f1##i.dalits c.base_raven_tt##i.dalits c.base_num_tt##i.dalits c.base_lit_tt##i.dalits i.female

global inttot c.base_f1##i.female##i.dalits c.base_raven_tt##i.female##i.dalits c.base_num_tt##i.female##i.dalits c.base_lit_tt##i.female##i.dalits



********** Recourse
* No PTCS
qui reg s_indebt i.female i.dalits $XIndiv $XHH $Xrest
est store pr0a
qui xtreg s_indebt i.female i.dalits $XIndiv $XHH $Xrest, fe
est store pr0b

* PTCS
qui reg s_indebt $PTCS $XIndiv $XHH $Xrest
est store pr1a
qui xtreg s_indebt $PTCS $XIndiv $XHH $Xrest, fe
est store pr1b

* Int female
qui reg `x' $intfem $XIndiv $XHH $Xrest
est store pr2a
qui xtreg `x' $intfem $XIndiv $XHH $Xrest, fe
est store pr2b

* Int Dalits
qui reg s_indebt $intdal $XIndiv $XHH $Xrest
est store pr3a
qui xtreg s_indebt $intdal $XIndiv $XHH $Xrest, fe
est store pr3b

* Int female Dalits
qui reg s_indebt $inttot $XIndiv $XHH $Xrest
est store pr4a
qui xtreg s_indebt $inttot $XIndiv $XHH $Xrest, fe
est store pr4b

*
esttab pr0a pr0b pr1a pr1b pr2a pr2b pr3a pr3b pr4a pr4b using "Reco_rob5a.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
est clear


********** Negotiation
* No PTCS
qui reg s_borrservices_none i.female i.dalits $XIndiv $XHH $Xrest
est store pr0a
qui xtreg s_borrservices_none i.female i.dalits $XIndiv $XHH $Xrest, fe
est store pr0b

* PTCS
qui reg s_borrservices_none $PTCS $XIndiv $XHH $Xrest
est store pr1a
qui xtreg s_borrservices_none $PTCS $XIndiv $XHH $Xrest, fe
est store pr1b

* Int female
qui reg s_borrservices_none $intfem $XIndiv $XHH $Xrest
est store pr2a
qui xtreg s_borrservices_none $intfem $XIndiv $XHH $Xrest, fe
est store pr2b

* Int Dalits
qui reg s_borrservices_none $intdal $XIndiv $XHH $Xrest
est store pr3a
qui xtreg s_borrservices_none $intdal $XIndiv $XHH $Xrest, fe
est store pr3b

* Int female Dalits
qui reg s_borrservices_none $inttot $XIndiv $XHH $Xrest
est store pr4a
qui xtreg s_borrservices_none $inttot $XIndiv $XHH $Xrest, fe
est store pr4b

*
esttab pr0a pr0b pr1a pr1b pr2a pr2b pr3a pr3b pr4a pr4b using "Nego_rob5a.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		
est clear


********** Management
* No PTCS
qui reg s_dummyproblemtorepay i.female i.dalits $XIndiv $XHH $Xrest
est store pr0a
qui xtreg s_dummyproblemtorepay i.female i.dalits $XIndiv $XHH $Xrest, fe
est store pr0b

* PTCS
qui reg s_dummyproblemtorepay $PTCS $XIndiv $XHH $Xrest
est store pr1a
qui xtreg s_dummyproblemtorepay $PTCS $XIndiv $XHH $Xrest, fe
est store pr1b

* Int female
qui reg s_dummyproblemtorepay $intfem $XIndiv $XHH $Xrest
est store pr2a
qui xtreg s_dummyproblemtorepay $intfem $XIndiv $XHH $Xrest, fe
est store pr2b

* Int Dalits
qui reg s_dummyproblemtorepay $intdal $XIndiv $XHH $Xrest
est store pr3a
qui xtreg s_dummyproblemtorepay $intdal $XIndiv $XHH $Xrest, fe
est store pr3b

* Int female Dalits
qui reg s_dummyproblemtorepay $inttot $XIndiv $XHH $Xrest
est store pr4a
qui xtreg s_dummyproblemtorepay $inttot $XIndiv $XHH $Xrest, fe
est store pr4b


esttab pr0a pr0b pr1a pr1b pr2a pr2b pr3a pr3b pr4a pr4b using "Mana_rob5a.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
est clear

*************************************
* END













*************************************
* All Y with mean
*************************************
use"base_panel", clear


*** Panel
xtset INDID year



*** Macro
global PTCS OP CO EX ES AG base_raven_tt base_num_tt base_lit_tt i.female i.dalits

global PTCSma OP CO EX ES AG base_raven_tt base_num_tt base_lit_tt

global XIndiv age dummyhead cat_mainocc_occupation_indiv_1 cat_mainocc_occupation_indiv_2 cat_mainocc_occupation_indiv_4 cat_mainocc_occupation_indiv_5 cat_mainocc_occupation_indiv_6 cat_mainocc_occupation_indiv_7 dummyedulevel maritalstatus2

global XHH assets1000 HHsize incomeHH1000

global Xrest villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 shock

global intfem c.OP##i.female c.CO##i.female c.EX##i.female c.ES##i.female c.AG##i.female c.base_raven_tt##i.female c.base_num_tt##i.female c.base_lit_tt##i.female i.dalits

global intdal c.OP##i.dalits c.CO##i.dalits c.EX##i.dalits c.ES##i.dalits c.AG##i.dalits c.base_raven_tt##i.dalits c.base_num_tt##i.dalits c.base_lit_tt##i.dalits i.female

global inttot c.OP##i.female##i.dalits c.CO##i.female##i.dalits c.EX##i.female##i.dalits c.ES##i.female##i.dalits c.AG##i.female##i.dalits c.base_raven_tt##i.female##i.dalits c.base_num_tt##i.female##i.dalits c.base_lit_tt##i.female##i.dalits



********** Recourse
* No PTCS
qui reg s_indebt i.female i.dalits $XIndiv $XHH $Xrest
est store pr0a
qui xtreg s_indebt i.female i.dalits $XIndiv $XHH $Xrest, fe
est store pr0b

* PTCS
qui reg s_indebt $PTCS $XIndiv $XHH $Xrest
est store pr1a
qui xtreg s_indebt $PTCS $XIndiv $XHH $Xrest, fe
est store pr1b

* Int female
qui reg `x' $intfem $XIndiv $XHH $Xrest
est store pr2a
qui xtreg `x' $intfem $XIndiv $XHH $Xrest, fe
est store pr2b

* Int Dalits
qui reg s_indebt $intdal $XIndiv $XHH $Xrest
est store pr3a
qui xtreg s_indebt $intdal $XIndiv $XHH $Xrest, fe
est store pr3b

* Int female Dalits
qui reg s_indebt $inttot $XIndiv $XHH $Xrest
est store pr4a
qui xtreg s_indebt $inttot $XIndiv $XHH $Xrest, fe
est store pr4b

*
esttab pr0a pr0b pr1a pr1b pr2a pr2b pr3a pr3b pr4a pr4b using "Reco_rob5b.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
est clear


********** Negotiation
* No PTCS
qui reg s_borrservices_none i.female i.dalits $XIndiv $XHH $Xrest
est store pr0a
qui xtreg s_borrservices_none i.female i.dalits $XIndiv $XHH $Xrest, fe
est store pr0b

* PTCS
qui reg s_borrservices_none $PTCS $XIndiv $XHH $Xrest
est store pr1a
qui xtreg s_borrservices_none $PTCS $XIndiv $XHH $Xrest, fe
est store pr1b

* Int female
qui reg s_borrservices_none $intfem $XIndiv $XHH $Xrest
est store pr2a
qui xtreg s_borrservices_none $intfem $XIndiv $XHH $Xrest, fe
est store pr2b

* Int Dalits
qui reg s_borrservices_none $intdal $XIndiv $XHH $Xrest
est store pr3a
qui xtreg s_borrservices_none $intdal $XIndiv $XHH $Xrest, fe
est store pr3b

* Int female Dalits
qui reg s_borrservices_none $inttot $XIndiv $XHH $Xrest
est store pr4a
qui xtreg s_borrservices_none $inttot $XIndiv $XHH $Xrest, fe
est store pr4b

*
esttab pr0a pr0b pr1a pr1b pr2a pr2b pr3a pr3b pr4a pr4b using "Nego_rob5b.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		
est clear


********** Management
* No PTCS
qui reg s_dummyproblemtorepay i.female i.dalits $XIndiv $XHH $Xrest
est store pr0a
qui xtreg s_dummyproblemtorepay i.female i.dalits $XIndiv $XHH $Xrest, fe
est store pr0b

* PTCS
qui reg s_dummyproblemtorepay $PTCS $XIndiv $XHH $Xrest
est store pr1a
qui xtreg s_dummyproblemtorepay $PTCS $XIndiv $XHH $Xrest, fe
est store pr1b

* Int female
qui reg s_dummyproblemtorepay $intfem $XIndiv $XHH $Xrest
est store pr2a
qui xtreg s_dummyproblemtorepay $intfem $XIndiv $XHH $Xrest, fe
est store pr2b

* Int Dalits
qui reg s_dummyproblemtorepay $intdal $XIndiv $XHH $Xrest
est store pr3a
qui xtreg s_dummyproblemtorepay $intdal $XIndiv $XHH $Xrest, fe
est store pr3b

* Int female Dalits
qui reg s_dummyproblemtorepay $inttot $XIndiv $XHH $Xrest
est store pr4a
qui xtreg s_dummyproblemtorepay $inttot $XIndiv $XHH $Xrest, fe
est store pr4b


esttab pr0a pr0b pr1a pr1b pr2a pr2b pr3a pr3b pr4a pr4b using "Mana_rob5b.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
est clear
*************************************
* END






