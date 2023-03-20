*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 1, 2022
*-----
gl link = "datacontextodriis"
*Prepa database
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------









****************************************
* Sample size
****************************************
cls
use"panel_indiv_v0", clear


********** Total
ta year


********** 15 or more 
ta year if age>=15


********** 25 more more
ta year if age>=25


********* Working age
ta workingage year


********** Employed
ta employed year



****************************************
* END








****************************************
* Age and marital status
****************************************
cls
use"panel_indiv_v0", clear

*** Age
ta sex year
tabstat age, stat(mean) by(year)
tabstat age if sex==1, stat(mean) by(year)
tabstat age if sex==2, stat(mean) by(year)


*** Marital status
keep if age>=15
ta sex year
ta maritalstatus year, col nofreq
ta maritalstatus year if sex==1, col nofreq
ta maritalstatus year if sex==2, col nofreq

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

*** Education KILM
ta educ_attainment2 year, col nofreq
ta educ_attainment2 year if sex==1, col nofreq
ta educ_attainment2 year if sex==2, col nofreq
ta educ_attainment2 year if caste==1, col nofreq
ta educ_attainment2 year if caste==2, col nofreq
ta educ_attainment2 year if caste==3, col nofreq

*** Comparison education - KILM
ta edulevel educ_attainment2

****************************************
* END
















****************************************
* Employment rate
****************************************
cls
use"panel_indiv_v0.dta", clear

*** Selection
ta employed
drop if employed==.

ta employed year, col nofreq
ta employed year if sex==1, col nofreq
ta employed year if sex==2, col nofreq
ta employed year if caste==1, col nofreq
ta employed year if caste==2, col nofreq
ta employed year if caste==3, col nofreq

keep HHID_panel INDID_panel year employed caste sex

rename employed occup1
gen occup2=occup1
recode occup2 (1=0) (0=1)

********** Graph
set graph off
*** Total
preserve
collapse (mean) occup1 occup2, by(year)
reshape long occup, i(year) j(p)
replace occup=occup*100
label define p 1"Occupied" 2"Unoccupied"
label values p p
graph bar occup, stack over(p, lab(angle(45))) over(year, lab(angle(90))) ///
asy ytitle("%") title("Total") legend(col(3) pos(6)) ///
ylab(0(20)100) ymtick(0(10)100) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(p_total, replace)
restore

*** Male
preserve
keep if sex==1
collapse (mean) occup1 occup2, by(year)
reshape long occup, i(year) j(p)
replace occup=occup*100
label define p 1"Occupied" 2"Unoccupied"
label values p p
graph bar occup, stack over(p, lab(angle(45))) over(year, lab(angle(90))) ///
asy ytitle("%") title("Male") legend(col(3) pos(6)) ///
ylab(0(20)100) ymtick(0(10)100) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(p_male, replace)
restore

*** Female
preserve
keep if sex==2
collapse (mean) occup1 occup2, by(year)
reshape long occup, i(year) j(p)
replace occup=occup*100
label define p 1"Occupied" 2"Unoccupied"
label values p p
graph bar occup, stack over(p, lab(angle(45))) over(year, lab(angle(90))) ///
asy ytitle("%") title("Female") legend(col(3) pos(6)) ///
ylab(0(20)100) ymtick(0(10)100) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(p_female, replace)
restore

*** Dalits
preserve
keep if caste==1
collapse (mean) occup1 occup2, by(year)
reshape long occup, i(year) j(p)
replace occup=occup*100
label define p 1"Occupied" 2"Unoccupied"
label values p p
graph bar occup, stack over(p, lab(angle(45))) over(year, lab(angle(90))) ///
asy ytitle("%") title("Dalits") legend(col(3) pos(6)) ///
ylab(0(20)100) ymtick(0(10)100) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(p_dalits, replace)
restore

*** Middle
preserve
keep if caste==2
collapse (mean) occup1 occup2, by(year)
reshape long occup, i(year) j(p)
replace occup=occup*100
label define p 1"Occupied" 2"Unoccupied"
label values p p
graph bar occup, stack over(p, lab(angle(45))) over(year, lab(angle(90))) ///
asy ytitle("%") title("Middle") legend(col(3) pos(6)) ///
ylab(0(20)100) ymtick(0(10)100) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(p_middle, replace)
restore

*** Upper
preserve
keep if caste==3
collapse (mean) occup1 occup2, by(year)
reshape long occup, i(year) j(p)
replace occup=occup*100
label define p 1"Occupied" 2"Unoccupied"
label values p p
graph bar occup, stack over(p, lab(angle(45))) over(year, lab(angle(90))) ///
asy ytitle("%") title("Upper") legend(col(3) pos(6)) ///
ylab(0(20)100) ymtick(0(10)100) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(p_upper, replace)
restore

set graph on

*** Combine
grc1leg p_total p_male p_female p_dalits p_middle p_upper, col(3) note("Individuals aged 15 and over.", size(vsmall)) name(p_comb, replace)
graph export "Emp_share.pdf", as(pdf) replace


****************************************
* END












****************************************
* Employment only for employed=1
****************************************
cls
use"panel_indiv_v0.dta", clear

*** Selection
drop if employed==.
drop if employed==0
ta year
* 3668


*** Elementary only for employed individuals
cls
ta elementaryoccup year, col nofreq
ta elementaryoccup year if sex==1, col nofreq
ta elementaryoccup year if sex==2, col nofreq
ta elementaryoccup year if caste==1, col nofreq
ta elementaryoccup year if caste==2, col nofreq
ta elementaryoccup year if caste==3, col nofreq


*** Sector
cls
tab sector_kilm4_V2 year, col nofreq
tab sector_kilm4_V2 year if sex==1, col nofreq
tab sector_kilm4_V2 year if sex==2, col nofreq
tab sector_kilm4_V2 year if caste==1, col nofreq
tab sector_kilm4_V2 year if caste==2, col nofreq
tab sector_kilm4_V2 year if caste==3, col nofreq


*** Total hours a year
cls
tabstat hoursayear_indiv, stat(mean) by(year)
tabstat hoursayear_indiv if sex==1, stat(mean) by(year)
tabstat hoursayear_indiv if sex==2, stat(mean) by(year)
tabstat hoursayear_indiv if caste==1, stat(mean) by(year)
tabstat hoursayear_indiv if caste==2, stat(mean) by(year)
tabstat hoursayear_indiv if caste==3, stat(mean) by(year)


*** Total annual income
cls
replace annualincome_indiv=annualincome_indiv/1000
tabstat annualincome_indiv, stat(mean) by(year)
tabstat annualincome_indiv if sex==1, stat(mean) by(year)
tabstat annualincome_indiv if sex==2, stat(mean) by(year)
tabstat annualincome_indiv if caste==1, stat(mean) by(year)
tabstat annualincome_indiv if caste==2, stat(mean) by(year)
tabstat annualincome_indiv if caste==3, stat(mean) by(year)

****************************************
* END














****************************************
* Employment only for employed=1
****************************************
cls
use"panel_indiv_v0.dta", clear

*** Selection
drop if employed==.
drop if employed==0
ta year
* 3668



*** Graph bar
fre mainocc_occupation_indiv
ta mainocc_occupation_indiv, gen(perc)

set graph off

* Total
preserve
collapse (mean) perc*, by(year)
reshape long perc, i(year) j(occ)
label define occupcode 1"Agri SE" 2"Agri casual" 3"Casual" 4"Reg non-quali" 5"Reg quali" 6"SE" 7"NREGA", modify
label values occ occupcode
graph bar perc, horiz over(year, lab(angle())) over(occ, lab(angle())) ///
asy ytitle("%") title("Total") legend(col(3) pos(6)) ///
ylab(0(.1).6) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(occ, replace) ///
 blabel(total, format(%4.2f) size(tiny))
restore

* Male
preserve
keep if sex==1
collapse (mean) perc*, by(year)
reshape long perc, i(year) j(occ)
label define occupcode 1"Agri SE" 2"Agri casual" 3"Casual" 4"Reg non-quali" 5"Reg quali" 6"SE" 7"NREGA", modify
label values occ occupcode
graph bar perc, horiz over(year, lab(angle())) over(occ, lab(angle())) ///
asy ytitle("%") title("Male") legend(col(3) pos(6)) ///
ylab(0(.1).6) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(occ_c1, replace) ///
 blabel(total, format(%4.2f) size(tiny))
restore

* Female
preserve
keep if sex==2
collapse (mean) perc*, by(year)
reshape long perc, i(year) j(occ)
label define occupcode 1"Agri SE" 2"Agri casual" 3"Casual" 4"Reg non-quali" 5"Reg quali" 6"SE" 7"NREGA", modify
label values occ occupcode
graph bar perc, horiz over(year, lab(angle())) over(occ, lab(angle())) ///
asy ytitle("%") title("Female") legend(col(3) pos(6)) ///
ylab(0(.1).6) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(occ_c2, replace) ///
 blabel(total, format(%4.2f) size(tiny))
restore




* Dalits
preserve
keep if caste==1
collapse (mean) perc*, by(year)
reshape long perc, i(year) j(occ)
label define occupcode 1"Agri SE" 2"Agri casual" 3"Casual" 4"Reg non-quali" 5"Reg quali" 6"SE" 7"NREGA", modify
label values occ occupcode
graph bar perc, horiz over(year, lab(angle())) over(occ, lab(angle())) ///
asy ytitle("%") title("Dalits") legend(col(3) pos(6)) ///
ylab(0(.1).6) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(occ_dal, replace) ///
 blabel(total, format(%4.2f) size(tiny))
restore

* Middle
preserve
keep if caste==2
collapse (mean) perc*, by(year)
reshape long perc, i(year) j(occ)
label define occupcode 1"Agri SE" 2"Agri casual" 3"Casual" 4"Reg non-quali" 5"Reg quali" 6"SE" 7"NREGA", modify
label values occ occupcode
graph bar perc, horiz over(year, lab(angle())) over(occ, lab(angle())) ///
asy ytitle("%") title("Middle") legend(col(3) pos(6)) ///
ylab(0(.1).6) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(occ_mid, replace) ///
 blabel(total, format(%4.2f) size(tiny))
restore

* Upper
preserve
keep if caste==3
collapse (mean) perc*, by(year)
reshape long perc, i(year) j(occ)
label define occupcode 1"Agri SE" 2"Agri casual" 3"Casual" 4"Reg non-quali" 5"Reg quali" 6"SE" 7"NREGA", modify
label values occ occupcode
graph bar perc, horiz over(year, lab(angle())) over(occ, lab(angle())) ///
asy ytitle("%") title("Upper") legend(col(3) pos(6)) ///
ylab(0(.1).6) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(occ_up, replace) ///
 blabel(total, format(%4.2f) size(tiny))
restore

set graph on


*** Combine
grc1leg occ occ_c1 occ_c2 occ_dal occ_mid occ_up, col(3) name(occ_comb, replace)
graph export "Occ_total.pdf", as(pdf) replace

****************************************
* END











****************************************
* Employment only for employed=1
****************************************
cls
use"panel_indiv_v0.dta", clear


*** Selection Cécile
drop if employed==.
drop if employed==0
ta year

*** Selection Arnaud
*drop if workingage==0
*drop if mainocc_occupation_indiv==0
ta year


*** Graph bar
fre mainocc_occupation_indiv
ta mainocc_occupation_indiv, gen(perc)


*** For poster
preserve
collapse (mean) perc*, by(year)
reshape long perc, i(year) j(occ)
replace perc=perc*100
label define occupcode 1"Agri SE" 2"Agri casual" 3"Casual" 4"Reg non-quali" 5"Reg quali" 6"SE" 7"NREGA", modify
label values occ occupcode
graph bar perc, over(year, lab(angle())) over(occ, lab(angle())) ///
asy ytitle("% for each year") title("Total") legend(col(3) pos(6)) ///
ylab(0(10)60) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(occ, replace) ///
 blabel(total, format(%4.1f) size(vsmall))
graph export "Occ_post.png", as(png) replace
restore


****************************************
* END















****************************************
* Employment only for employed=1
****************************************
cls
use"panel_indiv_v0.dta", clear

*** Selection
drop if employed==.
drop if employed==0
ta year
* 3668
replace mainocc_annualincome_indiv=mainocc_annualincome_indiv/1000


*** Income by occupation
tabstat mainocc_annualincome_indiv if year==2010, stat(n mean) by(mainocc_occupation_indiv)
tabstat mainocc_annualincome_indiv if year==2016, stat(n mean) by(mainocc_occupation_indiv)
tabstat mainocc_annualincome_indiv if year==2020, stat(n mean) by(mainocc_occupation_indiv)

/*
      Agri self-employed |       128  39.08125
     Agri casual workers |       320  14.50367
 Non-agri casual workers |       199  32.02854
Non-agri regular non-qua |        76  53.26447
Non-agri regular qualifi |        52     64.25
  Non-agri self-employed |        30      26.3
Public employment scheme |        70  4.257143
*/

set graph off

* Total
preserve
collapse (mean) mainocc_annualincome_indiv, by(mainocc_occupation_indiv year)
label define mainocc_occupation_indiv 1"Agri SE" 2"Agri casual" 3"Casual" 4"Reg non-quali" 5"Reg quali" 6"SE" 7"NREGA", modify
label value mainocc_occupation_indiv mainocc_occupation_indiv
graph bar mainocc_annualincome_indiv, horiz over(year, lab(angle())) over(mainocc_occupation_indiv, lab(angle())) ///
asy ytitle("Annual income (INR 1k)") title("Total") legend(col(3) pos(6)) ///
ylab(0(20)100) ymtick(0(10)110) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(occ, replace) ///
blabel(total, format(%4.2f) size(tiny))
restore


* Male
preserve
keep if sex==1
collapse (mean) mainocc_annualincome_indiv, by(mainocc_occupation_indiv year)
label define mainocc_occupation_indiv 1"Agri SE" 2"Agri casual" 3"Casual" 4"Reg non-quali" 5"Reg quali" 6"SE" 7"NREGA", modify
label value mainocc_occupation_indiv mainocc_occupation_indiv
graph bar mainocc_annualincome_indiv, horiz over(year, lab(angle())) over(mainocc_occupation_indiv, lab(angle())) ///
asy ytitle("Annual income (INR 1k)") title("Male") legend(col(3) pos(6)) ///
ylab(0(20)100) ymtick(0(10)110) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(occ_male, replace) ///
blabel(total, format(%4.2f) size(tiny))
restore


* Female
preserve
keep if sex==2
collapse (mean) mainocc_annualincome_indiv, by(mainocc_occupation_indiv year)
label define mainocc_occupation_indiv 1"Agri SE" 2"Agri casual" 3"Casual" 4"Reg non-quali" 5"Reg quali" 6"SE" 7"NREGA", modify
label value mainocc_occupation_indiv mainocc_occupation_indiv
graph bar mainocc_annualincome_indiv, horiz over(year, lab(angle())) over(mainocc_occupation_indiv, lab(angle())) ///
asy ytitle("Annual income (INR 1k)") title("Female") legend(col(3) pos(6)) ///
ylab(0(20)100) ymtick(0(10)110) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(occ_female, replace) ///
blabel(total, format(%4.2f) size(tiny))
restore


* Dalits
preserve
keep if caste==1
collapse (mean) mainocc_annualincome_indiv, by(mainocc_occupation_indiv year)
label define mainocc_occupation_indiv 1"Agri SE" 2"Agri casual" 3"Casual" 4"Reg non-quali" 5"Reg quali" 6"SE" 7"NREGA", modify
label value mainocc_occupation_indiv mainocc_occupation_indiv
graph bar mainocc_annualincome_indiv, horiz over(year, lab(angle())) over(mainocc_occupation_indiv, lab(angle())) ///
asy ytitle("Annual income (INR 1k)") title("Dalits") legend(col(3) pos(6)) ///
ylab(0(20)100) ymtick(0(10)110) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(occ_dalits, replace) ///
blabel(total, format(%4.2f) size(tiny))
restore


* Middle
preserve
keep if caste==2
collapse (mean) mainocc_annualincome_indiv, by(mainocc_occupation_indiv year)
label define mainocc_occupation_indiv 1"Agri SE" 2"Agri casual" 3"Casual" 4"Reg non-quali" 5"Reg quali" 6"SE" 7"NREGA", modify
label value mainocc_occupation_indiv mainocc_occupation_indiv
graph bar mainocc_annualincome_indiv, horiz over(year, lab(angle())) over(mainocc_occupation_indiv, lab(angle())) ///
asy ytitle("Annual income (INR 1k)") title("Middle") legend(col(3) pos(6)) ///
ylab(0(20)100) ymtick(0(10)110) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(occ_middle, replace) ///
blabel(total, format(%4.2f) size(tiny))
restore



* Upper
preserve
keep if caste==3
collapse (mean) mainocc_annualincome_indiv, by(mainocc_occupation_indiv year)
label define mainocc_occupation_indiv 1"Agri SE" 2"Agri casual" 3"Casual" 4"Reg non-quali" 5"Reg quali" 6"SE" 7"NREGA", modify
label value mainocc_occupation_indiv mainocc_occupation_indiv
graph bar mainocc_annualincome_indiv, horiz over(year, lab(angle())) over(mainocc_occupation_indiv, lab(angle())) ///
asy ytitle("Annual income (INR 1k)") title("Upper") legend(col(3) pos(6)) ///
ylab(0(20)100) ymtick(0(10)110) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(occ_upper, replace) ///
blabel(total, format(%4.2f) size(tiny))
restore

set graph on


*** Combine
grc1leg occ occ_male occ_female occ_dalits occ_middle occ_upper, col(3) name(occ_comb, replace)
graph export "Occ_inc_total.pdf", as(pdf) replace


****************************************
* END












/*
stripplot assets_totalnoland if assets_totalnoland<100, over(time) vert ///
stack width(.5) jitter(0) ///
box(barw(.2)) boffset(-0.15) pctile(25) ///
ms(oh oh oh) msize(small) mc(black%30) ///
yla(0(10)100, ang(h)) xla(, noticks) ///
ymtick(0(5)100) ///
xtitle("") ytitle("Monetary value of assets (INR 10k)") ///
name(wealth, replace)
graph export "Wealth.pdf", as(pdf) replace
