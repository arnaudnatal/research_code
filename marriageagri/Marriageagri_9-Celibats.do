*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*February 22, 2023
*-----
gl link = "marriageagri"
*Analysis NEEMSIS-2 marriage
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\marriageagri.do"
*-------------------------










****************************************
* Dataset construction
****************************************

***** 2016-17
use"raw/NEEMSIS1-HH", clear


keep HHID2016 INDID2016 age sex currentlyatschool maritalstatus livinghome lefthomereason

* Merge caste
merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-caste"
keep if _merge==3
drop _merge

* Merge income
merge m:1 HHID2016 using "raw/NEEMSIS1-occup_HH", keepusing(annualincome_HH shareincomeagri_HH shareincomenonagri_HH)
drop _merge

* Merge assets
merge m:1 HHID2016 using "raw/NEEMSIS1-assets", keepusing(assets_total1000 assets_totalnoland1000 assets_totalnoprop1000 assets_ownland)
drop _merge

* Merge education
merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-education"
keep if _merge==3
drop _merge

* Merge occupation
merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-occup_indiv", keepusing(working_pop mainocc_occupation_indiv mainocc_annualincome_indiv annualincome_indiv nboccupation_indiv hoursayear_indiv)
keep if _merge==3
drop _merge

* Merge HHID panel
merge m:m HHID2016 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

* Merge INDID panel
tostring INDID2016, replace
merge 1:m HHID2016 INDID2016 using "raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

gen year=2016
drop HHID2016 INDID2016
order HHID_panel INDID_panel year

save"N1_celib", replace






***** 2020-21
use"raw/NEEMSIS2-HH", clear

keep HHID2020 INDID2020 age sex currentlyatschool maritalstatus livinghome lefthomereason dummylefthousehold reasonlefthome

* Merge caste
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-caste"
keep if _merge==3
drop _merge

* Merge income
merge m:1 HHID2020 using "raw/NEEMSIS2-occup_HH", keepusing(annualincome_HH shareincomeagri_HH shareincomenonagri_HH)
drop _merge

* Merge assets
merge m:1 HHID2020 using "raw/NEEMSIS2-assets", keepusing(assets_total1000 assets_totalnoland1000 assets_totalnoprop1000 assets_ownland)
drop _merge

* Merge education
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-education"
keep if _merge==3
drop _merge

* Merge occupation
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-occup_indiv", keepusing(working_pop mainocc_occupation_indiv mainocc_annualincome_indiv annualincome_indiv nboccupation_indiv hoursayear_indiv)
keep if _merge==3
drop _merge

* Merge HHID panel
merge m:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

* Merge INDID panel
tostring INDID2020, replace
merge 1:m HHID2020 INDID2020 using "raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

gen year=2020
drop HHID2020 INDID2020
order HHID_panel INDID_panel year

* Decode
decode lefthomereason, gen(ok)
drop lefthomereason
rename ok lefthomereason

save"N2_celib", replace


***** Formation
use"N1_celib", replace
fre lefthomereason

append using "N2_celib"

* Recode
recode currentlyatschool (.=0)
fre currentlyatschool

* Creation 
gen ownland=0
replace ownland=1 if assets_ownland!=. & assets_ownland!=0

ta ownland year, col nofreq
preserve
keep HHID_panel year ownland
duplicates drop
ta year
ta ownland year, col nofreq
restore

* Creation 2
label define divHH 1"Agricultural household" 2"Non-agricultural household" 3"Diversified household"
gen divHH0=.
replace divHH0=1 if shareincomeagri_HH==1
replace divHH0=2 if shareincomeagri_HH==0
replace divHH0=3 if shareincomeagri_HH!=0 & shareincomeagri_HH!=1 & shareincomeagri_HH!=.
label values divHH0 divHH
fre divHH0
gen divHH5=.
replace divHH5=1 if shareincomeagri_HH>=0.95
replace divHH5=2 if shareincomeagri_HH<=0.05
replace divHH5=3 if shareincomeagri_HH>0.05 & shareincomeagri_HH<0.95 & shareincomeagri_HH!=.
label values divHH5 divHH
fre divHH5
gen divHH10=.
replace divHH10=1 if shareincomeagri_HH>=0.9
replace divHH10=2 if shareincomeagri_HH<=0.1
replace divHH10=3 if shareincomeagri_HH>0.1 & shareincomeagri_HH<0.9 & shareincomeagri_HH!=.
label values divHH10 divHH
fre divHH10

* Gen celibat
gen celib=.
replace celib=0 if maritalstatus==1
replace celib=1 if maritalstatus==2
replace celib=. if maritalstatus==3
replace celib=. if maritalstatus==4
replace celib=. if maritalstatus==5

label define celib 0"Married" 1"Single"
label values celib celib

order celib, after(maritalstatus)

save"Celibat", replace
****************************************
* END










****************************************
* Celibat
****************************************

********** Stat
use"Celibat", clear

* Selection
keep if sex==1
fre maritalstatus
drop if celib==.
sort HHID_panel INDID_panel year
keep if age>=30

* Evolution
ta celib year, col nofreq


cls
* Determinants in 2016-17
preserve
keep if year==2016
ta caste celib, col nofreq chi2

ta edulevel celib, col nofreq chi2
ta edulevel celib, exp cchi2 chi2

ta working_pop celib, col nofreq chi2
ta working_pop celib, exp cchi2 chi2

ta mainocc_occupation_indiv celib, col nofreq chi2
ta mainocc_occupation_indiv celib, exp cchi2 chi2

ta ownland celib, col nofreq chi2
ta divHH10 celib, col nofreq chi2

tabstat annualincome_HH annualincome_indiv, stat(mean sd) by(celib)
reg annualincome_HH i.celib
reg annualincome_indiv i.celib
restore


cls
* Determinants in 2020-21
preserve
keep if year==2020
ta caste celib, col nofreq chi2

ta edulevel celib, col nofreq chi2
ta edulevel celib, exp cchi2 chi2

ta working_pop celib, col nofreq chi2
ta working_pop celib, exp cchi2 chi2

ta mainocc_occupation_indiv celib, col nofreq chi2
ta mainocc_occupation_indiv celib, exp cchi2 chi2

ta ownland celib, col nofreq chi2
ta divHH10 celib, col nofreq chi2

tabstat annualincome_HH annualincome_indiv, stat(mean sd) by(celib)
reg annualincome_HH i.celib
reg annualincome_indiv i.celib
restore








********** Graph
use"Celibat", clear

* Selection
keep if sex==1
fre maritalstatus
drop if celib==.
sort HHID_panel INDID_panel year
keep if age>=30
label define caste 1"Dalits" 2"Middle castes" 3"Upper castes", replace
label values caste caste


ta celib year if caste==1, col nofreq

* Share
collapse (mean) celib, by(year caste)
replace celib=celib*100

graph bar (mean) celib, over(year, lab(nolab)) over(caste) asyvars ///
bar(1, fcolor(gs0)) bar(2, fcolor(gs7)) ///
ytitle("Percent") ylabel(0(1)9) ymtick(0(.5)9) ///
title("Share of single males") ///
legend(order(1 "2016-17" 2 "2020-21") pos(6) col(3)) name(celib, replace)

graph export "graph/single_males.png", as(png) replace



****************************************
* END



