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
* Matching for lockdown
****************************************
cls
use "$wave3", clear

********** Initialization
drop if egoid==0

global quali caste sex mainocc_occupation_indiv edulevel
foreach x in $quali {
ta `x', gen(`x'_)
}

global var age caste_1 caste_2 caste_3 sex_1 sex_2 mainocc_occupation_indiv_1 mainocc_occupation_indiv_2 mainocc_occupation_indiv_3 mainocc_occupation_indiv_4 mainocc_occupation_indiv_5 mainocc_occupation_indiv_6 mainocc_occupation_indiv_7 mainocc_occupation_indiv_8 edulevel_1 edulevel_2 edulevel_3 edulevel_4 edulevel_5 edulevel_6

***** y var
fre start_HH_quest
gen tos=dofc(start_HH_quest)
format tos %td
ta tos

ta tos if tos<d(01jan2021)
ta tos if tos>d(01jun2021)

gen treattos_6=.
replace treattos_6=0 if tos<d(05apr2021)
replace treattos_6=1 if tos>d(15jun2021)
ta treattos_6
/*
At 6 month diff
*/

global treat treattos_6


********** Mean + quantile test
cls
tabstat $var ,stat(n mean sd) by($treat)
foreach y in $var {
foreach x in $treat {
qui reg `y' `x'
local t=_b[`x']/_se[`x']
local p=2*ttail(e(df_r),abs(`t'))
dis "`y' -->" `p'
}
}



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
pstest $var, treated(treat_caliper) both graph label


********** k neighbor
psmatch2 $treat $var, n(5)
rename _treated treat_psm



********** Cross
ta $treat treat_psm, m
ta $treat treat_cbps, m
ta $treat treat_caliper, m



********** Mean + quantile test
cls
foreach y in $var {
foreach x in $treat treat_psm {
qui reg `y' `x'
local t=_b[`x']/_se[`x']
local p=2*ttail(e(df_r),abs(`t'))
dis "`y' -->" `p'
}
}

****************************************
* END
