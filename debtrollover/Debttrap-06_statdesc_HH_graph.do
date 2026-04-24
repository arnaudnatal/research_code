*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*January 21, 2025
*-----
gl link = "debtrollover"
*Stat desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------








****************************************
* Incidence of debt trap
****************************************
use"panel_HH_v2", clear

keep if dummyloans==1
ta year
ta dummytrap year, col nofreq
ta year dummytrap, row nofreq

tabplot dummytrap year, percent(year) showval frame(100) ///
frameopts(color(gs5)) ///
fcolor(gs5*0.4) lcolor(gs5) ///
subtitle("") ///
xtitle("") ytitle("Debt rollover?") ///
xlabel(1 "2010" 2 "2016-2017" 3 "2020-2021") ylabel(1 "Yes" 2 "No") ///
note("{it:Note:} Per cent given year.", size(small)) ///
scale(1.2)
graph export "graph/Incidence.png", as(png) replace


**
ta dummytrap year, col nofreq
ta year dummytrap, row nofreq
*
input y notrap trap
1 81.48 18.52
3 83.57 16.43
5 54.12 45.88
end
label define y 1"2010" 3"2016-2017" 5"2020-2021", replace
label values y y
gen sum1=trap
gen sum2=sum1+notrap
* 
twoway ///
(bar sum1 y, barwidth(1.9)) ///
(rbar sum1 sum2 y, barwidth(1.9)) ///
, ///
xlabel(1 3 5,valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
legend(order(1 "Debt rollover" 2 "No debt rollover") pos(6) col(3)) ///
note("", size(small)) ///
name(g1, replace) scale(1.2)
graph export "graph/Incidence2.png", as(png) replace


****************************************
* END












****************************************
* Incidence of debt trap by caste
****************************************
use"panel_HH_v2", clear

keep if dummyloans==1

ta caste dummytrap if year==2010, chi2 exp cchi2
ta caste dummytrap if year==2016, chi2 exp cchi2
ta caste dummytrap if year==2020, chi2 exp cchi2
ta caste dummytrap, chi2 exp cchi2

* Dalits
preserve
keep if caste==1
tabplot dummytrap year, percent(year) showval frame(100) ///
frameopts(color(plb1)) ///
fcolor(plb1*0.4) lcolor(plb1) ///
subtitle("") ///
title("Dalits") ///
xtitle("") ytitle("Debt rollover") ///
xlabel(1 "2010" 2 "2016-2017" 3 "2020-2021") ylabel(1 "Yes" 2 "No") ///
scale(1.2) name(dal, replace)
restore

* Middle castes
preserve
keep if caste==2
tabplot dummytrap year, percent(year) showval frame(100) ///
frameopts(color(plb1)) ///
fcolor(plb1*0.4) lcolor(plb1) ///
subtitle("") ///
title("Middle castes") ///
xtitle("") ytitle("Debt rollover") ///
xlabel(1 "2010" 2 "2016-2017" 3 "2020-2021") ylabel(1 "Yes" 2 "No") ///
scale(1.2) name(mid, replace)
restore


* Dalits
preserve
keep if caste==3
tabplot dummytrap year, percent(year) showval frame(100) ///
frameopts(color(plb1)) ///
fcolor(plb1*0.4) lcolor(plb1) ///
subtitle("") ///
title("Upper castes") ///
xtitle("") ytitle("Debt rollover") ///
xlabel(1 "2010" 2 "2016-2017" 3 "2020-2021") ylabel(1 "Yes" 2 "No") ///
scale(1.2) name(upp, replace)
restore

***** Comb
graph combine dal mid upp, col(3)


****************************************
* END























****************************************
* Intensity of debt trap
****************************************
use"panel_HH_v2", clear

keep if dummytrap==1
ta year


********** Absolut intensity (amount)
bys time: egen med = median(trapamount)
bys time: egen lqt = pctile(trapamount), p(25)
bys time: egen uqt = pctile(trapamount), p(75)
bys time: egen iqr = iqr(trapamount)
bys time: egen mean = mean(trapamount)
gen l = trapamount if(trapamount >= lqt-1.5*iqr)
bys time: egen ls = min(l)
gen u = trapamount if(trapamount <= uqt+1.5*iqr)
bys time: egen us = max(u)
*
twoway rbar lqt med time, fcolor(gs12) lcolor(black) barw(.5) || ///
       rbar med uqt time, fcolor(gs12) lcolor(black) barw(.5) || ///
       rspike lqt ls time, lcolor(black) || ///
       rspike uqt us time, lcolor(black) || ///
       rcap ls ls time, msize(*6) lcolor(black) || ///
       rcap us us time, msize(*6) pstyle(p1) || ///
       scatter mean time, msymbol(Oh) msize(*1) mcolor(black) ///
       legend(off)  xlabel( 1 "2010" 2 "2016-2017" 3 "2020-2021") ///
	   ylabel(0(20)180) ///
       ytitle("1,000 rupees") xtitle("") title("Debt rollover amount") scale(1.2) name(abs, replace)
*
drop med lqt uqt iqr mean l ls u us
	   
/*
tabstat trapamount, stat(n mean q) by(year)
violinplot trapamount, over(time) horizontal left dscale(4) noline now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
title("Debt rollover amount") ///
xtitle("1,000 rupees") xlabel(0(20)200) ///
ylabel(,grid) ///
legend(order(4 "IQR" 7 "Median" 10 "Mean") pos(6) col(3) on) ///
aspectratio() scale(1.2) name(abs, replace) range(0 200)
graph export "graph/Abs_intensity.png", as(png) replace
*/


********** Relative intensity (percent to debt)
bys time: egen med = median(gtdr)
bys time: egen lqt = pctile(gtdr), p(25)
bys time: egen uqt = pctile(gtdr), p(75)
bys time: egen iqr = iqr(gtdr)
bys time: egen mean = mean(gtdr)
gen l = gtdr if(gtdr >= lqt-1.5*iqr)
bys time: egen ls = min(l)
gen u = gtdr if(gtdr <= uqt+1.5*iqr)
bys time: egen us = max(u)
*
twoway rbar lqt med time, fcolor(gs12) lcolor(black) barw(.5) || ///
       rbar med uqt time, fcolor(gs12) lcolor(black) barw(.5) || ///
       rspike lqt ls time, lcolor(black) || ///
       rspike uqt us time, lcolor(black) || ///
       rcap ls ls time, msize(*6) lcolor(black) || ///
       rcap us us time, msize(*6) pstyle(p1) || ///
       scatter mean time, msymbol(Oh) msize(*1) mcolor(black) ///
       legend(off)  xlabel( 1 "2010" 2 "2016-2017" 3 "2020-2021") ///
	   ylabel(0(10)100) ///
       ytitle("Per cent") xtitle("") title("Share of debt rollover in household debt") scale(1.2) name(rel, replace)
*
drop med lqt uqt iqr mean l ls u us

/*
tabstat gtdr, stat(n mean q) by(year)
violinplot gtdr, over(time) horizontal left dscale(4) noline now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
title("Share of debt rollover in household debt") ///
xtitle("Percent") xlabel(0(10)100) ///
ylabel(,grid) ///
legend(order(4 "IQR" 7 "Median" 10 "Mean") pos(6) col(3) on) ///
aspectratio() scale(1.2) name(rel, replace) range(0 100)
graph export "graph/Rel_intensity.png", as(png) replace
*/

********** Relative intensity (percent to income)
bys time: egen med = median(gtir_HH)
bys time: egen lqt = pctile(gtir_HH), p(25)
bys time: egen uqt = pctile(gtir_HH), p(75)
bys time: egen iqr = iqr(gtir_HH)
bys time: egen mean = mean(gtir_HH)
gen l = gtir_HH if(gtir_HH >= lqt-1.5*iqr)
bys time: egen ls = min(l)
gen u = gtir_HH if(gtir_HH <= uqt+1.5*iqr)
bys time: egen us = max(u)
*
twoway rbar lqt med time, fcolor(gs12) lcolor(black) barw(.5) || ///
       rbar med uqt time, fcolor(gs12) lcolor(black) barw(.5) || ///
       rspike lqt ls time, lcolor(black) || ///
       rspike uqt us time, lcolor(black) || ///
       rcap ls ls time, msize(*6) lcolor(black) || ///
       rcap us us time, msize(*6) pstyle(p1) || ///
       scatter mean time, msymbol(Oh) msize(*1) mcolor(black) ///
       legend(off)  xlabel( 1 "2010" 2 "2016-2017" 3 "2020-2021") ///
	   ylabel(0(20)200) ///
       ytitle("Per cent") xtitle("") title("Share of debt rollover in annual income") scale(1.2) name(rel2, replace)
graph export "graph/Rel_intensity2.png", as(png) replace
*
drop med lqt uqt iqr mean l ls u us

/*
tabstat gtir_HH, stat(n mean q) by(year)
violinplot gtir_HH, over(time) horizontal left dscale(4) noline now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
title("Share of debt rollover in annual income") ///
xtitle("Percent") xlabel(0(20)200) ///
ylabel(,grid) ///
legend(order(4 "IQR" 7 "Median" 10 "Mean") pos(6) col(3) on) ///
aspectratio() scale(1.2) name(rel2, replace) range(0 200)
graph export "graph/Rel_intensity2.png", as(png) replace
*/


********** Total amount of debt
/*
tabstat loanamount_HH, stat(n mean q p90 p95 p99 max) by(year)
violinplot loanamount_HH, over(time) horizontal left dscale(4) noline now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
title("Total amount of debt") ///
xtitle("1,000 rupees") xlabel(0(80)800) ///
ylabel(,grid) ///
legend(order(4 "IQR" 7 "Median" 10 "Mean") pos(6) col(3) on) ///
aspectratio() scale(1.2) name(amt, replace) range(0 800)
graph export "graph/Amountdebt.png", as(png) replace
*/


********** Both
graph combine abs rel, col(2) name(comb, replace)
graph export "graph/Intensity.png", as(png) replace


****************************************
* END
















****************************************
* Assets and trap
****************************************
use"panel_HH_v2", clear

keep if dummyloans==1

***** 2010
twoway ///
(kdensity assets_total1000 if year==2010 & dummytrap==0, bwidth(800)) ///
(kdensity assets_total1000 if year==2010 &  dummytrap==1, bwidth(800)) ///
, xtitle("Total wealth (1,000 rupees)") ytitle("Density") ///
title("2010") ///
legend(order(1 "Not debt rollover" 2 "Debt rollover") pos(6) col(2)) ///
scale(1.2) aspectratio(1.5) name(g1, replace)

***** 2016-17
twoway ///
(kdensity assets_total1000 if year==2016 & dummytrap==0, bwidth(800)) ///
(kdensity assets_total1000 if year==2016 &  dummytrap==1, bwidth(800)) ///
, xtitle("Total wealth (1,000 rupees)") ytitle("Density") ///
title("2016-2017") ///
legend(order(1 "No debt rollover" 2 "Debt rollover") pos(6) col(2)) ///
scale(1.2) aspectratio(1.5) name(g2, replace)


***** 2020-21
twoway ///
(kdensity assets_total1000 if year==2020 & dummytrap==0, bwidth(800)) ///
(kdensity assets_total1000 if year==2020 &  dummytrap==1, bwidth(800)) ///
, xtitle("Total wealth (1,000 rupees)") ytitle("Density") ///
title("2020-2021") ///
legend(order(1 "No debt rollover" 2 "Debt rollover") pos(6) col(2)) ///
scale(1.2) aspectratio(1.5) name(g3, replace)


***** Combine
grc1leg g1 g2 g3, col(3) ///
note("Kernel: Epanechnikov" "Bandwidth=2", size(small)) ///
name(comb,replace)

****************************************
* END
























****************************************
* Income and trap
****************************************

********** Given trap
use"panel_HH_v2", clear

keep if dummyloans==1
replace annualincome_HH=annualincome_HH/1000
keep HHID_panel year dummytrap annualincome_HH
rename annualincome_HH contvar
rename dummytrap catvar
gen contvar1=contvar if year==2010 & catvar==0
gen contvar2=contvar if year==2010 & catvar==1
gen contvar3=contvar if year==2016 & catvar==0
gen contvar4=contvar if year==2016 & catvar==1
gen contvar5=contvar if year==2020 & catvar==0
gen contvar6=contvar if year==2020 & catvar==1

***** Macro for formatting database
global var contvar1 contvar2 contvar3 contvar4 contvar5 contvar6
local i=1
foreach x in $var {
preserve
rename `x' var
keep var
collapse (mean) m_var=var (sd) sd_var=var (count) n_var=var
gen sample=`i'
order sample
* M
gen max_var=m_var+invttail(n_var-1,0.025)*(sd_var/sqrt(n_var))
gen min_var=m_var-invttail(n_var-1,0.025)*(sd_var/sqrt(n_var))
save"_temp`i'", replace
restore
local i=`i'+1
}

***** Append
use "_temp1", clear

forvalues i=2/6 {
append using "_temp`i'"
}

gen year=.
replace year=2010 if sample==1
replace year=2010 if sample==2
replace year=2016 if sample==3
replace year=2016 if sample==4
replace year=2020 if sample==5
replace year=2020 if sample==6

replace sample=1 if sample==3
replace sample=2 if sample==4
replace sample=1 if sample==5
replace sample=2 if sample==6

order sample year

label define sample 1"No rollover" 2"Rollover", replace
label values sample sample


***** Graph
* 2010
preserve
keep if year==2010
twoway ///
(bar m_var sample, barwidth(.8)) ///
(rspike max_var min_var sample) ///
, ylabel(0(40)240) ymtick(0(20)240) ///
xlabel(1 2,valuelabel angle(0)) ///
ytitle("Annual income (1,000 rupees)") xtitle("") ///
title("2010") ///
legend(off) scale(1.2) /// 
name(g1, replace)
restore

* 2016
preserve
keep if year==2016
twoway ///
(bar m_var sample, barwidth(.8)) ///
(rspike max_var min_var sample) ///
, ylabel(0(40)240) ymtick(0(20)240) ///
xlabel(1 2,valuelabel angle(0)) ///
ytitle("Annual income (1,000 rupees)") xtitle("") ///
title("2016-2017") ///
legend(off) scale(1.2) /// 
name(g2, replace)
restore

* 2010
preserve
keep if year==2020
twoway ///
(bar m_var sample, barwidth(.8)) ///
(rspike max_var min_var sample) ///
, ylabel(0(40)240) ymtick(0(20)240) ///
xlabel(1 2,valuelabel angle(0)) ///
ytitle("Annual income (1,000 rupees)") xtitle("") ///
title("2020-2021") ///
legend(off) scale(1.2) /// 
name(g3, replace)
restore

* Combine
graph combine g1 g2 g3, col(3)
graph export "graph/Given_proba_income.png", as(png) replace


****************************************
* END











