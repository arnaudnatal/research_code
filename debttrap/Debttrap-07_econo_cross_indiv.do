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
* Parametric OLS
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

cls
* Individual
reg diff_w1_dsr w1_dsr1 w1_dsr1_2 w1_dsr1_3 w1_dsr1_4 ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 ///
HHsize HH_count_child ownland log_wealth log_income ///
dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9, cluster(HHFE)

* Within HH
reg diff_w1_dsr w1_dsr1 w1_dsr1_2 w1_dsr1_3 w1_dsr1_4 ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 ///
HHsize HH_count_child ownland log_wealth log_income ///
dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 i.HHFE


****************************************
* END














****************************************
* Parametric quantile
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

cls
* Individual
sqreg diff_w1_dsr w1_dsr1 w1_dsr1_2 w1_dsr1_3 w1_dsr1_4 ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 ///
HHsize HH_count_child ownland log_wealth log_income ///
dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9, q(.5) reps(50)

* Within HH
sqreg diff_w1_dsr w1_dsr1 w1_dsr1_2 w1_dsr1_3 w1_dsr1_4 ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 ///
HHsize HH_count_child ownland log_wealth log_income ///
dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 i.HHFE,  q(.5) reps(50)

* Graph
import excel "Qreg.xlsx", sheet("Sheet1") firstrow clear
*
twoway ///
(rarea max min quantile, color(gs5%30)) ///
(line coef quantile, lcolor(gs5) yline(0, lcolor(black))) ///
, xlabel(1(1)9) ylabel(-.9(.3)1.5) ///
xtitle("Quantile") ///
title("Diff dsr") ///
legend(order(2 "Effect" 1 "95 per cent confidence interval") pos(6) col(2)) ///
name(indv, replace) scale (1.2) aspectratio(3)


****************************************
* END
