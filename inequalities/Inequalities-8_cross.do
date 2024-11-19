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
xtitle("Monthly income p.c. (1k rupees)") xlabel(0(2)16) ///
ytitle("Total value of wealth (1k rupees)") ylabel(0(1000)7000) ///
legend(off) ///
note("Pearson {it:p}=0.174; Spearman {it:p}=0.104", size(vsmall)) ///
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
xtitle("Monthly income p.c. (1k rupees)") xlabel(0(2)16) ///
ytitle("Total value of wealth (1k rupees)") ylabel(0(1000)7000) ///
legend(off) ///
note("Pearson {it:p}=0.280; Spearman {it:p}=0.070", size(vsmall)) ///
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
xtitle("Monthly income p.c. (1k rupees)") xlabel(0(2)16) ///
ytitle("Total value of wealth (1k rupees)") ylabel(0(1000)7000) ///
legend(off) ///
note("Pearson {it:p}=0.164; Spearman {it:p}=0.245", size(vsmall)) ///
name(g3, replace) scale(1.2) 



********** Combine
graph combine g1 g2 g3, col(3) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 625 in 2020-21.", size(vsmall))
graph export "graph/Incass_split.png", as(png) replace



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
note("Pearson {it:p}=0.1587; Spearman {it:p}=0.1372." "{it:Note:} For 405 households in 2010, 492 in 2016-17, and 625 in 2020-21.", size(vsmall)) ///
name(gp, replace) scale(1.2) 
graph export "graph/Incass_pooled.png", as(png) replace





********** Log pooled
use"panel_v4", clear
replace assets_total=assets_total*1000
replace monthlyincome_pc=monthlyincome_pc*1000

gen logass=log(assets_total)
gen loginc=log(monthlyincome_pc)

* Stat
pwcorr logass loginc, sig
spearman logass loginc, stats(rho p)

* Graph
twoway ///
(scatter logass loginc, msymbol(oh) color(black%30)) ///
, title("Pooled sample (2010, 2016-17, and 2020-21)") ///
xtitle("Monthly income per capita (log)") xlabel(4(1)12) ///
ytitle("Total value of assets (log)") ylabel(8(1)18) ///
legend(off) ///
note("Pearson {it:p}=0.1587; Spearman {it:p}=0.1372." "{it:Note:} For 405 households in 2010, 492 in 2016-17, and 625 in 2020-21.", size(vsmall)) ///
name(gp, replace) scale(1.2) 
graph export "graph/Incass_logpooled.png", as(png) replace


****************************************
* END




















****************************************
* Corr between assets and income
****************************************
use"panel_v4", clear

gen assets=assets_total*1000
gen income=monthlyincome_pc*1000

keep HHID_panel year assets income

*
reldist pdf assets income
reldist graph

reldist hist assets income
reldist graph


reldist cdf assets income
reldist graph


reldist divergence assets income
reldist mrp assets income
reldist su assets income

****************************************
* END























****************************************
* Mean, median and std dev of income by wealth
****************************************
use"panel_v4", clear

*
keep HHID_panel year assets_total monthlyincome_pc
rename assets_total assets
rename monthlyincome_pc income

*
xtile assets_d1=assets if year==2010, n(10)
xtile assets_d2=assets if year==2016, n(10)
xtile assets_d3=assets if year==2020, n(10)
gen assets_d=.
replace assets_d=assets_d1 if year==2010
replace assets_d=assets_d2 if year==2016
replace assets_d=assets_d3 if year==2020
drop assets_d1 assets_d2 assets_d3

*
gen income_sd=income
gen income_med=income
rename income income_mean

*
collapse (mean) income_mean (median) income_med (sd) income_sd, by(year assets_d)

*
twoway ///
(line income_mean assets_d if year==2010) ///
(line income_mean assets_d if year==2016) ///
(line income_mean assets_d if year==2020) ///
, xtitle("Decile of wealth") ytitle("Average monthly income p.c. (1k rupees)") ///
xlabel(1(1)10) ylabel(0(1)7) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) ///
scale(1.2) name(mean, replace)

*
twoway ///
(line income_med assets_d if year==2010) ///
(line income_med assets_d if year==2016) ///
(line income_med assets_d if year==2020) ///
, xtitle("Decile of wealth") ytitle("Median monthly income p.c. (1k rupees)") ///
xlabel(1(1)10) ylabel(0(1)6) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) ///
scale(1.2) name(med, replace)

****************************************
* END














****************************************
* Mean, median and std dev of wealth by income
****************************************
use"panel_v4", clear

*
keep HHID_panel year assets_total monthlyincome_pc
rename assets_total assets
rename monthlyincome_pc income

*
xtile income_d1=income if year==2010, n(10)
xtile income_d2=income if year==2016, n(10)
xtile income_d3=income if year==2020, n(10)
gen income_d=.
replace income_d=income_d1 if year==2010
replace income_d=income_d2 if year==2016
replace income_d=income_d3 if year==2020
drop income_d1 income_d2 income_d3

*
gen assets_sd=assets
gen assets_med=assets
rename assets assets_mean

*
collapse (mean) assets_mean (median) assets_med (sd) assets_sd, by(year income_d)

*
twoway ///
(line assets_mean income_d if year==2010) ///
(line assets_mean income_d if year==2016) ///
(line assets_mean income_d if year==2020) ///
, xtitle("Decile of income") ytitle("Average wealth (1k rupees)") ///
xlabel(1(1)10) ylabel(700(300)3400) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) ///
scale(1.2) name(mean, replace)

*
twoway ///
(line assets_med income_d if year==2010) ///
(line assets_med income_d if year==2016) ///
(line assets_med income_d if year==2020) ///
, xtitle("Decile of income") ytitle("Median wealth (1k rupees)") ///
xlabel(1(1)10) ylabel(300(300)2400) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) ///
scale(1.2) name(med, replace)

****************************************
* END



