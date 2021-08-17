cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
August 17, 2021
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
********** Path to folder "data" folder.
global directory = "D:\Documents\_Thesis\Research-Stability_skills\Analysis"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
set scheme plotplain, perm

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH_v7"
global wave3 "NEEMSIS2-HH_v17"
****************************************
* END




****************************************
* PANEL
***************************************
use"C:\Users\Arnaud\Dropbox\RUME-NEEMSIS\RUME\RUME-HH_v8", clear
save"$wave1", replace
duplicates drop HHID_panel, force
keep HHID_panel year
rename year year2010
save"$wave1~hh", replace

use"C:\Users\Arnaud\Dropbox\RUME-NEEMSIS\NEEMSIS1\NEEMSIS1-HH_v7", clear
save"$wave2", replace
duplicates drop HHID_panel, force
keep HHID_panel year
rename year year2016
save"$wave2~hh", replace

use"C:\Users\Arnaud\Dropbox\RUME-NEEMSIS\NEEMSIS2\NEEMSIS2-HH_v17", clear
save"$wave3", replace
duplicates drop HHID_panel, force
duplicates drop HHID_panel, force
keep HHID_panel year
rename year year2020
save"$wave3~hh", replace

*Merge all
use"$wave1~hh", clear
merge 1:1 HHID_panel using "$wave2~hh"
rename _merge merge_1016
merge 1:1 HHID_panel using "$wave3~hh"
rename _merge merge_101620

*One var
gen panel=0
replace panel=2 if year2016!=. & year2020!=.
replace panel=1 if year2010!=. & year2016!=. & year2020!=.
tab panel

keep HHID_panel year2010 year2016 year2020 panel

foreach x in 2010 2016 2020{
recode year`x' (.=0) (`x'=1)
}

cls
tab year2010
tab year2016
tab year2020
tab year2010 year2016
tab year2010 year2020  // 392 en panel 2010-2020
tab year2016 year2020   // 485 en panel 2016-2020

tab year2016 year2020 if year2010==0
tab year2016 year2020 if year2010==1

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
global torename submissiondate username edulevel classcompleted relationshiptohead maritalstatus egoid everattendedschool canread converseinenglish mainoccupation_hours_indiv mainoccupation_income_indiv mainoccupation_indiv mainoccupationname_indiv enjoypeople curious organized managestress interestedbyart tryhard workwithother makeplans sharefeelings nervous stickwithgoals repetitivetasks shywithpeople workhard changemood understandotherfeeling inventive enthusiastic feeldepressed appointmentontime goaftergoal easilyupset talktomanypeople liketothink finishwhatbegin putoffduties rudetoother finishtasks toleratefaults worryalot easilydistracted keepworking completeduties talkative newideas staycalm forgiveother activeimagination expressingthoughts helpfulwithothers canreadcard1a canreadcard1b canreadcard1c canreadcard2 numeracy1 numeracy2 numeracy3 numeracy4 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 ab1 ab2 ab3 ab4 ab5 ab6 ab7 ab8 ab9 ab10 ab11 ab12 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 ra1 rab1 rb1 ra2 rab2 rb2 ra3 rab3 rb3 ra4 rab4 rb4 ra5 rab5 rb5 ra6 rab6 rb6 ra7 rab7 rb7 ra8 rab8 rb8 ra9 rab9 rb9 ra10 rab10 rb10 ra11 rab11 rb11 ra12 rab12 rb12 set_a set_ab set_b raven_tt refuse num_tt lit_tt curious_old interestedbyart_old repetitivetasks_old inventive_old liketothink_old newideas_old activeimagination_old organized_old makeplans_old workhard_old appointmentontime_old putoffduties_old easilydistracted_old completeduties_old enjoypeople_old sharefeelings_old shywithpeople_old enthusiastic_old talktomanypeople_old talkative_old expressingthoughts_old workwithother_old understandotherfeeling_old trustingofother_old rudetoother_old toleratefaults_old forgiveother_old helpfulwithothers_old managestress_old nervous_old changemood_old feeldepressed_old easilyupset_old worryalot_old staycalm_old tryhard_old stickwithgoals_old goaftergoal_old finishwhatbegin_old finishtasks_old keepworking_old raw_curious raw_rec_curious raw_interestedbyart raw_rec_interestedbyart raw_repetitivetasks raw_rec_repetitivetasks raw_inventive raw_rec_inventive raw_liketothink raw_rec_liketothink raw_newideas raw_rec_newideas raw_activeimagination raw_rec_activeimagination raw_organized raw_rec_organized raw_makeplans raw_rec_makeplans raw_workhard raw_rec_workhard raw_appointmentontime raw_rec_appointmentontime raw_putoffduties raw_rec_putoffduties raw_easilydistracted raw_rec_easilydistracted raw_completeduties raw_rec_completeduties raw_enjoypeople raw_rec_enjoypeople raw_sharefeelings raw_rec_sharefeelings raw_shywithpeople raw_rec_shywithpeople raw_enthusiastic raw_rec_enthusiastic raw_talktomanypeople raw_rec_talktomanypeople raw_talkative raw_rec_talkative raw_expressingthoughts raw_rec_expressingthoughts raw_workwithother raw_rec_workwithother raw_understandotherfeeling raw_rec_understandotherfeeling raw_trustingofother raw_rec_trustingofother raw_rudetoother raw_rec_rudetoother raw_toleratefaults raw_rec_toleratefaults raw_forgiveother raw_rec_forgiveother raw_helpfulwithothers raw_rec_helpfulwithothers raw_managestress raw_rec_managestress raw_nervous raw_rec_nervous raw_changemood raw_rec_changemood raw_feeldepressed raw_rec_feeldepressed raw_easilyupset raw_rec_easilyupset raw_worryalot raw_rec_worryalot raw_staycalm raw_rec_staycalm raw_tryhard raw_rec_tryhard raw_stickwithgoals raw_rec_stickwithgoals raw_goaftergoal raw_rec_goaftergoal raw_finishwhatbegin raw_rec_finishwhatbegin raw_finishtasks raw_rec_finishtasks raw_keepworking raw_rec_keepworking ars ars2 ars3 cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit age

keep HHINDID HHID_panel INDID_panel HHID2016 HHID2010 INDID2016 ///
sex caste jatis  name address religion  villageid villageareaid comefrom otherorigin villageid_new villageid_new_comments ///
dummydemonetisation demotrustneighborhood demotrustemployees_ego demotrustbank_ego demonetworkpeoplehelping_ego demonetworkhelpkinmember_ego demogeneralperception demogoodexpectations demobadexpectations ///
$torename


********** Rename 2016
foreach x in $torename{
rename `x' `x'_1
}

order HHINDID HHID_panel INDID_panel
sort HHINDID


save"$wave2~ego", replace
****************************************
* END












****************************************
* PREPA 2020
****************************************
use"$wave3", clear
merge m:1 HHID_panel using "panel", nogen keep(3)
keep if egoid>0
egen HHINDID=concat(HHID_panel INDID_panel), p(/)
tostring username, replace
destring religion, replace
destring comefrom, replace
global torename submissiondate username edulevel classcompleted relationshiptohead maritalstatus egoid everattendedschool canread converseinenglish mainoccupation_hours_indiv mainoccupation_income_indiv mainoccupation_indiv mainoccupationname_indiv enjoypeople curious organized managestress interestedbyart tryhard workwithother makeplans sharefeelings nervous stickwithgoals repetitivetasks shywithpeople workhard changemood understandotherfeeling inventive enthusiastic feeldepressed appointmentontime goaftergoal easilyupset talktomanypeople liketothink finishwhatbegin putoffduties rudetoother finishtasks toleratefaults worryalot easilydistracted keepworking completeduties talkative newideas staycalm forgiveother activeimagination expressingthoughts helpfulwithothers canreadcard1a canreadcard1b canreadcard1c canreadcard2 numeracy1 numeracy2 numeracy3 numeracy4 numeracy5 numeracy6 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 ab1 ab2 ab3 ab4 ab5 ab6 ab7 ab8 ab9 ab10 ab11 ab12 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 ra1 rab1 rb1 ra2 rab2 rb2 ra3 rab3 rb3 ra4 rab4 rb4 ra5 rab5 rb5 ra6 rab6 rb6 ra7 rab7 rb7 ra8 rab8 rb8 ra9 rab9 rb9 ra10 rab10 rb10 ra11 rab11 rb11 ra12 rab12 rb12 set_a set_ab set_b raven_tt refuse num_tt lit_tt raw_curious raw_rec_curious raw_interestedbyart raw_rec_interestedbyart raw_repetitivetasks raw_rec_repetitivetasks raw_inventive raw_rec_inventive raw_liketothink raw_rec_liketothink raw_newideas raw_rec_newideas raw_activeimagination raw_rec_activeimagination raw_organized raw_rec_organized raw_makeplans raw_rec_makeplans raw_workhard raw_rec_workhard raw_appointmentontime raw_rec_appointmentontime raw_putoffduties raw_rec_putoffduties raw_easilydistracted raw_rec_easilydistracted raw_completeduties raw_rec_completeduties raw_enjoypeople raw_rec_enjoypeople raw_sharefeelings raw_rec_sharefeelings raw_shywithpeople raw_rec_shywithpeople raw_enthusiastic raw_rec_enthusiastic raw_talktomanypeople raw_rec_talktomanypeople raw_talkative raw_rec_talkative raw_expressingthoughts raw_rec_expressingthoughts raw_workwithother raw_rec_workwithother raw_understandotherfeeling raw_rec_understandotherfeeling raw_trustingofother raw_rec_trustingofother raw_rudetoother raw_rec_rudetoother raw_toleratefaults raw_rec_toleratefaults raw_forgiveother raw_rec_forgiveother raw_helpfulwithothers raw_rec_helpfulwithothers raw_managestress raw_rec_managestress raw_nervous raw_rec_nervous raw_changemood raw_rec_changemood raw_feeldepressed raw_rec_feeldepressed raw_easilyupset raw_rec_easilyupset raw_worryalot raw_rec_worryalot raw_staycalm raw_rec_staycalm raw_tryhard raw_rec_tryhard raw_stickwithgoals raw_rec_stickwithgoals raw_goaftergoal raw_rec_goaftergoal raw_finishwhatbegin raw_rec_finishwhatbegin raw_finishtasks raw_rec_finishtasks raw_keepworking raw_rec_keepworking ars ars2 ars3 cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_tryhard imcr_stickwithgoals imcr_goaftergoal imcr_finishwhatbegin imcr_finishtasks imcr_keepworking imcurious iminterestedbyart imrepetitivetasks iminventive imliketothink imnewideas imactiveimagination imorganized immakeplans imworkhard imappointmentontime imputoffduties imeasilydistracted imcompleteduties imenjoypeople imsharefeelings imshywithpeople imenthusiastic imtalktomanypeople imtalkative imexpressingthoughts imworkwithother imunderstandotherfeeling imtrustingofother imrudetoother imtoleratefaults imforgiveother imhelpfulwithothers immanagestress imnervous imchangemood imfeeldepressed imeasilyupset imworryalot imstaycalm imtryhard imstickwithgoals imgoaftergoal imfinishwhatbegin imfinishtasks imkeepworking age
keep HHINDID HHID_panel INDID_panel  ///
sex caste jatis  name address religion  villageid villageareaid comefrom otherorigin villageid_new villageid_new_comments ///
dummydemonetisation ///
$torename


********** Rename 2020
foreach x in $torename{
rename `x' `x'_2
}

order HHINDID HHID_panel INDID_panel
sort HHINDID

save"$wave3~ego", replace
****************************************
* END










****************************************
* MERGE 2016
****************************************
use"$wave2~ego", clear

merge 1:1 HHID_panel INDID_panel using "$wave3~ego"

gen match=1 if _merge==3
replace match=2 if _merge==2
replace match=3 if _merge==1
label define match 1"Matched" 2"2020-21 only" 3"2016-17 only"
label values match match
drop _merge

order HHINDID HHID_panel INDID_panel match HHID2016 HHID2010 INDID2016 name sex caste jatis age_1 age_2 address religion  villageid villageareaid comefrom otherorigin villageid_new villageid_new_comments dummydemonetisation demotrustneighborhood demotrustemployees_ego demotrustbank_ego demonetworkpeoplehelping_ego demonetworkhelpkinmember_ego demogeneralperception demogoodexpectations demobadexpectations submissiondate_1 submissiondate_2
sort HHINDID

save"panel_stab_v1", replace
****************************************
* END