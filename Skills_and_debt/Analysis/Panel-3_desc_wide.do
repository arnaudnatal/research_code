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
global git "C:\Users\Arnaud\Documents\GitHub"
global dropbox "C:\Users\Arnaud\Dropbox"


*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
set scheme plotplain

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
*global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH_v8"
global wave3 "NEEMSIS2-HH_v19"


********** Stata package

*coefplot, horizontal xline(0) drop(_cons) levels(95 90 ) ciopts(recast(. rcap))mlabel mlabposition(12) mlabgap(*2)

****************************************
* END






****************************************
* Descriptive statistics
****************************************
use"panel_wide_v2.dta", clear

tab segmana 

********** HH characteristics
*** 2016-17
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
restore

*** 2020-21
cls
preserve
recode caste (3=2)
bysort HHID_panel: egen nbego=sum(1)
duplicates drop HHID_panel, force
*473 HH, in panel, 835 egos
tabstat hhsize_2 nbego, stat(n mean) by(caste)
tab nbego caste, col nofreq
tab sexratiocat_2 caste, col nofreq
tabstat assets1000_2, stat(mean sd p50) by(caste)
tab shock_2 caste, col nofreq
tabstat annualincome_HH1000_2 incomeHH1000_2, stat(n mean sd p50) by(caste)
tab indebt_HH_2 caste, col nofreq
foreach x in near_panruti near_villupur near_tirup near_chengal near_kanchip near_chennai {
tab `x' caste, col nofreq
}
restore


*** Delta HH
cls
preserve
foreach x in assets1000 incomeHH1000 {
gen delta2_`x'=(`x'_2-`x'_1)*100/`x'_1
replace delta2_`x'=`x'_2/100 if `x'_1==0
replace delta2_`x'=-(`x'_1)/100 if `x'_2==0
}

fre indebt_HH_1 indebt_HH_2

gen debtpath_HH=0
replace debtpath_HH=1 if indebt_HH_1==0 & indebt_HH_2==0
replace debtpath_HH=2 if indebt_HH_1==1 & indebt_HH_2==0
replace debtpath_HH=3 if indebt_HH_1==0 & indebt_HH_2==1
replace debtpath_HH=4 if indebt_HH_1==1 & indebt_HH_2==1

tab debtpath_HH caste2, col nofreq
tabstat delta2_assets1000 delta2_incomeHH1000, stat(n mean sd p50) by(caste2)
restore

********** Indiv characteristics
*** 2016-17
cls
tab caste2 female, col
tabstat age_1, stat(n mean) by(female)
tab dummyhead_1 female, col nofreq
tab relationshiptohead_1 female, col nofreq
tab mainocc_occupation_indiv_1 female, col nofreq
tab dummyedulevel female, col nofreq
tab edulevel_1 female, col nofreq
tab maritalstatus_1 female, col nofreq
tab maritalstatus2_1 female, col nofreq
tab dummymultipleoccupation_indiv_1 female, col nofreq
tabstat annualincome_indiv1000_1, stat(mean sd p50) by(female)

*** 2020-21
cls
tabstat age_2, stat(n mean) by(female)
tab dummyhead_2 female, col nofreq
tab mainocc_occupation_indiv_2 female, col nofreq
tab maritalstatus_2 female, col  nofreq
tab dummymultipleoccupation_indiv_2 female, col nofreq
tabstat annualincome_indiv1000_2, stat(mean sd p50) by(female)

*** Delta income
gen delta2_labinc=(annualincome_indiv1000_2-annualincome_indiv1000_1)*100/annualincome_indiv1000_1
replace delta2_labinc=annualincome_indiv1000_2/100 if annualincome_indiv1000_1==0
replace delta2_labinc=-(annualincome_indiv1000_1)/100 if annualincome_indiv1000_2==0

tabstat delta2_labinc, stat(n mean sd p50) by(female)


*** EFA
set graph off
twoway ///
(kdensity base_factor_imcor_1_std if female==0, bwidth(0.32) lpattern(solid) lcolor(gs4)) ///
(kdensity base_factor_imcor_1_std if female==1, bwidth(0.32) lpattern(shortdash) lcolor(gs0)), ///
xsize() xtitle("F1 -- CO (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17") off) name(f1, replace) aspect(0)

twoway ///
(kdensity base_factor_imcor_2_std if female==0, bwidth(0.32) lpattern(solid) lcolor(gs4)) ///
(kdensity base_factor_imcor_2_std if female==1, bwidth(0.32) lpattern(shortdash) lcolor(gs0)), ///
xsize() xtitle("F2 -- ES (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17") off) name(f2, replace) aspect(0)

twoway ///
(kdensity base_factor_imcor_3_std if female==0, bwidth(0.32) lpattern(solid) lcolor(gs4)) ///
(kdensity base_factor_imcor_3_std if female==1, bwidth(0.32) lpattern(shortdash) lcolor(gs0)), ///
xsize() xtitle("F3 -- EX-OP (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17") off) name(f3, replace) aspect(0)

twoway ///
(kdensity base_factor_imcor_4_std if female==0, bwidth(0.32) lpattern(solid) lcolor(gs4)) ///
(kdensity base_factor_imcor_4_std if female==1, bwidth(0.32) lpattern(shortdash) lcolor(gs0)), ///
xsize() xtitle("F4 -- ES-CO (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17") off) name(f4, replace) aspect(0)

twoway ///
(kdensity base_factor_imcor_5_std if female==0, bwidth(0.32) lpattern(solid) lcolor(gs4)) ///
(kdensity base_factor_imcor_5_std if female==1, bwidth(0.32) lpattern(shortdash) lcolor(gs0)), ///
xsize() xtitle("F5 -- AG (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17") off) name(f5, replace) aspect(0)


*** Big-5 raw
foreach x in cr_OP cr_CO cr_EX cr_AG cr_ES { 
twoway ///
(kdensity std_`x'_1 if female==0, bwidth(0.50) lpattern(solid) lcolor(gs4)) ///
(kdensity std_`x'_1 if female==1, bwidth(0.50) lpattern(shortdash) lcolor(gs0)), ///
xsize() xtitle("`x' (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17") size(small) off) name(f_`x', replace)
}

*** Cog
twoway ///
(kdensity std_raven_tt_1 if female==0, bwidth(.5) lpattern(solid) lcolor(gs4)) ///
(kdensity std_raven_tt_1 if female==1, bwidth(.5) lpattern(shortdash) lcolor(gs0)), ///
xsize() xtitle("Raven (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17") off) name(f_rav, replace)

twoway ///
(kdensity std_num_tt_1 if female==0, bwidth(.5) lpattern(solid) lcolor(gs4)) ///
(kdensity std_num_tt_1 if female==1, bwidth(.5) lpattern(shortdash) lcolor(gs0)), ///
xsize() xtitle("Numeracy (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17") off) name(f_num, replace)

twoway ///
(kdensity std_lit_tt_1 if female==0, bwidth(.5) lpattern(solid) lcolor(gs4)) ///
(kdensity std_lit_tt_1 if female==1, bwidth(.5) lpattern(shortdash) lcolor(gs0)), ///
xsize() xtitle("Literacy (std)", size(medsmall)) xlabel(,angle() labsize(small)) ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17") off) name(f_lit, replace)

*** Joint
*Factor & Big5
grc1leg f1 f2 f3 f4 f5 f_cr_OP f_cr_CO f_cr_EX f_cr_AG f_cr_ES, cols(5) leg(f_cr_OP) name(perso_cor, replace) 
*Cog
grc1leg f_rav f_num f_lit, cols(3) leg(f_rav) name(cog, replace)
*All
set graph on
grc1leg f1 f2 f3 f4 f5 f_cr_OP f_cr_CO f_cr_EX f_cr_AG f_cr_ES f_rav f_num f_lit, cols(5) leg(f_cr_OP) note("Kernel: Epanechnikov" "Bandwidth: 0.32 for factors, 0.50 for Big-5, raven, numeracy and literacy." "Items corrected from acquiesence biais for factor analysis." "Big-5 traits corrected from acquiesence bias." "NEEMSIS-1 (2016-17) & NEEMSIS-2 (2020-21).", size(tiny))
graph save "Kernel_PTCS_cor_new.gph", replace
graph export "Kernel_PTCS_cor_new.pdf", as(pdf) replace






********** Debt
cls
tabstat indebt_indiv_1 indebt_indiv_2, stat(mean) by(female)
forvalues i=1(1)2{
tabstat loanamount_indiv1000_`i' DSR_indiv_`i' if indebt_indiv_`i'==1, stat(n mean sd p50) by(female)
}
tab debtpath female, col nofreq

tabstat del_loanamount_indiv delta_loanamount_indiv delta2_loanamount_indiv, stat(n mean sd p50) by(female)
tabstat del_DSR_indiv delta_DSR_indiv delta2_DSR_indiv, stat(n mean sd p50) by(female)

tabstat delta2_loanamount_indiv delta2_DSR_indiv, stat(mean sd p50) by(female)
tab debtpath female, col nofreq



****************************************
* END













/*
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
