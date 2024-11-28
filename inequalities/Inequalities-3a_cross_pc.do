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
pwcorr assets_total_pc monthlyincome_pc, sig
spearman assets_total_pc monthlyincome_pc, stats(rho p)


* Graph
twoway ///
(scatter assets_total_pc monthlyincome_pc if assets_total_pc<=3000 & monthlyincome_pc<=16, msymbol(oh) color(black%30)) ///
, title("2010") ///
xtitle("Monthly income p.c. (1k rupees)") xlabel(0(4)16) ///
ytitle("Wealth per capita (1k rupees)") ylabel(0(500)3000) ///
legend(off) ///
note("Pearson {it:p}=0.183; Spearman {it:p}=0.146", size(vsmall)) ///
name(g1, replace) scale(1.2) 



********** 2016-17
use"panel_v3", clear
keep if year==2016

* Stat
pwcorr assets_total_pc monthlyincome_pc, sig
spearman assets_total_pc monthlyincome_pc, stats(rho p)

* Graph
twoway ///
(scatter assets_total_pc monthlyincome_pc if assets_total_pc<=3000 & monthlyincome_pc<=16, msymbol(oh) color(black%30)) ///
, title("2016-17") ///
xtitle("Monthly income p.c. (1k rupees)") xlabel(0(4)16) ///
ytitle("Wealth per capita (1k rupees)") ylabel(0(500)3000) ///
legend(off) ///
note("Pearson {it:p}=0.292; Spearman {it:p}=0.128", size(vsmall)) ///
name(g2, replace) scale(1.2) 



********** 2020-21
use"panel_v3", clear
keep if year==2020

* Stat
pwcorr assets_total_pc monthlyincome_pc, sig
spearman assets_total_pc monthlyincome_pc, stats(rho p)

* Graph
twoway ///
(scatter assets_total_pc monthlyincome_pc if assets_total_pc<=3000 & monthlyincome_pc<=16, msymbol(oh) color(black%30)) ///
, title("2020-21") ///
xtitle("Monthly income p.c. (1k rupees)") xlabel(0(4)16) ///
ytitle("Wealth per capita (1k rupees)") ylabel(0(500)3000) ///
legend(off) ///
note("Pearson {it:p}=0.192; Spearman {it:p}=0.283", size(vsmall)) ///
name(g3, replace) scale(1.2) 



********** Combine
graph combine g1 g2 g3, col(3) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 625 in 2020-21.", size(vsmall))
graph export "graph_pc/Incass_split_pc.png", as(png) replace


****************************************
* END
