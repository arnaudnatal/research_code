*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*February 16, 2026
*-----
gl link = "measuringinvisible"
*Anaysis
*-----
cd "C:\Users\Arnaud\Documents\MEGA\Research\Ongoing_Measuringinvisible\Analysis"
*cd"C:\Users\anatal\Documents\invisible\Analysis"
*-------------------------






****************************************
* Import + clean data
****************************************
* Import
import excel "_data.xlsx", sheet("Sheet1") firstrow clear
dropmiss, force

* Cat
tostring year, replace
egen data=concat(source year), p(" ")
destring year, replace

* Label
foreach x in source area rural level timeperiod {
encode `x', gen(n_`x')
drop `x'
rename n_`x' `x'
}
order data source year area rural level timeperiod samplesize indebted

* Amount
foreach x in mean_amount median_amount std_amount {
replace `x'=`x'/1000
label var `x' "1,000 rupees"
}


save"IndianHHdebt_v01.dta", replace






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
foreach x in amount_mean amount_sd amount_med inf_mean inf_sd inf_med {
replace `x'=`x'/1000
label var `x' "1,000 rupees"
}

save"Hyderabad_v01.dta", replace
****************************************
* END













****************************************
* Tamil Nadu: ODRIIS vs NSSO vs IHDS
****************************************
use"IndianHHdebt_v01.dta", clear
/*
Details with outstanding debt
*/
********** Selection
keep if level==1
keep if area==1
keep if timeperiod==1
drop l_bank l_moneylender l_mfi l_relatives l_employer l_shop l_pawn l_wkp r_house r_educ r_health r_farmbusi
drop mean_nbloan median_nbloan mean_loanamount median_loanamount



***** Graph 1: IOI
twoway ///
(connected indebted year if source==1, color(plr1)) ///
(connected indebted year if source==2, color(plb1)) ///
(connected indebted year if source==3, color(ply1)) ///
, ylabel(0(10)100) xlabel(2000(4)2020) ///
ytitle("Per cent") xtitle("") ///
legend(order(1 "IHDS" 2 "AIDIS" 3 "RUME-NEEMSIS") pos(6) col(3)) ///
title("Incidence of indebtedness") name(ioi, replace)
graph export "graph/TN_incidence.png", replace



***** Graph 2: AOD
* Mean
gen sqrtn=sqrt(samplesize*(indebted/100))
gen low=mean_amount-1.96*(std_amount/sqrtn)
gen high=mean_amount+1.96*(std_amount/sqrtn)

twoway ///
(connected mean_amount year if source==1, color(plr1)) ///
(rarea low high year if source==1, color(plr1%10)) ///
(connected mean_amount year if source==2, color(plb1)) ///
(rarea low high year if source==2, color(plb1%10)) ///
(connected mean_amount year if source==3, color(ply1)) ///
(rarea low high year if source==3, color(ply1%10)) ///
, ylabel(0(20)200) xlabel(2000(4)2020) ///
ytitle("1,000 rupees") xtitle("") ///
legend(order(1 "IHDS" 3 "AIDIS" 5 "RUME-NEEMSIS") pos(6) col(3)) ///
title("Mean") name(aodci, replace)

* Median
twoway ///
(connected median_amount year if source==1, color(plr1)) ///
(connected median_amount year if source==2, color(plb1)) ///
(connected median_amount year if source==3, color(ply1)) ///
, ylabel(0(20)200) xlabel(2000(4)2020) ///
ytitle("1,000 rupees") xtitle("") ///
legend(order(1 "IHDS" 2 "AIDIS" 3 "RUME-NEEMSIS") pos(6) col(3)) ///
title("Median") name(aodmed, replace)


* Combine
grc1leg aodci aodmed, col(2) title("Household outstanding debt")
graph export "graph/TN_outstanding.png", replace

****************************************
* END












****************************************
* Tamil Nadu: ODRIIS vs NSSO for indebted households
****************************************
use"IndianHHdebt_v01.dta", clear
/*
Details with outstanding debt: nb of loans
*/
********** Selection
keep if level==1
keep if area==1
keep if timeperiod==1
drop if source==1
drop l_bank l_moneylender l_mfi l_relatives l_employer l_shop l_pawn l_wkp r_house r_educ r_health r_farmbusi
drop mean_amount median_amount std_amount
drop mean_loanamount median_loanamount std_loanamount

********** Graph 3: Number of loan
* Mean
gen sqrtn=sqrt(samplesize*(indebted/100))
gen low=mean_nbloan-1.96*(std_nbloan/sqrtn)
gen high=mean_nbloan+1.96*(std_nbloan/sqrtn)

twoway ///
(connected mean_nbloan year if source==2, color(plb1)) ///
(rarea low high year if source==2, color(plb1%10)) ///
(connected mean_nbloan year if source==3, color(ply1)) ///
(rarea low high year if source==3, color(ply1%10)) ///
, ylabel(0(1)8) xlabel(2000(4)2020) ///
ytitle("Number of loans") xtitle("") ///
legend(order(1 "AIDIS" 3 "RUME-NEEMSIS") pos(6) col(2)) ///
title("Mean") name(nbmean, replace)

* Median
twoway ///
(connected median_nbloan year if source==2, color(plb1)) ///
(connected median_nbloan year if source==3, color(ply1)) ///
, ylabel(0(1)8) xlabel(2000(4)2020) ///
ytitle("Number of loans") xtitle("") ///
legend(order(1 "AIDIS" 2 "RUME-NEEMSIS") pos(6) col(2)) ///
title("Median") name(nbmed, replace)

* Combine
grc1leg nbmean nbmed, col(2) title("Number of loans per household")
graph export "graph/TN_nb.png", replace

****************************************
* END











****************************************
* Tamil Nadu: ODRIIS vs NSSO for indebted households
****************************************
use"IndianHHdebt_v01.dta", clear
/*
Details with outstanding debt: loan amount
*/
********** Selection
keep if level==1
keep if area==1
keep if timeperiod==2
drop l_bank l_moneylender l_mfi l_relatives l_employer l_shop l_pawn l_wkp r_house r_educ r_health r_farmbusi
drop mean_amount median_amount std_amount
drop indebted mean_nbloan median_nbloan std_nbloan


********** Graph 4: Number of loan
* Mean
gen sqrtn=sqrt(samplesize)
gen low=mean_loanamount-1.96*(std_loanamount/sqrtn)
gen high=mean_loanamount+1.96*(std_loanamount/sqrtn)

twoway ///
(connected mean_loanamount year if source==2, color(plb1)) ///
(rarea low high year if source==2, color(plb1%10)) ///
(connected mean_loanamount year if source==3, color(ply1)) ///
(rarea low high year if source==3, color(ply1%10)) ///
, ylabel(0(20)120) xlabel(2000(4)2020) ///
ytitle("1,000 rupees") xtitle("") ///
legend(order(1 "AIDIS" 3 "RUME-NEEMSIS") pos(6) col(2)) ///
title("Mean") name(loanmean, replace)

* Median
twoway ///
(connected median_loanamount year if source==2, color(plb1)) ///
(connected median_loanamount year if source==3, color(ply1)) ///
, ylabel(0(20)120) xlabel(2000(4)2020) ///
ytitle("1,000 rupees") xtitle("") ///
legend(order(1 "AIDIS" 2 "RUME-NEEMSIS") pos(6) col(2)) ///
title("Median") name(loanmed, replace)

* Combine
grc1leg loanmean loanmed, col(2) title("Loan amount")
graph export "graph/TN_loanamount.png", replace

****************************************
* END












****************************************
* Tamil Nadu: ODRIIS vs NSSO for indebted households
****************************************
use"IndianHHdebt_v01.dta", clear
/*
Details with outstanding debt: lenders
*/
********** Selection
keep if level==1
keep if area==1
keep if timeperiod==1
drop if source==1

********** Graph 5: Lenders
* Banks
twoway ///
(connected l_bank year if source==2, color(plb1)) ///
(connected l_bank year if source==3, color(ply1)) ///
, ylabel(0(20)100) xlabel(2000(5)2020) ///
ytitle("Per cent") xtitle("") ///
legend(order(1 "AIDIS" 2 "RUME-NEEMSIS") pos(6) col(2)) ///
title("Banks") name(bank, replace)
* Moneylender
twoway ///
(connected l_moneylender year if source==2, color(plb1)) ///
(connected l_moneylender year if source==3, color(ply1)) ///
, ylabel(0(20)100) xlabel(2000(5)2020) ///
ytitle("Per cent") xtitle("") ///
legend(order(1 "AIDIS" 2 "RUME-NEEMSIS") pos(6) col(2)) ///
title("Moneylenders") name(ml, replace)
* Relatives
twoway ///
(connected l_relatives year if source==2, color(plb1)) ///
(connected l_relatives year if source==3, color(ply1)) ///
, ylabel(0(20)100) xlabel(2000(5)2020) ///
ytitle("Per cent") xtitle("") ///
legend(order(1 "AIDIS" 2 "RUME-NEEMSIS") pos(6) col(2)) ///
title("Relatives") name(relatives, replace)
* Combine
grc1leg bank ml relatives, title("Incidence of indebtedness") col(3)
graph export "graph/TN_lenders.png", replace

****************************************
* END



















****************************************
* Tamil Nadu: ODRIIS vs NSSO for indebted households
****************************************
use"IndianHHdebt_v01.dta", clear
/*
Details with outstanding debt: loan reason given
*/
********** Selection
keep if level==1
keep if area==1
keep if timeperiod==1
drop if source==1


********** Graph 6: Loan reason given
* Housing
preserve
drop if year==2002
twoway ///
(connected r_house year if source==2, color(plb1)) ///
(connected r_house year if source==3, color(ply1)) ///
, ylabel(0(20)100) xlabel(2010(2)2020) ///
ytitle("Per cent") xtitle("") ///
legend(order(1 "AIDIS" 2 "RUME-NEEMSIS") pos(6) col(2)) ///
title("Housing") name(hou, replace)
restore
* Education
preserve
drop if year==2002
twoway ///
(connected r_educ year if source==2, color(plb1)) ///
(connected r_educ year if source==3, color(ply1)) ///
, ylabel(0(20)100) xlabel(2010(2)2020) ///
ytitle("Per cent") xtitle("") ///
legend(order(1 "AIDIS" 2 "RUME-NEEMSIS") pos(6) col(2)) ///
title("Education") name(edu, replace)
restore
* Health
preserve
drop if year==2002
twoway ///
(connected r_health year if source==2, color(plb1)) ///
(connected r_health year if source==3, color(ply1)) ///
, ylabel(0(20)100) xlabel(2010(2)2020) ///
ytitle("Per cent") xtitle("") ///
legend(order(1 "AIDIS" 2 "RUME-NEEMSIS") pos(6) col(2)) ///
title("Health") name(heal, replace)
restore
* Farm/business
twoway ///
(connected r_farmbusi year if source==2, color(plb1)) ///
(connected r_farmbusi year if source==3, color(ply1)) ///
, ylabel(0(20)100) xlabel(2000(5)2020) ///
ytitle("Per cent") xtitle("") ///
legend(order(1 "AIDIS" 2 "RUME-NEEMSIS") pos(6) col(2)) ///
title("Own business or farm") name(farm, replace)
* Combine
grc1leg hou edu heal farm, title("Incidence of indebtedness") col(2)
graph export "graph/TN_reasons.png", replace

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


***** Graph 3: IOI inf
preserve
drop if source==2
recode source (3=2)
label define source_code 1"AIDIS 2002" 2"BDGK 2005", modify
twoway ///
(bar ioi_inf source, barw(.6)) ///
, xlabel(1 "AIDIS 2002" 2 "BDGK 2005") xtitle("") ///
ylabel(0(10)100) ytitle("Per cent") ///
title("Incidence of informal indebtedness") legend(off) name(ioi, replace)
graph export "graph/Hy_incidenceinformal.png", as(png) replace
restore

****************************************
* END





