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
*clear all
macro drop _all

* Scheme
*net install schemepack, from("https://raw.githubusercontent.com/asjadnaqvi/Stata-schemes/main/schemes/") replace
*set scheme plotplain
set scheme white_tableau
*set scheme plotplain
grstyle init
grstyle set plain, nogrid


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
* Personality traits construction
****************************************
cls
use "$wave2", clear

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

save"$wave2~matching_v2.dta", replace
*clear all
****************************************
* END













****************************************
* Demonetisation database preparation
****************************************
cls
use "$wave2~matching_v2.dta", clear

********** Initialization
drop if egoid==0

fre mainocc_occupation_indiv
recode mainocc_occupation_indiv (.=0)

global quali caste sex mainocc_occupation_indiv edulevel villageid
foreach x in $quali {
ta `x', gen(`x'_)
}

global var age caste_2 caste_3 sex_2 mainocc_occupation_indiv_1 mainocc_occupation_indiv_2 mainocc_occupation_indiv_4 mainocc_occupation_indiv_5 mainocc_occupation_indiv_6 mainocc_occupation_indiv_7 mainocc_occupation_indiv_8 edulevel_2 edulevel_3 edulevel_4 edulevel_5 edulevel_6

global treat dummydemonetisation

********** Prepare to R
preserve
keep f1_2016 f2_2016 f3_2016 f4_2016 f5_2016 $var $treat villageid_1 villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 HHID_panel INDID_panel egoid cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit lit_tt num_tt raven_tt
rename dummydemonetisation treat 
saveold "N1_CBPS.dta", version(12) replace
restore
****************************************
* END














****************************************
* Reg weight
****************************************
cls
use "neemsis1_r.dta", clear

global var age caste_2 caste_3 sex_2 mainocc_occupation_indiv_1 mainocc_occupation_indiv_2 mainocc_occupation_indiv_4 mainocc_occupation_indiv_5 mainocc_occupation_indiv_6 mainocc_occupation_indiv_7 mainocc_occupation_indiv_8 edulevel_2 edulevel_3 edulevel_4 edulevel_5 edulevel_6


forvalues i=1(1)5 {
reg f`i'_2016 treat $var [pw=weights]
}
****************************************
* END

















****************************************
* ADMS graph
****************************************
cls
use "adsm_n1_r.dta", clear

replace balanced=balanced*100
replace original=original*100

gen la=""
replace la="Age" if covariate=="age"
replace la="Middle" if covariate=="caste_2"
replace la="Upper" if covariate=="caste_3"
replace la="Female" if covariate=="sex_2"
replace la="No occup" if covariate=="mainocc_occupation_indiv_1"
replace la="Agri SE" if covariate=="mainocc_occupation_indiv_2"
replace la="Non-agri casual" if covariate=="mainocc_occupation_indiv_4"
replace la="Non-agri reg non-qualified" if covariate=="mainocc_occupation_indiv_5"
replace la="Non-agri reg qualified" if covariate=="mainocc_occupation_indiv_6"
replace la="Non-agri SE" if covariate=="mainocc_occupation_indiv_7"
replace la="NREGA" if covariate=="mainocc_occupation_indiv_8"
replace la="Primary comp" if covariate=="edulevel_2"
replace la="High school" if covariate=="edulevel_3"
replace la="HSC/Diploma" if covariate=="edulevel_4"
replace la="Bachelors" if covariate=="edulevel_5"
replace la="Post graduate" if covariate=="edulevel_6"

egen labpos=mlabvpos(balanced original)
replace labpos=12 if covariate=="mainocc_occupation_indiv_1"
replace labpos=12 if covariate=="mainocc_occupation_indiv_2"
replace labpos=8 if covariate=="mainocc_occupation_indiv_5"
replace labpos=12 if covariate=="mainocc_occupation_indiv_4"
replace labpos=12 if covariate=="mainocc_occupation_indiv_7"
replace labpos=12 if covariate=="caste_2"
replace labpos=12 if covariate=="caste_3"

replace labpos=6 if covariate=="edulevel_2"
replace labpos=12 if covariate=="edulevel_3"
replace labpos=6 if covariate=="edulevel_5"
replace labpos=12 if covariate=="edulevel_6"

twoway scatter balanced original, mlabel(la) mlabvpos(labpos) ///
xlabel(0(10)60) xmtick(0(5)65) xtitle("ADSM before weighting (%)") ///
ylabel(0(1)8) ymtick(0(.5)8) ytitle("ADSM after weighting (%)") ///
name(adsm, replace)
graph save "adsm.gph", replace
****************************************
* END
