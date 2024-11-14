*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 8, 2024
*-----
gl link = "inequalities"
*Prepa HH
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\inequalities.do"
*-------------------------





****************************************
* 2010
****************************************
use"raw/RUME-HH", clear

* Savings
sort HHID2010 INDID2010
egen savings_indiv=rowtotal(savingsamount1 savingsamount2 savingsamount3)
bysort HHID2010: egen savings_HH=sum(savings_indiv)

* To keep
keep HHID2010 village villagearea ownland house housetitle savings_HH
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

* Savings
egen savings_indiv=rowtotal(savingsamount1 savingsamount2 savingsamount3 savingsamount4)
bysort HHID2016: egen savings_HH=sum(savings_indiv)

* To keep
keep HHID2016 villagearea villageid dummydemonetisation dummymarriage ownland house housetitle savings_HH
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
drop _merge transferts_HH

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

* Drop duplicates
drop if HHID2020=="uuid:ff95bdde-6012-4cf6-b7e8-be866fbaa68b"

* Savings
egen savings_indiv=rowtotal(savingsamount1 savingsamount2 savingsamount3 savingsamount4)
bysort HHID2020: egen savings_HH=sum(savings_indiv)

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
keep HHID2020 villagearea villageid dummymarriage ownland ownland house housetitle compensation compensationamount savings_HH
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
drop _merge transferts_HH

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

* GPS
merge 1:1 HHID_panel using "raw/NEEMSIS2-GPS", keepusing(jatisdetails jatis)
keep if _merge==3
drop _merge

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

* Append
append using "temp_NEEMSIS1"
append using "temp_RUME"


*
drop if HHID_panel=="KUV65"

* Housing pour selection
fre house
label define house 1"Own house" 2"Joint house" 3"Family property" 4"Rental" 77"Others", modify
label values house house
ta house year, m
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

* Quanti defalte and round
global quanti1 head_mocc_annualincome head_annualincome 
global quanti2 loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH
global quanti3 expenses_total expenses_food expenses_educ expenses_heal expenses_cere expenses_agri expenses_marr
global quanti4 assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland assets_totalnoprop assets_total1000 assets_totalnoland1000 assets_totalnoprop1000 annualincome_HH
global quanti5 remreceived_HH remsent_HH remittnet_HH pension_HH
global quanti6 goldreadyamount incomeagri_HH incomenonagri_HH incagrise_HH incagricasual_HH incnonagricasual_HH incnonagriregnonquali_HH incnonagriregquali_HH incnonagrise_HH incnrega_HH
global quanti $quanti1 $quanti2 $quanti3 $quanti4 $quanti5 $quanti6

foreach x in $quanti {
replace `x'=`x'*(100/54) if year==2010
replace `x'=`x'*(100/86) if year==2016
replace `x'=round(`x',1)
}

* Recode and replace
recode dummyexposure (.=0)
recode head_mocc_occupation (.=0)
recode head_nboccupation (.=0)
replace loanamount_HH=0 if loanamount_HH==.


* Selection
drop if housetitle==.
bysort HHID_panel: gen n=_N
ta n
dis 1146/3
drop n


save"panel_v0", replace
****************************************
* END



















****************************************
* Construction variables
****************************************
use"panel_v0", clear

********** Debt
* DSR
gen dsr=imp1_ds_tot_HH/annualincome_HH
replace dsr=0 if dsr==.

* ISR
gen isr=imp1_is_tot_HH/annualincome_HH
replace isr=0 if isr==.
replace dsr=dsr*100
replace isr=isr*100

* DAR
gen dar=loanamount_HH/assets_totalnoprop
replace dar=0 if dar==.


********** Family
* HH
encode HHID_panel, gen(panelvar)

* Village
encode villageid, gen(vill)
fre village villageid vill
ta vill, gen(village_)

* Stem
gen stem=.
replace stem=0 if typeoffamily=="nuclear"
replace stem=1 if typeoffamily=="stem"
replace stem=1 if typeoffamily=="joint-stem"
label define stem 0"Nuclear" 1"Stem"
label values stem stem
ta stem typeoffamily

* Head sex
fre head_sex
gen head_female=.
replace head_female=0 if head_sex==1
replace head_female=1 if head_sex==2
ta head_sex head_female
label define head_female 0"Male" 1"Female"
label values head_female head_female

* Head occupation
fre head_mocc_occupation
recode head_mocc_occupation (5=4)
ta head_mocc_occupation, gen(head_occ)

* Head edulevel
fre head_edulevel
recode head_edulevel (3=2) (4=2) (5=2)
ta head_edulevel, gen(head_educ)

* Head age
tabstat head_age, stat(n mean sd q)
gen head_agesq=head_age*head_age
gen head_agecat=0
replace head_agecat=1 if head_age<40
replace head_agecat=2 if head_age>=40 & head_age<50
replace head_agecat=3 if head_age>=50 & head_age<60
replace head_agecat=4 if head_age>=60
label define head_agecat 1"Less 40" 2"40-50" 3"50-60" 4"60 or more"
label values head_agecat head_agecat
ta head_agecat, gen(head_agecat)

* Head maritalstatus
fre head_maritalstatus
gen head_nonmarried=head_maritalstatus
recode head_nonmarried (1=0) (2=1) (3=1) (4=1) (.=0)
label define head_nonmarried 0"Married" 1"Non-married"
label values head_nonmarried head_nonmarried
fre head_nonmarried


********** Assets
* Clean
drop assets_total assets_totalnoland assets_totalnoprop assets_total1000 assets_totalnoland1000 assets_totalnoprop1000 shareassets_housevalue shareassets_livestock shareassets_goods shareassets_ownland shareassets_gold assets_sizeownland

* Rename
rename savings_HH assets_savings
rename assets_ownland assets_land
rename assets_housevalue assets_house

* Recode and dummies
global assets house livestock goods land gold savings
foreach x in $assets {
recode assets_`x' (.=0)
replace assets_`x'=assets_`x'/1000
gen dum_`x'=.
replace dum_`x'=0 if assets_`x'==0
replace dum_`x'=1 if assets_`x'>0
}

* Total
egen assets_total=rowtotal(assets_house assets_livestock assets_goods assets_land assets_gold assets_savings)

* Total without land
egen assets_total2=rowtotal(assets_house assets_livestock assets_goods assets_gold assets_savings)

order assets_total assets_total2 assets_house assets_livestock assets_goods assets_land assets_gold assets_savings dum_house dum_livestock dum_goods dum_land dum_gold dum_savings, after(shareexpenses_cere)

* Share
foreach x in house livestock goods land gold savings {
g s_`x'=assets_`x'*100/assets_total
}

* Share without land
foreach x in house livestock goods gold savings {
g s2_`x'=assets_`x'*100/assets_total2
}

* Dummy ownland
recode ownland (.=0)
ta ownland year, col nofreq
label define ownland 0"Own land: No" 1"Own land: Yes"
label values ownland ownland

* House
ta house, gen(house_)





********** Others
* Time
gen time=0
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time

* Std
foreach x in loanamount_HH annualincome_HH assets_total imp1_ds_tot_HH imp1_is_tot_HH dsr isr dar expenses_total remreceived_HH remsent_HH remittnet_HH assets_gold goldquantity_HH goldreadyamount nbloans_HH {
egen `x'_std=std(`x')
}

* Lockdown
recode secondlockdownexposure dummysell(.=1)
ta secondlockdownexposure, gen(lock_)
label var lock_1 "Sec. lockdown: Before"
label var lock_2 "Sec. lockdown: During"
label var lock_3 "Sec. lockdown: After"
label var dummysell "Sell assets to face lockdown: Yes"
label var dummydemonetisation "Demonetisation: Yes"

* Time var
bysort HHID_panel: gen nobs=_N
gen nobs1=nobs==1
gen nobs2=nobs==2
gen nobs3=nobs==3
gen year2010=year==2010
gen year2016=year==2016
gen year2020=year==2020
foreach x in year2010 year2016 year2020 {
bysort HHID_panel: egen mean_`x'=mean(`x')
}

* Jatis and caste
drop jatisdetails jatis
merge 1:1 HHID_panel year using "raw/JatisCastePanel"
keep if _merge==3
drop _merge
rename casten caste
rename jatisn jatis
encode jatis, gen(jatis_code)
drop jatis
rename jatis_code jatis

gen dalits=.
replace dalits=1 if caste==1
replace dalits=0 if caste==2
replace dalits=0 if caste==3

ta caste, gen(caste_)
label var caste_1 "Caste: Dalits"
label var caste_2 "Caste: Middle castes"
label var caste_3 "Caste: Upper castes"

* Jatis by prestige en faisant en deux fois pour ne pas me perdre
fre jatis
gen jatis2=jatis
recode jatis2 ///
(1=1) (11=2) ///
(7=3) (9=5) (12=6) (4=8) (2=9) ///
(6=11) (3=12) (8=13) (5=14) (10=15)

label define jatis2 ///
2"SC" 1"Arunthathiyar" ///
9"Asarai" 8"Kulalar" 7"Gramani" 6"Vanniyar" 5"Nattar" 4"Navithar" 3"Muslims" ///
15"Rediyar" 14"Marwari" 13"Naidu" 12"Chettiyar" 11"Mudaliar" 10"Yathavar"
label values jatis2 jatis2

ta jatis jatis2

drop jatis
rename jatis2 jatis
order jatis, after(caste)


* 2e etape
gen jatis3=jatis
fre jatis3
recode jatis3 (5=4) (6=5) (8=6) (9=7) (11=8) (12=9) (13=10) (14=11) (15=12)
label define jatis3 ///
2"SC" 1"Arunthathiyar" ///
7"Asarai" 6"Kulalar" 5"Vanniyar" 4"Nattar" 3"Muslims" ///
12"Rediyar" 11"Marwari" 10"Naidu" 9"Chettiyar" 8"Mudaliar"
label values jatis3 jatis3

ta jatis3 jatis
drop jatis
rename jatis3 jatis
order jatis, after(caste)



save"panel_v1", replace
****************************************
* END


















****************************************
* Label
****************************************
use"panel_v1", clear

* Label
label var HHsize "Household size"
label var HH_count_child "Number of childrens"
label var stem "Family: Stem"
label var ownland "Land owner: Yes"
label var head_age "Head: Age (years)"
label var head_occ1 "Head occ: Unoccupied"
label var head_occ2 "Head occ: Agri SE"
label var head_occ3 "Head occ: Agri casual"
label var head_occ4 "Head occ: Casual"
label var head_occ5 "Head occ: Regular"
label var head_occ6 "Head occ: SE"
label var head_occ7 "Head occ: NREGA"
label var head_educ1 "Head edu: Below primary"
label var head_educ2 "Head edu: Primary completed"
label var head_educ3 "Head edu: High school or more"
label var head_nonmarried "Head married: No"
label var dummymarriage "Marriage: Yes"
label var dummydemonetisation "Demonetisation: Yes"
label var village_1 "Village: ELA"
label var village_2 "Village: GOV" 
label var village_3 "Village: KAR"
label var village_4 "Village: KOR"
label var village_5 "Village: KUV"
label var village_6 "Village: MAN"
label var village_7 "Village: MANAM"
label var village_8 "Village: NAT"
label var village_9 "Village: ORA"
label var village_10 "Village: SEM"
label var nonworkersratio "Non-workers ratio"
label var housetitle "House title: Yes"
label var head_female "Head sex: Female"
label var remittnet_HH "Net remittances (Rs.)"
label var sexratio "Sex ratio"
label var dependencyratio "Dependency ratio"

label var dar_std "DAR (std)"
label var dsr_std "DSR (std)"
label var isr_std "ISR (std)"
label var assets_total_std "Wealth (std)"
label var nbloans_HH_std "Nb loans (std)"
label var annualincome_HH_std "Annual income (std)"
label var loanamount_HH_std "Loan amount (std)"

label var nobs1 "Nb obs: 1"
label var nobs2 "Nb obs: 2"
label var nobs3 "Nb obs: 3"
label var year2010 "Year: 2010"
label var year2016 "Year: 2016-17"
label var year2020 "Year: 2020-21"
label var mean_year2010 "Within year: 2010"
label var mean_year2016 "Within year: 2016-17"
label var mean_year2020 "Within year: 2020-21"

save"panel_v2", replace
****************************************
* END

















****************************************
* Inequalities
****************************************


********** RUME
use"raw\RUME-HH.dta", clear

* Selection
keep HHID2010 INDID2010 name sex age relationshiptohead

* Merge income
merge m:1 HHID2010 using "raw\RUME-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH nonworkersratio)
drop _merge

merge 1:1 HHID2010 INDID2010 using "raw\RUME-occup_indiv", keepusing(working_pop mainocc_occupation_indiv mainocc_annualincome_indiv annualincome_indiv nboccupation_indiv)
keep if _merge==3
drop _merge

* Panel
merge m:m HHID2010 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2010, replace
merge 1:m HHID2010 INDID2010 using"raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge HHID2010 INDID2010

gen year=2010
order HHID_panel INDID_panel year

save"temp1",replace






********** NEEMSIS-1
use"raw\NEEMSIS1-HH.dta", clear

* Selection
ta livinghome egoid
drop if livinghome>=3
keep HHID2016 INDID2016 name sex age relationshiptohead

* Merge income
merge m:1 HHID2016 using "raw\NEEMSIS1-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH nonworkersratio)
drop _merge

merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-occup_indiv", keepusing(working_pop mainocc_occupation_indiv mainocc_annualincome_indiv annualincome_indiv nboccupation_indiv)
keep if _merge==3
drop _merge

* Panel
merge m:m HHID2016 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2016, replace
merge 1:m HHID2016 INDID2016 using"raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge HHID2016 INDID2016

gen year=2016
order HHID_panel INDID_panel year

save"temp2",replace







********** NEEMSIS-2
use"raw\NEEMSIS2-HH.dta", clear

* Selection
ta livinghome egoid
drop if livinghome==3
drop if livinghome==4
drop if dummylefthousehold==1
keep HHID2020 INDID2020 name sex age relationshiptohead

* Merge income
merge m:1 HHID2020 using "raw\NEEMSIS2-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH nonworkersratio)
drop _merge

merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-occup_indiv", keepusing(working_pop mainocc_occupation_indiv mainocc_annualincome_indiv annualincome_indiv nboccupation_indiv)
keep if _merge==3
drop _merge

* Panel
merge m:m HHID2020 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge 1:m HHID2020 INDID2020 using"raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge HHID2020 INDID2020

gen year=2020
order HHID_panel INDID_panel year

save"temp3",replace






********** Append
use"temp1", clear

append using "temp2"
append using "temp3"


* Quanti defalte and round
foreach x in annualincome_HH mainocc_annualincome_indiv annualincome_indiv {
replace `x'=`x'*(100/54) if year==2010
replace `x'=`x'*(100/86) if year==2016
replace `x'=round(`x',1)
}

save"ineqindiv", replace
****************************************
* END

















****************************************
* Construction inequalities
****************************************
use"ineqindiv", clear

* Share income by sex
gen monthlyincome_indiv=annualincome_indiv/12
gen monthlyincome_HH=annualincome_HH/12
gen inc_men=monthlyincome_indiv  if sex==1
gen inc_women=monthlyincome_indiv if sex==2
bysort HHID_panel year: egen suminc_men=sum(inc_men)
bysort HHID_panel year: egen suminc_women=sum(inc_women)
gen test=monthlyincome_HH-suminc_men-suminc_women

* Working pop
fre working_pop
replace working_pop=2 if working_pop==1 & age>35 & (annualincome_indiv==. | annualincome_indiv==0)
replace working_pop=3 if working_pop==1 & age>35 & annualincome_indiv!=. & annualincome_indiv!=0

* Inactive
gen wp_inactive=0
replace wp_inactive=1 if working_pop==1

gen wp_inactive_men=0
replace wp_inactive_men=1 if working_pop==1 & sex==1
gen wp_inactive_women=0
replace wp_inactive_women=1 if working_pop==1 & sex==2

* Unoccupied
gen wp_unoccupi=0
replace wp_unoccupi=1 if working_pop==2

gen wp_unoccupi_men=0
replace wp_unoccupi_men=1 if working_pop==2 & sex==1
gen wp_unoccupi_women=0
replace wp_unoccupi_women=1 if working_pop==2 & sex==2

* Occupied
gen wp_occupied=0
replace wp_occupied=1 if working_pop==3

gen wp_occupied_men=0
replace wp_occupied_men=1 if working_pop==3 & sex==1
gen wp_occupied_women=0
replace wp_occupied_women=1 if working_pop==3 & sex==2

* Total by households
foreach x in inactive inactive_men inactive_women unoccupi unoccupi_men unoccupi_women occupied occupied_men occupied_women {
bysort HHID_panel year: egen wp_`x'_HH=sum(wp_`x')
}
gen wp_active_HH=wp_unoccupi_HH+wp_occupied_HH

gen wp_active_men_HH=wp_unoccupi_men_HH+wp_occupied_men_HH
gen wp_active_women_HH=wp_unoccupi_women_HH+wp_occupied_women_HH

* Save indiv
save "ineqindiv_v2", replace

* Save HH
keep HHID_panel year suminc_men suminc_women wp_inactive_HH wp_inactive_men_HH wp_inactive_women_HH wp_unoccupi_HH wp_unoccupi_men_HH wp_unoccupi_women_HH wp_occupied_HH wp_occupied_men_HH wp_occupied_women_HH wp_active_HH wp_active_men_HH wp_active_women_HH
duplicates drop
compress
save "ineqHH", replace


* Merge
use"panel_v2", clear

merge 1:1 HHID_panel year using "ineqHH"
keep if _merge==3
drop _merge

order HHID_panel HHID panelvar year time dummypanel

save "panel_v3", replace
****************************************
* END


















****************************************
* Construction 2
****************************************
use"panel_v3", clear

* Regular
gen incnonagrireg_HH=incnonagriregnonquali_HH+incnonagriregquali_HH
order incnonagrireg_HH, after(incnrega_HH)

* Annual income 2 = SUM of income to have exact tot (sinon décalage arrondi)
gen annualincome_HH2=incagrise_HH+incagricasual_HH+incnonagricasual_HH+incnonagrireg_HH+incnonagrise_HH+incnrega_HH
order annualincome_HH2, after(annualincome_HH)
tabstat annualincome_HH annualincome_HH2, stat(n mean)

* Annual income 3 = labour + pensions + remittances
gen annualincome_HH3=annualincome_HH2+pension_HH+remreceived_HH
foreach x in incagrise_HH incagricasual_HH incnonagricasual_HH incnonagrireg_HH incnonagrise_HH incnrega_HH pension_HH remreceived_HH {
gen share3_`x'=`x'*100/annualincome_HH3
}

* Monthly income
gen monthlyincome_HH=annualincome_HH3/12

* Per capita
foreach x in ///
annualincome_HH2 annualincome_HH3 ///
incomeagri_HH incomenonagri_HH /// 
incagrise_HH incagricasual_HH incnonagricasual_HH incnonagriregnonquali_HH incnonagriregquali_HH incnonagrise_HH incnrega_HH incnonagrireg_HH monthlyincome_HH ///
pension_HH remreceived_HH {
gen `x'_pc=`x'/HHsize
}
rename annualincome_HH2_pc annualincome_pc
rename annualincome_HH3_pc annualincome3_pc
rename incomeagri_HH_pc incomeagri_pc
rename incomenonagri_HH_pc incomenonagri_pc
rename incagrise_HH_pc incagrise_pc
rename incagricasual_HH_pc incagricasual_pc
rename incnonagricasual_HH_pc incnonagricasual_pc
rename incnonagriregnonquali_HH_pc incnonagriregnonquali_pc
rename incnonagriregquali_HH_pc incnonagriregquali_pc
rename incnonagrise_HH_pc incnonagrise_pc
rename incnrega_HH_pc incnrega_pc
rename incnonagrireg_HH_pc incnonagrireg_pc
rename monthlyincome_HH_pc monthlyincome_pc
rename remreceived_HH_pc remreceived_pc
rename pension_HH_pc pension_pc

gen test=annualincome_pc-incagrise_pc-incagricasual_pc-incnonagricasual_pc-incnonagrireg_pc-incnonagrise_pc-incnrega_pc
ta test
drop test

gen test=annualincome3_pc-incagrise_pc-incagricasual_pc-incnonagricasual_pc-incnonagrireg_pc-incnonagrise_pc-incnrega_pc-pension_pc-remreceived_pc
ta test
drop test

* 1000
replace monthlyincome_pc=monthlyincome_pc/1000

* Worker ratio
drop nbworker_HH nbnonworker_HH nonworkersratio
gen nonworkersratio=wp_unoccupi_HH/wp_occupied_HH
replace nonworkersratio=wp_unoccupi_HH if nonworkersratio==.
bysort HHID_panel: egen mean_nonworkersratio=mean(nonworkersratio)
label var nonworkersratio "Non-workers ratio"

* Dummies occupation
global inc incagrise_HH incagricasual_HH incnonagricasual_HH incnonagrireg_HH incnonagrise_HH incnrega_HH pension_HH remreceived_HH
foreach x in $inc {
gen d_`x'=0
}
foreach x in $inc {
replace d_`x'=1 if `x'!=0 & `x'!=.
}
rename d_incagrise_HH d_agrise
rename d_incagricasual_HH d_agricasual
rename d_incnonagricasual_HH d_nonagricasual
rename d_incnonagrireg_HH d_nonagrireg
rename d_incnonagrise_HH d_nonagrise
rename d_incnrega_HH d_nrega

* Share
drop shareincomeagri_HH shareincomenonagri_HH shareincagrise_HH shareincagricasual_HH shareincnonagricasual_HH shareincnonagriregnonquali_HH shareincnonagriregquali_HH shareincnonagrise_HH shareincnrega_HH
gen s_agrise=incagrise_pc*100/annualincome3_pc
gen s_agrica=incagricasual_pc*100/annualincome3_pc
gen s_casual=incnonagricasual_pc*100/annualincome3_pc
gen s_regula=incnonagrireg_pc*100/annualincome3_pc
gen s_selfem=incnonagrise_pc*100/annualincome3_pc
gen s_mgnreg=incnrega_pc*100/annualincome3_pc
gen s_pensio=pension_pc*100/annualincome3_pc
gen s_remitt=remreceived_pc*100/annualincome3_pc

save "panel_v4", replace
****************************************
* END

