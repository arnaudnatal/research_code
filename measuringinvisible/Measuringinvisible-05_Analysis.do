*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*February 16, 2026
*-----
gl link = "measuringinvisible"
*NSSO 2019
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
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
foreach x in mean_amount median_amount mean_loanamount median_loanamount {
replace `x'=`x'/1000
label var `x' "1,000 rupees"
}


save"IndianHHdebt_v01.dta", replace
****************************************
* END












****************************************
* All India
****************************************
/*
Main characteristics aligned with IHDS
*/
********** HOUSEHOLD LEVEL: NSSO vs IHDS
use"IndianHHdebt_v01.dta", clear
*
keep if level==1
keep if area==1
keep if rural==1
keep if timeperiod==1
drop if source==3 & year>2013
* 
twoway ///
(connected indebted year if source==2, color(plb1)) ///
(connected indebted year if source==3, color(ply1)) ///
, ylabel(0(20)100) xlabel(2003(2)2013) ///
ytitle("Percent") xtitle("") ///
legend(order(1 "IHDS" 2 "NSSO") pos(6) col(3)) ///
title("Households in debt over the last 5 years in India") name(india1, replace)
graph export "graph/India_nsso_ihds.png", replace


********** INDIVIDUAL LEVEL: Findex
use"IndianHHdebt_v01.dta", clear
*
keep if source==1
keep if rural==1
*
twoway ///
(connected indebted year, color(plr1)) ///
, ylabel(0(20)100) xlabel(2011(2)2024) ///
ytitle("Percent") xtitle("") ///
legend(order(1 "Findex") pos(6) col(1) on) ///
title("Individuals in debt over the last year in India") name(findex, replace)
graph export "graph/India_findex.png", replace


********** Combine
graph combine india1 findex
graph export "graph/India_nsso_ihds_findex.png", replace

****************************************
* END











****************************************
* Tamil Nadu: ODRIIS vs NSSO vs IHDS around 2010
****************************************
use"IndianHHdebt_v01.dta", clear
/*
Main characteristics aligned with IHDS
*/
*** Selection
keep if level==1
keep if area==2
keep if timeperiod==1
drop if year<2010
drop if year>2013


*** Graphs
* All lenders
graph bar indebted, over(data) ylabel(0(20)100) title("Rural Tamil households in debt over the last 5 years") ytitle("Percent") name(global, replace)
graph export "graph/TamilNadu_nsso_ihds_odriis.png", replace

****************************************
* END


















****************************************
* Tamil Nadu: ODRIIS vs NSSO
****************************************
use"IndianHHdebt_v01.dta", clear
/*
Details with outstanding debt
*/
********** Selection
keep if level==1
keep if area==2
keep if timeperiod==3
drop if year==2003
drop l_mfi l_employer l_shop l_pawn l_wkp

********** Graph 1: IOI and AOD
* IOI
twoway ///
(connected indebted year if source==3, color(plb1)) ///
(connected indebted year if source==4, color(ply1)) ///
, ylabel(0(10)100) xlabel(2010(2)2020) ///
ytitle("Percent") xtitle("") ///
legend(order(1 "NSSO" 2 "ODRIIS") pos(6) col(2)) ///
title("Households with outstanding debt") name(ioi, replace)
* AOD
twoway ///
(connected mean_amount year if source==3, color(plb1)) ///
(connected mean_amount year if source==4, color(ply1)) ///
, ylabel(40(20)200) xlabel(2010(2)2020) ///
ytitle("1,000 rupees") xtitle("") ///
legend(order(1 "NSSO" 2 "ODRIIS") pos(6) col(2)) ///
title("Average amount of debt for indebted rural Tamil households") name(aod, replace)
* AOD
twoway ///
(connected median_amount year if source==3, color(plb1)) ///
(connected median_amount year if source==4, color(ply1)) ///
, ylabel(20(20)120) xlabel(2010(2)2020) ///
ytitle("1,000 rupees") xtitle("") ///
legend(order(1 "NSSO" 2 "ODRIIS") pos(6) col(2)) ///
title("Median amount of debt for indebted rural Tamil households") name(mod, replace)
* Combine
grc1leg ioi aod
graph export "graph/TamilNadu_nsso_odriis_ioi_aod.png", replace
grc1leg ioi mod
graph export "graph/TamilNadu_nsso_odriis_ioi_mod.png", replace


********** Graph 2: Number of loan and amount
* Nb
twoway ///
(connected mean_nbloan year if source==3, color(plb1)) ///
(connected mean_nbloan year if source==4, color(ply1)) ///
, ylabel(0(1)10) xlabel(2010(2)2020) ///
ytitle("Number of loans") xtitle("") ///
legend(order(1 "NSSO" 2 "ODRIIS") pos(6) col(2)) ///
title("Average number of loans per indebted rural Tamil household") name(nb, replace)
* Average loan amount
twoway ///
(connected mean_loanamount year if source==3, color(plb1)) ///
(connected mean_loanamount year if source==4, color(ply1)) ///
, ylabel(0(10)100) xlabel(2010(2)2020) ///
ytitle("1,000 rupees") xtitle("") ///
legend(order(1 "NSSO" 2 "ODRIIS") pos(6) col(2)) ///
title("Average loan amount in rural Tamil household") name(avloan, replace)
* Median loan amount
twoway ///
(connected median_loanamount year if source==3, color(plb1)) ///
(connected median_loanamount year if source==4, color(ply1)) ///
, ylabel(0(10)100) xlabel(2010(2)2020) ///
ytitle("1,000 rupees") xtitle("") ///
legend(order(1 "NSSO" 2 "ODRIIS") pos(6) col(2)) ///
title("Median loan amount in rural Tamil household") name(medloan, replace)
grc1leg nb avloan
graph export "graph/TamilNadu_nsso_odriis_nb_avloanamount.png", replace
grc1leg nb medloan
graph export "graph/TamilNadu_nsso_odriis_nb_medloanamount.png", replace


********** Graph 3: Lenders
* Banks
twoway ///
(connected l_bank year if source==3, color(plb1)) ///
(connected l_bank year if source==4, color(ply1)) ///
, ylabel(0(20)100) xlabel(2010(2)2020) ///
ytitle("Percent") xtitle("") ///
legend(order(1 "NSSO" 2 "ODRIIS") pos(6) col(2)) ///
title("Banks") name(bank, replace)
* Moneylender
twoway ///
(connected l_moneylender year if source==3, color(plb1)) ///
(connected l_moneylender year if source==4, color(ply1)) ///
, ylabel(0(20)100) xlabel(2010(2)2020) ///
ytitle("Percent") xtitle("") ///
legend(order(1 "NSSO" 2 "ODRIIS") pos(6) col(2)) ///
title("Moneylenders") name(ml, replace)
* Relatives
twoway ///
(connected l_relatives year if source==3, color(plb1)) ///
(connected l_relatives year if source==4, color(ply1)) ///
, ylabel(0(20)100) xlabel(2010(2)2020) ///
ytitle("Percent") xtitle("") ///
legend(order(1 "NSSO" 2 "ODRIIS") pos(6) col(2)) ///
title("Relatives") name(relatives, replace)
* Combine
grc1leg bank ml relatives, title("Rural Tamil households with outstanding debt from ...") col(3)
graph export "graph/TamilNadu_nsso_odriis_lenders.png", replace


********** Graph 4: Loan reason given
* Housing
twoway ///
(connected r_house year if source==3, color(plb1)) ///
(connected r_house year if source==4, color(ply1)) ///
, ylabel(0(20)100) xlabel(2010(2)2020) ///
ytitle("Percent") xtitle("") ///
legend(order(1 "NSSO" 2 "ODRIIS") pos(6) col(2)) ///
title("Housing") name(hou, replace)
* Education
twoway ///
(connected r_educ year if source==3, color(plb1)) ///
(connected r_educ year if source==4, color(ply1)) ///
, ylabel(0(20)100) xlabel(2010(2)2020) ///
ytitle("Percent") xtitle("") ///
legend(order(1 "NSSO" 2 "ODRIIS") pos(6) col(2)) ///
title("Education") name(edu, replace)
* Health
twoway ///
(connected r_health year if source==3, color(plb1)) ///
(connected r_health year if source==4, color(ply1)) ///
, ylabel(0(20)100) xlabel(2010(2)2020) ///
ytitle("Percent") xtitle("") ///
legend(order(1 "NSSO" 2 "ODRIIS") pos(6) col(2)) ///
title("Health") name(heal, replace)
* Farm/business
twoway ///
(connected r_farmbusi year if source==3, color(plb1)) ///
(connected r_farmbusi year if source==4, color(ply1)) ///
, ylabel(0(20)100) xlabel(2010(2)2020) ///
ytitle("Percent") xtitle("") ///
legend(order(1 "NSSO" 2 "ODRIIS") pos(6) col(2)) ///
title("Own business or farm") name(farm, replace)
* Combine
grc1leg hou edu heal farm, title("Rural Tamil households with outstanding debt for ...") col(2)
graph export "graph/TamilNadu_nsso_odriis_reasons.png", replace

****************************************
* END
