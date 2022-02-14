cls

/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
October 1, 2021
-----
Stability over time of personality traits: merging des bases
-----

-------------------------
*/


****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
set scheme plotplain

********** Path to folder "data" folder.
*** PC
global directory = "C:\Users\Arnaud\Documents\_Thesis\Research-Stability_skills\Analysis"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

*** Fac
*global directory = "C:\Users\anatal\Downloads\_Thesis\Research-Stability_skills\Analysis"
*cd "$directory"
*global git "C:\Users\anatal\Downloads\GitHub"

********** Name of the NEEMSIS2 questionnaire version to clean
global wave2 "NEEMSIS1-HH"
global wave3 "NEEMSIS2-HH"
****************************************
* END









****************************************
* PANEL
***************************************

global tokeep egoid name age sex edulevel jatis caste villageid  relationshiptohead maritalstatus year mainocc_kindofwork_indiv mainocc_occupation_indiv annualincome_indiv annualincome_HH assets aspirationminimumwage dummyaspirationmorehours aspirationminimumwage2

use"$directory\\$wave2", clear
keep HHID_panel INDID_panel $tokeep dummydemonetisation
foreach x in $tokeep dummydemonetisation {
rename `x' `x'_2016
}
save"$wave2-_tempego", replace

use"$directory\\$wave3", clear
keep HHID_panel INDID_panel $tokeep
foreach x in $tokeep {
rename `x' `x'_2020
}
save"$wave3-_tempego", replace



*Merge all
use"$directory\\$wave2-_tempego", clear
merge 1:1 HHID_panel INDID_panel using "$directory\\$wave3-_tempego"
rename _merge merge_1620
keep if egoid_2016>0 | egoid_2020>0
keep if year_2016==2016 & year_2020==2020
tab egoid_2016 egoid_2020
order HHID_panel INDID_panel name_2016 egoid_2016 name_2020 egoid_2020

tab egoid_2020


*One var
gen panel=0
replace panel=1 if year_2016!=. & egoid_2016!=0 & year_2020!=. & egoid_2020!=0
tab panel

save"panel", replace
****************************************
* END







****************************************
* PREPA 2016
****************************************
use "$wave2", clear
keep if egoid>0
egen HHINDID=concat(HHID_panel INDID_panel), p(/)
duplicates tag HHINDID, gen(tag)
tab tag
drop tag

*Merge
merge 1:1 HHID_panel INDID_panel using "panel", keepusing(panel)
drop if _merge==2
drop _merge
recode panel (.=0)

global tokeep egoid name age sex edulevel everattendedschool reasonneverattendedschool converseinenglish canread  jatis caste villageid  relationshiptohead maritalstatus year mainocc_kindofwork_indiv mainocc_occupation_indiv annualincome_indiv annualincome_HH assets house housetype electricity water toiletfacility noowntoilet readystartjob aspirationminimumwage dummyaspirationmorehours aspirationminimumwage2 nbercontactphone nberpersonfamilyevent contactlist dummycontactleaders contactleaders trustneighborhood trustemployees networkpeoplehelping networkhelpkinmember ///
dummydemonetisation demotrustneighborhood demotrustemployees_ego demotrustbank_ego demonetworkpeoplehelping_ego demonetworkhelpkinmember_ego demogeneralperception demogoodexpectations demobadexpectations ///
curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination organized makeplans workhard appointmentontime putoffduties easilydistracted completeduties enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople talkative expressingthoughts workwithother understandotherfeeling trustingofother rudetoother toleratefaults forgiveother helpfulwithothers managestress nervous changemood feeldepressed easilyupset worryalot staycalm tryhard stickwithgoals goaftergoal finishwhatbegin finishtasks keepworking cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking curious_backup interestedbyart_backup repetitivetasks_backup inventive_backup liketothink_backup newideas_backup activeimagination_backup organized_backup makeplans_backup workhard_backup appointmentontime_backup putoffduties_backup easilydistracted_backup completeduties_backup enjoypeople_backup sharefeelings_backup shywithpeople_backup enthusiastic_backup talktomanypeople_backup talkative_backup expressingthoughts_backup workwithother_backup understandotherfeeling_backup trustingofother_backup rudetoother_backup toleratefaults_backup forgiveother_backup helpfulwithothers_backup managestress_backup nervous_backup changemood_backup feeldepressed_backup easilyupset_backup worryalot_backup staycalm_backup tryhard_backup stickwithgoals_backup goaftergoal_backup finishwhatbegin_backup finishtasks_backup keepworking_backup ///
canread canreadcard1a canreadcard1b canreadcard1c canreadcard2 numeracy1 numeracy2 numeracy3 numeracy4 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 ab1 ab2 ab3 ab4 ab5 ab6 ab7 ab8 ab9 ab10 ab11 ab12 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 ///
ra1 rab1 rb1 ra2 rab2 rb2 ra3 rab3 rb3 ra4 rab4 rb4 ra5 rab5 rb5 ra6 rab6 rb6 ra7 rab7 rb7 ra8 rab8 rb8 ra9 rab9 rb9 ra10 rab10 rb10 ra11 rab11 rb11 ra12 rab12 rb12 set_a set_ab set_b raven_tt refuse num_tt lit_tt
keep HHINDID villageareaid villageid_new HHID_panel INDID_panel panel egoid year username $tokeep healthexpenses dummymarriage submissiondate

*** Username
replace username="Antoni" if username=="1"
replace username="Antoni - Vivek Radja" if username=="1 2"
replace username="Vivek Radja" if username=="2"
replace username="Vivek Radja - Mayan" if username=="2 5"
replace username="Vivek Radja - Raja Annamalai" if username=="2 6"
replace username="Kumaresh" if username=="3"
replace username="Kumaresh - Sithanantham" if username=="3 4"
replace username="Kumaresh - Raja Annamalai" if username=="3 6"
replace username="Sithanantham" if username=="4"
replace username="Sithanantham - Raja Annamalai" if username=="4 6"
replace username="Mayan" if username=="5"
replace username="Mayan - Raja Annamalai" if username=="5 6"
replace username="Raja Annamalai" if username=="6"
replace username="Raja Annamalai - Pazhani" if username=="6 7"
replace username="Pazhani" if username=="7"


order HHINDID HHID_panel INDID_panel
sort HHINDID

save"$wave2-_ego", replace
****************************************
* END










****************************************
* PREPA 2020
****************************************
use"$wave3", clear
keep if egoid>0
egen HHINDID=concat(HHID_panel INDID_panel), p(/)
duplicates tag HHINDID, gen(tag)
tab tag
drop tag

*Merge
merge 1:1 HHID_panel INDID_panel using "panel", keepusing(panel)
drop if _merge==2
drop _merge
recode panel (.=0)

global tokeep egoid name age sex edulevel everattendedschool reasonneverattendedschool converseinenglish canread  jatis caste villageid  relationshiptohead maritalstatus year mainocc_kindofwork_indiv mainocc_occupation_indiv annualincome_indiv annualincome_HH assets house housetype electricity water toiletfacility noowntoilet readystartjob aspirationminimumwage dummyaspirationmorehours aspirationminimumwage2 nbercontactphone nberpersonfamilyevent contactlist dummycontactleaders contactleaders networktrustneighborhood networktrustemployees networkpeoplehelping networkhelpkinmember ///
covsick covsellland covsubsistence ///
curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination organized makeplans workhard appointmentontime putoffduties easilydistracted completeduties enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople talkative expressingthoughts workwithother understandotherfeeling trustingofother rudetoother toleratefaults forgiveother helpfulwithothers managestress nervous changemood feeldepressed easilyupset worryalot staycalm tryhard stickwithgoals goaftergoal finishwhatbegin finishtasks keepworking cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking curious_backup interestedbyart_backup repetitivetasks_backup inventive_backup liketothink_backup newideas_backup activeimagination_backup organized_backup makeplans_backup workhard_backup appointmentontime_backup putoffduties_backup easilydistracted_backup completeduties_backup enjoypeople_backup sharefeelings_backup shywithpeople_backup enthusiastic_backup talktomanypeople_backup talkative_backup expressingthoughts_backup workwithother_backup understandotherfeeling_backup trustingofother_backup rudetoother_backup toleratefaults_backup forgiveother_backup helpfulwithothers_backup managestress_backup nervous_backup changemood_backup feeldepressed_backup easilyupset_backup worryalot_backup staycalm_backup tryhard_backup stickwithgoals_backup goaftergoal_backup finishwhatbegin_backup finishtasks_backup keepworking_backup ///
canread canreadcard1a canreadcard1b canreadcard1c canreadcard2 numeracy1 numeracy2 numeracy3 numeracy4 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 ab1 ab2 ab3 ab4 ab5 ab6 ab7 ab8 ab9 ab10 ab11 ab12 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 ///
ra1 rab1 rb1 ra2 rab2 rb2 ra3 rab3 rb3 ra4 rab4 rb4 ra5 rab5 rb5 ra6 rab6 rb6 ra7 rab7 rb7 ra8 rab8 rb8 ra9 rab9 rb9 ra10 rab10 rb10 ra11 rab11 rb11 ra12 rab12 rb12 set_a set_ab set_b raven_tt refuse num_tt lit_tt

keep HHINDID villageareaid HHID_panel INDID_panel panel egoid year username $tokeep dummymarriage healthexpenses

*** Cleaning
rename networktrustneighborhood trustneighborhood
rename networktrustemployees trustemployees
foreach x in house housetype electricity water toiletfacility noowntoilet {
destring `x', replace
}

***Username
rename username_str username
*fre username
*decode username, gen(username_str)
*fre username_str
*drop username
*rename username_str username



order HHINDID HHID_panel INDID_panel
sort HHINDID

save"$wave3-_ego", replace
****************************************
* END










****************************************
* Panel 2016 2020
****************************************
use"$wave2-_ego", clear


append using "$wave3-_ego"
tab panel

order HHINDID HHID_panel INDID_panel year egoid name sex age jatis caste edulevel villageid villageareaid villageid_new username panel

order curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination ///
organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties ///
enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts  ///
workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers ///
managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm ///
tryhard  stickwithgoals   goaftergoal finishwhatbegin finishtasks  keepworking, after(panel)

sort HHID_panel INDID_panel year

*Clean year
clonevar time=year
recode time (2016=1) (2020=2)
label define time 1"2016" 2"2020"
label values time time


*Clean username 2016
fre username


save"panel_stab_v1", replace
****************************************
* END
