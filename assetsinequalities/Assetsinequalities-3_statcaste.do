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
* Decomposition GE by caste
****************************************
use"panel_v1", clear


***** Stat
cls
* 2010
ineqdeco assets_total if year==2010, by(caste)

cls
* 2016
ineqdeco assets_total if year==2016, by(caste)

cls
* 2020
ineqdeco assets_total if year==2020, by(caste)


***** Std Err.
ineqerr assets_total if year==2010, reps(200)
ineqerr assets_total if year==2016, reps(200)
ineqerr assets_total if year==2020, reps(200)


****************************************
* END











****************************************
* Pop and assets share
****************************************
import excel "Statdesc.xlsx", sheet("GE_caste2") firstrow clear
drop if year==.
label define caste 1"Dalits" 2"Middle castes" 3"Upper castes"
label values caste caste
replace popshare=popshare*100
replace assetsshare=assetsshare*100

* Ratio détenu/population
gen ratio=assetsshare*100/popshare



********** Graph bar
graph bar (mean) popshare assetsshare, over(year) over(caste) ///
ylabel(0(10)60) ymtick(0(5)65) ytitle("Percent") ///
legend(order(1 "Share in the population" 2 "Share in the total wealth") col(2) pos(6))
graph export "Shareincshareass.png", as(png) replace



********** Graph with ratio
twoway ///
(connected ratio year if caste==1, yline(100)) ///
(connected ratio year if caste==2) ///
(connected ratio year if caste==3) ///
, title("Ratio between shares") ///
ytitle("Percent") ylabel(40(20)160) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) name(g, replace)

graph export "Ratioshareincshareass.png", as(png) replace


****************************************
* END













****************************************
* ELMO (2008)
****************************************
use"panel_v1", clear

cls
foreach y in 2010 2016 2020 {
preserve
quietly {
keep if year==`y'
sort assets_total
gen n=_n

* Local pour compter tout seul
count if caste==1
local D=r(N)

count if caste==2
local M=r(N)

count if caste==3
local U=r(N)

* DMU
gen comb1=.
replace comb1=1 if n<=`D'
replace comb1=2 if n>`D' & n<=(`D'+`M')
replace comb1=3 if n>(`D'+`M')

* DUM
gen comb2=.
replace comb2=1 if n<=`D'
replace comb2=2 if n>`D' & n<=(`D'+`U')
replace comb2=3 if n>(`D'+`U')

* MDU
gen comb3=.
replace comb3=1 if n<=`M'
replace comb3=2 if n>`M' & n<=(`M'+`D')
replace comb3=3 if n>(`M'+`D')

* MUD
gen comb4=.
replace comb4=1 if n<=`M'
replace comb4=2 if n>`M' & n<=(`M'+`U')
replace comb4=3 if n>(`M'+`U')

* UMD
gen comb5=.
replace comb5=1 if n<=`U'
replace comb5=2 if n>`U' & n<=(`U'+`M')
replace comb5=3 if n>(`U'+`M')

* UDM
gen comb6=.
replace comb6=1 if n<=`U'
replace comb6=2 if n>`U' & n<=(`U'+`D')
replace comb6=3 if n>(`U'+`D')
}

* Standard between to choose max
dis "`y'" _newline
forvalues i=1(1)6 {
qui ineqdeco assets_total if year==`y', by(comb`i')
foreach x in ge0 ge1 ge2 within_ge0 within_ge1 within_ge2 between_ge0 between_ge1 between_ge2 {
local `x'=round(r(`x'),0.001)
}
dis _skip(3) "GE(0)" _skip(2) "GE(1)" _skip(2) "GE(2)" _newline ///
"B" _skip(2) "`between_ge0'" _skip(3) "`between_ge1'" _skip(3) "`between_ge2'"
}
restore
}


****************************************
* END















****************************************
* Graph within
****************************************
import excel "GE.xlsx", sheet("Sheet1") firstrow clear
label define type 1"Level" 2"Base100"
label values type type

* Level within
twoway ///
(connected w_GE0 year if type==1) ///
(connected w_GE1 year if type==1) ///
(connected w_GE2 year if type==1) ///
, title("Share of {it:within} inequalities") ///
ytitle("Percent") ylabel(82(2)96) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "GE(0)" 2 "GE(1)" 3 "GE(2)") pos(6) col(3)) name(sw, replace) scale(1.2)


* Base 100 within
twoway ///
(connected w_GE0 year if type==2) ///
(connected w_GE1 year if type==3) ///
(connected w_GE2 year if type==2) ///
, title("{it:Within} growth (base 100 in 2010) ") ///
ytitle("") ylabel(94(2)108) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "GE(0)" 2 "GE(1)" 3 "GE(2)") pos(6) col(3)) name(bw, replace) scale(1.2)

* Combine
grc1leg sw bw, name(cw, replace)  note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 626 in 2020-21.", size(vsmall))
graph export "Within_caste.png", as(png) replace

****************************************
* END













****************************************
* Graph between
****************************************
import excel "GE.xlsx", sheet("Sheet1") firstrow clear
label define type 1"Level" 2"Base100"
label values type type

* Level between max
twoway ///
(connected bm_GE0 year if type==1) ///
(connected bm_GE1 year if type==1) ///
(connected bm_GE2 year if type==1) ///
, title("Share of {it:between} inequalities") ///
ytitle("Percent") ylabel(6(2)20) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "GE(0)" 2 "GE(1)" 3 "GE(2)") pos(6) col(3)) name(sbm, replace) scale(1.2)


* Base 100 between max
twoway ///
(connected bm_GE0 year if type==2) ///
(connected bm_GE1 year if type==3) ///
(connected bm_GE2 year if type==2) ///
, title("{it:Between} growth (base 100 in 2010) ") ///
ytitle("") ylabel(50(10)150) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "GE(0)" 2 "GE(1)" 3 "GE(2)") pos(6) col(3)) name(bbm, replace) scale(1.2)

* Combine
grc1leg sbm bbm, name(cbm, replace) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 626 in 2020-21.", size(vsmall))
graph export "Between_caste.png", as(png) replace


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
