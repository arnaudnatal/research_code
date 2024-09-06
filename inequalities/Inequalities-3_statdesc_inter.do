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
use"panel_v6", clear

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
use"panel_v6", clear

replace monthlyincome_pc=monthlyincome_mpc/1000
tabstat monthlyincome_pc, stat(mean) by(year)
tabstat monthlyincome_pc, stat(min p1 p5 p10 q p90 p95 p99 max) by(year)

local ub 18
violinplot monthlyincome_pc, over(time) horizontal left dscale(4) noline now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
title("Monthly income per capita") ///
xtitle("1k rupees") xlabel(0(2)`ub') ///
ylabel(,grid) ///
legend(order(4 "IQR" 7 "Median" 10 "Mean") pos(6) col(3) on) ///
aspectratio() scale(1.2) name(vio, replace) range(0 `ub')
graph export "Violin.png", as(png) replace

****************************************
* END









****************************************
* Ineq income
****************************************

***** Decile
use"panel_v6", clear
replace monthlyincome_pc=monthlyincome_pc/1000

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
ytitle("%") ylabel(0(5)35) ///
xtitle("Decile of income per capita") xlabel(1(1)10) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) name(decile, replace) scale(1.2)


***** Lorenz curves
use"panel_v6", clear

keep HHID_panel year monthlyincome_pc
reshape wide monthlyincome_pc, i(HHID_panel) j(year)
lorenz estimate monthlyincome_pc2010 monthlyincome_pc2016 monthlyincome_pc2020, gini
lorenz graph, overlay noci legend(pos(6) col(3) order(1 "2010" 2 "2016-17" 3 "2020-21")) xtitle("Population share") ytitle("Cumulative income proportion") title("Lorenz curves") xlabel(0(10)100) ylabel(0(.1)1) nodiagonal aspectratio() scale(1.2) name(lorenz, replace)


***** Combine
grc1leg decile lorenz, name(comb3, replace) note("{it:Note:} The Gini index is 0.326 in 2010, 0.432 in 2016-17 and 0.495 in 2020-21.", size(vsmall)) leg(lorenz)
graph export "IneqInc.png", as(png) replace


****************************************
* END


















****************************************
* Gini decomposition
****************************************

***** Decomposition Gini by income source
use"panel_v6", clear

global PC annualincome_compo2_pc incagrise_pc incagricasual_pc incnonagricasual_pc incnonagrireg_pc incnonagrise_pc incnrega_pc

descogini $PC if year==2010
descogini $PC if year==2016
descogini $PC if year==2020

* With pension and remittances
global PC annualincome_compo3_pc incagrise_pc incagricasual_pc incnonagricasual_pc incnonagrireg_pc incnonagrise_pc incnrega_pc pension_pc remreceived_pc

descogini $PC if year==2010
descogini $PC if year==2016
descogini $PC if year==2020



***** Graph
import excel "Gini.xlsx", sheet("Sheet1") firstrow clear
label define occupation 1"Agri self-employed" 2"Agri casual" 3"Casual" 4"Regular" 5"Self-employed" 6"MGNREGA"
label values occupation occupation

* Sk
twoway ///
(connected Sk year if occupation==1, yline(0, lcolor(black))) ///
(connected Sk year if occupation==2) ///
(connected Sk year if occupation==3) ///
(connected Sk year if occupation==4) ///
(connected Sk year if occupation==5) ///
(connected Sk year if occupation==6) ///
, title("Share in total income") ylabel(0(.1).5) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA") pos(6) col(3)) name(sk, replace)

* Gk
twoway ///
(connected Gk year if occupation==1, yline(0, lcolor(black))) ///
(connected Gk year if occupation==2) ///
(connected Gk year if occupation==3) ///
(connected Gk year if occupation==4) ///
(connected Gk year if occupation==5) ///
(connected Gk year if occupation==6) ///
,title("Income source Gini") ylabel(0.4(.1)1) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA") pos(6) col(3)) name(gk, replace)

* Rk
twoway ///
(connected Rk year if occupation==1, yline(0, lcolor(black))) ///
(connected Rk year if occupation==2) ///
(connected Rk year if occupation==3) ///
(connected Rk year if occupation==4) ///
(connected Rk year if occupation==5) ///
(connected Rk year if occupation==6) ///
, title("Gini correlation with income rankings") ylabel(-.4(.2)1) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA") pos(6) col(3)) name(rk, replace)

* Share
replace Share=0 if Share<0
twoway ///
(connected Share year if occupation==1, yline(0, lcolor(black))) ///
(connected Share year if occupation==2) ///
(connected Share year if occupation==3) ///
(connected Share year if occupation==4) ///
(connected Share year if occupation==5) ///
(connected Share year if occupation==6) ///
, title("Share in total-income inequality") ylabel(0(.1).6) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA") pos(6) col(3)) name(share, replace)

* Percentage
twoway ///
(connected Percentage year if occupation==1, yline(0, lcolor(black))) ///
(connected Percentage year if occupation==2) ///
(connected Percentage year if occupation==3) ///
(connected Percentage year if occupation==4) ///
(connected Percentage year if occupation==5) ///
(connected Percentage year if occupation==6) ///
, title("% change in Gini") ylabel(-.2(.1).2) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA") pos(6) col(3)) name(percentage, replace)

***** Combine
grc1leg sk gk rk share percentage, name(decompo, replace)
graph export "Decompo.png", as(png) replace

****************************************
* END



















****************************************
* Evolution of income level by caste
****************************************
use"panel_v6", clear

replace monthlyincome_pc=monthlyincome_pc/1000
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
grc1leg incomecaste growthcaste, name(combcaste, replace)
graph export "Income_caste.png", as(png) replace


****************************************
* END















****************************************
* Quintiles of income by caste
****************************************
use"panel_v6", clear

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
ylabel(0(10)100) ytitle("%") ///
title("2010") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
note("Pearson Chi2(8)=9.04   Pr=0.34", size(small)) ///
name(compo1, replace)

twoway ///
(bar sum1 quintile if time==2, barwidth(1.9)) ///
(rbar sum1 sum2 quintile if time==2, barwidth(1.9)) ///
(rbar sum2 sum3 quintile if time==2, barwidth(1.9)) ///
, ///
xlabel(1 3 5 7 9 12,valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("%") ///
title("2016-17") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
note("Pearson Chi2(8)=29.90   Pr=0.00", size(small)) ///
name(compo2, replace)

twoway ///
(bar sum1 quintile if time==3, barwidth(1.9)) ///
(rbar sum1 sum2 quintile if time==3, barwidth(1.9)) ///
(rbar sum2 sum3 quintile if time==3, barwidth(1.9)) ///
, ///
xlabel(1 3 5 7 9 12,valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("%") ///
title("2020-21") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
note("Pearson Chi2(8)=34.81   Pr=0.00", size(small)) ///
name(compo3, replace)

grc1leg compo1 compo2 compo3, col(3) name(comp, replace)
graph export "Quintile.png", as(png) replace

****************************************
* END


















****************************************
* Caste and occupations
****************************************
cls
use"panelocc_v2", clear

ta occupation caste, col nofreq chi2

ta occupation caste if year==2010, row nofreq chi2
ta occupation caste if year==2016, row nofreq chi2
ta occupation caste if year==2020, row nofreq chi2


***** Graph
import excel "CastesOccupations.xlsx", sheet("Sheet1") firstrow clear
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time

recode occupation (1=1) (2=3) (3=5) (4=7) (5=9) (6=11) (7=13) (8=16)

label define occupation 1"Agri self-employed" 3"Agri casual" 5"Casual" 7"Reg non-quali" 9"Reg qualified" 11"Self-employed" 13"MGNREGA" 16"Total"
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
xlabel(1 3 5 7 9 11 13 16, angle(45) valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("%") ///
title("2010") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
note("Pearson Chi2(12)=160.94   Pr=0.00", size(small)) ///
name(compo1, replace)

twoway ///
(bar sum1 occupation if time==2, barwidth(1.9)) ///
(rbar sum1 sum2 occupation if time==2, barwidth(1.9)) ///
(rbar sum2 sum3 occupation if time==2, barwidth(1.9)) ///
, ///
xlabel(1 3 5 7 9 11 13 16, angle(45) valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("%") ///
title("2016-17") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
note("Pearson Chi2(12)=240.48   Pr=0.00", size(small)) ///
name(compo2, replace)

twoway ///
(bar sum1 occupation if time==3, barwidth(1.9)) ///
(rbar sum1 sum2 occupation if time==3, barwidth(1.9)) ///
(rbar sum2 sum3 occupation if time==3, barwidth(1.9)) ///
, ///
xlabel(1 3 5 7 9 11 13 16, angle(45) valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("%") ///
title("2020-21") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
note("Pearson Chi2(8)=162.56   Pr=0.00", size(small)) ///
name(compo3, replace)


grc1leg compo1 compo2 compo3, col(3) name(comp, replace)
graph export "Occupations.png", as(png) replace

****************************************
* END


















****************************************
* Decomposition GE by caste
****************************************
use"panel_v6", clear

replace monthlyincome_pc=monthlyincome_pc/1000
ta monthlyincome_pc

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
* ELMO (2008)
****************************************
use"panel_v6", clear

replace monthlyincome_pc=monthlyincome_pc/1000
ta monthlyincome_pc

cls
foreach y in 2010 2016 2020 {
preserve
quietly {
keep if year==`y'
sort monthlyincome_pc
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
qui ineqdeco monthlyincome_pc if year==`y', by(comb`i')
foreach x in ge0 ge1 ge2 within_ge0 within_ge1 within_ge2 between_ge0 between_ge1 between_ge2 {
local `x'=round(r(`x'),0.001)
}
/*
dis _skip(3) "GE(0)" _skip(2) "GE(1)" _skip(2) "GE(2)" _newline ///
"O" _skip(2) "`ge0'" _skip(3)"`ge1'" _skip(3) "`ge2'"  _newline ///
"W" _skip(2) "`within_ge0'" _skip(3) "`within_ge1'" _skip(3) "`within_ge2'"  _newline ///
"B" _skip(2) "`between_ge0'" _skip(3) "`between_ge1'" _skip(3) "`between_ge2'"
*/
dis _skip(3) "GE(0)" _skip(2) "GE(1)" _skip(2) "GE(2)" _newline ///
"B" _skip(2) "`between_ge0'" _skip(3) "`between_ge1'" _skip(3) "`between_ge2'"
}
restore
}


****************************************
* END















****************************************
* Income by decile for each year
****************************************
use"panel_v6", clear
replace monthlyincome_pc=monthlyincome_pc/1000

foreach i in 2010 2016 2020 {
xtile monthlyinc`i'=monthlyincome_pc if year==`i', n(10)
}
gen incgroup=.
foreach i in 2010 2016 2020 {
replace incgroup=monthlyinc`i' if year==`i'
drop monthlyinc`i' 
}

foreach x in incagrise incagricasual incnonagricasual incnonagrireg incnonagrise incnrega {
replace share`x'_HH=share`x'_HH*100
rename share`x'_HH s_`x'
}


collapse (mean) s_incagrise s_incagricasual s_incnonagricasual s_incnonagrireg s_incnonagrise s_incnrega, by(time incgroup)

gen sum1=s_incagrise
gen sum2=sum1+s_incagricasual
gen sum3=sum2+s_incnonagricasual
gen sum4=sum3+s_incnonagrireg
gen sum5=sum4+s_incnonagrise
gen sum6=sum5+s_incnrega

* By year
twoway ///
(area sum1 incgroup if time==1) ///
(rarea sum1 sum2 incgroup if time==1) ///
(rarea sum2 sum3 incgroup if time==1) ///
(rarea sum3 sum4 incgroup if time==1) ///
(rarea sum4 sum5 incgroup if time==1) ///
(rarea sum5 sum6 incgroup if time==1) ///
, ///
xlabel(1(1)10) xtitle("Decile of income per capita") ///
ylabel(0(10)100) ytitle("%") ///
title("2010") ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA") pos(6) col(3)) ///
name(compo1, replace)

twoway ///
(area sum1 incgroup if time==2) ///
(rarea sum1 sum2 incgroup if time==2) ///
(rarea sum2 sum3 incgroup if time==2) ///
(rarea sum3 sum4 incgroup if time==2) ///
(rarea sum4 sum5 incgroup if time==2) ///
(rarea sum5 sum6 incgroup if time==2) ///
, ///
xlabel(1(1)10) xtitle("Decile of income per capita") ///
ylabel(0(10)100) ytitle("%") ///
title("2016-17") ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA") pos(6) col(3)) ///
name(compo2, replace)

twoway ///
(area sum1 incgroup if time==3) ///
(rarea sum1 sum2 incgroup if time==3) ///
(rarea sum2 sum3 incgroup if time==3) ///
(rarea sum3 sum4 incgroup if time==3) ///
(rarea sum4 sum5 incgroup if time==3) ///
(rarea sum5 sum6 incgroup if time==3) ///
, ///
xlabel(1(1)10) xtitle("Decile of income per capita") ///
ylabel(0(10)100) ytitle("%") ///
title("2020-21") ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA") pos(6) col(3)) ///
name(compo3, replace)

grc1leg compo1 compo2 compo3, col(3) name(compo, replace)
graph export "Compositionincome.png", as(png) replace

****************************************
* END



