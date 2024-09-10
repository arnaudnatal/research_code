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

tabstat assets_total, stat(n mean q iqr) by(year)

violinplot assets_total, over(time) horizontal left dscale(4) noline now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
title("Total value of assets") ///
xtitle("1k rupees") xlabel(0(500)4000) ///
ylabel(,grid) ///
legend(order(4 "IQR" 7 "Median" 10 "Mean") pos(6) col(3) on) ///
note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 626 in 2020-21.", size(vsmall)) ///
aspectratio() scale(1.2) name(vio, replace) range(0 4000)

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
* Gini decomposition
****************************************

***** Decomposition Gini by assets source
use"panel_v1", clear

global assets assets_total assets_house assets_livestock assets_goods assets_land assets_gold assets_savings

descogini $assets if year==2010
descogini $assets if year==2016
descogini $assets if year==2020


***** Graph
import excel "Gini.xlsx", sheet("Sheet1") firstrow clear
label define assets 1"House" 2"Livestock" 3"Durable goods" 4"Land" 5"Gold" 6"Saving"
label values assets assets

* Sk
twoway ///
(connected Sk year if assets==1, color(black)) ///
(connected Sk year if assets==2, color(plr1)) ///
(connected Sk year if assets==3, color(ply1)) ///
(connected Sk year if assets==4, color(plg1)) ///
(connected Sk year if assets==5, color(plb1)) ///
(connected Sk year if assets==6, color(pll1)) ///
, title("Share in total income") ylabel(0(.1).8) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "House" 2 "Livestock" 3 "Durable goods" 4 "Land" 5 "Gold" 6 "Saving") pos(6) col(3)) name(sk, replace)

* Gk
twoway ///
(connected Gk year if assets==1, color(black)) ///
(connected Gk year if assets==2, color(plr1)) ///
(connected Gk year if assets==3, color(ply1)) ///
(connected Gk year if assets==4, color(plg1)) ///
(connected Gk year if assets==5, color(plb1)) ///
(connected Gk year if assets==6, color(pll1)) ///
,title("Income source Gini") ylabel(0.4(.1)1) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "House" 2 "Livestock" 3 "Durable goods" 4 "Land" 5 "Gold" 6 "Saving") pos(6) col(3)) name(gk, replace)

* Rk
twoway ///
(connected Rk year if assets==1, color(black)) ///
(connected Rk year if assets==2, color(plr1)) ///
(connected Rk year if assets==3, color(ply1)) ///
(connected Rk year if assets==4, color(plg1)) ///
(connected Rk year if assets==5, color(plb1)) ///
(connected Rk year if assets==6, color(pll1)) ///
, title("Gini correlation with income rankings") ylabel(0(.2)1) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "House" 2 "Livestock" 3 "Durable goods" 4 "Land" 5 "Gold" 6 "Saving") pos(6) col(3)) name(rk, replace)

* Share
replace Share=0 if Share<0
twoway ///
(connected Share year if assets==1, color(black)) ///
(connected Share year if assets==2, color(plr1)) ///
(connected Share year if assets==3, color(ply1)) ///
(connected Share year if assets==4, color(plg1)) ///
(connected Share year if assets==5, color(plb1)) ///
(connected Share year if assets==6, color(pll1)) ///
, title("Share in total-income inequality") ylabel(0(.1)1) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "House" 2 "Livestock" 3 "Durable goods" 4 "Land" 5 "Gold" 6 "Saving") pos(6) col(3)) name(share, replace)

* Percentage
twoway ///
(connected Percentage year if assets==1, color(black)) ///
(connected Percentage year if assets==2, color(plr1)) ///
(connected Percentage year if assets==3, color(ply1)) ///
(connected Percentage year if assets==4, color(plg1)) ///
(connected Percentage year if assets==5, color(plb1)) ///
(connected Percentage year if assets==6, color(pll1)) ///
, title("Percent change in Gini") ylabel(-.2(.1).2) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "House" 2 "Livestock" 3 "Durable goods" 4 "Land" 5 "Gold" 6 "Saving") pos(6) col(3)) name(percentage, replace)

***** Combine
grc1leg sk gk rk share percentage, name(decompo, replace) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 626 in 2020-21.", size(vsmall))
graph export "Decompo.png", as(png) replace

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

