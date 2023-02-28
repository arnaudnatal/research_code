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


* Jatis caste Isabelle
ta jatis caste if year==2010, col nofreq
ta jatis caste if year==2016, col nofreq
ta jatis caste if year==2020, col nofreq


* Caste
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

* Quanti
tabstat HHsize sexratio dependencyratio nonworkersratio, stat(n mean) by(year) long
tabstat HHsize sexratio dependencyratio nonworkersratio if caste2==1, stat(mean) by(year) long
tabstat HHsize sexratio dependencyratio nonworkersratio if caste2==2, stat(mean) by(year) long


* Quali
ta typeoffamily tof
ta tof year, col nofreq
ta tof year if caste2==1, col nofreq
ta tof year if caste2==2, col nofreq


* Head
ta head_sex year, col nofreq
ta head_sex year if caste2==1, col nofreq
ta head_sex year if caste2==2, col nofreq

tabstat head_age, stat(n mean) by(year)
tabstat head_age if caste2==1, stat(n mean) by(year)
tabstat head_age if caste2==2, stat(n mean) by(year)


fre head_edulevel
recode head_edulevel (5=2) (4=2) (3=2)
ta head_edulevel year, col nofreq
ta head_edulevel year if caste2==1, col nofreq
ta head_edulevel year if caste2==2, col nofreq



****************************************
* END









****************************************
* Agri
****************************************
cls
use"panel_v0", clear


*** % of land owner?
ta ownland year, col nofreq
ta ownland year if caste2==1, col nofreq
ta ownland year if caste2==2, col nofreq


*** Size of land
tabstat sizeownland, stat(n mean p50) by(year)
tabstat sizeownland if caste2==1, stat(n mean p50) by(year)
tabstat sizeownland if caste2==2, stat(n mean p50) by(year)


*** Collapse for graph
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
* Wealth
****************************************
cls
use"panel_v0", clear

*** Rescale
replace assets_total=assets_total/10000


*** Stat
tabstat assets_total, stat(mean cv p50) by(year)
tabstat assets_total if caste2==1, stat(mean cv p50) by(year)
tabstat assets_total if caste2==2, stat(mean cv p50) by(year)

*** Graph 2: Line
global var assets_total
global time year
global id HHID_panel

* Global
preserve
keep HHID_panel $time $var
reshape wide $var, i($id) j($time)
foreach x in $var {
foreach t in 2010 2016 2020 {
pctile `x'`t'_p=`x'`t', n(50)
egen mean_`x'`t'=mean(`x'`t')
drop `x'`t'
}
}
drop $id
gen n=_n*2
drop if n>100
foreach x in $var {
foreach t in 2010 2016 2020 {
gen error`t'=`x'`t'_p-mean_`x'`t'
gen diff`t'=abs(error`t')
egen mindiff`t'=min(diff`t')
replace mean_`x'`t'=. if mindiff`t'!=diff`t'
replace error`t'=. if mindiff`t'!=diff`t'
replace mean_`x'`t'=mean_`x'`t'+error`t'
drop mindiff`t' diff`t'
}
}
local var2="$var"
twoway ///
(line `var2'2010_p n if n<96, lcolor(gs12) lpattern(solid)) ///
(line `var2'2016_p n if n<96, lcolor(gs6) lpattern(solid)) ///
(line `var2'2020_p n if n<96, lcolor(gs0) lpattern(solid)) ///
(scatter mean_`var2'2010 n, mcolor(gs12) ms(+) msize(large)) ///
(scatter mean_`var2'2016 n, mcolor(gs6) ms(+) msize(large)) ///
(scatter mean_`var2'2020 n, mcolor(gs0) ms(+) msize(large)) ///
, ///
ytitle("Monetary value of assets (INR 10k)") xtitle("Percentile") ///
xlab(0(20)100) xmtick(0(10)100) ///
ylab(0(50)600) ymtick(0(25)600) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") col(3) pos(6)) ///
title("Total") ///
name(wealth, replace)
restore

* Dalits
preserve
keep if caste2==1
keep HHID_panel $time $var
reshape wide $var, i($id) j($time)
foreach x in $var {
foreach t in 2010 2016 2020 {
pctile `x'`t'_p=`x'`t', n(50)
egen mean_`x'`t'=mean(`x'`t')
drop `x'`t'
}
}
drop $id
gen n=_n*2
drop if n>100
foreach x in $var {
foreach t in 2010 2016 2020 {
gen error`t'=`x'`t'_p-mean_`x'`t'
gen diff`t'=abs(error`t')
egen mindiff`t'=min(diff`t')
replace mean_`x'`t'=. if mindiff`t'!=diff`t'
replace error`t'=. if mindiff`t'!=diff`t'
replace mean_`x'`t'=mean_`x'`t'+error`t'
drop mindiff`t' diff`t'
}
}
local var2="$var"
twoway ///
(line `var2'2010_p n if n<96, lcolor(gs12) lpattern(solid)) ///
(line `var2'2016_p n if n<96, lcolor(gs6) lpattern(solid)) ///
(line `var2'2020_p n if n<96, lcolor(gs0) lpattern(solid)) ///
(scatter mean_`var2'2010 n, mcolor(gs12) ms(+) msize(large)) ///
(scatter mean_`var2'2016 n, mcolor(gs6) ms(+) msize(large)) ///
(scatter mean_`var2'2020 n, mcolor(gs0) ms(+) msize(large)) ///
, ///
ytitle("Monetary value of assets (INR 10k)") xtitle("Percentile") ///
xlab(0(20)100) xmtick(0(10)100) ///
ylab(0(50)600) ymtick(0(25)600) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") col(3) pos(6)) ///
title("Dalits") ///
name(wealth_c1, replace)
restore


* Non-Dalits
preserve
keep if caste2==2
keep HHID_panel $time $var
reshape wide $var, i($id) j($time)
foreach x in $var {
foreach t in 2010 2016 2020 {
pctile `x'`t'_p=`x'`t', n(50)
egen mean_`x'`t'=mean(`x'`t')
drop `x'`t'
}
}
drop $id
gen n=_n*2
drop if n>100
foreach x in $var {
foreach t in 2010 2016 2020 {
gen error`t'=`x'`t'_p-mean_`x'`t'
gen diff`t'=abs(error`t')
egen mindiff`t'=min(diff`t')
replace mean_`x'`t'=. if mindiff`t'!=diff`t'
replace error`t'=. if mindiff`t'!=diff`t'
replace mean_`x'`t'=mean_`x'`t'+error`t'
drop mindiff`t' diff`t'
}
}
local var2="$var"
twoway ///
(line `var2'2010_p n if n<96, lcolor(gs12) lpattern(solid)) ///
(line `var2'2016_p n if n<96, lcolor(gs6) lpattern(solid)) ///
(line `var2'2020_p n if n<96, lcolor(gs0) lpattern(solid)) ///
(scatter mean_`var2'2010 n, mcolor(gs12) ms(+) msize(large)) ///
(scatter mean_`var2'2016 n, mcolor(gs6) ms(+) msize(large)) ///
(scatter mean_`var2'2020 n, mcolor(gs0) ms(+) msize(large)) ///
, ///
ytitle("Monetary value of assets (INR 10k)") xtitle("Percentile") ///
xlab(0(20)100) xmtick(0(10)100) ///
ylab(0(50)600) ymtick(0(25)600) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") col(3) pos(6)) ///
title("Non-Dalits") ///
name(wealth_c2, replace)
restore

* Combine
grc1leg wealth wealth_c1 wealth_c2, col(3) name(wealth, replace) note("+ represent the mean.")
graph export "Wealth_comb.pdf", as(pdf) replace


****************************************
* END












****************************************
* Wealth: No Land
****************************************
cls
use"panel_v0", clear

*** Rescale
replace assets_totalnoland=assets_totalnoland/10000


*** Stat
tabstat assets_totalnoland, stat(mean cv p50) by(year)
tabstat assets_totalnoland if caste2==1, stat(mean cv p50) by(year)
tabstat assets_totalnoland if caste2==2, stat(mean cv p50) by(year)


*** Graph 2: Line
global var assets_totalnoland
global time year
global id HHID_panel

* Global
preserve
keep HHID_panel $time $var
reshape wide $var, i($id) j($time)
foreach x in $var {
foreach t in 2010 2016 2020 {
pctile `x'`t'_p=`x'`t', n(50)
egen mean_`x'`t'=mean(`x'`t')
drop `x'`t'
}
}
drop $id
gen n=_n*2
drop if n>100
foreach x in $var {
foreach t in 2010 2016 2020 {
gen error`t'=`x'`t'_p-mean_`x'`t'
gen diff`t'=abs(error`t')
egen mindiff`t'=min(diff`t')
replace mean_`x'`t'=. if mindiff`t'!=diff`t'
replace error`t'=. if mindiff`t'!=diff`t'
replace mean_`x'`t'=mean_`x'`t'+error`t'
drop mindiff`t' diff`t'
}
}
local var2="$var"
twoway ///
(line `var2'2010_p n if n<96, lcolor(gs12) lpattern(solid)) ///
(line `var2'2016_p n if n<96, lcolor(gs6) lpattern(solid)) ///
(line `var2'2020_p n if n<96, lcolor(gs0) lpattern(solid)) ///
(scatter mean_`var2'2010 n, mcolor(gs12) ms(+) msize(large)) ///
(scatter mean_`var2'2016 n, mcolor(gs6) ms(+) msize(large)) ///
(scatter mean_`var2'2020 n, mcolor(gs0) ms(+) msize(large)) ///
, ///
ytitle("Monetary value of assets (INR 10k)") xtitle("Percentile") ///
xlab(0(20)100) xmtick(0(10)100) ///
ylab(0(10)80) ymtick(0(5)80) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") col(3) pos(6)) ///
title("Total") ///
name(wealthnl, replace)
restore

* Dalits
preserve
keep if caste2==1
keep HHID_panel $time $var
reshape wide $var, i($id) j($time)
foreach x in $var {
foreach t in 2010 2016 2020 {
pctile `x'`t'_p=`x'`t', n(50)
egen mean_`x'`t'=mean(`x'`t')
drop `x'`t'
}
}
drop $id
gen n=_n*2
drop if n>100
foreach x in $var {
foreach t in 2010 2016 2020 {
gen error`t'=`x'`t'_p-mean_`x'`t'
gen diff`t'=abs(error`t')
egen mindiff`t'=min(diff`t')
replace mean_`x'`t'=. if mindiff`t'!=diff`t'
replace error`t'=. if mindiff`t'!=diff`t'
replace mean_`x'`t'=mean_`x'`t'+error`t'
drop mindiff`t' diff`t'
}
}
local var2="$var"
twoway ///
(line `var2'2010_p n if n<96, lcolor(gs12) lpattern(solid)) ///
(line `var2'2016_p n if n<96, lcolor(gs6) lpattern(solid)) ///
(line `var2'2020_p n if n<96, lcolor(gs0) lpattern(solid)) ///
(scatter mean_`var2'2010 n, mcolor(gs12) ms(+) msize(large)) ///
(scatter mean_`var2'2016 n, mcolor(gs6) ms(+) msize(large)) ///
(scatter mean_`var2'2020 n, mcolor(gs0) ms(+) msize(large)) ///
, ///
ytitle("Monetary value of assets (INR 10k)") xtitle("Percentile") ///
xlab(0(20)100) xmtick(0(10)100) ///
ylab(0(10)80) ymtick(0(5)80) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") col(3) pos(6)) ///
title("Dalits") ///
name(wealthnl_c1, replace)
restore


* Non-Dalits
preserve
keep if caste2==2
keep HHID_panel $time $var
reshape wide $var, i($id) j($time)
foreach x in $var {
foreach t in 2010 2016 2020 {
pctile `x'`t'_p=`x'`t', n(50)
egen mean_`x'`t'=mean(`x'`t')
drop `x'`t'
}
}
drop $id
gen n=_n*2
drop if n>100
foreach x in $var {
foreach t in 2010 2016 2020 {
gen error`t'=`x'`t'_p-mean_`x'`t'
gen diff`t'=abs(error`t')
egen mindiff`t'=min(diff`t')
replace mean_`x'`t'=. if mindiff`t'!=diff`t'
replace error`t'=. if mindiff`t'!=diff`t'
replace mean_`x'`t'=mean_`x'`t'+error`t'
drop mindiff`t' diff`t'
}
}
local var2="$var"
twoway ///
(line `var2'2010_p n if n<96, lcolor(gs12) lpattern(solid)) ///
(line `var2'2016_p n if n<96, lcolor(gs6) lpattern(solid)) ///
(line `var2'2020_p n if n<96, lcolor(gs0) lpattern(solid)) ///
(scatter mean_`var2'2010 n, mcolor(gs12) ms(+) msize(large)) ///
(scatter mean_`var2'2016 n, mcolor(gs6) ms(+) msize(large)) ///
(scatter mean_`var2'2020 n, mcolor(gs0) ms(+) msize(large)) ///
, ///
ytitle("Monetary value of assets (INR 10k)") xtitle("Percentile") ///
xlab(0(20)100) xmtick(0(10)100) ///
ylab(0(10)80) ymtick(0(5)80) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") col(3) pos(6)) ///
title("Non-Dalits") ///
name(wealthnl_c2, replace)
restore

* Combine
grc1leg wealthnl wealthnl_c1 wealthnl_c2, col(3) name(wealth, replace) note("+ represent the mean.")
graph export "Wealthnoland_comb.pdf", as(pdf) replace


****************************************
* END











****************************************
* Employment: Income
****************************************
cls
use"panel_v0", clear

*** Rescale
replace annualincome_HH=annualincome_HH/1000

*** Stat
tabstat annualincome_HH, stat(mean cv p50) by(year)
tabstat annualincome_HH if caste2==1, stat(mean cv p50) by(year)
tabstat annualincome_HH if caste2==2, stat(mean cv p50) by(year)


*** Graph: Line
global var annualincome_HH
global time year
global id HHID_panel

* Total
preserve
keep HHID_panel $time $var
reshape wide $var, i($id) j($time)
foreach x in $var {
foreach t in 2010 2016 2020 {
pctile `x'`t'_p=`x'`t', n(50)
egen mean_`x'`t'=mean(`x'`t')
drop `x'`t'
}
}
drop $id
gen n=_n*2
drop if n>100
foreach x in $var {
foreach t in 2010 2016 2020 {
gen error`t'=`x'`t'_p-mean_`x'`t'
gen diff`t'=abs(error`t')
egen mindiff`t'=min(diff`t')
replace mean_`x'`t'=. if mindiff`t'!=diff`t'
replace error`t'=. if mindiff`t'!=diff`t'
replace mean_`x'`t'=mean_`x'`t'+error`t'
drop mindiff`t' diff`t'
}
}
local var2="$var"
twoway ///
(line `var2'2010_p n if n<96, lcolor(gs12) lpattern(solid)) ///
(line `var2'2016_p n if n<96, lcolor(gs6) lpattern(solid)) ///
(line `var2'2020_p n if n<96, lcolor(gs0) lpattern(solid)) ///
(scatter mean_`var2'2010 n, mcolor(gs12) ms(+) msize(large)) ///
(scatter mean_`var2'2016 n, mcolor(gs6) ms(+) msize(large)) ///
(scatter mean_`var2'2020 n, mcolor(gs0) ms(+) msize(large)) ///
, ///
ytitle("Annual income (INR 1k)") xtitle("Percentile") ///
xlab(0(20)100) xmtick(0(10)100) ///
ylab(0(30)300) ymtick(0(15)300) ///
title("Total") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") col(3) pos(6)) ///
name(income, replace)
restore



* Dalits
preserve
keep if caste2==1
keep HHID_panel $time $var
reshape wide $var, i($id) j($time)
foreach x in $var {
foreach t in 2010 2016 2020 {
pctile `x'`t'_p=`x'`t', n(50)
egen mean_`x'`t'=mean(`x'`t')
drop `x'`t'
}
}
drop $id
gen n=_n*2
drop if n>100
foreach x in $var {
foreach t in 2010 2016 2020 {
gen error`t'=`x'`t'_p-mean_`x'`t'
gen diff`t'=abs(error`t')
egen mindiff`t'=min(diff`t')
replace mean_`x'`t'=. if mindiff`t'!=diff`t'
replace error`t'=. if mindiff`t'!=diff`t'
replace mean_`x'`t'=mean_`x'`t'+error`t'
drop mindiff`t' diff`t'
}
}
local var2="$var"
twoway ///
(line `var2'2010_p n if n<96, lcolor(gs12) lpattern(solid)) ///
(line `var2'2016_p n if n<96, lcolor(gs6) lpattern(solid)) ///
(line `var2'2020_p n if n<96, lcolor(gs0) lpattern(solid)) ///
(scatter mean_`var2'2010 n, mcolor(gs12) ms(+) msize(large)) ///
(scatter mean_`var2'2016 n, mcolor(gs6) ms(+) msize(large)) ///
(scatter mean_`var2'2020 n, mcolor(gs0) ms(+) msize(large)) ///
, ///
ytitle("Annual income (INR 1k)") xtitle("Percentile") ///
xlab(0(20)100) xmtick(0(10)100) ///
ylab(0(30)300) ymtick(0(15)300) ///
title("Dalits") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") col(3) pos(6)) ///
name(income_c1, replace)
restore


* Non-Dalits
preserve
keep if caste2==2
keep HHID_panel $time $var
reshape wide $var, i($id) j($time)
foreach x in $var {
foreach t in 2010 2016 2020 {
pctile `x'`t'_p=`x'`t', n(50)
egen mean_`x'`t'=mean(`x'`t')
drop `x'`t'
}
}
drop $id
gen n=_n*2
drop if n>100
foreach x in $var {
foreach t in 2010 2016 2020 {
gen error`t'=`x'`t'_p-mean_`x'`t'
gen diff`t'=abs(error`t')
egen mindiff`t'=min(diff`t')
replace mean_`x'`t'=. if mindiff`t'!=diff`t'
replace error`t'=. if mindiff`t'!=diff`t'
replace mean_`x'`t'=mean_`x'`t'+error`t'
drop mindiff`t' diff`t'
}
}
local var2="$var"
twoway ///
(line `var2'2010_p n if n<96, lcolor(gs12) lpattern(solid)) ///
(line `var2'2016_p n if n<96, lcolor(gs6) lpattern(solid)) ///
(line `var2'2020_p n if n<96, lcolor(gs0) lpattern(solid)) ///
(scatter mean_`var2'2010 n, mcolor(gs12) ms(+) msize(large)) ///
(scatter mean_`var2'2016 n, mcolor(gs6) ms(+) msize(large)) ///
(scatter mean_`var2'2020 n, mcolor(gs0) ms(+) msize(large)) ///
, ///
ytitle("Annual income (INR 1k)") xtitle("Percentile") ///
xlab(0(20)100) xmtick(0(10)100) ///
ylab(0(30)300) ymtick(0(15)300) ///
title("Non-Dalits") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") col(3) pos(6)) ///
name(income_c2, replace)
restore


* Combine
grc1leg income income_c1 income_c2, col(3) note("+ represent the mean.") name(income_comb, replace)
graph export "Income_comb.pdf", as(pdf) replace



****************************************
* END












****************************************
* Employment: share non-agri
****************************************
cls
use"panel_v0", clear

*** Stat
tabstat shareincomenonagri_HH, stat(mean cv p50) by(year)
tabstat shareincomenonagri_HH if caste2==1, stat(mean cv p50) by(year)
tabstat shareincomenonagri_HH if caste2==2, stat(mean cv p50) by(year)


*** Graph: Line
global var shareincomenonagri_HH
global time year
global id HHID_panel

* Total
preserve
keep HHID_panel $time $var
reshape wide $var, i($id) j($time)
foreach x in $var {
foreach t in 2010 2016 2020 {
pctile `x'`t'_p=`x'`t', n(50)
egen mean_`x'`t'=mean(`x'`t')
drop `x'`t'
}
}
drop $id
gen n=_n*2
drop if n>100
foreach x in $var {
foreach t in 2010 2016 2020 {
gen error`t'=`x'`t'_p-mean_`x'`t'
gen diff`t'=abs(error`t')
egen mindiff`t'=min(diff`t')
replace mean_`x'`t'=. if mindiff`t'!=diff`t'
replace error`t'=. if mindiff`t'!=diff`t'
replace mean_`x'`t'=mean_`x'`t'+error`t'
drop mindiff`t' diff`t'
}
}
local var2="$var"
twoway ///
(line `var2'2010_p n if n<96, lcolor(gs12) lpattern(solid)) ///
(line `var2'2016_p n if n<96, lcolor(gs6) lpattern(solid)) ///
(line `var2'2020_p n if n<96, lcolor(gs0) lpattern(solid)) ///
(scatter mean_`var2'2010 n, mcolor(gs12) ms(+) msize(large)) ///
(scatter mean_`var2'2016 n, mcolor(gs6) ms(+) msize(large)) ///
(scatter mean_`var2'2020 n, mcolor(gs0) ms(+) msize(large)) ///
, ///
ytitle("% of non-agri. income") xtitle("Percentile") ///
xlab(0(20)100) xmtick(0(10)100) ///
ylab(0(.2)1) ymtick(0(.1)1) ///
title("Total") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") col(3) pos(6)) ///
name(shincome, replace)
restore



* Dalits
preserve
keep if caste2==1
keep HHID_panel $time $var
reshape wide $var, i($id) j($time)
foreach x in $var {
foreach t in 2010 2016 2020 {
pctile `x'`t'_p=`x'`t', n(50)
egen mean_`x'`t'=mean(`x'`t')
drop `x'`t'
}
}
drop $id
gen n=_n*2
drop if n>100
foreach x in $var {
foreach t in 2010 2016 2020 {
gen error`t'=`x'`t'_p-mean_`x'`t'
gen diff`t'=abs(error`t')
egen mindiff`t'=min(diff`t')
replace mean_`x'`t'=. if mindiff`t'!=diff`t'
replace error`t'=. if mindiff`t'!=diff`t'
replace mean_`x'`t'=mean_`x'`t'+error`t'
drop mindiff`t' diff`t'
}
}
local var2="$var"
twoway ///
(line `var2'2010_p n if n<96, lcolor(gs12) lpattern(solid)) ///
(line `var2'2016_p n if n<96, lcolor(gs6) lpattern(solid)) ///
(line `var2'2020_p n if n<96, lcolor(gs0) lpattern(solid)) ///
(scatter mean_`var2'2010 n, mcolor(gs12) ms(+) msize(large)) ///
(scatter mean_`var2'2016 n, mcolor(gs6) ms(+) msize(large)) ///
(scatter mean_`var2'2020 n, mcolor(gs0) ms(+) msize(large)) ///
, ///
ytitle("% of non-agri. income") xtitle("Percentile") ///
xlab(0(20)100) xmtick(0(10)100) ///
ylab(0(.2)1) ymtick(0(.1)1) ///
title("Dalits") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") col(3) pos(6)) ///
name(shincome_c1, replace)
restore


* Non-Dalits
preserve
keep if caste2==2
keep HHID_panel $time $var
reshape wide $var, i($id) j($time)
foreach x in $var {
foreach t in 2010 2016 2020 {
pctile `x'`t'_p=`x'`t', n(50)
egen mean_`x'`t'=mean(`x'`t')
drop `x'`t'
}
}
drop $id
gen n=_n*2
drop if n>100
foreach x in $var {
foreach t in 2010 2016 2020 {
gen error`t'=`x'`t'_p-mean_`x'`t'
gen diff`t'=abs(error`t')
egen mindiff`t'=min(diff`t')
replace mean_`x'`t'=. if mindiff`t'!=diff`t'
replace error`t'=. if mindiff`t'!=diff`t'
replace mean_`x'`t'=mean_`x'`t'+error`t'
drop mindiff`t' diff`t'
}
}
local var2="$var"
twoway ///
(line `var2'2010_p n if n<96, lcolor(gs12) lpattern(solid)) ///
(line `var2'2016_p n if n<96, lcolor(gs6) lpattern(solid)) ///
(line `var2'2020_p n if n<96, lcolor(gs0) lpattern(solid)) ///
(scatter mean_`var2'2010 n, mcolor(gs12) ms(+) msize(large)) ///
(scatter mean_`var2'2016 n, mcolor(gs6) ms(+) msize(large)) ///
(scatter mean_`var2'2020 n, mcolor(gs0) ms(+) msize(large)) ///
, ///
ytitle("% of non-agri. income") xtitle("Percentile") ///
xlab(0(20)100) xmtick(0(10)100) ///
ylab(0(.2)1) ymtick(0(.1)1) ///
title("Non-Dalits") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") col(3) pos(6)) ///
name(shincome_c2, replace)
restore


* Combine
grc1leg shincome shincome_c1 shincome_c2, col(3) note("+ represent the mean.") name(share_comb, replace)
graph export "Share_comb.pdf", as(pdf) replace



****************************************
* END




















****************************************
* Debt
****************************************
cls
use"panel_v0", clear

*** Rescale
gen dir=loanamount_HH/annualincome_HH
replace loanamount_HH=loanamount_HH/10000


*** Stat
gen dummydebt=0
replace dummydebt=1 if nbloans_HH>0 & nbloans_HH!=.
ta dummydebt year, col nofreq
ta dummydebt year if caste2==1, col nofreq
ta dummydebt year if caste2==2, col nofreq

tabstat loanamount_HH, stat(mean cv p50) by(year)
tabstat loanamount_HH if caste2==1, stat(mean cv p50) by(year)
tabstat loanamount_HH if caste2==2, stat(mean cv p50) by(year)


*** Graph 1: Line
global var loanamount_HH
global time year
global id HHID_panel

* Total
preserve
keep HHID_panel $time $var
reshape wide $var, i($id) j($time)
foreach x in $var {
foreach t in 2010 2016 2020 {
pctile `x'`t'_p=`x'`t', n(50)
egen mean_`x'`t'=mean(`x'`t')
drop `x'`t'
}
}
drop $id
gen n=_n*2
drop if n>100
foreach x in $var {
foreach t in 2010 2016 2020 {
gen error`t'=`x'`t'_p-mean_`x'`t'
gen diff`t'=abs(error`t')
egen mindiff`t'=min(diff`t')
replace mean_`x'`t'=. if mindiff`t'!=diff`t'
replace error`t'=. if mindiff`t'!=diff`t'
replace mean_`x'`t'=mean_`x'`t'+error`t'
drop mindiff`t' diff`t'
}
}
local var2="$var"
twoway ///
(line `var2'2010_p n if n<96, lcolor(gs12) lpattern(solid)) ///
(line `var2'2016_p n if n<96, lcolor(gs6) lpattern(solid)) ///
(line `var2'2020_p n if n<96, lcolor(gs0) lpattern(solid)) ///
(scatter mean_`var2'2010 n, mcolor(gs12) ms(+) msize(large)) ///
(scatter mean_`var2'2016 n, mcolor(gs6) ms(+) msize(large)) ///
(scatter mean_`var2'2020 n, mcolor(gs0) ms(+) msize(large)) ///
, ///
ytitle("Total loan amount (INR 10k)") xtitle("Percentile") ///
xlab(0(20)100) xmtick(0(10)100) ///
ylab(0(10)60) ymtick(0(5)60) ///
title("Total") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") col(3) pos(6)) ///
name(debt, replace)
restore



* Dalits
preserve
keep if caste2==1
keep HHID_panel $time $var
reshape wide $var, i($id) j($time)
foreach x in $var {
foreach t in 2010 2016 2020 {
pctile `x'`t'_p=`x'`t', n(50)
egen mean_`x'`t'=mean(`x'`t')
drop `x'`t'
}
}
drop $id
gen n=_n*2
drop if n>100
foreach x in $var {
foreach t in 2010 2016 2020 {
gen error`t'=`x'`t'_p-mean_`x'`t'
gen diff`t'=abs(error`t')
egen mindiff`t'=min(diff`t')
replace mean_`x'`t'=. if mindiff`t'!=diff`t'
replace error`t'=. if mindiff`t'!=diff`t'
replace mean_`x'`t'=mean_`x'`t'+error`t'
drop mindiff`t' diff`t'
}
}
local var2="$var"
twoway ///
(line `var2'2010_p n if n<96, lcolor(gs12) lpattern(solid)) ///
(line `var2'2016_p n if n<96, lcolor(gs6) lpattern(solid)) ///
(line `var2'2020_p n if n<96, lcolor(gs0) lpattern(solid)) ///
(scatter mean_`var2'2010 n, mcolor(gs12) ms(+) msize(large)) ///
(scatter mean_`var2'2016 n, mcolor(gs6) ms(+) msize(large)) ///
(scatter mean_`var2'2020 n, mcolor(gs0) ms(+) msize(large)) ///
, ///
ytitle("Total loan amount (INR 10k)") xtitle("Percentile") ///
xlab(0(20)100) xmtick(0(10)100) ///
ylab(0(10)60) ymtick(0(5)60) ///
title("Dalits") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") col(3) pos(6)) ///
name(debt_c1, replace)
restore



* Non-Dalits
preserve
keep if caste2==2
keep HHID_panel $time $var
reshape wide $var, i($id) j($time)
foreach x in $var {
foreach t in 2010 2016 2020 {
pctile `x'`t'_p=`x'`t', n(50)
egen mean_`x'`t'=mean(`x'`t')
drop `x'`t'
}
}
drop $id
gen n=_n*2
drop if n>100
foreach x in $var {
foreach t in 2010 2016 2020 {
gen error`t'=`x'`t'_p-mean_`x'`t'
gen diff`t'=abs(error`t')
egen mindiff`t'=min(diff`t')
replace mean_`x'`t'=. if mindiff`t'!=diff`t'
replace error`t'=. if mindiff`t'!=diff`t'
replace mean_`x'`t'=mean_`x'`t'+error`t'
drop mindiff`t' diff`t'
}
}
local var2="$var"
twoway ///
(line `var2'2010_p n if n<96, lcolor(gs12) lpattern(solid)) ///
(line `var2'2016_p n if n<96, lcolor(gs6) lpattern(solid)) ///
(line `var2'2020_p n if n<96, lcolor(gs0) lpattern(solid)) ///
(scatter mean_`var2'2010 n, mcolor(gs12) ms(+) msize(large)) ///
(scatter mean_`var2'2016 n, mcolor(gs6) ms(+) msize(large)) ///
(scatter mean_`var2'2020 n, mcolor(gs0) ms(+) msize(large)) ///
, ///
ytitle("Total loan amount (INR 10k)") xtitle("Percentile") ///
xlab(0(20)100) xmtick(0(10)100) ///
ylab(0(10)60) ymtick(0(5)60) ///
title("Non-Dalits") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") col(3) pos(6)) ///
name(debt_c2, replace)
restore

* Combine
grc1leg debt debt_c1 debt_c2, col(3) note("+ represent the mean.") name(debt_comb, replace)
graph export "Debt_comb.pdf", as(pdf) replace







*** Graph 2: DIR
tabstat dir if year==2010, stat(n mean cv q) by(caste)
tabstat dir if year==2016, stat(n mean cv q) by(caste)
tabstat dir if year==2020, stat(n mean cv q) by(caste)


****************************************
* END

























****************************************
* Debt: formel
****************************************
cls
use"panel_v0", clear



*** Recourse to formal debt
gen dummyformal=.
replace dummyformal=0 if totHH_lendercatamt_form!=.
replace dummyformal=1 if totHH_lendercatamt_form!=. & totHH_lendercatamt_form>0
ta dummyformal

*** Rescale
ta totHH_lendercatamt_form
replace totHH_lendercatamt_form=totHH_lendercatamt_form/10000
replace totHH_lendercatamt_form=. if dummyformal==0
replace totHH_lendercatamt_form=. if dummyformal==.


*** Stat
ta dummyformal year, col nofreq
ta dummyformal year if caste2==1, col nofreq
ta dummyformal year if caste2==2, col nofreq

tabstat totHH_lendercatamt_form, stat(mean cv p50) by(year)
tabstat totHH_lendercatamt_form if caste2==1, stat(mean cv p50) by(year)
tabstat totHH_lendercatamt_form if caste2==2, stat(mean cv p50) by(year)


*** Collapse for graph
preserve
collapse (mean) dummyformal totHH_lendercatamt_form, by(time)
twoway ///
(bar dummyformal time, yaxis(1) barwidth(.5)) ///
(connected totHH_lendercatamt_form time, yaxis(2)) ///
, ///
ylabel(0(.1).8, axis(1)) ///
ylabel(0(2)12, axis(2)) ///
ytitle("Share of household formally indebted", axis(1)) ///
ytitle("Average amount of formal debt (INR 10k)", axis(2)) ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ///
xtitle("") ///
legend(order(1 "Share of household formally indebted" 2 "Average amount of formal debt (INR 10k)") pos(6) col(2)) ///
title("Total") ///
aspectratio(2) name(debtfo, replace)
restore

*** By caste
preserve
collapse (mean) dummyformal totHH_lendercatamt_form, by(caste2 time)

* Dalits
twoway ///
(bar dummyformal time if caste2==1, yaxis(1) barwidth(.5)) ///
(connected totHH_lendercatamt_form time if caste2==1, yaxis(2)) ///
, ///
ylabel(0(.1).8, axis(1)) ///
ylabel(0(2)12, axis(2)) ///
ytitle("Share of household formally indebted", axis(1)) ///
ytitle("Average amount of formal debt (INR 10k)", axis(2)) ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ///
xtitle("") ///
legend(order(1 "Share of household formally indebted" 2 "Average amount of formal debt (INR 10k)") pos(6) col(2)) ///
title("Dalits") ///
aspectratio(2) name(debtfo_c1, replace)

* Non-Dalits
twoway ///
(bar dummyformal time if caste2==2, yaxis(1) barwidth(.5)) ///
(connected totHH_lendercatamt_form time if caste2==2, yaxis(2)) ///
, ///
ylabel(0(.1).8, axis(1)) ///
ylabel(0(2)12, axis(2)) ///
ytitle("Share of household formally indebted", axis(1)) ///
ytitle("Average amount of formal debt (INR 10k)", axis(2)) ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ///
xtitle("") ///
legend(order(1 "Share of household formally indebted" 2 "Average amount of formal debt (INR 10k)") pos(6) col(2)) ///
title("Non-Dalits") ///
aspectratio(2) name(debtfo_c2, replace)
restore

*** Combine
grc1leg debtfo debtfo_c1 debtfo_c2, col(3) name(agri_comb, replace)
graph export "Formal_comb.pdf", as(pdf) replace


****************************************
* END









****************************************
* MOC indiv level
****************************************
cls
use"panel_indiv_v0", clear

********** Initialization
ta year
ta age
drop if age<15
ta age working_pop
ta sex year
fre sex
ta mainocc_occupation_indiv working_pop, m

replace annualincome_indiv=annualincome_indiv/1000
replace mainocc_annualincome_indiv=mainocc_annualincome_indiv/1000



********** Working pop
ta working_pop year, col nofreq
ta working_pop year if sex==1, col nofreq
ta working_pop year if sex==2, col nofreq

*** 
ta working_pop, gen(perc)

* Total
preserve
collapse (mean) perc*, by(year)
reshape long perc, i(year) j(wp)
label define wp 1"Inactive" 2"Act. unocc." 3"Act. occ."
label values wp wp
graph bar perc, stack over(wp, lab(angle(45))) over(year, lab(angle(90))) ///
asy ytitle("%") title("Total") legend(col(3) pos(6)) ///
ylab(0(.1)1) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(wp, replace)
restore

* Male
preserve
keep if sex==1
collapse (mean) perc*, by(year)
reshape long perc, i(year) j(wp)
label define wp 1"Inactive" 2"Act. unocc." 3"Act. occ."
label values wp wp
graph bar perc, stack over(wp, lab(angle(45))) over(year, lab(angle(90))) ///
asy ytitle("%") title("Male") legend(col(3) pos(6)) ///
ylab(0(.1)1) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(wp_c1, replace)
restore


* Female
preserve
keep if sex==2
collapse (mean) perc*, by(year)
reshape long perc, i(year) j(wp)
label define wp 1"Inactive" 2"Act. unocc." 3"Act. occ."
label values wp wp
graph bar perc, stack over(wp, lab(angle(45))) over(year, lab(angle(90))) ///
asy ytitle("%") title("Female") legend(col(3) pos(6)) ///
ylab(0(.1)1) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(wp_c2, replace)
restore

*** Combine
grc1leg wp wp_c1 wp_c2, col(3) name(wp_comb, replace)
graph export "wp_comb.pdf", as(pdf) replace

*** Clean
drop perc1 perc2 perc3


********* Occupation
keep if working_pop==3
ta mainocc_occupation_indiv year, col nofreq
ta mainocc_occupation_indiv year if sex==1, col nofreq
ta mainocc_occupation_indiv year if sex==2, col nofreq

tabstat annualincome_indiv, stat(mean cv p50) by(year)
tabstat annualincome_indiv if sex==1, stat(mean cv p50) by(year)
tabstat annualincome_indiv if sex==2, stat(mean cv p50) by(year)

*** Graph bar
fre mainocc_occupation_indiv
recode mainocc_occupation_indiv (5=4)
ta mainocc_occupation_indiv, gen(perc)

* Total
preserve
collapse (mean) perc*, by(year)
reshape long perc, i(year) j(occ)
label define occupcode 1"Agri SE" 2"Agri casual" 3"Casual" 4"Regular" 5"SE" 6"NREGA", modify
label values occ occupcode
graph bar perc, over(year, lab(angle(90))) over(occ, lab(angle(45))) ///
asy ytitle("%") title("Total") legend(col(3) pos(6)) ///
ylab(0(.1).6) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(occ, replace)
restore

* Male
preserve
keep if sex==1
collapse (mean) perc*, by(year)
reshape long perc, i(year) j(occ)
label define occupcode 1"Agri SE" 2"Agri casual" 3"Casual" 4"Regular" 5"SE" 6"NREGA", modify
label values occ occupcode
graph bar perc, over(year, lab(angle(90))) over(occ, lab(angle(45))) ///
asy ytitle("%") title("Male") legend(col(3) pos(6)) ///
ylab(0(.1).6) ///
name(occ_c1, replace)
restore

* Female
preserve
keep if sex==2
collapse (mean) perc*, by(year)
reshape long perc, i(year) j(occ)
label define occupcode 1"Agri SE" 2"Agri casual" 3"Casual" 4"Regular" 5"SE" 6"NREGA", modify
label values occ occupcode
graph bar perc, over(year, lab(angle(90))) over(occ, lab(angle(45))) ///
asy ytitle("%") title("Female") legend(col(3) pos(6)) ///
ylab(0(.1).6) ///
name(occ_c2, replace)
restore

*** Combine
grc1leg occ occ_c1 occ_c2, col(3) name(occ_comb, replace)
graph export "Occ_comb.pdf", as(pdf) replace


****************************************
* END











****************************************
* Stat Isabelle sur emploi agri et non-agri
****************************************
cls
use"panel_v0", clear


*** Test
gen test1=annualincome_HH-incomeagri_HH-incomenonagri_HH
gen test2=1-shareincomeagri_HH-shareincomenonagri_HH

tab1 test1 test2
drop test1 test2

*** Stat Isabelle
replace annualincome_HH=annualincome_HH/1000
replace incomenonagri_HH=incomenonagri_HH/1000
replace incomeagri_HH=incomeagri_HH/1000

fsum annualincome_HH incomeagri_HH incomenonagri_HH shareincomeagri_HH shareincomenonagri_HH if year==2010, stat(n mean sd p25 p50 p75)
fsum annualincome_HH incomeagri_HH incomenonagri_HH shareincomeagri_HH shareincomenonagri_HH if year==2016, stat(n mean sd p25 p50 p75)
fsum annualincome_HH incomeagri_HH incomenonagri_HH shareincomeagri_HH shareincomenonagri_HH if year==2020, stat(n mean sd p25 p50 p75)

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
