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
*global directory = "D:\Documents\_Thesis\Research-Skills_and_debt\Analysis"
*cd"$directory"


*Fac
cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
set scheme plotplain, perm

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
use"panel_long_v1.dta", clear


********** Déclaration du panel
xtset panelvar year



********** Macro
global big5raw std_OP std_CO std_EX std_AG std_ES 
global intfemraw fem_std_OP fem_std_CO fem_std_EX fem_std_AG fem_std_ES fem_raven_tt fem_lit_tt fem_num_tt
global intdalraw dal_std_OP dal_std_CO dal_std_EX dal_std_AG dal_std_ES dal_raven_tt dal_lit_tt dal_num_tt
global threeraw threeway_std_OP threeway_std_CO threeway_std_EX threeway_std_AG threeway_std_ES threeway_raven_tt threeway_lit_tt threeway_num_tt

global big5cor std_cr_OP std_cr_CO std_cr_EX std_cr_AG std_cr_ES
global intfemcor fem_std_cr_OP fem_std_cr_CO fem_std_cr_EX fem_std_cr_AG fem_std_cr_ES fem_raven_tt fem_lit_tt fem_num_tt
global intdalcor dal_std_cr_OP dal_std_cr_CO dal_std_cr_EX dal_std_cr_AG dal_std_cr_ES dal_raven_tt dal_lit_tt dal_num_tt
global threecor threeway_std_cr_OP threeway_std_cr_CO threeway_std_cr_EX threeway_std_cr_AG threeway_std_cr_ES threeway_raven_tt threeway_lit_tt threeway_num_tt

global cog raven_tt num_tt lit_tt

global indivcontrol age agesq dummyhead cat_mainoccupation_indiv_1 cat_mainoccupation_indiv_2 cat_mainoccupation_indiv_3 cat_mainoccupation_indiv_4 cat_mainoccupation_indiv_5 dummyedulevel maritalstatus2 dummymultipleoccupation_indiv
global hhcontrol4 assets1000 sexratiocat_1 sexratiocat_2 sexratiocat_3 hhsize shock incomeHH1000
global villagesFE near_panruti near_villupur near_tirup near_chengal near_kanchip near_chennai




********** Interaction terms and margin with FE model:
/*
** Interaction: https://stats.stackexchange.com/questions/151284/interaction-between-time-variant-and-time-invariant-variable-in-fe-model

	I want to estimate the effect of several variables x1,it, x2,it, … on yit. All of these variables vary across countries i and time t. I use OLS to estimate a model with country and year dummies Di and Dt:
	yit=β1x1,it+β2x2,it+γiDi+δtDt+ϵit
	Additionally, I am interested in the moderating effect of a time-invariant variable zi on the relationship between x1,it and yit.
	My intuition is to include ηx1,itzi in the above estimation. While zi does not vary across time, x1,it does and η should pick up the effect of interest.
	Is this intuition correct? If so, are there any caveats? If not, what am I overlooking?

	Your intuition is fine. When you take the partial derivative with respect to x1,it, then you get exactly what you were looking for.
	∂yit∂x1,it=β1+ηzi
	This is particularly convenient if zi is a dummy variable. Wooldridge (2010) "Econometric Analysis of Cross Section and Panel Data" has a similar example where he interacts a time-invariant female dummy with time dummies. So even though one cannot estimate the female coefficient directly, its interaction with the time dummies still has a meaning as it shows the increase in the gender wage gap over time. So what you propose is perfectly valid under the usual assumptions, e.g. zi and x1,it are uncorrelated with the error ϵit.

	
** Margins: https://www.statalist.org/forums/forum/general-stata-discussion/general/1572618-margins-not-estimable-using-fixed-effects

	The predictive margins are, in fact, mathematically not estimable following a fixed-effects regression. That's because fixed-effects regression estimates within-panel effects, and the predictive margins would be between-panel effects. However, the marginal effects are estimable, although Stata does not seem to recognize that. If you add the -noestimcheck- option to the command shown in #6, you will get correct results.
	Do not, however, in other work, indiscriminately use -noestimcheck- whenever Stata says things are not estimable. Stata is usually right when it says that. Use -noestimcheck- only in circumstances, like this one (marginal effects after fixed-effects regression), where the parameters in question really can be estimated. Otherwise, you will get meaningless answers.
*/


****************************************
* END



****************************************
* 
****************************************
********** 01.
********** Not interaction

foreach var in loanamount_indiv1000 DSR_indiv {
xtreg `var' $big5raw $cog $indivcontrol $hhcontrol female dalits, fe vce(cluster HHFE)
est store res_1
xtreg `var' $big5raw $cog $indivcontrol $hhcontrol female dalits $intfemraw, fe vce(cluster HHFE)
est store res_2
xtreg `var' $big5raw $cog $indivcontrol $hhcontrol female dalits $intdalraw, fe vce(cluster HHFE)
est store res_3
xtreg `var' $big5raw $cog $indivcontrol $hhcontrol female dalits $threeraw, fe vce(cluster HHFE)
est store res_4


esttab res_1 res_2 res_3 res_4 using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop() ///
	legend label varlabels(_cons constant) ///
	stats(N N_g corr rho r2 r2_a r2_w r2_o r2_b ll F p F_f p_f, fmt(0 0 3 3 3 3 3 3 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
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
export excel using "FE_indebt.xlsx", sheet("`var'", replace)
restore


********** Margins

*** No int
qui xtreg `var' $big5raw $cog $indivcontrol $hhcontrol dalit female, vce(cluster HHFE)

*dy/dx
margins, dydx($big5raw $cog) atmeans noestimcheck saving(margin_FE_`var'1, replace) 

*** Female
qui xtreg `var' $big5raw $cog $indivcontrol $hhcontrol c.std_OP##i.female c.std_CO##i.female c.std_EX##i.female c.std_AG##i.female c.std_ES##i.female c.raven_tt##i.female c.num_tt##i.female c.lit_tt##i.female, vce(cluster HHFE)

*dy/dx
margins, dydx($big5raw $cog) at(female=(0 1)) atmeans noestimcheck saving(margin_FE_`var'2, replace)

*** Dalits
qui xtreg `var' $big5raw $cog $indivcontrol $hhcontrol c.std_OP##i.dalits c.std_CO##i.dalits c.std_EX##i.dalits c.std_AG##i.dalits c.std_ES##i.dalits c.raven_tt##i.dalits c.num_tt##i.dalits c.lit_tt##i.dalits , vce(cluster HHFE)

*dy/dx
margins, dydx($big5raw $cog) at(dalits=(0 1)) atmeans noestimcheck saving(margin_FE_`var'3, replace)

*** Three
qui xtreg `var' $big5raw $cog $indivcontrol $hhcontrol c.std_OP##i.female##i.dalits c.std_CO##i.female##i.dalits c.std_EX##i.female##i.dalits c.std_AG##i.female##i.dalits c.std_ES##i.female##i.dalits c.raven_tt##i.female##i.dalits c.num_tt##i.female##i.dalits c.lit_tt##i.female##i.dalits , vce(cluster HHFE)

*dy/dx
margins, dydx($big5raw $cog) at(dalits=(0 1) female=(0 1)) atmeans noestimcheck saving(margin_FE_`var'4, replace)
}













