*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*January 21, 2025
*-----
gl link = "debttrap"
*Stat desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------









****************************************
* Income and trap
****************************************

********** Given trap
use"panel_HH_v3", clear

keep if dummyloans_HH==1
replace annualincome_HH=annualincome_HH/1000
keep HHID_panel year giv_trap annualincome_HH
rename annualincome_HH contvar
rename giv_trap catvar
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

label define sample 1"Non-trapped" 2"Trapped", replace
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
ytitle("Annual income (1k rupees)") xtitle("") ///
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
ytitle("Annual income (1k rupees)") xtitle("") ///
title("2016-17") ///
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
ytitle("Annual income (1k rupees)") xtitle("") ///
title("2020-21") ///
legend(off) scale(1.2) /// 
name(g3, replace)
restore

* Combine
graph combine g1 g2 g3, col(3)
graph export "graph/Given_proba_income.png", as(png) replace


****************************************
* END











