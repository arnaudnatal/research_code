*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*May 13, 2021
*-----
gl link = "psychodebt"
*Econ
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------




****************************************
* Prepa db
****************************************
use"panel_wide_v4.dta", clear


/*
Instrument for Heckman;
- debtor ratio ok
- network nope
- distance nope
- network size nope
- contact list nope
- association nope
- trust nope
*/




********** Macro
global intfem fem_base_f1_std fem_base_f2_std fem_base_f3_std fem_base_f5_std fem_base_raven_tt_std fem_base_lit_tt_std fem_base_num_tt_std

global intdal dal_base_f1_std dal_base_f2_std dal_base_f3_std dal_base_f5_std dal_base_raven_tt_std dal_base_lit_tt_std dal_base_num_tt_std

global three thr_base_f1_std thr_base_f2_std thr_base_f3_std thr_base_f5_std thr_base_raven_tt_std thr_base_lit_tt_std thr_base_num_tt_std

global efa base_f1_std base_f2_std base_f3_std base_f5_std

global cog base_raven_tt_std base_num_tt_std base_lit_tt_std

*global indivcontrol age_1 agesq_1 dummyhead_1 cat_mainocc_occupation_indiv_1_1 cat_mainocc_occupation_indiv_1_2 cat_mainocc_occupation_indiv_1_4 cat_mainocc_occupation_indiv_1_5 cat_mainocc_occupation_indiv_1_6 cat_mainocc_occupation_indiv_1_7 dummyedulevel maritalstatus2_1

global indivcontrol age_1 cat_mainocc_occupation_indiv_1_1 cat_mainocc_occupation_indiv_1_2 cat_mainocc_occupation_indiv_1_4 cat_mainocc_occupation_indiv_1_5 cat_mainocc_occupation_indiv_1_6 cat_mainocc_occupation_indiv_1_7 dummyedulevel maritalstatus2_1


global hhcontrol4 assets1000_1 hhsize_1 shock_1 covsell incomeHH1000_1

global villagesFE villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10



********** Macro Y
global quali indebt_indiv_2
global qualinego borrowerservices_none
*otherlenderservices_finansupp
global qualimana dummyproblemtorepay
*plantorepay_borr

*** Desc
mdesc $quali $qualiml $quanti
****************************************
* END



















****************************************
* PROBIT
****************************************



********** Probit RECOURSE
qui probit indebt_indiv_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE female dalits, vce(cluster HHFE)
overfit: probit indebt_indiv_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE female dalits, vce(cluster HHFE)
est store res_0

qui probit indebt_indiv_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits, vce(cluster HHFE)
overfit: probit indebt_indiv_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits, vce(cluster HHFE)
est store res_1

qui probit indebt_indiv_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem, vce(cluster HHFE)
overfit: probit indebt_indiv_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem, vce(cluster HHFE)
est store res_2

qui probit indebt_indiv_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal, vce(cluster HHFE)
overfit: probit indebt_indiv_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal, vce(cluster HHFE)
est store res_3

qui probit indebt_indiv_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three, vce(cluster HHFE)
overfit: probit indebt_indiv_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three, vce(cluster HHFE)
est store res_4

esttab res_0 res_1 res_2 res_3 res_4 using "_reg.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop() ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 2 2 2 2) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\upchi^2$"' `"p-value"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
estimates clear

preserve
import delimited "_reg.csv", delimiter(",") varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "Probit_indebt.xlsx", sheet("indebt_indiv_2", replace)
restore





********** Probit NEGOTIATION
probit borrowerservices_none indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE female dalits c.share_nb_samesex c.share_nb_samecaste, vce(cluster HHFE)
overfit: probit borrowerservices_none indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE female dalits c.share_nb_samesex c.share_nb_samecaste, vce(cluster HHFE)
est store res_0

probit borrowerservices_none indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits c.share_nb_samesex c.share_nb_samecaste, vce(cluster HHFE)
overfit: probit borrowerservices_none indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits c.share_nb_samesex c.share_nb_samecaste, vce(cluster HHFE)
est store res_1

probit borrowerservices_none indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem c.share_nb_samesex c.share_nb_samecaste, vce(cluster HHFE)
overfit: probit borrowerservices_none indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem c.share_nb_samesex c.share_nb_samecaste, vce(cluster HHFE)
est store res_2

qui probit borrowerservices_none indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal c.share_nb_samesex c.share_nb_samecaste, vce(cluster HHFE)
overfit: probit borrowerservices_none indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal c.share_nb_samesex c.share_nb_samecaste, vce(cluster HHFE)
est store res_3

qui probit borrowerservices_none indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three c.share_nb_samesex c.share_nb_samecaste, vce(cluster HHFE)
lroc
overfit: probit borrowerservices_none indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three c.share_nb_samesex c.share_nb_samecaste, vce(cluster HHFE)
est store res_4

esttab res_0 res_1 res_2 res_3 res_4 using "_reg.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop() ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 2 2 2 2) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\upchi^2$"' `"p-value"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
estimates clear

preserve
import delimited "_reg.csv", delimiter(",") varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "Probit_indebt.xlsx", sheet("borrowerservices_none", replace)
restore








********** Probit MANAGEMENT
qui probit dummyproblemtorepay indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE female dalits c.loanamount_indiv, vce(cluster HHFE)
overfit: probit dummyproblemtorepay indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE female dalits c.loanamount_indiv, vce(cluster HHFE)
est store res_0

qui probit dummyproblemtorepay indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits c.loanamount_indiv, vce(cluster HHFE)
overfit: probit dummyproblemtorepay indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits c.loanamount_indiv, vce(cluster HHFE)
est store res_1

qui probit dummyproblemtorepay indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem c.loanamount_indiv, vce(cluster HHFE)
overfit: probit dummyproblemtorepay indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem c.loanamount_indiv, vce(cluster HHFE)
est store res_2

qui probit dummyproblemtorepay indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal c.loanamount_indiv, vce(cluster HHFE)
overfit: probit dummyproblemtorepay indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal c.loanamount_indiv, vce(cluster HHFE)
est store res_3

probit dummyproblemtorepay indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three c.loanamount_indiv, vce(cluster HHFE)
overfit: probit dummyproblemtorepay indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three c.loanamount_indiv, vce(cluster HHFE)
est store res_4

esttab res_0 res_1 res_2 res_3 res_4 using "_reg.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop() ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 2 2 2 2) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\upchi^2$"' `"p-value"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
estimates clear

preserve
import delimited "_reg.csv", delimiter(",") varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "Probit_indebt.xlsx", sheet("dummyproblemtorepay", replace)
restore







overfit: probit dummyproblemtorepay indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE female dalits c.loanamount_indiv, vce(cluster HHFE)






*********** Marges RECOURSE
*** No int
probit indebt_indiv_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std c.base_f2_std c.base_f3_std c.base_f5_std c.base_raven_tt_std c.base_num_tt_std c.base_lit_tt_std dalits female, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) atmeans saving(margin_indebt_indiv_21, replace)

*** Female
probit indebt_indiv_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std##i.female c.base_f2_std##i.female c.base_f3_std##i.female c.base_f5_std##i.female c.base_raven_tt_std##i.female c.base_num_tt_std##i.female c.base_lit_tt_std##i.female dalits, vce(cluster HHFE)
*dy/dx
margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(female=(0 1)) atmeans saving(margin_indebt_indiv_22, replace)

*** Dalits
probit indebt_indiv_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std##i.dalits c.base_f2_std##i.dalits c.base_f3_std##i.dalits c.base_f5_std##i.dalits c.base_raven_tt_std##i.dalits c.base_num_tt_std##i.dalits c.base_lit_tt_std##i.dalits female, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1)) atmeans saving(margin_indebt_indiv_23, replace)

*** Three
qui probit indebt_indiv_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1) female=(0 1)) atmeans saving(margin_indebt_indiv_24, replace)
}

















********** Marges NEGOTATION
*** No int
qui probit borrowerservices_none indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std c.base_f2_std c.base_f3_std c.base_f5_std c.base_raven_tt_std c.base_num_tt_std c.base_lit_tt_std dalits female c.share_nb_samesex c.share_nb_samecaste, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) atmeans saving(margin_borrowerservices_none1, replace)

*** Female
qui probit borrowerservices_none indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std##i.female c.base_f2_std##i.female c.base_f3_std##i.female c.base_f5_std##i.female c.base_raven_tt_std##i.female c.base_num_tt_std##i.female c.base_lit_tt_std##i.female dalits c.share_nb_samesex c.share_nb_samecaste, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(female=(0 1)) atmeans saving(margin_borrowerservices_none2, replace)

*** Dalits
qui probit borrowerservices_none indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std##i.dalits c.base_f2_std##i.dalits c.base_f3_std##i.dalits c.base_f5_std##i.dalits c.base_raven_tt_std##i.dalits c.base_num_tt_std##i.dalits c.base_lit_tt_std##i.dalits female c.share_nb_samesex c.share_nb_samecaste, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1)) atmeans saving(margin_borrowerservices_none3, replace)

*** Three
qui probit borrowerservices_none indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits c.share_nb_samesex c.share_nb_samecaste, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1) female=(0 1)) atmeans saving(margin_borrowerservices_none4, replace)































********** Marges MANAGEMENT
*** No int
qui probit dummyproblemtorepay indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std c.base_f2_std c.base_f3_std c.base_f5_std c.base_raven_tt_std c.base_num_tt_std c.base_lit_tt_std dalits female c.loanamount_indiv, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) atmeans saving(margin_dummyproblemtorepay1, replace)

*** Female
qui probit dummyproblemtorepay indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std##i.female c.base_f2_std##i.female c.base_f3_std##i.female c.base_f5_std##i.female c.base_raven_tt_std##i.female c.base_num_tt_std##i.female c.base_lit_tt_std##i.female dalits c.loanamount_indiv, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(female=(0 1)) atmeans saving(margin_dummyproblemtorepay2, replace)

*** Dalits
qui probit dummyproblemtorepay indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std##i.dalits c.base_f2_std##i.dalits c.base_f3_std##i.dalits c.base_f5_std##i.dalits c.base_raven_tt_std##i.dalits c.base_num_tt_std##i.dalits c.base_lit_tt_std##i.dalits female c.loanamount_indiv, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1)) atmeans saving(margin_dummyproblemtorepay3, replace)

*** Three
qui probit dummyproblemtorepay indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits c.loanamount_indiv, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1) female=(0 1)) atmeans saving(margin_dummyproblemtorepay4, replace)



****************************************
* END







global intfem fem_base_f1_std fem_base_f2_std fem_base_f3_std fem_base_f5_std

global intdal dal_base_f1_std dal_base_f2_std dal_base_f3_std dal_base_f5_std  

global three thr_base_f1_std thr_base_f2_std thr_base_f3_std thr_base_f5_std  

global efa base_f1_std base_f2_std base_f3_std base_f5_std

global cog base_raven_tt_std base_num_tt_std base_lit_tt_std

global indivcontrol age_1 cat_mainocc_occupation_indiv_1_1 cat_mainocc_occupation_indiv_1_2 cat_mainocc_occupation_indiv_1_4 cat_mainocc_occupation_indiv_1_5 cat_mainocc_occupation_indiv_1_6 cat_mainocc_occupation_indiv_1_7 dummyedulevel maritalstatus2_1

global hhcontrol4 assets1000_1 hhsize_1 shock_1 covsell incomeHH1000_1

global villagesFE villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10





overfit: probit dummyproblemtorepay female dalits







/*




****************************************
* PROBIT
****************************************



********** Macro
global indivcontrol age_1 agesq_1 dummyhead_1 cat_mainocc_occupation_indiv_1_1 cat_mainocc_occupation_indiv_1_2 cat_mainocc_occupation_indiv_1_4 cat_mainocc_occupation_indiv_1_5 cat_mainocc_occupation_indiv_1_6 cat_mainocc_occupation_indiv_1_7 dummyedulevel maritalstatus2_1

global hhcontrol4 hhsize_1 shock_1 covsell incomeHH1000_1

global villagesFE villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10



cls
********** No int
*** Without
probit indebt_indiv_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE dalits female c.assets1000_1, vce(cluster HHFE)
*dy/dx
margins, dydx(assets1000_1) atmeans

*** With
probit indebt_indiv_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std c.base_f2_std c.base_f3_std c.base_f5_std c.base_raven_tt_std c.base_num_tt_std c.base_lit_tt_std dalits female  c.assets1000_1, vce(cluster HHFE)
*dy/dx
margins, dydx(assets1000_1) atmeans







********** Females
*** Without
probit indebt_indiv_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE dalits  c.assets1000_1##i.female, vce(cluster HHFE)
*dy/dx
margins, dydx(assets1000_1) at(female=(0 1)) atmeans

*** With
probit indebt_indiv_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std c.base_f2_std c.base_f3_std c.base_f5_std c.base_raven_tt_std c.base_num_tt_std c.base_lit_tt_std dalits  c.assets1000_1##i.female, vce(cluster HHFE)
*dy/dx
margins, dydx(assets1000_1) at(female=(0 1)) atmeans



********** Dalits
*** Without
probit indebt_indiv_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE female  c.assets1000_1##i.dalits, vce(cluster HHFE)
*dy/dx
margins, dydx(assets1000_1) at(dalits=(0 1)) atmeans

*** With
probit indebt_indiv_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std c.base_f2_std c.base_f3_std c.base_f5_std c.base_raven_tt_std c.base_num_tt_std c.base_lit_tt_std female  c.assets1000_1##i.dalits, vce(cluster HHFE)
*dy/dx
margins, dydx(assets1000_1) at(dalits=(0 1)) atmeans



********** Three
*** Without
probit indebt_indiv_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE  c.assets1000_1##i.female##i.dalits, vce(cluster HHFE)
*dy/dx
margins, dydx(assets1000_1) at(dalits=(0 1) female=(0 1)) atmeans

*** With
probit indebt_indiv_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std c.base_f2_std c.base_f3_std c.base_f5_std c.base_raven_tt_std c.base_num_tt_std c.base_lit_tt_std  c.assets1000_1##i.female##i.dalits, vce(cluster HHFE)
*dy/dx
margins, dydx(assets1000_1) at(dalits=(0 1) female=(0 1)) atmeans

****************************************
* END
