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

*Interaction terms for female
gen ff1=female*base_nocorrf1_std
gen ff2=female*base_nocorrf2_std
gen ff3=female*base_nocorrf3_std
gen ff4=female*base_nocorrf4_std
gen ff5=female*base_nocorrf5_std
gen fr1=female*base_raven_tt
gen fn1=female*base_num_tt
gen fl1=female*base_lit_tt
label var ff1 "Female x Factor 1"
label var ff2 "Female x Factor 2"
label var ff3 "Female x Factor 3"
label var ff4 "Female x Factor 4"
label var ff5 "Female x Factor 5"
label var fr1 "Female x Raven"
label var fn1 "Female x Numeracy"
label var fl1 "Female x Literacy"

*Interaction terms for dalits
gen df1=caste_1*base_nocorrf1_std
gen df2=caste_1*base_nocorrf2_std
gen df3=caste_1*base_nocorrf3_std
gen df4=caste_1*base_nocorrf4_std
gen df5=caste_1*base_nocorrf5_std
gen dr1=caste_1*base_raven_tt
gen dn1=caste_1*base_num_tt
gen dl1=caste_1*base_lit_tt
label var df1 "Dalit x Factor 1"
label var df2 "Dalit x Factor 2"
label var df3 "Dalit x Factor 3"
label var df4 "Dalit x Factor 4"
label var df5 "Dalit x Factor 5"
label var dr1 "Dalit x Raven"
label var dn1 "Dalit x Numeracy"
label var dl1 "Dalit x Literacy"

*Interaction terms for upper
gen uf1=caste_3*base_nocorrf1_std
gen uf2=caste_3*base_nocorrf2_std
gen uf3=caste_3*base_nocorrf3_std
gen uf4=caste_3*base_nocorrf4_std
gen uf5=caste_3*base_nocorrf5_std
gen ur1=caste_3*base_raven_tt
gen un1=caste_3*base_num_tt
gen ul1=caste_3*base_lit_tt
label var uf1 "Upper x Factor 1"
label var uf2 "Upper x Factor 2"
label var uf3 "Upper x Factor 3"
label var uf4 "Upper x Factor 4"
label var uf5 "Upper x Factor 5"
label var ur1 "Upper x Raven"
label var un1 "Upper x Numeracy"
label var ul1 "Upper x Literacy"

*Interaction terms for educated
gen ef1=dummyedulevel*base_nocorrf1_std
gen ef2=dummyedulevel*base_nocorrf2_std
gen ef3=dummyedulevel*base_nocorrf3_std
gen ef4=dummyedulevel*base_nocorrf4_std
gen ef5=dummyedulevel*base_nocorrf5_std
gen er1=dummyedulevel*base_raven_tt
gen en1=dummyedulevel*base_num_tt
gen el1=dummyedulevel*base_lit_tt
label var ef1 "Edu scho x Factor 1"
label var ef2 "Edu scho x Factor 2"
label var ef3 "Edu scho x Factor 3"
label var ef4 "Edu scho x Factor 4"
label var ef5 "Edu scho x Factor 5"
label var er1 "Edu scho x Raven"
label var en1 "Edu scho x Numeracy"
label var el1 "Edu scho x Literacy"

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

save"panel_wide_v2", replace

****************************************
* END












****************************************
* Descriptive statistics
****************************************
use"panel_wide_v2.dta", clear



********** Personality
/*
set graph off
forvalues i=1(1)5{
twoway ///
(kdensity base_nocorrf`i'_std if female==0, bwidth(0.2585)) ///
(kdensity base_nocorrf`i'_std if female==1, bwidth(0.2585)), ///
xsize() xtitle("Factor `i' (std. score)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Kernel density", size(small)) ///
legend(position(6) col(2) order(1 "Male" 2 "Female") off) name(f`i', replace)
}

twoway ///
(kdensity base_raven_tt if female==0, bwidth(1.5)) ///
(kdensity base_raven_tt if female==1, bwidth(1.5)), ///
xsize() xtitle("Raven test score", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Kernel density", size(small)) ///
legend(position(6) col(2) order(1 "Male" 2 "Female") off) name(f6, replace)

twoway ///
(kdensity base_num_tt if female==0, bwidth(1)) ///
(kdensity base_num_tt if female==1, bwidth(1)), ///
xsize() xtitle("Numeracy test score", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Kernel density", size(small)) ///
legend(position(6) col(2) order(1 "Male" 2 "Female") off) name(f7, replace)

twoway ///
(kdensity base_lit_tt if female==0, bwidth(1.5)) ///
(kdensity base_lit_tt if female==1, bwidth(1.5)), ///
xsize() xtitle("Literacy test score", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Kernel density", size(small)) ///
legend(position(6) col(2) order(1 "Male" 2 "Female") off) name(f8, replace)

grc1leg f1 f2 f3 f4 f5 f6 f7 f8, cols(4) note("Kernel: Epanechnikov;" "Bandwidth: 0.2585 for factors, 1.5 for raven & lit., 1 for num.", size(vsmall)) name(perso, replace)
graph export "Kernel_perso.svg", as(svg) name(perso) replace
set graph on
*/




********** Debt
*Global
tab debtpath
tab caste debtpath, col row nofreq
tab female debtpath, col row  nofreq

*Debt
tabstat loanamount_indiv1000_1 loanamount_indiv1000_2 if debtpath>0, stat(n min p1 p5 p10 q p90 p95 p99 max) by(female)
tabstat loanamount_indiv1000_1 loanamount_indiv1000_2 if debtpath>0, stat(n  min p1 p5 p10 q p90 p95 p99 max) by(caste)

*Recoder extremums
/*
order loanamount_indiv_1 loanamount_indiv_2 delta_loanamount_indiv delta2_loanamount_indiv delta3_loanamount_indiv, last
sort delta2_loanamount_indiv
*/


*Debt trajectory
cls
tab1 bin_debtshare bin_loanamount_indiv bin_imp1_ds_tot_indiv bin_imp1_is_tot_indiv bin_DSR_indiv bin_ISR_indiv bin_goldquantity bin_goldquantitypledge bin_mean_yratepaid_indiv bin_mean_monthly_indiv bin_informal_amount_indiv bin_formal_amount_indiv bin_semiformal_amount_indiv bin_economic_amount_indiv bin_current_amount_indiv bin_humancap_amount_indiv bin_social_amount_indiv bin_house_amount_indiv bin_noincomegen_amount_indiv bin_incomegen_amount_indiv bin_dummyinterest_indiv bin_loans_indiv bin_DAR_indiv bin_FormR_indiv bin_InformR_indiv bin_SemiformR_indiv bin_IncogenR_indiv bin_NoincogenR_indiv bin_savingsamount bin_chitfundamount bin_nbsavingaccounts bin_nbinsurance bin_nbchitfunds bin_annualincome_indiv


tab1 bin_debtshare bin_loanamount_indiv bin_imp1_ds_tot_indiv bin_imp1_is_tot_indiv bin_DSR_indiv bin_ISR_indiv  bin_informal_amount_indiv bin_formal_amount_indiv bin_semiformal_amount_indiv bin_economic_amount_indiv bin_current_amount_indiv bin_humancap_amount_indiv bin_social_amount_indiv bin_house_amount_indiv bin_noincomegen_amount_indiv bin_incomegen_amount_indiv bin_dummyinterest_indiv bin_loans_indiv bin_DAR_indiv bin_FormR_indiv bin_InformR_indiv bin_IncogenR_indiv bin_NoincogenR_indiv bin_savingsamount bin_nbsavingaccounts bin_nbinsurance bin_annualincome_indiv



fsum delta_debtshare delta_loanamount_indiv delta_imp1_ds_tot_indiv delta_imp1_is_tot_indiv delta_DSR_indiv delta_ISR_indiv delta_informal_amount_indiv delta_formal_amount_indiv delta_semiformal_amount_indiv delta_economic_amount_indiv delta_current_amount_indiv delta_humancap_amount_indiv delta_social_amount_indiv delta_house_amount_indiv delta_noincomegen_amount_indiv delta_incomegen_amount_indiv delta_dummyinterest_indiv delta_loans_indiv delta_DAR_indiv delta_FormR_indiv delta_InformR_indiv delta_IncogenR_indiv delta_NoincogenR_indiv delta_savingsamount delta_nbsavingaccounts delta_nbinsurance delta_annualincome_indiv, stat(n mean sd p50 min max)

global efacog base_nocorrf1_std base_nocorrf2_std base_nocorrf3_std base_nocorrf4_std base_nocorrf5_std base_raven_tt base_num_tt base_lit_tt


cpcorr  loanamount_indiv1000_2 imp1_ds_tot_indiv_2 DSR_indiv_2 imp1_is_tot_indiv_2 ISR_indiv_2 debtshare_2 savingsamount1000_2 annualincome_indiv1000_2  DAR_indiv_2 FormR_indiv_2 InformR_indiv_2 SemiformR_indiv_2 IncogenR_indiv_2 NoincogenR_indiv_2 indebt_indiv_2 loans_indiv_2 dummyinterest_indiv_2 dummyproblemtorepay_indiv_2 \ $efacog

preserve
duplicates drop HHID_panel, force
cpcorr loanamount_HH_2 imp1_ds_tot_HH_2 DSR_HH_2 imp1_is_tot_HH_2 ISR_HH_2 DAR_HH_2 FormR_HH_2 InformR_HH_2 SemiformR_HH_2 IncogenR_HH_2 NoincogenR_HH_2 indebt_HH_2 loans_HH_2 dummyinterest_HH_2 dummyproblemtorepay_HH_2 dummyhelptosettleloan_HH_2 educationexpenses_HH_2 productexpenses_HH_2 businessexpenses_HH_2 foodexpenses_HH_2 healthexpenses_HH_2 ceremoniesexpenses_HH_2 deathexpenses_HH_2 chitfundpaymentamount_HH_2 chitfundamount_HH_2 chitfundamounttot_HH_2 nbchitfunds_HH_2 savingsamount_HH_2 annualincome_HH_2 totalincome_HH_2 amountlent_HH_2 goldquantity_HH_2 goldquantitypledge_HH_2 \  nocorrf11 nocorrf21 nocorrf31 nocorrf41 nocorrf51 nocorrf12 nocorrf22 nocorrf32 nocorrf42 nocorrf52 raven_tt1 raven_tt2 num_tt1 num_tt2 lit_tt1 lit_tt2
restore


********** Test de moyenne et p50 pour perso par path
cls
qui reg base_nocorrf1_std i.debtpath
est store res1
qui reg base_nocorrf2_std i.debtpath
est store res2
qui reg base_nocorrf3_std i.debtpath
est store res3
qui reg base_nocorrf4_std i.debtpath
est store res4
qui reg base_nocorrf5_std i.debtpath
est store res5
qui reg base_raven_tt i.debtpath
est store res6
qui reg base_num_tt i.debtpath
est store res7
qui reg base_lit_tt i.debtpath
est store res8
esttab res* using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop(_cons ) ///
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
export excel using "Stat_desc.xlsx", sheet(, replace)
restore





********** loanamount
tabstat loanamount_indiv1000_2 if female==0, stat(n mean sd) by(caste2)
tabstat loanamount_indiv1000_2 if female==1, stat(n mean sd) by(caste2)

tabstat loanamount_indiv1000_2, stat(n mean sd) by(caste2)




tab caste2 female

/*
stripplot diff_loanamount_indiv, ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(-10(1)10) ymtick(-10(1)10) ytitle()
*/

****************************************
* END











****************************************
* Analysis : debt
****************************************
use"panel_wide_v2.dta", clear

global hhcontrol1 ownland_1 ownhouse_1 q_assets1000_1_2 q_assets1000_1_3 q_assets1000_1_4 q_assets1000_1_5 sexratiocat_1_1 sexratiocat_1_2 hhsize_1 shock_1 incomeHH1000_1

global hhcontrol2 ownland_1 ownhouse_1 assets1000_1 sexratiocat_1_1 sexratiocat_1_2 hhsize_1 shock_1 incomeHH1000_1

global hhcontrol3 q_assets1000_1_2 q_assets1000_1_3 q_assets1000_1_4 q_assets1000_1_5 sexratiocat_1_1 sexratiocat_1_2 hhsize_1 shock_1 incomeHH1000_1


global hhcontrol5 ownland_1 ownhouse_1 sexratiocat_1_1 sexratiocat_1_2 hhsize_1 shock_1 incomeHH1000_1

global householdFE HHFE_1 HHFE_2 HHFE_3 HHFE_4 HHFE_5 HHFE_6 HHFE_7 HHFE_8 HHFE_9 HHFE_10 HHFE_11 HHFE_12 HHFE_13 HHFE_14 HHFE_15 HHFE_16 HHFE_17 HHFE_18 HHFE_19 HHFE_20 HHFE_21 HHFE_22 HHFE_23 HHFE_24 HHFE_25 HHFE_26 HHFE_27 HHFE_28 HHFE_29 HHFE_30 HHFE_31 HHFE_32 HHFE_33 HHFE_34 HHFE_35 HHFE_36 HHFE_37 HHFE_38 HHFE_39 HHFE_40 HHFE_41 HHFE_42 HHFE_43 HHFE_44 HHFE_45 HHFE_46 HHFE_47 HHFE_48 HHFE_49 HHFE_50 HHFE_51 HHFE_52 HHFE_53 HHFE_54 HHFE_55 HHFE_56 HHFE_57 HHFE_58 HHFE_59 HHFE_60 HHFE_61 HHFE_62 HHFE_63 HHFE_64 HHFE_65 HHFE_66 HHFE_67 HHFE_68 HHFE_69 HHFE_70 HHFE_71 HHFE_72 HHFE_73 HHFE_74 HHFE_75 HHFE_76 HHFE_77 HHFE_78 HHFE_79 HHFE_80 HHFE_81 HHFE_82 HHFE_83 HHFE_84 HHFE_85 HHFE_86 HHFE_87 HHFE_88 HHFE_89 HHFE_90 HHFE_91 HHFE_92 HHFE_93 HHFE_94 HHFE_95 HHFE_96 HHFE_97 HHFE_98 HHFE_99 HHFE_100 HHFE_101 HHFE_102 HHFE_103 HHFE_104 HHFE_105 HHFE_106 HHFE_107 HHFE_108 HHFE_109 HHFE_110 HHFE_111 HHFE_112 HHFE_113 HHFE_114 HHFE_115 HHFE_116 HHFE_117 HHFE_118 HHFE_119 HHFE_120 HHFE_121 HHFE_122 HHFE_123 HHFE_124 HHFE_125 HHFE_126 HHFE_127 HHFE_128 HHFE_129 HHFE_130 HHFE_131 HHFE_132 HHFE_133 HHFE_134 HHFE_135 HHFE_136 HHFE_137 HHFE_138 HHFE_139 HHFE_140 HHFE_141 HHFE_142 HHFE_143 HHFE_144 HHFE_145 HHFE_146 HHFE_147 HHFE_148 HHFE_149 HHFE_150 HHFE_151 HHFE_152 HHFE_153 HHFE_154 HHFE_155 HHFE_156 HHFE_157 HHFE_158 HHFE_159 HHFE_160 HHFE_161 HHFE_162 HHFE_163 HHFE_164 HHFE_165 HHFE_166 HHFE_167 HHFE_168 HHFE_169 HHFE_170 HHFE_171 HHFE_172 HHFE_173 HHFE_174 HHFE_175 HHFE_176 HHFE_177 HHFE_178 HHFE_179 HHFE_180 HHFE_181 HHFE_182 HHFE_183 HHFE_184 HHFE_185 HHFE_186 HHFE_187 HHFE_188 HHFE_189 HHFE_190 HHFE_191 HHFE_192 HHFE_193 HHFE_194 HHFE_195 HHFE_196 HHFE_197 HHFE_198 HHFE_199 HHFE_200 HHFE_201 HHFE_202 HHFE_203 HHFE_204 HHFE_205 HHFE_206 HHFE_207 HHFE_208 HHFE_209 HHFE_210 HHFE_211 HHFE_212 HHFE_213 HHFE_214 HHFE_215 HHFE_216 HHFE_217 HHFE_218 HHFE_219 HHFE_220 HHFE_221 HHFE_222 HHFE_223 HHFE_224 HHFE_225 HHFE_226 HHFE_227 HHFE_228 HHFE_229 HHFE_230 HHFE_231 HHFE_232 HHFE_233 HHFE_234 HHFE_235 HHFE_236 HHFE_237 HHFE_238 HHFE_239 HHFE_240 HHFE_241 HHFE_242 HHFE_243 HHFE_244 HHFE_245 HHFE_246 HHFE_247 HHFE_248 HHFE_249 HHFE_250 HHFE_251 HHFE_252 HHFE_253 HHFE_254 HHFE_255 HHFE_256 HHFE_257 HHFE_258 HHFE_259 HHFE_260 HHFE_261 HHFE_262 HHFE_263 HHFE_264 HHFE_265 HHFE_266 HHFE_267 HHFE_268 HHFE_269 HHFE_270 HHFE_271 HHFE_272 HHFE_273 HHFE_274 HHFE_275 HHFE_276 HHFE_277 HHFE_278 HHFE_279 HHFE_280 HHFE_281 HHFE_282 HHFE_283 HHFE_284 HHFE_285 HHFE_286 HHFE_287 HHFE_288 HHFE_289 HHFE_290 HHFE_291 HHFE_292 HHFE_293 HHFE_294 HHFE_295 HHFE_296 HHFE_297 HHFE_298 HHFE_299 HHFE_300 HHFE_301 HHFE_302 HHFE_303 HHFE_304 HHFE_305 HHFE_306 HHFE_307 HHFE_308 HHFE_309 HHFE_310 HHFE_311 HHFE_312 HHFE_313 HHFE_314 HHFE_315 HHFE_316 HHFE_317 HHFE_318 HHFE_319 HHFE_320 HHFE_321 HHFE_322 HHFE_323 HHFE_324 HHFE_325 HHFE_326 HHFE_327 HHFE_328 HHFE_329 HHFE_330 HHFE_331 HHFE_332 HHFE_333 HHFE_334 HHFE_335 HHFE_336 HHFE_337 HHFE_338 HHFE_339 HHFE_340 HHFE_341 HHFE_342 HHFE_343 HHFE_344 HHFE_345 HHFE_346 HHFE_347 HHFE_348 HHFE_349 HHFE_350 HHFE_351 HHFE_352 HHFE_353 HHFE_354 HHFE_355 HHFE_356 HHFE_357 HHFE_358 HHFE_359 HHFE_360 HHFE_361 HHFE_362 HHFE_363 HHFE_364 HHFE_365 HHFE_366 HHFE_367 HHFE_368 HHFE_369 HHFE_370 HHFE_371 HHFE_372 HHFE_373 HHFE_374 HHFE_375 HHFE_376 HHFE_377 HHFE_378 HHFE_379 HHFE_380 HHFE_381 HHFE_382 HHFE_383 HHFE_384 HHFE_385 HHFE_386 HHFE_387 HHFE_388 HHFE_389 HHFE_390 HHFE_391 HHFE_392 HHFE_393 HHFE_394 HHFE_395 HHFE_396 HHFE_397 HHFE_398 HHFE_399 HHFE_400 HHFE_401 HHFE_402 HHFE_403 HHFE_404 HHFE_405 HHFE_406 HHFE_407 HHFE_408 HHFE_409 HHFE_410 HHFE_411 HHFE_412 HHFE_413 HHFE_414 HHFE_415 HHFE_416 HHFE_417 HHFE_418 HHFE_419 HHFE_420 HHFE_421 HHFE_422 HHFE_423 HHFE_424 HHFE_425 HHFE_426 HHFE_427 HHFE_428 HHFE_429 HHFE_430 HHFE_431 HHFE_432 HHFE_433 HHFE_434 HHFE_435 HHFE_436 HHFE_437 HHFE_438 HHFE_439 HHFE_440 HHFE_441 HHFE_442 HHFE_443 HHFE_444 HHFE_445 HHFE_446 HHFE_447 HHFE_448 HHFE_449 HHFE_450 HHFE_451 HHFE_452 HHFE_453 HHFE_454 HHFE_455 HHFE_456 HHFE_457 HHFE_458 HHFE_459 HHFE_460 HHFE_461 HHFE_462 HHFE_463 HHFE_464 HHFE_465 HHFE_466 HHFE_467 HHFE_468 HHFE_469











********** 1.
********** Proba that debt/Y increase with probit
foreach var in  imp1_ds_tot_indiv DSR_indiv loanamount_indiv ///
imp1_is_tot_indiv ISR_indiv mean_yratepaid_indiv ///
InformR_indiv NoincogenR_indiv ///
savingsamount ///
annualincome_indiv ///
goldquantity ///
{ 
global efa base_nocorrf1_std base_nocorrf2_std base_nocorrf3_std base_nocorrf4_std base_nocorrf5_std
global cog base_raven_tt base_num_tt base_lit_tt
global indivcontrol female age_1 dummyhead agesq_1 caste_2 caste_3 cat_mainoccupation_indiv_1_1 cat_mainoccupation_indiv_1_2 cat_mainoccupation_indiv_1_3 cat_mainoccupation_indiv_1_5 dummyedulevel maritalstatus2_1 nboccupation_1 nboccupation_3 nboccupation_4
global hhcontrol4 assets1000_1 sexratiocat_1_1 sexratiocat_1_2 hhsize_1 shock_1 incomeHH1000_1
global villagesFE near_villupur near_tirup near_chengal near_kanchip near_chennai
global femaleint ff1 ff2 ff3 ff4 ff5 fr1 fn1 fl1
global dalitint df1 df2 df3 df4 df5 dr1 dn1 dl1
global upperint uf1 uf2 uf3 uf4 uf5 ur1 un1 ul1
global educint ef1 ef2 ef3 ef4 ef5 er1 en1 el1

qui probit bin_`var' $efa $cog, vce(rob)
est store res_1
qui probit bin_`var' $efa $cog $indivcontrol, vce(rob)
est store res_2
qui probit bin_`var' $efa $cog $indivcontrol $hhcontrol4 $villagesFE, vce(rob)
est store res_3
qui probit bin_`var' $efa $cog $indivcontrol $hhcontrol4 $villagesFE $femaleint, vce(rob)
est store res_4
qui probit bin_`var' $efa $cog $indivcontrol $hhcontrol4 $villagesFE $dalitint, vce(rob)
est store res_5
qui probit bin_`var' $efa $cog $indivcontrol $hhcontrol4 $villagesFE $upperint, vce(rob)
est store res_6

esttab res_* using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop($indivcontrol $hhcontrol4 $villagesFE) ///
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
export excel using "Probit_increase.xlsx", sheet("`var'", replace)
restore
}









********** 2.
********** Proba of being in debt, or overindebted, interest in t+1
foreach var in indebt_indiv over30_indiv over40_indiv dichotomyinterest_indiv dummyproblemtorepay_indiv dummyhelptosettleloan_indiv { 
global efa base_nocorrf1_std base_nocorrf2_std base_nocorrf3_std base_nocorrf4_std base_nocorrf5_std
global cog base_raven_tt base_num_tt base_lit_tt
global indivcontrol female age_1 dummyhead agesq_1 caste_2 caste_3 cat_mainoccupation_indiv_1_1 cat_mainoccupation_indiv_1_2 cat_mainoccupation_indiv_1_3 cat_mainoccupation_indiv_1_5 dummyedulevel maritalstatus2_1 nboccupation_1 nboccupation_3 nboccupation_4
global hhcontrol4 assets1000_1 sexratiocat_1_1 sexratiocat_1_2 hhsize_1 shock_1 incomeHH1000_1
global villagesFE near_villupur near_tirup near_chengal near_kanchip near_chennai
global femaleint ff1 ff2 ff3 ff4 ff5 fr1 fn1 fl1
global dalitint df1 df2 df3 df4 df5 dr1 dn1 dl1
global upperint uf1 uf2 uf3 uf4 uf5 ur1 un1 ul1
global educint ef1 ef2 ef3 ef4 ef5 er1 en1 el1

qui probit `var'_2 `var'_1 $efa $cog, vce(rob)
est store res_1

qui probit `var'_2 `var'_1 $efa $cog $indivcontrol, vce(rob)
est store res_2

qui probit `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE, vce(rob)
est store res_3
/*
qui probit `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if caste==1, vce(rob)
est store res_4

qui probit `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if caste==2, vce(rob)
est store res_5

qui probit `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if caste==3, vce(rob)
est store res_6

qui probit `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if caste==2 | caste==3, vce(rob)
est store res_7

qui probit `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if female==0, vce(rob)
est store res_8

qui probit `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if female==1, vce(rob)
est store res_9
*/
*****
qui probit `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if caste==1 & female==0, vce(rob)
est store res_10

qui probit `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if caste==1 & female==1, vce(rob)
est store res_11

qui probit `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if caste2==2 & female==0, vce(rob)
est store res_12

qui probit `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE if caste2==2 & female==1, vce(rob)
est store res_13


esttab res_* using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop($indivcontrol $hhcontrol4 $villagesFE _cons) ///
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
foreach var in imp1_ds_tot_indiv DSR_indiv loanamount_indiv1000 debtshare ///
imp1_is_tot_indiv ISR_indiv mean_yratepaid_indiv ///
InformR_indiv NoincogenR_indiv ///
savingsamount ///
annualincome_indiv ///
goldquantity ///
loans_indiv dummyinterest_indiv ///
 {
global efa base_nocorrf1_std base_nocorrf2_std base_nocorrf3_std base_nocorrf4_std base_nocorrf5_std
global cog base_raven_tt base_num_tt base_lit_tt
global indivcontrol female age_1 dummyhead agesq_1 caste_2 caste_3 cat_mainoccupation_indiv_1_1 cat_mainoccupation_indiv_1_2 cat_mainoccupation_indiv_1_3 cat_mainoccupation_indiv_1_5 dummyedulevel maritalstatus2_1 nboccupation_1 nboccupation_3 nboccupation_4
global hhcontrol4 assets1000_1 sexratiocat_1_1 sexratiocat_1_2 hhsize_1 shock_1 incomeHH1000_1
global villagesFE near_villupur near_tirup near_chengal near_kanchip near_chennai
global femaleint ff1 ff2 ff3 ff4 ff5 fr1 fn1 fl1
global dalitint df1 df2 df3 df4 df5 dr1 dn1 dl1
global upperint uf1 uf2 uf3 uf4 uf5 ur1 un1 ul1
global educint ef1 ef2 ef3 ef4 ef5 er1 en1 el1

qui reg `var'_2 `var'_1 $efa $cog
est store res_1

qui reg `var'_2 `var'_1 $efa $cog $indivcontrol
est store res_2

qui reg `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE
est store res_3

qui reg `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE $householdFE
est store res_4
/*
qui reg `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE $householdFE if caste==1
est store res_5

qui reg `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE $householdFE if caste==2
est store res_6

qui reg `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE $householdFE if caste==3
est store res_7

qui reg `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE $householdFE if caste==2 | caste==3
est store res_8

qui reg `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE $householdFE if female==0
est store res_9

qui reg `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE $householdFE if female==1
est store res_10
*/
****
qui reg `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE $householdFE if caste==1 & female==0
est store res_11

qui reg `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE $householdFE if caste==1 & female==1
est store res_12

qui reg `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE $householdFE if caste2==2 & female==0
est store res_13

qui reg `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE $householdFE if caste2==2 & female==1
est store res_14


esttab res_* using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop($indivcontrol $hhcontrol4 $villagesFE $householdFE _cons) ///	
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
********** Level of debt in t+1 in number and not in volume
foreach var in loans_indiv dummyinterest_indiv {
global efa base_nocorrf1_std base_nocorrf2_std base_nocorrf3_std base_nocorrf4_std base_nocorrf5_std
global cog base_raven_tt base_num_tt base_lit_tt
global indivcontrol female age_1 dummyhead agesq_1 caste_2 caste_3 cat_mainoccupation_indiv_1_1 cat_mainoccupation_indiv_1_2 cat_mainoccupation_indiv_1_3 cat_mainoccupation_indiv_1_5 dummyedulevel maritalstatus2_1 nboccupation_1 nboccupation_3 nboccupation_4
global hhcontrol4 assets1000_1 sexratiocat_1_1 sexratiocat_1_2 hhsize_1 shock_1 incomeHH1000_1
global villagesFE near_villupur near_tirup near_chengal near_kanchip near_chennai
global femaleint ff1 ff2 ff3 ff4 ff5 fr1 fn1 fl1
global dalitint df1 df2 df3 df4 df5 dr1 dn1 dl1
global upperint uf1 uf2 uf3 uf4 uf5 ur1 un1 ul1
global educint ef1 ef2 ef3 ef4 ef5 er1 en1 el1

qui poisson `var'_2 `var'_1 $efa $cog
est store res_1
qui poisson `var'_2 `var'_1 $efa $cog $indivcontrol
est store res_2
qui poisson `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE
est store res_3
qui poisson `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE $femaleint
est store res_4
qui poisson `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE $dalitint
est store res_5
qui poisson `var'_2 `var'_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE $upperint
est store res_6
*qui poisson `var' $efa $cog $indivcontrol $hhcontrol4 $villagesFE $householdFE
*est store res_8

esttab res_* using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop($indivcontrol $hhcontrol4 $villagesFE) ///
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












********** 8.
********** Perso on delta
global delta delta_debtshare delta_loanamount_indiv delta_imp1_ds_tot_indiv delta_imp1_is_tot_indiv delta_DSR_indiv delta_ISR_indiv delta_goldquantity delta_mean_yratepaid_indiv delta_loans_indiv delta_InformR_indiv delta_NoincogenR_indiv delta_savingsamount delta_annualincome_indiv


foreach var in $delta {
global efa base_nocorrf1_std base_nocorrf2_std base_nocorrf3_std base_nocorrf4_std base_nocorrf5_std
global cog base_raven_tt base_num_tt base_lit_tt
global indivcontrol female age_1 dummyhead agesq_1 caste_2 caste_3 cat_mainoccupation_indiv_1_1 cat_mainoccupation_indiv_1_2 cat_mainoccupation_indiv_1_3 cat_mainoccupation_indiv_1_5 dummyedulevel maritalstatus2_1 nboccupation_1 nboccupation_3 nboccupation_4
global hhcontrol4 assets1000_1 sexratiocat_1_1 sexratiocat_1_2 hhsize_1 shock_1 incomeHH1000_1
global villagesFE near_villupur near_tirup near_chengal near_kanchip near_chennai
global femaleint ff1 ff2 ff3 ff4 ff5 fr1 fn1 fl1
global dalitint df1 df2 df3 df4 df5 dr1 dn1 dl1
global upperint uf1 uf2 uf3 uf4 uf5 ur1 un1 ul1
global educint ef1 ef2 ef3 ef4 ef5 er1 en1 el1

global pathint `var'_f1 `var'_f2 `var'_f3 `var'_f4 `var'_f5 `var'_r1 `var'_n1 `var'_l1

qui reg abs_`var' c.bin_`var' $efa $cog $indivcontrol $hhcontrol4 $villagesFE $householdFE $pathint
est store res_4

esttab res_* using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop($indivcontrol $hhcontrol4 $villagesFE $householdFE) ///	
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
export excel using "OLS_pathstrenght.xlsx", sheet("`var'", replace)
restore

}





































/*
********** Quantile reg
foreach x in d_loanamount_indiv  {
set trace on
foreach j in  10 25 5 75 90  {
global efa base_nocorrf1_std base_nocorrf2_std base_nocorrf3_std base_nocorrf4_std base_nocorrf5_std
global cog base_raven_tt base_num_tt base_lit_tt
global indivcontrol female age_1 dummyhead agesq_1 caste_2 caste_3 cat_mainoccupation_indiv_1_1 cat_mainoccupation_indiv_1_2 cat_mainoccupation_indiv_1_3 cat_mainoccupation_indiv_1_5 dummyedulevel maritalstatus2_1 nboccupation_1 nboccupation_3 nboccupation_4
global hhcontrol4 assets1000_1 sexratiocat_1_1 sexratiocat_1_2 hhsize_1 shock_1 incomeHH1000_1
global villagesFE near_villupur near_tirup near_chengal near_kanchip near_chennai
global femaleint ff1 ff2 ff3 ff4 ff5 fr1 fn1 fl1
global dalitint df1 df2 df3 df4 df5 dr1 dn1 dl1
global upperint uf1 uf2 uf3 uf4 uf5 ur1 un1 ul1
global educint ef1 ef2 ef3 ef4 ef5 er1 en1 el1

qui qreg `x' $efa $cog, q(0.`j')
est store qr1
qui qreg `x' $efa $cog $indivcontrol, q(0.`j')
est store qr2
qui qreg `x' $efa $cog $indivcontrol $hhcontrol4 $villagesFE, q(0.`j')
est store qr3
qui qreg `x' $efa $cog $indivcontrol $hhcontrol4 $villagesFE $femaleint, q(0.`j')
est store qr4
qui qreg `x' $efa $cog $indivcontrol $hhcontrol4 $villagesFE $dalitint, q(0.`j')
est store qr5
qui qreg `x' $efa $cog $indivcontrol $hhcontrol4 $villagesFE $upperint, q(0.`j')
est store qr6
qui qreg `x' $efa $cog $indivcontrol $hhcontrol4 $villagesFE $educint, q(0.`j')
est store qr7
qui qreg `x' $efa $cog $indivcontrol $hhcontrol4 $villagesFE $householdFE, q(0.`j')
est store qr8

esttab 	qr* using "_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	drop($indivcontrol $hhcontrol4 $villagesFE $householdFE) ///	
	legend label varlabels(_cons constant) ///
	stats(N df_m q f_r bwidth, fmt(0 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
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
export excel using "Quantile_analysis.xlsx", sheet("`x' `j'", replace)
restore
}
}



****************************************
* END
