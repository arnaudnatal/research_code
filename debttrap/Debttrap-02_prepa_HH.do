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
* 2010
****************************************
use"raw/RUME-HH", clear

* To keep
keep HHID2010 villagename villagearea ownland house housetitle
fre house housetitle
gen livingarea=1

* Clean
decode villagename, gen(villageid)
drop villagename

* Uniq HH
duplicates drop
count

* Family compo
merge 1:1 HHID2010 using "raw/RUME-family", keepusing(nbfemale nbmale agegrp_0_13 agegrp_14_17 agegrp_18_24 agegrp_25_29 agegrp_30_34 agegrp_35_39 agegrp_40_49 agegrp_50_59 agegrp_60_69 agegrp_70_79 agegrp_80_100 HHsize HH_count_child HH_count_adult typeoffamily dummypolygamous head_sex head_age head_dummyworkedpastyear head_working_pop head_mocc_occupation head_edulevel)
drop _merge

* Add debt
merge 1:1 HHID2010 using "raw/RUME-loans_HH", keepusing(nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH)
drop _merge

* Add assets and expenses
merge 1:1 HHID2010 using "raw/RUME-assets", keepusing(assets_total1000 assets_totalnoland1000 assets_ownland expenses_total expenses_food expenses_educ expenses_heal expenses_cere shareexpenses_food shareexpenses_educ shareexpenses_heal shareexpenses_cere)
drop _merge

* Add income
merge 1:1 HHID2010 using "raw/RUME-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH)
drop _merge

* Add remittances
merge 1:1 HHID2010 using "raw/RUME-transferts_HH", keepusing(remreceived_HH remsent_HH remittnet_HH)
drop _merge

* Panel
merge 1:m HHID2010 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename HHID2010 HHID

*Year
gen year=2010
ta villageid livingarea

save"_temp_RUME", replace
****************************************
* END











****************************************
* 2016-17
****************************************
use"raw/NEEMSIS1-HH", clear

* Drop migrants
fre livinghome
drop if livinghome==3
drop if livinghome==4

* To keep
keep HHID2016 villagearea villageid dummydemonetisation dummymarriage ownland house housetitle
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
merge 1:1 HHID2016 using "raw/NEEMSIS1-family", keepusing(nbfemale nbmale agegrp_0_13 agegrp_14_17 agegrp_18_24 agegrp_25_29 agegrp_30_34 agegrp_35_39 agegrp_40_49 agegrp_50_59 agegrp_60_69 agegrp_70_79 agegrp_80_100 HHsize HH_count_child HH_count_adult typeoffamily dummypolygamous head_sex head_age head_dummyworkedpastyear head_working_pop head_mocc_occupation head_edulevel head_maritalstatus)
drop _merge

* Add debt
merge 1:1 HHID2016 using "raw/NEEMSIS1-loans_HH", keepusing(nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH)
drop _merge

* Add assets and expenses
merge 1:1 HHID2016 using "raw/NEEMSIS1-assets", keepusing(assets_total1000 assets_totalnoland1000 assets_ownland expenses_educ expenses_marr expenses_total expenses_food expenses_heal expenses_cere expenses_agri shareexpenses_food shareexpenses_educ shareexpenses_heal shareexpenses_cere)
drop _merge

* Add income
merge 1:1 HHID2016 using "raw/NEEMSIS1-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH)
drop _merge

* Add remittances
merge 1:1 HHID2016 using "raw/NEEMSIS1-transferts_HH", keepusing(remreceived_HH remsent_HH remittnet_HH)
drop _merge

* Panel
merge 1:m HHID2016 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename HHID2016 HHID

* Year
gen year=2016

save"_temp_NEEMSIS1", replace

********** Daily income hh level
use"raw/NEEMSIS1-occupations", clear

gen daysayear=daysamonth*monthsayear
gen dailyincome=annualincome/daysayear

bysort HHID2016: egen daysayear_HH=sum(daysayear)
bysort HHID2016: egen annualincome_HH=sum(annualincome)
bysort HHID2016: egen dailyincome_HH=sum(dailyincome)

keep HHID2016 daysayear_HH annualincome_HH dailyincome_HH
duplicates drop
gen dailyincome2_HH=annualincome_HH/daysayear_HH

clear all

****************************************
* END











****************************************
* 2020-21
****************************************
use"raw/NEEMSIS2-HH", clear


* Drop migrants
fre livinghome
drop if livinghome==3
drop if livinghome==4
drop if dummylefthousehold==1


* To keep
keep HHID2020 villagearea villageid dummymarriage ownland ownland house housetitle
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
merge 1:1 HHID2020 using "raw/NEEMSIS2-family", keepusing(nbfemale nbmale agegrp_0_13 agegrp_14_17 agegrp_18_24 agegrp_25_29 agegrp_30_34 agegrp_35_39 agegrp_40_49 agegrp_50_59 agegrp_60_69 agegrp_70_79 agegrp_80_100 HHsize HH_count_child HH_count_adult typeoffamily dummypolygamous head_sex head_age head_dummyworkedpastyear head_working_pop head_mocc_occupation head_edulevel head_maritalstatus)
drop _merge

* Add debt
merge 1:1 HHID2020 using "raw/NEEMSIS2-loans_HH", keepusing(nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH)
drop _merge

* Add assets and expenses
merge 1:1 HHID2020 using "raw/NEEMSIS2-assets", keepusing(assets_total1000 assets_totalnoland1000 assets_ownland expenses_educ expenses_marr expenses_total expenses_food expenses_heal expenses_cere expenses_agri shareexpenses_food shareexpenses_educ shareexpenses_heal shareexpenses_cere)
drop _merge

* Add income
merge 1:1 HHID2020 using "raw/NEEMSIS2-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH)
drop _merge

* Add remittances
merge 1:1 HHID2020 using "raw/NEEMSIS2-transferts_HH", keepusing(remreceived_HH remsent_HH remittnet_HH)
drop _merge

* Add covid
merge 1:1 HHID2020 using "raw/NEEMSIS2-covid", keepusing(secondlockdownexposure dummysell dummyexposure)
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
* Panel
****************************************
use"_temp_NEEMSIS2", clear

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
rename casten caste
keep if _merge==3
drop _merge
ta caste


*** Quanti 
global quanti loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH assets_ownland assets_total1000 assets_totalnoland1000 annualincome_HH remreceived_HH remsent_HH remittnet_HH expenses_educ expenses_marr expenses_total expenses_food expenses_heal expenses_cere expenses_agri


*** Deflate and round
foreach x in $quanti {
replace `x'=`x'*(100/54) if year==2010
replace `x'=`x'*(100/86) if year==2016
replace `x'=round(`x',1)
}


*** Clean
recode dummyexposure (.=0)
recode head_mocc_occupation (.=0)




********* Consumption
drop expenses_total
drop expenses_marr
drop expenses_agri
drop shareexpenses_food shareexpenses_educ shareexpenses_heal shareexpenses_cere

egen expenses_total=rowtotal(expenses_educ expenses_food expenses_heal expenses_cere)

foreach x in educ food heal cere {
gen shareexpenses_`x'=expenses_`x'/expenses_total
}





********** Poverty



********** Selection
drop if housetitle==.
bysort HHID_panel: gen n=_N
ta n
dis 1146/3
drop n




********* Merge trap
merge 1:1 HHID_panel year using "_temp_trap_HH"
drop _merge


*
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV67" & year==2020
drop if HHID_panel=="GOV65" & year==2020


save"panel_HH_v0", replace
****************************************
* END



do"$dofile\Debttrap-03_prepa_indiv"
