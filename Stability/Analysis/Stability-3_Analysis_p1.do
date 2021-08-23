cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
August 17, 2021
-----
Stability over time of personality traits: analysis p1
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
set scheme plottig

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
* OMEGA
****************************************
use"panel_stab_v4", clear


/*
original data = 1 always to 5 never: more = never


liketothink_old_1 		original data (alw-->nev)

raw_liketothink_1 		original but 99 recoded to . (alw-->nev)

raw_rec_liketothink_1 	original but 99 recoded to . + all reverse  (nev-->alw)

liketothink_1 			original but 99 recoded to . + all reverse + reverse reversed questions (nev-->alw)

cr_liketothink_1 		original but 99 recoded to . + all reverse + reverse reversed questions (nev-->alw)

In order to calculate omega on subsample, I am using "raw" variable.

global big5 ///
curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination ///
organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties ///
enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts  ///
workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers ///
managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm ///
tryhard  stickwithgoals   goaftergoal finishwhatbegin finishtasks  keepworking
*/



********** LOOP

fre caste
clonevar dalit=caste
recode dalit (3=2)
tab dalit
tab agecat_1

cls
forvalues x=2(1)2{ 
preserve
keep if dalit==`x'
forvalues i=1(1)1{

omega raw_curious_`i' raw_interestedbyart_`i' raw_repetitivetasks_`i' raw_inventive_`i' raw_liketothink_`i' raw_newideas_`i' raw_activeimagination_`i', rev(raw_repetitivetasks_`i')
omega cr_curious_`i' cr_interestedbyart_`i' cr_repetitivetasks_`i' cr_inventive_`i' cr_liketothink_`i' cr_newideas_`i' cr_activeimagination_`i'

omega raw_organized_`i' raw_makeplans_`i' raw_workhard_`i' raw_appointmentontime_`i' raw_putoffduties_`i' raw_easilydistracted_`i' raw_completeduties_`i', rev(raw_putoffduties_`i' raw_easilydistracted_`i')
omega cr_organized_`i' cr_makeplans_`i' cr_workhard_`i' cr_appointmentontime_`i' cr_putoffduties_`i' cr_easilydistracted_`i' cr_completeduties_`i'

omega raw_enjoypeople_`i' raw_sharefeelings_`i' raw_shywithpeople_`i' raw_enthusiastic_`i' raw_talktomanypeople_`i' raw_talkative_`i' raw_expressingthoughts_`i', rev(raw_shywithpeople_`i')
omega cr_enjoypeople_`i' cr_sharefeelings_`i' cr_shywithpeople_`i' cr_enthusiastic_`i' cr_talktomanypeople_`i' cr_talkative_`i' cr_expressingthoughts_`i'

omega raw_workwithother_`i' raw_understandotherfeeling_`i' raw_trustingofother_`i' raw_rudetoother_`i' raw_toleratefaults_`i' raw_forgiveother_`i' raw_helpfulwithothers_`i', rev(raw_rudetoother_`i')
omega cr_workwithother_`i' cr_understandotherfeeling_`i' cr_trustingofother_`i' cr_rudetoother_`i' cr_toleratefaults_`i' cr_forgiveother_`i' cr_helpfulwithothers_`i'


omega raw_managestress_`i' raw_nervous_`i' raw_changemood_`i' raw_feeldepressed_`i' raw_easilyupset_`i' raw_worryalot_`i' raw_staycalm_`i', rev(raw_managestress_`i' raw_staycalm_`i')
omega cr_managestress_`i' cr_nervous_`i' cr_changemood_`i' cr_feeldepressed_`i' cr_easilyupset_`i' cr_worryalot_`i' cr_staycalm_`i'

omega raw_tryhard_`i' raw_stickwithgoals_`i' raw_goaftergoal_`i' raw_finishwhatbegin_`i' raw_finishtasks_`i' raw_keepworking_`i'
omega cr_tryhard_`i' cr_stickwithgoals_`i' cr_goaftergoal_`i' cr_finishwhatbegin_`i' cr_finishtasks_`i' cr_keepworking_`i'
}
restore
}







****************************************
* END
























****************************************
* Cognitive skills
****************************************
use"panel_stab_v4", clear

*Tab
tab1 diff_lit_tt diff_num_tt diff_raven_tt


********** SCATTER
set graph off
twoway (scatter diff_raven_tt age_1 if sex==1) (scatter diff_raven_tt age_1 if sex==2)
twoway (scatter diff_raven_tt age_1 if caste==1) (scatter diff_raven_tt age_1 if caste==2) (scatter diff_raven_tt age_1 if caste==3)

twoway (scatter diff_lit_tt age_1 if sex==1) (scatter diff_lit_tt age_1 if sex==2)
twoway (scatter diff_lit_tt age_1 if caste==1) (scatter diff_lit_tt age_1 if caste==2) (scatter diff_lit_tt age_1 if caste==3)

twoway (scatter diff_num_tt age_1 if sex==1) (scatter diff_num_tt age_1 if sex==2)
twoway (scatter diff_num_tt age_1 if caste==1) (scatter diff_num_tt age_1 if caste==2) (scatter diff_num_tt age_1 if caste==3)

set graph on


********** KERNEL
set graph off
twoway (kdensity diff_raven_tt if sex==1) (kdensity diff_raven_tt   if sex==2)
twoway (kdensity diff_raven_tt if caste==1) (kdensity diff_raven_tt   if caste==2) (kdensity diff_raven_tt if caste==3)

twoway (kdensity diff_lit_tt   if sex==1) (kdensity diff_lit_tt   if sex==2)
twoway (kdensity diff_lit_tt   if caste==1) (kdensity diff_lit_tt   if caste==2) (kdensity diff_lit_tt   if caste==3)

twoway (kdensity diff_num_tt   if sex==1) (kdensity diff_num_tt   if sex==2)
twoway (kdensity diff_num_tt   if caste==1) (kdensity diff_num_tt   if caste==2) (kdensity diff_num_tt   if caste==3)

set graph on



********** CAT PLOT
*ssc install catplot
*Gender
set graph off
foreach x in raven_tt num_tt lit_tt {
catplot sex cat_diff_`x', asyvars percent(sex) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
title(`"`: var label cat_diff_`x''"', size(small)) ///
name(g_`x', replace) legend(col(2) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))
}
grc1leg g_raven_tt g_num_tt g_lit_tt, cols(3) leg(g_raven_tt) name(combage, replace) pos(6)
set graph on
graph save "$git\Analysis\Stability\Analysis\Graph\diff_cog_gender.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diff_cog_gender.svg", as(svg) replace
graph export "$git\Analysis\Stability\Analysis\Graph\diff_cog_gender.pdf", as(pdf) replace

*Caste
set graph off
foreach x in raven_tt num_tt lit_tt {
catplot caste cat_diff_`x', asyvars percent(caste) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
title(`"`: var label cat_diff_`x''"', size(small)) ///
name(g_`x', replace) legend(col(3) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))
}
grc1leg g_raven_tt g_num_tt g_lit_tt, cols(3) leg(g_raven_tt) name(combage, replace) pos(6)
set graph on
graph save "$git\Analysis\Stability\Analysis\Graph\diff_cog_caste.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diff_cog_caste.svg", as(svg) replace
graph export "$git\Analysis\Stability\Analysis\Graph\diff_cog_caste.pdf", as(pdf) replace

*Age
set graph off
foreach x in raven_tt num_tt lit_tt {
catplot agecat_1 cat_diff_`x', asyvars percent(agecat_1) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
title(`"`: var label cat_diff_`x''"', size(small)) ///
name(g_`x', replace) legend(col(2) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))
}
grc1leg g_raven_tt g_num_tt g_lit_tt, cols(3) leg(g_raven_tt) name(combage, replace) pos(6)
set graph on
graph save "$git\Analysis\Stability\Analysis\Graph\diff_cog_age.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diff_cog_age.svg", as(svg) replace
graph export "$git\Analysis\Stability\Analysis\Graph\diff_cog_age.pdf", as(pdf) replace



********** HISTOGRAM
set graph off
histogram diff_raven_tt, percent width(1) xlabel(-36(6)27, labsize(vsmall) ang(0)) xmtick(-36(1)27) ylabel(, labsize(vsmall)) ymtick() xtitle("slope - Raven", size(small)) ytitle(, size(small)) name(g1, replace) note("") title("") legend(off)
histogram diff_num_tt, percent width(1) xlabel(-12(2)12, labsize(vsmall) ang()) ylabel(, labsize(vsmall)) ymtick() xtitle("slope -  Num", size(small)) ytitle(, size(small)) name(g2, replace)  note("") title("") legend(off)
histogram diff_lit_tt, percent width(0.5) xlabel(-4(1)4, labsize(vsmall) ang()) xmtick(-4(0.2)4) ylabel(, labsize(vsmall)) ymtick() xtitle("slope -  Lit", size(small)) ytitle(, size(small)) name(g3, replace)  note("") title("") legend(off)
*Combine
graph combine g1 g2 g3, cols(3)
graph save "$git\Analysis\Stability\Analysis\Graph\diffcont_cog.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diffcont_cog.svg", as(svg) replace
graph export "$git\Analysis\Stability\Analysis\Graph\diffcont_cog.pdf", as(pdf) replace
set graph on 

****************************************
* END


















****************************************
* Bias
****************************************

********** GLOBAL KERNEL
set graph off
twoway ///
(kdensity ars3_1, bwidth(0.15)) ///
(kdensity ars3_2, bwidth(0.15)) ///
, xtitle("Acquiesence bias", size(small)) xlabel(0(0.25)1.75, labsize(vsmall)) legend(order(1 "2016-17" 2 "2020-21") pos(6) col(2)) ytitle("Density", size(small)) ylabel(,labsize(small)) note("Kernel epanechnikov with bandwidth=0.15", size(tiny))
graph save "$git\Analysis\Stability\Analysis\Graph\kernel_ars.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\kernel_ars.svg", as(svg) replace
graph export "$git\Analysis\Stability\Analysis\Graph\kernel_ars.pdf", as(pdf) replace
set graph on




********** SUB KERNEL
set graph off
twoway (kdensity ars3_1 if sex==1, bwidth(0.15)) (kdensity ars3_1 if sex==2, bwidth(0.15)) ///
, title("2016-17", size(medium)) xtitle("Acquiesence bias", size(small)) xlabel(0(0.25)1.75, labsize(vsmall)) legend(order(1 "Male" 2 "Female") pos(6) col(1) off) ytitle("Density", size(small)) ylabel(,labsize(small)) name(g1, replace)
twoway (kdensity ars3_2 if sex==1, bwidth(0.15)) (kdensity ars3_2 if sex==2, bwidth(0.15)) ///
, title("2020-21", size(medium)) xtitle("Acquiesence bias", size(small)) xlabel(0(0.25)1.75, labsize(vsmall)) legend(order(1 "Male" 2 "Female") pos(6) col(1)) ytitle("Density", size(small)) ylabel(,labsize(small))  name(g2, replace)

twoway (kdensity ars3_1 if caste==1, bwidth(0.15)) (kdensity ars3_1 if caste==2, bwidth(0.15)) (kdensity ars3_1 if caste==3, bwidth(0.15)) ///
, xtitle("Acquiesence bias", size(small)) xlabel(0(0.25)1.75, labsize(vsmall)) legend(order(1 "Dalits" 2 "Middle" 3 "Upper") pos(6) col(1) off) ytitle("Density", size(small)) ylabel(,labsize(small)) name(g3, replace)
twoway (kdensity ars3_2 if caste==1, bwidth(0.15)) (kdensity ars3_2 if caste==2, bwidth(0.15)) (kdensity ars3_2 if caste==3, bwidth(0.15)) ///
, xtitle("Acquiesence bias", size(small)) xlabel(0(0.25)1.75, labsize(vsmall)) legend(order(1 "Dalits" 2 "Middle" 3 "Upper") pos(6) col(1)) ytitle("Density", size(small)) ylabel(,labsize(small)) name(g4, replace)

twoway (kdensity ars3_1 if agecat_1==0, bwidth(0.15)) (kdensity ars3_1 if agecat_1==1, bwidth(0.15)) ///
, xtitle("Acquiesence bias", size(small)) xlabel(0(0.25)1.75, labsize(vsmall)) legend(order(1 "30 or less in 2016-17" 2 "More than 30 in 2016-17") pos(6) col(1) off) ytitle("Density", size(small)) ylabel(,labsize(small)) name(g5, replace)
twoway (kdensity ars3_2 if agecat_1==0, bwidth(0.15)) (kdensity ars3_2 if agecat_1==1, bwidth(0.15)) ///
, xtitle("Acquiesence bias", size(small)) xlabel(0(0.25)1.75, labsize(vsmall)) legend(order(1 "30 or less in 2016-17" 2 "More than 30 in 2016-17") pos(6) col(1)) ytitle("Density", size(small)) ylabel(,labsize(small)) name(g6, replace)

grc1leg g1 g2, name(comb1, replace) pos(3)
grc1leg g3 g4, name(comb2, replace) pos(3)
grc1leg g5 g6, name(comb3, replace) pos(3)

graph combine comb1 comb2 comb3, col(1) xcommon note("Kernel epanechnikov with bandwidth=0.15", size(tiny))
graph save "$git\Analysis\Stability\Analysis\Graph\kernel_ars_sub.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\kernel_ars_sub.svg", as(svg) replace
graph export "$git\Analysis\Stability\Analysis\Graph\kernel_ars_sub.pdf", as(pdf) replace
set graph on








********** LINE
pctile ars3_1_p=ars3_1, n(20)
pctile ars3_2_p=ars3_2, n(20)
gen n=_n*5
replace n=. if n>100

set graph off
twoway (line ars3_1_p n) (line ars3_2_p n), xtitle("Percentage of population", size(small)) xlabel(0(10)100, labsize(vsmall)) xmtick(0(5)100) legend(order(1 "2016-17" 2 "2020-21") pos(6) col(2)) ytitle("Acquiesence bias", size(small)) ylabel(0(0.1)1.1, labsize(vsmall)) ymtick(0(0.05)1.1)
graph save "$git\Analysis\Stability\Analysis\Graph\curve_ars.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\curve_ars.svg", as(svg) replace
graph export "$git\Analysis\Stability\Analysis\Graph\curve_ars.pdf", as(pdf) replace
set graph on

drop n ars3_1_p ars3_2_p






********** CATPLOT
set graph off
catplot sex pathars, asyvars percent(sex) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
name(g1, replace) legend(col(2) pos(6) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))

catplot caste pathars, asyvars percent(caste) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
name(g2, replace) legend(col(3) pos(6) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))

catplot agecat_1 pathars, asyvars percent(agecat_1) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
name(g3, replace) legend(col(2) pos(6) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))

graph combine g1 g2 g3, col(3) note("Acquiesence bias", size(tiny))
graph save "$git\Analysis\Stability\Analysis\Graph\path_ars.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\path_ars.svg", as(svg) replace
graph export "$git\Analysis\Stability\Analysis\Graph\path_ars.pdf", as(pdf) replace
set graph on
****************************************
* END
















****************************************
* PERSONALITY TRAITS: CATPLOT
****************************************

********** Corrected vs Non corrected
preserve
foreach x in OP CO EX AG ES Grit {
rename cat_diff_cr_`x' cat_diff_`x'2
rename cat_diff_`x' cat_diff_`x'1
}
gen corr2=1
gen corr1=0
sort HHINDID
reshape long cat_diff_OP cat_diff_CO cat_diff_EX cat_diff_AG cat_diff_ES cat_diff_Grit corr, i(HHINDID) j(n)
order HHINDID corr cat_diff_OP cat_diff_CO cat_diff_EX cat_diff_AG cat_diff_ES cat_diff_Grit
sort HHINDID
*Graph
set graph off
foreach x in OP CO EX AG ES Grit {
catplot corr cat_diff_`x', asyvars percent(corr) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
title("`x'", size(small)) ///
name(g_`x', replace) legend(order(1 "Non-corrected" 2 "Corrected") col(3) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))
}
grc1leg g_OP g_CO g_EX g_AG g_ES, leg(g_OP) pos(6) cols(3)
graph save "$git\Analysis\Stability\Analysis\Graph\diff_cor_ncor.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diff_cor_ncor.svg", as(svg) replace
graph export "$git\Analysis\Stability\Analysis\Graph\diff_cor_ncor.pdf", as(pdf) replace
set graph on
restore



********** Corrected
*ssc install catplot
*Gender
set graph off
foreach x in OP CO EX AG ES {
catplot sex cat_diff_cr_`x', asyvars percent(sex) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
title("`x'", size(small)) ///
name(g_`x', replace) legend(col(2) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))
}
grc1leg g_OP g_CO g_EX g_AG g_ES, cols(2) name(combage, replace) legend(g_OP) pos(6) note("Traits corrected from acquiesence bias.", size(tiny))
graph save "$git\Analysis\Stability\Analysis\Graph\diff_gender_cor.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diff_gender_cor.svg", as(svg) replace
graph export "$git\Analysis\Stability\Analysis\Graph\diff_gender_cor.pdf", as(pdf) replace
set graph on

*Caste
set graph off
foreach x in OP CO EX AG ES {
catplot caste cat_diff_cr_`x', asyvars percent(caste) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
title("`x'", size(small)) ///
name(g_`x', replace) legend(col(3) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))
}
grc1leg g_OP g_CO g_EX g_AG g_ES, cols(2) name(combage, replace) legend(g_OP) pos(6) note("Traits corrected from acquiesence bias.", size(tiny))
set graph on
graph save "$git\Analysis\Stability\Analysis\Graph\diff_caste_cor.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diff_caste_cor.svg", as(svg) replace
graph export "$git\Analysis\Stability\Analysis\Graph\diff_caste_cor.pdf", as(pdf) replace

*Age
set graph off
foreach x in OP CO EX AG ES {
catplot agecat_1 cat_diff_cr_`x', asyvars percent(agecat_1) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
title("`x'", size(small)) ///
name(g_`x', replace) legend(col(2) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))
}
grc1leg g_OP g_CO g_EX g_AG g_ES, cols(2) name(combage, replace) legend(g_OP) pos(6) note("Traits corrected from acquiesence bias.", size(tiny))
set graph on
graph save "$git\Analysis\Stability\Analysis\Graph\diff_age_cor.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diff_age_cor.svg", as(svg) replace
graph export "$git\Analysis\Stability\Analysis\Graph\diff_age_cor.pdf", as(pdf) replace



********** Raw
*ssc install catplot
*Gender
set graph off
foreach x in OP CO EX AG ES {
catplot sex cat_diff_`x', asyvars percent(sex) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
title("`x'", size(small)) ///
name(g_`x', replace) legend(col(2) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))
}
grc1leg g_OP g_CO g_EX g_AG g_ES, cols(2) name(combage, replace) legend(g_OP) pos(6) note("Raw traits (non-corrected from acquiesence bias).", size(tiny))
set graph on
graph save "$git\Analysis\Stability\Analysis\Graph\diff_gender_raw.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diff_gender_raw.svg", as(svg) replace
graph export "$git\Analysis\Stability\Analysis\Graph\diff_gender_raw.pdf", as(pdf) replace

*Caste
set graph off
foreach x in OP CO EX AG ES {
catplot caste cat_diff_`x', asyvars percent(caste) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
title("`x'", size(small)) ///
name(g_`x', replace) legend(col(3) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))
}
grc1leg g_OP g_CO g_EX g_AG g_ES, cols(2) name(combage, replace) legend(g_OP) pos(6) note("Raw traits (non-corrected from acquiesence bias).", size(tiny))
set graph on
graph save "$git\Analysis\Stability\Analysis\Graph\diff_caste_raw.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diff_caste_raw.svg", as(svg) replace
graph export "$git\Analysis\Stability\Analysis\Graph\diff_caste_raw.pdf", as(pdf) replace

*Age
set graph off
foreach x in OP CO EX AG ES {
catplot agecat_1 cat_diff_`x', asyvars percent(agecat_1) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
title("`x'", size(small)) ///
name(g_`x', replace) legend(col(2) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))
}
grc1leg g_OP g_CO g_EX g_AG g_ES, cols(2) name(combage, replace) legend(g_OP) pos(6) note("Raw traits (non-corrected from acquiesence bias).", size(tiny))
set graph on
graph save "$git\Analysis\Stability\Analysis\Graph\diff_age_raw.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diff_age_raw.svg", as(svg) replace
graph export "$git\Analysis\Stability\Analysis\Graph\diff_age_raw.pdf", as(pdf) replace



****************************************
* END


















****************************************
* PERSONALITY TRAITS: HISTOGRAM
****************************************


********** Raw traits
*Density
set graph off
histogram diff_OP, percent width(0.1) xlabel(-4(1)4, labsize(vsmall) ang(0)) xmtick(-4(0.2)4) ylabel(, labsize(vsmall)) ymtick() xtitle("slope - OP", size(small)) ytitle(, size(small)) name(g1, replace) note("") title("") legend(off)
histogram diff_CO, percent width(0.1) xlabel(-4(1)4, labsize(vsmall) ang()) xmtick(-4(0.2)4) ylabel(, labsize(vsmall)) ymtick() xtitle("slope -  CO", size(small)) ytitle(, size(small)) name(g2, replace)  note("") title("") legend(off)
histogram diff_EX, percent width(0.1) xlabel(-4(1)4, labsize(vsmall) ang()) xmtick(-4(0.2)4) ylabel(, labsize(vsmall)) ymtick() xtitle("slope -  EX", size(small)) ytitle(, size(small)) name(g3, replace)  note("") title("") legend(off)
histogram diff_AG, percent width(0.1) xlabel(-4(1)4, labsize(vsmall) ang()) xmtick(-4(0.2)4) ylabel(, labsize(vsmall)) ymtick() xtitle("slope -  AG", size(small)) ytitle(, size(small)) name(g4, replace)  note("") title("") legend(off)
histogram diff_ES, percent width(0.1) xlabel(-4(1)4, labsize(vsmall) ang()) xmtick(-4(0.2)-4) ylabel(, labsize(vsmall)) ymtick() xtitle("slope -  ES", size(small)) ytitle(, size(small)) name(g5, replace)  note("") title("") legend(off)
/*
*Line
twoway ///
(line absdiff_OP_p n, lpattern(solid) lcolor(gs0)) ///
(line absdiff_CO_p n, lpattern(shortdash) lcolor(gs4)) ///
(line absdiff_EX_p n, lpattern(shortdash) lcolor(gs10)) ///
(line absdiff_AG_p n, lpattern(dash) lcolor(gs8)) ///
(line absdiff_ES_p n, lpattern(solid) lcolor(gs12)) ///
, xtitle("Percentage of population", size(small)) xlabel(0(10)100, labsize(vsmall) ang()) xmtick(0(2.5)100) ytitle("|slope|", size(small)) ylabel(0(0.2)2.2, labsize(vsmall)) ymtick(0(0.1)2.2) yline() legend(position(6) col(5) size(vsmall) order(1 "OP" 2 "CO" 3 "EX" 4 "AG" 5 "ES")) name(line2, replace)
*/
*Combine
graph combine g1 g2 g3 g4 g5, cols(3) note("Raw traits (non-corrected from acquiesence bias).", size(tiny))
graph save "$git\Analysis\Stability\Analysis\Graph\diffcont_raw.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diffcont_raw.svg", as(svg) replace
graph export "$git\Analysis\Stability\Analysis\Graph\diffcont_raw.pdf", as(pdf) replace
set graph on 



********** Cor traits
*Density
set graph off
histogram diff_cr_OP, percent width(0.1) xlabel(-4(1)4, labsize(vsmall) ang(0)) xmtick(-4(0.2)4) ylabel(, labsize(vsmall)) ymtick() xtitle("slope - OP", size(small)) ytitle(, size(small)) name(g1, replace) note("") title("") legend(off)
histogram diff_cr_CO, percent width(0.1) xlabel(-4(1)4, labsize(vsmall) ang()) xmtick(-4(0.2)4) ylabel(, labsize(vsmall)) ymtick() xtitle("slope -  CO", size(small)) ytitle(, size(small)) name(g2, replace)  note("") title("") legend(off)
histogram diff_cr_EX, percent width(0.1) xlabel(-4(1)4, labsize(vsmall) ang()) xmtick(-4(0.2)4) ylabel(, labsize(vsmall)) ymtick() xtitle("slope -  EX", size(small)) ytitle(, size(small)) name(g3, replace)  note("") title("") legend(off)
histogram diff_cr_AG, percent width(0.1) xlabel(-4(1)4, labsize(vsmall) ang()) xmtick(-4(0.2)4) ylabel(, labsize(vsmall)) ymtick() xtitle("slope -  AG", size(small)) ytitle(, size(small)) name(g4, replace)  note("") title("") legend(off)
histogram diff_cr_ES, percent width(0.1) xlabel(-4(1)4, labsize(vsmall) ang()) xmtick(-4(0.2)-4) ylabel(, labsize(vsmall)) ymtick() xtitle("slope -  ES", size(small)) ytitle(, size(small)) name(g5, replace)  note("") title("") legend(off)
/*
*Line
twoway ///
(line absdiff_cr_OP_p n, lpattern(solid) lcolor(gs0)) ///
(line absdiff_cr_CO_p n, lpattern(shortdash) lcolor(gs4)) ///
(line absdiff_cr_EX_p n, lpattern(shortdash) lcolor(gs10)) ///
(line absdiff_cr_AG_p n, lpattern(dash) lcolor(gs8)) ///
(line absdiff_cr_ES_p n, lpattern(solid) lcolor(gs12)) ///
, xtitle("Percentage of population", size(small)) xlabel(0(10)100, labsize(vsmall) ang(45)) xmtick(0(2.5)100) ytitle("|Δ|", size(small)) ylabel(0(10)70, labsize(vsmall)) ymtick(0(5)70) yline() legend(position(6) col(5) size(vsmall) order(1 "Openness" 2 "Conscientiousness" 3 "Extraversion" 4 "Agreeableness" 5 "Emotional stability")) name(line2, replace)
*/
*Combine
graph combine g1 g2 g3 g4 g5, cols(3) note("Traits corrected from acquiesence bias.", size(tiny))
graph save "$git\Analysis\Stability\Analysis\Graph\diffcont_cor.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diffcont_cor.svg", as(svg) replace
graph export "$git\Analysis\Stability\Analysis\Graph\diffcont_cor.pdf", as(pdf) replace
set graph on 

****************************************
* END
