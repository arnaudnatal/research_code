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


*** Total 
pwcorr snbo shay, sig
foreach x in male female young middle old {
pwcorr snbo_`x' shay_`x', sig
}


*** 2016-17
cls
preserve
keep if year==2016
pwcorr snbo shay, sig
foreach x in male female young middle old {
pwcorr snbo_`x' shay_`x', sig
}
restore


*** 2020-21
cls
preserve
keep if year==2020 
pwcorr snbo shay, sig
foreach x in male female young middle old {
pwcorr snbo_`x' shay_`x', sig
}
restore



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






********** Only income gen employment
use"panel-occoccvar", clear

drop if workingage==0

*
fre kindofwork
fre kindofwork2010

* Drop domestic work
drop if kindofwork==5
drop if kindofwork==7
drop if kindofwork==6
drop if kindofwork==8


*
gen male=1 if sex==1
gen female=1 if sex==2
gen young=1 if age<=29
gen middle=1 if age>=30 & age<60
gen old=1 if age>=60

* Occ level
bysort HHID_panel year: egen snbo3=sum(1)
foreach x in male female young middle old {
bysort HHID_panel year: egen snbo3_`x'=sum(`x')
}

* Indiv level
bysort HHID_panel INDID_panel year: egen ind3=sum(1)
foreach x in male female young middle old {
bysort HHID_panel INDID_panel year: egen ind3_`x'=sum(`x')
}
foreach x in ind3 ind3_male ind3_female ind3_young ind3_middle ind3_old {
replace `x'=1 if `x'>0
}
preserve
keep HHID_panel INDID_panel year ind3 ind3_male ind3_female ind3_young ind3_middle ind3_old
duplicates drop
ta year
bysort HHID_panel year: egen sind3=sum(ind3)
foreach x in male female young middle old {
bysort HHID_panel year: egen sind3_`x'=sum(ind3_`x')
}
drop ind3 ind3_male ind3_female ind3_young ind3_middle ind3_old
drop INDID_panel
duplicates drop
ta year
save"_temp_HHoccnoHH.dta", replace
restore


keep HHID_panel year snbo3 snbo3_male snbo3_female snbo3_young snbo3_middle snbo3_old
duplicates drop
ta year

merge 1:1 HHID_panel year using "_temp_HHoccnoHH.dta"

drop _merge

save"panel-occoccvar_v3", replace

****************************************
* END


















****************************************
* New vars
****************************************


********** RUME
use"raw/RUME-occupnew", clear

fre occupation
drop if occupation==0

gen occ_agri=0
replace occ_agri=1 if occupation==1
replace occ_agri=1 if occupation==2
gen occ_nagr=0
replace occ_nagr=1 if occupation==3
replace occ_nagr=1 if occupation==4
replace occ_nagr=1 if occupation==5
replace occ_nagr=1 if occupation==6
replace occ_nagr=1 if occupation==7

gen occ_casu=0
replace occ_casu=1 if occupation==2
replace occ_casu=1 if occupation==3
replace occ_casu=1 if occupation==7
gen occ_ncas=0
replace occ_ncas=1 if occupation==1
replace occ_ncas=1 if occupation==4
replace occ_ncas=1 if occupation==5
replace occ_ncas=1 if occupation==6

gen occ_self=0
replace occ_self=1 if occupation==1
replace occ_self=1 if occupation==6
gen occ_nsel=0
replace occ_nsel=1 if occupation==2
replace occ_nsel=1 if occupation==3
replace occ_nsel=1 if occupation==4
replace occ_nsel=1 if occupation==5
replace occ_nsel=1 if occupation==7

gen occ_agse=0
replace occ_agse=1 if occupation==1
gen occ_agca=0
replace occ_agca=1 if occupation==2
gen occ_naca=0
replace occ_naca=1 if occupation==3
gen occ_nare=0
replace occ_nare=1 if occupation==4
replace occ_nare=1 if occupation==5
gen occ_nase=0
replace occ_nase=1 if occupation==6
gen occ_nreg=0
replace occ_nreg=1 if occupation==7


foreach x in occ_agri occ_nagr occ_casu occ_ncas occ_self occ_nsel occ_agse occ_agca occ_naca occ_nare occ_nase occ_nreg {
bysort HHID2010: egen s`x'=sum(`x')
}

keep HHID2010 socc_agri socc_nagr socc_casu socc_ncas socc_self socc_nsel socc_agse socc_agca socc_naca socc_nare socc_nase socc_nreg
duplicates drop

merge 1:m HHID2010 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge HHID2010
gen year=2010
order HHID_panel year

save"RUME_newdbnewvar", replace






********** NEEMSIS-1
use"raw/NEEMSIS1-occupnew", clear

fre occupation
drop if occupation==0

gen occ_agri=0
replace occ_agri=1 if occupation==1
replace occ_agri=1 if occupation==2
gen occ_nagr=0
replace occ_nagr=1 if occupation==3
replace occ_nagr=1 if occupation==4
replace occ_nagr=1 if occupation==5
replace occ_nagr=1 if occupation==6
replace occ_nagr=1 if occupation==7

gen occ_casu=0
replace occ_casu=1 if occupation==2
replace occ_casu=1 if occupation==3
replace occ_casu=1 if occupation==7
gen occ_ncas=0
replace occ_ncas=1 if occupation==1
replace occ_ncas=1 if occupation==4
replace occ_ncas=1 if occupation==5
replace occ_ncas=1 if occupation==6

gen occ_self=0
replace occ_self=1 if occupation==1
replace occ_self=1 if occupation==6
gen occ_nsel=0
replace occ_nsel=1 if occupation==2
replace occ_nsel=1 if occupation==3
replace occ_nsel=1 if occupation==4
replace occ_nsel=1 if occupation==5
replace occ_nsel=1 if occupation==7

gen occ_agse=0
replace occ_agse=1 if occupation==1
gen occ_agca=0
replace occ_agca=1 if occupation==2
gen occ_naca=0
replace occ_naca=1 if occupation==3
gen occ_nare=0
replace occ_nare=1 if occupation==4
replace occ_nare=1 if occupation==5
gen occ_nase=0
replace occ_nase=1 if occupation==6
gen occ_nreg=0
replace occ_nreg=1 if occupation==7


foreach x in occ_agri occ_nagr occ_casu occ_ncas occ_self occ_nsel occ_agse occ_agca occ_naca occ_nare occ_nase occ_nreg {
bysort HHID2016: egen s`x'=sum(`x')
}

keep HHID2016 socc_agri socc_nagr socc_casu socc_ncas socc_self socc_nsel socc_agse socc_agca socc_naca socc_nare socc_nase socc_nreg
duplicates drop

merge 1:m HHID2016 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge HHID2016
gen year=2016
order HHID_panel year

save"NEEMSIS1_newdbnewvar", replace






********** NEEMSIS-2
use"raw/NEEMSIS2-occupnew", clear

fre occupation
drop if occupation==0

gen occ_agri=0
replace occ_agri=1 if occupation==1
replace occ_agri=1 if occupation==2
gen occ_nagr=0
replace occ_nagr=1 if occupation==3
replace occ_nagr=1 if occupation==4
replace occ_nagr=1 if occupation==5
replace occ_nagr=1 if occupation==6
replace occ_nagr=1 if occupation==7

gen occ_casu=0
replace occ_casu=1 if occupation==2
replace occ_casu=1 if occupation==3
replace occ_casu=1 if occupation==7
gen occ_ncas=0
replace occ_ncas=1 if occupation==1
replace occ_ncas=1 if occupation==4
replace occ_ncas=1 if occupation==5
replace occ_ncas=1 if occupation==6

gen occ_self=0
replace occ_self=1 if occupation==1
replace occ_self=1 if occupation==6
gen occ_nsel=0
replace occ_nsel=1 if occupation==2
replace occ_nsel=1 if occupation==3
replace occ_nsel=1 if occupation==4
replace occ_nsel=1 if occupation==5
replace occ_nsel=1 if occupation==7

gen occ_agse=0
replace occ_agse=1 if occupation==1
gen occ_agca=0
replace occ_agca=1 if occupation==2
gen occ_naca=0
replace occ_naca=1 if occupation==3
gen occ_nare=0
replace occ_nare=1 if occupation==4
replace occ_nare=1 if occupation==5
gen occ_nase=0
replace occ_nase=1 if occupation==6
gen occ_nreg=0
replace occ_nreg=1 if occupation==7


foreach x in occ_agri occ_nagr occ_casu occ_ncas occ_self occ_nsel occ_agse occ_agca occ_naca occ_nare occ_nase occ_nreg {
bysort HHID2020: egen s`x'=sum(`x')
}

keep HHID2020 socc_agri socc_nagr socc_casu socc_ncas socc_self socc_nsel socc_agse socc_agca socc_naca socc_nare socc_nase socc_nreg
duplicates drop

merge 1:m HHID2020 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge HHID2020
gen year=2020
order HHID_panel year

save"NEEMSIS2_newdbnewvar", replace



********** Append all
use"RUME_newdbnewvar", clear

append using "NEEMSIS1_newdbnewvar"
append using "NEEMSIS2_newdbnewvar"

save"panel_newdbnewvar", replace
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

*** Merge with only income gen
merge 1:1 HHID_panel year using "panel-occoccvar_v3"
drop _merge

*** Merge with all new
merge 1:1 HHID_panel year using "panel_newdbnewvar"
drop _merge
recode socc_agri socc_nagr socc_casu socc_ncas socc_self socc_nsel socc_agse socc_agca socc_naca socc_nare socc_nase socc_nreg (.=0)


*** Diff
gen test1=snbo-snbo2
ta test1

gen test2=snbo2-snbo3
ta test2

drop test1 test2


*** Relative nb of occupations
foreach x in snbo snbo_female snbo_male snbo_young snbo_middle snbo_old snbo2 snbo2_female snbo2_male snbo2_young snbo2_middle snbo2_old snbo3 snbo3_female snbo3_male snbo3_young snbo3_middle snbo3_old socc_agri socc_nagr socc_casu socc_ncas socc_self socc_nsel socc_agse socc_agca socc_naca socc_nare socc_nase socc_nreg {
gen rel_`x'=`x'/HHsize
}



*** Clean
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV65" & year==2020
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="KUV67" & year==2020



save"panel_v3", replace
****************************************
* END
