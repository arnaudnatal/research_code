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
use"panel_wide_v3.dta", clear

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

/*
*** EFA
set graph off
twoway ///
(kdensity base_f1_std if female==0, bwidth(0.25) lpattern(solid) lcolor(gs4)) ///
(kdensity base_f1_std if female==1, bwidth(0.25) lpattern(shortdash) lcolor(gs0)), ///
xsize() xtitle("Factor: ES (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17") off) name(f1, replace) aspectratio(1) plotregion(margin(none))

twoway ///
(kdensity base_f2_std if female==0, bwidth(0.25) lpattern(solid) lcolor(gs4)) ///
(kdensity base_f2_std if female==1, bwidth(0.25) lpattern(shortdash) lcolor(gs0)), ///
xsize() xtitle("Factor: CO (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17") off) name(f2, replace) aspectratio(1) plotregion(margin(none))

twoway ///
(kdensity base_f3_std if female==0, bwidth(0.25) lpattern(solid) lcolor(gs4)) ///
(kdensity base_f3_std if female==1, bwidth(0.25) lpattern(shortdash) lcolor(gs0)), ///
xsize() xtitle("Factor: OP-EX (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17") off) name(f3, replace) aspectratio(1) plotregion(margin(none))

twoway ///
(kdensity base_f5_std if female==0, bwidth(0.25) lpattern(solid) lcolor(gs4)) ///
(kdensity base_f5_std if female==1, bwidth(0.25) lpattern(shortdash) lcolor(gs0)), ///
xsize() xtitle("Factor: AG (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17") off) name(f5, replace) aspectratio(1) plotregion(margin(none))


*** Big-5
foreach x in OP CO EX AG ES { 
twoway ///
(kdensity base_cr_`x'_std if female==0, bwidth(0.35) lpattern(solid) lcolor(gs4)) ///
(kdensity base_cr_`x'_std if female==1, bwidth(0.35) lpattern(shortdash) lcolor(gs0)), ///
xsize() xtitle("Naïve: `x' (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17") size(small) off) name(f_`x', replace) aspectratio(1) plotregion(margin(none))
}


*** Cog
twoway ///
(kdensity base_raven_tt_std if female==0, bwidth(.5) lpattern(solid) lcolor(gs4)) ///
(kdensity base_raven_tt_std if female==1, bwidth(.5) lpattern(shortdash) lcolor(gs0)), ///
xsize() xtitle("Cog: Raven (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17") off) name(f_rav, replace) aspectratio(1) plotregion(margin(none))

twoway ///
(kdensity base_num_tt_std if female==0, bwidth(.5) lpattern(solid) lcolor(gs4)) ///
(kdensity base_num_tt_std if female==1, bwidth(.5) lpattern(shortdash) lcolor(gs0)), ///
xsize() xtitle("Cog: Numeracy (std)", size(medsmall)) xlabel(,angle() labsize(small))  ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17") off) name(f_num, replace) aspectratio(1) plotregion(margin(none))

twoway ///
(kdensity base_lit_tt_std if female==0, bwidth(.5) lpattern(solid) lcolor(gs4)) ///
(kdensity base_lit_tt_std if female==1, bwidth(.5) lpattern(shortdash) lcolor(gs0)), ///
xsize() xtitle("Cog: Literacy (std)", size(medsmall)) xlabel(,angle() labsize(small)) ///
ylabel(,labsize(small)) ymtick() ytitle("Density", size(small)) ///
legend(position(6) col(4) order(1 "Male in 2016-17" 2 "Female in 2016-17") off) name(f_lit, replace) aspectratio(1) plotregion(margin(none))


*All
grc1leg f_OP f_CO f_EX f_AG f_ES f1 f2 f3 f5 f_rav f_num f_lit, cols(5) holes(10) leg(f_OP) note("Kernel: Epanechnikov" "Bandwidth: 0.25 for factors; 0.35 for Big-5; 0.50 for raven, numeracy and literacy." "Items corrected from acquiesence biais." "NEEMSIS-1 (2016-17) & NEEMSIS-2 (2020-21).", size(tiny))
graph save "Kernel_PTCS.gph", replace
graph export "Kernel_PTCS.pdf", as(pdf) replace
set graph on
*/


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
