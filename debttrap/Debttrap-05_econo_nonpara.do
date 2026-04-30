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
* Household level
****************************************
use"panel_HH_v2", clear


*** All
lpoly log_dsr2 log_dsr1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48))

lpoly log_isr2 log_isr1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48))

lpoly log_dar2 log_dar1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48))


****************************************
* END











****************************************
* Individual level
****************************************
use"panel_indiv_v2", clear


*** All
lpoly log_dsr2 log_dsr1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48))

lpoly log_isr2 log_isr1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(-2 8) xline(1.48))

lpoly log_loan2 log_loan1, kernel(epanechnikov) degree(4) ci noscatter ///
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

