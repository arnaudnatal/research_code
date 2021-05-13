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

merge m:1 HHID2010 using "panel", nogen keep(3)
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

save"$wave3~efa", replace

****************************************
* END











****************************************
* EFA 2016
****************************************

********** 
use"$wave2", clear

global big5with ///
curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination ///
organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties ///
enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts  ///
workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers ///
managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm ///
tryhard  stickwithgoals   goaftergoal finishwhatbegin finishtasks  keepworking

global big5without ///
curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination ///
organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties ///
enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts  ///
workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers ///
managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm 

global big5crwith cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm cr_tryhard  cr_stickwithgoals   cr_goaftergoal cr_finishwhatbegin cr_finishtasks  cr_keepworking

global big5crwithout cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm

********** No corrected
/*
* no corr. male without
minap $big5without if sex==1
factor $big5without if sex==1, pcf fa(5) // 5-56
rotate, promax
putexcel set "EFA_2016.xlsx", modify sheet(ncorr_without_male)
putexcel (E2)=matrix(e(r_L))

* no corr. female without
minap $big5without if sex==2
factor $big5without if sex==2, pcf fa(5) // 5-56
rotate, promax
putexcel set "EFA_2016.xlsx", modify sheet(ncorr_without_female)
putexcel (E2)=matrix(e(r_L))
*/

* no corr. all without
minap $big5without
factor $big5without, pcf fa(5) // 5-56
rotate, promax
*putexcel set "EFA_2016.xlsx", modify sheet(ncorr_without_all)
*putexcel (E2)=matrix(e(r_L))
predict nocorrf1 nocorrf2 nocorrf3 nocorrf4 nocorrf5

/*
* no corr. male with
minap $big5with if sex==1
factor $big5with if sex==1, pcf fa(6) // 6-57
rotate, promax
putexcel set "EFA_2016.xlsx", modify sheet(ncorr_with_male)
putexcel (E2)=matrix(e(r_L))

* no corr. female with
minap $big5with if sex==2
factor $big5with if sex==2, pcf fa(6) // 6-56
rotate, promax
putexcel set "EFA_2016.xlsx", modify sheet(ncorr_with_female)
putexcel (E2)=matrix(e(r_L))

* no corr. all with
minap $big5with
factor $big5with, pcf fa(6) // 6-56
rotate, promax
putexcel set "EFA_2016.xlsx", modify sheet(ncorr_with_all)
putexcel (E2)=matrix(e(r_L))
*/



********** Corrected
/*
* corr. male without
minap $big5crwithout if sex==1
factor $big5crwithout if sex==1, pcf fa(5) // 5-55
rotate, promax
putexcel set "EFA_2016.xlsx", modify sheet(corr_without_male)
putexcel (E2)=matrix(e(r_L))

* corr. female without
minap $big5crwithout if sex==2
factor $big5crwithout if sex==2, pcf fa(5) // 5-53
rotate, promax
putexcel set "EFA_2016.xlsx", modify sheet(corr_without_female)
putexcel (E2)=matrix(e(r_L))
*/

* corr. all without
minap $big5crwithout
factor $big5crwithout, pcf fa(5) // 5-54
rotate, promax
*putexcel set "EFA_2016.xlsx", modify sheet(corr_without_all)
*putexcel (E2)=matrix(e(r_L))
predict corrf1 corrf2 corrf3 corrf4 corrf5


/*
* corr. male with
minap $big5crwith if sex==1
factor $big5crwith if sex==1, pcf fa(6) // 6-56
rotate, promax
putexcel set "EFA_2016.xlsx", modify sheet(corr_with_male)
putexcel (E2)=matrix(e(r_L))

* corr. female with
minap $big5crwith if sex==2
factor $big5crwith if sex==2, pcf fa(6) // 6-55
rotate, promax
putexcel set "EFA_2016.xlsx", modify sheet(corr_with_female)
putexcel (E2)=matrix(e(r_L))

* corr. all with
minap $big5crwith
factor $big5crwith, pcf fa(6) // 6-55
rotate, promax
putexcel set "EFA_2016.xlsx", modify sheet(corr_with_all)
putexcel (E2)=matrix(e(r_L))
*/


save "$wave2~efa", replace
****************************************
* END











****************************************
* Prépa 2016
****************************************

********** 
use"$wave2~efa", clear

*HH size
keep if livinghome==1 | livinghome==2
bysort HHID2010: gen hhsize=_N

*Nb children
gen child=0
replace child=1 if age<=14
bysort HHID2010: egen nbchild=sum(child)

*Sex ratio
gen female=0
gen male=0
replace female=1 if sex==2
replace male=1 if sex==1
bysort HHID2010: egen nbfemale=sum(female)
bysort HHID2010: egen nbmale=sum(male)

*Only ego
fre egoid
drop if egoid==0

rename loanamount_indiv loanamountmar_indiv
rename loanamount_HH loanamountmar_HH

rename loanamountnomar_indiv loanamount_indiv
rename loanamountnomar_HH loanamount_HH


*Rename
foreach x in villageid edulevel annualincome_indiv annualincome_HH villageid_new imp1_ds_tot_indiv imp1_is_tot_indiv semiformal_indiv formal_indiv economic_indiv current_indiv humancap_indiv social_indiv house_indiv incomegen_indiv noincomegen_indiv economic_amount_indiv current_amount_indiv humancap_amount_indiv social_amount_indiv house_amount_indiv incomegen_amount_indiv noincomegen_amount_indiv informal_amount_indiv formal_amount_indiv semiformal_amount_indiv marriageloan_indiv marriageloanamount_indiv marriageloan_mar_indiv marriageloanamount_mar_indiv marriageloan_fin_indiv marriageloanamount_fin_indiv dummyproblemtorepay_indiv dummyhelptosettleloan_indiv dummyinterest_indiv loans_indiv loanamount_indiv loanbalance_indiv loanamountmar_indiv imp1_ds_tot_HH imp1_is_tot_HH informal_HH semiformal_HH formal_HH economic_HH current_HH humancap_HH social_HH house_HH incomegen_HH noincomegen_HH economic_amount_HH current_amount_HH humancap_amount_HH social_amount_HH house_amount_HH incomegen_amount_HH noincomegen_amount_HH informal_amount_HH formal_amount_HH semiformal_amount_HH marriageloan_HH marriageloanamount_HH marriageloan_mar_HH marriageloanamount_mar_HH marriageloan_fin_HH marriageloanamount_fin_HH dummyproblemtorepay_HH dummyhelptosettleloan_HH dummyinterest_HH loans_HH loanamount_HH loanbalance_HH loanamountmar_HH nocorrf1 nocorrf2 nocorrf3 nocorrf4 nocorrf5 corrf1 corrf2 corrf3 corrf4 corrf5 cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit raven_tt num_tt lit_tt assets ownland house totalincome_indiv totalincome_HH mainoccupation_hours_indiv mainoccupation_income_indiv mainoccupation_indiv mainoccupationname_indiv nboccupation_indiv mainoccupation_HH nboccupation_HH relationshiptohead jatis caste sex age foodexpenses healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses marriageexpenses businessexpenses dummymarriage hhsize nbchild nbfemale nbmale readystartjob methodfindjob jobpreference moveoutsideforjob moveoutsideforjobreason aspirationminimumwage dummyaspirationmorehours aspirationminimumwage2 dummydemonetisation name interviewplace address religion mean_yratepaid_indiv mean_monthlyinterestrate_indiv mean_yratepaid_HH mean_monthlyinterestrate_HH{
rename `x' `x'_1
}


keep *_1 HHID2010 INDID egoid HHID_panel

save"$wave2~panel", replace
****************************************
* END











****************************************
* Prépa 2020
****************************************

********** 
use"$wave3~efa", clear

*HH size
keep if livinghome==1 | livinghome==2
bysort HHID2010: gen hhsize=_N

*Nb children
gen child=0
replace child=1 if age<=14
bysort HHID2010: egen nbchild=sum(child)

*Sex ratio
gen female=0
gen male=0
replace female=1 if sex==2
replace male=1 if sex==1
bysort HHID2010: egen nbfemale=sum(female)
bysort HHID2010: egen nbmale=sum(male)

*Only ego
fre egoid
drop if egoid==0

*Rename
foreach x in edulevel annualincome_indiv annualincome_HH villageid villageid_new imp1_ds_tot_indiv imp1_is_tot_indiv semiformal_indiv formal_indiv economic_indiv current_indiv humancap_indiv social_indiv house_indiv incomegen_indiv noincomegen_indiv economic_amount_indiv current_amount_indiv humancap_amount_indiv social_amount_indiv house_amount_indiv incomegen_amount_indiv noincomegen_amount_indiv informal_amount_indiv formal_amount_indiv semiformal_amount_indiv marriageloan_indiv marriageloanamount_indiv marriageloan_mar_indiv marriageloanamount_mar_indiv marriageloan_fin_indiv marriageloanamount_fin_indiv dummyproblemtorepay_indiv dummyhelptosettleloan_indiv dummyinterest_indiv loans_indiv loanamount_indiv loanbalance_indiv imp1_ds_tot_HH imp1_is_tot_HH informal_HH semiformal_HH formal_HH economic_HH current_HH humancap_HH social_HH house_HH incomegen_HH noincomegen_HH economic_amount_HH current_amount_HH humancap_amount_HH social_amount_HH house_amount_HH incomegen_amount_HH noincomegen_amount_HH informal_amount_HH formal_amount_HH semiformal_amount_HH marriageloan_HH marriageloanamount_HH marriageloan_mar_HH marriageloanamount_mar_HH marriageloan_fin_HH marriageloanamount_fin_HH dummyproblemtorepay_HH dummyhelptosettleloan_HH dummyinterest_HH loans_HH loanamount_HH loanbalance_HH cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit raven_tt num_tt lit_tt assets ownland house totalincome_indiv totalincome_HH mainoccupation_hours_indiv mainoccupation_income_indiv mainoccupation_indiv mainoccupationname_indiv nboccupation_indiv mainoccupation_HH nboccupation_HH relationshiptohead jatis caste sex age foodexpenses healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses marriageexpenses businessexpenses dummymarriage hhsize nbchild nbfemale nbmale readystartjob methodfindjob jobpreference moveoutsideforjob moveoutsideforjobreason moveoutsideforjobreasonother dummyaspirationmorehours aspirationminimumwage2 aspirationminimumwage name interviewplace address religion mean_yratepaid_indiv mean_monthlyinterestrate_indiv mean_yratepaid_HH mean_monthlyinterestrate_HH{
rename `x' `x'_2
}

keep *_2 HHID2010 INDID egoid HHID_panel

save"$wave3~panel", replace
****************************************
* END











****************************************
* Formation
****************************************

**********
use"$wave2~panel", clear
merge 1:1 HHID2010 INDID using "$wave3~panel"
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
egen HHINDID=concat(HHID2010 INDID), p(/)
encode HHINDID, gen(panelvar)
encode HHID2010, gen(HHFE)
encode villageid_new, gen(villagenewFE)
drop villageid_2 villageid_new_2
rename caste_1 caste
rename jatis_1 jatis
drop caste_2 jatis_2


foreach x in nocorrf1 nocorrf2 nocorrf3 nocorrf4 nocorrf5 corrf1 corrf2 corrf3 corrf4 corrf5 cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit raven_tt num_tt lit_tt{
clonevar base_`x'=`x'_1
}

********** Verifications
gen test1=sex_2-sex_1
tab test1

gen test2=age_2-age_1
tab test2


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

tab1 indebt_indiv_1 indebt_indiv_2 indebt_HH_1 indebt_HH_2

recode loanamount_indiv_1 loanamount_HH_1 loanamount_indiv_2 loanamount_HH_2 (0=.)

tab indebt_indiv_1 indebt_indiv_2
gen reallyindebt=0 if indebt_indiv_1==0 & indebt_indiv_2==0
replace reallyindebt=1 if indebt_indiv_1==1 & indebt_indiv_2==0
replace reallyindebt=2 if indebt_indiv_1==0 & indebt_indiv_2==1
replace reallyindebt=3 if indebt_indiv_1==1 & indebt_indiv_2==1
label define reallyindebt 0"Never in debt" 1"Out of debt" 2"Becomes in debt" 3"Always in debt"
label values reallyindebt reallyindebt
tab reallyindebt
rename reallyindebt debtpath


********** Total income for indiv (zero issue)
*2016
tab totalincome_indiv_1 if totalincome_indiv_1!=0
replace totalincome_indiv_1=1000 if totalincome_indiv_1<1000
tab totalincome_indiv_1
*2020
tab totalincome_indiv_2 if totalincome_indiv_2!=0
replace totalincome_indiv_2=1000 if totalincome_indiv_2<1000
tab totalincome_indiv_2


********** Total income for HH
*2016 
tab totalincome_HH_1
*2020
tab totalincome_HH_2
replace totalincome_HH_2=2000 if totalincome_HH_2<2000


********** Recode everything
forvalues i=1(1)2{
recode imp1_ds_tot_indiv_`i' imp1_is_tot_indiv_`i' loanamount_indiv_`i' imp1_ds_tot_HH_`i' imp1_is_tot_HH_`i' loanamount_HH_`i' formal_amount_indiv_`i' formal_amount_HH_`i' informal_amount_indiv_`i' informal_amount_HH_`i' semiformal_amount_indiv_`i' semiformal_amount_HH_`i' incomegen_indiv_`i' incomegen_HH_`i' noincomegen_indiv_`i' noincomegen_HH_`i' (.=0)
}



********** Ratio construction
forvalues i=1(1)2{
gen DSR_indiv_`i'=(imp1_ds_tot_indiv_`i'/totalincome_indiv_`i')*100
gen DSR_HH_`i'=(imp1_ds_tot_HH_`i'/totalincome_HH_`i')*100

gen ISR_indiv_`i'=(imp1_is_tot_indiv_`i'/totalincome_indiv_`i')*100
gen ISR_HH_`i'=(imp1_is_tot_HH_`i'/totalincome_HH_`i')*100

gen DAR_indiv_`i'=(loanamount_indiv_`i'/assets_`i')*100
gen DAR_HH_`i'=(loanamount_HH_`i'/assets_`i')*100

gen FormR_indiv_`i'=(formal_amount_indiv_`i'/loanamount_indiv_`i')*100
gen FormR_HH_`i'=(formal_amount_HH_`i'/loanamount_HH_`i')*100
gen InformR_indiv_`i'=(informal_amount_indiv_`i'/loanamount_indiv_`i')*100
gen InformR_HH_`i'=(informal_amount_HH_`i'/loanamount_HH_`i')*100
gen SemiformR_indiv_`i'=(semiformal_amount_indiv_`i'/loanamount_indiv_`i')*100
gen SemiformR_HH_`i'=(semiformal_amount_HH_`i'/loanamount_HH_`i')*100

gen IncogenR_indiv_`i'=(incomegen_indiv_`i'/loanamount_indiv_`i')*100
gen IncogenR_HH_`i'=(incomegen_HH_`i'/loanamount_HH_`i')*100
gen NoincogenR_indiv_`i'=(noincomegen_indiv_`i'/loanamount_indiv_`i')*100
gen NoincogenR_HH_`i'=(noincomegen_HH_`i'/loanamount_HH_`i')*100
}

tab ISR_indiv_1
tab ISR_indiv_1 debtpath, m




********** Check the 0
tab debtpath
foreach x in mean_yratepaid_indiv mean_monthlyinterestrate_indiv imp1_ds_tot_indiv imp1_is_tot_indiv semiformal_indiv formal_indiv economic_indiv current_indiv humancap_indiv social_indiv house_indiv incomegen_indiv noincomegen_indiv economic_amount_indiv current_amount_indiv humancap_amount_indiv social_amount_indiv house_amount_indiv incomegen_amount_indiv noincomegen_amount_indiv informal_amount_indiv formal_amount_indiv semiformal_amount_indiv marriageloan_indiv marriageloanamount_indiv marriageloan_mar_indiv marriageloanamount_mar_indiv marriageloan_fin_indiv marriageloanamount_fin_indiv dummyproblemtorepay_indiv dummyhelptosettleloan_indiv dummyinterest_indiv loans_indiv loanamount_indiv loanbalance_indiv DSR_indiv ISR_indiv DAR_indiv FormR_indiv InformR_indiv SemiformR_indiv IncogenR_indiv NoincogenR_indiv {
replace `x'_1=0.001 if debtpath>=1 & `x'_1==0
replace `x'_2=0.001 if (debtpath==1 | debtpath==3) & `x'_2==0
replace `x'_1=. if debtpath==0
replace `x'_2=. if debtpath==0
}



********** Variation of debt, etc.
foreach x in mean_yratepaid_indiv mean_monthlyinterestrate_indiv mean_yratepaid_HH mean_monthlyinterestrate_HH imp1_ds_tot_indiv imp1_is_tot_indiv semiformal_indiv formal_indiv economic_indiv current_indiv humancap_indiv social_indiv house_indiv incomegen_indiv noincomegen_indiv economic_amount_indiv current_amount_indiv humancap_amount_indiv social_amount_indiv house_amount_indiv incomegen_amount_indiv noincomegen_amount_indiv informal_amount_indiv formal_amount_indiv semiformal_amount_indiv marriageloan_indiv marriageloanamount_indiv marriageloan_mar_indiv marriageloanamount_mar_indiv marriageloan_fin_indiv marriageloanamount_fin_indiv dummyproblemtorepay_indiv dummyhelptosettleloan_indiv dummyinterest_indiv loans_indiv loanamount_indiv loanbalance_indiv imp1_ds_tot_HH imp1_is_tot_HH informal_HH semiformal_HH formal_HH economic_HH current_HH humancap_HH social_HH house_HH incomegen_HH noincomegen_HH economic_amount_HH current_amount_HH humancap_amount_HH social_amount_HH house_amount_HH incomegen_amount_HH noincomegen_amount_HH informal_amount_HH formal_amount_HH semiformal_amount_HH marriageloan_HH marriageloanamount_HH marriageloan_mar_HH marriageloanamount_mar_HH marriageloan_fin_HH marriageloanamount_fin_HH dummyproblemtorepay_HH dummyhelptosettleloan_HH dummyinterest_HH loans_HH loanamount_HH loanbalance_HH DSR_indiv DSR_HH ISR_indiv ISR_HH DAR_indiv DAR_HH FormR_indiv FormR_HH InformR_indiv InformR_HH SemiformR_indiv SemiformR_HH IncogenR_indiv IncogenR_HH NoincogenR_indiv NoincogenR_HH{
gen d_`x'=(`x'_2-`x'_1)*100/`x'_1
}





********** Creation of cat
global dcat d_loanamount_indiv d_loanamount_HH d_DSR_indiv d_DSR_HH d_ISR_indiv d_ISR_HH d_mean_yratepaid_indiv d_mean_yratepaid_HH d_FormR_indiv d_FormR_HH d_InformR_indiv d_InformR_HH d_IncogenR_indiv d_IncogenR_HH d_NoincogenR_indiv d_NoincogenR_HH d_imp1_ds_tot_indiv d_imp1_ds_tot_HH d_imp1_is_tot_indiv d_imp1_is_tot_HH d_DAR_indiv d_DAR_HH

foreach x in $dcat {
gen cat_`x'=0 if `x'!=.
gen bin_`x'=. if `x'!=.
}

foreach x in $dcat{
replace cat_`x'=1 if `x'>5 & `x'!=.
replace cat_`x'=2 if `x'>=-5 & `x'<=5 & `x'!=.
replace cat_`x'=3 if `x'<-5 & `x'!=.
replace bin_`x'=0 if `x'<=0 & `x'!=.
replace bin_`x'=1 if `x'>0 & `x'!=.
}

label define timevar 1"Increase" 2"Stable" 3"Decrease"
label define timevar2 0"Stable or decrease" 1"Increase"
foreach x in $dcat{
label values cat_`x' timevar
replace cat_`x'=. if debtpath==0

label values bin_`x' timevar2
replace bin_`x'=. if debtpath==0
}

foreach x in $dcat{
tab cat_`x'
}



save"panel_wide", replace



********** Reshape

reshape long name_ interviewplace_	edulevel_ address_	sex_	age_	relationshiptohead_	ownland_	foodexpenses_	healthexpenses_	ceremoniesexpenses_	ceremoniesrelativesexpenses_	deathexpenses_	dummymarriage_	marriageexpenses_	house_	readystartjob_	methodfindjob_	jobpreference_	moveoutsideforjob_	moveoutsideforjobreason_	aspirationminimumwage_	businessexpenses_	dummyaspirationmorehours_	aspirationminimumwage2_	mainoccupation_hours_indiv_	mainoccupation_income_indiv_	mainoccupation_indiv_	mainoccupationname_indiv_	totalincome_indiv_	nboccupation_indiv_	mainoccupation_HH_	totalincome_HH_	nboccupation_HH_	caste_	assets_	raven_tt_	num_tt_	lit_tt_	cr_OP_	cr_CO_	cr_EX_	cr_AG_	cr_ES_	cr_Grit_	OP_	CO_	EX_	AG_	ES_	Grit_	imp1_ds_tot_indiv_	imp1_is_tot_indiv_	semiformal_indiv_	formal_indiv_	economic_indiv_	current_indiv_	humancap_indiv_	social_indiv_	house_indiv_	incomegen_indiv_	noincomegen_indiv_	economic_amount_indiv_	current_amount_indiv_	humancap_amount_indiv_	social_amount_indiv_	house_amount_indiv_	incomegen_amount_indiv_	noincomegen_amount_indiv_	informal_amount_indiv_	formal_amount_indiv_	semiformal_amount_indiv_	marriageloan_indiv_	marriageloanamount_indiv_	marriageloan_mar_indiv_	marriageloanamount_mar_indiv_	marriageloan_fin_indiv_	marriageloanamount_fin_indiv_	dummyproblemtorepay_indiv_	dummyhelptosettleloan_indiv_	dummyinterest_indiv_	loans_indiv_	loanamountmar_indiv_	loanbalance_indiv_	loanamount_indiv_	mean_yratepaid_indiv_	mean_monthlyinterestrate_indiv_	imp1_ds_tot_HH_	imp1_is_tot_HH_	informal_HH_	semiformal_HH_	formal_HH_	economic_HH_	current_HH_	humancap_HH_	social_HH_	house_HH_	incomegen_HH_	noincomegen_HH_	economic_amount_HH_	current_amount_HH_	humancap_amount_HH_	social_amount_HH_	house_amount_HH_	incomegen_amount_HH_	noincomegen_amount_HH_	informal_amount_HH_	formal_amount_HH_	semiformal_amount_HH_	marriageloan_HH_	marriageloanamount_HH_	marriageloan_mar_HH_	marriageloanamount_mar_HH_	marriageloan_fin_HH_	marriageloanamount_fin_HH_	dummyproblemtorepay_HH_	dummyhelptosettleloan_HH_	dummyinterest_HH_	loans_HH_	loanamountmar_HH_	loanbalance_HH_	loanamount_HH_	mean_yratepaid_HH_	mean_monthlyinterestrate_HH_	nocorrf1_	nocorrf2_	nocorrf3_	nocorrf4_	nocorrf5_	corrf1_	corrf2_	corrf3_	corrf4_	corrf5_	hhsize_	nbchild_	nbfemale_	nbmale_ DSR_indiv_ DSR_HH_ ISR_indiv_ ISR_HH_ DAR_indiv_ DAR_HH_ FormR_indiv_ FormR_HH_ InformR_indiv_ InformR_HH_ SemiformR_indiv_ SemiformR_HH_ IncogenR_indiv_ IncogenR_HH_ NoincogenR_indiv_ NoincogenR_HH_ annualincome_indiv_ annualincome_HH_, i(HHINDID) j(year)

recode year (1=2016) (2=2020)

*Rename
foreach x in name_ edulevel_ sex_ age_ interviewplace_ address_ dummymarriage_ moveoutsideforjobreasonother_2 dummyaspirationmorehours_ moveoutsideforjobreason_ aspirationminimumwage2_ aspirationminimumwage_ moveoutsideforjob_ businessexpenses_ readystartjob_ methodfindjob_ jobpreference_ relationshiptohead_ reasonneverattendedschool_2 marriageexpenses_ ownland_ foodexpenses_ healthexpenses_ ceremoniesexpenses_ ceremoniesrelativesexpenses_ deathexpenses_ house_ mainoccupation_hours_indiv_ mainoccupation_income_indiv_ mainoccupation_indiv_ mainoccupationname_indiv_ totalincome_indiv_ nboccupation_indiv_ mainoccupation_HH_ totalincome_HH_ nboccupation_HH_ assets_ raven_tt_ num_tt_ lit_tt_ cr_OP_ cr_CO_ cr_EX_ cr_AG_ cr_ES_ cr_Grit_ OP_ CO_ EX_ AG_ ES_ Grit_ imp1_ds_tot_indiv_ imp1_is_tot_indiv_ semiformal_indiv_ formal_indiv_ economic_indiv_ current_indiv_ humancap_indiv_ social_indiv_ house_indiv_ incomegen_indiv_ noincomegen_indiv_ economic_amount_indiv_ current_amount_indiv_ humancap_amount_indiv_ social_amount_indiv_ house_amount_indiv_ incomegen_amount_indiv_ noincomegen_amount_indiv_ informal_amount_indiv_ formal_amount_indiv_ semiformal_amount_indiv_ marriageloan_indiv_ marriageloanamount_indiv_ marriageloan_mar_indiv_ marriageloanamount_mar_indiv_ marriageloan_fin_indiv_ marriageloanamount_fin_indiv_ dummyproblemtorepay_indiv_ dummyhelptosettleloan_indiv_ dummyinterest_indiv_ loans_indiv_ loanamount_indiv_ loanbalance_indiv_ mean_yratepaid_indiv_ mean_monthlyinterestrate_indiv_ imp1_ds_tot_HH_ imp1_is_tot_HH_ informal_HH_ semiformal_HH_ formal_HH_ economic_HH_ current_HH_ humancap_HH_ social_HH_ house_HH_ incomegen_HH_ noincomegen_HH_ economic_amount_HH_ current_amount_HH_ humancap_amount_HH_ social_amount_HH_ house_amount_HH_ incomegen_amount_HH_ noincomegen_amount_HH_ informal_amount_HH_ formal_amount_HH_ semiformal_amount_HH_ marriageloan_HH_ marriageloanamount_HH_ marriageloan_mar_HH_ marriageloanamount_mar_HH_ marriageloan_fin_HH_ marriageloanamount_fin_HH_ dummyproblemtorepay_HH_ dummyhelptosettleloan_HH_ dummyinterest_HH_ loans_HH_ loanamount_HH_ loanbalance_HH_ mean_yratepaid_HH_ mean_monthlyinterestrate_HH_ hhsize_ nbchild_ nbfemale_ nbmale_ DSR_indiv_ DSR_HH_ ISR_indiv_ ISR_HH_ DAR_indiv_ DAR_HH_ FormR_indiv_ FormR_HH_ InformR_indiv_ InformR_HH_ SemiformR_indiv_ SemiformR_HH_ IncogenR_indiv_ IncogenR_HH_ NoincogenR_indiv_ NoincogenR_HH_ loanamountmar_indiv_ loanamountmar_HH_ nocorrf1_ nocorrf2_ nocorrf3_ nocorrf4_ nocorrf5_ corrf1_ corrf2_ corrf3_ corrf4_ corrf5_ annualincome_indiv_ annualincome_HH_{

local new=substr("`x'",1,strlen("`x'")-1)
rename `x' `new'
}

save"panel_long", replace
****************************************
* END
