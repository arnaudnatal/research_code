cls

/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
June 14, 2022
-----
Impact of lockdown
-----

-------------------------
*/






****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all

global user "Arnaud"
global folder "Documents"

********** Path to folder "data" folder.
global directory = "C:\Users\\$user\\$folder\_Thesis\Research-Overindebtedness\Persistence_over"
cd"$directory"
global git "C:\Users\\$user\\$folder\GitHub"

*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
*set scheme plotplain

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH"
global wave2 "NEEMSIS1-HH"
global wave3 "NEEMSIS2-HH"

global loan1 "RUME-all_loans"
global loan2 "NEEMSIS1-all_loans"
global loan3 "NEEMSIS2-all_loans"

* Scheme
set scheme plotplain_v2
grstyle init
grstyle set plain, box nogrid

********** Deflate
*https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
*(100/158) if year==2016
*(100/184) if year==2020

****************************************
* END









****************************************
* Lockdown database preparation
****************************************
cls
use "$wave3", clear

/*
********** How much HH regarding date of survey?
gen tos=dofc(start_HH_quest)
format tos %td
ta tos

ta tos if tos<d(01jan2021)
ta tos if tos>d(01jun2021)

gen swt=.
replace swt=1 if tos<d(05apr2021)
replace swt=2 if tos>=d(05apr2021) & tos<=d(15jun2021)
replace swt=3 if tos>d(15jun2021)

preserve
duplicates drop HHID_panel, force
ta swt
restore
*/


********** HHsize
drop if livinghome==3
drop if livinghome==4
drop if INDID_left!=.
bys HHID_panel: egen HHsize=sum(1)


********** Initialization
drop if egoid==0

fre mainocc_occupation_indiv
recode mainocc_occupation_indiv (.=0)

global quali caste sex mainocc_occupation_indiv edulevel villageid maritalstatus username_code
foreach x in $quali {
ta `x', gen(`x'_)
}

global var age caste_2 caste_3 sex_2 mainocc_occupation_indiv_1 mainocc_occupation_indiv_2 mainocc_occupation_indiv_4 mainocc_occupation_indiv_5 mainocc_occupation_indiv_6 mainocc_occupation_indiv_7 mainocc_occupation_indiv_8 edulevel_2 edulevel_3 edulevel_4 edulevel_5 edulevel_6 maritalstatus_2 maritalstatus_3 maritalstatus_4 username_code_1 username_code_3 username_code_4 username_code_5 username_code_6 username_code_7 username_code_8



***** y var
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

ta treat, m


********** Prepare to R
keep f1_2020 f2_2020 f3_2020 f4_2020 f5_2020 $var treat villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 HHID_panel INDID_panel egoid cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit lit_tt num_tt raven_tt annualincome_indiv assets_noland HHsize locus

keep if treat!=.
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


*twoway ///
*(scatter balanced original, mlab(la) mlabvpos(labpos) xline(20)) ///
*(function y=x, range(0 13) lpattern(shortdash) lcolor(gs8)), ///
*xlabel(0(5)40) xmtick(0(2.5)40) xtitle("ADSM before weighting (%)") ///
*ylabel(0(3)12) ymtick(0(1)13) ytitle("ADSM after weighting (%)") ///
*legend(off) name(adsm, replace)

twoway ///
(scatter balanced original, xline(20) aspectratio(0.8)) ///
(function y=x, range(0 13) lpattern(shortdash) lcolor(gs8)), ///
xlabel(0(5)40) xmtick(0(2.5)40) xtitle("ADSM before weighting (%)") ///
ylabel(0(3)12) ymtick(0(1)13) ytitle("ADSM after weighting (%)") ///
title("Lockdown") ///
legend(off) name(adsm2, replace)


********** Demo
preserve
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
(scatter balanced original, xline(20) aspectratio(0.8)) ///
(function y=x, range(0 10) lpattern(shortdash) lcolor(gs8)), ///
xlabel(0(10)60) xmtick(0(5)65) xtitle("ADSM before weighting (%)") ///
ylabel(0(5)10) ymtick(0(2.5)10) ytitle("ADSM after weighting (%)") ///
title("Demonetisation") ///
legend(off) name(adsm1, replace)
restore


********* Combine
graph combine adsm1 adsm2, graphregion(margin(zero)) plotregion(margin(zero)) name(comb_ADSM, replace)

graph export "ADSM.pdf", as(pdf) replace
graph save "ADSM.gph", replace

****************************************
* END
*/








****************************************
* Mean test
****************************************
cls
use "neemsis2_r.dta", clear

global var age caste_2 caste_3 sex_2 mainocc_occupation_indiv_1 mainocc_occupation_indiv_2 mainocc_occupation_indiv_4 mainocc_occupation_indiv_5 mainocc_occupation_indiv_6 mainocc_occupation_indiv_7 mainocc_occupation_indiv_8 edulevel_2 edulevel_3 edulevel_4 edulevel_5 edulevel_6 maritalstatus_2 maritalstatus_3 maritalstatus_4 annualincome_indiv HHsize villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 username_code_1 username_code_3 username_code_4 username_code_5 username_code_6 username_code_7 username_code_8


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
use "neemsis2_r.dta", clear

global var age caste_2 caste_3 sex_2 mainocc_occupation_indiv_1 mainocc_occupation_indiv_2 mainocc_occupation_indiv_4 mainocc_occupation_indiv_5 mainocc_occupation_indiv_6 mainocc_occupation_indiv_7 mainocc_occupation_indiv_8 edulevel_2 edulevel_3 edulevel_4 edulevel_5 edulevel_6 maritalstatus_2 maritalstatus_3 maritalstatus_4 annualincome_indiv HHsize villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 username_code_1 username_code_3 username_code_4 username_code_5 username_code_6 username_code_7 username_code_8

***** Label
label var treat "Lockdown (T=1)"
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

cls
foreach x in f1_2020 f2_2020 f3_2020 f4_2020 f5_2020 raven_tt num_tt lit_tt cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit locus {
reg `x' treat $var [pw=weights]
est store regpw_`x'
qui reg `x' treat $var
est store reg_`x'
}


***** Before weighting
esttab reg_f1_2020 reg_raven_tt reg_num_tt reg_lit_tt reg_locus using "reg_lock_nopw.tex", replace f ///
	label booktabs b(3) p(3) eqlabels(none) alignment(S) collabels("\multicolumn{1}{c}{$\beta$ / Std. Err.}") ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N r2 r2_a F p, fmt(0 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"\(R^{2}\)"' `"Adjusted \(R^{2}\)"' `"F-stat"' `"p-value"'))

***** After weighting
esttab regpw_f1_2020 regpw_raven_tt regpw_num_tt regpw_lit_tt regpw_locus using "reg_lock_pw.tex", replace f ///
	label booktabs b(3) p(3) eqlabels(none) alignment(S) collabels("\multicolumn{1}{c}{$\beta$ / Std. Err.}") ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N r2 r2_a F p, fmt(0 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"\(R^{2}\)"' `"Adjusted \(R^{2}\)"' `"F-stat"' `"p-value"'))

****************************************
* END
