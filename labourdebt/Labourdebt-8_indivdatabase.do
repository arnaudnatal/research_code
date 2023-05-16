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

merge 1:1 HHID2010 INDID2010 using "raw/RUME-education"
keep if _merge==3
drop _merge

merge 1:1 HHID2010 INDID2010 using "raw/RUME-kilm"
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

keep HHID2016 INDID2016 name age sex maritalstatus

merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-occup_indiv"
keep if _merge==3
drop _merge

merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-education"
keep if _merge==3
drop _merge

merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-kilm"
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

keep HHID2020 INDID2020 name age sex maritalstatus

merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-occup_indiv"
keep if _merge==3
drop _merge

merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-education"
keep if _merge==3
drop _merge

merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-kilm"
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

* Clean 
egen panelvar=group(HHID_panel INDID_panel)
gen time=.
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020

order HHID_panel INDID_panel panelvar year time
sort HHID_panel INDID_panel year

**
save"panel_indiv", replace
****************************************
* END










****************************************
* Prepa DB + merging
****************************************

********** Indiv
use"panel_indiv", clear

*** To keep
keep HHID_panel INDID_panel year sex age annualincome_indiv nboccupation_indiv mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv edulevel maritalstatus dummyworkedpastyear educ_attainment2 workingage employed

save"panel_indiv_temp", replace


********** HH
use"panel_v3", clear

keep HHID_panel year fvi fvi2 fvi3 fvi4 caste_1 caste_2 caste_3 village_1 village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10 head_female head_age head_educ remittnet_HH assets_total annualincome_HH shareform stem log_HHsize share_female share_children share_young share_old share_stock sexratio dependencyratio

save"panel_hh_temp", replace


********** Merging
use"panel_indiv_temp", clear

merge m:1 HHID_panel year using "panel_hh_temp"
drop _merge

********* Panel
* Panel var
egen panelvar=group(HHID_panel INDID_panel)
order HHID_panel INDID_panel year panelvar
sort HHID_panel INDID_panel year

* Time
gen time=.
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020

label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time



********** Covariates
* Sex
fre sex
gen female=.
replace female=0 if sex==1
replace female=1 if sex==2

* Age
ta age
gen agesq=age*age

* Education
ta educ_attainment2
ta educ_attainment2, gen(edu_)



save"panel_indiv_v2", replace
****************************************
* END











****************************************
* New var
****************************************

********** RUME
use"raw/RUME-occupnew", clear

fre occupation
drop if occupation==0
recode occupation (5=4)

ta occupation, gen(occ_)
rename occ_1 occ_agse
rename occ_2 occ_agca
rename occ_3 occ_naca
rename occ_4 occ_nare
rename occ_5 occ_nase
rename occ_6 occ_nreg

global var occ_agse occ_agca occ_naca occ_nare occ_nase occ_nreg

keep HHID2010 INDID2010 occupationid $var

reshape wide $var, i(HHID2010 INDID2010) j(occupationid)

egen occ_agse=rowtotal(occ_agse1 occ_agse2 occ_agse3 occ_agse4 occ_agse5)
egen occ_agca=rowtotal(occ_agca1 occ_agca2 occ_agca3 occ_agca4 occ_agca5)
egen occ_naca=rowtotal(occ_naca1 occ_naca2 occ_naca3 occ_naca4 occ_naca5)
egen occ_nare=rowtotal(occ_nare1 occ_nare2 occ_nare3 occ_nare4 occ_nare5)
egen occ_nase=rowtotal(occ_nase1 occ_nase2 occ_nase3 occ_nase4 occ_nase5)
egen occ_nreg=rowtotal(occ_nreg1 occ_nreg2 occ_nreg3 occ_nreg4 occ_nreg5)

keep HHID2010 INDID2010 $var

foreach x in $var {
replace `x'=1 if `x'>1 & `x'!=0 & `x'!=.
}

merge m:m HHID2010 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

merge m:m HHID_panel INDID2010 using "raw/ODRIIS-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

drop HHID2010 INDID2010
gen year=2010
order HHID_panel INDID_panel year

save"RUME_indndb", replace



********** NEEMSIS-1
use"raw/NEEMSIS1-occupnew", clear

fre occupation
drop if occupation==0
recode occupation (5=4)

ta occupation, gen(occ_)
rename occ_1 occ_agse
rename occ_2 occ_agca
rename occ_3 occ_naca
rename occ_4 occ_nare
rename occ_5 occ_nase
rename occ_6 occ_nreg

global var occ_agse occ_agca occ_naca occ_nare occ_nase occ_nreg

keep HHID2016 INDID2016 occupationid $var

reshape wide $var, i(HHID2016 INDID2016) j(occupationid)

egen occ_agse=rowtotal(occ_agse1 occ_agse2 occ_agse3 occ_agse4)
egen occ_agca=rowtotal(occ_agca1 occ_agca2 occ_agca3 occ_agca4)
egen occ_naca=rowtotal(occ_naca1 occ_naca2 occ_naca3 occ_naca4)
egen occ_nare=rowtotal(occ_nare1 occ_nare2 occ_nare3 occ_nare4)
egen occ_nase=rowtotal(occ_nase1 occ_nase2 occ_nase3 occ_nase4)
egen occ_nreg=rowtotal(occ_nreg1 occ_nreg2 occ_nreg3 occ_nreg4)

keep HHID2016 INDID2016 $var

foreach x in $var {
replace `x'=1 if `x'>1 & `x'!=0 & `x'!=.
}

merge m:m HHID2016 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2016, replace
merge m:m HHID_panel INDID2016 using "raw/ODRIIS-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

drop HHID2016 INDID2016
gen year=2016
order HHID_panel INDID_panel year

save"NEEMSIS1_indndb", replace





********** NEEMSIS-2
use"raw/NEEMSIS2-occupnew", clear

fre occupation
drop if occupation==0
recode occupation (5=4)

ta occupation, gen(occ_)
rename occ_1 occ_agse
rename occ_2 occ_agca
rename occ_3 occ_naca
rename occ_4 occ_nare
rename occ_5 occ_nase
rename occ_6 occ_nreg

global var occ_agse occ_agca occ_naca occ_nare occ_nase occ_nreg

keep HHID2020 INDID2020 occupationid $var

reshape wide $var, i(HHID2020 INDID2020) j(occupationid)

egen occ_agse=rowtotal(occ_agse1 occ_agse2 occ_agse3 occ_agse4 occ_agse5 occ_agse6)
egen occ_agca=rowtotal(occ_agca1 occ_agca2 occ_agca3 occ_agca4 occ_agca5 occ_agca6)
egen occ_naca=rowtotal(occ_naca1 occ_naca2 occ_naca3 occ_naca4 occ_naca5 occ_naca6)
egen occ_nare=rowtotal(occ_nare1 occ_nare2 occ_nare3 occ_nare4 occ_nare5 occ_nare6)
egen occ_nase=rowtotal(occ_nase1 occ_nase2 occ_nase3 occ_nase4 occ_nase5 occ_nase6)
egen occ_nreg=rowtotal(occ_nreg1 occ_nreg2 occ_nreg3 occ_nreg4 occ_nreg5 occ_nreg6)

keep HHID2020 INDID2020 $var

foreach x in $var {
replace `x'=1 if `x'>1 & `x'!=0 & `x'!=.
}

merge m:m HHID2020 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw/ODRIIS-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

drop HHID2020 INDID2020
gen year=2020
order HHID_panel INDID_panel year

save"NEEMSIS2_indndb", replace




********** Append
use"RUME_indndb", clear

append using "NEEMSIS1_indndb"
append using "NEEMSIS2_indndb"


********** Agri vs non agri
gen occ_agri=0
replace occ_agri=1 if occ_agse==1
replace occ_agri=1 if occ_agca==1

gen occ_nagr=0
replace occ_nagr=1 if occ_naca==1
replace occ_nagr=1 if occ_nare==1
replace occ_nagr=1 if occ_nase==1
replace occ_nagr=1 if occ_nreg==1



********** Casu vs non-casu
gen occ_casu=0
replace occ_casu=1 if occ_agca==1
replace occ_casu=1 if occ_naca==1
replace occ_casu=1 if occ_nreg==1

gen occ_ncas=0
replace occ_casu=1 if occ_agse==1
replace occ_casu=1 if occ_nare==1
replace occ_casu=1 if occ_nase==1


********** SE vs non SE
gen occ_self=0
replace occ_self=1 if occ_agse==1
replace occ_self=1 if occ_nase==1

gen occ_nsel=0
replace occ_self=1 if occ_agca==1
replace occ_self=1 if occ_naca==1
replace occ_self=1 if occ_nare==1
replace occ_self=1 if occ_nreg==1


save "panel_indndb", replace
****************************************
* END








****************************************
* Y-var
****************************************
use"panel_indiv_v2", clear

*** Selection
drop if workingage==0

*** LFP tot
gen lfp=.
replace lfp=1 if dummyworkedpastyear==1
replace lfp=0 if dummyworkedpastyear==0
replace lfp=0 if dummyworkedpastyear==.
ta lfp year, col nofreq

*** LFP male
fre sex
gen lfp_male=.
replace lfp_male=1 if dummyworkedpastyear==1 & sex==1
replace lfp_male=0 if dummyworkedpastyear==0 & sex==1
replace lfp_male=0 if dummyworkedpastyear==. & sex==1

*** LFP female
fre sex
gen lfp_female=. 
replace lfp_female=1 if dummyworkedpastyear==1 & sex==2
replace lfp_female=0 if dummyworkedpastyear==0 & sex==2
replace lfp_female=0 if dummyworkedpastyear==. & sex==2

*** LFP young ILO [15-30[
gen lfp_young=.
replace lfp_young=1 if dummyworkedpastyear==1 & age<=29
replace lfp_young=0 if dummyworkedpastyear==0 & age<=29
replace lfp_young=0 if dummyworkedpastyear==. & age<=29

*** LFP middle ILO [30;60[
gen lfp_middle=.
replace lfp_middle=1 if dummyworkedpastyear==1 & age>=30 & age<60
replace lfp_middle=0 if dummyworkedpastyear==0 & age>=30 & age<60
replace lfp_middle=0 if dummyworkedpastyear==. & age>=30 & age<60

*** LFP old ILO [60;+[
gen lfp_old=.
replace lfp_old=1 if dummyworkedpastyear==1 & age>=60
replace lfp_old=0 if dummyworkedpastyear==0 & age>=60
replace lfp_old=0 if dummyworkedpastyear==. & age>=60

*** LFP young + old
gen lfp_youngold=.
replace lfp_youngold=1 if dummyworkedpastyear==1 & (age<=29 | age>=60)
replace lfp_youngold=0 if dummyworkedpastyear==0 & (age<=29 | age>=60)
replace lfp_youngold=0 if dummyworkedpastyear==. & (age<=29 | age>=60)

ta lfp_youngold


********** Merge new var
merge 1:1 HHID_panel INDID_panel year using "panel_indndb"
drop _merge


********** Clean
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV65" & year==2020
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="KUV67" & year==2020



save"panel_indiv_v3", replace
****************************************
* END

