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
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------








****************************************
* Loan level
****************************************
use"panel_loans_v0", clear

* Merge sex and drop died
merge m:1 HHID_panel INDID_panel year using "panel_indiv_v0", keepusing(sex livinghome)
drop if _merge==2
drop _merge
ta livinghome year
drop if livinghome==3
drop if livinghome==4
drop livinghome

* Merge caste
merge m:1 HHID_panel year using "panel_HH_v0", keepusing(caste)
drop if _merge==2
drop _merge
order HHID_panel INDID_panel year caste sex 

* Cat of amount
xtile catloanamount=loanamount, n(5)
label define catloanamount 1"A: Vlow" 2"A: Low" 3"A: Int" 4"A: High" 5"A: Vhigh"
label values catloanamount catloanamount
tabstat loanamount, stat(min max) by(catloanamount)
order catloanamount, after(loanamount)

* Cat of amount for main loans
xtile catmainloanamount=loanamount if dummymainloan==1, n(5)
label define catmainloanamount 1"A: Vlow" 2"A: Low" 3"A: Int" 4"A: High" 5"A: Vhigh"
label values catmainloanamount catmainloanamount
tabstat loanamount, stat(min max) by(catmainloanamount)
order catmainloanamount, after(catloanamount)
ta catmainloanamount catloanamount


********** Prepa for R
*
fre catloanamount
*
fre loanreasongiven
recode loanreasongiven (8=7) (11=7)
drop if loanreasongiven==12
drop if loanreasongiven==77
label define loanreasongiven 1"R: Agri" 2"R: Fam" 3"R: Heal" 4"R: Rep" 5"R: Hou" 6"R: Inv" 7"R: Cere" 9"R: Educ" 10"R: Rela", modify
*
fre reason_cat
label define reason_cat 1"R: Eco" 2"R: Cur" 3"R: Hum" 4"R: Soc" 5"R: Hou", modify
*
fre lender4
recode lender4 (5=10)
label define lender4 1"L: WKP" 2"L: Rel" 3"L: Lab" 4"L: Paw" 6"L: Mon" 7"L: Fri" 8"L: Mic" 9"L: Ban" 10"L: Nei", modify
*
fre lender4cat
label define lender4cat 1"L: Inf" 2"L: For", modify
*
gen otherlenderservice=0
replace otherlenderservice=1 if othlendserv_poli==1 | othlendserv_guar==1 | othlendserv_gene==1 | othlendserv_othe==1
label var otherlenderservice "LenServ: Y"
label define otherlenderservice 0"LenServ: N" 1"LenServ: Y"
label values otherlenderservice otherlenderservice
ta otherlenderservice
*
gen guarantee=0
replace guarantee=1 if guarantee_docu==1
replace guarantee=1 if guarantee_chit==1
replace guarantee=1 if guarantee_shg==1
replace guarantee=1 if guarantee_pers==1
replace guarantee=1 if guarantee_jewe==1
replace guarantee=1 if guarantee_other==1
replace guarantee=1 if guarantee_doc==1
replace guarantee=1 if guarantee_othe==1
replace guarantee=1 if guarantee_both==1
replace guarantee=0 if guarantee_none==1
label var guarantee "Guar: Y"
label define guarantee 0"Guar: N" 1"Guar: Y"
label values guarantee guarantee
*
fre dummyinterest
recode dummyinterest (88=0)
label var dummyinterest "Int: Y"
label define dummyinterest 0"Int: N" 1"Int: Y", replace
label values dummyinterest dummyinterest
*


save"panel_loans_v1", replace
****************************************
* END













****************************************
* Long lender
****************************************
use"panel_loans_v1", clear

fre dummyinterest
drop if dummyinterest==88

********** All loans
/*
preserve
keep lender4 loanreasongiven catloanamount
rename lender4 lender
rename loanreasongiven reason
rename catloanamount amount
export delimited using "Allloans.csv", replace
restore
*/

preserve
keep lender4 reason_cat catloanamount
rename lender4 lender
rename reason_cat reason
rename catloanamount amount
export delimited using "Allloans_2.csv", replace
restore



********** Finance loan
/*
preserve
drop if loan_database=="GOLD"
drop if loan_database=="MARRIAGE"
keep lender4 loanreasongiven catloanamount otherlenderservice
rename lender4 lender
rename loanreasongiven reason
rename catloanamount amount
rename otherlenderservice services
export delimited using "Financeloans.csv", replace
restore
*/

preserve
drop if loan_database=="GOLD"
drop if loan_database=="MARRIAGE"
keep lender4 reason_cat catloanamount otherlenderservice
rename lender4 lender
rename reason_cat reason
rename catloanamount amount
rename otherlenderservice services
export delimited using "Financeloans_2.csv", replace
restore



********** Finance loans 2020-21
/*
preserve
drop if loan_database=="GOLD"
drop if loan_database=="MARRIAGE"
keep if year==2020
keep lender4 loanreasongiven catloanamount dummyinterest guarantee otherlenderservice
rename lender4 lender
rename loanreasongiven reason
rename catloanamount amount
rename dummyinterest interest
rename otherlenderservice services
export delimited using "Financeloans2020.csv", replace
restore
*/

/*
preserve
drop if loan_database=="GOLD"
drop if loan_database=="MARRIAGE"
keep if year==2020
keep lender4 reason_cat catloanamount dummyinterest guarantee otherlenderservice
rename lender4 lender
rename reason_cat reason
rename catloanamount amount
rename dummyinterest interest
rename otherlenderservice services
export delimited using "Financeloans2020_2.csv", replace
restore
*/

********** Main loans
/*
preserve
keep if dummymainloan==1
keep lender4 loanreasongiven catloanamount dummyinterest guarantee
rename lender4 lender
rename loanreasongiven reason
rename catloanamount amount
rename dummyinterest interest 
export delimited using "Mainloans.csv", replace
restore
*/

/*
preserve
keep if dummymainloan==1
keep lender4 reason_cat catloanamount dummyinterest guarantee
rename lender4 lender
rename reason_cat reason
rename catloanamount amount
rename dummyinterest interest 
export delimited using "Mainloans_2.csv", replace
restore
*/

/*
preserve
keep if dummymainloan==1
keep lender4 loanreasongiven catloanamount dummyinterest guarantee otherlenderservice
rename lender4 lender
rename loanreasongiven reason
rename catloanamount amount
rename dummyinterest interest 
export delimited using "Mainloans_3.csv", replace
restore
*/

preserve
keep if dummymainloan==1
keep lender4 reason_cat catmainloanamount dummyinterest guarantee otherlenderservice
rename lender4 lender
rename reason_cat reason
rename catmainloanamount amount
rename dummyinterest interest
rename otherlenderservice services
export delimited using "Mainloans_4.csv", replace
restore

****************************************
* END















/*
****************************************
* Short lender
****************************************
use"panel_loans_v1", clear

fre dummyinterest
drop if dummyinterest==88

********** All loans
preserve
keep lender4cat loanreasongiven catloanamount
rename lender4cat lender
rename loanreasongiven reason
rename catloanamount amount
export delimited using "SL_Allloans.csv", replace
restore

preserve
keep lender4cat reason_cat catloanamount
rename lender4cat lender
rename reason_cat reason
rename catloanamount amount
export delimited using "SL_Allloans_2.csv", replace
restore



********** Finance loan
preserve
drop if loan_database=="GOLD"
drop if loan_database=="MARRIAGE"
keep lender4cat loanreasongiven catloanamount otherlenderservice
rename lender4cat lender
rename loanreasongiven reason
rename catloanamount amount
rename otherlenderservice services
export delimited using "SL_Financeloans.csv", replace
restore

preserve
drop if loan_database=="GOLD"
drop if loan_database=="MARRIAGE"
keep lender4cat reason_cat catloanamount otherlenderservice
rename lender4cat lender
rename reason_cat reason
rename catloanamount amount
rename otherlenderservice services
export delimited using "SL_Financeloans_2.csv", replace
restore



********** Finance loans 2020-21
preserve
drop if loan_database=="GOLD"
drop if loan_database=="MARRIAGE"
keep if year==2020
keep lender4cat loanreasongiven catloanamount dummyinterest guarantee otherlenderservice
rename lender4cat lender
rename loanreasongiven reason
rename catloanamount amount
rename dummyinterest interest
rename otherlenderservice services
export delimited using "SL_Financeloans2020.csv", replace
restore

preserve
drop if loan_database=="GOLD"
drop if loan_database=="MARRIAGE"
keep if year==2020
keep lender4cat reason_cat catloanamount dummyinterest guarantee otherlenderservice
rename lender4cat lender
rename reason_cat reason
rename catloanamount amount
rename dummyinterest interest
rename otherlenderservice services
export delimited using "SL_Financeloans2020_2.csv", replace
restore


********** Main loans
preserve
keep if dummymainloan==1
keep lender4cat loanreasongiven catloanamount dummyinterest guarantee
rename lender4cat lender
rename loanreasongiven reason
rename catloanamount amount
rename dummyinterest interest 
export delimited using "SL_Mainloans.csv", replace
restore

preserve
keep if dummymainloan==1
keep lender4cat reason_cat catloanamount dummyinterest guarantee
rename lender4cat lender
rename reason_cat reason
rename catloanamount amount
rename dummyinterest interest 
export delimited using "SL_Mainloans_2.csv", replace
restore

preserve
keep if dummymainloan==1
keep lender4cat loanreasongiven catloanamount dummyinterest guarantee otherlenderservice
rename lender4cat lender
rename loanreasongiven reason
rename catloanamount amount
rename dummyinterest interest 
export delimited using "SL_Mainloans_3.csv", replace
restore

preserve
keep if dummymainloan==1
keep lender4cat reason_cat catloanamount dummyinterest guarantee otherlenderservice
rename lender4cat lender
rename reason_cat reason
rename catloanamount amount
rename dummyinterest interest 
export delimited using "SL_Mainloans_4.csv", replace
restore

****************************************
* END
*/





















****************************************
* Indiv level
****************************************
use"panel_indiv_v0", clear

********** Debt
* DSR
gen dsr_indiv=(imp1_ds_tot_indiv*100)/annualincome_indiv
replace dsr_indiv=0 if dsr_indiv==.


********** Controls
* Panelvar
egen panelvar=group(HHID_panel INDID_panel)

* Village
encode villageid, gen(vill)
ta vill, gen(village_)

*Stem
gen stem=.
replace stem=0 if typeoffamily=="nuclear"
replace stem=1 if typeoffamily=="stem"
replace stem=1 if typeoffamily=="joint-stem"
label define stem 0"Nuclear" 1"Stem"
label values stem stem
ta stem typeoffamily

* Dalits
gen dalits=.
replace dalits=1 if caste==1
replace dalits=0 if caste==2
replace dalits=0 if caste==3
label define dalits 0"Non-dalits" 1"Dalits"
label values dalits dalits

* Caste
fre caste
ta caste, gen(caste_)

* Ownland
recode ownland (.=0)
ta ownland year, col nofreq
label define ownland 0"Own land: No" 1"Own land: Yes"
label values ownland ownland



********** Label
label var caste_2 "Caste: Middle"
label var caste_3 "Caste: Upper"
label var HHsize "Household size"
label var HH_count_child "Number of childrens"
label var stem "Family: Stem"
label var ownland "Land owner: Yes"
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
label var housetitle "House title: Yes"




********** Cleaning
rename head_sex sexhead
drop head_* nbloans_indiv loanamount_indiv
rename sexhead headsex



********** Selection
drop if age<18
drop if livinghome==3
drop if livinghome==4
drop livinghome
ta year
/*
       year |      Freq.     Percent        Cum.
------------+-----------------------------------
       2016 |      1,689       42.82       42.82
       2020 |      2,255       57.18      100.00
------------+-----------------------------------
      Total |      3,944      100.00
*/

/*
* OK POUR LA TAILLE DE L'ECHANTILLON
preserve
use"raw/NEEMSIS2-HH", clear
merge m:m HHID2020 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
drop if dummylefthousehold==1
drop if livinghome==3
drop if livinghome==4
drop if age<18
drop if HHID_panel=="GOV66"
drop if HHID_panel=="KUV66"
drop if HHID_panel=="GOV64"
drop if HHID_panel=="GOV67"
drop if HHID_panel=="KUV67"
drop if HHID_panel=="GOV65"
count
restore
*/


********** Order
order HHID_panel year
sort HHID_panel year




save"panel_indiv_v1", replace
****************************************
* END

























****************************************
* HH level
****************************************
use"panel_HH_v0", clear


********** Debt
* DSR
gen dsr=(imp1_ds_tot_HH*100)/annualincome_HH
replace dsr=0 if dsr==.

* ISR
gen isr=(imp1_is_tot_HH*100)/annualincome_HH
replace isr=0 if isr==.





********** Controls
* panelvar
encode HHID_panel, gen(panelvar)

* Village
encode villageid, gen(vill)
ta vill, gen(village_)

*Stem
gen stem=.
replace stem=0 if typeoffamily=="nuclear"
replace stem=1 if typeoffamily=="stem"
replace stem=1 if typeoffamily=="joint-stem"
label define stem 0"Nuclear" 1"Stem"
label values stem stem
ta stem typeoffamily

* Head sex
gen head_female=.
replace head_female=0 if head_sex==1
replace head_female=1 if head_sex==2
label define head_female 0"Male" 1"Female"
label values head_female head_female

* Head occupation
recode head_mocc_occupation (5=4)
ta head_mocc_occupation, gen(head_occ)

* Head edulevel
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
gen head_nonmarried=head_maritalstatus
recode head_nonmarried (1=0) (2=1) (3=1) (4=1) (.=0)
label define head_nonmarried 0"Married" 1"Non-married"
label values head_nonmarried head_nonmarried

* Dalits
gen dalits=.
replace dalits=1 if caste==1
replace dalits=0 if caste==2
replace dalits=0 if caste==3
label define dalits 1"Dalits" 0"Non-dalits"
label values dalits dalits

* Caste
ta caste, gen(caste_)

* Time
gen time=0
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time

* Dummy ownland
recode ownland (.=0)
label define ownland 0"Own land: No" 1"Own land: Yes"
label values ownland ownland



********* Label
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
label var housetitle "House title: Yes"
label var head_female "Head sex: Female"



********** Drop
drop nbloans_HH loanamount_HH



********** Order
order HHID_panel year
sort HHID_panel year


save"panel_HH_v1", replace
****************************************
* END

