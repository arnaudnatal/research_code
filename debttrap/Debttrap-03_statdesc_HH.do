*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*October 7, 2024
*-----
gl link = "debttrap"
*Stat desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------







****************************************
* Stat desc
****************************************
use"panel_HH_v3", clear

********** Total
* Sample size
ta dummyloans_HH year, m
ta dummyloans_HH year, col
keep if dummyloans_HH==1

* Given
ta giv_trap year, col
tabstat giv_trapamount if giv_trap==1, stat(mean med) by(year)
tabstat gtdr if giv_trap==1, stat(mean med) by(year)

* Effective
ta eff_trap year, col
tabstat eff_trapamount if eff_trap==1, stat(mean med) by(year)
tabstat etdr if eff_trap==1, stat(mean med) by(year)

****************************************
* END













****************************************
* Caste and trap
****************************************


********** Dalits
use"panel_HH_v3", clear
fre dalits
keep if dalits==1

* Sample size
ta dummyloans_HH year, m
ta dummyloans_HH year, col
keep if dummyloans_HH==1

* Given
ta giv_trap year, col
tabstat giv_trapamount if giv_trap==1, stat(mean med) by(year)
tabstat gtdr if giv_trap==1, stat(mean med) by(year)

* Effective
ta eff_trap year, col
tabstat eff_trapamount if eff_trap==1, stat(mean med) by(year)
tabstat etdr if eff_trap==1, stat(mean med) by(year)



********** Non-Dalits
use"panel_HH_v3", clear
fre dalits
keep if dalits==0

* Sample size
ta dummyloans_HH year, m
ta dummyloans_HH year, col
keep if dummyloans_HH==1

* Given
ta giv_trap year, col
tabstat giv_trapamount if giv_trap==1, stat(mean med) by(year)
tabstat gtdr if giv_trap==1, stat(mean med) by(year)

* Effective
ta eff_trap year, col
tabstat eff_trapamount if eff_trap==1, stat(mean med) by(year)
tabstat etdr if eff_trap==1, stat(mean med) by(year)




********** Diff
use"panel_HH_v3", clear

keep if dummyloans_HH==1

* Proba given
probit giv_trap i.dalits if year==2010
probit giv_trap i.dalits if year==2016
probit giv_trap i.dalits if year==2020

* Given amount
reg giv_trapamount i.dalits if giv_trap==1 & year==2010
reg giv_trapamount i.dalits if giv_trap==1 & year==2016
reg giv_trapamount i.dalits if giv_trap==1 & year==2020

* Given ratio amount
reg gtdr i.dalits if giv_trap==1 & year==2010
reg gtdr i.dalits if giv_trap==1 & year==2016
reg gtdr i.dalits if giv_trap==1 & year==2020


* Proba effective
probit eff_trap i.dalits if year==2010
probit eff_trap i.dalits if year==2016
probit eff_trap i.dalits if year==2020

* Effective amount
reg eff_trapamount i.dalits if eff_trap==1 & year==2010
reg eff_trapamount i.dalits if eff_trap==1 & year==2016
reg eff_trapamount i.dalits if eff_trap==1 & year==2020

* Effective ratio amount
reg etdr i.dalits if eff_trap==1 & year==2010
reg etdr i.dalits if eff_trap==1 & year==2016
reg etdr i.dalits if eff_trap==1 & year==2020

****************************************
* END















****************************************
* Land ownership and trap
****************************************


********** No land
use"panel_HH_v3", clear
fre ownland
keep if ownland==0

* Sample size
ta dummyloans_HH year, m
ta dummyloans_HH year, col
keep if dummyloans_HH==1

* Given
ta giv_trap year, col
tabstat giv_trapamount if giv_trap==1, stat(mean med) by(year)
tabstat gtdr if giv_trap==1, stat(mean med) by(year)

* Effective
ta eff_trap year, col
tabstat eff_trapamount if eff_trap==1, stat(mean med) by(year)
tabstat etdr if eff_trap==1, stat(mean med) by(year)



********** Landowner
use"panel_HH_v3", clear
fre ownland
keep if ownland==1

* Sample size
ta dummyloans_HH year, m
ta dummyloans_HH year, col
keep if dummyloans_HH==1

* Given
ta giv_trap year, col
tabstat giv_trapamount if giv_trap==1, stat(mean med) by(year)
tabstat gtdr if giv_trap==1, stat(mean med) by(year)

* Effective
ta eff_trap year, col
tabstat eff_trapamount if eff_trap==1, stat(mean med) by(year)
tabstat etdr if eff_trap==1, stat(mean med) by(year)




********** Diff
use"panel_HH_v3", clear

keep if dummyloans_HH==1

* Proba given
probit giv_trap i.ownland if year==2010
probit giv_trap i.ownland if year==2016
probit giv_trap i.ownland if year==2020

* Given amount
reg giv_trapamount i.ownland if giv_trap==1 & year==2010
reg giv_trapamount i.ownland if giv_trap==1 & year==2016
reg giv_trapamount i.ownland if giv_trap==1 & year==2020

* Given ratio amount
reg gtdr i.ownland if giv_trap==1 & year==2010
reg gtdr i.ownland if giv_trap==1 & year==2016
reg gtdr i.ownland if giv_trap==1 & year==2020


* Proba effective
probit eff_trap i.ownland if year==2010
probit eff_trap i.ownland if year==2016
probit eff_trap i.ownland if year==2020

* Effective amount
reg eff_trapamount i.ownland if eff_trap==1 & year==2010
reg eff_trapamount i.ownland if eff_trap==1 & year==2016
reg eff_trapamount i.ownland if eff_trap==1 & year==2020

* Effective ratio amount
reg etdr i.ownland if eff_trap==1 & year==2010
reg etdr i.ownland if eff_trap==1 & year==2016
reg etdr i.ownland if eff_trap==1 & year==2020

****************************************
* END























****************************************
* Income and trap
****************************************

********** Given trap
use"panel_HH_v3", clear

replace annualincome_HH=annualincome_HH/1000

*** Dummy
tabstat annualincome_HH if year==2010, stat(n mean q) by(giv_trap)
tabstat annualincome_HH if year==2016, stat(n mean q) by(giv_trap)
tabstat annualincome_HH if year==2020, stat(n mean q) by(giv_trap)


*** Amount
keep if giv_trap==1
pwcorr giv_trapamount annualincome_HH if year==2010, sig
pwcorr giv_trapamount annualincome_HH if year==2016, sig
pwcorr giv_trapamount annualincome_HH if year==2020, sig
spearman giv_trapamount annualincome_HH if year==2010, stats(rho p)
spearman giv_trapamount annualincome_HH if year==2016, stats(rho p)
spearman giv_trapamount annualincome_HH if year==2020, stats(rho p)

*** Ratio dette
replace gtdr=gtdr*100
pwcorr gtdr annualincome_HH if year==2010, sig
pwcorr gtdr annualincome_HH if year==2016, sig
pwcorr gtdr annualincome_HH if year==2020, sig
spearman gtdr annualincome_HH if year==2010, stats(rho p)
spearman gtdr annualincome_HH if year==2016, stats(rho p)
spearman gtdr annualincome_HH if year==2020, stats(rho p)

*** Ratio actifs
replace gtar=gtar*100
pwcorr gtar annualincome_HH if year==2010, sig
pwcorr gtar annualincome_HH if year==2016, sig
pwcorr gtar annualincome_HH if year==2020, sig
spearman gtar annualincome_HH if year==2010, stats(rho p)
spearman gtar annualincome_HH if year==2016, stats(rho p)
spearman gtar annualincome_HH if year==2020, stats(rho p)







********** Effective trap
use"panel_HH_v3", clear

replace annualincome_HH=annualincome_HH/1000

*** Dummy
tabstat annualincome_HH if year==2010, stat(n mean q) by(eff_trap)
tabstat annualincome_HH if year==2016, stat(n mean q) by(eff_trap)
tabstat annualincome_HH if year==2020, stat(n mean q) by(eff_trap)

*** Amount
keep if eff_trap==1
pwcorr eff_trapamount annualincome_HH if year==2010, sig
pwcorr eff_trapamount annualincome_HH if year==2016, sig
pwcorr eff_trapamount annualincome_HH if year==2020, sig
spearman eff_trapamount annualincome_HH if year==2010, stats(rho p)
spearman eff_trapamount annualincome_HH if year==2016, stats(rho p)
spearman eff_trapamount annualincome_HH if year==2020, stats(rho p)

*** Ratio dette
replace etdr=etdr*100
pwcorr etdr annualincome_HH if year==2010, sig
pwcorr etdr annualincome_HH if year==2016, sig
pwcorr etdr annualincome_HH if year==2020, sig
spearman etdr annualincome_HH if year==2010, stats(rho p)
spearman etdr annualincome_HH if year==2016, stats(rho p)
spearman etdr annualincome_HH if year==2020, stats(rho p)

*** Ratio actifs
replace etar=etar*100
pwcorr etar annualincome_HH if year==2010, sig
pwcorr etar annualincome_HH if year==2016, sig
pwcorr etar annualincome_HH if year==2020, sig
spearman etar annualincome_HH if year==2010, stats(rho p)
spearman etar annualincome_HH if year==2016, stats(rho p)
spearman etar annualincome_HH if year==2020, stats(rho p)

****************************************
* END

















****************************************
* Wealth and trap
****************************************

********** Given trap
use"panel_HH_v3", clear

*** Dummy
tabstat assets_total1000 if year==2010, stat(n mean q) by(giv_trap)
tabstat assets_total1000 if year==2016, stat(n mean q) by(giv_trap)
tabstat assets_total1000 if year==2020, stat(n mean q) by(giv_trap)

*** Amount
keep if giv_trap==1
pwcorr giv_trapamount assets_total1000 if year==2010, sig
pwcorr giv_trapamount assets_total1000 if year==2016, sig
pwcorr giv_trapamount assets_total1000 if year==2020, sig
spearman giv_trapamount assets_total1000 if year==2010, stats(rho p)
spearman giv_trapamount assets_total1000 if year==2016, stats(rho p)
spearman giv_trapamount assets_total1000 if year==2020, stats(rho p)

*** Ratio dette
replace gtdr=gtdr*100
pwcorr gtdr assets_total1000 if year==2010, sig
pwcorr gtdr assets_total1000 if year==2016, sig
pwcorr gtdr assets_total1000 if year==2020, sig
spearman gtdr assets_total1000 if year==2010, stats(rho p)
spearman gtdr assets_total1000 if year==2016, stats(rho p)
spearman gtdr assets_total1000 if year==2020, stats(rho p)

*** Ratio actifs
replace gtar=gtar*100
pwcorr gtar assets_total1000 if year==2010, sig
pwcorr gtar assets_total1000 if year==2016, sig
pwcorr gtar assets_total1000 if year==2020, sig
spearman gtar assets_total1000 if year==2010, stats(rho p)
spearman gtar assets_total1000 if year==2016, stats(rho p)
spearman gtar assets_total1000 if year==2020, stats(rho p)







********** Effective trap
use"panel_HH_v3", clear

*** Dummy
tabstat assets_total1000 if year==2010, stat(n mean q) by(eff_trap)
tabstat assets_total1000 if year==2016, stat(n mean q) by(eff_trap)
tabstat assets_total1000 if year==2020, stat(n mean q) by(eff_trap)

*** Amount
keep if eff_trap==1
pwcorr eff_trapamount assets_total1000 if year==2010, sig
pwcorr eff_trapamount assets_total1000 if year==2016, sig
pwcorr eff_trapamount assets_total1000 if year==2020, sig
spearman eff_trapamount assets_total1000 if year==2010, stats(rho p)
spearman eff_trapamount assets_total1000 if year==2016, stats(rho p)
spearman eff_trapamount assets_total1000 if year==2020, stats(rho p)

*** Ratio dette
replace etdr=etdr*100
pwcorr etdr assets_total1000 if year==2010, sig
pwcorr etdr assets_total1000 if year==2016, sig
pwcorr etdr assets_total1000 if year==2020, sig
spearman etdr assets_total1000 if year==2010, stats(rho p)
spearman etdr assets_total1000 if year==2016, stats(rho p)
spearman etdr assets_total1000 if year==2020, stats(rho p)

*** Ratio actifs
replace etar=etar*100
pwcorr etar assets_total1000 if year==2010, sig
pwcorr etar assets_total1000 if year==2016, sig
pwcorr etar assets_total1000 if year==2020, sig
spearman etar assets_total1000 if year==2010, stats(rho p)
spearman etar assets_total1000 if year==2016, stats(rho p)
spearman etar assets_total1000 if year==2020, stats(rho p)

****************************************
* END













****************************************
* DSR and trap
****************************************

********** Given trap
use"panel_HH_v3", clear

replace dsr=dsr*100

*** Dummy
tabstat dsr if year==2010, stat(n mean q) by(giv_trap)
tabstat dsr if year==2016, stat(n mean q) by(giv_trap)
tabstat dsr if year==2020, stat(n mean q) by(giv_trap)

*** Amount
keep if giv_trap==1
pwcorr giv_trapamount dsr if year==2010, sig
pwcorr giv_trapamount dsr if year==2016, sig
pwcorr giv_trapamount dsr if year==2020, sig
spearman giv_trapamount dsr if year==2010, stats(rho p)
spearman giv_trapamount dsr if year==2016, stats(rho p)
spearman giv_trapamount dsr if year==2020, stats(rho p)

*** Ratio dette
replace gtdr=gtdr*100
pwcorr gtdr dsr if year==2010, sig
pwcorr gtdr dsr if year==2016, sig
pwcorr gtdr dsr if year==2020, sig
spearman gtdr dsr if year==2010, stats(rho p)
spearman gtdr dsr if year==2016, stats(rho p)
spearman gtdr dsr if year==2020, stats(rho p)

*** Ratio actifs
replace gtar=gtar*100
pwcorr gtar dsr if year==2010, sig
pwcorr gtar dsr if year==2016, sig
pwcorr gtar dsr if year==2020, sig
spearman gtar dsr if year==2010, stats(rho p)
spearman gtar dsr if year==2016, stats(rho p)
spearman gtar dsr if year==2020, stats(rho p)







********** Effective trap
use"panel_HH_v3", clear

*** Dummy
tabstat dsr if year==2010, stat(n mean q) by(eff_trap)
tabstat dsr if year==2016, stat(n mean q) by(eff_trap)
tabstat dsr if year==2020, stat(n mean q) by(eff_trap)

*** Amount
keep if eff_trap==1
pwcorr eff_trapamount dsr if year==2010, sig
pwcorr eff_trapamount dsr if year==2016, sig
pwcorr eff_trapamount dsr if year==2020, sig
spearman eff_trapamount dsr if year==2010, stats(rho p)
spearman eff_trapamount dsr if year==2016, stats(rho p)
spearman eff_trapamount dsr if year==2020, stats(rho p)

*** Ratio dette
replace etdr=etdr*100
pwcorr etdr dsr if year==2010, sig
pwcorr etdr dsr if year==2016, sig
pwcorr etdr dsr if year==2020, sig
spearman etdr dsr if year==2010, stats(rho p)
spearman etdr dsr if year==2016, stats(rho p)
spearman etdr dsr if year==2020, stats(rho p)

*** Ratio actifs
replace etar=etar*100
pwcorr etar dsr if year==2010, sig
pwcorr etar dsr if year==2016, sig
pwcorr etar dsr if year==2020, sig
spearman etar dsr if year==2010, stats(rho p)
spearman etar dsr if year==2016, stats(rho p)
spearman etar dsr if year==2020, stats(rho p)

****************************************
* END






























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







********** Effective trap
use"panel_HH_v3", clear

keep if dummyloans_HH==1
replace annualincome_HH=annualincome_HH/1000
keep HHID_panel year eff_trap annualincome_HH
rename annualincome_HH contvar
rename eff_trap catvar
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
graph export "graph/Effective_proba_income.png", as(png) replace


****************************************
* END




















****************************************
* Wealth (with land) and trap
****************************************

********** Given trap
use"panel_HH_v3", clear

keep if dummyloans_HH==1
keep HHID_panel year giv_trap assets_total1000
rename assets_total1000 contvar
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
, ylabel(0(400)2800) ymtick(0(200)2800) ///
xlabel(1 2,valuelabel angle(0)) ///
ytitle("Wealth (1k rupees)") xtitle("") ///
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
, ylabel(0(400)2800) ymtick(0(200)2800) ///
xlabel(1 2,valuelabel angle(0)) ///
ytitle("Wealth (1k rupees)") xtitle("") ///
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
, ylabel(0(400)2800) ymtick(0(200)2800) ///
xlabel(1 2,valuelabel angle(0)) ///
ytitle("Wealth (1k rupees)") xtitle("") ///
title("2020-21") ///
legend(off) scale(1.2) /// 
name(g3, replace)
restore

* Combine
graph combine g1 g2 g3, col(3)
graph export "graph/Given_proba_wealth.png", as(png) replace







********** Effective trap
use"panel_HH_v3", clear

keep if dummyloans_HH==1
keep HHID_panel year eff_trap assets_total1000
rename assets_total1000 contvar
rename eff_trap catvar
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
, ylabel(0(400)3200) ymtick(0(200)3200) ///
xlabel(1 2,valuelabel angle(0)) ///
ytitle("Wealth (1k rupees)") xtitle("") ///
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
, ylabel(0(400)3200) ymtick(0(200)3200) ///
xlabel(1 2,valuelabel angle(0)) ///
ytitle("Wealth (1k rupees)") xtitle("") ///
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
, ylabel(0(400)3200) ymtick(0(200)3200) ///
xlabel(1 2,valuelabel angle(0)) ///
ytitle("Wealth (1k rupees)") xtitle("") ///
title("2020-21") ///
legend(off) scale(1.2) /// 
name(g3, replace)
restore

* Combine
graph combine g1 g2 g3, col(3)
graph export "graph/Effective_proba_wealth.png", as(png) replace


****************************************
* END





















****************************************
* Wealth (without land) and trap
****************************************

********** Given trap
use"panel_HH_v3", clear

keep if dummyloans_HH==1
keep HHID_panel year giv_trap assets_totalnoland1000
rename assets_totalnoland1000 contvar
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
, ylabel(0(80)640) ymtick(0(40)640) ///
xlabel(1 2,valuelabel angle(0)) ///
ytitle("Wealth (1k rupees)") xtitle("") ///
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
, ylabel(0(80)640) ymtick(0(40)640) ///
xlabel(1 2,valuelabel angle(0)) ///
ytitle("Wealth (1k rupees)") xtitle("") ///
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
, ylabel(0(80)640) ymtick(0(40)640) ///
xlabel(1 2,valuelabel angle(0)) ///
ytitle("Wealth (1k rupees)") xtitle("") ///
title("2020-21") ///
legend(off) scale(1.2) /// 
name(g3, replace)
restore

* Combine
graph combine g1 g2 g3, col(3)
graph export "graph/Given_proba_wealthnl.png", as(png) replace







********** Effective trap
use"panel_HH_v3", clear

keep if dummyloans_HH==1
keep HHID_panel year eff_trap assets_totalnoland1000
rename assets_totalnoland1000 contvar
rename eff_trap catvar
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
, ylabel(0(80)640) ymtick(0(40)640) ///
xlabel(1 2,valuelabel angle(0)) ///
ytitle("Wealth (1k rupees)") xtitle("") ///
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
, ylabel(0(80)640) ymtick(0(40)640) ///
xlabel(1 2,valuelabel angle(0)) ///
ytitle("Wealth (1k rupees)") xtitle("") ///
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
, ylabel(0(80)640) ymtick(0(40)640) ///
xlabel(1 2,valuelabel angle(0)) ///
ytitle("Wealth (1k rupees)") xtitle("") ///
title("2020-21") ///
legend(off) scale(1.2) /// 
name(g3, replace)
restore

* Combine
graph combine g1 g2 g3, col(3)
graph export "graph/Effective_proba_wealthnl.png", as(png) replace


****************************************
* END




















****************************************
* DSR and trap
****************************************

********** Given trap
use"panel_HH_v3", clear

keep if dummyloans_HH==1
keep HHID_panel year giv_trap dsr
replace dsr=dsr*100
rename dsr contvar
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
, ylabel(0(10)80) ymtick(0(5)80) ///
xlabel(1 2,valuelabel angle(0)) ///
ytitle("DSR (%)") xtitle("") ///
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
, ylabel(0(10)80) ymtick(0(5)80) ///
xlabel(1 2,valuelabel angle(0)) ///
ytitle("DSR (%)") xtitle("") ///
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
, ylabel(0(10)80) ymtick(0(5)80) ///
xlabel(1 2,valuelabel angle(0)) ///
ytitle("DSR (%)") xtitle("") ///
title("2020-21") ///
legend(off) scale(1.2) /// 
name(g3, replace)
restore

* Combine
graph combine g1 g2 g3, col(3)
graph export "graph/Given_proba_dsr.png", as(png) replace







********** Effective trap
use"panel_HH_v3", clear

keep if dummyloans_HH==1
keep HHID_panel year eff_trap dsr
replace dsr=dsr*100
rename dsr contvar
rename eff_trap catvar
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
, ylabel(0(10)80) ymtick(0(8)80) ///
xlabel(1 2,valuelabel angle(0)) ///
ytitle("DSR (%)") xtitle("") ///
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
, ylabel(0(10)80) ymtick(0(8)80) ///
xlabel(1 2,valuelabel angle(0)) ///
ytitle("DSR (%)") xtitle("") ///
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
, ylabel(0(10)80) ymtick(0(8)80) ///
xlabel(1 2,valuelabel angle(0)) ///
ytitle("DSR (%)") xtitle("") ///
title("2020-21") ///
legend(off) scale(1.2) /// 
name(g3, replace)
restore

* Combine
graph combine g1 g2 g3, col(3)
graph export "graph/Effective_proba_dsr.png", as(png) replace


****************************************
* END



