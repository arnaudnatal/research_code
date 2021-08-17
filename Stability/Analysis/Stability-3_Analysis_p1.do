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







*scatter
set scheme plottig
gen age_2016=age_2020-4
twoway (scatter diff_raven_tt age_2016 if sex==1 & diff_raven_tt<0) 
twoway (scatter diff_raven_tt age_2016 if sex==2 & diff_raven_tt<0)

twoway (scatter diff_raven_tt age_2016 if caste==1 & diff_raven_tt<0)
twoway (scatter diff_raven_tt age_2016 if caste==2 & diff_raven_tt<0)
twoway (scatter diff_raven_tt age_2016 if caste==3 & diff_raven_tt<0)

****************************************
* END















****************************************
* BIAS
****************************************
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
****************************************
* END
















****************************************
* CAT PLOT
****************************************

********** Corrected - Non corrected
preserve
foreach x in OP CO EX AG ES Grit {
rename cat_diff_cr_`x' cat_diff_`x'2
rename cat_diff_`x' cat_diff_`x'1
}
gen corr2=1
gen corr1=0
egen HHINDID=concat(HHID_panel INDID_panel), p(/)
order HHINDID
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
graph save "$git\Analysis\Personality\Big-5\diff_cor_ncor.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diff_cor_ncor.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\diff_cor_ncor.pdf", as(pdf) replace
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
graph save "$git\Analysis\Personality\Big-5\diff_gender_cor.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diff_gender_cor.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\diff_gender_cor.pdf", as(pdf) replace
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
graph save "$git\Analysis\Personality\Big-5\diff_caste_cor.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diff_caste_cor.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\diff_caste_cor.pdf", as(pdf) replace

*Age
set graph off
foreach x in OP CO EX AG ES {
catplot agecat1 cat_diff_cr_`x', asyvars percent(agecat1) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
title("`x'", size(small)) ///
name(g_`x', replace) legend(col(2) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))
}
grc1leg g_OP g_CO g_EX g_AG g_ES, cols(2) name(combage, replace) legend(g_OP) pos(6) note("Traits corrected from acquiesence bias.", size(tiny))
set graph on
graph save "$git\Analysis\Personality\Big-5\diff_age_cor.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diff_age_cor.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\diff_age_cor.pdf", as(pdf) replace



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
graph save "$git\Analysis\Personality\Big-5\diff_gender_raw.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diff_gender_raw.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\diff_gender_raw.pdf", as(pdf) replace

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
graph save "$git\Analysis\Personality\Big-5\diff_caste_raw.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diff_caste_raw.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\diff_caste_raw.pdf", as(pdf) replace

*Age
set graph off
foreach x in OP CO EX AG ES {
catplot agecat1 cat_diff_`x', asyvars percent(agecat1) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
title("`x'", size(small)) ///
name(g_`x', replace) legend(col(2) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))
}
grc1leg g_OP g_CO g_EX g_AG g_ES, cols(2) name(combage, replace) legend(g_OP) pos(6) note("Raw traits (non-corrected from acquiesence bias).", size(tiny))
set graph on
graph save "$git\Analysis\Personality\Big-5\diff_age_raw.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diff_age_raw.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\diff_age_raw.pdf", as(pdf) replace


********** Cognitif
*ssc install catplot
*Gender
set graph off
foreach x in raven_tt num_tt lit_tt {
catplot sex cat_diff_`x', asyvars percent(sex) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
title("`x'", size(small)) ///
name(g_`x', replace) legend(col(2) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))
}
grc1leg g_raven_tt g_num_tt g_lit_tt, cols(3) leg(g_raven_tt) name(combage, replace) pos(6)
set graph on
graph save "$git\Analysis\Personality\Big-5\diff_cog_gender.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diff_cog_gender.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\diff_cog_gender.pdf", as(pdf) replace

*Caste
set graph off
foreach x in raven_tt num_tt lit_tt {
catplot caste cat_diff_`x', asyvars percent(caste) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
title("`x'", size(small)) ///
name(g_`x', replace) legend(col(3) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))
}
grc1leg g_raven_tt g_num_tt g_lit_tt, cols(3) leg(g_raven_tt) name(combage, replace) pos(6)
set graph on
graph save "$git\Analysis\Personality\Big-5\diff_cog_caste.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diff_cog_caste.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\diff_cog_caste.pdf", as(pdf) replace

*Age
set graph off
foreach x in raven_tt num_tt lit_tt {
catplot agecat1 cat_diff_`x', asyvars percent(agecat1) recast(bar) ///
ylabel(, labsize(vsmall)) ytitle("Percent", size(small)) ///
var2opts(label(labsize(vsmall) angle(45))) ///
title("`x'", size(small)) ///
name(g_`x', replace) legend(col(2) size(vsmall)) blabel(bar, format(%4.1f) size(tiny) angle(45))
}
grc1leg g_raven_tt g_num_tt g_lit_tt, cols(3) leg(g_raven_tt) name(combage, replace) pos(6)
set graph on
graph save "$git\Analysis\Personality\Big-5\diff_cog_age.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diff_cog_age.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\diff_cog_age.pdf", as(pdf) replace

****************************************
* END














****************************************
* HISTOGRAM
****************************************

********** Graphical
*For line 
foreach x in absdiff_cr_OP absdiff_cr_CO absdiff_cr_EX absdiff_cr_AG absdiff_cr_ES absdiff_cr_Grit absdiff_OP absdiff_CO absdiff_EX absdiff_AG absdiff_ES absdiff_Grit {
pctile `x'_p=`x', n(20)
}
gen n=_n*5
replace n=. if n>100


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
graph save "$git\Analysis\Personality\Big-5\diffcont_raw.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diffcont_raw.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\diffcont_raw.pdf", as(pdf) replace
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
graph save "$git\Analysis\Personality\Big-5\diffcont_cor.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diffcont_cor.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\diffcont_cor.pdf", as(pdf) replace
set graph on 

drop absdiff_cr_OP_p absdiff_cr_CO_p absdiff_cr_EX_p absdiff_cr_AG_p absdiff_cr_ES_p absdiff_cr_Grit_p absdiff_OP_p absdiff_CO_p absdiff_EX_p absdiff_AG_p absdiff_ES_p absdiff_Grit_p n






********** COGNITIF
tab1 diff_raven_tt diff_num_tt diff_lit_tt
*Density
set graph off
histogram diff_raven_tt, percent width(1) xlabel(-36(6)27, labsize(vsmall) ang(0)) xmtick(-36(1)27) ylabel(, labsize(vsmall)) ymtick() xtitle("slope - Raven", size(small)) ytitle(, size(small)) name(g1, replace) note("") title("") legend(off)
histogram diff_num_tt, percent width(1) xlabel(-12(2)12, labsize(vsmall) ang()) ylabel(, labsize(vsmall)) ymtick() xtitle("slope -  Num", size(small)) ytitle(, size(small)) name(g2, replace)  note("") title("") legend(off)
histogram diff_lit_tt, percent width(0.5) xlabel(-4(1)4, labsize(vsmall) ang()) xmtick(-4(0.2)4) ylabel(, labsize(vsmall)) ymtick() xtitle("slope -  Lit", size(small)) ytitle(, size(small)) name(g3, replace)  note("") title("") legend(off)
*Combine
graph combine g1 g2 g3, cols(3)
graph save "$git\Analysis\Personality\Big-5\diffcont_cog.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\diffcont_cog.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\diffcont_cog.pdf", as(pdf) replace
set graph on 

drop absdiff_raven_tt absdiff_num_tt absdiff_lit_tt

drop absdiff_cr_OP absdiff_cr_CO absdiff_cr_EX absdiff_cr_AG absdiff_cr_ES absdiff_cr_Grit absdiff_OP absdiff_CO absdiff_EX absdiff_AG absdiff_ES absdiff_Grit absdiff_ars absdiff_ars2 absdiff_ars3
****************************************
* END