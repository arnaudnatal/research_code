*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 8, 2024
*-----
gl link = "inequalities"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\inequalities.do"
*-------------------------








****************************************
* 2010
****************************************
use"raw/RUME-HH", clear

* To keep
keep HHID2010 village villagearea ownland house housetitle
fre house housetitle
gen livingarea=1

* Clean
decode village, gen(villageid)
drop village
rename villageid village
replace village="ELA" if village=="ELANTHALMPATTU"
replace village="GOV" if village=="GOVULAPURAM"
replace village="KOR" if village=="KORATTORE"
replace village="KAR" if village=="KARUMBUR"
replace village="KUV" if village=="KUVAGAM"
replace village="ORA" if village=="ORAIYURE"
replace village="SEM" if village=="SEMAKOTTAI"
replace village="MAN" if village=="MANAPAKKAM"
replace village="MANAM" if village=="MANAMTHAVIZHINTHAPUTHUR"
replace village="NAT" if village=="NATHAM"

decode villagearea, gen(vi)
drop villagearea
rename vi area
gen villageid=village

* Uniq HH
duplicates drop
count

* Family compo
merge 1:1 HHID2010 using "raw/RUME-family"
drop _merge

* Add debt
merge 1:1 HHID2010 using "raw/RUME-loans_HH", keepusing(nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH)
drop _merge

* Add assets and expenses
merge 1:1 HHID2010 using "raw/RUME-assets"
drop _merge

* Add income
merge 1:1 HHID2010 using "raw/RUME-occup_HH"
drop _merge

* Add remittances
merge 1:1 HHID2010 using "raw/RUME-transferts_HH"
drop _merge

* Gold
merge 1:1 HHID2010 using "raw/RUME-gold_HH"
drop _merge
drop goldamount_HH goldamountpledge_HH

* Panel
merge 1:m HHID2010 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename HHID2010 HHID

*Year
gen year=2010
ta village livingarea


* Gold not pledge
gen test=assets_gold-(goldquantity_HH*2000)
ta test
drop test
gen goldreadyamount=(goldquantity_HH-goldquantitypledge_HH)*2000
tabstat assets_gold goldreadyamount, stat(n mean cv q)


save"temp_RUME", replace
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
merge 1:1 HHID2016 using "raw/NEEMSIS1-family"
drop _merge

* Add debt
merge 1:1 HHID2016 using "raw/NEEMSIS1-loans_HH", keepusing(nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH)
drop _merge

* Add assets and expenses
merge 1:1 HHID2016 using "raw/NEEMSIS1-assets"
drop _merge

* Add income
merge 1:1 HHID2016 using "raw/NEEMSIS1-occup_HH"
drop _merge

* Add remittances
merge 1:1 HHID2016 using "raw/NEEMSIS1-transferts_HH"
drop _merge pension_HH transferts_HH

* Gold
merge 1:1 HHID2016 using "raw/NEEMSIS1-gold_HH"
drop _merge
drop goldamount_HH goldamountpledge_HH

* Panel
merge 1:m HHID2016 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename HHID2016 HHID

* Year
gen year=2016

* Gold not pledge
gen test=assets_gold-(goldquantity_HH*2700)
ta test
drop test
gen goldreadyamount=(goldquantity_HH-goldquantitypledge_HH)*2700
tabstat assets_gold goldreadyamount, stat(n mean cv q)


save"temp_NEEMSIS1", replace
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
fre house
preserve
keep if house==""
ta dummyeverland2010
ta dummyeverhadland
restore

* To keep
keep HHID2020 villagearea villageid dummymarriage ownland ownland house housetitle compensation compensationamount
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
merge 1:1 HHID2020 using "raw/NEEMSIS2-family"
drop _merge


* Add debt
merge 1:1 HHID2020 using "raw/NEEMSIS2-loans_HH", keepusing(nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH)
drop _merge

* Add assets and expenses
merge 1:1 HHID2020 using "raw/NEEMSIS2-assets"
drop _merge

* Add income
merge 1:1 HHID2020 using "raw/NEEMSIS2-occup_HH"
drop _merge

* Add remittances
merge 1:1 HHID2020 using "raw/NEEMSIS2-transferts_HH"
drop _merge pension_HH transferts_HH

* Add gold
merge 1:1 HHID2020 using "raw/NEEMSIS2-gold_HH"
drop _merge
drop goldamount_HH goldamountpledge_HH

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

* Gold not pledge
gen test=assets_gold-(goldquantity_HH*2700)
ta test
drop test
gen goldreadyamount=(goldquantity_HH-goldquantitypledge_HH)*2700
tabstat assets_gold goldreadyamount, stat(n mean cv q)


save"temp_NEEMSIS2", replace
****************************************
* END











****************************************
* Panel
****************************************
use"temp_NEEMSIS2", clear

append using "temp_NEEMSIS1"
append using "temp_RUME"


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
*tostring year, replace
merge 1:1 HHID_panel year using "raw/Panel-Caste_HH_long", keepusing(caste)
keep if _merge==3
drop _merge
ta caste
label define castecode 1"Dalits" 2"Middle castes" 3"Upper castes"
label values caste castecode
fre caste


*** Quanti 
global quanti1 head_mocc_annualincome head_annualincome 
global quanti2 loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH
global quanti3 expenses_total expenses_food expenses_educ expenses_heal expenses_cere expenses_agri expenses_marr
global quanti4 assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland assets_totalnoprop assets_total1000 assets_totalnoland1000 assets_totalnoprop1000
global quanti5 incomeagri_HH incomenonagri_HH annualincome_HH incagrise_HH incagricasual_HH incnonagricasual_HH incnonagriregnonquali_HH incnonagriregquali_HH incnonagrise_HH incnrega_HH
global quanti6 remreceived_HH remsent_HH remittnet_HH
global quant7 goldreadyamount
global quanti $quanti1 $quanti2 $quanti3 $quanti4 $quanti5 $quanti6 $quanti7


gen annualincome_HH_backup=annualincome_HH

*** Deflate and round
foreach x in $quanti {
replace `x'=`x'*(100/158) if year==2016
replace `x'=`x'*(100/184) if year==2020
replace `x'=round(`x',1)
}


*** Clean
/*
foreach x in $quanti1 $quanti3 $quanti4 $quanti5 $quanti6  {
recode `x' (.=0)
}
*/

recode dummyexposure (.=0)
recode head_mocc_occupation (.=0)
recode head_nboccupation (.=0)



********** Selection
drop if housetitle==.
bysort HHID_panel: gen n=_N
ta n
dis 1146/3
drop n


save"panel_v0", replace
****************************************
* END
