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



********** Mean + quantile test
cls
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


/*
Matching ou pas, ca ne change rien car ils sont quasi identiques en moyenne
*/

save"$wave2~matching_v2.dta", replace
clear all
****************************************
* END













****************************************
* Personality traits construction
****************************************
cls
use "$wave2~matching_v2.dta", clear

********** Imputation for non corrected one
global big5cr cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking

foreach x in $big5cr{
gen im`x'=`x'
}

forvalues j=1(1)3{
forvalues i=1(1)2{
foreach x in $big5cr{
qui sum im`x' if sex==`i' & caste==`j' & egoid!=0 & egoid!=.
replace im`x'=r(mean) if im`x'==. & sex==`i' & caste==`j' & egoid!=0 & egoid!=.
}
}
}


********** Macro
global imcor imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm


********** Factor analyses: without grit
minap $imcor
qui factor $imcor, pcf fa(5) // 5
rotate, quartimin
*putexcel set "EFA_2016.xlsx", modify sheet(without)
*putexcel (E2)=matrix(e(r_L))


********** omegacoef with Laajaj approach for factor analysis and Cobb Clark
** F1
global f1 imcr_easilyupset imcr_nervous imcr_feeldepressed imcr_worryalot imcr_changemood imcr_easilydistracted imcr_shywithpeople imcr_putoffduties imcr_rudetoother imcr_repetitivetasks

** F2
global f2 imcr_makeplans imcr_appointmentontime imcr_completeduties imcr_enthusiastic imcr_organized imcr_workhard imcr_workwithother

** F3
global f3 imcr_liketothink imcr_expressingthoughts imcr_activeimagination imcr_sharefeelings imcr_newideas imcr_inventive imcr_curious imcr_talktomanypeople imcr_talkative imcr_understandotherfeeling imcr_interestedbyart

** F4
global f4 imcr_staycalm imcr_managestress
** F5
global f5 imcr_forgiveother imcr_toleratefaults imcr_trustingofother imcr_enjoypeople imcr_helpfulwithothers

*** omegacoef
omegacoef $f1
omegacoef $f2
omegacoef $f3
alpha $f4
omegacoef $f5

*** Score
egen f1_2016=rowmean($f1)
egen f2_2016=rowmean($f2)
egen f3_2016=rowmean($f3)
egen f4_2016=rowmean($f4)
egen f5_2016=rowmean($f5)


save"$wave2~matching_v3.dta", replace
clear all
****************************************
* END






















****************************************
* Test
****************************************
cls
use "$wave2~matching_v3.dta", clear



clear all
****************************************
* END
