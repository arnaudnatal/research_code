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
keep HHID2010 village ownland saving
duplicates drop
decode village, gen(vi)
drop village
rename vi villageid

* Drop
duplicates drop
count

* Add debt
merge 1:1 HHID2010 using "raw/RUME-loans_HH", keepusing(imp1_ds_tot_HH)
drop _merge

* Add loanbalance
preserve
use"raw/RUME-loans_mainloans_new", clear
keep HHID2010 loanbalance2 loanlendercat
rename loanbalance2 balance
rename loanlendercat cat
fre cat
recode cat (2=1)
gen bal_info=0
replace bal_info=balance if cat==1
gen bal_form=0
replace bal_form=balance if cat==3
bys HHID2010: egen bal_info_HH=sum(bal_info)
bys HHID2010: egen bal_form_HH=sum(bal_form)
keep HHID2010 bal_info_HH bal_form_HH
duplicates drop
save"_temp", replace
restore
merge 1:1 HHID2010 using "_temp"
drop _merge

* Add assets and expenses
merge 1:1 HHID2010 using "raw/RUME-assets", keepusing(assets_total1000 assets_totalnoland1000 expenses_educ expenses_food expenses_heal assets_nolandnogold)
drop _merge

* Add income
merge 1:1 HHID2010 using "raw/RUME-occup_HH", keepusing(annualincome_HH   incomeagri_HH incomenonagri_HH)
drop _merge

* Add remittances
merge 1:1 HHID2010 using "raw/RUME-transferts_HH", keepusing(remreceived_HH remsent_HH)
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
keep HHID2016 villagearea villageid ownland saving
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

* Add debt
merge 1:1 HHID2016 using "raw/NEEMSIS1-loans_HH", keepusing(imp1_ds_tot_HH)
drop _merge

* Add loanbalance
preserve
use"raw/NEEMSIS1-loans_mainloans_new", clear
keep HHID2016 loanbalance2 lender_cat
rename loanbalance2 balance
rename lender_cat cat
fre cat
recode cat (2=1)
gen bal_info=0
replace bal_info=balance if cat==1
gen bal_form=0
replace bal_form=balance if cat==3
bys HHID2016: egen bal_info_HH=sum(bal_info)
bys HHID2016: egen bal_form_HH=sum(bal_form)
keep HHID2016 bal_info_HH bal_form_HH
duplicates drop
save"_temp", replace
restore
merge 1:1 HHID2016 using "_temp"
drop _merge

* Add assets and expenses
merge 1:1 HHID2016 using "raw/NEEMSIS1-assets", keepusing(assets_total1000 assets_totalnoland1000 expenses_educ expenses_food expenses_heal assets_nolandnogold)
drop _merge

* Add income
merge 1:1 HHID2016 using "raw/NEEMSIS1-occup_HH", keepusing(annualincome_HH   incomeagri_HH incomenonagri_HH)
drop _merge

* Add remittances
merge 1:1 HHID2016 using "raw/NEEMSIS1-transferts_HH", keepusing(remreceived_HH remsent_HH)
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
keep HHID2020 villagearea villageid ownland saving
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

* Add debt
merge 1:1 HHID2020 using "raw/NEEMSIS2-loans_HH", keepusing(imp1_ds_tot_HH)
drop _merge

* Add loanbalance
preserve
use"raw/NEEMSIS2-loans_mainloans_new", clear
keep HHID2020 loanbalance2 lender_cat
rename loanbalance2 balance
rename lender_cat cat
fre cat
recode cat (2=1)
gen bal_info=0
replace bal_info=balance if cat==1
gen bal_form=0
replace bal_form=balance if cat==3
bys HHID2020: egen bal_info_HH=sum(bal_info)
bys HHID2020: egen bal_form_HH=sum(bal_form)
keep HHID2020 bal_info_HH bal_form_HH
duplicates drop
save"_temp", replace
restore
merge 1:1 HHID2020 using "_temp"
drop _merge

* Add assets and expenses
merge 1:1 HHID2020 using "raw/NEEMSIS2-assets", keepusing(assets_total1000 assets_totalnoland1000 assets_ownland expenses_educ expenses_food expenses_heal assets_nolandnogold)
drop _merge

* Add income
merge 1:1 HHID2020 using "raw/NEEMSIS2-occup_HH", keepusing(annualincome_HH   incomeagri_HH incomenonagri_HH )
drop _merge

* Add remittances
merge 1:1 HHID2020 using "raw/NEEMSIS2-transferts_HH", keepusing(remreceived_HH remsent_HH )
drop _merge

* Add gold
merge 1:1 HHID2020 using "raw/NEEMSIS2-gold_HH", keepusing(goldquantity_HH)
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
keep HHID2026 HHID_panel villagearea villageid ownland saving caste
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

* Add debt
merge 1:1 HHID2026 using "raw/NEEMSIS3-loans_HH", keepusing(imp1_ds_tot_HH)
drop _merge

* Add loanbalance
preserve
use"raw/NEEMSIS3-loans_mainloans_new", clear
keep HHID2026 loanbalance2 lender_cat
rename loanbalance2 balance
rename lender_cat cat
fre cat
recode cat (2=1)
gen bal_info=0
replace bal_info=balance if cat==1
gen bal_form=0
replace bal_form=balance if cat==3
bys HHID2026: egen bal_info_HH=sum(bal_info)
bys HHID2026: egen bal_form_HH=sum(bal_form)
keep HHID2026 bal_info_HH bal_form_HH
duplicates drop
save"_temp", replace
restore
merge 1:1 HHID2026 using "_temp"
drop _merge

* Add assets and expenses
merge 1:1 HHID2026 using "raw/NEEMSIS3-assets", keepusing(assets_total1000 assets_totalnoland1000 assets_ownland expenses_educ expenses_food expenses_heal assets_nolandnogold)
drop _merge

* Add income
merge 1:1 HHID2026 using "raw/NEEMSIS3-occup_HH", keepusing(annualincome_HH  incomeagri_HH incomenonagri_HH)
drop _merge

* Add remittances
merge 1:1 HHID2026 using "raw/NEEMSIS3-transferts_HH", keepusing(remreceived_HH remsent_HH)
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

* Caste
merge 1:1 HHID_panel year using "raw/JatisCastePanel"
rename jatisn jatis
rename caste caste2025
rename casten caste
drop _merge
ta caste


*** Quanti 
global quanti saving bal_info_HH bal_form_HH expenses_educ expenses_food expenses_heal assets_ownland assets_nolandnogold assets_total1000 assets_totalnoland1000 incomeagri_HH incomenonagri_HH annualincome_HH remreceived_HH remsent_HH imp1_ds_tot_HH

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


********** Selection
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV67" & year==2020
drop if HHID_panel=="GOV65" & year==2020


******** Vars
*
gen dsr=imp1_ds_tot_HH*100/annualincome_HH


*
recode ownland (.=0)


*
encode HHID_panel, gen(HHFE)
order HHFE, after(HHID_panel)

*
ta villageid
drop village
replace villageid="ELA" if villageid=="ELANTHALMPATTU"
replace villageid="GOV" if villageid=="GOVULAPURAM"
replace villageid="KAR" if villageid=="KARUMBUR"
replace villageid="KOR" if villageid=="KORATTORE"
replace villageid="KUV" if villageid=="KUVAGAM"
replace villageid="MANAM" if villageid=="MANAMTHAVIZHINTHAPUTHUR"
replace villageid="MAN" if villageid=="MANAPAKKAM"
replace villageid="NAT" if villageid=="NATHAM"
replace villageid="ORA" if villageid=="ORAIYURE"
replace villageid="SEM" if villageid=="SEMAKOTTAI"
ta villageid
rename villageid village
encode village, gen(villageid)
drop village


* Dalits
gen dalits=.
replace dalits=1 if caste==1
replace dalits=1 if caste2025==2
replace dalits=0 if caste==2
replace dalits=0 if caste==3
replace dalits=0 if caste2025!=2 & caste2025!=.
label define dalits 1"Dalits" 0"Non-dalits"
label values dalits dalits

ta caste2025 dalits
drop caste caste2025

* Clean
drop area livingarea assets_ownland
recode bal_info_HH bal_form_HH expenses_educ expenses_food expenses_heal assets_nolandnogold assets_total1000 assets_totalnoland1000 goldquantity_HH (.=0)
drop jatis

order HHID_panel HHFE HHID year time villageid dalits
sort HHID_panel year

* Total expenses
egen expenses=rowtotal(expenses_educ expenses_food expenses_heal)

save"panel_evo_v0", replace
****************************************
* END









****************************************
* PCA
****************************************
use"panel_evo_v0", clear


* Std
foreach x in saving bal_info_HH bal_form_HH expenses assets_nolandnogold goldquantity_HH incomeagri_HH incomenonagri_HH remreceived_HH remsent_HH dsr {
egen std_`x'=std(`x')
}

global var saving dsr expenses assets_nolandnogold goldquantity_HH incomeagri_HH incomenonagri_HH remreceived_HH remsent_HH ownland
global varstd std_saving std_dsr std_expenses std_assets_nolandnogold std_goldquantity_HH std_incomeagri_HH std_incomenonagri_HH std_remreceived_HH std_remsent_HH ownland

*
factortest $varstd
minap $varstd 
pca $varstd, comp(4)
predict a1 a2 a3 a4

cluster wardslinkage a1 a2 a3 a4, measure(Euclidean)
cluster dendrogram, cutnumber(50)
cluster gen clust3=groups(3)

ta clust3
tabstat $var, stat(mean p50) by(clust3)

ta clust3 year, col nofreq
ta clust3 dalit, exp cchi2 chi2




****************************************
* END
