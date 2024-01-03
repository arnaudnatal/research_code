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
* 2020-21 at individual level
****************************************
use"raw/NEEMSIS2-occup_indiv", clear

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
* Append indiv database
****************************************
use"hoursindiv2016", clear

append using "hoursindiv2020"
order HHID_panel INDID_panel year
drop HHID2016 HHID2020 INDID2016 INDID2020

save"hoursindiv", replace
****************************************
* END









****************************************
* Creation variables
****************************************
use"hoursindiv", clear


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



*** Deflate and round
foreach x in mainocc_annualincome_indiv annualincome_indiv {
replace `x'=`x'*0.54 if year==2010
replace `x'=`x'*0.86 if year==2016
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

save "laboursupply_indiv", replace
****************************************
* END
