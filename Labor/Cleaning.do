cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
24 avril 2021
-----
TITLE: Nettoyage

-------------------------
*/

global directory = "D:\Documents\_Thesis\Research-Labour_and_debt\Data"
cd "$directory"

global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH_v7"
global wave3 "NEEMSIS2-HH_v15"
global track "TRACKING1-HH_v2"


****************************************
* Test 2020
****************************************
use"$wave3", clear
fre livinghome
keep if livinghome==1 | livinghome==2
tab INDID_left

*HH size
bysort HHID_panel: egen HHsize=sum(1)
tab HHsize

*Nb child
bysort HHID_panel: egen nbchildren=sum(1) if age<16
recode nbchildren (.=0)
bysort HHID_panel: egen nbchild=max(nbchildren)
drop nbchildren
tab nbchild

*Own house
destring house, replace
gen ownhouse=0
replace ownhouse=1 if house==1

*Land
destring ownland, replace

foreach x in totalloanamount_indiv totalnumberloans_indiv totalloanbalance_indiv totalloanamount totalnumberloans totalloanbalance imp1_ds_tot imp1_is_tot loanamount_indiv IDR DSDR DSR ISR DSR_HH ISR_HH IDHDR InfoDR FoDR IncDR NoincDR PRdummy HSdummy ILdummy edulevel age sex caste jatis relationshiptohead villageid maritalstatus assets assets_noland dummymarriage HHsize nbchild ownhouse ownland totalincome_indiv totalincome_HH dummyremreceived mainoccupation_hours_indiv mainoccupation_income_indiv mainoccupation_indiv mainoccupationname_indiv mainoccupation_HH nboccupation_indiv nboccupation_HH {
rename `x' `x'_2020
}

keep HHID2010 HHID_panel INDID *_2020

save"$wave3~1.dta", replace
****************************************
* END













****************************************
* Test 2016
****************************************
use"$wave2", clear
fre livinghome
keep if livinghome==1 | livinghome==2

*HH size
bysort HHID_panel: egen HHsize=sum(1)
tab HHsize

*Nb child
bysort HHID_panel: egen nbchildren=sum(1) if age<16
recode nbchildren (.=0)
bysort HHID_panel: egen nbchild=max(nbchildren)
drop nbchildren
tab nbchild

*Own house
destring house, replace
gen ownhouse=0
replace ownhouse=1 if house==1

*Land
destring ownland, replace

foreach x in totalloanamount_indiv totalnumberloans_indiv totalloanbalance_indiv totalloanamount totalnumberloans totalloanbalance imp1_ds_tot imp1_is_tot loanamount_indiv IDR DSDR DSR ISR DSR_HH ISR_HH IDHDR InfoDR FoDR IncDR NoincDR PRdummy HSdummy ILdummy edulevel age sex caste jatis relationshiptohead villageid maritalstatus assets assets_noland dummymarriage HHsize nbchild ownhouse ownland totalincome_indiv totalincome_HH dummyremreceived mainoccupation_hours_indiv mainoccupation_income_indiv mainoccupation_indiv mainoccupationname_indiv mainoccupation_HH nboccupation_indiv nboccupation_HH {
rename `x' `x'_2020
}

keep HHID2010 HHID_panel INDID *_2020

save"$wave2~1.dta", replace
****************************************
* END













****************************************
* Test panel
****************************************
use"$wave3~1", clear

merge 1:1 HHID2010 INDID using "$wave2~1"
keep if _merge==3
drop _merge

save"paneltest.dta", replace



/*
We measure income mobility in absolute and relative terms. Absolute income mobility is measured by
the logged value of the difference of income between 2010 and 2016 (after controlling for inflation).
Relative income mobility is detected by a variable measuring the number of percentiles of mobility
(percentile rank change) that a worker experienced across the distribution of annual wages between the
2010 and 2016-2017 waves. The variable can take the values [-100; 100].
*/

****************************************
* END











****************************************
* Test tracking
****************************************
use"$track", clear
fre livinghome
keep if livinghome==1 | livinghome==2
tab INDID_left

*HH size
bysort HHID_panel: egen HHsize=sum(1)
tab HHsize

*Nb child
bysort HHID_panel: egen nbchildren=sum(1) if age<16
recode nbchildren (.=0)
bysort HHID_panel: egen nbchild=max(nbchildren)
drop nbchildren
tab nbchild

*Own house
destring house, replace
gen ownhouse=0
replace ownhouse=1 if house==1

*Land
destring ownland, replace

foreach x in totalloanamount_indiv totalnumberloans_indiv totalloanbalance_indiv totalloanamount totalnumberloans totalloanbalance imp1_ds_tot imp1_is_tot loanamount_indiv IDR DSDR DSR ISR DSR_HH ISR_HH IDHDR InfoDR FoDR IncDR NoincDR PRdummy HSdummy ILdummy edulevel age sex caste jatis relationshiptohead villageid maritalstatus assets assets_noland dummymarriage HHsize nbchild ownhouse ownland totalincome_indiv totalincome_HH dummyremreceived mainoccupation_hours_indiv mainoccupation_income_indiv mainoccupation_indiv mainoccupationname_indiv mainoccupation_HH nboccupation_indiv nboccupation_HH {
rename `x' `x'_2020
}

keep HHID2010 HHID_panel INDID *_2020

save"$wave3~1.dta", replace
****************************************
* END
