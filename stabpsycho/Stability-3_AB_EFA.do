*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*April 23, 2021
*-----
gl link = "stabpsycho"
*Stab
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------










****************************************
* 1. ACQUIESCENCE BIAS
****************************************
use"panel_stab_v2", clear

fre panel
********** Graph
*** General
/*
stripplot ars3 if panel==1, over(time) separate(caste) ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(,angle(0))  ///
msymbol(+ + +) mcolor(black black black)  ///
ylabel(0(.2)1.6) ymtick(0(.1)1.7) ytitle("") ///
note("2016: n=835" "2020: n=835", size(vsmall)) ///
legend(order(1 "Mean" 5 "Individual")) ///
name(biaspanel, replace)
graph export bias_panel_old.pdf, replace
*/

stripplot ars3 if panel==1, over(time) vert ///
stack width(0.01) jitter(0) ///
box(barw(0.05)) boffset(-0.1) pctile(25) ///
ms(oh) msize(small) mc(black%30) ///
ylabel(0(.2)1.6) ymtick(0(.1)1.7) ytitle("") ///
xmtick(0.9(0)2.5) xtitle("") ///
note("2016: n=835" "2020: n=835", size(vsmall)) ///
name(biaspanel2, replace)
graph export bias_panel.pdf, replace


****************************************
* END









****************************************
* Evolution acquiesence bias
****************************************
use"panel_stab_v2_wide", clear


*keep if egoid2016!=. & egoid2020!=.


********** Impact of enum
encode username2016, gen(user16)
encode username2020, gen(user20)

***** 2016-17
reg ars32016 i.sex2016 i.caste2016 age2016 i.edulevel2016 i.villageid2016
reg ars32016 i.sex2016 i.caste2016 age2016 i.edulevel2016 i.villageid2016 i.user16
* 2.91 --> 26.32


***** 2016-17
reg ars32020 i.sex2020 i.caste2020 age2020 i.edulevel2020 i.villageid2020
* R2 --> 5.77
reg ars32020 i.sex2020 i.caste2020 age2020 i.edulevel2020 i.villageid2020 i.user20
* R2 --> 12.16

****************************************
* END














****************************************
* EFA 2016
****************************************
use"panel_stab_v2", clear
keep if year==2016


********** Imputation for corrected one
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


********** Macro
global imcor imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm



********** Factor analyses: without grit
factortest $imcor
factor $imcor, pcf fa(5)
rotate, quartimin
*putexcel set "EFA_2016.xlsx", modify sheet(without_panel)
*putexcel (E2)=matrix(e(r_L))


********** omegacoef with Laajaj approach for factor analysis and Cobb Clark
** F1
global f1 imcr_easilyupset imcr_nervous imcr_feeldepressed imcr_worryalot imcr_changemood imcr_easilydistracted imcr_shywithpeople imcr_putoffduties imcr_rudetoother imcr_repetitivetasks
/*
imcr_easilyupset imcr_nervous imcr_feeldepressed imcr_worryalot imcr_changemood imcr_easilydistracted imcr_shywithpeople imcr_putoffduties imcr_rudetoother imcr_repetitivetasks
*/

** F2
global f2 imcr_makeplans imcr_appointmentontime imcr_completeduties imcr_enthusiastic imcr_organized imcr_workhard imcr_workwithother
/*
imcr_makeplans imcr_appointmentontime imcr_completeduties imcr_enthusiastic imcr_organized imcr_workhard imcr_workwithother
*/

** F3
global f3 imcr_liketothink imcr_expressingthoughts imcr_activeimagination imcr_sharefeelings imcr_newideas imcr_inventive imcr_curious imcr_talktomanypeople imcr_talkative imcr_understandotherfeeling imcr_interestedbyart
/*
imcr_liketothink imcr_expressedthoughts imcr_activeimagination imcr_sharefeelings imcr_newideas imcr_inventive imcr_curious imcr_talktomanypeople imcr_talkative imcr_understandotherfeeling imcr_interestbyart
*/

** F4
global f4 imcr_staycalm imcr_managestress
/*
imcr_staycalm imcr_managestress
*/

** F5
global f5 imcr_forgiveother imcr_toleratefaults imcr_trustingofother imcr_enjoypeople imcr_helpfulwithothers
/*
imcr_forgiveother imcr_toleratefaults imcr_trustingofother imcr_enjoypeople imcr_helpfulwithothers
*/


*** omega for naive approach
cls
omegacoef imcr_curious imcr_interested~t   imcr_repetitive~s imcr_inventive imcr_liketothink imcr_newideas imcr_activeimag~n
omegacoef imcr_organized  imcr_makeplans imcr_workhard imcr_appointmen~e imcr_putoffduties imcr_easilydist~d imcr_completedu~s
omegacoef imcr_enjoypeople imcr_sharefeeli~s imcr_shywithpeo~e  imcr_enthusiastic  imcr_talktomany~e  imcr_talkative imcr_expressing~s 
omegacoef imcr_workwithot~r   imcr_understand~g imcr_trustingof~r imcr_rudetoother imcr_toleratefa~s  imcr_forgiveother  imcr_helpfulwit~s
omegacoef imcr_managestress  imcr_nervous  imcr_changemood imcr_feeldepres~d imcr_easilyupset imcr_worryalot  imcr_staycalm


*** omegacoef for factor approach
cls
omegacoef $f1
omegacoef $f2
omegacoef $f3
alpha $f4
omegacoef $f5

*** Score
egen f1_2016=rowmean($f1)
egen f2_2016=rowmean($f2)
egen f3_2016=rowmean($f3)
egen f4_2016=rowmean($f4)
egen f5_2016=rowmean($f5)



* To keep
keep HHID_panel INDID_panel f1_2016 f2_2016 f3_2016 f4_2016 f5_2016
save "panel_stab_v2_2016", replace
****************************************
* END















****************************************
* EFA 2020
****************************************
use"panel_stab_v2", clear
keep if year==2020

*keep if panel==1

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


********** Macro
global imcor imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm


********** Factor analyses: without grit
factortest $imcor
factor $imcor, pcf fa(5) // 2
rotate, quartimin
*putexcel set "EFA_2020.xlsx", modify sheet(without_panel)
*putexcel (E2)=matrix(e(r_L))



********** omegacoef with Laajaj approach for factor analysis and Cobb Clark
** F1
global f1 imcr_worryalot imcr_easilydistracted imcr_feeldepressed imcr_easilyupset imcr_changemood imcr_repetitivetasks imcr_nervous imcr_putoffduties imcr_shywithpeople imcr_rudetoother imcr_understandotherfeeling
/*
worryalot
easilydistracted
feeldepressed
easilyupset
changemood
nervous
repetitivetasks
putoffduties
shywithpeople
rudetoother
understandotherfeeling
*/

** F2
global f2 imcr_workhard imcr_enthusiastic imcr_talktomanypeople imcr_appointmentontime imcr_forgiveother imcr_expressingthoughts imcr_interestedbyart imcr_newideas imcr_understandotherfeeling imcr_makeplans imcr_completeduties
/*
talkative
helpfulwithothers
inventive
staycalm
trustingofother
liketothink
sharefeelings
organized
appointmentontime
*/

** F3
global f3 imcr_trustingofother imcr_inventive imcr_liketothink imcr_curious imcr_sharefeelings imcr_workwithother
/*
enthusiastic
talktomanypeople
completeduties
forgiveother
expressedthoughts
activeimagination
makeplans
workwithother
*/

** F4
global f4 imcr_organized imcr_helpfulwithothers imcr_staycalm imcr_activeimagination imcr_talkative
/*
curious
interestbyart
workhard
enjoypeople
newideas
toleratefaults
*/


*** omega for naive approach
cls
omegacoef imcr_curious imcr_interested~t   imcr_repetitive~s imcr_inventive imcr_liketothink imcr_newideas imcr_activeimag~n
omegacoef imcr_organized  imcr_makeplans imcr_workhard imcr_appointmen~e imcr_putoffduties imcr_easilydist~d imcr_completedu~s
omegacoef imcr_enjoypeople imcr_sharefeeli~s imcr_shywithpeo~e  imcr_enthusiastic  imcr_talktomany~e  imcr_talkative imcr_expressing~s 
omegacoef imcr_workwithot~r   imcr_understand~g imcr_trustingof~r imcr_rudetoother imcr_toleratefa~s  imcr_forgiveother  imcr_helpfulwit~s
omegacoef imcr_managestress  imcr_nervous  imcr_changemood imcr_feeldepres~d imcr_easilyupset imcr_worryalot  imcr_staycalm


*** omegacoef for factor approach
cls
omegacoef $f1  //.9
omegacoef $f2
omegacoef $f3
omegacoef $f4
omegacoef $f5


*** Score
egen f1_2020=rowmean($f1)
egen f2_2020=rowmean($f2)
egen f3_2020=rowmean($f3)
egen f4_2020=rowmean($f4)

* To keep
keep HHID_panel INDID_panel f1_2020 f2_2020 f3_2020 f4_2020
save "panel_stab_v2_2020", replace
****************************************
* END
