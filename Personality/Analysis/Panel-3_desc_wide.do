cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
May 13, 2021
-----
Personality traits & debt AT INDIVIDUAL LEVEL in wide
-----
help fvvarlist
-------------------------
*/





****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
set scheme plotplain
********** Path to folder "data" folder.
global directory = "D:\Documents\_Thesis\Research-Skills_and_debt\Analysis"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"
global dropbox "C:\Users\Arnaud\Dropbox"


*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
set scheme plotplain

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH_v7"
global wave3 "NEEMSIS2-HH_v16"


********** Stata package

*coefplot, horizontal xline(0) drop(_cons) levels(95 90 ) ciopts(recast(. rcap))mlabel mlabposition(12) mlabgap(*2)

****************************************
* END






****************************************
* Descriptive statistics
****************************************
use"panel_wide_v3.dta", clear

tab segmana 

********** HH characteristics
*** 2016-17
preserve
recode caste (3=2)
bysort HHID_panel: egen nbego=sum(1)
duplicates drop HHID_panel, force
*473 HH, in panel, 835 egos
tabstat hhsize_1 nbego, stat(n mean) by(caste)
tab nbego caste, col nofreq
tab sexratiocat_1_1 caste, col nofreq 
tab sexratiocat_1_2 caste, col nofreq 
tab  sexratiocat_1_3 caste, col nofreq
tabstat assets1000_1, stat(mean sd p50) by(caste)
tab shock_1 caste, col nofreq
tabstat annualincome_HH1000_1 incomeHH1000_1, stat(n mean sd p50) by(caste)
tab indebt_HH_1 caste, col nofreq
cls
foreach x in near_panruti near_villupur near_tirup near_chengal near_kanchip near_chennai {
tab `x' caste, col nofreq
}
restore

*** 2020-21
cls
preserve
recode caste (3=2)
bysort HHID_panel: egen nbego=sum(1)
duplicates drop HHID_panel, force
*473 HH, in panel, 835 egos
tabstat hhsize_2 nbego, stat(n mean) by(caste)
tab nbego caste, col nofreq
tab sexratiocat_2 caste, col nofreq
tabstat assets1000_2, stat(mean sd p50) by(caste)
tab shock_2 caste, col nofreq
tabstat annualincome_HH1000_2 incomeHH1000_2, stat(n mean sd p50) by(caste)
tab indebt_HH_2 caste, col nofreq
foreach x in near_panruti near_villupur near_tirup near_chengal near_kanchip near_chennai {
tab `x' caste, col nofreq
}
restore


*** Delta HH
cls
preserve
foreach x in assets1000 incomeHH1000 {
gen delta2_`x'=(`x'_2-`x'_1)*100/`x'_1
replace delta2_`x'=`x'_2/100 if `x'_1==0
replace delta2_`x'=-(`x'_1)/100 if `x'_2==0
}

fre indebt_HH_1 indebt_HH_2

gen debtpath_HH=0
replace debtpath_HH=1 if indebt_HH_1==0 & indebt_HH_2==0
replace debtpath_HH=2 if indebt_HH_1==1 & indebt_HH_2==0
replace debtpath_HH=3 if indebt_HH_1==0 & indebt_HH_2==1
replace debtpath_HH=4 if indebt_HH_1==1 & indebt_HH_2==1

tab debtpath_HH caste2, col nofreq
tabstat delta2_assets1000 delta2_incomeHH1000, stat(n mean sd p50) by(caste2)
restore

********** Indiv characteristics
*** 2016-17
cls
tab caste2 female, col
tabstat age_1, stat(n mean) by(female)
tab dummyhead_1 female, col nofreq
tab relationshiptohead_1 female, col nofreq
tab cat_mainoccupation_indiv_1 female, col nofreq
tab mainoccupation_indiv_1 female, col nofreq
tab dummyedulevel female, col nofreq
tab edulevel_1 female, col nofreq
tab maritalstatus_1 female, col nofreq
tab maritalstatus2_1 female, col nofreq
tab dummymultipleoccupation_indiv_1 female, col nofreq
tabstat annualincome_indiv1000_1, stat(mean sd p50) by(female)

*** 2020-21
cls
tabstat age_2, stat(n mean) by(female)
tab dummyhead_2 female, col nofreq
tab cat_mainoccupation_indiv_2 female, col nofreq
tab maritalstatus_2 female, col  nofreq
tab dummymultipleoccupation_indiv_2 female, col nofreq
tabstat annualincome_indiv1000_2, stat(mean sd p50) by(female)

*** Delta income
gen delta2_labinc=(annualincome_indiv1000_2-annualincome_indiv1000_1)*100/annualincome_indiv1000_1
replace delta2_labinc=annualincome_indiv1000_2/100 if annualincome_indiv1000_1==0
replace delta2_labinc=-(annualincome_indiv1000_1)/100 if annualincome_indiv1000_2==0

tabstat delta2_labinc, stat(n mean sd p50) by(female)




*** EFA
set graph off
twoway ///
(kdensity base_factor_imraw_1_std if female==0, bwidth(0.32) lpattern(solid) lcolor(gs4)) ///
(kdensity base_factor_imraw_1_std if female==1, bwidth(0.32) lpattern(shortdash) lcolor(gs0)), ///
xsize() xtitle("F1 -- OP-EX (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17") off) name(f1, replace) aspect(0)

twoway ///
(kdensity base_factor_imraw_2_std if female==0, bwidth(0.32) lpattern(solid) lcolor(gs4)) ///
(kdensity base_factor_imraw_2_std if female==1, bwidth(0.32) lpattern(shortdash) lcolor(gs0)), ///
xsize() xtitle("F2 -- CO (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17") off) name(f2, replace) aspect(0)

twoway ///
(kdensity base_factor_imraw_3_std if female==0, bwidth(0.32) lpattern(solid) lcolor(gs4)) ///
(kdensity base_factor_imraw_3_std if female==1, bwidth(0.32) lpattern(shortdash) lcolor(gs0)), ///
xsize() xtitle("F3 -- Porupillatavan (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17") off) name(f3, replace) aspect(0)

twoway ///
(kdensity base_factor_imraw_4_std if female==0, bwidth(0.32) lpattern(solid) lcolor(gs4)) ///
(kdensity base_factor_imraw_4_std if female==1, bwidth(0.32) lpattern(shortdash) lcolor(gs0)), ///
xsize() xtitle("F4 -- ES (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17") off) name(f4, replace) aspect(0)

twoway ///
(kdensity base_factor_imraw_5_std if female==0, bwidth(0.32) lpattern(solid) lcolor(gs4)) ///
(kdensity base_factor_imraw_5_std if female==1, bwidth(0.32) lpattern(shortdash) lcolor(gs0)), ///
xsize() xtitle("F5 -- AG (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17") off) name(f5, replace) aspect(0)


*** Big-5 raw
foreach x in OP CO EX AG ES { 
twoway ///
(kdensity std_`x'_1 if female==0, bwidth(0.50) lpattern(solid) lcolor(gs4)) ///
(kdensity std_`x'_1 if female==1, bwidth(0.50) lpattern(shortdash) lcolor(gs0)) ///
(kdensity std_`x'_2 if female==0, bwidth(0.50) lpattern(dash) lcolor(gs9)) ///
(kdensity std_`x'_2 if female==1, bwidth(0.50) lpattern(solid) lcolor(gs12)), ///
xsize() xtitle("`x' (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17" 3 "Male in 2020-21" 4 "Female in 2020-21") size(small) off) name(f_`x', replace)
}

*** Cog
twoway ///
(kdensity std_raven_tt_1 if female==0, bwidth(.5) lpattern(solid) lcolor(gs4)) ///
(kdensity std_raven_tt_1 if female==1, bwidth(.5) lpattern(shortdash) lcolor(gs0)) ///
(kdensity std_raven_tt_2 if female==0, bwidth(.5) lpattern(dash) lcolor(gs9)) ///
(kdensity std_raven_tt_2 if female==1, bwidth(.5) lpattern(solid) lcolor(gs12)), ///
xsize() xtitle("Raven (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17" 3 "Male in 2020-21" 4 "Female in 2020-21") off) name(f_rav, replace)

twoway ///
(kdensity std_num_tt_1 if female==0, bwidth(.5) lpattern(solid) lcolor(gs4)) ///
(kdensity std_num_tt_1 if female==1, bwidth(.5) lpattern(shortdash) lcolor(gs0)) ///
(kdensity std_num_tt_2 if female==0, bwidth(.5) lpattern(dash) lcolor(gs9)) ///
(kdensity std_num_tt_2 if female==1, bwidth(.5) lpattern(solid) lcolor(gs12)), ///
xsize() xtitle("Numeracy (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17" 3 "Male in 2020-21" 4 "Female in 2020-21") off) name(f_num, replace)

twoway ///
(kdensity std_lit_tt_1 if female==0, bwidth(.5) lpattern(solid) lcolor(gs4)) ///
(kdensity std_lit_tt_1 if female==1, bwidth(.5) lpattern(shortdash) lcolor(gs0)) ///
(kdensity std_lit_tt_2 if female==0, bwidth(.5) lpattern(dash) lcolor(gs9)) ///
(kdensity std_lit_tt_2 if female==1, bwidth(.5) lpattern(solid) lcolor(gs12)), ///
xsize() xtitle("Literacy (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17" 3 "Male in 2020-21" 4 "Female in 2020-21") off) name(f_lit, replace)

*** Joint
*Factor & Big5
grc1leg f1 f2 f3 f4 f5 f_OP f_CO f_EX f_AG f_ES, cols(5) leg(f_OP) name(perso_raw, replace) 
*Cog
grc1leg f_rav f_num f_lit, cols(3) leg(f_rav) name(cog_raw, replace)
*All
set graph on
grc1leg f1 f2 f3 f4 f5 f_OP f_CO f_EX f_AG f_ES f_rav f_num f_lit, cols(5) leg(f_OP) note("Kernel: Epanechnikov" "Bandwidth: 0.32 for factors, 0.50 for Big-5, raven, numeracy and literacy." "Items non-corrected from acquiesence biais for factor analysis." "Big-5 traits non-corrected from acquiesence bias." "NEEMSIS-1 (2016-17) & NEEMSIS-2 (2020-21).", size(tiny))
graph save "Kernel_PTCS_raw_new.gph", replace
graph export "Kernel_PTCS_raw_new.pdf", as(pdf) replace



/*
* ANOVA for personality
tabstat base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std, stat(n mean sd p50) by(segmana)
cls
forvalues i=1(1)5{
oneway base_factor_imraw_`i'_std segmana //, tab
*pwmean base_nocorrf`i'_std, over(segmana) mcompare(tukey) effects
}

cls
oneway base_raven_tt segmana
oneway base_num_tt segmana
oneway base_lit_tt segmana
*/


********** Debt
cls
tabstat indebt_indiv_1 indebt_indiv_2, stat(mean) by(female)
forvalues i=1(1)2{
tabstat loanamount_indiv1000_`i' DSR_indiv_`i' if indebt_indiv_`i'==1, stat(n mean sd p50) by(female)
}
tab debtpath female, col nofreq

tabstat del_loanamount_indiv delta_loanamount_indiv delta2_loanamount_indiv, stat(n mean sd p50) by(female)
tabstat del_DSR_indiv delta_DSR_indiv delta2_DSR_indiv, stat(n mean sd p50) by(female)

tabstat delta2_loanamount_indiv delta2_DSR_indiv, stat(mean sd p50) by(female)
tab debtpath female, col nofreq

/*
*Recode pour ne pas écraser la boite
clonevar DSR_indiv_2_2=DSR_indiv_2
replace DSR_indiv_2_2=300 if DSR_indiv_2_2>300

tabstat DSR_indiv_2 DSR_indiv_2_2, stat(n mean sd q) by(segmana)

stripplot DSR_indiv_2_2 , over(segmana) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(4) xtitle("") xlabel(1 "Dalits women" 2 "Dalits men" 3 "MUC women" 4 "MUC men",angle(0))  ///
ylabel(0(100)300) ymtick(0(50)300) ytitle("") ///
title("DSR (%)") ///
msymbol(oh) mcolor(gs8) name(y1, replace) ///
legend(order(1 "Mean"  4 "Dalits women" 5 "Dalits men" 6 "MUC women" 7 "MUC men") col(4) pos(6))

stripplot debtshare_2, over(segmana) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(4) xtitle("") xlabel(1 "Dalits women" 2 "Dalits men" 3 "MUC women" 4 "MUC men",angle(0))  ///
ylabel(0(0.1)1) ymtick(0(.05)1) ytitle("") ///
title("Share of HH debt (%)") ///
msymbol(oh) mcolor(gs8) name(y1, replace) ///
legend(order(1 "Mean"  4 "Dalits women" 5 "Dalits men" 6 "MUC women" 7 "MUC men") col(4) pos(6))
*/



* ANOVA for debt
cls
foreach x in loans_indiv_2 loanamount_indiv1000_2 DSR_indiv_2 debtshare_2  InformR_indiv_2 NoincogenR_indiv_2{
oneway `x' segmana
}

tab indebt_indiv_2 segmana, nofreq chi2
tab over30_indiv_2 segmana, nofreq chi2
tab over40_indiv_2 segmana, nofreq chi2

*cls
*foreach x in $varokok{
*kwallis `x', by(segmana)
*}



********** Correlation Big5-EFA

pwcorr cr_OP_1 cr_EX_1 cr_ES_1 cr_CO_1 cr_AG_1 cr_OP_2 cr_EX_2 cr_ES_2 cr_CO_2 cr_AG_2, sig
pwcorr OP_1 EX_1 ES_1 CO_1 AG_1 OP_2 EX_2 ES_2 CO_2 AG_2, sig

forvalues i=1(1)5 {
label var factor_imraw_`i'_1 "Factor `i'"
}

label var cr_CO_1 "CO cor (std) 2016-17"
label var cr_OP_1 "OP cor (std) 2016-17"
label var cr_EX_1 "EX cor (std) 2016-17"
label var cr_AG_1 "AG cor (std) 2016-17"
label var cr_ES_1 "ES cor (std) 2016-17"
label var cr_CO_2 "CO cor (std) 2020-21"
label var cr_OP_2 "OP cor (std) 2020-21"
label var cr_EX_2 "EX cor (std) 2020-21"
label var cr_AG_2 "AG cor (std) 2020-21"
label var cr_ES_2 "ES cor (std) 2020-21"

label var CO_1 "CO (std) 2016-17"
label var OP_1 "OP (std) 2016-17"
label var EX_1 "EX (std) 2016-17"
label var AG_1 "AG (std) 2016-17"
label var ES_1 "ES (std) 2016-17"
label var CO_2 "CO (std) 2020-21"
label var OP_2 "OP (std) 2020-21"
label var EX_2 "EX (std) 2020-21"
label var AG_2 "AG (std) 2020-21"
label var ES_2 "ES (std) 2020-21"

set graph off
graph matrix factor_imraw_1_1 factor_imraw_2_1 factor_imraw_3_1 factor_imraw_4_1 factor_imraw_5_1 cr_OP_1 cr_EX_1 cr_ES_1 cr_CO_1 cr_AG_1, half msymbol(o) msize(*0.2)
graph save "$git\Analysis\Personality\Big-5\matrix_b5_efa.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\matrix_b5_efa.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\matrix_b5_efa.pdf", as(pdf) replace

graph matrix cr_OP_1 cr_EX_1 cr_ES_1 cr_CO_1 cr_AG_1 cr_OP_2 cr_EX_2 cr_ES_2 cr_CO_2 cr_AG_2, half msymbol(o) msize(*0.2)
graph save "$git\Analysis\Personality\Big-5\matrix_b5_cr.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\matrix_b5_cr.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\matrix_b5_cr.pdf", as(pdf) replace

graph matrix OP_1 EX_1 ES_1 CO_1 AG_1 OP_2 EX_2 ES_2 CO_2 AG_2, half msymbol(o) msize(*0.2)
graph save "$git\Analysis\Personality\Big-5\matrix_b5.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\matrix_b5.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\matrix_b5.pdf", as(pdf) replace
set graph on



********** CORR personality - debt
/*
cls
forvalues i=1(1)4{
cpcorr  base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt \ loanamount_indiv1000_2  DSR_indiv_2 if segmana==`i', f(%5.2f)
matrix list r(C)
matrix list r(p)
}

preserve
import delimited "corryx.csv", delimiter(";") clear

gen skills_code=.
forvalues i=1(1)5{
replace skills_code=`i' if skills=="F`i'"
}
replace skills_code=6 if skills=="Raven"
replace skills_code=7 if skills=="Num"
replace skills_code=8 if skills=="Lit"

label define skills 1"Factor 1 (std)" 2"Factor 2 (std)" 3"Factor 3 (std)" 4"Factor 5 (std)" 5"Factor 6 (std)" 6"Raven" 7"Numeracy" 8"Literacy"
label values skills_code skills 
label define segmana 1"Dalit female" 2"Dalit male" 3"MU female" 4"MU male"
label values segmana segmana

replace loanamount=round(loanamount,0.01)
replace dsr=round(dsr,0.01)
replace pvalue_loanamount=round(pvalue_loanamount,0.01)
replace pvalue_dsr=round(pvalue_dsr,0.01)

label var loanamount "Total loan amount"
label var dsr "Debt Service Ratio"

set graph off
foreach x in loanamount dsr {
separate `x', by(segmana)
label var `x'1 "Dalit female"
label var `x'2 "Dalit male"
label var `x'3 "MU female"
label var `x'4 "MU male"
separate pvalue_`x', by(segmana)
forvalues i=1(1)4{ 
gsort - `x'`i' skills_code
gen n=_n
sencode skills, gen(var_`x'`i') gsort(`x'`i' skills_code)
replace n=. if n>8
gen threshold=.05
replace threshold=. if n>8
twoway ///
(bar `x'`i' var_`x'`i', barw(0.6) yline(0, lcolor(gs10) lpattern(solid) lwidth(*0.8))) ///
(scatter `x'`i' var_`x'`i', mlabel(`x'`i') mlabposition(12) mlabsize(*0.8) mlabangle(0) msymbol(i)) ///
(scatter pvalue_`x'`i' var_`x'`i', msymbol(o) mcolor(gs1) msize(*0.2)) ///
(line threshold var_`x', lcolor(gs1) lpattern(solid) lwidth(*0.2)), ///
xlabel(1(1)8, valuelabel labsize(vsmall) angle(45) nogrid) xtitle(`:variable label `x'`i'')  ///
ylabel(-.2(.2)1, labsize(vsmall)) ///
title("", size(small)) ///
legend(order(1 "Correlation" 3 "p-value" 4 ".05 threshold") pos(6) col(3) size(vsmall) off) ///
name(g_`x'`i', replace)
drop n
drop `x'`i' pvalue_`x'`i' var_`x'`i'
drop threshold
}
}
grc1leg g_loanamount1 g_loanamount2 g_loanamount3 g_loanamount4, cols(4) title("Total loan amount", size(small)) name(comb_loanamount, replace)
grc1leg g_dsr1 g_dsr2 g_dsr3 g_dsr4, cols(4) title("Debt service ratio", size(small)) name(comb_dsr, replace)
set graph on
grc1leg comb_loanamount comb_dsr, cols(1)
graph save "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\corryx.gph", replace
graph export "C:\Users\Arnaud\Documents\GitHub\RUME-NEEMSIS\Big-5\corryx.svg", as(svg) replace
graph export "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\corryx.pdf", as(pdf) replace
restore
*/

****************************************
* END














****************************************
* Descriptive statistics for loans
****************************************
use"NEEMSIS2-loans_v13~desc", clear

gen loanamount1000=loanamount/1000

tabstat loanamount1000, stat(n mean sd p50) by(loanlender_new2020)
tabstat loanamount1000, stat(n mean sd p50) by(loanreasongiven)

********** Total clientele using it: reason
fre loanreasongiven
forvalues i=1(1)13{
gen reason`i'=0
}

forvalues i=1(1)12{
replace reason`i'=1 if loanreasongiven==`i'
}
replace reason13=1 if loanreasongiven==77

cls
preserve 
forvalues i=1(1)13{
bysort HHID_panel INDID_panel: egen reasonHH_`i'=max(reason`i')
} 
bysort HHID_panel INDID_panel: gen n=_n
keep if n==1
forvalues i=1(1)13{
tab reasonHH_`i', m
}
restore
drop reason1 reason2 reason3 reason4 reason5 reason6 reason7 reason8 reason9 reason10 reason11 reason12 reason13

********** Clientele using it: source
fre loanlender_new2020
forvalues i=1(1)15{
gen lenders_`i'=0
}
forvalues i=1(1)15{
replace lenders_`i'=1 if loanlender_new2020==`i'
}


cls
preserve 
forvalues i=1(1)15{
bysort HHID_panel INDID_panel: egen lendersHH_`i'=max(lenders_`i')
} 
bysort HHID_panel INDID_panel: gen n=_n
keep if n==1
forvalues i=1(1)15{
tab lendersHH_`i', m
}
restore
drop lenders_1 lenders_2 lenders_3 lenders_4 lenders_5 lenders_6 lenders_7 lenders_8 lenders_9 lenders_10 lenders_11 lenders_12 lenders_13 lenders_14 lenders_15

****************************************
* END
