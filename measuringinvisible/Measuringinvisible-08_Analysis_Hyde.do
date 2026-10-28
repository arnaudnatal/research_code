*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*February 16, 2026
*-----
gl link = "measuringinvisible"
*Anaysis
*-----
*cd "C:\Users\Arnaud\Documents\MEGA\Research\Ongoing_Measuringinvisible\Analysis"
cd"C:\Users\anatal\Documents\invisible\Analysis"
*-------------------------






****************************************
* Import + clean data
****************************************

***** Banerjee et al. 
* Import
import excel "_data.xlsx", sheet("Sheet2") firstrow clear
dropmiss, force
drop if year==.

* Source
encode source, gen(source_code)
drop source
rename source_code source
order source, first

* Amount
foreach x in amount_mean amount_sd amount_med {
replace `x'=`x'/1000
label var `x' "1,000 rupees"
}

save"Hyderabad_v01.dta", replace
****************************************
* END

















****************************************
* Hyderabad
****************************************
use"Hyderabad_v01.dta", clear

fre source
ta source year
recode source (3=2) (2=3)
codebook source
label define source_code 1"AIDIS 2002" 2"IHDS 2004" 3"BDGK 2005", modify

***** Graph 1: IOI
twoway ///
(bar ioi source, barw(.6)) ///
, xlabel(1 "AIDIS 2002" 2 "IHDS 2004" 3 "BDGK 2005") xtitle("") ///
ylabel(0(10)100) ytitle("Per cent") ///
title("Incidence of indebtedness") legend(off) name(ioi, replace)
graph export "graph/Hy_incidence.png", as(png) replace

***** Graph 2: Amount
* Mean
gen sqrtn=sqrt(nbHH*(ioi/100))
gen low=amount_mean-1.96*(amount_sd/sqrtn)
gen high=amount_mean+1.96*(amount_sd/sqrtn)

twoway ///
(bar amount_mean source, barw(.6)) ///
(rcap low high source) ///
, xlabel(1 "AIDIS 2002" 2 "IHDS 2004" 3 "BDGK 2005") xtitle("") ///
ylabel(0(20)140) ytitle("1,000 rupees") ///
title("Mean") legend(off) name(mean, replace)

* Median
twoway ///
(bar amount_med source, barw(.6)) ///
, xlabel(1 "AIDIS 2002" 2 "IHDS 2004" 3 "BDGK 2005") xtitle("") ///
ylabel(0(20)140) ytitle("1,000 rupees") ///
title("Median") legend(off) name(med, replace)

*
graph combine mean med, col(2) title("Household outstanding debt")
graph export "graph/Hy_outstanding.png", as(png) replace

****************************************
* END





