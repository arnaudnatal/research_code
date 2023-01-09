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


*** By sex
/*
stripplot ars3 if year==2020 & panel==1, over(sex) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(4) xtitle("") xlabel(,angle(45))  ///
ylabel(0(.2)1.6) ymtick(0(.1)1.7) ytitle("") ///
msymbol(oh oh oh) mcolor(ply1 plr1 plb1)  ///
legend(pos(6) col(3))
*/

*** By caste
/*
stripplot ars3 if year==2020 & panel==1, over(caste) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(4) xtitle("") xlabel(,angle(45))  ///
ylabel(0(.2)1.6) ymtick(0(.1)1.7) ytitle("") ///
msymbol(oh oh oh) mcolor(ply1 plr1 plb1)  ///
legend(pos(6) col(3))
*/

*** By age
/*
twoway ///
(scatter ars3 age if year==2020 & panel==1) ///
(lfit ars3 age if year==2020 & panel==1)
*/

*** By education level
/*
stripplot ars3 if year==2020 & panel==1, over(edulevel) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(4) xtitle("") xlabel(,angle(45))  ///
ylabel(0(.2)1.6) ymtick(0(.1)1.7) ytitle("") ///
msymbol(oh oh oh) mcolor(ply1 plr1 plb1)  ///
legend(pos(6) col(3))
*/

*** By traits
/*
twoway ///
(kdensity ars2_AG if year==2020 & panel==1, bwidth(0.7)) ///
(kdensity ars2_CO if year==2020 & panel==1, bwidth(0.7)) ///
(kdensity ars2_EX if year==2020 & panel==1, bwidth(0.7)) ///
(kdensity ars2_OP if year==2020 & panel==1, bwidth(0.7)) ///
(kdensity ars2_ES if year==2020 & panel==1, bwidth(0.7)) 

twoway ///
(kdensity ars3_AG if year==2020 & panel==1, bwidth(0.5)) ///
(kdensity ars3_CO if year==2020 & panel==1, bwidth(0.5)) ///
(kdensity ars3_EX if year==2020 & panel==1, bwidth(0.5)) ///
(kdensity ars3_OP if year==2020 & panel==1, bwidth(0.5)) ///
(kdensity ars3_ES if year==2020 & panel==1, bwidth(0.5)) 
*/

*** By enumerator
/*
stripplot ars3 if year==2016 & panel==1, over(username_2016_code) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(4) xtitle("") xlabel(,angle(45))  ///
ylabel(0(.2)1.6) ymtick(0(.1)1.7) ytitle("") ///
msymbol(oh oh oh) mcolor(ply1 plr1 plb1)  ///
legend(pos(6) col(3)) title("2016-17") name(bias_enum16, replace)

stripplot ars3 if year==2020 & panel==1, over(username_2020_code) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(4) xtitle("") xlabel(,angle(45))  ///
ylabel(0(.2)1.6) ymtick(0(.1)1.7) ytitle("") ///
msymbol(oh oh oh) mcolor(ply1 plr1 plb1)  ///
legend(pos(6) col(3)) title("2020-21") name(bias_enum20, replace)

graph combine bias_enum16 bias_enum20, name(bias_enum, replace)
*/


********** Reg test
/*
qui reg ars3 ib(1).sex ib(1).caste c.age##c.age ib(freq).edulevel ib(freq).username_2016_code ib(freq).mainocc_occupation_indiv ib(freq).villageid if year==2016 & panel==1, allbaselevels
est store bias16
qui reg ars3 ib(1).sex ib(1).caste c.age##c.age ib(freq).edulevel ib(3).username_2020_code ib(freq).mainocc_occupation_indiv ib(freq).villageid if year==2020 & panel==1, allbaselevels
est store bias20

estout bias16 bias20, cells("b(fmt(3)) p(fmt(2))" se(fmt(2))) stats(N r2 r2_a, fmt(0 2 2)) 
*/

****************************************
* END









****************************************
* Evolution acquiesence bias
****************************************
use"panel_stab_v2_wide", clear

********** Quantile mobility
*** Absolut mobility
tabstat ars32016 ars32020, stat(n mean sd p50 min max range)
/*
total distribution : [0;1.65]
cutoff .2
*/
egen ars32016_cut=cut(ars32016), at(0,.2,.4,.6,.8,1,1.2,1.4,1.6,1.8)
egen ars32020_cut=cut(ars32020), at(0,.2,.4,.6,.8,1,1.2,1.4,1.6,1.8)
*Matrix
tab ars32016_cut ars32020_cut
tab ars32016_cut ars32020_cut, row nofreq
tab ars32016_cut ars32020_cut, col nofreq


*** Pure relative
xtile ars32016_q=ars32016, n(5)
tabstat ars32016, stat(n mean sd p50 min max range) by(ars32016_q)

xtile ars32020_q=ars32020, n(5)
tabstat ars32020, stat(n mean sd p50 min max range) by(ars32020_q)
*Matrix
tab ars32016_q ars32020_q, row nofreq

****************************************
* END













****************************************
* EFA 2016
****************************************
use"panel_stab_v2", clear
keep if year==2016

keep if panel==1

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
global imcorgrit imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm imcr_tryhard imcr_stickwithgoals imcr_goaftergoal imcr_finishwhatbegin imcr_finishtasks imcr_keepworking

global imcor imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm



********** Factor analyses: without grit
minap $imcor

factortest $imcor

factor $imcor, pcf fa(5) // 5
estat kmo
*rotate, promax
rotate, quartimin
*putexcel set "EFA_2016.xlsx", modify sheet(without_panel)
*putexcel (E2)=matrix(e(r_L))


********** omegacoef with Laajaj approach for factor analysis and Cobb Clark
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

*** omegacoef
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

keep if panel==1

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
global imcorgrit imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm imcr_tryhard imcr_stickwithgoals imcr_goaftergoal imcr_finishwhatbegin imcr_finishtasks imcr_keepworking

global imcor imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm


********** CFA first
/*
sem ///
(imcr_appointmentontime imcr_makeplans imcr_completeduties imcr_enthusiastic imcr_organized imcr_workhard imcr_workwithother imcr_putoffduties <- CO) ///
(imcr_easilyupset imcr_worryalot imcr_feeldepressed imcr_nervous imcr_repetitivetasks imcr_shywithpeople imcr_changemood imcr_easilydistracted imcr_rudetoother <- ES) ///
(imcr_expressingthoughts imcr_liketothink imcr_sharefeelings imcr_activeimagination imcr_newideas imcr_talktomanypeople imcr_inventive imcr_curious imcr_talkative imcr_understandotherfeeling imcr_interestedbyart <- EXOP) ///
(imcr_forgiveother imcr_toleratefaults imcr_trustingofother imcr_helpfulwithothers imcr_enjoypeople <-AG) ///
, method(ml) standardized 
*/

********** Factor analyses: without grit
minap $imcor
factortest $imcor
factor $imcor, pcf fa(5) // 2
estat kmo
rotate, quartimin
*putexcel set "EFA_2020.xlsx", modify sheet(without_panel)
*putexcel (E2)=matrix(e(r_L))



********** omegacoef with Laajaj approach for factor analysis and Cobb Clark
** F1
global f1 imcr_worryalot imcr_easilydistracted imcr_feeldepressed imcr_easilyupset imcr_changemood imcr_repetitivetasks imcr_nervous imcr_putoffduties imcr_shywithpeople imcr_rudetoother imcr_enjoypeople imcr_toleratefaults
** F2
global f2 imcr_workhard imcr_enthusiastic imcr_talktomanypeople imcr_appointmentontime imcr_forgiveother imcr_expressingthoughts imcr_interestedbyart imcr_newideas imcr_understandotherfeeling imcr_makeplans imcr_completeduties
** F3
global f3 imcr_trustingofother imcr_inventive imcr_liketothink imcr_curious imcr_sharefeelings imcr_workwithother
** F4
global f4 imcr_organized imcr_helpfulwithothers imcr_staycalm imcr_activeimagination imcr_talkative

*** omegacoef
omegacoef $f1
omegacoef $f2
omegacoef $f3
omegacoef $f4

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
