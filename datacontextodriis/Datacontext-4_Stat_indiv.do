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
* Indiv education, age
****************************************
cls
use"panel_indiv_v0", clear


*** Initialization
ta year
drop if age<15
ta age working_pop
ta sex year


*** Rescale
replace annualincome_indiv=annualincome_indiv/1000
replace mainocc_annualincome_indiv=mainocc_annualincome_indiv/1000


*** Age
tabstat age, stat(n mean)
tabstat age, stat(mean) by(year)
tabstat age if sex==1, stat(mean) by(year)
tabstat age if sex==2, stat(mean) by(year)


*** Marital status
ta maritalstatus year, col nofreq
ta maritalstatus year if sex==1, col nofreq
ta maritalstatus year if sex==2, col nofreq


*** Working pop
ta working_pop year, col nofreq
ta working_pop year if sex==1, col nofreq
ta working_pop year if sex==2, col nofreq



********** 25 or more
keep if age>=25
ta age

*** Education
ta edulevel year, col nofreq
ta edulevel year if sex==1, col nofreq
ta edulevel year if sex==2, col nofreq


*** Comparison education - KILM
ta edulevel educ_attainment2

*** Education KILM
ta educ_attainment2 year, col nofreq
ta educ_attainment2 year if sex==1, col nofreq
ta educ_attainment2 year if sex==2, col nofreq
ta educ_attainment2 year if caste==1, col nofreq
ta educ_attainment2 year if caste==2, col nofreq
ta educ_attainment2 year if caste==3, col nofreq

ta sex year
ta caste year




****************************************
* END











****************************************
* Graph working pop
****************************************
cls
use"panel_indiv_v0", clear

*** Initialization
ta year
drop if age<15
ta age working_pop
ta sex year

*** Rescale
replace annualincome_indiv=annualincome_indiv/1000
replace mainocc_annualincome_indiv=mainocc_annualincome_indiv/1000


*** Graph
ta working_pop, gen(perc)

* Total
preserve
collapse (mean) perc*, by(year)
reshape long perc, i(year) j(wp)
label define wp 1"Inactive" 2"Act. unocc." 3"Act. occ."
label values wp wp
graph bar perc, stack over(wp, lab(angle(45))) over(year, lab(angle(90))) ///
asy ytitle("%") title("Total") legend(col(3) pos(6)) ///
ylab(0(.1)1) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(wp, replace)
restore

* Male
preserve
keep if sex==1
collapse (mean) perc*, by(year)
reshape long perc, i(year) j(wp)
label define wp 1"Inactive" 2"Act. unocc." 3"Act. occ."
label values wp wp
graph bar perc, stack over(wp, lab(angle(45))) over(year, lab(angle(90))) ///
asy ytitle("%") title("Male") legend(col(3) pos(6)) ///
ylab(0(.1)1) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(wp_c1, replace)
restore


* Female
preserve
keep if sex==2
collapse (mean) perc*, by(year)
reshape long perc, i(year) j(wp)
label define wp 1"Inactive" 2"Act. unocc." 3"Act. occ."
label values wp wp
graph bar perc, stack over(wp, lab(angle(45))) over(year, lab(angle(90))) ///
asy ytitle("%") title("Female") legend(col(3) pos(6)) ///
ylab(0(.1)1) ///
bar(1, fcolor(gs14)) bar(2, fcolor(gs10)) bar(3, fcolor(gs5)) ///
name(wp_c2, replace)
restore

*** Combine
grc1leg wp wp_c1 wp_c2, col(3) name(wp_comb, replace)
graph export "wp_comb.pdf", as(pdf) replace

****************************************
* END












****************************************
* Graph occupations
****************************************
cls
use"panel_indiv_v0", clear

*** Initialization
ta year
keep if age>=15
ta age working_pop
ta sex year

*** Rescale
replace annualincome_indiv=annualincome_indiv/1000
replace mainocc_annualincome_indiv=mainocc_annualincome_indiv/1000
drop if mainocc_occupation_indiv==0

*** Graph bar
fre mainocc_occupation_indiv
*recode mainocc_occupation_indiv (5=4)
ta mainocc_occupation_indiv, gen(perc)

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
name(occ, replace)
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
name(occ_c1, replace)
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
name(occ_c2, replace)
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
name(occ_dal, replace)
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
name(occ_mid, replace)
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
name(occ_up, replace)
restore




*** Combine
grc1leg occ occ_c1 occ_c2, col(2) name(occ_comb, replace)

grc1leg occ occ_c1 occ_c2, col(2) name(occ_comb, replace)


graph export "Occ_comb.pdf", as(pdf) replace


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
