cls

/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
October 25, 2021
-----
Stability over time of personality traits
-----

-------------------------
*/


****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
set scheme white_tableau

********** Path to folder "data" folder.
*** PC
global directory = "D:\Documents\_Thesis\Research-Stability_skills\Analysis"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

*** Fac
*global directory = "C:\Users\anatal\Downloads\_Thesis\Research-Stability_skills\Analysis"
*cd "$directory"
*global git "C:\Users\anatal\Downloads\GitHub"

********** Name of the NEEMSIS2 questionnaire version to clean
global wave2 "NEEMSIS1-HH_v9"
global wave3 "NEEMSIS2-HH_v21"
****************************************
* END








****************************************
* Desc p1
****************************************
use "panel_stab_wide_v4", clear
keep if age25==1
*740 individuals

********** Difference
*** Graph: histogram
/*
twoway__histogram_gen diff_fa_ES, percent width(0.1) gen(h x, replace)
twoway ///
(bar h x if x<-.444, color(gs8) barwidth(0.1)) ///
(bar h x if x>=-.444 & x<=.444, color(gs10) barwidth(0.1)) ///
(bar h x if x>.444, color(gs4) barwidth(0.1)) ///
(kdensity diff_fa_ES, bwidth(0.15) lcolor(gs1) lpattern(solid) yaxis(2)) ///
, ///
xlabel(-4(1)5) xmtick(-4.5(.5)5.5) xtitle("ΔES") ///
ytitle("%", axis(1))  ///
ytitle("Density", axis(2)) ///
note("Kernel: Epanechnikov" "Bandwidth: 0.15" "Histogram can be read with the left-hand y-axis." "Kernel curve can be read with the right-hand y-axis.", size(tiny)) ///
plotregion(margin(none)) legend(pos(6) col(4) order(1 "Decrease" 2 "Stable" 3 "Increase" 4 "Kernel density")) name(histo, replace) 
graph export "Histo_kernel_instab.pdf", replace


twoway__histogram_gen diff_cr_ES, percent width(0.1) gen(h x, replace)
twoway ///
(bar h x if x<-.314, color(gs8) barwidth(0.1)) ///
(bar h x if x>=-.314 & x<=.314, color(gs10) barwidth(0.1)) ///
(bar h x if x>.314, color(gs4) barwidth(0.1)) ///
(kdensity diff_cr_ES, bwidth(0.15) lcolor(gs1) lpattern(solid) yaxis(2)) ///
, ///
xlabel(-3(1)3) xmtick(-3.5(.5)3) xtitle("ΔES") ///
ytitle("%", axis(1))  ///
ytitle("Density", axis(2)) ///
note("Kernel: Epanechnikov" "Bandwidth: 0.15" "Histogram can be read with the left-hand y-axis." "Kernel curve can be read with the right-hand y-axis.", size(tiny)) ///
plotregion(margin(none)) legend(pos(6) col(4) order(1 "Decrease" 2 "Stable" 3 "Increase" 4 "Kernel density")) name(histo, replace) 
graph export "Histo_kernel_instab_naive.pdf", replace
*/



********** Transition matrix
tab cr_ES2016_cut cr_ES2020_cut
tab cr_ES2016_cut cr_ES2020_cut, nofreq row

tab fa_ES2016_cut fa_ES2020_cut
tab fa_ES2016_cut fa_ES2020_cut, nofreq row



********** Difference between FA and NA
fre diff_cr_ES_cat5 diff_fa_ES_cat5
tab diff_cr_ES_cat5 diff_fa_ES_cat5, m
dis (284+105+62)*100/738
*61%

twoway (scatter diff_fa_ES diff_cr_ES, xline(-.314 .314) yline(-.444 .444)), xtitle("Naïve approach") ytitle("Factor analysis approach")



********** Age and diff
*** FA
twoway (scatter diff_fa_ES age2016, yline(-.444 .444)), xtitle("Age") ytitle("Factor analysis approach")

*** Na
twoway (scatter diff_cr_ES age2016, yline(-.314 .314)), xtitle("Age") ytitle("Naïve approach")



********** Difference over trajectory
*** Descriptive statistics for naïve Big-5
tab sex diff_cr_ES_cat5, col nofreq
tab caste diff_cr_ES_cat5, col nofreq
tab age_cat diff_cr_ES_cat5, col nofreq
tab edulevel2016 diff_cr_ES_cat5, col nofreq
tab username_backup2020 diff_cr_ES_cat5, col nofreq
tab diff_ars3_cat5 diff_cr_ES_cat5, col nofreq
tab shock_recode diff_cr_ES_cat5, col nofreq

*** Descriptive statistics for factor Big-5
tab sex diff_fa_ES_cat5, col nofreq
tab caste diff_fa_ES_cat5, col nofreq
tab age_cat diff_fa_ES_cat5, col nofreq
tab edulevel2016 diff_fa_ES_cat5, col nofreq
tab username_backup2020 diff_fa_ES_cat5, col nofreq
tab diff_ars3_cat5 diff_fa_ES_cat5, col nofreq
tab shock_recode diff_fa_ES_cat5, col nofreq

****************************************
* END











****************************************
* Desc p2
****************************************
use "panel_stab_wide_v4", clear

label define castecat 1"Dalits" 2"Middle" 3"Upper", modify

*** Caste and sex
egen caste_sex=group(sex caste), lab
fre caste_sex

set graph off
/*
********** Decrease, naïve
*** Boxplot
* Sex
stripplot decrease_cr_ES, over(sex) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(,angle(0))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel() ymtick() ytitle("") ///
legend(order(1 "Mean" 5 "Individual"))

* Caste
stripplot decrease_cr_ES, over(caste) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(,angle(0))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel() ymtick() ytitle("") ///
legend(order(1 "Mean" 5 "Individual"))

* Caste & sex
stripplot decrease_cr_ES, over(caste_sex) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(,angle(45))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel() ymtick() ytitle("") ///
legend(order(1 "Mean" 5 "Individual"))

* Moc
stripplot decrease_cr_ES, over(moc_indiv) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(,angle(45))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel() ymtick() ytitle("") ///
legend(order(1 "Mean" 5 "Individual"))

* Caste
stripplot decrease_cr_ES, over(caste) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(,angle(0))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel() ymtick() ytitle("") ///
legend(order(1 "Mean" 5 "Individual"))

* Caste
stripplot decrease_cr_ES, over(caste) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(,angle(0))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel() ymtick() ytitle("") ///
legend(order(1 "Mean" 5 "Individual"))

set graph on
*/


*** Kernel
twoway ///
(kdensity decrease_cr_ES if caste==1, bwidth(.4)) ///
(kdensity decrease_cr_ES if caste==2, bwidth(.4)) ///
(kdensity decrease_cr_ES if caste==3, bwidth(.4)) ///
, legend(order(1 "Dalits" 2 "Middle" 3 "Upper"))



****************************************
* END













****************************************
* ECON OLS
****************************************
use "panel_stab_wide_v4", clear




********** Clean
**** Username
* 2016
rename username_2016_code2016 username_neemsis1
desc username_neemsis1
fre username_neemsis1
label define username_2016_code 1"Enum: Ant" 2"Enum: Kum" 3"Enum: May" 4"Enum: Paz" 5"Enum: Raj" 6"Enum: Sit" 7"Enum: Viv", modify
* 2020
rename username_encode_2020 username_neemsis2
fre username_neemsis2


********** Assessment: bias higher in 2020-21 than in 2016-17.
stripplot ars32016 ars32020, over() separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(1 "2016-17" 2 "2020-21",angle(0))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel() ymtick() ytitle("") ///
legend(order(1 "Mean" 5 "Individual") off) name(ars_global, replace)
graph export "bias_panel.pdf", replace

*** Kernel
* 2016-17
twoway ///
(kdensity ars32016 if username_neemsis1==1, bwidth(.1)) ///
(kdensity ars32016 if username_neemsis1==2, bwidth(.1)) ///
(kdensity ars32016 if username_neemsis1==3, bwidth(.1)) ///
(kdensity ars32016 if username_neemsis1==4, bwidth(.1)) ///
(kdensity ars32016 if username_neemsis1==5, bwidth(.1)) ///
(kdensity ars32016 if username_neemsis1==6, bwidth(.1)) ///
(kdensity ars32016 if username_neemsis1==7, bwidth(.1)) ///
, ///
xtitle("Absolut acquiescence score") ///
ytitle("Kernel") ///
title("2016-17") ///
legend(order(1 "Enum 1" 2 "Enum 2" 3 "Enum 3" 4 "Enum 4" 5 "Enum 5" 6 "Enum 6" 7 "Enum 7") col(4) pos(6)) ///
name(ars_2016_kernel, replace)

* 2020-21
twoway ///
(kdensity ars32020 if username_neemsis2==1, bwidth(.3)) ///
(kdensity ars32020 if username_neemsis2==2, bwidth(.2)) ///
(kdensity ars32020 if username_neemsis2==3, bwidth(.2)) ///
(kdensity ars32020 if username_neemsis2==4, bwidth(.2)) ///
(kdensity ars32020 if username_neemsis2==5, bwidth(.2)) ///
(kdensity ars32020 if username_neemsis2==6, bwidth(.2)) ///
(kdensity ars32020 if username_neemsis2==7, bwidth(.2)) ///
(kdensity ars32020 if username_neemsis2==8, bwidth(.2)) ///
, ///
xtitle("Absolut acquiescence score") ///
ytitle("Kernel") ///
title("2020-21") ///
legend(order(1 "Enum 1" 2 "Enum 2" 3 "Enum 3" 4 "Enum 4" 5 "Enum 5" 6 "Enum 6" 7 "Enum 7" 8 "Enum 8") col(4) pos(6)) ///
name(ars_2020_kernel, replace)

graph combine ars_2016_kernel ars_2020_kernel, name(ars_enumyear_kernel, replace)
graph export "bias_enum_panel.pdf", replace


*** Role of enumerator in 2016-17
label define usercode 1"Enum: 1" 2"Enum: 2" 3"Enum: 3" 4"Enum: 4" 5"Enum: 5" 6"Enum: 6" 7"Enum: 7" 8"Enum: 8"
label values username_neemsis1 usercode
label values username_neemsis2 usercode

reg ars32016 i.sex i.caste ib(1).age_cat ib(0).educode i.villageid2016, allbase
est store ars1_1

reg ars32016 i.sex i.caste ib(1).age_cat ib(0).educode i.villageid2016 ib(4).username_neemsis1, allbase
est store ars1_2


*** Role of enumerator in 2020-21
reg ars32020 i.sex i.caste ib(1).age_cat ib(0).educode i.villageid2020, allbase
est store ars2_1

reg ars32020 i.sex i.caste ib(1).age_cat ib(0).educode i.villageid2020 ib(4).username_neemsis2, allbase
est store ars2_2


esttab ars1_1 ars1_2 ars2_1 ars2_2 using "_reg.csv", ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)) t(fmt(2)par)") /// 
	drop() ///	
	legend label varlabels(_cons constant) ///
	stats(N r2 F, fmt(0 3 3) labels(`"Observations"' `"\$R^2$"' `"F"')) ///
	replace





********** ES distribution
stripplot cr_ES2016 cr_ES2020 fa_ES2016 fa_ES2020 , over() separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(,angle(0))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel() ymtick() ytitle("") ///
legend(order(1 "Mean" 5 "Individual"))



********** Naïve Big-5
*** Abs instability 
reg abs_instab_cr ///
i.female ///
b(1).caste ///
ib(0).age_cat ///
ib(0).educode ///
ib(2).moc_indiv ///
ib(2).annualincome_indiv2016_q ///
i.dummydemonetisation2016 ///
i.villageid2016 ///
ib(1).diff_ars3_cat5 ///
i.username_encode_2020 ///
, cluster(cluster) allbase
est store cr_abs

*** Decrease
reg decrease_cr_ES ///
i.female ///
b(1).caste ///
ib(0).age_cat ///
ib(0).educode ///
ib(2).moc_indiv ///
ib(2).annualincome_indiv2016_q ///
i.dummydemonetisation2016 ///
i.villageid2016 ///
ib(1).diff_ars3_cat5 ///
i.username_encode_2020 ///
, cluster(cluster) allbase
est store cr_dec

*** Increase
reg increase_cr_ES ///
i.female ///
ib(1).caste ///
ib(0).age_cat ///
ib(0).educode ///
ib(2).moc_indiv ///
ib(2).annualincome_indiv2016_q ///
i.dummydemonetisation2016 ///
i.villageid2016 ///
ib(1).diff_ars3_cat5 ///
i.username_encode_2020 ///
, cluster(cluster) allbase
est store cr_inc





********** EFA
*** Abs instability
reg abs_instab_fa ///
i.female ///
b(1).caste ///
ib(0).age_cat ///
ib(0).educode ///
ib(2).moc_indiv ///
ib(2).annualincome_indiv2016_q ///
i.dummydemonetisation2016 ///
i.villageid2016 ///
ib(1).diff_ars3_cat5 ///
i.username_encode_2020 ///
, cluster(cluster) allbase
est store fa_abs

*** Decrease
reg decrease_fa_ES ///
i.female ///
ib(1).caste ///
ib(0).age_cat ///
ib(0).educode ///
ib(2).moc_indiv ///
ib(2).annualincome_indiv2016_q ///
i.dummydemonetisation2016 ///
i.villageid2016 ///
ib(1).diff_ars3_cat5 ///
i.username_encode_2020 ///
, cluster(cluster) allbase
est store fa_dec

*** Increase
reg increase_fa_ES ///
i.female ///
ib(1).caste ///
ib(0).age_cat ///
ib(0).educode ///
ib(2).moc_indiv ///
ib(2).annualincome_indiv2016_q ///
i.dummydemonetisation2016 ///
i.villageid2016 ///
ib(1).diff_ars3_cat5 ///
i.username_encode_2020 ///
, cluster(cluster) allbase
est store fa_inc

esttab cr_abs cr_dec cr_inc fa_abs fa_dec fa_inc using "_reg.csv", ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star) se(fmt(2)par)") /// 
	drop() ///	
	legend label varlabels(_cons constant) ///
	stats(N r2 F, fmt(0 3 3) labels(`"Observations"' `"\$R^2$"' `"F"')) ///
	replace
****************************************
* END
