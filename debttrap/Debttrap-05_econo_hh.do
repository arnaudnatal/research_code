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
cd"C:\Users\anatal\Documents\DT\Analysis"
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
use"panel_HH_v2", clear

* Selection
drop if timeperiod==.
keep if dummyloans_HH1==1
keep if dummyloans_HH2==1

* Graph
lpoly dsr_r2 dsr_r1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(0 200) xline(0 30) yline(0)) ///
xtitle("t") ytitle("t+1") ///
title("") legend(off) name(all, replace)

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
drop if timeperiod==.

*
keep HHID_panel HHFE year ///
dsr_r1 dsr_r2 ///
log_wealth log_income ownland ///
HHsize HH_count_child nbworker_HH nbnonworker_HH ///
head_sex head_age head_mocc_occupation head_edulevel head_nonmarried ///
dummylock dummydemonetisation dummymarriage ///
dalits villageid

* Panel
xtset HHFE year

* First diff
gen d_dsr=dsr_r2-dsr_r1

* FE
xtreg d_dsr c.dsr_r1##c.dsr_r1##c.dsr_r1##c.dsr_r1 ///
i.head_sex c.head_age##c.head_age i.head_mocc_occupation i.head_edulevel i.head_nonmarried ///
HHsize HH_count_child i.ownland log_wealth log_income ///
i.dummylock i.dummydemonetisation i.dummymarriage, fe

****************************************
* END












