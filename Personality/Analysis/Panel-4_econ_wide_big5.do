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



********** Macro
global intfem fem_base_cr_OP_std fem_base_cr_CO_std fem_base_cr_EX_std fem_base_cr_AG_std fem_base_cr_ES_std fem_base_raven_tt fem_base_num_tt fem_base_lit_tt

global intdal dal_base_cr_OP_std dal_base_cr_CO_std dal_base_cr_EX_std dal_base_cr_AG_std dal_base_cr_ES_std dal_base_raven_tt dal_base_num_tt dal_base_lit_tt

global three threeway_base_cr_OP_std threeway_base_cr_CO_std threeway_base_cr_EX_std threeway_base_cr_AG_std threeway_base_cr_ES_std threeway_base_raven_tt threeway_base_num_tt threeway_base_lit_tt

global big5 base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std

global cog base_raven_tt base_num_tt base_lit_tt
global indivcontrol age_1 agesq_1 dummyhead_1 cat_mainoccupation_indiv_1_1 cat_mainoccupation_indiv_1_2 cat_mainoccupation_indiv_1_3 cat_mainoccupation_indiv_1_4 cat_mainoccupation_indiv_1_5 dummyedulevel maritalstatus2_1 dummymultipleoccupation_indiv_1

global hhcontrol4 assets1000_1 sexratiocat_1_1 sexratiocat_1_2 sexratiocat_1_3 hhsize_1 shock_1 incomeHH1000_1
global villagesFE near_panruti near_villupur near_tirup near_chengal near_kanchip near_chennai


********** Label
foreach x in OP CO EX AG ES {
label var fem_base_cr_`x'_std "Female X `x' cor (std)"
label var dal_base_cr_`x'_std "Dalit X `x' cor (std)"
label var threeway_base_cr_`x'_std "Dalit X Female X `x' cor (std)"
label var base_cr_`x'_std "`x' cor (std)"
}
label var fem_base_raven_tt "Female X Raven"
label var dal_base_raven_tt "Dalit X Raven"
label var threeway_base_raven_tt "Dalit X Female X Raven"
label var fem_base_num_tt "Female X Numeracy"
label var dal_base_num_tt "Dalit X Numeracy"
label var threeway_base_num_tt "Dalit X Female X Numeracy"
label var fem_base_lit_tt "Female X Literacy"
label var dal_base_lit_tt "Dalit X Literacy"
label var threeway_base_lit_tt "Dalit X Female X Literacy"
label var femXdal "Female X Dalit"
label var debtorratio2_1 "Debtor ratio in 2016-17"
label var indebt_indiv_1 "Indebted (=1) in 2016-17"




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
	cells(b(fmt(3)) /// 
	t(par fmt(3))) ///
	drop() ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 3 3 3 3) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\upchi^2$"' `"p-value"')) /// //starlevels(* 0.10 ** 0.05 *** 0.01) ///
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
qui probit `x'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_cr_OP_std c.base_cr_CO_std c.base_cr_EX_std c.base_cr_AG_std c.base_cr_ES_std c.base_raven_tt c.base_num_tt c.base_lit_tt dalits female debtorratio2_1, vce(cluster HHFE)
est store res_6
*dy/dx
qui margins, dydx(base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std base_raven_tt base_num_tt base_lit_tt) atmeans saving(margin_b5_`x'1, replace)

*** Female
qui probit `x'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_cr_OP_std##i.female c.base_cr_CO_std##i.female c.base_cr_EX_std##i.female c.base_cr_AG_std##i.female c.base_cr_ES_std##i.female c.base_raven_tt##i.female c.base_num_tt##i.female c.base_lit_tt##i.female dalits debtorratio2_1, vce(cluster HHFE)
est store res_6
*dy/dx
qui margins, dydx(base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std base_raven_tt base_num_tt base_lit_tt) at(female=(0 1)) atmeans saving(margin_b5_`x'2, replace)

*** Dalits
qui probit `x'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_cr_OP_std##i.dalits c.base_cr_CO_std##i.dalits c.base_cr_EX_std##i.dalits c.base_cr_AG_std##i.dalits c.base_cr_ES_std##i.dalits c.base_raven_tt##i.dalits c.base_num_tt##i.dalits c.base_lit_tt##i.dalits female debtorratio2_1, vce(cluster HHFE)
est store res_6
*dy/dx
qui margins, dydx(base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std base_raven_tt base_num_tt base_lit_tt) at(dalits=(0 1)) atmeans saving(margin_b5_`x'3, replace)

*** Three
qui probit `x'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_cr_OP_std##i.female##i.dalits c.base_cr_CO_std##i.female##i.dalits c.base_cr_EX_std##i.female##i.dalits c.base_cr_AG_std##i.female##i.dalits c.base_cr_ES_std##i.female##i.dalits c.base_raven_tt##i.female##i.dalits c.base_num_tt##i.female##i.dalits c.base_lit_tt##i.female##i.dalits debtorratio2_1, vce(cluster HHFE)
est store res_6
*dy/dx
qui margins, dydx(base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std base_raven_tt base_num_tt base_lit_tt) at(dalits=(0 1) female=(0 1)) atmeans saving(margin_b5_`x'4, replace)
}


********** Label IMR
label var imr_noint "IMR (no int)"
label var imr_intfem "IMR (gender int)"
label var imr_intdal "IMR (caste int)"
label var imr_three "IMR (gender and caste int)"















********** 2.
********** Level of debt in t+1
 
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
	cells(b(fmt(3)) /// 
	t(par fmt(3))) ///
	drop() ///	
	legend label varlabels(_cons constant) ///
	stats(N r2 r2_a F p, fmt(0 3 3 3 3) labels(`"Observations"' `"\$R^2$"' `"Adjusted \$R^2$"' `"F-stat"' `"p-value"')) ///
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
qui reg `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_cr_OP_std c.base_cr_CO_std c.base_cr_EX_std c.base_cr_AG_std c.base_cr_ES_std c.base_raven_tt c.base_num_tt c.base_lit_tt dalits female imr_noint if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6
*dy/dx
qui margins, dydx(base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std base_raven_tt base_num_tt base_lit_tt) atmeans  saving(margin_b5_`var'1, replace)

*** Female
qui reg `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_cr_OP_std##i.female c.base_cr_CO_std##i.female c.base_cr_EX_std##i.female c.base_cr_AG_std##i.female c.base_cr_ES_std##i.female c.base_raven_tt##i.female c.base_num_tt##i.female c.base_lit_tt##i.female dalits imr_intfem if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6
*dy/dx
qui margins, dydx(base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std base_raven_tt base_num_tt base_lit_tt) at(female=(0 1)) atmeans saving(margin_b5_`var'2, replace)

*** Dalits
qui reg `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_cr_OP_std##i.dalits c.base_cr_CO_std##i.dalits c.base_cr_EX_std##i.dalits c.base_cr_AG_std##i.dalits c.base_cr_ES_std##i.dalits c.base_raven_tt##i.dalits c.base_num_tt##i.dalits c.base_lit_tt##i.dalits female imr_intdal if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6
*dy/dx
qui margins, dydx(base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std base_raven_tt base_num_tt base_lit_tt) at(dalits=(0 1)) atmeans saving(margin_b5_`var'3, replace)

*** Three
qui reg `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_cr_OP_std##i.female##i.dalits c.base_cr_CO_std##i.female##i.dalits c.base_cr_EX_std##i.female##i.dalits c.base_cr_AG_std##i.female##i.dalits c.base_cr_ES_std##i.female##i.dalits c.base_raven_tt##i.female##i.dalits c.base_num_tt##i.female##i.dalits c.base_lit_tt##i.female##i.dalits imr_three if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6
*dy/dx
qui margins, dydx(base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std base_raven_tt base_num_tt base_lit_tt) at(dalits=(0 1) female=(0 1)) atmeans saving(margin_b5_`var'4, replace)
}




























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
	cells(b(fmt(3)) /// 
	t(par fmt(3))) ///
	drop() ///	
	legend label varlabels(_cons constant) ///
	stats(N r2 r2_a F p, fmt(0 3 3 3 3) labels(`"Observations"' `"\$R^2$"' `"Adjusted \$R^2$"' `"F-stat"' `"p-value"')) ///
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
export excel using "OLS_indebt_heckman.xlsx", sheet("b5_`var'", replace)
restore

********** Margins

*** No int
qui reg `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_cr_OP_std c.base_cr_CO_std c.base_cr_EX_std c.base_cr_AG_std c.base_cr_ES_std c.base_raven_tt c.base_num_tt c.base_lit_tt dalits female imr_noint if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std base_raven_tt base_num_tt base_lit_tt) atmeans  saving(margin_b5_heck_`var'1, replace)

*** Female
qui reg `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_cr_OP_std##i.female c.base_cr_CO_std##i.female c.base_cr_EX_std##i.female c.base_cr_AG_std##i.female c.base_cr_ES_std##i.female c.base_raven_tt##i.female c.base_num_tt##i.female c.base_lit_tt##i.female dalits imr_intfem if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std base_raven_tt base_num_tt base_lit_tt) at(female=(0 1)) atmeans saving(margin_b5_heck_`var'2, replace)



*** Dalits
qui reg `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_cr_OP_std##i.dalits c.base_cr_CO_std##i.dalits c.base_cr_EX_std##i.dalits c.base_cr_AG_std##i.dalits c.base_cr_ES_std##i.dalits c.base_raven_tt##i.dalits c.base_num_tt##i.dalits c.base_lit_tt##i.dalits female imr_intdal if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std base_raven_tt base_num_tt base_lit_tt) at(dalits=(0 1)) atmeans saving(margin_b5_heck_`var'3, replace)



*** Three
qui reg `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_cr_OP_std##i.female##i.dalits c.base_cr_CO_std##i.female##i.dalits c.base_cr_EX_std##i.female##i.dalits c.base_cr_AG_std##i.female##i.dalits c.base_cr_ES_std##i.female##i.dalits c.base_raven_tt##i.female##i.dalits c.base_num_tt##i.female##i.dalits c.base_lit_tt##i.female##i.dalits imr_three if indebt_indiv_2==1, vce(cluster HHFE)
est store res_6

*dy/dx
qui margins, dydx(base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std base_raven_tt base_num_tt base_lit_tt) at(dalits=(0 1) female=(0 1)) atmeans saving(margin_b5_heck_`var'4, replace)
}






















********** 6.
********** Path of debt

foreach var in debtpath {

qui mprobit `var' $big5 $cog $indivcontrol $hhcontrol4 female dalits, vce(cluster HHFE)
est store res_1

qui mprobit `var' $big5 $cog $indivcontrol $hhcontrol4 female dalits $intfem, vce(cluster HHFE)
est store res_2

qui mprobit `var' $big5 $cog $indivcontrol $hhcontrol4 female dalits $intdal, vce(cluster HHFE)
est store res_3

qui mprobit `var' $big5 $cog $indivcontrol $hhcontrol4 female dalits femXdal $intfem $intdal $three, vce(cluster HHFE)
est store res_5

esttab res_1 res_2 res_3 res_5 using "_reg.csv", ///
	cells(b(fmt(3)) /// 
	t(par fmt(3))) ///
	drop() ///
	legend label varlabels(_cons constant) ///
	stats(N ll chi2 p, fmt(0 3 3 3) labels(`"Observations"' `"Log-likelihood"' `"\$\upchi^2$"' `"p-value"')) ///
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
export excel using "MProbit_indebt.xlsx", sheet("`var'_b5", replace)
restore
}

********** Margins
foreach var in debtpath {
*** No int
qui mprobit `var' $indivcontrol $hhcontrol4 c.base_cr_OP_std c.base_cr_CO_std c.base_cr_EX_std c.base_cr_AG_std c.base_cr_ES_std c.base_raven_tt c.base_num_tt c.base_lit_tt dalits female, vce(cluster HHFE)
est store res_6
*dy/dx
margins, dydx(base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std base_raven_tt base_num_tt base_lit_tt) atmeans  saving(margin_b5_`var'1, replace)


*** Female
qui mprobit `var' $indivcontrol $hhcontrol4 c.base_cr_OP_std##i.female c.base_cr_CO_std##i.female c.base_cr_EX_std##i.female c.base_cr_AG_std##i.female c.base_cr_ES_std##i.female c.base_raven_tt##i.female c.base_num_tt##i.female c.base_lit_tt##i.female dalits, vce(cluster HHFE)
est store res_6
*dy/dx
margins, dydx(base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std base_raven_tt base_num_tt base_lit_tt) at(female=(0 1)) atmeans saving(margin_b5_`var'2, replace)

*** Dalits
qui mprobit `var' $indivcontrol $hhcontrol4 c.base_cr_OP_std##i.dalits c.base_cr_CO_std##i.dalits c.base_cr_EX_std##i.dalits c.base_cr_AG_std##i.dalits c.base_cr_ES_std##i.dalits c.base_raven_tt##i.dalits c.base_num_tt##i.dalits c.base_lit_tt##i.dalits female, vce(cluster HHFE)
est store res_6
*dy/dx
margins, dydx(base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std base_raven_tt base_num_tt base_lit_tt) at(dalits=(0 1)) atmeans saving(margin_b5_`var'3, replace)

*** Three
qui mprobit `var' $indivcontrol $hhcontrol4 c.base_cr_OP_std##i.female##i.dalits c.base_cr_CO_std##i.female##i.dalits c.base_cr_EX_std##i.female##i.dalits c.base_cr_AG_std##i.female##i.dalits c.base_cr_ES_std##i.female##i.dalits c.base_raven_tt##i.female##i.dalits c.base_num_tt##i.female##i.dalits c.base_lit_tt##i.female##i.dalits, vce(cluster HHFE)
est store res_6
*dy/dx
margins, dydx(base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std base_raven_tt base_num_tt base_lit_tt) at(dalits=(0 1) female=(0 1)) atmeans saving(margin_b5_`var'4, replace)
}

