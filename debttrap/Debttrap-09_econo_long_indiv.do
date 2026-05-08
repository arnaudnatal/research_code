*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*April 29, 2026
*-----
gl link = "debttrap"
*Econo indiv level
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------







****************************************
* Winsorise 1%
****************************************
use"panel_indiv_v3", clear

* Selection
ta timeperiod
drop if timeperiod==.
keep if dummyloans1==1
keep if dummyloans2==1

/*
********** Nonparametric regression
lpoly w1_dsr2 w1_dsr1, kernel(epanechnikov) degree(4) ci noscatter  ///
addplot(function y=x, range(0 1100) xline(30)) ///
xtitle("DSR t") ytitle("DSR t+1") ///
title("Individual level analysis (w1)") legend(off) name(dsr_all, replace)
graph export "graph/indiv_w1.png", replace
*/

/*
********** Equilibrium
eq_lpoly w1_dsr2 w1_dsr1
* By gender
foreach i in 0 1 {
preserve
keep if female==`i'
eq_lpoly w1_dsr2 w1_dsr1
restore
}
* By marital status
foreach i in 0 1 {
preserve
keep if nonmarried==`i'
eq_lpoly w1_dsr2 w1_dsr1
restore
}
* By occupation
foreach i in 1 2 3 4 6 7 {
preserve
keep if occ`i'==1
eq_lpoly w1_dsr2 w1_dsr1
restore
}
* By education
foreach i in 1 2 3 4 {
preserve
keep if educ`i'==1
eq_lpoly w1_dsr2 w1_dsr1
restore
}
*/

********** Parametric
xtset INDIVFE year

* FE
xtreg diff_w1_dsr w1_dsr1 w1_dsr1_2 w1_dsr1_3 w1_dsr1_4 ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealth log_income ///
dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9, fe cluster(HHFE)

* FE within
xtreg diff_w1_dsr w1_dsr1 w1_dsr1_2 w1_dsr1_3 w1_dsr1_4 ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealth log_income ///
dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 i.HHFE, fe

* Vars CRE
foreach x in ///
w1_dsr1 w1_dsr1_2 w1_dsr1_3 w1_dsr1_4 ///
age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealth log_income ///
dummydemonetisation dummymarriage {
bys HHID_panel: egen m_`x'=mean(`x')
}
bys HHID_panel: gen nby=_N
ta year, gen(y)

global mean m_w1_dsr1 m_w1_dsr1_2 m_w1_dsr1_3 m_w1_dsr1_4 m_age m_age2 m_nonmarried m_occ1 m_occ2 m_occ4 m_occ5 m_occ6 m_occ7 m_educ2 m_educ3 m_educ4 m_log_saving m_goldquantity m_HHsize m_HH_count_child m_ownland m_log_wealth m_log_income m_dummydemonetisation m_dummymarriage

* CRE
xtreg diff_w1_dsr w1_dsr1 w1_dsr1_2 w1_dsr1_3 w1_dsr1_4 ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealth log_income ///
dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 $mean, re cluster(HHFE)

* CRE within
xtreg diff_w1_dsr w1_dsr1 w1_dsr1_2 w1_dsr1_3 w1_dsr1_4 ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealth log_income ///
dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 i.HHFE $mean, re

****************************************
* END
















****************************************
* Winsorise 5%
****************************************
use"panel_indiv_v3", clear

* Selection
ta timeperiod
drop if timeperiod==.
keep if dummyloans1==1
keep if dummyloans2==1

/*
********** Nonparametric regression
lpoly w5_dsr2 w5_dsr1, kernel(epanechnikov) degree(4) ci noscatter  ///
addplot(function y=x, range(0 300) xline(30)) ///
xtitle("DSR t") ytitle("DSR t+1") ///
title("Individual level analysis (w5)") legend(off) name(dsr_all, replace)
graph export "graph/indiv_w5.png", replace
*/

/*
********** Equilibrium
eq_lpoly w5_dsr2 w5_dsr1
* By gender
foreach i in 0 1 {
preserve
keep if female==`i'
eq_lpoly w5_dsr2 w5_dsr1
restore
}
* By marital status
foreach i in 0 1 {
preserve
keep if nonmarried==`i'
eq_lpoly w5_dsr2 w5_dsr1
restore
}
* By occupation
foreach i in 1 2 3 4 6 7 {
preserve
keep if occ`i'==1
eq_lpoly w5_dsr2 w5_dsr1
restore
}
* By education
foreach i in 1 2 3 4 {
preserve
keep if educ`i'==1
eq_lpoly w5_dsr2 w5_dsr1
restore
}
*/

********** Parametric
xtset INDIVFE year

* FE
xtreg diff_w5_dsr w5_dsr1 w5_dsr1_2 w5_dsr1_3 w5_dsr1_4 ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealth log_income ///
dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9, fe cluster(HHFE)

* FE within
xtreg diff_w5_dsr w5_dsr1 w5_dsr1_2 w5_dsr1_3 w5_dsr1_4 ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealth log_income ///
dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 i.HHFE, fe

* Vars CRE
foreach x in ///
w5_dsr1 w5_dsr1_2 w5_dsr1_3 w5_dsr1_4 ///
age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealth log_income ///
dummydemonetisation dummymarriage {
bys HHID_panel: egen m_`x'=mean(`x')
}
bys HHID_panel: gen nby=_N
ta year, gen(y)

global mean m_w5_dsr1 m_w5_dsr1_2 m_w5_dsr1_3 m_w5_dsr1_4 m_age m_age2 m_nonmarried m_occ1 m_occ2 m_occ4 m_occ5 m_occ6 m_occ7 m_educ2 m_educ3 m_educ4 m_log_saving m_goldquantity m_HHsize m_HH_count_child m_ownland m_log_wealth m_log_income m_dummydemonetisation m_dummymarriage

* CRE
xtreg diff_w5_dsr w5_dsr1 w5_dsr1_2 w5_dsr1_3 w5_dsr1_4 ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealth log_income ///
dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 $mean, re cluster(HHFE)

* CRE within
xtreg diff_w5_dsr w5_dsr1 w5_dsr1_2 w5_dsr1_3 w5_dsr1_4 ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealth log_income ///
dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 i.HHFE $mean, re


****************************************
* END












****************************************
* No winsorise
****************************************
use"panel_indiv_v3", clear

* Selection
ta timeperiod
drop if timeperiod==.
keep if dummyloans1==1
keep if dummyloans2==1

/*
********** Nonparametric regression
lpoly dsr2 dsr1, kernel(epanechnikov) degree(4) ci noscatter  ///
addplot(function y=x, range(0 300) xline(30)) ///
xtitle("DSR t") ytitle("DSR t+1") ///
title("Individual level analysis (nw)") legend(off) name(dsr_all, replace)
graph export "graph/indiv_nw.png", replace
*/

/*
********** Equilibrium
eq_lpoly dsr2 dsr1
* By gender
foreach i in 0 1 {
preserve
keep if female==`i'
eq_lpoly dsr2 dsr1
restore
}
* By marital status
foreach i in 0 1 {
preserve
keep if nonmarried==`i'
eq_lpoly dsr2 dsr1
restore
}
* By occupation
foreach i in 1 2 3 4 6 7 {
preserve
keep if occ`i'==1
eq_lpoly dsr2 dsr1
restore
}
* By education
foreach i in 1 2 3 4 {
preserve
keep if educ`i'==1
eq_lpoly dsr2 dsr1
restore
}
*/

********** Parametric
xtset INDIVFE year

* FE
xtreg diff_dsr dsr1 dsr1_2 dsr1_3 dsr1_4 ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealth log_income ///
dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9, fe cluster(HHFE)

* FE within
xtreg diff_dsr dsr1 dsr1_2 dsr1_3 dsr1_4 ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealth log_income ///
dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 i.HHFE, fe

* Vars CRE
foreach x in ///
dsr1 dsr1_2 dsr1_3 dsr1_4 ///
age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealth log_income ///
dummydemonetisation dummymarriage {
bys HHID_panel: egen m_`x'=mean(`x')
}
bys HHID_panel: gen nby=_N
ta year, gen(y)

global mean m_dsr1 m_dsr1_2 m_dsr1_3 m_dsr1_4 m_age m_age2 m_nonmarried m_occ1 m_occ2 m_occ4 m_occ5 m_occ6 m_occ7 m_educ2 m_educ3 m_educ4 m_log_saving m_goldquantity m_HHsize m_HH_count_child m_ownland m_log_wealth m_log_income m_dummydemonetisation m_dummymarriage

* CRE
xtreg diff_dsr dsr1 dsr1_2 dsr1_3 dsr1_4 ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealth log_income ///
dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 $mean, re cluster(HHFE)

* CRE within
xtreg diff_dsr dsr1 dsr1_2 dsr1_3 dsr1_4 ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealth log_income ///
dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 i.HHFE $mean, re


****************************************
* END

