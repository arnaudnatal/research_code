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


keep HHID_panel year monthlyincome_pc assets_total
rename monthlyincome_pc income
rename assets_total assets

reshape wide income assets, i(HHID_panel) j(year)
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

* Income
tabstat income2010, stat(n mean median) by(attrition2010)
tabstat income2016, stat(n mean median) by(attrition2016)
reg income2010 i.attrition2010
reg income2016 i.attrition2016

* Assets
tabstat assets2010, stat(n mean median) by(attrition2010)
tabstat assets2016, stat(n mean median) by(attrition2016)
reg assets2010 i.attrition2010
reg assets2016 i.attrition2016

****************************************
* END















****************************************
* Violin plot
****************************************
use"panel_v4", clear


********** Income
tabstat monthlyincome_pc, stat(n mean q iqr) by(year)

violinplot monthlyincome_pc, over(time) horizontal left dscale(4) noline now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
title("Monthly income per capita") ///
xtitle("1k rupees") xlabel(0(2)16) ///
ylabel(,grid) ///
legend(order(4 "IQR" 7 "Median" 10 "Mean") pos(6) col(3) on) ///
aspectratio() scale(1.2) name(inc, replace) range(0 16)



********** Assets
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
aspectratio() scale(1.2) name(ass, replace) range(0 7000)


********** Combine
grc1leg inc ass, col(2) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 625 in 2020-21.", size(vsmall))
graph export "graph/Violin.png", as(png) replace

****************************************
* END
















****************************************
* Decile
****************************************

***** Income
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
ytitle("Percent") ylabel(0(5)55) ///
xtitle("Decile of income per capita") xlabel(1(1)10) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) name(inc, replace) scale(1.2)


***** Assets
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
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) name(ass, replace) scale(1.2)



***** Combine
grc1leg inc ass, col(2) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 625 in 2020-21.", size(vsmall))
graph export "graph/Decile.png", as(png) replace

****************************************
* END




















****************************************
* Lorenz
****************************************

***** Income
use"panel_v4", clear

keep HHID_panel year monthlyincome_pc
reshape wide monthlyincome_pc, i(HHID_panel) j(year)
lorenz estimate monthlyincome_pc2010 monthlyincome_pc2016 monthlyincome_pc2020, gini


***** Assets
use"panel_v4", clear

keep HHID_panel year assets_total
reshape wide assets_total, i(HHID_panel) j(year)
lorenz estimate assets_total2010 assets_total2016 assets_total2020, gini


********** À la main pour les CI

*** Income
import excel "Lorenz.xlsx", sheet("Income") firstrow clear
*
twoway ///
(line coef2010 pop, color(ply1)) ///
(rarea ub2010 lb2010 pop, color(ply1%10)) ///
(line coef2016 pop, color(plr1)) ///
(rarea ub2016 lb2016 pop, color(plr1%10)) ///
(line coef2020 pop, color(plg1)) ///
(rarea ub2020 lb2020 pop, color(plg1%10)) ///
, title("Income") ytitle("Cumulative income proportion") ylabel(0(.1)1) ///
xtitle("Population share") xlabel(0(10)100) ///
legend(order(1 "2010" 3 "2016-17" 5 "2020-21") pos(6) col(3)) ///
scale(1.2) note("Gini index is 0.32 in 2010, 0.42 in 2016-17 and 0.48 in 2020-21.", size(vsmall)) name(inc, replace)

*** Wealth
import excel "Lorenz.xlsx", sheet("Wealth") firstrow clear
*
twoway ///
(line coef2010 pop, color(ply1)) ///
(rarea ub2010 lb2010 pop, color(ply1%10)) ///
(line coef2016 pop, color(plr1)) ///
(rarea ub2016 lb2016 pop, color(plr1%10)) ///
(line coef2020 pop, color(plg1)) ///
(rarea ub2020 lb2020 pop, color(plg1%10)) ///
, title("Wealth") ytitle("Cumulative wealth proportion") ylabel(0(.1)1) ///
xtitle("Population share") xlabel(0(10)100) ///
legend(order(1 "2010" 3 "2016-17" 5 "2020-21") pos(6) col(3)) ///
scale(1.2) note("Gini index is 0.58 in 2010, 0.66 in 2016-17 and 0.61 in 2020-21.", size(vsmall)) name(ass, replace)


*** Combine
grc1leg inc ass, col(2) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 625 in 2020-21.", size(vsmall))
graph export "graph/Lorenz.png", as(png) replace

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
graph export "graph/Assets_ownership.png", as(png) replace


****************************************
* END

