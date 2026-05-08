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
* Winsorise 1%
****************************************
use"panel_HH_v3", clear

* Selection
fre timeperiod
keep if timeperiod==2
keep if dummyloans_HH1==1
keep if dummyloans_HH2==1
drop if dsr1>1000

/*
********** Nonparametric regression
lpoly w1_dsr2 w1_dsr1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(0 400) xline(30)) ///
xtitle("DSR t") ytitle("DSR t+1") ///
title("Household level analysis (w1)") legend(off) name(all, replace)
graph export "graph/hh_w1.png", replace
*/

/*
********** Nonparametric equilibrium
* All
eq_lpoly w1_dsr2 w1_dsr1
* By caste
foreach i in 0 1 {
preserve
keep if dalits==`i'
eq_lpoly w1_dsr2 w1_dsr1
restore
}
* By land
foreach i in 0 1 {
preserve
keep if ownland==`i'
eq_lpoly w1_dsr2 w1_dsr1
restore
}
*/

********** OLS
reg diff_w1_dsr ///
w1_dsr1 w1_dsr1_2 w1_dsr1_3 w1_dsr1_4 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child ownland log_wealth log_income log_saving goldquantity_HH ///
dummylock dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9


********** Quantile regression
sqreg diff_w1_dsr ///
w1_dsr1 w1_dsr1_2 w1_dsr1_3 w1_dsr1_4 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child ownland log_wealth log_income log_saving goldquantity_HH ///
dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9, q(.5) reps(50)

* Graph
/*
import excel "Qreg.xlsx", sheet("Sheet1") firstrow clear
*
twoway ///
(rarea max min quantile, color(gs5%30)) ///
(line coef quantile, lcolor(gs5) yline(0, lcolor(black))) ///
, xlabel(1(1)9) ylabel(-.9(.3)1.5) ///
xtitle("Quantile") ///
title("Diff dsr") ///
legend(order(2 "Effect" 1 "95 per cent confidence interval") pos(6) col(2)) ///
name(hh, replace) scale (1.2) aspectratio(3)
*/
****************************************
* END
















****************************************
* Winsorise 5%
****************************************
use"panel_HH_v3", clear

* Selection
fre timeperiod
keep if timeperiod==2
keep if dummyloans_HH1==1
keep if dummyloans_HH2==1
*drop if dsr1>1000
*replace ownland=1 if landstatus==3

/*
********** Nonparametric regression
lpoly w5_dsr2 w5_dsr1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(0 180) xline(30)) ///
xtitle("DSR t") ytitle("DSR t+1") ///
title("Household level analysis (w5)") legend(off) name(all, replace)
graph export "graph/hh_w5.png", replace
*/

/*
********** Nonparametric equilibrium
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
*/

********** OLS
reg diff_w5_dsr ///
w5_dsr1 w5_dsr1_2 w5_dsr1_3 w5_dsr1_4 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child worker sexratio log_wealth log_incagri log_incnonagri log_saving ///
dummylock dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9


********** Quantile regression
sqreg diff_w5_dsr ///
w5_dsr1 w5_dsr1_2 w5_dsr1_3 w5_dsr1_4 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child ownland log_wealth log_income log_saving goldquantity_HH ///
dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9, q(.5) reps(50)

* Graph
/*
import excel "Qreg.xlsx", sheet("Sheet1") firstrow clear
*
twoway ///
(rarea max min quantile, color(gs5%30)) ///
(line coef quantile, lcolor(gs5) yline(0, lcolor(black))) ///
, xlabel(1(1)9) ylabel(-.9(.3)1.5) ///
xtitle("Quantile") ///
title("Diff dsr") ///
legend(order(2 "Effect" 1 "95 per cent confidence interval") pos(6) col(2)) ///
name(hh, replace) scale (1.2) aspectratio(3)
*/
****************************************
* END









****************************************
* No winsorise
****************************************
use"panel_HH_v3", clear

* Selection
fre timeperiod
keep if timeperiod==2
keep if dummyloans_HH1==1
keep if dummyloans_HH2==1
drop if dsr1>1000

/*
********** Nonparametric regression
lpoly dsr2 dsr1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(0 400) xline(30)) ///
xtitle("DSR t") ytitle("DSR t+1") ///
title("Household level analysis (nw)") legend(off) name(all, replace)
graph export "graph/hh_nw.png", replace
*/

/*
********** Nonparametric equilibrium
* All
eq_lpoly dsr2 dsr1
* By caste
foreach i in 0 1 {
preserve
keep if dalits==`i'
eq_lpoly dsr2 dsr1
restore
}
* By land
foreach i in 0 1 {
preserve
keep if ownland==`i'
eq_lpoly dsr2 dsr1
restore
}
*/

********** OLS
reg diff_dsr ///
dsr1 dsr1_2 dsr1_3 dsr1_4 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child ownland log_wealth log_income log_saving goldquantity_HH ///
dummylock dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9


********** Quantile regression
sqreg diff_dsr ///
dsr1 dsr1_2 dsr1_3 dsr1_4 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child ownland log_wealth log_income log_saving goldquantity_HH ///
dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9, q(.5) reps(50)

* Graph
/*
import excel "Qreg.xlsx", sheet("Sheet1") firstrow clear
*
twoway ///
(rarea max min quantile, color(gs5%30)) ///
(line coef quantile, lcolor(gs5) yline(0, lcolor(black))) ///
, xlabel(1(1)9) ylabel(-.9(.3)1.5) ///
xtitle("Quantile") ///
title("Diff dsr") ///
legend(order(2 "Effect" 1 "95 per cent confidence interval") pos(6) col(2)) ///
name(hh, replace) scale (1.2) aspectratio(3)
*/
****************************************
* END

