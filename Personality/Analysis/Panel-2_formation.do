cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
May 13, 2021
-----
Personality traits: EFA + panel
-----

-------------------------
*/

*ssc install catplot
*ssc install sencode

****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
********** Path to folder "data" folder.
global directory = "D:\Documents\_Thesis\Research-Skills_and_debt\Analysis"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"
global dropbox "C:\Users\Arnaud\Dropbox"

set scheme plotplain 

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
* Prépa 2020
****************************************

********** 
use"$wave3", clear

merge m:1 HHID_panel using "panel", nogen keep(3)
*keep if egoid>0

tab age
fre sex


********** Imputation for non corrected one
global big5 ///
curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination ///
organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties ///
enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts  ///
workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers ///
managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm ///
tryhard  stickwithgoals   goaftergoal finishwhatbegin finishtasks  keepworking

global big5raw raw_curious raw_interestedbyart raw_repetitivetasks raw_inventive raw_liketothink raw_newideas raw_activeimagination raw_organized raw_makeplans raw_workhard raw_appointmentontime raw_putoffduties raw_easilydistracted raw_completeduties raw_enjoypeople raw_sharefeelings raw_shywithpeople raw_enthusiastic raw_talktomanypeople raw_talkative raw_expressingthoughts raw_workwithother raw_understandotherfeeling raw_trustingofother raw_rudetoother raw_toleratefaults raw_forgiveother raw_helpfulwithothers raw_managestress raw_nervous raw_changemood raw_feeldepressed raw_easilyupset raw_worryalot raw_staycalm raw_tryhard raw_stickwithgoals raw_goaftergoal raw_finishwhatbegin raw_finishtasks raw_keepworking

global big5cor cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking

foreach x in $big5 $big5raw $big5cor{
gen im_`x'=`x'
}


forvalues j=1(1)3{
forvalues i=1(1)2{
foreach x in $big5 $big5raw $big5cor{
sum im_`x' if sex==`i' & caste==`j' & egoid!=0 & egoid!=.
replace im_`x'=r(mean) if im_`x'==. & sex==`i' & caste==`j' & egoid!=0 & egoid!=.
}
}
}

global imcorwith im_cr_curious im_cr_interestedbyart im_cr_repetitivetasks im_cr_inventive im_cr_liketothink im_cr_newideas im_cr_activeimagination im_cr_organized im_cr_makeplans im_cr_workhard im_cr_appointmentontime im_cr_putoffduties im_cr_easilydistracted im_cr_completeduties im_cr_enjoypeople im_cr_sharefeelings im_cr_shywithpeople im_cr_enthusiastic im_cr_talktomanypeople im_cr_talkative im_cr_expressingthoughts im_cr_workwithother im_cr_understandotherfeeling im_cr_trustingofother im_cr_rudetoother im_cr_toleratefaults im_cr_forgiveother im_cr_helpfulwithothers im_cr_managestress im_cr_nervous im_cr_changemood im_cr_feeldepressed im_cr_easilyupset im_cr_worryalot im_cr_staycalm im_cr_tryhard im_cr_stickwithgoals im_cr_goaftergoal im_cr_finishwhatbegin im_cr_finishtasks im_cr_keepworking

global imrawwith im_raw_curious im_raw_interestedbyart im_raw_repetitivetasks im_raw_inventive im_raw_liketothink im_raw_newideas im_raw_activeimagination im_raw_organized im_raw_makeplans im_raw_workhard im_raw_appointmentontime im_raw_putoffduties im_raw_easilydistracted im_raw_completeduties im_raw_enjoypeople im_raw_sharefeelings im_raw_shywithpeople im_raw_enthusiastic im_raw_talktomanypeople im_raw_talkative im_raw_expressingthoughts im_raw_workwithother im_raw_understandotherfeeling im_raw_trustingofother im_raw_rudetoother im_raw_toleratefaults im_raw_forgiveother im_raw_helpfulwithothers im_raw_managestress im_raw_nervous im_raw_changemood im_raw_feeldepressed im_raw_easilyupset im_raw_worryalot im_raw_staycalm  im_raw_tryhard im_raw_stickwithgoals im_raw_goaftergoal im_raw_finishwhatbegin im_raw_finishtasks im_raw_keepworking

global imcor im_cr_curious im_cr_interestedbyart im_cr_repetitivetasks im_cr_inventive im_cr_liketothink im_cr_newideas im_cr_activeimagination im_cr_organized im_cr_makeplans im_cr_workhard im_cr_appointmentontime im_cr_putoffduties im_cr_easilydistracted im_cr_completeduties im_cr_enjoypeople im_cr_sharefeelings im_cr_shywithpeople im_cr_enthusiastic im_cr_talktomanypeople im_cr_talkative im_cr_expressingthoughts im_cr_workwithother im_cr_understandotherfeeling im_cr_trustingofother im_cr_rudetoother im_cr_toleratefaults im_cr_forgiveother im_cr_helpfulwithothers im_cr_managestress im_cr_nervous im_cr_changemood im_cr_feeldepressed im_cr_easilyupset im_cr_worryalot im_cr_staycalm

global imraw im_raw_curious im_raw_interestedbyart im_raw_repetitivetasks im_raw_inventive im_raw_liketothink im_raw_newideas im_raw_activeimagination im_raw_organized im_raw_makeplans im_raw_workhard im_raw_appointmentontime im_raw_putoffduties im_raw_easilydistracted im_raw_completeduties im_raw_enjoypeople im_raw_sharefeelings im_raw_shywithpeople im_raw_enthusiastic im_raw_talktomanypeople im_raw_talkative im_raw_expressingthoughts im_raw_workwithother im_raw_understandotherfeeling im_raw_trustingofother im_raw_rudetoother im_raw_toleratefaults im_raw_forgiveother im_raw_helpfulwithothers im_raw_managestress im_raw_nervous im_raw_changemood im_raw_feeldepressed im_raw_easilyupset im_raw_worryalot im_raw_staycalm 

foreach x in imcorwith imrawwith {
*minap $`x'
*fsum $`x', stat(n mean sd)
qui factor $`x', pcf fa(6) 
rotate, promax
*putexcel set "EFA_2020.xlsx", modify sheet(`x')
*putexcel (E2)=matrix(e(r_L))

predict factor_`x'_1 factor_`x'_2 factor_`x'_3 factor_`x'_4 factor_`x'_5 factor_`x'_6
cpcorr $`x' \ factor_`x'_1 factor_`x'_2 factor_`x'_3 factor_`x'_4 factor_`x'_5 factor_`x'_6
matrix list r(p)

*Correlation with big-5 and cronbach
cpcorr cr_OP cr_EX cr_ES cr_CO cr_AG cr_Grit OP EX ES CO AG Grit factor_`x'_1 factor_`x'_2 factor_`x'_3 factor_`x'_4 factor_`x'_5 factor_`x'_6
matrix list r(p)
}


foreach x in imcor imraw {
minap $`x'
fsum $`x', stat(n mean sd)
qui factor $`x', pcf fa(5) 
rotate, promax
*putexcel set "EFA_2020.xlsx", modify sheet(`x')
*putexcel (E2)=matrix(e(r_L))

predict factor_`x'_1 factor_`x'_2 factor_`x'_3 factor_`x'_4 factor_`x'_5
cpcorr $`x' \ factor_`x'_1 factor_`x'_2 factor_`x'_3 factor_`x'_4 factor_`x'_5
matrix list r(p)

*Correlation with big-5 and cronbach
cpcorr cr_OP cr_EX cr_ES cr_CO cr_AG cr_Grit OP EX ES CO AG Grit factor_`x'_1 factor_`x'_2 factor_`x'_3 factor_`x'_4 factor_`x'_5
matrix list r(p)
}


********** Graph rpz
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

* Without
drop if n>=36
foreach x in Raw Corr {
forvalues i=1(1)5{
*Sort
gsort - factor_`x'_`i'
sencode var, gen(var_factor_`x'_`i') gsort(factor_`x'_`i')
replace factor_`x'_`i'=round(factor_`x'_`i', 0.01)
*Graph
twoway ///
(bar factor_`x'_`i' var_factor_`x'_`i', barw(0.6) yline(0, lcolor(gs10) lpattern(solid) lwidth(*0.8))) ///
(scatter factor_`x'_`i' var_factor_`x'_`i', mlabel(factor_`x'_`i') mlabposition(12) mlabsize(*0.3) mlabangle(0) msymbol(i)) ///
(scatter pvalue_`x'_`i' var_factor_`x'_`i', msymbol(o) mcolor(gs1) msize(*0.2)) ///
(line threshold var_factor_`x'_`i', lcolor(gs1) lpattern(solid) lwidth(*0.2)), ///
xlabel(1(1)35,valuelabel labsize(tiny) angle(45) nogrid) xtitle("")  ///
ylabel(,labsize(tiny)) ///
title("Factor `i'", size(small)) ///
legend(order(1 "Correlation with factor" 3 "p-value" 4 ".05 threshold") pos(6) col(3) size(vsmall) off) ///
name(g_`x'_`i', replace)
drop var_factor_`x'_`i'
sort n
}
grc1leg g_`x'_1 g_`x'_2 g_`x'_3 g_`x'_4 g_`x'_5, note("`x' items with NEEMSIS-2 (2020-21) data.", size(tiny)) col(2) name(comb_`x', replace)
graph save "$git\Analysis\Personality\Big-5\factor2020_`x'.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\factor2020_`x'.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\factor2020_`x'.pdf", as(pdf) replace
}
restore
set graph on
*/



**********Correlation + omega
/*
*Factor 1
omega im_expressingthoughts im_liketothink im_talktomanypeople im_activeimagination im_sharefeelings im_newideas im_curious im_inventive

*Factor 2
omega im_completeduties im_appointmentontime im_enthusiastic im_makeplans im_workhard im_workwithother im_organized


*Factor 3
omega im_changemood im_easilydistracted im_putoffduties im_staycalm im_nervous im_rudetoother im_managestress

*Factor 4
omega im_worryalot im_easilyupset im_feeldepressed im_nervous im_shywithpeople im_easilydistracted im_changemood

*Factor 5
omega im_forgiveother im_toleratefaults im_helpfulwithothers im_trustingofother im_talkative im_workwithother im_changemood im_understandotherfeeling im_curious im_repetitivetasks im_interestedbyart im_staycalm im_shywithpeople im_completeduties
*/



*HH size
drop if INDID_left!=.
keep if livinghome==1 | livinghome==2
bysort HHID_panel: gen hhsize=_N

*
sum sum_borrowerservices_3 sum_plantorepay_6 sum_settleloanstrategy_8
sum loanamount_indiv

/*
*Reshape ego
preserve
drop if egoid==0
drop if egoid==3
keep f1_2020 f2_2020 f3_2020 f4_2020 f5_2020 egoid HHID_panel maritalstatus edulevel relationshiptohead sex age readystartjob methodfindjob jobpreference moveoutsideforjob moveoutsideforjobreason aspirationminimumwage dummyaspirationmorehours aspirationminimumwage2 name num_tt raven_tt lit_tt OP CO EX AG ES Grit cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit
rename aspirationminimumwage2 aspirationminimumwageTWO
reshape wide f1_2020 f2_2020 f3_2020 f4_2020 f5_2020 maritalstatus edulevel relationshiptohead sex age readystartjob methodfindjob jobpreference moveoutsideforjob moveoutsideforjobreason aspirationminimumwage  aspirationminimumwageTWO dummyaspirationmorehours  name num_tt raven_tt lit_tt OP CO EX AG ES Grit cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit, i(HHID_panel) j(egoid)
save"$wave3~efa_ego.dta", replace
restore
*/

*Nb children
gen child=0
replace child=1 if age<=14
bysort HHID_panel: egen nbchild=sum(child)

*Sex ratio
gen female=0
gen male=0
replace female=1 if sex==2
replace male=1 if sex==1
bysort HHID_panel: egen nbfemale=sum(female)
bysort HHID_panel: egen nbmale=sum(male)


********** New HH level var: savings, chitfunds, lending, gold, insurance, land purchased, livestockexpenses (livestockspent), equipmentyear 
sort HHID_panel INDID_panel

*Savings
egen savingsamount_temp_HH=rowtotal(savingsamount1 savingsamount2 savingsamount3 savingsamount4)
bysort HHID_panel: egen savingsamount_HH=sum(savingsamount_temp_HH)

*Expenses
bysort HHID_panel: egen educationexpenses_HH=sum(educationexpenses)
egen productexpenses_HH=rowtotal(productexpenses9 productexpenses5 productexpenses4 productexpenses3 productexpenses2 productexpenses14 productexpenses12 productexpenses11 productexpenses1)
bysort HHID_panel: egen businessexpenses_HH=sum(businessexpenses)
gen foodexpenses_HH=foodexpenses*52
gen healthexpenses_HH=healthexpenses
gen ceremoniesexpenses_HH=ceremoniesexpenses
gen deathexpenses_HH=deathexpenses

*Chitfunds
egen chitfundpaymentamount_temp_HH=rowmean(chitfundpaymentamount1 chitfundpaymentamount2 chitfundpaymentamount3)
egen chitfundamount_temp_HH=rowmean(chitfundamount1 chitfundamount2 chitfundamount3)
egen chitfundamounttot_temp_HH=rowtotal(chitfundamount1 chitfundamount2 chitfundamount3)
bysort HHID_panel: egen chitfundpaymentamount_HH=mean(chitfundpaymentamount_temp_HH)
bysort HHID_panel: egen chitfundamount_HH=mean(chitfundamount_temp_HH)
bysort HHID_panel: egen chitfundamounttot_HH=sum(chitfundamounttot_temp_HH)
bysort HHID_panel: egen nbchitfunds_HH=sum(nbchitfunds)

*Lending
bysort HHID_panel: egen amountlent_HH=sum(amoutlent)
bysort HHID_panel: egen interestlending_HH=mean(interestlending)
bysort HHID_panel: egen problemrepayment_HH=sum(problemrepayment)

*Gold
bysort HHID_panel: egen goldquantity_HH=sum(goldquantity)
bysort HHID_panel: egen goldquantitypledge_HH=sum(goldquantitypledge)

*Insurance
bysort HHID_panel: egen nbinsurance_HH=sum(nbinsurance)
egen insuranceamount=rowtotal(insuranceamount1 insuranceamount2 insuranceamount3 insuranceamount4 insuranceamount5 insuranceamount6)
egen insuranceamountm=rowmean(insuranceamount1 insuranceamount2 insuranceamount3 insuranceamount4 insuranceamount5 insuranceamount6)
bysort HHID_panel: egen insuranceamount_HH=mean(insuranceamountm)
bysort HHID_panel: egen insuranceamounttot_HH=sum(insuranceamount)

egen insurancebenefitamount=rowtotal(insurancebenefitamount3 insurancebenefitamount2 insurancebenefitamount1)
egen insurancebenefitamountm=rowmean(insurancebenefitamount3 insurancebenefitamount2 insurancebenefitamount1)

bysort HHID_panel: egen insurancebenefitamount_HH=mean(insurancebenefitamountm)
bysort HHID_panel: egen insurancebenefitamounttot_HH=sum(insurancebenefitamount)

*Land purchased as investment
tab landpurchased
tab landpurchasedacres
tab landpurchasedamount
tab landpurchasedhowbuy

*Equipment
foreach x in tractor bullockcart plowingmach {
gen investequip_`x'=.
}
replace investequip_tractor=equipmentcost_tractor if equipementyear1>="2016"
replace investequip_bullockcart=equipmentcost_bullockcart if equipementyear2>="2016"
replace investequip_plowingmach=equipmentcost_plowingmach if equipementyear4>="2016"

egen investequiptot_HH=rowtotal(investequip_tractor investequip_bullockcart investequip_plowingmach)


* Ratio de dépendance à la dette : 
gen debtor=0
replace debtor=1 if loanamount_indiv>0 & loanamount_indiv!=.
gen nondebtor=0
replace nondebtor=1 if debtor==0 & debtor!=.

gen worker=0
replace worker=1 if annualincome_indiv>0 & annualincome_indiv!=.
gen nonworker=0
replace nonworker=1 if worker==0 & worker!=.

foreach x in debtor nondebtor worker nonworker {
bysort HHID_panel: egen `x'_HH=sum(`x')
}

gen debtorratio=debtor_HH/nondebtor_HH
clonevar debtorratio2=debtorratio
replace debtorratio2=debtor_HH if debtorratio==.

gen workerratio=worker_HH/nonworker_HH
clonevar workerratio2=workerratio
replace workerratio2=worker_HH if workerratio==.

preserve
duplicates drop HHID_panel, force
fre debtorratio debtorratio2
fre workerratio workerratio2
restore


*Only ego
fre egoid
drop if egoid==0
rename amoutlent amountlent

*Services and repayment 
global newvar sum_borrowerservices_1 sum_borrowerservices_2 sum_borrowerservices_3 sum_borrowerservices_4 sum_plantorepay_1 sum_plantorepay_2 sum_plantorepay_3 sum_plantorepay_4 sum_plantorepay_5 sum_plantorepay_6 sum_settleloanstrategy_1 sum_settleloanstrategy_2 sum_settleloanstrategy_3 sum_settleloanstrategy_4 sum_settleloanstrategy_5 sum_settleloanstrategy_6 sum_settleloanstrategy_7 sum_settleloanstrategy_8 sum_settleloanstrategy_9 sum_settleloanstrategy_10

foreach x in $newvar{
clonevar `x'_r=`x'
}

foreach x in $newvar{
replace `x'_r=1 if `x'>=1 & `x'!=.
}

tab1 sum_borrowerservices_1_r sum_borrowerservices_2_r sum_borrowerservices_3_r sum_borrowerservices_4_r sum_plantorepay_1_r sum_plantorepay_2_r sum_plantorepay_3_r sum_plantorepay_4_r sum_plantorepay_5_r sum_plantorepay_6_r sum_settleloanstrategy_1_r sum_settleloanstrategy_2_r sum_settleloanstrategy_3_r sum_settleloanstrategy_4_r sum_settleloanstrategy_5_r sum_settleloanstrategy_6_r sum_settleloanstrategy_7_r sum_settleloanstrategy_8_r sum_settleloanstrategy_9_r sum_settleloanstrategy_10_r


*Macro for rename

global charactindiv maritalstatus edulevel relationshiptohead sex age readystartjob methodfindjob jobpreference moveoutsideforjob moveoutsideforjobreason aspirationminimumwage dummyaspirationmorehours aspirationminimumwage2 name
 
global characthh villageid villageid_new assets ownland house jatis caste dummymarriage hhsize nbchild nbfemale nbmale dummydemonetisation interviewplace address religion dummyeverhadland

global wealthindiv annualincome_indiv totalincome_indiv mainoccupation_hours_indiv mainoccupation_income_indiv mainoccupation_indiv mainoccupationname_indiv nboccupation_indiv

global wealthhh annualincome_HH totalincome_HH mainoccupation_HH nboccupation_HH foodexpenses healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses marriageexpenses businessexpenses

global debtindiv imp1_ds_tot_indiv imp1_is_tot_indiv semiformal_indiv formal_indiv economic_indiv current_indiv humancap_indiv social_indiv house_indiv incomegen_indiv noincomegen_indiv economic_amount_indiv current_amount_indiv humancap_amount_indiv social_amount_indiv house_amount_indiv incomegen_amount_indiv noincomegen_amount_indiv informal_amount_indiv formal_amount_indiv semiformal_amount_indiv loanamount_indiv dummyproblemtorepay_indiv dummyhelptosettleloan_indiv dummyinterest_indiv loans_indiv loanbalance_indiv marriageloanamount_indiv mean_yratepaid_indiv mean_monthlyinterestrate_indiv nbsavingaccounts savingsamount1 savingsamount2 savingsamount3 savingsamount4 dummydebitcard1 dummydebitcard2 dummydebitcard3 dummydebitcard4 datedebitcard1 datedebitcard2 datedebitcard3 datedebitcard4 dummychitfund amountlent interestlending goldquantity goldquantitypledge nbinsurance dummycreditcard1 dummycreditcard2 dummycreditcard3 dummycreditcard4 nbchitfunds chitfundamount1 chitfundamount2 chitfundamount3 marriageloan_indiv sum_borrowerservices_1_r sum_borrowerservices_2_r sum_borrowerservices_3_r sum_borrowerservices_4_r sum_plantorepay_1_r sum_plantorepay_2_r sum_plantorepay_3_r sum_plantorepay_4_r sum_plantorepay_5_r sum_plantorepay_6_r sum_settleloanstrategy_1_r sum_settleloanstrategy_2_r sum_settleloanstrategy_3_r sum_settleloanstrategy_4_r sum_settleloanstrategy_5_r sum_settleloanstrategy_6_r sum_settleloanstrategy_7_r sum_settleloanstrategy_8_r sum_settleloanstrategy_9_r sum_settleloanstrategy_10_r sum_otherlenderservices_1 sum_otherlenderservices_2 sum_otherlenderservices_3 sum_otherlenderservices_4 sum_otherlenderservices_5 sum_debtrelation_shame

global debthh imp1_ds_tot_HH imp1_is_tot_HH informal_HH semiformal_HH formal_HH economic_HH current_HH humancap_HH social_HH house_HH incomegen_HH noincomegen_HH economic_amount_HH current_amount_HH humancap_amount_HH social_amount_HH house_amount_HH incomegen_amount_HH noincomegen_amount_HH informal_amount_HH formal_amount_HH semiformal_amount_HH marriageloanamount_HH loanamount_HH dummyproblemtorepay_HH dummyhelptosettleloan_HH dummyinterest_HH loans_HH loanbalance_HH mean_yratepaid_HH mean_monthlyinterestrate_HH marriageloan_HH debtorratio workerratio debtorratio2 workerratio2

global perso cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit raven_tt num_tt lit_tt factor_imcorwith_1 factor_imcorwith_2 factor_imcorwith_3 factor_imcorwith_4 factor_imcorwith_5 factor_imcorwith_6 factor_imrawwith_1 factor_imrawwith_2 factor_imrawwith_3 factor_imrawwith_4 factor_imrawwith_5 factor_imrawwith_6 factor_imcor_1 factor_imcor_2 factor_imcor_3 factor_imcor_4 factor_imcor_5 factor_imraw_1 factor_imraw_2 factor_imraw_3 factor_imraw_4 factor_imraw_5

global expenses savingsamount_HH educationexpenses_HH productexpenses_HH businessexpenses_HH foodexpenses_HH healthexpenses_HH ceremoniesexpenses_HH deathexpenses_HH chitfundpaymentamount_HH chitfundamount_HH chitfundamounttot_HH nbchitfunds_HH amountlent_HH interestlending_HH problemrepayment_HH goldquantity_HH goldquantitypledge_HH nbinsurance_HH insuranceamount_HH insuranceamounttot_HH insurancebenefitamount_HH insurancebenefitamounttot_HH landpurchased investequiptot_HH 

global all $charactindiv $characthh $wealthindiv $wealthhh $debtindiv $debthh $perso $expenses nbercontactphone networkhelpkinmember

keep $all HHID_panel INDID_panel egoid

*merge m:1 HHID_panel using"$wave3~efa_ego.dta"
*drop _merge

*Rename
foreach x in $all {
rename `x' `x'_2
}

order HHID_panel INDID_panel

preserve
duplicates drop HHID_panel, force
tab caste_2
*Tous les HH ont un égo donc je suis censé en avoir plus car 485 HH en panel avec un peu de chance, 483 sinon minimum !
restore

**********drop 
drop factor_imcorwith_1_2 factor_imcorwith_2_2 factor_imcorwith_3_2 factor_imcorwith_4_2 factor_imcorwith_5_2 factor_imcorwith_6_2 factor_imrawwith_1_2 factor_imrawwith_2_2 factor_imrawwith_3_2 factor_imrawwith_4_2 factor_imrawwith_5_2 factor_imrawwith_6_2 factor_imcor_1_2 factor_imcor_2_2 factor_imcor_3_2 factor_imcor_4_2 factor_imcor_5_2 factor_imraw_1_2 factor_imraw_2_2 factor_imraw_3_2 factor_imraw_4_2 factor_imraw_5_2

save"$wave3~panel", replace
****************************************
* END

















****************************************
* Prepa 2016
****************************************
cls
********** Verif type of job
use"$dropbox/RUME-NEEMSIS/NEEMSIS1/NEEMSIS-occupation_alllong.dta", clear
fre kindofwork
tab joblocation
tab jobdistance




********** 
use"$wave2", clear


*ER test with network
tab nbercontactphone
tab dummycontactleaders
tab1 nbcontact_headbusiness nbcontact_policeman nbcontact_civilserv nbcontact_bankemployee nbcontact_panchayatcommittee nbcontact_peoplecouncil nbcontact_recruiter nbcontact_headunion


********** Imputation for non corrected one
global big5 ///
curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination ///
organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties ///
enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts  ///
workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers ///
managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm ///
tryhard  stickwithgoals   goaftergoal finishwhatbegin finishtasks  keepworking

global big5raw raw_curious raw_interestedbyart raw_repetitivetasks raw_inventive raw_liketothink raw_newideas raw_activeimagination raw_organized raw_makeplans raw_workhard raw_appointmentontime raw_putoffduties raw_easilydistracted raw_completeduties raw_enjoypeople raw_sharefeelings raw_shywithpeople raw_enthusiastic raw_talktomanypeople raw_talkative raw_expressingthoughts raw_workwithother raw_understandotherfeeling raw_trustingofother raw_rudetoother raw_toleratefaults raw_forgiveother raw_helpfulwithothers raw_managestress raw_nervous raw_changemood raw_feeldepressed raw_easilyupset raw_worryalot raw_staycalm raw_tryhard raw_stickwithgoals raw_goaftergoal raw_finishwhatbegin raw_finishtasks raw_keepworking

global big5rawrec raw_rec_curious raw_rec_interestedbyart raw_rec_repetitivetasks raw_rec_inventive raw_rec_liketothink raw_rec_newideas raw_rec_activeimagination raw_rec_organized raw_rec_makeplans raw_rec_workhard raw_rec_appointmentontime raw_rec_putoffduties raw_rec_easilydistracted raw_rec_completeduties raw_rec_enjoypeople raw_rec_sharefeelings raw_rec_shywithpeople raw_rec_enthusiastic raw_rec_talktomanypeople raw_rec_talkative raw_rec_expressingthoughts raw_rec_workwithother raw_rec_understandotherfeeling raw_rec_trustingofother raw_rec_rudetoother raw_rec_toleratefaults raw_rec_forgiveother raw_rec_helpfulwithothers raw_rec_managestress raw_rec_nervous raw_rec_changemood raw_rec_feeldepressed raw_rec_easilyupset raw_rec_worryalot raw_rec_staycalm raw_rec_tryhard raw_rec_stickwithgoals raw_rec_goaftergoal raw_rec_finishwhatbegin raw_rec_finishtasks raw_rec_keepworking

*** Identify the way of ES/NE questions when they are non-corrected for reverse coded & acquiesence bias
*OP
fre raw_curious raw_interestedbyart raw_repetitivetasks raw_inventive raw_liketothink raw_newideas raw_activeimagination

*ES/NE
fre raw_managestress raw_nervous raw_changemood raw_feeldepressed raw_easilyupset raw_worryalot raw_staycalm

global big5cor cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking

foreach x in $big5 {
rename raw_rec_`x' rr_`x'
}

global big5rr rr_curious rr_interestedbyart rr_repetitivetasks rr_inventive rr_liketothink rr_newideas rr_activeimagination rr_organized rr_makeplans rr_workhard rr_appointmentontime rr_putoffduties rr_easilydistracted rr_completeduties rr_enjoypeople rr_sharefeelings rr_shywithpeople rr_enthusiastic rr_talktomanypeople rr_talkative rr_expressingthoughts rr_workwithother rr_understandotherfeeling rr_trustingofother rr_rudetoother rr_toleratefaults rr_forgiveother rr_helpfulwithothers rr_managestress rr_nervous rr_changemood rr_feeldepressed rr_easilyupset rr_worryalot rr_staycalm rr_tryhard rr_stickwithgoals rr_goaftergoal rr_finishwhatbegin rr_finishtasks rr_keepworking

/*
cls
fre rr_managestress rr_nervous rr_changemood rr_feeldepressed rr_easilyupset rr_worryalot rr_staycalm
cls
fre raw_managestress raw_nervous raw_changemood raw_feeldepressed raw_easilyupset raw_worryalot raw_staycalm
cls
fre managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm 
*/
cls
fre rr_curious rr_interestedbyart rr_repetitivetasks rr_inventive rr_liketothink rr_newideas rr_activeimagination
fre raw_curious raw_interestedbyart raw_repetitivetasks raw_inventive raw_liketothink raw_newideas raw_activeimagination
fre curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination

cls
fre rr_curious rr_interestedbyart rr_repetitivetasks rr_inventive rr_liketothink rr_newideas rr_activeimagination rr_organized rr_makeplans rr_workhard rr_appointmentontime rr_putoffduties rr_easilydistracted rr_completeduties rr_enjoypeople rr_sharefeelings rr_shywithpeople rr_enthusiastic rr_talktomanypeople rr_talkative rr_expressingthoughts rr_workwithother rr_understandotherfeeling rr_trustingofother rr_rudetoother rr_toleratefaults rr_forgiveother rr_helpfulwithothers rr_managestress rr_nervous rr_changemood rr_feeldepressed rr_easilyupset rr_worryalot rr_staycalm

*****************************************************************************
*****************************************************************************
*****************************************************************************
*****************************************************************************
*****************************************************************************
*** Recoder ES dans rr pour que tout fonctionne dans le bon sens et que pour ceux de ES ca capte ES en max et non NE comme ca fait normalement.
*** Dans ce que j'avais fait, c'était ES et tout le reste dans l'ordre du questionnaire, donc à l'envers...
*** rr_ et raw_ fonctionne parfaitement en sens inverse, je prends rr car 4 dans le bon sens, je recode juste NE en ES
*** rr_ max = NE donc à recoder pour ES
*** raw max = ES
fre rr_managestress rr_nervous rr_changemood rr_feeldepressed rr_easilyupset rr_worryalot rr_staycalm
foreach x in rr_managestress rr_nervous rr_changemood rr_feeldepressed rr_easilyupset rr_worryalot rr_staycalm {
recode `x' (5=1) (4=2) (3=3) (2=4) (1=5)
}
fre rr_managestress rr_nervous rr_changemood rr_feeldepressed rr_easilyupset rr_worryalot rr_staycalm
label define b5new 1"1 - Almost always" 2"2 - Quite often" 3"3 - Sometimes" 4"4 - Rarely" 5"5 - Almost never"
foreach x in rr_managestress rr_nervous rr_changemood rr_feeldepressed rr_easilyupset rr_worryalot rr_staycalm {
label values `x' b5new
}

fre managestress nervous changemood feeldepressed easilyupset worryalot staycalm 
cls
fre rr_curious rr_interestedbyart rr_repetitivetasks rr_inventive rr_liketothink rr_newideas rr_activeimagination 
fre rr_organized  rr_makeplans rr_workhard rr_appointmentontime rr_putoffduties rr_easilydistracted rr_completeduties 
fre rr_enjoypeople rr_sharefeelings rr_shywithpeople rr_enthusiastic rr_talktomanypeople  rr_talkative rr_expressingthoughts 
fre rr_workwithother rr_understandotherfeeling rr_trustingofother rr_rudetoother rr_toleratefaults rr_forgiveother rr_helpfulwithothers 
fre rr_managestress  rr_nervous  rr_changemood rr_feeldepressed rr_easilyupset rr_worryalot rr_staycalm 

global big5rrok rr_curious rr_interestedbyart rr_repetitivetasks rr_inventive rr_liketothink rr_newideas rr_activeimagination rr_organized rr_makeplans rr_workhard rr_appointmentontime rr_putoffduties rr_easilydistracted rr_completeduties rr_enjoypeople rr_sharefeelings rr_shywithpeople rr_enthusiastic rr_talktomanypeople rr_talkative rr_expressingthoughts rr_workwithother rr_understandotherfeeling rr_trustingofother rr_rudetoother rr_toleratefaults rr_forgiveother rr_helpfulwithothers rr_managestress rr_nervous rr_changemood rr_feeldepressed rr_easilyupset rr_worryalot rr_staycalm rr_tryhard rr_stickwithgoals rr_goaftergoal rr_finishwhatbegin rr_finishtasks rr_keepworking


foreach x in $big5 $big5raw $big5cor $big5rrok{
gen im`x'=`x'
}


forvalues j=1(1)3{
forvalues i=1(1)2{
foreach x in $big5 {
sum im`x' if sex==`i' & caste==`j' & egoid!=0 & egoid!=.
replace im`x'=r(mean) if `x'==. & sex==`i' & caste==`j' & egoid!=0 & egoid!=.
}
}
}

*Tester le sens 

global imcorwith im_cr_curious im_cr_interestedbyart im_cr_repetitivetasks im_cr_inventive im_cr_liketothink im_cr_newideas im_cr_activeimagination im_cr_organized im_cr_makeplans im_cr_workhard im_cr_appointmentontime im_cr_putoffduties im_cr_easilydistracted im_cr_completeduties im_cr_enjoypeople im_cr_sharefeelings im_cr_shywithpeople im_cr_enthusiastic im_cr_talktomanypeople im_cr_talkative im_cr_expressingthoughts im_cr_workwithother im_cr_understandotherfeeling im_cr_trustingofother im_cr_rudetoother im_cr_toleratefaults im_cr_forgiveother im_cr_helpfulwithothers im_cr_managestress im_cr_nervous im_cr_changemood im_cr_feeldepressed im_cr_easilyupset im_cr_worryalot im_cr_staycalm im_cr_tryhard im_cr_stickwithgoals im_cr_goaftergoal im_cr_finishwhatbegin im_cr_finishtasks im_cr_keepworking

global imrawwith im_raw_curious im_raw_interestedbyart im_raw_repetitivetasks im_raw_inventive im_raw_liketothink im_raw_newideas im_raw_activeimagination im_raw_organized im_raw_makeplans im_raw_workhard im_raw_appointmentontime im_raw_putoffduties im_raw_easilydistracted im_raw_completeduties im_raw_enjoypeople im_raw_sharefeelings im_raw_shywithpeople im_raw_enthusiastic im_raw_talktomanypeople im_raw_talkative im_raw_expressingthoughts im_raw_workwithother im_raw_understandotherfeeling im_raw_trustingofother im_raw_rudetoother im_raw_toleratefaults im_raw_forgiveother im_raw_helpfulwithothers im_raw_managestress im_raw_nervous im_raw_changemood im_raw_feeldepressed im_raw_easilyupset im_raw_worryalot im_raw_staycalm  im_raw_tryhard im_raw_stickwithgoals im_raw_goaftergoal im_raw_finishwhatbegin im_raw_finishtasks im_raw_keepworking

global imcor im_cr_curious im_cr_interestedbyart im_cr_repetitivetasks im_cr_inventive im_cr_liketothink im_cr_newideas im_cr_activeimagination im_cr_organized im_cr_makeplans im_cr_workhard im_cr_appointmentontime im_cr_putoffduties im_cr_easilydistracted im_cr_completeduties im_cr_enjoypeople im_cr_sharefeelings im_cr_shywithpeople im_cr_enthusiastic im_cr_talktomanypeople im_cr_talkative im_cr_expressingthoughts im_cr_workwithother im_cr_understandotherfeeling im_cr_trustingofother im_cr_rudetoother im_cr_toleratefaults im_cr_forgiveother im_cr_helpfulwithothers im_cr_managestress im_cr_nervous im_cr_changemood im_cr_feeldepressed im_cr_easilyupset im_cr_worryalot im_cr_staycalm

global imraw im_raw_curious im_raw_interestedbyart im_raw_repetitivetasks im_raw_inventive im_raw_liketothink im_raw_newideas im_raw_activeimagination im_raw_organized im_raw_makeplans im_raw_workhard im_raw_appointmentontime im_raw_putoffduties im_raw_easilydistracted im_raw_completeduties im_raw_enjoypeople im_raw_sharefeelings im_raw_shywithpeople im_raw_enthusiastic im_raw_talktomanypeople im_raw_talkative im_raw_expressingthoughts im_raw_workwithother im_raw_understandotherfeeling im_raw_trustingofother im_raw_rudetoother im_raw_toleratefaults im_raw_forgiveother im_raw_helpfulwithothers im_raw_managestress im_raw_nervous im_raw_changemood im_raw_feeldepressed im_raw_easilyupset im_raw_worryalot im_raw_staycalm 

global imraw2 im_rr_curious im_rr_interestedbyart im_rr_repetitivetasks im_rr_inventive im_rr_liketothink im_rr_newideas im_rr_activeimagination im_rr_organized im_rr_makeplans im_rr_workhard im_rr_appointmentontime im_rr_putoffduties im_rr_easilydistracted im_rr_completeduties im_rr_enjoypeople im_rr_sharefeelings im_rr_shywithpeople im_rr_enthusiastic im_rr_talktomanypeople im_rr_talkative im_rr_expressingthoughts im_rr_workwithother im_rr_understandotherfeeling im_rr_trustingofother im_rr_rudetoother im_rr_toleratefaults im_rr_forgiveother im_rr_helpfulwithothers im_rr_managestress im_rr_nervous im_rr_changemood im_rr_feeldepressed im_rr_easilyupset im_rr_worryalot im_rr_staycalm

*fre $big5rrok
cls
foreach x in curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts  workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm {
label var raw_`x' "raw_`x'"
label var rr_`x' "rr_`x'"
tab raw_`x' rr_`x'
}

fre imrr_curious imrr_interestedbyart imrr_repetitivetasks imrr_inventive imrr_liketothink imrr_newideas imrr_activeimagination rr_curious rr_interestedbyart rr_repetitivetasks rr_inventive rr_liketothink rr_newideas rr_activeimagination 

cls
foreach x in imraw2 { //imcor imraw {
qui factor $`x', pcf fa(5) 
*loadingplot
*scoreplot
*screeplot
rotate, promax
*putexcel set "EFA_2016.xlsx", modify sheet(`x')
*putexcel (E2)=matrix(e(r_L))


predict factor_`x'_1 factor_`x'_2 factor_`x'_3 factor_`x'_4 factor_`x'_5
cpcorr $`x' \ factor_`x'_1 factor_`x'_2 factor_`x'_3 factor_`x'_4 factor_`x'_5
/*
matrix list r(p)

*Correlation with big-5 and cronbach
cpcorr cr_OP cr_EX cr_ES cr_CO cr_AG cr_Grit OP EX ES CO AG Grit factor_`x'_1 factor_`x'_2 factor_`x'_3 factor_`x'_4 factor_`x'_5
matrix list r(p)
*/
}

forvalues i=1(1)5 {
rename factor_imraw2_`i' factor_imraw_`i'
}

pwcorr cr_OP cr_EX cr_ES cr_CO cr_AG cr_Grit OP EX ES CO AG Grit factor_imraw_1 factor_imraw_2 factor_imraw_3 factor_imraw_4 factor_imraw_5, star(.01)





********** Graph rpz

preserve
import delimited "factor2016.csv", delimiter(";") clear
gen n=_n
drop if n==42
order n var
gen threshold=0.05
*Clean
/*
forvalues i=1(1)6{
rename factor_imcrwith_`i' factor_Corrwith_`i'
rename pvalue_imcrwith_`i' pvalue_Corrwith_`i'
rename factor_imrawwith_`i' factor_Rawwith_`i'
rename pvalue_imrawwith_`i' pvalue_Rawwith_`i'
}
*/

forvalues i=1(1)5{
*rename factor_imcr_`i' factor_Corr_`i'
*rename pvalue_imcr_`i' pvalue_Corr_`i'
rename factor_imraw_`i' factor_Raw_`i'
rename pvalue_imraw_`i' pvalue_Raw_`i'
}
gen big5=""
replace big5="max -> OP" if n>=1 & n<=7
replace big5="max -> CO" if n>=8 & n<=14
replace big5="max -> EX" if n>=15 & n<=21
replace big5="max -> AG" if n>=22 & n<=28
replace big5="max -> ES" if n>=29 & n<=35
replace big5="max -> GR" if n>=36 & n<=41
order n var big5


*Identitfy reverse questions
gen reverse=0
foreach x in rudetoother putoffduties easilydistracted shywithpeople repetitivetasks staycalm managestress  {
replace reverse=1 if var=="`x'"
}
/*
Etant donné que j'ai changé le sens, sur les 7 questions ESNE, 5 captent au max ES (car j'ai changé le sens) et les deux autres (staycalm et managestress) captent NE au max
*/

foreach x in curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts  workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm {
replace var="`x' (r)" if var=="`x'" & reverse==1
}

*Interpretation
*F1
gsort - factor_Raw_1
list n var big5 reverse factor_Raw_1, clean noobs  // OPEX
*F2
gsort - factor_Raw_2
list n var big5 reverse factor_Raw_2, clean noobs  // 
*F3
gsort - factor_Raw_3
list n var big5 reverse factor_Raw_3, clean noobs
*F4
gsort - factor_Raw_4
list n var big5 reverse factor_Raw_4, clean noobs
*F5
gsort - factor_Raw_5
list n var big5 reverse factor_Raw_5, clean noobs

save"factor2016.dta", replace

use"factor2016.dta", clear

set graph off
* With
/*
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
name(g_`x'_`i', replace) aspectratio(0.5)
drop var_factor_`x'with_`i'
sort n
}
}
set graph on
grc1leg g_Raw_1 g_Raw_2 g_Raw_3, note("Raw items with NEEMSIS-1 (2016-17) data.", size(tiny)) col(1) name(comb_`x'_with, replace) 

g_Raw_4 g_Raw_5 g_Raw_6, note("Raw items with NEEMSIS-1 (2016-17) data.", size(tiny)) col(1) name(comb_`x'_with, replace)
graph save "$git\Analysis\Personality\Big-5\factor2016_`x'_with.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\factor2016_`x'_with.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\factor2016_`x'_with.pdf", as(pdf) replace
*/
* Without
set graph off
drop if n>=36
foreach x in Raw { // Corr {
forvalues i=1(1)5{
*Sort
gsort - factor_`x'_`i'
sencode var, gen(var_factor_`x'_`i') gsort(factor_`x'_`i')
replace factor_`x'_`i'=round(factor_`x'_`i', 0.01)
*Graph
twoway ///
(connected var_factor_`x'_`i' factor_`x'_`i', msymbol(o) msize(*0.2) lwidth(*0.2)) ///
(scatter var_factor_`x'_`i' factor_`x'_`i', mlabel(factor_`x'_`i') mlabposition(3) mlabsize(*0.5) mlabangle(0) msymbol(i) xline(0.05, lpattern(solid) lcolor(gs12) lwidth(*0.5))) ///
(scatter var_factor_`x'_`i' pvalue_`x'_`i', msymbol(X) mcolor(gs1) msize(*.5) xline(0, lpattern(solid) lcolor(gs1) lwidth(*0.5))) ///
, ylabel(1(1)35, valuelabel labsize(tiny) angle(0)) ytitle("")  ///
xlabel(, labsize(tiny) nogrid) xmtick() ///
title("Factor `i'", size(small)) ///
legend(order(1 "Correlation with factor" 3 "p-value" 4 ".05 threshold") pos(6) col(3) size(vsmall) off) ///
name(g_`x'_`i', replace)  // aspectratio(10)
drop var_factor_`x'_`i'
}
set graph on
grc1leg g_Raw_1 g_Raw_2 g_Raw_3 g_Raw_4 g_Raw_5, note("Raw items with NEEMSIS-1 (2016-17) data." "items (r) are reverse coded according to Big-5 taxonomy.", size(tiny)) col(3) name(comb_`x'_with, replace) 
}
graph save "$git\Analysis\Personality\Big-5\factor2016_2.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\factor2016_2.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\factor2016_2.pdf", as(pdf) replace


restore
set graph on
*/


**********Correlation + omega

*Factor 1 - 0.91
omega im_rr_liketothink im_rr_expressingthoughts im_rr_activeimagination im_rr_sharefeelings im_rr_newideas im_rr_curious im_rr_inventive im_rr_talktomanypeople     

*Factor 2 - 0.88
omega im_rr_appointmentontime im_rr_enthusiastic im_rr_makeplans im_rr_completeduties im_rr_workhard im_rr_organized im_rr_repetitivetasks 

*Factor 3 - 0.69
omega im_rr_easilydistracted im_rr_putoffduties im_rr_talkative im_rr_helpfulwithothers

*Factor 4 - 0.78
omega im_rr_worryalot im_rr_easilyupset im_rr_feeldepressed im_rr_nervous 
*im_rr_staycalm

*Factor 5 - 0.62
omega im_rr_toleratefaults im_rr_forgiveother im_rr_repetitivetasks im_rr_trustingofother im_rr_helpfulwithothers
*im_rr_expressingthoughts


********** Other variables
*Y
sum sum_borrowerservices_3 sum_plantorepay_6 sum_settleloanstrategy_8
sum loanamount_indiv

*HH size
keep if livinghome==1 | livinghome==2
bysort HHID_panel: gen hhsize=_N

ta hhsize

*Nb children
gen child=0
replace child=1 if age<=14
bysort HHID_panel: egen nbchild=sum(child)

*Sex ratio
gen female=0
gen male=0
replace female=1 if sex==2
replace male=1 if sex==1
bysort HHID_panel: egen nbfemale=sum(female)
bysort HHID_panel: egen nbmale=sum(male)

*Savings
egen savingsamount_temp_HH=rowtotal(savingsamount1 savingsamount2 savingsamount3 savingsamount4)
bysort HHID_panel: egen savingsamount_HH=sum(savingsamount_temp_HH)

*Expenses
bysort HHID_panel: egen educationexpenses_HH=sum(educationexpenses)
egen productexpenses_HH=rowtotal(productexpenses_paddy productexpenses_ragi productexpenses_millets productexpenses_tapioca productexpenses_cotton productexpenses_sugarca productexpenses_savukku productexpenses_guava productexpenses_groundnut)
bysort HHID_panel: egen businessexpenses_HH=sum(businessexpenses)
gen foodexpenses_HH=foodexpenses*52
gen healthexpenses_HH=healthexpenses
gen ceremoniesexpenses_HH=ceremoniesexpenses
gen deathexpenses_HH=deathexpenses
egen livestockexpenses_HH=rowtotal(livestockspent_cow livestockspent_goat livestockspent_chicken livestockspent_bullock)

*Chitfunds
egen chitfundpaymentamount_temp_HH=rowmean(chitfundpaymentamount1 chitfundpaymentamount2)
egen chitfundamount_temp_HH=rowmean(chitfundamount1 chitfundamount2)
egen chitfundamounttot_temp_HH=rowtotal(chitfundamount1 chitfundamount2)
bysort HHID_panel: egen chitfundpaymentamount_HH=mean(chitfundpaymentamount_temp_HH)
bysort HHID_panel: egen chitfundamount_HH=mean(chitfundamount_temp_HH)
bysort HHID_panel: egen chitfundamounttot_HH=sum(chitfundamounttot_temp_HH)
bysort HHID_panel: egen nbchitfunds_HH=sum(nbchitfunds)

*Lending
bysort HHID_panel: egen amountlent_HH=sum(amountlent)
bysort HHID_panel: egen interestlending_HH=mean(interestlending)
bysort HHID_panel: egen problemrepayment_HH=sum(problemrepayment)

*Gold
bysort HHID_panel: egen goldquantity_HH=sum(goldquantity)
bysort HHID_panel: egen goldquantitypledge_HH=sum(goldquantitypledge)

*Insurance
bysort HHID_panel: egen nbinsurance_HH=sum(nbinsurance)
egen insuranceamount=rowtotal(insuranceamount1 insuranceamount2)
egen insuranceamountm=rowmean(insuranceamount1 insuranceamount2)
bysort HHID_panel: egen insuranceamount_HH=mean(insuranceamountm)
bysort HHID_panel: egen insuranceamounttot_HH=sum(insuranceamount)
bysort HHID_panel: egen insurancebenefitamount_HH=mean(insurancebenefitamount)
bysort HHID_panel: egen insurancebenefitamounttot_HH=sum(insurancebenefitamount)

*Land purchased as investment
tab landpurchased
tab landpurchasedacres
tab landpurchasedamount
tab landpurchasedhowbuy

*Equipment
foreach x in tractor bullockcart ploughmach {
gen investequip_`x'=.
}
foreach x in tractor bullockcart ploughmach {
replace investequip_`x'=equiowncost_`x' if equiownyear_`x'>=2010
}
egen investequiptot_HH=rowtotal(investequip_tractor investequip_bullockcart investequip_ploughmach)

* Ratio de dépendance à la dette : 
gen debtor=0
replace debtor=1 if loanamount_indiv>0 & loanamount_indiv!=.
gen nondebtor=0
replace nondebtor=1 if debtor==0 & debtor!=.

gen worker=0
replace worker=1 if annualincome_indiv>0 & annualincome_indiv!=.
gen nonworker=0
replace nonworker=1 if worker==0 & worker!=.

foreach x in debtor nondebtor worker nonworker {
bysort HHID_panel: egen `x'_HH=sum(`x')
}

gen debtorratio=debtor_HH/nondebtor_HH
clonevar debtorratio2=debtorratio
replace debtorratio2=debtor_HH if debtorratio==.

gen workerratio=worker_HH/nonworker_HH
clonevar workerratio2=workerratio
replace workerratio2=worker_HH if workerratio==.

preserve
duplicates drop HHID_panel, force
fre debtorratio debtorratio2
fre workerratio workerratio2
restore



********** Keep my sample
fre egoid
drop if egoid==0

*Services and repayment 
global newvar sum_borrowerservices_1 sum_borrowerservices_2 sum_borrowerservices_3 sum_borrowerservices_4 sum_plantorepay_1 sum_plantorepay_2 sum_plantorepay_3 sum_plantorepay_4 sum_plantorepay_5 sum_plantorepay_6 sum_settleloanstrategy_1 sum_settleloanstrategy_2 sum_settleloanstrategy_3 sum_settleloanstrategy_4 sum_settleloanstrategy_5 sum_settleloanstrategy_6 sum_settleloanstrategy_7 sum_settleloanstrategy_8 sum_settleloanstrategy_9 sum_settleloanstrategy_10

foreach x in $newvar{
clonevar `x'_r=`x'
}

foreach x in $newvar{
replace `x'_r=1 if `x'>=1 & `x'!=.
}

*Macro for rename

global charactindiv maritalstatus edulevel relationshiptohead sex age readystartjob methodfindjob jobpreference moveoutsideforjob moveoutsideforjobreason aspirationminimumwage dummyaspirationmorehours aspirationminimumwage2 name
 
global characthh villageid villageid_new assets ownland house jatis caste dummymarriage hhsize nbchild nbfemale nbmale dummydemonetisation interviewplace address religion dummyeverhadland

global wealthindiv annualincome_indiv totalincome_indiv mainoccupation_hours_indiv mainoccupation_income_indiv mainoccupation_indiv mainoccupationname_indiv nboccupation_indiv

global wealthhh annualincome_HH totalincome_HH mainoccupation_HH nboccupation_HH foodexpenses healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses marriageexpenses businessexpenses

global debtindiv imp1_ds_tot_indiv imp1_is_tot_indiv semiformal_indiv formal_indiv economic_indiv current_indiv humancap_indiv social_indiv house_indiv incomegen_indiv noincomegen_indiv economic_amount_indiv current_amount_indiv humancap_amount_indiv social_amount_indiv house_amount_indiv incomegen_amount_indiv noincomegen_amount_indiv informal_amount_indiv formal_amount_indiv semiformal_amount_indiv loanamount_indiv loanamount_wm_indiv dummyproblemtorepay_indiv dummyhelptosettleloan_indiv dummyinterest_indiv loans_indiv loanbalance_indiv marriageloanamount_indiv mean_yratepaid_indiv mean_monthlyinterestrate_indiv nbsavingaccounts savingsamount1 savingsamount2 savingsamount3 savingsamount4 dummydebitcard1 dummydebitcard2 dummydebitcard3 dummydebitcard4 datedebitcard1 datedebitcard2 datedebitcard3 datedebitcard4 dummychitfund amountlent interestlending goldquantity goldquantitypledge nbinsurance dummycreditcard1 dummycreditcard2 dummycreditcard3 dummycreditcard4 nbchitfunds chitfundamount1 chitfundamount2 marriageloan_indiv sum_borrowerservices_1_r sum_borrowerservices_2_r sum_borrowerservices_3_r sum_borrowerservices_4_r sum_plantorepay_1_r sum_plantorepay_2_r sum_plantorepay_3_r sum_plantorepay_4_r sum_plantorepay_5_r sum_plantorepay_6_r sum_settleloanstrategy_1_r sum_settleloanstrategy_2_r sum_settleloanstrategy_3_r sum_settleloanstrategy_4_r sum_settleloanstrategy_5_r sum_settleloanstrategy_6_r sum_settleloanstrategy_7_r sum_settleloanstrategy_8_r sum_settleloanstrategy_9_r sum_settleloanstrategy_10_r sum_otherlenderservices_1 sum_otherlenderservices_2 sum_otherlenderservices_3 sum_otherlenderservices_4 sum_otherlenderservices_5

global debthh imp1_ds_tot_HH imp1_is_tot_HH informal_HH semiformal_HH formal_HH economic_HH current_HH humancap_HH social_HH house_HH incomegen_HH noincomegen_HH economic_amount_HH current_amount_HH humancap_amount_HH social_amount_HH house_amount_HH incomegen_amount_HH noincomegen_amount_HH informal_amount_HH formal_amount_HH semiformal_amount_HH marriageloanamount_HH loanamount_HH loanamount_wm_HH dummyproblemtorepay_HH dummyhelptosettleloan_HH dummyinterest_HH loans_HH loanbalance_HH mean_yratepaid_HH mean_monthlyinterestrate_HH marriageloan_HH debtorratio workerratio debtorratio2 workerratio2

*global perso factor_imcor_1 factor_imcor_2 factor_imcor_3 factor_imcor_4 factor_imcor_5 factor_imcorwith_1 factor_imcorwith_2 factor_imcorwith_3 factor_imcorwith_4 factor_imcorwith_5 factor_imcorwith_6 factor_imraw_1 factor_imraw_2 factor_imraw_3 factor_imraw_4 factor_imraw_5 factor_imrawwith_1 factor_imrawwith_2 factor_imrawwith_3 factor_imrawwith_4 factor_imrawwith_5 factor_imrawwith_6 cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit raven_tt num_tt lit_tt
global perso factor_imraw_1 factor_imraw_2 factor_imraw_3 factor_imraw_4 factor_imraw_5 cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit raven_tt num_tt lit_tt


global expenses savingsamount_HH educationexpenses_HH productexpenses_HH businessexpenses_HH foodexpenses_HH healthexpenses_HH ceremoniesexpenses_HH deathexpenses_HH livestockexpenses_HH chitfundpaymentamount_HH chitfundamount_HH chitfundamounttot_HH nbchitfunds_HH amountlent_HH interestlending_HH problemrepayment_HH goldquantity_HH goldquantitypledge_HH nbinsurance_HH insuranceamount_HH insuranceamounttot_HH insurancebenefitamount_HH insurancebenefitamounttot_HH landpurchased investequiptot_HH 

global network nbercontactphone dummycontactleaders nbcontact_headbusiness nbcontact_policeman nbcontact_civilserv nbcontact_bankemployee nbcontact_panchayatcommittee nbcontact_peoplecouncil nbcontact_recruiter nbcontact_headunion nberpersonfamilyevent associationlist networkhelpkinmember demotrustbank_ego trustneighborhood trustemployees networkpeoplehelping raw_trustingofother mainoccupation_distance_indiv sum_ext_HH

global all $charactindiv $characthh $wealthindiv $wealthhh $debtindiv $debthh $perso $expenses $network

keep $all HHID_panel INDID_panel egoid

*merge m:1 HHID_panel using"$wave2~efa_ego.dta"
*drop _merge

*Rename
foreach x in $all {
rename `x' `x'_1
}

order HHID_panel INDID_panel dummyeverhadland_1 ownland_1

preserve
duplicates drop HHID_panel, force
tab caste_1
*2 HH sans égos donc 490 là
restore


save"$wave2~panel", replace
****************************************
* END

















****************************************
* Formation
****************************************

**********
use"$wave2~panel", clear
rename egoid egoid_1
tab egoid

preserve
duplicates drop HHID_panel, force
tab caste_1
restore
*490

merge 1:1 HHID_panel INDID_panel using "$wave3~panel"
rename egoid egoid_2
tab egoid_1 egoid_2, m

order HHID_panel INDID_panel name_1 name_2 _merge
sort HHID_panel INDID_panel

*Verif le merging avec les noms car il y en a peu qui ont effectivement merge
preserve
*Garder que ceux pour qui il y a des gens que là en 2016 et que là en 2020
gen ok=1 if _merge==1
gen ok2=1 if _merge==2
bysort HHID_panel: egen sum_ok=sum(ok)
bysort HHID_panel: egen sum_ok2=sum(ok2)
replace sum_ok=1 if sum_ok>1
replace sum_ok2=1 if sum_ok2>1
gen todrop=sum_ok+sum_ok2
drop ok ok2 sum_ok sum_ok2
keep if todrop>1
*Virer ceux qui ont au moins 1 mb qui colle
gen ok=1 if name_1!="" & name_2!=""
bysort HHID_panel: egen sum_ok=sum(ok)
*br
restore

/*
**********
use"panel_indiv_2010_2016_2020_wide", replace
/*
Sur la base panel indiv vérifier les dix HH concernés: ceux où les égos ont changés
GOV13-19-20-28-33
MANAM16-9
ORA25
SEM37-50
*/
preserve
gen tokeep=0
replace tokeep=1 if HHID_panel=="GOV33"
replace tokeep=1 if HHID_panel=="GOV28"
replace tokeep=1 if HHID_panel=="GOV20"
replace tokeep=1 if HHID_panel=="GOV19"
replace tokeep=1 if HHID_panel=="GOV13"
replace tokeep=1 if HHID_panel=="MANAM16"
replace tokeep=1 if HHID_panel=="MANAM9"
replace tokeep=1 if HHID_panel=="ORA25"
replace tokeep=1 if HHID_panel=="SEM37"
replace tokeep=1 if HHID_panel=="SEM50"

keep if tokeep==1
sort HHID_panel INDID_panel
order HHID_panel INDID_panel INDID2016 INDID2020 name2016 name2020 egoid2016 egoid2020

/*
Les egos ne collent pas entre les deux dates.
Exprés ? ou pas ?
Vérifier dans les bases HH2016 & HH2020

Ce sont des gens qui sont parti entre 2016 et 2020.
Peut-être faire un petit tableau pour expliquer
*/
restore

merge 1:1 HHID_panel INDID_panel using "$wave3~efa", keepusing(INDID_left livinghome)
gen pan=1 if name2016!="" & name2020!=""
keep if pan==1
preserve
keep if INDID_left!=.
tab egoid2016
restore
drop if INDID_left!=.
tab egoid2016  // 454+387=841 sauf que j'en ai 835 moi
tab livinghome
drop if livinghome==3 
tab egoid2016  // 1 qui est leftpermanently donc 601
drop if livinghome==4
tab egoid2016
drop if egoid2016==0
order HHID_panel INDID_panel INDID2016 INDID2020 name2016 name2020 egoid2016 egoid2020


preserve
*Maybe diff in ego nb?
gen test=0
replace test=1 if egoid2016==egoid2020
drop if test==1
restore

preserve
keep HHID_panel INDID_panel
gen explication=1
save"temp_explication", replace
restore
**********
*/

/*
use"$wave2~panel", clear
rename egoid egoid_1
tab egoid

preserve
use"$wave2~efa", clear
duplicates drop HHID_panel, force
tab caste_1
restore
*490

*Qui sont les deux HH?
preserve
use"C:\Users\Arnaud\Dropbox\RUME-NEEMSIS\NEEMSIS1\NEEMSIS1-HH_v7", clear
bysort HHID_panel: egen sum_ego=sum(egoid)
tab sum_ego
keep if sum_ego==0
tab HHID_panel
*MANAM18 & MANAM6
restore

merge 1:1 HHID_panel INDID_panel using "$wave3~panel"
keep if _merge==3
drop _merge
merge 1:1 HHID_panel INDID_panel using "temp_explication"
list HHID_panel INDID_panel if _merge==2, clean noobs
/*
  HHID_panel      INDID_panel  
        GOV3      Ind_3    --> Muthaiyyan d'après NEEMSIS1
								C'est égo 1 en 2016
								Pas égo en 2020
      MANAM9      Ind_2    --> Cauvery@gowri
								C'est égo 1 en 2016
								Pas égo en 2020
       ORA12      Ind_3    --> Veeran S/o Mannu
   								C'est égo 1 en 2016
								Pas égo en 2020
       ORA18      Ind_8    --> Chithra
								C'est égo 2 en 2016
								Pas égo en 2020
       ORA41      Ind_4    --> Annamalai
								C'est égo 2 en 2016
								Pas égo en 2020
*/
*/

keep if _merge==3
drop _merge

********** Missings for lit_tt
mdesc lit_tt_1 lit_tt_2
list HHID_panel INDID_panel if lit_tt_2==., clean noobs




********** Cleaning
rename dummydemonetisation_1 dummydemonetisation
rename religion_1 religion
drop religion_2
destring ownland_2, replace
destring house_2, replace
rename villageid_1 villageid
rename villageid_new_1 villageid_new
egen HHINDID=concat(HHID_panel INDID_panel), p(/)
encode HHINDID, gen(panelvar)
encode HHID_panel, gen(HHFE)
encode villageid_new, gen(villagenewFE)
drop villageid_2 villageid_new_2
rename caste_1 caste
rename jatis_1 jatis
drop caste_2 jatis_2


*foreach x in factor_imcor_1 factor_imcor_2 factor_imcor_3 factor_imcor_4 factor_imcor_5 factor_imcorwith_1 factor_imcorwith_2 factor_imcorwith_3 factor_imcorwith_4 factor_imcorwith_5 factor_imcorwith_6 factor_imraw_1 factor_imraw_2 factor_imraw_3 factor_imraw_4 factor_imraw_5 factor_imrawwith_1 factor_imrawwith_2 factor_imrawwith_3 factor_imrawwith_4 factor_imrawwith_5 factor_imrawwith_6 cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit raven_tt num_tt lit_tt{
foreach x in factor_imraw_1 factor_imraw_2 factor_imraw_3 factor_imraw_4 factor_imraw_5 cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit raven_tt num_tt lit_tt{
clonevar base_`x'=`x'_1
}


*global indivcontrol age agesq dummyhead cat_mainoccupation_indiv_1 cat_mainoccupation_indiv_2 cat_mainoccupation_indiv_3 cat_mainoccupation_indiv_4 cat_mainoccupation_indiv_5 dummyedulevel maritalstatus2 dummymultipleoccupation_indiv
*global hhcontrol4 assets1000 sexratiocat_1 sexratiocat_2 sexratiocat_3 hhsize shock incomeHH1000


********** Déflater
global amount aspirationminimumwage2_2 aspirationminimumwage_2 businessexpenses_2 amountlent_2 chitfundamount1_2 chitfundamount2_2 chitfundamount3_2 savingsamount1_2 savingsamount2_2 savingsamount3_2 savingsamount4_2 marriageexpenses_2 foodexpenses_2 healthexpenses_2  ceremoniesexpenses_2 ceremoniesrelativesexpenses_2 deathexpenses_2 mainoccupation_income_indiv_2 annualincome_indiv_2 annualincome_HH_2 assets_2 totalincome_indiv_2 totalincome_HH_2 imp1_ds_tot_indiv_2 imp1_is_tot_indiv_2 economic_amount_indiv_2 current_amount_indiv_2 humancap_amount_indiv_2 social_amount_indiv_2 house_amount_indiv_2 incomegen_amount_indiv_2 noincomegen_amount_indiv_2 informal_amount_indiv_2 formal_amount_indiv_2 semiformal_amount_indiv_2 marriageloanamount_indiv_2 loanamount_indiv_2 loanbalance_indiv_2 imp1_ds_tot_HH_2 imp1_is_tot_HH_2 economic_amount_HH_2 current_amount_HH_2 humancap_amount_HH_2 social_amount_HH_2 house_amount_HH_2 incomegen_amount_HH_2 noincomegen_amount_HH_2 informal_amount_HH_2 formal_amount_HH_2 semiformal_amount_HH_2 marriageloanamount_HH_2 loanamount_HH_2 loanbalance_HH_2

foreach x in $amount {
replace `x'=`x'*(1/(180/155))
}




********** Indebt
recode loanamount_indiv_1 loanamount_HH_1 loanamount_indiv_2 loanamount_HH_2 (.=0)
gen indebt_indiv_1=0
replace indebt_indiv_1=1 if loanamount_indiv_1>0
gen indebt_indiv_2=0
replace indebt_indiv_2=1 if loanamount_indiv_2>0
gen indebt_HH_1=0
replace indebt_HH_1=1 if loanamount_HH_1>0
gen indebt_HH_2=0
replace indebt_HH_2=1 if loanamount_HH_2>0
recode loanamount_indiv_1 loanamount_HH_1 loanamount_indiv_2 loanamount_HH_2 (0=.)

gen reallyindebt=0 if indebt_indiv_1==0 & indebt_indiv_2==0
replace reallyindebt=1 if indebt_indiv_1==1 & indebt_indiv_2==0
replace reallyindebt=2 if indebt_indiv_1==0 & indebt_indiv_2==1
replace reallyindebt=3 if indebt_indiv_1==1 & indebt_indiv_2==1
label define reallyindebt 0"Never in debt" 1"Out of debt" 2"Becomes in debt" 3"Always in debt"
label values reallyindebt reallyindebt
rename reallyindebt debtpath


********** Total income for indiv (zero issue) & for HH
*2016
tab totalincome_indiv_1 if totalincome_indiv_1!=0
replace totalincome_indiv_1=1000 if totalincome_indiv_1<1000
tab totalincome_indiv_1
*2020
tab totalincome_indiv_2 if totalincome_indiv_2!=0
replace totalincome_indiv_2=1000 if totalincome_indiv_2<1000
tab totalincome_indiv_2

*2016 
tab totalincome_HH_1
*2020
tab totalincome_HH_2
replace totalincome_HH_2=2000 if totalincome_HH_2<2000




********** Recode everything
forvalues i=1(1)2{
recode imp1_ds_tot_indiv_`i' imp1_is_tot_indiv_`i' loanamount_indiv_`i' formal_amount_indiv_`i' informal_amount_indiv_`i' semiformal_amount_indiv_`i' incomegen_indiv_`i' noincomegen_indiv_`i' loans_indiv_`i' (.=0)

recode imp1_ds_tot_HH_`i' imp1_is_tot_HH_`i' loanamount_HH_`i' formal_amount_HH_`i' informal_amount_HH_`i' semiformal_amount_HH_`i' incomegen_HH_`i' noincomegen_HH_`i' loans_HH_`i' (.=0)

recode nbsavingaccounts_`i' nbinsurance_`i' nbchitfunds_`i' (.=0)
}

tab formal_amount_indiv_1
tab loanamount_indiv_1

********** Ratio construction
forvalues i=1(1)2{
gen DSR_indiv_`i'=(imp1_ds_tot_indiv_`i'/totalincome_indiv_`i')*100
gen DSR_HH_`i'=(imp1_ds_tot_HH_`i'/totalincome_HH_`i')*100

gen ISR_indiv_`i'=(imp1_is_tot_indiv_`i'/totalincome_indiv_`i')*100
gen ISR_HH_`i'=(imp1_is_tot_HH_`i'/totalincome_HH_`i')*100

gen DAR_indiv_`i'=(loanamount_indiv_`i'/assets_`i')*100
gen DAR_HH_`i'=(loanamount_HH_`i'/assets_`i')*100

gen FormR_indiv_`i'=(formal_amount_indiv_`i'/loanamount_indiv_`i')*100
gen InformR_indiv_`i'=(informal_amount_indiv_`i'/loanamount_indiv_`i')*100
gen SemiformR_indiv_`i'=(semiformal_amount_indiv_`i'/loanamount_indiv_`i')*100
gen FormR_HH_`i'=(formal_amount_HH_`i'/loanamount_HH_`i')*100
gen InformR_HH_`i'=(informal_amount_HH_`i'/loanamount_HH_`i')*100
gen SemiformR_HH_`i'=(semiformal_amount_HH_`i'/loanamount_HH_`i')*100

gen IncogenR_indiv_`i'=(incomegen_amount_indiv_`i'/loanamount_indiv_`i')*100
gen NoincogenR_indiv_`i'=(noincomegen_amount_indiv_`i'/loanamount_indiv_`i')*100
gen IncogenR_HH_`i'=(incomegen_amount_HH_`i'/loanamount_HH_`i')*100
gen NoincogenR_HH_`i'=(noincomegen_amount_HH_`i'/loanamount_HH_`i')*100

gen debtshare_`i'=loanamount_indiv_`i'*100/loanamount_HH_`i'
}



********** Cleaning des new amount
egen savingsamount_1=rowtotal(savingsamount1_1 savingsamount2_1 savingsamount3_1 savingsamount4_1)
egen savingsamount_2=rowtotal(savingsamount1_2 savingsamount2_2 savingsamount3_2 savingsamount4_2)
drop savingsamount1_1 savingsamount2_1 savingsamount3_1 savingsamount4_1 savingsamount1_2 savingsamount2_2 savingsamount3_2 savingsamount4_2

egen dummydebitcard_1=rowtotal(dummydebitcard1_1 dummydebitcard2_1 dummydebitcard3_1 dummydebitcard4_1)
egen dummydebitcard_2=rowtotal(dummydebitcard1_2 dummydebitcard2_2 dummydebitcard3_2 dummydebitcard4_2)
drop dummydebitcard1_1 dummydebitcard2_1 dummydebitcard3_1 dummydebitcard4_1 dummydebitcard1_2 dummydebitcard2_2 dummydebitcard3_2 dummydebitcard4_2

egen dummycreditcard_1=rowtotal(dummycreditcard1_1 dummycreditcard2_1 dummycreditcard3_1 dummycreditcard4_1)
egen dummycreditcard_2=rowtotal(dummycreditcard1_2 dummycreditcard2_2 dummycreditcard3_2 dummycreditcard4_2)
drop dummycreditcard1_1 dummycreditcard2_1 dummycreditcard3_1 dummycreditcard4_1 dummycreditcard1_2 dummycreditcard2_2 dummycreditcard3_2 dummycreditcard4_2

egen chitfundamount_1=rowtotal(chitfundamount1_1 chitfundamount2_1)
egen chitfundamount_2=rowtotal(chitfundamount1_2 chitfundamount2_2 chitfundamount3_2)
drop chitfundamount1_1 chitfundamount2_1 chitfundamount1_2 chitfundamount2_2 chitfundamount3_2


save"panel1.dta", replace


use"panel1.dta", clear
********** Check the 0
tab debtpath

rename mean_monthlyinterestrate_indiv_1 mean_monthly_indiv_1
rename mean_monthlyinterestrate_indiv_2 mean_monthly_indiv_2

global toclean debtshare loanamount_indiv imp1_ds_tot_indiv imp1_is_tot_indiv DSR_indiv ISR_indiv goldquantity goldquantitypledge mean_yratepaid_indiv mean_monthly_indiv informal_amount_indiv formal_amount_indiv semiformal_amount_indiv economic_amount_indiv current_amount_indiv humancap_amount_indiv social_amount_indiv house_amount_indiv noincomegen_amount_indiv incomegen_amount_indiv dummyinterest_indiv loans_indiv DAR_indiv FormR_indiv InformR_indiv SemiformR_indiv IncogenR_indiv NoincogenR_indiv savingsamount chitfundamount nbsavingaccounts nbinsurance nbchitfunds annualincome_indiv ///
educationexpenses_HH productexpenses_HH businessexpenses_HH foodexpenses_HH healthexpenses_HH ceremoniesexpenses_HH deathexpenses_HH ///
loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH DSR_HH ISR_HH DAR_HH FormR_HH InformR_HH SemiformR_HH IncogenR_HH NoincogenR_HH  ///
annualincome_HH totalincome_HH dummyproblemtorepay_HH dummyhelptosettleloan_HH dummyinterest_HH loans_HH savingsamount_HH chitfundpaymentamount_HH chitfundamount_HH chitfundamounttot_HH nbchitfunds_HH amountlent_HH interestlending_HH problemrepayment_HH goldquantity_HH goldquantitypledge_HH nbinsurance_HH insuranceamount_HH insuranceamounttot_HH insurancebenefitamount_HH investequiptot_HH

*Then the variation rate
foreach x in $toclean {
recode `x'_2 (.=0)
gen del_`x'=(`x'_2-`x'_1)*100/`x'_1
gen delta_`x'=(`x'_2-`x'_1)*100/`x'_1
replace delta_`x'=`x'_2 if `x'_1==0
replace delta_`x'=-(`x'_1) if `x'_2==0
recode delta_`x' (0=.) if debtpath==0
}

foreach x in $toclean {
recode `x'_2 (.=0)
gen delta2_`x'=(`x'_2-`x'_1)*100/`x'_1
replace delta2_`x'=`x'_2/100 if `x'_1==0
replace delta2_`x'=-(`x'_1)/100 if `x'_2==0
recode delta2_`x' (0=.) if debtpath==0
}

foreach x in $toclean {
recode `x'_2 (.=0)
gen delta3_`x'=(`x'_2-`x'_1)*100/`x'_1
replace delta3_`x'=100 if `x'_1==0 & delta_`x'!=.
replace delta3_`x'=-100 if `x'_2==0 & delta_`x'!=.
recode delta3_`x' (0=.) if debtpath==0
}


sum delta_debtshare delta_loanamount_indiv delta_imp1_ds_tot_indiv delta_imp1_is_tot_indiv delta_DSR_indiv delta_ISR_indiv delta_goldquantity delta_goldquantitypledge delta_mean_yratepaid_indiv delta_mean_monthly_indiv delta_informal_amount_indiv delta_formal_amount_indiv delta_semiformal_amount_indiv delta_economic_amount_indiv delta_current_amount_indiv delta_humancap_amount_indiv delta_social_amount_indiv delta_house_amount_indiv delta_noincomegen_amount_indiv delta_incomegen_amount_indiv delta_dummyinterest_indiv delta_loans_indiv delta_DAR_indiv delta_FormR_indiv delta_InformR_indiv delta_SemiformR_indiv delta_IncogenR_indiv delta_NoincogenR_indiv delta_savingsamount delta_chitfundamount delta_nbsavingaccounts delta_nbinsurance delta_nbchitfunds delta_annualincome_indiv


foreach x in goldquantity mean_monthly_indiv mean_yratepaid_indiv mean_monthlyinterestrate_HH mean_yratepaid_HH {
forvalues i=1(1)2{
recode `x'_`i' (.=0)
}
}


*Dummy
foreach x in $toclean {
gen bin_`x'=0 if `x'_1!=.
}

foreach x in $toclean {
replace bin_`x'=1 if `x'_2>`x'_1
}
label define timevar2 0"Stable or decrease" 1"Increase"
foreach x in $toclean{
label values bin_`x' timevar2
replace bin_`x'=. if debtpath==0
}

tab bin_goldquantity
tab bin_mean_monthly_indiv
tab bin_mean_yratepaid_indiv


********** Cleaning
*Housing
tab house_1
tab house_2
gen ownhouse_1=0
gen ownhouse_2=0
replace ownhouse_1=1 if house_1==1
replace ownhouse_2=1 if house_2==1

*Land
tab ownland_1
tab ownland_2
recode ownland_1 ownland_2 (.=0)
tab1 ownland_1 ownland_2

*Sex ratio
gen sexratio_1=nbmale_1/nbfemale_1
replace sexratio_1=nbmale_1 if nbfemale_1==0
gen sexratio_2=nbmale_2/nbfemale_2
replace sexratio_2=nbmale_2 if nbfemale_2==0

gen sexratiocat_1=.
replace sexratiocat_1=1 if sexratio_1<1
replace sexratiocat_1=2 if sexratio_1==1
replace sexratiocat_1=3 if sexratio_1>1
gen sexratiocat_2=.
replace sexratiocat_2=1 if sexratio_2<1
replace sexratiocat_2=2 if sexratio_2==1
replace sexratiocat_2=3 if sexratio_2>1

label define sexratiocat 1"SR: More female" 2"SR: Same nb" 3"SR: More male"
label values sexratiocat_1 sexratiocat
label values sexratiocat_2 sexratiocat

tab sexratiocat_1
tab sexratiocat_2

*Caste
label define castenew 1"C: Dalits" 2"C: Middle" 3"C: Upper"
label values caste castenew

*Nb children
label var nbchild_1 "Nb children"
label var nbchild_2 "Nb children"

*HH size
label var hhsize_1 "Household size"
label var hhsize_2 "Household size"

*Shock
gen shock_1=0
gen shock_2=0
replace shock_1=1 if dummymarriage_1==1 | dummydemonetisation==1
replace shock_2=1 if dummymarriage_2==1

tab shock_1 shock_2


*Villages
clonevar villages2016=villageid_new
replace villages2016="TIRUP_reg" if villageid_new=="Somanur" | villageid_new=="Tiruppur" | villageid_new=="Chinnaputhur"

gen town_close=0
replace town_close=1 if (villageid_new=="Chengalpattu"|villageid_new=="Poonamallee"|villageid_new=="Tiruppur"|villageid_new=="Somanur"|villageid_new=="ELA"|villageid_new=="MAN"|villageid_new=="NAT"|villageid_new=="ORA"|villageid_new=="SEM"|villageid_new=="MANAM"|villageid_new=="KAR")

gen near_panruti=0
replace near_panruti=1 if (villageid_new=="ELA"|villageid_new=="MAN"|villageid_new=="NAT"|villageid_new=="ORA"|villageid_new=="SEM"|villageid_new=="MANAM"|villageid_new=="KAR")

gen near_villupur=0
replace near_villupur=1 if (villageid_new=="KUV"|villageid_new=="KOR"|villageid_new=="GOV")

gen near_tirup=0
replace near_tirup=1 if (villageid_new=="Tiruppur"|villageid_new=="Somanur"|villageid_new=="Chinnaputhur")

gen near_chengal=0
replace near_chengal=1 if (villageid_new=="Chengalpattu"|villageid_new=="Athur"|villageid_new=="Villiambakkam")

gen near_kanchip=0
replace near_kanchip=1 if (villageid_new=="Sembarambakkam"|villageid_new=="Walajabad")

gen near_chennai=0
replace near_chennai=1 if (villageid_new=="Poonamallee")

gen most_remote=0
replace most_remote=1 if (villageid_new=="Chinnaputhur")


*Edulevel
tab edulevel_2 edulevel_1

fre edulevel_1
replace edulevel_2=1 if edulevel_1==1 & edulevel_2==0
replace edulevel_2=2 if edulevel_1==2 & edulevel_2==0
replace edulevel_2=2 if edulevel_1==2 & edulevel_2==1
replace edulevel_2=3 if edulevel_1==3 & edulevel_2==2
replace edulevel_2=4 if edulevel_1==4 & edulevel_2==2
replace edulevel_2=4 if edulevel_1==4 & edulevel_2==3
replace edulevel_2=5 if edulevel_1==5 & edulevel_2==1
replace edulevel_2=5 if edulevel_1==5 & edulevel_2==2
replace edulevel_2=5 if edulevel_1==5 & edulevel_2==4

tab edulevel_1
tab edulevel_2 
gen dummyedulevel=0 if edulevel_1==0
replace dummyedulevel=1 if edulevel_1>0

tab dummyedulevel

*Main occupation
fre mainoccupation_indiv_1

gen cat_mainoccupation_indiv_1=.
gen cat_mainoccupation_indiv_2=.

forvalues i=1(1)2{
replace cat_mainoccupation_indiv_`i'=1 if mainoccupation_indiv_`i'==1
replace cat_mainoccupation_indiv_`i'=2 if mainoccupation_indiv_`i'==2
replace cat_mainoccupation_indiv_`i'=3 if mainoccupation_indiv_`i'==3
replace cat_mainoccupation_indiv_`i'=4 if mainoccupation_indiv_`i'==4
replace cat_mainoccupation_indiv_`i'=5 if mainoccupation_indiv_`i'==5
replace cat_mainoccupation_indiv_`i'=5 if mainoccupation_indiv_`i'==6
replace cat_mainoccupation_indiv_`i'=5 if mainoccupation_indiv_`i'==7
replace cat_mainoccupation_indiv_`i'=5 if mainoccupation_indiv_`i'==8
replace cat_mainoccupation_indiv_`i'=5 if mainoccupation_indiv_`i'==0
}
label define cat_mainocc 1"Agri" 2"SE" 3"SJ agri" 4"SJ non agri" 5"UW or NW", replace
label values cat_mainoccupation_indiv_1 cat_mainocc
label values cat_mainoccupation_indiv_2 cat_mainocc
tab cat_mainoccupation_indiv_1
tab cat_mainoccupation_indiv_2

drop villagenewFE



**********Standardiser personality traits
cls
foreach x in base_factor_imraw_1 base_factor_imraw_2 base_factor_imraw_3 base_factor_imraw_4 base_factor_imraw_5 {
qui reg `x' age_1
predict res_`x', residuals
egen `x'_std=std(res_`x')
}


foreach x in base_cr_OP base_cr_CO base_cr_EX base_cr_AG base_cr_ES base_cr_Grit base_OP base_CO base_EX base_AG base_ES base_Grit {
qui reg `x' age_1
predict res_`x', residuals
egen `x'_std=std(res_`x')
}

forvalues i=1(1)2 {
foreach x in cr_OP cr_CO cr_ES cr_AG cr_EX cr_Grit OP CO ES AG EX Grit {
qui reg `x'_`i' age_`i'
predict res_`x'_`i', residuals
}
}

preserve
keep HHID_panel INDID_panel res_cr_OP_1 res_cr_CO_1 res_cr_ES_1 res_cr_AG_1 res_cr_EX_1 res_cr_Grit_1 res_OP_1 res_CO_1 res_ES_1 res_AG_1 res_EX_1 res_Grit_1 res_cr_OP_2 res_cr_CO_2 res_cr_ES_2 res_cr_AG_2 res_cr_EX_2 res_cr_Grit_2 res_OP_2 res_CO_2 res_ES_2 res_AG_2 res_EX_2 res_Grit_2
egen HHINDID=concat(HHID_panel INDID_panel), p(/)
reshape long res_cr_OP_ res_cr_CO_ res_cr_ES_ res_cr_AG_ res_cr_EX_ res_cr_Grit_ res_OP_ res_CO_ res_ES_ res_AG_ res_EX_ res_Grit_, i(HHINDID) j(num)
tabstat res_cr_OP_ res_cr_CO_ res_cr_ES_ res_cr_AG_ res_cr_EX_ res_cr_Grit_ res_OP_ res_CO_ res_ES_ res_AG_ res_EX_ res_Grit_, stat(n mean sd p50)
/*
   stats |  res_c~P_  res_c~O_  res_c~S_  res_c~G_  res_c~X_  res_c~t_   res_OP_   res_CO_   res_ES_   res_AG_   res_EX_  res_Gr~_
---------+------------------------------------------------------------------------------------------------------------------------
       N |      1668      1668      1668      1668      1668      1668      1668      1668      1668      1668      1668      1668
    mean |  7.24e-10  3.48e-10  6.64e-10  1.60e-10 -9.22e-10  5.72e-10  3.15e-11  3.48e-09  3.99e-11  1.46e-10 -1.12e-10 -2.40e-10
      sd |  .4695046  .5884246  .7123245  .4011361  .4670096  .5543762  .5743814  .5573983  .4510244  .4752726  .5665607  .6036053
     p50 | -.0028035 -.0312275  .0027712  .0208227 -.0079332 -.0061333  .0565965  .0138466  .0352371    .02968  .0100178 -.0028547
----------------------------------------------------------------------------------------------------------------------------------
*/
restore

/*
forvalues i=1(1)2 {
foreach x in cr_OP cr_CO cr_ES cr_AG cr_EX cr_Grit OP CO ES AG EX Grit {
egen std_each_`x'_`i'=std(res_`x'_`i')
}
}
*/

forvalues i=1(1)2 {
gen std_cr_OP_`i'=(res_cr_OP_`i'-7.24e-10)/.4695046
gen std_cr_CO_`i'=(res_cr_CO_`i'-3.48e-10)/.5884246
gen std_cr_ES_`i'=(res_cr_ES_`i'-6.64e-10)/.7123245
gen std_cr_AG_`i'=(res_cr_AG_`i'-1.60e-10)/.4011361
gen std_cr_EX_`i'=(res_cr_EX_`i'+9.22e-10)/.4670096
gen std_cr_Grit_`i'=(res_cr_Grit_`i'-5.72e-10)/.5543762
gen std_OP_`i'=(res_OP_`i'-3.15e-11)/.5743814
gen std_CO_`i'=(res_CO_`i'-3.48e-09)/.5573983
gen std_ES_`i'=(res_ES_`i'-3.99e-11)/.4510244
gen std_AG_`i'=(res_AG_`i'-1.46e-10)/.4752726
gen std_EX_`i'=(res_EX_`i'+1.12e-10)/.5665607
gen std_Grit_`i'=(res_Grit_`i'+2.40e-10)/.6036053
}

label var base_cr_OP_std "OP cor (std)"
label var base_cr_CO_std "CO cor (std)"
label var base_cr_EX_std "EX cor (std)"
label var base_cr_AG_std "AG cor (std)"
label var base_cr_ES_std "ES cor (std)"
label var base_cr_Grit_std "Grit cor (std)"

label var base_OP_std "OP (std)"
label var base_CO_std "CO (std)"
label var base_EX_std "EX (std)"
label var base_AG_std "AG (std)"
label var base_ES_std "ES (std)"
label var base_Grit_std "Grit (std)"



********** Standardiser les compétences cognitives
foreach x in base_raven_tt base_num_tt base_lit_tt {
qui reg `x' age_1
predict res_`x', residuals
egen `x'_std=std(res_`x')
}

foreach x in raven_tt lit_tt num_tt {
forvalues i=1(1)2{
qui reg `x'_`i' age_`i'
predict res_`x'_`i', residuals
}
}

preserve
keep HHID_panel INDID_panel res_raven_tt_1 res_raven_tt_2 res_lit_tt_1 res_lit_tt_2 res_num_tt_1 res_num_tt_2 raven_tt_1 raven_tt_2 lit_tt_1 lit_tt_2 num_tt_1 num_tt_2
egen HHINDID=concat(HHID_panel INDID_panel), p(/)
reshape long res_raven_tt_ res_lit_tt_ res_num_tt_ raven_tt_ lit_tt_ num_tt_, i(HHINDID) j(num)
tabstat res_raven_tt_ res_lit_tt_ res_num_tt_ raven_tt_ lit_tt_ num_tt_, stat(n mean sd p50)
/*
   stats |  res_ra~_  res_li~_  res_nu~_  raven_~_   lit_tt_   num_tt_
---------+------------------------------------------------------------
       N |      1670      1486      1643      1670      1486      1643
    mean | -1.69e-09  3.54e-10  4.70e-11  11.37665  2.061575  2.738892
      sd |  7.699597  1.541575  1.559463  8.675844    1.6993  1.892511
     p50 | -1.712547  .0731145 -.0593502         8         2         2
----------------------------------------------------------------------
*/
restore

forvalues i=1(1)2 {
gen std_raven_tt_`i'=(res_raven_tt_`i'+1.69e-09)/7.699597
gen std_lit_tt_`i'=(res_lit_tt_`i'-3.54e-10)/1.541575
gen std_num_tt_`i'=(res_num_tt_`i'-4.70e-11)/1.559463
}

label var base_raven_tt_std "Raven (std)"
label var base_lit_tt_std "Literacy (std)"
label var base_num_tt_std "Numeracy (std)"

save"panel_wide", replace
****************************************
* END














****************************************
* Cleaning HH database
****************************************

**********
use"panel_wide", clear


********** Groups creation
gen female=0 if sex_1==1
replace female=1 if sex_1==2
label var female "Female (=1)"

gen segmana=.
replace segmana=1 if caste==1 & female==1  // female dalits (DJ)
replace segmana=2 if caste==1 & female==0  // male dalits
replace segmana=3 if (caste==2 | caste==3) & female==1  // female midup
replace segmana=4 if (caste==2 | caste==3) & female==0  // male midup

label define segmana 1"Dalit women" 2"Dalit men" 3"MU caste women" 4"MU caste men"
label values segmana segmana

tab segmana



********** Labels
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
gen dummyhead_1=0
replace dummyhead_1=1 if relationshiptohead_1==1
gen dummyhead_2=0
replace dummyhead_2=1 if relationshiptohead_2==1
label var dummyhead_1 "HH head (=1)"
label var dummyhead_2 "HH head (=1)"


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

forvalues i=1(1)5 {
label var base_factor_imraw_`i'_std "Factor `i' (std)"
}


********** gen FE
*Indiv
encode HHINDID, gen(indivFE)
*Villages
fre villageid  villages2016
drop villageid_new
encode villages2016, gen(villageid2016FE)
fre villageid villages2016 villageid2016FE



**********Dummy for debt or not
fre debtpath
gen dummydebt=0 if debtpath==0
replace dummydebt=0 if debtpath==1
replace dummydebt=1 if debtpath==2
replace dummydebt=1 if debtpath==3

label define debt 0"Not in debt" 1"Indebted"
label values dummydebt debt

tab debtpath dummydebt, row nofreq
tab debtpath dummydebt, col nofreq


********** Correlation
*Correlation with assets and house
median assets1000_1, by(ownland_1)
ttest assets1000_1, by(ownland_1)
sdtest assets1000_1, by(ownland_1)

*Correlation wiht assets and house
median assets1000_1, by(ownhouse_1)
ttest assets1000_1, by(ownhouse_1)
sdtest assets1000_1, by(ownhouse_1)



********** 1,000 INR variables
foreach x in loanamount_indiv loanamount_HH imp1_ds_tot_indiv imp1_ds_tot_HH imp1_is_tot_indiv imp1_is_tot_HH savingsamount annualincome_indiv annualincome_HH totalincome_indiv {
gen `x'1000_1=`x'_1/1000 
gen `x'1000_2=`x'_2/1000 
}



********** Recoder les dummy
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



********** Variation de la dette
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
forvalues i=1(1)5 {
gen `x'_f`i'=bin_`x'*base_factor_imraw_`i'_std
}
gen `x'_r1=bin_`x'*base_raven_tt
gen `x'_n1=bin_`x'*base_num_tt
gen `x'_l1=bin_`x'*base_lit_tt
}




********** Caste
clonevar caste2=caste
recode caste2 (3=2)

tab caste2 female





**********Dummy for multiple occupation
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

recode dummymultipleoccupation_indiv_1 (.=0)
label var dummymultipleoccupation_indiv_1 "Multiple occupation (=1)"



**********Combien de prêts sans services de la part du prêteur 1?
tab1  sum_otherlenderservices_5_2

gen sharenoservices_1=sum_otherlenderservices_5_1/loans_indiv_1
gen sharenoservices_2=sum_otherlenderservices_5_2/loans_indiv_2

tab sharenoservices_1
tab sharenoservices_2


********** Taux de varation de la personnalité
foreach x in CO OP ES EX AG {
gen diff_`x'=cr_`x'_2-cr_`x'_1
gen delta_`x'=(cr_`x'_2-cr_`x'_1)*100/cr_`x'_1
}
tabstat diff_CO diff_OP diff_ES diff_EX diff_AG delta_CO delta_OP delta_ES delta_EX delta_AG, stat(n mean sd q)




********** Interaction 
fre caste2
gen dalits=0 if caste2==2
replace dalits=1 if caste2==1
tab dalits female
label var dalits "Dalits (=1)"

foreach x in base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt_std base_num_tt_std base_lit_tt_std base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std base_OP_std base_CO_std base_EX_std base_AG_std base_ES_std {
gen fem_`x'=`x'*female
gen dal_`x'=`x'*dalits
gen threeway_`x'=`x'*female*dalits
}
gen femXdal=female*dalits

drop over30_indiv_2 over40_indiv_2

gen over30_indiv_2=0
replace over30_indiv_2=1 if DSR_indiv_2>=30

gen over40_indiv_2=0
replace over40_indiv_2=1 if DSR_indiv_2>=40

gen over50_indiv_2=0
replace over50_indiv_2=1 if DSR_indiv_2>=50


	
********** Username
preserve
use "NEEMSIS2-HH_v17", clear
duplicates drop HHID_panel, force
keep HHID_panel username
save"NEEMSIS2-username", replace
restore

merge m:1 HHID_panel using "NEEMSIS2-username"
drop if _merge==2
drop _merge


save"panel_wide_v2", replace
****************************************
* END







****************************************
* Reshaper 
****************************************
********** Reshape la base pour FE
use"panel_wide_v2", clear

destring dummyeverhadland_2, replace
destring landpurchased_2, replace

reshape long ///
dummyhead_ ///
name_ ///
dummyeverhadland_ ///
ownland_ ///
egoid_ ///
interviewplace_ ///
address_ ///
sex_ ///
age_ ///
relationshiptohead_ ///
maritalstatus_ ///
amountlent_ ///
interestlending_ ///
dummychitfund_ ///
nbchitfunds_ ///
nbsavingaccounts_ ///
datedebitcard1_ ///
datedebitcard2_ ///
datedebitcard3_ ///
datedebitcard4_ ///
goldquantity_ ///
goldquantitypledge_ ///
nbinsurance_ ///
landpurchased_ ///
foodexpenses_ ///
healthexpenses_ ///
ceremoniesexpenses_ ///
ceremoniesrelativesexpenses_ ///
deathexpenses_ ///
dummymarriage_ ///
marriageexpenses_ ///
house_ ///
readystartjob_ ///
methodfindjob_ ///
jobpreference_ ///
moveoutsideforjob_ ///
moveoutsideforjobreason_ ///
aspirationminimumwage_ ///
businessexpenses_ ///
dummyaspirationmorehours_ ///
aspirationminimumwage2_ ///
mainoccupation_hours_indiv_ ///
mainoccupation_income_indiv_ ///
mainoccupation_indiv_ ///
mainoccupationname_indiv_ ///
annualincome_indiv_ ///
nboccupation_indiv_ ///
mainoccupation_HH_ ///
annualincome_HH_ ///
nboccupation_HH_ ///
edulevel_ ///
assets_ ///
totalincome_indiv_ ///
totalincome_HH_ ///
std_raven_tt_ ///
std_lit_tt_ ///
std_num_tt_ ///
std_cr_OP_ ///
std_cr_CO_ ///
std_cr_EX_ ///
std_cr_AG_ ///
std_cr_ES_ ///
std_cr_Grit_ ///
std_OP_ ///
std_CO_ ///
std_EX_ ///
std_AG_ ///
std_ES_ ///
std_Grit_ ///
imp1_ds_tot_indiv_ ///
imp1_is_tot_indiv_ ///
semiformal_indiv_ ///
formal_indiv_ ///
economic_indiv_ ///
current_indiv_ ///
humancap_indiv_ ///
social_indiv_ ///
house_indiv_ ///
incomegen_indiv_ ///
noincomegen_indiv_ ///
economic_amount_indiv_ ///
current_amount_indiv_ ///
humancap_amount_indiv_ ///
social_amount_indiv_ ///
house_amount_indiv_ ///
incomegen_amount_indiv_ ///
noincomegen_amount_indiv_ ///
informal_amount_indiv_ ///
formal_amount_indiv_ ///
semiformal_amount_indiv_ ///
marriageloan_indiv_ ///
marriageloanamount_indiv_ ///
dummyproblemtorepay_indiv_ ///
dummyhelptosettleloan_indiv_ ///
dummyinterest_indiv_ ///
loans_indiv_ ///
loanamount_indiv_ ///
loanbalance_indiv_ ///
loanamount_wm_indiv_ ///
mean_yratepaid_indiv_ ///
mean_monthly_indiv_ ///
sum_otherlenderservices_1_ ///
sum_otherlenderservices_2_ ///
sum_otherlenderservices_3_ ///
sum_otherlenderservices_4_ ///
sum_otherlenderservices_5_ ///
imp1_ds_tot_HH_ ///
imp1_is_tot_HH_ ///
informal_HH_ ///
semiformal_HH_ ///
formal_HH_ ///
economic_HH_ ///
current_HH_ ///
humancap_HH_ ///
social_HH_ ///
house_HH_ ///
incomegen_HH_ ///
noincomegen_HH_ ///
economic_amount_HH_ ///
current_amount_HH_ ///
humancap_amount_HH_ ///
social_amount_HH_ ///
house_amount_HH_ ///
incomegen_amount_HH_ ///
noincomegen_amount_HH_ ///
informal_amount_HH_ ///
formal_amount_HH_ ///
semiformal_amount_HH_ ///
marriageloan_HH_ ///
marriageloanamount_HH_ ///
dummyproblemtorepay_HH_ ///
dummyhelptosettleloan_HH_ ///
dummyinterest_HH_ ///
loans_HH_ ///
loanamount_HH_ ///
loanbalance_HH_ ///
loanamount_wm_HH_ ///
mean_yratepaid_HH_ ///
mean_monthlyinterestrate_HH_ ///
factor_imraw_1_ ///
factor_imraw_2_ ///
factor_imraw_3_ ///
factor_imraw_4_ ///
factor_imraw_5_ ///
hhsize_ ///
nbchild_ ///
nbfemale_ ///
nbmale_ ///
savingsamount_HH_ ///
educationexpenses_HH_ ///
productexpenses_HH_ ///
businessexpenses_HH_ ///
foodexpenses_HH_ ///
healthexpenses_HH_ ///
ceremoniesexpenses_HH_ ///
deathexpenses_HH_ ///
livestockexpenses_HH_ ///
chitfundpaymentamount_HH_ ///
chitfundamount_HH_ ///
chitfundamounttot_HH_ ///
nbchitfunds_HH_ ///
amountlent_HH_ ///
interestlending_HH_ ///
problemrepayment_HH_ ///
goldquantity_HH_ ///
goldquantitypledge_HH_ ///
nbinsurance_HH_ ///
insuranceamount_HH_ ///
insuranceamounttot_HH_ ///
insurancebenefitamount_HH_ ///
insurancebenefitamounttot_HH_ ///
investequiptot_HH_ ///
debtorratio_ ///
debtorratio2_ ///
workerratio_ ///
workerratio2_ ///
sum_borrowerservices_1_r_ ///
sum_borrowerservices_2_r_ ///
sum_borrowerservices_3_r_ ///
sum_borrowerservices_4_r_ ///
sum_plantorepay_1_r_ ///
sum_plantorepay_2_r_ ///
sum_plantorepay_3_r_ ///
sum_plantorepay_4_r_ ///
sum_plantorepay_5_r_ ///
sum_plantorepay_6_r_ ///
sum_settleloanstrategy_1_r_ ///
sum_settleloanstrategy_2_r_ ///
sum_settleloanstrategy_3_r_ ///
sum_settleloanstrategy_4_r_ ///
sum_settleloanstrategy_5_r_ ///
sum_settleloanstrategy_6_r_ ///
sum_settleloanstrategy_7_r_ ///
sum_settleloanstrategy_8_r_ ///
sum_settleloanstrategy_9_r_ ///
sum_settleloanstrategy_10_r_ ///
indebt_indiv_ ///
indebt_HH_ ///
DSR_indiv_ ///
DSR_HH_ ///
ISR_indiv_ ///
ISR_HH_ ///
DAR_indiv_ ///
DAR_HH_ ///
FormR_indiv_ ///
InformR_indiv_ ///
SemiformR_indiv_ ///
FormR_HH_ ///
InformR_HH_ ///
SemiformR_HH_ ///
IncogenR_indiv_ ///
NoincogenR_indiv_ ///
IncogenR_HH_ ///
NoincogenR_HH_ ///
debtshare_ ///
savingsamount_ ///
dummydebitcard_ ///
dummycreditcard_ ///
chitfundamount_ ///
ownhouse_ ///
sexratio_ ///
sexratiocat_ ///
shock_ ///
cat_mainoccupation_indiv_ ///
agesq_ ///
maritalstatus2_ ///
assets1000_ ///
incomeHH1000_ ///
loanamount_indiv1000_ ///
loanamount_HH1000_ ///
imp1_ds_tot_indiv1000_ ///
imp1_ds_tot_HH1000_ ///
imp1_is_tot_indiv1000_ ///
imp1_is_tot_HH1000_ ///
savingsamount1000_ ///
annualincome_indiv1000_ ///
annualincome_HH1000_ ///
totalincome_indiv1000_ ///
over30_indiv_ ///
over40_indiv_ ///
dichotomyinterest_indiv_ ///
dummymultipleoccupation_indiv_ ///
sharenoservices_ ///
, i(HHINDID) j(year)




*** Rename
foreach x in name_ ///
dummyhead_ ///
dummyeverhadland_ ///
ownland_ ///
egoid_ ///
interviewplace_ ///
address_ ///
sex_ ///
age_ ///
relationshiptohead_ ///
maritalstatus_ ///
amountlent_ ///
interestlending_ ///
dummychitfund_ ///
nbchitfunds_ ///
nbsavingaccounts_ ///
datedebitcard1_ ///
datedebitcard2_ ///
datedebitcard3_ ///
datedebitcard4_ ///
goldquantity_ ///
goldquantitypledge_ ///
nbinsurance_ ///
landpurchased_ ///
foodexpenses_ ///
healthexpenses_ ///
ceremoniesexpenses_ ///
ceremoniesrelativesexpenses_ ///
deathexpenses_ ///
dummymarriage_ ///
marriageexpenses_ ///
house_ ///
readystartjob_ ///
methodfindjob_ ///
jobpreference_ ///
moveoutsideforjob_ ///
moveoutsideforjobreason_ ///
aspirationminimumwage_ ///
businessexpenses_ ///
dummyaspirationmorehours_ ///
aspirationminimumwage2_ ///
mainoccupation_hours_indiv_ ///
mainoccupation_income_indiv_ ///
mainoccupation_indiv_ ///
mainoccupationname_indiv_ ///
annualincome_indiv_ ///
nboccupation_indiv_ ///
mainoccupation_HH_ ///
annualincome_HH_ ///
nboccupation_HH_ ///
edulevel_ ///
assets_ ///
totalincome_indiv_ ///
totalincome_HH_ ///
std_raven_tt_ ///
std_lit_tt_ ///
std_num_tt_ ///
std_cr_OP_ ///
std_cr_CO_ ///
std_cr_EX_ ///
std_cr_AG_ ///
std_cr_ES_ ///
std_cr_Grit_ ///
std_OP_ ///
std_CO_ ///
std_EX_ ///
std_AG_ ///
std_ES_ ///
std_Grit_ ///
imp1_ds_tot_indiv_ ///
imp1_is_tot_indiv_ ///
semiformal_indiv_ ///
formal_indiv_ ///
economic_indiv_ ///
current_indiv_ ///
humancap_indiv_ ///
social_indiv_ ///
house_indiv_ ///
incomegen_indiv_ ///
noincomegen_indiv_ ///
economic_amount_indiv_ ///
current_amount_indiv_ ///
humancap_amount_indiv_ ///
social_amount_indiv_ ///
house_amount_indiv_ ///
incomegen_amount_indiv_ ///
noincomegen_amount_indiv_ ///
informal_amount_indiv_ ///
formal_amount_indiv_ ///
semiformal_amount_indiv_ ///
marriageloan_indiv_ ///
marriageloanamount_indiv_ ///
dummyproblemtorepay_indiv_ ///
dummyhelptosettleloan_indiv_ ///
dummyinterest_indiv_ ///
loans_indiv_ ///
loanamount_indiv_ ///
loanbalance_indiv_ ///
loanamount_wm_indiv_ ///
mean_yratepaid_indiv_ ///
mean_monthly_indiv_ ///
sum_otherlenderservices_1_ ///
sum_otherlenderservices_2_ ///
sum_otherlenderservices_3_ ///
sum_otherlenderservices_4_ ///
sum_otherlenderservices_5_ ///
imp1_ds_tot_HH_ ///
imp1_is_tot_HH_ ///
informal_HH_ ///
semiformal_HH_ ///
formal_HH_ ///
economic_HH_ ///
current_HH_ ///
humancap_HH_ ///
social_HH_ ///
house_HH_ ///
incomegen_HH_ ///
noincomegen_HH_ ///
economic_amount_HH_ ///
current_amount_HH_ ///
humancap_amount_HH_ ///
social_amount_HH_ ///
house_amount_HH_ ///
incomegen_amount_HH_ ///
noincomegen_amount_HH_ ///
informal_amount_HH_ ///
formal_amount_HH_ ///
semiformal_amount_HH_ ///
marriageloan_HH_ ///
marriageloanamount_HH_ ///
dummyproblemtorepay_HH_ ///
dummyhelptosettleloan_HH_ ///
dummyinterest_HH_ ///
loans_HH_ ///
loanamount_HH_ ///
loanbalance_HH_ ///
loanamount_wm_HH_ ///
mean_yratepaid_HH_ ///
mean_monthlyinterestrate_HH_ ///
factor_imraw_1_ ///
factor_imraw_2_ ///
factor_imraw_3_ ///
factor_imraw_4_ ///
factor_imraw_5_ ///
hhsize_ ///
nbchild_ ///
nbfemale_ ///
nbmale_ ///
savingsamount_HH_ ///
educationexpenses_HH_ ///
productexpenses_HH_ ///
businessexpenses_HH_ ///
foodexpenses_HH_ ///
healthexpenses_HH_ ///
ceremoniesexpenses_HH_ ///
deathexpenses_HH_ ///
livestockexpenses_HH_ ///
chitfundpaymentamount_HH_ ///
chitfundamount_HH_ ///
chitfundamounttot_HH_ ///
nbchitfunds_HH_ ///
amountlent_HH_ ///
interestlending_HH_ ///
problemrepayment_HH_ ///
goldquantity_HH_ ///
goldquantitypledge_HH_ ///
nbinsurance_HH_ ///
insuranceamount_HH_ ///
insuranceamounttot_HH_ ///
insurancebenefitamount_HH_ ///
insurancebenefitamounttot_HH_ ///
investequiptot_HH_ ///
debtorratio_ ///
debtorratio2_ ///
workerratio_ ///
workerratio2_ ///
sum_borrowerservices_1_r_ ///
sum_borrowerservices_2_r_ ///
sum_borrowerservices_3_r_ ///
sum_borrowerservices_4_r_ ///
sum_plantorepay_1_r_ ///
sum_plantorepay_2_r_ ///
sum_plantorepay_3_r_ ///
sum_plantorepay_4_r_ ///
sum_plantorepay_5_r_ ///
sum_plantorepay_6_r_ ///
sum_settleloanstrategy_1_r_ ///
sum_settleloanstrategy_2_r_ ///
sum_settleloanstrategy_3_r_ ///
sum_settleloanstrategy_4_r_ ///
sum_settleloanstrategy_5_r_ ///
sum_settleloanstrategy_6_r_ ///
sum_settleloanstrategy_7_r_ ///
sum_settleloanstrategy_8_r_ ///
sum_settleloanstrategy_9_r_ ///
sum_settleloanstrategy_10_r_ ///
indebt_indiv_ ///
indebt_HH_ ///
DSR_indiv_ ///
DSR_HH_ ///
ISR_indiv_ ///
ISR_HH_ ///
DAR_indiv_ ///
DAR_HH_ ///
FormR_indiv_ ///
InformR_indiv_ ///
SemiformR_indiv_ ///
FormR_HH_ ///
InformR_HH_ ///
SemiformR_HH_ ///
IncogenR_indiv_ ///
NoincogenR_indiv_ ///
IncogenR_HH_ ///
NoincogenR_HH_ ///
debtshare_ ///
savingsamount_ ///
dummydebitcard_ ///
dummycreditcard_ ///
chitfundamount_ ///
ownhouse_ ///
sexratio_ ///
sexratiocat_ ///
shock_ ///
cat_mainoccupation_indiv_ ///
agesq_ ///
maritalstatus2_ ///
assets1000_ ///
incomeHH1000_ ///
loanamount_indiv1000_ ///
loanamount_HH1000_ ///
imp1_ds_tot_indiv1000_ ///
imp1_ds_tot_HH1000_ ///
imp1_is_tot_indiv1000_ ///
imp1_is_tot_HH1000_ ///
savingsamount1000_ ///
annualincome_indiv1000_ ///
annualincome_HH1000_ ///
totalincome_indiv1000_ ///
over30_indiv_ ///
over40_indiv_ ///
dichotomyinterest_indiv_ ///
dummymultipleoccupation_indiv_ ///
sharenoservices_ {
local y=substr("`x'",1,strlen("`x'")-1)
rename `x' `y'
}

*** Recode year
replace year=2016 if year==1
replace year=2020 if year==2

*** Interaction
fre female dalits
foreach x in std_cr_OP std_cr_CO std_cr_EX std_cr_AG std_cr_ES std_OP std_CO std_EX std_AG std_ES std_raven_tt std_lit_tt std_num_tt {
gen fem_`x'=`x'*female
gen dal_`x'=`x'*dalits
gen threeway_`x'=`x'*female*dalits
}


*** Occupation
tab cat_mainoccupation_indiv, gen(cat_mainoccupation_indiv_)

*** Head?
tab relationshiptohead dummyhead, m
replace dummyhead=0 if relationshiptohead==.

*** Sexratio
drop sexratiocat_1_1 sexratiocat_1_2 sexratiocat_1_3
tab sexratiocat, gen(sexratiocat_)


save"panel_long_v1.dta", replace
****************************************
* END










*Pas besoin de le lancer à chaque fois car je n'y touche quasi jamais

****************************************
* Cleaning loans database
****************************************
use"$dropbox\RUME-NEEMSIS\NEEMSIS2\NEEMSIS2-loans_v13", clear
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


*Gen dummy for interest
tab1 dummyinterest_indiv_1 dummyinterest_indiv_2
tab1 dichotomyinterest_indiv_1 dichotomyinterest_indiv_2
drop dichotomyinterest_indiv_1 dichotomyinterest_indiv_2

forvalues i=1(1)2 {
gen dichotomyinterest_indiv_`i'=0 if indebt_indiv_`i'==1
}

replace dichotomyinterest_indiv_1=1 if indebt_indiv_1==1 & dummyinterest_indiv_1>0
replace dichotomyinterest_indiv_2=1 if indebt_indiv_2==1 & dummyinterest_indiv_2>0

*verif
tab1 dummyhelptosettleloan_indiv_1 dummyhelptosettleloan_indiv_2
tab dummyhelptosettleloan_indiv_2 segmana


*Dummy for formal
tab FormR_indiv_2
gen dummyformal_2=1 	if FormR_indiv_2>0 & FormR_indiv_2!=.
replace dummyformal_2=0 if FormR_indiv_2==0 & FormR_indiv_2!=.
replace dummyformal_2=. if indebt_indiv_2==0
tab dummyformal_2

tab InformR_indiv_2
gen dummyinformal_2=1 	if InformR_indiv_2>0 & InformR_indiv_2!=.
replace dummyinformal_2=0 if InformR_indiv_2==0 & InformR_indiv_2!=.
replace dummyinformal_2=. if indebt_indiv_2==0
tab dummyinformal_2

tab IncogenR_indiv_2
gen dummyincomegen_2=1 	if IncogenR_indiv_2>0 & IncogenR_indiv_2!=.
replace dummyincomegen_2=0 if IncogenR_indiv_2==0 & IncogenR_indiv_2!=.
replace dummyincomegen_2=. if indebt_indiv_2==0
tab dummyincomegen_2

tab NoincogenR_indiv_2
gen dummynoincomegen_2=1 	if NoincogenR_indiv_2>0 & NoincogenR_indiv_2!=.
replace dummynoincomegen_2=0 if NoincogenR_indiv_2==0 & NoincogenR_indiv_2!=.
replace dummynoincomegen_2=. if indebt_indiv_2==0
tab dummynoincomegen_2

tab1 dummyformal_2 dummyinformal_2 dummyincomegen_2 dummynoincomegen_2

*Nb interest/nb tot
ta dummyinterest_indiv_2
gen interestratio_2=dummyinterest_indiv_2/loans_indiv_2
tab interestratio_2
gen dummyinterestratio_2=0 if interestratio_2<1 & interestratio_2!=.
replace dummyinterestratio_2=1 if interestratio_2==1 & interestratio_2!=.

tab segmana dummyinterestratio_2, row nofreq

save"panel_wide_v3.dta", replace
****************************************
* END
