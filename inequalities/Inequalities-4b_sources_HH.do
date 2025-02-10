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
xtile incgrp`i'=annualincome if year==`i', n(10)
}
gen incgroup=.
foreach i in 2010 2016 2020 {
replace incgroup=incgrp`i' if year==`i'
drop incgrp`i' 
}
rename monthlyincome income

collapse (mean) s_agrise s_agrica s_casual s_regula s_selfem s_mgnreg s_pensio s_remitt income, by(time incgroup)

gen sum1=s_agrise
gen sum2=sum1+s_agrica
gen sum3=sum2+s_casual
gen sum4=sum3+s_regula
gen sum5=sum4+s_selfem
gen sum6=sum5+s_mgnreg
gen sum7=sum6+s_pensio
gen sum8=sum7+s_remitt

*** Line for appendix
ta income
twoway ///
(connected income incgroup if time==1) ///
(connected income incgroup if time==2) ///
(connected income incgroup if time==3) ///
, ///
title("Average monthly income") ///
xlabel(1(1)10) xtitle("Decile of monthly income") ///
ylabel(0(10)60) ytitle("1k rupees") ///
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
xlabel(1(1)10) xtitle("Decile of monthly income") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2010") ///
legend(order(1 "Agri self-emp" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA" 7 "Pension" 8 "Remittances") pos(6) col(4)) ///
name(compo1, replace)

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
xlabel(1(1)10) xtitle("Decile of monthly income") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2016-17") ///
legend(order(1 "Agri self-emp" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA" 7 "Pension" 8 "Remittances") pos(6) col(4)) ///
name(compo2, replace)

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
xlabel(1(1)10) xtitle("Decile of monthly income") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2020-21") ///
legend(order(1 "Agri self-emp" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA" 7 "Pension" 8 "Remittances") pos(6) col(4)) ///
name(compo3, replace)


grc1leg compo1 compo2 compo3, col(3) name(inc, replace)
graph export "graph_HH/Compo_income_HH.png", as(png) replace

****************************************
* END













****************************************
* Compo income FRENCH for MSH
****************************************
use"panel_v3", clear


* Decile
foreach i in 2010 2016 2020 {
xtile incgrp`i'=annualincome if year==`i', n(10)
}
gen incgroup=.
foreach i in 2010 2016 2020 {
replace incgroup=incgrp`i' if year==`i'
drop incgrp`i' 
}
rename monthlyincome income

collapse (mean) s_agrise s_agrica s_casual s_regula s_selfem s_mgnreg s_pensio s_remitt income, by(time incgroup)

gen sum1=s_agrise
gen sum2=sum1+s_agrica
gen sum3=sum2+s_casual
gen sum4=sum3+s_regula
gen sum5=sum4+s_selfem
gen sum6=sum5+s_mgnreg
gen sum7=sum6+s_pensio
gen sum8=sum7+s_remitt

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
xlabel(1(1)10) xtitle("Décile de revenu") ///
ylabel(0(10)100) ytitle("%") ///
title("2010") ///
legend(order(1 "Agr. indép." 2 "Agr. occas." 3 "Occas." 4 "Régul." 5 "Indép." 6 "NREGA" 7 "Retraite" 8 "Trans. de fonds") pos(6) col(4)) ///
name(compo1, replace)

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
xlabel(1(1)10) xtitle("Décile de revenu") ///
ylabel(0(10)100) ytitle("%") ///
title("2016-2017") ///
legend(order(1 "Agr. indép." 2 "Agr. occas." 3 "Occas." 4 "Régul." 5 "Indép." 6 "NREGA" 7 "Retraite" 8 "Trans. de fonds") pos(6) col(4)) ///
name(compo2, replace)

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
xlabel(1(1)10) xtitle("Décile de revenu") ///
ylabel(0(10)100) ytitle("%") ///
title("2020-21") ///
legend(order(1 "Agr. indép." 2 "Agr. occas." 3 "Occas." 4 "Régul." 5 "Indép." 6 "NREGA" 7 "Retraite" 8 "Trans. de fonds") pos(6) col(4)) ///
name(compo3, replace)


grc1leg compo1 compo2 compo3, col(3) name(inc, replace)
graph export "graph_HH/FR_Compo_income_HH.png", as(png) replace

****************************************
* END




























****************************************
* Compo assets
****************************************
use"panel_v3", clear

* Decile
foreach i in 2010 2016 2020 {
xtile assgrp`i'=assets_total if year==`i', n(10)
}
gen assgroup=.
foreach i in 2010 2016 2020 {
replace assgroup=assgrp`i' if year==`i'
drop assgrp`i' 
}
rename assets_total assets

collapse (mean) s_house s_livestock s_goods s_land s_gold s_savings assets, by(time assgroup)

gen sum1=s_house
gen sum2=sum1+s_livestock
gen sum3=sum2+s_goods
gen sum4=sum3+s_land
gen sum5=sum4+s_gold
gen sum6=sum5+s_savings

*** Line for appendix
ta assets
twoway ///
(connected assets assgroup if time==1) ///
(connected assets assgroup if time==2) ///
(connected assets assgroup if time==3) ///
, ///
title("Average wealth") ///
xlabel(1(1)10) xtitle("Decile of wealth") ///
ylabel(0(2000)10000) ytitle("1k rupees") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) ///
name(lineass, replace) scale(1.2)

* Graph combine
grc1leg lineinc lineass, name(comb, replace)
graph export "graph_HH/Levelbydecile_HH.png", as(png) replace



* By year
twoway ///
(area sum1 assgroup if time==1) ///
(rarea sum1 sum2 assgroup if time==1) ///
(rarea sum2 sum3 assgroup if time==1) ///
(rarea sum3 sum4 assgroup if time==1) ///
(rarea sum4 sum5 assgroup if time==1) ///
(rarea sum5 sum6 assgroup if time==1) ///
, ///
xlabel(1(1)10) xtitle("Decile of wealth") ///
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
xlabel(1(1)10) xtitle("Decile of wealth") ///
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
xlabel(1(1)10) xtitle("Decile of wealth") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2020-21") ///
legend(order(1 "House" 2 "Livestock" 3 "Durable goods" 4 "Land" 5 "Gold" 6 "Saving") pos(6) col(3)) ///
name(compo3, replace)


grc1leg compo1 compo2 compo3, col(3) name(compo, replace)
graph export "graph_HH/Compo_assets_HH.png", as(png) replace

****************************************
* END














****************************************
* Compo assets FRENCH for MSH
****************************************
use"panel_v3", clear

* Decile
foreach i in 2010 2016 2020 {
xtile assgrp`i'=assets_total if year==`i', n(10)
}
gen assgroup=.
foreach i in 2010 2016 2020 {
replace assgroup=assgrp`i' if year==`i'
drop assgrp`i' 
}
rename assets_total assets

collapse (mean) s_house s_livestock s_goods s_land s_gold s_savings assets, by(time assgroup)

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
xlabel(1(1)10) xtitle("Décile de patrimoine") ///
ylabel(0(10)100) ytitle("%") ///
title("2010") ///
legend(order(1 "Habitat" 2 "Bétail" 3 "Biens" 4 "Terre" 5 "Or" 6 "Épargne") pos(6) col(3)) ///
name(compo1, replace)

twoway ///
(area sum1 assgroup if time==2) ///
(rarea sum1 sum2 assgroup if time==2) ///
(rarea sum2 sum3 assgroup if time==2) ///
(rarea sum3 sum4 assgroup if time==2) ///
(rarea sum4 sum5 assgroup if time==2) ///
(rarea sum5 sum6 assgroup if time==2) ///
, ///
xlabel(1(1)10) xtitle("Décile de patrimoine") ///
ylabel(0(10)100) ytitle("%") ///
title("2016-2017") ///
legend(order(1 "Habitat" 2 "Bétail" 3 "Biens" 4 "Terre" 5 "Or" 6 "Épargne") pos(6) col(3)) ///
name(compo2, replace)

twoway ///
(area sum1 assgroup if time==3) ///
(rarea sum1 sum2 assgroup if time==3) ///
(rarea sum2 sum3 assgroup if time==3) ///
(rarea sum3 sum4 assgroup if time==3) ///
(rarea sum4 sum5 assgroup if time==3) ///
(rarea sum5 sum6 assgroup if time==3) ///
, ///
xlabel(1(1)10) xtitle("Décile de patrimoine") ///
ylabel(0(10)100) ytitle("%") ///
title("2020-2021") ///
legend(order(1 "Habitat" 2 "Bétail" 3 "Biens" 4 "Terre" 5 "Or" 6 "Épargne") pos(6) col(3)) ///
name(compo3, replace)


grc1leg compo1 compo2 compo3, col(3) name(compo, replace)
graph export "graph_HH/FR_Compo_assets_HH.png", as(png) replace

****************************************
* END






















****************************************
* Gini decomposition
****************************************

********** Income
use"panel_v3", clear

global HH annualincome agrise agrica casual regula selfem mgnreg pensio remitt

descogini $HH if year==2010
descogini $HH if year==2016
descogini $HH if year==2020


***** Graph
import excel "Gini.xlsx", sheet("Income_HH") firstrow clear
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
, title("Monthly income") ylabel(-.2(.1).2) ///
xtitle("") xlabel(2010(2)2020) ///
ytitle("Percent") ///
legend(order(1 "Agri self" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-emp" 6 "MGNREGA" 7 "Pension" 8 "Remitt") pos(6) col(3)) name(inc, replace) scale(1.2)








********** Assets
use"panel_v3", clear

global assets assets_total house livestock goods land gold savings

descogini $assets if year==2010
descogini $assets if year==2016
descogini $assets if year==2020

***** Graph
import excel "Gini.xlsx", sheet("Wealth_HH") firstrow clear
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
, title("Wealth") ylabel(-.2(.1).2) ///
xtitle("") xlabel(2010(2)2020) ///
ytitle("Percent") ///
legend(order(1 "House" 2 "Livestock" 3 "Durable goods" 4 "Land" 5 "Gold" 6 "Saving") pos(6) col(2)) name(ass, replace) scale(1.2)


********** Combine graph
graph combine inc ass, col(2) title("Percent change in Gini") note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 625 in 2020-21.", size(vsmall))
graph export "graph_HH/DecompoGini_HH.png", as(png) replace

****************************************
* END
