cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
July 22, 2022
-----
Revue d'Économie du Développement : Naïve correlation between debt and psychology
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
global directory = "C:\Users\Arnaud\Documents\_Thesis\Research-Skills_and_debt\Analysis"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

set scheme plotplain 

*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
*set scheme plotplain

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"



********** Name of the NEEMSIS2 questionnaire version to clean
*global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH"
global wave3 "NEEMSIS2-HH"

global loan "NEEMSIS2-all_loans"
****************************************
* END








****************************************
* EFA 2020
****************************************

********** 
use"$wave3", clear
keep if egoid>0

order HHID_panel INDID_panel ars2 curious cr_curious
sort HHID_panel INDID_panel

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


global imcor imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm 


/*
********** Without grit
minap $imcor
factor $imcor, pcf fa(5) 
rotate, oblimin
putexcel set "EFA_2020.xlsx", modify sheet(imcor)
putexcel (E2)=matrix(e(r_L))
*/

********** Omega with Laajaj approach for factor analysis and Cobb Clark
** F1
global f1 imcr_worryalot imcr_easilydistracted imcr_feeldepressed imcr_easilyupset imcr_changemood imcr_repetitivetasks imcr_nervous imcr_putoffduties imcr_shywithpeople imcr_rudetoother imcr_enjoypeople imcr_toleratefaults
** F2
global f2 imcr_workhard imcr_enthusiastic imcr_talktomanypeople imcr_appointmentontime imcr_forgiveother imcr_expressingthoughts imcr_interestedbyart imcr_newideas imcr_understandotherfeeling imcr_makeplans imcr_completeduties
** F3
global f3 imcr_trustingofother imcr_inventive imcr_liketothink imcr_curious imcr_sharefeelings imcr_workwithother
** F4
global f4 imcr_organized imcr_helpfulwithothers imcr_staycalm imcr_activeimagination imcr_talkative


*** Omega
cls
omegacoef $f1
omegacoef $f2
omegacoef $f3
omegacoef $f4

***** Big-5
*OP
global OP imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination

*CO
global CO imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties

*EX
global EX imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts 

*AG
global AG imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers

*ES
global ES imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm

*Grit
global Grit imcr_tryhard imcr_stickwithgoals imcr_goaftergoal imcr_finishwhatbegin imcr_finishtasks imcr_keepworking

omegacoef $OP
omegacoef $CO
omegacoef $EX
omegacoef $AG
omegacoef $ES
omegacoef $Grit


*** Score
egen f1_2020=rowmean($f1)
egen f2_2020=rowmean($f2)
egen f3_2020=rowmean($f3)
egen f4_2020=rowmean($f4)




***** Save
save"$wave3~_ego_RED.dta", replace






********** Locus of control
use"$wave3~_ego_RED.dta", clear

/*
1. I like taking responsibility.
2. I find it best to make decisions by myself rather than to rely on fate.
3. When I encounter problems or opposition, I usually find ways and means to overcome them.
4. Success often depends more on luck than on effort.
5. I often have the feeling that I have little influence over what happens to me.
6. When I make important decisions, I often look at what others have done.
*/

global locus locuscontrol1 locuscontrol2 locuscontrol3 locuscontrol4 locuscontrol5 locuscontrol6
fre $locus



***** Internal consistency
omegacoef $locus  // .81


***** Reverse locuscontrol4 5 6 for min=intern and max=extern as locuscontrol1 2 3
forvalues i=4(1)6 {
vreverse locuscontrol`i', gen(locuscontrol`i'_rv)
}


***** Imputation
global locus2 locuscontrol1 locuscontrol2 locuscontrol3 locuscontrol4_rv locuscontrol5_rv locuscontrol6_rv
foreach x in $locus2{
gen im`x'=`x'
}
forvalues j=1(1)3{
forvalues i=1(1)2{
foreach x in $locus2{
qui sum im`x' if sex==`i' & caste==`j' & egoid!=0 & egoid!=.
replace im`x'=r(mean) if im`x'==. & sex==`i' & caste==`j' & egoid!=0 & egoid!=.
}
}
} 

* Verification
global imlocus2 imlocuscontrol1 imlocuscontrol2 imlocuscontrol3 imlocuscontrol4_rv imlocuscontrol5_rv imlocuscontrol6_rv

omegacoef $imlocus2  // 0.81

* Score
egen locus=rowmean($imlocus2)
replace locus=round(locus, .01)
label var locus "intern -3-> extern"

tabstat locus, stat(n mean sd p50) by(sex)
ta locus
gen locuscat=.
replace locuscat=1 if locus<3
replace locuscat=2 if locus==3
replace locuscat=3 if locus>3

label define locuscast 1"Intern" 2"Mid" 3"Extern"
label values locuscat locuscat

ta locus locuscat

***** Save
save"$wave3~_ego_v2_RED.dta", replace

/*
stripplot locus, over(sex) by(caste, title("`1'")) vert ///
stack width(1) jitter(0) ///
box(barw(1)) boffset(-0.3) pctile(10) ///
ms(oh oh oh) msize(small) mc(blue%30) ///
yla(, ang(h)) xla(, noticks)
*/
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

/*
*Savings
egen savingsamount_temp_HH=rowtotal(savingsamount1 savingsamount2 savingsamount3 savingsamount4)
bysort HHID_panel: egen savingsamount_HH=sum(savingsamount_temp_HH)
*/

*Expenses
bysort HHID_panel: egen educationexpenses_HH=sum(educationexpenses)
egen productexpenses_HH=rowtotal(productexpenses9 productexpenses5 productexpenses4 productexpenses3 productexpenses2 productexpenses14 productexpenses12 productexpenses11 productexpenses1)
bysort HHID_panel: egen businessexpenses_HH=sum(businessexpenses)
gen foodexpenses_HH=foodexpenses*52
gen healthexpenses_HH=healthexpenses
gen ceremoniesexpenses_HH=ceremoniesexpenses
gen deathexpenses_HH=deathexpenses

/*
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
*/

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




********** cov
fre covsellland covselllivestock_none covsellequipment_none covsellgoods_none covsellhouse covsellplot
destring covsellland covsellhouse covsellplot, replace
recode covsellland covsellhouse covsellplot (66=0) (2=0)
recode covselllivestock_none covsellequipment_none covsellgoods_none (0=1) (1=0)
egen covsell=rowtotal(covsellland covselllivestock_none covsellequipment_none covsellgoods_none covsellhouse covsellplot)
replace covsell=1 if covsell>=1 & covsell!=.
ta covsell


/*
*Services and repayment 
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

global wealthindiv annualincome_indiv totalincome_indiv mainocc_kindofwork_indiv mainocc_profession_indiv mainocc_occupation_indiv mainocc_annualincome_indiv nboccupation_indiv loanamount_indiv

global wealthhh annualincome_HH totalincome_HH nboccupation_HH foodexpenses healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses marriageexpenses businessexpenses 

*global debtindiv imp1_ds_tot_indiv imp1_is_tot_indiv loanamount_indiv loans_indiv debtor nondebtor worker nonworker sum_borrowerservices_1_r sum_borrowerservices_2_r sum_borrowerservices_3_r sum_borrowerservices_4_r sum_plantorepay_1_r sum_plantorepay_2_r sum_plantorepay_3_r sum_plantorepay_4_r sum_plantorepay_5_r sum_plantorepay_6_r sum_settleloanstrategy_1_r sum_settleloanstrategy_2_r sum_settleloanstrategy_3_r sum_settleloanstrategy_4_r sum_settleloanstrategy_5_r sum_settleloanstrategy_6_r sum_settleloanstrategy_7_r sum_settleloanstrategy_8_r sum_settleloanstrategy_9_r sum_settleloanstrategy_10_r dummyhelptosettleloan_indiv dummyproblemtorepay_indiv dummyinterest_indiv

*global debthh imp1_ds_tot_HH imp1_is_tot_HH loanamount_HH loans_HH debtorratio workerratio debtorratio2 workerratio2 debtor_HH nondebtor_HH worker_HH nonworker_HH

global perso cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit Grit raven_tt num_tt lit_tt 

global expenses educationexpenses_HH productexpenses_HH businessexpenses_HH foodexpenses_HH healthexpenses_HH ceremoniesexpenses_HH deathexpenses_HH  landpurchased investequiptot_HH 

global all $charactindiv $characthh $wealthindiv $wealthhh $debtindiv $debthh $perso $expenses nbercontactphone networkhelpkinmember

keep $all HHID_panel INDID_panel egoid covsell

order HHID_panel INDID_panel



********** Merge factor
merge 1:1 HHID_panel INDID_panel using "$wave3~_ego_v2_RED.dta"
keep if _merge==3
drop _merge


save"$wave3~_RED", replace
****************************************
* END













****************************************
* Correlation with recourse and amount of debt
****************************************

********** 
use"$wave3~_RED", clear

********** Var crea + transfo
rename loanamount_indiv loanamount
replace loanamount=loanamount/1000
replace loanamount=. if loanamount==0

gen dummydebt=.
replace dummydebt=1 if loanamount>0
replace dummydebt=0 if loanamount==0
replace dummydebt=0 if loanamount==.

gen logloanamount=log(loanamount)




********** Recourse
ta locuscat dummydebt, col nofreq
ta locuscat dummydebt, row nofreq
*Nothing




********** Intensity
tabstat loanamount, stat(n mean sd p50) by(locuscat)
tabstat loanamount, stat(min p1 p5 p10 q p90 p95 p99 max) by(locuscat)

oneway loanamount locuscat

reg loanamount ib(2).locuscat i.sex i.caste i.edulevel, baselevel 
reg loanamount locus i.sex i.caste i.edulevel, baselevel



********** Graph
twoway ///
(kdensity loanamount if locuscat==1, bwidth(30)) ///
(kdensity loanamount if locuscat==2, bwidth(30)) ///
(kdensity loanamount if locuscat==3, bwidth(30))



****************************************
* END






