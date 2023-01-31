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

* Caste
preserve
keep HHID_panel year caste jatiscorr
reshape wide caste jatiscorr, i(HHID_panel) j(year)
ta caste2010 caste2016
ta caste2016 caste2020
ta jatiscorr2010 jatiscorr2016
ta jatiscorr2016 jatiscorr2020
restore

* Quanti
tabstat HHsize sexratio dependencyratio nonworkersratio, stat(n mean) by(year) long

* Quali
ta typeoffamily tof
ta tof year, col nofreq


* Head
ta head_sex year, col nofreq
tabstat head_age, stat(n mean) by(year)

fre head_edulevel
recode head_edulevel (5=2) (4=2) (3=2)
ta head_edulevel year, col nofreq



****************************************
* END









****************************************
* Agri
****************************************
use"panel_v0", clear


*** % of land owner?
ta ownland year, col nofreq


*** Size of land
tabstat sizeownland, stat(n mean p50) by(year)
/*
    year |         N      mean       p50
---------+------------------------------
    2010 |       220  1.935591       1.5
    2016 |       154  2.431916         1
    2020 |       219  2.038584         1
---------+------------------------------
   Total |       593  2.102521         1
----------------------------------------
*/


*** Collapse for graph
collapse (mean) ownland sizeownland, by(time)
/*
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
legend(order(1 "Share of land owner" 2 "Average land size (ha)") pos(6) col(1)) ///
aspectratio(1) name(agri, replace)
graph export "Agri.pdf", as(pdf) replace
*/


****************************************
* END









****************************************
* Wealth
****************************************
use"panel_v0", clear

*** Rescale
replace assets_total=assets_total/10000
replace assets_totalnoland=assets_totalnoland/10000


*** Stat
tabstat assets_total, stat(mean cv p1 p5 p10 q p90 p95 p99) by(year)
tabstat assets_totalnoland, stat(mean cv p1 p5 p10 q p90 p95 p99) by(year)

*** Graph 1: Stripplot
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
*/

*** Graph 2: Line
global var assets_totalnoland
global time year
global id HHID_panel
/*
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
xlab(0(10)100) xmtick(0(5)100) ///
ylab(0(10)80) ymtick(0(5)80) ///
note("+ represent the mean.") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") col(3) pos(6)) ///
name(wealth2, replace)
graph export "Wealth2.pdf", as(pdf) replace
restore
*/


****************************************
* END










****************************************
* Employment
****************************************
use"panel_v0", clear




****************************************
* END








****************************************
* Debt
****************************************
use"panel_v0", clear




****************************************
* END
