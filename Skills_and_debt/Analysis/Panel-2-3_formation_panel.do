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

global loan "NEEMSIS2-loans_v14"
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



foreach x in f1 f2 f3 f4 f5 cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit raven_tt num_tt lit_tt{
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

* Age
replace age_2=age_1+4 if age_2==. & age_1!=.

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
foreach x in base_f1 base_f2 base_f3 base_f4 base_f5 base_cr_OP base_cr_CO base_cr_EX base_cr_AG base_cr_ES base_cr_Grit {
qui reg `x' age_1
predict res_`x', residuals
egen `x'_std=std(res_`x')
}



label var base_cr_OP_std "OP (std)"
label var base_cr_CO_std "CO (std)"
label var base_cr_EX_std "EX (std)"
label var base_cr_AG_std "AG (std)"
label var base_cr_ES_std "ES (std)"
label var base_cr_Grit_std "Grit cor (std)"

label var base_f1_std "ES (std)"
label var base_f2_std "CO (std)"
label var base_f3_std "OP-EX (std)"
label var base_f4_std "weak ES (std)"
label var base_f5_std "AG (std)"


********** Standardiser les compétences cognitives
foreach x in base_raven_tt base_num_tt base_lit_tt {
qui reg `x' age_1
predict res_`x', residuals
egen `x'_std=std(res_`x')
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

fre mainocc_occupation_indiv_1
recode mainocc_occupation_indiv_1 (5=4)
tab mainocc_occupation_indiv_1,gen(cat_mainocc_occupation_indiv_1_)
label var cat_mainocc_occupation_indiv_1_1 "MO: No occ."
label var cat_mainocc_occupation_indiv_1_2 "MO: Agri"
label var cat_mainocc_occupation_indiv_1_3 "MO: Agri coolie"
label var cat_mainocc_occupation_indiv_1_4 "MO: Coolie"
label var cat_mainocc_occupation_indiv_1_5 "MO: Regular"
label var cat_mainocc_occupation_indiv_1_6 "MO: SE"
label var cat_mainocc_occupation_indiv_1_7 "MO: NREGA"

fre cat_mainocc_occupation_indiv_1_1 cat_mainocc_occupation_indiv_1_2 cat_mainocc_occupation_indiv_1_3 cat_mainocc_occupation_indiv_1_4 cat_mainocc_occupation_indiv_1_5 cat_mainocc_occupation_indiv_1_6 cat_mainocc_occupation_indiv_1_7


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

global cogperso base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std base_cr_Grit_std base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_lit_tt_std base_num_tt_std 

foreach x in $cogperso {
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
