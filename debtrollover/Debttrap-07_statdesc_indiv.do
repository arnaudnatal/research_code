*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*January 21, 2025
*-----
gl link = "debttrap"
*Stat desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------












****************************************
* Stat desc
****************************************

********** Dummy trap
use"panel_indiv_v2", clear
keep if trapamount_HH!=0
keep if dummyloans==1

*** 2016-17
ta dummytrap sex if year==2016, col nofreq chi2
ta sex dummytrap if year==2016, row nofreq
*
input cat notrap trap
1 75.68 24.32
3 26.97 73.03
5 49.08 50.92
end
label define cat 1"Men" 3"Women" 5"Total", replace
label values cat cat
gen sum1=trap
gen sum2=sum1+notrap
* 
twoway ///
(bar sum1 cat, barwidth(1.9)) ///
(rbar sum1 sum2 cat, barwidth(1.9)) ///
, ///
xlabel(1 3 5,valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2016-2017") ///
legend(order(1 "Rollover" 2 "No rollover") pos(6) col(3)) ///
note("Pearson Chi2(1)=38.36   Pr=0.00", size(small)) ///
name(g1, replace) scale(1.2)
drop cat notrap trap sum1 sum2


*** 2020-21
*
ta dummytrap sex if year==2020, col nofreq chi2
ta sex dummytrap if year==2020, row nofreq
*
input cat notrap trap
1 61.36 38.64
3 28.27 71.73
5 44.10 55.90
end
label define cat 1"Men" 3"Women" 5"Total", replace
label values cat cat
gen sum1=trap
gen sum2=sum1+notrap
* 
twoway ///
(bar sum1 cat, barwidth(1.9)) ///
(rbar sum1 sum2 cat, barwidth(1.9)) ///
, ///
xlabel(1 3 5,valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2020-2021") ///
legend(order(1 "Rollover" 2 "No rollover") pos(6) col(3)) ///
note("Pearson Chi2(1)=71.37   Pr=0.00", size(small)) ///
name(g2, replace) scale(1.2)
drop cat notrap trap sum1 sum2


*** Comb
grc1leg g1 g2, col(2) name(comb, replace)
graph export "graph/Incidence_indiv.png", as(png) replace











********** Share trap
use"panel_indiv_v2", clear
keep if trapamount_HH!=0
keep if dummyloans==1
keep if dummytrap==1
ta year sex

*** 2016-17
twoway ///
(histogram share_giventrap if year==2016 & sex==1, width(2) color(plb1%50) percent) ///
(histogram share_giventrap if year==2016 & sex==2, width(2) color(plr1%50) percent) ///
, title("2016-2017") ///
ytitle("Percent") xtitle("Share of debt rollover (percent)") ///
ylabel(0(10)100) xlabel(0(10)100) ///
legend(order(1 "Men" 2 "Women") pos(6) col(2)) scale(1.2) ///
name(g1, replace)


*** 2020-21
twoway ///
(histogram share_giventrap if year==2020 & sex==1, width(2) color(plb1%50) percent) ///
(histogram share_giventrap if year==2020 & sex==2, width(2) color(plr1%50) percent) ///
, title("2020-2021") ///
ytitle("Percent") xtitle("Share of debt rollover (percent)") ///
ylabel(0(10)100) xlabel(0(10)100) ///
legend(order(1 "Men" 2 "Women") pos(6) col(2)) scale(1.2) ///
name(g2, replace)


*** Comb
grc1leg g1 g2, col(2) name(comb, replace)
graph export "graph/Intensity_indiv.png", as(png) replace

****************************************
* END


