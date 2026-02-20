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
replace amount=amount/1000
label var amount "Outstanding (1,000 rupees)"

save"IndianHHdebt_v01.dta", replace
****************************************
* END












****************************************
* All Indian households
****************************************
use"IndianHHdebt_v01.dta", clear

*** Selection
fre level
keep if level==1
fre area
keep if area==1
fre rural
keep if rural==1
fre timeperiod
keep if timeperiod==1
drop if source==3 & year>2013

*** Graphs
* All lenders
graph bar indebted, over(data) ylabel(0(20)100) title("All lenders") ytitle("Percent") name(global, replace)
*
graph bar indebted, over(data) ylabel(0(20)100) title("Households in debt over the last 5 years in India") ytitle("Percent") name(g1, replace)
graph export "graph/Global_india_5.png", replace



* Bank
graph bar l_bank, over(data) ylabel(0(20)100) title("Banks") ytitle("Percent") name(bank, replace)

* Moneylenders
graph bar l_moneylender, over(data) ylabel(0(20)100) title("Moneylenders") ytitle("Percent") name(ml, replace)

* Relatives
graph bar l_relatives, over(data) ylabel(0(20)100) title("Relatives") ytitle("Percent") name(relatives, replace)

* Combine
graph combine global bank ml relatives, title("Households in debt over the last 5 years in India")
graph export "graph/Global_india_5.pdf", replace
graph export "graph/Global_india_5.png", replace


****************************************
* END










****************************************
* All Indian indiv from Findex
****************************************
use"IndianHHdebt_v01.dta", clear

*** Selection
keep if source==1
keep if rural==1

*** Graphs
twoway ///
(connected indebted year, color(plb1)) ///
(connected l_bank year, color(ply1)) ///
(connected l_relatives year, color(plr1)) ///
, ylabel(0(20)100) xlabel(2011(1)2024) ///
ytitle("Percent") xtitle("") ///
legend(order(1 "All lenders" 2 "Bank" 3 "Relatives") pos(6) col(3)) ///
title("Individuals in debt over the last year in India (Findex data)") name(global, replace)
graph export "graph/Global_findex_india_1.pdf", replace
graph export "graph/Global_findex_india_1.png", replace


****************************************
* END









****************************************
* Rural Tamil indiv from ODRIIS
****************************************
use"IndianHHdebt_v01.dta", clear

*** Selection
keep if source==4
keep if level==2
keep if timeperiod==2

*** Graphs
twoway ///
(connected indebted year, color(plb1)) ///
(connected l_bank year, color(ply1)) ///
(connected l_relatives year, color(plr1)) ///
, ylabel(0(20)100) xlabel(2016(1)2020) ///
ytitle("Percent") xtitle("") ///
legend(order(1 "All lenders" 2 "Bank" 3 "Relatives") pos(6) col(3)) ///
title("Individuals in debt over the last year in rural Tamil Nadu (ODRIIS data)") name(global, replace)
graph export "graph/Rural_odriis_tamil_1.pdf", replace
graph export "graph/Rural_odriis_tamil_1.png", replace


****************************************
* END













****************************************
* All Indian households from rural area
****************************************
use"IndianHHdebt_v01.dta", clear

*** Selection
fre level
keep if level==1
fre area
keep if area==1
fre rural
keep if rural==2
fre timeperiod
keep if timeperiod==1
drop if source==3 & year>2013


*** Graphs
* All lenders
graph bar indebted, over(data) ylabel(0(20)100) title("All lenders") ytitle("Percent") name(global, replace)

* Bank
graph bar l_bank, over(data) ylabel(0(20)100) title("Banks") ytitle("Percent") name(bank, replace)

* Moneylenders
graph bar l_moneylender, over(data) ylabel(0(20)100) title("Moneylenders") ytitle("Percent") name(ml, replace)

* Relatives
graph bar l_relatives, over(data) ylabel(0(20)100) title("Relatives") ytitle("Percent") name(relatives, replace)

* Combine
graph combine global bank ml relatives, title("Rural households in debt over the last 5 years in India")
graph export "graph/Rural_india_5.pdf", replace
graph export "graph/Rural_india_5.png", replace

****************************************
* END











****************************************
* TN households from rural area five years
****************************************
use"IndianHHdebt_v01.dta", clear

*** Selection
fre level
keep if level==1
fre area
keep if area==2
fre timeperiod
keep if timeperiod==1
drop if source==4 & year>2010
drop if source==3 & year>2013


*** Graphs
* All lenders
graph bar indebted, over(data) ylabel(0(20)100) title("All lenders") ytitle("Percent") name(global, replace)

* Bank
graph bar l_bank, over(data) ylabel(0(20)100) title("Banks") ytitle("Percent") name(bank, replace)

* Moneylenders
graph bar l_moneylender, over(data) ylabel(0(20)100) title("Moneylenders") ytitle("Percent") name(ml, replace)

* Relatives
graph bar l_relatives, over(data) ylabel(0(20)100) title("Relatives") ytitle("Percent") name(relatives, replace)

* Combine
graph combine global bank ml relatives, title("Rural households in debt over the last 5 years in Tamil Nadu")
graph export "graph/Rural_tamil_5.pdf", replace
graph export "graph/Rural_tamil_5.png", replace

****************************************
* END


















****************************************
* TN households from rural area outstanding
****************************************
use"IndianHHdebt_v01.dta", clear

*** Selection
fre level
keep if level==1
fre area
keep if area==2
fre timeperiod
keep if timeperiod==3


*** Graphs
* All lenders
twoway ///
(connected indebted year if source==3, color(plb1)) ///
(connected indebted year if source==4, color(ply1)) ///
, ylabel(0(20)100) xlabel(2010(2)2020) ///
ytitle("Percent") xtitle("") ///
legend(order(1 "NSSO" 2 "ODRIIS") pos(6) col(2)) ///
title("All lenders") name(global, replace)

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

* Amount
twoway ///
(connected amount year if source==3, color(plb1)) ///
(connected amount year if source==4, color(ply1)) ///
, ylabel(50(20)190) xlabel(2010(2)2020) ///
ytitle("1,000 rupees") xtitle("") ///
legend(order(1 "NSSO" 2 "ODRIIS") pos(6) col(2)) ///
title("Outstanding debt for rural Tamil households") name(amount, replace)
graph export "graph/Rural_tamil_amount.pdf", replace
graph export "graph/Rural_tamil_amount.png", replace


* Combine
grc1leg global bank ml relatives, title("Rural Tamil households in debt at the time of the survey")
graph export "graph/Rural_tamil_out.pdf", replace
graph export "graph/Rural_tamil_out.png", replace

****************************************
* END
