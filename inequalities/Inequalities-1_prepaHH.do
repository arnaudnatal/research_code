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

* Income
gen annualincome_HH_backup=annualincome_HH

*** Quanti 
global quanti1 head_mocc_annualincome head_annualincome 
global quanti2 loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH
global quanti3 expenses_total expenses_food expenses_educ expenses_heal expenses_cere expenses_agri expenses_marr
global quanti4 assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland assets_totalnoprop assets_total1000 assets_totalnoland1000 assets_totalnoprop1000 annualincome_HH
global quanti5 remreceived_HH remsent_HH remittnet_HH
global quanti6 goldreadyamount incomeagri_HH incomenonagri_HH incagrise_HH incagricasual_HH incnonagricasual_HH incnonagriregnonquali_HH incnonagriregquali_HH incnonagrise_HH incnrega_HH
global quanti $quanti1 $quanti2 $quanti3 $quanti4 $quanti5 $quanti6


*** Deflate and round
foreach x in $quanti {
replace `x'=`x'*(100/54) if year==2010
replace `x'=`x'*(100/86) if year==2016
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


gen annualincome_HH_compo1=incomeagri_HH+incomenonagri_HH
gen test=annualincome_HH_compo1-(incomeagri_HH+incomenonagri_HH)
ta test
drop test

gen annualincome_HH_compo2=incagrise_HH+incagricasual_HH+incnonagricasual_HH+incnonagriregnonquali_HH+incnonagriregquali_HH+incnonagrise_HH+incnrega_HH
gen test=annualincome_HH_compo2-(incagrise_HH+incagricasual_HH+incnonagricasual_HH+incnonagriregnonquali_HH+incnonagriregquali_HH+incnonagrise_HH+incnrega_HH)
ta test
drop test




********** Selection
drop if housetitle==.
bysort HHID_panel: gen n=_N
ta n
dis 1146/3
drop n


save"panel_v0", replace
****************************************
* END



















****************************************
* Construction
****************************************
use"panel_v0", clear


gen test=annualincome_HH_compo1-incomeagri_HH-incomenonagri_HH
ta test
drop test

* DSR
tabstat imp1_ds_tot_HH annualincome_HH, stat(min p1 p5 p10 q p90 p95 p99 max)
gen dsr=imp1_ds_tot_HH/annualincome_HH
replace dsr=0 if dsr==.

* ISR
gen isr=imp1_is_tot_HH/annualincome_HH
replace isr=0 if isr==.
replace dsr=dsr*100
replace isr=isr*100
tabstat dsr isr, stat(n mean cv p50) by(year) long
replace dsr=dsr/100
replace isr=isr/100

* DAR
tabstat loanamount_HH assets_total assets_totalnoland assets_totalnoprop, stat(n mean cv p50) by(year)
gen dar=loanamount_HH/assets_totalnoprop
replace dar=0 if dar==.

* DIR
gen dir=loanamount_HH/annualincome_HH
replace dir=0 if dir==.

* LPC - Loans per capita
gen lpc=nbloans_HH/squareroot_HHsize
replace lpc=0 if lpc==.

* LAPC - Loan amount per capita
gen lapc=loanamount_HH/squareroot_HHsize
replace lapc=0 if lapc==.


* Poverty
/*
All is expressed in 2010 PPP
However, new PL with 2017
annualincome_HH is expressed in 2010 rupees
annualincome_HH_backup is not deflated
*/
tabstat annualincome_HH annualincome_HH_backup, stat(n mean) by(year)
* Deflate for 2017 PPP
gen annualincome_HH2=annualincome_HH_backup
replace annualincome_HH2=annualincome_HH2*(100/62.81) if year==2010
replace annualincome_HH2=annualincome_HH2*(100/114.95) if year==2020
replace annualincome_HH2=round(annualincome_HH2,1)
 

* Test
tabstat annualincome_HH_backup annualincome_HH annualincome_HH2, stat(n mean) by(year)

gen dailyincome_pc=(annualincome_HH2/365)/HHsize
gen dailyuspppdincome_pc=dailyincome_pc/20.65
gen rrgpl_ppp=((dailyuspppdincome_pc-2.15)/2.15)*(-1)

rename rrgpl_ppp rrgpl
drop annualincome_HH2 annualincome_HH_backup

gen poor_HH=0
replace poor_HH=1 if dailyuspppdincome_pc<=2.15
gen sopl_HH=dailyuspppdincome_pc/2.15
label define poor 0"Non-poor" 1"Poor"
label values poor_HH poor

save"panel_v1", replace
****************************************
* END


















****************************************
* Other
****************************************
use"panel_v1", clear

* HH
encode HHID_panel, gen(panelvar)

* Village
encode villageid, gen(vill)

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

* Class
tabstat assets_total, stat(q) by(year)
foreach i in 2010 2016 2020 {
xtile assets_`i'=assets_total if year==`i', n(3) 
}
gen assets_cat=.
replace assets_cat=assets_2010 if year==2010
replace assets_cat=assets_2016 if year==2016
replace assets_cat=assets_2020 if year==2020
drop assets_2010 assets_2016 assets_2020
ta assets_cat
label define assets_cat 1"Wealth: Poor" 2"Wealth: Middle" 3"Wealth: Rich"
label values assets_cat assets_cat
fre assets_cat
ta assets_cat caste, chi2 cchi2 exp
ta assets_cat, gen(assets_cat)

tabstat annualincome_HH, stat(q) by(year)
foreach i in 2010 2016 2020 {
xtile income_`i'=annualincome_HH if year==`i', n(3) 
}
gen income_cat=.
replace income_cat=income_2010 if year==2010
replace income_cat=income_2016 if year==2016
replace income_cat=income_2020 if year==2020
drop income_2010 income_2016 income_2020
ta income_cat
label define income_cat 1"Income: Poor" 2"Income: Middle" 3"Income: Rich"
label values income_cat income_cat
fre income_cat
ta income_cat caste, chi2 cchi2 exp
ta income_cat, gen(income_cat)

* Dalits
gen dalits=.
replace dalits=1 if caste==1
replace dalits=0 if caste==2
replace dalits=0 if caste==3
label define dalits 0"Non-dalits" 1"Dalits"
label values dalits dalits

* Time
gen time=0
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time

* Dummy ownland
recode ownland (.=0)
ta ownland year, col nofreq
label define ownland 0"Own land: No" 1"Own land: Yes"
label values ownland ownland

* Village
fre village villageid vill
ta vill, gen(village_)

* Caste
fre caste
ta caste, gen(caste_)

* Label
label var caste_2 "Caste: Middle"
label var caste_3 "Caste: Upper"
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



save"panel_v2", replace
****************************************
* END




















****************************************
* Construction: clean
****************************************
use"panel_v2", clear


replace loanamount_HH=0 if loanamount_HH==.

foreach x in loanamount_HH annualincome_HH assets_total imp1_ds_tot_HH imp1_is_tot_HH dsr isr dar dir expenses_total remreceived_HH remsent_HH remittnet_HH dailyincome_pc assets_gold goldquantity_HH goldreadyamount nbloans_HH lpc lapc {
egen `x'_std=std(`x')
}

*** Label
label var dar_std "DAR (std)"
label var dsr_std "DSR (std)"
label var isr_std "ISR (std)"
label var dailyincome_pc_std "Livelihood (std)"
label var assets_total_std "Wealth (std)"
label var nbloans_HH_std "Nb loans (std)"
label var lpc_std "Loans pc (std)"
label var lapc_std "Loan amount pc (std)"
label var annualincome_HH_std "Annual income (std)"
label var loanamount_HH_std "Loan amount (std)"

*** Order
order HHID_panel year
sort HHID_panel year


save"panel_v3", replace
****************************************
* END



















****************************************
* HH inequalities
****************************************

********** RUME
use"raw\RUME-HH.dta", clear

* Selection
keep HHID2010 INDID2010 name sex age relationshiptohead

* Merge income
merge m:1 HHID2010 using "raw\RUME-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH nonworkersratio)
drop _merge

merge 1:1 HHID2010 INDID2010 using "raw\RUME-occup_indiv", keepusing(working_pop mainocc_occupation_indiv mainocc_annualincome_indiv annualincome_indiv nboccupation_indiv)
drop _merge

* Share income by indiv and sex
gen inc_men=annualincome_indiv  if sex==1
gen inc_women=annualincome_indiv if sex==2
drop annualincome_HH
bysort HHID2010: egen annualincome_HH=sum(annualincome_indiv)
bysort HHID2010: egen suminc_men=sum(inc_men)
bysort HHID2010: egen suminc_women=sum(inc_women)
gen test=annualincome_HH-suminc_men-suminc_women
ta test
drop test
gen sharemen=suminc_men/annualincome_HH
gen sharewomen=suminc_women/annualincome_HH
gen shareindiv=annualincome_indiv/annualincome_HH
bysort HHID2010: egen test=sum(shareindiv)
ta test
drop test
gen diffinc=suminc_men-suminc_women
gen absdiffinc=abs(diffinc)
gen absdiffinctoinc=absdiffinc/annualincome_HH
gen diffshare=sharemen-sharewomen
gen absdiffshare=abs(diffshare)
gen type=.
replace type=1 if diffshare<-0.05
replace type=2 if diffshare>=-0.05 & diffshare<=0.05
replace type=3 if diffshare>0.05
label define type 1"W>M" 2"W=M" 3"W<M"
label values type type

* Working pop
fre working_pop
replace working_pop=2 if working_pop==1 & age>35 & (annualincome_indiv==. | annualincome_indiv==0)
replace working_pop=3 if working_pop==1 & age>35 & annualincome_indiv!=. & annualincome_indiv!=0

drop nbworker_HH nbnonworker_HH nonworkersratio

gen wp_inactive=0
replace wp_inactive=1 if working_pop==1

gen wp_unoccupi=0
replace wp_unoccupi=1 if working_pop==2

gen wp_occupied=0
replace wp_occupied=1 if working_pop==3

foreach x in inactive unoccupi occupied {
bysort HHID2010: egen wp_`x'_HH=sum(wp_`x')
}
gen wp_active_HH=wp_unoccupi_HH+wp_occupied_HH

* Panel
merge m:m HHID2010 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

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

* Share income by indiv and sex
gen inc_men=annualincome_indiv  if sex==1
gen inc_women=annualincome_indiv if sex==2
bysort HHID2016: egen suminc_men=sum(inc_men)
bysort HHID2016: egen suminc_women=sum(inc_women)
gen test=annualincome_HH-suminc_men-suminc_women
ta test
drop test
gen sharemen=suminc_men/annualincome_HH
replace sharemen=0 if sharemen==.
gen sharewomen=suminc_women/annualincome_HH
replace sharewomen=0 if sharewomen==.
gen shareindiv=annualincome_indiv/annualincome_HH
bysort HHID2016: egen test=sum(shareindiv)
ta test
drop test
gen diffinc=suminc_men-suminc_women
gen absdiffinc=abs(diffinc)
gen absdiffinctoinc=absdiffinc/annualincome_HH
gen diffshare=sharemen-sharewomen
gen absdiffshare=abs(diffshare)
gen type=.
replace type=1 if diffshare<-0.05
replace type=2 if diffshare>=-0.05 & diffshare<=0.05
replace type=3 if diffshare>0.05
label define type 1"W>M" 2"W=M" 3"W<M"
label values type type

* Working pop
fre working_pop
replace working_pop=2 if working_pop==1 & age>35 & (annualincome_indiv==. | annualincome_indiv==0)
replace working_pop=3 if working_pop==1 & age>35 & annualincome_indiv!=. & annualincome_indiv!=0

drop nbworker_HH nbnonworker_HH nonworkersratio

gen wp_inactive=0
replace wp_inactive=1 if working_pop==1

gen wp_unoccupi=0
replace wp_unoccupi=1 if working_pop==2

gen wp_occupied=0
replace wp_occupied=1 if working_pop==3

foreach x in inactive unoccupi occupied {
bysort HHID2016: egen wp_`x'_HH=sum(wp_`x')
}
gen wp_active_HH=wp_unoccupi_HH+wp_occupied_HH

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
drop if dummylefthousehold==1
drop if livinghome>=3
keep HHID2020 INDID2020 name sex age relationshiptohead

* Merge income
merge m:1 HHID2020 using "raw\NEEMSIS2-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH nonworkersratio)
drop _merge

merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-occup_indiv", keepusing(working_pop mainocc_occupation_indiv mainocc_annualincome_indiv annualincome_indiv nboccupation_indiv)
keep if _merge==3
drop _merge

* Share income by indiv and sex
gen inc_men=annualincome_indiv  if sex==1
gen inc_women=annualincome_indiv if sex==2
bysort HHID2020: egen suminc_men=sum(inc_men)
bysort HHID2020: egen suminc_women=sum(inc_women)
gen test=annualincome_HH-suminc_men-suminc_women
ta test
drop test
gen sharemen=suminc_men/annualincome_HH
replace sharemen=0 if sharemen==.
gen sharewomen=suminc_women/annualincome_HH
replace sharewomen=0 if sharewomen==.
gen shareindiv=annualincome_indiv/annualincome_HH
bysort HHID2020: egen test=sum(shareindiv)
ta test
drop test
gen diffinc=suminc_men-suminc_women
gen absdiffinc=abs(diffinc)
gen absdiffinctoinc=absdiffinc/annualincome_HH
gen diffshare=sharemen-sharewomen
gen absdiffshare=abs(diffshare)
gen type=.
replace type=1 if diffshare<-0.05
replace type=2 if diffshare>=-0.05 & diffshare<=0.05
replace type=3 if diffshare>0.05
label define type 1"W>M" 2"W=M" 3"W<M"
label values type type

* Working pop
fre working_pop
replace working_pop=2 if working_pop==1 & age>35 & (annualincome_indiv==. | annualincome_indiv==0)
replace working_pop=3 if working_pop==1 & age>35 & annualincome_indiv!=. & annualincome_indiv!=0

drop nbworker_HH nbnonworker_HH nonworkersratio

gen wp_inactive=0
replace wp_inactive=1 if working_pop==1

gen wp_unoccupi=0
replace wp_unoccupi=1 if working_pop==2

gen wp_occupied=0
replace wp_occupied=1 if working_pop==3

foreach x in inactive unoccupi occupied {
bysort HHID2020: egen wp_`x'_HH=sum(wp_`x')
}
gen wp_active_HH=wp_unoccupi_HH+wp_occupied_HH

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



********** Append + construction
use"temp1", clear

append using "temp2"
append using "temp3"

* Selection
fre mainocc_occupation_indiv
recode mainocc_occupation_indiv (0=.)
replace annualincome_indiv=. if mainocc_occupation_indiv==.

* Poverty indiv
gen annualincome_indiv2=annualincome_indiv
replace annualincome_indiv2=annualincome_indiv2*(100/62.81) if year==2010
replace annualincome_indiv2=annualincome_indiv2*(100/114.95) if year==2020
replace annualincome_indiv2=round(annualincome_indiv2,1)
gen dayinc=annualincome_indiv2/365
gen dayinc_usd_ppp=dayinc/20.65
gen poor_indiv=0
replace poor_indiv=1 if dayinc_usd_ppp<=2.15
gen sopl_indiv=dayinc_usd_ppp/2.15
label values poor_indiv poor

compress


********** Save indiv
save "ineqindiv", replace

********** Save HH
keep HHID_panel year suminc_men suminc_women sharemen sharewomen diffinc absdiffinc diffshare absdiffshare type wp_inactive_HH wp_unoccupi_HH wp_occupied_HH wp_active_HH
duplicates drop
compress
save "ineqHH", replace


********** Merge
use"panel_v3", clear

merge 1:1 HHID_panel year using "ineqHH"
keep if _merge==3
drop _merge

order HHID_panel HHID panelvar year time dummypanel

save "panel_v4", replace
****************************************
* END












****************************************
* Supp for CRE
****************************************
use"panel_v4", clear


* House
ta house, gen(house_)

* Lockdown
recode secondlockdownexposure dummysell(.=1)
ta secondlockdownexposure, gen(lock_)
label var lock_1 "Sec. lockdown: Before"
label var lock_2 "Sec. lockdown: During"
label var lock_3 "Sec. lockdown: After"
label var dummysell "Sell assets to face lockdown: Yes"
label var dummydemonetisation "Demonetisation: Yes"

* Clean assets
sum assets_housevalue assets_livestock assets_goods assets_ownland assets_gold
foreach x in assets_housevalue assets_livestock assets_goods assets_ownland assets_gold {
replace `x'=1 if `x'==. | `x'<1
}

* Log
foreach x in assets_total assets_totalnoland assets_housevalue assets_livestock assets_goods assets_ownland assets_gold annualincome_HH assets_totalnoprop {
replace `x'=1 if `x'<1 | `x'==.
gen log_`x'=log(`x')
}

* Mean over time
global livelihood log_annualincome_HH log_assets_total log_assets_totalnoland remittnet_HH assets_total assets_totalnoland annualincome_HH log_assets_housevalue log_assets_livestock log_assets_goods log_assets_ownland log_assets_gold log_assets_totalnoprop
global family HHsize HH_count_child stem housetitle ownland sexratio dependencyratio nonworkersratio
global head head_female head_age head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried
global shock dummymarriage dummydemonetisation lock_1 lock_2 lock_3 dummysell dummyexposure
foreach x in $family $livelihood $head $shock {
bysort HHID_panel: egen mean_`x'=mean(`x')
}

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

label var nobs1 "Nb obs: 1"
label var nobs2 "Nb obs: 2"
label var nobs3 "Nb obs: 3"
label var year2010 "Year: 2010"
label var year2016 "Year: 2016-17"
label var year2020 "Year: 2020-21"
label var mean_year2010 "Within year: 2010"
label var mean_year2016 "Within year: 2016-17"
label var mean_year2020 "Within year: 2020-21"
label var log_annualincome_HH "Annual income (log)"
label var log_assets_total "Assets (log)"
label var log_assets_totalnoland "Assets without land (log)"


save "panel_v5", replace
****************************************
* END










****************************************
* Per active / worker, etc.
****************************************
use"panel_v5", clear

* Regular
gen incnonagrireg_HH=incnonagriregnonquali_HH+incnonagriregquali_HH
order incnonagrireg_HH, after(incnrega_HH)

* Monthly income
gen monthlyincome_HH=annualincome_HH/12


* Per capita
foreach x in annualincome_HH_compo1 incomeagri_HH incomenonagri_HH annualincome_HH_compo2 incagrise_HH incagricasual_HH incnonagricasual_HH incnonagriregnonquali_HH incnonagriregquali_HH incnonagrise_HH incnrega_HH incnonagrireg_HH monthlyincome_HH {
gen `x'_pc=`x'/HHsize
}
rename annualincome_HH_compo1_pc annualincome_compo1_pc
rename incomeagri_HH_pc incomeagri_pc
rename incomenonagri_HH_pc incomenonagri_pc
rename annualincome_HH_compo2_pc annualincome_compo2_pc
rename incagrise_HH_pc incagrise_pc
rename incagricasual_HH_pc incagricasual_pc
rename incnonagricasual_HH_pc incnonagricasual_pc
rename incnonagriregnonquali_HH_pc incnonagriregnonquali_pc
rename incnonagriregquali_HH_pc incnonagriregquali_pc
rename incnonagrise_HH_pc incnonagrise_pc
rename incnrega_HH_pc incnrega_pc
rename incnonagrireg_HH_pc incnonagrireg_pc
rename monthlyincome_HH_pc monthlyincome_pc


* Modified per capita
foreach x in annualincome_HH_compo1 incomeagri_HH incomenonagri_HH annualincome_HH_compo2 incagrise_HH incagricasual_HH incnonagricasual_HH incnonagriregnonquali_HH incnonagriregquali_HH incnonagrise_HH incnrega_HH incnonagrireg_HH monthlyincome_HH {
gen `x'_mpc=`x'/equimodiscale_HHsize
}
rename annualincome_HH_compo1_mpc annualincome_compo1_mpc
rename incomeagri_HH_mpc incomeagri_mpc
rename incomenonagri_HH_mpc incomenonagri_mpc
rename annualincome_HH_compo2_mpc annualincome_compo2_mpc
rename incagrise_HH_mpc incagrise_mpc
rename incagricasual_HH_mpc incagricasual_mpc
rename incnonagricasual_HH_mpc incnonagricasual_mpc
rename incnonagriregnonquali_HH_mpc incnonagriregnonquali_mpc
rename incnonagriregquali_HH_mpc incnonagriregquali_mpc
rename incnonagrise_HH_mpc incnonagrise_mpc
rename incnrega_HH_mpc incnrega_mpc
rename incnonagrireg_HH_mpc incnonagrireg_mpc
rename monthlyincome_HH_mpc monthlyincome_mpc


* Worker ratio
drop nbworker_HH nbnonworker_HH nonworkersratio mean_nonworkersratio
gen nonworkersratio=wp_unoccupi_HH/wp_occupied_HH
replace nonworkersratio=wp_unoccupi_HH if nonworkersratio==.
bysort HHID_panel: egen mean_nonworkersratio=mean(nonworkersratio)

* Dummies occupation
global inc incagrise_HH incagricasual_HH incnonagricasual_HH incnonagrireg_HH incnonagrise_HH incnrega_HH
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
gen shareincnonagrireg_HH=shareincnonagriregnonquali_HH+shareincnonagriregquali_HH

* Percent
gen absdiffpercent=absdiffshare*100
gen diffpercent=diffshare*100

save "panel_v6", replace
****************************************
* END
