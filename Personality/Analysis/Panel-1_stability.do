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
global directory = "D:\Documents\_Thesis\Research-Skills_and_debt\Analysis"
cd"$directory"

*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
*set scheme plotplain

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
* Stability
****************************************

********** 2016 prépa
use "$wave2", clear
keep if egoid>0
egen HHINDID=concat(HHID_panel INDID_panel), p(/)
duplicates tag HHINDID, gen(tag)
tab tag

sort lit_tt

save"$wave2~ego", replace


********** 
use"$wave3", clear
/*
global big5 ///
curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination ///
organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties ///
enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts  ///
workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers ///
managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm ///
tryhard  stickwithg~s   goaftergoal finishwhat~n finishtasks  keepworking ars ars2 ars3
*/
merge m:1 HHID_panel using "panel", nogen keep(3)
keep if egoid>0


********** Rename 2020 perso
foreach x in cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit lit_tt num_tt raven_tt age ars ars2 ars3{
rename `x' `x'_2020
}

********** Merge with 2016 values
merge 1:1 HHID_panel INDID_panel using "$wave2~ego", keepusing (cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit lit_tt num_tt raven_tt age ars ars2 ars3)
*Gen delta
foreach x in cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit ars ars2 ars3{
gen delta_`x'=((`x'_2020-`x')*100/`x')
}
*Gen abs delta
foreach x in cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit ars ars2 ars3{
gen absdelta_`x'=abs(delta_`x')
}


*Stability as categorical variable
foreach x in delta_cr_OP delta_cr_CO delta_cr_EX delta_cr_AG delta_cr_ES delta_cr_Grit delta_OP delta_CO delta_EX delta_AG delta_ES delta_Grit{
gen cat_`x'=0 if _merge==3
}
foreach x in delta_cr_OP delta_cr_CO delta_cr_EX delta_cr_AG delta_cr_ES delta_cr_Grit delta_OP delta_CO delta_EX delta_AG delta_ES delta_Grit{
replace cat_`x'=1 if `x'<=-50 & cat_`x'==0  // 				]-inf;-50]
replace cat_`x'=2 if `x'<=-20 & `x'>-50 & cat_`x'==0  // 	]-50;-20]
replace cat_`x'=3 if `x'<=-10 & `x'>-20 & cat_`x'==0 //		]-20;-10]
replace cat_`x'=4 if `x'<=-5 & `x'>-10 & cat_`x'==0 // 		]-10;-5]

replace cat_`x'=5 if `x'>-5 & `x'<5 & cat_`x'==0 //		]-5;5[

replace cat_`x'=6 if `x'>=5 & `x'<10 & cat_`x'==0 //			[5;10[
replace cat_`x'=7 if `x'>=10 & `x'<20 & cat_`x'==0
replace cat_`x'=8 if `x'>=20 & `x'<50 & cat_`x'==0
replace cat_`x'=9 if `x'>=50 & cat_`x'==0
}
label define varcat 1"]-∞;-50]" 2"]-50;-20]" 3"]-20;-10]" 4"]-10;-5]" 5"]-5;5[" 6"[5;10[" 7"[10;20[" 8"[20;50[" 9"[50;+∞[", replace
foreach x in delta_cr_OP delta_cr_CO delta_cr_EX delta_cr_AG delta_cr_ES delta_cr_Grit delta_OP delta_CO delta_EX delta_AG delta_ES delta_Grit{
label values cat_`x' varcat
}

cls
tab1 cat_delta_cr_OP cat_delta_cr_CO cat_delta_cr_EX cat_delta_cr_AG cat_delta_cr_ES cat_delta_cr_Grit cat_delta_OP cat_delta_CO cat_delta_EX cat_delta_AG cat_delta_ES cat_delta_Grit

********* Age
gen agecat1=0 		if age_2020<=34
replace agecat1=1 	if age_2020>34 & age_2020!=.
label define age 0"];30] 2016-17" 1"]30;[ 2016-17"
label values agecat1 age

/*
********** Bias
*** Kernel
set graph off
twoway ///
(kdensity ars3, bwidth(0.15)) ///
(kdensity ars3_2020, bwidth(0.15)) ///
, xtitle("Acquiesence bias", size(small)) xlabel(0(0.25)1.75, labsize(vsmall)) legend(order(1 "2016-17" 2 "2020-21") pos(6) col(2)) ytitle("Density", size(small)) ylabel(,labsize(small)) note("Kernel epanechnikov with bandwidth=0.15", size(tiny))
graph save "$git\Analysis\Personality\Big-5\kernel_ars.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\kernel_ars.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\kernel_ars.pdf", as(pdf) replace
set graph on

*** Kernel over sex caste and age per year
set graph off
twoway (kdensity ars3 if sex==1, bwidth(0.15)) (kdensity ars3 if sex==2, bwidth(0.15)) ///
, title("2016-17", size(medium)) xtitle("Acquiesence bias", size(small)) xlabel(0(0.25)1.75, labsize(vsmall)) legend(order(1 "Male" 2 "Female") pos(6) col(1) off) ytitle("Density", size(small)) ylabel(,labsize(small)) name(g1, replace)
twoway (kdensity ars3_2020 if sex==1, bwidth(0.15)) (kdensity ars3_2020 if sex==2, bwidth(0.15)) ///
, title("2020-21", size(medium)) xtitle("Acquiesence bias", size(small)) xlabel(0(0.25)1.75, labsize(vsmall)) legend(order(1 "Male" 2 "Female") pos(6) col(1)) ytitle("Density", size(small)) ylabel(,labsize(small))  name(g2, replace)

twoway (kdensity ars3 if caste==1, bwidth(0.15)) (kdensity ars3 if caste==2, bwidth(0.15)) (kdensity ars3 if caste==3, bwidth(0.15)) ///
, xtitle("Acquiesence bias", size(small)) xlabel(0(0.25)1.75, labsize(vsmall)) legend(order(1 "Dalits" 2 "Middle" 3 "Upper") pos(6) col(1) off) ytitle("Density", size(small)) ylabel(,labsize(small)) name(g3, replace)
twoway (kdensity ars3_2020 if caste==1, bwidth(0.15)) (kdensity ars3_2020 if caste==2, bwidth(0.15)) (kdensity ars3_2020 if caste==3, bwidth(0.15)) ///
, xtitle("Acquiesence bias", size(small)) xlabel(0(0.25)1.75, labsize(vsmall)) legend(order(1 "Dalits" 2 "Middle" 3 "Upper") pos(6) col(1)) ytitle("Density", size(small)) ylabel(,labsize(small)) name(g4, replace)

twoway (kdensity ars3 if caste==1, bwidth(0.15)) (kdensity ars3 if caste==2, bwidth(0.15)) ///
, xtitle("Acquiesence bias", size(small)) xlabel(0(0.25)1.75, labsize(vsmall)) legend(order(1 "];30] 2016-17" 2 "]30;[ 2016-17") pos(6) col(1) off) ytitle("Density", size(small)) ylabel(,labsize(small)) name(g5, replace)
twoway (kdensity ars3_2020 if agecat1==0, bwidth(0.15)) (kdensity ars3_2020 if agecat1==1, bwidth(0.15)) ///
, xtitle("Acquiesence bias", size(small)) xlabel(0(0.25)1.75, labsize(vsmall)) legend(order(1 "];30] 2016-17" 2 "]30;[ 2016-17") pos(6) col(1)) ytitle("Density", size(small)) ylabel(,labsize(small)) name(g6, replace)

grc1leg g1 g2, name(comb1, replace) pos(3)
grc1leg g3 g4, name(comb2, replace) pos(3)
grc1leg g5 g6, name(comb3, replace) pos(3)

graph combine comb1 comb2 comb3, col(1) xcommon note("Kernel epanechnikov with bandwidth=0.15", size(tiny))
graph save "$git\Analysis\Personality\Big-5\kernel_ars_sub.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\kernel_ars_sub.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\kernel_ars_sub.pdf", as(pdf) replace
set graph on


*** Line
pctile ars3_p=ars3, n(20)
pctile ars3_2020_p=ars3_2020, n(20)
gen n=_n*5
replace n=. if n>100

set graph off
twoway (line ars3_p n) (line ars3_2020_p n), xtitle("Percentage of population", size(small)) xlabel(0(10)100, labsize(vsmall)) xmtick(0(5)100) legend(order(1 "2016-17" 2 "2020-21") pos(6) col(2)) ytitle("Acquiesence bias", size(small)) ylabel(0(0.1)1.1, labsize(vsmall)) ymtick(0(0.05)1.1)
graph save "$git\Analysis\Personality\Big-5\curve_ars.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\curve_ars.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\curve_ars.pdf", as(pdf) replace
set graph on

drop n ars3_p ars3_2020_p

*** Variation
gen pathars=.
replace pathars=1 if ars3>=0.5 & ars3_2020>=0.5 & ars3!=. & ars3_2020!=.  // tjrs
replace pathars=2 if ars3<0.5 & ars3_2020>=0.5 & ars3!=. & ars3_2020!=.  // devenu
replace pathars=3 if ars3>=0.5 & ars3_2020<0.5 & ars3!=. & ars3_2020!=.  // sort
replace pathars=4 if ars3<0.5 & ars3_2020<0.5 & ars3!=. & ars3_2020!=.  // jamais
tab pathars sex

label define pathars 1"Always biased" 2"Becomes biased" 3"Leave bias" 4"Never biased"
label values pathars pathars

set graph off
catplot sex pathars, asyvars percent(sex) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
name(g1, replace) legend(col(2) pos(6) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))

catplot caste pathars, asyvars percent(caste) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
name(g2, replace) legend(col(3) pos(6) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))

catplot agecat1 pathars, asyvars percent(agecat1) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
name(g3, replace) legend(col(2) pos(6) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))

graph combine g1 g2 g3, col(3) note("Acquiesence bias", size(tiny))
graph save "$git\Analysis\Personality\Big-5\path_ars.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\path_ars.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\path_ars.pdf", as(pdf) replace
set graph on


********** Corrected
*ssc install catplot
*Gender
set graph off
foreach x in OP CO EX AG ES {
catplot sex cat_delta_cr_`x', asyvars percent(sex) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
title("`x'", size(small)) ///
name(g_`x', replace) legend(col(2) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))
}
grc1leg g_OP g_CO g_EX g_AG g_ES, cols(2) name(combage, replace) legend(g_OP) pos(6) note("Traits corrected from acquiesence bias.", size(tiny))
set graph on
graph save "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\delta_gender_cor.gph", replace
graph export "C:\Users\Arnaud\Documents\GitHub\RUME-NEEMSIS\Big-5\delta_gender_cor.svg", as(svg) replace
graph export "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\delta_gender_cor.pdf", as(pdf) replace

*Caste
set graph off
foreach x in OP CO EX AG ES {
catplot caste cat_delta_cr_`x', asyvars percent(caste) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
title("`x'", size(small)) ///
name(g_`x', replace) legend(col(3) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))
}
grc1leg g_OP g_CO g_EX g_AG g_ES, cols(2) name(combage, replace) legend(g_OP) pos(6) note("Traits corrected from acquiesence bias.", size(tiny))
set graph on
graph save "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\delta_caste_cor.gph", replace
graph export "C:\Users\Arnaud\Documents\GitHub\RUME-NEEMSIS\Big-5\delta_caste_cor.svg", as(svg) replace
graph export "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\delta_caste_cor.pdf", as(pdf) replace

*Age
set graph off
foreach x in OP CO EX AG ES {
catplot agecat1 cat_delta_cr_`x', asyvars percent(agecat1) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
title("`x'", size(small)) ///
name(g_`x', replace) legend(col(2) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))
}
grc1leg g_OP g_CO g_EX g_AG g_ES, cols(2) name(combage, replace) legend(g_OP) pos(6) note("Traits corrected from acquiesence bias.", size(tiny))
set graph on
graph save "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\delta_age_cor.gph", replace
graph export "C:\Users\Arnaud\Documents\GitHub\RUME-NEEMSIS\Big-5\delta_age_cor.svg", as(svg) replace
graph export "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\delta_age_cor.pdf", as(pdf) replace


********** Raw
*ssc install catplot
*Gender
set graph off
foreach x in OP CO EX AG ES {
catplot sex cat_delta_`x', asyvars percent(sex) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
title("`x'", size(small)) ///
name(g_`x', replace) legend(col(2) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))
}
grc1leg g_OP g_CO g_EX g_AG g_ES, cols(2) name(combage, replace) legend(g_OP) pos(6) note("Raw traits (non-corrected from acquiesence bias).", size(tiny))
set graph on
graph save "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\delta_gender_raw.gph", replace
graph export "C:\Users\Arnaud\Documents\GitHub\RUME-NEEMSIS\Big-5\delta_gender_raw.svg", as(svg) replace
graph export "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\delta_gender_raw.pdf", as(pdf) replace

*Caste
set graph off
foreach x in OP CO EX AG ES {
catplot caste cat_delta_`x', asyvars percent(caste) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
title("`x'", size(small)) ///
name(g_`x', replace) legend(col(3) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))
}
grc1leg g_OP g_CO g_EX g_AG g_ES, cols(2) name(combage, replace) legend(g_OP) pos(6) note("Raw traits (non-corrected from acquiesence bias).", size(tiny))
set graph on
graph save "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\delta_caste_raw.gph", replace
graph export "C:\Users\Arnaud\Documents\GitHub\RUME-NEEMSIS\Big-5\delta_caste_raw.svg", as(svg) replace
graph export "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\delta_caste_raw.pdf", as(pdf) replace

*Age
set graph off
foreach x in OP CO EX AG ES {
catplot agecat1 cat_delta_`x', asyvars percent(agecat1) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
title("`x'", size(small)) ///
name(g_`x', replace) legend(col(2) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))
}
grc1leg g_OP g_CO g_EX g_AG g_ES, cols(2) name(combage, replace) legend(g_OP) pos(6) note("Raw traits (non-corrected from acquiesence bias).", size(tiny))
set graph on
graph save "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\delta_age_raw.gph", replace
graph export "C:\Users\Arnaud\Documents\GitHub\RUME-NEEMSIS\Big-5\delta_age_raw.svg", as(svg) replace
graph export "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\delta_age_raw.pdf", as(pdf) replace




********** Graphical
*For line 
foreach x in absdelta_cr_OP absdelta_cr_CO absdelta_cr_EX absdelta_cr_AG absdelta_cr_ES absdelta_cr_Grit absdelta_OP absdelta_CO absdelta_EX absdelta_AG absdelta_ES absdelta_Grit {
pctile `x'_p=`x', n(20)
}
gen n=_n*5
replace n=. if n>100


********** Raw traits
*Density
set graph off
kdensity delta_OP, lpattern(solid) lcolor(gs0) bwidth(0.1) xlabel(-60(20)250, labsize(vsmall) ang(45)) xmtick(-60(5)255) ylabel(, labsize(vsmall)) ymtick() xtitle("Δ Openness", size(small)) ytitle(, size(small)) name(g1, replace) note("") title("")
kdensity delta_CO, lpattern(shortdash) lcolor(gs4) bwidth(0.1) xlabel(-60(20)130, labsize(vsmall) ang(45)) xmtick(-60(5)130) ylabel(, labsize(vsmall)) ymtick() xtitle("Δ Conscientiousness", size(small)) ytitle(, size(small)) name(g2, replace)  note("") title("")
kdensity delta_EX, lpattern(shortdash) lcolor(gs10) bwidth(0.1) xlabel(-60(20)150, labsize(vsmall) ang(45)) xmtick(-60(5)150) ylabel(, labsize(vsmall)) ymtick() xtitle("Δ Extraversion", size(small)) ytitle(, size(small)) name(g3, replace)  note("") title("")
kdensity delta_AG, lpattern(dash) lcolor(gs8) bwidth(0.1) xlabel(-60(20)90, labsize(vsmall) ang(45)) xmtick(-60(5)90) ylabel(, labsize(vsmall)) ymtick() xtitle("Δ Agreeableness", size(small)) ytitle(, size(small)) name(g4, replace)  note("") title("")
kdensity delta_ES, lpattern(solid) lcolor(gs12) bwidth(0.1) xlabel(-60(20)210, labsize(vsmall) ang(45)) xmtick(-60(5)210) ylabel(, labsize(vsmall)) ymtick() xtitle("Δ Emotional stability", size(small)) ytitle(, size(small)) name(g5, replace)  note("") title("")
*Line
twoway ///
(line absdelta_OP_p n, lpattern(solid) lcolor(gs0)) ///
(line absdelta_CO_p n, lpattern(shortdash) lcolor(gs4)) ///
(line absdelta_EX_p n, lpattern(shortdash) lcolor(gs10)) ///
(line absdelta_AG_p n, lpattern(dash) lcolor(gs8)) ///
(line absdelta_ES_p n, lpattern(solid) lcolor(gs12)) ///
, xtitle("Percentage of population", size(small)) xlabel(0(10)100, labsize(vsmall) ang(45)) xmtick(0(2.5)100) ytitle("|Δ|", size(small)) ylabel(0(10)125, labsize(vsmall)) ymtick(0(5)125) yline() legend(position(6) col(5) size(vsmall) order(1 "Openness" 2 "Conscientiousness" 3 "Extraversion" 4 "Agreeableness" 5 "Emotional stability")) name(line2, replace)
*Combine
grc1leg g1 g2 g3 g4 g5 line2, cols(3) leg(line2) pos(6) note("Raw traits (non-corrected from acquiesence bias)." "Density: kernel epanechnikov with bandwidth=0.1", size(tiny))
graph save "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\deltacont_raw.gph", replace
graph export "C:\Users\Arnaud\Documents\GitHub\RUME-NEEMSIS\Big-5\deltacont_raw.svg", as(svg) replace
graph export "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\deltacont_raw.pdf", as(pdf) replace
set graph on 



********** Cor traits
*Density
set graph off
kdensity delta_cr_OP, lpattern(solid) lcolor(gs0) bwidth(0.1) xlabel(-60(20)200, labsize(vsmall) ang(45)) xmtick(-60(5)200) ylabel(, labsize(vsmall)) ymtick() xtitle("Δ Openness", size(small)) ytitle(, size(small)) name(g1, replace) note("") title("")
kdensity delta_cr_CO, lpattern(shortdash) lcolor(gs4) bwidth(0.1) xlabel(-80(20)90, labsize(vsmall) ang(45)) xmtick(-75(5)95) ylabel(, labsize(vsmall)) ymtick() xtitle("Δ Conscientiousness", size(small)) ytitle(, size(small)) name(g2, replace)  note("") title("")
kdensity delta_cr_EX, lpattern(shortdash) lcolor(gs10) bwidth(0.1) xlabel(-60(20)100, labsize(vsmall) ang(45)) xmtick(-65(5)100) ylabel(, labsize(vsmall)) ymtick() xtitle("Δ Extraversion", size(small)) ytitle(, size(small)) name(g3, replace)  note("") title("")
kdensity delta_cr_AG, lpattern(dash) lcolor(gs8) bwidth(0.1) xlabel(-60(20)120, labsize(vsmall) ang(45)) xmtick(-65(5)120) ylabel(, labsize(vsmall)) ymtick() xtitle("Δ Agreeableness", size(small)) ytitle(, size(small)) name(g4, replace)  note("") title("")
kdensity delta_cr_ES, lpattern(solid) lcolor(gs12) bwidth(0.1) xlabel(-90(45)630, labsize(vsmall) ang(45)) xmtick(-90(15)650) ylabel(, labsize(vsmall)) ymtick() xtitle("Δ Emotional stability", size(small)) ytitle(, size(small)) name(g5, replace)  note("") title("")
*Line
twoway ///
(line absdelta_cr_OP_p n, lpattern(solid) lcolor(gs0)) ///
(line absdelta_cr_CO_p n, lpattern(shortdash) lcolor(gs4)) ///
(line absdelta_cr_EX_p n, lpattern(shortdash) lcolor(gs10)) ///
(line absdelta_cr_AG_p n, lpattern(dash) lcolor(gs8)) ///
(line absdelta_cr_ES_p n, lpattern(solid) lcolor(gs12)) ///
, xtitle("Percentage of population", size(small)) xlabel(0(10)100, labsize(vsmall) ang(45)) xmtick(0(2.5)100) ytitle("|Δ|", size(small)) ylabel(0(10)70, labsize(vsmall)) ymtick(0(5)70) yline() legend(position(6) col(5) size(vsmall) order(1 "Openness" 2 "Conscientiousness" 3 "Extraversion" 4 "Agreeableness" 5 "Emotional stability")) name(line2, replace)
*Combine
grc1leg g1 g2 g3 g4 g5 line2, cols(3) leg(line2) pos(6) note("Traits corrected from acquiesence bias." "Density: kernel epanechnikov with bandwidth=0.1", size(tiny))
graph save "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\deltacont_cor.gph", replace
graph export "C:\Users\Arnaud\Documents\GitHub\RUME-NEEMSIS\Big-5\deltacont_cor.svg", as(svg) replace
graph export "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\deltacont_cor.pdf", as(pdf) replace
set graph on 

drop absdelta_cr_OP_p absdelta_cr_CO_p absdelta_cr_EX_p absdelta_cr_AG_p absdelta_cr_ES_p absdelta_cr_Grit_p absdelta_OP_p absdelta_CO_p absdelta_EX_p absdelta_AG_p absdelta_ES_p absdelta_Grit_p n



preserve
import delimited "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\_omega.csv", delimiter(";") clear

encode traits, gen(big5)
gen deltaraw=(raw2020-raw2016)*100/raw2016
gen deltacor=(cor2020-cor2016)*100/cor2016

gen delta2016=(cor2016-raw2016)*100/raw2016
gen delta2020=(cor2020-raw2020)*100/raw2020
set graph off
graph bar raw2016 cor2016 raw2020 cor2020, over(traits) blabel(bar, format(%4.2f) size(tiny)) legend(pos(6) col(4) order(1 "Non-cor. 2016-17" 2 "Corr. 2016-17" 3 "Non-cor. 2020-21" 4 "Corr. 2020-21")) name(g1, replace) note("McDonald's Ω", size(tiny))
graph save "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\omega.gph", replace
graph export "C:\Users\Arnaud\Documents\GitHub\RUME-NEEMSIS\Big-5\omega.svg", as(svg) replace
graph export "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\omega.pdf", as(pdf) replace


graph bar deltaraw deltacor, over(traits) ylabel(-70(10)80) ymtick(-65(5)75) blabel(bar, format(%4.2f) size(tiny)) legend(pos(6) col(2) order(1 "Non-cor." 2 "Corr.")) title("Variation over time (2016-17 / 2020-21)", size(small)) name(g2, replace)
graph bar delta2016 delta2020, over(traits) ylabel(-70(10)80) blabel(bar, format(%4.2f) size(tiny)) legend(pos(6) col(2) order(1 "2016-17" 2 "2020-21")) title("Variation over correction (Non-cor. / Corr.)", size(small)) name(g3, replace)
graph combine g2 g3, col(3) note("Variation rate of McDonald's Ω", size(tiny))
graph save "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\omega_delta.gph", replace
graph export "C:\Users\Arnaud\Documents\GitHub\RUME-NEEMSIS\Big-5\omega_delta.svg", as(svg) replace
graph export "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\omega_delta.pdf", as(pdf) replace
set graph on

restore

****************************************
* END
