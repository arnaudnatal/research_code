cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
July 05, 2021
-----
Personality traits & debt AT INDIVIDUAL LEVEL in long
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
global directory = "D:\Documents\_Thesis\Research-Skills_and_debt\Analysis"
cd"$directory"


*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
*set scheme plotplain

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"



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
use"panel_long_v1.dta", clear


********** Déclaration du panel
xtset panelvar year



********** Macro
*global intfem fem_base_factor_imraw_1_std fem_base_factor_imraw_2_std fem_base_factor_imraw_3_std fem_base_factor_imraw_4_std fem_base_factor_imraw_5_std fem_base_raven_tt fem_base_num_tt fem_base_lit_tt

*global intdal dal_base_factor_imraw_1_std dal_base_factor_imraw_2_std dal_base_factor_imraw_3_std dal_base_factor_imraw_4_std dal_base_factor_imraw_5_std dal_base_raven_tt dal_base_num_tt dal_base_lit_tt

*global three threeway_base_factor_imraw_1_std threeway_base_factor_imraw_2_std threeway_base_factor_imraw_3_std threeway_base_factor_imraw_4_std threeway_base_factor_imraw_5_std threeway_base_raven_tt threeway_base_num_tt threeway_base_lit_tt

*global efa base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std
*global cog base_raven_tt base_num_tt base_lit_tt
global indivcontrol age_1 agesq_1 dummyhead cat_mainoccupation_indiv_1_1 cat_mainoccupation_indiv_1_2 cat_mainoccupation_indiv_1_3 cat_mainoccupation_indiv_1_4 cat_mainoccupation_indiv_1_5 dummyedulevel maritalstatus2_1 dummymultipleoccupation_indiv_1
*global indivcontrol age_1 dummyhead cat_n_mainoccupation_indiv_1_1 cat_n_mainoccupation_indiv_1_2 cat_n_mainoccupation_indiv_1_3 dummyedulevel maritalstatus2_1


global hhcontrol4 assets1000_1 sexratiocat_1_1 sexratiocat_1_2 sexratiocat_1_3 hhsize_1 shock_1 incomeHH1000_1
*global hhcontrol4 assets1000_1 shock_1 incomeHH1000_percapita
global villagesFE near_panruti near_villupur near_tirup near_chengal near_kanchip near_chennai
global big5 base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std



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
probit indebt_indiv_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.female##i.dalits c.base_factor_imraw_2_std##i.female##i.dalits c.base_factor_imraw_3_std##i.female##i.dalits c.base_factor_imraw_4_std##i.female##i.dalits c.base_factor_imraw_5_std##i.female##i.dalits c.base_raven_tt##i.female##i.dalits c.base_num_tt##i.female##i.dalits c.base_lit_tt##i.female##i.dalits, vce(cluster HHvar)

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
* FE
****************************************

********** 01.
********** Deter of evolution of PTCS




xtreg loanamount_indiv c.std_cr_OP##i.female std_cr_CO std_cr_EX std_cr_AG std_cr_ES lit_tt num_tt raven_tt age agesq i.cat_mainoccupation_indiv maritalstatus2 dummymultipleoccupation_indiv assets1000 sexratiocat hhsize shock incomeHH1000 i.relationshiptohead, fe

xtreg loanamount_indiv std_OP std_CO std_EX std_AG std_ES lit_tt num_tt raven_tt age agesq i.cat_mainoccupation_indiv maritalstatus2 dummymultipleoccupation_indiv assets1000 sexratiocat hhsize shock incomeHH1000 i.relationshiptohead, fe


