*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*January 21, 2025
*-----
gl link = "debtdiversity"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------

cd"D:\Ongoing_Diversity\Analysis"





****************************************
* 2010
****************************************
use"raw/RUME-HH", clear

* Saving
preserve
keep HHID2010 savingsamount1 savingsamount2 savingsamount3
forvalues i=1/3 {
bysort HHID2010: egen sam`i'=sum(savingsamount`i')
}
egen savingamount=rowtotal(sam1 sam2 sam3)
keep HHID2010 savingamount
duplicates drop
save"R_sav", replace
restore

* To keep
keep HHID2010 villagename villagearea ownland house housetitle dummysavingaccount
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
merge 1:1 HHID2010 using "raw/RUME-loans_HH", keepusing(nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH dumHH_givencat_econ dumHH_givencat_curr dumHH_givencat_huma dumHH_givencat_soci dumHH_givencat_hous dumHH_lendercat_form)
drop _merge

* Add assets and expenses
merge 1:1 HHID2010 using "raw/RUME-assets", keepusing(assets_total1000 assets_totalnoland1000 assets_ownland assets_gold)
drop _merge

* Add gold quantity
merge 1:1 HHID2010 using "raw/RUME-gold_HH", keepusing(goldquantity_HH)
drop _merge

* Add saving
merge 1:1 HHID2010 using "R_sav"
drop _merge

* Add income
merge 1:1 HHID2010 using "raw/RUME-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH incagrise_HH incagricasual_HH incnonagricasual_HH incnonagriregnonquali_HH incnonagriregquali_HH incnonagrise_HH incnrega_HH shareincomeagri_HH shareincomenonagri_HH)
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

* Saving
preserve
keep HHID2016 savingsamount1 savingsamount2 savingsamount3 savingsamount4
forvalues i=1/4 {
bysort HHID2016: egen sam`i'=sum(savingsamount`i')
}
egen savingamount=rowtotal(sam1 sam2 sam3 sam4)
keep HHID2016 savingamount
duplicates drop
save"N1_sav", replace
restore

* To keep
keep HHID2016 villagearea villageid dummydemonetisation dummymarriage ownland house housetitle dummysavingaccount
fre house housetitle
duplicates drop
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
merge 1:1 HHID2016 using "raw/NEEMSIS1-loans_HH", keepusing(nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH dumHH_givencat_econ dumHH_givencat_curr dumHH_givencat_huma dumHH_givencat_soci dumHH_givencat_hous dumHH_lendercat_form)
drop _merge

* Add assets and expenses
merge 1:1 HHID2016 using "raw/NEEMSIS1-assets", keepusing(assets_total1000 assets_totalnoland1000 assets_ownland assets_gold)
drop _merge

* Add gold quantity
merge 1:1 HHID2016 using "raw/NEEMSIS1-gold_HH", keepusing(goldquantity_HH)
drop _merge

* Add saving
merge 1:1 HHID2016 using "N1_sav"
drop _merge

* Add income
merge 1:1 HHID2016 using "raw/NEEMSIS1-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH incagrise_HH incagricasual_HH incnonagricasual_HH incnonagriregnonquali_HH incnonagriregquali_HH incnonagrise_HH incnrega_HH shareincomeagri_HH shareincomenonagri_HH)
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

* Saving
preserve
keep HHID2020 savingsamount1 savingsamount2 savingsamount3 savingsamount4
forvalues i=1/4 {
bysort HHID2020: egen sam`i'=sum(savingsamount`i')
}
egen savingamount=rowtotal(sam1 sam2 sam3 sam4)
keep HHID2020 savingamount
duplicates drop
save"N2_sav", replace
restore

* To keep
keep HHID2020 villagearea villageid dummymarriage ownland ownland house housetitle dummysavingaccount
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
merge 1:1 HHID2020 using "raw/NEEMSIS2-loans_HH", keepusing(nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH dumHH_givencat_econ dumHH_givencat_curr dumHH_givencat_huma dumHH_givencat_soci dumHH_givencat_hous dumHH_lendercat_form)
drop _merge

* Add assets and expenses
merge 1:1 HHID2020 using "raw/NEEMSIS2-assets", keepusing(assets_total1000 assets_totalnoland1000 assets_ownland assets_gold)
drop _merge

* Add gold quantity
merge 1:1 HHID2020 using "raw/NEEMSIS2-gold_HH", keepusing(goldquantity_HH)
drop _merge

* Add saving
merge 1:1 HHID2020 using "N2_sav"
drop _merge

* Add income
merge 1:1 HHID2020 using "raw/NEEMSIS2-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH incagrise_HH incagricasual_HH incnonagricasual_HH incnonagriregnonquali_HH incnonagriregquali_HH incnonagrise_HH incnrega_HH shareincomeagri_HH shareincomenonagri_HH)
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

* Caste
merge 1:1 HHID_panel year using "raw/JatisCastePanel"
rename jatisn jatis
rename casten caste
keep if _merge==3
drop _merge
ta caste


*** Quanti 
global quanti loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH assets_ownland assets_total1000 assets_totalnoland1000 annualincome_HH remreceived_HH remsent_HH remittnet_HH savingamount incagrise_HH incagricasual_HH incnonagricasual_HH incnonagriregnonquali_HH incnonagriregquali_HH incnonagrise_HH incnrega_HH

gen annualincome_HH_nondef=annualincome_HH

*** Deflate and round
foreach x in $quanti {
replace `x'=`x'*(100/54) if year==2010
replace `x'=`x'*(100/86) if year==2016
replace `x'=round(`x',1)
}


*** Clean
recode dummyexposure (.=0)
recode head_mocc_occupation (.=0)

********** Selection
drop if housetitle==.
bysort HHID_panel: gen n=_N
ta n
dis 1146/3
drop n

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















****************************************
* MDI
****************************************
use"panel_HH_v0", replace


***** DSR: 1 if more than 0.3
gen dsr=imp1_ds_tot_HH/annualincome_HH
gen d_dsr=0
replace d_dsr=1 if dsr>.3
ta d_dsr year, col

***** ISR: 1 if more than 0.3
gen isr=imp1_is_tot_HH/annualincome_HH
gen d_isr=0
replace d_isr=1 if isr>.3
ta d_isr year, col

***** DAR: 1 if more than 0.3
gen dar=loanamount_HH/(assets_total1000*1000)
gen d_dar=0
replace d_dar=1 if dar>.3

***** Current: 1 if debt for current expenses
recode dumHH_givencat_curr (.=0)
fre dumHH_givencat_curr
rename dumHH_givencat_curr d_curr

***** Non-access to formal: 1 if non-access to formal debt
recode dumHH_lendercat_form (.=0)
fre dumHH_lendercat_form
recode dumHH_lendercat_form (1=0) (0=1)
rename dumHH_lendercat_form d_form
ta d_form year, col

***** Land: 1 if no land
fre assets_ownland
recode ownland (.=0)
recode ownland (1=0) (0=1)
rename ownland d_land

***** House title: 1 if no house title
fre housetitle
recode housetitle (.=0)
recode housetitle (1=0) (0=1)
rename housetitle d_htitle

***** Gold: 1 if less than 20 gr of gold
tabstat goldquantity_HH, stat(n mean min p1 p5 p10 q) by(year)
ta goldquantity_HH
gen d_gold=0
replace d_gold=1 if goldquantity_HH<=20
ta d_gold year, col

***** Saving account: 1 if no saving
ta dummysavingaccount
ta savingamount
gen d_sav=0
replace d_sav=1 if savingamount==0
ta d_sav year, col

***** Poverty (2.15 USD 2017 PPP): 1 if below de PL
replace annualincome_HH_nondef=annualincome_HH_nondef*(100/62.81) if year==2010
replace annualincome_HH_nondef=annualincome_HH_nondef*(100/114.95) if year==2020
replace annualincome_HH_nondef=round(annualincome_HH_nondef,1)
gen dailyincome_pc=(annualincome_HH_nondef/365)/HHsize
gen dailyuspppdincome_pc=dailyincome_pc/20.65
gen d_poor=0
replace d_poor=1 if dailyuspppdincome_pc<2.15
ta d_poor year, col nofreq

***** Casual income: 1 if majority of HH income is from casual activities
gen inc_casu=incagricasual_HH+incnonagricasual_HH+incnrega_HH
gen inc_ncasu=incagrise_HH+incnonagriregnonquali_HH+incnonagriregquali_HH+incnonagrise_HH
gen d_casu=0
replace d_casu=1 if inc_casu>inc_ncasu
ta d_casu year, col

***** Diversification: 1 if no diversification (more than 90% of income is from agri)
ta shareincomeagri_HH
gen d_div=0
replace d_div=1 if shareincomeagri_HH>.9
ta d_div year

***** Remittances: 1 if send more than received
gen d_rem=0
replace d_rem=1 if remittnet_HH<0


***** Verification
cls
foreach x in ///
d_dsr d_isr d_dar d_curr d_form ///
d_land d_htitle d_gold d_sav ///
d_poor d_div d_casu d_rem {
ta `x' year, col
}


********** Deprivation indicator
***** 50-25-25
gen dps1= ///
 (0.125*d_dsr) ///
+(0.125*d_isr) ///
+(0.125*d_dar) ///
+(0.125*d_curr) ///
+(0.0833*d_land) ///
+(0.0833*d_gold) ///
+(0.0833*d_sav) ///
+(0.0833*d_poor) ///
+(0.0833*d_casu) ///
+(0.0833*d_rem)

***** 33-33-33
gen dps2= ///
 (0.0825*d_dsr) ///
+(0.0825*d_isr) ///
+(0.0825*d_dar) ///
+(0.0825*d_curr) ///
+(0.11*d_land) ///
+(0.11*d_gold) ///
+(0.11*d_sav) ///
+(0.11*d_poor) ///
+(0.11*d_casu) ///
+(0.11*d_rem)


***** Stat
tabstat dps1 dps2, stat(mean p50) by(year)
tabstat dps1 dps2, stat(mean p50) by(dummydemonetisation)
tabstat dps1 dps2, stat(mean p50) by(secondlockdownexposure)
corr dps1 dps2
spearman dps1 dps2
ta dps1
ta dps2

***** Obj: vuln index for debt so i prefer the first one
drop dps1 dps2

gen dps= ///
 (0.13*d_dsr) ///
+(0.13*d_isr) ///
+(0.13*d_dar) ///
+(0.13*d_curr) ///
+(0.08*d_land) ///
+(0.08*d_gold) ///
+(0.08*d_sav) ///
+(0.08*d_poor) ///
+(0.08*d_casu) ///
+(0.08*d_rem)

*
order d_dsr d_isr d_dar d_curr d_land d_gold d_sav d_poor d_casu d_rem, before(dps)
drop annualincome_HH_nondef dailyincome_pc dailyuspppdincome_pc inc_casu inc_ncasu d_div d_form d_htitle agegrp_0_13 agegrp_14_17 agegrp_18_24 agegrp_25_29 agegrp_30_34 agegrp_35_39 agegrp_40_49 agegrp_50_59 agegrp_60_69 agegrp_70_79 agegrp_80_100 dummypolygamous dumHH_givencat_econ dumHH_givencat_huma dumHH_givencat_soci dumHH_givencat_hous savingamount incagrise_HH incagricasual_HH incnonagricasual_HH incnonagriregnonquali_HH incnonagriregquali_HH incnonagrise_HH incnrega_HH remreceived_HH remsent_HH remittnet_HH dummysell dummysavingaccount

* Jatis
rename jatis jatis_str
encode jatis_str, gen(jatis)
order jatis, after(jatis_str)

* HHID
rename HHID HHIDyear
encode HHID_panel, gen(HHID)
order HHID, after(HHIDyear)

* Time
gen time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
label define time 1"2010" 2"2016-2017" 3"2020-2021"
label values time time
order time, before(year)

* Village
drop village
rename villageid village
encode village, gen(villageid)

* Type of family
encode typeoffamily, gen(family)
drop typeoffamily

save"panel_HH_v1", replace
****************************************
* END
