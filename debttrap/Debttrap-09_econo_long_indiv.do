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
* Individual level: All
****************************************
use"panel_indiv_v3", clear

* Selection
ta timeperiod
keep if timeperiod==1
ta year
ta dummyloans1
ta dummyloans2
keep if dummyloans1==1
keep if dummyloans2==1

* Graph
lpoly w1_dsr2 w1_dsr1, kernel(epanechnikov) degree(4) ci noscatter  ///
addplot(function y=x, range(0 1100) xline(30)) ///
xtitle("DSR t") ytitle("DSR t+1") ///
title("Individual level analysis") legend(off) name(dsr_all, replace)
graph export "indiv.png", replace


cls
* Equilibrium
eq_lpoly w1_dsr2 w1_dsr1

* By gender
foreach i in 0 1 {
preserve
keep if female==`i'
eq_lpoly w1_dsr2 w1_dsr1
restore
}

* By caste
foreach i in 0 1 {
preserve
keep if dalits==`i'
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

****************************************
* END











****************************************
* Parametric
****************************************
use"panel_indiv_v3", clear

* Selection
drop if timeperiod==.


* Panel
xtset INDIVFE year


global mean m_dsr1 m_dsr2 m_dsr3 m_dsr4 m_female m_age m_age2 m_nonmarried m_occ1 m_occ2 m_occ4 m_occ5 m_occ6 m_occ7 m_educ2 m_educ3 m_educ4 m_HHsize m_HH_count_child m_ownland m_log_wealth m_log_income m_dummylock m_dummydemonetisation m_dummymarriage


***** Within housheold
cls
* Within HH FE
xtreg d_dsr dsr1 dsr2 dsr3 dsr4 ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 ///
HHsize HH_count_child ownland log_wealth log_income ///
dummylock dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 ///
$HH, fe

* Within HH CRE
cls
xtreg d_dsr dsr1 dsr2 dsr3 dsr4 ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 ///
HHsize HH_count_child ownland log_wealth log_income ///
dummylock dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 ///
$mean ///
$HH, re

****************************************
* END
