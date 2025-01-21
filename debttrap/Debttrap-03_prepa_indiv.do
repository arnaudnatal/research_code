*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*January 21, 2025
*-----
gl link = "debttrap"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------









****************************************
* 2016-17
****************************************
use"raw/NEEMSIS1-HH", clear

* To keep
keep HHID2016 INDID2016 villagearea villageid dummydemonetisation dummymarriage ownland house housetitle name sex age relationshiptohead livinghome maritalstatus
fre house housetitle
duplicates drop
decode villagearea, gen(vi)
drop villagearea
rename vi area
decode villageid, gen(vi)
drop villageid
rename vi villageid

* Livingarea
merge m:1 HHID2016 using "raw/NEEMSIS1-villages", keepusing(villagename2016 livingarea)
drop _merge
rename villagename2016 village
ta village livingarea

* Education
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-education", keepusing(edulevel)
drop _merge

* Occupation
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-occup_indiv", keepusing(dummyworkedpastyear working_pop mainocc_occupation_indiv annualincome_indiv nboccupation_indiv hoursayear_indiv)
drop _merge

* Debt
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-loans_indiv", keepusing(nbloans_indiv loanamount_indiv imp1_ds_tot_indiv imp1_is_tot_indiv)
drop _merge

* Transferts
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-transferts_indiv", keepusing(remreceived_indiv remsent_indiv remittnet_indiv)
drop _merge

* Panel HH
merge m:m HHID2016 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

* Panel indiv
tostring INDID2016, replace
merge 1:m HHID2016 INDID2016 using"raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Rename
rename HHID2016 HHID
rename INDID2016 INDID
order HHID_panel INDID_panel

*Year
gen year=2016


save"_temp_NEEMSIS1indiv", replace
****************************************
* END











****************************************
* 2020-21
****************************************
use"raw/NEEMSIS2-HH", clear

* Drop migrants
drop if dummylefthousehold==1
fre house

* To keep
keep HHID2020 INDID2020 villagearea villageid village_new dummymarriage ownland ownland house housetitle name sex age relationshiptohead livinghome maritalstatus
fre house housetitle
destring house housetitle, replace
destring ownland, replace
duplicates drop
decode villagearea, gen(vi)
drop villagearea
rename vi area
decode villageid, gen(vi)
drop villageid
rename vi villageid


* Livingarea
rename village_new village
replace village="ELA" if village=="Elanthalmpattu"
replace village="GOV" if village=="Govulapuram"
replace village="KOR" if village=="Korattore"
replace village="KAR" if village=="Karumbur"
replace village="KUV" if village=="Kuvagam"
replace village="ORA" if village=="Oraiyure"
replace village="SEM" if village=="Semakottai"
replace village="MAN" if village=="Manapakkam"
replace village="MANAM" if village=="Manamthavizhinthaputhur"
replace village="NAT" if village=="Natham"
ta village area

* Education
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-education", keepusing(edulevel)
drop _merge

* Occupation
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-occup_indiv", keepusing(dummyworkedpastyear working_pop mainocc_occupation_indiv annualincome_indiv nboccupation_indiv hoursayear_indiv)
drop _merge

* Debt
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-loans_indiv", keepusing(nbloans_indiv loanamount_indiv imp1_ds_tot_indiv imp1_is_tot_indiv)
drop _merge

* Transferts
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-transferts_indiv", keepusing(remreceived_indiv remsent_indiv remittnet_indiv)
drop _merge

* Panel HH
merge m:m HHID2020 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

* Panel indiv
tostring INDID2020, replace
merge 1:m HHID2020 INDID2020 using"raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Rename
rename HHID2020 HHID
rename INDID2020 INDID
order HHID_panel INDID_panel

*Year
gen year=2020

save"_temp_NEEMSIS2indiv", replace
****************************************
* END











****************************************
* Panel
****************************************
use"_temp_NEEMSIS2indiv", clear

***
append using "_temp_NEEMSIS1indiv"

*
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV67" & year==2020
drop if HHID_panel=="GOV65" & year==2020


*** Dummy panel HH
bysort HHID_panel: gen n=_N
recode n (1=0) (2=0) (3=1)
rename n dummypanel_HH

*** Dummy panel indiv
bysort HHID_panel INDID_panel: gen n=_N
recode n (1=0) (2=0) (3=1)
rename n dummypanel_indiv
order HHID_panel HHID dummypanel_HH INDID_panel INDID dummypanel_indiv year  
sort HHID_panel INDID_panel year

*** Shock
recode dummydemonetisation (.=0)
recode dummymarriage (.=0)

* Time
gen time=0
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020

label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time


*** Quanti 
global quanti annualincome_indiv loanamount_indiv imp1_ds_tot_indiv imp1_is_tot_indiv remreceived_indiv remsent_indiv remittnet_indiv

*** Deflate and round
foreach x in $quanti {
replace `x'=`x'*(100/86) if year==2016
replace `x'=round(`x',1)
}


********** Merge trap
merge 1:1 HHID_panel INDID_panel year using "_temp_trap_indiv"
drop _merge


********** Merge HH charact
merge m:1 HHID_panel year using "panel_HH_v0"
drop if _merge==2
drop _merge

*** Clean
recode dummyexposure (.=0)
recode head_mocc_occupation (.=0)

/*
*** Caste
merge m:1 HHID_panel year using "raw/JatisCastePanel"
rename jatisn jatis
rename casten caste
keep if _merge==3
drop _merge
ta caste
*/

save"panel_indiv_v0", replace
****************************************
* END
