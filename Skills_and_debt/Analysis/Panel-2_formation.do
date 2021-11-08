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
*global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH_v8"
global wave3 "NEEMSIS2-HH_v19"
****************************************
* END







****************************************
* Panel
****************************************
use"$wave3", clear
gen year2020=2020
rename egoid egoid2020
keep HHID_panel INDID_panel egoid2020 year2020
save"$wave3~_temp", replace

use"$wave2", clear
gen year2016=2016
rename egoid egoid2016
keep HHID_panel INDID_panel egoid2016 year2016
merge 1:1 HHID_panel INDID_panel using "$wave3~_temp"
gen panel_indiv=0
replace panel_indiv=1 if _merge==3
drop _merge
save"panel_indiv", replace

****************************************
* END








****************************************
* EFA 2020
****************************************

********** 
use"$wave3", clear
merge 1:1 HHID_panel INDID_panel using "panel_indiv"
keep if panel_indiv==1
keep if egoid>0
keep if egoid2016>0

order HHID_panel INDID_panel ars2 curious cr_curious
sort HHID_panel INDID_panel

********** Imputation for non corrected one
global big5 ///
curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination ///
organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties ///
enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts  ///
workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers ///
managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm ///
tryhard  stickwithgoals   goaftergoal finishwhatbegin finishtasks  keepworking


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

global imcorwith imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm imcr_tryhard imcr_stickwithgoals imcr_goaftergoal imcr_finishwhatbegin imcr_finishtasks imcr_keepworking


global imcor imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm 


********** With grit
minap $imcorwith  // Kaiser=14, minap=2
qui factor $imcorwith, pcf fa(6) 
rotate, promax
putexcel set "EFA_2020.xlsx", modify sheet(imcorwith)
putexcel (E2)=matrix(e(r_L))

predict factor_imcorwith_1 factor_imcorwith_2 factor_imcorwith_3 factor_imcorwith_4 factor_imcorwith_5 factor_imcorwith_6
cpcorr $imcorwith \ factor_imcorwith_1 factor_imcorwith_2 factor_imcorwith_3 factor_imcorwith_4 factor_imcorwith_5 factor_imcorwith_6
matrix list r(p)

*Correlation with big-5 and cronbach
cpcorr cr_OP cr_EX cr_ES cr_CO cr_AG cr_Grit OP EX ES CO AG Grit factor_imcorwith_1 factor_imcorwith_2 factor_imcorwith_3 factor_imcorwith_4 factor_imcorwith_5 factor_imcorwith_6
matrix list r(p)



********** Without grit
minap $imcor
factor $imcor, pcf fa(5) 
rotate, promax
putexcel set "EFA_2020.xlsx", modify sheet(imcor)
putexcel (E2)=matrix(e(r_L))

predict factor_imcor_1 factor_imcor_2 factor_imcor_3 factor_imcor_4 factor_imcor_5
cpcorr $imcor \ factor_imcor_1 factor_imcor_2 factor_imcor_3 factor_imcor_4 factor_imcor_5
matrix list r(p)

*Correlation with big-5 and cronbach
cpcorr cr_OP cr_EX cr_ES cr_CO cr_AG cr_Grit OP EX ES CO AG Grit factor_imcor_1 factor_imcor_2 factor_imcor_3 factor_imcor_4 factor_imcor_5
matrix list r(p)


keep $imcorwith HHID_panel INDID_panel factor_imcorwith_1 factor_imcorwith_2 factor_imcorwith_3 factor_imcorwith_4 factor_imcorwith_5 factor_imcorwith_6 factor_imcor_1 factor_imcor_2 factor_imcor_3 factor_imcor_4 factor_imcor_5



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


save"$wave3~_ego.dta", replace





********** Graph rpz
*** With
set graph off
import excel "EFA_2020.xlsx", sheet("imcorwith") firstrow clear
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
graph combine g_1 g_2 g_3 g_4 g_5 g_6, note("cr items with NEEMSIS-2 (2020-21) data.", size(tiny)) name(comb_cr_with, replace)
graph export "factor2020_cr_with.pdf", as(pdf) replace


* Without
import excel "EFA_2020.xlsx", sheet("imcor") firstrow clear
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
drop var_F`i'
sort n
}
graph combine g_1 g_2 g_3 g_4 g_5, note("cr items with NEEMSIS-2 (2020-21) data.", size(tiny)) name(comb_cr_with, replace)
graph export "factor2020_cr_without.pdf", as(pdf) replace

****************************************
* END














****************************************
* Prepa 2020
****************************************

********** 
use"$wave3", clear
*HH size
drop if INDID_left!=.
keep if livinghome==1 | livinghome==2
bysort HHID_panel: gen hhsize=_N

*
sum loanamount_indiv


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


*** Dependency ratio :
* Debt
gen debtor=0
replace debtor=1 if loanamount_indiv>0 & loanamount_indiv!=.
gen nondebtor=0
replace nondebtor=1 if debtor==0 & debtor!=.

* Worker
gen nonworker=0
replace nonworker=1 if worker==0 & worker!=.

* HH level
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
/*
global newvar sum_borrowerservices_1 sum_borrowerservices_2 sum_borrowerservices_3 sum_borrowerservices_4 sum_plantorepay_1 sum_plantorepay_2 sum_plantorepay_3 sum_plantorepay_4 sum_plantorepay_5 sum_plantorepay_6 sum_settleloanstrategy_1 sum_settleloanstrategy_2 sum_settleloanstrategy_3 sum_settleloanstrategy_4 sum_settleloanstrategy_5 sum_settleloanstrategy_6 sum_settleloanstrategy_7 sum_settleloanstrategy_8 sum_settleloanstrategy_9 sum_settleloanstrategy_10

foreach x in $newvar{
clonevar `x'_r=`x'
}

foreach x in $newvar{
replace `x'_r=1 if `x'>=1 & `x'!=.
}

tab1 sum_borrowerservices_1_r sum_borrowerservices_2_r sum_borrowerservices_3_r sum_borrowerservices_4_r sum_plantorepay_1_r sum_plantorepay_2_r sum_plantorepay_3_r sum_plantorepay_4_r sum_plantorepay_5_r sum_plantorepay_6_r sum_settleloanstrategy_1_r sum_settleloanstrategy_2_r sum_settleloanstrategy_3_r sum_settleloanstrategy_4_r sum_settleloanstrategy_5_r sum_settleloanstrategy_6_r sum_settleloanstrategy_7_r sum_settleloanstrategy_8_r sum_settleloanstrategy_9_r sum_settleloanstrategy_10_r
*/

*Macro for rename
global charactindiv maritalstatus edulevel relationshiptohead sex age readystartjob methodfindjob jobpreference moveoutsideforjob moveoutsideforjobreason aspirationminimumwage dummyaspirationmorehours aspirationminimumwage2 name
 
global characthh villageid assets assets_noland sizeownland ownland house jatis caste dummymarriage hhsize nbchild nbfemale nbmale interviewplace address religion dummyeverhadland

global wealthindiv annualincome_indiv totalincome_indiv mainocc_kindofwork_indiv mainocc_profession_indiv mainocc_occupation_indiv mainocc_annualincome_indiv nboccupation_indiv

global wealthhh annualincome_HH totalincome_HH nboccupation_HH foodexpenses healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses marriageexpenses businessexpenses 

global debtindiv imp1_ds_tot_indiv imp1_is_tot_indiv loanamount_indiv loans_indiv debtor nondebtor worker nonworker

global debthh imp1_ds_tot_HH imp1_is_tot_HH loanamount_HH loans_HH debtorratio workerratio debtorratio2 workerratio2 debtor_HH nondebtor_HH worker_HH nonworker_HH

global perso cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit raven_tt num_tt lit_tt 

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



********** Merge factor
merge 1:1 HHID_panel INDID_panel using "$wave3~_ego.dta"
keep if _merge==3
drop _merge

foreach x in factor_imcorwith_1 factor_imcorwith_2 factor_imcorwith_3 factor_imcorwith_4 factor_imcorwith_5 factor_imcorwith_6 factor_imcor_1 factor_imcor_2 factor_imcor_3 factor_imcor_4 factor_imcor_5 {
rename `x' `x'_2
}

save"$wave3~panel", replace
****************************************
* END















****************************************
* EFA 2016
****************************************

********** 
use"$wave2", clear
merge 1:1 HHID_panel INDID_panel using "panel_indiv"
keep if panel_indiv==1
keep if egoid>0
keep if egoid2020>0


********** Imputation for non corrected one
global big5 ///
curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination ///
organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties ///
enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts  ///
workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers ///
managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm ///
tryhard  stickwithgoals   goaftergoal finishwhatbegin finishtasks  keepworking


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


/*
order HHID_panel INDID_panel cr_curious imcr_curious
sort HHID_panel INDID_panel
preserve
keep if HHID_panel=="KAR20"
*/

global imcorwith imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm imcr_tryhard imcr_stickwithgoals imcr_goaftergoal imcr_finishwhatbegin imcr_finishtasks imcr_keepworking


global imcor imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm 




********** With grit
minap $imcorwith  // Kaiser=14, minap=2
factor $imcorwith, pcf fa(6) 
rotate, promax
putexcel set "EFA_2016.xlsx", modify sheet(imcorwith)
putexcel (E2)=matrix(e(r_L))

predict factor_imcorwith_1 factor_imcorwith_2 factor_imcorwith_3 factor_imcorwith_4 factor_imcorwith_5 factor_imcorwith_6
cpcorr $imcorwith \ factor_imcorwith_1 factor_imcorwith_2 factor_imcorwith_3 factor_imcorwith_4 factor_imcorwith_5 factor_imcorwith_6
matrix list r(p)

*Correlation with big-5 and cronbach
cpcorr cr_OP cr_EX cr_ES cr_CO cr_AG cr_Grit OP EX ES CO AG Grit factor_imcorwith_1 factor_imcorwith_2 factor_imcorwith_3 factor_imcorwith_4 factor_imcorwith_5 factor_imcorwith_6
matrix list r(p)



********** Without grit
minap $imcor
factor $imcor, pcf fa(5) 
rotate, promax
putexcel set "EFA_2016.xlsx", modify sheet(imcor)
putexcel (E2)=matrix(e(r_L))

predict factor_imcor_1 factor_imcor_2 factor_imcor_3 factor_imcor_4 factor_imcor_5
cpcorr $imcor \ factor_imcor_1 factor_imcor_2 factor_imcor_3 factor_imcor_4 factor_imcor_5
matrix list r(p)

*Correlation with big-5 and cronbach
cpcorr cr_OP cr_EX cr_ES cr_CO cr_AG cr_Grit OP EX ES CO AG Grit factor_imcor_1 factor_imcor_2 factor_imcor_3 factor_imcor_4 factor_imcor_5
matrix list r(p)



keep $imcorwith HHID_panel INDID_panel factor_imcorwith_1 factor_imcorwith_2 factor_imcorwith_3 factor_imcorwith_4 factor_imcorwith_5 factor_imcorwith_6 factor_imcor_1 factor_imcor_2 factor_imcor_3 factor_imcor_4 factor_imcor_5



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


save"$wave2~_ego.dta", replace






********** Graph rpz
*** With
set graph off
import excel "EFA_2016.xlsx", sheet("imcorwith") firstrow clear
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
graph combine g_1 g_2 g_3 g_4 g_5 g_6, note("cr items with NEEMSIS-1 (2016-17) data.", size(tiny)) name(comb_cr_with, replace)
graph export "factor2016_cr_with.pdf", as(pdf) replace


* Without
import excel "EFA_2016.xlsx", sheet("imcor") firstrow clear
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
drop var_F`i'
sort n
}
graph combine g_1 g_2 g_3 g_4 g_5, note("cr items with NEEMSIS-1 (2016-17) data.", size(tiny)) name(comb_cr_with, replace)
graph export "factor2016_cr_without.pdf", as(pdf) replace



****************************************
* END













****************************************
* Prepa 2016
****************************************

********** 
use"$wave2", clear
*HH size
keep if livinghome==1 | livinghome==2
/*
drop if egoid==0
duplicates drop HHID_panel, force

2 HH without ego
*/
bysort HHID_panel: gen hhsize=_N

*
sum loanamount_indiv


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


*** Dependency ratio :
* Debt
gen debtor=0
replace debtor=1 if loanamount_indiv>0 & loanamount_indiv!=.
gen nondebtor=0
replace nondebtor=1 if debtor==0 & debtor!=.

* Worker
gen nonworker=0
replace nonworker=1 if worker==0 & worker!=.

* HH level
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


*Services and repayment 
/*
global newvar sum_borrowerservices_1 sum_borrowerservices_2 sum_borrowerservices_3 sum_borrowerservices_4 sum_plantorepay_1 sum_plantorepay_2 sum_plantorepay_3 sum_plantorepay_4 sum_plantorepay_5 sum_plantorepay_6 sum_settleloanstrategy_1 sum_settleloanstrategy_2 sum_settleloanstrategy_3 sum_settleloanstrategy_4 sum_settleloanstrategy_5 sum_settleloanstrategy_6 sum_settleloanstrategy_7 sum_settleloanstrategy_8 sum_settleloanstrategy_9 sum_settleloanstrategy_10

foreach x in $newvar{
clonevar `x'_r=`x'
}

foreach x in $newvar{
replace `x'_r=1 if `x'>=1 & `x'!=.
}

tab1 sum_borrowerservices_1_r sum_borrowerservices_2_r sum_borrowerservices_3_r sum_borrowerservices_4_r sum_plantorepay_1_r sum_plantorepay_2_r sum_plantorepay_3_r sum_plantorepay_4_r sum_plantorepay_5_r sum_plantorepay_6_r sum_settleloanstrategy_1_r sum_settleloanstrategy_2_r sum_settleloanstrategy_3_r sum_settleloanstrategy_4_r sum_settleloanstrategy_5_r sum_settleloanstrategy_6_r sum_settleloanstrategy_7_r sum_settleloanstrategy_8_r sum_settleloanstrategy_9_r sum_settleloanstrategy_10_r
*/

*Macro for rename
global charactindiv maritalstatus edulevel relationshiptohead sex age readystartjob methodfindjob jobpreference moveoutsideforjob moveoutsideforjobreason aspirationminimumwage dummyaspirationmorehours aspirationminimumwage2 name
 
global characthh villageid assets assets_noland sizeownland ownland house jatis caste dummymarriage hhsize nbchild nbfemale nbmale interviewplace address religion dummyeverhadland villageid_new dummydemonetisation

global wealthindiv annualincome_indiv totalincome_indiv mainocc_kindofwork_indiv mainocc_profession_indiv mainocc_occupation_indiv mainocc_annualincome_indiv nboccupation_indiv

global wealthhh annualincome_HH totalincome_HH nboccupation_HH foodexpenses healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses marriageexpenses businessexpenses

global debtindiv imp1_ds_tot_indiv imp1_is_tot_indiv loanamount_indiv loans_indiv debtor nondebtor worker nonworker

global debthh imp1_ds_tot_HH imp1_is_tot_HH loanamount_HH loans_HH debtorratio workerratio debtorratio2 workerratio2 debtor_HH nondebtor_HH worker_HH nonworker_HH

global perso cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit raven_tt num_tt lit_tt 

global expenses savingsamount_HH educationexpenses_HH productexpenses_HH businessexpenses_HH foodexpenses_HH healthexpenses_HH ceremoniesexpenses_HH deathexpenses_HH chitfundpaymentamount_HH chitfundamount_HH chitfundamounttot_HH nbchitfunds_HH amountlent_HH interestlending_HH problemrepayment_HH goldquantity_HH goldquantitypledge_HH nbinsurance_HH insuranceamount_HH insuranceamounttot_HH insurancebenefitamount_HH insurancebenefitamounttot_HH landpurchased investequiptot_HH 

global all $charactindiv $characthh $wealthindiv $wealthhh $debtindiv $debthh $perso $expenses nbercontactphone dummycontactleaders nbcontact_headbusiness nbcontact_policeman nbcontact_civilserv nbcontact_bankemployee nbcontact_panchayatcommittee nbcontact_peoplecouncil nbcontact_recruiter nbcontact_headunion nberpersonfamilyevent associationlist networkhelpkinmember demotrustbank_ego trustneighborhood trustemployees networkpeoplehelping trustingofother_backup

keep $all HHID_panel INDID_panel egoid

*merge m:1 HHID_panel using"$wave3~efa_ego.dta"
*drop _merge

*Rename
foreach x in $all {
rename `x' `x'_1
}

order HHID_panel INDID_panel

preserve
duplicates drop HHID_panel, force
tab caste_1
*Tous les HH ont un égo donc je suis censé en avoir plus car 485 HH en panel avec un peu de chance, 483 sinon minimum !
restore



********** Merge factor
merge 1:1 HHID_panel INDID_panel using "$wave2~_ego.dta"
keep if _merge==3
drop _merge

foreach x in factor_imcorwith_1 factor_imcorwith_2 factor_imcorwith_3 factor_imcorwith_4 factor_imcorwith_5 factor_imcorwith_6 factor_imcor_1 factor_imcor_2 factor_imcor_3 factor_imcor_4 factor_imcor_5 {
rename `x' `x'_1
}

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


merge 1:1 HHID_panel INDID_panel using "$wave3~panel"
rename egoid egoid_2
tab egoid_1 egoid_2, m

order HHID_panel INDID_panel name_1 name_2 _merge
sort HHID_panel INDID_panel

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
drop villageid_2
rename caste_1 caste
rename jatis_1 jatis
drop caste_2 jatis_2



foreach x in factor_imcorwith_1 factor_imcorwith_2 factor_imcorwith_3 factor_imcorwith_4 factor_imcorwith_5 factor_imcorwith_6 factor_imcor_1 factor_imcor_2 factor_imcor_3 factor_imcor_4 factor_imcor_5 cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit raven_tt num_tt lit_tt{
clonevar base_`x'=`x'_1
}



********** Deflate
global amount aspirationminimumwage2_2 aspirationminimumwage_2 businessexpenses_2 marriageexpenses_2 foodexpenses_2 healthexpenses_2 ceremoniesexpenses_2 ceremoniesrelativesexpenses_2 deathexpenses_2 assets_2 assets_noland_2 mainocc_annualincome_indiv_2 annualincome_indiv_2 annualincome_HH_2 totalincome_indiv_2 totalincome_HH_2 imp1_ds_tot_indiv_2 imp1_is_tot_indiv_2 loanamount_indiv_2 imp1_ds_tot_HH_2 imp1_is_tot_HH_2 loanamount_HH_2 savingsamount_HH_2 educationexpenses_HH_2 productexpenses_HH_2 businessexpenses_HH_2 foodexpenses_HH_2 healthexpenses_HH_2 ceremoniesexpenses_HH_2 deathexpenses_HH_2 chitfundpaymentamount_HH_2 chitfundamount_HH_2 chitfundamounttot_HH_2 amountlent_HH_2 insuranceamount_HH_2 insuranceamounttot_HH_2 insurancebenefitamount_HH_2 insurancebenefitamounttot_HH_2

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
recode imp1_ds_tot_indiv_`i' imp1_is_tot_indiv_`i' loanamount_indiv_`i' loans_indiv_`i' (.=0)

recode imp1_ds_tot_HH_`i' imp1_is_tot_HH_`i' loanamount_HH_`i' loans_HH_`i' (.=0)

recode  savingsamount_HH_`i' nbchitfunds_HH_`i' nbinsurance_HH_`i' (.=0)
}




********** Ratio construction
forvalues i=1(1)2{
gen DSR_indiv_`i'=(imp1_ds_tot_indiv_`i'/totalincome_indiv_`i')*100
gen DSR_HH_`i'=(imp1_ds_tot_HH_`i'/totalincome_HH_`i')*100

gen ISR_indiv_`i'=(imp1_is_tot_indiv_`i'/totalincome_indiv_`i')*100
gen ISR_HH_`i'=(imp1_is_tot_HH_`i'/totalincome_HH_`i')*100

gen DAR_indiv_`i'=(loanamount_indiv_`i'/assets_`i')*100
gen DAR_HH_`i'=(loanamount_HH_`i'/assets_`i')*100

gen debtshare_`i'=loanamount_indiv_`i'*100/loanamount_HH_`i'
}


save"panel1.dta", replace


use"panel1.dta", clear
********** Check the 0
tab debtpath


global toclean debtshare loanamount_indiv imp1_ds_tot_indiv imp1_is_tot_indiv DSR_indiv ISR_indiv DAR_indiv annualincome_indiv totalincome_indiv loans_indiv ///
educationexpenses_HH productexpenses_HH businessexpenses_HH foodexpenses_HH healthexpenses_HH ceremoniesexpenses_HH deathexpenses_HH ///
loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH DSR_HH ISR_HH DAR_HH  ///
annualincome_HH totalincome_HH loans_HH

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
drop villagenewFE



**********Standardiser personality traits
cls
foreach x in base_factor_imcorwith_1 base_factor_imcorwith_2 base_factor_imcorwith_3 base_factor_imcorwith_4 base_factor_imcorwith_5 base_factor_imcorwith_6 base_factor_imcor_1 base_factor_imcor_2 base_factor_imcor_3 base_factor_imcor_4 base_factor_imcor_5 base_cr_OP base_cr_CO base_cr_EX base_cr_AG base_cr_ES base_cr_Grit base_OP base_CO base_EX base_AG base_ES base_Grit {
qui reg `x' age_1
predict res_`x', residuals
egen `x'_std=std(res_`x')
}



forvalues i=1(1)2 {
foreach x in cr_OP cr_CO cr_ES cr_AG cr_EX cr_Grit OP CO ES AG EX Grit factor_imcorwith_1 factor_imcorwith_2 factor_imcorwith_3 factor_imcorwith_4 factor_imcorwith_5 factor_imcorwith_6 factor_imcor_1 factor_imcor_2 factor_imcor_3 factor_imcor_4 factor_imcor_5 {
qui reg `x'_`i' age_`i'
predict res_`x'_`i', residuals
}
}

preserve
keep HHID_panel INDID_panel res_cr_OP_1 res_cr_CO_1 res_cr_ES_1 res_cr_AG_1 res_cr_EX_1 res_cr_Grit_1 res_OP_1 res_CO_1 res_ES_1 res_AG_1 res_EX_1 res_Grit_1 res_factor_imcorwith_1_1 res_factor_imcorwith_2_1 res_factor_imcorwith_3_1 res_factor_imcorwith_4_1 res_factor_imcorwith_5_1 res_factor_imcorwith_6_1 res_factor_imcor_1_1 res_factor_imcor_2_1 res_factor_imcor_3_1 res_factor_imcor_4_1 res_factor_imcor_5_1 res_cr_OP_2 res_cr_CO_2 res_cr_ES_2 res_cr_AG_2 res_cr_EX_2 res_cr_Grit_2 res_OP_2 res_CO_2 res_ES_2 res_AG_2 res_EX_2 res_Grit_2 res_factor_imcorwith_1_2 res_factor_imcorwith_2_2 res_factor_imcorwith_3_2 res_factor_imcorwith_4_2 res_factor_imcorwith_5_2 res_factor_imcorwith_6_2 res_factor_imcor_1_2 res_factor_imcor_2_2 res_factor_imcor_3_2 res_factor_imcor_4_2 res_factor_imcor_5_2
egen HHINDID=concat(HHID_panel INDID_panel), p(/)
reshape long res_cr_OP_ res_cr_CO_ res_cr_ES_ res_cr_AG_ res_cr_EX_ res_cr_Grit_ res_OP_ res_CO_ res_ES_ res_AG_ res_EX_ res_Grit_ res_factor_imcorwith_1_ res_factor_imcorwith_2_ res_factor_imcorwith_3_ res_factor_imcorwith_4_ res_factor_imcorwith_5_ res_factor_imcorwith_6_ res_factor_imcor_1_ res_factor_imcor_2_ res_factor_imcor_3_ res_factor_imcor_4_ res_factor_imcor_5_, i(HHINDID) j(num)
tabstat res_cr_OP_ res_cr_CO_ res_cr_ES_ res_cr_AG_ res_cr_EX_ res_cr_Grit_, stat(n mean sd p50)
tabstat res_OP_ res_CO_ res_ES_ res_AG_ res_EX_ res_Grit_, stat(n mean sd p50)
tabstat res_factor_imcorwith_1_ res_factor_imcorwith_2_ res_factor_imcorwith_3_ res_factor_imcorwith_4_ res_factor_imcorwith_5_ res_factor_imcorwith_6_, stat(n mean sd p50)
tabstat res_factor_imcor_1_ res_factor_imcor_2_ res_factor_imcor_3_ res_factor_imcor_4_ res_factor_imcor_5_, stat(n mean sd p50)
restore

/*
forvalues i=1(1)2 {
foreach x in cr_OP cr_CO cr_ES cr_AG cr_EX cr_Grit OP CO ES AG EX Grit {
egen std_each_`x'_`i'=std(res_`x'_`i')
}
}
*/

forvalues i=1(1)2 {
gen std_cr_OP_`i'=(res_cr_OP_`i'-6.40e-10)/.4695055
gen std_cr_CO_`i'=(res_cr_CO_`i'-7.94e-10)/.5901779
gen std_cr_ES_`i'=(res_cr_ES_`i'-5.04e-10)/.7104544
gen std_cr_AG_`i'=(res_cr_AG_`i'-7.99e-11)/.40031
gen std_cr_EX_`i'=(res_cr_EX_`i'+6.93e-10)/.4683449
gen std_cr_Grit_`i'=(res_cr_Grit_`i'-2.53e-10)/.5564151

gen std_OP_`i'=(res_OP_`i'+2.70e-10)/.5761487
gen std_CO_`i'=(res_CO_`i'-8.53e-10)/.5596447
gen std_ES_`i'=(res_ES_`i'+1.75e-10)/.4514791
gen std_AG_`i'=(res_AG_`i'+4.30e-10)/.4752377
gen std_EX_`i'=(res_EX_`i'+6.33e-10)/.5666251
gen std_Grit_`i'=(res_Grit_`i'+4.08e-09)/.6034942

gen std_f1_crwith_`i'=(res_factor_imcorwith_1_`i'+1.00e-10)/.9967619
gen std_f2_crwith_`i'=(res_factor_imcorwith_2_`i'+1.42e-09)/.9993092
gen std_f3_crwith_`i'=(res_factor_imcorwith_3_`i'+1.01e-09)/.9888102
gen std_f4_crwith_`i'=(res_factor_imcorwith_4_`i'-7.09e-10)/.9908982
gen std_f5_crwith_`i'=(res_factor_imcorwith_5_`i'+1.24e-09)/.990863
gen std_f6_crwith_`i'=(res_factor_imcorwith_6_`i'-9.05e-10)/.9808956

gen std_f1_cr_`i'=(res_factor_imcor_1_`i'+7.24e-10)/.993121
gen std_f2_cr_`i'=(res_factor_imcor_2_`i'+1.10e-09)/1.000836
gen std_f3_cr_`i'=(res_factor_imcor_3_`i'+3.41e-10)/.9884444 
gen std_f4_cr_`i'=(res_factor_imcor_4_`i'-3.04e-10)/.9959425
gen std_f5_cr_`i'=(res_factor_imcor_5_`i'+2.63e-10)/.9958991
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

label var base_factor_imcorwith_1_std "CO-GR (std)"
label var base_factor_imcorwith_2_std "ES (std)"
label var base_factor_imcorwith_3_std "OP-EX (std)"
label var base_factor_imcorwith_4_std "AG-EX (std)"
label var base_factor_imcorwith_5_std "ES-CO (std)"
label var base_factor_imcorwith_6_std "AG (std)"

label var base_factor_imcor_1_std "CO (std)"
label var base_factor_imcor_2_std "ES (std)"
label var base_factor_imcor_3_std "EX-OP (std)"
label var base_factor_imcor_4_std "ES-CO (std)"
label var base_factor_imcor_5_std "AG (std)"


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
tabstat res_raven_tt_ res_lit_tt_ res_num_tt_, stat(n mean sd p50)
/*
   stats |  res_ra~_  res_li~_  res_nu~_
---------+------------------------------
       N |      1646      1614      1645
    mean | -8.27e-09  3.21e-09  1.12e-09
      sd |  7.733731  1.563907  1.607305
     p50 | -1.739282 -.0899114 -.0593502
----------------------------------------
*/
restore

forvalues i=1(1)2 {
gen std_raven_tt_`i'=(res_raven_tt_`i'+8.27e-09)/7.733731
gen std_lit_tt_`i'=(res_lit_tt_`i'-3.21e-09)/1.563907
gen std_num_tt_`i'=(res_num_tt_`i'-1.12e-09)/1.607305
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

tab mainocc_occupation_indiv_1,gen(cat_mainocc_occupation_indiv_1_)
label var cat_mainocc_occupation_indiv_1_1 "MO: No occ."
label var cat_mainocc_occupation_indiv_1_2 "MO: Agri"
label var cat_mainocc_occupation_indiv_1_3 "MO: Agri coolie"
label var cat_mainocc_occupation_indiv_1_4 "MO: Coolie"
label var cat_mainocc_occupation_indiv_1_5 "MO: Reg non-quali"
label var cat_mainocc_occupation_indiv_1_6 "MO: Reg quali"
label var cat_mainocc_occupation_indiv_1_7 "MO: SE"
label var cat_mainocc_occupation_indiv_1_8 "MO: NREGA"


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
foreach x in loanamount_indiv loanamount_HH imp1_ds_tot_indiv imp1_ds_tot_HH imp1_is_tot_indiv imp1_is_tot_HH annualincome_indiv annualincome_HH totalincome_indiv {
gen `x'1000_1=`x'_1/1000 
gen `x'1000_2=`x'_2/1000 
}

********** Recoder les dummy
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


********** Variation de la dette
global delta delta_debtshare delta_loanamount_indiv delta_imp1_ds_tot_indiv delta_imp1_is_tot_indiv delta_DSR_indiv delta_ISR_indiv delta_DAR_indiv delta_annualincome_indiv delta_totalincome_indiv delta_loans_indiv delta_educationexpenses_HH delta_productexpenses_HH delta_businessexpenses_HH delta_foodexpenses_HH delta_healthexpenses_HH delta_ceremoniesexpenses_HH delta_deathexpenses_HH delta_loanamount_HH delta_imp1_ds_tot_HH delta_imp1_is_tot_HH delta_DSR_HH delta_ISR_HH delta_DAR_HH delta_annualincome_HH delta_totalincome_HH delta_loans_HH
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


/*
foreach x in $delta {
forvalues i=1(1)5 {
gen `x'_f`i'=bin_`x'*base_factor_imraw_`i'_std
}
gen `x'_r1=bin_`x'*base_raven_tt
gen `x'_n1=bin_`x'*base_num_tt
gen `x'_l1=bin_`x'*base_lit_tt
}
*/



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
foreach x in debtshare {
forvalues i=1(1)2{
clonevar `x'_`i'_old=`x'_`i'
}
}

foreach x in debtshare {
forvalues i=1(1)2{
replace `x'_`i'=`x'_`i'/100
}
}

recode dummymultipleoccupation_indiv_1 (.=0)
label var dummymultipleoccupation_indiv_1 "Multiple occupation (=1)"


********** Variation rate of personality
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

foreach x in base_raven_tt_std base_factor_imcorwith_3_std base_cr_OP_std base_OP_std base_num_tt_std base_lit_tt_std base_cr_Grit_std base_Grit_std base_factor_imcor_3_std base_cr_EX_std base_EX_std base_factor_imcorwith_5_std base_factor_imcor_4_std base_cr_ES_std base_factor_imcorwith_2_std base_factor_imcor_2_std base_ES_std base_factor_imcorwith_1_std base_cr_CO_std base_factor_imcor_1_std base_CO_std base_factor_imcorwith_4_std base_cr_AG_std base_factor_imcorwith_6_std base_factor_imcor_5_std base_AG_std {
gen fem_`x'=`x'*female
gen dal_`x'=`x'*dalits
gen thr_`x'=`x'*female*dalits
}
gen femXdal=female*dalits

drop over30_indiv_2 over40_indiv_2

gen over30_indiv_2=0
replace over30_indiv_2=1 if DSR_indiv_2>=30

gen over40_indiv_2=0
replace over40_indiv_2=1 if DSR_indiv_2>=40

gen over50_indiv_2=0
replace over50_indiv_2=1 if DSR_indiv_2>=50



save"panel_wide_v2", replace
****************************************
* END





/*
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
