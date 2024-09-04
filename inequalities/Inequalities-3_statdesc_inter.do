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
* Evolution of HH composition
****************************************
use"panel_v6", clear

tabstat HHsize HH_count_child HH_count_adult, stat(mean) by(year)
tabstat HHsize HH_count_child HH_count_adult if dalits==1, stat(mean) by(year)
tabstat HHsize HH_count_child HH_count_adult if dalits==0, stat(mean) by(year)

cls
foreach i in 2020 {
reg HHsize dalits if year==`i'
reg HH_count_child dalits if year==`i'
reg HH_count_adult dalits if year==`i'
}


/*
Il y a des différences de composition des ménages entre Dalits et non-Dalits donc on va s'intéresser au revenu par tête en tenant compte des équivalences scales. On prend celle de l'OCDE.
*/


****************************************
* END












****************************************
* Graph 1: Income level
****************************************

***** Income level
use"panel_v6", clear

replace monthlyincome_pc=monthlyincome_mpc/1000
tabstat monthlyincome_pc, stat(mean) by(year)
tabstat monthlyincome_pc, stat(min p1 p5 p10 q p90 p95 p99 max) by(year)

local ub 18
violinplot monthlyincome_pc, over(time) horizontal left dscale(4) noline now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
title("Monthly income per capita") ///
xtitle("1k rupees") xlabel(0(2)`ub') ///
ylabel(,grid) ///
legend(order(4 "IQR" 7 "Median" 10 "Mean") pos(6) col(3) on) ///
aspectratio() scale(1.2) name(vio, replace) range(0 `ub')
graph export "Violin.png", as(png) replace


***** Lorenz curves
use"panel_v6", clear

keep HHID_panel year monthlyincome_pc
reshape wide monthlyincome_pc, i(HHID_panel) j(year)
lorenz estimate monthlyincome_pc2010 monthlyincome_pc2016 monthlyincome_pc2020, gini
lorenz graph, overlay noci legend(pos(6) col(3) order(1 "2010" 2 "2016-17" 3 "2020-21")) xtitle("Population share") ytitle("Cumulative income proportion") title("Lorenz curves") xlabel(0(10)100) ylabel(0(.1)1) nodiagonal aspectratio() scale(1.2) name(lorenz, replace)


***** Decile
use"panel_v6", clear
replace monthlyincome_pc=monthlyincome_pc/1000

foreach i in 2010 2016 2020 {
xtile monthlyinc`i'=monthlyincome_pc if year==`i', n(10)
}
gen incgroup=.
foreach i in 2010 2016 2020 {
replace incgroup=monthlyinc`i' if year==`i'
drop monthlyinc`i' 
}

collapse (sum) monthlyincome_pc, by(year incgroup)
bysort year: egen totincome=sum(monthlyincome_pc)
gen shareinc=monthlyincome_pc*100/totincome

twoway ///
(connected shareinc incgroup if year==2010) ///
(connected shareinc incgroup if year==2016) ///
(connected shareinc incgroup if year==2020) ///
, title("Share of total income per capita by decile") ///
ytitle("%") ylabel(0(5)35) ///
xtitle("Decile of income per capita") xlabel(1(1)10) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) name(decile, replace) scale(1.2)



***** Combine
graph combine vio lorenz, name(comb, replace) note("{it:Note:} The average monthly income per capita is 4600 rupees in 2010, 5600 rupees in 2016-17 and 6000 rupees in 2020-21. The Gini index is 0.326 in 2010," "0.432 in 2016-17 and 0.495 in 2020-21.", size(vsmall))
graph export "Income.png", as(png) replace

graph combine vio decile, name(comb2, replace) note("{it:Note:} The average monthly income per capita is 4600 rupees in 2010, 5600 rupees in 2016-17 and 6000 rupees in 2020-21.", size(vsmall))
graph export "Income2.png", as(png) replace

grc1leg decile lorenz, name(comb3, replace) note("{it:Note:} The Gini index is 0.326 in 2010, 0.432 in 2016-17 and 0.495 in 2020-21.", size(vsmall)) leg(lorenz)
graph export "Income3.png", as(png) replace


****************************************
* END


















****************************************
* Graph 2: Gini decomposition
****************************************

***** Decomposition Gini by income source
use"panel_v6", clear

global PC annualincome_compo2_pc incagrise_pc incagricasual_pc incnonagricasual_pc incnonagrireg_pc incnonagrise_pc incnrega_pc

descogini $PC if year==2010
descogini $PC if year==2016
descogini $PC if year==2020

* With pension and remittances
global PC annualincome_compo3_pc incagrise_pc incagricasual_pc incnonagricasual_pc incnonagrireg_pc incnonagrise_pc incnrega_pc pension_pc remreceived_pc

descogini $PC if year==2010
descogini $PC if year==2016
descogini $PC if year==2020



***** Graph
import excel "Gini.xlsx", sheet("Sheet1") firstrow clear
label define occupation 1"Agri self-employed" 2"Agri casual" 3"Casual" 4"Regular" 5"Self-employed" 6"MGNREGA"
label values occupation occupation

* Sk
twoway ///
(connected Sk year if occupation==1, yline(0, lcolor(black))) ///
(connected Sk year if occupation==2) ///
(connected Sk year if occupation==3) ///
(connected Sk year if occupation==4) ///
(connected Sk year if occupation==5) ///
(connected Sk year if occupation==6) ///
, title("Share in total income") ylabel(0(.1).5) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA") pos(6) col(3)) name(sk, replace)

* Gk
twoway ///
(connected Gk year if occupation==1, yline(0, lcolor(black))) ///
(connected Gk year if occupation==2) ///
(connected Gk year if occupation==3) ///
(connected Gk year if occupation==4) ///
(connected Gk year if occupation==5) ///
(connected Gk year if occupation==6) ///
,title("Income source Gini") ylabel(0.4(.1)1) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA") pos(6) col(3)) name(gk, replace)

* Rk
twoway ///
(connected Rk year if occupation==1, yline(0, lcolor(black))) ///
(connected Rk year if occupation==2) ///
(connected Rk year if occupation==3) ///
(connected Rk year if occupation==4) ///
(connected Rk year if occupation==5) ///
(connected Rk year if occupation==6) ///
, title("Gini correlation with income rankings") ylabel(-.4(.2)1) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA") pos(6) col(3)) name(rk, replace)

* Share
replace Share=0 if Share<0
twoway ///
(connected Share year if occupation==1, yline(0, lcolor(black))) ///
(connected Share year if occupation==2) ///
(connected Share year if occupation==3) ///
(connected Share year if occupation==4) ///
(connected Share year if occupation==5) ///
(connected Share year if occupation==6) ///
, title("Share in total-income inequality") ylabel(0(.1).6) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA") pos(6) col(3)) name(share, replace)

* Percentage
twoway ///
(connected Percentage year if occupation==1, yline(0, lcolor(black))) ///
(connected Percentage year if occupation==2) ///
(connected Percentage year if occupation==3) ///
(connected Percentage year if occupation==4) ///
(connected Percentage year if occupation==5) ///
(connected Percentage year if occupation==6) ///
, title("% change in Gini") ylabel(-.2(.1).2) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA") pos(6) col(3)) name(percentage, replace)

***** Combine
grc1leg sk gk rk share percentage, name(decompo, replace)
graph export "Decompo.png", as(png) replace

****************************************
* END



















****************************************
* Graph 3: Income by caste
****************************************

use"panel_v6", clear

replace monthlyincome_pc=monthlyincome_pc/1000
rename monthlyincome_pc income_m
gen income_se=income_m
gen income_iqr=income_m

collapse (mean) income_m (semean) income_se (iqr) income_iqr, by(caste year)

* 95 CI
gen income_lb=income_m-(income_se*1.96)
gen income_ub=income_m+(income_se*1.96)

* Growth rate
reshape wide income_m income_se income_iqr income_lb income_ub, i(caste) j(year)
gen growth2010=100
gen growth2016=income_m2016*100/income_m2010
gen growth2020=income_m2020*100/income_m2010
reshape long income_m income_se income_iqr income_lb income_ub growth, i(caste) j(year)



***** Income level
twoway ///
(connected income_m year if caste==1, color(ply1)) ///
(rarea income_ub income_lb year if caste==1, color(ply1%10)) ///
(connected income_m year if caste==2, color(plr1)) ///
(rarea income_ub income_lb year if caste==2, color(plr1%10)) ///
(connected income_m year if caste==3, color(plg1)) ///
(rarea income_ub income_lb year if caste==3, color(plg1%10)) ///
, title("Monthly income per capita") ytitle("1k rupees") ylabel(1(1)7) ///
xtitle("") ///
legend(order(1 "Dalits" 3 "Middle castes" 5 "Upper castes") pos(6) col(3)) ///
scale(1.2) name(incomecaste, replace)


***** Growth rate
twoway ///
(connected growth year if caste==1, color(ply1)) ///
(connected growth year if caste==2, color(plr1)) ///
(connected growth year if caste==3, color(plg1)) ///
, title("Growth rate (base 100 in 2010)") ytitle("") ylabel(100(10)170) ///
xtitle("") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
scale(1.2) name(growthcaste, replace)


***** Combine
grc1leg incomecaste growthcaste, name(combcaste, replace)
graph export "Income_caste.png", as(png) replace


****************************************
* END














****************************************
* Graph 3: Share of income by occupation
****************************************
use"panel_v6", clear

foreach x in shareincagrise_HH shareincagricasual_HH shareincnonagricasual_HH shareincnonagrireg_HH shareincnonagrise_HH shareincnrega_HH {
replace `x'=`x'*100
}

foreach x in incagrise incagricasual incnonagricasual incnonagrireg incnonagrise incnrega {
rename share`x'_HH s_`x'
}

tabstat s_incagrise s_incagricasual s_incnonagricasual s_incnonagrireg s_incnonagrise s_incnrega, stat(mean) by(caste)

collapse (mean) s_incagrise s_incagricasual s_incnonagricasual s_incnonagrireg s_incnonagrise s_incnrega, by(year caste)

rename s_incagrise s_inc1
rename s_incagricasual s_inc2
rename s_incnonagricasual s_inc3
rename s_incnonagrireg s_inc4
rename s_incnonagrise s_inc5
rename s_incnrega s_inc6

***** Bar
gen time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
label define time 1"2010" 2"2016-17" 3"2020-21", replace
label values time time

graph bar s_inc1 s_inc2 s_inc3 s_inc4 s_inc5 s_inc6, over(time) over(caste) stack legend(pos(6) col(3) order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA")) ytitle("Percentage") title("")
graph export "Occ1.png", as(png) replace


***** Graph line
reshape long s_inc, i(year caste) j(occ)

label define occ 1"Agri self-employed" 2"Agri casual" 3"Casual" 4"Regular" 5"Self-employed" 6"MGNREGA"
label values occ occ


* Occ 1
twoway ///
(connected s_inc year if caste==1 & occ==1, color(ply1)) ///
(connected s_inc year if caste==2 & occ==1, color(plr1)) ///
(connected s_inc year if caste==3 & occ==1, color(plg1)) ///
, title("Agricultural self-employed") ytitle("Percentage") ylabel(0(10)50) ///
xtitle("") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
scale(1.2) name(gr1, replace)

* Occ 2
twoway ///
(connected s_inc year if caste==1 & occ==2, color(ply1)) ///
(connected s_inc year if caste==2 & occ==2, color(plr1)) ///
(connected s_inc year if caste==3 & occ==2, color(plg1)) ///
, title("Agricultural casual") ytitle("Percentage") ylabel(0(10)50) ///
xtitle("") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
scale(1.2) name(gr2, replace)

* Occ 3
twoway ///
(connected s_inc year if caste==1 & occ==3, color(ply1)) ///
(connected s_inc year if caste==2 & occ==3, color(plr1)) ///
(connected s_inc year if caste==3 & occ==3, color(plg1)) ///
, title("Casual") ytitle("Percentage") ylabel(0(10)50) ///
xtitle("") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
scale(1.2) name(gr3, replace)

* Occ 4
twoway ///
(connected s_inc year if caste==1 & occ==4, color(ply1)) ///
(connected s_inc year if caste==2 & occ==4, color(plr1)) ///
(connected s_inc year if caste==3 & occ==4, color(plg1)) ///
, title("Regular") ytitle("Percentage") ylabel(0(10)50) ///
xtitle("") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
scale(1.2) name(gr4, replace)

* Occ 5
twoway ///
(connected s_inc year if caste==1 & occ==5, color(ply1)) ///
(connected s_inc year if caste==2 & occ==5, color(plr1)) ///
(connected s_inc year if caste==3 & occ==5, color(plg1)) ///
, title("Self-employed") ytitle("Percentage") ylabel(0(10)50) ///
xtitle("") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
scale(1.2) name(gr5, replace)

* Occ 6
twoway ///
(connected s_inc year if caste==1 & occ==6, color(ply1)) ///
(connected s_inc year if caste==2 & occ==6, color(plr1)) ///
(connected s_inc year if caste==3 & occ==6, color(plg1)) ///
, title("MGNREGA") ytitle("Percentage") ylabel(0(10)50) ///
xtitle("") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
scale(1.2) name(gr6, replace)

* Combine
grc1leg gr1 gr2 gr3 gr4 gr5 gr6, col(3) name(occ, replace)
graph export "Occ2.png", as(png) replace




****************************************
* END














****************************************
* Quintiles
****************************************
use"panel_v6", clear

foreach i in 2010 2016 2020 {
xtile q_inc_`i'=monthlyincome_pc if year==`i', n(5)
}

gen q_inc=.
foreach i in 2010 2016 2020 {
replace q_inc=q_inc_`i' if year==`i'
drop q_inc_`i'
}

ta q_inc caste if year==2010, row nofreq chi2
ta q_inc caste if year==2016, row nofreq chi2
ta q_inc caste if year==2020, row nofreq chi2

****************************************
* END














****************************************
* Ineq mesures by group
****************************************
use"panel_v6", clear

replace monthlyincome_pc=monthlyincome_pc/1000
ta monthlyincome_pc

***** Stat
cls
* 2010
ineqdeco monthlyincome_pc if year==2010, by(caste)

cls
* 2016
ineqdeco monthlyincome_pc if year==2016, by(caste)

cls
* 2020
ineqdeco monthlyincome_pc if year==2020, by(caste)


***** Std Err.
ineqerr monthlyincome_pc if year==2010, reps(200)
ineqerr monthlyincome_pc if year==2016, reps(200)
ineqerr monthlyincome_pc if year==2020, reps(200)










/*
GE(0)=déviation logarithmique moyenne
GE(1)=Theil
GE(2)=Demi coeff de variation au carré

between + within = overall pour GE, peut être passé en % ?

L’interprétation du coefficient de Gini est très intuitive. En multipliant le coefficient par deux et par le revenu moyen, on obtient l’écart de revenu attendu entre deux individus choisis au hasard au sein de la population.
*/

****************************************
* END









