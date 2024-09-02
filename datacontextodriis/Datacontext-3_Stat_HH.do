*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 1, 2022
*-----
gl link = "datacontextodriis"
*Prepa database
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------










****************************************
* Socio demo charact
****************************************
cls
use"panel_v0", clear


*** Rescale
replace assets_total=assets_total/10000
replace assets_totalnoland=assets_totalnoland/10000
replace annualincome_HH=annualincome_HH/1000
replace loanamount_HH=loanamount_HH/10000
gen dummydebt=0
replace dummydebt=1 if nbloans_HH>0 & nbloans_HH!=.
replace sizeownland=sizeownland*0.404686
replace healthexpenses=healthexpenses/1000
replace educationexpenses=educationexpenses/1000


*** Share of gold
gen sharegold=assets_gold/(assets_totalnoland*10000)


*** Caste
ta caste year
preserve
keep HHID_panel year caste jatis
bysort HHID_panel: gen n=_n
reshape wide caste jatis n, i(HHID_panel) j(year)
ta caste2010
ta caste2016
ta caste2020
ta caste2010 caste2016
ta caste2016 caste2020
ta caste2010 caste2016 if n2020==3
restore

*** Socio demo
tabstat HHsize sexratio dependencyratio nonworkersratio, stat(mean) by(year) long
tabstat HHsize sexratio dependencyratio nonworkersratio if caste==1, stat(mean) by(year) long
tabstat HHsize sexratio dependencyratio nonworkersratio if caste==2, stat(mean) by(year) long
tabstat HHsize sexratio dependencyratio nonworkersratio if caste==3, stat(mean) by(year) long

*** Income
tabstat annualincome_HH, stat(mean cv q) by(year)
tabstat annualincome_HH if caste==1, stat(mean cv q) by(year)
tabstat annualincome_HH if caste==2, stat(mean cv q) by(year)
tabstat annualincome_HH if caste==3, stat(mean cv q) by(year)

*** Income agri (share)
tabstat shareincomenonagri_HH, stat(mean cv q) by(year)
tabstat shareincomenonagri_HH if caste==1, stat(mean cv q) by(year)
tabstat shareincomenonagri_HH if caste==2, stat(mean cv q) by(year)
tabstat shareincomenonagri_HH if caste==3, stat(mean cv q) by(year)

*** Assets
tabstat assets_total, stat(mean cv q) by(year)
tabstat assets_total if caste==1, stat(mean cv q) by(year)
tabstat assets_total if caste==2, stat(mean cv q) by(year)
tabstat assets_total if caste==3, stat(mean cv q) by(year)

*** Assets no land
tabstat assets_totalnoland, stat(mean cv q) by(year)
tabstat assets_totalnoland if caste==1, stat(mean cv q) by(year)
tabstat assets_totalnoland if caste==2, stat(mean cv q) by(year)
tabstat assets_totalnoland if caste==3, stat(mean cv q) by(year)

*** Gold
tabstat goldquantity_HH, stat(mean cv q) by(year)
tabstat goldquantity_HH if caste==1, stat(mean cv q) by(year)
tabstat goldquantity_HH if caste==2, stat(mean cv q) by(year)
tabstat goldquantity_HH if caste==3, stat(mean cv q) by(year)

*** Share gols
tabstat sharegold, stat(mean cv q) by(year)
tabstat sharegold if caste==1, stat(mean cv q) by(year)
tabstat sharegold if caste==2, stat(mean cv q) by(year)
tabstat sharegold if caste==3, stat(mean cv q) by(year)

*** House
tabstat assets_housevalue, stat(mean cv q) by(year)
tabstat assets_housevalue if caste==1, stat(mean cv q) by(year)
tabstat assets_housevalue if caste==2, stat(mean cv q) by(year)
tabstat assets_housevalue if caste==3, stat(mean cv q) by(year)

*** Migration
ta dummymigration year, col nofreq
ta dummymigration year if caste==1, col nofreq
ta dummymigration year if caste==2, col nofreq
ta dummymigration year if caste==3, col nofreq


*** % of land owner?
ta ownland year, col nofreq
ta ownland year if caste==1, col nofreq
ta ownland year if caste==2, col nofreq
ta ownland year if caste==3, col nofreq

*** Size of land
tabstat sizeownland, stat(mean cv q) by(year)
tabstat sizeownland if caste==1, stat(mean cv q) by(year)
tabstat sizeownland if caste==2, stat(mean cv q) by(year)
tabstat sizeownland if caste==3, stat(mean cv q) by(year)

*** Incidence of debt
ta dummydebt year, col nofreq
ta dummydebt year if caste==1, col nofreq
ta dummydebt year if caste==2, col nofreq
ta dummydebt year if caste==3, col nofreq

*** Intensity of debt
tabstat loanamount_HH, stat(mean cv q) by(year)
tabstat loanamount_HH if caste==1, stat(mean cv q) by(year)
tabstat loanamount_HH if caste==2, stat(mean cv q) by(year)
tabstat loanamount_HH if caste==3, stat(mean cv q) by(year)


*** Expenses
* Food
tabstat foodexpenses, stat(n mean cv q) by(year)
tabstat foodexpenses if caste==1, stat(mean cv q) by(year)
tabstat foodexpenses if caste==2, stat(mean cv q) by(year)
tabstat foodexpenses if caste==3, stat(mean cv q) by(year)

* Health
tabstat healthexpenses, stat(n mean cv q) by(year)
tabstat healthexpenses if caste==1, stat(mean cv q) by(year)
tabstat healthexpenses if caste==2, stat(mean cv q) by(year)
tabstat healthexpenses if caste==3, stat(mean cv q) by(year)

* Education
tabstat educationexpenses, stat(n mean cv q) by(year)
tabstat educationexpenses if caste==1, stat(mean cv q) by(year)
tabstat educationexpenses if caste==2, stat(mean cv q) by(year)
tabstat educationexpenses if caste==3, stat(mean cv q) by(year)


****************************************
* END








****************************************
* Income inequalities
****************************************
cls
use"panel_v0", clear

*** Selection
keep HHID_panel year annualincome_HH caste
reshape wide annualincome_HH caste, i(HHID_panel) j(year)
gen caste=.
replace caste=caste2010 if caste2010!=.
replace caste=caste2016 if caste2016!=.
replace caste=caste2020 if caste2020!=.
drop caste2010 caste2016 caste2020
label values caste caste
order HHID_panel caste


********** Income
set graph off
* Income total
lorenz annualincome_HH2010 annualincome_HH2016 annualincome_HH2020, gini
lorenz graph, overlay noci legend(order(2 "2010" 3 "2016-17" 4 "2020-21") pos(6) col(3)) title("Total") name(total,replace) diagonal(lpattern(dot)) xtitle("Population share") ytitle("Share of cumulative income")


* Income Dalits
preserve
keep if caste==1
lorenz annualincome_HH2010 annualincome_HH2016 annualincome_HH2020, gini
lorenz graph, overlay noci legend(order(2 "2010" 3 "2016-17" 4 "2020-21") pos(6) col(3)) title("Dalits") name(dalits,replace) diagonal(lpattern(dot)) xtitle("Population share") ytitle("Share of cumulative income")
restore

* Income middle
preserve
keep if caste==2
lorenz annualincome_HH2010 annualincome_HH2016 annualincome_HH2020, gini
lorenz graph, overlay noci legend(order(2 "2010" 3 "2016-17" 4 "2020-21") pos(6) col(3)) title("Middle castes") name(mid,replace) diagonal(lpattern(dot)) xtitle("Population share") ytitle("Share of cumulative income")
restore


* Income upper
preserve
keep if caste==3
lorenz annualincome_HH2010 annualincome_HH2016 annualincome_HH2020, gini
lorenz graph, overlay noci legend(order(2 "2010" 3 "2016-17" 4 "2020-21") pos(6) col(3)) title("Upper castes") name(upp,replace) diagonal(lpattern(dot)) xtitle("Population share") ytitle("Share of cumulative income")
restore
set graph on

*** Combine
grc1leg total dalits mid upp, col(2) name(income_comb, replace)
graph export "Lorenz_income.pdf", replace as(pdf)


*** Montrer que les inégalités augmentent
lorenz annualincome_HH2010 annualincome_HH2016 annualincome_HH2020, gini
lorenz graph, overlay noci legend(order(2 "2010" 3 "2016-17" 4 "2020-21") pos(6) col(3)) title("Courbe de Lorenz des revenues des ménages") name(total,replace) diagonal(lpattern(solid) lcolor("197 102 63")) xtitle("Part de la population") ytitle("Part des revenus cumulés") lcolor("164 204 76")


****************************************
* END



















****************************************
* Assets inequalities
****************************************
cls
use"panel_v0", clear

*** Selection
keep HHID_panel year assets_totalnoland caste
reshape wide assets_totalnoland caste, i(HHID_panel) j(year)
gen caste=.
replace caste=caste2010 if caste2010!=.
replace caste=caste2016 if caste2016!=.
replace caste=caste2020 if caste2020!=.
drop caste2010 caste2016 caste2020
label values caste caste
order HHID_panel caste


********** Income
set graph off
* Income total
lorenz assets_totalnoland2010 assets_totalnoland2016 assets_totalnoland2020, gini
lorenz graph, overlay noci legend(order(2 "2010" 3 "2016-17" 4 "2020-21") pos(6) col(3)) title("Total") name(total2,replace) diagonal(lpattern(dot)) xtitle("Population share") ytitle("Share of cumulative assets")


* Income Dalits
preserve
keep if caste==1
lorenz assets_totalnoland2010 assets_totalnoland2016 assets_totalnoland2020, gini
lorenz graph, overlay noci legend(order(2 "2010" 3 "2016-17" 4 "2020-21") pos(6) col(3)) title("Dalits") name(dalits2,replace) diagonal(lpattern(dot)) xtitle("Population share") ytitle("Share of cumulative assets")
restore

* Income middle
preserve
keep if caste==2
lorenz assets_totalnoland2010 assets_totalnoland2016 assets_totalnoland2020, gini
lorenz graph, overlay noci legend(order(2 "2010" 3 "2016-17" 4 "2020-21") pos(6) col(3)) title("Middle castes") name(mid2,replace) diagonal(lpattern(dot)) xtitle("Population share") ytitle("Share of cumulative assets")
restore


* Income upper
preserve
keep if caste==3
lorenz assets_totalnoland2010 assets_totalnoland2016 assets_totalnoland2020, gini
lorenz graph, overlay noci legend(order(2 "2010" 3 "2016-17" 4 "2020-21") pos(6) col(3)) title("Upper castes") name(upp2,replace) diagonal(lpattern(dot)) xtitle("Population share") ytitle("Share of cumulative assets")
restore
set graph on

*** Combine
grc1leg total2 dalits2 mid2 upp2, col(2) name(assets_comb, replace)
graph export "Lorenz_assets.pdf", replace as(pdf)
graph export "Lorenz_assets.png", replace as(png)


*** Combine assets and income
grc1leg total total2, name(comb_incass, replace)
graph export "Lorenz_incass.pdf", replace as(pdf)
graph export "Lorenz_incass.png", replace as(png)

****************************************
* END




















****************************************
* At least one source of agricultural income
****************************************
cls
use"panel_v0", clear

*** Rescale
replace assets_total=assets_total/10000
replace assets_totalnoland=assets_totalnoland/10000
replace annualincome_HH=annualincome_HH/1000
replace loanamount_HH=loanamount_HH/10000
gen dummydebt=0
replace dummydebt=1 if nbloans_HH>0 & nbloans_HH!=.
replace sizeownland=sizeownland*0.404686

*** Construction
ta shareincomeagri_HH, m

gen agri_HH=shareincomeagri_HH
replace agri_HH=1 if shareincomeagri_HH>0

* Recode à la main pour ceux qui ont un revenu annuel de 0
sort HHID_panel year
list HHID_panel year ownland annualincome_HH if shareincomeagri_HH==., clean noobs

replace agri_HH=0 if HHID_panel=="KAR41" & year==2020
replace agri_HH=0 if HHID_panel=="MANAM14" & year==2020
replace agri_HH=1 if HHID_panel=="MANAM31" & year==2020
replace agri_HH=1 if HHID_panel=="NAT35" & year==2016

*** Stat
ta agri_HH year, col nofreq
ta agri_HH year if caste==1, col nofreq
ta agri_HH year if caste==2, col nofreq
ta agri_HH year if caste==3, col nofreq

****************************************
* END













****************************************
* Land
****************************************
cls
use"panel_v0", clear


*** Rescale
replace assets_total=assets_total/10000
replace assets_totalnoland=assets_totalnoland/10000
replace annualincome_HH=annualincome_HH/1000
replace loanamount_HH=loanamount_HH/10000
gen dummydebt=0
replace dummydebt=1 if nbloans_HH>0 & nbloans_HH!=.
replace sizeownland=sizeownland*0.404686


*** Stat
tabstat ownland sizeownland, stat(n mean) by(year)
tabstat ownland sizeownland if caste==1, stat(n mean) by(year)
tabstat ownland sizeownland if caste==2, stat(n mean) by(year)
tabstat ownland sizeownland if caste==3, stat(n mean) by(year)


*** Total
preserve
collapse (mean) ownland sizeownland, by(time)
twoway ///
(bar ownland time, yaxis(1) barwidth(.5)) ///
(connected sizeownland time, yaxis(2)) ///
, ///
ylabel(0(.1).7, axis(1)) ///
ylabel(0(.5)2, axis(2)) ///
ymtick(0(.25)2, axis(2)) ///
ytitle("Share of land owner", axis(1)) ///
ytitle("Average land size (ha)", axis(2)) ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ///
xtitle("") ///
legend(order(1 "Share of land owner" 2 "Average land size (ha)") pos(6) col(2)) ///
title("Land ownership and size") ///
aspectratio() name(agri, replace)
graph export "Agri_total.png", as(png) replace
restore





*** Total
preserve
collapse (mean) ownland sizeownland, by(time)
twoway ///
(bar ownland time, yaxis(1) barwidth(.5)) ///
(connected sizeownland time, yaxis(2)) ///
, ///
ylabel(0(.1).7, axis(1)) ///
ylabel(0(.5)2, axis(2)) ///
ymtick(0(.25)2, axis(2)) ///
ytitle("Share of land owner", axis(1)) ///
ytitle("Average land size (ha)", axis(2)) ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ///
xtitle("") ///
legend(order(1 "Share of land owner" 2 "Average land size (ha)") pos(6) col(2)) ///
title("Total") ///
aspectratio() name(agri, replace)
graph export "Agri_total.pdf", as(pdf) replace
graph export "Agri_total.png", as(png) replace
restore


*** By caste
preserve
collapse (mean) ownland sizeownland, by(caste time)

* Dalits
twoway ///
(bar ownland time if caste==1, yaxis(1) barwidth(.5)) ///
(connected sizeownland time if caste==1, yaxis(2)) ///
, ///
ylabel(0(.1).7, axis(1)) ///
ylabel(0(.5)2, axis(2)) ///
ymtick(0(.25)2, axis(2)) ///
ytitle("Share of land owner", axis(1)) ///
ytitle("Average land size (ha)", axis(2)) ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ///
xtitle("") ///
legend(order(1 "Share of land owner" 2 "Average land size (ha)") pos(6) col(2)) ///
title("Dalits") ///
aspectratio() name(agri_c1, replace)


* Middle
twoway ///
(bar ownland time if caste==2, yaxis(1) barwidth(.5)) ///
(connected sizeownland time if caste==2, yaxis(2)) ///
, ///
ylabel(0(.1).7, axis(1)) ///
ylabel(0(.5)2, axis(2)) ///
ymtick(0(.25)2, axis(2)) ///
ytitle("Share of land owner", axis(1)) ///
ytitle("Average land size (ha)", axis(2)) ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ///
xtitle("") ///
legend(order(1 "Share of land owner" 2 "Average land size (ha)") pos(6) col(2)) ///
title("Middle castes") ///
aspectratio() name(agri_c2, replace)


* Upper
twoway ///
(bar ownland time if caste==3, yaxis(1) barwidth(.5)) ///
(connected sizeownland time if caste==3, yaxis(2)) ///
, ///
ylabel(0(.1).7, axis(1)) ///
ylabel(0(.5)2, axis(2)) ///
ymtick(0(.25)2, axis(2)) ///
ytitle("Share of land owner", axis(1)) ///
ytitle("Average land size (ha)", axis(2)) ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ///
xtitle("") ///
legend(order(1 "Share of land owner" 2 "Average land size (ha)") pos(6) col(2)) ///
title("Upper castes") ///
aspectratio() name(agri_c3, replace)
restore

*** Combine
grc1leg agri agri_c1 agri_c2 agri_c3, col(2) name(agri_comb, replace)
graph export "Agri_total.pdf", as(pdf) replace
graph export "Agri_total.png", as(png) replace


****************************************
* END













****************************************
* Share income agri
****************************************
cls
use"panel_v0", clear

* Test
gen test=annualincome_HH-incomeagri_HH-incomenonagri_HH
ta test
drop test

gen test=1-shareincomeagri_HH-shareincomenonagri_HH
ta test
drop test


* Stat
tabstat shareincomeagri_HH shareincomenonagri_HH, stat(n mean cv p50) by(year)
tabstat shareincomeagri_HH shareincomenonagri_HH if caste==1, stat(n mean cv p50) by(year)
tabstat shareincomeagri_HH shareincomenonagri_HH if caste==2, stat(n mean cv p50) by(year)
tabstat shareincomeagri_HH shareincomenonagri_HH if caste==3, stat(n mean cv p50) by(year)

tabstat shareincomeagri_HH shareincomenonagri_HH, stat(mean) by(year)
tabstat shareincomeagri_HH shareincomenonagri_HH if caste==1, stat(mean) by(year)
tabstat shareincomeagri_HH shareincomenonagri_HH if caste==2, stat(mean) by(year)
tabstat shareincomeagri_HH shareincomenonagri_HH if caste==3, stat(mean) by(year)


* Graph
label define caste 1"Dalits" 2"Middle castes" 3"Upper castes", modify
collapse (mean) shareincomeagri_HH shareincomenonagri_HH, by(caste year)

graph bar shareincomeagri_HH shareincomenonagri_HH, over(year, label(angle(45))) over(caste) stack ytitle("Share") legend(order(1 "Agricultural income" 2 "Non-agricultural income") pos(6) col(2))
graph export "Shareincome.pdf", replace as(pdf)
graph export "Shareincome.png", replace as(png)


****************************************
* END














****************************************
* Graph debt
****************************************
cls
use"panel_v0", clear

*** Rescale
replace assets_total=assets_total/10000
replace assets_totalnoland=assets_totalnoland/10000
replace annualincome_HH=annualincome_HH/1000
replace loanamount_HH=loanamount_HH/10000
gen dummydebt=0
replace dummydebt=1 if nbloans_HH>0 & nbloans_HH!=.

/*
To ensure a good visibility, we recode the extrems values at p99
of the pooled sample
i.e., 25 changes
*/
tabstat loanamount_HH, stat(mean)  by(year)
tabstat loanamount_HH if caste==1, stat(mean)  by(year)
tabstat loanamount_HH if caste==2, stat(mean)  by(year)
tabstat loanamount_HH if caste==3, stat(mean)  by(year)
*tabstat loanamount_HH, stat(p90 p95 p99 max)
*replace loanamount_HH=80 if loanamount>80


preserve
collapse (mean) dummydebt loanamount_HH, by(time)
twoway ///
(bar dummydebt time, yaxis(1) barwidth(.5)) ///
(connected loanamount_HH time, yaxis(2)) ///
, ///
ylabel(0(.1)1, axis(1)) ///
ylabel(0(5)20, axis(2)) ///
ymtick(0(2.5)20, axis(2)) ///
ytitle("Share of indebted households", axis(1)) ///
ytitle("Average loanamount (INR 10k)", axis(2)) ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ///
xtitle("") ///
legend(order(1 "Share of indebted households" 2 "Average loanamount (INR 10k)") pos(6) col(2)) ///
title("Total") ///
aspectratio() name(debt, replace)
graph export "Debt_total.pdf", as(pdf) replace
graph export "Debt_total.png", as(png) replace
restore


*** By caste
preserve
collapse (mean) dummydebt loanamount_HH, by(caste time)

* Dalits
twoway ///
(bar dummydebt time if caste==1, yaxis(1) barwidth(.5)) ///
(connected loanamount_HH time if caste==1, yaxis(2)) ///
, ///
ylabel(0(.1)1, axis(1)) ///
ylabel(0(5)20, axis(2)) ///
ymtick(0(2.5)20, axis(2)) ///
ytitle("Share of indebted households", axis(1)) ///
ytitle("Average loanamount (INR 10k)", axis(2)) ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ///
xtitle("") ///
legend(order(1 "Share of indebted households" 2 "Average loanamount (INR 10k)") pos(6) col(2)) ///
title("Dalits") ///
aspectratio() name(debt_c1, replace)


* Middle
twoway ///
(bar dummydebt time if caste==2, yaxis(1) barwidth(.5)) ///
(connected loanamount_HH time if caste==2, yaxis(2)) ///
, ///
ylabel(0(.1)1, axis(1)) ///
ylabel(0(5)20, axis(2)) ///
ymtick(0(2.5)20, axis(2)) ///
ytitle("Share of indebted households", axis(1)) ///
ytitle("Average loanamount (INR 10k)", axis(2)) ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ///
xtitle("") ///
legend(order(1 "Share of indebted households" 2 "Average loanamount (INR 10k)") pos(6) col(2)) ///
title("Middle") ///
aspectratio() name(debt_c2, replace)


* Upper
twoway ///
(bar dummydebt time if caste==3, yaxis(1) barwidth(.5)) ///
(connected loanamount_HH time if caste==3, yaxis(2)) ///
, ///
ylabel(0(.1)1, axis(1)) ///
ylabel(0(5)20, axis(2)) ///
ymtick(0(2.5)20, axis(2)) ///
ytitle("Share of indebted households", axis(1)) ///
ytitle("Average loanamount (INR 10k)", axis(2)) ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ///
xtitle("") ///
legend(order(1 "Share of indebted households" 2 "Average loanamount (INR 10k)") pos(6) col(2)) ///
title("Upper") ///
aspectratio() name(debt_c3, replace)
restore



*** Combine
grc1leg debt debt_c1 debt_c2 debt_c3, col(2) name(debt_comb, replace)
graph export "Debt_total.pdf", as(pdf) replace
graph export "Debt_total.png", as(png) replace


****************************************
* END

















****************************************
* Graph poster
****************************************
cls
use"panel_v0", clear

*** Rescale
replace assets_total=assets_total/10000
replace assets_totalnoland=assets_totalnoland/10000
replace annualincome_HH=annualincome_HH/10000
replace loanamount_HH=loanamount_HH/10000
gen dummydebt=0
replace dummydebt=1 if nbloans_HH>0 & nbloans_HH!=.




********** Amount
preserve
*keep if caste==1
*drop if caste==1
collapse (median) assets_totalnoland annualincome_HH loanamount_HH, by(time)
twoway ///
(connected assets_totalnoland time, lcolor(gs8)) ///
(connected annualincome_HH time, lcolor(gs5) lpattern(dash)) ///
(connected loanamount_HH time, lcolor(gs0)) ///
, ///
ylabel(0(5)30, axis(1)) ///
ytitle("INR 10k") ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ///
xtitle("") ///
legend(order(1 "Assets without land" 2 "Annual income" 3 "Total indebtedness") pos(6) col(3)) ///
title("Median amount of assets, income and debt") ///
subtitle(".", color(white)) ///
note("." ".", size(vsmall) color(white)) ///
aspectratio() name(amount, replace)
graph export "Amount.png", as(png) replace
restore




********** IQR
preserve
foreach x in assets_totalnoland annualincome_HH loanamount_HH {
egen iqr_`x'_2010=iqr(`x') if year==2010
egen iqr_`x'_2016=iqr(`x') if year==2016
egen iqr_`x'_2020=iqr(`x') if year==2020
gen iqr_`x'=.
replace iqr_`x'=iqr_`x'_2010 if year==2010
replace iqr_`x'=iqr_`x'_2016 if year==2016
replace iqr_`x'=iqr_`x'_2020 if year==2020
drop iqr_`x'_2010 iqr_`x'_2016 iqr_`x'_2020
}
tabstat assets_totalnoland annualincome_HH loanamount_HH, stat(iqr) by(year)
keep year time iqr_assets_totalnoland iqr_annualincome_HH iqr_loanamount_HH
sort time
twoway ///
(connected iqr_assets_totalnoland time, lcolor(gs8)) ///
(connected iqr_annualincome_HH time, lcolor(gs5) lpattern(dash)) ///
(connected iqr_loanamount_HH time, color(gs0)) ///
, ///
ylabel(0(5)30, axis(1)) ///
ytitle("INR 10k") ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ///
xtitle("") ///
legend(order(1 "Assets without land" 2 "Annual income" 3 "Total indebtedness") pos(6) col(3)) ///
title("Inequalities of assets, income and debt measured with the interquartile range:") ///
subtitle("difference between the third (Q3) and first (Q1) quartile") ///
note("Q1: splits off the lowest 25% of data from the highest 75%." "Q3: splits off the highest 25% of data from the lowest 75%.", size(vsmall)) ///
aspectratio() name(ineq, replace)
graph export "Inequalities.png", as(png) replace
restore



****************************************
* END
