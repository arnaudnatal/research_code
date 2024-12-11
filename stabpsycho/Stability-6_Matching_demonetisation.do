*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*March 19, 2024
*-----
gl link = "stabpsycho"
*Stab
*-----
do "C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------







****************************************
* Demonetisation
****************************************
cls
use "panel_stab_v2_pooled_long", clear

********** Preparation données

*** Username
encode username, gen(username_code)
ta username_code

*** Occupations and income
fre mainocc_occupation_indiv
recode mainocc_occupation_indiv (.=0) (5=4)
rename mainocc_occupation_indiv occupation
recode annualincome_indiv (.=0)
recode maritalstatus (1=0) (2=1) (3=1) (4=1)
fre edulevel
recode edulevel (4=3)
label define maritalstatus 0"Married" 1"Non-married", replace
label values maritalstatus maritalstatus

*** Var creation
global quali caste sex occupation edulevel villageid maritalstatus username_code
foreach x in $quali {
ta `x', gen(`x'_)
}

global var age caste_2 caste_3 sex_2 occupation_1 occupation_2 occupation_4 occupation_5 occupation_6 occupation_7 edulevel_2 edulevel_3 edulevel_4 maritalstatus_2 username_code_1 username_code_2 username_code_3 username_code_4 username_code_5 username_code_7

global treat dummydemonetisation


*** Clean Database
keep if year==2016
keep fES fOPEX fCO $var $treat villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 HHID_panel INDID_panel egoid annualincome_indiv assets_total1000 HHsize
rename dummydemonetisation treat 

label var treat "Demonetisation (T=1)"
label var age "Age"
label var caste_2 "Caste: Middle"
label var caste_3 "Caste: Upper"
label var sex_2 "Sex: Female"
label var occupation_1 "Occ: No occupation"
label var occupation_2 "Occ: Agri SE"
label var occupation_4 "Occ: Casual"
label var occupation_5 "Occ: Regular"
label var occupation_6 "Occ: Self-emp"
label var occupation_7 "Occ: MGNREGA"
label var edulevel_2 "Edu: Primary completed"
label var edulevel_3 "Edu: High-School"
label var edulevel_4 "Edu: HSC/Diploma or more"
label var maritalstatus_2 "MS: Unmarried"
label var annualincome_indiv "Income"
label var HHsize "Household size"


global varstep1 age caste_2 caste_3 sex_2 occupation_1 occupation_2 occupation_4 occupation_5 occupation_6 occupation_7 edulevel_2 edulevel_3 edulevel_4 maritalstatus_2 HHsize

global varstep2 age caste_2 caste_3 sex_2 occupation_1 occupation_2 occupation_4 occupation_5 occupation_6 occupation_7 edulevel_2 edulevel_3 edulevel_4 maritalstatus_2 HHsize villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 username_code_1 username_code_2 username_code_3 username_code_4 username_code_5 username_code_7






********** Balance test
/*
fre sex_2
keep if sex_2==0
*/
psweight balance treat $varstep1
psweight cbpsoid treat $varstep1
psweight call balanceresults()

cls
foreach x in $varstep1 {
reg `x' i.treat, noheader
}

cls
foreach x in $varstep1 {
reg `x' i.treat [pw=_weight], noheader
}



********** Reg
cls
foreach x in fES fOPEX fCO {
glm `x' treat $varstep2 [pw=_weight], link(log) family(igaussian)
est store `x'w
qui glm `x' treat $varstep2, link(log) family(igaussian)
est store `x'r
}

esttab fESw fOPEXw fCOw, drop(_cons $varstep2)


/*
*** Before weighting
esttab fESr fOPEXr fCOr using "reg_demo_nopw.tex", replace f ///
	label booktabs b(3) p(3) eqlabels(none) alignment(S) collabels("\multicolumn{1}{c}{$\beta$ / Std. Err.}") ///
	drop(_cons $varstep2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N r2 r2_a F p, fmt(0 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"\(R^{2}\)"' `"Adjusted \(R^{2}\)"' `"F-stat"' `"p-value"'))


*** After weighting
esttab fESw fOPEXw fCOw using "reg_demo_pw.tex", replace f ///
	label booktabs b(3) p(3) eqlabels(none) alignment(S) collabels("\multicolumn{1}{c}{$\beta$ / Std. Err.}") ///
	drop(_cons $varstep2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N r2 r2_a F p, fmt(0 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"\(R^{2}\)"' `"Adjusted \(R^{2}\)"' `"F-stat"' `"p-value"'))
*/
****************************************
* END


























****************************************
* Lockdown
****************************************
cls
use "panel_stab_v2_pooled_long", clear

********** Preparation données

*** Username
encode username, gen(username_code)
ta username_code

*** Occupations and income
fre mainocc_occupation_indiv
recode mainocc_occupation_indiv (.=0) (5=4)
rename mainocc_occupation_indiv occupation
recode annualincome_indiv (.=0)
recode maritalstatus (1=0) (2=1) (3=1) (4=1)
fre edulevel
recode edulevel (4=3)
label define maritalstatus 0"Married" 1"Non-married", replace
label values maritalstatus maritalstatus

*** Var creation
global quali caste sex occupation edulevel villageid maritalstatus username_code
foreach x in $quali {
ta `x', gen(`x'_)
}

global var age caste_2 caste_3 sex_2 occupation_1 occupation_2 occupation_4 occupation_5 occupation_6 occupation_7 edulevel_2 edulevel_3 edulevel_4 maritalstatus_2 username_code_1 username_code_2 username_code_3 username_code_4 username_code_5 username_code_7

global treat dummyexposure


*** Clean Database
keep if year==2020
keep fES fOPEX fCO $var $treat villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 HHID_panel INDID_panel egoid annualincome_indiv assets_total1000 HHsize
rename dummyexposure treat 

label var treat "Demonetisation (T=1)"
label var age "Age"
label var caste_2 "Caste: Middle"
label var caste_3 "Caste: Upper"
label var sex_2 "Sex: Female"
label var occupation_1 "Occ: No occupation"
label var occupation_2 "Occ: Agri SE"
label var occupation_4 "Occ: Casual"
label var occupation_5 "Occ: Regular"
label var occupation_6 "Occ: Self-emp"
label var occupation_7 "Occ: MGNREGA"
label var edulevel_2 "Edu: Primary completed"
label var edulevel_3 "Edu: High-School"
label var edulevel_4 "Edu: HSC/Diploma or more"
label var maritalstatus_2 "MS: Unmarried"
label var annualincome_indiv "Income"
label var HHsize "Household size"


global varstep1 age caste_2 caste_3 sex_2 occupation_1 occupation_2 occupation_4 occupation_5 occupation_6 occupation_7 edulevel_2 edulevel_3 edulevel_4 maritalstatus_2 HHsize

global varstep2 age caste_2 caste_3 sex_2 occupation_1 occupation_2 occupation_4 occupation_5 occupation_6 occupation_7 edulevel_2 edulevel_3 edulevel_4 maritalstatus_2 HHsize villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 username_code_1 username_code_2 username_code_3 username_code_4 username_code_5 username_code_7







********** Balance test
psweight balance treat $varstep1
psweight cbpsoid treat $varstep1
psweight call balanceresults()

cls
foreach x in $varstep1 {
reg `x' i.treat, noheader
}

cls
foreach x in $varstep1 {
reg `x' i.treat [pw=_weight], noheader
}






********** Reg
cls
foreach x in fES fOPEX fCO {
glm `x' treat $varstep2 [pw=_weight], link(log) family(igaussian)
est store `x'w
qui glm `x' treat $varstep2, link(log) family(igaussian)
est store `x'r
}

esttab fESw fOPEXw fCOw, drop(_cons $varstep2)


/*
*** Before weighting
esttab fESr fOPEXr fCOr using "reg_lock_nopw.tex", replace f ///
	label booktabs b(3) p(3) eqlabels(none) alignment(S) collabels("\multicolumn{1}{c}{$\beta$ / Std. Err.}") ///
	drop(_cons $varstep2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N r2 r2_a F p, fmt(0 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"\(R^{2}\)"' `"Adjusted \(R^{2}\)"' `"F-stat"' `"p-value"'))


*** After weighting
esttab fESw fOPEXw fCOw using "reg_lock_pw.tex", replace f ///
	label booktabs b(3) p(3) eqlabels(none) alignment(S) collabels("\multicolumn{1}{c}{$\beta$ / Std. Err.}") ///
	drop(_cons $varstep2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N r2 r2_a F p, fmt(0 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"\(R^{2}\)"' `"Adjusted \(R^{2}\)"' `"F-stat"' `"p-value"'))
*/
****************************************
* END












