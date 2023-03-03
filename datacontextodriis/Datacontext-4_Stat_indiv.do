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
* Avec la base de Cécile
****************************************
cls
use"KILM_Ind_VF2.dta", clear

keep HHID_panel INDID_panel year
gen base_cecile=1

save"Size_cecile.dta", replace

***
use"panel_indiv_v0", clear

merge 1:1 HHID_panel INDID_panel year using "Size_cecile.dta"
drop _merge

list HHID_panel INDID_panel year age sex name caste if base_cecile==., clean noobs

gen keep=0
replace keep=1 if base_cecile==.

bysort HHID_panel: egen max_c=max(keep)
keep if max_c==1

order HHID_panel INDID_panel year name sex age working_pop mainocc_occupation_indiv keep


********** Comparison
cls
*** Cécile
use"KILM_Ind_VF2.dta", clear

keep if age>=15
ta year
ta occupation_mainoccup, m

ta occupation_mainoccup employed, m
ta occupation_mainoccup employed if year==2010, m
ta occupation_mainoccup employed if year==2016, m
ta occupation_mainoccup employed if year==2020, m


*** Arnaud
use"panel_indiv_v0", clear

keep if age>=15
ta year
ta mainocc_occupation_indiv, m


ta year
keep if age>=15
drop if mainocc_occupation_indiv==0
drop if mainocc_occupation_indiv==.
replace annualincome_indiv=annualincome_indiv/1000
replace mainocc_annualincome_indiv=mainocc_annualincome_indiv/1000
ta sex year






********** Stat Cécile
cls
use"KILM_Ind_VF2.dta", clear

*** Check the construction
keep if age>=15

ta occupation_mainoccup employed if year==2010, m
ta occupation_mainoccup employed if year==2016, m
ta occupation_mainoccup employed if year==2020, m

drop if occupation_mainoccup==0
drop if occupation_mainoccup==.

ta elementaryoccup, m
ta occupation_mainoccup elementaryoccup, m

ta employed
ta employed year, col nofreq
ta employed year if sex==1, col nofreq
ta employed year if sex==2, col nofreq


*** Original
bysort survey : tab elementaryoccup groupcaste, col

by survey : tab kilm1
by survey : tab kilm1 sex, col
by survey : tab kilm1 groupcaste, col

bysort survey : tab occupation_mainoccup if employed==1
bysort survey occupation_mainoccup: sum annualincome_mainoccup_real if employed==1
bysort survey sex : sum annualincome_mainoccup_real if employed==1
bysort survey groupcaste : sum annualincome_mainoccup_real if employed==1

bysort survey : tab sector_kilm4 if employed==1
bysort survey : tab sector_kilm4 sex if employed==1, col
bysort survey : tab sector_kilm4 groupcaste if employed==1, col



****************************************
* END















****************************************
* Employment rate
****************************************
cls
use"panel_indiv_v0", clear

*** Initialization
keep if age>=15
ta sex year

*** Creation
ta age mainocc_occupation_indiv, m
fre mainocc_occupation_indiv

gen occup1=.
replace occup1=0 if mainocc_occupation_indiv==.
replace occup1=0 if mainocc_occupation_indiv==0
replace occup1=1 if mainocc_occupation_indiv>0 & occup1==.
ta mainocc_occupation_indiv occup1, m

gen occup2=occup1
recode occup2 (1=0) (0=1)

ta occup1 occup2, m

*** Stat
ta sex year
ta caste year

ta occup1 year, col nofreq
ta occup1 year if sex==1, col nofreq
ta occup1 year if sex==2, col nofreq
ta occup1 year if caste==1, col nofreq
ta occup1 year if caste==2, col nofreq
ta occup1 year if caste==3, col nofreq


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
* Graph occupations
****************************************
cls
use"panel_indiv_v0", clear

*** Initialization
ta year
keep if age>=15
drop if mainocc_occupation_indiv==0
drop if mainocc_occupation_indiv==.
replace annualincome_indiv=annualincome_indiv/1000
replace mainocc_annualincome_indiv=mainocc_annualincome_indiv/1000
ta sex year

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

grc1leg occ_dal occ_mid occ_up, col(2) name(occ_comb, replace)


graph export "Occ_comb.pdf", as(pdf) replace


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


tabstat mainocc_annualincome_indiv if year==2010, stat(n mean cv p50) by(mainocc_occupation_indiv)
tabstat mainocc_annualincome_indiv if year==2016, stat(n mean cv p50) by(mainocc_occupation_indiv)
tabstat mainocc_annualincome_indiv if year==2020, stat(n mean cv p50) by(mainocc_occupation_indiv)


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
