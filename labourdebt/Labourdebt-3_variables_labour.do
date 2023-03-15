*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*November 19, 2022
*-----
gl link = "labourdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------








****************************************
* New var
****************************************

********** RUME
use"raw/RUME-occup_indiv", clear

keep HHID2010 INDID2010 nboccupation_indiv

*** Merge charact
merge 1:1 HHID2010 INDID2010 using "raw/RUME-kilm", keepusing(workingage employed)
keep if _merge==3
drop _merge

merge 1:1 HHID2010 INDID2010 using "raw/RUME-HH", keepusing(name age sex)
keep if _merge==3
drop _merge

*** Merge HHID_panel
merge m:m HHID2010 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2010

save"RUME-occindivvar", replace




********** NEEMSIS-1
use"raw/NEEMSIS1-occup_indiv", clear

keep HHID2016 INDID2016 nboccupation_indiv hoursayear_indiv

*** Merge charact
merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-kilm", keepusing(workingage employed)
keep if _merge==3
drop _merge

merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-HH", keepusing(name age sex)
keep if _merge==3
drop _merge

*** Merge HHID_panel
merge m:m HHID2016 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2016

save"NEEMSIS1-occindivvar", replace




********** NEEMSIS-2
use"raw/NEEMSIS2-occup_indiv", clear

keep HHID2020 INDID2020 nboccupation_indiv hoursayear_indiv

*** Merge charact
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-kilm", keepusing(workingage employed)
keep if _merge==3
drop _merge

merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-HH", keepusing(name age sex)
keep if _merge==3
drop _merge

*** Merge HHID_panel
merge m:m HHID2020 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2020

save"NEEMSIS2-occindivvar", replace




********** Append
use"RUME-occindivvar"

append using "NEEMSIS1-occindivvar"
append using "NEEMSIS2-occindivvar"

order HHID_panel year name age sex nboccupation_indiv workingage employed 
fre workingage

save"panel-occindivvar", replace

********** Var crea
use"panel-occindivvar", clear

drop if workingage==0
recode nboccupation_indiv (.=0)
rename nboccupation_indiv nbo

* Sub
gen nbo_male=.
gen nbo_female=.
gen nbo_young=.
gen nbo_middle=.
gen nbo_old=.
gen hay_male=.
gen hay_female=.
gen hay_young=.
gen hay_middle=.
gen hay_old=.

* Sex
fre sex
replace nbo_male=nbo if sex==1
replace nbo_female=nbo if sex==2
replace hay_male=hoursayear_indiv if sex==1
replace hay_female=hoursayear_indiv if sex==2

* Age
replace nbo_young=nbo if age<=29
replace nbo_middle=nbo if age>=30 & age<60
replace nbo_old=nbo if age>=60
replace hay_young=hoursayear_indiv if age<=29
replace hay_middle=hoursayear_indiv if age>=30 & age<60
replace hay_old=hoursayear_indiv if age>=60

*
rename hoursayear_indiv hay

* Recode
foreach x in nbo nbo_male nbo_female nbo_young nbo_middle nbo_old hay hay_female hay_male hay_middle hay_old hay_young {
recode `x' (.=0)
}

* Indiv level
gen ind=nbo
recode ind (.=0)
foreach x in male female young middle old {
gen ind_`x'=nbo_`x'
recode ind_`x' (.=0)
}
replace ind=1 if ind>1
foreach x in male female young middle old {
replace ind_`x'=1 if ind_`x'>1
}


* HH level
foreach x in nbo nbo_male nbo_female nbo_young nbo_middle nbo_old ind ind_male ind_female ind_young ind_middle ind_old hay hay_female hay_male hay_middle hay_old hay_young {
bysort HHID_panel year: egen s`x'=sum(`x')
}


keep HHID_panel year snbo* sind* shay*
duplicates drop

tab1 snbo snbo_male snbo_female snbo_young snbo_middle snbo_old
tab1 sind sind_male sind_female sind_young sind_middle sind_old


save"panel-occindivvar_v2", replace

****************************************
* END











****************************************
* Corr hours a year number of occupations
****************************************
cls
use"panel-occindivvar_v2", clear


***
pwcorr snbo shay, sig
foreach x in male female young middle old {
pwcorr snbo_`x' shay_`x', sig
}

****************************************
* END











****************************************
* New var with only income gen and no HH labour
****************************************

********** RUME
use"raw/RUME-occupnew", clear

keep HHID2010 INDID2010 kindofwork annualincome occupation

*** Merge charact
merge m:1 HHID2010 INDID2010 using "raw/RUME-kilm", keepusing(workingage employed)
keep if _merge==3
drop _merge

merge m:1 HHID2010 INDID2010 using "raw/RUME-HH", keepusing(name age sex)
keep if _merge==3
drop _merge

*** Merge HHID_panel
merge m:m HHID2010 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2010
rename kindofwork kindofwork2010

fre kindofwork
label define kow 1"Agri" 2"Coolie" 3"Agri coolie" 4"NREGA" 5"Invest" 6"Employee" 8"SE" 9"Pension"
label values kindofwork kow

save"RUME-occoccvar", replace




********** NEEMSIS-1
use"raw/NEEMSIS1-occupnew", clear

keep HHID2016 INDID2016 kindofwork_new annualincome occupation
rename kindofwork_new kindofwork

*** Merge charact
merge m:1 HHID2016 INDID2016 using "raw/NEEMSIS1-kilm", keepusing(workingage employed)
keep if _merge==3
drop _merge

merge m:1 HHID2016 INDID2016 using "raw/NEEMSIS1-HH", keepusing(name age sex)
keep if _merge==3
drop _merge

*** Merge HHID_panel
merge m:m HHID2016 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2016

fre kindofwork


save"NEEMSIS1-occoccvar", replace




********** NEEMSIS-2
use"raw/NEEMSIS2-occupnew", clear

keep HHID2020 INDID2020 kindofwork_new annualincome occupation
rename kindofwork_new kindofwork

*** Merge charact
merge m:1 HHID2020 INDID2020 using "raw/NEEMSIS2-kilm", keepusing(workingage employed)
keep if _merge==3
drop _merge

merge m:1 HHID2020 INDID2020 using "raw/NEEMSIS2-HH", keepusing(name age sex)
keep if _merge==3
drop _merge

*** Merge HHID_panel
merge m:m HHID2020 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2020


save"NEEMSIS2-occoccvar", replace




********** Append
use"RUME-occoccvar", clear

append using "NEEMSIS1-occoccvar"
append using "NEEMSIS2-occoccvar"

order HHID_panel year name age sex 

*** Merge INDID_panel
ta year
tostring INDID2016, replace
tostring INDID2020, replace
tostring year, replace

gen INDID=""
replace INDID=INDID2010 if year=="2010"
replace INDID=INDID2016 if year=="2016"
replace INDID=INDID2020 if year=="2020"


merge m:1 HHID_panel INDID year using "raw/ODRIIS-indiv_long", keepusing(INDID_panel)
keep if _merge==3

drop _merge

order HHID_panel INDID_panel year

destring INDID2016, replace
destring INDID2020, replace
destring year, replace

save"panel-occoccvar", replace




********** Drop HH work
use"panel-occoccvar", clear

drop if workingage==0

*
fre kindofwork
fre kindofwork2010

* Drop domestic work
drop if kindofwork==5
drop if kindofwork==7

* Non-income gen work
*drop if kindofwork==6
*drop if kindofwork==8


*
gen male=1 if sex==1
gen female=1 if sex==2
gen young=1 if age<=29
gen middle=1 if age>=30 & age<60
gen old=1 if age>=60

* Occ level
bysort HHID_panel year: egen snbo2=sum(1)
foreach x in male female young middle old {
bysort HHID_panel year: egen snbo2_`x'=sum(`x')
}

* Indiv level
bysort HHID_panel INDID_panel year: egen ind2=sum(1)
foreach x in male female young middle old {
bysort HHID_panel INDID_panel year: egen ind2_`x'=sum(`x')
}
foreach x in ind2 ind2_male ind2_female ind2_young ind2_middle ind2_old {
replace `x'=1 if `x'>0
}
preserve
keep HHID_panel INDID_panel year ind2 ind2_male ind2_female ind2_young ind2_middle ind2_old
duplicates drop
ta year
bysort HHID_panel year: egen sind2=sum(ind2)
foreach x in male female young middle old {
bysort HHID_panel year: egen sind2_`x'=sum(ind2_`x')
}
drop ind2 ind2_male ind2_female ind2_young ind2_middle ind2_old
drop INDID_panel
duplicates drop
ta year
save"_temp_HHoccnoHH.dta", replace
restore


keep HHID_panel year snbo2 snbo2_male snbo2_female snbo2_young snbo2_middle snbo2_old
duplicates drop
ta year

merge 1:1 HHID_panel year using "_temp_HHoccnoHH.dta"

drop _merge

save"panel-occoccvar_v2", replace
****************************************
* END










****************************************
* Merge with main dataset
****************************************
use"panel_v2", clear


*** Merge all
merge 1:1 HHID_panel year using "panel-occindivvar_v2"
drop _merge

*** Merge without HH labour
merge 1:1 HHID_panel year using "panel-occoccvar_v2"
drop _merge


*** Drop
ta sind sind2
ta snbo snbo2


save"panel_v3", replace
****************************************
* END
