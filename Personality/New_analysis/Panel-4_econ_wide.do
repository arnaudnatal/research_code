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
global directory = "D:\Documents\_Thesis\Research-Skills_and_debt\New_analysis"
cd"$directory"

********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH_v7"
global wave3 "NEEMSIS2-HH_v16"


********** Stata package

*coefplot, horizontal xline(0) drop(_cons) levels(95 90 ) ciopts(recast(. rcap))mlabel mlabposition(12) mlabgap(*2)

****************************************
* END













****************************************
* Analysis : debt with interaction
****************************************
use"panel_wide_v3.dta", clear

/*
predict probitxb_`cat', xb
ge pdf_`cat'=normalden(probitxb_`cat')
ge cdf_`cat'=normal(probitxb_`cat')
ge imr_`cat'=pdf_`cat'/cdf_`cat'
*/


********** Interaction pour sous échantillon car pas bon du tout
fre caste2
gen dalits=0 if caste2==2
replace dalits=1 if caste2==1
tab dalits female
label var dalits "Dalits (=1)"

foreach x in base_nocorrf1_std base_nocorrf2_std base_nocorrf3_std base_nocorrf4_std base_nocorrf5_std base_raven_tt base_num_tt base_lit_tt {
gen fem_`x'=`x'*female
gen dal_`x'=`x'*dalits
gen threeway_`x'=`x'*female*dalits
}
gen femXdal=female*dalits



tab segmana

global intfem fem_base_nocorrf1_std fem_base_nocorrf2_std fem_base_nocorrf3_std fem_base_nocorrf4_std fem_base_nocorrf5_std fem_base_raven_tt fem_base_num_tt fem_base_lit_tt

global intdal dal_base_nocorrf1_std dal_base_nocorrf2_std dal_base_nocorrf3_std dal_base_nocorrf4_std dal_base_nocorrf5_std dal_base_raven_tt dal_base_num_tt dal_base_lit_tt

global three threeway_base_nocorrf1_std threeway_base_nocorrf2_std threeway_base_nocorrf3_std threeway_base_nocorrf4_std threeway_base_nocorrf5_std threeway_base_raven_tt threeway_base_num_tt threeway_base_lit_tt

global efa base_nocorrf1_std base_nocorrf2_std base_nocorrf3_std base_nocorrf4_std base_nocorrf5_std
global cog base_raven_tt base_num_tt base_lit_tt
global indivcontrol age_1 agesq_1 dummyhead cat_mainoccupation_indiv_1_1 cat_mainoccupation_indiv_1_2 cat_mainoccupation_indiv_1_3 cat_mainoccupation_indiv_1_4 cat_mainoccupation_indiv_1_5 dummyedulevel maritalstatus2_1 dummymultipleoccupation_indiv_1
*global indivcontrol age_1 dummyhead cat_n_mainoccupation_indiv_1_1 cat_n_mainoccupation_indiv_1_2 cat_n_mainoccupation_indiv_1_3 dummyedulevel maritalstatus2_1


global hhcontrol4 assets1000_1 sexratiocat_1_1 sexratiocat_1_2 sexratiocat_1_3 hhsize_1 shock_1 incomeHH1000_1
*global hhcontrol4 assets1000_1 shock_1 incomeHH1000_percapita
global villagesFE near_panruti near_villupur near_tirup near_chengal near_kanchip near_chennai
global big5 base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std


********** 1.
********** Proba of being in debt, or overindebted, interest in t+1

qui probit indebt_indiv_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits, vce(cluster HHvar)
est store res_`cat'1

qui probit indebt_indiv_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem, vce(cluster HHvar)
est store res_`cat'2

qui probit indebt_indiv_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal, vce(cluster HHvar)
est store res_`cat'3

qui probit indebt_indiv_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem $intdal, vce(cluster HHvar)
est store res_`cat'4

qui probit indebt_indiv_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three, vce(cluster HHvar)
est store res_`cat'5

qui probit indebt_indiv_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE i.segmana##c.base_nocorrf1_std i.segmana##c.base_nocorrf2_std i.segmana##c.base_nocorrf3_std i.segmana##c.base_nocorrf4_std i.segmana##c.base_nocorrf5_std i.segmana##c.base_raven_tt i.segmana##c.base_num_tt i.segmana##c.base_lit_tt, vce(cluster HHvar)
est store res_`cat'6

esttab res_* using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop($indivcontrol $hhcontrol4 $villagesFE) ///
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
export excel using "Probit_indebt.xlsx", sheet("Indebt", replace)
restore






********** 2.
********** Proba of being overindebted, interest in t+1
foreach var in dummyproblemtorepay_indiv dummyhelptosettleloan_indiv sum_settleloanstrategy_3_r sum_settleloanstrategy_7_r sum_settleloanstrategy_8_r sum_plantorepay_6_r sum_borrowerservices_3_r {

qui probit `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits if indebt_indiv_2==1, vce(cluster HHvar)
est store res_`cat'1

qui probit `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem if indebt_indiv_2==1, vce(cluster HHvar)
est store res_`cat'2

qui probit `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal if indebt_indiv_2==1, vce(cluster HHvar)
est store res_`cat'3

qui probit `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem $intdal if indebt_indiv_2==1, vce(cluster HHvar)
est store res_`cat'4

qui probit `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three if indebt_indiv_2==1, vce(cluster HHvar)
est store res_`cat'5

**************************
qui probit `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits if indebt_indiv_2==1 & indebt_indiv_1==1, vce(cluster HHvar)
est store res_`cat'6

qui probit `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem if indebt_indiv_2==1 & indebt_indiv_1==1, vce(cluster HHvar)
est store res_`cat'7

qui probit `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal if indebt_indiv_2==1 & indebt_indiv_1==1, vce(cluster HHvar)
est store res_`cat'8

qui probit `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem $intdal if indebt_indiv_2==1 & indebt_indiv_1==1, vce(cluster HHvar)
est store res_`cat'9

qui probit `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three if indebt_indiv_2==1 & indebt_indiv_1==1, vce(cluster HHvar)
est store res_`cat'10


esttab res_* using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop($indivcontrol $hhcontrol4 $villagesFE) ///
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
}



********** Three way test
reg loanamount_indiv1000_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three if indebt_indiv_2==1, vce(cluster HHvar)


reg loanamount_indiv1000_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_nocorrf1_std##i.dalits##i.female c.base_nocorrf2_std##i.dalits##i.female c.base_nocorrf3_std##i.dalits##i.female c.base_nocorrf4_std##i.dalits##i.female c.base_nocorrf5_std##i.dalits##i.female c.base_raven_tt##i.dalits##i.female c.base_num_tt##i.dalits##i.female c.base_lit_tt##i.dalits##i.female if indebt_indiv_2==1, vce(cluster HHvar) // allbaselevels

*Type 2
margins, dydx(base_nocorrf1_std) at(dalits=(0 1) female=(0 1))
/*
-----------------------------------------------------------------------------------
                  |            Delta-method
                  |      dy/dx   Std. Err.      t    P>|t|     [95% Conf. Interval]
------------------+----------------------------------------------------------------
base_nocorrf1_std |
              _at |
            MUCM  |   47.33951   21.54482     2.20   0.029     4.994621     89.6844
            MUCW  |   13.23904   11.95436     1.11   0.269    -10.25645    36.73453
         DalitsM  |  -7.209672   11.91426    -0.61   0.545    -30.62635    16.20701
         DalitsW  |   13.08039   6.689882     1.96   0.051    -.0681177    26.22891
-----------------------------------------------------------------------------------
valeur du coefficient 
*/
marginsplot

*Type 3
set scheme plottig
margins, at(base_nocorrf1_std=(-3 (0.25) 3) dalits=(0 1) female=(0 1))
margins, at(dalits=(0 1) female=(0 1)base_nocorrf1_std=(-3 3) )

marginsplot, yline(0)




reg loanamount_indiv1000_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_nocorrf1_std##i.dalits##i.female c.base_nocorrf2_std##i.dalits##i.female c.base_nocorrf3_std##i.dalits##i.female c.base_nocorrf4_std##i.dalits##i.female c.base_nocorrf5_std##i.dalits##i.female c.base_raven_tt##i.dalits##i.female c.base_num_tt##i.dalits##i.female c.base_lit_tt##i.dalits##i.female if indebt_indiv_2==1, vce(cluster HHvar) // allbaselevels




/*
valeurs de Y pour tel groupe
*/

reg loanamount_indiv1000_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE i.female c.base_nocorrf1_std##i.dalits c.base_nocorrf2_std##i.dalits c.base_nocorrf3_std##i.dalits c.base_nocorrf4_std##i.dalits c.base_nocorrf5_std##i.dalits c.base_raven_tt##i.dalits c.base_num_tt##i.dalits c.base_lit_tt##i.dalits if indebt_indiv_2==1, vce(cluster HHvar) // allbaselevels

margins, dydx(base_nocorrf1_std) at(dalits=(0 1))
margins, dydx(base_nocorrf1_std) at(dalits=(0 1) female=(0 1))



probit dummyproblemtorepay_indiv_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE i.female c.base_nocorrf1_std##i.dalits c.base_nocorrf2_std##i.dalits c.base_nocorrf3_std##i.dalits c.base_nocorrf4_std##i.dalits c.base_nocorrf5_std##i.dalits c.base_raven_tt##i.dalits c.base_num_tt##i.dalits c.base_lit_tt##i.dalits c.base_nocorrf1_std##i.female c.base_nocorrf2_std##i.female c.base_nocorrf3_std##i.female c.base_nocorrf4_std##i.female c.base_nocorrf5_std##i.female c.base_raven_tt##i.female c.base_num_tt##i.female c.base_lit_tt##i.female if indebt_indiv_2==1, vce(cluster HHvar) // allbaselevels

margins, dydx(base_nocorrf1_std) at(dalits=(0 1) female=(0 1))
margins, dydx(base_nocorrf2_std) at(dalits=(0 1) female=(0 1))
margins, dydx(base_nocorrf3_std) at(dalits=(0 1) female=(0 1))
margins, dydx(base_nocorrf4_std) at(dalits=(0 1) female=(0 1))
margins, dydx(base_nocorrf5_std) at(dalits=(0 1) female=(0 1))
margins, dydx(base_raven_tt) at(dalits=(0 1) female=(0 1))
margins, dydx(base_num_tt) at(dalits=(0 1) female=(0 1))
margins, dydx(base_lit_tt) at(dalits=(0 1) female=(0 1))





********** 3.
********** Level of debt in t+1
 
foreach var in loanamount_indiv1000 {

qui reg `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits if indebt_indiv_2==1, vce(cluster HHvar)
est store res_`cat'1

qui reg `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem if indebt_indiv_2==1, vce(cluster HHvar)
est store res_`cat'2

qui reg `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal if indebt_indiv_2==1, vce(cluster HHvar)
est store res_`cat'3

qui reg `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem $intdal if indebt_indiv_2==1, vce(cluster HHvar)
est store res_`cat'4

qui reg `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_nocorrf1##i.dalits##i.female c.base_nocorrf2##i.dalits##i.female c.base_nocorrf3##i.dalits##i.female c.base_nocorrf4##i.dalits##i.female c.base_nocorrf5##i.dalits##i.female c.base_raven_tt##i.dalits##i.female c.base_num_tt##i.dalits##i.female c.base_lit_tt##i.dalits##i.female if indebt_indiv_2==1, vce(cluster HHvar)
est store res_`cat'5

**************************
qui reg `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits if indebt_indiv_2==1 & indebt_indiv_1==1, vce(cluster HHvar)
est store res_`cat'6

qui reg `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem if indebt_indiv_2==1 & indebt_indiv_1==1, vce(cluster HHvar)
est store res_`cat'7

qui reg `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal if indebt_indiv_2==1 & indebt_indiv_1==1, vce(cluster HHvar)
est store res_`cat'8

qui reg `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem $intdal if indebt_indiv_2==1 & indebt_indiv_1==1, vce(cluster HHvar)
est store res_`cat'9

qui reg `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three if indebt_indiv_2==1 & indebt_indiv_1==1, vce(cluster HHvar)
est store res_`cat'10

esttab res_* using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop($indivcontrol $hhcontrol4 $villagesFE) ///	
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

}








********** 4.
********** Level of debt in t+1

foreach var in debtshare InformR_indiv NoincogenR_indiv {

qui glm `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits if indebt_indiv_2==1, fam(bin) link(logit) vce(cluster HHvar)
est store res_`cat'1

qui glm `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem if indebt_indiv_2==1, fam(bin) link(logit) vce(cluster HHvar)
est store res_`cat'2

qui glm `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal if indebt_indiv_2==1, fam(bin) link(logit) vce(cluster HHvar)
est store res_`cat'3

qui glm `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem $intdal if indebt_indiv_2==1, fam(bin) link(logit) vce(cluster HHvar)
est store res_`cat'4

qui glm `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three if indebt_indiv_2==1, fam(bin) link(logit) vce(cluster HHvar)
est store res_`cat'5

**************************
qui glm `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits if indebt_indiv_2==1 & indebt_indiv_1==1, fam(bin) link(logit) vce(cluster HHvar)
est store res_`cat'6

qui glm `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem if indebt_indiv_2==1 & indebt_indiv_1==1, fam(bin) link(logit) vce(cluster HHvar)
est store res_`cat'7

qui glm `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal if indebt_indiv_2==1 & indebt_indiv_1==1, fam(bin) link(logit) vce(cluster HHvar)
est store res_`cat'8

qui glm `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem $intdal if indebt_indiv_2==1 & indebt_indiv_1==1, fam(bin) link(logit) vce(cluster HHvar)
est store res_`cat'9

qui glm `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three if indebt_indiv_2==1 & indebt_indiv_1==1, fam(bin) link(logit) vce(cluster HHvar)
est store res_`cat'10

esttab res_* using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop($indivcontrol $hhcontrol4 $villagesFE) ///	
	legend label varlabels(_cons constant) ///
	stats(N chi2 p deviance ic, fmt(0 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
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
export excel using "GLM_indebt.xlsx", sheet("`var'", replace)
restore

}






********** 5.
********** Level of debt in t+1

foreach var in loans_indiv dummyinterest_indiv {

qui poisson `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits if indebt_indiv_2==1, vce(cluster HHvar)
est store res_`cat'1

qui poisson `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem if indebt_indiv_2==1, vce(cluster HHvar)
est store res_`cat'2

qui poisson `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal if indebt_indiv_2==1, vce(cluster HHvar)
est store res_`cat'3

qui poisson `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem $intdal if indebt_indiv_2==1, vce(cluster HHvar)
est store res_`cat'4

qui poisson `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three if indebt_indiv_2==1, vce(cluster HHvar)
est store res_`cat'5

**************************
qui poisson `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits if indebt_indiv_2==1 & indebt_indiv_1==1, vce(cluster HHvar)
est store res_`cat'6

qui poisson `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem if indebt_indiv_2==1 & indebt_indiv_1==1, vce(cluster HHvar)
est store res_`cat'7

qui poisson `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal if indebt_indiv_2==1 & indebt_indiv_1==1, vce(cluster HHvar)
est store res_`cat'8

qui poisson `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem $intdal if indebt_indiv_2==1 & indebt_indiv_1==1, vce(cluster HHvar)
est store res_`cat'9

qui poisson `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three if indebt_indiv_2==1 & indebt_indiv_1==1, vce(cluster HHvar)
est store res_`cat'10


esttab res_* using "_reg.csv", ///
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
}

****************************************
* END




















































****************************************
* Analysis : debt with sub sample
****************************************
use"panel_wide_v3.dta", clear


global efa base_nocorrf1_std base_nocorrf2_std base_nocorrf3_std base_nocorrf4_std base_nocorrf5_std
global cog base_raven_tt base_num_tt base_lit_tt
global indivcontrol age_1 agesq_1 dummyhead cat_mainoccupation_indiv_1_1 cat_mainoccupation_indiv_1_2 cat_mainoccupation_indiv_1_3 cat_mainoccupation_indiv_1_4 cat_mainoccupation_indiv_1_5 dummyedulevel maritalstatus2_1 dummymultipleoccupation_indiv_1
*global indivcontrol age_1 dummyhead cat_n_mainoccupation_indiv_1_1 cat_n_mainoccupation_indiv_1_2 cat_n_mainoccupation_indiv_1_3 dummyedulevel maritalstatus2_1


global hhcontrol4 assets1000_1 sexratiocat_1_1 sexratiocat_1_2 sexratiocat_1_3 hhsize_1 shock_1 incomeHH1000_1
*global hhcontrol4 assets1000_1 shock_1 incomeHH1000_percapita
global villagesFE near_panruti near_villupur near_tirup near_chengal near_kanchip near_chennai
global big5 base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std


/*
*** Faible puissance statistique quand segmentation+double dette, combien de égos par HH ?
tab indebt_indiv_1 indebt_indiv_2
tab segmana 
tab segmana if  indebt_indiv_2==1
tab segmana if  indebt_indiv_2==1 & indebt_indiv_1==1
*Total at 835
preserve
gen dw=1 if segmana==1
gen dm=1 if segmana==2
gen mucw=1 if segmana==3
gen mucm=1 if segmana==4
foreach x in dw dm mucw mucm {
bysort HHID_panel: egen sum_`x'=sum(`x')
}
duplicates drop HHID_panel, force
tab1 sum_dw sum_dm sum_mucw sum_mucm
restore

*Total at 606
preserve
gen dw=1 if indebt_indiv_2==1 & segmana==1
gen dm=1 if indebt_indiv_2==1 & segmana==2
gen mucw=1 if indebt_indiv_2==1 & segmana==3
gen mucm=1 if indebt_indiv_2==1 & segmana==4
foreach x in dw dm mucw mucm {
bysort HHID_panel: egen sum_`x'=sum(`x')
}
duplicates drop HHID_panel, force
tab1 sum_dw sum_dm sum_mucw sum_mucm
restore

preserve
keep if indebt_indiv_2==1
duplicates drop HHID_panel, force
restore

*Total at 516
preserve
gen dw=1 if indebt_indiv_2==1 & indebt_indiv_1==1 & segmana==1
gen dm=1 if indebt_indiv_2==1 & indebt_indiv_1==1 & segmana==2
gen mucw=1 if indebt_indiv_2==1 & indebt_indiv_1==1 & segmana==3
gen mucm=1 if indebt_indiv_2==1 & indebt_indiv_1==1 & segmana==4
foreach x in dw dm mucw mucm {
bysort HHID_panel: egen sum_`x'=sum(`x')
}
duplicates drop HHID_panel, force
tab1 sum_dw sum_dm sum_mucw sum_mucm
list HHID_panel if sum_dw==2 | sum_dm==2 | sum_mucw==2 | sum_mucm==2, clean noobs
restore

preserve
keep if indebt_indiv_2==1 & indebt_indiv_1==1
duplicates drop HHID_panel, force
tab caste
restore
/*
KOR1	 
NAT36	 
ORA22	 
ORA7	 
SEM45
*/
*/



/*
predict probitxb_`cat', xb
ge pdf_`cat'=normalden(probitxb_`cat')
ge cdf_`cat'=normal(probitxb_`cat')
ge imr_`cat'=pdf_`cat'/cdf_`cat'
*/


*Quelle stat affichée ?
*reg loanamount_indiv1000_2 loanamount_indiv1000_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==3, vce(cluster HHvar)
*matlist r(table)


********** 1.
********** Proba of being in debt, or overindebted, interest in t+1
foreach cat in 1 2 3 4 {
qui probit indebt_indiv_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat', vce(cluster HHvar)
est store res_`cat'3

predict probitxb_`cat', xb
ge pdf_`cat'=normalden(probitxb_`cat')
ge cdf_`cat'=normal(probitxb_`cat')
ge imr_`cat'=pdf_`cat'/cdf_`cat'
}

esttab res_* using "_reg.csv", ///
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
export excel using "Probit_indebt.xlsx", sheet("Indebt", replace)
restore



********** 2.
********** Proba of being overindebted, interest in t+1
foreach var in over30_indiv over40_indiv dummyproblemtorepay_indiv dummyhelptosettleloan_indiv sum_settleloanstrategy_3_r sum_settleloanstrategy_7_r sum_settleloanstrategy_8_r sum_plantorepay_6_r {

foreach cat in 1 2 3 4 {

qui probit `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat' & indebt_indiv_2==1, vce(cluster HHvar)
est store res_`cat'1

qui probit `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat' & indebt_indiv_2==1
est store res_`cat'2

qui probit `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat' & indebt_indiv_2==1 & indebt_indiv_1==1, vce(cluster HHvar)
est store res_`cat'3

qui probit `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat' & indebt_indiv_2==1 & indebt_indiv_1==1
est store res_`cat'4
}

esttab res_* using "_reg.csv", ///
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
}

tab sum_borrowerservices_1_r_2 segmana if indebt_indiv_2==1
tab sum_borrowerservices_2_r_2 segmana if indebt_indiv_2==1
tab sum_borrowerservices_3_r_2 segmana if indebt_indiv_2==1

foreach var in sum_borrowerservices_3_r {

foreach cat in 1 2 3 4 {
qui probit `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat' & indebt_indiv_2==1, vce(cluster HHvar)
est store res_`cat'1

qui probit `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat' & indebt_indiv_2==1
est store res_`cat'2


}

esttab res_* using "_reg.csv", ///
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
}




********** 3.
********** Level of debt in t+1
 
foreach var in loanamount_indiv1000 DSR_indiv {

foreach cat in 1 2 3 4 {

qui reg `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat' & indebt_indiv_2==1, vce(cluster HHvar)
est store res_`cat'1

qui reg `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat' & indebt_indiv_2==1
est store res_`cat'2

qui reg `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat' & indebt_indiv_2==1 & indebt_indiv_1==1, vce(cluster HHvar)
est store res_`cat'3

qui reg `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat' & indebt_indiv_2==1 & indebt_indiv_1==1
est store res_`cat'4
}

esttab res_* using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop() ///	
	legend label varlabels(_cons constant) ///
	stats(N r2 r2_a F, fmt(0 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
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

}









********** 4.
********** Level of debt in t+1

foreach var in debtshare InformR_indiv NoincogenR_indiv {

foreach cat in 1 2 3 4 {
qui glm `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat' & indebt_indiv_2==1, fam(bin) link(logit) vce(cluster HHvar)
est store res_`cat'1

qui glm `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat' & indebt_indiv_2==1, fam(bin) link(logit)
est store res_`cat'2

qui glm `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat' & indebt_indiv_2==1 & indebt_indiv_1==1, fam(bin) link(logit) vce(cluster HHvar)
est store res_`cat'3

qui glm `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat' & indebt_indiv_2==1 & indebt_indiv_1==1, fam(bin) link(logit)
est store res_`cat'4
}

esttab res_* using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop() ///	
	legend label varlabels(_cons constant) ///
	stats(N chi2 p deviance ic, fmt(0 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
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
export excel using "GLM_indebt.xlsx", sheet("`var'", replace)
restore

}






********** 5.
********** Level of debt in t+1

foreach var in loans_indiv dummyinterest_indiv {

foreach cat in 1 2 3 4 {
qui poisson `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat' & indebt_indiv_2==1, vce(cluster HHvar)
est store res_`cat'1

qui poisson `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat' & indebt_indiv_2==1
est store res_`cat'2

qui poisson `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat' & indebt_indiv_2==1  & indebt_indiv_1==1, vce(cluster HHvar)
est store res_`cat'3

qui poisson `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat' & indebt_indiv_2==1  & indebt_indiv_1==1
est store res_`cat'4
}

esttab res_* using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop() ///
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
}

****************************************
* END
