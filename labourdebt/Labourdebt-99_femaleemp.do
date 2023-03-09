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
* Female employment
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






