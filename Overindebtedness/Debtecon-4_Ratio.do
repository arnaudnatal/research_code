cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
September 30, 2021
-----
Panel for indebtedness and over-indebtedness
-----

-------------------------
*/









****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
********** Path to folder "data" folder.
global directory = "D:\Documents\_Thesis\Research-Overindebtedness\Persistence_over"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
set scheme plotplain

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH_v8"
global wave3 "NEEMSIS2-HH_v19"

global loan1 "RUME-loans_v8"
global loan2 "NEEMSIS1-loans_v4"
global loan3 "NEEMSIS2-all_loans"



********** Deflate
*https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
*(100/158) if year==2016
*(100/184) if year==2020



****************************************
* END












****************************************
* Ratio
****************************************
use"panel_v4", clear



********** Replace assets
/*
egen assetsnew=rowtotal(amountownland livestock housevalue_new goldquantityamount_new goodtotalamount)
egen assetsnew_noland=rowtotal(livestock housevalue_new goldquantityamount_new goodtotalamount)
gen assetsnew1000=assetsnew/1000
gen assetsnew_noland1000=assetsnew_noland/1000
drop assetsnew assetsnew_noland

tabstat assets1000 assetsnew1000 assets_noland1000 assetsnew_noland1000, stat(n mean sd p50) by(year)

global assecalc assets1000 assetsnew1000 assets_noland1000 assetsnew_noland1000
*/



**********Debt measure
tabstat loanamount annualincome assets assets_noland imp1_ds_tot imp1_is_tot, stat(n mean sd p50 min max) by(year)

*Continuous
gen DIR=loanamount/annualincome

gen DAR_without=loanamount/assets_noland
gen DAR_with=loanamount/assets

*gen DAR_with_new=loanamount/assetsnew
*gen DAR_without_new=loanamount/assetsnew_noland

gen DSR=imp1_ds_tot/annualincome
gen ISR=imp1_is_tot/annualincome


*Dummy for overindebtedness
foreach x in DSR DAR_with DAR_without { //DAR_with_new DAR_without_new {
forvalues i=30(10)50{
gen `x'`i'=0
}
}

foreach x in DSR DAR_with DAR_without { //DAR_with_new DAR_without_new {
forvalues i=30(10)50{
replace `x'`i'=1 if `x'>=.`i' & `x'!=.
}
}


*** Recode for extreme
foreach x in DIR DAR_with DAR_without DSR ISR {
clonevar `x'_r=`x'
}

replace DIR_r=9.5 if DIR>=10 & year==2010
replace DIR_r=25.51 if DIR>=26 & year==2016
replace DIR_r=50 if DIR>=51 & year==2020

replace DAR_with_r=2 if DAR_with>=2.2 & year==2010
replace DAR_with_r=10.41 if DAR_with>=11 & year==2016
replace DAR_with_r=2.32 if DAR_with>=2.5 & year==2020

replace DAR_without_r=2 if DAR_without>=2.2 & year==2010
replace DAR_without_r=10.41 if DAR_without>=11 & year==2016
replace DAR_without_r=2.32 if DAR_without>=2.5 & year==2020

*replace DAR_with_new_r=2 if DAR_with_new>=2.2 & year==2010
*replace DAR_with_new_r=10.41 if DAR_with_new>=11 & year==2016
*replace DAR_with_new_r=2.32 if DAR_with_new>=2.5 & year==2020

*replace DAR_without_new_r=2 if DAR_without_new>=2.2 & year==2010
*replace DAR_without_new_r=10.41 if DAR_without_new>=11 & year==2016
*replace DAR_without_new_r=2.32 if DAR_without_new>=2.5 & year==2020

replace DSR_r=2.66 if DSR>=2.7 & year==2010
replace DSR_r=3.7 if DSR>=3.8 & year==2016
replace DSR_r=7.22 if DSR>=7.3 & year==2020

replace ISR_r=0.74 if ISR>=0.75 & year==2010
replace ISR_r=2.34 if ISR>=2.35 & year==2016
replace ISR_r=3.11 if ISR>=3.13 & year==2020



********* Desc
ta caste year
cls
foreach x in DSR30 DSR40 DSR50 DAR_with30 DAR_with40 DAR_with50 DAR_without30 DAR_without40 DAR_without50 {
ta `x' year if caste==1, col nofreq
ta `x' year if caste==2, col nofreq
ta `x' year if caste==3, col nofreq
}

preserve
keep if panel==1
cls
foreach x in DSR30 DSR40 DSR50 DAR_with30 DAR_with40 DAR_with50 DAR_without30 DAR_without40 DAR_without50 {
ta `x' year if caste==1, col nofreq
ta `x' year if caste==2, col nofreq
ta `x' year if caste==3, col nofreq
}
restore

save"panel_v5", replace
****************************************
* END














****************************************
* Evo
****************************************
use"panel_v5", clear
********** Initialization
xtset time panelvar

global var DIR_r DAR_with_r DAR_without_r DSR_r ISR_r loanamount annualincome

*** Select+reshape
keep HHID_panel year caste panel $var
reshape wide $var, i(HHID_panel) j(year)


********** Graph1
foreach y in DIR_r DAR_with_r DAR_without_r DSR_r ISR_r loanamount annualincome {
set graph off
forvalues i=1(1)3 {

foreach j in 10 16 20 {
qui sum `y'20`j' if caste==`i', det
local med`j'=round(r(p50),1)
local n`j'=r(N)
}

stripplot `y'2010 `y'2016 `y'2020 if caste==`i', over() separate() ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("Caste `i'") xlabel(1"2010" 2"2016-17" 3"2020-21",angle(45))  ///
ylabel(#10) ymtick(#20) ytitle("`y'") ///
msymbol(oh) mcolor(ply`i') ///
note("N--Median" "2010: `n10'--`med10'" "2016: `n16'--`med16'" "2020: `n20'--`med20'", size(small)) ///
legend(off) ///
name(`y'`i', replace) 
}
graph combine `y'1 `y'2 `y'3, title("`y'") col(3) name(`y'_comb, replace)
graph export "graph/evo_`y'.pdf", replace
set graph on
}


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
