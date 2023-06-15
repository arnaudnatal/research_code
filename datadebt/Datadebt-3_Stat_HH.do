*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*June 1, 2023
*-----
gl link = "datadebt"
*Stat HH
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
tabstat annualincome_HH, stat(mean cv p50) by(year)
tabstat annualincome_HH if caste==1, stat(mean cv p50) by(year)
tabstat annualincome_HH if caste==2, stat(mean cv p50) by(year)
tabstat annualincome_HH if caste==3, stat(mean cv p50) by(year)

*** Income agri (share)
tabstat shareincomenonagri_HH, stat(mean cv p50) by(year)
tabstat shareincomenonagri_HH if caste==1, stat(mean cv p50) by(year)
tabstat shareincomenonagri_HH if caste==2, stat(mean cv p50) by(year)
tabstat shareincomenonagri_HH if caste==3, stat(mean cv p50) by(year)

*** Assets no land
tabstat assets_totalnoland, stat(mean cv p50) by(year)
tabstat assets_totalnoland if caste==1, stat(mean cv p50) by(year)
tabstat assets_totalnoland if caste==2, stat(mean cv p50) by(year)
tabstat assets_totalnoland if caste==3, stat(mean cv p50) by(year)

*** Share gold
tabstat sharegold, stat(mean cv p50) by(year)
tabstat sharegold if caste==1, stat(mean cv p50) by(year)
tabstat sharegold if caste==2, stat(mean cv p50) by(year)
tabstat sharegold if caste==3, stat(mean cv p50) by(year)

*** % of land owner?
ta ownland year, col nofreq
ta ownland year if caste==1, col nofreq
ta ownland year if caste==2, col nofreq
ta ownland year if caste==3, col nofreq

*** Size of land
tabstat sizeownland, stat(mean cv p50) by(year)
tabstat sizeownland if caste==1, stat(mean cv p50) by(year)
tabstat sizeownland if caste==2, stat(mean cv p50) by(year)
tabstat sizeownland if caste==3, stat(mean cv p50) by(year)


*** PL
cls
ta poor year, col nofreq
ta poor year if caste==1, col nofreq
ta poor year if caste==2, col nofreq
ta poor year if caste==3, col nofreq




****************************************
* END












****************************************
* Graph debt: nb of loans
****************************************
cls
use"panel_v0", clear

*** Nb of loans
tabstat nbloans_HH, stat(n mean cv p50) by(year)
tabstat nbloans_HH if caste==1, stat(n mean cv p50) by(year)
tabstat nbloans_HH if caste==2, stat(n mean cv p50) by(year)
tabstat nbloans_HH if caste==3, stat(n mean cv p50) by(year)


*** Graph
* Total
stripplot nbloans_HH, over(time) ///
stack width(0.01) jitter(1) refline(lp(dash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh oh) msize(small) mc(black%30) ///
xla(0(2)20, ang(h)) yla(, noticks) ///
xmtick(0(1)20) ///
legend(order(1 "Mean" 4 "Whisker from 5% to 95%") pos(6) col(2) on) ///
xtitle("No. of loans per household") ytitle("") ///
title("Total") name(c0, replace)

* Dalits
stripplot nbloans_HH if caste==1, over(time) ///
stack width(0.01) jitter(1) refline(lp(dash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh oh) msize(small) mc(black%30) ///
xla(0(2)20, ang(h)) yla(, noticks) ///
xmtick(0(1)20) ///
legend(order(1 "Mean" 4 "Whisker from 5% to 95%") pos(6) col(2) on) ///
xtitle("No. of loans per household") ytitle("") ///
title("Dalits") name(c1, replace)

* Middle
stripplot nbloans_HH if caste==2, over(time) ///
stack width(0.01) jitter(1) refline(lp(dash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh oh) msize(small) mc(black%30) ///
xla(0(2)20, ang(h)) yla(, noticks) ///
xmtick(0(1)20) ///
legend(order(1 "Mean" 4 "Whisker from 5% to 95%") pos(6) col(2) on) ///
xtitle("No. of loans per household") ytitle("") ///
title("Middle castes") name(c2, replace)

* Upper
stripplot nbloans_HH if caste==3, over(time) ///
stack width(0.01) jitter(1) refline(lp(dash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh oh) msize(small) mc(black%30) ///
xla(0(2)20, ang(h)) yla(, noticks) ///
xmtick(0(1)20) ///
legend(order(1 "Mean" 4 "Whisker from 5% to 95%") pos(6) col(2) on) ///
xtitle("No. of loans per household") ytitle("") ///
title("Upper castes") name(c3, replace)



* Combine
grc1leg c0 c1 c2 c3, col(2) name(comb, replace)
graph save "nbloans.gph", replace
graph export "nbloans.pdf", as(pdf) replace
graph export "nbloans.png", as(png) replace

****************************************
* END











****************************************
* Graph debt: amount and incidence
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
ytitle("Average loan amount (INR 10k)", axis(2)) ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ///
xtitle("") ///
legend(order(1 "Share of indebted households" 2 "Average loan amount (INR 10k)") pos(6) col(2)) ///
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
ytitle("Average loan amount (INR 10k)", axis(2)) ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ///
xtitle("") ///
legend(order(1 "Share of indebted households" 2 "Average loan amount (INR 10k)") pos(6) col(2)) ///
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
ytitle("Average loan amount (INR 10k)", axis(2)) ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ///
xtitle("") ///
legend(order(1 "Share of indebted households" 2 "Average loan amount (INR 10k)") pos(6) col(2)) ///
title("Middle castes") ///
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
ytitle("Average loan amount (INR 10k)", axis(2)) ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ///
xtitle("") ///
legend(order(1 "Share of indebted households" 2 "Average loan amount (INR 10k)") pos(6) col(2)) ///
title("Upper castes") ///
aspectratio() name(debt_c3, replace)
restore



*** Combine
grc1leg debt debt_c1 debt_c2 debt_c3, col(2) name(debt_comb, replace)
graph export "Debt_total.pdf", as(pdf) replace

****************************************
* END
