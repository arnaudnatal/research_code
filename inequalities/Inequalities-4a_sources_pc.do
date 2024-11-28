*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 8, 2024
*-----
gl link = "inequalities"
*Desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\inequalities.do"
*-------------------------









****************************************
* Compo income
****************************************
use"panel_v3", clear


* Decile
foreach i in 2010 2016 2020 {
xtile incgrp`i'=annualincome_pc if year==`i', n(10)
}
gen incgroup=.
foreach i in 2010 2016 2020 {
replace incgroup=incgrp`i' if year==`i'
drop incgrp`i' 
}
rename monthlyincome_pc income_pc

collapse (mean) s_agrise_pc s_agrica_pc s_casual_pc s_regula_pc s_selfem_pc s_mgnreg_pc s_pensio_pc s_remitt_pc income_pc, by(time incgroup)

gen sum1=s_agrise_pc
gen sum2=sum1+s_agrica_pc
gen sum3=sum2+s_casual_pc
gen sum4=sum3+s_regula_pc
gen sum5=sum4+s_selfem_pc
gen sum6=sum5+s_mgnreg_pc
gen sum7=sum6+s_pensio_pc
gen sum8=sum7+s_remitt_pc

*** Line for appendix
ta income
twoway ///
(connected income_pc incgroup if time==1) ///
(connected income_pc incgroup if time==2) ///
(connected income_pc incgroup if time==3) ///
, ///
title("Average monthly income per capita") ///
xlabel(1(1)10) xtitle("Decile of income") ///
ylabel(0(2)14) ytitle("1k rupees") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) ///
name(lineinc, replace) scale(1.2)

* By year
twoway ///
(area sum1 incgroup if time==1) ///
(rarea sum1 sum2 incgroup if time==1) ///
(rarea sum2 sum3 incgroup if time==1) ///
(rarea sum3 sum4 incgroup if time==1) ///
(rarea sum4 sum5 incgroup if time==1) ///
(rarea sum5 sum6 incgroup if time==1) ///
(rarea sum6 sum7 incgroup if time==1) ///
(rarea sum7 sum8 incgroup if time==1) ///
, ///
xlabel(1(1)10) xtitle("Decile of monthly income per capita") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2010") ///
legend(order(1 "Agri self-emp" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA" 7 "Pension" 8 "Remittances") pos(6) col(4)) ///
name(compo1, replace) scale(1.2)

twoway ///
(area sum1 incgroup if time==2) ///
(rarea sum1 sum2 incgroup if time==2) ///
(rarea sum2 sum3 incgroup if time==2) ///
(rarea sum3 sum4 incgroup if time==2) ///
(rarea sum4 sum5 incgroup if time==2) ///
(rarea sum5 sum6 incgroup if time==2) ///
(rarea sum6 sum7 incgroup if time==2) ///
(rarea sum7 sum8 incgroup if time==2) ///
, ///
xlabel(1(1)10) xtitle("Decile of monthly income per capita") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2016-17") ///
legend(order(1 "Agri self-emp" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA" 7 "Pension" 8 "Remittances") pos(6) col(4)) ///
name(compo2, replace) scale(1.2)

twoway ///
(area sum1 incgroup if time==3) ///
(rarea sum1 sum2 incgroup if time==3) ///
(rarea sum2 sum3 incgroup if time==3) ///
(rarea sum3 sum4 incgroup if time==3) ///
(rarea sum4 sum5 incgroup if time==3) ///
(rarea sum5 sum6 incgroup if time==3) ///
(rarea sum6 sum7 incgroup if time==3) ///
(rarea sum7 sum8 incgroup if time==3) ///
, ///
xlabel(1(1)10) xtitle("Decile of monthly income per capita") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2020-21") ///
legend(order(1 "Agri self-emp" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA" 7 "Pension" 8 "Remittances") pos(6) col(4)) ///
name(compo3, replace) scale(1.2)


grc1leg compo1 compo2 compo3, col(3) name(inc, replace)
graph export "graph_pc/Compo_income_pc.png", as(png) replace

****************************************
* END

















****************************************
* Compo assets
****************************************
use"panel_v3", clear

* Decile
foreach i in 2010 2016 2020 {
xtile assgrp`i'=assets_total_pc if year==`i', n(10)
}
gen assgroup=.
foreach i in 2010 2016 2020 {
replace assgroup=assgrp`i' if year==`i'
drop assgrp`i' 
}
rename assets_total_pc assets_pc

collapse (mean) s_house_pc s_livestock_pc s_goods_pc s_land_pc s_gold_pc s_savings_pc assets_pc, by(time assgroup)

gen sum1=s_house_pc
gen sum2=sum1+s_livestock_pc
gen sum3=sum2+s_goods_pc
gen sum4=sum3+s_land_pc
gen sum5=sum4+s_gold_pc
gen sum6=sum5+s_savings_pc

*** Line for appendix
ta assets_pc
twoway ///
(connected assets_pc assgroup if time==1) ///
(connected assets_pc assgroup if time==2) ///
(connected assets_pc assgroup if time==3) ///
, ///
title("Average wealth per capita") ///
xlabel(1(1)10) xtitle("Decile of wealth per capita") ///
ylabel(0(500)2500) ytitle("1k rupees") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) ///
name(lineass, replace) scale(1.2)

* Graph combine
grc1leg lineinc lineass, name(comb, replace)
graph export "graph_pc/Levelbydecile_pc.png", as(png) replace



* By year
twoway ///
(area sum1 assgroup if time==1) ///
(rarea sum1 sum2 assgroup if time==1) ///
(rarea sum2 sum3 assgroup if time==1) ///
(rarea sum3 sum4 assgroup if time==1) ///
(rarea sum4 sum5 assgroup if time==1) ///
(rarea sum5 sum6 assgroup if time==1) ///
, ///
xlabel(1(1)10) xtitle("Decile of wealth per capita") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2010") ///
legend(order(1 "House" 2 "Livestock" 3 "Durable goods" 4 "Land" 5 "Gold" 6 "Saving") pos(6) col(3)) ///
name(compo1, replace) scale(1.2)

twoway ///
(area sum1 assgroup if time==2) ///
(rarea sum1 sum2 assgroup if time==2) ///
(rarea sum2 sum3 assgroup if time==2) ///
(rarea sum3 sum4 assgroup if time==2) ///
(rarea sum4 sum5 assgroup if time==2) ///
(rarea sum5 sum6 assgroup if time==2) ///
, ///
xlabel(1(1)10) xtitle("Decile of wealth per capita") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2016-17") ///
legend(order(1 "House" 2 "Livestock" 3 "Durable goods" 4 "Land" 5 "Gold" 6 "Saving") pos(6) col(3)) ///
name(compo2, replace) scale(1.2)

twoway ///
(area sum1 assgroup if time==3) ///
(rarea sum1 sum2 assgroup if time==3) ///
(rarea sum2 sum3 assgroup if time==3) ///
(rarea sum3 sum4 assgroup if time==3) ///
(rarea sum4 sum5 assgroup if time==3) ///
(rarea sum5 sum6 assgroup if time==3) ///
, ///
xlabel(1(1)10) xtitle("Decile of wealth per capita") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2020-21") ///
legend(order(1 "House" 2 "Livestock" 3 "Durable goods" 4 "Land" 5 "Gold" 6 "Saving") pos(6) col(3)) ///
name(compo3, replace) scale(1.2)


grc1leg compo1 compo2 compo3, col(3) name(compo, replace)
graph export "graph_pc/Compo_assets_pc.png", as(png) replace

****************************************
* END



















****************************************
* Gini decomposition
****************************************

********** Income
use"panel_v3", clear

global PC annualincome_pc agrise_pc agrica_pc casual_pc regula_pc selfem_pc mgnreg_pc pensio_pc remitt_pc

descogini $PC if year==2010
descogini $PC if year==2016
descogini $PC if year==2020


***** Graph
import excel "Gini.xlsx", sheet("Income") firstrow clear
label define occupation 1"Agri self" 2"Agri casual" 3"Casual" 4"Regular" 5"Self-emp" 6"MGNREGA" 7"Pensions" 8"Remitt"
label values occupation occupation

* Percentage
twoway ///
(line Percentage year if occupation==1, color(black)) ///
(line Percentage year if occupation==2, color(plr1)) ///
(line Percentage year if occupation==3, color(ply1)) ///
(line Percentage year if occupation==4, color(plg1)) ///
(line Percentage year if occupation==5, color(plb1)) ///
(line Percentage year if occupation==6, color(pll1)) ///
(line Percentage year if occupation==7, color(gs10)) ///
(line Percentage year if occupation==8, color(black) lpattern(shortdash)) ///
, title("Monthly income per capita") ylabel(-.2(.1).2) ///
xtitle("") xlabel(2010(2)2020) ///
ytitle("Percent") ///
legend(order(1 "Agri self" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-emp" 6 "MGNREGA" 7 "Pension" 8 "Remitt") pos(6) col(3)) name(inc, replace) scale(1.2)








********** Assets
use"panel_v3", clear

global assets assets_total_pc house_pc livestock_pc goods_pc land_pc gold_pc savings_pc

descogini $assets if year==2010
descogini $assets if year==2016
descogini $assets if year==2020

***** Graph
import excel "Gini.xlsx", sheet("Wealth") firstrow clear
label define assets 1"House" 2"Livestock" 3"Durable goods" 4"Land" 5"Gold" 6"Saving"
label values assets assets

* Percentage
twoway ///
(line Percentage year if assets==1, color(black)) ///
(line Percentage year if assets==2, color(plr1)) ///
(line Percentage year if assets==3, color(ply1)) ///
(line Percentage year if assets==4, color(plg1)) ///
(line Percentage year if assets==5, color(plb1)) ///
(line Percentage year if assets==6, color(pll1)) ///
, title("Wealth per capita") ylabel(-.2(.1).2) ///
xtitle("") xlabel(2010(2)2020) ///
ytitle("Percent") ///
legend(order(1 "House" 2 "Livestock" 3 "Durable goods" 4 "Land" 5 "Gold" 6 "Saving") pos(6) col(2)) name(ass, replace) scale(1.2)


********** Combine graph
graph combine inc ass, col(2) title("Percent change in Gini") note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 625 in 2020-21.", size(vsmall))
graph export "graph_pc/DecompoGini_pc.png", as(png) replace

****************************************
* END
