*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*April 23, 2021
*-----
gl link = "stabpsycho"
*Stab
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------










****************************************
* Acquiescence bias
****************************************
use"panel_stab_v2", clear

fre panel
********** Graph
*** General
codebook time
label define time 1"2016-17" 2"2020-21", modify


stripplot ars3 if panel==1, over(time) ///
stack width(0.01) jitter(1) /// //refline(lp(dash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh oh) msize(small) mc(black%30) ///
xla(0(.2)1.6, ang(h)) yla(, valuelabel noticks) ///
xmtick(0(.1)1.7) ymtick(0.9(0)2.5) ///
legend(order(1 "Mean" 4 "Whisker from 5% to 95%" 5 "Individual") pos(6) col(3) on) ///
note("2016: n=835" "2020: n=835", size(vsmall)) ///
xtitle("") ytitle("") name(biaspanel, replace)
graph export bias_panel.pdf, replace


****************************************
* END











****************************************
* Impact of enumerators on bias
****************************************
use"panel_stab_v2", clear


*** 2016-17
qui reg ars3 i.sex i.caste age ib(0).edulevel i.villageid if year==2016
est store ars1_1
qui reg ars3 i.sex i.caste age ib(0).edulevel i.villageid i.username_2016_code if year==2016
est store ars1_2


*** 2016-17
qui reg ars3 i.sex i.caste age ib(0).edulevel i.villageid if year==2020
est store ars2_1
qui reg ars3 i.sex i.caste age ib(0).edulevel i.villageid i.username_2020_code if year==2020
est store ars2_2

esttab ars1_1 ars1_2 ars2_1 ars2_2, ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop() ///	
	legend label varlabels(_cons constant) ///
	stats(N r2, fmt(0 3) labels(`"Observations"' `"\$R^2$"'))

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
keep if panel==1
keep HHID_panel INDID_panel f1_2016 f2_2016 f3_2016 f4_2016 f5_2016
save "panel_stab_v2_2016", replace
****************************************
* END















****************************************
* EFA 2020
****************************************
use"panel_stab_v2", clear
keep if year==2020


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
global f1 imcr_worryalot imcr_easilydistracted imcr_feeldepressed imcr_easilyupset imcr_changemood imcr_nervous imcr_repetitivetasks imcr_putoffduties imcr_shywithpeople imcr_rudetoother imcr_understandotherfeeling
/*
imcr_worryalot imcr_easilydistracted imcr_feeldepressed imcr_easilyupset imcr_changemood imcr_nervous imcr_repetitivetasks imcr_putoffduties imcr_shywithpeople imcr_rudetoother imcr_understandotherfeeling
*/

** F2
global f2 imcr_talkative imcr_helpfulwithothers imcr_inventive imcr_staycalm imcr_trustingofother imcr_liketothink imcr_sharefeelings imcr_organized imcr_appointmentontime
/*
imcr_talkative imcr_helpfulwithothers imcr_inventive imcr_staycalm imcr_trustingofother imcr_liketothink imcr_sharefeelings imcr_organized imcr_appointmentontime
*/

** F3
global f3 imcr_enthusiastic imcr_talktomanypeople imcr_completeduties imcr_forgiveother imcr_expressingthoughts imcr_activeimagination imcr_makeplans imcr_workwithother
/*
imcr_enthusiastic imcr_talktomanypeople imcr_completeduties imcr_forgiveother imcr_expressedthoughts imcr_activeimagination imcr_makeplans imcr_workwithother
*/

** F4
global f4 imcr_curious imcr_interestedbyart imcr_workhard imcr_enjoypeople imcr_newideas imcr_toleratefaults
/*
imcr_curious imcr_interestbyart imcr_workhard imcr_enjoypeople imcr_newideas imcr_toleratefaults
*/

** F5
global f5 imcr_managestress
/*
imcr_managestress
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
omegacoef $f4
*omegacoef $f5


*** Score
egen f1_2020=rowmean($f1)
egen f2_2020=rowmean($f2)
egen f3_2020=rowmean($f3)
egen f4_2020=rowmean($f4)

* To keep
keep if panel==1
keep HHID_panel INDID_panel f1_2020 f2_2020 f3_2020 f4_2020
save "panel_stab_v2_2020", replace
****************************************
* END
