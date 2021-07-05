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


*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
*set scheme plotplain

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

forvalues i=1(1)5 {
label var base_factor_imraw_`i'_std "Factor `i' (std)"
}





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


********** HHFE
encode HHID_panel, gen(HHvar)
fre HHvar


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


foreach x in base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt {
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


********** Villages
encode villageid_new, gen(village2016)


preserve
use "NEEMSIS2-HH_v17", clear
duplicates drop HHID_panel, force
keep HHID_panel username
save"NEEMSIS2-username", replace
restore

merge m:1 HHID_panel using "NEEMSIS2-username"
drop if _merge==2
drop _merge



********** Username



save"panel_wide_v2", replace



********** Reshape la base pour FE
use"panel_wide_v2", clear
global toresh name_1 dummyeverhadland_1 ownland_1 egoid_1 interviewplace_1 address_1 sex_1 age_1 relationshiptohead_1 maritalstatus_1 amountlent_1 interestlending_1 dummychitfund_1 nbchitfunds_1 nbsavingaccounts_1 datedebitcard1_1 datedebitcard2_1 datedebitcard3_1 datedebitcard4_1 goldquantity_1 goldquantitypledge_1 nbinsurance_1 landpurchased_1 foodexpenses_1 healthexpenses_1 ceremoniesexpenses_1 ceremoniesrelativesexpenses_1 deathexpenses_1 dummymarriage_1 marriageexpenses_1 house_1 readystartjob_1 methodfindjob_1 jobpreference_1 moveoutsideforjob_1 moveoutsideforjobreason_1 aspirationminimumwage_1 businessexpenses_1 dummyaspirationmorehours_1 aspirationminimumwage2_1 mainoccupation_hours_indiv_1 mainoccupation_income_indiv_1 mainoccupation_indiv_1 mainoccupationname_indiv_1 annualincome_indiv_1 nboccupation_indiv_1 mainoccupation_HH_1 annualincome_HH_1 nboccupation_HH_1 edulevel_1 assets_1 totalincome_indiv_1 totalincome_HH_1 raven_tt_1 num_tt_1 lit_tt_1 cr_OP_1 cr_CO_1 cr_EX_1 cr_AG_1 cr_ES_1 cr_Grit_1 OP_1 CO_1 EX_1 AG_1 ES_1 Grit_1 imp1_ds_tot_indiv_1 imp1_is_tot_indiv_1 semiformal_indiv_1 formal_indiv_1 economic_indiv_1 current_indiv_1 humancap_indiv_1 social_indiv_1 house_indiv_1 incomegen_indiv_1 noincomegen_indiv_1 economic_amount_indiv_1 current_amount_indiv_1 humancap_amount_indiv_1 social_amount_indiv_1 house_amount_indiv_1 incomegen_amount_indiv_1 noincomegen_amount_indiv_1 informal_amount_indiv_1 formal_amount_indiv_1 semiformal_amount_indiv_1 marriageloan_indiv_1 marriageloanamount_indiv_1 dummyproblemtorepay_indiv_1 dummyhelptosettleloan_indiv_1 dummyinterest_indiv_1 loans_indiv_1 loanamount_indiv_1 loanbalance_indiv_1 loanamount_wm_indiv_1 mean_yratepaid_indiv_1 mean_monthly_indiv_1 sum_otherlenderservices_1_1 sum_otherlenderservices_2_1 sum_otherlenderservices_3_1 sum_otherlenderservices_4_1 sum_otherlenderservices_5_1 imp1_ds_tot_HH_1 imp1_is_tot_HH_1 informal_HH_1 semiformal_HH_1 formal_HH_1 economic_HH_1 current_HH_1 humancap_HH_1 social_HH_1 house_HH_1 incomegen_HH_1 noincomegen_HH_1 economic_amount_HH_1 current_amount_HH_1 humancap_amount_HH_1 social_amount_HH_1 house_amount_HH_1 incomegen_amount_HH_1 noincomegen_amount_HH_1 informal_amount_HH_1 formal_amount_HH_1 semiformal_amount_HH_1 marriageloan_HH_1 marriageloanamount_HH_1 dummyproblemtorepay_HH_1 dummyhelptosettleloan_HH_1 dummyinterest_HH_1 loans_HH_1 loanamount_HH_1 loanbalance_HH_1 loanamount_wm_HH_1 mean_yratepaid_HH_1 mean_monthlyinterestrate_HH_1 factor_imcorwith_1_1 factor_imcorwith_2_1 factor_imcorwith_3_1 factor_imcorwith_4_1 factor_imcorwith_5_1 factor_imcorwith_6_1 factor_imrawwith_1_1 factor_imrawwith_2_1 factor_imrawwith_3_1 factor_imrawwith_4_1 factor_imrawwith_5_1 factor_imrawwith_6_1 factor_imcor_1_1 factor_imcor_2_1 factor_imcor_3_1 factor_imcor_4_1 factor_imcor_5_1 factor_imraw_1_1 factor_imraw_2_1 factor_imraw_3_1 factor_imraw_4_1 factor_imraw_5_1 hhsize_1 nbchild_1 nbfemale_1 nbmale_1 savingsamount_HH_1 educationexpenses_HH_1 productexpenses_HH_1 businessexpenses_HH_1 foodexpenses_HH_1 healthexpenses_HH_1 ceremoniesexpenses_HH_1 deathexpenses_HH_1 livestockexpenses_HH_1 chitfundpaymentamount_HH_1 chitfundamount_HH_1 chitfundamounttot_HH_1 nbchitfunds_HH_1 amountlent_HH_1 interestlending_HH_1 problemrepayment_HH_1 goldquantity_HH_1 goldquantitypledge_HH_1 nbinsurance_HH_1 insuranceamount_HH_1 insuranceamounttot_HH_1 insurancebenefitamount_HH_1 insurancebenefitamounttot_HH_1 investequiptot_HH_1 debtorratio_1 debtorratio2_1 workerratio_1 workerratio2_1 sum_borrowerservices_1_r_1 sum_borrowerservices_2_r_1 sum_borrowerservices_3_r_1 sum_borrowerservices_4_r_1 sum_plantorepay_1_r_1 sum_plantorepay_2_r_1 sum_plantorepay_3_r_1 sum_plantorepay_4_r_1 sum_plantorepay_5_r_1 sum_plantorepay_6_r_1 sum_settleloanstrategy_1_r_1 sum_settleloanstrategy_2_r_1 sum_settleloanstrategy_3_r_1 sum_settleloanstrategy_4_r_1 sum_settleloanstrategy_5_r_1 sum_settleloanstrategy_6_r_1 sum_settleloanstrategy_7_r_1 sum_settleloanstrategy_8_r_1 sum_settleloanstrategy_9_r_1 sum_settleloanstrategy_10_r_1 indebt_indiv_1 indebt_HH_1 DSR_indiv_1 DSR_HH_1 ISR_indiv_1 ISR_HH_1 DAR_indiv_1 DAR_HH_1 FormR_indiv_1 InformR_indiv_1 SemiformR_indiv_1 FormR_HH_1 InformR_HH_1 SemiformR_HH_1 IncogenR_indiv_1 NoincogenR_indiv_1 IncogenR_HH_1 NoincogenR_HH_1 debtshare_1 savingsamount_1 dummydebitcard_1 dummycreditcard_1 chitfundamount_1 ownhouse_1 sexratio_1 sexratiocat_1 shock_1 cat_mainoccupation_indiv_1 agesq_1 maritalstatus2_1 nboccupation_1 assets1000_1 incomeHH1000_1 q_assets1000_1 loanamount_indiv1000_1 loanamount_HH1000_1 imp1_ds_tot_indiv1000_1 imp1_ds_tot_HH1000_1 imp1_is_tot_indiv1000_1 imp1_is_tot_HH1000_1 savingsamount1000_1 annualincome_indiv1000_1 annualincome_HH1000_1 totalincome_indiv1000_1 over30_indiv_1 over40_indiv_1 dichotomyinterest_indiv_1 dummymultipleoccupation_indiv_1 sharenoservices_1

cls
foreach x in $toresh {
local y=substr("`x'",1,strlen("`x'")-1)
dis "`y'" " " "///"
}
destring dummyeverhadland_2, replace
destring landpurchased_2, replace

reshape long ///
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
raven_tt_ ///
num_tt_ ///
lit_tt_ ///
cr_OP_ ///
cr_CO_ ///
cr_EX_ ///
cr_AG_ ///
cr_ES_ ///
cr_Grit_ ///
OP_ ///
CO_ ///
EX_ ///
AG_ ///
ES_ ///
Grit_ ///
res_cr_OP_ ///
res_cr_CO_ ///
res_cr_EX_ ///
res_cr_AG_ ///
res_cr_ES_ ///
res_cr_Grit_ ///
res_OP_ ///
res_CO_ ///
res_EX_ ///
res_AG_ ///
res_ES_ ///
res_Grit_ ///
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
factor_imcorwith_1_ ///
factor_imcorwith_2_ ///
factor_imcorwith_3_ ///
factor_imcorwith_4_ ///
factor_imcorwith_5_ ///
factor_imcorwith_6_ ///
factor_imrawwith_1_ ///
factor_imrawwith_2_ ///
factor_imrawwith_3_ ///
factor_imrawwith_4_ ///
factor_imrawwith_5_ ///
factor_imrawwith_6_ ///
factor_imcor_1_ ///
factor_imcor_2_ ///
factor_imcor_3_ ///
factor_imcor_4_ ///
factor_imcor_5_ ///
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
raven_tt_ ///
num_tt_ ///
lit_tt_ ///
cr_OP_ ///
cr_CO_ ///
cr_EX_ ///
cr_AG_ ///
cr_ES_ ///
cr_Grit_ ///
OP_ ///
CO_ ///
EX_ ///
AG_ ///
ES_ ///
Grit_ ///
res_cr_OP_ ///
res_cr_CO_ ///
res_cr_EX_ ///
res_cr_AG_ ///
res_cr_ES_ ///
res_cr_Grit_ ///
res_OP_ ///
res_CO_ ///
res_EX_ ///
res_AG_ ///
res_ES_ ///
res_Grit_ ///
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
factor_imcorwith_1_ ///
factor_imcorwith_2_ ///
factor_imcorwith_3_ ///
factor_imcorwith_4_ ///
factor_imcorwith_5_ ///
factor_imcorwith_6_ ///
factor_imrawwith_1_ ///
factor_imrawwith_2_ ///
factor_imrawwith_3_ ///
factor_imrawwith_4_ ///
factor_imrawwith_5_ ///
factor_imrawwith_6_ ///
factor_imcor_1_ ///
factor_imcor_2_ ///
factor_imcor_3_ ///
factor_imcor_4_ ///
factor_imcor_5_ ///
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


save"panel_long_v1.dta", replace
****************************************
* END








*Pas besoin de le lancer à chaque fois car je n'y touche quasi jamais
/*
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
*/












****************************************
* Descriptive statistics
****************************************
use"panel_wide_v3.dta", clear

tab segmana 

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
tabstat annualincome_HH1000_1 incomeHH1000_1, stat(n mean sd p50) by(caste)
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
(kdensity base_factor_imraw_`i'_std if segmana==1, bwidth(0.32) lpattern(solid) lcolor(gs4)) ///
(kdensity base_factor_imraw_`i'_std if segmana==2, bwidth(0.32) lpattern(shortdash) lcolor(gs0)) ///
(kdensity base_factor_imraw_`i'_std if segmana==3, bwidth(0.32) lpattern(dash) lcolor(gs9)) ///
(kdensity base_factor_imraw_`i'_std if segmana==4, bwidth(0.32) lpattern(solid) lcolor(gs12)), ///
xsize() xtitle("Factor `i' (std.)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(2) order(1 "Dalits women" 2 "Dalits men" 3 "MU caste women" 4 "MU caste men") off) name(f`i', replace)
}

twoway ///
(kdensity base_raven_tt if segmana==1, bwidth(3) lpattern(solid) lcolor(gs4)) ///
(kdensity base_raven_tt if segmana==2, bwidth(3) lpattern(shortdash) lcolor(gs0)) ///
(kdensity base_raven_tt if segmana==3, bwidth(3) lpattern(dash) lcolor(gs9)) ///
(kdensity base_raven_tt if segmana==4, bwidth(3) lpattern(solid) lcolor(gs12)), ///
xsize() xtitle("Raven test", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(2) order(1 "Male" 2 "Female") off) name(f6, replace)

twoway ///
(kdensity base_num_tt if segmana==1, bwidth(1.5) lpattern(solid) lcolor(gs4)) ///
(kdensity base_num_tt if segmana==2, bwidth(1.5) lpattern(shortdash) lcolor(gs0)) ///
(kdensity base_num_tt if segmana==3, bwidth(1.5) lpattern(dash) lcolor(gs9)) ///
(kdensity base_num_tt if segmana==4, bwidth(1.5) lpattern(solid) lcolor(gs12)), ///
xsize() xtitle("Numeracy test", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(2) order(1 "Male" 2 "Female") off) name(f7, replace)

twoway ///
(kdensity base_lit_tt if segmana==1, bwidth(1.7) lpattern(solid) lcolor(gs4)) ///
(kdensity base_lit_tt if segmana==2, bwidth(1.7) lpattern(shortdash) lcolor(gs0)) ///
(kdensity base_lit_tt if segmana==3, bwidth(1.7) lpattern(dash) lcolor(gs9)) ///
(kdensity base_lit_tt if segmana==4, bwidth(1.7) lpattern(solid) lcolor(gs12)), ///
xsize() xtitle("Literacy test", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(2) order(1 "Male" 2 "Female") off) name(f8, replace)

set graph on

grc1leg f1 f2 f3 f4 f5 f6 f7 f8, cols(4) note("Kernel: Epanechnikov;" "Bandwidth: 0.32 for factors, 3 for raven, 1.5 for literacy, 1 for numeracy.", size(vsmall)) name(perso, replace)
graph save "Kernel_perso2.gph", replace
graph export "Kernel_perso2.pdf", as(pdf) name(perso) replace
*/

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
cpcorr  loanamount_indiv1000_2 loans_indiv_2 DSR_indiv_2 over40_indiv_2 \ base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt if segmana==`i', f(%5.2f)
*matrix list r(C)
matrix list r(p)

cpcorr indebt_indiv_2 \ base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt base_num_tt base_lit_tt if segmana==`i', f(%4.2f)
*matrix list r(C)
matrix list r(p)
}


* new Y
tab1 sum_borrowerservices_1_r_2 sum_borrowerservices_2_r_2 sum_borrowerservices_3_r_2 sum_borrowerservices_4_r_2
/*
Ok pour 1 2 3
1 free service
2 work for less wage
3 provide support whenever he need
*/

tab1 sum_plantorepay_1_r_2 sum_plantorepay_2_r_2 sum_plantorepay_3_r_2 sum_plantorepay_4_r_2 sum_plantorepay_5_r_2 sum_plantorepay_6_r_2 
/*
Ok pour 6
6 borrowing elsewhere
*/

tab1 sum_settleloanstrategy_1_r_2 sum_settleloanstrategy_2_r_2 sum_settleloanstrategy_3_r_2 sum_settleloanstrategy_4_r_2 sum_settleloanstrategy_5_r_2 sum_settleloanstrategy_6_r_2 sum_settleloanstrategy_7_r_2 sum_settleloanstrategy_8_r_2 sum_settleloanstrategy_9_r_2 sum_settleloanstrategy_10_r_2
/*
Ok pour 3 4 6 7 8
3 borrowing elsewhere
4 selling something which was not planned
6 consumption reduction
7 take an additional job
8 work more
*/

tab1 sum_borrowerservices_1_r_2 sum_borrowerservices_2_r_2 sum_borrowerservices_3_r_2 sum_plantorepay_6_r_2 sum_settleloanstrategy_3_r_2 sum_settleloanstrategy_4_r_2 sum_settleloanstrategy_6_r_2 sum_settleloanstrategy_7_r_2 sum_settleloanstrategy_8_r_2

tab sum_plantorepay_6_r_2 sum_settleloanstrategy_3_r_2

tabstat sum_borrowerservices_3_r_2 dummyhelptosettleloan_indiv_2 sum_settleloanstrategy_8_r_2 sum_plantorepay_6_r_2 if indebt_indiv_2==1 , stat(n mean) by(segmana)

tabstat loans_indiv_2 debtshare_2 ISR_indiv_2 FormR_indiv_2 InformR_indiv_2 if indebt_indiv_2==1, stat(n mean sd p50) by(segmana)

oneway loans_indiv_2 segmana

tabstat over40_indiv_2 if indebt_indiv_2==1, stat(n mean) by(segmana)

oneway over40_indiv_2 segmana
tab over40_indiv_2 segmana, chi2 nofreq




********** Tester nouveaux Y


*Relation
replace sum_debtrelation_shame_2=1 if sum_debtrelation_shame_2>1
rename sum_debtrelation_shame_2 debtrelation_shame_2
replace debtrelation_shame_2=. if indebt_indiv_2==0
tab debtrelation_shame_2 segmana, col nofreq



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
