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
global directory = "D:\Documents\_Thesis\Research-Skills_and_debt\New_analysis"
cd"$directory"

********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH_v7"
global wave3 "NEEMSIS2-HH_v16"


********** Stata package

*coefplot, horizontal xline(0) drop(_cons) levels(95 90 ) ciopts(recast(. rcap))mlabel mlabposition(12) mlabgap(*2)

****************************************
* END








****************************************
* LAST CLEANING BEFORE ANALYSIS
****************************************

**********
use"panel_wide", clear

*Recode
gen female=0 if sex_1==1
replace female=1 if sex_1==2
label var female "Female (=1)"

gen agesq_1=age_1*age_1
gen agesq_2=age_2*age_2
label var age_1 "Age"
label var agesq_1 "Age square"
label var age_2 "Age"
label var agesq_2 "Age square"

tab caste, gen(caste_)
label var caste_1 "C: Dalits"
label var caste_2 "C: Middle"
label var caste_3 "C: Upper"

tab cat_mainoccupation_indiv_1,gen(cat_mainoccupation_indiv_1_)
label var cat_mainoccupation_indiv_1_1 "MO: Agri"
label var cat_mainoccupation_indiv_1_2 "MO: SE"
label var cat_mainoccupation_indiv_1_3 "MO: SJ agri"
label var cat_mainoccupation_indiv_1_4 "MO: SJ non-agri"
label var cat_mainoccupation_indiv_1_5 "MO: UW or NW"

fre relationshiptohead_1
gen dummyhead=0
replace dummyhead=1 if relationshiptohead_1==1
label var dummyhead "HH head (=1)"


tab sexratiocat_1, gen(sexratiocat_1_)
label var sexratiocat_1_1 "SR: More female"
label var sexratiocat_1_2 "SR: Same nb"
label var sexratiocat_1_3 "SR: More male"

fre maritalstatus_1 maritalstatus_2
gen maritalstatus2_1=1 if maritalstatus_1==1
gen maritalstatus2_2=1 if maritalstatus_2==1
recode maritalstatus2_1 maritalstatus2_2 (.=0)
label define marital 0"Other (un, wid, sep)" 1"Married (=1)"
label values maritalstatus2_1 marital
label values maritalstatus2_2 marital
label var maritalstatus2_1 "Married (=1)"
label var maritalstatus2_2 "Married (=1)"
fre maritalstatus2_1 maritalstatus2_2

tab1 near_panruti near_villupur near_tirup near_chengal near_kanchip near_chennai
label var near_panruti "Loc: near Panruti"
label var near_villupur "Loc: near Villupuram"
label var near_tirup "Loc: near Tiruppur"
label var near_chengal "Loc: near Chengalpattu"
label var near_kanchip "Loc: near Kanchipuram"
label var near_chennai "Loc: near Chennai"

gen nboccupation=2 if nboccupation_indiv_1==1
replace nboccupation=3 if nboccupation_indiv_1==2
replace nboccupation=4 if nboccupation_indiv_1>2
replace nboccupation=1 if nboccupation_indiv_1==.
tab nboccupation
label define occ 1"Nb occ: 0" 2"Nb occ: 1" 3"Nb occ: 2" 4"Nb occ: 3 or more"
label values nboccupation occ
tab nboccupation, gen(nboccupation_)
label var nboccupation_1 "Nb occ: 0"
label var nboccupation_2 "Nb occ: 1"
label var nboccupation_3 "Nb occ: 2"
label var nboccupation_4 "Nb occ: 3 or more"
tab1 nboccupation_1 nboccupation_2 nboccupation_3 nboccupation_4

tab HHID_panel, gen(HHFE_)

label var dummyedulevel "School educ (=1)"

label var shock_1 "Shock (=1)"
label var shock_2 "Shock (=1)"

gen assets1000_1=assets_1/1000
gen assets1000_2=assets_2/1000
label var assets1000_1 "Assets (1,000 INR)"
label var assets1000_2 "Assets (1,000 INR)"

gen incomeHH1000_1=totalincome_HH_1/1000
gen incomeHH1000_2=totalincome_HH_2/1000
label var incomeHH1000_1 "Total income (1,000 INR)"
label var incomeHH1000_2 "Total income (1,000 INR)"

xtile q_assets1000_1=assets_1, n(4)
tab q_assets1000_1, gen(q_assets1000_1_)
label var q_assets1000_1_1 "Assets Q1"
label var q_assets1000_1_2 "Assets Q2"
label var q_assets1000_1_3 "Assets Q3"
label var q_assets1000_1_4 "Assets Q4"


*Dummy for debt or not
fre debtpath
gen dummydebt=0 if debtpath==0
replace dummydebt=0 if debtpath==1
replace dummydebt=1 if debtpath==2
replace dummydebt=1 if debtpath==3

label define debt 0"Not in debt" 1"Indebted"
label values dummydebt debt

tab debtpath dummydebt, row nofreq
tab debtpath dummydebt, col nofreq

*Correlation with assets and house
median assets1000_1, by(ownland_1)
ttest assets1000_1, by(ownland_1)
sdtest assets1000_1, by(ownland_1)

*Correlation wiht assets and house
median assets1000_1, by(ownhouse_1)
ttest assets1000_1, by(ownhouse_1)
sdtest assets1000_1, by(ownhouse_1)


*Label for factor
label var base_nocorrf1_std "Factor 1 (std)"
label var base_nocorrf2_std "Factor 2 (std)"
label var base_nocorrf3_std "Factor 3 (std)"
label var base_nocorrf4_std "Factor 4 (std)"
label var base_nocorrf5_std "Factor 5 (std)"



*1000 
foreach x in loanamount_indiv loanamount_HH imp1_ds_tot_indiv imp1_ds_tot_HH imp1_is_tot_indiv imp1_is_tot_HH savingsamount annualincome_indiv annualincome_HH totalincome_indiv {
gen `x'1000_1=`x'_1/1000 
gen `x'1000_2=`x'_2/1000 
}


*Recoder dummy
recode dummyproblemtorepay_indiv_1 dummyproblemtorepay_indiv_2 dummyhelptosettleloan_indiv_1 dummyhelptosettleloan_indiv_2 (2=1) (3=1) (4=1) (5=1)




tab1 indebt_indiv_1 indebt_indiv_2
tab DSR_indiv_2
gen over30_indiv_1=0
gen over30_indiv_2=0
gen over40_indiv_1=0
gen over40_indiv_2=0

replace over30_indiv_1=1 if DSR_indiv_1>30
replace over30_indiv_2=1 if DSR_indiv_2>30
replace over40_indiv_1=1 if DSR_indiv_1>40
replace over40_indiv_2=1 if DSR_indiv_2>40

gen dichotomyinterest_indiv_1=0
gen dichotomyinterest_indiv_2=0

replace dichotomyinterest_indiv_1=1 if dummyinterest_indiv_1>0
replace dichotomyinterest_indiv_2=1 if dummyinterest_indiv_2>0

replace dichotomyinterest_indiv_1=. if indebt_indiv_1==0
replace dichotomyinterest_indiv_2=. if indebt_indiv_2==0

tab1 dichotomyinterest_indiv_1 dichotomyinterest_indiv_2




*Est-ce que la personnalité contribue à l'augmentation ou à la diminution ?
global delta delta_debtshare delta_loanamount_indiv delta_imp1_ds_tot_indiv delta_imp1_is_tot_indiv delta_DSR_indiv delta_ISR_indiv delta_goldquantity delta_mean_yratepaid_indiv delta_loans_indiv delta_InformR_indiv delta_NoincogenR_indiv delta_savingsamount delta_annualincome_indiv
foreach x in $delta {
gen abs_`x'=abs(`x')
}

foreach x in $delta {
gen bin_`x'=0 if `x'<0
}

foreach x in $delta {
replace bin_`x'=1 if `x'>0
}

tabstat abs_delta_debtshare, stat(n mean sd p50) by(bin_delta_debtshare)


foreach x in $delta {
gen `x'_f1=bin_`x'*base_nocorrf1_std
gen `x'_f2=bin_`x'*base_nocorrf2_std
gen `x'_f3=bin_`x'*base_nocorrf3_std
gen `x'_f4=bin_`x'*base_nocorrf4_std
gen `x'_f5=bin_`x'*base_nocorrf5_std
gen `x'_r1=bin_`x'*base_raven_tt
gen `x'_n1=bin_`x'*base_num_tt
gen `x'_l1=bin_`x'*base_lit_tt
}



clonevar caste2=caste
recode caste2 (3=2)

tab caste2 female


********** Groups creation
gen segmana=.
replace segmana=1 if caste==1 & female==1  // female dalits (DJ)
replace segmana=2 if caste==1 & female==0  // male dalits
replace segmana=3 if (caste==2 | caste==3) & female==1  // female midup
replace segmana=4 if (caste==2 | caste==3) & female==0  // male midup

label define segmana 1"Dalit women" 2"Dalit men" 3"MU caste women" 4"MU caste men"
label values segmana segmana

tab segmana


*HHFE
encode HHID_panel, gen(HHvar)
fre HHvar


*Dummy for multiple occupation
fre nboccupation_indiv_1 nboccupation_indiv_2
gen dummymultipleoccupation_indiv_1=0 if nboccupation_indiv_1==1
gen dummymultipleoccupation_indiv_2=0 if nboccupation_indiv_2==1

replace dummymultipleoccupation_indiv_1=1 if nboccupation_indiv_1>1 & nboccupation_indiv_1!=.
replace dummymultipleoccupation_indiv_2=1 if nboccupation_indiv_2>1 & nboccupation_indiv_2!=.

tab nboccupation_indiv_1 dummymultipleoccupation_indiv_1, m


**
foreach x in debtshare InformR_indiv FormR_indiv NoincogenR_indiv IncogenR_indiv {
forvalues i=1(1)2{
clonevar `x'_`i'_old=`x'_`i'
}
}

foreach x in debtshare InformR_indiv FormR_indiv NoincogenR_indiv IncogenR_indiv {
forvalues i=1(1)2{
replace `x'_`i'=`x'_`i'/100
}
}


********** Verif N
global efa base_nocorrf1_std base_nocorrf2_std base_nocorrf3_std base_nocorrf4_std base_nocorrf5_std
global cog base_raven_tt base_num_tt base_lit_tt
global indivcontrol age_1 agesq_1 dummyhead cat_mainoccupation_indiv_1_1 cat_mainoccupation_indiv_1_2 cat_mainoccupation_indiv_1_3 cat_mainoccupation_indiv_1_4 cat_mainoccupation_indiv_1_5 dummyedulevel maritalstatus2_1 dummymultipleoccupation_indiv_1
global hhcontrol4 assets1000_1 sexratiocat_1_1 sexratiocat_1_2 sexratiocat_1_3 hhsize_1 shock_1 incomeHH1000_1
global villagesFE near_panruti near_villupur near_tirup near_chengal near_kanchip near_chennai
global big5 base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std

sum $efa $cog $indivcontrol $hhcontrol4 $villagesFE $big5
tab1 cat_mainoccupation_indiv_1_1 cat_mainoccupation_indiv_1_2 cat_mainoccupation_indiv_1_3 cat_mainoccupation_indiv_1_5 
tab cat_mainoccupation_indiv_1 nboccupation, m 
tab nboccupation dummymultipleoccupation_indiv_1, m
recode dummymultipleoccupation_indiv_1 (.=0)
tab dummymultipleoccupation_indiv_1

fsum $efa $cog $indivcontrol $hhcontrol4 $villagesFE

label var dummymultipleoccupation_indiv_1 "Multiple occupation (=1)"

save"panel_wide_v2", replace
****************************************
* END




********** Loans check
use"C:\Users\Arnaud\Dropbox\RUME-NEEMSIS\NEEMSIS2\NEEMSIS2-loans_v13", clear
order HHID_panel INDID_panel
*Id for ML
gen dummymainloan=0
replace dummymainloan=1 if lenderfirsttime!=.
tab dummymainloan

tab otherlenderservices
gen otherlenderservices_politsupp=0
gen otherlenderservices_finansupp=0
gen otherlenderservices_guarantor=0
gen otherlenderservices_generainf=0
gen otherlenderservices_none=0
gen otherlenderservices_other=0
replace otherlenderservices_politsupp=1 if strpos(otherlenderservices,"1")
replace otherlenderservices_finansupp=1 if strpos(otherlenderservices,"2")
replace otherlenderservices_guarantor=1 if strpos(otherlenderservices,"3")
replace otherlenderservices_generainf=1 if strpos(otherlenderservices,"4")
replace otherlenderservices_none=1 if strpos(otherlenderservices,"5")
replace otherlenderservices_other=1 if strpos(otherlenderservices,"77")

tab1 otherlenderservices_politsupp otherlenderservices_finansupp otherlenderservices_guarantor otherlenderservices_generainf otherlenderservices_none otherlenderservices_other

tab borrowerservices
gen borrowerservices_freeserv=0 if dummymainloan==1
gen borrowerservices_worklesswage=0 if dummymainloan==1
gen borrowerservices_suppwhenever=0 if dummymainloan==1
gen borrowerservices_none=0 if dummymainloan==1
gen borrowerservices_other=0 if dummymainloan==1
replace borrowerservices_freeserv=1 if strpos(borrowerservices,"1") & dummymainloan==1
replace borrowerservices_worklesswage=1 if strpos(borrowerservices,"2") & dummymainloan==1
replace borrowerservices_suppwhenever=1 if strpos(borrowerservices,"3") & dummymainloan==1
replace borrowerservices_none=1 if strpos(borrowerservices,"4") & dummymainloan==1
replace borrowerservices_other=1 if strpos(borrowerservices,"77") & dummymainloan==1

tab1 borrowerservices_freeserv borrowerservices_worklesswage borrowerservices_suppwhenever borrowerservices_none borrowerservices_other

*New Y through borrowerservices?
foreach x in borrowerservices_freeserv borrowerservices_worklesswage borrowerservices_suppwhenever borrowerservices_none borrowerservices_other {
bysort HHID_panel INDID_panel: egen s_`x'=sum(`x')
}

preserve
duplicates drop HHID_panel INDID_panel, force
tab1 s_borrowerservices_freeserv s_borrowerservices_worklesswage s_borrowerservices_suppwhenever s_borrowerservices_none s_borrowerservices_other
restore

tab loanlender_new2020

***** Garder que mes individus
merge m:1 HHID_panel INDID_panel using "panel_wide_v2.dta", keepusing(caste_1)
keep if _merge==3
drop _merge
drop caste_1

*Intermediate
save "NEEMSIS2-loans_v13~desc", replace

*Gen borrowerservices
tab1 s_borrowerservices_freeserv s_borrowerservices_worklesswage s_borrowerservices_suppwhenever s_borrowerservices_none s_borrowerservices_other
preserve 
keep HHID_panel INDID_panel s_borrowerservices_freeserv s_borrowerservices_worklesswage s_borrowerservices_suppwhenever s_borrowerservices_none s_borrowerservices_other
duplicates drop
save"NEEMSIS2_services", replace
restore

use"panel_wide_v2", clear
merge 1:1 HHID_panel INDID_panel using "NEEMSIS2_services"
drop _merge


*Creation dummy
tab1 s_borrowerservices_freeserv s_borrowerservices_worklesswage s_borrowerservices_suppwhenever s_borrowerservices_none s_borrowerservices_other

clonevar dummysuppwhenever=s_borrowerservices_suppwhenever
recode dummysuppwhenever (3=1) (2=1)

tab1 dummysuppwhenever dummyhelptosettleloan_indiv_2 dummyproblemtorepay_indiv_2

*Clonevar
fre dummyproblemtorepay_indiv_1 dummyproblemtorepay_indiv_2
foreach x in dummyproblemtorepay_indiv_1 dummyproblemtorepay_indiv_2{
clonevar n_`x'=`x'
recode n_`x' (.=0)
}

fre dummyproblemtorepay_indiv_1 n_dummyproblemtorepay_indiv_1 dummyproblemtorepay_indiv_2 n_dummyproblemtorepay_indiv_2



save"panel_wide_v3.dta", replace
****************************************
* END













****************************************
* Descriptive statistics
****************************************
use"panel_wide_v3.dta", clear

tab segmana

gen incomeHH1000_pc_1=incomeHH1000_1/hhsize_1
gen incomeHH1000_pc_2=incomeHH1000_2/hhsize_2


********** HH characteristics
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
tabstat annualincome_HH1000_1 incomeHH1000_1 incomeHH1000_pc_1, stat(n mean sd p50) by(caste)
tab indebt_HH_1 caste, col nofreq
cls
foreach x in near_panruti near_villupur near_tirup near_chengal near_kanchip near_chennai {
tab `x' caste, col nofreq
}
*Test
cls
ttest hhsize_1, by(caste)
tab sexratiocat_1 caste, nofreq chi2
ttest assets1000_1, by(caste)
ttest incomeHH1000_1, by(caste)
tab shock_1 caste, nofreq chi2
tab indebt_HH_1 caste, nofreq chi2
restore


********** Indiv characteristics
cls
tabstat age_1, stat(n mean) by(segmana)

tab dummyhead segmana, col nofreq
tab relationshiptohead_1 segmana, col nofreq

tab cat_mainoccupation_indiv_1 segmana, col nofreq
tab mainoccupation_indiv_1 segmana, col nofreq

tab dummyedulevel segmana, col nofreq
tab edulevel_1 segmana, col nofreq

tab maritalstatus_1 segmana, col nofreq
tab maritalstatus2_1 segmana, col nofreq

tab dummymultipleoccupation_indiv_1 segmana, col nofreq

tabstat annualincome_indiv1000_1, stat(mean sd p50) by(segmana)


*Test
cls
oneway age_1 segmana

foreach x in dummyhead cat_mainoccupation_indiv_1 dummyedulevel maritalstatus2_1 dummymultipleoccupation_indiv_1 {
tab `x' segmana, nofreq chi2
}

oneway annualincome_indiv1000_1 segmana





********** Personality
/*
set graph off
forvalues i=1(1)5{
twoway ///
(kdensity base_nocorrf`i'_std if segmana==1, bwidth(0.32) lpattern(solid) lcolor(gs4)) ///
(kdensity base_nocorrf`i'_std if segmana==2, bwidth(0.32) lpattern(shortdash) lcolor(gs0)) ///
(kdensity base_nocorrf`i'_std if segmana==3, bwidth(0.32) lpattern(dash) lcolor(gs9)) ///
(kdensity base_nocorrf`i'_std if segmana==4, bwidth(0.32) lpattern(solid) lcolor(gs12)), ///
xsize() xtitle("Factor `i' (std.)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Kernel density", size(small)) ///
legend(position(6) col(2) order(1 "Dalits women" 2 "Dalits men" 3 "MU caste women" 4 "MU caste men") off) name(f`i', replace)
}

twoway ///
(kdensity base_raven_tt if segmana==1, bwidth(3) lpattern(solid) lcolor(gs4)) ///
(kdensity base_raven_tt if segmana==2, bwidth(3) lpattern(shortdash) lcolor(gs0)) ///
(kdensity base_raven_tt if segmana==3, bwidth(3) lpattern(dash) lcolor(gs9)) ///
(kdensity base_raven_tt if segmana==4, bwidth(3) lpattern(solid) lcolor(gs12)), ///
xsize() xtitle("Raven test", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Kernel density", size(small)) ///
legend(position(6) col(2) order(1 "Male" 2 "Female") off) name(f6, replace)

twoway ///
(kdensity base_num_tt if segmana==1, bwidth(1.5) lpattern(solid) lcolor(gs4)) ///
(kdensity base_num_tt if segmana==2, bwidth(1.5) lpattern(shortdash) lcolor(gs0)) ///
(kdensity base_num_tt if segmana==3, bwidth(1.5) lpattern(dash) lcolor(gs9)) ///
(kdensity base_num_tt if segmana==4, bwidth(1.5) lpattern(solid) lcolor(gs12)), ///
xsize() xtitle("Numeracy test", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Kernel density", size(small)) ///
legend(position(6) col(2) order(1 "Male" 2 "Female") off) name(f7, replace)

twoway ///
(kdensity base_lit_tt if segmana==1, bwidth(1.7) lpattern(solid) lcolor(gs4)) ///
(kdensity base_lit_tt if segmana==2, bwidth(1.7) lpattern(shortdash) lcolor(gs0)) ///
(kdensity base_lit_tt if segmana==3, bwidth(1.7) lpattern(dash) lcolor(gs9)) ///
(kdensity base_lit_tt if segmana==4, bwidth(1.7) lpattern(solid) lcolor(gs12)), ///
xsize() xtitle("Literacy test", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Kernel density", size(small)) ///
legend(position(6) col(2) order(1 "Male" 2 "Female") off) name(f8, replace)

set graph on

grc1leg f1 f2 f3 f4 f5 f6 f7 f8, cols(4) note("Kernel: Epanechnikov;" "Bandwidth: 0.32 for factors, 3 for raven, 1.5 for literacy, 1 for numeracy.", size(vsmall)) name(perso, replace)
graph export "Kernel_perso2.pdf", as(pdf) name(perso) replace


* ANOVA for personality
tabstat base_nocorrf1_std base_nocorrf2_std base_nocorrf3_std base_nocorrf4_std base_nocorrf5_std, stat(n mean sd p50) by(segmana)
cls
forvalues i=1(1)5{
oneway base_nocorrf`i'_std segmana //, tab
*pwmean base_nocorrf`i'_std, over(segmana) mcompare(tukey) effects
}

cls
oneway base_raven_tt segmana
oneway base_num_tt segmana
oneway base_lit_tt segmana
*/






********** Debt
tabstat loans_indiv_2 loanamount_indiv1000_2 DSR_indiv_2 debtshare_2  InformR_indiv_2 NoincogenR_indiv_2, stat(mean sd p50) by(segmana)

tabstat indebt_indiv_2 over30_indiv_2 over40_indiv_2, stat(mean) by(segmana)

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

 




********** CORR personality - debt
forvalues i=1(1)4{
estpost correlate base_nocorrf1_std base_nocorrf2_std base_nocorrf3_std base_nocorrf4_std base_nocorrf5_std base_raven_tt base_num_tt base_lit_tt indebt_indiv_2 loans_indiv_2 loanamount_indiv1000_2 DSR_indiv_2 debtshare_2 over30_indiv_2 over40_indiv_2 InformR_indiv_2 NoincogenR_indiv_2 if segmana==`i', matrix listwise
esttab using corr.csv, unstack not noobs compress starlevels(* 0.10 ** 0.05 *** 0.01) replace cells(b(fmt(2)))

preserve
import delimited "corr.csv", delimiter(",") varnames(nonames) clear
gen n=_n
drop if n<=12
drop v10 v11 v12 v13 v14 v15 v16 v17 v18
drop n
forvalues j=2(1)9{
replace v`j'=substr(v`j',3,strlen(v`j')) if substr(v`j',strlen(v`j')-1,1)!="*"
replace v`j'=substr(v`j',1,strlen(v`j')-1) if substr(v`j',strlen(v`j')-1,1)!="*"
}
destring v2 v3 v4 v5 v6 v7 v8 v9, replace
export excel using "Stat_desc.xlsx", sheet("corr_segmana_`i'", replace)
restore
}

*cells(b(star fmt(2)))

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
















****************************************
* Analysis : debt
****************************************
use"panel_wide_v3.dta", clear

global efa base_nocorrf1_std base_nocorrf2_std base_nocorrf3_std base_nocorrf4_std base_nocorrf5_std
global cog base_raven_tt base_num_tt base_lit_tt
global indivcontrol age_1 agesq_1 dummyhead cat_mainoccupation_indiv_1_1 cat_mainoccupation_indiv_1_2 cat_mainoccupation_indiv_1_3 cat_mainoccupation_indiv_1_4 cat_mainoccupation_indiv_1_5 dummyedulevel maritalstatus2_1 dummymultipleoccupation_indiv_1
global hhcontrol4 assets1000_1 sexratiocat_1_1 sexratiocat_1_2 sexratiocat_1_3 hhsize_1 shock_1 incomeHH1000_1
global villagesFE near_panruti near_villupur near_tirup near_chengal near_kanchip near_chennai
global big5 base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std


/*
*Test effet de selection?
foreach x in over30_indiv over40_indiv loanamount_indiv1000 DSR_indiv debtshare InformR_indiv NoincogenR_indiv loans_indiv {
replace `x'_2=. if indebt_indiv_2==0
}
*/

*Quelle stat affichée ?
*reg loanamount_indiv1000_2 loanamount_indiv1000_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==3, vce(cluster HHvar)
*matlist r(table)


********** 1.
********** Proba of being in debt, or overindebted, interest in t+1
foreach cat in 1 2 3 4 {
qui probit indebt_indiv_2 indebt_indiv_1 $efa $cog if segmana==`cat', vce(cluster HHvar)
est store res_`cat'1

qui probit indebt_indiv_2 indebt_indiv_1 $efa $cog $indivcontrol if segmana==`cat', vce(cluster HHvar)
est store res_`cat'2

qui probit indebt_indiv_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat', vce(cluster HHvar)
est store res_`cat'3

predict probitxb_`cat', xb
ge pdf_`cat'=normalden(probitxb_`cat')
ge cdf_`cat'=normal(probitxb_`cat')
ge imr_`cat'=pdf_`cat'/cdf_`cat'
}

esttab res_* using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop() ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace
estimates clear
preserve
import delimited "_reg.csv", delimiter(",") varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "Probit_indebt.xlsx", sheet("`var'", replace)
restore



********** Effet de selection pour ceux pas endettés
drop if indebt_indiv_2==0
tab segmana




********** 2.
********** Proba of being overindebted, interest in t+1
foreach var in over30_indiv over40_indiv {
foreach cat in 1 2 3 4 {
qui probit `var'_2 `var'_1 $efa $cog if segmana==`cat', vce(cluster HHvar)
est store res_`cat'1

qui probit `var'_2 `var'_1 $efa $cog $indivcontrol if segmana==`cat', vce(cluster HHvar)
est store res_`cat'2

qui probit `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat', vce(cluster HHvar)
est store res_`cat'3
}

esttab res_* using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop() ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace
estimates clear
preserve
import delimited "_reg.csv", delimiter(",") varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "Probit_indebt.xlsx", sheet("`var'", replace)
restore
}




********** 3.
********** Level of debt in t+1
 
foreach var in loanamount_indiv1000 DSR_indiv {

foreach cat in 1 2 3 4 {
qui reg `var'_2 `var'_1 $efa $cog if segmana==`cat', vce(cluster HHvar)
est store res_`cat'1

qui reg `var'_2 `var'_1 $efa $cog $indivcontrol if segmana==`cat', vce(cluster HHvar)
est store res_`cat'2

qui reg `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat', vce(cluster HHvar)
est store res_`cat'3
}

esttab res_* using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop() ///	
	legend label varlabels(_cons constant) ///
	stats(N r2 r2_a F, fmt(0 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace
estimates clear
preserve
import delimited "_reg.csv", delimiter(",") varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "OLS_indebt.xlsx", sheet("`var'", replace)
restore

}









********** 4.
********** Level of debt in t+1

foreach var in debtshare InformR_indiv NoincogenR_indiv {

foreach cat in 1 2 3 4 {
qui glm `var'_2 `var'_1 $efa $cog if segmana==`cat', fam(bin) link(logit) vce(cluster HHvar)
est store res_`cat'1

qui glm `var'_2 `var'_1 $efa $cog $indivcontrol if segmana==`cat', fam(bin) link(logit) vce(cluster HHvar)
est store res_`cat'2

qui glm `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat', fam(bin) link(logit) vce(cluster HHvar)
est store res_`cat'3
}

esttab res_* using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop() ///	
	legend label varlabels(_cons constant) ///
	stats(N chi2 p deviance ic, fmt(0 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace
estimates clear
preserve
import delimited "_reg.csv", delimiter(",") varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "GLM_indebt.xlsx", sheet("`var'", replace)
restore

}





********** 5.
********** Level of debt in t+1

foreach var in loans_indiv {

foreach cat in 1 2 3 4 {
qui poisson `var'_2 `var'_1 $efa $cog if segmana==`cat', vce(cluster HHvar)
est store res_`cat'1

qui poisson `var'_2 `var'_1 $efa $cog $indivcontrol if segmana==`cat', vce(cluster HHvar)
est store res_`cat'2

qui poisson `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if segmana==`cat', vce(cluster HHvar)
est store res_`cat'3
}

esttab res_* using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop() ///
	legend label varlabels(_cons constant) ///
	stats(N df_m r2_p ll chi2 p, fmt(0 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace
estimates clear
preserve
import delimited "_reg.csv", delimiter(",") varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "Poisson_indebt.xlsx", sheet("`var'", replace)
restore
}

