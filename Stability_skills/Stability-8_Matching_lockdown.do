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

*set scheme black_tableau
*set scheme swift_red

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
use "$wave3", clear

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
*putexcel set "EFA_2020.xlsx", modify sheet(without)
*putexcel (E2)=matrix(e(r_L))


********** omegacoef with Laajaj approach for factor analysis and Cobb Clark
** F1
global f1 imcr_worryalot imcr_easilydistracted imcr_feeldepressed imcr_easilyupset imcr_changemood imcr_nervous imcr_repetitivetasks imcr_putoffduties imcr_shywithpeople imcr_rudetoother

** F2
global f2 imcr_enthusiastic imcr_expressingthoughts imcr_forgiveother imcr_organized imcr_talktomanypeople imcr_completeduties imcr_workhard imcr_activeimagination imcr_appointmentontime imcr_workwithother imcr_newideas imcr_enjoypeople imcr_makeplans imcr_understandotherfeeling

** F3
global f3 imcr_staycalm imcr_talkative imcr_helpfulwithothers imcr_inventive imcr_trustingofother imcr_liketothink imcr_sharefeelings

** F4
global f4 imcr_curious imcr_toleratefaults

** F5
global f5 imcr_managestress imcr_interestedbyart

*** omegacoef
omegacoef $f1  // .91
omegacoef $f2  // .56
omegacoef $f3  // .46
alpha $f4  // .07
alpha $f5  // .03

*** Score
egen f1_2020=rowmean($f1)
egen f2_2020=rowmean($f2)
egen f3_2020=rowmean($f3)
egen f4_2020=rowmean($f4)
egen f5_2020=rowmean($f5)

save"$wave3~matching_v2.dta", replace
*clear all
****************************************
* END











****************************************
* Lockdown database preparation
****************************************
cls
use "$wave3~matching_v2.dta", clear

********** HHsize
drop if livinghome==3
drop if livinghome==4
drop if INDID_left!=.
bys HHID_panel: egen HHsize=sum(1)


********** Initialization
drop if egoid==0

fre mainocc_occupation_indiv
recode mainocc_occupation_indiv (.=0)

global quali caste sex mainocc_occupation_indiv edulevel villageid maritalstatus
foreach x in $quali {
ta `x', gen(`x'_)
}

global var age caste_2 caste_3 sex_2 mainocc_occupation_indiv_1 mainocc_occupation_indiv_2 mainocc_occupation_indiv_4 mainocc_occupation_indiv_5 mainocc_occupation_indiv_6 mainocc_occupation_indiv_7 mainocc_occupation_indiv_8 edulevel_2 edulevel_3 edulevel_4 edulevel_5 edulevel_6 maritalstatus_2 maritalstatus_3 maritalstatus_4



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

rename treattos_6 treat


********** Locus of control
/*
1. I like taking responsibility.
2. I find it best to make decisions by myself rather than to rely on fate.
3. When I encounter problems or opposition, I usually find ways and means to overcome them.
4. Success often depends more on luck than on effort.
5. I often have the feeling that I have little influence over what happens to me.
6. When I make important decisions, I often look at what others have done.
*/

global locus locuscontrol1 locuscontrol2 locuscontrol3 locuscontrol4 locuscontrol5 locuscontrol6
fre $locus

/*
label define locusscale2 1"VL extent" 2"Great extent" 3"Some extent" 4"Hardly applies" 5"Not at all", replace
forvalues i=1(1)6{
label values locuscontrol`i' locusscale2
}
heatplot locuscontrol1 locuscontrol2, colors(HSV grays, reverse) statistic(count) discrete
*/

omegacoef $locus  // .80

* Reverse locuscontrol4 5 6 for min=intern and max=extern as locuscontrol1 2 3
forvalues i=4(1)6 {
vreverse locuscontrol`i', gen(locuscontrol`i'_rv)
}

* Verification
global locus2 locuscontrol1 locuscontrol2 locuscontrol3 locuscontrol4_rv locuscontrol5_rv locuscontrol6_rv
fre $locus2

omegacoef $locus2

* Score
egen locus=rowmean($locus2)
replace locus=round(locus, .01)
label var locus "intern -3-> extern  "

tabstat locus, stat(n mean sd p50) by(sex)


********** Prepare to R
keep f1_2020 f2_2020 f3_2020 f4_2020 f5_2020 $var treat villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 HHID_panel INDID_panel egoid cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit lit_tt num_tt raven_tt annualincome_indiv assets_noland HHsize locus

keep if treat!=.
saveold "N2_CBPS.dta", version(12) replace
****************************************
* END















****************************************
* Reg weight
****************************************
cls
use "neemsis2_r.dta", clear

global var age caste_2 caste_3 sex_2 mainocc_occupation_indiv_1 mainocc_occupation_indiv_2 mainocc_occupation_indiv_4 mainocc_occupation_indiv_5 mainocc_occupation_indiv_6 mainocc_occupation_indiv_7 mainocc_occupation_indiv_8 edulevel_2 edulevel_3 edulevel_4 edulevel_5 edulevel_6


forvalues i=1(1)5 {
reg f`i'_2020 treat $var [pw=weights]
}

****************************************
* END

















****************************************
* ADSM
****************************************
cls
use "adsm_n2_r.dta", clear

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
replace labpos=11 if covariate=="mainocc_occupation_indiv_2"
replace labpos=12 if covariate=="mainocc_occupation_indiv_4"
replace labpos=6 if covariate=="mainocc_occupation_indiv_6"
replace labpos=12 if covariate=="mainocc_occupation_indiv_7"
replace labpos=7 if covariate=="mainocc_occupation_indiv_8"
replace labpos=12 if covariate=="sex_2"
replace labpos=1 if covariate=="caste_2"
replace labpos=6 if covariate=="edulevel_3"
replace labpos=6 if covariate=="edulevel_5"
replace labpos=6 if covariate=="age"

twoway scatter balanced original, mlabel(la) mlabvpos(labpos) ///
xlabel(0(10)40) xmtick(0(5)40) xtitle("ADSM before weighting (%)") ///
ylabel(0(1)7) ymtick(0(.5)7.5) ytitle("ADSM after weighting (%)") ///
name(adsm, replace)

graph save "adsm_n2.gph", replace

****************************************
* END
