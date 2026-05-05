*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*April 29, 2026
*-----
gl link = "debttrap"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------



****************************************
* Arunachalam & Shenoy (2017)
****************************************
use"panel_HH_v2", clear

*
keep HHID_panel year log_dsr1 log_dsr2

* Step 1
gen dsr_inc=0
replace dsr_inc=1 if log_dsr1<log_dsr2

* Step 2a
sum log_dsr1, det
drop if log_dsr1<-.3364722 & log_dsr1!=.
drop if log_dsr1>6.089628 & log_dsr1!=.

* Step 2b
xtile q_dsr1=log_dsr1, n(10)


* Step 3
reg dsr_inc i.q_dsr1


****************************************
* END












****************************************
* Household level
****************************************
use"panel_HH_v2", clear

***** Graph
set graph off
foreach y in dsr isr dar {
* All
lpoly log_`y'2 log_`y'1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48)) ///
xtitle("`y' t (log) ") ytitle("`y' t+1 (log)") ///
title("All") legend(off) name(`y'_all, replace)
*graph export "graph/`y'_all.png", as(png) replace

* Dalits
lpoly log_`y'2 log_`y'1 if dalits==1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48)) ///
xtitle("`y' t (log) ") ytitle("`y' t+1 (log)") ///
title("Dalits") legend(off) name(`y'_dalits, replace)
*graph export "graph/`y'_dalits.png", as(png) replace

* Non-dalits
lpoly log_`y'2 log_`y'1 if dalits==0, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48)) ///
xtitle("`y' t (log) ") ytitle("`y' t+1 (log)") ///
title("Non-dalits") legend(off)  name(`y'_nondalits, replace)
*graph export "graph/`y'_nondalits.png", as(png) replace

* Wealth T1
lpoly log_`y'2 log_`y'1 if wealth_t==1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48)) ///
xtitle("`y' t (log) ") ytitle("`y' t+1 (log)") ///
title("Wealth T1") legend(off)  name(`y'_wt1, replace)
*graph export "graph/`y'_wealtht1.png", as(png) replace

* Wealth T2
lpoly log_`y'2 log_`y'1 if wealth_t==2, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48)) ///
xtitle("`y' t (log) ") ytitle("`y' t+1 (log)") ///
title("Wealth T2") legend(off) name(`y'_wt2, replace)
*graph export "graph/`y'_wealtht2.png", as(png) replace

* Wealth T3
lpoly log_`y'2 log_`y'1 if wealth_t==3, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48)) ///
xtitle("`y' t (log) ") ytitle("`y' t+1 (log)") ///
title("Wealth T3") legend(off) name(`y'_wt3, replace)
*graph export "graph/`y'_wealtht3.png", as(png) replace

* Income T1
lpoly log_`y'2 log_`y'1 if income_t==1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48)) ///
xtitle("`y' t (log) ") ytitle("`y' t+1 (log)") ///
title("Income T1") legend(off) name(`y'_it1, replace)
*graph export "graph/`y'_incomet1.png", as(png) replace

* Income T2
lpoly log_`y'2 log_`y'1 if income_t==2, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48)) ///
xtitle("`y' t (log) ") ytitle("`y' t+1 (log)") ///
title("Income T2") legend(off) name(`y'_it2, replace)
*graph export "graph/`y'_incomet2.png", as(png) replace

* Income T3
lpoly log_`y'2 log_`y'1 if income_t==3, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48)) ///
xtitle("`y' t (log) ") ytitle("`y' t+1 (log)") ///
title("Income T3") legend(off) name(`y'_it3, replace)
*graph export "graph/`y'_incomet3.png", as(png) replace
}

set graph on
graph combine dsr_all dsr_dalits dsr_nondalits dsr_wt1 dsr_wt2 dsr_wt3 dsr_it1 dsr_it2 dsr_it3, col(3) name(dsr, replace)
graph export "graph/dsr_hh.png", as(png) replace


***** Reg
npregress kernel log_dsr2 log_dsr1, kernel(epanechnikov) reps(50)

****************************************
* END











****************************************
* Individual level
****************************************
use"panel_indiv_v2", clear

set graph off

foreach y in dsr isr loan {
* All
lpoly log_`y'2 log_`y'1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48))  ///
xtitle("`y' t (log) ") ytitle("`y' t+1 (log)") ///
title("All") legend(off) name(`y'_indivall, replace)
*graph export "graph/indiv_`y'all.png", as(png) replace

* Female
lpoly log_`y'2 log_`y'1 if female==1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48))  ///
xtitle("`y' t (log) ") ytitle("`y' t+1 (log)") ///
title("Women") legend(off) name(`y'_indivfem, replace)
*graph export "graph/indiv_`y'female.png", as(png) replace

* Male
lpoly log_`y'2 log_`y'1 if female==0, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48))  ///
xtitle("`y' t (log) ") ytitle("`y' t+1 (log)") ///
title("Men") legend(off) name(`y'_indivmen, replace)
*graph export "graph/indiv_`y'male.png", as(png) replace
}

set graph on
graph combine dsr_indivall dsr_indivfem dsr_indivmen, col(3) name(dsrindiv, replace)
graph export "graph/dsr_indiv.png", as(png) replace



****************************************
* END

