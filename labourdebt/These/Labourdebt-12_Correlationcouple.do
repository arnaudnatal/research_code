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
