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
* Household level : cumulative level
****************************************
use"panel_HH_v3", clear

* Selection
fre timeperiod
keep if timeperiod==2
keep if dummyloans_HH1==1
keep if dummyloans_HH2==1

/*
W1 415
W2 300
W3 245
W4 200
W5 178
W6 152
W7 137
*/

forvalues i=1/2 {
*
gen w1dsr`i'=dsr`i'
replace w1dsr`i'=415 if w1dsr`i'>415
*
gen w2dsr`i'=dsr`i'
replace w2dsr`i'=300 if w2dsr`i'>300
*
gen w3dsr`i'=dsr`i'
replace w3dsr`i'=245 if w3dsr`i'>245
*
gen w4dsr`i'=dsr`i'
replace w4dsr`i'=200 if w4dsr`i'>200
*
gen w5dsr`i'=dsr`i'
replace w5dsr`i'=178 if w5dsr`i'>178
*
gen w6dsr`i'=dsr`i'
replace w6dsr`i'=152 if w6dsr`i'>152
*
gen w7dsr`i'=dsr`i'
replace w7dsr`i'=137 if w7dsr`i'>137
}

* Cumulative
cumul dsr1, gen(c_dsr1)
cumul dsr2, gen(c_dsr2)
forvalues i=1/7 {
cumul w`i'dsr1, gen(c_w`i'dsr1)
cumul w`i'dsr2, gen(c_w`i'dsr2)
}

* No wins
twoway ///
(line c_dsr1 dsr1, sort xline(30)) ///
(line c_dsr2 dsr2, sort) ///
, xtitle("Debt service ratio (%)") ytitle("Cum. % of pop.") title("No winsorizing") ylabel(0(.1)1) ///
legend(order(1 "2016-2017" 2 "2020-2021") pos(6) col(4)) name(nw, replace) scale(1.1)

* Winsorizing
forvalues i=1/7 {
twoway ///
(line c_w`i'dsr1 w`i'dsr1, sort xline(30)) ///
(line c_w`i'dsr2 w`i'dsr2, sort) ///
, xtitle("Debt service ratio (%)") ytitle("Cum. % of pop.") title("`i'% winsorizing") ylabel(0(.1)1) ///
legend(order(1 "2016-2017" 2 "2020-2021") pos(6) col(4)) name(w`i', replace) scale(1.1)
}

grc1leg nw w1 w2 w3 w4 w5 w6 w7, col(4)
graph export "graph/cum_dsr_hh.png", replace

****************************************
* END










****************************************
* Individual level : cumulative level
****************************************
use"panel_indiv_v3", clear

* Selection
fre timeperiod
keep if timeperiod==1
keep if dummyloans1==1
keep if dummyloans2==1

/*
W1 1540
W2 1060
W3 800
W4 615
W5 485
W6 412
W7 366
*/

forvalues i=1/2 {
*
gen w1dsr`i'=dsr`i'
replace w1dsr`i'=1540 if w1dsr`i'>1540
*
gen w2dsr`i'=dsr`i'
replace w2dsr`i'=1060 if w2dsr`i'>1060
*
gen w3dsr`i'=dsr`i'
replace w3dsr`i'=800 if w3dsr`i'>800
*
gen w4dsr`i'=dsr`i'
replace w4dsr`i'=615 if w4dsr`i'>615
*
gen w5dsr`i'=dsr`i'
replace w5dsr`i'=485 if w5dsr`i'>485
*
gen w6dsr`i'=dsr`i'
replace w6dsr`i'=412 if w6dsr`i'>412
*
gen w7dsr`i'=dsr`i'
replace w7dsr`i'=366 if w7dsr`i'>366
}

* Cumulative
cumul dsr1, gen(c_dsr1)
cumul dsr2, gen(c_dsr2)
forvalues i=1/7 {
cumul w`i'dsr1, gen(c_w`i'dsr1)
cumul w`i'dsr2, gen(c_w`i'dsr2)
}

* No wins
twoway ///
(line c_dsr1 dsr1, sort xline(30)) ///
(line c_dsr2 dsr2, sort) ///
, xtitle("Debt service ratio (%)") ytitle("Cum. % of pop.") title("No winsorizing") ylabel(0(.1)1) ///
legend(order(1 "2016-2017" 2 "2020-2021") pos(6) col(4)) name(nw, replace) scale(1.1)

* Winsorizing
forvalues i=1/7 {
twoway ///
(line c_w`i'dsr1 w`i'dsr1, sort xline(30)) ///
(line c_w`i'dsr2 w`i'dsr2, sort) ///
, xtitle("Debt service ratio (%)") ytitle("Cum. % of pop.") title("`i'% winsorizing") ylabel(0(.1)1) ///
legend(order(1 "2016-2017" 2 "2020-2021") pos(6) col(4)) name(w`i', replace) scale(1.1)
}

grc1leg nw w1 w2 w3 w4 w5 w6 w7, col(4)
graph export "graph/cum_dsr_indiv.png", replace

****************************************
* END














****************************************
* Transition
****************************************

********** Household level
use"panel_HH_v2", clear

keep HHID_panel year dummyloans_HH
rename dummyloans_HH debt
reshape wide debt, i(HHID_panel) j(year)
*
ta debt2016 debt2020, row cell

********** Individual level
use"panel_indiv_v2", clear

keep HHID_panel INDID_panel year dummyloans
rename dummyloans debt
drop if year==2025
reshape wide debt, i(HHID_panel INDID_panel) j(year)
*
ta debt2016 debt2020, row cell


****************************************
* END









****************************************
* Mobilities
****************************************

********** Household
use"panel_HH_v2", clear
drop if year==2010
drop if year==2025
bys HHID_panel: gen n=_N
keep if n==2
drop n
keep HHID_panel year dummyloans_HH dsr
reshape wide dummyloans_HH dsr, i(HHID_panel) j(year)
keep if dummyloans_HH2016==1 & dummyloans_HH2020==1
drop dummyloans_HH2016 dummyloans_HH2020
*
xtile dsr2016_q=dsr2016, n(5)
xtile dsr2020_q=dsr2020, n(5)
*
ta dsr2016_q dsr2020_q, row 

********** Individual
use"panel_indiv_v2", clear
drop if year==2025
bys HHID_panel INDID_panel: gen n=_N
keep if n==2
drop n
keep HHID_panel INDID_panel year dummyloans dsr
reshape wide dummyloans dsr, i(HHID_panel INDID_panel) j(year)
keep if dummyloans2016==1 & dummyloans2020==1
drop dummyloans2016 dummyloans2020
*
xtile dsr2016_q=dsr2016, n(5)
xtile dsr2020_q=dsr2020, n(5)
*
ta dsr2016_q dsr2020_q, row 


****************************************
* END
