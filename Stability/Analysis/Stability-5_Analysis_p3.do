cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
August 17, 2021
-----
Stability over time of personality traits: analysis p3
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

/*
global big5 ///
curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination ///
organized makeplans workhard appointmentontime putoffduties easilydistracted completeduties ///
enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople talkative expressingthoughts  ///
workwithother understandotherfeeling trustingofother rudetoother toleratefaults forgiveother helpfulwithothers ///
managestress nervous changemood feeldepressed easilyupset worryalot staycalm ///
tryhard stickwithgoals goaftergoal finishwhatbegin finishtasks keepworking
*/

********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH_v7"
global wave3 "NEEMSIS2-HH_v17"
****************************************
* END


















****************************************
* Factor analysis 2020-21
****************************************

********** 
use"panel_stab_v4", clear
drop *_1
drop if egoid==.

********** Factor analysis 1: with grit for total sample
preserve
global big5 ///
imrr_curious_2 imrr_interestedbyart_2 imrr_repetitivetasks_2 imrr_inventive_2 imrr_liketothink_2 imrr_newideas_2 imrr_activeimagination_2 imrr_organized_2 imrr_makeplans_2 imrr_workhard_2 imrr_appointmentontime_2 imrr_putoffduties_2 imrr_easilydistracted_2 imrr_completeduties_2 imrr_enjoypeople_2 imrr_sharefeelings_2 imrr_shywithpeople_2 imrr_enthusiastic_2 imrr_talktomanypeople_2 imrr_talkative_2 imrr_expressingthoughts_2 imrr_workwithother_2 imrr_understandotherfeeling_2 imrr_trustingofother_2 imrr_rudetoother_2 imrr_toleratefaults_2 imrr_forgiveother_2 imrr_helpfulwithothers_2 imrr_managestress_2 imrr_nervous_2 imrr_changemood_2 imrr_feeldepressed_2 imrr_easilyupset_2 imrr_worryalot_2 imrr_staycalm_2 imrr_tryhard_2 imrr_stickwithgoals_2 imrr_goaftergoal_2 imrr_finishwhatbegin_2 imrr_finishtasks_2 imrr_keepworking_2

minap $big5
factor $big5, pcf fa(6) 
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(eigen)
putexcel (B2)=matrix(e(Ev))
rotate, promax
ereturn list
matrix list e(r_Ev)
matrix list e(r_Phi)
matrix list e(Ev)

putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(promax)
putexcel (B2)=matrix(e(r_Ev))

qui predict f_1 f_2 f_3 f_4 f_5 f_6
qui cpcorr $big5 \ f_1 f_2 f_3 f_4 f_5 f_6
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(fa1)
putexcel (D2)=matrix(r(C))
putexcel (J2)=matrix(r(p))
restore


********** Factor analysis 2: without grit for total sample
preserve
global big5 ///
imrr_curious_2 imrr_interestedbyart_2 imrr_repetitivetasks_2 imrr_inventive_2 imrr_liketothink_2 imrr_newideas_2 imrr_activeimagination_2 imrr_organized_2 imrr_makeplans_2 imrr_workhard_2 imrr_appointmentontime_2 imrr_putoffduties_2 imrr_easilydistracted_2 imrr_completeduties_2 imrr_enjoypeople_2 imrr_sharefeelings_2 imrr_shywithpeople_2 imrr_enthusiastic_2 imrr_talktomanypeople_2 imrr_talkative_2 imrr_expressingthoughts_2 imrr_workwithother_2 imrr_understandotherfeeling_2 imrr_trustingofother_2 imrr_rudetoother_2 imrr_toleratefaults_2 imrr_forgiveother_2 imrr_helpfulwithothers_2 imrr_managestress_2 imrr_nervous_2 imrr_changemood_2 imrr_feeldepressed_2 imrr_easilyupset_2 imrr_worryalot_2 imrr_staycalm_2 

qui minap $big5
qui factor $big5, pcf fa(5) 
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(eigen)
putexcel (B3)=matrix(e(Ev))
qui rotate, promax
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(promax)
putexcel (B3)=matrix(e(r_Ev))

qui predict f_1 f_2 f_3 f_4 f_5
qui cpcorr $big5 \ f_1 f_2 f_3 f_4 f_5
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(fa2)
putexcel (D2)=matrix(r(C))
putexcel (J2)=matrix(r(p))
restore



********** Factor analysis 3: with grit for male
preserve
keep if sex==1
global big5 ///
imrr_curious_2 imrr_interestedbyart_2 imrr_repetitivetasks_2 imrr_inventive_2 imrr_liketothink_2 imrr_newideas_2 imrr_activeimagination_2 imrr_organized_2 imrr_makeplans_2 imrr_workhard_2 imrr_appointmentontime_2 imrr_putoffduties_2 imrr_easilydistracted_2 imrr_completeduties_2 imrr_enjoypeople_2 imrr_sharefeelings_2 imrr_shywithpeople_2 imrr_enthusiastic_2 imrr_talktomanypeople_2 imrr_talkative_2 imrr_expressingthoughts_2 imrr_workwithother_2 imrr_understandotherfeeling_2 imrr_trustingofother_2 imrr_rudetoother_2 imrr_toleratefaults_2 imrr_forgiveother_2 imrr_helpfulwithothers_2 imrr_managestress_2 imrr_nervous_2 imrr_changemood_2 imrr_feeldepressed_2 imrr_easilyupset_2 imrr_worryalot_2 imrr_staycalm_2 imrr_tryhard_2 imrr_stickwithgoals_2 imrr_goaftergoal_2 imrr_finishwhatbegin_2 imrr_finishtasks_2 imrr_keepworking_2

qui minap $big5
qui factor $big5, pcf fa(6) 
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(eigen)
putexcel (B4)=matrix(e(Ev))
qui rotate, promax
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(promax)
putexcel (B4)=matrix(e(r_Ev))

qui predict f_1 f_2 f_3 f_4 f_5 f_6
qui cpcorr $big5 \ f_1 f_2 f_3 f_4 f_5 f_6
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(fa3)
putexcel (D2)=matrix(r(C))
putexcel (J2)=matrix(r(p))
restore


********** Factor analysis 4: without grit for male
preserve
keep if sex==1
global big5 ///
imrr_curious_2 imrr_interestedbyart_2 imrr_repetitivetasks_2 imrr_inventive_2 imrr_liketothink_2 imrr_newideas_2 imrr_activeimagination_2 imrr_organized_2 imrr_makeplans_2 imrr_workhard_2 imrr_appointmentontime_2 imrr_putoffduties_2 imrr_easilydistracted_2 imrr_completeduties_2 imrr_enjoypeople_2 imrr_sharefeelings_2 imrr_shywithpeople_2 imrr_enthusiastic_2 imrr_talktomanypeople_2 imrr_talkative_2 imrr_expressingthoughts_2 imrr_workwithother_2 imrr_understandotherfeeling_2 imrr_trustingofother_2 imrr_rudetoother_2 imrr_toleratefaults_2 imrr_forgiveother_2 imrr_helpfulwithothers_2 imrr_managestress_2 imrr_nervous_2 imrr_changemood_2 imrr_feeldepressed_2 imrr_easilyupset_2 imrr_worryalot_2 imrr_staycalm_2 

qui minap $big5
qui factor $big5, pcf fa(5) 
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(eigen)
putexcel (B5)=matrix(e(Ev))
qui rotate, promax
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(promax)
putexcel (B5)=matrix(e(r_Ev))

qui predict f_1 f_2 f_3 f_4 f_5
qui cpcorr $big5 \ f_1 f_2 f_3 f_4 f_5
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(fa4)
putexcel (D2)=matrix(r(C))
putexcel (J2)=matrix(r(p))
restore



********** Factor analysis 5: with grit for female
preserve
keep if sex==2
global big5 ///
imrr_curious_2 imrr_interestedbyart_2 imrr_repetitivetasks_2 imrr_inventive_2 imrr_liketothink_2 imrr_newideas_2 imrr_activeimagination_2 imrr_organized_2 imrr_makeplans_2 imrr_workhard_2 imrr_appointmentontime_2 imrr_putoffduties_2 imrr_easilydistracted_2 imrr_completeduties_2 imrr_enjoypeople_2 imrr_sharefeelings_2 imrr_shywithpeople_2 imrr_enthusiastic_2 imrr_talktomanypeople_2 imrr_talkative_2 imrr_expressingthoughts_2 imrr_workwithother_2 imrr_understandotherfeeling_2 imrr_trustingofother_2 imrr_rudetoother_2 imrr_toleratefaults_2 imrr_forgiveother_2 imrr_helpfulwithothers_2 imrr_managestress_2 imrr_nervous_2 imrr_changemood_2 imrr_feeldepressed_2 imrr_easilyupset_2 imrr_worryalot_2 imrr_staycalm_2 imrr_tryhard_2 imrr_stickwithgoals_2 imrr_goaftergoal_2 imrr_finishwhatbegin_2 imrr_finishtasks_2 imrr_keepworking_2

qui minap $big5
qui factor $big5, pcf fa(6) 
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(eigen)
putexcel (B6)=matrix(e(Ev))
qui rotate, promax
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(promax)
putexcel (B6)=matrix(e(r_Ev))

qui predict f_1 f_2 f_3 f_4 f_5 f_6
qui cpcorr $big5 \ f_1 f_2 f_3 f_4 f_5 f_6
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(fa5)
putexcel (D2)=matrix(r(C))
putexcel (J2)=matrix(r(p))
restore


********** Factor analysis 6: without grit for female
preserve
keep if sex==2
global big5 ///
imrr_curious_2 imrr_interestedbyart_2 imrr_repetitivetasks_2 imrr_inventive_2 imrr_liketothink_2 imrr_newideas_2 imrr_activeimagination_2 imrr_organized_2 imrr_makeplans_2 imrr_workhard_2 imrr_appointmentontime_2 imrr_putoffduties_2 imrr_easilydistracted_2 imrr_completeduties_2 imrr_enjoypeople_2 imrr_sharefeelings_2 imrr_shywithpeople_2 imrr_enthusiastic_2 imrr_talktomanypeople_2 imrr_talkative_2 imrr_expressingthoughts_2 imrr_workwithother_2 imrr_understandotherfeeling_2 imrr_trustingofother_2 imrr_rudetoother_2 imrr_toleratefaults_2 imrr_forgiveother_2 imrr_helpfulwithothers_2 imrr_managestress_2 imrr_nervous_2 imrr_changemood_2 imrr_feeldepressed_2 imrr_easilyupset_2 imrr_worryalot_2 imrr_staycalm_2  

qui minap $big5
qui factor $big5, pcf fa(5) 
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(eigen)
putexcel (B7)=matrix(e(Ev))
qui rotate, promax
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(promax)
putexcel (B7)=matrix(e(r_Ev))

qui predict f_1 f_2 f_3 f_4 f_5
qui cpcorr $big5 \ f_1 f_2 f_3 f_4 f_5
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(fa6)
putexcel (D2)=matrix(r(C))
putexcel (J2)=matrix(r(p))
restore


********** Factor analysis 7: with grit for dalit
preserve
keep if caste==1
global big5 ///
imrr_curious_2 imrr_interestedbyart_2 imrr_repetitivetasks_2 imrr_inventive_2 imrr_liketothink_2 imrr_newideas_2 imrr_activeimagination_2 imrr_organized_2 imrr_makeplans_2 imrr_workhard_2 imrr_appointmentontime_2 imrr_putoffduties_2 imrr_easilydistracted_2 imrr_completeduties_2 imrr_enjoypeople_2 imrr_sharefeelings_2 imrr_shywithpeople_2 imrr_enthusiastic_2 imrr_talktomanypeople_2 imrr_talkative_2 imrr_expressingthoughts_2 imrr_workwithother_2 imrr_understandotherfeeling_2 imrr_trustingofother_2 imrr_rudetoother_2 imrr_toleratefaults_2 imrr_forgiveother_2 imrr_helpfulwithothers_2 imrr_managestress_2 imrr_nervous_2 imrr_changemood_2 imrr_feeldepressed_2 imrr_easilyupset_2 imrr_worryalot_2 imrr_staycalm_2 imrr_tryhard_2 imrr_stickwithgoals_2 imrr_goaftergoal_2 imrr_finishwhatbegin_2 imrr_finishtasks_2 imrr_keepworking_2

qui minap $big5
qui factor $big5, pcf fa(6) 
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(eigen)
putexcel (B8)=matrix(e(Ev))
qui rotate, promax
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(promax)
putexcel (B8)=matrix(e(r_Ev))

qui predict f_1 f_2 f_3 f_4 f_5 f_6
qui cpcorr $big5 \ f_1 f_2 f_3 f_4 f_5 f_6
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(fa7)
putexcel (D2)=matrix(r(C))
putexcel (J2)=matrix(r(p))
restore


********** Factor analysis 8: without grit for dalit
preserve
keep if caste==1
global big5 ///
imrr_curious_2 imrr_interestedbyart_2 imrr_repetitivetasks_2 imrr_inventive_2 imrr_liketothink_2 imrr_newideas_2 imrr_activeimagination_2 imrr_organized_2 imrr_makeplans_2 imrr_workhard_2 imrr_appointmentontime_2 imrr_putoffduties_2 imrr_easilydistracted_2 imrr_completeduties_2 imrr_enjoypeople_2 imrr_sharefeelings_2 imrr_shywithpeople_2 imrr_enthusiastic_2 imrr_talktomanypeople_2 imrr_talkative_2 imrr_expressingthoughts_2 imrr_workwithother_2 imrr_understandotherfeeling_2 imrr_trustingofother_2 imrr_rudetoother_2 imrr_toleratefaults_2 imrr_forgiveother_2 imrr_helpfulwithothers_2 imrr_managestress_2 imrr_nervous_2 imrr_changemood_2 imrr_feeldepressed_2 imrr_easilyupset_2 imrr_worryalot_2 imrr_staycalm_2 

qui minap $big5
qui factor $big5, pcf fa(5) 
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(eigen)
putexcel (B9)=matrix(e(Ev))
qui rotate, promax
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(promax)
putexcel (B9)=matrix(e(r_Ev))

qui predict f_1 f_2 f_3 f_4 f_5
qui cpcorr $big5 \ f_1 f_2 f_3 f_4 f_5
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(fa8)
putexcel (D2)=matrix(r(C))
putexcel (J2)=matrix(r(p))
restore



********** Factor analysis 9: with grit for non-dalit
preserve
keep if caste==2 | caste==3
global big5 ///
imrr_curious_2 imrr_interestedbyart_2 imrr_repetitivetasks_2 imrr_inventive_2 imrr_liketothink_2 imrr_newideas_2 imrr_activeimagination_2 imrr_organized_2 imrr_makeplans_2 imrr_workhard_2 imrr_appointmentontime_2 imrr_putoffduties_2 imrr_easilydistracted_2 imrr_completeduties_2 imrr_enjoypeople_2 imrr_sharefeelings_2 imrr_shywithpeople_2 imrr_enthusiastic_2 imrr_talktomanypeople_2 imrr_talkative_2 imrr_expressingthoughts_2 imrr_workwithother_2 imrr_understandotherfeeling_2 imrr_trustingofother_2 imrr_rudetoother_2 imrr_toleratefaults_2 imrr_forgiveother_2 imrr_helpfulwithothers_2 imrr_managestress_2 imrr_nervous_2 imrr_changemood_2 imrr_feeldepressed_2 imrr_easilyupset_2 imrr_worryalot_2 imrr_staycalm_2 imrr_tryhard_2 imrr_stickwithgoals_2 imrr_goaftergoal_2 imrr_finishwhatbegin_2 imrr_finishtasks_2 imrr_keepworking_2

qui minap $big5
qui factor $big5, pcf fa(6) 
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(eigen)
putexcel (B10)=matrix(e(Ev))
qui rotate, promax
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(promax)
putexcel (B10)=matrix(e(r_Ev))

qui predict f_1 f_2 f_3 f_4 f_5 f_6
qui cpcorr $big5 \ f_1 f_2 f_3 f_4 f_5 f_6
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(fa9)
putexcel (D2)=matrix(r(C))
putexcel (J2)=matrix(r(p))
restore


********** Factor analysis 10: without grit for non-dalit
preserve
keep if caste==2 | caste==3
global big5 ///
imrr_curious_2 imrr_interestedbyart_2 imrr_repetitivetasks_2 imrr_inventive_2 imrr_liketothink_2 imrr_newideas_2 imrr_activeimagination_2 imrr_organized_2 imrr_makeplans_2 imrr_workhard_2 imrr_appointmentontime_2 imrr_putoffduties_2 imrr_easilydistracted_2 imrr_completeduties_2 imrr_enjoypeople_2 imrr_sharefeelings_2 imrr_shywithpeople_2 imrr_enthusiastic_2 imrr_talktomanypeople_2 imrr_talkative_2 imrr_expressingthoughts_2 imrr_workwithother_2 imrr_understandotherfeeling_2 imrr_trustingofother_2 imrr_rudetoother_2 imrr_toleratefaults_2 imrr_forgiveother_2 imrr_helpfulwithothers_2 imrr_managestress_2 imrr_nervous_2 imrr_changemood_2 imrr_feeldepressed_2 imrr_easilyupset_2 imrr_worryalot_2 imrr_staycalm_2  

qui minap $big5
qui factor $big5, pcf fa(5) 
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(eigen)
putexcel (B11)=matrix(e(Ev))
qui rotate, promax
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(promax)
putexcel (B11)=matrix(e(r_Ev))

qui predict f_1 f_2 f_3 f_4 f_5
qui cpcorr $big5 \ f_1 f_2 f_3 f_4 f_5
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(fa10)
putexcel (D2)=matrix(r(C))
putexcel (J2)=matrix(r(p))
restore


****************************************
* END




















****************************************
* Factor analysis 2016-17
****************************************

********** 
use"panel_stab_v4", clear
drop *_2
drop if egoid==.


********** Factor analysis 1: with grit for total sample
preserve
global big5 ///
imrr_curious_1 imrr_interestedbyart_1 imrr_repetitivetasks_1 imrr_inventive_1 imrr_liketothink_1 imrr_newideas_1 imrr_activeimagination_1 imrr_organized_1 imrr_makeplans_1 imrr_workhard_1 imrr_appointmentontime_1 imrr_putoffduties_1 imrr_easilydistracted_1 imrr_completeduties_1 imrr_enjoypeople_1 imrr_sharefeelings_1 imrr_shywithpeople_1 imrr_enthusiastic_1 imrr_talktomanypeople_1 imrr_talkative_1 imrr_expressingthoughts_1 imrr_workwithother_1 imrr_understandotherfeeling_1 imrr_trustingofother_1 imrr_rudetoother_1 imrr_toleratefaults_1 imrr_forgiveother_1 imrr_helpfulwithothers_1 imrr_managestress_1 imrr_nervous_1 imrr_changemood_1 imrr_feeldepressed_1 imrr_easilyupset_1 imrr_worryalot_1 imrr_staycalm_1 imrr_tryhard_1 imrr_stickwithgoals_1 imrr_goaftergoal_1 imrr_finishwhatbegin_1 imrr_finishtasks_1 imrr_keepworking_1

minap $big5
factor $big5, pcf fa(6) 
qui rotate, promax

qui predict f_1 f_2 f_3 f_4 f_5 f_6
qui cpcorr $big5 \ f_1 f_2 f_3 f_4 f_5 f_6
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(fa11)
putexcel (D2)=matrix(r(C))
putexcel (J2)=matrix(r(p))
restore


********** Factor analysis 2: without grit for total sample
preserve
global big5 ///
imrr_curious_1 imrr_interestedbyart_1 imrr_repetitivetasks_1 imrr_inventive_1 imrr_liketothink_1 imrr_newideas_1 imrr_activeimagination_1 imrr_organized_1 imrr_makeplans_1 imrr_workhard_1 imrr_appointmentontime_1 imrr_putoffduties_1 imrr_easilydistracted_1 imrr_completeduties_1 imrr_enjoypeople_1 imrr_sharefeelings_1 imrr_shywithpeople_1 imrr_enthusiastic_1 imrr_talktomanypeople_1 imrr_talkative_1 imrr_expressingthoughts_1 imrr_workwithother_1 imrr_understandotherfeeling_1 imrr_trustingofother_1 imrr_rudetoother_1 imrr_toleratefaults_1 imrr_forgiveother_1 imrr_helpfulwithothers_1 imrr_managestress_1 imrr_nervous_1 imrr_changemood_1 imrr_feeldepressed_1 imrr_easilyupset_1 imrr_worryalot_1 imrr_staycalm_1

minap $big5
qui factor $big5, pcf fa(5) 
qui rotate, promax

qui predict f_1 f_2 f_3 f_4 f_5
qui cpcorr $big5 \ f_1 f_2 f_3 f_4 f_5
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(fa12)
putexcel (D2)=matrix(r(C))
putexcel (J2)=matrix(r(p))
restore



********** Factor analysis 3: with grit for male
preserve
keep if sex==1
global big5 ///
imrr_curious_1 imrr_interestedbyart_1 imrr_repetitivetasks_1 imrr_inventive_1 imrr_liketothink_1 imrr_newideas_1 imrr_activeimagination_1 imrr_organized_1 imrr_makeplans_1 imrr_workhard_1 imrr_appointmentontime_1 imrr_putoffduties_1 imrr_easilydistracted_1 imrr_completeduties_1 imrr_enjoypeople_1 imrr_sharefeelings_1 imrr_shywithpeople_1 imrr_enthusiastic_1 imrr_talktomanypeople_1 imrr_talkative_1 imrr_expressingthoughts_1 imrr_workwithother_1 imrr_understandotherfeeling_1 imrr_trustingofother_1 imrr_rudetoother_1 imrr_toleratefaults_1 imrr_forgiveother_1 imrr_helpfulwithothers_1 imrr_managestress_1 imrr_nervous_1 imrr_changemood_1 imrr_feeldepressed_1 imrr_easilyupset_1 imrr_worryalot_1 imrr_staycalm_1 imrr_tryhard_1 imrr_stickwithgoals_1 imrr_goaftergoal_1 imrr_finishwhatbegin_1 imrr_finishtasks_1 imrr_keepworking_1

minap $big5
qui factor $big5, pcf fa(6) 
qui rotate, promax

qui predict f_1 f_2 f_3 f_4 f_5 f_6
qui cpcorr $big5 \ f_1 f_2 f_3 f_4 f_5 f_6
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(fa13)
putexcel (D2)=matrix(r(C))
putexcel (J2)=matrix(r(p))
restore


********** Factor analysis 4: without grit for male
preserve
keep if sex==1
global big5 ///
imrr_curious_1 imrr_interestedbyart_1 imrr_repetitivetasks_1 imrr_inventive_1 imrr_liketothink_1 imrr_newideas_1 imrr_activeimagination_1 imrr_organized_1 imrr_makeplans_1 imrr_workhard_1 imrr_appointmentontime_1 imrr_putoffduties_1 imrr_easilydistracted_1 imrr_completeduties_1 imrr_enjoypeople_1 imrr_sharefeelings_1 imrr_shywithpeople_1 imrr_enthusiastic_1 imrr_talktomanypeople_1 imrr_talkative_1 imrr_expressingthoughts_1 imrr_workwithother_1 imrr_understandotherfeeling_1 imrr_trustingofother_1 imrr_rudetoother_1 imrr_toleratefaults_1 imrr_forgiveother_1 imrr_helpfulwithothers_1 imrr_managestress_1 imrr_nervous_1 imrr_changemood_1 imrr_feeldepressed_1 imrr_easilyupset_1 imrr_worryalot_1 imrr_staycalm_1  

minap $big5
qui factor $big5, pcf fa(5) 
qui rotate, promax

qui predict f_1 f_2 f_3 f_4 f_5
qui cpcorr $big5 \ f_1 f_2 f_3 f_4 f_5
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(fa14)
putexcel (D2)=matrix(r(C))
putexcel (J2)=matrix(r(p))
restore



********** Factor analysis 5: with grit for female
preserve
keep if sex==2
global big5 ///
imrr_curious_1 imrr_interestedbyart_1 imrr_repetitivetasks_1 imrr_inventive_1 imrr_liketothink_1 imrr_newideas_1 imrr_activeimagination_1 imrr_organized_1 imrr_makeplans_1 imrr_workhard_1 imrr_appointmentontime_1 imrr_putoffduties_1 imrr_easilydistracted_1 imrr_completeduties_1 imrr_enjoypeople_1 imrr_sharefeelings_1 imrr_shywithpeople_1 imrr_enthusiastic_1 imrr_talktomanypeople_1 imrr_talkative_1 imrr_expressingthoughts_1 imrr_workwithother_1 imrr_understandotherfeeling_1 imrr_trustingofother_1 imrr_rudetoother_1 imrr_toleratefaults_1 imrr_forgiveother_1 imrr_helpfulwithothers_1 imrr_managestress_1 imrr_nervous_1 imrr_changemood_1 imrr_feeldepressed_1 imrr_easilyupset_1 imrr_worryalot_1 imrr_staycalm_1 imrr_tryhard_1 imrr_stickwithgoals_1 imrr_goaftergoal_1 imrr_finishwhatbegin_1 imrr_finishtasks_1 imrr_keepworking_1

minap $big5
qui factor $big5, pcf fa(6) 
qui rotate, promax

qui predict f_1 f_2 f_3 f_4 f_5 f_6
qui cpcorr $big5 \ f_1 f_2 f_3 f_4 f_5 f_6
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(fa15)
putexcel (D2)=matrix(r(C))
putexcel (J2)=matrix(r(p))
restore


********** Factor analysis 6: without grit for female
preserve
keep if sex==2
global big5 ///
imrr_curious_1 imrr_interestedbyart_1 imrr_repetitivetasks_1 imrr_inventive_1 imrr_liketothink_1 imrr_newideas_1 imrr_activeimagination_1 imrr_organized_1 imrr_makeplans_1 imrr_workhard_1 imrr_appointmentontime_1 imrr_putoffduties_1 imrr_easilydistracted_1 imrr_completeduties_1 imrr_enjoypeople_1 imrr_sharefeelings_1 imrr_shywithpeople_1 imrr_enthusiastic_1 imrr_talktomanypeople_1 imrr_talkative_1 imrr_expressingthoughts_1 imrr_workwithother_1 imrr_understandotherfeeling_1 imrr_trustingofother_1 imrr_rudetoother_1 imrr_toleratefaults_1 imrr_forgiveother_1 imrr_helpfulwithothers_1 imrr_managestress_1 imrr_nervous_1 imrr_changemood_1 imrr_feeldepressed_1 imrr_easilyupset_1 imrr_worryalot_1 imrr_staycalm_1 

minap $big5
qui factor $big5, pcf fa(5) 
qui rotate, promax

qui predict f_1 f_2 f_3 f_4 f_5
qui cpcorr $big5 \ f_1 f_2 f_3 f_4 f_5
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(fa16)
putexcel (D2)=matrix(r(C))
putexcel (J2)=matrix(r(p))
restore


********** Factor analysis 7: with grit for dalit
preserve
keep if caste==1
global big5 ///
imrr_curious_1 imrr_interestedbyart_1 imrr_repetitivetasks_1 imrr_inventive_1 imrr_liketothink_1 imrr_newideas_1 imrr_activeimagination_1 imrr_organized_1 imrr_makeplans_1 imrr_workhard_1 imrr_appointmentontime_1 imrr_putoffduties_1 imrr_easilydistracted_1 imrr_completeduties_1 imrr_enjoypeople_1 imrr_sharefeelings_1 imrr_shywithpeople_1 imrr_enthusiastic_1 imrr_talktomanypeople_1 imrr_talkative_1 imrr_expressingthoughts_1 imrr_workwithother_1 imrr_understandotherfeeling_1 imrr_trustingofother_1 imrr_rudetoother_1 imrr_toleratefaults_1 imrr_forgiveother_1 imrr_helpfulwithothers_1 imrr_managestress_1 imrr_nervous_1 imrr_changemood_1 imrr_feeldepressed_1 imrr_easilyupset_1 imrr_worryalot_1 imrr_staycalm_1 imrr_tryhard_1 imrr_stickwithgoals_1 imrr_goaftergoal_1 imrr_finishwhatbegin_1 imrr_finishtasks_1 imrr_keepworking_1

minap $big5
qui factor $big5, pcf fa(6) 
qui rotate, promax

qui predict f_1 f_2 f_3 f_4 f_5 f_6
qui cpcorr $big5 \ f_1 f_2 f_3 f_4 f_5 f_6
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(fa17)
putexcel (D2)=matrix(r(C))
putexcel (J2)=matrix(r(p))
restore


********** Factor analysis 8: without grit for dalit
preserve
keep if caste==1
global big5 ///
imrr_curious_1 imrr_interestedbyart_1 imrr_repetitivetasks_1 imrr_inventive_1 imrr_liketothink_1 imrr_newideas_1 imrr_activeimagination_1 imrr_organized_1 imrr_makeplans_1 imrr_workhard_1 imrr_appointmentontime_1 imrr_putoffduties_1 imrr_easilydistracted_1 imrr_completeduties_1 imrr_enjoypeople_1 imrr_sharefeelings_1 imrr_shywithpeople_1 imrr_enthusiastic_1 imrr_talktomanypeople_1 imrr_talkative_1 imrr_expressingthoughts_1 imrr_workwithother_1 imrr_understandotherfeeling_1 imrr_trustingofother_1 imrr_rudetoother_1 imrr_toleratefaults_1 imrr_forgiveother_1 imrr_helpfulwithothers_1 imrr_managestress_1 imrr_nervous_1 imrr_changemood_1 imrr_feeldepressed_1 imrr_easilyupset_1 imrr_worryalot_1 imrr_staycalm_1 

minap $big5
qui factor $big5, pcf fa(5) 
qui rotate, promax

qui predict f_1 f_2 f_3 f_4 f_5
qui cpcorr $big5 \ f_1 f_2 f_3 f_4 f_5
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(fa18)
putexcel (D2)=matrix(r(C))
putexcel (J2)=matrix(r(p))
restore



********** Factor analysis 9: with grit for non-dalit
preserve
keep if caste==2 | caste==3
global big5 ///
imrr_curious_1 imrr_interestedbyart_1 imrr_repetitivetasks_1 imrr_inventive_1 imrr_liketothink_1 imrr_newideas_1 imrr_activeimagination_1 imrr_organized_1 imrr_makeplans_1 imrr_workhard_1 imrr_appointmentontime_1 imrr_putoffduties_1 imrr_easilydistracted_1 imrr_completeduties_1 imrr_enjoypeople_1 imrr_sharefeelings_1 imrr_shywithpeople_1 imrr_enthusiastic_1 imrr_talktomanypeople_1 imrr_talkative_1 imrr_expressingthoughts_1 imrr_workwithother_1 imrr_understandotherfeeling_1 imrr_trustingofother_1 imrr_rudetoother_1 imrr_toleratefaults_1 imrr_forgiveother_1 imrr_helpfulwithothers_1 imrr_managestress_1 imrr_nervous_1 imrr_changemood_1 imrr_feeldepressed_1 imrr_easilyupset_1 imrr_worryalot_1 imrr_staycalm_1 imrr_tryhard_1 imrr_stickwithgoals_1 imrr_goaftergoal_1 imrr_finishwhatbegin_1 imrr_finishtasks_1 imrr_keepworking_1

minap $big5
qui factor $big5, pcf fa(6) 
qui rotate, promax

qui predict f_1 f_2 f_3 f_4 f_5 f_6
qui cpcorr $big5 \ f_1 f_2 f_3 f_4 f_5 f_6
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(fa19)
putexcel (D2)=matrix(r(C))
putexcel (J2)=matrix(r(p))
restore


********** Factor analysis 10: without grit for non-dalit
preserve
keep if caste==2 | caste==3
global big5 ///
imrr_curious_1 imrr_interestedbyart_1 imrr_repetitivetasks_1 imrr_inventive_1 imrr_liketothink_1 imrr_newideas_1 imrr_activeimagination_1 imrr_organized_1 imrr_makeplans_1 imrr_workhard_1 imrr_appointmentontime_1 imrr_putoffduties_1 imrr_easilydistracted_1 imrr_completeduties_1 imrr_enjoypeople_1 imrr_sharefeelings_1 imrr_shywithpeople_1 imrr_enthusiastic_1 imrr_talktomanypeople_1 imrr_talkative_1 imrr_expressingthoughts_1 imrr_workwithother_1 imrr_understandotherfeeling_1 imrr_trustingofother_1 imrr_rudetoother_1 imrr_toleratefaults_1 imrr_forgiveother_1 imrr_helpfulwithothers_1 imrr_managestress_1 imrr_nervous_1 imrr_changemood_1 imrr_feeldepressed_1 imrr_easilyupset_1 imrr_worryalot_1 imrr_staycalm_1 

minap $big5
qui factor $big5, pcf fa(5) 
qui rotate, promax

qui predict f_1 f_2 f_3 f_4 f_5
qui cpcorr $big5 \ f_1 f_2 f_3 f_4 f_5
putexcel set "$git\Analysis\Stability\Analysis\stat.xlsx", modify sheet(fa20)
putexcel (D2)=matrix(r(C))
putexcel (J2)=matrix(r(p))
restore


****************************************
* END













****************************************
* DATABASE
****************************************

********** Data base
forvalues i=1(1)20{
import excel "$git\Analysis\Stability\Analysis\stat.xlsx", sheet("fa`i'") firstrow clear
foreach x in C_F1 C_F2 C_F3 C_F4 C_F5 C_F6 p_F1 p_F2 p_F3 p_F4 p_F5 p_F6 {
rename `x' b`i'_`x'
}
save "$git\Analysis\Stability\Analysis\fa`i'.dta", replace
}

import excel "$git\Analysis\Stability\Analysis\stat.xlsx", sheet("promax_mod") firstrow clear
split Factor, p(F)
order Factor Factor2
drop Factor1 Factor
destring Factor2, replace
rename Factor2 Factor
save "$git\Analysis\Stability\Analysis\promax_mod.dta", replace

import excel "$git\Analysis\Stability\Analysis\stat.xlsx", sheet("eigen_mod") firstrow clear
split Factor, p(F)
order Factor Factor2
drop Factor1 Factor
destring Factor2, replace
rename Factor2 Factor
merge 1:1 Factor using "$git\Analysis\Stability\Analysis\promax_mod.dta", nogen

save "$git\Analysis\Stability\Analysis\promax_eigen.dta", replace
erase"$git\Analysis\Stability\Analysis\promax_mod.dta"


********** Merge
use"$git\Analysis\Stability\Analysis\fa1.dta", clear
forvalues i=2(1)20{
merge 1:1 N using "$git\Analysis\Stability\Analysis\fa`i'.dta", nogen
}
dropmiss, force

forvalues i=1(1)6{
foreach x in C_F p_F {
rename b1_`x'`i' with_tot_2020_`x'`i'
rename b3_`x'`i' with_mal_2020_`x'`i' 
rename b5_`x'`i' with_fem_2020_`x'`i'
rename b7_`x'`i' with_dal_2020_`x'`i'
rename b9_`x'`i' with_nda_2020_`x'`i'

rename b11_`x'`i' with_tot_2016_`x'`i'
rename b13_`x'`i' with_mal_2016_`x'`i' 
rename b15_`x'`i' with_fem_2016_`x'`i'
rename b17_`x'`i' with_dal_2016_`x'`i'
rename b19_`x'`i' with_nda_2016_`x'`i'

}
}

forvalues i=1(1)5{
foreach x in C_F p_F {
rename b2_`x'`i' without_tot_2020_`x'`i'
rename b4_`x'`i' without_mal_2020_`x'`i' 
rename b6_`x'`i' without_fem_2020_`x'`i'
rename b8_`x'`i' without_dal_2020_`x'`i'
rename b10_`x'`i' without_nda_2020_`x'`i'

rename b12_`x'`i' without_tot_2016_`x'`i'
rename b14_`x'`i' without_mal_2016_`x'`i' 
rename b16_`x'`i' without_fem_2016_`x'`i'
rename b18_`x'`i' without_dal_2016_`x'`i'
rename b20_`x'`i' without_nda_2016_`x'`i'

}
}

foreach x in repetitivetasks rudetoother easilydistracted putoffduties shywithpeople staycalm managestress{
replace Variable="`x' (r)" if Variable=="`x'"
}

rename Variable Variable_unique
egen Variable=concat(Variable_unique Big5), p(" - ")

save"factor.dta", replace
save"$git\Analysis\Stability\Analysis\factor.dta", replace

forvalues i=1(1)20{
erase "$git\Analysis\Stability\Analysis\fa`i'.dta"
}

****************************************
* END












****************************************
* GRAPH
****************************************
set scheme plottig

set graph off

*Graph
*twoway ///
*(connected var_with_`x'_`i'_C_F`j' with_`x'_`i'_C_F`j', msymbol(o) msize(*0.2) lwidth(*0.2)) ///
*(scatter var_with_`x'_`i'_C_F`j' with_`x'_`i'_C_F`j', mlabel(with_`x'_`i'_C_F`j') mlabposition(3) mlabsize(*0.5) mlabangle(0) msymbol(i) xline(0.05, lpattern(solid) lcolor(gs12) lwidth(*0.5))) ///
*(scatter var_with_`x'_`i'_C_F`j' with_`x'_`i'_p_F`j', msymbol(X) mcolor(gs1) msize(*.5) xline(0, lpattern(solid) lcolor(gs1) lwidth(*0.5))) ///
*, ylabel(1(1)35, valuelabel labsize(tiny) angle(0)) ytitle("")  ///
*xlabel(, labsize(tiny) nogrid) xmtick() ///
*title("Factor `j'", size(small)) ///
*legend(order(1 "Correlation with factor" 3 "p-value" 4 ".05 threshold") pos(6) col(3) size(vsmall) off) ///
*name(g_with_`x'_`i'_`j', replace)  // aspectratio(10)
*sort n


*** With
preserve
gen n=_n
foreach x in tot mal fem dal nda {
foreach i in 2016 2020 {
forvalues j=1(1)6{

*Sort
gsort - with_`x'_`i'_C_F`j'
sencode Variable, gen(var_with_`x'_`i'_C_F`j') gsort(with_`x'_`i'_C_F`j')
replace with_`x'_`i'_C_F`j'=round(with_`x'_`i'_C_F`j', 0.01)

*Graph
twoway ///
(connected var_with_`x'_`i'_C_F`j' with_`x'_`i'_C_F`j', msymbol(o) msize(*0.2) lwidth(*0.2)) ///
(scatter var_with_`x'_`i'_C_F`j' with_`x'_`i'_C_F`j', mlabel(with_`x'_`i'_C_F`j') mlabposition(3) mlabsize(*0.5) mlabangle(0) msymbol(i) xline(0, lpattern(solid) lcolor(gs1) lwidth(*0.5))) ///
, ylabel(1(1)41, valuelabel labsize(tiny) angle(0)) ytitle("")  ///
xlabel(, labsize(tiny) nogrid) xmtick() xtitle("") ///
title("Factor `j'", size(small)) ///
legend(order(1 "Correlation with factor") pos(6) col(3) size(vsmall) off) ///
name(g_with_`x'_`i'_`j', replace)  // aspectratio(10)
sort n
}
}

grc1leg g_with_`x'_2016_1 g_with_`x'_2016_2 g_with_`x'_2016_3 g_with_`x'_2016_4 g_with_`x'_2016_5 g_with_`x'_2016_6, note("`x' sample." "NEEMSIS-1 (2016-17) data.", size(tiny)) name(comb_`x'_with_2016, replace)
graph save "$git\Analysis\Stability\Analysis\Graph\factor2016_`x'_with.gph", replace
graph export "$git\Analysis\Stability\Analysis\Graph\factor2016_`x'_with.pdf", as(pdf) replace

grc1leg g_with_`x'_2020_1 g_with_`x'_2020_2 g_with_`x'_2020_3 g_with_`x'_2020_4 g_with_`x'_2020_5 g_with_`x'_2020_6, note("`x' sample." "NEEMSIS-2 (2020-21) data.", size(tiny)) name(comb_`x'_with_2020, replace)
graph save "$git\Analysis\Stability\Analysis\Graph\factor2020_`x'_with.gph", replace
graph export "$git\Analysis\Stability\Analysis\Graph\factor2020_`x'_with.pdf", as(pdf) replace
}
restore


*** Without
preserve
gen n=_n
drop if n>35
foreach x in tot mal fem dal nda {
foreach i in 2016 2020 {
forvalues j=1(1)5{

*Sort
gsort - without_`x'_`i'_C_F`j'
sencode Variable, gen(var_without_`x'_`i'_C_F`j') gsort(without_`x'_`i'_C_F`j')
replace without_`x'_`i'_C_F`j'=round(without_`x'_`i'_C_F`j', 0.01)

*Graph
twoway ///
(connected var_without_`x'_`i'_C_F`j' without_`x'_`i'_C_F`j', msymbol(o) msize(*0.2) lwidth(*0.2)) ///
(scatter var_without_`x'_`i'_C_F`j' without_`x'_`i'_C_F`j', mlabel(without_`x'_`i'_C_F`j') mlabposition(3) mlabsize(*0.5) mlabangle(0) msymbol(i) xline(0, lpattern(solid) lcolor(gs1) lwidth(*0.5))) ///
, ylabel(1(1)35, valuelabel labsize(tiny) angle(0)) ytitle("")  ///
xlabel(, labsize(tiny) nogrid) xmtick() xtitle("")  ///
title("Factor `j'", size(small)) ///
legend(order(1 "Correlation without factor") pos(6) col(3) size(vsmall) off) ///
name(g_without_`x'_`i'_`j', replace)  // aspectratio(10)
sort n
}
}

grc1leg g_without_`x'_2016_1 g_without_`x'_2016_2 g_without_`x'_2016_3 g_without_`x'_2016_4 g_without_`x'_2016_5, note("`x' sample." "NEEMSIS-1 (2016-17) data.", size(tiny)) name(comb_`x'_without_2016, replace)
graph save "$git\Analysis\Stability\Analysis\Graph\factor2016_`x'_without.gph", replace
graph export "$git\Analysis\Stability\Analysis\Graph\factor2016_`x'_without.pdf", as(pdf) replace

grc1leg g_without_`x'_2020_1 g_without_`x'_2020_2 g_without_`x'_2020_3 g_without_`x'_2020_4 g_without_`x'_2020_5, note("`x' sample." "NEEMSIS-2 (2020-21) data.", size(tiny)) name(comb_`x'_without_2020, replace)
graph save "$git\Analysis\Stability\Analysis\Graph\factor2020_`x'_without.gph", replace
graph export "$git\Analysis\Stability\Analysis\Graph\factor2020_`x'_without.pdf", as(pdf) replace
}
restore
****************************************
* END














****************************************
* STAT
****************************************
use"$git\Analysis\Stability\Analysis\promax_eigen.dta", clear



****************************************
* END
