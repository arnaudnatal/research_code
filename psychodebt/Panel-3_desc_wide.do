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
global directory = "C:\Users\Arnaud\Documents\_Thesis\Research-Skills_and_debt\Analysis"
global git "C:\Users\Arnaud\Documents\GitHub"
global dropbox "C:\Users\Arnaud\Documents\Dropbox\Arnaud\Thesis_Debt_skills\INPUT"

***
set scheme plotplain
cd"$directory"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave2 "NEEMSIS1-HH"
global wave3 "NEEMSIS2-HH"


********** Stata package

*coefplot, horizontal xline(0) drop(_cons) levels(95 90 ) ciopts(recast(. rcap))mlabel mlabposition(12) mlabgap(*2)

/*
Pour avoir un box plot en colonne et 1 en ligne pour un nuage de points:
graph7 mpg weight, twoway oneway box xla yla
*/

*stripplot

****************************************
* END









****************************************
* Last recode
****************************************
use"panel_wide_v3.dta", clear

*** Label
label var indebt_indiv_2 "Prob. that individual is in debt"
label var loanamount_indiv "Total amount of debt (\rupee1k)"
label var ISR_indiv "Interest service ratio (\%)" 
label var otherlenderservices_finansupp "Lender provide fin. supp. to borrower"
label var borrowerservices_none "No need to provide services"
label var plantorepay_borr "Borrow elsewhere to repay the debt"
label var dummyproblemtorepay "Have a problem to repay the loan"
label define female 0"Male" 1"Female"
label values female female
label define dalits 0"Middle-upper" 1"Dalits"
label values dalits dalits
egen dal_fem=group(female dalit), la
fre dal_fem
label var totalincome_indiv_1 "Total individual income (\rupee1k)"

label var covsell "Sell assets to face lockdown"


label var villageid_1 "Loc: ELA"
label var villageid_2 "Loc: GOV"
label var villageid_3 "Loc: KAR"
label var villageid_4 "Loc: KOR"
label var villageid_5 "Loc: KUV"
label var villageid_6 "Loc: MAN"
label var villageid_7 "Loc: MANAM"
label var villageid_8 "Loc: NAT"
label var villageid_9 "Loc: ORA"
label var villageid_10 "Loc: SEM"


label var fem_base_f1_std "Female*ES (std)"
label var dal_base_f1_std "Dalit*ES (std)"
label var thr_base_f1_std "Dalit*Female*ES (std)"

label var fem_base_f2_std "Female*CO (std)"
label var dal_base_f2_std "Dalit*CO (std)"
label var thr_base_f2_std "Dalit*Female*CO (std)"

label var fem_base_f3_std "Female*OP-EX (std)"
label var dal_base_f3_std "Dalit*OP-EX (std)"
label var thr_base_f3_std "Dalit*Female*OP-EX (std)"

label var fem_base_f5_std "Female*AG (std)"
label var dal_base_f5_std "Dalit*AG (std)"
label var thr_base_f5_std "Dalit*Female*AG (std)"

label var fem_base_raven_tt_std "Female*Raven (std)"
label var dal_base_raven_tt_std "Dalit*Raven (std)"
label var thr_base_raven_tt_std "Dalit*Female*Raven (std)"
label var fem_base_num_tt_std "Female*Numeracy (std)"
label var dal_base_num_tt_std "Dalit*Numeracy (std)"
label var thr_base_num_tt_std "Dalit*Female*Numeracy (std)"
label var fem_base_lit_tt_std "Female*Literacy (std)"
label var dal_base_lit_tt_std "Dalit*Literacy (std)"
label var thr_base_lit_tt_std "Dalit*Female*Literacy (std)"
label var femXdal "Female*Dalit"
label var debtorratio2_1 "Debtor ratio in 2016-17"
label var indebt_indiv_1 "Indebted (=1) in 2016-17"

label var base_f1_std "ES (std)"
label var base_f2_std "CO (std)"
label var base_f3_std "OP-EX (std)"
label var base_f5_std "AG (std)"


label var share_nb_samesex "Share loans same sex"
label var share_nb_samecaste "Share loans same caste"
label var share_nb_samesex "Share amount same sex"
label var share_nb_samecaste "Share amount same caste"


tabstat share_nb_samesex share_nb_samecaste share_amt_samesex share_amt_samecaste, stat(n mean sd p50)

replace share_nb_samesex=0 if share_nb_samesex==. & indebt_indiv_2==1
replace share_nb_samecaste=0 if share_nb_samecaste==. & indebt_indiv_2==1
replace share_amt_samesex=0 if share_amt_samesex==. & indebt_indiv_2==1
replace share_amt_samecaste=0 if share_amt_samecaste==. & indebt_indiv_2==1

tabstat share_nb_samesex share_nb_samecaste share_amt_samesex share_amt_samecaste, stat(n mean sd p50)


*** Recode
replace ISR_indiv=. if indebt_indiv_2==0
replace ISR_indiv=. if indiv_interest==0
clonevar ISR_indiv_backup=ISR_indiv
tabstat ISR_indiv, stat(n mean sd min p1 p5 p10 q p90 p95 p99 max)
replace ISR_indiv=4 if ISR_indiv>4 & ISR_indiv!=.
tabstat ISR_indiv_backup ISR_indiv, stat(n mean sd min p1 p5 p10 q p90 p95 p99 max) by(female) long

replace indebt_indiv_2=0
replace indebt_indiv_2=1 if loanamount_indiv>0 & loanamount_indiv!=.
replace totalincome_indiv_1=totalincome_indiv_1/1000

save"panel_wide_v4.dta", replace
****************************************
* END








****************************************
* Descriptive statistics
****************************************
use "panel_wide_v4.dta", clear

********** HH
preserve
bysort HHID_panel: egen nbego=sum(1)
duplicates drop HHID_panel, force

global hhvar hhsize_1 assets1000_1 incomeHH1000_1 shock_1 covsell villageid_1 villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10

cls
est clear
eststo ndal: estpost sum $hhvar if dalits==0
eststo dalits: estpost sum $hhvar if dalits==1
eststo diff: estpost ttest hhsize_1 assets1000_1 incomeHH1000_1 shock_1, by(dalits) unequal

esttab ndal dalits diff using "$dropbox/desc_HH.tex", replace f ///
	label booktabs nonumber noobs eqlabels(none) alignment(S S S S S) ///
	collabels("\multicolumn{1}{c}{N}" "\multicolumn{1}{c}{Mean}" "\multicolumn{1}{c}{Std Err.}" "\multicolumn{1}{c}{t-stat}" "\multicolumn{1}{c}{p-value}") ///
	cells("count(pattern(1 1 0) fmt(0)) mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0) fmt(2)) t(pattern(0 0 1) fmt(2)) p(pattern(0 0 1) fmt(2))") ///
	mtitle("Non-dalits" "Dalits" "Diff")

restore


********** Indiv characteristics

global indivvar dalits age_1 dummyhead_1 maritalstatus2_1 dummyedulevel cat_mainocc_occupation_indiv_1_1 cat_mainocc_occupation_indiv_1_2 cat_mainocc_occupation_indiv_1_3 cat_mainocc_occupation_indiv_1_4 cat_mainocc_occupation_indiv_1_5 cat_mainocc_occupation_indiv_1_6 cat_mainocc_occupation_indiv_1_7 dummymultipleoccupation_indiv_1 totalincome_indiv_1

cls
est clear
eststo male: estpost sum $indivvar if female==0
eststo female: estpost sum $indivvar if female==1
eststo diff: estpost ttest $indivvar, by(female) unequal

esttab male female diff using "$dropbox/desc_indiv.tex", replace f ///
	label booktabs nonumber noobs eqlabels(none) alignment(S S S S S) ///
	collabels("\multicolumn{1}{c}{N}" "\multicolumn{1}{c}{Mean}" "\multicolumn{1}{c}{Std Err.}" "\multicolumn{1}{c}{t-stat}" "\multicolumn{1}{c}{p-value}") ///
	cells("count(pattern(1 1 0) fmt(0)) mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0) fmt(2)) t(pattern(0 0 1) fmt(2)) p(pattern(0 0 1) fmt(2))") ///
	mtitle("Male" "Female" "Diff")




********** Debt for all
global yvar indebt_indiv_2 loanamount_indiv ISR_indiv otherlenderservices_finansupp borrowerservices_none plantorepay_borr dummyproblemtorepay

cls
est clear
eststo male: estpost sum $yvar if female==0
eststo female: estpost sum $yvar if female==1
eststo diff: estpost ttest $yvar, by(female) unequal

esttab male female diff using "$dropbox/desc_dep.tex", replace f ///
	label booktabs nonumber noobs eqlabels(none) alignment(S S S S S) ///
	collabels("\multicolumn{1}{c}{N}" "\multicolumn{1}{c}{Mean}" "\multicolumn{1}{c}{Std Err.}" "\multicolumn{1}{c}{t-stat}" "\multicolumn{1}{c}{p-value}") ///
	cells("count(pattern(1 1 0) fmt(0)) mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0) fmt(2)) t(pattern(0 0 1) fmt(2)) p(pattern(0 0 1) fmt(2))") ///
	mtitle("Male" "Female" "Diff")



/*
********** EFA
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

********** Advanced descriptive statistics
global efa base_f1_std base_f2_std base_f3_std base_f5_std
global cog base_raven_tt_std base_num_tt_std base_lit_tt_std

global quali indebt_indiv_2 otherlenderservices_finansupp otherlenderservices_guarantor otherlenderservices_generainf
 
global qualiml borrowerservices_none plantorepay_borr dummyproblemtorepay

global quanti loanamount_indiv ISR_indiv


*** Scatter with lfit
*graph7 loanamount_indiv base_f1_std, twoway oneway box xla yla
/*
graph drop _all
foreach x in $cog $efa {
forvalues i=0(1)1 {
forvalues j=0(1)1 {
set graph off
twoway scatter loanamount_indiv `x' if female==`i' & dalits==`j', name(s_f`i'd`j'_amt_`x', replace)
set graph on
}
}
}
graph dir

forvalues i=0(1)1 {
forvalues j=0(1)1 {
set graph off
graph combine s_f`i'd`j'_amt_base_lit_tt_std s_f`i'd`j'_amt_base_num_tt_std s_f`i'd`j'_amt_base_raven_tt_std s_f`i'd`j'_amt_base_f1_std s_f`i'd`j'_amt_base_f2_std s_f`i'd`j'_amt_base_f3_std s_f`i'd`j'_amt_base_f5_std, name(combine_f`i'd`j', replace)
set graph on
}
}

* Male middle upper
graph display combine_f0d0

* Male dalits
graph display combine_f0d1

* Female middle upper
graph display combine_f1d0

* Female dalits
graph display combine_f1d1
*/
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