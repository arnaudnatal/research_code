*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*October 7, 2024
*-----
gl link = "debttrap"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------











****************************************
* Construction: debt
****************************************
use"panel_HH_v0", clear

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

* DCR
gen dcr=loanamount_HH/expenses_total
replace dcr=0 if dcr==.


* GTDR
gen gtdr=totHH_givenamt_repa/loanamount_HH
replace gtdr=0 if gtdr==.

* GTAR
gen gtar=totHH_givenamt_repa/assets_total
replace gtar=0 if gtar==.


* ETDR
gen etdr=totHH_effectiveamt_repa/loanamount_HH
replace etdr=0 if etdr==.


* ETAR
gen etar=totHH_effectiveamt_repa/assets_total
replace etar=0 if etar==.


save"panel_HH_v1", replace
****************************************
* END

















****************************************
* Variables
****************************************
use"panel_HH_v1", clear

* HH
encode HHID_panel, gen(panelvar)

* Village
encode villageid, gen(vill)

*Stem
gen stem=.
replace stem=0 if typeoffamily=="nuclear"
replace stem=1 if typeoffamily=="stem"
replace stem=1 if typeoffamily=="joint-stem"
label define stem 0"Nuclear" 1"Stem"
label values stem stem
ta stem typeoffamily

* Trap
gen dummygtrap=0
replace dummygtrap=1 if gtdr>0

gen dummyetrap=0
replace dummyetrap=1 if etdr>0

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
/*
by year to take into account the
increasing level of consumption
see ref on conspicuous consumption
*/
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
label var shareform "Share formal debt"
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


save"panel_v2", replace
****************************************
* END








****************************************
* Construction: clean
****************************************
use"panel_v2", clear


replace loanamount_HH=0 if loanamount_HH==.

foreach x in loanamount_HH annualincome_HH assets_total imp1_ds_tot_HH imp1_is_tot_HH totHH_givenamt_repa dsr isr dar dir expenses_total remreceived_HH remsent_HH remittnet_HH assets_gold goldquantity_HH goldreadyamount nbloans_HH {
egen `x'_std=std(`x')
}

*** Label
label var dar_std "DAR (std)"
label var dsr_std "DSR (std)"
label var isr_std "ISR (std)"
label var assets_total_std "Wealth (std)"
label var nbloans_HH_std "Nb loans (std)"


label var annualincome_HH_std "Annual income (std)"
label var loanamount_HH_std "Loan amount (std)"


*** Order
order HHID_panel year
sort HHID_panel year

*** Label
label var housetitle "House title: Yes"
label var head_female "Head sex: Female"


*** Dummyloans
gen dummyloans_HH=0
replace dummyloans_HH=1 if loanamount_HH!=. & loanamount_HH>0
label values dummyloans_HH yesno
ta dummyloans_HH year, col nofreq


*** Povery
tabstat annualincome_HH annualincome_HH_backup, stat(n mean) by(year)
gen annualincome_HH2=annualincome_HH_backup
replace annualincome_HH2=annualincome_HH2*(100/62.81) if year==2010
replace annualincome_HH2=annualincome_HH2*(100/114.95) if year==2020
replace annualincome_HH2=round(annualincome_HH2,1)
gen dailyincome_pc=(annualincome_HH2/365)/HHsize
gen dailyuspppdincome_pc=dailyincome_pc/20.65
drop annualincome_HH_backup annualincome_HH2 dailyincome_pc



save"panel_HH_v3", replace
****************************************
* END
