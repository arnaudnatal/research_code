*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*August 8, 2024
*-----
gl link = "inequalities"
*Supp analysis
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\inequalities.do"
*-------------------------







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
import excel "Occupation_caste.xlsx", sheet("Sheet1") firstrow clear
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
graph export "graph/Occupations.png", as(png) replace

****************************************
* END















****************************************
* Compo assets by caste for each year
****************************************
use"panel_v4", clear

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
graph export "graph/Compositionassets_caste.png", as(png) replace

****************************************
* END
