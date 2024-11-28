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
* Growth rate of income and wealth by caste
****************************************

********** Income
use"panel_v3", clear

rename monthlyincome income_m
gen income_se=income_m
gen income_iqr=income_m

collapse (mean) income_m (semean) income_se (iqr) income_iqr, by(caste year)

* 95 CI
gen income_lb=income_m-(income_se*1.96)
gen income_ub=income_m+(income_se*1.96)

*
twoway ///
(connected income_m year if caste==1, color(ply1)) ///
(rarea income_ub income_lb year if caste==1, color(ply1%10)) ///
(connected income_m year if caste==2, color(plr1)) ///
(rarea income_ub income_lb year if caste==2, color(plr1%10)) ///
(connected income_m year if caste==3, color(plg1)) ///
(rarea income_ub income_lb year if caste==3, color(plg1%10)) ///
, title("Monthly income") ytitle("1k rupees") ylabel(10(3)25) ///
xtitle("") ///
legend(order(1 "Dalits" 3 "Middle castes" 5 "Upper castes") pos(6) col(3)) ///
scale(1.2) name(inc, replace)




********** Wealth
use"panel_v3", clear

rename assets_total assets_m
gen assets_se=assets_m
gen assets_iqr=assets_m

collapse (mean) assets_m (semean) assets_se (iqr) assets_iqr, by(caste year)

* 95 CI
gen assets_lb=assets_m-(assets_se*1.96)
gen assets_ub=assets_m+(assets_se*1.96)

*
twoway ///
(connected assets_m year if caste==1, color(ply1)) ///
(rarea assets_ub assets_lb year if caste==1, color(ply1%10)) ///
(connected assets_m year if caste==2, color(plr1)) ///
(rarea assets_ub assets_lb year if caste==2, color(plr1%10)) ///
(connected assets_m year if caste==3, color(plg1)) ///
(rarea assets_ub assets_lb year if caste==3, color(plg1%10)) ///
, title("Wealth") ytitle("1k rupees") ylabel(0(1000)5000) ///
xtitle("") ///
legend(order(1 "Dalits" 3 "Middle castes" 5 "Upper castes") pos(6) col(3)) ///
scale(1.2) name(ass, replace)




*********** Combine
grc1leg inc ass, note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 625 in 2020-21.", size(vsmall))
graph export "graph_HH/Level_caste_HH.png", as(png) replace


****************************************
* END















****************************************
* Quintiles of income by caste
****************************************
use"panel_v3", clear

foreach i in 2010 2016 2020 {
xtile q_inc_`i'=monthlyincome if year==`i', n(5)
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
import excel "Quintiles.xlsx", sheet("Income_HH") firstrow clear
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
note("Pearson Chi2(8)=6.94   Pr=0.54", size(small)) ///
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
note("Pearson Chi2(8)=17.17   Pr=0.03", size(small)) ///
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
note("Pearson Chi2(8)=15.98   Pr=0.04", size(small)) ///
name(compo3, replace)

grc1leg compo1 compo2 compo3, col(3) name(comp, replace) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 625 in 2020-21.", size(vsmall))
graph export "graph_HH/Quintinc_caste_HH.png", as(png) replace

****************************************
* END













****************************************
* Quintiles of assets by caste
****************************************
use"panel_v3", clear

foreach i in 2010 2016 2020 {
xtile q_ass_`i'=assets_total if year==`i', n(5)
}

gen q_ass=.
foreach i in 2010 2016 2020 {
replace q_ass=q_ass_`i' if year==`i'
drop q_ass_`i'
}


*** 
ta q_ass caste if year==2010, row nofreq chi2
ta q_ass caste if year==2016, row nofreq chi2
ta q_ass caste if year==2020, row nofreq chi2


***** Graph
import excel "Quintiles.xlsx", sheet("Wealth_HH") firstrow clear
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
note("Pearson Chi2(8)=50.57   Pr=0.00", size(small)) ///
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
note("Pearson Chi2(8)=70.25   Pr=0.00", size(small)) ///
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
note("Pearson Chi2(8)=52.85   Pr=0.00", size(small)) ///
name(compo3, replace)

grc1leg compo1 compo2 compo3, col(3) name(comp, replace) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 625 in 2020-21.", size(vsmall))
graph export "graph_HH/Quintass_caste_HH.png", as(png) replace

****************************************
* END















****************************************
* Source and caste
****************************************
use"panel_v3", clear

********** Stat income
* 2010
cls
preserve
keep if year==2010
foreach x in d_agrise d_agrica d_casual d_regul d_selfem d_mgnreg d_pensio d_remitt {
ta `x' caste, col nofreq
}
restore

* 2016-17
cls
preserve
keep if year==2016
foreach x in d_agrise d_agrica d_casual d_regul d_selfem d_mgnreg d_pensio d_remitt {
ta `x' caste, col nofreq
}
restore

* 2020-21
cls
preserve
keep if year==2020
foreach x in d_agrise d_agrica d_casual d_regul d_selfem d_mgnreg d_pensio d_remitt {
ta `x' caste, col nofreq
}
restore



********** Stat assets
* 2010
cls
preserve
keep if year==2010
foreach x in d_house d_livestock d_goods d_land d_gold d_savings {
recode `x' (.=0)
ta `x' caste, col nofreq
}
restore

* 2016-17
cls
preserve
keep if year==2016
foreach x in d_house d_livestock d_goods d_land d_gold d_savings {
recode `x' (.=0)
ta `x' caste, col nofreq
}
restore

* 2020-21
cls
preserve
keep if year==2020
foreach x in d_house d_livestock d_goods d_land d_gold d_savings {
recode `x' (.=0)
ta `x' caste, col nofreq
}
restore

****************************************
* END













****************************************
* Source and caste
****************************************

********** Income
import excel "Sources_caste.xlsx", sheet("Income") firstrow clear
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time
label define cat 1"Agri SE" 2"Agri casual" 3"Casual" 4"Reg" 5"SE" 6"MGNREGA" 7"Pensions" 8"Remittances" 9"Total"
label values cat cat

* Graph 
set graph off
graph bar dalits middle upper if time==1, over(cat, label(angle(45))) title("2010") ytitle("Percent") legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") col(3) pos(6)) name(g1, replace) ylabel(0(10)80)

graph bar dalits middle upper if time==2, over(cat, label(angle(45))) title("2016-17") ytitle("Percent") legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") col(3) pos(6)) name(g2, replace) ylabel(0(10)80)

graph bar dalits middle upper if time==3, over(cat, label(angle(45))) title("2020-21") ytitle("Percent") legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") col(3) pos(6)) name(g3, replace) ylabel(0(10)80)
set graph on

grc1leg g1 g2 g3, col(3) name(inc, replace) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 625 in 2020-21.", size(vsmall))
graph export "graph_HH/Source_caste_inc.png", as(png)


********** Assets
import excel "Sources_caste.xlsx", sheet("Wealth") firstrow clear
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time
label define cat 1"House" 2"Livestock" 3"Durable goods" 4"Land" 5"Gold" 6"Savings"
label values cat cat

* Graph 
set graph off
graph bar dalits middle upper if time==1, over(cat, label(angle(45))) title("2010") ytitle("Percent") legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") col(3) pos(6)) name(g1, replace) ylabel(0(10)100)

graph bar dalits middle upper if time==2, over(cat, label(angle(45))) title("2016-17") ytitle("Percent") legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") col(3) pos(6)) name(g2, replace) ylabel(0(10)100)

graph bar dalits middle upper if time==3, over(cat, label(angle(45))) title("2020-21") ytitle("Percent") legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") col(3) pos(6)) name(g3, replace) ylabel(0(10)100)
set graph on

grc1leg g1 g2 g3, col(3) name(ass, replace) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 625 in 2020-21.", size(vsmall))
graph export "graph_HH/Source_caste_ass.png", as(png)


****************************************
* END

















****************************************
* Population share vs income and assets shares
****************************************

********** Stat
use"panel_v3", clear

*** Income
cls
* 2010
ineqdeco monthlyincome if year==2010, by(caste)

cls
* 2016
ineqdeco monthlyincome if year==2016, by(caste)

cls
* 2020
ineqdeco monthlyincome if year==2020, by(caste)


*** Assets
cls
* 2010
ineqdeco assets_total if year==2010, by(caste)

cls
* 2016
ineqdeco assets_total if year==2016, by(caste)

cls
* 2020
ineqdeco assets_total if year==2020, by(caste)





********** Graph
import excel "Pop_shares.xlsx", sheet("HH") firstrow clear
drop if year==.
label define caste 1"Dalits" 2"Middle castes" 3"Upper castes"
label values caste caste
label define year 1"2010" 2"2016-17" 3"2020-21"
label values year year
* 
graph bar (mean) pop income wealth, over(year) over(caste) ///
ylabel(0(10)60) ymtick(0(5)60) ytitle("Percent") ///
legend(order(1 "Share in the population" 2 "Share in the total monthly income" 3 "Share in the total wealth") col(1) pos(6)) scale(1.2) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 625 in 2020-21.", size(vsmall))
graph export "graph_HH/Shares_HH.png", as(png) replace

****************************************
* END
