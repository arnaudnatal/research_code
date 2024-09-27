*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*September 9, 2024
*-----
gl link = "assetsinequalities"
*Desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\assetsinequalities.do"
*-------------------------










****************************************
* Evolution of assets level by caste
****************************************
use"panel_v1", clear

rename assets_total assets_m
gen assets_se=assets_m
gen assets_iqr=assets_m

collapse (mean) assets_m (semean) assets_se (iqr) assets_iqr, by(caste year)

* 95 CI
gen assets_lb=assets_m-(assets_se*1.96)
gen assets_ub=assets_m+(assets_se*1.96)

* Growth rate
reshape wide assets_m assets_se assets_iqr assets_lb assets_ub, i(caste) j(year)
gen growth2010=100
gen growth2016=assets_m2016*100/assets_m2010
gen growth2020=assets_m2020*100/assets_m2010
reshape long assets_m assets_se assets_iqr assets_lb assets_ub growth, i(caste) j(year)



***** Assets level
twoway ///
(connected assets_m year if caste==1, color(ply1)) ///
(rarea assets_ub assets_lb year if caste==1, color(ply1%10)) ///
(connected assets_m year if caste==2, color(plr1)) ///
(rarea assets_ub assets_lb year if caste==2, color(plr1%10)) ///
(connected assets_m year if caste==3, color(plg1)) ///
(rarea assets_ub assets_lb year if caste==3, color(plg1%10)) ///
, title("Assets") ytitle("1k rupees") ylabel(0(500)5000) ///
xtitle("") ///
legend(order(1 "Dalits" 3 "Middle castes" 5 "Upper castes") pos(6) col(3)) ///
scale(1.2) name(assetscaste, replace)


***** Growth rate
twoway ///
(connected growth year if caste==1, color(ply1)) ///
(connected growth year if caste==2, color(plr1)) ///
(connected growth year if caste==3, color(plg1)) ///
, title("Growth rate (base 100 in 2010)") ytitle("") ylabel(40(10)100) ///
xtitle("") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
scale(1.2) name(growthcaste, replace)


***** Combine
grc1leg assetscaste growthcaste, name(combcaste, replace) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 626 in 2020-21.", size(vsmall))
graph export "Assets_caste.png", as(png) replace


****************************************
* END















****************************************
* Quintiles of assets by caste
****************************************
use"panel_v1", clear

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
note("Pearson Chi2(8)=51.57   Pr=0.00", size(small)) ///
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
note("Pearson Chi2(8)=53.22   Pr=0.00", size(small)) ///
name(compo3, replace)

grc1leg compo1 compo2 compo3, col(3) name(comp, replace) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 626 in 2020-21.", size(vsmall))
graph export "Quintile.png", as(png) replace

****************************************
* END




















****************************************
* Caste and wealth
****************************************
use"panel_v1", clear

* 2010
cls
preserve
keep if year==2010
foreach x in dum_house dum_livestock dum_goods dum_land dum_gold dum_savings {
recode `x' (.=0)
ta `x' caste, row nofreq
}
restore

* 2016-17
cls
preserve
keep if year==2016
foreach x in dum_house dum_livestock dum_goods dum_land dum_gold dum_savings {
recode `x' (.=0)
ta `x' caste, row nofreq
}
restore

* 2020-21
cls
preserve
keep if year==2020
foreach x in dum_house dum_livestock dum_goods dum_land dum_gold dum_savings {
recode `x' (.=0)
ta `x' caste, row nofreq
}
restore


*****
import excel "CasteWealth.xlsx", sheet("Sheet1") firstrow clear
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time
label define cat 1"House" 2"Livestock" 3"Duable goods" 4"Land" 5"Gold" 6"Savings" 7"Total"
label values cat cat

* Graph 2
gen sum1=dalits
gen sum2=sum1+middle
gen sum3=sum2+upper
recode cat (1=1) (2=3) (3=5) (4=7) (5=9) (6=11) (7=14)

label define cat 1"House" 3"Livestock" 5"Duable goods" 7"Land" 9"Gold" 11"Savings" 14"Total", replace
label values cat cat

twoway ///
(bar sum1 cat if time==1, barwidth(1.9)) ///
(rbar sum1 sum2 cat if time==1, barwidth(1.9)) ///
(rbar sum2 sum3 cat if time==1, barwidth(1.9)) ///
, ///
xlabel(1 3 5 7 9 11 14, angle(45) valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2010") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
name(compo1, replace)


twoway ///
(bar sum1 cat if time==2, barwidth(1.9)) ///
(rbar sum1 sum2 cat if time==2, barwidth(1.9)) ///
(rbar sum2 sum3 cat if time==2, barwidth(1.9)) ///
, ///
xlabel(1 3 5 7 9 11 14, angle(45) valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2016-17") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
name(compo2, replace)


twoway ///
(bar sum1 cat if time==3, barwidth(1.9)) ///
(rbar sum1 sum2 cat if time==3, barwidth(1.9)) ///
(rbar sum2 sum3 cat if time==3, barwidth(1.9)) ///
, ///
xlabel(1 3 5 7 9 11 14, angle(45) valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2020-21") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
name(compo3, replace)

grc1leg compo1 compo2 compo3, col(3) name(comp, replace) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 626 in 2020-21.", size(vsmall))
graph export "Castecatwealth2.png", as(png) replace


****************************************
* END


















****************************************
* Caste and wealth II
****************************************
use"panel_v1", clear

* 2010
cls
preserve
keep if year==2010
foreach x in dum_house dum_livestock dum_goods dum_land dum_gold dum_savings {
recode `x' (.=0)
ta `x' caste, col nofreq
}
restore

* 2016-17
cls
preserve
keep if year==2016
foreach x in dum_house dum_livestock dum_goods dum_land dum_gold dum_savings {
recode `x' (.=0)
ta `x' caste, col nofreq
}
restore

* 2020-21
cls
preserve
keep if year==2020
foreach x in dum_house dum_livestock dum_goods dum_land dum_gold dum_savings {
recode `x' (.=0)
ta `x' caste, col nofreq
}
restore

*****
import excel "CasteWealth.xlsx", sheet("Sheet2") firstrow clear
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time
label define cat 1"House" 2"Livestock" 3"Duable goods" 4"Land" 5"Gold" 6"Savings"
label values cat cat

* Graph 
set graph off
graph bar dalits middle upper if time==1, over(cat, label(angle(45))) title("2010") ytitle("Percentage") legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") col(3) pos(6)) name(g1, replace) ylabel(0(10)100)

graph bar dalits middle upper if time==2, over(cat, label(angle(45))) title("2016-17") ytitle("Percentage") legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") col(3) pos(6)) name(g2, replace) ylabel(0(10)100)

graph bar dalits middle upper if time==3, over(cat, label(angle(45))) title("2020-21") ytitle("Percentage") legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") col(3) pos(6)) name(g3, replace) ylabel(0(10)100)
set graph on

grc1leg g1 g2 g3, col(3) name(comb, replace)
*graph export "Castecatinc.png", as(png) replace


****************************************
* END



























****************************************
* Compo assets by caste for each year
****************************************
use"panel_v1", clear

collapse (mean) s_house s_livestock s_goods s_land s_gold s_savings, by(time caste)

gen sum1=s_house
gen sum2=sum1+s_livestock
gen sum3=sum2+s_goods
gen sum4=sum3+s_land
gen sum5=sum4+s_gold
gen sum6=sum5+s_savings

* By year
twoway ///
(bar sum1 caste if time==1, barwidth(0.95)) ///
(rbar sum1 sum2 caste if time==1, barwidth(0.95)) ///
(rbar sum2 sum3 caste if time==1, barwidth(0.95)) ///
(rbar sum3 sum4 caste if time==1, barwidth(0.95)) ///
(rbar sum4 sum5 caste if time==1, barwidth(0.95)) ///
(rbar sum5 sum6 caste if time==1, barwidth(0.95)) ///
, ///
xlabel(1(1)3, valuelabel angle(45)) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2010") ///
legend(order(1 "House" 2 "Livestock" 3 "Durable goods" 4 "Land" 5 "Gold" 6 "Saving") pos(6) col(3)) ///
name(compo1, replace)

twoway ///
(bar sum1 caste if time==2, barwidth(0.95)) ///
(rbar sum1 sum2 caste if time==2, barwidth(0.95)) ///
(rbar sum2 sum3 caste if time==2, barwidth(0.95)) ///
(rbar sum3 sum4 caste if time==2, barwidth(0.95)) ///
(rbar sum4 sum5 caste if time==2, barwidth(0.95)) ///
(rbar sum5 sum6 caste if time==2, barwidth(0.95)) ///
, ///
xlabel(1(1)3, valuelabel angle(45)) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2016-17") ///
legend(order(1 "House" 2 "Livestock" 3 "Durable goods" 4 "Land" 5 "Gold" 6 "Saving") pos(6) col(3)) ///
name(compo2, replace)

twoway ///
(bar sum1 caste if time==3, barwidth(0.95)) ///
(rbar sum1 sum2 caste if time==3, barwidth(0.95)) ///
(rbar sum2 sum3 caste if time==3, barwidth(0.95)) ///
(rbar sum3 sum4 caste if time==3, barwidth(0.95)) ///
(rbar sum4 sum5 caste if time==3, barwidth(0.95)) ///
(rbar sum5 sum6 caste if time==3, barwidth(0.95)) ///
, ///
xlabel(1(1)3, valuelabel angle(45)) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
title("2020-21") ///
legend(order(1 "House" 2 "Livestock" 3 "Durable goods" 4 "Land" 5 "Gold" 6 "Saving") pos(6) col(3)) ///
name(compo3, replace)


grc1leg compo1 compo2 compo3, col(3) name(compo, replace)
graph export "Compositionassets_caste.png", as(png) replace

****************************************
* END
