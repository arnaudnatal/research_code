cls

/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
October 25, 2021
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
set scheme plotplain

********** Path to folder "data" folder.
*** PC
global directory = "D:\Documents\_Thesis\Research-Stability_skills\Analysis"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

*** Fac
*global directory = "C:\Users\anatal\Downloads\_Thesis\Research-Stability_skills\Analysis"
*cd "$directory"
*global git "C:\Users\anatal\Downloads\GitHub"

********** Name of the NEEMSIS2 questionnaire version to clean
global wave2 "NEEMSIS1-HH_v9"
global wave3 "NEEMSIS2-HH_v21"
****************************************
* END





****************************************
* EFA interpretations
****************************************
/*
********** 2016
*** with
F1 as CO-GR
F2 as ES
F3 as OP-EX
F4 as mix
F5 as ES-CO
F6 as AG

*** without
F1 as CO
F2 as ES
F3 as EX-OP
F4 as ES-CO
F5 as AG


********** 2020
*** with
F1 as ES
F2 as mix
F3 as mix
F4 as OP
F5 as mix
F6 as mix

*** without
F1 as ES
F2 as EX-CO
F3 as OP (OP-EX)
F4 as mix
F5 as EX-mix

*/
****************************************
* END










****************************************
* Formation
****************************************
use"panel_stab_v2_wide", clear

merge 1:1 HHID_panel INDID_panel using "panel_stab_v2_2016"
drop _merge
merge 1:1 HHID_panel INDID_panel using "panel_stab_v2_2020"
drop _merge



********** 2016
drop canreadcard1a2016 canreadcard1b2016 canreadcard1c2016 canreadcard22016 numeracy12016 numeracy22016 numeracy32016 numeracy42016 a12016 a22016 a32016 a42016 a52016 a62016 a72016 a82016 a92016 a102016 a112016 a122016 ab12016 ab22016 ab32016 ab42016 ab52016 ab62016 ab72016 ab82016 ab92016 ab102016 ab112016 ab122016 b12016 b22016 b32016 b42016 b52016 b62016 b72016 b82016 b92016 b102016 b112016 b122016

drop curious2016 interestedbyart2016 repetitivetasks2016 inventive2016 liketothink2016 newideas2016 activeimagination2016 organized2016 makeplans2016 workhard2016 appointmentontime2016 putoffduties2016 easilydistracted2016 completeduties2016 enjoypeople2016 sharefeelings2016 shywithpeople2016 enthusiastic2016 talktomanypeople2016 talkative2016 expressingthoughts2016 workwithother2016 understandotherfeeling2016 trustingofother2016 rudetoother2016 toleratefaults2016 forgiveother2016 helpfulwithothers2016 managestress2016 nervous2016 changemood2016 feeldepressed2016 easilyupset2016 worryalot2016 staycalm2016 tryhard2016 stickwithgoals2016 goaftergoal2016 finishwhatbegin2016 finishtasks2016 keepworking2016

drop ra12016 rab12016 rb12016 ra22016 rab22016 rb22016 ra32016 rab32016 rb32016 ra42016 rab42016 rb42016 ra52016 rab52016 rb52016 ra62016 rab62016 rb62016 ra72016 rab72016 rb72016 ra82016 rab82016 rb82016 ra92016 rab92016 rb92016 ra102016 rab102016 rb102016 ra112016 rab112016 rb112016 ra122016 rab122016 rb122016 set_a2016 set_ab2016 set_b2016

drop _1_ars2016 _1_ars22016 _1_ars32016 _2_ars2016 _2_ars22016 _2_ars32016 _3_ars2016 _3_ars22016 _3_ars32016 _4_ars2016 _4_ars22016 _4_ars32016 _5_ars2016 _5_ars22016 _5_ars32016 _6_ars2016 _6_ars22016 _6_ars32016 _7_ars2016 _7_ars22016 _7_ars32016 ars2_AG2016 ars3_AG2016 ars2_CO2016 ars3_CO2016 ars2_EX2016 ars3_EX2016 ars2_OP2016 ars3_OP2016 ars2_ES2016 ars3_ES2016

drop cr_curious2016 cr_interestedbyart2016 cr_repetitivetasks2016 cr_inventive2016 cr_liketothink2016 cr_newideas2016 cr_activeimagination2016 cr_organized2016 cr_makeplans2016 cr_workhard2016 cr_appointmentontime2016 cr_putoffduties2016 cr_easilydistracted2016 cr_completeduties2016 cr_enjoypeople2016 cr_sharefeelings2016 cr_shywithpeople2016 cr_enthusiastic2016 cr_talktomanypeople2016 cr_talkative2016 cr_expressingthoughts2016 cr_workwithother2016 cr_understandotherfeeling2016 cr_trustingofother2016 cr_rudetoother2016 cr_toleratefaults2016 cr_forgiveother2016 cr_helpfulwithothers2016 cr_managestress2016 cr_nervous2016 cr_changemood2016 cr_feeldepressed2016 cr_easilyupset2016 cr_worryalot2016 cr_staycalm2016 cr_tryhard2016 cr_stickwithgoals2016 cr_goaftergoal2016 cr_finishwhatbegin2016 cr_finishtasks2016 cr_keepworking2016


********** 2020
drop canreadcard1a2020 canreadcard1b2020 canreadcard1c2020 canreadcard22020 numeracy12020 numeracy22020 numeracy32020 numeracy42020 a12020 a22020 a32020 a42020 a52020 a62020 a72020 a82020 a92020 a102020 a112020 a122020 ab12020 ab22020 ab32020 ab42020 ab52020 ab62020 ab72020 ab82020 ab92020 ab102020 ab112020 ab122020 b12020 b22020 b32020 b42020 b52020 b62020 b72020 b82020 b92020 b102020 b112020 b122020

drop curious2020 interestedbyart2020 repetitivetasks2020 inventive2020 liketothink2020 newideas2020 activeimagination2020 organized2020 makeplans2020 workhard2020 appointmentontime2020 putoffduties2020 easilydistracted2020 completeduties2020 enjoypeople2020 sharefeelings2020 shywithpeople2020 enthusiastic2020 talktomanypeople2020 talkative2020 expressingthoughts2020 workwithother2020 understandotherfeeling2020 trustingofother2020 rudetoother2020 toleratefaults2020 forgiveother2020 helpfulwithothers2020 managestress2020 nervous2020 changemood2020 feeldepressed2020 easilyupset2020 worryalot2020 staycalm2020 tryhard2020 stickwithgoals2020 goaftergoal2020 finishwhatbegin2020 finishtasks2020 keepworking2020

drop ra12020 rab12020 rb12020 ra22020 rab22020 rb22020 ra32020 rab32020 rb32020 ra42020 rab42020 rb42020 ra52020 rab52020 rb52020 ra62020 rab62020 rb62020 ra72020 rab72020 rb72020 ra82020 rab82020 rb82020 ra92020 rab92020 rb92020 ra102020 rab102020 rb102020 ra112020 rab112020 rb112020 ra122020 rab122020 rb122020 set_a2020 set_ab2020 set_b2020

drop _1_ars2020 _1_ars22020 _1_ars32020 _2_ars2020 _2_ars22020 _2_ars32020 _3_ars2020 _3_ars22020 _3_ars32020 _4_ars2020 _4_ars22020 _4_ars32020 _5_ars2020 _5_ars22020 _5_ars32020 _6_ars2020 _6_ars22020 _6_ars32020 _7_ars2020 _7_ars22020 _7_ars32020 ars2_AG2020 ars3_AG2020 ars2_CO2020 ars3_CO2020 ars2_EX2020 ars3_EX2020 ars2_OP2020 ars3_OP2020 ars2_ES2020 ars3_ES2020

drop cr_curious2020 cr_interestedbyart2020 cr_repetitivetasks2020 cr_inventive2020 cr_liketothink2020 cr_newideas2020 cr_activeimagination2020 cr_organized2020 cr_makeplans2020 cr_workhard2020 cr_appointmentontime2020 cr_putoffduties2020 cr_easilydistracted2020 cr_completeduties2020 cr_enjoypeople2020 cr_sharefeelings2020 cr_shywithpeople2020 cr_enthusiastic2020 cr_talktomanypeople2020 cr_talkative2020 cr_expressingthoughts2020 cr_workwithother2020 cr_understandotherfeeling2020 cr_trustingofother2020 cr_rudetoother2020 cr_toleratefaults2020 cr_forgiveother2020 cr_helpfulwithothers2020 cr_managestress2020 cr_nervous2020 cr_changemood2020 cr_feeldepressed2020 cr_easilyupset2020 cr_worryalot2020 cr_staycalm2020 cr_tryhard2020 cr_stickwithgoals2020 cr_goaftergoal2020 cr_finishwhatbegin2020 cr_finishtasks2020 cr_keepworking2020


save "panel_stab_wide_v3", replace
****************************************
* END







****************************************
* Stability of ES
****************************************
use "panel_stab_wide_v3", clear
set graph on

********** Calculation
*** Naive Big-5
gen diff_cr_ES=cr_ES2020-cr_ES2016
xtile diff_cr_ES_cat=diff_cr_ES, n(10)
tabstat diff_cr_ES, stat(n mean sd p50 min max range) by(diff_cr_ES_cat)

*** Factor analysis
rename f2_without_2016 fa_ES2016
rename f1_without_2020 fa_ES2020
gen diff_fa_ES=fa_ES2020-fa_ES2016
xtile diff_fa_ES_cat=diff_fa_ES, n(10)
tabstat diff_fa_ES, stat(n mean sd p50 min max range) by(diff_fa_ES_cat)

*** Are individuals the same?
tab diff_cr_ES_cat diff_fa_ES_cat


*** Stat
tabstat diff_cr_ES diff_fa_ES, stat(n mean sd p50)

*** Graph: histogram
histogram diff_cr_ES, percent width(0.1) xlabel(-4(1)4, labsize(vsmall) ang(0)) xmtick(-4(0.2)4) ylabel(, labsize(vsmall)) ymtick() xtitle("Δ ES", size(small)) ytitle(, size(small)) note("") title("") legend(off)

histogram diff_fa_ES, percent width(0.1) xlabel(-4(1)4, labsize(vsmall) ang(0)) xmtick(-4(0.2)4) ylabel(, labsize(vsmall)) ymtick() xtitle("Δ ES", size(small)) ytitle(, size(small)) note("") title("") legend(off)


*** Graph: boxplot
stripplot diff_cr_ES, over() separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(,angle(0))  ///
msymbol(+ + +) mcolor(black black black)  ///
ylabel() ymtick() ytitle("") ///
note("2016: n=835" "2020: n=835", size(vsmall)) ///
legend(order(1 "Mean" 5 "Individual"))





********** Categorisation + matrix
*** Categorisation
tabstat cr_ES2016 cr_ES2020, stat(n mean sd p50 min max range)
egen cr_ES2016_cut=cut(cr_ES2016), at(0,1,2,3,4,5,6)
egen cr_ES2020_cut=cut(cr_ES2020), at(0,1,2,3,4,5,6)

tab cr_ES2016_cut cr_ES2020_cut
tab cr_ES2016_cut cr_ES2020_cut, nofreq row

****************************************
* END
