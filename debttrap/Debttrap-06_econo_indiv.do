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
cd"C:\Users\anatal\Documents\DT\Analysis"
*-------------------------





****************************************
* Transition debt // no debt
****************************************
use"panel_indiv_v2", clear

* Selection
drop if timeperiod==.

ta dummyloans1 dummyloans2, row

****************************************
* END







****************************************
* Individual level: All
****************************************
use"panel_indiv_v2", clear

* Selection
drop if timeperiod==.
keep if dummyloans1==1
keep if dummyloans2==1

* Graph
ta dsr_r1
ta dsr_r2
lpoly dsr_r2 dsr_r1, kernel(epanechnikov) degree(4) ci noscatter  ///
addplot(function y=x, range(0 1100) xline(30)) ///
xtitle("DSR t") ytitle("DSR t+1") ///
title("DSR") legend(off) name(dsr_all, replace)

cls
* Equilibrium
eq_lpoly dsr_r2 dsr_r1

* By gender
foreach i in 0 1 {
preserve
keep if female==`i'
eq_lpoly dsr_r2 dsr_r1
restore
}

* By caste
foreach i in 0 1 {
preserve
keep if dalits==`i'
eq_lpoly dsr_r2 dsr_r1
restore
}

* By marital status
foreach i in 0 1 {
preserve
keep if nonmarried==`i'
eq_lpoly dsr_r2 dsr_r1
restore
}

* By occupation
foreach i in 1 2 3 4 6 7 {
preserve
keep if occupation==`i'
eq_lpoly dsr_r2 dsr_r1
restore
}

* By education
foreach i in 0 1 2 3 {
preserve
keep if edulevel==`i'
eq_lpoly dsr_r2 dsr_r1
restore
}

****************************************
* END











****************************************
* Parametric
****************************************
use"panel_indiv_v2", clear
drop if timeperiod==.

*
keep HHID_panel INDID_panel HHFE INDIVFE year ///
dsr_r1 dsr_r2 ///
log_wealth log_income ownland ///
HHsize HH_count_child nbworker_HH nbnonworker_HH ///
female age nonmarried edulevel occupation ///
dummylock dummydemonetisation dummymarriage ///
dalits villageid

* Panel
xtset INDIVFE year

* First diff
gen d_dsr=dsr_r2-dsr_r1

* FE
xtreg d_dsr c.dsr_r1##c.dsr_r1##c.dsr_r1##c.dsr_r1 ///
i.female c.age##c.age i.occupation i.edulevel i.nonmarried ///
HHsize HH_count_child i.ownland log_wealth log_income ///
i.dummylock i.dummydemonetisation i.dummymarriage i.villageid, fe

* Within HH FE
xtreg d_dsr c.dsr_r1##c.dsr_r1##c.dsr_r1##c.dsr_r1 ///
i.female c.age##c.age i.occupation i.edulevel i.nonmarried ///
HHsize HH_count_child i.ownland log_wealth log_income ///
i.dummylock i.dummydemonetisation i.dummymarriage i.villageid ///
i.HHFE, fe

****************************************
* END
