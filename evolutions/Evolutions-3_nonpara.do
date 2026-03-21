*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*March 16, 2026
*-----
gl link = "evolutions"
*Desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\evolutions.do"
*-------------------------






****************************************
* Debt dynamics for the pooled sample
****************************************
use"pooled_v1", clear

pwcorr logdebt_t1 logdebt_t
spearman logdebt_t1 logdebt_t

*
npregress kernel logdebt_t1 logdebt_t, reps(100) kernel(epanechnikov)

* Graphs
local v="logdebt_t"
local v1="logdebt_t1"
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
restore
* Graph-1
set graph off
twoway ///
(scatter `v1' `v', symbol(oh) color(black%30)) ///
(line _Mean_`v1' `v', xline(`wstar') sort) ///
(function y=x, range(`xmin' `xmax')) ///
,xtitle("t") ytitle("t+1") title("Debt dynamics") ///
legend(order(2 "Reg" 3 "Bisector") pos(6) col(2)) ///
name(dyn, replace)
* Graph-2
margins, dydx(`v') at(`v'=(`xmin'(0.05)`xmax')) saving(slope_grid, replace)
preserve
use slope_grid, clear
twoway ///
(line _margin _at1, sort) ///
(function y=1, range(_at1) lpattern(dash)) ///
,xtitle("t") ytitle("Local slope") title("Local slope") ///
legend(order(1 "Est. local slope" 2 "Slope = 1") pos(6) col(2)) ///
name(slope, replace)
restore
* Combine
graph combine dyn slope, col(2) title("Pooled") name(comb, replace)
set graph on
graph display comb
graph export "Dyn_pooled.png", replace

****************************************
* END















****************************************
* Debt dynamics for 2010 to 2016
****************************************
use"pooled_v1", clear

fre timeperiod
keep if timeperiod==1

npregress kernel logdebt_t1 logdebt_t, reps(100) kernel(epanechnikov)

* Graphs
local v="logdebt_t"
local v1="logdebt_t1"
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
restore
* Graph-1
set graph off
twoway ///
(scatter `v1' `v', symbol(oh) color(black%30)) ///
(line _Mean_`v1' `v', xline(`wstar') sort) ///
(function y=x, range(`xmin' `xmax')) ///
,xtitle("t") ytitle("t+1") title("Debt dynamics") ///
legend(order(2 "Reg" 3 "Bisector") pos(6) col(2)) ///
name(dyn, replace)
* Graph-2
margins, dydx(`v') at(`v'=(`xmin'(0.05)`xmax')) saving(slope_grid, replace)
preserve
use slope_grid, clear
twoway ///
(line _margin _at1, sort) ///
(function y=1, range(_at1) lpattern(dash)) ///
,xtitle("t") ytitle("Local slope") title("Local slope") ///
legend(order(1 "Est. local slope" 2 "Slope = 1") pos(6) col(2)) ///
name(slope, replace)
restore
* Combine
graph combine dyn slope, col(2) title("2010 to 2016") name(comb, replace)
set graph on
graph display comb
graph export "Dyn_10_16.png", replace

****************************************
* END













****************************************
* Debt dynamics for 2016 to 2020
****************************************
use"pooled_v1", clear

fre timeperiod
keep if timeperiod==2

npregress kernel logdebt_t1 logdebt_t, reps(100) kernel(epanechnikov)

* Graphs
local v="logdebt_t"
local v1="logdebt_t1"
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
restore
* Graph-1
set graph off
twoway ///
(scatter `v1' `v', symbol(oh) color(black%30)) ///
(line _Mean_`v1' `v', xline(`wstar') sort) ///
(function y=x, range(`xmin' `xmax')) ///
,xtitle("t") ytitle("t+1") title("Debt dynamics") ///
legend(order(2 "Reg" 3 "Bisector") pos(6) col(2)) ///
name(dyn, replace)
* Graph-2
margins, dydx(`v') at(`v'=(`xmin'(0.05)`xmax')) saving(slope_grid, replace)
preserve
use slope_grid, clear
twoway ///
(line _margin _at1, sort) ///
(function y=1, range(_at1) lpattern(dash)) ///
,xtitle("t") ytitle("Local slope") title("Local slope") ///
legend(order(1 "Est. local slope" 2 "Slope = 1") pos(6) col(2)) ///
name(slope, replace)
restore
* Combine
graph combine dyn slope, col(2) title("2016 to 2020") name(comb, replace)
set graph on
graph display comb
graph export "Dyn_16_20.png", replace

****************************************
* END











****************************************
* Debt dynamics for 2020 to 2026
****************************************
use"pooled_v1", clear

fre timeperiod
keep if timeperiod==3

npregress kernel logdebt_t1 logdebt_t, reps(100) kernel(epanechnikov)

* Graphs
local v="logdebt_t"
local v1="logdebt_t1"
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
restore
* Graph-1
set graph off
twoway ///
(scatter `v1' `v', symbol(oh) color(black%30)) ///
(line _Mean_`v1' `v', xline(`wstar') sort) ///
(function y=x, range(`xmin' `xmax')) ///
,xtitle("t") ytitle("t+1") title("Debt dynamics") ///
legend(order(2 "Reg" 3 "Bisector") pos(6) col(2)) ///
name(dyn, replace)
* Graph-2
margins, dydx(`v') at(`v'=(`xmin'(0.05)`xmax')) saving(slope_grid, replace)
preserve
use slope_grid, clear
twoway ///
(line _margin _at1, sort) ///
(function y=1, range(_at1) lpattern(dash)) ///
,xtitle("t") ytitle("Local slope") title("Local slope") ///
legend(order(1 "Est. local slope" 2 "Slope = 1") pos(6) col(2)) ///
name(slope, replace)
restore
* Combine
graph combine dyn slope, col(2) title("2020 to 2026") name(comb, replace)
set graph on
graph display comb
graph export "Dyn_20_26.png", replace

****************************************
* END
