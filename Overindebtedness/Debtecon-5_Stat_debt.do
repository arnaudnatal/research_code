cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
December 07, 2021
-----
Stat for indebtedness and over-indebtedness
-----

-------------------------
*/









****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all

global user "Arnaud"
global folder "Documents"

********** Path to folder "data" folder.
global directory = "C:\Users\\$user\\$folder\_Thesis\Research-Overindebtedness\Persistence_over"
cd"$directory"
global git "C:\Users\\$user\\$folder\GitHub"


*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
set scheme plotplain

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH"
global wave2 "NEEMSIS1-HH"
global wave3 "NEEMSIS2-HH"

global loan1 "RUME-all_loans"
global loan2 "NEEMSIS1-all_loans"
global loan3 "NEEMSIS2-all_loans"



********** Deflate
*https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
*(100/158) if year==2016
*(100/184) if year==2020

****************************************
* END










/*
****************************************
* Isabelle new graphes
****************************************
use"panel_v4", clear


********** Initialization
xtset time panelvar

global var DIR_r DAR_with_r DAR_without_r DSR_r DSR ISR_r loanamount annualincome
sort HHID_panel year

*** Select+reshape
keep HHID_panel year caste panel $var
reshape wide $var caste, i(HHID_panel) j(year)




********** Isabelle book
tabstat DSR_r if panel==1, stat(n mean sd q) by(year)

tabstat DSR_r if panel==1 & caste==1, stat(n mean sd q) by(year)
tabstat DSR_r if panel==1 & caste==2, stat(n mean sd q) by(year)
tabstat DSR_r if panel==1 & caste==3, stat(n mean sd q) by(year)

tabstat DSR_r if panel==1 & assetspanel_q3==1, stat(n mean sd q) by(year)
tabstat DSR_r if panel==1 & assetspanel_q3==2, stat(n mean sd q) by(year)
tabstat DSR_r if panel==1 & assetspanel_q3==3, stat(n mean sd q) by(year)

set graph off
*drop if time==3
*** Over caste
egen median = median(DSR_r), by(time)
replace median=round(median,0.1)
ta median
gen x2=.
gen x3=.
replace x2=time-0.45
replace x3=time+0.45

*** Over caste
stripplot DSR_r if panel==1, over(time) separate(caste) ///
cumul cumprob centre refline vertical /// 
xsize(3) xlabel(,angle(0))  ///
ylabel(#10) ymtick(#20) ///
msymbol(oh oh oh) msize(medium medium medium) mcolor(plr1%50 ply1%50 plg1%50) ///
legend(order(2 "Dalits" 3 "Middle castes" 4 "Upper castes" 1 "Mean" 5 "Median") pos(6) col(3)) ///
xtitle("") ytitle("Debt service ratio (%)") ///
title("") ///
addplot(rspike x3 x2 median, mla() msymbol(+) horizontal) ///
note("", size(small)) name(caste, replace)

*** Over wealth
stripplot DSR_r if panel==1, over(time) separate(assetspanel_q3) ///
cumul cumprob centre refline vertical /// 
xsize(3) xlabel(,angle(0))  ///
ylabel(#10) ymtick(#20) ///
msymbol(oh oh oh) msize(medium medium medium) mcolor(plr1%50 ply1%50 plg1%50) ///
legend(order(2 "Tercile 1" 3 "Tercile 2" 4 "Tercile 3" 1 "Mean" 5 "Median") pos(6) col(3)) ///
xtitle("") ytitle("Debt service ratio (%)") ///
title("") ///
addplot(rspike x3 x2 median, mla() msymbol(+) horizontal) ///
note("", size(small)) name(wealth, replace)

set graph on
graph combine caste wealth
graph export "graph/DSR_caste_wealth_col.pdf", as(pdf) replace
graph export "graph/DSR_caste_wealth_col.svg", as(svg) replace
graph save "graph/DSR_caste_wealth_BW.gph", replace

********** Second test
egen group=group(caste year)
egen group2=group(assetspanel_q3 year)

stripplot DSR_r, vertical ms(oh oh oh) mc(gs0 gs5 gs12) msize(tiny tiny tiny) separate(caste) tufte(ms(+) msize(normalsize)) whiskers(lpattern(blank)) over(group) stack width(5) refline(lw(medthick) lpattern(dash)) reflevel(mean) reflinestretch(0.1) xla(1 `""Dalits" "2010" "' 2 `""Dalits" "2016-17" "' 3 `""Dalits" "2020-21" "' 4 `""Middle" "2010" "' 5 `""Middle" "2016-17" "' 6 `""Middle" "2020-21" "' 7 `""Upper" "2010" "' 8 `""Upper" "2016-17" "' 9 `""Upper" "2020-21" "', angle(90)) ytitle("Debt service ratio (%)") legend(order(1 "Mean" 2 "Median") pos(6) col(2)) xtitle("") yla(0(100)600) ymtick(0(50)600) name(caste, replace)

stripplot DSR_r, vertical ms(oh oh oh) mc(gs0 gs5 gs12) msize(tiny tiny tiny) separate(assetspanel_q3) tufte(ms(+) msize(normalsize)) whiskers(lpattern(blank)) over(group2) stack width(5) refline(lw(medthick) lpattern(dash)) reflevel(mean) reflinestretch(0.1) xla(1 `""Tercile 1" "2010" "' 2 `""Tercile 1" "2016-17" "' 3 `""Tercile 1" "2020-21" "' 4 `""Tercile 2" "2010" "' 5 `""Tercile 2" "2016-17" "' 6 `""Tercile 2" "2020-21" "' 7 `""Tercile 3" "2010" "' 8 `""Tercile 3" "2016-17" "' 9 `""Tercile 3" "2020-21" "', angle(90)) ytitle("Debt service ratio (%)") legend(order(1 "Mean" 2 "Median") pos(6) col(2)) xtitle("") yla(0(100)600) ymtick(0(50)600) name(assets, replace)

grc1leg caste assets, col(1)
graph export "graph/DSR_caste_wealth_BW_v2.pdf", as(pdf) 
graph export "graph/DSR_caste_wealth_BW_v2.svg", as(svg)
graph save "graph/DSR_caste_wealth_BW_v2.gph"


********** Observe strange households
keep if panel==1

mdesc loanamount2010 DIR_r2010 DAR_with_r2010 DAR_without_r2010 DSR_r2010 ISR_r2010 loanamount2016 DIR_r2016 DAR_with_r2016 DAR_without_r2016 DSR_r2016 ISR_r2016 loanamount2020 DIR_r2020 DAR_with_r2020 DAR_without_r2020 DSR_r2020 ISR_r2020 annualincome2010 annualincome2016 annualincome2020

*** Evol
foreach x in $var {
gen b1_`x'=`x'2016-`x'2010
gen b2_`x'=`x'2020-`x'2016
}


*** Graph
foreach cat in caste {
foreach x in $var {
forvalues i=1(1)3 {
set graph off

twoway ///
(scatter b2_`x' b1_`x' if `cat'==`i', xline(0) yline(0) msymbol(oh) msize(medsmall)) ///
(function y=-x if `cat'==`i', range(b1_`x')) ///
, ///
xlabel(#5) ylabel(#5) ///
xmtick(#10) ymtick(#10) ///
xtitle("β1=2016-2010") ytitle("β2=2020-2016") ///
title("`cat' `i'") ///
legend(pos(6) col(2) order(2 "Second bisector")) name(`x'_`i', replace)
}
grc1leg `x'_1 `x'_2 `x'_3, col(3) title("`x'") name(comb_`x', replace)
graph export "graph/comb`cat'_`x'.pdf", replace
set graph on
}
}

****************************************
* END
*/















****************************************
* Stat debt evo
****************************************
use"panel_v4", clear

********** Initialization
xtset panelvar time
keep if panel==1

tabstat loanamount_HH, stat(n mean sd q) by(year)
tabstat DIR, stat(n mean sd q) by(year)
tabstat DSR, stat(n mean sd q) by(year)
tabstat ISR, stat(n mean sd q) by(year)
*tabstat DAR_with DAR_with_r DAR_without DAR_without_r, stat(n mean sd q) by(year)
tabstat formal_HH informal_HH rel_formal_HH rel_informal_HH, stat(n mean sd q) by(year)


********** Line
preserve
collapse (mean) rel_formal_HH rel_informal_HH, by(caste year)

forvalues i=1(1)3 {
twoway ///
(line rel_formal_HH year if caste==`i') ///
(line rel_informal_HH year if caste==`i') ///
, ///
ytitle("`x'") xtitle("Year") ///
ylabel(0(20)200) ///
xlabel(2010 2016 2020, ang(45)) ///
legend(order() col(3) pos(6)) ///
name(caste`i', replace)
}
restore





********** Kernel
/*
foreach y in 2010 2016 2020 {
foreach x in DIR DAR_with DSR ISR {
qui sum `x'_r, det
local maxv=r(max)
set graph off
twoway ///
(kdensity `x'_r if caste==1 & year==`y', bwidth(.5)) ///
(kdensity `x'_r if caste==2 & year==`y', bwidth(.5)) ///
(kdensity `x'_r if caste==3 & year==`y', bwidth(.5)) ///
, ///
xlabel(0(1)`maxv') ///
legend(order(1 "Dalits" 2 "Middle" 3 "Upper") col(3)) ///
name(`x'_`y', replace)
set graph on
}
}
*/


********** Boxplot
foreach x in DSR_r ISR_r {
stripplot `x', over(time) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(1 "2009-10" 2 "2016-17" 3 "2020-21",angle(0))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel(0(100)600) ymtick(0(50)600) ytitle("`x'") ///
legend(order(1 "Mean" 5 "Individual") off) name(box_`x', replace)
}

*save"panel_v3", replace
****************************************
* END
