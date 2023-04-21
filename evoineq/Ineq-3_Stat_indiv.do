*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*April 21, 2023
*-----
gl link = "evoineq"
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
* PTCS
****************************************
cls
use"panel_indiv_v0", clear

replace num_tt=num_tt/1.5 if year==2020

tabstat num_tt lit_tt raven_tt cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit locus if year==2016, stat(n mean cv) by(sex)
tabstat num_tt lit_tt raven_tt cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit locus if year==2020, stat(n mean cv) by(sex)

tabstat num_tt lit_tt raven_tt cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit locus if year==2016, stat(n mean cv) by(caste)
tabstat num_tt lit_tt raven_tt cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit locus if year==2020, stat(n mean cv) by(caste)


* OP
preserve
keep if year==2016
twoway ///
(kdensity cr_OP if sex==1) ///
(kdensity cr_OP if sex==2) ///
, xtitle("Score in 2016-17") ytitle("Density") ///
title("Openness to experience") ///
legend(order(1 "Male" 2 "Female") pos(6) col(2)) ///
name(op, replace)
restore 


* CO
preserve
keep if year==2016
twoway ///
(kdensity cr_CO if sex==1, bwidth(0.3)) ///
(kdensity cr_CO if sex==2, bwidth(0.3)) ///
, xtitle("Score in 2016-17") ytitle("Density") ///
title("Conscientiousness") ///
legend(order(1 "Male" 2 "Female") pos(6) col(2)) ///
name(co, replace)
restore 



* EX
preserve
keep if year==2016
twoway ///
(kdensity cr_EX if sex==1) ///
(kdensity cr_EX if sex==2) ///
, xtitle("Score in 2016-17") ytitle("Density") ///
title("Extraversion") ///
legend(order(1 "Male" 2 "Female") pos(6) col(2)) ///
name(ex, replace)
restore 



* AG
preserve
keep if year==2016
twoway ///
(kdensity cr_AG if sex==1, bwidth(0.15)) ///
(kdensity cr_AG if sex==2, bwidth(0.15)) ///
, xtitle("Score in 2016-17") ytitle("Density") ///
title("Agreeableness") ///
legend(order(1 "Male" 2 "Female") pos(6) col(2)) ///
name(ag, replace)
restore 



* ES
preserve
keep if year==2016
twoway ///
(kdensity cr_ES if sex==1, bwidth(0.2)) ///
(kdensity cr_ES if sex==2, bwidth(0.2)) ///
, xtitle("Score in 2016-17") ytitle("Density") ///
title("Emotional stability") ///
legend(order(1 "Male" 2 "Female") pos(6) col(2)) ///
name(es, replace)
restore 



* Grit
preserve
keep if year==2016
twoway ///
(kdensity cr_Grit if sex==1) ///
(kdensity cr_Grit if sex==2) ///
, xtitle("Score in 2016-17") ytitle("Density") ///
title("Grit") ///
legend(order(1 "Male" 2 "Female") pos(6) col(2)) ///
name(grit, replace)
restore 



* LOC
preserve
keep if year==2020
twoway ///
(kdensity locus if sex==1, bwidth(0.2)) ///
(kdensity locus if sex==2, bwidth(0.2)) ///
, xtitle("Score in 2020-21") ytitle("Density") ///
title("Locus of control") ///
legend(order(1 "Male" 2 "Female") pos(6) col(2)) ///
name(locus, replace)
restore 



* Numeracy
preserve
keep if year==2016
twoway ///
(kdensity num_tt if sex==1, bwidth(1.2)) ///
(kdensity num_tt if sex==2, bwidth(1.2)) ///
, xtitle("Score in 2016-17") ytitle("Density") ///
title("Numeracy") ///
legend(order(1 "Male" 2 "Female") pos(6) col(2)) ///
name(num, replace)
restore 



* Literacy
preserve
keep if year==2016
twoway ///
(kdensity lit_tt if sex==1, bwidth(1.6)) ///
(kdensity lit_tt if sex==2, bwidth(1.6)) ///
, xtitle("Score in 2016-17") ytitle("Density") ///
title("Literacy") ///
legend(order(1 "Male" 2 "Female") pos(6) col(2)) ///
name(lit, replace)
restore 



* Raven
preserve
keep if year==2016
twoway ///
(kdensity raven_tt if sex==1, bwidth(5)) ///
(kdensity raven_tt if sex==2, bwidth(5)) ///
, xtitle("Score in 2016-17") ytitle("Density") ///
title("Raven") ///
legend(order(1 "Male" 2 "Female") pos(6) col(2)) ///
name(raven, replace)
restore 


********** Same graph
grc1leg co op ex ag es grit locus num lit raven, col(5) name(ptcscomb, replace)
graph export "ptcs.pdf", replace as(pdf)
graph export "ptcs.png", replace as(png)

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
asy ytitle("% for each year") title("Distribution of main occupations") legend(col(3) pos(6)) ///
ylab(0(10)60) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(occ, replace) ///
blabel(total, format(%4.1f) size(vsmall)) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21"))
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















****************************************
* Working conditions
****************************************
cls
use"panel_indiv_v0.dta", clear

* Selection
keep if year==2020
keep if executionwork1!=.

* Execution work
global exe executionwork1 executionwork2 executionwork3 executionwork4 executionwork5 executionwork6 executionwork7 executionwork8 executionwork9
fre $exe
egen executionwork=rowtotal($exe)
replace executionwork=executionwork/9
ta executionwork


* Problem at work
global pb problemwork1 problemwork2 problemwork4 problemwork5 problemwork6 problemwork7 problemwork8 problemwork9 problemwork10
fre $pb
* The more is worst
foreach x in $pb {
replace `x'=. if `x'==66
replace `x'=. if `x'==99
recode `x' (1=3) (3=1)
}
egen problemwork=rowtotal($pb)
replace problemwork=problemwork/30
ta problemwork


* Work exposure
global expo workexposure1 workexposure2 workexposure3 workexposure4 workexposure5
fre $expo
* The more is worst
foreach x in $expo {
replace `x'=. if `x'==66
replace `x'=. if `x'==99
recode `x' (1=3) (3=1)
}
egen workexposure=rowtotal($expo)
replace workexposure=workexposure/15
fre workexposure



********* Graph bar
tabstat executionwork problemwork workexposure, stat(mean) by(mainocc_occupation_indiv)

collapse (mean) executionwork problemwork workexposure, by(mainocc_occupation_indiv)
drop if mainocc_occupation_indiv==.
drop if mainocc_occupation_indiv==0

set graph off
* Execution
twoway ///
(bar executionwork mainocc_occupation_indiv, barwidth(.5)) ///
, ///
xlab(1 "Agri SE" 2 "Agri casual" 3 "Casual" 4 "Reg non-quali" 5 "Reg quali" 6 "SE" 7 "NREGA", angle(45)) xtitle("") ///
ylab(.3(.1)1) ytitle("Mean") ///
title("Execution score") name(exe, replace)

* Problem
twoway ///
(bar problemwork mainocc_occupation_indiv, barwidth(.5)) ///
, ///
xlab(1 "Agri SE" 2 "Agri casual" 3 "Casual" 4 "Reg non-quali" 5 "Reg quali" 6 "SE" 7 "NREGA", angle(45)) xtitle("") ///
ylab(.3(.1)1) ytitle("Mean") ///
title("Problem score") name(pb, replace)

* Work exposure
twoway ///
(bar workexposure mainocc_occupation_indiv, barwidth(.5)) ///
, ///
xlab(1 "Agri SE" 2 "Agri casual" 3 "Casual" 4 "Reg non-quali" 5 "Reg quali" 6 "SE" 7 "NREGA", angle(45)) xtitle("") ///
ylab(.3(.1)1) ytitle("Mean") ///
title("Exposition score") name(work, replace)
set graph on


graph combine exe pb work, col(3) name(comb, replace)
graph export "Workingcond.pdf", as(pdf) replace

****************************************
* END

















****************************************
* NEEMSIS-1 migrant tracking
****************************************
*** Where?
use"$directory\NEEMSIS1-tracking", clear

keep HHID2019 migrationplace
duplicates drop
ta migrationplace



*** Path
use"$directory\NEEMSIS1-tracking", clear

* Rename
rename rationhelptrue migrationhelptrue

* Selection
keep HHID2019 householdvillageoriginal migrationplace migrationareatype migration1type2 migration1reason satisfaction migration1type migrationhelptrue migration1decision migration1cost
drop if migration1type2==.

* Var crea
split migration1reason, destring
recode migration1reason1 migration1reason2 migration1reason3 (77=11)
forvalues i=1/11 {
gen migration1reason_`i'=0 if migration1reason!=""
}
forvalues i=1/11 {
replace migration1reason_`i'=1 if migration1reason1==`i'
replace migration1reason_`i'=1 if migration1reason2==`i'
replace migration1reason_`i'=1 if migration1reason3==`i'
label var migration1reason_`i' " migration1reason=`i'"
label define yesno 0"No" 1"Yes", replace
label values migration1reason_`i' yesno
}
rename migration1reason_1 migration1reason_enoug
rename migration1reason_2 migration1reason_advan
rename migration1reason_3 migration1reason_assur
rename migration1reason_4 migration1reason_repay
rename migration1reason_5 migration1reason_oppor
rename migration1reason_6 migration1reason_inter
rename migration1reason_7 migration1reason_money
rename migration1reason_8 migration1reason_diver
rename migration1reason_9 migration1reason_statu
rename migration1reason_10 migration1reason_someo
rename migration1reason_11 migration1reason_other
drop migration1reason1 migration1reason2 migration1reason3
order migration1reason_enoug migration1reason_advan migration1reason_assur migration1reason_repay migration1reason_oppor migration1reason_inter migration1reason_money migration1reason_diver migration1reason_statu migration1reason_someo migration1reason_other, after(migration1reason)

replace migration1cost=migration1cost*(100/158)

* Type
ta migration1type2

* Selection work
keep if migration1type2==2
ta migration1reason

tab1 migration1reason_enoug migration1reason_advan migration1reason_assur migration1reason_repay migration1reason_oppor migration1reason_inter migration1reason_money migration1reason_diver migration1reason_statu migration1reason_someo migration1reason_other

ta satisfaction
ta migration1type
ta migrationhelptrue
ta migration1decision
tabstat migration1cost, stat(mean cv p50)

****************************************
* END










****************************************
* NEEMSIS-1 migrant tracking
****************************************
*** Where?
use"$directory\NEEMSIS1-tracking", clear

keep HHID2019 migrationplace INDID_mig name rankingmigrant
decode rankingmigrant, gen(namemig)
keep if namemig==name
drop name namemig rankingmigrant
order HHID2019 INDID_mig
save"_tempplacetrack1", replace


use"$directory\NEEMSIS1-tracking_occupations", clear

merge m:m HHID2019 INDID_mig using "_tempplacetrack1"
keep if _merge==3
drop _merge

ta migrationplace kindofwork 
fre kindofwork
ta occupationname if kindofwork==4



****************************************
* END














****************************************
* NEEMSIS-2 migrant tracking
****************************************

*** Where?
use"$directory\NEEMSIS2-tracking", clear
drop if realmig==0
keep HHID2022 migrationplacename
duplicates drop
fre migrationplacename

*** Path
use"$directory\NEEMSIS2-tracking_migpath", clear
drop if migrationstepid==.

* Var crea
ta migration1reason
split migration1reason, destring
recode migration1reason1 migration1reason2 migration1reason3 (77=11)
forvalues i=1/11 {
gen migration1reason_`i'=0 if migration1reason!=""
}
forvalues i=1/11 {
replace migration1reason_`i'=1 if migration1reason1==`i'
replace migration1reason_`i'=1 if migration1reason2==`i'
replace migration1reason_`i'=1 if migration1reason3==`i'
label var migration1reason_`i' " migration1reason=`i'"
label define yesno 0"No" 1"Yes", replace
label values migration1reason_`i' yesno
}
rename migration1reason_1 migration1reason_enoug
rename migration1reason_2 migration1reason_advan
rename migration1reason_3 migration1reason_assur
rename migration1reason_4 migration1reason_repay
rename migration1reason_5 migration1reason_oppor
rename migration1reason_6 migration1reason_inter
rename migration1reason_7 migration1reason_money
rename migration1reason_8 migration1reason_diver
rename migration1reason_9 migration1reason_statu
rename migration1reason_10 migration1reason_someo
rename migration1reason_11 migration1reason_other
drop migration1reason1 migration1reason2 migration1reason3
order migration1reason_enoug migration1reason_advan migration1reason_assur migration1reason_repay migration1reason_oppor migration1reason_inter migration1reason_money migration1reason_diver migration1reason_statu migration1reason_someo migration1reason_other, after(migration1reason)

replace migration1cost=migration1cost*(100/184)

* Type
ta migration1type2

* Selection work
keep if migration1type2==2
tab1 migration1reason_enoug migration1reason_advan migration1reason_assur migration1reason_repay migration1reason_oppor migration1reason_inter migration1reason_money migration1reason_diver migration1reason_statu migration1reason_someo migration1reason_other

ta migsatisfaction
ta migration1type
ta migrationhelptrue
ta migsndecimig
tabstat migration1cost, stat(mean cv p50)

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
