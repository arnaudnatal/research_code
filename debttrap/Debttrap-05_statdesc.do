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
* Decomposition evolution DSR
****************************************
********** HH
use"panel_HH_v0", clear

* Construction
gen dummyloans_HH=0
replace dummyloans_HH=1 if nbloans_HH!=. & nbloans_HH>0
rename imp1_ds_tot_HH debtserv
gen income_HH=annualincome_HH+remreceived_HH
gen dsr=(debtserv*100)/income_HH
replace dsr=0 if dsr==.
replace dsr=. if dummyloans_HH==0

* Selection
keep HHID_panel year dsr debtserv income_HH
drop if year==2010
drop if year==2025
reshape wide debtserv income_HH dsr, i(HHID_panel) j(year)
keep if dsr2016!=.
keep if dsr2020!=.

* Categories
foreach x in debtserv income_HH dsr {
gen cat_`x'=.
label define cat_`x' 1"Baisse" 2"Hausse" 3"Stagnation"
label values cat_`x' cat_`x'
replace cat_`x'=1 if `x'2016>`x'2020
replace cat_`x'=2 if `x'2016<`x'2020
replace cat_`x'=3 if `x'2016==`x'2020
}

* Stat
preserve
keep if cat_dsr==1
ta cat_debtserv cat_income, cell nofreq
restore
preserve
keep if cat_dsr==2
ta cat_debtserv cat_income, cell nofreq
restore


********** Indiv
use"panel_indiv_v0", clear

* Construction
gen dummyloans=0
replace dummyloans=1 if nbloans_indiv!=. & nbloans_indiv>0
rename imp1_ds_tot_indiv debtserv
gen income_indiv=annualincome_indiv+remreceived_indiv
gen dsr=(debtserv*100)/income_indiv
replace dsr=0 if dsr==.
replace dsr=. if dummyloans==0

* Selection
keep HHID_panel INDID_panel year dsr debtserv income_indiv
drop if year==2010
drop if year==2025
reshape wide dsr debtserv income_indiv, i(HHID_panel INDID_panel) j(year)
keep if dsr2016!=.
keep if dsr2020!=.

* Categories
foreach x in debtserv income_indiv dsr {
gen cat_`x'=.
label define cat_`x' 1"Baisse" 2"Hausse" 3"Stagnation"
label values cat_`x' cat_`x'
replace cat_`x'=1 if `x'2016>`x'2020
replace cat_`x'=2 if `x'2016<`x'2020
replace cat_`x'=3 if `x'2016==`x'2020
}

* Stat
preserve
keep if cat_dsr==1
ta cat_debtserv cat_income, cell nofreq
restore
preserve
keep if cat_dsr==2
ta cat_debtserv cat_income, cell nofreq
restore

****************************************
* END

















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

grc1leg nw w1 w2 w3 w4 w5, col(3)
graph export "graph/cum_dsr_hh.png", replace

****************************************
* END










****************************************
* Attrition
****************************************

********** Household level
use"panel_HH_v2", clear

keep HHID_panel year dsr income_HH assets_total1000
ta year
replace income_HH=income_HH/1000
drop if year==2010
drop if year==2025
bys HHID_panel: gen n=_N
keep if year==2016
ta n
*
tabstat dsr income_HH assets_total1000, stat(n mean) by(n)
reg dsr i.n
reg income_HH i.n
reg assets_total1000 i.n


********** Individual level
use"panel_indiv_v2", clear

keep HHID_panel INDID_panel year dsr income_indiv
ta year
replace income_indiv=income_indiv/1000
drop if year==2025
bys HHID_panel INDID_panel: gen n=_N
keep if year==2016
ta n
*
tabstat dsr income_indiv, stat(n mean) by(n)
reg dsr i.n
reg income_indiv i.n


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

grc1leg nw w1 w2 w3 w4 w5, col(3)
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













****************************************
* Stat desc HH
****************************************

********** p1
use"panel_HH_v2", clear

* Selection
fre timeperiod
drop if timeperiod==.
keep if dummyloans_HH1==1
keep if dummyloans_HH2==1
drop if year==2020
drop if year==2010

* Quali
ta head_mocc_occupation ownland, col nofreq chi2
ta head_edulevel ownland, col nofreq chi2

* Quanti
foreach x in assets_nolandnogold income_HH saving {
replace `x'=`x'/1000
}
tabstat assets_nolandnogold income_HH saving, stat(mean) by(ownland)
reg assets_nolandnogold i.ownland
reg income_HH i.ownland
reg saving i.ownland



********** p2
use"panel_HH_v3", clear

* Selection
fre timeperiod
drop if timeperiod==.
keep if dummyloans_HH1==1
keep if dummyloans_HH2==1
drop if year==2020
drop if year==2010

* Quali
ta head_female ownland, col nofreq chi2
ta head_nonmarried ownland, col nofreq chi2
ta dalits ownland, col nofreq chi2
ta dummydemonetisation ownland, col nofreq chi2

* Quanti
tabstat ///
diff_w5_dsr w5_dsr1 ///
head_age ///
HHsize HH_count_child worker sexratio ///
goldquantity_HH ///
, stat(mean) by(ownland)

reg diff_w5_dsr i.ownland
reg w5_dsr1 i.ownland
reg head_age i.ownland
reg HHsize i.ownland
reg HH_count_child i.ownland
reg worker i.ownland
reg sexratio i.ownland
reg goldquantity_HH i.ownland


****************************************
* END








****************************************
* Stat desc indiv
****************************************

********* p1
use"panel_indiv_v2", clear

* Selection
fre timeperiod
drop if timeperiod==.
keep if dummyloans1==1
keep if dummyloans2==1
drop if year==2020
drop if year==2010

ta ownland

* Quali
recode occupation (.=0)
ta occupation ownland, col chi2 nofreq
ta edulevel ownland, col chi2 nofreq

* Quanti
replace saving=saving/1000
tabstat saving, stat(mean) by(ownland)
reg saving i.ownland



********* p2
use"panel_indiv_v3", clear

* Selection
fre timeperiod
drop if timeperiod==.
keep if dummyloans1==1
keep if dummyloans2==1
drop if year==2020
drop if year==2010

* Quali
ta female ownland, chi2 col nofreq
ta nonmarried ownland, chi2 col nofreq

* Quanti
tabstat diff_w5_dsr w5_dsr1 ///
age goldquantity, stat(mean) by(ownland)

reg diff_w5_dsr i.ownland
reg w5_dsr1 i.ownland
reg age i.ownland
reg goldquantity i.ownland

****************************************
* END



