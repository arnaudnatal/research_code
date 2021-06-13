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
global big5 ///
curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination ///
organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties ///
enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts  ///
workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers ///
managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm ///
tryhard  stickwithg~s   goaftergoal finishwhat~n finishtasks  keepworking

merge m:1 HHID_panel using "panel", nogen keep(3)
keep if egoid>0


********** Rename 2020 perso

foreach x in cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit lit_tt num_tt raven_tt age{
rename `x' `x'_2020
}

********** Merge with 2016 values
merge 1:1 HHID_panel INDID_panel using "$wave2~ego", keepusing (cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit lit_tt num_tt raven_tt age)
*Gen diff
foreach x in cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit{
gen diff_`x'=`x'_2020 - `x'
}
*Gen abs delta
foreach x in cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit{
gen absdelta_`x'=abs(((`x'_2020-`x')*100/`x'))
}
*Gen delta
foreach x in cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit{
gen delta_`x'=((`x'_2020-`x')*100/`x')
}
*Gen delta 2
foreach x in cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit{
gen delta2_`x'=((`x'_2020-`x')*100/`x')
}
foreach x in cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit{
replace delta2_`x'=100 if delta2_`x'>100 & delta2_`x'!=.
replace delta2_`x'=-60 if delta2_`x'<-60 & delta2_`x'!=.
}

*Verif age
gen test=age_2020-age
replace test=0 if test!=4
replace test=1 if test==4
tab test

*Stability as categorical variable
foreach x in delta_cr_OP delta_cr_CO delta_cr_EX delta_cr_AG delta_cr_ES delta_cr_Grit delta_OP delta_CO delta_EX delta_AG delta_ES delta_Grit{
gen cat_`x'=0 if _merge==3
}
foreach x in delta_cr_OP delta_cr_CO delta_cr_EX delta_cr_AG delta_cr_ES delta_cr_Grit delta_OP delta_CO delta_EX delta_AG delta_ES delta_Grit{
replace cat_`x'=1 if `x'>=-5 & `x'<=5 & cat_`x'==0
replace cat_`x'=2 if `x'>=-10 & `x'<=10 & cat_`x'==0
replace cat_`x'=3 if `x'>=-20 & `x'<=20 & cat_`x'==0
replace cat_`x'=4 if `x'>=-50 & `x'<=50 & cat_`x'==0
replace cat_`x'=5 if `x'>=-100 & `x'<=100 & cat_`x'==0
replace cat_`x'=6 if (`x'<-100 | `x'>100) & cat_`x'==0
}
label define varcat 1"[0;5]" 2"]5;10]" 3"]10;20]" 4"]20;50]" 5"]50;100]" 6"]100;∞]", replace
foreach x in delta_cr_OP delta_cr_CO delta_cr_EX delta_cr_AG delta_cr_ES delta_cr_Grit delta_OP delta_CO delta_EX delta_AG delta_ES delta_Grit{
label values cat_`x' varcat
}

* Age
gen agecat1=0 		if age_2020<=34
replace agecat1=1 	if age_2020>34 & age_2020!=.

gen agecat2=0 		if age_2020<=39
replace agecat2=1 	if age_2020>39 & age_2020!=.

gen agecat3=0 		if age_2020<=44
replace agecat3=1 	if age_2020>44 & age_2020!=.


/*
********** Check the stability
* All egos in 2016-2020
fsum absdelta_cr_OP absdelta_cr_CO absdelta_cr_EX absdelta_cr_AG absdelta_cr_ES absdelta_cr_Grit absdelta_OP absdelta_CO absdelta_EX absdelta_AG absdelta_ES absdelta_Grit if _merge==3, stat(sd p1 p5 p10 p25 p50 p75 p90 p95 p99)

* All egos in 2010-2016-2020
fsum absdelta_cr_OP absdelta_cr_CO absdelta_cr_EX absdelta_cr_AG absdelta_cr_ES absdelta_cr_Grit absdelta_OP absdelta_CO absdelta_EX absdelta_AG absdelta_ES absdelta_Grit if _merge==3 & panel==1, stat(sd p1 p5 p10 p25 p50 p75 p90 p95 p99)

* Ego 1 in 2016-2020
fsum absdelta_cr_OP absdelta_cr_CO absdelta_cr_EX absdelta_cr_AG absdelta_cr_ES absdelta_cr_Grit absdelta_OP absdelta_CO absdelta_EX absdelta_AG absdelta_ES absdelta_Grit if _merge==3 & egoid==1, stat(sd p1 p5 p10 p25 p50 p75 p90 p95 p99)

* Ego 1 in 2016-2020
fsum absdelta_cr_OP absdelta_cr_CO absdelta_cr_EX absdelta_cr_AG absdelta_cr_ES absdelta_cr_Grit absdelta_OP absdelta_CO absdelta_EX absdelta_AG absdelta_ES absdelta_Grit if _merge==3 & egoid==1 & panel==1, stat(sd p1 p5 p10 p25 p50 p75 p90 p95 p99)

* More than 30 in 2016 in 2016-2020
fsum absdelta_cr_OP absdelta_cr_CO absdelta_cr_EX absdelta_cr_AG absdelta_cr_ES absdelta_cr_Grit absdelta_OP absdelta_CO absdelta_EX absdelta_AG absdelta_ES absdelta_Grit if _merge==3 & age_2020>=34, stat(sd p1 p5 p10 p25 p50 p75 p90 p95 p99)

* More than 35 in 2016 in 2016-2020
fsum absdelta_cr_OP absdelta_cr_CO absdelta_cr_EX absdelta_cr_AG absdelta_cr_ES absdelta_cr_Grit absdelta_OP absdelta_CO absdelta_EX absdelta_AG absdelta_ES absdelta_Grit if _merge==3 & age_2020>=39, stat(sd p1 p5 p10 p25 p50 p75 p90 p95 p99)

* More than 40 in 2016 in 2016-2020
fsum absdelta_cr_OP absdelta_cr_CO absdelta_cr_EX absdelta_cr_AG absdelta_cr_ES absdelta_cr_Grit absdelta_OP absdelta_CO absdelta_EX absdelta_AG absdelta_ES absdelta_Grit if _merge==3 & age_2020>=44, stat(sd p1 p5 p10 p25 p50 p75 p90 p95 p99)

* More than 45 in 2016 in 2016-2020
fsum absdelta_cr_OP absdelta_cr_CO absdelta_cr_EX absdelta_cr_AG absdelta_cr_ES absdelta_cr_Grit absdelta_OP absdelta_CO absdelta_EX absdelta_AG absdelta_ES absdelta_Grit if _merge==3 & age_2020>=49, stat(sd p1 p5 p10 p25 p50 p75 p90 p95 p99)

* More than 50 in 2016 in 2016-2020
fsum absdelta_cr_OP absdelta_cr_CO absdelta_cr_EX absdelta_cr_AG absdelta_cr_ES absdelta_cr_Grit absdelta_OP absdelta_CO absdelta_EX absdelta_AG absdelta_ES absdelta_Grit if _merge==3 & age_2020>=54, stat(sd p1 p5 p10 p25 p50 p75 p90 p95 p99)

* Less than 25 in 2016 in 2016-2020
fsum absdelta_cr_OP absdelta_cr_CO absdelta_cr_EX absdelta_cr_AG absdelta_cr_ES absdelta_cr_Grit absdelta_OP absdelta_CO absdelta_EX absdelta_AG absdelta_ES absdelta_Grit if _merge==3 & age_2020<29, stat(sd p1 p5 p10 p25 p50 p75 p90 p95 p99)

* Less than 30 in 2016 in 2016-2020
fsum absdelta_cr_OP absdelta_cr_CO absdelta_cr_EX absdelta_cr_AG absdelta_cr_ES absdelta_cr_Grit absdelta_OP absdelta_CO absdelta_EX absdelta_AG absdelta_ES absdelta_Grit if _merge==3 & age_2020<34, stat(sd p1 p5 p10 p25 p50 p75 p90 p95 p99)

* Less than 35 in 2016 in 2016-2020
fsum absdelta_cr_OP absdelta_cr_CO absdelta_cr_EX absdelta_cr_AG absdelta_cr_ES absdelta_cr_Grit absdelta_OP absdelta_CO absdelta_EX absdelta_AG absdelta_ES absdelta_Grit if _merge==3 & age_2020<39, stat(sd p1 p5 p10 p25 p50 p75 p90 p95 p99)

* Less than 40 in 2016 in 2016-2020
fsum absdelta_cr_OP absdelta_cr_CO absdelta_cr_EX absdelta_cr_AG absdelta_cr_ES absdelta_cr_Grit absdelta_OP absdelta_CO absdelta_EX absdelta_AG absdelta_ES absdelta_Grit if _merge==3 & age_2020<44, stat(sd p1 p5 p10 p25 p50 p75 p90 p95 p99)
*/

* With cat
cls
foreach x in cat_delta_cr_OP cat_delta_cr_CO cat_delta_cr_EX cat_delta_cr_AG cat_delta_cr_ES cat_delta_cr_Grit cat_delta_OP cat_delta_CO cat_delta_EX cat_delta_AG cat_delta_ES cat_delta_Grit{
tab `x' sex if _merge==3, col nofreq
tab `x' agecat1 if _merge==3, col nofreq
tab `x' agecat2 if _merge==3, col nofreq
tab `x' agecat3 if _merge==3, col nofreq
}

********** Graphical
tabstat cr_OP_2020 delta_cr_OP, stat(p95 p99 max)

set graph off
kdensity delta2_cr_OP, bwidth(0.1) xline(-5 5) xlabel(-60(20)100) xmtick(-60(5)100) note("") lcolor(black) lpattern(solid) title("") xtitle("Δ Openness", size(medsmall)) ytitle("Kernel density", size(small)) name(g1, replace) 
kdensity delta2_cr_CO, bwidth(0.1) xline(-5 5) xlabel(-60(20)100) xmtick(-60(5)100) note("") lcolor(black) lpattern(solid) title("") xtitle("Δ Conscientiousness", size(medsmall)) ytitle("Kernel density", size(small)) name(g2, replace) 
kdensity delta2_cr_EX, bwidth(0.1) xline(-5 5) xlabel(-60(20)100) xmtick(-60(5)100) note("") lcolor(black) lpattern(solid) title("") xtitle("Δ Extraversion", size(medsmall)) ytitle("Kernel density", size(small)) name(g3, replace) 
kdensity delta2_cr_AG, bwidth(0.1) xline(-5 5) xlabel(-60(20)100) xmtick(-60(5)100) note("") lcolor(black) lpattern(solid) title("") xtitle("Δ Agreeableness", size(medsmall)) ytitle("Kernel density", size(small)) name(g4, replace) 
kdensity delta2_cr_ES, bwidth(0.1) xline(-5 5) xlabel(-60(20)100) xmtick(-60(5)100) note("") lcolor(black) lpattern(solid) title("") xtitle("Δ Emotional stability", size(medsmall)) ytitle("Kernel density", size(small)) name(g5, replace) 
*kdensity delta2_cr_Grit, bwidth(0.1) xline(-5 5) xlabel(-60(20)100) xmtick(-60(5)100) note("") lcolor(plb1) title("") xtitle("Δ Grit corr.") name(g6, replace)
*graph combine g1 g2 g3 g4 g5 g6, ycommon note("epanechnikov kernel; bandwidth=0.1") name(combined, replace)
graph combine g1 g2 g3 g4 g5, ycommon note("Kernel: Epanechnikov;" "Bandwidth: 0.1;" "All traits are corrected from acquiescence bias.", size(vsmall)) name(combined, replace)
set graph on 
graph export "Stabcorr.pdf", as(pdf) replace


****************************************
* END
