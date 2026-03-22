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





/*
****************************************
* Debt dynamics for the pooled sample
****************************************
use"pooled_v1", clear


pwcorr logdsr_t1 logdsr_t
*
npregress kernel isr_t1 isr_t, reps(100) kernel(epanechnikov)
npgraph

* Graphs
local v="dsr_t"
local v1="dsr_t1"
summ `v' if e(sample), meanonly
local xmin=r(min)
local xmax=r(max)
*
margins, at(`v'=(`xmin'(5)`xmax')) saving(mhat_grid, replace)
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
margins, dydx(`v') at(`v'=(`xmin'(5)`xmax')) saving(slope_grid, replace)
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
graph combine dyn, col(1) title("Pooled") name(comb, replace)
set graph on
graph display comb
graph export "Dyn_pooled.png", replace

****************************************
* END
*/












****************************************
* DSR dynamics
****************************************
use"pooled_v1", clear

*drop if dsr_t==0
*drop if dsr_t1==0
ta timeperiod


* Pooled
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Pooled")
graph export "Dyn_dsr_1_pooled.png", replace

* 2010 to 2016
preserve
keep if timeperiod==1
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("10 to 16")
graph export "Dyn_dsr_2_10_16.png", replace
restore

* 2016 to 2020
preserve
keep if timeperiod==2
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("16 to 20")
graph export "Dyn_dsr_3_16_20.png", replace
restore

* 2020 to 2026
preserve
keep if timeperiod==3
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("20 to 26")
graph export "Dyn_dsr_4_20_26.png", replace
restore

* Dalits
preserve
keep if dalits==1
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Dalits")
graph export "Dyn_dsr_5_dal.png", replace
restore

* Non-Dalits
preserve
keep if dalits==0
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Non-dalits")
graph export "Dyn_dsr_6_ndal.png", replace
restore

* No land
preserve
keep if ownland==0
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("No land")
graph export "Dyn_dsr_7_noland.png", replace
restore

* Land
preserve
keep if ownland==1
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Land")
graph export "Dyn_dsr_8_land.png", replace
restore

* Poor wealth
preserve
keep if wealth_grp==1
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Poor wealth")
graph export "Dyn_dsr_9_poorwealth.png", replace
restore

* Rich wealth
preserve
keep if wealth_grp==3
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Rich wealth")
graph export "Dyn_dsr_10_richwealth.png", replace
restore

* Poor inc
preserve
keep if income_grp==1
pwcorr logdsr_t1 logdsr_t
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Poor income")
graph export "Dyn_dsr_11_poorincome.png", replace
restore

* Rich inc
preserve
tabstat annualincome_HH, stat(n mean) by(income_grp)
keep if income_grp==3
pwcorr logdsr_t1 logdsr_t
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Rich income")
graph export "Dyn_dsr_12_richincome.png", replace
restore

* Inc type: Non agri
preserve
keep if catinc==1
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Inc: non agri")
graph export "Dyn_dsr_13_nonagri.png", replace
restore

* Inc type: Agri
preserve
keep if catinc==2
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Inc: agri")
graph export "Dyn_dsr_14_agri.png", replace
restore

* Inc type: Both
preserve
keep if catinc==3
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Inc: both")
graph export "Dyn_dsr_15_both.png", replace
restore


****************************************
* END










****************************************
* DSR dynamics 0 dropped
****************************************
use"pooled_v1", clear

drop if dsr_t==0
drop if dsr_t1==0
ta timeperiod


* Pooled
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Pooled")
graph export "Dyn_dsrd_1_pooled.png", replace

* 2010 to 2016
preserve
keep if timeperiod==1
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("10 to 16")
graph export "Dyn_dsrd_2_10_16.png", replace
restore

* 2016 to 2020
preserve
keep if timeperiod==2
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("16 to 20")
graph export "Dyn_dsrd_3_16_20.png", replace
restore

* 2020 to 2026
preserve
keep if timeperiod==3
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("20 to 26")
graph export "Dyn_dsrd_4_20_26.png", replace
restore

* Dalits
preserve
keep if dalits==1
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Dalits")
graph export "Dyn_dsrd_5_dal.png", replace
restore

* Non-Dalits
preserve
keep if dalits==0
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Non-dalits")
graph export "Dyn_dsrd_6_ndal.png", replace
restore

* No land
preserve
keep if ownland==0
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("No land")
graph export "Dyn_dsrd_7_noland.png", replace
restore

* Land
preserve
keep if ownland==1
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Land")
graph export "Dyn_dsrd_8_land.png", replace
restore

* Poor wealth
preserve
keep if wealth_grp==1
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Poor wealth")
graph export "Dyn_dsrd_9_poorwealth.png", replace
restore

* Rich wealth
preserve
keep if wealth_grp==3
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Rich wealth")
graph export "Dyn_dsrd_10_richwealth.png", replace
restore

* Poor inc
preserve
keep if income_grp==1
pwcorr logdsr_t1 logdsr_t
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Poor income")
graph export "Dyn_dsrd_11_poorincome.png", replace
restore

* Rich inc
preserve
tabstat annualincome_HH, stat(n mean) by(income_grp)
keep if income_grp==3
pwcorr logdsr_t1 logdsr_t
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Rich income")
graph export "Dyn_dsrd_12_richincome.png", replace
restore

* Inc type: Non agri
preserve
keep if catinc==1
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Inc: non agri")
graph export "Dyn_dsrd_13_nonagri.png", replace
restore

* Inc type: Agri
preserve
keep if catinc==2
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Inc: agri")
graph export "Dyn_dsrd_14_agri.png", replace
restore

* Inc type: Both
preserve
keep if catinc==3
npregress kernel logdsr_t1 logdsr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Inc: both")
graph export "Dyn_dsrd_15_both.png", replace
restore


****************************************
* END

















****************************************
* ISR dynamics
****************************************
use"pooled_v1", clear

*drop if isr_t==0
*drop if isr_t1==0
ta timeperiod

* Pooled
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Pooled")
graph export "Dyn_isr_1_pooled.png", replace

* 2010 to 2016
preserve
keep if timeperiod==1
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("10 to 16")
graph export "Dyn_isr_2_10_16.png", replace
restore

* 2016 to 2020
preserve
keep if timeperiod==2
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("16 to 20")
graph export "Dyn_isr_3_16_20.png", replace
restore

* 2020 to 2026
preserve
keep if timeperiod==3
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("20 to 26")
graph export "Dyn_isr_4_20_26.png", replace
restore

* Dalits
preserve
keep if dalits==1
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Dalits")
graph export "Dyn_isr_5_dal.png", replace
restore

* Non-Dalits
preserve
keep if dalits==0
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Non-dalits")
graph export "Dyn_isr_6_ndal.png", replace
restore

* No land
preserve
keep if ownland==0
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("No land")
graph export "Dyn_isr_7_noland.png", replace
restore

* Land
preserve
keep if ownland==1
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Land")
graph export "Dyn_isr_8_land.png", replace
restore

* Poor wealth
preserve
keep if wealth_grp==1
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Poor wealth")
graph export "Dyn_isr_9_poorwealth.png", replace
restore

* Rich wealth
preserve
keep if wealth_grp==3
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Rich wealth")
graph export "Dyn_isr_10_richwealth.png", replace
restore

* Poor inc
preserve
keep if income_grp==1
pwcorr logisr_t1 logisr_t
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Poor income")
graph export "Dyn_isr_11_poorincome.png", replace
restore

* Rich inc
preserve
tabstat annualincome_HH, stat(n mean) by(income_grp)
keep if income_grp==3
pwcorr logisr_t1 logisr_t
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Rich income")
graph export "Dyn_isr_12_richincome.png", replace
restore

* Inc type: Non agri
preserve
keep if catinc==1
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Inc: non agri")
graph export "Dyn_isr_13_nonagri.png", replace
restore

* Inc type: Agri
preserve
keep if catinc==2
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Inc: agri")
graph export "Dyn_isr_14_agri.png", replace
restore

* Inc type: Both
preserve
keep if catinc==3
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Inc: both")
graph export "Dyn_isr_15_both.png", replace
restore

****************************************
* END
















****************************************
* ISR dynamics 0 dropped 
****************************************
use"pooled_v1", clear

drop if isr_t==0
drop if isr_t1==0
ta timeperiod

* Pooled
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Pooled")
graph export "Dyn_isrd_1_pooled.png", replace

* 2010 to 2016
preserve
keep if timeperiod==1
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("10 to 16")
graph export "Dyn_isrd_2_10_16.png", replace
restore

* 2016 to 2020
preserve
keep if timeperiod==2
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("16 to 20")
graph export "Dyn_isrd_3_16_20.png", replace
restore

* 2020 to 2026
preserve
keep if timeperiod==3
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("20 to 26")
graph export "Dyn_isrd_4_20_26.png", replace
restore

* Dalits
preserve
keep if dalits==1
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Dalits")
graph export "Dyn_isrd_5_dal.png", replace
restore

* Non-Dalits
preserve
keep if dalits==0
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Non-dalits")
graph export "Dyn_isrd_6_ndal.png", replace
restore

* No land
preserve
keep if ownland==0
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("No land")
graph export "Dyn_isrd_7_noland.png", replace
restore

* Land
preserve
keep if ownland==1
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Land")
graph export "Dyn_isrd_8_land.png", replace
restore

* Poor wealth
preserve
keep if wealth_grp==1
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Poor wealth")
graph export "Dyn_isrd_9_poorwealth.png", replace
restore

* Rich wealth
preserve
keep if wealth_grp==3
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Rich wealth")
graph export "Dyn_isrd_10_richwealth.png", replace
restore

* Poor inc
preserve
keep if income_grp==1
pwcorr logisr_t1 logisr_t
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Poor income")
graph export "Dyn_isrd_11_poorincome.png", replace
restore

* Rich inc
preserve
tabstat annualincome_HH, stat(n mean) by(income_grp)
keep if income_grp==3
pwcorr logisr_t1 logisr_t
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Rich income")
graph export "Dyn_isrd_12_richincome.png", replace
restore

* Inc type: Non agri
preserve
keep if catinc==1
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Inc: non agri")
graph export "Dyn_isrd_13_nonagri.png", replace
restore

* Inc type: Agri
preserve
keep if catinc==2
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Inc: agri")
graph export "Dyn_isrd_14_agri.png", replace
restore

* Inc type: Both
preserve
keep if catinc==3
npregress kernel logisr_t1 logisr_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Inc: both")
graph export "Dyn_isrd_15_both.png", replace
restore

****************************************
* END

















****************************************
* DAR dynamics
****************************************
use"pooled_v1", clear

*drop if dar_t==0
*drop if dar_t1==0
ta timeperiod

* Pooled
npregress kernel logdar_t1 logdar_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Pooled")
graph export "Dyn_dar_1_pooled.png", replace

* 2010 to 2016
preserve
keep if timeperiod==1
npregress kernel logdar_t1 logdar_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("10 to 16")
graph export "Dyn_dar_2_10_16.png", replace
restore

* 2016 to 2020
preserve
keep if timeperiod==2
npregress kernel logdar_t1 logdar_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("16 to 20")
graph export "Dyn_dar_3_16_20.png", replace
restore

* 2020 to 2026
preserve
keep if timeperiod==3
npregress kernel logdar_t1 logdar_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("20 to 26")
graph export "Dyn_dar_4_20_26.png", replace
restore

* Dalits
preserve
keep if dalits==1
npregress kernel logdar_t1 logdar_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Dalits")
graph export "Dyn_dar_5_dal.png", replace
restore

* Non-Dalits
preserve
keep if dalits==0
npregress kernel logdar_t1 logdar_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Non-dalits")
graph export "Dyn_dar_6_ndal.png", replace
restore

* No land
preserve
keep if ownland==0
npregress kernel logdar_t1 logdar_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("No land")
graph export "Dyn_dar_7_noland.png", replace
restore

* Land
preserve
keep if ownland==1
npregress kernel logdar_t1 logdar_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Land")
graph export "Dyn_dar_8_land.png", replace
restore

* Poor wealth
preserve
keep if wealth_grp==1
npregress kernel logdar_t1 logdar_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Poor wealth")
graph export "Dyn_dar_9_poorwealth.png", replace
restore

* Rich wealth
preserve
keep if wealth_grp==3
npregress kernel logdar_t1 logdar_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Rich wealth")
graph export "Dyn_dar_10_richwealth.png", replace
restore

* Poor inc
preserve
keep if income_grp==1
pwcorr logdar_t1 logdar_t
npregress kernel logdar_t1 logdar_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Poor income")
graph export "Dyn_dar_11_poorincome.png", replace
restore

* Rich inc
preserve
tabstat annualincome_HH, stat(n mean) by(income_grp)
keep if income_grp==3
pwcorr logdar_t1 logdar_t
npregress kernel logdar_t1 logdar_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Rich income")
graph export "Dyn_dar_12_richincome.png", replace
restore

* Inc type: Non agri
preserve
keep if catinc==1
npregress kernel logdar_t1 logdar_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Inc: non agri")
graph export "Dyn_dar_13_nonagri.png", replace
restore

* Inc type: Agri
preserve
keep if catinc==2
npregress kernel logdar_t1 logdar_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Inc: agri")
graph export "Dyn_dar_14_agri.png", replace
restore

* Inc type: Both
preserve
keep if catinc==3
npregress kernel logdar_t1 logdar_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(0 10)) title("Inc: both")
graph export "Dyn_dar_15_both.png", replace
restore


****************************************
* END



















****************************************
* Debt dynamics
****************************************
use"pooled_v1", clear

drop if debt_t==0
drop if debt_t1==0
ta timeperiod

* Pooled
npregress kernel logdebt_t1 logdebt_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("Pooled")
graph export "Dyn_debt_1_pooled.png", replace

* 2010 to 2016
preserve
keep if timeperiod==1
npregress kernel logdebt_t1 logdebt_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("10 to 16")
graph export "Dyn_debt_2_10_16.png", replace
restore

* 2016 to 2020
preserve
keep if timeperiod==2
npregress kernel logdebt_t1 logdebt_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("16 to 20")
graph export "Dyn_debt_3_16_20.png", replace
restore

* 2020 to 2026
preserve
keep if timeperiod==3
npregress kernel logdebt_t1 logdebt_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("20 to 26")
graph export "Dyn_debt_4_20_26.png", replace
restore

* Dalits
preserve
keep if dalits==1
npregress kernel logdebt_t1 logdebt_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("Dalits")
graph export "Dyn_debt_5_dal.png", replace
restore

* Non-Dalits
preserve
keep if dalits==0
npregress kernel logdebt_t1 logdebt_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("Non-dalits")
graph export "Dyn_debt_6_ndal.png", replace
restore

* No land
preserve
keep if ownland==0
npregress kernel logdebt_t1 logdebt_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("No land")
graph export "Dyn_debt_7_noland.png", replace
restore

* Land
preserve
keep if ownland==1
npregress kernel logdebt_t1 logdebt_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("Land")
graph export "Dyn_debt_8_land.png", replace
restore

* Poor wealth
preserve
keep if wealth_grp==1
npregress kernel logdebt_t1 logdebt_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("Poor wealth")
graph export "Dyn_debt_9_poorwealth.png", replace
restore

* Rich wealth
preserve
keep if wealth_grp==3
npregress kernel logdebt_t1 logdebt_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("Rich wealth")
graph export "Dyn_debt_10_richwealth.png", replace
restore

* Poor inc
preserve
keep if income_grp==1
pwcorr logdebt_t1 logdebt_t
npregress kernel logdebt_t1 logdebt_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("Poor income")
graph export "Dyn_debt_11_poorincome.png", replace
restore

* Rich inc
preserve
tabstat annualincome_HH, stat(n mean) by(income_grp)
keep if income_grp==3
pwcorr logdebt_t1 logdebt_t
npregress kernel logdebt_t1 logdebt_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("Rich income")
graph export "Dyn_debt_12_richincome.png", replace
restore

* Inc type: Non agri
preserve
keep if catinc==1
npregress kernel logdebt_t1 logdebt_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("Inc: non agri")
graph export "Dyn_debt_13_nonagri.png", replace
restore

* Inc type: Agri
preserve
keep if catinc==2
npregress kernel logdebt_t1 logdebt_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("Inc: agri")
graph export "Dyn_debt_14_agri.png", replace
restore

* Inc type: Both
preserve
keep if catinc==3
npregress kernel logdebt_t1 logdebt_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("Inc: both")
graph export "Dyn_debt_15_both.png", replace
restore


****************************************
* END


















****************************************
* Debt balance dynamics
****************************************
use"pooled_v1", clear

drop if debtbal_t==0
drop if debtbal_t1==0
ta timeperiod

* Pooled
npregress kernel logdebtbal_t1 logdebtbal_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("Pooled")
graph export "Dyn_debtbal_1_pooled.png", replace

* 2010 to 2016
preserve
keep if timeperiod==1
npregress kernel logdebtbal_t1 logdebtbal_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("10 to 16")
graph export "Dyn_debtbal_2_10_16.png", replace
restore

* 2016 to 2020
preserve
keep if timeperiod==2
npregress kernel logdebtbal_t1 logdebtbal_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("16 to 20")
graph export "Dyn_debtbal_3_16_20.png", replace
restore

* 2020 to 2026
preserve
keep if timeperiod==3
npregress kernel logdebtbal_t1 logdebtbal_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("20 to 26")
graph export "Dyn_debtbal_4_20_26.png", replace
restore

* Dalits
preserve
keep if dalits==1
npregress kernel logdebtbal_t1 logdebtbal_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("Dalits")
graph export "Dyn_debtbal_5_dal.png", replace
restore

* Non-Dalits
preserve
keep if dalits==0
npregress kernel logdebtbal_t1 logdebtbal_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("Non-dalits")
graph export "Dyn_debtbal_6_ndal.png", replace
restore

* No land
preserve
keep if ownland==0
npregress kernel logdebtbal_t1 logdebtbal_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("No land")
graph export "Dyn_debtbal_7_noland.png", replace
restore

* Land
preserve
keep if ownland==1
npregress kernel logdebtbal_t1 logdebtbal_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("Land")
graph export "Dyn_debtbal_8_land.png", replace
restore

* Poor wealth
preserve
keep if wealth_grp==1
npregress kernel logdebtbal_t1 logdebtbal_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("Poor wealth")
graph export "Dyn_debtbal_9_poorwealth.png", replace
restore

* Rich wealth
preserve
keep if wealth_grp==3
npregress kernel logdebtbal_t1 logdebtbal_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("Rich wealth")
graph export "Dyn_debtbal_10_richwealth.png", replace
restore

* Poor inc
preserve
keep if income_grp==1
pwcorr logdebtbal_t1 logdebtbal_t
npregress kernel logdebtbal_t1 logdebtbal_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("Poor income")
graph export "Dyn_debtbal_11_poorincome.png", replace
restore

* Rich inc
preserve
tabstat annualincome_HH, stat(n mean) by(income_grp)
keep if income_grp==3
pwcorr logdebtbal_t1 logdebtbal_t
npregress kernel logdebtbal_t1 logdebtbal_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("Rich income")
graph export "Dyn_debtbal_12_richincome.png", replace
restore

* Inc type: Non agri
preserve
keep if catinc==1
npregress kernel logdebtbal_t1 logdebtbal_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("Inc: non agri")
graph export "Dyn_debtbal_13_nonagri.png", replace
restore

* Inc type: Agri
preserve
keep if catinc==2
npregress kernel logdebtbal_t1 logdebtbal_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("Inc: agri")
graph export "Dyn_debtbal_14_agri.png", replace
restore

* Inc type: Both
preserve
keep if catinc==3
npregress kernel logdebtbal_t1 logdebtbal_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(8 16)) title("Inc: both")
graph export "Dyn_debtbal_15_both.png", replace
restore


****************************************
* END
























****************************************
* Assets dynamics
****************************************
use"pooled_v1", clear


tabstat logassets_t1 logassets_t, stat(min p1 p5 p10 q)
drop if logassets_t1<1
drop if logassets_t<1

* Pooled
npregress kernel logassets_t1 logassets_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(10 18)) title("Pooled")
graph export "Dyn_ass_1_pooled.png", replace

* 2010 to 2016
preserve
keep if timeperiod==1
npregress kernel logassets_t1 logassets_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(10 18)) title("10 to 16")
graph export "Dyn_ass_2_10_16.png", replace
restore

* 2016 to 2020
preserve
keep if timeperiod==2
npregress kernel logassets_t1 logassets_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(10 18)) title("16 to 20")
graph export "Dyn_ass_3_16_20.png", replace
restore

* 2020 to 2026
preserve
keep if timeperiod==3
npregress kernel logassets_t1 logassets_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(10 18)) title("20 to 26")
graph export "Dyn_ass_4_20_26.png", replace
restore

* Dalits
preserve
keep if dalits==1
npregress kernel logassets_t1 logassets_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(10 18)) title("Dalits")
graph export "Dyn_ass_5_dal.png", replace
restore

* Non-Dalits
preserve
keep if dalits==0
npregress kernel logassets_t1 logassets_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(10 18)) title("Non-dalits")
graph export "Dyn_ass_6_ndal.png", replace
restore

* No land
preserve
keep if ownland==0
npregress kernel logassets_t1 logassets_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(10 18)) title("No land")
graph export "Dyn_ass_7_noland.png", replace
restore

* Land
preserve
keep if ownland==1
npregress kernel logassets_t1 logassets_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(10 18)) title("Land")
graph export "Dyn_ass_8_land.png", replace
restore

* Poor inc
preserve
keep if income_grp==1
pwcorr logassets_t1 logassets_t
npregress kernel logassets_t1 logassets_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(10 18)) title("Poor income")
graph export "Dyn_ass_9_poorincome.png", replace
restore

* Rich inc
preserve
tabstat annualincome_HH, stat(n mean) by(income_grp)
keep if income_grp==3
pwcorr logassets_t1 logassets_t
npregress kernel logassets_t1 logassets_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(10 18)) title("Rich income")
graph export "Dyn_ass_10_richincome.png", replace
restore

* Inc type: Non agri
preserve
keep if catinc==1
npregress kernel logassets_t1 logassets_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(10 18)) title("Inc: non agri")
graph export "Dyn_ass_11_nonagri.png", replace
restore

* Inc type: Agri
preserve
keep if catinc==2
npregress kernel logassets_t1 logassets_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(10 18)) title("Inc: agri")
graph export "Dyn_ass_12_agri.png", replace
restore

* Inc type: Both
preserve
keep if catinc==3
npregress kernel logassets_t1 logassets_t, kernel(epanechnikov)
npgraph, addplot(function y=x, range(10 18)) title("Inc: both")
graph export "Dyn_ass_13_both.png", replace
restore


****************************************
* END




