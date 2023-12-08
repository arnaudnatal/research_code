*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*April 23, 2021
*-----
gl link = "stabpsycho"
*Stab
*-----
do "C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------







****************************************
* Personality traits construction
****************************************
cls
use"panel_stab_v2", clear
keep if year==2020


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


********** Traits
global f1 imcr_worryalot imcr_easilydistracted imcr_feeldepressed imcr_easilyupset imcr_changemood imcr_nervous imcr_repetitivetasks imcr_putoffduties imcr_shywithpeople imcr_rudetoother imcr_understandotherfeeling
global f2 imcr_talkative imcr_helpfulwithothers imcr_inventive imcr_staycalm imcr_trustingofother imcr_liketothink imcr_sharefeelings imcr_organized imcr_appointmentontime
global f3 imcr_enthusiastic imcr_talktomanypeople imcr_completeduties imcr_forgiveother imcr_expressingthoughts imcr_activeimagination imcr_makeplans imcr_workwithother
global f4 imcr_curious imcr_interestedbyart imcr_workhard imcr_enjoypeople imcr_newideas imcr_toleratefaults
global f5 imcr_managestress

egen f1_2020=rowmean($f1)
egen f2_2020=rowmean($f2)
egen f3_2020=rowmean($f3)
egen f4_2020=rowmean($f4)
egen f5_2020=rowmean($f5)


save"$wave3~matching_v2.dta", replace
****************************************
* END












****************************************
* Lockdown database preparation
****************************************
cls
use "$wave3~matching_v2.dta", clear

********** Username
encode username, gen(username_code)
ta username_code

********** Occupations and income
fre mainocc_occupation_indiv
recode mainocc_occupation_indiv (.=0)
recode annualincome_indiv (.=0)
recode maritalstatus (1=0) (2=1) (3=1) (4=1)
label define maritalstatus 0"Married" 1"Non-married", replace
label values maritalstatus maritalstatus


********** Locus
global varloc locuscontrol1 locuscontrol2 locuscontrol3 locuscontrol4 locuscontrol5 locuscontrol6
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-ego", keepusing($varloc)
drop _merge
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-PTCS", keepusing(locus)
drop _merge

omegacoef $varloc
drop $varloc


********** Var creation
global quali caste sex mainocc_occupation_indiv edulevel villageid maritalstatus username_code
foreach x in $quali {
ta `x', gen(`x'_)
}

global var age caste_2 caste_3 sex_2 mainocc_occupation_indiv_1 mainocc_occupation_indiv_2 mainocc_occupation_indiv_4 mainocc_occupation_indiv_5 mainocc_occupation_indiv_6 mainocc_occupation_indiv_7 mainocc_occupation_indiv_8 edulevel_2 edulevel_3 edulevel_4 edulevel_5 maritalstatus_2 username_code_1 username_code_2 username_code_3 username_code_4 username_code_5 username_code_7 username_code_8

global treat dummyexposure
ta dummyexposure
ta secondlockdownexposure
ta dummysell

ta dummysell dummyexposure


********** Prepare to R
keep f1_2020 f2_2020 f3_2020 f4_2020 f5_2020 locus $var $treat villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 HHID_panel INDID_panel egoid cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit lit_tt num_tt raven_tt annualincome_indiv assets_total1000 HHsize
rename $treat treat 
drop if treat==.
ta treat
saveold "N2_CBPS.dta", version(12) replace
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
replace la="Female" if covariate=="sex_2"
replace la="MANAM" if covariate=="villageid_7"
replace la="SEM" if covariate=="villageid_10"


egen labpos=mlabvpos(balanced original)
replace labpos=12 if la=="Female"
replace labpos=12 if la=="KOR"
replace labpos=12 if la=="SEM"


********** Twoway
twoway ///
(scatter balanced original, xline(20) mcolor(black%30)) ///
(function y=x, range(0 10) lpattern(shortdash) lcolor(gs8)), ///
xlabel(0(10)60) xmtick(0(5)65) xtitle("ADSM before weighting (%)") ///
ylabel(0(5)10) ymtick(0(2.5)10) ytitle("ADSM after weighting (%)") ///
title("Second lockdown") ///
legend(off) name(adsm2, replace)

graph export "ADSM_lock.pdf", as(pdf) replace
graph save "ADSM_lock.gph", replace

****************************************
* END








****************************************
* Mean test
****************************************
cls
use "neemsis2_r.dta", clear

fre treat
mdesc
drop if locus==.

global var age caste_2 caste_3 sex_2 mainocc_occupation_indiv_1 mainocc_occupation_indiv_2 mainocc_occupation_indiv_4 mainocc_occupation_indiv_5 mainocc_occupation_indiv_6 mainocc_occupation_indiv_7 mainocc_occupation_indiv_8 edulevel_2 edulevel_3 edulevel_4 edulevel_5 maritalstatus_2 annualincome_indiv HHsize
* villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 username_code_1 username_code_2 username_code_3 username_code_4 username_code_5 username_code_7 username_code_8


********** Mean diff before weighting
reg age treat
ta treat
local i=0
foreach x in $var {
local i=`i'+1
qui reg `x' treat
est store reg_`i'
}

***** Only constant
qui esttab reg_1 reg_2 reg_3 reg_4 reg_5 reg_6 reg_7 reg_8 reg_9 reg_10 reg_11 reg_12 reg_13 reg_14 reg_15 reg_16 reg_17 reg_18, replace ///
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
qui esttab reg_1 reg_2 reg_3 reg_4 reg_5 reg_6 reg_7 reg_8 reg_9 reg_10 reg_11 reg_12 reg_13 reg_14 reg_15 reg_16 reg_17 reg_18, replace ///
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
qui esttab reg_1 reg_2 reg_3 reg_4 reg_5 reg_6 reg_7 reg_8 reg_9 reg_10 reg_11 reg_12 reg_13 reg_14 reg_15 reg_16 reg_17 reg_18, replace ///
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
qui esttab reg_1 reg_2 reg_3 reg_4 reg_5 reg_6 reg_7 reg_8 reg_9 reg_10 reg_11 reg_12 reg_13 reg_14 reg_15 reg_16 reg_17 reg_18, replace ///
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
qui esttab reg_1 reg_2 reg_3 reg_4 reg_5 reg_6 reg_7 reg_8 reg_9 reg_10 reg_11 reg_12 reg_13 reg_14 reg_15 reg_16 reg_17 reg_18, replace ///
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
qui esttab reg_1 reg_2 reg_3 reg_4 reg_5 reg_6 reg_7 reg_8 reg_9 reg_10 reg_11 reg_12 reg_13 reg_14 reg_15 reg_16 reg_17 reg_18, replace ///
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
use "neemsis2_r.dta", clear

merge 1:1 HHID_panel INDID_panel using "$wave3~matching_v2.dta", keepusing(caste)
keep if _merge==3
drop _merge
merge m:1 HHID_panel using "raw/keypanel-HH_wide", keepusing(HHID2020)
keep if _merge==3
drop _merge
merge m:1 HHID_panel INDID_panel using "raw/keypanel-indiv_wide", keepusing(INDID2020)
keep if _merge==3
drop _merge
destring INDID2020, replace
merge 1:m HHID2020 INDID2020 using "raw/NEEMSIS2-HH", keepusing(compensation compensationamount)
keep if _merge==3
drop _merge


global var age caste_2 caste_3 sex_2 mainocc_occupation_indiv_1 mainocc_occupation_indiv_2 mainocc_occupation_indiv_4 mainocc_occupation_indiv_5 mainocc_occupation_indiv_6 mainocc_occupation_indiv_7 mainocc_occupation_indiv_8 edulevel_2 edulevel_3 edulevel_4 edulevel_5 maritalstatus_2 annualincome_indiv HHsize villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 username_code_1 username_code_2 username_code_3 username_code_4 username_code_5 username_code_7 username_code_8

***** Label
label var treat "COVID-19 lockdown (T=1)"
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
label var maritalstatus_2 "MS: Unmarried"
label var annualincome_indiv "Income"
label var HHsize "HH size"

replace f1_2020=0.01 if f1_2020<0
cls
foreach x in f1_2020 locus {
glm `x' treat $var [pw=weights], link(log) family(igaussian)
est store regpw_`x'
qui glm `x' treat $var, link(log) family(igaussian)
est store reg_`x'
}

esttab regpw_f1_2020 regpw_locus, drop(_cons $var)



***** Before weighting
esttab reg_f1_2020 reg_locus using "reg_lock_nopw.tex", replace f ///
	label booktabs b(3) p(3) eqlabels(none) alignment(S) collabels("\multicolumn{1}{c}{$\beta$ / Std. Err.}") ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N r2 r2_a F p, fmt(0 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"\(R^{2}\)"' `"Adjusted \(R^{2}\)"' `"F-stat"' `"p-value"'))

***** After weighting
esttab regpw_f1_2020 regpw_locus using "reg_lock_pw.tex", replace f ///
	label booktabs b(3) p(3) eqlabels(none) alignment(S) collabels("\multicolumn{1}{c}{$\beta$ / Std. Err.}") ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N r2 r2_a F p, fmt(0 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"\(R^{2}\)"' `"Adjusted \(R^{2}\)"' `"F-stat"' `"p-value"'))

********** Caste
cls
foreach x in f1_2020 locus {
glm `x' i.treat##i.caste $var [pw=weights], link(log) family(igaussian)
est store regpw_`x'
}

esttab regpw_f1_2020 regpw_locus, drop(_cons $var) cells("b(fmt(2)star)" "se(fmt(2)par)")


********** Compensation
cls
foreach x in f1_2020 locus {
glm `x' treat i.compensation $var [pw=weights], link(log) family(igaussian)
est store regpw_`x'
}

esttab regpw_f1_2020 regpw_locus, drop(_cons) cells("b(fmt(2)star)" "se(fmt(2)par)") 
 
	
****************************************
* END












****************************************
* Support commun
****************************************
cls
use "neemsis2_r.dta", clear

merge 1:1 HHID_panel INDID_panel using "$wave3~matching_v2.dta", keepusing(caste)
drop _merge


global var age caste_2 caste_3 sex_2 mainocc_occupation_indiv_1 mainocc_occupation_indiv_2 mainocc_occupation_indiv_4 mainocc_occupation_indiv_5 mainocc_occupation_indiv_6 mainocc_occupation_indiv_7 mainocc_occupation_indiv_8 edulevel_2 edulevel_3 edulevel_4 edulevel_5 maritalstatus_2 annualincome_indiv HHsize villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 username_code_1 username_code_2 username_code_3 username_code_4 username_code_5 username_code_7 username_code_8

***** Label
label var treat "COVID-19 lockdown (T=1)"
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
label var maritalstatus_2 "MS: Unmarried"
label var annualincome_indiv "Income"
label var HHsize "HH size"

replace f1_2020=0.01 if f1_2020<0



***** Support commun à la main
fre treat
twoway ///
(kdensity ps_scores if treat==1, lcolor("164 204 76") bwidth(0.04)) ///
(kdensity ps_scores if treat==2, lcolor("80 151 68") bwidth(0.04)) ///
,  xtitle("Score de propension") ytitle("") legend(order(1 "T=0" 2 "T=1") pos(6) col(2)) title("Support commun COVID-19") name(covid, replace)
graph export "supportlock.pdf", as(pdf) replace
*("164 204 76")
*("197 102 63")
*("80 151 68")



****************************************
* END




















****************************************
* Compensation amount
****************************************
cls
use "raw/NEEMSIS2-HH", clear

keep HHID2020 compensation compensationamount caste
duplicates drop

ta compensation caste, col nofreq
tabstat compensationamount, stat(n mean q) by(caste)

probit compensation i.caste
reg compensationamount i.caste

****************************************
* END







