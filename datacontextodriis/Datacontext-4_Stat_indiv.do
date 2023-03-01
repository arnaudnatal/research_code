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


*** Education
ta edulevel year, col nofreq
ta edulevel year if sex==1, col nofreq
ta edulevel year if sex==2, col nofreq


*** Working pop
ta working_pop year, col nofreq
ta working_pop year if sex==1, col nofreq
ta working_pop year if sex==2, col nofreq


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
drop if age<15
ta age working_pop
ta sex year

*** Rescale
replace annualincome_indiv=annualincome_indiv/1000
replace mainocc_annualincome_indiv=mainocc_annualincome_indiv/1000


*** Graph bar
fre mainocc_occupation_indiv
recode mainocc_occupation_indiv (5=4)
ta mainocc_occupation_indiv, gen(perc)

* Total
preserve
collapse (mean) perc*, by(year)
reshape long perc, i(year) j(occ)
label define occupcode 1"Agri SE" 2"Agri casual" 3"Casual" 4"Regular" 5"SE" 6"NREGA", modify
label values occ occupcode
graph bar perc, over(year, lab(angle(90))) over(occ, lab(angle(45))) ///
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
label define occupcode 1"Agri SE" 2"Agri casual" 3"Casual" 4"Regular" 5"SE" 6"NREGA", modify
label values occ occupcode
graph bar perc, over(year, lab(angle(90))) over(occ, lab(angle(45))) ///
asy ytitle("%") title("Male") legend(col(3) pos(6)) ///
ylab(0(.1).6) ///
name(occ_c1, replace)
restore

* Female
preserve
keep if sex==2
collapse (mean) perc*, by(year)
reshape long perc, i(year) j(occ)
label define occupcode 1"Agri SE" 2"Agri casual" 3"Casual" 4"Regular" 5"SE" 6"NREGA", modify
label values occ occupcode
graph bar perc, over(year, lab(angle(90))) over(occ, lab(angle(45))) ///
asy ytitle("%") title("Female") legend(col(3) pos(6)) ///
ylab(0(.1).6) ///
name(occ_c2, replace)
restore

*** Combine
grc1leg occ occ_c1 occ_c2, col(3) name(occ_comb, replace)
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
