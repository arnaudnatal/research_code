cls

/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
March 30, 2022
-----
Stability over time of personality traits
-----

-------------------------
*/


****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
set scheme plotplain

********** Path to folder "data" folder.
*** PC
global directory = "C:\Users\Arnaud\Documents\_Thesis\Research-Stability_skills\Analysis"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

*** Fac
*global directory = "C:\Users\anatal\Downloads\_Thesis\Research-Stability_skills\Analysis"
*cd "$directory"
*global git "C:\Users\anatal\Downloads\GitHub"

********** Name of the NEEMSIS2 questionnaire version to clean
global wave2 "NEEMSIS1-HH"
global wave3 "NEEMSIS2-HH"
****************************************
* END












****************************************
* Matching for demonetisation
****************************************
cls
use "$wave2", clear

********** Initialization
drop if egoid==0

global quali caste sex mainocc_occupation_indiv edulevel
foreach x in $quali {
ta `x', gen(`x'_)
}

global var age caste_1 caste_2 caste_3 sex_1 sex_2 mainocc_occupation_indiv_1 mainocc_occupation_indiv_2 mainocc_occupation_indiv_3 mainocc_occupation_indiv_4 mainocc_occupation_indiv_5 mainocc_occupation_indiv_6 mainocc_occupation_indiv_7 mainocc_occupation_indiv_8 edulevel_1 edulevel_2 edulevel_3 edulevel_4 edulevel_5 edulevel_6

***** yvar
global treat dummydemonetisation


********** CBPS
psweight cbps $treat $var
rename _treated treat_cbps



********** Caliper
qui logit $treat $var
qui predict t_pred, pr
qui sum t_pred
local cal=r(sd)*0.2

psmatch2 $treat $var, common caliper(`cal') noreplacement
rename _treated treat_caliper


********** k neighbor
psmatch2 $treat $var, common n(2)
rename _treated treat_psm

*pstest $var, treated(treat_psm) both
*pstest $var, treated(treat_psm) both graph label
*pstest $var, treated(treat_psm) both scatter





********** Cross
ta $treat treat_cbps, m
ta $treat treat_caliper, m
ta $treat treat_psm, m


********** Mean + quantile test
cls
foreach y in $var {
foreach x in $treat treat_cbps {
qui reg `y' `x'
local t=_b[`x']/_se[`x']
local p=2*ttail(e(df_r),abs(`t'))
dis "`y' -->" `p'
}
}

****************************************
* END
