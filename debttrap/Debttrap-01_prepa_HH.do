*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*April 29, 2026
*-----
gl link = "debttrap"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------





****************************************
* 2010
****************************************
use"raw/RUME-HH", clear

* Savings
egen sav=rowtotal(savingsamount1 savingsamount2 savingsamount3)
bysort HHID2010: egen saving=sum(sav)
drop sav

* To keep
keep HHID2010 village ownland house housetitle saving
fre house housetitle 
duplicates drop
decode village, gen(vi)
drop village
rename vi villageid

* Drop
duplicates drop
count

* Family compo
merge 1:1 HHID2010 using "raw/RUME-family", keepusing(nbfemale nbmale HHsize HH_count_child typeoffamily head_sex head_age head_dummyworkedpastyear head_working_pop head_mocc_occupation head_edulevel)
drop _merge

* Add debt
merge 1:1 HHID2010 using "raw/RUME-loans_HH", keepusing(nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH)
drop _merge

* Add loanbalance
preserve
use"raw/RUME-loans_mainloans_new", clear
keep HHID2010 loanbalance2
rename loanbalance2 loanbalance
bys HHID2010: egen loanbalance_HH=sum(loanbalance)
keep HHID2010 loanbalance_HH
duplicates drop
save"_temp", replace
restore
merge 1:1 HHID2010 using "_temp"
drop _merge

* Add assets and expenses
merge 1:1 HHID2010 using "raw/RUME-assets", keepusing(assets_total1000 assets_totalnoland1000 expenses_educ expenses_food expenses_heal assets_nolandnogold)
drop _merge

* Add land
merge 1:1 HHID2010 using "raw/RUME-land"
drop _merge

* Add income
merge 1:1 HHID2010 using "raw/RUME-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH)
drop _merge

* Add remittances
merge 1:1 HHID2010 using "raw/RUME-transferts_HH", keepusing(remreceived_HH remsent_HH remittnet_HH)
drop _merge

* Add gold
merge 1:1 HHID2010 using "raw/RUME-gold_HH", keepusing(goldquantity_HH)
drop _merge

* Panel
merge 1:m HHID2010 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename HHID2010 HHID

* Year
gen year=2010

save"_temp_RUME", replace

****************************************
* END









****************************************
* 2016-2017
****************************************
use"raw/NEEMSIS1-HH", clear

* Drop migrants
fre livinghome
drop if livinghome==3
drop if livinghome==4

* Savings
egen sav=rowtotal(savingsamount1 savingsamount2 savingsamount3 savingsamount4)
bysort HHID2016: egen saving=sum(sav)
drop sav

* To keep
keep HHID2016 villagearea villageid dummydemonetisation dummymarriage ownland house housetitle saving
fre house housetitle
duplicates drop
sort dummymarriage
decode villagearea, gen(vi)
drop villagearea
rename vi area
decode villageid, gen(vi)
drop villageid
rename vi villageid

* Livingarea
merge 1:1 HHID2016 using "raw/NEEMSIS1-villages", keepusing(villagename2016 livingarea)
drop _merge
rename villagename2016 village
ta village livingarea

* Drop
duplicates drop
count

* Family compo
merge 1:1 HHID2016 using "raw/NEEMSIS1-family", keepusing(nbfemale nbmale HHsize HH_count_child typeoffamily head_sex head_age head_dummyworkedpastyear head_working_pop head_mocc_occupation head_edulevel head_maritalstatus)
drop _merge

* Add debt
merge 1:1 HHID2016 using "raw/NEEMSIS1-loans_HH", keepusing(nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH)
drop _merge

* Add loanbalance
preserve
use"raw/NEEMSIS1-loans_mainloans_new", clear
keep HHID2016 loanbalance2
rename loanbalance2 loanbalance
bys HHID2016: egen loanbalance_HH=sum(loanbalance)
keep HHID2016 loanbalance_HH
duplicates drop
save"_temp", replace
restore
merge 1:1 HHID2016 using "_temp"
drop _merge

* Add assets and expenses
merge 1:1 HHID2016 using "raw/NEEMSIS1-assets", keepusing(assets_total1000 assets_totalnoland1000 expenses_educ expenses_food expenses_heal assets_nolandnogold)
drop _merge

* Add land
merge 1:1 HHID2016 using "raw/NEEMSIS1-land"
drop _merge

* Add income
merge 1:1 HHID2016 using "raw/NEEMSIS1-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH)
drop _merge

* Add remittances
merge 1:1 HHID2016 using "raw/NEEMSIS1-transferts_HH", keepusing(remreceived_HH remsent_HH remittnet_HH)
drop _merge

* Add gold
merge 1:1 HHID2016 using "raw/NEEMSIS1-gold_HH", keepusing(goldquantity_HH)
drop _merge

* Panel
merge 1:m HHID2016 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename HHID2016 HHID

* Year
gen year=2016

save"_temp_NEEMSIS1", replace

****************************************
* END











****************************************
* 2020-2021
****************************************
use"raw/NEEMSIS2-HH", clear


* Drop migrants
fre livinghome
drop if livinghome==3
drop if livinghome==4
drop if dummylefthousehold==1

* Savings
egen sav=rowtotal(savingsamount1 savingsamount2 savingsamount3 savingsamount4)
bysort HHID2020: egen saving=sum(sav)
drop sav

* To keep
keep HHID2020 villagearea villageid dummymarriage ownland ownland house housetitle saving
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
merge 1:1 HHID2020 using "raw/NEEMSIS2-villages",keepusing(village_new livingarea)
drop _merge
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
ta village livingarea

* Drop
duplicates drop
count

* Family compo
merge 1:1 HHID2020 using "raw/NEEMSIS2-family", keepusing(nbfemale nbmale HHsize HH_count_child typeoffamily head_sex head_age head_dummyworkedpastyear head_working_pop head_mocc_occupation head_edulevel head_maritalstatus)
drop _merge

* Add debt
merge 1:1 HHID2020 using "raw/NEEMSIS2-loans_HH", keepusing(nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH)
drop _merge

* Add loanbalance
preserve
use"raw/NEEMSIS2-loans_mainloans_new", clear
keep HHID2020 loanbalance2
rename loanbalance2 loanbalance
bys HHID2020: egen loanbalance_HH=sum(loanbalance)
keep HHID2020 loanbalance_HH
duplicates drop
save"_temp", replace
restore
merge 1:1 HHID2020 using "_temp"
drop _merge

* Add assets and expenses
merge 1:1 HHID2020 using "raw/NEEMSIS2-assets", keepusing(assets_total1000 assets_totalnoland1000 assets_ownland expenses_educ expenses_food expenses_heal assets_nolandnogold)
drop _merge

* Add land
merge 1:1 HHID2020 using "raw/NEEMSIS2-land"
drop _merge

* Add income
merge 1:1 HHID2020 using "raw/NEEMSIS2-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH)
drop _merge

* Add remittances
merge 1:1 HHID2020 using "raw/NEEMSIS2-transferts_HH", keepusing(remreceived_HH remsent_HH remittnet_HH)
drop _merge

* Add gold
merge 1:1 HHID2020 using "raw/NEEMSIS2-gold_HH", keepusing(goldquantity_HH)
drop _merge

* Add Covid-19
merge 1:1 HHID2020 using "raw/NEEMSIS2-covid", keepusing(secondlockdownexposure)
drop _merge

* Panel
merge 1:m HHID2020 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename HHID2020 HHID

* Year
gen year=2020

save"_temp_NEEMSIS2", replace
****************************************
* END











****************************************
* 2025-2026
****************************************
use"raw/NEEMSIS3-HH", clear


* Drop migrants
fre livinghome
drop if livinghome==3
drop if livinghome==4
drop if dummylefthousehold==1

* Savings
egen sav=rowtotal(savingsamount1 savingsamount2 savingsamount3)
bysort HHID2026: egen saving=sum(sav)
drop sav

* To keep
keep HHID2026 HHID_panel villagearea villageid dummymarriage ownland ownland house housetitle caste saving
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

* Drop
duplicates drop
count

* Family compo
merge 1:1 HHID2026 using "raw/NEEMSIS3-family", keepusing(nbfemale nbmale HHsize HH_count_child typeoffamily head_sex head_age head_dummyworkedpastyear head_working_pop head_mocc_occupation head_edulevel head_maritalstatus)
drop _merge

* Add debt
merge 1:1 HHID2026 using "raw/NEEMSIS3-loans_HH", keepusing(nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH)
drop _merge

* Add loanbalance
preserve
use"raw/NEEMSIS3-loans_mainloans_new", clear
keep HHID2026 loanbalance2
rename loanbalance2 loanbalance
bys HHID2026: egen loanbalance_HH=sum(loanbalance)
keep HHID2026 loanbalance_HH
duplicates drop
save"_temp", replace
restore
merge 1:1 HHID2026 using "_temp"
drop _merge

* Add assets and expenses
merge 1:1 HHID2026 using "raw/NEEMSIS3-assets", keepusing(assets_total1000 assets_totalnoland1000 assets_ownland expenses_educ expenses_food expenses_heal assets_nolandnogold)
drop _merge

* Add land
merge 1:1 HHID2026 using "raw/NEEMSIS3-land"
drop _merge

* Add income
merge 1:1 HHID2026 using "raw/NEEMSIS3-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH)
drop _merge

* Add remittances
merge 1:1 HHID2026 using "raw/NEEMSIS3-transferts_HH", keepusing(remreceived_HH remsent_HH remittnet_HH)
drop _merge

* Add gold
merge 1:1 HHID2026 using "raw/NEEMSIS3-gold_HH", keepusing(goldquantity_HH)
drop _merge

*
rename HHID2026 HHID

* Year
gen year=2025

save"_temp_NEEMSIS3", replace
****************************************
* END













****************************************
* Panel
****************************************
use"_temp_NEEMSIS2", clear

append using "_temp_NEEMSIS3"
append using "_temp_NEEMSIS1"
append using "_temp_RUME"


fre house
label define house 1"Own house" 2"Joint house" 3"Family property" 4"Rental" 77"Others", modify
label values house house
ta house year, m
*2020
list HHID_panel year if house==., clean noobs

drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV67" & year==2020
drop if HHID_panel=="GOV65" & year==2020


fre housetitle
label values housetitle housetitle
ta housetitle year, m

fre typeoffamily

ta livingarea year

* Dummy panel
bysort HHID_panel: gen n=_N
recode n (1=0) (2=0) (3=1)
rename n dummypanel
ta dummypanel
order HHID_panel HHID year dummypanel
sort HHID_panel year

* Shock
recode dummydemonetisation (.=0)
recode dummymarriage (.=0)
fre secondlockdownexposure
recode secondlockdownexposure (.=1)


* Caste
merge 1:1 HHID_panel year using "raw/JatisCastePanel"
rename jatisn jatis
rename caste caste2025
rename casten caste
drop _merge
ta caste


*** Quanti 
global quanti loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH assets_ownland assets_total1000 assets_totalnoland1000 annualincome_HH remreceived_HH remsent_HH remittnet_HH expenses_educ expenses_food expenses_heal loanbalance_HH saving assets_nolandnogold


*** Deflate and round
foreach x in $quanti {
replace `x'=`x'*(100/40) if year==2010
replace `x'=`x'*(100/63.2) if year==2016
replace `x'=`x'*(100/73.6) if year==2020
replace `x'=round(`x',1)
}

* Time
gen time=0
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
replace time=4 if year==2025

label define time 1"2010" 2"2016-2017" 3"2020-2021" 4"2025-2026"
label values time time
order time, after(year)

*** Clean
recode head_mocc_occupation (.=0)
recode ownland (.=0)
mdesc

********** Selection
drop if housetitle==.

drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV67" & year==2020
drop if HHID_panel=="GOV65" & year==2020

save"panel_HH_v0", replace
****************************************
* END
