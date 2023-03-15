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
use"panel_indiv_v3", clear

* General
ta year
fre mainocc_occupation_indiv



********** Working pop
*** Stat
ta dummyworkedpastyear sex if year==2010, col nofreq
ta dummyworkedpastyear sex if year==2016, col nofreq
ta dummyworkedpastyear sex if year==2020, col nofreq

*** Sex %
*tabplot dummyworkedpastyear sex, perc(sex) showval frame(100) horizontal

*** Occupation %
*tabplot dummyworkedpastyear sex, perc(dummyworkedpastyear) showval frame(100) horizontal





********** Main occupation
drop if mainocc_occupation_indiv==.
drop if mainocc_occupation_indiv==0

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
graph export "graph/Labourfemale.pdf", as(pdf) replace

set graph on

****************************************
* END













****************************************
* Working conditions of females compared to males
****************************************
use"raw/NEEMSIS2-ego", clear

* Sex age
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-HH", keepusing(sex age)
keep if _merge==3
drop _merge

* Occupations
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-occup_indiv"
keep if _merge==3
drop _merge

* Education
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-education"
keep if _merge==3
drop _merge

* KILM
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-kilm"
keep if _merge==3
drop _merge


save"NEEMSIS2-workingconditions", replace
****************************************
* END



















****************************************
* Working conditions 
****************************************
use"NEEMSIS2-workingconditions", clear

drop if executionwork1==.

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


* Accident loss work
fre accidentalinjury losswork lossworknumber mostseriousincident mostseriousinjury seriousinjuryother physicalharm



save"NEEMSIS2-workingconditions_v2", replace
****************************************
* END
















****************************************
* Analysis
****************************************
use"NEEMSIS2-workingconditions_v2", clear



********** Corr sex occupation
ta mainocc_occupation_indiv sex, chi2 cchi2 exp
/*
Females are over represented among vulnerable occupations such as NREGA and agri casual workers
*/


********* Occupation and working conditions
foreach y in executionwork problemwork workexposure {
reg `y' ib(3).mainocc_occupation_indiv, base
}



********* Graph bar
tabstat executionwork problemwork workexposure, stat(mean) by(mainocc_occupation_indiv)

collapse (mean) executionwork problemwork workexposure, by(mainocc_occupation_indiv)
drop if mainocc_occupation_indiv==.

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


* Combine
graph combine exe pb work, col(3) name(comb, replace)
graph export "graph/Workingcond.pdf", as(pdf) replace

****************************************
* END








