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
* Loan level
****************************************
use"panel_loans_v0", clear

merge m:1 HHID_panel INDID_panel year using "panel_indiv_v0", keepusing(caste sex livinghome)
drop if _merge==2
drop _merge

order HHID_panel INDID_panel year caste sex livinghome

ta livinghome year
drop if livinghome==3
drop if livinghome==4
drop livinghome

save"panel_loans_v1", replace
****************************************
* END











****************************************
* Indiv level
****************************************
use"panel_indiv_v0", clear

********** Debt

* Dummyloans
gen dummyloans_indiv=0
replace dummyloans_indiv=1 if lamount_indiv!=. & lamount_indiv>0
label values dummyloans_indiv yesno
ta dummyloans_indiv year, col nofreq

* Loan amount
replace lamount_indiv=0 if lamount_indiv==.
replace lamount_indiv=. if dummyloans_indiv==0

* DSR
gen dsr_indiv=(imp1_ds_tot_indiv*100)/annualincome_indiv
replace dsr_indiv=0 if dsr_indiv==.
replace dsr_indiv=. if dummyloans_indiv==0

* GTDR
gen gtdr_indiv=(lamountgivenrepa_indiv*100)/lamount_indiv
replace gtdr_indiv=0 if gtdr_indiv==.
replace gtdr_indiv=. if dummyloans_indiv==0

* GTIR
gen gtir_indiv=(lamountgivenrepa_indiv*100)/annualincome_indiv
replace gtir_indiv=0 if gtir_indiv==.
replace gtir_indiv=. if dummyloans_indiv==0

* GBTR
gen gbtdr_indiv=(lbalancegivenrepa_indiv*100)/lbalance_indiv
replace gbtdr_indiv=0 if gbtdr_indiv==.
replace gbtdr_indiv=. if dummyloans_indiv==0

* GBTIR
gen gbtir_indiv=(lbalancegivenrepa_indiv*100)/annualincome_indiv
replace gbtir_indiv=0 if gbtir_indiv==.
replace gbtir_indiv=. if dummyloans_indiv==0

* Share DSR
gen share_dsr=(imp1_ds_tot_indiv*100)/imp1_ds_tot_HH
replace share_dsr=0 if share_dsr==.
replace share_dsr=. if dummyloans_indiv==0

* Share given
gen share_giventrap=(lamountgivenrepa_indiv*100)/lamountgivenrepa_HH
replace share_giventrap=0 if share_giventrap==.
replace share_giventrap=. if dummyloans_indiv==0

ta share_giventrap

* Trap
gen dummytrap_indiv=0
replace dummytrap_indiv=1 if gtdr_indiv>0
replace dummytrap_indiv=. if dummyloans_indiv==0

ta dummytrap_indiv


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

* DAR
gen dar=(lamount_HH*100)/(assets_total1000*1000)
replace dar=0 if dar==.

* DIR
gen dir=(lamount_HH*100)/annualincome_HH
replace dir=0 if dir==.

* GTDR
ta lamountgivenrepa_HH
ta lamount_HH
gen gtdr_HH=(lamountgivenrepa_HH*100)/lamount_HH
replace gtdr_HH=0 if gtdr_HH==.

* GTIR
ta lamountgivenrepa_HH
ta annualincome_HH
replace annualincome_HH=annualincome_HH/1000
gen gtir_HH=(lamountgivenrepa_HH*100)/annualincome_HH
replace gtir_HH=0 if gtir_HH==.
ta gtir_HH
replace annualincome_HH=annualincome_HH*1000

* GBTR
gen gbtdr_HH=(lbalancegivenrepa_HH*100)/lbalance_HH
replace gbtdr_HH=0 if gbtdr_HH==.
ta gbtdr_HH


* GBTIR
replace annualincome_HH=annualincome_HH/1000
gen gbtir_HH=(lbalancegivenrepa_HH*100)/annualincome_HH
replace gbtir_HH=0 if gbtir_HH==.
ta gbtir_HH
tabstat gbtir_HH if dummytrap_HH==1, stat(n mean q) by(year) 
replace annualincome_HH=annualincome_HH*1000

* Trap
gen dummytrap_HH=0
replace dummytrap_HH=1 if gtdr_HH>0

* Loanamount
replace lamount_HH=0 if lamount_HH==.

* Dummyloans
gen dummyloans_HH=0
replace dummyloans_HH=1 if lamount_HH!=. & lamount_HH>0
label values dummyloans_HH yesno





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




















****************************************
* Indiv level : rename trap
****************************************
use"panel_indiv_v1", clear


********** Clean
drop nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH


********** Rename
* Indiv
rename lamount_indiv loanamount_indiv
rename lbalance_indiv loanbalance_indiv
rename lnb_indiv nbloan_indiv

rename lamountgivenrepa_indiv trapamount_indiv
rename lbalancegivenrepa_indiv balancetrapamount_indiv
rename lnbgivenrepa_indiv nbloantrap_indiv

rename lamounteffectiverepa_indiv eff_trapamount_indiv
rename lbalanceeffectiverepa_indiv eff_balancetrapamount_indiv
rename lnbeffectiverepa_indiv eff_nbloantrap_indiv

* HH
rename lamount_HH loanamount_HH
rename lbalance_HH loanbalance_HH
rename lnb_HH nbloan_HH
gen dummyloans_HH=.
replace dummyloans_HH=0 if nbloan_HH==0
replace dummyloans_HH=0 if nbloan_HH==.
replace dummyloans_HH=1 if nbloan_HH>0
ta dummyloans_HH year
drop dummyloans_HH

rename lamountgivenrepa_HH trapamount_HH
rename lbalancegivenrepa_HH balancetrapamount_HH
rename lnbgivenrepa_HH nbloantrap_HH

rename lamounteffectiverepa_HH eff_trapamount_HH
rename lbalanceeffectiverepa_HH eff_balancetrapamount_HH
rename lnbeffectiverepa_HH eff_nbloantrap_HH


********** 1k rupees
/*
foreach x in loanamount_indiv loanbalance_indiv trapamount_indiv balancetrapamount_indiv eff_trapamount_indiv eff_balancetrapamount_indiv {
replace `x'=`x'/1000
}

foreach x in loanamount_HH loanbalance_HH trapamount_HH balancetrapamount_HH eff_trapamount_HH eff_balancetrapamount_HH {
replace `x'=`x'/1000
}
*/
* Already done with the loan data



********** Order
order HHID_panel INDID_panel HHID INDID year 
sort HHID_panel INDID_panel year


save"panel_indiv_v2", replace
****************************************
* END















****************************************
* HH level : rename trap
****************************************
use"panel_HH_v1", clear



********** Rename
rename lamount_HH loanamount_HH
rename lbalance_HH loanbalance_HH
rename lnb_HH nbloan_HH

rename lamountgivenrepa_HH trapamount_HH
rename lbalancegivenrepa_HH balancetrapamount_HH
rename lnbgivenrepa_HH nbloantrap_HH

rename lamounteffectiverepa_HH eff_trapamount_HH
rename lbalanceeffectiverepa_HH eff_balancetrapamount_HH
rename lnbeffectiverepa_HH eff_nbloantrap_HH



********** 1k rupees
/*
foreach x in loanamount_HH loanbalance_HH trapamount_HH balancetrapamount_HH eff_trapamount_HH eff_balancetrapamount_HH {
replace `x'=`x'/1000
}
*/
* Already done with the loan data


********** Order
order HHID_panel HHID year 
sort HHID_panel year


save"panel_HH_v2", replace
****************************************
* END
