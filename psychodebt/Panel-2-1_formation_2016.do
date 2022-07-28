cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
May 13, 2021
-----
Personality traits: EFA + panel
-----

-------------------------
*/

*ssc install catplot
*ssc install sencode

****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
********** Path to folder "data" folder.
global directory = "C:\Users\Arnaud\Documents\_Thesis\Research-Skills_and_debt\Analysis"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

set scheme plotplain 

*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
*set scheme plotplain

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"



********** Name of the NEEMSIS2 questionnaire version to clean
*global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH"
global wave3 "NEEMSIS2-HH"

global loan "NEEMSIS2-all_loans"
****************************************
* END







****************************************
* Panel
****************************************
use"$wave3", clear
gen year2020=2020
rename egoid egoid2020
keep HHID_panel INDID_panel egoid2020 year2020
save"$wave3~_temp", replace

use"$wave2", clear
gen year2016=2016
rename egoid egoid2016
keep HHID_panel INDID_panel egoid2016 year2016
merge 1:1 HHID_panel INDID_panel using "$wave3~_temp"
gen panel_indiv=0
replace panel_indiv=1 if _merge==3
drop _merge
save"panel_indiv", replace

****************************************
* END











****************************************
* EFA 2016
****************************************

********** 
use"$wave2", clear
merge 1:1 HHID_panel INDID_panel using "panel_indiv"

keep if panel_indiv==1
keep if egoid>0
keep if egoid2020>0

*keep if egoid!=0 & egoid!=.


********** Imputation for non corrected one
global big5cr cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking

foreach x in $big5cr{
gen im`x'=`x'
}


forvalues j=1(1)3{
forvalues i=1(1)2{
foreach x in $big5cr{
qui sum im`x' if sex==`i' & caste==`j' & egoid!=0 & egoid!=.
replace im`x'=r(mean) if im`x'==. & sex==`i' & caste==`j' & egoid!=0 & egoid!=.
}
}
}


global imcor imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm 


/*
********** Without grit
minap $imcor
factor $imcor, pcf fa(5) 
rotate, oblimin
putexcel set "EFA_2016.xlsx", modify sheet(imcor)
putexcel (E2)=matrix(e(r_L))
*/

********** Omega with Laajaj approach for factor analysis and Cobb Clark
** F1
global f1 imcr_easilyupset imcr_nervous imcr_worryalot imcr_feeldepressed imcr_changemood imcr_easilydistracted imcr_shywithpeople imcr_putoffduties imcr_rudetoother imcr_repetitivetasks
** F2
global f2 imcr_makeplans imcr_appointmentontime imcr_completeduties imcr_enthusiastic imcr_organized imcr_workhard imcr_workwithother
** F3
global f3 imcr_liketothink imcr_activeimagination imcr_expressingthoughts imcr_sharefeelings imcr_newideas imcr_inventive imcr_curious imcr_talktomanypeople imcr_talkative imcr_interestedbyart imcr_understandotherfeeling
** F4
global f4 imcr_staycalm imcr_managestress
** F5
global f5 imcr_forgiveother imcr_toleratefaults imcr_trustingofother imcr_enjoypeople imcr_helpfulwithothers

/*
*** Omega
omega $f1
omega $f2
omega $f3
alpha $f4
omega $f5
*/

*** Score
egen f1_2016=rowmean($f1)
egen f2_2016=rowmean($f2)
egen f3_2016=rowmean($f3)
egen f4_2016=rowmean($f4)
egen f5_2016=rowmean($f5)


keep $imcorwith HHID_panel INDID_panel f1_2016 f2_2016 f3_2016 f4_2016 f5_2016

save"$wave2~_ego.dta", replace
****************************************
* END













****************************************
* Prepa 2016
****************************************

********** 
use"$wave2", clear
*HH size
keep if livinghome==1 | livinghome==2
/*
drop if egoid==0
duplicates drop HHID_panel, force

2 HH without ego
*/
bysort HHID_panel: gen hhsize=_N

*
sum loanamount_indiv


*Nb children
gen child=0
replace child=1 if age<=14
bysort HHID_panel: egen nbchild=sum(child)

*Sex ratio
gen female=0
gen male=0
replace female=1 if sex==2
replace male=1 if sex==1
bysort HHID_panel: egen nbfemale=sum(female)
bysort HHID_panel: egen nbmale=sum(male)

*Savings
egen savingsamount_temp_HH=rowtotal(savingsamount1 savingsamount2 savingsamount3 savingsamount4)
bysort HHID_panel: egen savingsamount_HH=sum(savingsamount_temp_HH)

*Expenses
bysort HHID_panel: egen educationexpenses_HH=sum(educationexpenses)
egen productexpenses_HH=rowtotal(productexpenses_paddy productexpenses_ragi productexpenses_millets productexpenses_tapioca productexpenses_cotton productexpenses_sugarca productexpenses_savukku productexpenses_guava productexpenses_groundnut)
bysort HHID_panel: egen businessexpenses_HH=sum(businessexpenses)
gen foodexpenses_HH=foodexpenses*52
gen healthexpenses_HH=healthexpenses
gen ceremoniesexpenses_HH=ceremoniesexpenses
gen deathexpenses_HH=deathexpenses
egen livestockexpenses_HH=rowtotal(livestockspent_cow livestockspent_goat livestockspent_chicken livestockspent_bullock)

/*
*Chitfunds
egen chitfundpaymentamount_temp_HH=rowmean(chitfundpaymentamount1 chitfundpaymentamount2)
egen chitfundamount_temp_HH=rowmean(chitfundamount1 chitfundamount2)
egen chitfundamounttot_temp_HH=rowtotal(chitfundamount1 chitfundamount2)
bysort HHID_panel: egen chitfundpaymentamount_HH=mean(chitfundpaymentamount_temp_HH)
bysort HHID_panel: egen chitfundamount_HH=mean(chitfundamount_temp_HH)
bysort HHID_panel: egen chitfundamounttot_HH=sum(chitfundamounttot_temp_HH)
bysort HHID_panel: egen nbchitfunds_HH=sum(nbchitfunds)

*Lending
bysort HHID_panel: egen amountlent_HH=sum(amountlent)
bysort HHID_panel: egen interestlending_HH=mean(interestlending)
bysort HHID_panel: egen problemrepayment_HH=sum(problemrepayment)

*Gold
bysort HHID_panel: egen goldquantity_HH=sum(goldquantity)
bysort HHID_panel: egen goldquantitypledge_HH=sum(goldquantitypledge)

*Insurance
bysort HHID_panel: egen nbinsurance_HH=sum(nbinsurance)
egen insuranceamount=rowtotal(insuranceamount1 insuranceamount2)
egen insuranceamountm=rowmean(insuranceamount1 insuranceamount2)
bysort HHID_panel: egen insuranceamount_HH=mean(insuranceamountm)
bysort HHID_panel: egen insuranceamounttot_HH=sum(insuranceamount)
bysort HHID_panel: egen insurancebenefitamount_HH=mean(insurancebenefitamount)
bysort HHID_panel: egen insurancebenefitamounttot_HH=sum(insurancebenefitamount)
*/

*Land purchased as investment
tab landpurchased
tab landpurchasedacres
tab landpurchasedamount
tab landpurchasedhowbuy

*Equipment
foreach x in tractor bullockcart ploughmach {
gen investequip_`x'=.
}
foreach x in tractor bullockcart ploughmach {
replace investequip_`x'=equiowncost_`x' if equiownyear_`x'>=2010
}
egen investequiptot_HH=rowtotal(investequip_tractor investequip_bullockcart investequip_ploughmach)


*** Network :
* Asso
sort HHID_panel INDID_panel
fre associationlist
gen dummy_asso=0
replace dummy_asso=1 if associationlist!="" & associationlist!="13"
ta dummy_asso

* Chitfund
ta chitfundbelongerlist
split chitfundbelongerlist
destring chitfundbelongerlist1 chitfundbelongerlist2, replace
gen dummy_chit=0
replace dummy_chit=1 if chitfundbelongerlist1==INDID | chitfundbelongerlist2==INDID
ta dummy_chit

/*
* SHG
preserve
use "NEEMSIS1-loans_v4", clear
fre loanlender
gen dummy_shg=0
replace dummy_shg=1 if loanlender==10
bysort parent_key INDID: egen dummy_shg_tot=sum(dummy_shg)
drop dummy_shg
rename dummy_shg_tot dummy_shg
replace dummy_shg=1 if dummy_shg>1
keep parent_key INDID dummy_shg
duplicates drop
rename parent_key HHID2016
save "NEEMSIS1-shg", replace
restore

merge 1:1 HHID2016 INDID using "NEEMSIS1-shg"
drop if _merge==2
drop _merge
recode dummy_shg (.=0)


* Global asso
gen dummy_network=dummy_asso+dummy_chit+dummy_shg
order dummy_asso dummy_chit dummy_shg dummy_network, last
replace dummy_network=1 if dummy_network>1
ta dummy_network egoid
*/


*** Dependency ratio :
* Debt
gen debtor=0
replace debtor=1 if loanamount_indiv>0 & loanamount_indiv!=.
gen nondebtor=0
replace nondebtor=1 if debtor==0 & debtor!=.

* Worker
gen nonworker=0
replace nonworker=1 if worker==0 & worker!=.

* HH level
foreach x in debtor nondebtor worker nonworker {
bysort HHID_panel: egen `x'_HH=sum(`x')
}
gen debtorratio=debtor_HH/nondebtor_HH
clonevar debtorratio2=debtorratio
replace debtorratio2=debtor_HH if debtorratio==.

gen workerratio=worker_HH/nonworker_HH
clonevar workerratio2=workerratio
replace workerratio2=worker_HH if workerratio==.

preserve
duplicates drop HHID_panel, force
fre debtorratio debtorratio2
fre workerratio workerratio2
restore


*Only ego
fre egoid
drop if egoid==0


*Macro for rename
global charactindiv maritalstatus edulevel relationshiptohead sex age readystartjob methodfindjob jobpreference moveoutsideforjob moveoutsideforjobreason aspirationminimumwage dummyaspirationmorehours aspirationminimumwage2 name
 
global characthh villageid assets assets_noland sizeownland ownland house jatis caste dummymarriage hhsize nbchild nbfemale nbmale interviewplace address religion dummyeverhadland villageid_new dummydemonetisation

global wealthindiv annualincome_indiv totalincome_indiv mainocc_kindofwork_indiv mainocc_profession_indiv mainocc_occupation_indiv mainocc_annualincome_indiv nboccupation_indiv

global wealthhh annualincome_HH totalincome_HH nboccupation_HH foodexpenses healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses marriageexpenses businessexpenses

global debtindiv imp1_ds_tot_indiv imp1_is_tot_indiv loanamount_indiv loans_indiv debtor nondebtor worker nonworker

global debthh imp1_ds_tot_HH imp1_is_tot_HH loanamount_HH loans_HH debtorratio workerratio debtorratio2 workerratio2 debtor_HH nondebtor_HH worker_HH nonworker_HH

global perso cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit raven_tt num_tt lit_tt 

global expenses educationexpenses_HH productexpenses_HH businessexpenses_HH foodexpenses_HH healthexpenses_HH ceremoniesexpenses_HH deathexpenses_HH landpurchased investequiptot_HH 

global all $charactindiv $characthh $wealthindiv $wealthhh $debtindiv $debthh $perso $expenses nbercontactphone dummycontactleaders nbcontact_headbusiness nbcontact_policeman nbcontact_civilserv nbcontact_bankemployee nbcontact_panchayatcommittee nbcontact_peoplecouncil nbcontact_recruiter nbcontact_headunion nberpersonfamilyevent associationlist networkhelpkinmember demotrustbank_ego trustneighborhood trustemployees networkpeoplehelping trustingofother_backup

keep $all HHID_panel INDID_panel egoid //dummy_asso dummy_shg dummy_chit dummy_network

*merge m:1 HHID_panel using"$wave3~efa_ego.dta"
*drop _merge

*Rename
foreach x in $all {
rename `x' `x'_1
}

order HHID_panel INDID_panel

preserve
duplicates drop HHID_panel, force
tab caste_1
*Tous les HH ont un égo donc je suis censé en avoir plus car 485 HH en panel avec un peu de chance, 483 sinon minimum !
restore



********** Merge factor
merge 1:1 HHID_panel INDID_panel using "$wave2~_ego.dta"
keep if _merge==3
drop _merge

foreach x in f1 f2 f3 f4 f5 {
rename `x'_2016 `x'_1
}

gen indebt_indiv_1=0
replace indebt_indiv_1=1 if loanamount_indiv_1>0 & loanamount_indiv_1!=.

save"$wave2~panel", replace
****************************************
* END
