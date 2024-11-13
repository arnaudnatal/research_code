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
use"panel_v4", clear

ta stem year, col nofreq

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
* Attrition
****************************************
use"panel_v4", clear


keep HHID_panel year monthlyincome_pc
rename monthlyincome_pc income

reshape wide income, i(HHID_panel) j(year)
gen attrition2010=0
replace attrition2010=1 if income2010!=. & income2016==.
replace attrition2010=. if income2010==.
label define attrition2010 0"Recovered in 2016-17" 1"Lost in 2016-17"
label values attrition2010 attrition2010

gen attrition2016=0
replace attrition2016=1 if income2016!=. & income2020==.
replace attrition2016=. if income2016==.
label define attrition2016 0"Recovered in 2020-21" 1"Lost in 2020-21"
label values attrition2016 attrition2016


tabstat income2010, stat(n mean q) by(attrition2010)
tabstat income2016, stat(n mean q) by(attrition2016)

reg income2010 i.attrition2010
reg income2016 i.attrition2016

****************************************
* END















****************************************
* Income and IQR 
****************************************
use"panel_v4", clear

tabstat monthlyincome_pc, stat(n mean q iqr) by(year)

local ub 16
violinplot monthlyincome_pc, over(time) horizontal left dscale(4) noline now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
title("Monthly income per capita") ///
xtitle("1k rupees") xlabel(0(1)`ub') ///
ylabel(,grid) ///
legend(order(4 "IQR" 7 "Median" 10 "Mean") pos(6) col(3) on) ///
note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 626 in 2020-21.", size(vsmall)) ///
aspectratio() scale(1.2) name(vio, replace) range(0 `ub')

graph export "Violin.png", as(png) replace

****************************************
* END

















****************************************
* Assets and IQR 
****************************************
use"panel_v4", clear

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
* Ineq income
****************************************

***** Decile
use"panel_v4", clear

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
ytitle("Percent") ylabel(0(5)35) ///
xtitle("Decile of income per capita") xlabel(1(1)10) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) name(decile, replace) scale(1.2)
graph export "Decileincome.png", as(png) replace

***** Lorenz curves
use"panel_v4", clear

keep HHID_panel year monthlyincome_pc
reshape wide monthlyincome_pc, i(HHID_panel) j(year)
lorenz estimate monthlyincome_pc2010 monthlyincome_pc2016 monthlyincome_pc2020, gini
lorenz graph, overlay noci legend(pos(6) col(3) order(1 "2010" 2 "2016-17" 3 "2020-21")) xtitle("Population share") ytitle("Cumulative income proportion") title("Lorenz curves") xlabel(0(10)100) ylabel(0(.1)1) nodiagonal aspectratio() scale(1.2) name(lorenz, replace)


***** Combine
grc1leg decile lorenz, name(comb3, replace) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 626 in 2020-21. The Gini index is 0.322 in 2010, 0.422 in 2016-17 and 0.485 in 2020-21.", size(vsmall)) leg(lorenz)
graph export "IneqInc.png", as(png) replace


****************************************
* END







****************************************
* Ineq Assets
****************************************

***** Decile
use"panel_v4", clear

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
use"panel_v4", clear

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
* Wealth ownership
****************************************
use"panel_v4", clear

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
use"panel_v4", clear

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
* Corr between assets and income
****************************************

********** 2010
use"panel_v4", clear
keep if year==2010

* Stat
pwcorr assets_total monthlyincome_pc, sig
spearman assets_total monthlyincome_pc, stats(rho p)

* Graph
twoway ///
(scatter assets_total monthlyincome_pc if assets_total<=7000 & monthlyincome_pc<=16, msymbol(oh) color(black%30)) ///
, title("2010") ///
xtitle("Monthly income per capita (1k rupees)") xlabel(0(2)16) ///
ytitle("Total value of assets (1k rupees)") ylabel(0(1000)7000) ///
legend(off) ///
note("{it:Note:} Pearson {it:p}=0.1744 and Spearman {it:p}=0.1036", size(vsmall)) ///
name(g1, replace) scale(1.2) 



********** 2016-17
use"panel_v4", clear
keep if year==2016

* Stat
pwcorr assets_total monthlyincome_pc, sig
spearman assets_total monthlyincome_pc, stats(rho p)

* Graph
twoway ///
(scatter assets_total monthlyincome_pc if assets_total<=7000 & monthlyincome_pc<=16, msymbol(oh) color(black%30)) ///
, title("2016-17") ///
xtitle("Monthly income per capita (1k rupees)") xlabel(0(2)16) ///
ytitle("Total value of assets (1k rupees)") ylabel(0(1000)7000) ///
legend(off) ///
note("{it:Note:} Pearson {it:p}=0.2801 and Spearman {it:p}=0.0697", size(vsmall)) ///
name(g2, replace) scale(1.2) 



********** 2020-21
use"panel_v4", clear
keep if year==2020

* Stat
pwcorr assets_total monthlyincome_pc, sig
spearman assets_total monthlyincome_pc, stats(rho p)

* Graph
twoway ///
(scatter assets_total monthlyincome_pc if assets_total<=7000 & monthlyincome_pc<=16, msymbol(oh) color(black%30)) ///
, title("2020-21") ///
xtitle("Monthly income per capita (1k rupees)") xlabel(0(2)16) ///
ytitle("Total value of assets (1k rupees)") ylabel(0(1000)7000) ///
legend(off) ///
note("{it:Note:} Pearson {it:p}=0.1635 and Spearman {it:p}=0.2445", size(vsmall)) ///
name(g3, replace) scale(1.2) 



********** Combine
graph combine g1 g2 g3, col(3)



********** Pooled
use"panel_v4", clear

* Stat
pwcorr assets_total monthlyincome_pc, sig
spearman assets_total monthlyincome_pc, stats(rho p)

* Graph
twoway ///
(scatter assets_total monthlyincome_pc if assets_total<=7000 & monthlyincome_pc<=16, msymbol(oh) color(black%30)) ///
, title("Pooled sample (2010, 2016-17, and 2020-21)") ///
xtitle("Monthly income per capita (1k rupees)") xlabel(0(2)16) ///
ytitle("Total value of assets (1k rupees)") ylabel(0(1000)7000) ///
legend(off) ///
note("{it:Note:} Pearson {it:p}=0.1587 and Spearman {it:p}=0.1372", size(vsmall)) ///
name(gp, replace) scale(1.2) 


********** Matrices
use"panel_v4", clear

* Income
foreach i in 2010 2016 2020 {
xtile q_inc_`i'=monthlyincome_pc if year==`i', n(5)
}
gen q_inc=.
foreach i in 2010 2016 2020 {
replace q_inc=q_inc_`i' if year==`i'
drop q_inc_`i'
}


* Assets
foreach i in 2010 2016 2020 {
xtile q_ass_`i'=assets_total if year==`i', n(5)
}
gen q_ass=.
foreach i in 2010 2016 2020 {
replace q_ass=q_ass_`i' if year==`i'
drop q_ass_`i'
}

* Stat
ta q_inc q_ass, row nofreq chi2

ta q_inc q_ass if year==2010, row nofreq chi2
ta q_inc q_ass if year==2016, row nofreq chi2
ta q_inc q_ass if year==2020, row nofreq chi2


****************************************
* END
