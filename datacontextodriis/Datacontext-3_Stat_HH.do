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

*** Migraiton
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

****************************************
* END
