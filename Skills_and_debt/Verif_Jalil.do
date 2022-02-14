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

tab debtpath

/*
********** Vérification instrument pour procédure Heckman
*** Debtor ratio
reg c.debtorratio2_2 i.indebt_indiv_2
est store indebt
reg c.debtorratio2_2 c.loanamount_indiv1000_2
est store loan
reg c.debtorratio2_2 c.DSR_indiv_2
est store dsr

esttab indebt loan dsr using "_reg.csv", ///
	cells(b(fmt(3)) /// 
	t(par fmt(3))) ///
	drop() ///
	legend label varlabels(_cons constant) ///
	stats(N r2 r2_a F p, fmt(0 3 3 3 3 3)) ///
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
export excel using "IMR_check.xlsx", sheet("IMR", replace)
restore


***Graph
set graph off
twoway (scatter debtorratio2_2 indebt_indiv_2, msize(*0.5)), xlabel(0(1)1, labsize(vsmall)) ylabel(,labsize(vsmall)) xmtick(-.5(2)1.5) ytitle("Debtor ratio", size(small)) xtitle("Indebted (=1)", size(small)) note("t-stat=-8.55", size(vsmall)) name(g_indebt1, replace)
twoway (scatter debtorratio2_2 indebt_indiv_2 if debtorratio2_2<1, msize(*0.5)), xlabel(0(1)1, labsize(vsmall)) ylabel(,labsize(vsmall)) xmtick(-.5(2)1.5) ytitle("Debtor ratio", size(small)) xtitle("Indebted (=1)", size(small)) note("If debtor ratio<1", size(vsmall)) name(g_indebt2, replace)
twoway (scatter debtorratio2_2 loanamount_indiv1000_2, msize(*0.5)), xlabel(0(400)2600, labsize(vsmall)) ylabel(,labsize(vsmall)) ytitle("Debtor ratio", size(small)) xtitle("Loan amount (1,000 INR)", size(small)) note("Correlation = -0.02, p-value=0.54", size(vsmall)) name(g_loan1, replace)
twoway (scatter debtorratio2_2 loanamount_indiv1000_2 if loanamount_indiv1000_2<400, msize(*0.5)), xlabel(0(50)400, labsize(vsmall)) ylabel(,labsize(vsmall)) ytitle("Debtor ratio", size(small)) xtitle("Loan amount (1,000 INR)", size(small)) note("If loan amount<400", size(vsmall)) name(g_loan2, replace)
twoway (scatter debtorratio2_2 DSR_indiv_2, msize(*0.5)), xlabel(0(1000)6000, labsize(vsmall)) ylabel(,labsize(vsmall)) ytitle("Debtor ratio", size(small)) xtitle("Debt service ratio", size(small)) note("Correlation = 0.01, p-value=0.72", size(vsmall)) name(g_dsr1, replace)
twoway (scatter debtorratio2_2 DSR_indiv_2 if DSR_indiv_2<500, msize(*0.5)), xlabel(0(50)500, labsize(vsmall)) ylabel(,labsize(vsmall)) ytitle("Debtor ratio", size(small)) xtitle("Debt service ratio", size(small)) note("If DSR<500", size(vsmall)) name(g_dsr2, replace)

graph combine g_indebt1 g_indebt2 g_loan1 g_loan2 g_dsr1 g_dsr2, col(2)
graph export "$git\RUME-NEEMSIS\Big-5\imr_check.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\imr_check.pdf", as(pdf) replace
set graph on
*/


********** Macro
global intfem fem_base_factor_imraw_1_std fem_base_factor_imraw_2_std fem_base_factor_imraw_3_std fem_base_factor_imraw_4_std fem_base_factor_imraw_5_std fem_base_raven_tt fem_base_num_tt fem_base_lit_tt

global intdal dal_base_factor_imraw_1_std dal_base_factor_imraw_2_std dal_base_factor_imraw_3_std dal_base_factor_imraw_4_std dal_base_factor_imraw_5_std dal_base_raven_tt dal_base_num_tt dal_base_lit_tt

global three threeway_base_factor_imraw_1_std threeway_base_factor_imraw_2_std threeway_base_factor_imraw_3_std threeway_base_factor_imraw_4_std threeway_base_factor_imraw_5_std threeway_base_raven_tt threeway_base_num_tt threeway_base_lit_tt

global efa base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std
global cog base_raven_tt base_num_tt base_lit_tt
global indivcontrol age_1 agesq_1 dummyhead_1 cat_mainoccupation_indiv_1_1 cat_mainoccupation_indiv_1_2 cat_mainoccupation_indiv_1_3 cat_mainoccupation_indiv_1_4 cat_mainoccupation_indiv_1_5 dummyedulevel maritalstatus2_1 dummymultipleoccupation_indiv_1
*global indivcontrol age_1 dummyhead_1 cat_n_mainoccupation_indiv_1_1 cat_n_mainoccupation_indiv_1_2 cat_n_mainoccupation_indiv_1_3 dummyedulevel maritalstatus2_1


global hhcontrol4 assets1000_1 sexratiocat_1_1 sexratiocat_1_2 sexratiocat_1_3 hhsize_1 shock_1 incomeHH1000_1
*global hhcontrol4 assets1000_1 shock_1 incomeHH1000_percapita
global villagesFE near_panruti near_villupur near_tirup near_chengal near_kanchip near_chennai
global big5 base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std



********** Label
forvalues i=1(1)5{
label var fem_base_factor_imraw_`i'_std "Female X Factor `i' (std)"
label var dal_base_factor_imraw_`i'_std "Dalit X Factor `i' (std)"
label var threeway_base_factor_imraw_`i'_std "Dalit X Female X Factor `i' (std)"
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




********** Interpretation
/*

*Type 2
margins, dydx(base_factor_imraw_1_std) at(dalits=(0 1) female=(0 1))
/*
-----------------------------------------------------------------------------------
                  |            Delta-method
                  |      dy/dx   Std. Err.      t    P>|t|     [95% Conf. Interval]
------------------+----------------------------------------------------------------
base_factor_imraw_1_std |
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
margins, at(base_factor_imraw_1_std=(-3 (0.25) 3) dalits=(0 1) female=(0 1))
marginsplot, yline(0)

*/

/*
- Incidence de la dette avec la proba d'être endetté (1)
- Profondeur de la dette avec le loan amount & le DSR / SHDI (2)
- Fardeau de la dette avec le pb to repay, help to settle, services, repayment (4)
*/

/*
Margins dydx
OLS:
Slope, as B coefficient
Quand la personality/le score au raven, etc. augmente d'1 point, l'endettement varie de coef points.

Probit:
X cont = Quand la personality augmente d'un point, la proba d'être endetté augmente/diminue de coef*100 percentage points.
X dich = Etre ça plutôt que ça augmente/diminue la proba d'être endetté de coef*100 pp
*/



/*
********** Modèle
*1. Estimation
probit indebt_indiv_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.female##i.dalits c.base_factor_imraw_2_std##i.female##i.dalits c.base_factor_imraw_3_std##i.female##i.dalits c.base_factor_imraw_4_std##i.female##i.dalits c.base_factor_imraw_5_std##i.female##i.dalits c.base_raven_tt##i.female##i.dalits c.base_num_tt##i.female##i.dalits c.base_lit_tt##i.female##i.dalits, vce(cluster HHFE)

*2. Voir les pentes de mes var d'int en fonction des groupes (dalits, female)
qui margins, at(dalits=(0 1) female=(0 1) base_factor_imraw_1_std=(-3 3))  
marginsplot

*3. Coef des pentes pour mes var
margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) at(dalits=(0 1) female=(0 1))  saving(margin_indebt_indiv, replace) post

*4. Tester égalités ou pas des coef
margins, coeflegend
test _b[base_factor_imraw_1_std:1bn._at]=_b[base_factor_imraw_1_std:2._at]=_b[base_factor_imraw_1_std:3._at]=_b[base_factor_imraw_1_std:4._at]

*test (_b[base_factor_imraw_1_std:1bn._at]=_b[base_factor_imraw_1_std:2._at]) ()
*/

****************************************
* END












****************************************
* Preliminary analysis
****************************************

********** 0.
********** Deter of evolution of PTCS
*log using c:evoperso.log, replace
tab username
*
foreach x in CO OP EX ES AG {
reg delta_`x' c.age_1 i.sex_1 ib(freq).username ib(freq).villageid2016FE ib(freq).caste, baselevels
}
*
foreach x in CO OP EX ES AG {
reg delta_`x' c.age_1 i.sex_1 i.username i.villageid if age_1<30
reg delta_`x' c.age_1 i.sex_1 i.username i.villageid if age_1>=30
}
*log close



********** 101.
********** delta
tabstat delta_loanamount_indiv delta_DSR_indiv delta_ISR_indiv delta_goldquantity delta_loans_indiv, stat(n mean min p1 p5 p10 q p90 p95 p99 max) 
tab debtpath
*
preserve
foreach x in delta_loanamount_indiv delta_DSR_indiv delta_ISR_indiv delta_goldquantity delta_loans_indiv {
pctile `x'_p=`x',n(100)
}
gen n=_n
replace n=. if n>100
*Graph
/*
twoway ///
(line delta_loanamount_indiv_p n if delta_loanamount_indiv_p>-500 & delta_loanamount_indiv_p<500, yline(0)) ///
(line delta_DSR_indiv_p n if delta_DSR_indiv_p>-500 & delta_DSR_indiv_p<500) ///
(line delta_ISR_indiv_p n if delta_ISR_indiv_p>-500 & delta_ISR_indiv_p<500) ///
(line delta_loans_indiv_p n if delta_loans_indiv_p>-500 & delta_loans_indiv_p<500) ///
, xtitle("Percentage of population", size(small)) xlabel(0(10)100, labsize(vsmall)) xmtick(0(5)100) ///
 ytitle("Delta", size(small)) ylabel(-400(200)600, labsize(vsmall)) ymtick(-400(50)600) ///
legend(order(1 "Loan amount" 2 "DSR" 3 "ISR" 4 "Number of loans") pos(6) col(4) size(small))
*/
restore
cls
*log using c:delta.log, replace
foreach x in delta_loanamount_indiv delta_DSR_indiv delta_ISR_indiv delta_loans_indiv {
reg `x' $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three, vce(cluster HHFE)
qui reg `x' $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.female##i.dalits c.base_factor_imraw_2_std##i.female##i.dalits c.base_factor_imraw_3_std##i.female##i.dalits c.base_factor_imraw_4_std##i.female##i.dalits c.base_factor_imraw_5_std##i.female##i.dalits c.base_raven_tt##i.female##i.dalits c.base_num_tt##i.female##i.dalits c.base_lit_tt##i.female##i.dalits, vce(cluster HHFE)
margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt) at(dalits=(0 1) female=(0 1)) 
}
*log close

****************************************
* END