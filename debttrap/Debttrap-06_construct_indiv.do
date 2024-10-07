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
use"panel_indiv_v0", clear

* DSR
gen dsr_indiv=imp1_ds_tot_indiv/annualincome_indiv
replace dsr_indiv=0 if dsr_indiv==.

* GTDR
gen gtdr_indiv=totindiv_givenamt_repa/loanamount_indiv
replace gtdr_indiv=0 if gtdr_indiv==.

* ETDR
gen etdr_indiv=totindiv_effectiveamt_repa/loanamount_indiv
replace etdr_indiv=0 if etdr_indiv==.

* Share DSR
gen share_dsr=imp1_ds_tot_indiv/imp1_ds_tot_HH
replace share_dsr=0 if share_dsr==.

* Share GTDR
gen share_gtdr=totindiv_givenamt_repa/totHH_givenamt_repa
replace share_gtdr=0 if share_gtdr==.

* Share ETDR
gen share_etdr=totindiv_effectiveamt_repa/totHH_effectiveamt_repa
replace share_etdr=0 if share_etdr==.


save"panel_indiv_v1", replace
****************************************
* END














****************************************
* Explana
****************************************
use"panel_indiv_v1", clear

* panelvar
egen panelvar=group(HHID_panel INDID_panel)

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
gen dummygtrap_indiv=0
replace dummygtrap_indiv=1 if gtdr_indiv>0

gen dummyetrap_indiv=0
replace dummyetrap_indiv=1 if etdr_indiv>0


* Class
/*
by year to take into account the
increasing level of consumption
see ref on conspicuous consumption
*/
tabstat assets_total, stat(q) by(year)
foreach i in 2016 2020 {
xtile assets_`i'=assets_total if year==`i', n(3) 
}
gen assets_cat=.
replace assets_cat=assets_2016 if year==2016
replace assets_cat=assets_2020 if year==2020
drop assets_2016 assets_2020
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

* Drop head
drop head_*

save"panel_indiv_v2", replace
****************************************
* END











****************************************
* Construction: clean
****************************************
use"panel_indiv_v2", clear


replace loanamount_indiv=0 if loanamount_indiv==.


*** Label
label var housetitle "House title: Yes"


*** Dummyloans
gen dummyloans_indiv=0
replace dummyloans_indiv=1 if loanamount_indiv!=. & loanamount_indiv>0
label values dummyloans_indiv yesno
ta dummyloans_indiv year, col nofreq

*** Povery
tabstat annualincome_indiv annualincome_indiv_backup, stat(n mean) by(year)
gen annualincome_indiv2=annualincome_indiv_backup
replace annualincome_indiv2=annualincome_indiv2*(100/62.81) if year==2010
replace annualincome_indiv2=annualincome_indiv2*(100/114.95) if year==2020
replace annualincome_indiv2=round(annualincome_indiv2,1)
gen dailyincome=annualincome_indiv2/365
gen dailyuspppdincome=dailyincome/20.65
drop annualincome_indiv_backup annualincome_indiv2 dailyincome


* Selection, je garde que les majeurs
drop if age<18


save"panel_indiv_v3", replace
****************************************
* END

