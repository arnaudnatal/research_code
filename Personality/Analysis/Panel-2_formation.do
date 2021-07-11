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

global all $charactindiv $characthh $wealthindiv $wealthhh $debtindiv $debthh $perso $expenses

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

save"$wave3~panel", replace
****************************************
* END

















****************************************
* Prepa 2016
****************************************

********** 
use"$wave2", clear


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
cls
fre raw_curious raw_interestedbyart raw_repetitivetasks raw_inventive raw_liketothink raw_newideas raw_activeimagination
cls
fre curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination


*****************************************************************************
*****************************************************************************
*****************************************************************************
*****************************************************************************
*****************************************************************************
*** Recoder ES dans rr pour que tout fonctionne dans le bon sens et que pour ceux de ES ca capte ES en max et non NE comme ca fait normalement.
*** Dans ce que j'avais fait, c'était ES et tout le reste dans l'ordre du questionnaire, donc à l'envers...
*** rr_ et raw_ fonctionne parfaitement en sens inverse, je prends rr car 4 dans le bon sens, je recode juste NE en ES
foreach x in rr_managestress rr_nervous rr_changemood rr_feeldepressed rr_easilyupset rr_worryalot rr_staycalm {
recode `x' (5=1) (4=2) (3=3) (2=4) (1=5)
}
label define b5new 1"1 - Almost always" 2"2 - Quite often" 3"3 - Sometimes" 4"4 - Rarely" 5"5 - Almost never"
foreach x in rr_managestress rr_nervous rr_changemood rr_feeldepressed rr_easilyupset rr_worryalot rr_staycalm {
label values `x' b5new
}
cls
fre rr_curious rr_interestedbyart rr_repetitivetasks rr_inventive rr_liketothink rr_newideas rr_activeimagination 
fre rr_organized  rr_makeplans rr_workhard rr_appointmentontime rr_putoffduties rr_easilydistracted rr_completeduties 
fre rr_enjoypeople rr_sharefeelings rr_shywithpeople rr_enthusiastic rr_talktomanypeople  rr_talkative rr_expressingthoughts 
fre rr_workwithother rr_understandotherfeeling rr_trustingofother rr_rudetoother rr_toleratefaults rr_forgiveother rr_helpfulwithothers 
fre rr_managestress  rr_nervous  rr_changemood rr_feeldepressed rr_easilyupset rr_worryalot rr_staycalm 

global big5rrok rr_curious rr_interestedbyart rr_repetitivetasks rr_inventive rr_liketothink rr_newideas rr_activeimagination rr_organized rr_makeplans rr_workhard rr_appointmentontime rr_putoffduties rr_easilydistracted rr_completeduties rr_enjoypeople rr_sharefeelings rr_shywithpeople rr_enthusiastic rr_talktomanypeople rr_talkative rr_expressingthoughts rr_workwithother rr_understandotherfeeling rr_trustingofother rr_rudetoother rr_toleratefaults rr_forgiveother rr_helpfulwithothers rr_managestress rr_nervous rr_changemood rr_feeldepressed rr_easilyupset rr_worryalot rr_staycalm rr_tryhard rr_stickwithgoals rr_goaftergoal rr_finishwhatbegin rr_finishtasks rr_keepworking


foreach x in $big5 $big5raw $big5cor $big5rrok{
gen im_`x'=`x'
}


forvalues j=1(1)3{
forvalues i=1(1)2{
foreach x in $big5 $big5raw $big5cor $big5rrok{
sum im_`x' if sex==`i' & caste==`j' & egoid!=0 & egoid!=.
replace im_`x'=r(mean) if im_`x'==. & sex==`i' & caste==`j' & egoid!=0 & egoid!=.
}
}
}

*Tester le sens
fre 

global imcorwith im_cr_curious im_cr_interestedbyart im_cr_repetitivetasks im_cr_inventive im_cr_liketothink im_cr_newideas im_cr_activeimagination im_cr_organized im_cr_makeplans im_cr_workhard im_cr_appointmentontime im_cr_putoffduties im_cr_easilydistracted im_cr_completeduties im_cr_enjoypeople im_cr_sharefeelings im_cr_shywithpeople im_cr_enthusiastic im_cr_talktomanypeople im_cr_talkative im_cr_expressingthoughts im_cr_workwithother im_cr_understandotherfeeling im_cr_trustingofother im_cr_rudetoother im_cr_toleratefaults im_cr_forgiveother im_cr_helpfulwithothers im_cr_managestress im_cr_nervous im_cr_changemood im_cr_feeldepressed im_cr_easilyupset im_cr_worryalot im_cr_staycalm im_cr_tryhard im_cr_stickwithgoals im_cr_goaftergoal im_cr_finishwhatbegin im_cr_finishtasks im_cr_keepworking

global imrawwith im_raw_curious im_raw_interestedbyart im_raw_repetitivetasks im_raw_inventive im_raw_liketothink im_raw_newideas im_raw_activeimagination im_raw_organized im_raw_makeplans im_raw_workhard im_raw_appointmentontime im_raw_putoffduties im_raw_easilydistracted im_raw_completeduties im_raw_enjoypeople im_raw_sharefeelings im_raw_shywithpeople im_raw_enthusiastic im_raw_talktomanypeople im_raw_talkative im_raw_expressingthoughts im_raw_workwithother im_raw_understandotherfeeling im_raw_trustingofother im_raw_rudetoother im_raw_toleratefaults im_raw_forgiveother im_raw_helpfulwithothers im_raw_managestress im_raw_nervous im_raw_changemood im_raw_feeldepressed im_raw_easilyupset im_raw_worryalot im_raw_staycalm  im_raw_tryhard im_raw_stickwithgoals im_raw_goaftergoal im_raw_finishwhatbegin im_raw_finishtasks im_raw_keepworking

global imcor im_cr_curious im_cr_interestedbyart im_cr_repetitivetasks im_cr_inventive im_cr_liketothink im_cr_newideas im_cr_activeimagination im_cr_organized im_cr_makeplans im_cr_workhard im_cr_appointmentontime im_cr_putoffduties im_cr_easilydistracted im_cr_completeduties im_cr_enjoypeople im_cr_sharefeelings im_cr_shywithpeople im_cr_enthusiastic im_cr_talktomanypeople im_cr_talkative im_cr_expressingthoughts im_cr_workwithother im_cr_understandotherfeeling im_cr_trustingofother im_cr_rudetoother im_cr_toleratefaults im_cr_forgiveother im_cr_helpfulwithothers im_cr_managestress im_cr_nervous im_cr_changemood im_cr_feeldepressed im_cr_easilyupset im_cr_worryalot im_cr_staycalm

global imraw im_raw_curious im_raw_interestedbyart im_raw_repetitivetasks im_raw_inventive im_raw_liketothink im_raw_newideas im_raw_activeimagination im_raw_organized im_raw_makeplans im_raw_workhard im_raw_appointmentontime im_raw_putoffduties im_raw_easilydistracted im_raw_completeduties im_raw_enjoypeople im_raw_sharefeelings im_raw_shywithpeople im_raw_enthusiastic im_raw_talktomanypeople im_raw_talkative im_raw_expressingthoughts im_raw_workwithother im_raw_understandotherfeeling im_raw_trustingofother im_raw_rudetoother im_raw_toleratefaults im_raw_forgiveother im_raw_helpfulwithothers im_raw_managestress im_raw_nervous im_raw_changemood im_raw_feeldepressed im_raw_easilyupset im_raw_worryalot im_raw_staycalm 

global imraw2 im_rr_curious im_rr_interestedbyart im_rr_repetitivetasks im_rr_inventive im_rr_liketothink im_rr_newideas im_rr_activeimagination im_rr_organized im_rr_makeplans im_rr_workhard im_rr_appointmentontime im_rr_putoffduties im_rr_easilydistracted im_rr_completeduties im_rr_enjoypeople im_rr_sharefeelings im_rr_shywithpeople im_rr_enthusiastic im_rr_talktomanypeople im_rr_talkative im_rr_expressingthoughts im_rr_workwithother im_rr_understandotherfeeling im_rr_trustingofother im_rr_rudetoother im_rr_toleratefaults im_rr_forgiveother im_rr_helpfulwithothers im_rr_managestress im_rr_nervous im_rr_changemood im_rr_feeldepressed im_rr_easilyupset im_rr_worryalot im_rr_staycalm

/*
cls
foreach x in imcorwith imrawwith {
*minap $`x'
*fsum $`x', stat(n mean sd)
qui factor $`x', pcf fa(6) 
rotate, promax
*putexcel set "EFA_2016.xlsx", modify sheet(`x')
*putexcel (E2)=matrix(e(r_L))

predict factor_`x'_1 factor_`x'_2 factor_`x'_3 factor_`x'_4 factor_`x'_5 factor_`x'_6
cpcorr $`x' \ factor_`x'_1 factor_`x'_2 factor_`x'_3 factor_`x'_4 factor_`x'_5 factor_`x'_6
matrix list r(p)

*Correlation with big-5 and cronbach
cpcorr cr_OP cr_EX cr_ES cr_CO cr_AG cr_Grit OP EX ES CO AG Grit factor_`x'_1 factor_`x'_2 factor_`x'_3 factor_`x'_4 factor_`x'_5 factor_`x'_6
matrix list r(p)
}
*/
cls
foreach x in imraw2 { //imcor imraw {
*minap $`x'
*fsum $`x', stat(n mean sd)
qui factor $`x', pcf fa(5) 
rotate, promax
*putexcel set "EFA_2016.xlsx", modify sheet(`x')
*putexcel (E2)=matrix(e(r_L))

predict factor_`x'_1 factor_`x'_2 factor_`x'_3 factor_`x'_4 factor_`x'_5
cpcorr $`x' \ factor_`x'_1 factor_`x'_2 factor_`x'_3 factor_`x'_4 factor_`x'_5
matrix list r(p)

*Correlation with big-5 and cronbach
cpcorr cr_OP cr_EX cr_ES cr_CO cr_AG cr_Grit OP EX ES CO AG Grit factor_`x'_1 factor_`x'_2 factor_`x'_3 factor_`x'_4 factor_`x'_5
matrix list r(p)
}

forvalues i=1(1)5 {
rename factor_imraw2_`i' factor_imraw_`i'
}

pwcorr cr_OP cr_EX cr_ES cr_CO cr_AG cr_Grit OP EX ES CO AG Grit factor_imraw_1 factor_imraw_2 factor_imraw_3 factor_imraw_4 factor_imraw_5, star(.01)





********** Graph rpz
/*
preserve
import delimited "factor2016.csv", delimiter(";") clear
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

*Interpretation
*F1
gsort - factor_Raw_1
list n var big5 factor_Raw_1, clean noobs
*F2
gsort - factor_Raw_2
list n var big5 factor_Raw_2, clean noobs
*F3
gsort - factor_Raw_3
list n var big5 factor_Raw_3, clean noobs
*F4
gsort - factor_Raw_4
list n var big5 factor_Raw_4, clean noobs
*F5
gsort - factor_Raw_5
list n var big5 factor_Raw_5, clean noobs

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
grc1leg g_Raw_1 g_Raw_2 g_Raw_3 g_Raw_4 g_Raw_5, note("Raw items with NEEMSIS-1 (2016-17) data.", size(tiny)) col(3) name(comb_`x'_with, replace) 
}
graph save "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\factor2016_2.gph", replace
graph export "C:\Users\Arnaud\Documents\GitHub\RUME-NEEMSIS\Big-5\factor2016_2.svg", as(svg) replace
graph export "C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Big-5\factor2016_2.pdf", as(pdf) replace


restore
set graph on
*/









im_rr_curious im_rr_interestedbyart im_rr_repetitivetasks im_rr_inventive im_rr_liketothink im_rr_newideas im_rr_activeimagination im_rr_organized im_rr_makeplans im_rr_workhard im_rr_appointmentontime im_rr_putoffduties im_rr_easilydistracted im_rr_completeduties im_rr_enjoypeople im_rr_sharefeelings im_rr_shywithpeople im_rr_enthusiastic im_rr_talktomanypeople im_rr_talkative im_rr_expressingthoughts im_rr_workwithother im_rr_understandotherfeeling im_rr_trustingofother im_rr_rudetoother im_rr_toleratefaults im_rr_forgiveother im_rr_helpfulwithothers im_rr_managestress im_rr_nervous im_rr_changemood im_rr_feeldepressed im_rr_easilyupset im_rr_worryalot im_rr_staycalm


**********Correlation + omega

*Factor 1
omega im_rr_expressingthoughts im_rr_liketothink im_rr_talktomanypeople im_rr_activeimagination im_rr_sharefeelings im_rr_newideas im_rr_curious im_rr_inventive

*Factor 2
omega im_rr_completeduties im_rr_appointmentontime im_rr_enthusiastic im_rr_makeplans im_rr_workhard im_rr_workwithother im_rr_organized


*Factor 3
omega im_changemood im_easilydistracted im_putoffduties im_staycalm im_nervous im_rudetoother im_managestress

*Factor 4
omega im_worryalot im_easilyupset im_feeldepressed im_nervous im_shywithpeople im_easilydistracted im_changemood

*Factor 5
omega im_forgiveother im_toleratefaults im_helpfulwithothers im_trustingofother im_talkative im_workwithother im_changemood im_understandotherfeeling im_curious im_repetitivetasks im_interestedbyart im_staycalm im_shywithpeople im_completeduties



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

global perso factor_imcor_1 factor_imcor_2 factor_imcor_3 factor_imcor_4 factor_imcor_5 factor_imcorwith_1 factor_imcorwith_2 factor_imcorwith_3 factor_imcorwith_4 factor_imcorwith_5 factor_imcorwith_6 factor_imraw_1 factor_imraw_2 factor_imraw_3 factor_imraw_4 factor_imraw_5 factor_imrawwith_1 factor_imrawwith_2 factor_imrawwith_3 factor_imrawwith_4 factor_imrawwith_5 factor_imrawwith_6 cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit raven_tt num_tt lit_tt

global expenses savingsamount_HH educationexpenses_HH productexpenses_HH businessexpenses_HH foodexpenses_HH healthexpenses_HH ceremoniesexpenses_HH deathexpenses_HH livestockexpenses_HH chitfundpaymentamount_HH chitfundamount_HH chitfundamounttot_HH nbchitfunds_HH amountlent_HH interestlending_HH problemrepayment_HH goldquantity_HH goldquantitypledge_HH nbinsurance_HH insuranceamount_HH insuranceamounttot_HH insurancebenefitamount_HH insurancebenefitamounttot_HH landpurchased investequiptot_HH 

global all $charactindiv $characthh $wealthindiv $wealthhh $debtindiv $debthh $perso $expenses

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


foreach x in factor_imcor_1 factor_imcor_2 factor_imcor_3 factor_imcor_4 factor_imcor_5 factor_imcorwith_1 factor_imcorwith_2 factor_imcorwith_3 factor_imcorwith_4 factor_imcorwith_5 factor_imcorwith_6 factor_imraw_1 factor_imraw_2 factor_imraw_3 factor_imraw_4 factor_imraw_5 factor_imrawwith_1 factor_imrawwith_2 factor_imrawwith_3 factor_imrawwith_4 factor_imrawwith_5 factor_imrawwith_6 cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit raven_tt num_tt lit_tt{
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

*EFA+Big-5
cls
foreach x in base_factor_imcor_1 base_factor_imcor_2 base_factor_imcor_3 base_factor_imcor_4 base_factor_imcor_5 base_factor_imcorwith_1 base_factor_imcorwith_2 base_factor_imcorwith_3 base_factor_imcorwith_4 base_factor_imcorwith_5 base_factor_imcorwith_6 base_factor_imraw_1 base_factor_imraw_2 base_factor_imraw_3 base_factor_imraw_4 base_factor_imraw_5 base_factor_imrawwith_1 base_factor_imrawwith_2 base_factor_imrawwith_3 base_factor_imrawwith_4 base_factor_imrawwith_5 base_factor_imrawwith_6  {
rename `x' `x'_raw
reg `x' age_1
est store reg_`x'
predict `x', residuals
egen `x'_std=std(`x')
}

/*
esttab reg_base_factor_imraw_1 reg_base_factor_imraw_2 reg_base_factor_imraw_3 reg_base_factor_imraw_4 reg_base_factor_imraw_5 using "_std.csv", ///
	cells(b(fmt(3)) /// 
	t(par fmt(3))) ///
	drop(_cons) ///
	legend label varlabels(_cons constant) ///
	stats(N r2 r2_a F p, fmt(0 3 3 3 3)) ///
	replace
estimates clear
preserve
import delimited "_std.csv", delimiter(",") varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "Stat_desc.xlsx", sheet("EFA_std", replace)
restore
*/

foreach x in base_cr_OP base_cr_CO base_cr_EX base_cr_AG base_cr_ES base_cr_Grit base_OP base_CO base_EX base_AG base_ES base_Grit {
rename `x' `x'_raw
qui reg `x' age_1
est store reg_`x'
predict `x', residuals
egen `x'_std=std(`x')
}

forvalues i=1(1)2 {
foreach x in cr_OP cr_CO cr_ES cr_AG cr_EX cr_Grit OP CO ES AG EX Grit {
qui reg `x'_`i' age_`i'
est store reg_`x'`i'
predict res_`x'_`i', residuals
egen std_`x'_`i'=std(`x'_`i')
}
}

/*
esttab reg_OP1 reg_CO1 reg_ES1 reg_AG1 reg_EX1 reg_OP2 reg_CO2 reg_ES2 reg_AG2 reg_EX2 reg_base_cr_OP reg_base_cr_CO reg_base_cr_EX reg_base_cr_AG reg_base_cr_ES reg_base_OP reg_base_CO reg_base_EX reg_base_AG reg_base_ES using "_std.csv", ///
	cells(b(fmt(3)) /// 
	t(par fmt(3))) ///
	drop(_cons) ///
	legend label varlabels(_cons constant) ///
	stats(N r2 r2_a F p, fmt(0 3 3 3 3)) ///
	replace
estimates clear
preserve
import delimited "_std.csv", delimiter(",") varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "Stat_desc.xlsx", sheet("Big5_std", replace)
restore
*/





/*
label var base_nocorrf1 "Factor 1"
label var base_nocorrf2 "Factor 2"
label var base_nocorrf3 "Factor 3"
label var base_nocorrf4 "Factor 4"
label var base_nocorrf5 "Factor 5"
*/

label var base_cr_OP "OP (corr.)"
label var base_cr_CO "CO (corr.)"
label var base_cr_EX "EX (corr.)"
label var base_cr_AG "AG (corr.)"
label var base_cr_ES "ES (corr.)"
label var base_cr_Grit "Grit (corr.)"

label var base_OP "OP"
label var base_CO "CO"
label var base_EX "EX"
label var base_AG "AG"
label var base_ES "ES"
label var base_Grit "Grit"

label var base_raven_tt "Raven test"
label var base_num_tt "Numeracy test"
label var base_lit_tt "Literacy test"

drop villagenewFE

save"panel_wide", replace
