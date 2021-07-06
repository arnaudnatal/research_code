cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
May 13, 2021
-----
Personality traits & debt AT INDIVIDUAL LEVEL in wide
-----
help fvvarlist
-------------------------
*/





****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
set scheme plotplain
********** Path to folder "data" folder.
*global directory = "D:\Documents\_Thesis\Research-Skills_and_debt\Analysis"
*cd"$directory"


*Fac
cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
set scheme plotplain

global git "C:\Users\anatal\Downloads\GitHub"
global dropbox "C:\Users\anatal\Downloads\Dropbox"
global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"



********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH_v7"
global wave3 "NEEMSIS2-HH_v16"


********** Stata package

*coefplot, horizontal xline(0) drop(_cons) levels(95 90 ) ciopts(recast(. rcap))mlabel mlabposition(12) mlabgap(*2)

****************************************
* END








****************************************
* Préparation database
****************************************
use"panel_wide_v3.dta", clear


********** Vérification instrument pour procédure Heckman
*** Debtor ratio
tabstat debtorratio2_1 debtorratio2_2, stat(n mean sd p50) by(caste_1)
fre debtorratio2_1

*** Graph
/*
twoway (scatter loanamount_indiv1000_2 debtorratio2_1 if indebt_indiv_2==1), xtitle("Debtor ratio in 2016-17", size(small)) xlabel(0(1)5, labsize(small)) xmtick(0(0.2)5) ytitle("Total loan amount (1,000 INR)", size(small)) ylabel(0(500)2500, labsize(small)) ymtick(0(100)2600)
twoway (scatter DSR_indiv_2 debtorratio2_1 if indebt_indiv_2==1)
twoway (scatter over40_indiv_2 debtorratio2_1 if indebt_indiv_2==1)
twoway (scatter loans_indiv_2 debtorratio2_1 if indebt_indiv_2==1)
*/


********** Macro
global intfem fem_base_cr_OP_std fem_base_cr_CO_std fem_base_cr_EX_std fem_base_cr_AG_std fem_base_cr_ES_std fem_base_raven_tt fem_base_num_tt fem_base_lit_tt

global intdal dal_base_cr_OP_std dal_base_cr_CO_std dal_base_cr_EX_std dal_base_cr_AG_std dal_base_cr_ES_std dal_base_raven_tt dal_base_num_tt dal_base_lit_tt

global three threeway_base_cr_OP_std threeway_base_cr_CO_std threeway_base_cr_EX_std threeway_base_cr_AG_std threeway_base_cr_ES_std threeway_base_raven_tt threeway_base_num_tt threeway_base_lit_tt

global big5 base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std

global cog base_raven_tt base_num_tt base_lit_tt
global indivcontrol age_1 agesq_1 dummyhead cat_mainoccupation_indiv_1_1 cat_mainoccupation_indiv_1_2 cat_mainoccupation_indiv_1_3 cat_mainoccupation_indiv_1_4 cat_mainoccupation_indiv_1_5 dummyedulevel maritalstatus2_1 dummymultipleoccupation_indiv_1
*global indivcontrol age_1 dummyhead cat_n_mainoccupation_indiv_1_1 cat_n_mainoccupation_indiv_1_2 cat_n_mainoccupation_indiv_1_3 dummyedulevel maritalstatus2_1


global hhcontrol4 assets1000_1 sexratiocat_1_1 sexratiocat_1_2 sexratiocat_1_3 hhsize_1 shock_1 incomeHH1000_1
*global hhcontrol4 assets1000_1 shock_1 incomeHH1000_percapita
global villagesFE near_panruti near_villupur near_tirup near_chengal near_kanchip near_chennai







****************************************
* Analysis
****************************************

********** 1.
********** Proba of being in debt, or overindebted, interest in t+1

probit indebt_indiv_2 indebt_indiv_1 $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits debtorratio2_1, vce(cluster HHFE)
est store res_1
predict probitxb_noint, xb
ge pdf_noint=normalden(probitxb_noint)
ge cdf_noint=normal(probitxb_noint)
ge imr_noint=pdf_noint/cdf_noint

probit indebt_indiv_2 indebt_indiv_1 $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem debtorratio2_1, vce(cluster HHFE)
est store res_2
predict probitxb_intfem, xb
ge pdf_intfem=normalden(probitxb_intfem)
ge cdf_intfem=normal(probitxb_intfem)
ge imr_intfem=pdf_intfem/cdf_intfem

probit indebt_indiv_2 indebt_indiv_1 $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal debtorratio2_1, vce(cluster HHFE)
est store res_3
predict probitxb_intdal, xb
ge pdf_intdal=normalden(probitxb_intdal)
ge cdf_intdal=normal(probitxb_intdal)
ge imr_intdal=pdf_intdal/cdf_intdal

probit indebt_indiv_2 indebt_indiv_1 $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three debtorratio2_1, vce(cluster HHFE)
est store res_5
predict probitxb_three, xb
ge pdf_three=normalden(probitxb_three)
ge cdf_three=normal(probitxb_three)
ge imr_three=pdf_three/cdf_three


esttab res_1 res_2 res_3 res_5 using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop() ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
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
export excel using "Probit_indebt.xlsx", sheet("Indebt_Big5", replace)
restore

*********** Marges
cls
foreach x in indebt_indiv {
*** No int
qui probit `x'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std c.base_factor_imraw_2_std c.base_factor_imraw_3_std c.base_factor_imraw_4_std c.base_factor_imraw_5_std c.base_raven_tt c.base_num_tt c.base_lit_tt dalits female, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) atmeans saving(margin_b5_`x'1, replace)


*** Female
qui probit `x'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.female c.base_factor_imraw_2_std##i.female c.base_factor_imraw_3_std##i.female c.base_factor_imraw_4_std##i.female c.base_factor_imraw_5_std##i.female c.base_raven_tt##i.female c.base_num_tt##i.female c.base_lit_tt##i.female dalits, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) at(female=(0 1)) atmeans saving(margin_b5_`x'2, replace)



*** Dalits
qui probit `x'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.dalits c.base_factor_imraw_2_std##i.dalits c.base_factor_imraw_3_std##i.dalits c.base_factor_imraw_4_std##i.dalits c.base_factor_imraw_5_std##i.dalits c.base_raven_tt##i.dalits c.base_num_tt##i.dalits c.base_lit_tt##i.dalits female, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) at(dalits=(0 1)) atmeans saving(margin_b5_`x'3, replace)



*** Three
qui probit `x'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.female##i.dalits c.base_factor_imraw_2_std##i.female##i.dalits c.base_factor_imraw_3_std##i.female##i.dalits c.base_factor_imraw_4_std##i.female##i.dalits c.base_factor_imraw_5_std##i.female##i.dalits c.base_raven_tt##i.female##i.dalits c.base_num_tt##i.female##i.dalits c.base_lit_tt##i.female##i.dalits, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) at(dalits=(0 1) female=(0 1)) atmeans saving(margin_b5_`x'4, replace)
}





********** 2.
********** Level of debt in t+1
 
foreach var in loanamount_indiv1000 DSR_indiv {

qui reg `var'_2 indebt_indiv_1 $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits if indebt_indiv_2==1, vce(cluster HHFE)
est store res_1

qui reg `var'_2 indebt_indiv_1 $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem if indebt_indiv_2==1, vce(cluster HHFE)
est store res_2

qui reg `var'_2 indebt_indiv_1 $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal if indebt_indiv_2==1, vce(cluster HHFE)
est store res_3

qui reg `var'_2 indebt_indiv_1 $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three if indebt_indiv_2==1, vce(cluster HHFE)
est store res_5

esttab res_1 res_2 res_3 res_5 using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop() ///	
	legend label varlabels(_cons constant) ///
	stats(N r2 r2_a F p, fmt(0 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
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
export excel using "OLS_indebt.xlsx", sheet("`var'", replace)
restore

********** Margins

*** No int
qui reg `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std c.base_factor_imraw_2_std c.base_factor_imraw_3_std c.base_factor_imraw_4_std c.base_factor_imraw_5_std c.base_raven_tt c.base_num_tt c.base_lit_tt dalits female if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) atmeans  saving(margin_b5_`var'1, replace)

*** Female
qui reg `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.female c.base_factor_imraw_2_std##i.female c.base_factor_imraw_3_std##i.female c.base_factor_imraw_4_std##i.female c.base_factor_imraw_5_std##i.female c.base_raven_tt##i.female c.base_num_tt##i.female c.base_lit_tt##i.female dalits if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) at(female=(0 1)) atmeans saving(margin_b5_`var'2, replace)



*** Dalits
qui reg `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.dalits c.base_factor_imraw_2_std##i.dalits c.base_factor_imraw_3_std##i.dalits c.base_factor_imraw_4_std##i.dalits c.base_factor_imraw_5_std##i.dalits c.base_raven_tt##i.dalits c.base_num_tt##i.dalits c.base_lit_tt##i.dalits female  if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) at(dalits=(0 1)) atmeans saving(margin_b5_`var'3, replace)



*** Three
qui reg `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.female##i.dalits c.base_factor_imraw_2_std##i.female##i.dalits c.base_factor_imraw_3_std##i.female##i.dalits c.base_factor_imraw_4_std##i.female##i.dalits c.base_factor_imraw_5_std##i.female##i.dalits c.base_raven_tt##i.female##i.dalits c.base_num_tt##i.female##i.dalits c.base_lit_tt##i.female##i.dalits if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) at(dalits=(0 1) female=(0 1)) atmeans saving(margin_b5_`var'4, replace)
}





********** 4.
********** Proba of being overindebted, interest in t+1
foreach var in over40_indiv{

qui probit `var'_2 indebt_indiv_1 $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits if indebt_indiv_2==1, vce(cluster HHFE)
est store res_1

qui probit `var'_2 indebt_indiv_1 $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem if indebt_indiv_2==1, vce(cluster HHFE)
est store res_2

qui probit `var'_2 indebt_indiv_1 $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal if indebt_indiv_2==1, vce(cluster HHFE)
est store res_3

qui probit `var'_2 indebt_indiv_1 $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three if indebt_indiv_2==1, vce(cluster HHFE)
est store res_5

esttab res_1 res_2 res_3 res_5 using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop() ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
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
export excel using "Probit_indebt.xlsx", sheet("`var'", replace)
restore

********** Margins

*** No int
qui probit `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std c.base_factor_imraw_2_std c.base_factor_imraw_3_std c.base_factor_imraw_4_std c.base_factor_imraw_5_std c.base_raven_tt c.base_num_tt c.base_lit_tt dalits female if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) atmeans saving(margin_b5_`var'1, replace)

*** Female
qui probit `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.female c.base_factor_imraw_2_std##i.female c.base_factor_imraw_3_std##i.female c.base_factor_imraw_4_std##i.female c.base_factor_imraw_5_std##i.female c.base_raven_tt##i.female c.base_num_tt##i.female c.base_lit_tt##i.female dalits if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) at(female=(0 1)) atmeans saving(margin_b5_`var'2, replace)



*** Dalits
qui probit `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.dalits c.base_factor_imraw_2_std##i.dalits c.base_factor_imraw_3_std##i.dalits c.base_factor_imraw_4_std##i.dalits c.base_factor_imraw_5_std##i.dalits c.base_raven_tt##i.dalits c.base_num_tt##i.dalits c.base_lit_tt##i.dalits female  if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) at(dalits=(0 1)) atmeans saving(margin_b5_`var'3, replace)



*** Three
qui probit `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.female##i.dalits c.base_factor_imraw_2_std##i.female##i.dalits c.base_factor_imraw_3_std##i.female##i.dalits c.base_factor_imraw_4_std##i.female##i.dalits c.base_factor_imraw_5_std##i.female##i.dalits c.base_raven_tt##i.female##i.dalits c.base_num_tt##i.female##i.dalits c.base_lit_tt##i.female##i.dalits if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) at(dalits=(0 1) female=(0 1)) atmeans saving(margin_b5_`var'4, replace)
}






********** 5.
********** Level of debt in t+1 
foreach var in loans_indiv {

qui poisson `var'_2 indebt_indiv_1 $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits if indebt_indiv_2==1, vce(cluster HHFE)
est store res_1

qui poisson `var'_2 indebt_indiv_1 $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem if indebt_indiv_2==1, vce(cluster HHFE)
est store res_2

qui poisson `var'_2 indebt_indiv_1 $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal if indebt_indiv_2==1, vce(cluster HHFE)
est store res_3

qui poisson `var'_2 indebt_indiv_1 $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three if indebt_indiv_2==1, vce(cluster HHFE)
est store res_5

esttab res_1 res_2 res_3 res_5 using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop($indivcontrol $hhcontrol4 $villagesFE) ///
	legend label varlabels(_cons constant) ///
	stats(N df_m r2_p ll chi2 p, fmt(0 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
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
export excel using "Poisson_indebt.xlsx", sheet("`var'", replace)
restore

********** Margins

*** No int
qui poisson `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std c.base_factor_imraw_2_std c.base_factor_imraw_3_std c.base_factor_imraw_4_std c.base_factor_imraw_5_std c.base_raven_tt c.base_num_tt c.base_lit_tt dalits female if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) atmeans saving(margin_b5_`var'1, replace)

*** Female
qui poisson `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.female c.base_factor_imraw_2_std##i.female c.base_factor_imraw_3_std##i.female c.base_factor_imraw_4_std##i.female c.base_factor_imraw_5_std##i.female c.base_raven_tt##i.female c.base_num_tt##i.female c.base_lit_tt##i.female dalits if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) at(female=(0 1)) atmeans saving(margin_b5_`var'2, replace)



*** Dalits
qui poisson `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.dalits c.base_factor_imraw_2_std##i.dalits c.base_factor_imraw_3_std##i.dalits c.base_factor_imraw_4_std##i.dalits c.base_factor_imraw_5_std##i.dalits c.base_raven_tt##i.dalits c.base_num_tt##i.dalits c.base_lit_tt##i.dalits female  if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) at(dalits=(0 1)) atmeans saving(margin_b5_`var'3, replace)



*** Three
qui poisson `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.female##i.dalits c.base_factor_imraw_2_std##i.female##i.dalits c.base_factor_imraw_3_std##i.female##i.dalits c.base_factor_imraw_4_std##i.female##i.dalits c.base_factor_imraw_5_std##i.female##i.dalits c.base_raven_tt##i.female##i.dalits c.base_num_tt##i.female##i.dalits c.base_lit_tt##i.female##i.dalits if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) at(dalits=(0 1) female=(0 1)) atmeans saving(margin_b5_`var'4, replace)
}

****************************************
* END













********** 7.
********** Variation of debt
foreach x in delta_loanamount_indiv delta_DSR_indiv delta_ISR_indiv delta_loans_indiv {
fsum `x'
}
tab delta_loanamount_indiv
order loanamount_indiv1000_1 loanamount_indiv1000_2 delta2_loanamount_indiv, last
sort delta2_loanamount_indiv 



foreach var in delta2_loanamount_indiv delta2_DSR_indiv delta2_ISR_indiv delta2_loans_indiv {

qui reg `var' $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits, vce(cluster HHFE)
est store res_1

qui reg `var' $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem, vce(cluster HHFE)
est store res_2

qui reg `var' $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal, vce(cluster HHFE)
est store res_3

qui reg `var' $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three, vce(cluster HHFE)
est store res_5

esttab res_1 res_2 res_3 res_5 using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop($indivcontrol $hhcontrol4 $villagesFE) ///
	legend label varlabels(_cons constant) ///
	stats(N df_m r2_p ll chi2 p, fmt(0 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
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
export excel using "OLS_delta_indebt.xlsx", sheet("`var'", replace)
restore

********** Margins

*** No int
qui reg `var' $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std c.base_factor_imraw_2_std c.base_factor_imraw_3_std c.base_factor_imraw_4_std c.base_factor_imraw_5_std c.base_raven_tt c.base_num_tt c.base_lit_tt dalits female, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) atmeans saving(margin_b5_`var'1, replace)

*** Female
qui reg `var' $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.female c.base_factor_imraw_2_std##i.female c.base_factor_imraw_3_std##i.female c.base_factor_imraw_4_std##i.female c.base_factor_imraw_5_std##i.female c.base_raven_tt##i.female c.base_num_tt##i.female c.base_lit_tt##i.female dalits, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) at(female=(0 1)) atmeans saving(margin_b5_`var'2, replace)

*** Dalits
qui reg `var' $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.dalits c.base_factor_imraw_2_std##i.dalits c.base_factor_imraw_3_std##i.dalits c.base_factor_imraw_4_std##i.dalits c.base_factor_imraw_5_std##i.dalits c.base_raven_tt##i.dalits c.base_num_tt##i.dalits c.base_lit_tt##i.dalits female, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) at(dalits=(0 1)) atmeans saving(margin_b5_`var'3, replace)

*** Three
qui reg `var' $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.female##i.dalits c.base_factor_imraw_2_std##i.female##i.dalits c.base_factor_imraw_3_std##i.female##i.dalits c.base_factor_imraw_4_std##i.female##i.dalits c.base_factor_imraw_5_std##i.female##i.dalits c.base_raven_tt##i.female##i.dalits c.base_num_tt##i.female##i.dalits c.base_lit_tt##i.female##i.dalits, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) at(dalits=(0 1) female=(0 1)) atmeans saving(margin_b5_`var'4, replace)
}

****************************************
* END









********** 8.
********** Level of debt in t+1 with Heckman
 
foreach var in loanamount_indiv1000 DSR_indiv {

qui reg `var'_2 indebt_indiv_1 $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits imr_noint if indebt_indiv_2==1, vce(cluster HHFE)
est store res_1

qui reg `var'_2 indebt_indiv_1 $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem imr_intfem if indebt_indiv_2==1, vce(cluster HHFE)
est store res_2

qui reg `var'_2 indebt_indiv_1 $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal imr_intdal if indebt_indiv_2==1, vce(cluster HHFE)
est store res_3

qui reg `var'_2 indebt_indiv_1 $big5 $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three imr_three if indebt_indiv_2==1, vce(cluster HHFE)
est store res_5

esttab res_1 res_2 res_3 res_5 using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop() ///	
	legend label varlabels(_cons constant) ///
	stats(N r2 r2_a F p, fmt(0 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
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
export excel using "OLS_indebt_heckman.xlsx", sheet("`var'", replace)
restore

********** Margins

*** No int
qui reg `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std c.base_factor_imraw_2_std c.base_factor_imraw_3_std c.base_factor_imraw_4_std c.base_factor_imraw_5_std c.base_raven_tt c.base_num_tt c.base_lit_tt dalits female imr_noint if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) atmeans  saving(margin_b5_heck_`var'1, replace)

*** Female
qui reg `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.female c.base_factor_imraw_2_std##i.female c.base_factor_imraw_3_std##i.female c.base_factor_imraw_4_std##i.female c.base_factor_imraw_5_std##i.female c.base_raven_tt##i.female c.base_num_tt##i.female c.base_lit_tt##i.female dalits imr_intfem if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) at(female=(0 1)) atmeans saving(margin_b5_heck_`var'2, replace)



*** Dalits
qui reg `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.dalits c.base_factor_imraw_2_std##i.dalits c.base_factor_imraw_3_std##i.dalits c.base_factor_imraw_4_std##i.dalits c.base_factor_imraw_5_std##i.dalits c.base_raven_tt##i.dalits c.base_num_tt##i.dalits c.base_lit_tt##i.dalits female imr_intdal if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) at(dalits=(0 1)) atmeans saving(margin_b5_heck_`var'3, replace)



*** Three
qui reg `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.female##i.dalits c.base_factor_imraw_2_std##i.female##i.dalits c.base_factor_imraw_3_std##i.female##i.dalits c.base_factor_imraw_4_std##i.female##i.dalits c.base_factor_imraw_5_std##i.female##i.dalits c.base_raven_tt##i.female##i.dalits c.base_num_tt##i.female##i.dalits c.base_lit_tt##i.female##i.dalits imr_three if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) at(dalits=(0 1) female=(0 1)) atmeans saving(margin_b5_heck_`var'4, replace)
}
