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
********** Path to folder "data" folder.
global directory = "C:\Users\Arnaud\Documents\_Thesis\Research-Overindebtedness\Persistence_over"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

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











****************************************
* Evo finance
****************************************
use"panel_v4", clear

ta caste year

*** Not balanced
cls
ta ownland year if caste==1, col nofreq
ta ownland year if caste==2, col nofreq
ta ownland year if caste==3, col nofreq

tabstat sizeownland shareagri annualincome if caste==1, stat(n mean sd p50) by(year) col(var)
tabstat sizeownland shareagri annualincome if caste==2, stat(n mean sd p50) by(year) col(var)
tabstat sizeownland shareagri annualincome if caste==3, stat(n mean sd p50) by(year) col(var)


*** Strongly balanced
keep if panel==1
cls
ta ownland year if caste==1, col nofreq
ta ownland year if caste==2, col nofreq
ta ownland year if caste==3, col nofreq

tabstat sizeownland shareagri annualincome if caste==1, stat(n mean sd p50) by(year) col(var)
tabstat sizeownland shareagri annualincome if caste==2, stat(n mean sd p50) by(year) col(var)
tabstat sizeownland shareagri annualincome if caste==3, stat(n mean sd p50) by(year) col(var)
****************************************
* END





********** xt
global depvar loanamount_HH1000 DSR_r DAR_with_r DAR_without_r DAR_with_new_r DAR_without_new_r
foreach y in mean median {
set graph off
preserve
collapse (`y') $depvar, by(caste year)
foreach x in $depvar {
twoway ///
(line `x' year if caste==1) ///
(line `x' year if caste==2) ///
(line `x' year if caste==3) ///
, ///
ytitle("`x'") xtitle("Year") ///
xlabel(2010 2016 2020,ang(45)) ///
legend(order(1 "Dalits" 2 "Middle" 3 "Upper") col(3)) ///
name(`x', replace)
}
grc1leg $depvar, name(comb_`y', replace) title("`y'") col(6)
restore
}
grc1leg comb_mean comb_median, col(1) name(comb_debt, replace)
graph export "graph/line_debt.pdf", replace
set graph on













****************************************
* Assets
****************************************
use"panel_v3", clear


********** Initialization
xtset panelvar time






********** Graph line
global toana assets_noland1000 assetsnew_noland1000 livestock housevalue housevalue_new goldquantityamount goldquantityamount_new goodtotalamount

foreach y in mean median {
set graph off
preserve
collapse (`y') $toana, by(caste year)
foreach x in $toana {
twoway ///
(line `x' year if caste==1) ///
(line `x' year if caste==2) ///
(line `x' year if caste==3) ///
, ///
ytitle("`x'") xtitle("Year") ///
xlabel(2010 2016 2020, ang(45)) ///
legend(order(1 "Dalits" 2 "Middle" 3 "Upper") col(3)) ///
name(`x', replace)
}
grc1leg $toana, name(comb_`y', replace) title("`y'") col(3)
graph export "graph/line_desc_`y'.pdf", replace
restore
set graph on
}




****************************************
* END








****************************************
* Evo
****************************************
use"panel_v3", clear

rename assets1000 assets
rename assets_noland1000 assetsnl
rename assetsnew1000 assetsnew 
rename assetsnew_noland1000 assetsnewnl

rename annualincome_HH1000 income

rename loanamount_HH1000 loanamount


*** Macro
global var income assets assetsnl assetsnew assetsnewnl loanamount DAR_with_r DAR_without_r DAR_with_new_r DAR_without_new_r DSR_r ISR_r

*** Select+reshape
keep HHID_panel year caste $var
reshape wide $var, i(HHID_panel) j(year)

*** Evol
foreach x in $var {
gen b1_`x'=`x'2016-`x'2010
gen b2_`x'=`x'2020-`x'2016
}

*** Poor - Middle - Rich
foreach x in  $var {
xtile `x'_q=`x'2010, n(3)
}

*** Order
order b1_loanamount b2_loanamount loanamount2010 loanamount2016 loanamount2020 HHID_panel caste
sort b2_loanamount


preserve
/*
gen pb=0
replace pb=1 if housevalue2016>3*housevalue2010 & housevalue2016>3*housevalue2020
replace pb=1 if housevalue2016>3*housevalue2010 & housevalue2016>2*housevalue2020
list HHID_panel if pb==1, clean noobs
*/
/*
gen pb=0
replace pb=1 if goldquantityamount2016>3*goldquantityamount2010 & goldquantityamount2016>3*goldquantityamount2020
replace pb=1 if goldquantityamount2016>3*goldquantityamount2010 & goldquantityamount2016>2*goldquantityamount2020
list HHID_panel if pb==1, clean noobs
*/
restore







*** Categories
foreach x in  $var {
gen `x'_cat=.
}
label define cat 1"Only increase" 2"b1+, b2-, +" 3"b1+, b2-, -" 4"Only decrease" 5"b1-, b2+, -" 6"b1-, b2+, +"
foreach x in  $var {
replace `x'_cat=1 if b1_`x'>0 & b2_`x'>0
replace `x'_cat=2 if b1_`x'>0 & b2_`x'<0 & abs(b1_`x')>abs(b2_`x') & `x'_cat==.
replace `x'_cat=3 if b1_`x'>0 & b2_`x'<0 & abs(b1_`x')<abs(b2_`x') & `x'_cat==.
replace `x'_cat=4 if b1_`x'<0 & b2_`x'<0 & `x'_cat==.
replace `x'_cat=5 if b1_`x'<0 & b1_`x'<0 & abs(b1_`x')>abs(b2_`x') & `x'_cat==.
replace `x'_cat=6 if b1_`x'<0 & b1_`x'<0 & abs(b1_`x')<abs(b2_`x') & `x'_cat==.
label values `x'_cat cat
}

ta income_cat caste, nofreq col
ta DAR_without_r_cat caste, nofreq col




*** Drop extremum
foreach x in $var {
forvalues i=1(1)3 {
forvalues j=1(1)2 {
qui sum b`j'_`x' if `x'_q==`i', det
local vmin=r(p1)
local vmax=r(p99)

replace b`j'_`x'=. if b`j'_`x'>=`vmax' & `x'_q==`i'
replace b`j'_`x'=. if b`j'_`x'<=`vmin' & `x'_q==`i'
}
}
}


********** Graph global
foreach x in $var {
set graph off

twoway ///
(scatter b2_`x' b1_`x', xline(0) yline(0) msymbol(oh) msize(medsmall)) ///
(function y=-x, range(b1_`x')) ///
, ///
xlabel(#5) ylabel(#5) ///
xmtick(#10) ymtick(#10) ///
xtitle("β1=2016-2010") ytitle("β2=2020-2016") ///
title("`x'") ///
legend(pos(6) col(2) order(2 "Second bisector")) name(`x', replace)
graph export "graph/comb1_`x'.pdf", replace
set graph on
}





********** Graph over tercile
foreach x in $var {
forvalues i=1(1)3 {
set graph off

twoway ///
(scatter b2_`x' b1_`x' if `x'_q==`i', xline(0) yline(0) msymbol(oh) msize(medsmall)) ///
(function y=-x if `x'_q==`i', range(b1_`x')) ///
, ///
xlabel(#5) ylabel(#5) ///
xmtick(#10) ymtick(#10) ///
xtitle("β1=2016-2010") ytitle("β2=2020-2016") ///
title("Tercile `i' in 2010") ///
legend(pos(6) col(2) order(2 "Second bisector")) name(`x'_`i', replace)
}
grc1leg `x'_1 `x'_2 `x'_3, col(3) title("`x'") name(comb_`x', replace)
graph export "graph/comb2_tercile_`x'.pdf", replace
set graph on
}


********** Graph over caste
foreach cat in caste income_q assetsnl_q {
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














****************************************
* Stat debt evo
****************************************
use"panel_v3", clear


********** Initialization
xtset panelvar time




********** Kernel
foreach y in 2010 2016 2020 {
foreach x in DIR DAR DSR ISR {
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

grc1leg DIR_2010 DIR_2016 DIR_2020 DAR_2010 DAR_2016 DAR_2020 DSR_2010 DSR_2016 DSR_2020 ISR_2010 ISR_2016 ISR_2020, col(3)



********** Boxplot
stripplot DIR_r, over(time) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(1 "2009-10" 2 "2016-17" 3 "2020-21",angle(0))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel() ymtick() ytitle("") ///
legend(order(1 "Mean" 5 "Individual") off) name(box_`x', replace)

*save"panel_v3", replace
****************************************
* END











****************************************
* Econ test
****************************************
use"panel_v3", clear


********** Initialization
xtset panelvar time

xtreg DSR_r assets_noland1000 i.ownland   nontoworkers_HH femtomale_HH i.head_sex i.head_maritalstatus head_age i.head_edulevel i.head_occupation  







****************************************
* END
