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
set scheme plotplain


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
use "panel_stab_wide_v5", clear
keep if age25==1
*740 individuals


********** Cross table
*** Diff at 5%
ta diff_cr_ES_cat5 diff_fa_ES_cat5
ta diff_cr_ES_cat5 diff_fa_ES_cat5, cell nofreq

*** Diff at 10%
ta diff_cr_ES_cat10 diff_fa_ES_cat10, cell nofreq

*** Delta at 5%
ta delta_cr_ES_cat5 delta_fa_ES_cat5, cell nofreq

*** Delta at 10%
ta delta_cr_ES_cat10 delta_fa_ES_cat10, cell nofreq




********** Difference
tabstat diff_fa_ES diff_cr_ES, stat(min max)
replace diff_cr_ES=2 if diff_cr_ES>2

/*
*** Scatter
twoway ///
(scatter diff_fa_ES diff_cr_ES, xline(-.25 .25) yline(-.25 .25) msymbol() msize(vsmall)) ///
(lfit diff_fa_ES diff_cr_ES, lpattern(solid)), ///
xtitle("ΔES - Naïve appr.") ytitle("ΔES - Factor app.") ///
xlabel(-4"0" -2"-2" 0"0" 2"2", gmax gmin grid) ylabel(-4"" -2"-2" 0"0" 2"2" 4"4", gmin gmax grid) ///
plotregion(margin(none)) ///
legend(order(1 "Indiv." 2 "Fit.") pos(11) col(2) off) name(scatter_cent, replace) ysc(alt) xsc(alt)


*** histo x
twoway__histogram_gen diff_cr_ES, percent bin(71) gen(h x, replace)
twoway ///
(bar h x if x<-.25, color() barwidth(0.08)) ///
(bar h x if x>=-.25 & x<=.25, color() barwidth(0.08)) ///
(bar h x if x>.25, color() barwidth(0.08)) ///
, ///
xtitle("ΔES - Naïve app.") ytitle("Percent") ///
ylabel(0" 0" 1"1" 2"2" 3"3" 4"4" 5"5", nogrid gmax gmin labsize(small)) xlabel(, grid gmax gmin) ///
plotregion(margin(none)) legend(order(1 "Stab." 2 "Instab.") pos(6) col(2) off) name(histo_x, replace) ysc(reverse alt)


*** histo y
twoway__histogram_gen diff_fa_ES, percent bin(70) gen(h x, replace)
twoway ///
(bar h x if x<-.25, color() barwidth(0.1) horizontal) ///
(bar h x if x>=-.25 & x<=.25, color() barwidth(0.1) horizontal) ///
(bar h x if x>.25, color() barwidth(0.1) horizontal) ///
, ///
xtitle("Percent") ytitle("ΔES - Factor app.") ///
ylabel(, grid gmax gmin) xlabel(, nogrid gmax gmin) ///
plotregion(margin(none)) legend(order(1 "Decreasing" 2 "Stable" 3 "Increasing") pos(1) col(3) off) name(histo_y, replace) xsc(reverse alt)


*** Combine
grc1leg histo_y scatter_cent histo_x ///
, hole(3) imargin(0 0 0 0) graphregion(margin(l=0 r=0)) ///
leg(histo_y) ///
name(scatter_histo_new, replace) scale(1)
graph export "histo_abs.pdf", replace
*/



********** Difference over trajectory
*** Descriptive statistics for factor Big-5
cls
tab sex diff_fa_ES_cat5, col nofreq
tab caste diff_fa_ES_cat5, col nofreq
tab age_cat diff_fa_ES_cat5, col nofreq
tab educode diff_fa_ES_cat5, col nofreq
tab dummydemonetisation2016 diff_fa_ES_cat5, col nofreq
tab covsellland2020 diff_fa_ES_cat5, col nofreq

tab sex diff_fa_ES_cat5, chi2 nofreq
tab caste diff_fa_ES_cat5, chi2 nofreq
tab age_cat diff_fa_ES_cat5, chi2 nofreq
tab educode diff_fa_ES_cat5, chi2 nofreq
tab dummydemonetisation2016 diff_fa_ES_cat5, chi2 nofreq
tab covsellland2020 diff_fa_ES_cat5, chi2 nofreq
****************************************
* END





















****************************************
* ECON on bias
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
/*
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
*/

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

****************************************
* END









****************************************
* ECON on abs var
****************************************
use "panel_stab_wide_v5", clear
keep if age25==1


*** Naïve taxonomy
* Total sample
reg abs_cr_ES i.female b(1).caste ib(0).age_cat ib(0).educode ib(2).moc_indiv ib(2).annualincome_indiv2016_q i.dummydemonetisation2016 i.covsellland2020 i.villageid2016 ib(1).diff_ars3_cat5 i.username_encode_2020 if abs_instab5==1, cluster(cluster) allbase

* Interaction var
qui reg abs_cr_ES i.path_abs_cr5##i.female i.path_abs_cr5##i.caste i.path_abs_cr5##i.age_cat i.path_abs_cr5##i.educode i.path_abs_cr5##i.moc_indiv i.path_abs_cr5##i.annualincome_indiv2016_q i.dummydemonetisation2016 i.covsellland2020 i.villageid2016 i.diff_ars3_cat5 i.username_encode_2020 if abs_instab5==1, cluster(cluster)
margins, dydx(female caste age_cat educode moc_indiv) at(path_abs_cr5=(1 2)) atmeans



****************************************
* END











****************************************
* ECON on var
****************************************
use "panel_stab_wide_v5", clear
keep if age25==1


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
