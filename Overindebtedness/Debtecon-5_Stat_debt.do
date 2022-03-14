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

* Scheme
*net install schemepack, from("https://raw.githubusercontent.com/asjadnaqvi/Stata-schemes/main/schemes/") replace
*set scheme plotplain
set scheme white_tableau
*set scheme plotplain
grstyle init
grstyle set plain, nogrid

*set scheme black_tableau
*set scheme swift_red


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














/*
****************************************
* Stat debt evo with long data
****************************************
use"panel_v4", clear

********** Initialization
xtset panelvar time
keep if panel==1



********** Pctile
forvalues i=1(1)3{
preserve
keep if time==`i'
xtile cat_p=annualincome, n(5)
foreach x in loanamount annualincome assets_noland formal_HH informal_HH {
bysort cat_p: egen mean_`x'=mean(`x')
bysort cat_p: egen median_`x'=median(`x')
}
keep cat_p mean_loanamount median_loanamount mean_annualincome median_annualincome mean_assets_noland median_assets_noland mean_formal_HH median_formal_HH mean_informal_HH median_informal_HH
duplicates drop
rename cat_p n
set graph off
foreach x in mean median {
twoway ///
(connected `x'_loanamount n) ///
(connected `x'_annualincome n) ///
(connected `x'_assets_noland n) ///
, ///
title("t=`i'") ///
ylabel(0(100)600) ymtick(0(50)650) ///
leg(col(3) pos(6)) ///
name(`x'`i', replace)
grc1leg `x'1 `x'2 `x'3, col(3) name(`x', replace)
}
set graph on
restore
}
grc1leg mean, col(1) name(loan, replace)






********** DSR, ISR
forvalues i=1(1)3{
preserve
keep if time==`i'
xtile cat_p=annualincome, n(5)
foreach x in DSR ISR DAR_without {
bysort cat_p: egen mean_`x'=mean(`x')
bysort cat_p: egen median_`x'=median(`x')
}
keep cat_p mean_DSR median_DSR mean_ISR median_ISR mean_DAR_without median_DAR_without
duplicates drop
rename cat_p n
set graph off
foreach x in mean median {
twoway ///
(connected `x'_DSR n) ///
(connected `x'_ISR n) ///
(connected `x'_DAR_without n) ///
, ///
title("t=`i'") ///
ylabel() ymtick() ///
leg(col(3) pos(6)) ///
name(`x'`i', replace)
}
set graph on
restore
}
grc1leg mean1 mean2 mean3, col(3) name(mean, replace)

grc1leg mean, col(1) name(loan, replace)







********* Using mean according to distribution of debt and income
forvalues i=1(1)3{
preserve
keep if time==`i'
xtile cat_p=annualincome, n(5)

collapse (mean) rel_eco_HH rel_current_HH rel_humank_HH rel_social_HH rel_home_HH rel_other_HH, by(cat_p)

rename rel_eco_HH sum1
rename rel_current_HH up2
rename rel_humank_HH up3
rename rel_social_HH up4
rename rel_home_HH up5
rename rel_other_HH up6

gen sum2=sum1+up2
gen sum3=sum2+up3
gen sum4=sum3+up4
gen sum5=sum4+up5
gen sum6=sum5+up6

keep cat_p sum*

set graph off
twoway ///
area sum1 cat_p || ///
rarea sum1 sum2 cat_p || ///
rarea sum2 sum3 cat_p || ///
rarea sum3 sum4 cat_p || ///
rarea sum4 sum5 cat_p || ///
rarea sum5 sum6 cat_p ///
, ///
legend(pos(6) col(3) order(1 "Economic purpose" 2 "Current expenses" 3 "Human capital" 4 "Social purpose" 5 "Housing" 6 "Other")) ///
title("t=`i'") ///
name(using`i',replace)
set graph on
restore
}

grc1leg using1 using2 using3, col(3)





********* Source mean according to distribution of debt and income
forvalues i=1(1)3{
preserve
keep if time==`i'
xtile cat_p=annualincome, n(5)

collapse (mean) rel_formal_HH rel_informal_HH, by(cat_p)

rename rel_formal_HH sum1
rename rel_informal_HH up2

gen sum2=sum1+up2

keep cat_p sum*

set graph off
twoway ///
area sum1 cat_p || ///
rarea sum1 sum2 cat_p || ///
, ///
legend(pos(6) col(3) order(1 "Formal" 2 "Informal")) ///
title("t=`i'") ///
name(source`i',replace)
set graph on
restore
}

grc1leg source1 source2 source3, col(3)

****************************************
* END
*/














****************************************
* Wide data
****************************************
use"panel_v4_wide", clear

********** Panel
foreach x in caste cat_income cat_assets catevo_annualincome catevo_assets_noland {
forvalues i=30(10)50 {
ta path_`i' `x', col nofreq
}
}


preserve
rename caste over
rename path_30 path
contract path over
bysort over (path): replace _freq=sum(_freq)
bysort over (path): replace _freq=_freq/_freq[_N]*100
twoway ///
(bar _freq over if path==8, barw(.5)) ///
(bar _freq over if path==7, barw(.5)) ///
(bar _freq over if path==6, barw(.5)) ///
(bar _freq over if path==5, barw(.5)) ///
(bar _freq over if path==4, barw(.5)) ///
(bar _freq over if path==3, barw(.5)) ///
(bar _freq over if path==2, barw(.5)) ///	   
(bar _freq over if path==1, barw(.5)) ///
, ///
legend(order(1 "Always" 2 "Lasting entrance" 3 "Temporary exit" 4 "New over-indebted" 5 "New not over-indebted" 6 "Temporary entrance" 7 "Lasting exit" 8 "Never")) ///
ytitle(percent) 
restore





********** Over path: Among cat, how much % have this debt path?
foreach x in caste catevo_annualincome cat_income catevo_assets_noland cat_assets {
preserve 
rename `x' over
rename path_30 path
tabplot path over, percent(over) showval(format(%3.1f)) ///
xtitle("") ytitle("") ///
title("") subtitle("") ///
name(perc_`x', replace)
restore
}





********** Debt path: 
global classic annualincome assets_noland yearly_expenses loanamount sum_loans_HH DSR ISR

foreach y in $classic {
foreach x in caste cat_income cat_assets {
set graph off
preserve 
rename `x' over
rename catevo_`y' path
tabplot path over, percent(over) showval(format(%3.1f)) ///
xtitle("") ytitle("") ///
xlab(,ang(45)) ///
title("") subtitle("") ///
name(`y'_`x', replace)
restore
set graph on
}
}

foreach y in $classic {
set graph off
graph combine `y'_caste `y'_cat_income `y'_cat_assets, col(3) title("`y'") name(comb_`y', replace)
set graph on
}

graph display comb_annualincome


***** Caste
cls
foreach x in $classic {
ta catevo_`x' caste, col nofreq chi2
}

***** Tercile income
cls
foreach x in $classic {
ta catevo_`x' cat_income, col nofreq chi2
}

***** Tercile assets
cls
foreach x in $classic {
ta catevo_`x' cat_assets, col nofreq chi2
}






********** Graph rpz
/*
***** Outliers to drop
foreach x in $quanti {
gen todrop_`x'=0

qui sum d1_`x', det
replace todrop_`x'=1 if d1_`x'<r(p5)
replace todrop_`x'=1 if d1_`x'>r(p95)

qui sum d2_`x', det
replace todrop_`x'=1 if d1_`x'<r(p5)
replace todrop_`x'=1 if d1_`x'>r(p95)
}



***** Caste
foreach x in loanamount {
preserve
drop if todrop_`x'==1

twoway ///
(scatter d2_`x' d1_`x' if caste==1, xline(0) yline(0) msymbol(oh) msize(medsmall)) ///
(scatter d2_`x' d1_`x' if caste==2, xline(0) yline(0) msymbol(oh) msize(medsmall)) ///
(scatter d2_`x' d1_`x' if caste==3, xline(0) yline(0) msymbol(oh) msize(medsmall)) ///
(function y=-x, range(d1_`x')) ///
, ///
xtitle("Δ 2010 / 2016-17") ytitle("Δ 2016-17 / 2020-21") ///
title("`cat' `i'") ///
legend(pos(6) col(3) order(1 "Dalits" 2 "Middle" 3 "Upper")) name(`x'_`i', replace)

restore
}


***** Tercile
foreach x in loanamount {
preserve
drop if todrop_`x'==1

twoway ///
(scatter d2_`x' d1_`x' if cat_assets==1, xline(0) yline(0) msymbol(oh) msize(medsmall)) ///
(scatter d2_`x' d1_`x' if cat_assets==2, xline(0) yline(0) msymbol(oh) msize(medsmall)) ///
(scatter d2_`x' d1_`x' if cat_assets==3, xline(0) yline(0) msymbol(oh) msize(medsmall)) ///
(function y=-x, range(d1_`x')) ///
, ///
xtitle("Δ 2010 / 2016-17") ytitle("Δ 2016-17 / 2020-21") ///
title("`cat' `i'") ///
legend(pos(6) col(3) order(1 "T1 assets" 2 "T2 assets" 3 "T3 assets")) name(`x'_`i', replace)

restore
}
*/



****************************************
* END





































/*

********** Line
*** Debt, income and assets
preserve
set graph off
collapse (mean) annualincome loanamount assets_noland, by(caste year)
forvalues i=1(1)3 {
twoway ///
(line loanamount year if caste==`i') ///
(line annualincome year if caste==`i') ///
(line assets_noland year if caste==`i') ///
, ///
ytitle("`x'") xtitle("Year") ///
ylabel(0(100)500) ytick(0(50)500) ///
xlabel(2010 2016 2020, ang(45)) ///
legend(order() col(3) pos(6)) ///
name(caste`i', replace)
}
set graph on
restore

grc1leg caste1 caste2 caste3, col(3)

*** Income, interest and repayment
preserve
collapse (mean) DSR ISR annualincome rel_formal_HH rel_informal_HH, by(caste year)

forvalues i=1(1)3 {
set graph off
twoway ///
(line annualincome year if caste==`i') ///
(line DSR year if caste==`i') ///
(line ISR year if caste==`i') ///
(line rel_formal_HH year if caste==`i') ///
(line rel_informal_HH year if caste==`i') ///
, ///
ytitle("`x'") xtitle("Year") ///
ylabel(0(20)160) ytick(0(10)160) ///
xlabel(2010 2016 2020, ang(45)) ///
legend(order() col(3) pos(6)) ///
name(caste`i', replace)
}
set graph on
restore

grc1leg caste1 caste2 caste3, col(3)


********** Kernel
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


********** Boxplot
foreach x in DSR_r ISR_r {
stripplot `x', over(time) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(1 "2009-10" 2 "2016-17" 3 "2020-21",angle(0))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel(0(100)600) ymtick(0(50)600) ytitle("`x'") ///
legend(order(1 "Mean" 5 "Individual") off) name(box_`x', replace)
}



********** Violin plot
vioplot annualincome, over(year)
