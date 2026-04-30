*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*April 29, 2026
*-----
gl link = "debttrap"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------








****************************************
* Nonparametric regression
****************************************
use"panel_HH_v1", clear


********** Selection
global debt log_dsr log_isr log_dar log_dir
global var assets_total1000 annualincome_HH dalits 
keep HHID_panel time $debt $var
bys HHID_panel: gen n=_N
keep if n==2
drop n
reshape wide $debt $var, i(HHID_panel) j(time)
foreach x in $var {
drop `x'2
}

*** Hetero
xtile wealth_cat=assets_total10001, n(3)
xtile income_cat=annualincome_HH1, n(3)
drop assets_total10001 annualincome_HH1
rename dalits1 dalits


*** All
lpoly log_dsr2 log_dsr1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48))


*** Caste
* Dalits
lpoly log_dsr2 log_dsr1 if dalits==1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48))

* Non-dalits
lpoly log_dsr2 log_dsr1 if dalits==0, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48))


*** Wealth
* T1
lpoly log_dsr2 log_dsr1 if wealth_cat==1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48))

* T2
lpoly log_dsr2 log_dsr1 if wealth_cat==2, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48))

* T3
lpoly log_dsr2 log_dsr1 if wealth_cat==3, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48))


*** Income
* T1
lpoly log_dsr2 log_dsr1 if income_cat==1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48))

* T2
lpoly log_dsr2 log_dsr1 if income_cat==2, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48))

* T3
lpoly log_dsr2 log_dsr1 if income_cat==3, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48))


****************************************
* END













****************************************
* Parametric regression
****************************************
use"panel_HH_v1", clear


********** Selection
keep HHID_panel time log_dsr log_dir log_dar log_isr
bys HHID_panel: gen n=_N
keep if n==2
drop n
reshape wide log_dsr log_isr log_dar log_dir, i(HHID_panel) j(time)

********** Parametric results
reg log_dsr2 c.log_dsr1##c.log_dsr1##c.log_dsr1##c.log_dsr1, vce(cluster HHFE)

****************************************
* END

