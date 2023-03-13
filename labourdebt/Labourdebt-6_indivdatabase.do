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






*** IGAP tot
*Income generating activity participation
gen igap=.
replace igap=1 if lfp==1 & employed==1
replace igap=0 if lfp==1 & employed==0
replace igap=0 if lfp==1 & employed==.


*** IGAP male
gen igap_male=.
replace igap_male=1 if lfp==1 & employed==1 & sex==1
replace igap_male=0 if lfp==1 & employed==0 & sex==1
replace igap_male=0 if lfp==1 & employed==. & sex==1


*** IGAP female
gen igap_female=.
replace igap_female=1 if lfp==1 & employed==1 & sex==2
replace igap_female=0 if lfp==1 & employed==0 & sex==2
replace igap_female=0 if lfp==1 & employed==. & sex==2


*** IGAP young + old
gen igap_youngold=.
replace igap_youngold=1 if lfp==1 & employed==1 & (age<=29 | age>=60)
replace igap_youngold=0 if lfp==1 & employed==0 & (age<=29 | age>=60)
replace igap_youngold=0 if lfp==1 & employed==. & (age<=29 | age>=60)

ta igap_youngold





*** Nb occupations
ta nboccupation_indiv lfp, m

gen nbo=.
replace nbo=nboccupation_indiv if lfp==1

gen nbo_male=.
replace nbo_male=nboccupation_indiv if lfp_male==1

gen nbo_female=.
replace nbo_female=nboccupation_indiv if lfp_female==1





********** Desc
tab1 lfp*
tab1 igap*
tab1 nbo*



save"panel_indiv_v3", replace

****************************************
* END

