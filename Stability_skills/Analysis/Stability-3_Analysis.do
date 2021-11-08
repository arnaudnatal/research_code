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


/*
Je vois, a priori, 3 sources de biais à vérifier:
les questions plus mal compris que d'autres
les enquêtés (age, caste, sex, education, village, expo au covid, etc.)
les enquêteurs


EFA et congruence tucker

reg biais

correlation

test-retest measure pour la reliability des data
*/








****************************************
* 1. ACQUIESCENCE BIAS
****************************************
use"panel_stab_v2", clear
set graph off
fre panel
********** Graph
*** General
stripplot ars3 if panel==1, over(time) separate(caste) ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(,angle(0))  ///
msymbol(+ + +) mcolor(black black black)  ///
ylabel(0(.2)1.6) ymtick(0(.1)1.7) ytitle("") ///
note("2016: n=835" "2020: n=835", size(vsmall)) ///
legend(order(1 "Mean" 5 "Individual"))
graph export bias_panel.pdf, replace

*** By sex
stripplot ars3 if year==2020 & panel==1, over(sex) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(4) xtitle("") xlabel(,angle(45))  ///
ylabel(0(.2)1.6) ymtick(0(.1)1.7) ytitle("") ///
msymbol(oh oh oh) mcolor(ply1 plr1 plb1)  ///
legend(pos(6) col(3))

*** By caste
stripplot ars3 if year==2020 & panel==1, over(caste) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(4) xtitle("") xlabel(,angle(45))  ///
ylabel(0(.2)1.6) ymtick(0(.1)1.7) ytitle("") ///
msymbol(oh oh oh) mcolor(ply1 plr1 plb1)  ///
legend(pos(6) col(3))

*** By age
twoway ///
(scatter ars3 age if year==2020 & panel==1) ///
(lfit ars3 age if year==2020 & panel==1)

*** By education level
stripplot ars3 if year==2020 & panel==1, over(edulevel) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(4) xtitle("") xlabel(,angle(45))  ///
ylabel(0(.2)1.6) ymtick(0(.1)1.7) ytitle("") ///
msymbol(oh oh oh) mcolor(ply1 plr1 plb1)  ///
legend(pos(6) col(3))

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



********** Reg test
qui reg ars3 ib(1).sex ib(1).caste c.age##c.age ib(freq).edulevel ib(freq).username_2016_code ib(freq).mainocc_occupation_indiv ib(freq).villageid if year==2016 & panel==1, allbaselevels
est store bias16
qui reg ars3 ib(1).sex ib(1).caste c.age##c.age ib(freq).edulevel ib(3).username_2020_code ib(freq).mainocc_occupation_indiv ib(freq).villageid if year==2020 & panel==1, allbaselevels
est store bias20

estout bias16 bias20, cells("b(fmt(3)) p(fmt(2))" se(fmt(2))) stats(N r2 r2_a, fmt(0 2 2)) 

set graph on
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



********** Factor analyses: without grit
minap $imcor
factor $imcor, pcf fa(5) // 5
rotate, promax
putexcel set "EFA_2016.xlsx", modify sheet(without_panel)
putexcel (E2)=matrix(e(r_L))

*predict f1_without f2_without f3_without f4_without f5_without f6_without f7_without f8_without
*cpcorr $imcor \ f1_without f2_without f3_without f4_without f5_without f6_without f7_without f8_without
*matrix list r(p)


********** Factor analyses: with grit
minap $imcorgrit
qui factor $imcorgrit, pcf fa(6)  // 5
rotate, promax
putexcel set "EFA_2016.xlsx", modify sheet(with_panel)
putexcel (E2)=matrix(e(r_L))

*predict f1_with f2_with f3_with f4_with f5_with f6_with f7_with f8_with
*cpcorr $imcorgrit \ f1_with f2_with f3_with f4_with f5_with f6_with f7_with f8_with
*matrix list r(p)



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




********** Factor analyses: without grit
minap $imcor
qui factor $imcor, pcf fa(5) // 2
rotate, promax
putexcel set "EFA_2020.xlsx", modify sheet(without_panel)
putexcel (E2)=matrix(e(r_L))

*predict f1_without f2_without f3_without f4_without f5_without f6_without f7_without f8_without
*cpcorr $imcor \ f1_without f2_without f3_without f4_without f5_without f6_without f7_without f8_without
*matrix list r(p)


********** Factor analyses: with grit
minap $imcorgrit
qui factor $imcorgrit, pcf fa(6)  // 2
rotate, promax
putexcel set "EFA_2020.xlsx", modify sheet(with_panel)
putexcel (E2)=matrix(e(r_L))

*predict f1_with f2_with f3_with f4_with f5_with f6_with f7_with f8_with
*cpcorr $imcorgrit \ f1_with f2_with f3_with f4_with f5_with f6_with f7_with f8_with
*matrix list r(p)



****************************************
* END






****************************************
* Graphical representation
****************************************
set graph off

********** With
foreach x in with_panel {
forvalues j=2016(4)2020 {
import excel "EFA_`j'.xlsx", sheet("`x'") firstrow clear
rename Variables var
rename N n
gen Big5=""
replace Big5="(OP)" if NaiveBigFive=="Openness"
replace Big5="(CO)" if NaiveBigFive=="Conscientiousness"
replace Big5="(EX)" if NaiveBigFive=="Extraversion"
replace Big5="(AG)" if NaiveBigFive=="Agreeableness"
replace Big5="(ES)" if NaiveBigFive=="Emotional stability"
replace Big5="(GR)" if NaiveBigFive=="Grit"
egen varbis=concat(var Big5), p(" ")
drop var
rename varbis var
set graph off
forvalues i=1(1)6{
*Sort
gsort - F`i'
sencode var, gen(var_F`i') gsort(F`i')
replace F`i'=round(F`i', 0.01)
*Graph
twoway ///
(line var_F`i' F`i', xline(0, lcolor(gs10))) ///
(scatter var_F`i' F`i', mlabel(F`i') mlabposition(11) mlabsize(*0.3) mlabangle(0) msymbol(i)), ///
xlabel(, labsize(tiny) angle(0) nogrid) xtitle("")  ///
ylabel(1(1)41, valuelabel labsize(tiny)) ytitle("") ///
title("Factor `i'", size(small)) ///
legend(order(1 "Correlation with factor") pos(6) col(3) size(vsmall) off) ///
name(g_`i', replace)
sort n
}
graph combine g_1 g_2 g_3 g_4 g_5 g_6, note("Corrected items.", size(tiny)) name(comb_`j'_`x', replace)
graph export "factor`j'_`x'.pdf", as(pdf) replace
}
}


********** Without
foreach x in without_panel {
forvalues j=2016(4)2020 {
import excel "EFA_`j'.xlsx", sheet("`x'") firstrow clear
rename Variables var
rename N n
*Drop grit
drop if NaiveBigFive=="Grit"

gen Big5=""
replace Big5="(OP)" if NaiveBigFive=="Openness"
replace Big5="(CO)" if NaiveBigFive=="Conscientiousness"
replace Big5="(EX)" if NaiveBigFive=="Extraversion"
replace Big5="(AG)" if NaiveBigFive=="Agreeableness"
replace Big5="(ES)" if NaiveBigFive=="Emotional stability"
egen varbis=concat(var Big5), p(" ")
drop var
rename varbis var
set graph off
forvalues i=1(1)5{
*Sort
gsort - F`i'
sencode var, gen(var_F`i') gsort(F`i')
replace F`i'=round(F`i', 0.01)
*Graph
twoway ///
(line var_F`i' F`i', xline(0, lcolor(gs10))) ///
(scatter var_F`i' F`i', mlabel(F`i') mlabposition(11) mlabsize(*0.3) mlabangle(0) msymbol(i)), ///
xlabel(, labsize(tiny) angle(0) nogrid) xtitle("")  ///
ylabel(1(1)35, valuelabel labsize(tiny)) ytitle("") ///
title("Factor `i'", size(small)) ///
legend(order(1 "Correlation with factor") pos(6) col(3) size(vsmall) off) ///
name(g_`i', replace)
sort n
}
graph combine g_1 g_2 g_3 g_4 g_5, note("Corrected items.", size(tiny)) name(comb_`j'_`x', replace)
graph export "factor`j'_`x'.pdf", as(pdf) replace
}
}



****************************************
* END
