*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*March 16, 2026
*-----
gl link = "inequalities"
*Desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\inequalities.do"
*-------------------------










****************************************
* Asset dynamics
****************************************
use"pooled_v1", clear

* Assets dynamics for the pooled sample
npregress kernel logassets_t1 logassets_t, reps(100) kernel(epanechnikov)

* Find equilibrium state
local v="logassets_t"
summ `v' if e(sample), meanonly
local xmin=r(min)
local xmax=r(max)
*
margins, at(`v'=(`xmin'(0.025)`xmax')) saving(mhat_grid, replace)
*
preserve
use mhat_grid, clear
*
gen diff=_margin-_at1
gen signchange=diff[_n-1]*diff<=0 if _n>1
*
gen x0=_at1[_n-1]   if signchange==1
gen x1=_at1         if signchange==1
gen y0=diff[_n-1]   if signchange==1
gen y1=diff         if signchange==1
*
gen wstar=x0-y0*(x1-x0)/(y1-y0) if signchange==1
*
summ wstar, meanonly
local wstar = r(mean)
display "Estimated steady state w* = " `wstar'
restore
*

* Find slope at equilibrium state
margins, dydx(logassets_t) at(logassets_t=(6.65974 6.66974 6.67974))
/*
Si <1 l'équilibre est localement stable
Si >1 l'équilibre est localement instable
*/

* Graph trap
twoway ///
(line _Mean_logassets_t1 logassets_t, xline(6.6695962) sort) ///
(function y=x, range(0 10)) ///
,title("Pooled sample") ///
name(poo, replace)

* Graph slope
margins, dydx(logassets_t) at(logassets_t=(`xmin'(0.05)`xmax')) ///
    saving(slope_grid, replace)
preserve
use slope_grid, clear
twoway ///
    (line _margin _at1, sort) ///
    (function y=1, range(_at1) lpattern(dash)), ///
    ytitle("Local slope m'(w)") ///
    xtitle("logassets_t") ///
    legend(order(1 "Estimated local slope" 2 "Slope = 1"))
restore
/*
L'équilibre est localement stable
*/



* Groups
gen pooled_path=.
label define path 1"Below" 2"Above"
label values pooled_path path
replace pooled_path=1 if logassets_t<6.6695962
replace pooled_path=2 if logassets_t>6.6695962
ta pooled_path

ta pooled_path dalits, chi2 exp cchi2



* Assets dynamics for Dalits
preserve
keep if dalit==1
npregress kernel logassets_t1 logassets_t, reps(100) kernel(epanechnikov)
*
twoway ///
(scatter logassets_t1 logassets_t) ///
(line _Mean_logassets_t1 logassets_t , sort) ///
(function y=x, range(0 10)) ///
,title("Dalits") ///
name(dal, replace)
drop _unident_sample _Mean_logassets_t1 _d_Mean_logassets_t1_dlogassets_
restore

* Assets dynamics for non-Dalits
preserve
keep if dalit==0
npregress kernel logassets_t1 logassets_t, reps(100) kernel(epanechnikov)
*
twoway ///
(scatter logassets_t1 logassets_t) ///
(line _Mean_logassets_t1 logassets_t , sort) ///
(function y=x, range(0 10)) ///
,title("non-Dalits") ///
name(ndal, replace)
drop _unident_sample _Mean_logassets_t1 _d_Mean_logassets_t1_dlogassets_
restore

* Together
grc1leg poo dal ndal

****************************************
* END







****************************************
* Asset dynamics
****************************************
use"pooled_v1", clear

xtset panelvar year

gen diffass=logassets_t1-logassets_t

gen logincome=log(annualincome)
gen logdebt=log(loanamount_HH)


*** Macro
global head head_female head_age head_married i.head_edulevel i.head_mocc_occupation
global hh logdebt logincome sexratio HHsize


*** FE model
* Delta log assets
xtreg diffass c.logassets_t##c.logassets_t##c.logassets_t##c.logassets_t $hh $head, fe
xtreg diffass c.logincome##i.dalits c.logassets##i.dalits c.logdebt##i.dalits sexratio logHHsize $head $invar, fe


* Delta log income
xtreg d_logincome $hh $head $invar, fe
xtreg d_logincome c.logincome##i.dalits c.logassets##i.dalits c.logdebt##i.dalits sexratio logHHsize $head $invar, fe



*** Quantile regressions
* Delta log assets
xtqreg d_logassets $hh $head $invar, id(panelvar) q(.1 .2 .3 .4 .5 .6 .7 .8 .9)
xtqreg d_logassets c.logincome##i.dalits c.logassets##i.dalits c.logdebt##i.dalits sexratio logHHsize $head $invar, id(panelvar) q(.1 .2 .3 .4 .5 .6 .7 .8 .9)



* Delta log income
xtqreg d_logincome $hh $head $invar, id(panelvar) q(.1 .2 .3 .4 .5 .6 .7 .8 .9)
xtqreg d_logincome c.logincome##i.dalits c.logassets##i.dalits c.logdebt##i.dalits sexratio logHHsize $head $invar, id(panelvar) q(.1 .2 .3 .4 .5 .6 .7 .8 .9)





****************************************
* END



















****************************************
* Debt dynamics
****************************************
use"pooled_debt_v1", clear

ta debt_t
drop if debt_t==1

ta debt_t1
drop if debt_t1==1

* Assets dynamics for the pooled sample
npregress kernel logdebt_t1 logdebt_t, reps(100) kernel(epanechnikov)
npgraph

* Find equilibrium state
local v="logdebt_t"
summ `v' if e(sample), meanonly
local xmin=r(min)
local xmax=r(max)
*
margins, at(`v'=(`xmin'(0.25)`xmax')) saving(mhat_grid, replace)
*
preserve
use mhat_grid, clear
*
gen diff=_margin-_at1
gen signchange=diff[_n-1]*diff<=0 if _n>1
*
gen x0=_at1[_n-1]   if signchange==1
gen x1=_at1         if signchange==1
gen y0=diff[_n-1]   if signchange==1
gen y1=diff         if signchange==1
*
gen wstar=x0-y0*(x1-x0)/(y1-y0) if signchange==1
*
summ wstar, meanonly
local wstar = r(mean)
display "Estimated steady state w* = " `wstar'
restore
*

* Find slope at equilibrium state
margins, dydx(logdebt_t) at(logdebt_t=(12.126441 12.326441 12.526441))
/*
Si <1 l'équilibre est localement stable
Si >1 l'équilibre est localement instable
*/

* Graph trap
twoway ///
(scatter logdebt_t1 logdebt_t) ///
(line _Mean_logdebt_t1 logdebt_t, xline(12.326441) sort) ///
(function y=x, range(8 16)) ///
,xtitle("t") ytitle("t+1") title("Pooled sample") ///
name(poo, replace)

* Graph slope
local v="logdebt_t"
summ `v' if e(sample), meanonly
local xmin=r(min)
local xmax=r(max)
margins, dydx(logdebt_t) at(logdebt_t=(`xmin'(0.05)`xmax')) ///
    saving(slope_grid, replace)
preserve
use slope_grid, clear
twoway ///
    (line _margin _at1, sort) ///
    (function y=1, range(_at1) lpattern(dash)), ///
    ytitle("Local slope") ///
    xtitle("logdebt_t") ///
    legend(order(1 "Estimated local slope" 2 "Slope = 1"))
restore
/*
L'équilibre est localement stable
*/



* Groups
gen pooled_path=.
label define path 1"Below" 2"Above"
label values pooled_path path
replace pooled_path=1 if logassets_t<6.6695962
replace pooled_path=2 if logassets_t>6.6695962
ta pooled_path

ta pooled_path dalits, chi2 exp cchi2



* Assets dynamics for Dalits
preserve
keep if dalit==1
npregress kernel logassets_t1 logassets_t, reps(100) kernel(epanechnikov)
*
twoway ///
(scatter logassets_t1 logassets_t) ///
(line _Mean_logassets_t1 logassets_t , sort) ///
(function y=x, range(0 10)) ///
,title("Dalits") ///
name(dal, replace)
drop _unident_sample _Mean_logassets_t1 _d_Mean_logassets_t1_dlogassets_
restore

* Assets dynamics for non-Dalits
preserve
keep if dalit==0
npregress kernel logassets_t1 logassets_t, reps(100) kernel(epanechnikov)
*
twoway ///
(scatter logassets_t1 logassets_t) ///
(line _Mean_logassets_t1 logassets_t , sort) ///
(function y=x, range(0 10)) ///
,title("non-Dalits") ///
name(ndal, replace)
drop _unident_sample _Mean_logassets_t1 _d_Mean_logassets_t1_dlogassets_
restore

* Together
grc1leg poo dal ndal

****************************************
* END

