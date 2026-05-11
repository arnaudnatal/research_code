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
* Nonparametric
****************************************
use"panel_HH_v3", clear

* Selection
fre timeperiod
drop if timeperiod==.
keep if dummyloans_HH1==1
keep if dummyloans_HH2==1
drop if year==2020
drop if year==2010


********** Nonparametric regression
lpoly w5_dsr2 w5_dsr1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(0 180) xline(30)) ///
xtitle("DSR t") ytitle("DSR t+1") ///
title("Household level") legend(off) name(hhall, replace)
graph export "graph/hh_w5.png", replace



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



****************************************
* END














****************************************
* Parametrics
****************************************
use"panel_HH_v3", clear

* Selection
fre timeperiod
drop if timeperiod==.
keep if dummyloans_HH1==1
keep if dummyloans_HH2==1
drop if year==2020
drop if year==2010


/*
NW 1500
W1 415
W2 300
W3 245
W4 200
W5 178
W6 152
W7 137
W8 125
W9 110
W10 102
*/

/*
Vérifier si les résultats avec w5 sont robustes à w6 w7 w8
*/

local v=179
replace w5_dsr1=`v' if w5_dsr1>`v'
replace w5_dsr2=`v' if w5_dsr2>`v'
replace diff_w5_dsr=w5_dsr2-w5_dsr1

********** No int
reg diff_w5_dsr ///
c.w5_dsr1##c.w5_dsr1##c.w5_dsr1##c.w5_dsr1 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child worker sexratio ///
log_wealthbis goldquantity_HH log_income log_saving ownland ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9

cls
********** Land int
reg diff_w5_dsr ///
c.w5_dsr1##c.w5_dsr1##c.w5_dsr1##c.w5_dsr1##c.ownland ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child worker sexratio ///
log_wealthbis goldquantity_HH log_income log_saving ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9

********** Land and dalits int
reg diff_w5_dsr ///
c.w5_dsr1##c.w5_dsr1##c.w5_dsr1##c.w5_dsr1##c.ownland##i.dalits ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child worker sexratio ///
log_wealthbis goldquantity_HH log_income log_saving ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9

****************************************
* END















****************************************
* Robustness
****************************************
use"panel_HH_v3", clear

* Selection
fre timeperiod
drop if timeperiod==.
keep if dummyloans_HH1==1
keep if dummyloans_HH2==1
drop if year==2020
drop if year==2010

********** Winsorizing 2%
reg diff_w2_dsr ///
c.w2_dsr1##c.w2_dsr1##c.w2_dsr1##c.w2_dsr1 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child worker sexratio ///
log_wealthbis goldquantity_HH log_income log_saving ownland ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9

reg diff_w2_dsr ///
c.w2_dsr1##c.w2_dsr1##c.w2_dsr1##c.w2_dsr1##c.ownland ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child worker sexratio ///
log_wealthbis goldquantity_HH log_income log_saving ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9

reg diff_w2_dsr ///
c.w2_dsr1##c.w2_dsr1##c.w2_dsr1##c.w2_dsr1##c.ownland##i.dalits ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child worker sexratio ///
log_wealthbis goldquantity_HH log_income log_saving ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9



********** Winsorizing 1%
reg diff_w1_dsr ///
c.w1_dsr1##c.w1_dsr1##c.w1_dsr1##c.w1_dsr1 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child worker sexratio ///
log_wealthbis goldquantity_HH log_income log_saving ownland ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9

reg diff_w1_dsr ///
c.w1_dsr1##c.w1_dsr1##c.w1_dsr1##c.w1_dsr1##c.ownland ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child worker sexratio ///
log_wealthbis goldquantity_HH log_income log_saving ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9

reg diff_w1_dsr ///
c.w1_dsr1##c.w1_dsr1##c.w1_dsr1##c.w1_dsr1##c.ownland##i.dalits ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child worker sexratio ///
log_wealthbis goldquantity_HH log_income log_saving ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9




********** No winsorizing
reg diff_dsr ///
c.dsr1##c.dsr1##c.dsr1##c.dsr1 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child worker sexratio ///
log_wealthbis goldquantity_HH log_income log_saving ownland ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9

reg diff_dsr ///
c.dsr1##c.dsr1##c.dsr1##c.dsr1##c.ownland ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child worker sexratio ///
log_wealthbis goldquantity_HH log_income log_saving ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9

reg diff_dsr ///
c.dsr1##c.dsr1##c.dsr1##c.dsr1##c.ownland##i.dalits ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child worker sexratio ///
log_wealthbis goldquantity_HH log_income log_saving ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9



********** Quantile
sqreg diff_dsr ///
c.dsr1##c.dsr1##c.dsr1##c.dsr1 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child worker sexratio ///
log_wealthbis goldquantity_HH log_income log_saving ownland ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9, q(.5) reps(50)

****************************************
* END


