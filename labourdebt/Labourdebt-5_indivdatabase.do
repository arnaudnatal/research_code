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

****************************************
* END









****************************************
* Append HH var
****************************************
use"panel_indiv", clear

merge m:1 HHID_panel year using "panel_v3", keepusing(caste dalits fvi)
drop _merge

save"panel_indiv_v2", replace
****************************************
* END








