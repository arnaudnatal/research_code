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


* Cumulative no wins
cumul dsr1, gen(c_dsr1)
cumul dsr2, gen(c_dsr2)
twoway ///
(line c_dsr1 dsr1, sort xline(40)) ///
(line c_dsr2 dsr2, sort) ///
, xtitle("Debt service ratio (%)") ytitle("Cum. % of pop.") title("No winsorizing") ylabel(0(.1)1) ///
legend(order(1 "2016-2017" 2 "2020-2021") pos(6) col(2)) name(nw, replace) scale(1.1)

* Cumulative 1%
cumul w1_dsr1, gen(c_w1_dsr1)
cumul w1_dsr2, gen(c_w1_dsr2)
twoway ///
(line c_w1_dsr1 w1_dsr1, sort xline(40)) ///
(line c_w1_dsr2 w1_dsr2, sort) ///
, xtitle("Debt service ratio (%)") ytitle("Cum. % of pop.") title("1% winsorizing") ylabel(0(.1)1) ///
legend(order(1 "2016-2017" 2 "2020-2021") pos(6) col(2)) name(w1, replace) scale(1.1)

* Cumulative 2.5%
cumul w2_dsr1, gen(c_w2_dsr1)
cumul w2_dsr2, gen(c_w2_dsr2)
twoway ///
(line c_w2_dsr1 w2_dsr1, sort xline(40)) ///
(line c_w2_dsr2 w2_dsr2, sort) ///
, xtitle("Debt service ratio (%)") ytitle("Cum. % of pop.") title("2.5% winsorizing") ylabel(0(.1)1) ///
legend(order(1 "2016-2017" 2 "2020-2021") pos(6) col(2)) name(w2, replace) scale(1.1)

* Cumulative 5%
cumul w5_dsr1, gen(c_w5_dsr1)
cumul w5_dsr2, gen(c_w5_dsr2)
twoway ///
(line c_w5_dsr1 w5_dsr1, sort xline(40)) ///
(line c_w5_dsr2 w5_dsr2, sort) ///
, xtitle("Debt service ratio (%)") ytitle("Cum. % of pop.") title("5% winsorizing") ylabel(0(.1)1) ///
legend(order(1 "2016-2017" 2 "2020-2021") pos(6) col(2)) name(w5, replace) scale(1.1)

* All
grc1leg nw w1 w2 w5, col(2)
graph export "graph/cum_dsr.png", replace

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


* Cumulative no wins
cumul dsr1, gen(c_dsr1)
cumul dsr2, gen(c_dsr2)
twoway ///
(line c_dsr1 dsr1, sort xline(40)) ///
(line c_dsr2 dsr2, sort) ///
, xtitle("Debt service ratio (%)") ytitle("Cum. % of pop.") title("No winsorizing") ylabel(0(.1)1) ///
legend(order(1 "2016-2017" 2 "2020-2021") pos(6) col(2)) name(nw, replace) scale(1.1)

* Cumulative 1%
cumul w1_dsr1, gen(c_w1_dsr1)
cumul w1_dsr2, gen(c_w1_dsr2)
twoway ///
(line c_w1_dsr1 w1_dsr1, sort xline(40)) ///
(line c_w1_dsr2 w1_dsr2, sort) ///
, xtitle("Debt service ratio (%)") ytitle("Cum. % of pop.") title("1% winsorizing") ylabel(0(.1)1) ///
legend(order(1 "2016-2017" 2 "2020-2021") pos(6) col(2)) name(w1, replace) scale(1.1)

* Cumulative 2.5%
cumul w2_dsr1, gen(c_w2_dsr1)
cumul w2_dsr2, gen(c_w2_dsr2)
twoway ///
(line c_w2_dsr1 w2_dsr1, sort xline(40)) ///
(line c_w2_dsr2 w2_dsr2, sort) ///
, xtitle("Debt service ratio (%)") ytitle("Cum. % of pop.") title("2.5% winsorizing") ylabel(0(.1)1) ///
legend(order(1 "2016-2017" 2 "2020-2021") pos(6) col(2)) name(w2, replace) scale(1.1)

* Cumulative 5%
cumul w5_dsr1, gen(c_w5_dsr1)
cumul w5_dsr2, gen(c_w5_dsr2)
twoway ///
(line c_w5_dsr1 w5_dsr1, sort xline(40)) ///
(line c_w5_dsr2 w5_dsr2, sort) ///
, xtitle("Debt service ratio (%)") ytitle("Cum. % of pop.") title("5% winsorizing") ylabel(0(.1)1) ///
legend(order(1 "2016-2017" 2 "2020-2021") pos(6) col(2)) name(w5, replace) scale(1.1)

* All
grc1leg nw w1 w2 w5, col(2)
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
ta debt2016 debt2020, row

********** Individual level
use"panel_indiv_v2", clear

keep HHID_panel INDID_panel year dummyloans
rename dummyloans debt
drop if year==2025
reshape wide debt, i(HHID_panel INDID_panel) j(year)
*
ta debt2016 debt2020, row


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
ta dsr2016_q dsr2020_q, row nofreq


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
ta dsr2016_q dsr2020_q, row nofreq


****************************************
* END
