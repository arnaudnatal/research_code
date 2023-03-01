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


*** Caste
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


*** % of land owner?
ta ownland year, col nofreq
ta ownland year if caste2==1, col nofreq
ta ownland year if caste2==2, col nofreq

*** Size of land
tabstat sizeownland, stat(n mean p50) by(year)
tabstat sizeownland if caste2==1, stat(n mean p50) by(year)
tabstat sizeownland if caste2==2, stat(n mean p50) by(year)

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

****************************************
* END













****************************************
* Graph land
****************************************
cls
use"panel_v0", clear


*** Total
preserve
collapse (mean) ownland sizeownland, by(time)
twoway ///
(bar ownland time, yaxis(1) barwidth(.5)) ///
(connected sizeownland time, yaxis(2)) ///
, ///
ylabel(0(.1).7, axis(1)) ///
ylabel(1(.2)3, axis(2)) ///
ytitle("Share of land owner", axis(1)) ///
ytitle("Average land size (ha)", axis(2)) ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ///
xtitle("") ///
legend(order(1 "Share of land owner" 2 "Average land size (ha)") pos(6) col(2)) ///
title("Total") ///
aspectratio(2) name(agri, replace)
restore

*** By caste
preserve
collapse (mean) ownland sizeownland, by(caste2 time)

* Dalits
twoway ///
(bar ownland time if caste2==1, yaxis(1) barwidth(.5)) ///
(connected sizeownland time if caste2==1, yaxis(2)) ///
, ///
ylabel(0(.1).7, axis(1)) ///
ylabel(1(.2)3, axis(2)) ///
ytitle("Share of land owner", axis(1)) ///
ytitle("Average land size (ha)", axis(2)) ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ///
xtitle("") ///
legend(order(1 "Share of land owner" 2 "Average land size (ha)") pos(6) col(2)) ///
title("Dalits") ///
aspectratio(2) name(agri_c1, replace)


* Non-Dalits
twoway ///
(bar ownland time if caste2==2, yaxis(1) barwidth(.5)) ///
(connected sizeownland time if caste2==2, yaxis(2)) ///
, ///
ylabel(0(.1).7, axis(1)) ///
ylabel(1(.2)3, axis(2)) ///
ytitle("Share of land owner", axis(1)) ///
ytitle("Average land size (ha)", axis(2)) ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ///
xtitle("") ///
legend(order(1 "Share of land owner" 2 "Average land size (ha)") pos(6) col(2)) ///
title("Non-Dalits") ///
aspectratio(2) name(agri_c2, replace)
restore

*** Combine
grc1leg agri agri_c1 agri_c2, col(3) name(agri_comb, replace)
graph export "Agri_comb.pdf", as(pdf) replace



****************************************
* END
















****************************************
* Debt
****************************************
cls
use"panel_v0", clear

*** Rescale
replace loanamount_HH=loanamount_HH/10000
gen dummydebt=0
replace dummydebt=1 if nbloans_HH>0 & nbloans_HH!=.

*** Incidence
ta dummydebt year, col nofreq
ta dummydebt year if caste2==1, col nofreq
ta dummydebt year if caste2==2, col nofreq

*** Intensity
tabstat loanamount_HH, stat(mean cv p50) by(year)
tabstat loanamount_HH if caste2==1, stat(mean cv p50) by(year)
tabstat loanamount_HH if caste2==2, stat(mean cv p50) by(year)


****************************************
* END















****************************************
* Debt
****************************************
cls
use"panel_v0", clear

*** Rescale
replace loanamount_HH=loanamount_HH/10000
gen dummydebt=0
replace dummydebt=1 if nbloans_HH>0 & nbloans_HH!=.


*** Total
preserve
collapse (mean) dummydebt loanamount_HH, by(time)
twoway ///
(bar dummydebt time, yaxis(1) barwidth(.5)) ///
(connected loanamount_HH time, yaxis(2)) ///
, ///
ylabel(0(.1).7, axis(1)) ///
ylabel(1(.2)3, axis(2)) ///
ytitle("Share of land owner", axis(1)) ///
ytitle("Average land size (ha)", axis(2)) ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ///
xtitle("") ///
legend(order(1 "Share of land owner" 2 "Average land size (ha)") pos(6) col(2)) ///
title("Total") ///
aspectratio(2) name(agri, replace)
restore

****************************************
* END













/*
stripplot assets_totalnoland if assets_totalnoland<100, over(time) vert ///
stack width(.5) jitter(0) ///
box(barw(.2)) boffset(-0.15) pctile(25) ///
ms(oh oh oh) msize(small) mc(black%30) ///
yla(0(10)100, ang(h)) xla(, noticks) ///
ymtick(0(5)100) ///
xtitle("") ytitle("Monetary value of assets (INR 10k)") ///
name(wealth, replace)
graph export "Wealth.pdf", as(pdf) replace
