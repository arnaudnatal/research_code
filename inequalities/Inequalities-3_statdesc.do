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

replace monthlyincome_mpc=monthlyincome_mpc/1000
tabstat monthlyincome_mpc, stat(min p1 p5 p10 q p90 p95 p99 max) by(year)

local ub 18
violinplot monthlyincome_mpc, over(time) horizontal left dscale(4) noline now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
title("Monthly income per capita") ///
xtitle("1k rupees") xlabel(0(2)`ub') ///
ylabel(,grid) ///
legend(order(4 "IQR" 7 "Median" 10 "Mean") pos(6) col(3) on) ///
aspectratio() scale(1.2) name(vio, replace) range(0 `ub')


***** Lorenz curves
use"panel_v6", clear

keep HHID_panel year monthlyincome_mpc
reshape wide monthlyincome_mpc, i(HHID_panel) j(year)
lorenz estimate monthlyincome_mpc2010 monthlyincome_mpc2016 monthlyincome_mpc2020, gini
lorenz graph, overlay noci legend(pos(6) col(3) order(1 "2010" 2 "2016-17" 3 "2020-21")) xtitle("Population share") ytitle("Cumulative income proportion") title("Lorenz curves") xlabel(0(10)100) ylabel(0(.1)1) nodiagonal aspectratio() scale(1.2) name(lorenz, replace)



***** Combine
graph combine vio lorenz, name(comb, replace) note("{it:Note:} The average monthly income per capita is 4600 rupees in 2010, 5600 rupees in 2016-17 and 6100 rupees in 2020-21. The Gini index is 0.31 in 2010," "0.42 in 2016-17 and 0.48 in 2020-21.", size(vsmall))
graph export "Income.png", as(png) replace


****************************************
* END


















****************************************
* Graph 2: Gini decomposition
****************************************

***** Decomposition Gini by income source
use"panel_v6", clear

global MPC annualincome_compo2_mpc incagrise_mpc incagricasual_mpc incnonagricasual_mpc incnonagrireg_mpc incnonagrise_mpc incnrega_mpc

descogini $MPC if year==2010
descogini $MPC if year==2016
descogini $MPC if year==2020



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

replace monthlyincome_mpc=monthlyincome_mpc/1000
rename monthlyincome_mpc income_m
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
, title("Monthly income per capita") ytitle("1k rupees") ylabel(4(1)10) ///
xtitle("") ///
legend(order(1 "Dalits" 3 "Middle castes" 5 "Upper castes") pos(6) col(3)) ///
scale(1.2) name(incomecaste, replace)


***** Growth rate
twoway ///
(connected growth year if caste==1, color(ply1)) ///
(connected growth year if caste==2, color(plr1)) ///
(connected growth year if caste==3, color(plg1)) ///
, title("Growth rate (base 100 in 2010)") ytitle("") ylabel(100(10)160) ///
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
* Intra-HH
****************************************
cls
use"panel_v6", clear


* Categories
ta type year
ta type year, col nofreq

cls
foreach i in 2010 2016 2020 {
foreach x in log_annualincome_HH log_assets_totalnoland remittnet_HH ownland housetitle HHsize HH_count_child sexratio nonworkersratio stem head_female head_age head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage dummydemonetisation lock_2 lock_3 caste_2 caste_3 village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10 {
tabstat `x' if year==`i', stat(mean) by(type)
}
}






* Depth
tabstat absdiffpercent if type==1, stat(n mean q) by(year)
tabstat absdiffpercent if type==3, stat(n mean q) by(year)

* Graph for M<W
violinplot absdiffpercent if type==1, over(time) horizontal left dscale(2.8) noline range(-2 102) now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
subtitle("Sample 1: Men income < women income") ///
xtitle("Percent") xlabel(0(10)100) ///
ylabel(,grid) ///
legend(order(4 "IQR" 7 "Median" 10 "Mean") pos(6) col(3) on) ///
note("{it:Note:} For 28 households in 2010, 48 in 2016-17 and 94 in 2020-21.", size(vsmall)) ///
aspectratio() scale(1.2) name(vio1, replace)

* Graph for M>W
violinplot absdiffpercent if type==3, over(time) horizontal left dscale(2.8) noline range(-2 102) now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
subtitle("Sample 2: Men income > women income") ///
xtitle("Percent") xlabel(0(10)100) ///
ylabel(,grid) ///
legend(order(4 "IQR" 7 "Median" 10 "Mean") pos(6) col(3) on) ///
note("{it:Note:} For 357 households in 2010, 412 in 2016-17 and 502 in 2020-21.", size(vsmall)) ///
aspectratio() scale(1.2) name(vio2, replace)

* Combine
grc1leg vio1 vio2, title("Relative difference in incomes between men and women") name(comb, replace)
graph export "Intra.png", as(png) replace



****************************************
* END


