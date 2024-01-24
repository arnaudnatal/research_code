*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*December 5, 2023
*-----
gl link = "labourdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------









****************************************
* 2016-17 at individual level
****************************************
use"raw/NEEMSIS1-occup_indiv", clear


* Vérification
tabstat hoursayear_indiv hoursayearagri_indiv hoursayearnonagri_indiv, stat(p90 p95 p99 max)
replace hoursayear_indiv=7300 if hoursayear_indiv>7300 & hoursayear_indiv!=.
replace hoursayearagri_indiv=7300 if hoursayearagri_indiv>7300 & hoursayearagri_indiv!=.
replace hoursayearnonagri_indiv=7300 if hoursayearnonagri_indiv>7300 & hoursayearnonagri_indiv!=.


* Merge sex, age
merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-HH", keepusing(sex age relationshiptohead livinghome maritalstatus)
drop _merge

* Merge edulevel
merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-education", keepusing(edulevel)
drop _merge

* Keep
keep HHID2016 INDID2016 hoursayear_indiv sex age edulevel   relationshiptohead dummyworkedpastyear working_pop livinghome nboccupation_indiv mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv mainocc_hoursayear_indiv mainocc_tenureday_indiv maritalstatus

* Merge panel
merge m:m HHID2016 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2016, replace
merge 1:m HHID_panel INDID2016 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

gen year=2016
order HHID_panel INDID_panel HHID2016 INDID2016 year

* Ajout hours 2016
gen hoursayear_indiv2016=hoursayear_indiv

* Selection 
fre livinghome
drop if livinghome==3
drop if livinghome==4
drop livinghome

* Maritalstatus
fre maritalstatus

save "hoursindiv2016", replace
****************************************
* END











****************************************
* 2016-17 at occupation level 
****************************************
use"raw/NEEMSIS1-occupnew", clear

* Var to keep
keep HHID2016 INDID2016 year occupationname hoursayear kindofwork_new profession sector occupation

* Merge panel
merge m:m HHID2016 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2016, replace
merge m:m HHID_panel INDID2016 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Construction of type of job
fre occupation
ta occupation, gen(occ)

forvalues i=1/7 {
gen hours_occ`i'=.
}
forvalues i=1/7 {
replace hours_occ`i'=hoursayear if occ`i'==1
}

forvalues i=1/7 {
bysort HHID2016 INDID2016: egen indiv_hours_occ`i'=sum(hours_occ`i')
}

rename indiv_hours_occ1 hours_agriself
rename indiv_hours_occ2 hours_agricasu
rename indiv_hours_occ3 hours_casua
rename indiv_hours_occ4 hours_regnonqu
rename indiv_hours_occ5 hours_regquali
rename indiv_hours_occ6 hours_self
rename indiv_hours_occ7 hours_nrega

global var HHID_panel INDID_panel year hours_agriself hours_agricasu hours_casua hours_regnonqu hours_regquali hours_self hours_nrega
keep $var
order $var
duplicates drop

* Max
foreach x in hours_agriself hours_agricasu hours_casua hours_regnonqu hours_regquali hours_self hours_nrega {
tabstat `x', stat(p90 p95 p99 max)
replace `x'=7300 if `x'>7300 & `x'!=.
}

save"hoursindiv2016_bis", replace
****************************************
* END













****************************************
* 2020-21 at individual level
****************************************
use"raw/NEEMSIS2-occup_indiv", clear

* Vérification
tabstat hoursayear_indiv hoursayearagri_indiv hoursayearnonagri_indiv, stat(p90 p95 p99 max)
replace hoursayear_indiv=7300 if hoursayear_indiv>7300 & hoursayear_indiv!=.
replace hoursayearagri_indiv=7300 if hoursayearagri_indiv>7300 & hoursayearagri_indiv!=.
replace hoursayearnonagri_indiv=7300 if hoursayearnonagri_indiv>7300 & hoursayearnonagri_indiv!=.


* Merge sex, age
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-HH", keepusing(sex age relationshiptohead livinghome dummylefthousehold maritalstatus)
drop _merge

* Merge edulevel
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-education", keepusing(edulevel)
drop _merge

* Keep
keep HHID2020 INDID2020 hoursayear_indiv sex age edulevel relationshiptohead dummyworkedpastyear working_pop livinghome dummylefthousehold nboccupation_indiv mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv mainocc_hoursayear_indiv mainocc_tenureday_indiv maritalstatus

* Merge panel
merge m:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge 1:m HHID_panel INDID2020 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

gen year=2020
order HHID_panel INDID_panel HHID2020 INDID2020 year

* Ajout hours 2020
gen hoursayear_indiv2020=hoursayear_indiv

* Selection
fre livinghome
drop if livinghome==3
drop if livinghome==4
drop if dummylefthousehold==1
drop livinghome dummylefthousehold

* Maritalstatus
fre maritalstatus
recode maritalstatus (.=5)

save "hoursindiv2020", replace
****************************************
* END











****************************************
* 2020-21 at occupation level 
****************************************
use"raw/NEEMSIS2-occupnew", clear

* Var to keep
keep HHID2020 INDID2020 year occupationname hoursayear kindofwork_new profession sector occupation

* Merge panel
merge m:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Construction of type of job
fre occupation
ta occupation, gen(occ)

forvalues i=1/7 {
gen hours_occ`i'=.
}
forvalues i=1/7 {
replace hours_occ`i'=hoursayear if occ`i'==1
}

forvalues i=1/7 {
bysort HHID2020 INDID2020: egen indiv_hours_occ`i'=sum(hours_occ`i')
}

rename indiv_hours_occ1 hours_agriself
rename indiv_hours_occ2 hours_agricasu
rename indiv_hours_occ3 hours_casua
rename indiv_hours_occ4 hours_regnonqu
rename indiv_hours_occ5 hours_regquali
rename indiv_hours_occ6 hours_self
rename indiv_hours_occ7 hours_nrega

global var HHID_panel INDID_panel year hours_agriself hours_agricasu hours_casua hours_regnonqu hours_regquali hours_self hours_nrega
keep $var
order $var
duplicates drop

* Max
foreach x in hours_agriself hours_agricasu hours_casua hours_regnonqu hours_regquali hours_self hours_nrega {
tabstat `x', stat(p90 p95 p99 max)
replace `x'=7300 if `x'>7300 & `x'!=.
}

save"hoursindiv2020_bis", replace
****************************************
* END












****************************************
* Working conditions
****************************************
use"raw/NEEMSIS2-ego", clear


* Merge panel
merge m:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge


* Selection
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

* Gen global
foreach x in executionwork problemwork workexposure {
replace `x'=`x'*100
}
gen wec=(executionwork+problemwork+workexposure)/3
tabstat wec, stat(min max)

* To keep
gen year=2020
global var HHID_panel INDID_panel year wec executionwork problemwork workexposure
keep $var
order $var

save"wec", replace
****************************************
* END











****************************************
* Discrimination
****************************************
use"raw/NEEMSIS2-ego", clear


* Merge panel
merge m:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge


* Discrimination
global discri discrimination1 discrimination2 discrimination3 discrimination4 discrimination5 discrimination6 discrimination7 discrimination8 discrimination9
fre $discri
egen discrimination=rowtotal($discri)
replace discrimination=discrimination/9
ta discrimination

* Discrimination dummy
gen discrimination_dummy=discrimination
replace discrimination_dummy=1 if discrimination_dummy>0
ta discrimination_dummy


* To keep
gen year=2020
global var HHID_panel INDID_panel year discrimination discrimination_dummy respect workmate agreementatwork1 agreementatwork2 agreementatwork3 agreementatwork4 happywork verbalaggression physicalagression sexualharassment
keep $var
order $var
rename physicalagression physicalaggression

save"discri", replace
****************************************
* END















****************************************
* Append indiv database
****************************************

********** Main base
use"hoursindiv2016", clear

* Hours 2020
append using "hoursindiv2020"
order HHID_panel INDID_panel year
drop HHID2016 HHID2020 INDID2016 INDID2020

duplicates tag HHID_panel INDID_panel year, gen(tag)
ta tag
drop tag

save"hoursindiv", replace


********** Complementary database
use"hoursindiv2016_bis", clear

* Hours 2020
append using "hoursindiv2020_bis"
order HHID_panel INDID_panel year

duplicates tag HHID_panel INDID_panel year, gen(tag)
ta tag
drop tag

save"hoursindiv_bis", replace


********** Merge
use"hoursindiv", clear

merge 1:1 HHID_panel INDID_panel year using "hoursindiv_bis"
drop if _merge==2
drop _merge

merge 1:1 HHID_panel INDID_panel year using "wec"
drop if _merge==2
drop _merge

merge 1:1 HHID_panel INDID_panel year using "discri"
drop if _merge==2
drop _merge


save"hoursindiv_v2", replace
****************************************
* END






 

****************************************
* Creation variables at indiv level
****************************************
use"hoursindiv_v2", clear

* Work?
gen work=0
replace work=1 if nboccupation_indiv>0 & nboccupation_indiv!=.


* Multiple?
gen multipleoccup=0
replace multipleoccup=1 if nboccupation_indiv>1 & nboccupation_indiv!=.


ta nboccupation_indiv work, m
ta nboccupation_indiv multipleoccup, m

* Clean
drop hoursayear_indiv2016 hoursayear_indiv2020


* Type of job aggregation
gen hours_agri=hours_agriself+hours_agricasu
gen hours_nonagri=hours_casua+hours_regnonqu+hours_regquali+hours_self+hours_nrega
gen hours_selfemp=hours_agriself+hours_self
gen hours_casu=hours_agricasu+hours_casua+hours_nrega

order hours_agri hours_nonagri hours_selfemp hours_casu, after(hours_nrega)


* Deflate and round
foreach x in mainocc_annualincome_indiv annualincome_indiv {
replace `x'=`x'*1.85 if year==2010
replace `x'=`x'*1.16 if year==2016
replace `x'=round(`x',1)
}


* Maritalstatus
recode maritalstatus (4=3) (5=4)
label define maritalstatus 1"Married: Yes" 2"Married: No" 3"Married: Other" 4"Married: Below 10", replace
label values maritalstatus maritalstatus
preserve
drop if age<14
fre maritalstatus
restore
rename maritalstatus marital

* Share
tabstat hours_agriself hours_agricasu hours_casua hours_regnonqu hours_regquali hours_self hours_nrega hours_agri hours_nonagri hours_selfemp hours_casu, stat(n mean q p90 p95 p99 max)

save "laboursupply_indiv", replace
****************************************
* END











****************************************
* Creation variables at HH level
****************************************
use"laboursupply_indiv", clear

* By sex
gen hours_male=hoursayear_indiv if sex==1
gen hours_female=hoursayear_indiv if sex==2

* By age
gen hours_old=hoursayear_indiv if age>58

* HH level
global var hours_male hours_female hours_old hours_agriself hours_agricasu hours_casua hours_regnonqu hours_regquali hours_self hours_nrega hours_agri hours_nonagri hours_selfemp hours_casu

foreach x in $var {
bysort HHID_panel year: egen s_`x'=sum(`x')
drop `x'
rename s_`x' `x'
}

* Keep
keep HHID_panel year $var
duplicates drop
foreach x in $var {
rename `x' `x'_HH
}
ta year


save "laboursupply_HH", replace
****************************************
* END
