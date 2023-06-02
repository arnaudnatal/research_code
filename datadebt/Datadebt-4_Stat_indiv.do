*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*June 1, 2023
*-----
gl link = "datadebt"
*Stat indiv
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------









****************************************
* Sample size
****************************************
cls
use"panel_indiv_v0", clear


********** Total
ta sex year


********** 15 or more 
ta sex year if age>=15


********** 25 more more
ta sex year if age>=25


********* Working age
ta workingage year


********** Employed
ta employed year



****************************************
* END








****************************************
* Age
****************************************
cls
use"panel_indiv_v0", clear

*** Age
ta sex year
tabstat age, stat(mean) by(year)
tabstat age if sex==1, stat(mean) by(year)
tabstat age if sex==2, stat(mean) by(year)


****************************************
* END








****************************************
* Education
****************************************
cls
use"panel_indiv_v0", clear

*** Initialization
keep if age>=25
ta sex year

*** Education
ta edulevel year, col nofreq
ta edulevel year if sex==1, col nofreq
ta edulevel year if sex==2, col nofreq

****************************************
* END













****************************************
* Employment
****************************************
cls
use"panel_indiv_v0.dta", clear

*** Selection
drop if age<15
ta sex year

*** Who?
ta mainocc_occupation_indiv working_pop, m
fre working_pop
fre mainocc_occupation_indiv
ta occupied working_pop, m
ta occupied employed, m
recode mainocc_occupation_indiv (5=4)

*** Occupied?
cls
ta occupied year, col nofreq
ta occupied year if sex==1, col nofreq
ta occupied year if sex==2, col nofreq


*** For those who are occupied
cls
drop if occupied==0
ta sex year
ta mainocc_occupation_indiv year
ta mainocc_occupation_indiv year, col nofreq
ta mainocc_occupation_indiv year if sex==1, col nofreq
ta mainocc_occupation_indiv year if sex==2, col nofreq

*** Number of occupation
cls
tabstat nboccupation_indiv, stat(n mean) by(year)
tabstat nboccupation_indiv if sex==1, stat(mean) by(year)
tabstat nboccupation_indiv if sex==2, stat(mean) by(year)

****************************************
* END








****************************************
* Employment
****************************************
cls
use"paneloccup.dta", clear

preserve
use"panel_indiv_v0.dta", clear
drop if age<15
drop if occupied==0
keep HHID_panel INDID_panel year
gen tokeep=1
save"panelindivocc", replace
restore

merge m:1 HHID_panel INDID_panel year using "panelindivocc"
ta _merge year
keep if _merge==3
drop _merge
drop if occupation==0
drop if annualincome==0

gen monthlyincome=annualincome/12
gen monthlyincome2=monthlyincome
replace monthlyincome2=. if monthlyincome2<1
tabstat monthlyincome monthlyincome2, stat(min p1 p5 p10 q p90 p95 p99 max)

gen logmonthlyincome=log(monthlyincome2)
recode occupation (5=4)
fre occupation
recode occupation (6=5) (7=6)
label define occupcode 1"Agri SE" 2"Agri casual" 3"Casual" 4"Regular" 5"SE" 6"MNREGA", modify

*** Stat
tabstat monthlyincome2, stat(min p1 p5 p10 q p90 p95 p99 max)
tabstat monthlyincome2, stat(n mean cv p50) by(occupation)
tabstat monthlyincome2 if year==2010, stat(n mean cv p50) by(occupation)
tabstat monthlyincome2 if year==2016, stat(n mean cv p50) by(occupation)
tabstat monthlyincome2 if year==2020, stat(n mean cv p50) by(occupation)


*** Graph
egen occupyear=group(occupation year), label
fre occupyear
recode occupyear (4=5) (5=6) (6=7) (7=9) (8=10) (9=11) (10=13) (11=14) (12=15) (13=17) (14=18) (15=19) (16=21) (17=22) (18=23)
label define occupyear ///
1"2010" 2"Agri SE   2016-17" 3"2020-21" 4"" ///
5"2010" 6"Agri casual   2016-17" 7"2020-21" 8"" ///
9"2010" 10"Casual   2016-17" 11"2020-21" 12"" ///
13"2010" 14"Regular   2016-17" 15"2020-21" 16"" ///
17"2010" 18"SE   2016-17" 19"2020-21" 20"" ///
21"2010" 22"MNREGA   2016-17" 23"2020-21", modify

*** Log
stripplot logmonthlyincome, over(occupyear) ///
stack width(0.01) ///
box(barw(0.5)) boffset(-0.15) pctile(5) ///
mc(black%0) ///
yline(4 8 12 16 20, lpattern(shortdash) lcolor(black%15)) ///
xla(0(2)14, ang(h)) xmtick(0(0.5)15) yla(, noticks) ymtick(4(4)20) ///
legend(order(4 "Whisker from 5% to 95%") pos(6) col(2) on) ///
xtitle("Monthly income* (log INR)") ytitle("") note("*of one occupation", size(vsmall)) name(logmonthlyincome, replace)
graph save "monthlyincome.gph", replace
graph export "monthlyincome.pdf", as(pdf) replace
graph export "monthlyincome.png", as(png) replace

****************************************
* END







