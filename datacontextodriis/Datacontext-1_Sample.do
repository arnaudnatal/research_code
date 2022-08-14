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
use"$datapanel\ODRIIS-HH_long.dta", clear
save"$directory\ODRIIS-HH_long.dta", replace

use"$datapanel\ODRIIS-indiv_long.dta", clear
save"$directory\ODRIIS-indiv_long.dta", replace



********** Caste new var
use"$directory\ODRIIS-HH_long.dta", clear
use"$directory\ODRIIS-indiv_long.dta", clear

use"$directory\\$wave1", clear
merge m:1 HHID_panel year using "$directory\ODRIIS-HH_long.dta", keepusing(castecorr)
keep if _merge==3
drop _merge
rename castecorr castecorr_HH
merge 1:1 HHID_panel INDID_panel year using "$directory\ODRIIS-indiv_long.dta", keepusing(castecorr jatiscorr agecorr)
keep if _merge==3
drop _merge
save"$directory\\$wave1~v2", replace

use"$directory\\$wave2", clear
merge m:1 HHID_panel year using "$directory\ODRIIS-HH_long.dta", keepusing(castecorr)
keep if _merge==3
drop _merge
rename castecorr castecorr_HH
merge 1:1 HHID_panel INDID_panel year using "$directory\ODRIIS-indiv_long.dta", keepusing(castecorr jatiscorr agecorr)
keep if _merge==3
drop _merge
save"$directory\\$wave2~v2", replace

use"$directory\\$wave3", clear
merge m:1 HHID_panel year using "$directory\ODRIIS-HH_long.dta", keepusing(castecorr)
keep if _merge==3
drop _merge
rename castecorr castecorr_HH
merge 1:1 HHID_panel INDID_panel year using "$directory\ODRIIS-indiv_long.dta", keepusing(castecorr jatiscorr agecorr)
keep if _merge==3
drop _merge
save"$directory\\$wave3~v2", replace

****************************************
* END









****************************************
* Sample
****************************************

********** RUME
use"$directory\\$wave1~v2", clear
duplicates drop HHID_panel, force
ta villageid



********** NEEMSIS-1
use"$directory\\$wave2~v2", clear
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
use"$directory\\$wave3~v2", clear
ta egoid sex if egoid!=0
duplicates drop HHID_panel, force
ta villageid

****************************************
* END









****************************************
* Individual level stat
****************************************

********** RUME
use"$directory\\$wave1~v2", clear

fre working_pop
drop if working_pop==1
fre worker

ta sex
ta mainocc_occupation_indiv sex, col nofreq
ta edulevel sex, col nofreq



********** NEEMSIS-1
use"$directory\\$wave2~v2", clear
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
use"$directory\\$wave3~v2", clear

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
use"$directory\\$wave1~v2", clear

bysort HHID_panel : egen HHsize=sum(1)

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

keep HHID_panel castecorr_HH villageid HHsize ownland leaseland sizeownland assets_noland assets annualincome_HH nboccupation_HH occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega loanamount_HH loans_HH SR DR housetype
duplicates drop HHID_panel, force
replace assets=assets/1000
replace assets_noland=assets_noland/1000
replace annualincome_HH=annualincome_HH/1000
recode ownland (.=0)

merge 1:1 HHID_panel using "$directory\wave1_checkcastewithnewcleaning.dta"

***** Tables
cls
ta castecorr_HH
tabstat HHsize SR DR, stat(mean) by(castecorr_HH)
ta housetype castecorr_HH, col nofreq
ta ownland castecorr_HH, col nofreq
tabstat sizeownland if ownland==1, stat(n mean sd p50) by(castecorr_HH)
tabstat assets_noland annualincome_HH, stat(n mean sd p50) by(castecorr_HH)

tabstat assets_noland annualincome_HH, stat(n mean sd p50) by(caste)
****************************************
* END








****************************************
* Household level: NEEMSIS-1
****************************************
use"$directory\\$wave2~v2", clear
fre livinghome
drop if livinghome==3
drop if livinghome==4

bysort HHID_panel : egen HHsize=sum(1)

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

keep HHID_panel castecorr_HH villageid HHsize ownland leaseland sizeownland assets_noland assets annualincome_HH nboccupation_HH occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega loanamount_HH loans_HH SR DR housetype
duplicates drop HHID_panel, force
replace assets=(assets/1000)*(100/158)
replace assets_noland=(assets_noland/1000)*(100/158)
replace annualincome_HH=(annualincome_HH/1000)*(100/158)
recode ownland (.=0)

merge 1:1 HHID_panel using "$directory\wave2_checkcastewithnewcleaning.dta"

***** Tables
cls
ta castecorr_HH
tabstat HHsize SR DR, stat(mean) by(castecorr_HH)
ta housetype castecorr_HH, col nofreq
ta ownland castecorr_HH, col nofreq
tabstat sizeownland if ownland==1, stat(n mean sd p50) by(castecorr_HH)
tabstat assets_noland annualincome_HH, stat(n mean sd p50) by(castecorr_HH)

tabstat assets_noland annualincome_HH, stat(n mean sd p50) by(caste)
****************************************
* END







****************************************
* Household level: NEEMSIS-2
****************************************
use"$directory\\$wave3~v2", clear
fre livinghome
drop if livinghome==3
drop if livinghome==4
drop if INDID_left!=.

bysort HHID_panel : egen HHsize=sum(1)

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

keep HHID_panel castecorr_HH villageid HHsize ownland leaseland sizeownland assets_noland assets annualincome_HH nboccupation_HH occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega loanamount_HH loans_HH SR DR housetype freehousescheme
duplicates drop HHID_panel, force
replace assets=(assets/1000)*(100/184)
replace assets_noland=(assets_noland/1000)*(100/184)
replace annualincome_HH=(annualincome_HH/1000)*(100/184)
destring ownland, replace
recode ownland (.=0)
destring housetype, replace
recode housetype (2=3)
replace housetype=2 if freehousescheme==1

***** Tables
cls
ta castecorr_HH
tabstat HHsize SR DR, stat(mean) by(castecorr_HH)
ta housetype castecorr_HH, col nofreq
ta ownland castecorr_HH, col nofreq
tabstat sizeownland if ownland==1, stat(n mean sd p50) by(castecorr_HH)
tabstat assets_noland annualincome_HH, stat(n mean sd p50) by(castecorr_HH)

****************************************
* END
