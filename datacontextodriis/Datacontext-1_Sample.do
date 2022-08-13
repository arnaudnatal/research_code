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




use"$directory\\$wave2", clear
keep HHID_panel INDID_panel sex caste egoid year
foreach x in sex caste egoid year {
rename `x' `x'2016
}
merge 1:1 HHID_panel INDID_panel using "$directory\\$wave3", keepusing(sex caste egoid year)

drop if egoid==0
drop if egoid2016==0

ta sex sex2016



****************************************
* MOC of individuals
****************************************

********** RUME
use"$directory\\$wave1", clear
ta worker
ta working_pop
ta working_pop worker
ta mainocc_occupation_indiv if working_pop==3
ta mainocc_occupation_indiv sex if working_pop==3, col nofreq
ta mainocc_occupation_indiv caste if working_pop==3, col nofreq



********** NEEMSIS-1
use"$directory\\$wave2", clear
ta worker
ta working_pop
ta working_pop worker
ta mainocc_occupation_indiv if working_pop==3
ta mainocc_occupation_indiv sex if working_pop==3, col nofreq
ta mainocc_occupation_indiv caste if working_pop==3, col nofreq


********** NEEMSIS-2
use"$directory\\$wave3", clear
ta worker
ta working_pop
ta working_pop worker
ta mainocc_occupation_indiv if working_pop==3 & mainocc_occupation_indiv!=0
ta mainocc_occupation_indiv sex if working_pop==3 & mainocc_occupation_indiv!=0, col nofreq
ta mainocc_occupation_indiv caste if working_pop==3 & mainocc_occupation_indiv!=0, col nofreq


***** Check in occupation database
/*
use"$dataneemsis2\\$occup3", clear
keep if caste==3
drop if occupationname==""
ta occupation
tabstat hoursayear, stat(n mean sd p50) by(occupation)

bysort HHID_panel INDID_panel: egen max_hoursayear=max(hoursayear)
keep if hoursayear==maxhoursayear
duplicates tag HHID_panel INDID_panel, gen(tag)
fre occupation
ta occupationname if occupation==3
ta profession if occupation==3
ta sector if occupation==3
ta salariedjobtype if occupation==3
*/


****************************************
* END
