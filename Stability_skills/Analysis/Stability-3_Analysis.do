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
********** Path to folder "data" folder.
*global directory = "D:\Documents\_Thesis\Research-Stability_skills\Analysis"
*cd"$directory"
*global git "C:\Users\Arnaud\Documents\GitHub"

*Fac
global directory = "C:\Users\anatal\Downloads\_Thesis\Research-Stability_skills\Analysis"
cd "$directory"
set scheme plottig
global git "C:\Users\anatal\Downloads\GitHub"

*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave2 "NEEMSIS1-HH_v9"
global wave3 "NEEMSIS2-HH_v20"
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

fre panel
********** Graph
*** General
set graph off
stripplot ars3 if panel==1, over(time) separate(caste) ///
cumul cumprob box centre vertical refline /// 
xsize(4) xtitle("") xlabel(,angle(0))  ///
ylabel(0(.2)1.6) ymtick(0(.1)1.7) ytitle("") ///
msymbol(oh oh oh) mcolor(ply1 plr1 plb1)  ///
legend(pos(6) col(3))
graph export bias_panel.pdf, replace
set graph on

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

********** Macro
global imcorgrit imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm imcr_tryhard imcr_stickwithgoals imcr_goaftergoal imcr_finishwhatbegin imcr_finishtasks imcr_keepworking

global imcor imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm

**********
********** Panel: ALL

********** Factor analyses: without grit
minap $imcor
qui factor $imcor, pcf fa(8) // 5
rotate, promax
putexcel set "EFA_2016.xlsx", modify sheet(without_all)
putexcel (E2)=matrix(e(r_L))

*predict f1_without f2_without f3_without f4_without f5_without f6_without f7_without f8_without
*cpcorr $imcor \ f1_without f2_without f3_without f4_without f5_without f6_without f7_without f8_without
*matrix list r(p)


********** Factor analyses: with grit
minap $imcorgrit
qui factor $imcorgrit, pcf fa(8) // 5
rotate, promax
putexcel set "EFA_2016.xlsx", modify sheet(with_all)
putexcel (E2)=matrix(e(r_L))

*predict f1_with f2_with f3_with f4_with f5_with f6_with f7_with f8_with
*cpcorr $imcorgrit \ f1_with f2_with f3_with f4_with f5_with f6_with f7_with f8_with
*matrix list r(p)





**********
********** Panel: panel
keep if panel==1


********** Factor analyses: without grit
minap $imcor
qui factor $imcor, pcf fa(7) // 5
rotate, promax
putexcel set "EFA_2016.xlsx", modify sheet(without_panel)
putexcel (E2)=matrix(e(r_L))

*predict f1_without f2_without f3_without f4_without f5_without f6_without f7_without f8_without
*cpcorr $imcor \ f1_without f2_without f3_without f4_without f5_without f6_without f7_without f8_without
*matrix list r(p)


********** Factor analyses: with grit
minap $imcorgrit
qui factor $imcorgrit, pcf fa(9)  // 5
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

********** Macro
global imcorgrit imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm imcr_tryhard imcr_stickwithgoals imcr_goaftergoal imcr_finishwhatbegin imcr_finishtasks imcr_keepworking

global imcor imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm

**********
********** Panel: ALL

********** Factor analyses: without grit
minap $imcor
qui factor $imcor, pcf fa(11) // 2
rotate, promax
putexcel set "EFA_2020.xlsx", modify sheet(without_all)
putexcel (E2)=matrix(e(r_L))

*predict f1_without f2_without f3_without f4_without f5_without f6_without f7_without f8_without
*cpcorr $imcor \ f1_without f2_without f3_without f4_without f5_without f6_without f7_without f8_without
*matrix list r(p)


********** Factor analyses: with grit
minap $imcorgrit
qui factor $imcorgrit, pcf fa(13) // 2
rotate, promax
putexcel set "EFA_2020.xlsx", modify sheet(with_all)
putexcel (E2)=matrix(e(r_L))

*predict f1_with f2_with f3_with f4_with f5_with f6_with f7_with f8_with
*cpcorr $imcorgrit \ f1_with f2_with f3_with f4_with f5_with f6_with f7_with f8_with
*matrix list r(p)





**********
********** Panel: panel
keep if panel==1


********** Factor analyses: without grit
minap $imcor
qui factor $imcor, pcf fa(11) // 2
rotate, promax
putexcel set "EFA_2020.xlsx", modify sheet(without_panel)
putexcel (E2)=matrix(e(r_L))

*predict f1_without f2_without f3_without f4_without f5_without f6_without f7_without f8_without
*cpcorr $imcor \ f1_without f2_without f3_without f4_without f5_without f6_without f7_without f8_without
*matrix list r(p)


********** Factor analyses: with grit
minap $imcorgrit
qui factor $imcorgrit, pcf fa(14)  // 2
rotate, promax
putexcel set "EFA_2020.xlsx", modify sheet(with_panel)
putexcel (E2)=matrix(e(r_L))

*predict f1_with f2_with f3_with f4_with f5_with f6_with f7_with f8_with
*cpcorr $imcorgrit \ f1_with f2_with f3_with f4_with f5_with f6_with f7_with f8_with
*matrix list r(p)



****************************************
* END















/*
********** Correlation with big-5 and cronbach
cpcorr cr_OP cr_EX cr_ES cr_CO cr_AG cr_Grit OP EX ES CO AG Grit factor_`x'_1 factor_`x'_2 factor_`x'_3 factor_`x'_4 factor_`x'_5 factor_`x'_6
matrix list r(p)
*/



























****************************************
* Correlation + 
****************************************





********** Graphical representation
/*
preserve
import delimited "factor2020.csv", delimiter(";") clear
drop v46
gen n=_n
drop if n==42
order n var
gen threshold=0.05
*Clean
forvalues i=1(1)6{
rename factor_imcrwith_`i' factor_Corrwith_`i'
rename pvalue_imcrwith_`i' pvalue_Corrwith_`i'
rename factor_imrawwith_`i' factor_Rawwith_`i'
rename pvalue_imrawwith_`i' pvalue_Rawwith_`i'
}

forvalues i=1(1)5{
rename factor_imcr_`i' factor_Corr_`i'
rename pvalue_imcr_`i' pvalue_Corr_`i'
rename factor_imraw_`i' factor_Raw_`i'
rename pvalue_imraw_`i' pvalue_Raw_`i'
}
gen big5=""
replace big5="Openness" if n>=1 & n<=7
replace big5="Conscientiousness" if n>=8 & n<=14
replace big5="Extraversion" if n>=15 & n<=21
replace big5="Agreeableness" if n>=22 & n<=28
replace big5="Emotional stability / Neuroticism" if n>=29 & n<=35
replace big5="Grit" if n>=36 & n<=41
order n var big5
save"factor2020.dta", replace

use"factor2020.dta", clear

set graph off
* With
foreach x in Raw Corr {
forvalues i=1(1)6{
*Sort
gsort - factor_`x'with_`i'
sencode var, gen(var_factor_`x'with_`i') gsort(factor_`x'with_`i')
replace factor_`x'with_`i'=round(factor_`x'with_`i', 0.01)
*Graph
twoway ///
(bar factor_`x'with_`i' var_factor_`x'with_`i', barw(0.6) yline(0, lcolor(gs10) lpattern(solid) lwidth(*0.8))) ///
(scatter factor_`x'with_`i' var_factor_`x'with_`i', mlabel(factor_`x'with_`i') mlabposition(12) mlabsize(*0.3) mlabangle(0) msymbol(i)) ///
(scatter pvalue_`x'with_`i' var_factor_`x'with_`i', msymbol(o) mcolor(gs1) msize(*0.2)) ///
(line threshold var_factor_`x'with_`i', lcolor(gs1) lpattern(solid) lwidth(*0.2)), ///
xlabel(1(1)41, valuelabel labsize(tiny) angle(45) nogrid) xtitle("")  ///
ylabel(, labsize(tiny)) ///
title("Factor `i'", size(small)) ///
legend(order(1 "Correlation with factor" 3 "p-value" 4 ".05 threshold") pos(6) col(3) size(vsmall) off) ///
name(g_`x'_`i', replace)
drop var_factor_`x'with_`i'
sort n
}
grc1leg g_`x'_1 g_`x'_2 g_`x'_3 g_`x'_4 g_`x'_5 g_`x'_6, note("`x' items with NEEMSIS-2 (2020-21) data.", size(tiny)) name(comb_`x'_with, replace)
graph save "$git\Analysis\Personality\Big-5\factor2020_`x'_with.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\factor2020_`x'_with.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\factor2020_`x'_with.pdf", as(pdf) replace
}



****************************************
* END





/*
esttab res_2016 , ///
	cells("b(fmt(3)star)" "se(fmt(3)par)") /// 
	star(* 0.10 ** 0.05 *** 0.01) ///
	drop() ///
	legend label varlabels(_cons constant) ///
	stats(N r2 r2_a p, fmt(0 3 3 3) labels(`"Observations"' `"\$R^2$"' `"Adjusted \$R^2$"' `"p-value"')) ///
	replace	
	
preserve
import delimited "_reg.csv", delimiter(",") varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "OLS_username.xlsx", sheet(Class2016,replace)
restore
