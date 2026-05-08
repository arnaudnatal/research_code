*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*April 29, 2026
*-----
gl link = "debttrap"
*Economi HH level
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------





****************************************
* Transition debt // no debt
****************************************
use"panel_HH_v2", clear

* Selection
drop if timeperiod==.

ta dummyloans_HH1 dummyloans_HH2, row

****************************************
* END








****************************************
* Non-para
****************************************
use"panel_HH_v3", clear

* Graph
lpoly dsr_r2 dsr_r1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(0 200) xline(0 30) yline(0)) ///
xtitle("DSR t") ytitle("DSR t+1") ///
title("Household level analysis") legend(off) name(all, replace)
graph export "hh.png", replace

cls
* Equilibrium
eq_lpoly dsr_r2 dsr_r1

* By caste
foreach i in 0 1 {
preserve
keep if dalits==`i'
eq_lpoly dsr_r2 dsr_r1
restore
}

* By wealth
foreach i in 1 2 3 {
preserve
keep if wealth_t==`i'
eq_lpoly dsr_r2 dsr_r1
restore
}

* By income
foreach i in 1 2 3 {
preserve
keep if income_t==`i'
eq_lpoly dsr_r2 dsr_r1
restore
}

* By land
foreach i in 0 1 {
preserve
keep if ownland==`i'
eq_lpoly dsr_r2 dsr_r1
restore
}

****************************************
* END









****************************************
* Parametric
****************************************
use"panel_HH_v2", clear

* Panel
xtset HHFE year

global mean m_dsr1 m_dsr2 m_dsr3 m_dsr4 m_head_female m_head_age m_head_age2 m_head_nonmarried m_head_occ1 m_head_occ2 m_head_occ4 m_head_occ5 m_head_occ6 m_head_occ7 m_head_educ2 m_head_educ3 m_HHsize m_HH_count_child m_ownland m_log_wealth m_log_income m_dummylock m_dummydemonetisation m_dummymarriage

cls
* FE
xtreg d_dsr dsr1 dsr2 dsr3 dsr4 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child ownland log_wealth log_income ///
dummylock dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9, fe 

* CRE
xtreg d_dsr dsr1 dsr2 dsr3 dsr4 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child ownland log_wealth log_income ///
dummylock dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 ///
$mean ///
, re

****************************************
* END












