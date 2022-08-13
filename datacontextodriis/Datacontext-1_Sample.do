*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*September 30, 2021
*-----
gl link = "datacontextodriis"
*Prepa database
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------









****************************************
* Copy + paste
****************************************
********** RUME
use"$datarume\\$wave1", clear
save"$directory\\$wave1", replace


********** NEEMSIS-1
use"$dataneemsis1\\$wave2", clear
save"$directory\\$wave2", replace

********** NEEMSIS-2
use"$dataneemsis2\\$wave3", clear
save"$directory\\$wave3", replace

********** ODRIIS HH and indiv
use"$datapanel\ODRIIS-HH.dta", clear
save"$directory\ODRIIS-HH.dta", replace

use"$datapanel\ODRIIS-indiv_jatis.dta", clear
save"$directory\ODRIIS-indiv.dta", replace





****************************************
* END









****************************************
* Sample
****************************************

********** RUME
use"$directory\\$wave1", clear
duplicates drop HHID_panel, force
ta villageid



********** NEEMSIS-1
use"$directory\\$wave2", clear
ta egoid sex if egoid!=0
duplicates drop HHID_panel, force
ta villageid
ta villageid_new

***** Clubbing
clonevar villageid_new2=villageid_new
replace villageid_new2="TIRUP_reg" if villageid_new=="Somanur" | villageid_new=="Tiruppur" | villageid_new=="Chinnaputhur"
fre villageid_new2

ta villageid villageid_new if tracked==1


********** NEEMSIS-2
use"$directory\\$wave3", clear
ta egoid sex if egoid!=0
duplicates drop HHID_panel, force
ta villageid

****************************************
* END









****************************************
* Individual level stat
****************************************

********** RUME
use"$directory\\$wave1", clear

fre working_pop
drop if working_pop==1
fre worker

ta sex
ta mainocc_occupation_indiv sex, col nofreq
ta edulevel sex, col nofreq



********** NEEMSIS-1
use"$directory\\$wave2", clear
fre livinghome
drop if livinghome==3
drop if livinghome==4

fre working_pop
drop if working_pop==1
fre worker

ta sex
ta mainocc_occupation_indiv sex, col nofreq
ta edulevel sex, col nofreq


********** NEEMSIS-2
use"$directory\\$wave3", clear

fre livinghome
drop if livinghome==3
drop if livinghome==4
drop if INDID_left!=.

fre working_pop
drop if working_pop==1
fre worker

ta sex
ta mainocc_occupation_indiv sex, col nofreq
ta edulevel sex, col nofreq

****************************************
* END









****************************************
* Household level: RUME
****************************************
use"$directory\\$wave1", clear

bysort HHID_panel : egen HHsize=sum(1)

gen head=1 if relationshiptohead==1
bysort HHID_panel: egen sum_head=sum(head)
ta HHID_panel if sum_head>1
list HHID_panel INDID_panel name age sex relationshiptohead caste jatis if HHID_panel=="GOV18", clean noobs

gen caste_head=caste if relationshiptohead==1
replace caste_head=. if HHID_panel=="GOV18" & INDID_panel=="Ind_1"
ta caste_head
bysort HHID_panel: egen caste_HH=max(caste_head)

fre sex
gen male=0
replace male=1 if sex==1
gen female=0
replace female=1 if sex==2
bysort HHID_panel: egen nbmale=sum(male)
bysort HHID_panel: egen nbfemale=sum(female)
gen SR=nbmale/nbfemale
replace SR=nbmale if nbfemale==0

fre working_pop
gen actif=0
replace actif=1 if working_pop==2
replace actif=1 if working_pop==3
gen nonactif=0
replace nonactif=1 if working_pop==1
bysort HHID_panel: egen nbactif=sum(actif)
bysort HHID_panel: egen nbnonactif=sum(nonactif)
gen DR=nbnonactif/nbactif
ta DR

keep HHID_panel caste_HH villageid HHsize ownland leaseland sizeownland assets_noland assets annualincome_HH nboccupation_HH occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega loanamount_HH loans_HH SR DR housetype
duplicates drop HHID_panel, force
replace assets=assets/1000
replace assets_noland=assets_noland/1000
replace annualincome_HH=annualincome_HH/1000
recode ownland (.=0)

***** Tables
tabstat HHsize SR DR, stat(mean) by(caste)
ta housetype caste, col nofreq
ta ownland caste, col nofreq
tabstat sizeownland if ownland==1, stat(n mean sd p50) by(caste)
tabstat assets_noland annualincome_HH, stat(n mean sd p50) by(caste)

****************************************
* END








****************************************
* Household level: NEEMSIS-1
****************************************
use"$directory\\$wave2", clear
fre livinghome
drop if livinghome==3
drop if livinghome==4

bysort HHID_panel : egen HHsize=sum(1)

gen head=1 if relationshiptohead==1
bysort HHID_panel: egen sum_head=sum(head)
ta HHID_panel if sum_head>1
list HHID_panel INDID_panel name age sex relationshiptohead caste jatis if HHID_panel=="KUV36" | HHID_panel=="SEM29", clean noobs
ta HHID_panel if sum_head<1
list HHID_panel INDID_panel name age sex relationshiptohead caste jatis if HHID_panel=="ELA35" | HHID_panel=="ELA41" | HHID_panel=="GOV31" | HHID_panel=="KOR12" | HHID_panel=="KOR15" | HHID_panel=="KOR41" | HHID_panel=="KUV23" | HHID_panel=="9" | HHID_panel=="MAN3" | HHID_panel=="MAN45" | HHID_panel=="NAT12" | HHID_panel=="NAT24" | HHID_panel=="NAT39" | HHID_panel=="ORA14" | HHID_panel=="ORA25" | HHID_panel=="SEM44" | HHID_panel=="KUV9" | HHID_panel=="MAN3", clean noobs

gen caste_head=caste if relationshiptohead==1
replace caste_head=. if HHID_panel=="KUV36" & INDID_panel=="Ind_5"
replace caste_head=. if HHID_panel=="SEM29" & INDID_panel=="Ind_1"

replace caste_head=1 if HHID_panel=="ELA35" & INDID_panel=="Ind_2"
replace caste_head=1 if HHID_panel=="ELA41" & INDID_panel=="Ind_2"
replace caste_head=3 if HHID_panel=="GOV31" & INDID_panel=="Ind_2"
replace caste_head=2 if HHID_panel=="KOR12" & INDID_panel=="Ind_2"
replace caste_head=1 if HHID_panel=="KOR15" & INDID_panel=="Ind_2"
replace caste_head=1 if HHID_panel=="KOR41" & INDID_panel=="Ind_2"
replace caste_head=2 if HHID_panel=="KUV23" & INDID_panel=="Ind_2"
replace caste_head=1 if HHID_panel=="KUV9" & INDID_panel=="Ind_2"
replace caste_head=1 if HHID_panel=="MAN3" & INDID_panel=="Ind_2"
replace caste_head=2 if HHID_panel=="MAN45" & INDID_panel=="Ind_2"
replace caste_head=3 if HHID_panel=="NAT12" & INDID_panel=="Ind_2"
replace caste_head=2 if HHID_panel=="NAT24" & INDID_panel=="Ind_2"
replace caste_head=3 if HHID_panel=="NAT39" & INDID_panel=="Ind_2"
replace caste_head=2 if HHID_panel=="ORA14" & INDID_panel=="Ind_2"
replace caste_head=2 if HHID_panel=="ORA25" & INDID_panel=="Ind_3"
replace caste_head=3 if HHID_panel=="SEM44" & INDID_panel=="Ind_2"
ta caste_head
bysort HHID_panel: egen caste_HH=max(caste_head)
ta HHID_panel if caste_HH==.

fre sex
gen male=0
replace male=1 if sex==1
gen female=0
replace female=1 if sex==2
bysort HHID_panel: egen nbmale=sum(male)
bysort HHID_panel: egen nbfemale=sum(female)
gen SR=nbmale/nbfemale
replace SR=nbmale if nbfemale==0

fre working_pop
gen actif=0
replace actif=1 if working_pop==2
replace actif=1 if working_pop==3
gen nonactif=0
replace nonactif=1 if working_pop==1
bysort HHID_panel: egen nbactif=sum(actif)
bysort HHID_panel: egen nbnonactif=sum(nonactif)
gen DR=nbnonactif/nbactif
ta DR

keep HHID_panel caste_HH villageid HHsize ownland leaseland sizeownland assets_noland assets annualincome_HH nboccupation_HH occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega loanamount_HH loans_HH SR DR housetype
duplicates drop HHID_panel, force
replace assets=(assets/1000)*(100/158)
replace assets_noland=(assets_noland/1000)*(100/158)
replace annualincome_HH=(annualincome_HH/1000)*(100/158)
recode ownland (.=0)

***** Tables
tabstat HHsize SR DR, stat(mean) by(caste)
ta housetype caste, col nofreq
ta ownland caste, col nofreq
tabstat sizeownland if ownland==1, stat(n mean sd p50) by(caste)
tabstat assets_noland annualincome_HH, stat(n mean sd p50) by(caste)
****************************************
* END







****************************************
* Household level: NEEMSIS-1
****************************************
use"$directory\\$wave3", clear
fre livinghome
drop if livinghome==3
drop if livinghome==4
drop if INDID_left!=.


****************************************
* END
