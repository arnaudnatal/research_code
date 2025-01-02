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
use"panel_v3", clear
keep if year==2010

* Stat
pwcorr assets_total monthlyincome, sig
spearman assets_total monthlyincome, stats(rho p)


* Graph
twoway ///
(scatter assets_total monthlyincome if assets_total<=10000 & monthlyincome<=40, msymbol(oh) color(black%30)) ///
, title("2010") ///
xtitle("Monthly income (1k rupees)") xlabel(0(10)40) ///
ytitle("Wealth (1k rupees)") ylabel(0(2000)10000) ///
legend(off) ///
note("Pearson {it:p}=0.169; Spearman {it:p}=0.115", size(vsmall)) ///
name(g1, replace) scale(1.2) 



********** 2016-17
use"panel_v3", clear
keep if year==2016

* Stat
pwcorr assets_total monthlyincome, sig
spearman assets_total monthlyincome, stats(rho p)

* Graph
twoway ///
(scatter assets_total monthlyincome if assets_total<=10000 & monthlyincome<=40, msymbol(oh) color(black%30)) ///
, title("2016-17") ///
xtitle("Monthly income (1k rupees)") xlabel(0(10)40) ///
ytitle("Wealth (1k rupees)") ylabel(0(2000)10000) ///
legend(off) ///
note("Pearson {it:p}=0.459; Spearman {it:p}=0.170", size(vsmall)) ///
name(g2, replace) scale(1.2) 



********** 2020-21
use"panel_v3", clear
keep if year==2020

* Stat
pwcorr assets_total monthlyincome, sig
spearman assets_total monthlyincome, stats(rho p)

* Graph
twoway ///
(scatter assets_total monthlyincome if assets_total<=10000 & monthlyincome<=40, msymbol(oh) color(black%30)) ///
, title("2020-21") ///
xtitle("Monthly income (1k rupees)") xlabel(0(10)40) ///
ytitle("Wealth (1k rupees)") ylabel(0(2000)10000) ///
legend(off) ///
note("Pearson {it:p}=0.287; Spearman {it:p}=0.307", size(vsmall)) ///
name(g3, replace) scale(1.2) 



********** Combine
graph combine g1 g2 g3, col(3) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 625 in 2020-21.", size(vsmall))
graph export "graph_HH/Incass_split_HH.png", as(png) replace

****************************************
* END
