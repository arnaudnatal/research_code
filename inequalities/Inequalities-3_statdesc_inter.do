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
* Evo of position
****************************************
use"panel_v4", clear

keep HHID_panel year monthlyincome_pc caste
rename monthlyincome_pc income

reshape wide income, i(HHID_panel) j(year)

foreach x in 2010 2016 2020 {
xtile cent`x'=income`x', n(100)
xtile dec`x'=income`x', n(10)
xtile quint`x'=income`x', n(5)
}


ta quint2016 quint2010, chi2 nofreq row
ta quint2020 quint2016, chi2 nofreq row

ta dec2016 dec2010, chi2 nofreq row
ta dec2020 dec2016, chi2 nofreq row




* Categories
gen d1=cent2016-cent2010
gen d2=cent2020-cent2016

foreach i in 1 2 {
gen catd`i'=.
label define catd`i' 1"Increasing" 2"Stagnation" 3"Decreasing"
label values catd`i' catd`i'
replace catd`i'=1 if d`i'>=5 & d`i'!=.
replace catd`i'=2 if d`i'<5 & d`i'>-5 & d`i'!=.
replace catd`i'=3 if d`i'<=-5 & d`i'!=.
}



********** 2010 - 2016
* Income
pwcorr income2016 income2010, sig
spearman income2016 income2010, stats(rho p)
tabstat income2016 income2010, stat(p75 p90 p95 p99 max)
twoway ///
(scatter income2016 income2010 if income2016<30 & income2010<30, color(black%30)) ///
(function y=x, range(0 25)) ///
, xtitle("Monthly income per capita in 2010 (1k rupees)") ///
ytitle("Monthly income per capita in 2016-17 (1k rupees)") ///
note("{it:Note:} For 388 households." "Pearson's {it:p} = 0.1308" "Spearman's {it:p} = 0.1744", size(vsmall)) ///
legend(off) name(g1, replace)

* Centiles
pwcorr cent2016 cent2010, sig
spearman cent2016 cent2010, stats(rho p)
twoway ///
(scatter cent2016 cent2010, color(black%30)) ///
(function y=x, range(0 100)) ///
, xtitle("Percentile of monthly income per capita in 2010") ///
ytitle("Percentile of monthly income per capita in 2016-17") ///
note("{it:Note:} For 388 households." "Pearson's {it:p} = 0.1753" "Spearman's {it:p} = 0.1742", size(vsmall)) ///
legend(off) name(g2, replace)

* Combine
graph combine g1 g2, name(comb1, replace)
/*
Il y a de la mobilité sociale et les positions changes beaucoup
*/

*graph export "Percentile.png", as(png) replace




********** 2016 - 2020
* Income
pwcorr income2020 income2016, sig
spearman income2020 income2016, stats(rho p)
tabstat income2020 income2016, stat(p75 p90 p95 p99 max)
twoway ///
(scatter income2020 income2016 if income2020<60 & income2016<30, color(black%30)) ///
(function y=x, range(0 25)) ///
, xtitle("Monthly income per capita in 2016-17 (1k rupees)") ///
ytitle("Monthly income per capita in 2020-21 (1k rupees)") ///
note("{it:Note:} For 485 households." "Pearson's {it:p} = 0.1478" "Spearman's {it:p} = 0.2369", size(vsmall)) ///
legend(off) name(g3, replace)

* Centiles
pwcorr cent2020 cent2016, sig
spearman cent2020 cent2016, stats(rho p)
twoway ///
(scatter cent2020 cent2016, color(black%30)) ///
(function y=x, range(0 100)) ///
, xtitle("Percentile of monthly income per capita in 2016-17") ///
ytitle("Percentile of monthly income per capita in 2020-21") ///
note("{it:Note:} For 485 households." "Pearson's {it:p} = 0.2390" "Spearman's {it:p} = 0.2374", size(vsmall)) ///
legend(off) name(g4, replace)

* Combine
graph combine g3 g4, name(comb2, replace)
/*
Il y a de la mobilité sociale et les positions changes beaucoup
*/

*graph export "Percentile.png", as(png) replace


****************************************
* END

















****************************************
* Gini decomposition
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

* Sk
twoway ///
(connected Sk year if occupation==1, color(black)) ///
(connected Sk year if occupation==2, color(plr1)) ///
(connected Sk year if occupation==3, color(ply1)) ///
(connected Sk year if occupation==4, color(plg1)) ///
(connected Sk year if occupation==5, color(plb1)) ///
(connected Sk year if occupation==6, color(pll1)) ///
(connected Sk year if occupation==7, color(gs10)) ///
(connected Sk year if occupation==8, color(black) lpattern(shortdash)) ///
, title("Share in total income") ylabel(0(.1).5) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA" 7 "Pension" 8 "Remittances") pos(6) col(4)) name(sk, replace)

* Gk
twoway ///
(connected Gk year if occupation==1, color(black)) ///
(connected Gk year if occupation==2, color(plr1)) ///
(connected Gk year if occupation==3, color(ply1)) ///
(connected Gk year if occupation==4, color(plg1)) ///
(connected Gk year if occupation==5, color(plb1)) ///
(connected Gk year if occupation==6, color(pll1)) ///
(connected Gk year if occupation==7, color(gs10)) ///
(connected Gk year if occupation==8, color(black) lpattern(shortdash)) ///
,title("Income source Gini") ylabel(0.4(.1)1) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA" 7 "Pension" 8 "Remittances") pos(6) col(4)) name(gk, replace)

* Rk
twoway ///
(connected Rk year if occupation==1, color(black)) ///
(connected Rk year if occupation==2, color(plr1)) ///
(connected Rk year if occupation==3, color(ply1)) ///
(connected Rk year if occupation==4, color(plg1)) ///
(connected Rk year if occupation==5, color(plb1)) ///
(connected Rk year if occupation==6, color(pll1)) ///
(connected Rk year if occupation==7, color(gs10)) ///
(connected Rk year if occupation==8, color(black) lpattern(shortdash)) ///
, title("Gini correlation with income rankings") ylabel(-.4(.2)1) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA" 7 "Pension" 8 "Remittances") pos(6) col(4)) name(rk, replace)

* Share
replace Share=0 if Share<0
twoway ///
(connected Share year if occupation==1, color(black)) ///
(connected Share year if occupation==2, color(plr1)) ///
(connected Share year if occupation==3, color(ply1)) ///
(connected Share year if occupation==4, color(plg1)) ///
(connected Share year if occupation==5, color(plb1)) ///
(connected Share year if occupation==6, color(pll1)) ///
(connected Share year if occupation==7, color(gs10)) ///
(connected Share year if occupation==8, color(black) lpattern(shortdash)) ///
, title("Share in total-income inequality") ylabel(0(.1).6) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA" 7 "Pension" 8 "Remittances") pos(6) col(4)) name(share, replace)

* Percentage
twoway ///
(connected Percentage year if occupation==1, color(black)) ///
(connected Percentage year if occupation==2, color(plr1)) ///
(connected Percentage year if occupation==3, color(ply1)) ///
(connected Percentage year if occupation==4, color(plg1)) ///
(connected Percentage year if occupation==5, color(plb1)) ///
(connected Percentage year if occupation==6, color(pll1)) ///
(connected Percentage year if occupation==7, color(gs10)) ///
(connected Percentage year if occupation==8, color(black) lpattern(shortdash)) ///
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
* Evolution of income level by caste
****************************************
use"panel_v4", clear

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
grc1leg incomecaste growthcaste, name(combcaste, replace) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 626 in 2020-21.", size(vsmall))
graph export "Income_caste.png", as(png) replace


****************************************
* END















****************************************
* Quintiles of income by caste
****************************************
use"panel_v4", clear

foreach i in 2010 2016 2020 {
xtile q_inc_`i'=monthlyincome_pc if year==`i', n(5)
}

gen q_inc=.
foreach i in 2010 2016 2020 {
replace q_inc=q_inc_`i' if year==`i'
drop q_inc_`i'
}


*** 
ta q_inc caste if year==2010, row nofreq chi2
ta q_inc caste if year==2016, row nofreq chi2
ta q_inc caste if year==2020, row nofreq chi2


***** Graph
import excel "Quintiles.xlsx", sheet("Sheet1") firstrow clear
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time

recode quintile (1=1) (2=3) (3=5) (4=7) (5=9) (6=12)

label define quintile 1"Q1" 3"Q2" 5"Q3" 7"Q4" 9"Q5" 12"Total"
label values quintile quintile

gen sum1=share_dalits
gen sum2=sum1+share_middle
gen sum3=sum2+share_upper


* By year
twoway ///
(bar sum1 quintile if time==1, barwidth(1.9)) ///
(rbar sum1 sum2 quintile if time==1, barwidth(1.9)) ///
(rbar sum2 sum3 quintile if time==1, barwidth(1.9)) ///
, ///
xlabel(1 3 5 7 9 12,valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2010") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
note("Pearson Chi2(8)=12.85   Pr=0.12", size(small)) ///
name(compo1, replace)

twoway ///
(bar sum1 quintile if time==2, barwidth(1.9)) ///
(rbar sum1 sum2 quintile if time==2, barwidth(1.9)) ///
(rbar sum2 sum3 quintile if time==2, barwidth(1.9)) ///
, ///
xlabel(1 3 5 7 9 12,valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2016-17") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
note("Pearson Chi2(8)=39.04   Pr=0.00", size(small)) ///
name(compo2, replace)

twoway ///
(bar sum1 quintile if time==3, barwidth(1.9)) ///
(rbar sum1 sum2 quintile if time==3, barwidth(1.9)) ///
(rbar sum2 sum3 quintile if time==3, barwidth(1.9)) ///
, ///
xlabel(1 3 5 7 9 12,valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2020-21") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
note("Pearson Chi2(8)=36.61   Pr=0.00", size(small)) ///
name(compo3, replace)

grc1leg compo1 compo2 compo3, col(3) name(comp, replace) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 626 in 2020-21.", size(vsmall))
graph export "Quintile.png", as(png) replace

****************************************
* END















****************************************
* Caste and incomes
****************************************
use"panel_v4", clear

* 2010
cls
preserve
keep if year==2010
foreach x in d_agrise d_agricasual d_nonagricasual d_nonagrireg d_nonagrise d_nrega d_pension_HH d_remreceived_HH {
ta `x' caste, row nofreq
}
restore

* 2016-17
cls
preserve
keep if year==2016
foreach x in d_agrise d_agricasual d_nonagricasual d_nonagrireg d_nonagrise d_nrega d_pension_HH d_remreceived_HH {
ta `x' caste, row nofreq
}
restore

* 2020-21
cls
preserve
keep if year==2020
foreach x in d_agrise d_agricasual d_nonagricasual d_nonagrireg d_nonagrise d_nrega d_pension_HH d_remreceived_HH {
ta `x' caste, row nofreq
}
restore


*****
import excel "CasteIncomes.xlsx", sheet("Sheet1") firstrow clear
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time
label define cat 1"Agri SE" 2"Agri casual" 3"Casual" 4"Reg" 5"SE" 6"MGNREGA" 7"Pensions" 8"Remittances" 9"Total"
label values cat cat

* Graph 1
set graph off
graph bar dalits middle upper if time==1, over(cat, label(angle(45))) title("2010") ytitle("Percentage") legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") col(3) pos(6)) name(g1, replace) ylabel(0(10)70) aspectratio(1.5) ysize(20) xsize(10)

graph bar dalits middle upper if time==2, over(cat, label(angle(45))) title("2016-17") ytitle("Percentage") legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") col(3) pos(6)) name(g2, replace) ylabel(0(10)70) aspectratio(1.5) ysize(20) xsize(10)

graph bar dalits middle upper if time==3, over(cat, label(angle(45))) title("2020-21") ytitle("Percentage") legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") col(3) pos(6)) name(g3, replace) ylabel(0(10)70) aspectratio(1.5) ysize(20) xsize(10)
set graph on

grc1leg g1 g2 g3, col(3) name(comb, replace)
graph export "Castecatinc.png", as(png) replace


* Graph 2
gen sum1=dalits
gen sum2=sum1+middle
gen sum3=sum2+upper
recode cat (1=1) (2=3) (3=5) (4=7) (5=9) (6=11) (7=13) (8=15) (9=18)

label define cat 1"Agri SE" 3"Agri casual" 5"Casual" 7"Reg" 9"SE" 11"MGNREGA" 13"Pensions" 15"Remittances" 18"Total", replace
label values cat cat

twoway ///
(bar sum1 cat if time==1, barwidth(1.9)) ///
(rbar sum1 sum2 cat if time==1, barwidth(1.9)) ///
(rbar sum2 sum3 cat if time==1, barwidth(1.9)) ///
, ///
xlabel(1 3 5 7 9 11 13 15 18, angle(45) valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2010") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
name(compo1, replace)


twoway ///
(bar sum1 cat if time==2, barwidth(1.9)) ///
(rbar sum1 sum2 cat if time==2, barwidth(1.9)) ///
(rbar sum2 sum3 cat if time==2, barwidth(1.9)) ///
, ///
xlabel(1 3 5 7 9 11 13 15 18, angle(45) valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2016-17") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
name(compo2, replace)


twoway ///
(bar sum1 cat if time==3, barwidth(1.9)) ///
(rbar sum1 sum2 cat if time==3, barwidth(1.9)) ///
(rbar sum2 sum3 cat if time==3, barwidth(1.9)) ///
, ///
xlabel(1 3 5 7 9 11 13 15 18, angle(45) valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2020-21") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
name(compo3, replace)

grc1leg compo1 compo2 compo3, col(3) name(comp, replace) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 626 in 2020-21.", size(vsmall))
graph export "Castecatinc2.png", as(png) replace


****************************************
* END


















****************************************
* Caste and occupations
****************************************
cls
use"panelocc_v2", clear

ta year

fre occupation
clonevar occupation2=occupation
order occupation2, after(occupation)
recode occupation2 (5=4) (6=5) (7=6)
label define occupcode2 1"Agri SE" 2"Agri casual" 3"Casual" 4"Reg" 5"SE" 6"MGNREGA"
label values occupation2 occupcode2

ta occupation
ta occupation2

ta occupation2 caste, col nofreq chi2

ta occupation2 caste if year==2010, row nofreq chi2
ta occupation2 caste if year==2016, row nofreq chi2
ta occupation2 caste if year==2020, row nofreq chi2


***** Graph
import excel "CastesOccupations2.xlsx", sheet("Sheet1") firstrow clear
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time

recode occupation (1=1) (2=3) (3=5) (4=7) (5=9) (6=11) (7=14)

label define occupation 1"Agri SE" 3"Agri casual" 5"Casual" 7"Reg" 9"SE" 11"MGNREGA" 14"Total"
label values occupation occupation

gen sum1=share_dalits
gen sum2=sum1+share_middle
gen sum3=sum2+share_upper


* By year
twoway ///
(bar sum1 occupation if time==1, barwidth(1.9)) ///
(rbar sum1 sum2 occupation if time==1, barwidth(1.9)) ///
(rbar sum2 sum3 occupation if time==1, barwidth(1.9)) ///
, ///
xlabel(1 3 5 7 9 11 14, angle(45) valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2010") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
note("Pearson Chi2(12)=160.94   Pr=0.00", size(small)) ///
name(compo1, replace)

twoway ///
(bar sum1 occupation if time==2, barwidth(1.9)) ///
(rbar sum1 sum2 occupation if time==2, barwidth(1.9)) ///
(rbar sum2 sum3 occupation if time==2, barwidth(1.9)) ///
, ///
xlabel(1 3 5 7 9 11 14, angle(45) valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2016-17") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
note("Pearson Chi2(12)=240.48   Pr=0.00", size(small)) ///
name(compo2, replace)

twoway ///
(bar sum1 occupation if time==3, barwidth(1.9)) ///
(rbar sum1 sum2 occupation if time==3, barwidth(1.9)) ///
(rbar sum2 sum3 occupation if time==3, barwidth(1.9)) ///
, ///
xlabel(1 3 5 7 9 11 14, angle(45) valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2020-21") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
note("Pearson Chi2(8)=162.56   Pr=0.00", size(small)) ///
name(compo3, replace)


grc1leg compo1 compo2 compo3, col(3) name(comp, replace) note("{it:Note:} For 1343 occupations in 2010, 1952 in 2016-17, and 2616 in 2020-21.", size(vsmall))
graph export "Occupations.png", as(png) replace

****************************************
* END


















****************************************
* Decomposition GE by caste
****************************************
use"panel_v4", clear


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












****************************************
* ELMO (2008) : avec 3 groupes (les trois castes)
****************************************
use"panel_v4", clear

********** Pour 3 groupes
* Prepa orga
foreach year in 2010 2016 2020 {
preserve
keep if year==`year'
sort monthlyincome_pc
gen n=_n
local maxge0=0
local maxge1=0
local maxge2=0

* Création des groupes
foreach x in 123 132 213 231 312 321 {
quietly {
gen comb`x'=.
local c=0
forvalues i=1/3 {
local n`i'=substr("`x'",`i',1)
}
local j=1
foreach i in `n1' `n2' `n3' {
count if caste==`i'
local c=r(N)+`c'
dis `c'
replace comb`x'=`j' if n<=`c' & comb`x'==.
local j=`j'+1
}
}

* Ineqdeco pour chaque groupe
qui ineqdeco monthlyincome_pc, by(comb`x')
local ge0=r(between_ge0)
if `ge0'>`maxge0' {
	local maxge0=`ge0'
}
local ge1=r(between_ge1)
if `ge1'>`maxge1' {
	local maxge1=`ge1'
}
local ge2=r(between_ge2)
if `ge2'>`maxge2' {
	local maxge2=`ge2'
}
}
dis `maxge0'
dis `maxge1'
dis `maxge2'
restore
}
****************************************
* END














****************************************
* Decomposition GE by jatis for Dalits
****************************************
macro drop _all 
use"panel_v4", clear


* Selection
keep if caste==1
ta year

***** Stat
cls
* 2010
ineqdeco monthlyincome_pc if year==2010, by(jatis)

cls
* 2016
ineqdeco monthlyincome_pc if year==2016, by(jatis)

cls
* 2020
ineqdeco monthlyincome_pc if year==2020, by(jatis)


********** Pour 2 groupes
* Prepa orga
fre jatis
recode jatis (1=1) (11=2)
fre jatis
foreach year in 2010 2016 2020 {
preserve
keep if year==`year'
sort monthlyincome_pc
gen n=_n
local maxge0=0
local maxge1=0
local maxge2=0

* Création des groupes
foreach x in 12 21 {
quietly {
gen comb`x'=.
local c=0
forvalues i=1/2 {
local n`i'=substr("`x'",`i',1)
}
local j=1
foreach i in `n1' `n2' {
count if jatis==`i'
local c=r(N)+`c'
dis `c'
replace comb`x'=`j' if n<=`c' & comb`x'==.
local j=`j'+1
}
}

* Ineqdeco pour chaque groupe
qui ineqdeco monthlyincome_pc, by(comb`x')
local ge0=r(between_ge0)
if `ge0'>`maxge0' {
	local maxge0=`ge0'
}
local ge1=r(between_ge1)
if `ge1'>`maxge1' {
	local maxge1=`ge1'
}
local ge2=r(between_ge2)
if `ge2'>`maxge2' {
	local maxge2=`ge2'
}
}
dis `maxge0'
dis `maxge1'
dis `maxge2'
restore
}
****************************************
* END

















****************************************
* Decomposition GE by jatis for Middle
****************************************
macro drop _all 
use"panel_v4", clear


* Selection
keep if caste==2
ta year

***** Stat
cls
* 2010
ineqdeco monthlyincome_pc if year==2010, by(jatis)

cls
* 2016
ineqdeco monthlyincome_pc if year==2016, by(jatis)

cls
* 2020
ineqdeco monthlyincome_pc if year==2020, by(jatis)


********** Pour 2 groupes
* Prepa orga
fre jatis
recode jatis (2=1) (4=2) (7=3) (9=4) (12=5)
fre jatis
foreach year in 2010 2016 2020 {
preserve
keep if year==`year'
sort monthlyincome_pc
gen n=_n
local maxge0=0
local maxge1=0
local maxge2=0

* Création des groupes
foreach x in ///
12345 12354 12435 12453 12534 12543 13245 13254 13425 13452 13524 13542 14235 14253 14325 14352 14523 14532 15234 15243 15324 15342 15423 15432 21345 21354 21435 21453 21534 21543 23145 23154 23415 23451 23514 23541 24135 24153 24315 24351 24513 24531 25134 25143 25314 25341 25413 25431 31245 31254 31425 31452 31524 31542 32145 32154 32415 32451 32514 32541 34125 34152 34215 34251 34512 34521 35124 35142 35214 35241 35412 35421 41235 41253 41325 41352 41523 41532 42135 42153 42315 42351 42513 42531 43125 43152 43215 43251 43512 43521 45123 45132 45213 45231 45312 45321 51234 51243 51324 51342 51423 51432 52134 52143 52314 52341 52413 52431 53124 53142 53214 53241 53412 53421 54123 54132 54213 54231 54312 54321 {
quietly {
gen comb`x'=.
local c=0
forvalues i=1/5 {
local n`i'=substr("`x'",`i',1)
}
local j=1
foreach i in `n1' `n2' `n3' `n4' `n5' {
count if jatis==`i'
local c=r(N)+`c'
dis `c'
replace comb`x'=`j' if n<=`c' & comb`x'==.
local j=`j'+1
}
}

* Ineqdeco pour chaque groupe
qui ineqdeco monthlyincome_pc, by(comb`x')
local ge0=r(between_ge0)
if `ge0'>`maxge0' {
	local maxge0=`ge0'
}
local ge1=r(between_ge1)
if `ge1'>`maxge1' {
	local maxge1=`ge1'
}
local ge2=r(between_ge2)
if `ge2'>`maxge2' {
	local maxge2=`ge2'
}
}
dis `maxge0'
dis `maxge1'
dis `maxge2'
restore
}
****************************************
* END
























****************************************
* Decomposition GE by jatis for Upper
****************************************
macro drop _all 
use"panel_v4", clear

* Selection
keep if caste==3
ta year

***** Stat
cls
* 2010
ineqdeco monthlyincome_pc if year==2010, by(jatis)

cls
* 2016
ineqdeco monthlyincome_pc if year==2016, by(jatis)

cls
* 2020
ineqdeco monthlyincome_pc if year==2020, by(jatis)


********** Pour 2 groupes
* Prepa orga
fre jatis
recode jatis (3=1) (5=2) (6=3) (8=4) (10=5)
fre jatis
foreach year in 2010 2016 2020 {
preserve
keep if year==`year'
sort monthlyincome_pc
gen n=_n
local maxge0=0
local maxge1=0
local maxge2=0

* Création des groupes
foreach x in ///
12345 12354 12435 12453 12534 12543 13245 13254 13425 13452 13524 13542 14235 14253 14325 14352 14523 14532 15234 15243 15324 15342 15423 15432 21345 21354 21435 21453 21534 21543 23145 23154 23415 23451 23514 23541 24135 24153 24315 24351 24513 24531 25134 25143 25314 25341 25413 25431 31245 31254 31425 31452 31524 31542 32145 32154 32415 32451 32514 32541 34125 34152 34215 34251 34512 34521 35124 35142 35214 35241 35412 35421 41235 41253 41325 41352 41523 41532 42135 42153 42315 42351 42513 42531 43125 43152 43215 43251 43512 43521 45123 45132 45213 45231 45312 45321 51234 51243 51324 51342 51423 51432 52134 52143 52314 52341 52413 52431 53124 53142 53214 53241 53412 53421 54123 54132 54213 54231 54312 54321 {
quietly {
gen comb`x'=.
local c=0
forvalues i=1/5 {
local n`i'=substr("`x'",`i',1)
}
local j=1
foreach i in `n1' `n2' `n3' `n4' `n5' {
count if jatis==`i'
local c=r(N)+`c'
dis `c'
replace comb`x'=`j' if n<=`c' & comb`x'==.
local j=`j'+1
}
}

* Ineqdeco pour chaque groupe
qui ineqdeco monthlyincome_pc, by(comb`x')
local ge0=r(between_ge0)
if `ge0'>`maxge0' {
	local maxge0=`ge0'
}
local ge1=r(between_ge1)
if `ge1'>`maxge1' {
	local maxge1=`ge1'
}
local ge2=r(between_ge2)
if `ge2'>`maxge2' {
	local maxge2=`ge2'
}
}
dis `maxge0'
dis `maxge1'
dis `maxge2'
restore
}
****************************************
* END

















****************************************
* Income by decile for each year
****************************************
use"panel_v4", clear

* Decile
foreach i in 2010 2016 2020 {
xtile incgrp`i'=annualincome_HH3 if year==`i', n(10)
}
gen incgroup=.
foreach i in 2010 2016 2020 {
replace incgroup=incgrp`i' if year==`i'
drop incgrp`i' 
}

foreach x in s_agrise_HH s_agrica_HH s_casual_HH s_regula_HH s_selfem_HH s_mgnreg_HH s_pensio_HH s_remitt_HH {
replace `x'=`x'*100
}

collapse (mean) s_agrise_HH s_agrica_HH s_casual_HH s_regula_HH s_selfem_HH s_mgnreg_HH s_pensio_HH s_remitt_HH, by(time incgroup)

gen sum1=s_agrise_HH
gen sum2=sum1+s_agrica_HH
gen sum3=sum2+s_casual_HH
gen sum4=sum3+s_regula_HH
gen sum5=sum4+s_selfem_HH
gen sum6=sum5+s_mgnreg_HH
gen sum7=sum6+s_pensio_HH
gen sum8=sum7+s_remitt_HH

* By year
twoway ///
(area sum1 incgroup if time==1) ///
(rarea sum1 sum2 incgroup if time==1) ///
(rarea sum2 sum3 incgroup if time==1) ///
(rarea sum3 sum4 incgroup if time==1) ///
(rarea sum4 sum5 incgroup if time==1) ///
(rarea sum5 sum6 incgroup if time==1) ///
(rarea sum6 sum7 incgroup if time==1) ///
(rarea sum7 sum8 incgroup if time==1) ///
, ///
xlabel(1(1)10) xtitle("Decile of income per capita") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2010") ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA" 7 "Pension" 8 "Remittances") pos(6) col(4)) ///
name(compo1, replace)

twoway ///
(area sum1 incgroup if time==2) ///
(rarea sum1 sum2 incgroup if time==2) ///
(rarea sum2 sum3 incgroup if time==2) ///
(rarea sum3 sum4 incgroup if time==2) ///
(rarea sum4 sum5 incgroup if time==2) ///
(rarea sum5 sum6 incgroup if time==2) ///
(rarea sum6 sum7 incgroup if time==2) ///
(rarea sum7 sum8 incgroup if time==2) ///
, ///
xlabel(1(1)10) xtitle("Decile of income per capita") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2016-17") ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA" 7 "Pension" 8 "Remittances") pos(6) col(4)) ///
name(compo2, replace)

twoway ///
(area sum1 incgroup if time==3) ///
(rarea sum1 sum2 incgroup if time==3) ///
(rarea sum2 sum3 incgroup if time==3) ///
(rarea sum3 sum4 incgroup if time==3) ///
(rarea sum4 sum5 incgroup if time==3) ///
(rarea sum5 sum6 incgroup if time==3) ///
(rarea sum6 sum7 incgroup if time==3) ///
(rarea sum7 sum8 incgroup if time==3) ///
, ///
xlabel(1(1)10) xtitle("Decile of income per capita") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2020-21") ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA" 7 "Pension" 8 "Remittances") pos(6) col(4)) ///
name(compo3, replace)


grc1leg compo1 compo2 compo3, col(3) name(compo, replace)
graph export "Compositionincome.png", as(png) replace

****************************************
* END
