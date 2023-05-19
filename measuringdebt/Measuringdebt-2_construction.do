*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*November 19, 2022
*-----
gl link = "measuringdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\measuringdebt.do"
*-------------------------










****************************************
* Construction: debt
****************************************
use"panel_v0", clear

* DSR
tabstat imp1_ds_tot_HH annualincome_HH, stat(min p1 p5 p10 q p90 p95 p99 max)
gen dsr=imp1_ds_tot_HH/annualincome_HH
replace dsr=0 if dsr==.


* ISR
gen isr=imp1_is_tot_HH/annualincome_HH
replace isr=0 if isr==.


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

* TDR
gen tdr=totHH_givenamt_repa/loanamount_HH
replace tdr=0 if tdr==.


* TAR
gen tar=totHH_givenamt_repa/assets_total
replace tar=0 if tar==.


* AFM - Absolut Financial Margin
gen temp=1 if imp1_ds_tot_HH==.
recode imp1_ds_tot_HH (.=0)
gen afm=annualincome_HH+remittnet_HH+goldreadyamount-imp1_ds_tot_HH-expenses_total
replace imp1_ds_tot_HH=. if temp==1
drop temp


* RFM - Relative Financial Margin
gen rfm=afm/annualincome_HH

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
gen dailyusdincome_pc=dailyincome_pc/65.10
gen dailyuspppdincome_pc=dailyincome_pc/20.65
gen rrgpl=((dailyusdincome_pc-2.15)/2.15)*(-1)
gen rrgpl_ppp=((dailyuspppdincome_pc-2.15)/2.15)*(-1)

rename rrgpl rrgpl_tauxdechange
rename rrgpl_ppp rrgpl


save"panel_v1", replace
****************************************
* END

















****************************************
* Poverty and other
****************************************
use"panel_v1", clear

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
gen dummytrap=0
replace dummytrap=1 if tdr>0

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

foreach x in loanamount_HH annualincome_HH assets_total imp1_ds_tot_HH imp1_is_tot_HH totHH_givenamt_repa dsr isr dar dir tdr tar afm rfm expenses_total remreceived_HH remsent_HH remittnet_HH dailyincome_pc assets_gold goldquantity_HH goldreadyamount nbloans_HH lpc lapc {
egen `x'_std=std(`x')
}

*** Label
label var dar_std "DAR (std)"
label var dsr_std "DSR (std)"
label var afm_std "AFM (std)"
label var rfm_std "RFM (std)"
label var tdr_std "TDR (std)"
label var tar_std "TAR (std)"
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

*** Label
label var housetitle "House title: Yes"
label var head_female "Head sex: Female"



save"panel_v3", replace
****************************************
* END

















****************************************
* Construction: loan level database for descriptive stat
****************************************

*** RUME
use"raw/RUME-loans_mainloans_new.dta", replace

keep HHID2010 loanreasongiven loanlender loansettled loanamount lender_cat reason_cat lender4 dummyml loanamount2 loanbalance2 interestpaid2 totalrepaid2 principalpaid2

merge m:m HHID2010 using "raw/ODRIIS-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2010

save"RUME-loans.dta", replace




*** NEEMSIS1
use"raw/NEEMSIS1-loans_mainloans_new.dta", replace

ta loan_database
drop if loan_database=="MARRIAGE"
keep HHID2016 loanreasongiven loanlender loansettled loanamount lender_cat reason_cat lender4 dummyml loanamount2 loanbalance2 interestpaid2 totalrepaid2 principalpaid2

merge m:m HHID2016 using "raw/ODRIIS-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2016

save"NEEMSIS1-loans.dta", replace




*** NEEMSIS2
use"raw/NEEMSIS2-loans_mainloans_new.dta", replace

keep HHID2020 loanreasongiven loanlender loansettled loanamount lender_cat reason_cat lender4 dummyml loanamount2 loanbalance2 interestpaid2 totalrepaid2 principalpaid2

merge m:m HHID2020 using "raw/ODRIIS-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2020

save"NEEMSIS2-loans.dta", replace



*** Append
use"RUME-loans.dta", replace

append using "NEEMSIS1-loans"
append using "NEEMSIS2-loans"

gen test=loanamount-loanamount2
ta test
drop test loanamount

foreach x in loanamount loanbalance interestpaid totalrepaid principalpaid {
rename `x'2 `x'
}

drop HHID2010 HHID2016 HHID2020

order HHID_panel year loanamount loansettled loanreasongiven loanlender 


********** Selection of the 6 households
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV67" & year==2020
drop if HHID_panel=="GOV65" & year==2020

save"panel_loans", replace
****************************************
* END
