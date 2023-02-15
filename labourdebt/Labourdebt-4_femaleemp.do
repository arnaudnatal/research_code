*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*January 12, 2023
*-----
gl link = "labourdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------








****************************************
* Base indiv
****************************************

*** 2010
use"raw/RUME-HH", clear

keep HHID2010 INDID2010 name age sex

merge 1:1 HHID2010 INDID2010 using "raw/RUME-occup_indiv"
keep if _merge==3
drop _merge

merge m:m HHID2010 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

merge m:m HHID_panel INDID2010 using "raw/ODRIIS-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

duplicates report HHID_panel INDID_panel
gen year=2010

save"RUME-occdebt_indiv", replace


*** 2016-17
use"raw/NEEMSIS1-HH", clear

drop if livinghome==3
drop if livinghome==4

keep HHID2016 INDID2016 name age sex

merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-occup_indiv"
keep if _merge==3
drop _merge

merge m:m HHID2016 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2016, replace
merge m:m HHID_panel INDID2016 using "raw/ODRIIS-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge
destring INDID2016, replace

duplicates report HHID_panel INDID_panel
gen year=2016

save"NEEMSIS1-occdebt_indiv", replace


*** 2020-21
use"raw/NEEMSIS2-HH", clear

drop if dummylefthousehold==1
drop if livinghome==3
drop if livinghome==4

keep HHID2020 INDID2020 name age sex

merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-occup_indiv"
keep if _merge==3
drop _merge

merge m:m HHID2020 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw/ODRIIS-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge
destring INDID2020, replace

duplicates report HHID_panel INDID_panel
gen year=2020

save"NEEMSIS2-occdebt_indiv", replace



********** Append all
use"RUME-occdebt_indiv", clear

append using "NEEMSIS1-occdebt_indiv"
append using "NEEMSIS2-occdebt_indiv"

order HHID_panel INDID_panel year
drop HHID2010 INDID2010 HHID2016 INDID2016 HHID2020 INDID2020
sort HHID_panel INDID_panel year

*Labour partic
gen labourparticipation=.
replace labourparticipation=1 if dummyworkedpastyear==1
replace labourparticipation=0 if dummyworkedpastyear==0
replace labourparticipation=0 if dummyworkedpastyear==.
ta labourparticipation year, col nofreq

* Clean 
egen panelvar=group(HHID_panel INDID_panel)
gen time=.
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020

order HHID_panel INDID_panel panelvar year time
sort HHID_panel INDID_panel year

save"panel_indiv", replace



********** Append HH var
use"panel_indiv", clear

merge m:1 HHID_panel year using "panel_v8", keepusing(caste dalits fvi)
drop _merge

save"panel_indiv_v2", replace
****************************************
* END















****************************************
* Base indiv
****************************************
use"panel_indiv_v2", clear

* General
fre working_pop
fre mainocc_occupation_indiv
drop if mainocc_occupation_indiv==0



********** Working pop
*** Stat
ta working_pop sex if year==2010, col nofreq
ta working_pop sex if year==2016, col nofreq
ta working_pop sex if year==2020, col nofreq

*** Sex %
*tabplot working_pop sex, perc(sex) showval frame(100) horizontal


*** Occupation %
*tabplot working_pop sex, perc(working_pop) showval frame(100) horizontal





********** Main occupation
drop if mainocc_occupation_indiv==.
*** Stat
ta mainocc_occupation_indiv sex if year==2010, col nofreq
ta mainocc_occupation_indiv sex if year==2016, col nofreq
ta mainocc_occupation_indiv sex if year==2020, col nofreq

codebook mainocc_occupation_indiv
fre mainocc_occupation_indiv
label define occupcode 1"Agri SE" 2"Agri casual" 3"Casual" 4"Reg non-quali" 5"Reg quali" 6"SE" 7"NREGA", modify


set graph off


*** 2010
preserve
keep if year==2010

* Sex %
tabplot mainocc_occupation_indiv sex, perc(sex) ///
frame(100) horizontal ///
showval(format(%2.1f) mlabsize(vsmall)) ///
xtitle("") xlabel(, labgap(medium)) ///
ytitle("") ylabel(, labgap(medium)) ///
subtitle("") title("% by sex") name(sex2010, replace)

* Occupation %
tabplot mainocc_occupation_indiv sex, perc(mainocc_occupation_indiv) ///
frame(100) horizontal ///
showval(format(%2.1f) mlabsize(vsmall)) ///
xtitle("") xlabel(, labgap(medium)) ///
ytitle("") ylabel(, labgap(medium)) ///
subtitle("") title("% by main occupation") name(occ2010, replace)

*** Combine
graph combine sex2010 occ2010, col(2) name(femalecomb2010, replace) title("2010")
restore



*** 2016-17
preserve
keep if year==2016

* Sex %
tabplot mainocc_occupation_indiv sex, perc(sex) ///
frame(100) horizontal ///
showval(format(%2.1f) mlabsize(vsmall)) ///
xtitle("") xlabel(, labgap(medium)) ///
ytitle("") ylabel(, labgap(medium)) ///
subtitle("") title("% by sex") name(sex2016, replace)

* Occupation %
tabplot mainocc_occupation_indiv sex, perc(mainocc_occupation_indiv) ///
frame(100) horizontal ///
showval(format(%2.1f) mlabsize(vsmall)) ///
xtitle("") xlabel(, labgap(medium)) ///
ytitle("") ylabel(, labgap(medium)) ///
subtitle("") title("% by main occupation") name(occ2016, replace)

*** Combine
graph combine sex2016 occ2016, col(2) name(femalecomb2016, replace) title("2016-17")
restore



*** 2020-21
preserve
keep if year==2020

* Sex %
tabplot mainocc_occupation_indiv sex, perc(sex) ///
frame(100) horizontal ///
showval(format(%2.1f) mlabsize(vsmall)) ///
xtitle("") xlabel(, labgap(medium)) ///
ytitle("") ylabel(, labgap(medium)) ///
subtitle("") title("% by sex") name(sex2020, replace)

* Occupation %
tabplot mainocc_occupation_indiv sex, perc(mainocc_occupation_indiv) ///
frame(100) horizontal ///
showval(format(%2.1f) mlabsize(vsmall)) ///
xtitle("") xlabel(, labgap(medium)) ///
ytitle("") ylabel(, labgap(medium)) ///
subtitle("") title("% by main occupation") name(occ2020, replace)

*** Combine
graph combine sex2020 occ2020, col(2) name(femalecomb2020, replace) title("2020-21")
restore




********** Export
graph display femalecomb2010
graph display femalecomb2016
graph display femalecomb2020

graph combine femalecomb2010 femalecomb2016 femalecomb2020, col(1) graphregion(margin(zero)) plotregion(margin(zero))
graph export "Labourfemale.pdf", as(pdf) replace

set graph on

****************************************
* END






