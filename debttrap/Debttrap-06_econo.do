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
* Both nonparametric graphs
****************************************

********** Household
use"panel_HH_v3", clear
* 
drop if timeperiod==.
keep if dummyloans_HH1==1
keep if dummyloans_HH2==1
drop if year==2020
drop if year==2010
*
lpoly w5_dsr2 w5_dsr1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(0 180) xline(30)) ///
bwidth(42.3) pwidth(63.4) ///
xtitle("DSR (2016-2017)") ytitle("DSR (2020-2021)") ///
note("Bandwidth=42.3, Pilot bandwidth=63.4", size(vsmall)) ///
title("(a) Household") legend(off) name(hhall, replace) scale(1.1)


********** Individual
use"panel_indiv_v3", clear
* 
drop if timeperiod==.
keep if dummyloans1==1
keep if dummyloans2==1
drop if year==2020
drop if year==2010
*
lpoly w5_dsr2 w5_dsr1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(0 300) xline(30)) ///
bwidth(46.9) pwidth(70.3) ///
xtitle("DSR (2016-2017)") ytitle("DSR (2020-2021)") ///
note("Bandwidth=46.9, Pilot bandwidth=70.3", size(vsmall)) ///
title("(b) Individual") legend(off) name(indivall, replace) scale(1.1)



********** Combine
graph combine hhall indivall, col(2) note("Kernel: Epanechnikov, Degree=4") name(comb, replace)
graph export "graph/nonpara.png", as(png) replace

****************************************
* END













****************************************
* Equilibrium
****************************************

********** Household level
use"panel_HH_v3", clear

* Selection
fre timeperiod
drop if timeperiod==.
keep if dummyloans_HH1==1
keep if dummyloans_HH2==1
drop if year==2020
drop if year==2010

* All
eq_lpoly w5_dsr2 w5_dsr1
* By caste
foreach i in 0 1 {
preserve
keep if dalits==`i'
eq_lpoly w5_dsr2 w5_dsr1
restore
}
* By land
foreach i in 0 1 {
preserve
keep if ownland==`i'
eq_lpoly w5_dsr2 w5_dsr1
restore
}


********** Individual level
use"panel_indiv_v3", clear

* Selection
fre timeperiod
drop if timeperiod==.
keep if dummyloans1==1
keep if dummyloans2==1
drop if year==2020
drop if year==2010


* All
eq_lpoly w5_dsr2 w5_dsr1

* By gender
foreach i in 0 1 {
preserve
keep if female==`i'
eq_lpoly w5_dsr2 w5_dsr1
restore
}

* By caste
foreach i in 0 1 {
preserve
keep if dalits==`i'
eq_lpoly w5_dsr2 w5_dsr1
restore
}

* By agri
foreach i in 0 1 {
preserve
keep if ownland==`i'
eq_lpoly w5_dsr2 w5_dsr1
restore
}

****************************************
* END












****************************************
* Household level parametric
****************************************
use"panel_HH_v3", clear

* Selection
fre timeperiod
drop if timeperiod==.
keep if dummyloans_HH1==1
keep if dummyloans_HH2==1
drop if year==2020
drop if year==2010


********** No int
reg diff_w5_dsr ///
c.w5_dsr1##c.w5_dsr1##c.w5_dsr1##c.w5_dsr1 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child worker sexratio ///
log_wealthbis goldquantity_HH log_income log_saving i.ownland ///
dummylock dummydemonetisation i.dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9
est store r1

********** Land int
reg diff_w5_dsr ///
c.w5_dsr1##c.w5_dsr1##c.w5_dsr1##c.w5_dsr1##i.ownland ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child worker sexratio ///
log_wealthbis goldquantity_HH log_income log_saving ///
dummylock dummydemonetisation i.dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9
est store r2

********** Dalits int
reg diff_w5_dsr ///
c.w5_dsr1##c.w5_dsr1##c.w5_dsr1##c.w5_dsr1##i.dalits ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child worker sexratio ///
log_wealthbis goldquantity_HH log_income log_saving i.ownland ///
dummylock dummydemonetisation ///
village1 village2 village3 village4 village5 village6 village7 village8 village9
est store r3


********** Both int
reg diff_w5_dsr ///
c.w5_dsr1##c.w5_dsr1##c.w5_dsr1##c.w5_dsr1##i.dalits##i.ownland ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child worker sexratio ///
log_wealthbis goldquantity_HH log_income log_saving ///
dummylock dummydemonetisation ///
village1 village2 village3 village4 village5 village6 village7 village8 village9
est store r4

********** Tables
esttab r1 r2 r3 r4 using "Household.csv", replace ///
	b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END















