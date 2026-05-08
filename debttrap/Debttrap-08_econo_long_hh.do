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






/*
****************************************
* Winsorise 1%
****************************************
use"panel_HH_v3", clear

* Selection
fre timeperiod
drop if timeperiod==.
keep if dummyloans_HH1==1
keep if dummyloans_HH2==1
ta year
drop if year==2020


********** Nonparametric regression
lpoly w1_dsr2 w1_dsr1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(0 400) xline(30)) ///
xtitle("DSR t") ytitle("DSR t+1") ///
xlabel(0(50)450) ylabel(0(50)400) ///
title("Household level analysis (w1)") legend(off) name(all, replace)
graph export "graph/hh_w1_long.png", replace



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


********** Parametric
xtset HHFE year

* FE
xtreg diff_w1_dsr ///
w1_dsr1 w1_dsr1_2 w1_dsr1_3 w1_dsr1_4 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child ownland log_wealth log_income log_saving goldquantity_HH ///
dummylock dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9, fe

* CRE (xthyrbid)
/*
xthybrid diff_w1_dsr ///
w1_dsr1 w1_dsr1_2 w1_dsr1_3 w1_dsr1_4 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child ownland log_wealth log_income log_saving goldquantity_HH ///
dummylock dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9, cre clusterid(HHFE) full
*/

* Vars CRE
foreach x in ///
w1_dsr1 w1_dsr1_2 w1_dsr1_3 w1_dsr1_4 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child ownland log_wealth log_income log_saving goldquantity_HH ///
dummylock dummydemonetisation dummymarriage {
bys HHID_panel: egen m_`x'=mean(`x')
}
bys HHID_panel: gen nby=_N
ta year, gen(y)

global mean m_w1_dsr1 m_w1_dsr1_2 m_w1_dsr1_3 m_w1_dsr1_4 m_head_female m_head_age m_head_age2 m_head_nonmarried m_head_occ1 m_head_occ2 m_head_occ4 m_head_occ5 m_head_occ6 m_head_occ7 m_head_educ2 m_head_educ3 m_HHsize m_HH_count_child m_ownland m_log_wealth m_log_income m_log_saving m_goldquantity_HH m_dummylock m_dummydemonetisation m_dummymarriage

* CRE
xtreg diff_w1_dsr ///
w1_dsr1 w1_dsr1_2 w1_dsr1_3 w1_dsr1_4 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child ownland log_wealth log_income log_saving goldquantity_HH ///
dummylock dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 $mean, re

****************************************
* END
*/















****************************************
* Winsorise 5%
****************************************
use"panel_HH_v3", clear

* Selection
fre timeperiod
drop if timeperiod==.
keep if dummyloans_HH1==1
keep if dummyloans_HH2==1
ta year
*drop if year==2020
fre landstatus
replace ownland=1 if landstatus==3

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

********** Parametric
xtset HHFE year

* FE
xtreg diff_w5_dsr ///
w5_dsr1 w5_dsr1_2 w5_dsr1_3 w5_dsr1_4 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child worker sexratio ///
log_wealth log_saving log_incagri log_incnonagri ///
dummylock dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9, fe

* Quantile
/*
mmqreg diff_w5_dsr ///
w5_dsr1 w5_dsr1_2 w5_dsr1_3 w5_dsr1_4 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child ownland log_wealth log_income log_saving goldquantity_HH ///
dummylock dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 ///
, abs(HHFE) q(.1 .2 .3 .4 .5 .6 .7 .8 .9) cluster(HHFE)
*/


* CRE (xthybrid)
/*
xthybrid diff_w5_dsr ///
w5_dsr1 w5_dsr1_2 w5_dsr1_3 w5_dsr1_4 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child worker ownland log_wealth log_income log_saving goldquantity_HH ///
dummylock dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9, cre clusterid(HHFE)
*/

* Vars CRE
foreach x in ///
w5_dsr1 w5_dsr1_2 w5_dsr1_3 w5_dsr1_4 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child ownland log_wealth log_income log_saving goldquantity_HH ///
dummylock dummydemonetisation dummymarriage {
bys HHID_panel: egen m_`x'=mean(`x')
}
bys HHID_panel: gen nby=_N
ta year, gen(y)

global mean m_w5_dsr1 m_w5_dsr1_2 m_w5_dsr1_3 m_w5_dsr1_4 m_head_female m_head_age m_head_age2 m_head_nonmarried m_head_occ1 m_head_occ2 m_head_occ4 m_head_occ5 m_head_occ6 m_head_occ7 m_head_educ2 m_head_educ3 m_HHsize m_HH_count_child m_ownland m_log_wealth m_log_income m_log_saving m_goldquantity_HH m_dummylock m_dummydemonetisation m_dummymarriage

* CRE
xtreg diff_w5_dsr ///
w5_dsr1 w5_dsr1_2 w5_dsr1_3 w5_dsr1_4 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child ownland log_wealth log_income log_saving goldquantity_HH ///
dummylock dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 $mean, re

****************************************
* END
*/








****************************************
* No winsorise
****************************************
use"panel_HH_v3", clear

* Selection
fre timeperiod
drop if timeperiod==.
keep if dummyloans_HH1==1
keep if dummyloans_HH2==1
ta year
drop if year==2020

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

********** Parametric
xtset HHFE year

* FE
xtreg diff_dsr ///
dsr1 dsr1_2 dsr1_3 dsr1_4 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child ownland log_wealth log_income log_saving goldquantity_HH ///
dummylock dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9, fe

* CRE (xthybrid)
/*
xthybrid diff_dsr ///
dsr1 dsr1_2 dsr1_3 dsr1_4 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child ownland log_wealth log_income log_saving goldquantity_HH ///
dummylock dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9, cre clusterid(HHFE)
*/

* Vars CRE
foreach x in ///
dsr1 dsr1_2 dsr1_3 dsr1_4 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child ownland log_wealth log_income log_saving goldquantity_HH ///
dummylock dummydemonetisation dummymarriage {
bys HHID_panel: egen m_`x'=mean(`x')
}
bys HHID_panel: gen nby=_N
ta year, gen(y)

global mean m_dsr1 m_dsr1_2 m_dsr1_3 m_dsr1_4 m_head_female m_head_age m_head_age2 m_head_nonmarried m_head_occ1 m_head_occ2 m_head_occ4 m_head_occ5 m_head_occ6 m_head_occ7 m_head_educ2 m_head_educ3 m_HHsize m_HH_count_child m_ownland m_log_wealth m_log_income m_log_saving m_goldquantity_HH m_dummylock m_dummydemonetisation m_dummymarriage

* CRE
xtreg diff_dsr ///
dsr1 dsr1_2 dsr1_3 dsr1_4 ///
head_female head_age head_age2 head_nonmarried ///
head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 ///
head_educ2 head_educ3 ///
HHsize HH_count_child ownland log_wealth log_income log_saving goldquantity_HH ///
dummylock dummydemonetisation dummymarriage dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 $mean, re

****************************************
* END

