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
*set scheme white_tableau
set scheme plotplain
grstyle init
grstyle set plain, nogrid


********** Path to folder "data" folder.
*** PC
global directory = "C:\Users\Arnaud\Documents\MEGA\Thesis\Thesis_Stability\Analysis"
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

********** username
replace username="Antoni" if username=="1"
replace username="Antoni - Vivek Radja" if username=="1 2"
replace username="Antoni - Raja Annamalai" if username=="1 6"
replace username="Vivek Radja" if username=="2"
replace username="Vivek Radja - Mayan" if username=="2 5"
replace username="Vivek Radja - Raja Annamalai" if username=="2 6"
replace username="Kumaresh" if username=="3"
replace username="Kumaresh - Sithanantham" if username=="3 4"
replace username="Kumaresh - Raja Annamalai" if username=="3 6"
replace username="Sithanantham" if username=="4"
replace username="Sithanantham - Raja Annamalai" if username=="4 6"
replace username="Mayan" if username=="5"
replace username="Mayan - Raja Annamalai" if username=="5 6"
replace username="Raja Annamalai" if username=="6"
replace username="Raja Annamalai - Pazhani" if username=="6 7"
replace username="Pazhani" if username=="7"

replace username="Antoni" if username=="Antoni - Vivek Radja"
replace username="Kumaresh" if username=="Kumaresh - Raja Annamalai"
replace username="Kumaresh" if username=="Kumaresh - Sithanantham"
replace username="Raja Annamalai" if username=="Antoni - Raja Annamalai"
replace username="Raja Annamalai" if username=="Mayan - Raja Annamalai"
replace username="Raja Annamalai" if username=="Raja Annamalai - Pazhani"
replace username="Raja Annamalai" if username=="Sithanantham - Raja Annamalai"
replace username="Raja Annamalai" if username=="Vivek Radja - Raja Annamalai"
replace username="Mayan" if username=="Vivek Radja - Mayan"

encode username, gen(username_code)

ta username_code


********** HHsize
drop if livinghome==3
drop if livinghome==4
bys HHID_panel: egen HHsize=sum(1)


********** Initialization
drop if egoid==0

fre mainocc_occupation_indiv
recode mainocc_occupation_indiv (.=0)

global quali caste sex mainocc_occupation_indiv edulevel villageid maritalstatus username_code
foreach x in $quali {
ta `x', gen(`x'_)
}

global var age caste_2 caste_3 sex_2 mainocc_occupation_indiv_1 mainocc_occupation_indiv_2 mainocc_occupation_indiv_4 mainocc_occupation_indiv_5 mainocc_occupation_indiv_6 mainocc_occupation_indiv_7 mainocc_occupation_indiv_8 edulevel_2 edulevel_3 edulevel_4 edulevel_5 edulevel_6 maritalstatus_2 maritalstatus_3 maritalstatus_4 username_code_1 username_code_2 username_code_3 username_code_4 username_code_5 username_code_7

global treat dummydemonetisation



********** vérification des effectifs
fre HHsize annualincome_indiv maritalstatus_2 maritalstatus_3 maritalstatus_4 villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10

recode annualincome_indiv (.=0)

********** Prepare to R
keep f1_2016 f2_2016 f3_2016 f4_2016 f5_2016 $var $treat villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 HHID_panel INDID_panel egoid cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit lit_tt num_tt raven_tt annualincome_indiv assets_noland HHsize
rename dummydemonetisation treat 
saveold "N1_CBPS.dta", version(12) replace
****************************************
* END







/*
****************************************
* ADMS graph
****************************************
cls
use "adsm_n1_r.dta", clear

replace balanced=balanced*100
replace original=original*100

gen la=""
replace la="ORA" if covariate=="villageid_9"
replace la="SEM" if covariate=="villageid_10"

egen labpos=mlabvpos(balanced original)
replace labpos=11 if la=="ORA"
replace labpos=12 if la=="SEM"

*twoway ///
*(scatter balanced original, mlab(la) mlabvpos(labpos) yline(20) xline(20)) ///
*(function y=x, range(0 20) lpattern(shortdash) lcolor(gs8)), ///
*xlabel(0(10)60) xmtick(0(5)65) xtitle("ADSM before weighting (%)") ///
*ylabel(0(5)35) ymtick(0(2.5)35) ytitle("ADSM after weighting (%)") ///
*legend(off) name(adsm, replace)


twoway ///
(scatter balanced original, xline(20)) ///
(function y=x, range(0 10) lpattern(shortdash) lcolor(gs8)), ///
xlabel(0(10)60) xmtick(0(5)65) xtitle("ADSM before weighting (%)") ///
ylabel(0(5)10) ymtick(0(2.5)10) ytitle("ADSM after weighting (%)") ///
title("Demonetisation") ///
legend(off) name(adsm1, replace)

graph export "ADSM_demo.pdf", as(pdf) replace
graph save "ADSM_demo.gph", replace

****************************************
* END
*/












****************************************
* Mean test
****************************************
cls
use "neemsis1_r.dta", clear

global var age caste_2 caste_3 sex_2 mainocc_occupation_indiv_1 mainocc_occupation_indiv_2 mainocc_occupation_indiv_4 mainocc_occupation_indiv_5 mainocc_occupation_indiv_6 mainocc_occupation_indiv_7 mainocc_occupation_indiv_8 edulevel_2 edulevel_3 edulevel_4 edulevel_5 edulevel_6 maritalstatus_2 maritalstatus_3 maritalstatus_4 annualincome_indiv HHsize villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 username_code_1 username_code_2 username_code_3 username_code_4 username_code_5 username_code_7





********** Mean diff before weighting
local i=0
foreach x in $var {
local i=`i'+1
qui reg `x' treat
est store reg_`i'
}

***** Only constant
qui esttab reg_1 reg_2 reg_3 reg_4 reg_5 reg_6 reg_7 reg_8 reg_9 reg_10 reg_11 reg_12 reg_13 reg_14 reg_15 reg_16 reg_17 reg_18 reg_19 reg_20 reg_21, replace ///
	label b(3) p(3) eqlabels(none) ///
	drop(treat) ///
	cells("b(fmt(2))") ///
	refcat(, nolabel)
mat list r(coefs) 
mat rename r(coefs) tsp, replace
mat list tsp
qui esttab matrix(tsp, transpose), replace	///
	label b(3) p(3) eqlabels(none) 
mat list r(coefs)
mat rename r(coefs) cons, replace

***** Only treatment
qui esttab reg_1 reg_2 reg_3 reg_4 reg_5 reg_6 reg_7 reg_8 reg_9 reg_10 reg_11 reg_12 reg_13 reg_14 reg_15 reg_16 reg_17 reg_18 reg_19 reg_20 reg_21, replace ///
	label b(3) p(3) eqlabels(none) ///
	drop(_cons) ///
	cells("b(fmt(2))") ///
	refcat(, nolabel)
mat list r(coefs) 
mat rename r(coefs) tsp, replace
mat list tsp
qui esttab matrix(tsp, transpose), replace	///
	label b(3) p(3) eqlabels(none)
mat list r(coefs)
mat rename r(coefs) diff, replace

***** Only t-stat
qui esttab reg_1 reg_2 reg_3 reg_4 reg_5 reg_6 reg_7 reg_8 reg_9 reg_10 reg_11 reg_12 reg_13 reg_14 reg_15 reg_16 reg_17 reg_18 reg_19 reg_20 reg_21, replace ///
	label b(3) p(3) eqlabels(none) ///
	drop(_cons) ///
	cells("t(fmt(2))") ///
	refcat(, nolabel)
mat list r(coefs) 
mat rename r(coefs) tsp, replace
mat list tsp
qui esttab matrix(tsp, transpose), replace	///
	label b(3) p(3) eqlabels(none)
mat list r(coefs)
mat rename r(coefs) tstat, replace

***** Combine
matrix before=cons,diff,tstat






********** Mean diff after weighting
local i=0
foreach x in $var {
local i=`i'+1
qui reg `x' treat [pw=weight]
est store reg_`i'
}

***** Only constant
qui esttab reg_1 reg_2 reg_3 reg_4 reg_5 reg_6 reg_7 reg_8 reg_9 reg_10 reg_11 reg_12 reg_13 reg_14 reg_15 reg_16 reg_17 reg_18 reg_19 reg_20 reg_21, replace ///
	label b(3) p(3) eqlabels(none) ///
	drop(treat) ///
	cells("b(fmt(2))") ///
	refcat(, nolabel)
mat list r(coefs) 
mat rename r(coefs) tsp, replace
mat list tsp
qui esttab matrix(tsp, transpose), replace	///
	label b(3) p(3) eqlabels(none) 
mat list r(coefs)
mat rename r(coefs) cons, replace

***** Only treatment
qui esttab reg_1 reg_2 reg_3 reg_4 reg_5 reg_6 reg_7 reg_8 reg_9 reg_10 reg_11 reg_12 reg_13 reg_14 reg_15 reg_16 reg_17 reg_18 reg_19 reg_20 reg_21, replace ///
	label b(3) p(3) eqlabels(none) ///
	drop(_cons) ///
	cells("b(fmt(2))") ///
	refcat(, nolabel)
mat list r(coefs) 
mat rename r(coefs) tsp, replace
mat list tsp
qui esttab matrix(tsp, transpose), replace	///
	label b(3) p(3) eqlabels(none)
mat list r(coefs)
mat rename r(coefs) diff, replace

***** Only t-stat
qui esttab reg_1 reg_2 reg_3 reg_4 reg_5 reg_6 reg_7 reg_8 reg_9 reg_10 reg_11 reg_12 reg_13 reg_14 reg_15 reg_16 reg_17 reg_18 reg_19 reg_20 reg_21, replace ///
	label b(3) p(3) eqlabels(none) ///
	drop(_cons) ///
	cells("t(fmt(2))") ///
	refcat(, nolabel)
mat list r(coefs) 
mat rename r(coefs) tsp, replace
mat list tsp
qui esttab matrix(tsp, transpose), replace	///
	label b(3) p(3) eqlabels(none)
mat list r(coefs)
mat rename r(coefs) tstat, replace

***** Combine
matrix after=cons,diff,tstat





********** Before and after
matrix tot=before,after
matrix list tot

****************************************
* END


















****************************************
* Reg weight
****************************************
cls
use "neemsis1_r.dta", clear

global var age caste_2 caste_3 sex_2 mainocc_occupation_indiv_1 mainocc_occupation_indiv_2 mainocc_occupation_indiv_4 mainocc_occupation_indiv_5 mainocc_occupation_indiv_6 mainocc_occupation_indiv_7 mainocc_occupation_indiv_8 edulevel_2 edulevel_3 edulevel_4 edulevel_5 edulevel_6 maritalstatus_2 maritalstatus_3 maritalstatus_4 annualincome_indiv HHsize villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 username_code_1 username_code_2 username_code_3 username_code_4 username_code_5 username_code_7

***** Label
label var treat "Demonetisation (T=1)"
label var age "Age"
label var caste_2 "Caste: Middle"
label var caste_3 "Caste: Upper"
label var sex_2 "Sex: Female"
label var mainocc_occupation_indiv_1 "Occ: No occupation"
label var mainocc_occupation_indiv_2 "Occ: Agri SE"
label var mainocc_occupation_indiv_4 "Occ: Non-agri casual"
label var mainocc_occupation_indiv_5 "Occ: Non-agri regular non-qualified"
label var mainocc_occupation_indiv_6 "Occ: Non-agri regular qualified"
label var mainocc_occupation_indiv_7 "Occ: Non-agri SE"
label var mainocc_occupation_indiv_8 "Occ: NREGA"
label var edulevel_2 "Edu: Primary completed"
label var edulevel_3 "Edu: High-School"
label var edulevel_4 "Edu: HSC/Diploma"
label var edulevel_5 "Edu: Bachelors"
label var edulevel_6 "Edu: Post graduate"
label var maritalstatus_2 "MS: Unmarried"
label var maritalstatus_3 "MS: Widowed"
label var maritalstatus_4 "MS: Divorce/separated"
label var annualincome_indiv "Income"
label var HHsize "HH size"


***** Reg
cls
foreach x in f1_2016 f2_2016 f3_2016 f4_2016 f5_2016 {
glm `x' treat $var [pw=weights], link(log) family(igaussian)
est store regpw_`x'
qui glm `x' treat $var, link(log) family(igaussian)
est store reg_`x'
}

*foreach x in f1_2016 f2_2016 f3_2016 f4_2016 f5_2016 {
*glm `x' treat $var [pw=weights], link(log) family(igaussian)
*}

esttab regpw_f1_2016 regpw_f2_2016 regpw_f3_2016 regpw_f5_2016



***** Before weighting
esttab reg_f1_2016 reg_f2_2016 reg_f3_2016 reg_f5_2016 using "reg_demo_nopw.tex", replace f ///
	label booktabs b(3) p(3) eqlabels(none) alignment(S) collabels("\multicolumn{1}{c}{$\beta$ / Std. Err.}") ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N r2 r2_a F p, fmt(0 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"\(R^{2}\)"' `"Adjusted \(R^{2}\)"' `"F-stat"' `"p-value"'))


***** After weighting
esttab regpw_f1_2016 regpw_f2_2016 regpw_f3_2016 regpw_f5_2016 using "reg_demo_pw.tex", replace f ///
	label booktabs b(3) p(3) eqlabels(none) alignment(S) collabels("\multicolumn{1}{c}{$\beta$ / Std. Err.}") ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N r2 r2_a F p, fmt(0 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"\(R^{2}\)"' `"Adjusted \(R^{2}\)"' `"F-stat"' `"p-value"'))

****************************************
* END
