cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
April 23, 2021
-----
Stability over time of personality traits
-----

-------------------------
*/


****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
********** Path to folder "data" folder.
global directory = "D:\Documents\_Thesis\Research-Skills_and_debt\New_analysis"
cd"$directory"

********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH_v7_loans"
global wave2 "NEEMSIS1-HH_v7"
global wave3 "NEEMSIS2-HH_v15"
****************************************
* END



****************************************
* Stability
****************************************

********** 2016 prépa
use "$wave2", clear
keep if egoid>0
save"$wave2~ego", replace


********** 
use"$wave3", clear
global big5 ///
curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination ///
organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties ///
enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts  ///
workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers ///
managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm ///
tryhard  stickwithg~s   goaftergoal finishwhat~n finishtasks  keepworking

merge m:1 HHID2010 using "panel", nogen keep(3)
keep if egoid>0


********** Rename 2020 perso

foreach x in cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit lit_tt num_tt raven_tt cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking{
rename `x' `x'_2020
}

********** Merge with 2016 values
merge 1:1 HHID2010 INDID using "$wave2~ego", keepusing (cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit lit_tt num_tt raven_tt cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking)
*Gen diff
foreach x in cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit{
gen diff_`x'=`x'_2020 - `x'
}

foreach x in cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking{
gen diff_`x'=`x'_2020-`x'
}



********** Check the stability
*Descriptive
fsum cr_OP cr_OP_2020 cr_CO cr_CO_2020 cr_EX cr_EX_2020 cr_AG cr_AG_2020 cr_ES cr_ES_2020 cr_Grit cr_Grit_2020 if _merge==3, stats(mean)

fsum cr_OP cr_OP_2020 cr_CO cr_CO_2020 cr_EX cr_EX_2020 cr_AG cr_AG_2020 cr_ES cr_ES_2020 cr_Grit cr_Grit_2020 if _merge==3 & panel_2010_2016_2020==1, stats( mean)

*Diff
fsum diff_cr_OP diff_cr_CO diff_cr_EX diff_cr_AG diff_cr_ES diff_cr_Grit if _merge==3, stat(n mean sd p1 p5 p10 p25 p50 p75 p90 p95 p99)

fsum diff_cr_OP diff_cr_CO diff_cr_EX diff_cr_AG diff_cr_ES diff_cr_Grit if _merge==3 & panel_2010_2016_2020==1, stat(n mean sd p1 p5 p10 p25 p50 p75 p90 p95 p99)

*Diff for details
cls
foreach x in cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit{
ttest `x'==`x'_2020
}
cls
foreach x in cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit{
ttest `x'==`x'_2020 if panel_2010_2016_2020==1
}

********** Compute delta
foreach x in cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit{
gen delta_`x'=abs(((`x'_2020-`x')*100/`x'))
}
foreach x in cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking{
gen delta_`x'=abs(((`x'_2020-`x')*100/`x'))
}

fsum delta_* if _merge==3, stat(p1 p5 p10 p25 p50 p75 p90 p95 p99)

fsum delta_* if _merge==3 & panel_2010_2016_2020, stat(p1 p5 p10 p25 p50 p75 p90 p95 p99)

fsum delta_cr_curious delta_cr_interestedbyart delta_cr_repetitivetasks delta_cr_inventive delta_cr_liketothink delta_cr_newideas delta_cr_activeimagination delta_cr_organized delta_cr_makeplans delta_cr_workhard delta_cr_appointmentontime delta_cr_putoffduties delta_cr_easilydistracted delta_cr_completeduties delta_cr_enjoypeople delta_cr_sharefeelings delta_cr_shywithpeople delta_cr_enthusiastic delta_cr_talktomanypeople delta_cr_talkative delta_cr_expressingthoughts delta_cr_workwithother delta_cr_understandotherfeeling delta_cr_trustingofother delta_cr_rudetoother delta_cr_toleratefaults delta_cr_forgiveother delta_cr_helpfulwithothers delta_cr_managestress delta_cr_nervous delta_cr_changemood delta_cr_feeldepressed delta_cr_easilyupset delta_cr_worryalot delta_cr_staycalm delta_cr_tryhard delta_cr_stickwithgoals delta_cr_goaftergoal delta_cr_finishwhatbegin delta_cr_finishtasks delta_cr_keepworking, stat(n mean sd p1 p5 p10 p25 p50 p75 p90 p95 p99)



********** For whom it is stable ? Check with delta
foreach x in cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit{
gen stable_05_`x'=0
gen stable_10_`x'=0
}
foreach x in cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit{
replace stable_05_`x'=1 if delta_`x'<=5
replace stable_10_`x'=1 if delta_`x'<=10
}
egen stable_05_tot=rowtotal(stable_05_cr_OP stable_05_cr_CO stable_05_cr_EX stable_05_cr_AG stable_05_cr_ES stable_05_cr_Grit)
egen stable_10_tot=rowtotal(stable_10_cr_OP stable_10_cr_CO stable_10_cr_EX stable_10_cr_AG stable_10_cr_ES stable_10_cr_Grit)

tab stable_05_tot 
tab stable_10_tot



********** Force the stability in all HH
bysort HHID2010: egen max_stab=max(stable_05_tot)
gen stabok=1 if max_stab==stable_05_tot
recode stabok (.=0)
tab panel_2010_2016_2020 stabok, m
/*
Il manque 377..
Avec un peu de chance, sur les 448 bon, ils y en a qu'un seul par HH
Vérifions
*/
bysort HHID2010: egen max_stabok=max(stabok)
preserve
bysort HHID2010: gen n=_n
keep if n==1
tab max_stabok panel_2010_2016_2020, m
restore
/*
Ok, je vais essayer avec que stabok du coup..!
*/
tabstat cr_OP cr_OP_2020 cr_CO cr_CO_2020 cr_EX cr_EX_2020 cr_AG cr_AG_2020 cr_ES cr_ES_2020 cr_Grit cr_Grit_2020 if stabok==1, stat(mean)
fsum diff_* if stabok==1, stat(n mean sd)
fsum delta_* if stabok==1, stat(p1 p5 p10 p25 p50 p75 p90 p95 p99)

/*
Nothing....
*/
****************************************
* END










****************************************
* EFA
****************************************

********** 
use"$wave3", clear

merge m:1 HHID2010 using "panel", nogen keep(3)
keep if egoid>0

tab age
fre sex

global big5i imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination ///
imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties ///
imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts ///
imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother ///
imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm

minap $big5i if sex==1
minap $big5i if sex==2
factor $big5i if sex==1, pcf fa(5)
factor $big5i if sex==2, pcf fa(5)
rotate, promax 
*screeplot, neigen(10) yline(1) ylabel(1[1]10) xlabel(1[1]10) 
*loadingplot, legend(off) xline(0) yline(0) scale(.8)
*scoreplot
*putexcel set "$directory\_temp\STAT.xlsx", modify sheet(imput4)
*putexcel (E2) = matrix( e(r_L) ) 
predict f1 f2 f3 f4 f5
global factor f1 f2 f3 f4 f5
sum $factor
sum $big5, sep(50)
sum $big5i, sep(50)
global naivebig5 EGOcrOP EGOcrEX EGOcrES EGOcrCO EGOcrAG
pwcorr $naivebig5 $factor, star(.01)
