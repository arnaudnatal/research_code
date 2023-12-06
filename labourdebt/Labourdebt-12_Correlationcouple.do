*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*December 5, 2023
*-----
gl link = "labourdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------






****************************************
* 2010 at individual level
****************************************
use"raw/RUME-occup_indiv", clear

* Merge sex, age
merge 1:1 HHID2010 INDID2010 using "raw/RUME-HH", keepusing(name sex age relationshiptohead)
drop _merge

* Selection 
keep HHID2010 INDID2010 sex age name relationshiptohead mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv nboccupation_indiv working_pop annualincome_indiv incomeagri_indiv incomenonagri_indiv

* Merge panel
merge m:m HHID2010 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2010, replace
merge 1:m HHID_panel INDID2010 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Year
gen year=2010

* Order
order HHID_panel INDID_panel HHID2010 INDID2010 year name age sex relationshiptohead working_pop

drop HHID2010 INDID2010

save "occ2010", replace
****************************************
* END








****************************************
* 2016-17 at individual level
****************************************
use"raw/NEEMSIS1-occup_indiv", clear

* Merge sex, age
merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-HH", keepusing(name sex age relationshiptohead livinghome)
drop _merge

* Selection 
fre livinghome
drop if livinghome==3
drop if livinghome==4
drop livinghome

keep HHID2016 INDID2016 sex age name relationshiptohead mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv nboccupation_indiv mainocc_hoursayear_indiv working_pop hoursayear_indiv hoursayearagri_indiv hoursayearnonagri_indiv annualincome_indiv incomeagri_indiv incomenonagri_indiv


* Merge panel
merge m:m HHID2016 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2016, replace
merge 1:m HHID_panel INDID2016 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Year
gen year=2016

* Order
order HHID_panel INDID_panel HHID2016 INDID2016 year name age sex relationshiptohead working_pop

drop HHID2016 INDID2016

save "occ2016", replace
****************************************
* END











****************************************
* 2020-21 at individual level
****************************************
use"raw/NEEMSIS2-occup_indiv", clear

* Merge sex, age
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-HH", keepusing(name sex age relationshiptohead livinghome dummylefthousehold)
drop _merge

* Selection
drop if dummylefthousehold==1
fre livinghome
drop if livinghome==3
drop if livinghome==4
drop dummylefthousehold livinghome

keep HHID2020 INDID2020 sex age name relationshiptohead mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv nboccupation_indiv mainocc_hoursayear_indiv working_pop hoursayear_indiv hoursayearagri_indiv hoursayearnonagri_indiv annualincome_indiv incomeagri_indiv incomenonagri_indiv

* Merge panel
merge m:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge 1:m HHID_panel INDID2020 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Year
gen year=2020

* Order
order HHID_panel INDID_panel HHID2020 INDID2020 year name age sex relationshiptohead working_pop

drop HHID2020 INDID2020

save "occ2020", replace
****************************************
* END












****************************************
* Append indiv database
****************************************
use"occ2010", clear

append using "occ2016"
append using "occ2020"

* Merge caste
merge m:m HHID_panel year using "raw/Panel-Caste_HH_long", keepusing(jatiscorr caste)
drop _merge

order jatiscorr caste, after(relationshiptohead)
label define caste 1"Dalits" 2"Middle castes" 3"Upper castes", replace
label values caste caste


save"occindiv", replace
****************************************
* END







****************************************
* ID by couple
****************************************
use"occindiv", clear

* Removing those who cannot be in a couple
fre relationshiptohead
drop if relationshiptohead==9
drop if relationshiptohead==12
drop if relationshiptohead==13
drop if relationshiptohead==14
drop if relationshiptohead==15
drop if relationshiptohead==16
drop if relationshiptohead==17
drop if relationshiptohead==77

* Creating groups of couples
fre relationshiptohead
gen couplegrp=.
replace couplegrp=1 if relationshiptohead==1
replace couplegrp=1 if relationshiptohead==2
replace couplegrp=2 if relationshiptohead==3
replace couplegrp=2 if relationshiptohead==4
replace couplegrp=3 if relationshiptohead==5
replace couplegrp=3 if relationshiptohead==7
replace couplegrp=4 if relationshiptohead==6
replace couplegrp=4 if relationshiptohead==8
replace couplegrp=5 if relationshiptohead==10
replace couplegrp=5 if relationshiptohead==11


* Identify the partners in each group
fre relationshiptohead
gen partner=.
replace partner=1 if relationshiptohead==1
replace partner=2 if relationshiptohead==2
replace partner=1 if relationshiptohead==3
replace partner=2 if relationshiptohead==4
replace partner=1 if relationshiptohead==5
replace partner=2 if relationshiptohead==7
replace partner=1 if relationshiptohead==6
replace partner=2 if relationshiptohead==8
replace partner=1 if relationshiptohead==10
replace partner=2 if relationshiptohead==11

save"panel_couple", replace
****************************************
* END









****************************************
* Reshape by couple
****************************************
use"panel_couple", clear

* Check duplicates for sons and daughters
fre relationshiptohead
ta relationshiptohead, gen(rela)
forvalues i=1/10 {
bysort HHID_panel year: egen sum_rela`i'=sum(rela`i')
drop rela`i'
}

tab1 sum_rela1 sum_rela2 sum_rela3 sum_rela4 sum_rela5 sum_rela6 sum_rela7 sum_rela8 sum_rela9 sum_rela10
drop sum_rela1 sum_rela2 sum_rela3 sum_rela4 sum_rela5 sum_rela6 sum_rela7 sum_rela8 sum_rela9 sum_rela10

/*
There are too many sons and daughters in each household to re-couple so quickly, so I'm only keeping the chef.
*/

keep if relationshiptohead==1 | relationshiptohead==2
drop couplegrp partner

* Check duplicates head
ta relationshiptohead, gen(rela)
forvalues i=1/2 {
bysort HHID_panel year: egen sum_rela`i'=sum(rela`i')
drop rela`i'
}

tab1 sum_rela1 sum_rela2
preserve
keep if sum_rela1==2 | sum_rela2==2
sort HHID_panel year
restore

drop if sum_rela1==2 
drop if sum_rela2==2
drop if sum_rela1==0 
drop if sum_rela2==0
drop sum_rela*
/*
I've decided to delete the ones with duplicates to go faster, but I'll have to look into this further next time.
I also delete those for which there is no partner.
*/

* Reshape
reshape wide INDID_panel name age sex jatiscorr caste working_pop mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv nboccupation_indiv incomeagri_indiv incomenonagri_indiv hoursayear_indiv mainocc_hoursayear_indiv hoursayearagri_indiv hoursayearnonagri_indiv, i(HHID_panel year) j(relationshiptohead)

ta year

save"panel_couple_wide", replace
****************************************
* END










****************************************
* Stat by sex
****************************************
save"occindiv", replace


ta mainocc_occupation_indiv year, col nofreq



****************************************
* END













****************************************
* Stat by couple
****************************************
use"panel_couple_wide", clear

********** Demographic characteristics
ta sex1 sex2
corr age1 age2
ta caste1 caste2



********* Labour characteristics
* Decision to work
ta working_pop1 working_pop2, chi2

* Main occupation
ta mainocc_occupation_indiv1 mainocc_occupation_indiv2, chi2 exp cchi2

* Nb of occupation
corr nboccupation_indiv1 nboccupation_indiv2

* Labour supply
corr hoursayear_indiv1 hoursayear_indiv2
corr hoursayearagri_indiv1 hoursayearagri_indiv2
corr hoursayearnonagri_indiv1 hoursayearnonagri_indiv2

* Income
corr annualincome_indiv1 annualincome_indiv2

****************************************
* END
