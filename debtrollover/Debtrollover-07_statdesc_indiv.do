*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*January 21, 2025
*-----
gl link = "debtrollover"
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

tabplot dummytrap sex if year==2016, percent(sex) showval frame(100) ///
frameopts(color(gs5)) ///
fcolor(gs5*0.4) lcolor(gs5) ///
subtitle("") ///
xtitle("") ytitle("") ///
xlabel(1 "Men" 2 "Women") ylabel(1 "Rollover" 2 "No rollover") ///
note("{it:Note:} Per cent given gender.", size(small)) scale(1.2) ///
title("2016-2017") note("Pearson Chi2(1)=38.36   Pr=0.00", size(small)) ///
name(g1, replace)


*** 2020-21
ta dummytrap sex if year==2020, col nofreq chi2
ta sex dummytrap if year==2020, row nofreq

tabplot dummytrap sex if year==2020, percent(sex) showval frame(100) ///
frameopts(color(gs5)) ///
fcolor(gs5*0.4) lcolor(gs5) ///
subtitle("") ///
xtitle("") ytitle("") ///
xlabel(1 "Men" 2 "Women") ylabel(1 "Rollover" 2 "No rollover") ///
note("{it:Note:} Per cent given gender.", size(small)) scale(1.2) ///
title("2020-2021") note("Pearson Chi2(1)=71.37   Pr=0.00", size(small)) ///
name(g2, replace)


/*
*** 2016-17
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
(rbar sum1 sum2 cat, barwidth(1.9) color(gs12)) ///
, ///
xlabel(1 3 5,valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("Per cent") ///
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
*/

*** Comb
graph combine g1 g2, col(2) name(comb, replace)
graph export "graph/Incidence_indiv.png", as(png) replace











********** Share trap
use"panel_indiv_v2", clear
keep if trapamount_HH!=0
keep if dummyloans==1
keep if dummytrap==1
ta year sex

tabstat share_giventrap if year==2016, stat(n mean sd q) by(sex)
tabstat share_giventrap if year==2020, stat(n mean sd q) by(sex)

reg share_giventrap i.sex if year==2016
qreg share_giventrap i.sex if year==2016, q(.5)

reg share_giventrap i.sex if year==2020
qreg share_giventrap i.sex if year==2020, q(.5)

*** 2016-2017
preserve
keep if year==2016
bys sex: egen med = median(share_giventrap)
bys sex: egen lqt = pctile(share_giventrap), p(25)
bys sex: egen uqt = pctile(share_giventrap), p(75)
bys sex: egen iqr = iqr(share_giventrap)
bys sex: egen mean = mean(share_giventrap)
gen l = share_giventrap if(share_giventrap >= lqt-1.5*iqr)
bys time: egen ls = min(l)
gen u = share_giventrap if(share_giventrap <= uqt+1.5*iqr)
bys sex: egen us = max(u)
*
twoway rbar lqt med sex, fcolor(gs12) lcolor(black) barw(.5) || ///
       rbar med uqt sex, fcolor(gs12) lcolor(black) barw(.5) || ///
       rspike lqt ls sex, lcolor(black) || ///
       rspike uqt us sex, lcolor(black) || ///
       rcap ls ls sex, msize(*6) lcolor(black) || ///
       rcap us us sex, msize(*6) pstyle(p1) || ///
       scatter mean sex, msymbol(Oh) msize(*1) mcolor(black) ///
       legend(off)  xlabel( 1 "Men" 2 "Women") ///
	   ylabel(0(10)100) ///
       ytitle("Share of debt rollover (per cent)") xtitle("") title("2016-2017") scale(1.2) name(g1, replace)
*
drop med lqt uqt iqr mean l ls u us
restore

*** 2020-2021
preserve
keep if year==2020
bys sex: egen med = median(share_giventrap)
bys sex: egen lqt = pctile(share_giventrap), p(25)
bys sex: egen uqt = pctile(share_giventrap), p(75)
bys sex: egen iqr = iqr(share_giventrap)
bys sex: egen mean = mean(share_giventrap)
gen l = share_giventrap if(share_giventrap >= lqt-1.5*iqr)
bys time: egen ls = min(l)
gen u = share_giventrap if(share_giventrap <= uqt+1.5*iqr)
bys sex: egen us = max(u)
*
twoway rbar lqt med sex, fcolor(gs12) lcolor(black) barw(.5) || ///
       rbar med uqt sex, fcolor(gs12) lcolor(black) barw(.5) || ///
       rspike lqt ls sex, lcolor(black) || ///
       rspike uqt us sex, lcolor(black) || ///
       rcap ls ls sex, msize(*6) lcolor(black) || ///
       rcap us us sex, msize(*6) pstyle(p1) || ///
       scatter mean sex, msymbol(Oh) msize(*1) mcolor(black) ///
       legend(off)  xlabel( 1 "Men" 2 "Women") ///
	   ylabel(0(10)100) ///
       ytitle("Share of debt rollover (per cent)") xtitle("") title("2020-2021") scale(1.2) name(g2, replace)
*
drop med lqt uqt iqr mean l ls u us
restore

/*
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
*/

*** Comb
graph combine g1 g2, col(2) name(comb, replace)
graph export "graph/Intensity_indiv.png", as(png) replace

****************************************
* END


