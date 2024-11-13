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
* Gini decomposition income
****************************************

***** Decomposition Gini by income source
use"panel_v4", clear

* Check recours
foreach x in d_agrise d_agricasual d_nonagricasual d_nonagrireg d_nonagrise d_nrega d_pension_HH d_remreceived_HH {
ta `x' year, col nofreq
}

global PC annualincome3_pc incagrise_pc incagricasual_pc incnonagricasual_pc incnonagrireg_pc incnonagrise_pc incnrega_pc pension_pc remreceived_pc

descogini $PC if year==2010
descogini $PC if year==2016
descogini $PC if year==2020


***** Graph
import excel "Gini.xlsx", sheet("Sheet1") firstrow clear
label define occupation 1"Agri self-employed" 2"Agri casual" 3"Casual" 4"Regular" 5"Self-employed" 6"MGNREGA" 7"Pensions" 8"Remittances"
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
, title("Percent change in Gini") ylabel(-.2(.1).2) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA" 7 "Pension" 8 "Remittances") pos(6) col(4)) name(percentage, replace) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 626 in 2020-21.", size(vsmall))
graph export "Percentagechange.png", as(png) replace


***** Combine
grc1leg sk gk rk share, name(decompo, replace) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 626 in 2020-21.", size(vsmall))
graph export "Decompo.png", as(png) replace

****************************************
* END









****************************************
* Gini decomposition wealth
****************************************

***** Decomposition Gini by assets source
use"panel_v4", clear

global assets assets_total assets_house assets_livestock assets_goods assets_land assets_gold assets_savings

descogini $assets if year==2010
descogini $assets if year==2016
descogini $assets if year==2020

****************************************
* END

