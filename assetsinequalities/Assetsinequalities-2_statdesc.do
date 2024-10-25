*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*September 9, 2024
*-----
gl link = "assetsinequalities"
*Desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\assetsinequalities.do"
*-------------------------












****************************************
* Assets and IQR 
****************************************
use"panel_v1", clear

tabstat assets_total, stat(n mean q p90 p95 p99) by(year)

violinplot assets_total, over(time) horizontal left dscale(4) noline now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
title("Total value of assets") ///
xtitle("1k rupees") xlabel(0(1000)7000) ///
ylabel(,grid) ///
legend(order(4 "IQR" 7 "Median" 10 "Mean") pos(6) col(3) on) ///
note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 626 in 2020-21.", size(vsmall)) ///
aspectratio() scale(1.2) name(vio, replace) range(0 7000)

graph export "Violin.png", as(png) replace

****************************************
* END











****************************************
* Ineq Assets
****************************************

***** Decile
use"panel_v1", clear

foreach i in 2010 2016 2020 {
xtile assets_total`i'=assets_total if year==`i', n(10)
}
gen assgroup=.
foreach i in 2010 2016 2020 {
replace assgroup=assets_total`i' if year==`i'
drop assets_total`i' 
}

collapse (sum) assets_total, by(year assgroup)
bysort year: egen totassets=sum(assets_total)
gen shareass= assets_total*100/totassets

twoway ///
(connected shareass assgroup if year==2010) ///
(connected shareass assgroup if year==2016) ///
(connected shareass assgroup if year==2020) ///
, title("Share of total assets by decile") ///
ytitle("Percent") ylabel(0(5)55) ///
xtitle("Decile of assets") xlabel(1(1)10) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) name(decile, replace) scale(1.2)


***** Lorenz curves
use"panel_v1", clear

keep HHID_panel year assets_total
reshape wide assets_total, i(HHID_panel) j(year)
lorenz estimate assets_total2010 assets_total2016 assets_total2020, gini
lorenz graph, overlay noci legend(pos(6) col(3) order(1 "2010" 2 "2016-17" 3 "2020-21")) xtitle("Population share") ytitle("Cumulative assets proportion") title("Lorenz curves") xlabel(0(10)100) ylabel(0(.1)1) nodiagonal aspectratio() scale(1.2) name(lorenz, replace)


***** Combine
grc1leg decile lorenz, name(comb3, replace) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 626 in 2020-21. The Gini index is 0.580 in 2010, 0.660 in 2016-17 and 0.612 in 2020-21.", size(vsmall)) leg(lorenz)
graph export "IneqAss.png", as(png) replace


****************************************
* END




















****************************************
* Social mobility
****************************************
use"panel_v1", clear

keep HHID_panel year assets_total caste
rename assets_total assets

reshape wide assets, i(HHID_panel) j(year)

foreach x in 2010 2016 2020 {
xtile cent`x'=assets`x', n(100)
xtile vingt`x'=assets`x', n(20)
xtile dec`x'=assets`x', n(10)
xtile quint`x'=assets`x', n(5)
}



* Diff abs for stat
/*
On considère que plus ou moins 20000 roupies c'est identique.
*/
tabstat assets2010 assets2016 assets2020, stat(n sd mean q)

gen diff1=assets2016-assets2010
gen absdiff1=abs(diff1)
gen catdiff1=.
label define catdiff1 1"Downward" 2"Immobility" 3"Upward"
label values catdiff1 catdiff1
replace catdiff1=1 if diff1<-20 & diff1!=.
replace catdiff1=2 if diff1>=-20 & diff1<=20 & diff1!=.
replace catdiff1=3 if diff1>20 & diff1!=.
drop diff1

gen diff2=assets2020-assets2016
gen absdiff2=abs(diff2)
gen catdiff2=.
label define catdiff2 1"Downward" 2"Immobility" 3"Upward"
label values catdiff2 catdiff2
replace catdiff2=1 if diff2<-20 & diff2!=.
replace catdiff2=2 if diff2>=-20 & diff2<=20 & diff2!=.
replace catdiff2=3 if diff2>20 & diff2!=.
drop diff2




* Diff vingtile for stat
gen diffv1=vingt2016-vingt2010
gen absdiffv1=abs(diffv1)
gen catdiffv1=.
label define catdiffv1 1"Downward" 2"Immobility" 3"Upward"
label values catdiffv1 catdiffv1
replace catdiffv1=1 if diffv1<0 & diffv1!=.
replace catdiffv1=2 if diffv1==0 & diffv1!=.
replace catdiffv1=3 if diffv1>0 & diffv1!=.
drop diffv1

gen diffv2=vingt2020-vingt2016
gen absdiffv2=abs(diffv2)
gen catdiffv2=.
label define catdiffv2 1"Downward" 2"Immobility" 3"Upward"
label values catdiffv2 catdiffv2
replace catdiffv2=1 if diffv2<0 & diffv2!=.
replace catdiffv2=2 if diffv2==0 & diffv2!=.
replace catdiffv2=3 if diffv2>0 & diffv2!=.
drop diffv2





********** 2010 - 2016
* Stat
pwcorr assets2016 assets2010, sig
spearman assets2016 assets2010, stats(rho p)
ta catdiff1
ta catdiffv1
tabstat absdiffv1, stat(n mean) by(catdiffv1)

* Graph income
tabstat assets2016 assets2010, stat(p75 p90 p95 p99 max)
twoway ///
(scatter assets2016 assets2010 if assets2016<7000 & assets2010<7000, color(black%30)) ///
(function y=x, range(0 7000)) ///
, xtitle("Wealth per household in 2010 (1k rupees)") ///
ytitle("Wealth per household in 2016-17 (1k rupees)") ///
xlabel(0(1000)7000) ylabel(0(1000)7000) ///
scale(1.2) legend(off) name(g1, replace)

* Graph centiles
twoway ///
(scatter cent2016 cent2010, color(black%30)) ///
(function y=x, range(0 100)) ///
, xtitle("Percentile of wealth per household in 2010") ///
ytitle("Percentile of wealth per household in 2016-17") ///
scale(1.2) legend(off) name(g2, replace)

* Combine
graph combine g1 g2, name(comb1, replace) note("{it:Note:} For 388 households.", size(vsmall))
graph export "socmob1.png", as(png) replace



********** 2016 - 2020
* Stat
pwcorr assets2020 assets2016, sig
spearman assets2020 assets2016, stats(rho p)
ta catdiff2
ta catdiffv2
tabstat absdiffv2, stat(n mean) by(catdiffv2)

* Graph income
twoway ///
(scatter assets2020 assets2016 if assets2020<7000 & assets2016<7000, color(black%30)) ///
(function y=x, range(0 7000)) ///
, xtitle("Wealth per household in 2016-17 (1k rupees)") ///
ytitle("Wealth per household in 2020-21 (1k rupees)") ///
xlabel(0(1000)7000) ylabel(0(1000)7000) ///
scale(1.2) legend(off) name(g3, replace)

* Graph centiles
twoway ///
(scatter cent2020 cent2016, color(black%30)) ///
(function y=x, range(0 100)) ///
, xtitle("Percentile of wealth per household in 2016-17") ///
ytitle("Percentile of wealth per household in 2020-21") ///
scale(1.2) legend(off) name(g4, replace)

* Combine
graph combine g3 g4, name(comb2, replace) note("{it:Note:} For 485 households.", size(vsmall)) 
graph export "socmob2.png", as(png) replace


****************************************
* END

















****************************************
* Wealth ownership
****************************************
use"panel_v1", clear

* Collapse
global var dum_house dum_livestock dum_goods dum_land dum_gold dum_savings
recode $var (.=0)
collapse (mean) $var, by(time)
foreach x in $var {
replace `x'=`x'*100
}

rename dum_house share1
rename dum_livestock share2
rename dum_goods share3
rename dum_land share4
rename dum_gold share5
rename dum_savings share6

* Reshape
reshape long share, i(time) j(cat)
label define cat 1"House" 2"Livestock" 3"Durable goods" 4"Land" 5"Gold" 6"Savings"
label values cat cat

* Reshape 2
reshape wide share, i(cat) j(time)

* Graph 
graph bar share1 share2 share3, over(cat, label(angle(45))) title("") ytitle("Percent") legend(order(1 "2010" 2 "2016-17" 3 "2020-21") col(3) pos(6)) name(g1, replace) ylabel(0(10)100)
graph export "Wealthdum.png", as(png) replace


****************************************
* END
















****************************************
* Compo assets by decile for each year
****************************************
use"panel_v1", clear

* Decile
foreach i in 2010 2016 2020 {
xtile assgrp`i'=assets_total if year==`i', n(10)
}
gen assgroup=.
foreach i in 2010 2016 2020 {
replace assgroup=assgrp`i' if year==`i'
drop assgrp`i' 
}

collapse (mean) s_house s_livestock s_goods s_land s_gold s_savings, by(time assgroup)

gen sum1=s_house
gen sum2=sum1+s_livestock
gen sum3=sum2+s_goods
gen sum4=sum3+s_land
gen sum5=sum4+s_gold
gen sum6=sum5+s_savings

* By year
twoway ///
(area sum1 assgroup if time==1) ///
(rarea sum1 sum2 assgroup if time==1) ///
(rarea sum2 sum3 assgroup if time==1) ///
(rarea sum3 sum4 assgroup if time==1) ///
(rarea sum4 sum5 assgroup if time==1) ///
(rarea sum5 sum6 assgroup if time==1) ///
, ///
xlabel(1(1)10) xtitle("Decile of assets") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2010") ///
legend(order(1 "House" 2 "Livestock" 3 "Durable goods" 4 "Land" 5 "Gold" 6 "Saving") pos(6) col(3)) ///
name(compo1, replace)

twoway ///
(area sum1 assgroup if time==2) ///
(rarea sum1 sum2 assgroup if time==2) ///
(rarea sum2 sum3 assgroup if time==2) ///
(rarea sum3 sum4 assgroup if time==2) ///
(rarea sum4 sum5 assgroup if time==2) ///
(rarea sum5 sum6 assgroup if time==2) ///
, ///
xlabel(1(1)10) xtitle("Decile of assets") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2016-17") ///
legend(order(1 "House" 2 "Livestock" 3 "Durable goods" 4 "Land" 5 "Gold" 6 "Saving") pos(6) col(3)) ///
name(compo2, replace)

twoway ///
(area sum1 assgroup if time==3) ///
(rarea sum1 sum2 assgroup if time==3) ///
(rarea sum2 sum3 assgroup if time==3) ///
(rarea sum3 sum4 assgroup if time==3) ///
(rarea sum4 sum5 assgroup if time==3) ///
(rarea sum5 sum6 assgroup if time==3) ///
, ///
xlabel(1(1)10) xtitle("Decile of assets") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2020-21") ///
legend(order(1 "House" 2 "Livestock" 3 "Durable goods" 4 "Land" 5 "Gold" 6 "Saving") pos(6) col(3)) ///
name(compo3, replace)


grc1leg compo1 compo2 compo3, col(3) name(compo, replace)
graph export "Compositionassets.png", as(png) replace

****************************************
* END
















****************************************
* Gini decomposition
****************************************

***** Decomposition Gini by assets source
use"panel_v1", clear

global assets assets_total assets_house assets_livestock assets_goods assets_land assets_gold assets_savings

descogini $assets if year==2010
descogini $assets if year==2016
descogini $assets if year==2020

****************************************
* END

