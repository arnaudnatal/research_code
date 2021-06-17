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
* EFA: 2020
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
foreach x in $big5{
gen im_`x'=`x'
}
global big5im im_curious im_interestedbyart im_repetitivetasks im_inventive im_liketothink im_newideas im_activeimagination im_organized im_makeplans im_workhard im_appointmentontime im_putoffduties im_easilydistracted im_completeduties im_enjoypeople im_sharefeelings im_shywithpeople im_enthusiastic im_talktomanypeople im_talkative im_expressingthoughts im_workwithother im_understandotherfeeling im_trustingofother im_rudetoother im_toleratefaults im_forgiveother im_helpfulwithothers im_managestress im_nervous im_changemood im_feeldepressed im_easilyupset im_worryalot im_staycalm ///
im_tryhard im_stickwithgoals im_goaftergoal im_finishwhatbegin im_finishtasks im_keepworking

forvalues j=1(1)3{
forvalues i=1(1)2{
foreach x in $big5im{
sum `x' if sex==`i' & caste==`j' & egoid!=0 & egoid!=.
replace `x'=r(mean) if `x'==. & sex==`i' & caste==`j' & egoid!=0 & egoid!=.
}
}
}

global big5imwith im_curious im_interestedbyart im_repetitivetasks im_inventive im_liketothink im_newideas im_activeimagination im_organized im_makeplans im_workhard im_appointmentontime im_putoffduties im_easilydistracted im_completeduties im_enjoypeople im_sharefeelings im_shywithpeople im_enthusiastic im_talktomanypeople im_talkative im_expressingthoughts im_workwithother im_understandotherfeeling im_trustingofother im_rudetoother im_toleratefaults im_forgiveother im_helpfulwithothers im_managestress im_nervous im_changemood im_feeldepressed im_easilyupset im_worryalot im_staycalm ///
im_tryhard im_stickwithgoals im_goaftergoal im_finishwhatbegin im_finishtasks im_keepworking

global big5imwithout im_curious im_interestedbyart im_repetitivetasks im_inventive im_liketothink im_newideas im_activeimagination im_organized im_makeplans im_workhard im_appointmentontime im_putoffduties im_easilydistracted im_completeduties im_enjoypeople im_sharefeelings im_shywithpeople im_enthusiastic im_talktomanypeople im_talkative im_expressingthoughts im_workwithother im_understandotherfeeling im_trustingofother im_rudetoother im_toleratefaults im_forgiveother im_helpfulwithothers im_managestress im_nervous im_changemood im_feeldepressed im_easilyupset im_worryalot im_staycalm

/*
minap $big5imwith if sex==1
factor $big5imwith if sex==1, pcf fa(9)  // 6-43
rotate, promax 
putexcel set "EFA_2020.xlsx", modify sheet(with_male)
putexcel (E2)=matrix(e(r_L))
minap $big5imwith if sex==2
factor $big5imwith if sex==2, pcf fa(8)  // 6-44
rotate, promax
putexcel set "EFA_2020.xlsx", modify sheet(with_female)
putexcel (E2)=matrix(e(r_L))
minap $big5imwith
factor $big5imwith, pcf fa(7)  // 6-43
rotate, promax
putexcel set "EFA_2020.xlsx", modify sheet(with_all)
putexcel (E2)=matrix(e(r_L))

minap $big5imwithout if sex==1
factor $big5imwithout if sex==1, pcf fa(8)  // 5-42
rotate, promax
putexcel set "EFA_2020.xlsx", modify sheet(without_male)
putexcel (E2)=matrix(e(r_L))
minap $big5imwithout if sex==2
factor $big5imwithout if sex==2, pcf fa(6)  // 5-43
rotate, promax
putexcel set "EFA_2020.xlsx", modify sheet(without_female)
putexcel (E2)=matrix(e(r_L))
*/
minap $big5imwithout
factor $big5imwithout, pcf fa(5)  // 5-42
rotate, promax
*putexcel set "EFA_2020.xlsx", modify sheet(without_all)
*putexcel (E2)=matrix(e(r_L))
predict f1_2020 f2_2020 f3_2020 f4_2020 f5_2020



*HH size
drop if INDID_left!=.
keep if livinghome==1 | livinghome==2
bysort HHID_panel: gen hhsize=_N

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
replace `x'_r=1 if `x'>=1
}


*Macro for rename

global charactindiv maritalstatus edulevel relationshiptohead sex age readystartjob methodfindjob jobpreference moveoutsideforjob moveoutsideforjobreason aspirationminimumwage dummyaspirationmorehours aspirationminimumwage2 name
 
global characthh villageid villageid_new assets ownland house jatis caste dummymarriage hhsize nbchild nbfemale nbmale dummydemonetisation interviewplace address religion dummyeverhadland

global wealthindiv annualincome_indiv totalincome_indiv mainoccupation_hours_indiv mainoccupation_income_indiv mainoccupation_indiv mainoccupationname_indiv nboccupation_indiv

global wealthhh annualincome_HH totalincome_HH mainoccupation_HH nboccupation_HH foodexpenses healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses marriageexpenses businessexpenses

global debtindiv imp1_ds_tot_indiv imp1_is_tot_indiv semiformal_indiv formal_indiv economic_indiv current_indiv humancap_indiv social_indiv house_indiv incomegen_indiv noincomegen_indiv economic_amount_indiv current_amount_indiv humancap_amount_indiv social_amount_indiv house_amount_indiv incomegen_amount_indiv noincomegen_amount_indiv informal_amount_indiv formal_amount_indiv semiformal_amount_indiv loanamount_indiv dummyproblemtorepay_indiv dummyhelptosettleloan_indiv dummyinterest_indiv loans_indiv loanbalance_indiv marriageloanamount_indiv mean_yratepaid_indiv mean_monthlyinterestrate_indiv nbsavingaccounts savingsamount1 savingsamount2 savingsamount3 savingsamount4 dummydebitcard1 dummydebitcard2 dummydebitcard3 dummydebitcard4 datedebitcard1 datedebitcard2 datedebitcard3 datedebitcard4 dummychitfund amountlent interestlending goldquantity goldquantitypledge nbinsurance dummycreditcard1 dummycreditcard2 dummycreditcard3 dummycreditcard4 nbchitfunds chitfundamount1 chitfundamount2 chitfundamount3 marriageloan_indiv sum_borrowerservices_1_r sum_borrowerservices_2_r sum_borrowerservices_3_r sum_borrowerservices_4_r sum_plantorepay_1_r sum_plantorepay_2_r sum_plantorepay_3_r sum_plantorepay_4_r sum_plantorepay_5_r sum_plantorepay_6_r sum_settleloanstrategy_1_r sum_settleloanstrategy_2_r sum_settleloanstrategy_3_r sum_settleloanstrategy_4_r sum_settleloanstrategy_5_r sum_settleloanstrategy_6_r sum_settleloanstrategy_7_r sum_settleloanstrategy_8_r sum_settleloanstrategy_9_r sum_settleloanstrategy_10_r

global debthh imp1_ds_tot_HH imp1_is_tot_HH informal_HH semiformal_HH formal_HH economic_HH current_HH humancap_HH social_HH house_HH incomegen_HH noincomegen_HH economic_amount_HH current_amount_HH humancap_amount_HH social_amount_HH house_amount_HH incomegen_amount_HH noincomegen_amount_HH informal_amount_HH formal_amount_HH semiformal_amount_HH marriageloanamount_HH loanamount_HH dummyproblemtorepay_HH dummyhelptosettleloan_HH dummyinterest_HH loans_HH loanbalance_HH mean_yratepaid_HH mean_monthlyinterestrate_HH marriageloan_HH

global perso f1_2020 f2_2020 f3_2020 f4_2020 f5_2020 cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit raven_tt num_tt lit_tt

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
foreach x in $big5{
gen im_`x'=`x'
}
global big5im im_curious im_interestedbyart im_repetitivetasks im_inventive im_liketothink im_newideas im_activeimagination im_organized im_makeplans im_workhard im_appointmentontime im_putoffduties im_easilydistracted im_completeduties im_enjoypeople im_sharefeelings im_shywithpeople im_enthusiastic im_talktomanypeople im_talkative im_expressingthoughts im_workwithother im_understandotherfeeling im_trustingofother im_rudetoother im_toleratefaults im_forgiveother im_helpfulwithothers im_managestress im_nervous im_changemood im_feeldepressed im_easilyupset im_worryalot im_staycalm ///
im_tryhard im_stickwithgoals im_goaftergoal im_finishwhatbegin im_finishtasks im_keepworking

forvalues j=1(1)3{
forvalues i=1(1)2{
foreach x in $big5im{
sum `x' if sex==`i' & caste==`j' & egoid!=0 & egoid!=.
replace `x'=r(mean) if `x'==. & sex==`i' & caste==`j' & egoid!=0 & egoid!=.
}
}
}

global big5imwithout im_curious im_interestedbyart im_repetitivetasks im_inventive im_liketothink im_newideas im_activeimagination im_organized im_makeplans im_workhard im_appointmentontime im_putoffduties im_easilydistracted im_completeduties im_enjoypeople im_sharefeelings im_shywithpeople im_enthusiastic im_talktomanypeople im_talkative im_expressingthoughts im_workwithother im_understandotherfeeling im_trustingofother im_rudetoother im_toleratefaults im_forgiveother im_helpfulwithothers im_managestress im_nervous im_changemood im_feeldepressed im_easilyupset im_worryalot im_staycalm


********** No corrected

* no corr. all without
minap $big5imwithout
fsum $big5imwithout, stat(n mean sd)
factor $big5imwithout, pcf fa(5) // 5-56
rotate, promax
*putexcel set "EFA_2016.xlsx", modify sheet(ncorr_without_all)
*putexcel (E2)=matrix(e(r_L))
predict nocorrf1 nocorrf2 nocorrf3 nocorrf4 nocorrf5
estpost correlate nocorrf1 nocorrf2 nocorrf3 nocorrf4 nocorrf5 $big5imwithout, matrix listwise
*esttab using "_corr.csv", unstack not noobs compress cells(b(star fmt(2))) starlevels(* 0.05 ** 0.01 *** 0.001) replace


*Correlation with big-5 and cronbach
estpost correlate cr_OP cr_EX cr_ES cr_CO cr_AG nocorrf1 nocorrf2 nocorrf3 nocorrf4 nocorrf5, matrix listwise
esttab , unstack not noobs compress cells(b(star fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) replace



********** Alpha for traits
**Alpha
*drop if egoid==0
cls

*OP
*alpha curious 		interested~t   repetitive~s inventive liketothink newideas activeimag~n
*alpha cr_curious cr_interested~t   cr_repetitive~s cr_inventive cr_liketothink cr_newideas cr_activeimag~n
omega cr_curious cr_interested~t   cr_repetitive~s cr_inventive cr_liketothink cr_newideas cr_activeimag~n


*CO
*alpha organized  makeplans workhard appointmen~e putoffduties easilydist~d completedu~s
*alpha cr_organized  cr_makeplans cr_workhard cr_appointmen~e cr_putoffduties cr_easilydist~d cr_completedu~s
omega cr_organized  cr_makeplans cr_workhard cr_appointmen~e cr_putoffduties cr_easilydist~d cr_completedu~s
	
	
*EX	
*alpha enjoypeople sharefeeli~s shywithpeo~e  enthusiastic  talktomany~e  talkative expressing~s 
*alpha cr_enjoypeople cr_sharefeeli~s cr_shywithpeo~e  cr_enthusiastic  cr_talktomany~e  cr_talkative cr_expressing~s
omega cr_enjoypeople cr_sharefeeli~s cr_shywithpeo~e  cr_enthusiastic  cr_talktomany~e  cr_talkative cr_expressing~s
	
	
*AG	
*alpha workwithot~r   understand~g trustingof~r rudetoother toleratefa~s  forgiveother  helpfulwit~s
*alpha cr_workwithot~r   cr_understand~g cr_trustingof~r cr_rudetoother cr_toleratefa~s  cr_forgiveother  cr_helpfulwit~s 
omega cr_workwithot~r   cr_understand~g cr_trustingof~r cr_rudetoother cr_toleratefa~s  cr_forgiveother  cr_helpfulwit~s 

	
*ES	
*alpha managestress  nervous  changemood feeldepres~d easilyupset worryalot  staycalm 
*alpha cr_managestress  cr_nervous  cr_changemood cr_feeldepres~d cr_easilyupset cr_worryalot  cr_staycalm
omega cr_managestress  cr_nervous  cr_changemood cr_feeldepres~d cr_easilyupset cr_worryalot  cr_staycalm



**********Correlation + omega
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


********** Other variables
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


********** Keep my sample
fre egoid
drop if egoid==0

*Services and repayment 
global newvar sum_borrowerservices_1 sum_borrowerservices_2 sum_borrowerservices_3 sum_borrowerservices_4 sum_plantorepay_1 sum_plantorepay_2 sum_plantorepay_3 sum_plantorepay_4 sum_plantorepay_5 sum_plantorepay_6 sum_settleloanstrategy_1 sum_settleloanstrategy_2 sum_settleloanstrategy_3 sum_settleloanstrategy_4 sum_settleloanstrategy_5 sum_settleloanstrategy_6 sum_settleloanstrategy_7 sum_settleloanstrategy_8 sum_settleloanstrategy_9 sum_settleloanstrategy_10

foreach x in $newvar{
clonevar `x'_r=`x'
}

foreach x in $newvar{
replace `x'_r=1 if `x'>=1
}


*Macro for rename

global charactindiv maritalstatus edulevel relationshiptohead sex age readystartjob methodfindjob jobpreference moveoutsideforjob moveoutsideforjobreason aspirationminimumwage dummyaspirationmorehours aspirationminimumwage2 name
 
global characthh villageid villageid_new assets ownland house jatis caste dummymarriage hhsize nbchild nbfemale nbmale dummydemonetisation interviewplace address religion dummyeverhadland

global wealthindiv annualincome_indiv totalincome_indiv mainoccupation_hours_indiv mainoccupation_income_indiv mainoccupation_indiv mainoccupationname_indiv nboccupation_indiv

global wealthhh annualincome_HH totalincome_HH mainoccupation_HH nboccupation_HH foodexpenses healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses marriageexpenses businessexpenses

global debtindiv imp1_ds_tot_indiv imp1_is_tot_indiv semiformal_indiv formal_indiv economic_indiv current_indiv humancap_indiv social_indiv house_indiv incomegen_indiv noincomegen_indiv economic_amount_indiv current_amount_indiv humancap_amount_indiv social_amount_indiv house_amount_indiv incomegen_amount_indiv noincomegen_amount_indiv informal_amount_indiv formal_amount_indiv semiformal_amount_indiv loanamount_indiv loanamount_wm_indiv dummyproblemtorepay_indiv dummyhelptosettleloan_indiv dummyinterest_indiv loans_indiv loanbalance_indiv marriageloanamount_indiv mean_yratepaid_indiv mean_monthlyinterestrate_indiv nbsavingaccounts savingsamount1 savingsamount2 savingsamount3 savingsamount4 dummydebitcard1 dummydebitcard2 dummydebitcard3 dummydebitcard4 datedebitcard1 datedebitcard2 datedebitcard3 datedebitcard4 dummychitfund amountlent interestlending goldquantity goldquantitypledge nbinsurance dummycreditcard1 dummycreditcard2 dummycreditcard3 dummycreditcard4 nbchitfunds chitfundamount1 chitfundamount2 marriageloan_indiv sum_borrowerservices_1_r sum_borrowerservices_2_r sum_borrowerservices_3_r sum_borrowerservices_4_r sum_plantorepay_1_r sum_plantorepay_2_r sum_plantorepay_3_r sum_plantorepay_4_r sum_plantorepay_5_r sum_plantorepay_6_r sum_settleloanstrategy_1_r sum_settleloanstrategy_2_r sum_settleloanstrategy_3_r sum_settleloanstrategy_4_r sum_settleloanstrategy_5_r sum_settleloanstrategy_6_r sum_settleloanstrategy_7_r sum_settleloanstrategy_8_r sum_settleloanstrategy_9_r sum_settleloanstrategy_10_r

global debthh imp1_ds_tot_HH imp1_is_tot_HH informal_HH semiformal_HH formal_HH economic_HH current_HH humancap_HH social_HH house_HH incomegen_HH noincomegen_HH economic_amount_HH current_amount_HH humancap_amount_HH social_amount_HH house_amount_HH incomegen_amount_HH noincomegen_amount_HH informal_amount_HH formal_amount_HH semiformal_amount_HH marriageloanamount_HH loanamount_HH loanamount_wm_HH dummyproblemtorepay_HH dummyhelptosettleloan_HH dummyinterest_HH loans_HH loanbalance_HH mean_yratepaid_HH mean_monthlyinterestrate_HH marriageloan_HH

global perso nocorrf1 nocorrf2 nocorrf3 nocorrf4 nocorrf5 cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit raven_tt num_tt lit_tt

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


foreach x in nocorrf1 nocorrf2 nocorrf3 nocorrf4 nocorrf5 cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit raven_tt num_tt lit_tt{
clonevar base_`x'=`x'_1
}




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
foreach x in base_nocorrf1 base_nocorrf2 base_nocorrf3 base_nocorrf4 base_nocorrf5 {
rename `x' `x'_raw
qui reg `x' age_1
est store reg_`x'
predict `x', residuals
egen `x'_std=std(`x')
}

esttab reg_* using "_std.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop(_cons) ///
	legend label varlabels(_cons constant) ///
	stats(N mss df_m rss df_r r2 F p, fmt(0 3 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
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





foreach x in base_cr_OP base_cr_CO base_cr_EX base_cr_AG base_cr_ES base_cr_Grit {
rename `x' `x'_raw
qui reg `x' age_1
predict `x', residuals
egen `x'_std=std(`x')
}


label var base_nocorrf1 "Factor 1"
label var base_nocorrf2 "Factor 2"
label var base_nocorrf3 "Factor 3"
label var base_nocorrf4 "Factor 4"
label var base_nocorrf5 "Factor 5"

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

fsum base_nocorrf1 base_nocorrf2 base_nocorrf3 base_nocorrf4 base_nocorrf5 base_cr_OP base_cr_CO base_cr_EX base_cr_AG base_cr_ES base_cr_Grit base_OP base_CO base_EX base_AG base_ES base_Grit base_raven_tt base_num_tt base_lit_tt

drop villagenewFE

save"panel_wide", replace
