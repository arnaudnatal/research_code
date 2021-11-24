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
* ECON on bias
****************************************
use "panel_stab_wide_v5", clear

fre moc_indiv

********** Assessment: bias higher in 2020-21 than in 2016-17.
/*
stripplot ars32016 ars32020, over() separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(1 "2016-17" 2 "2020-21",angle(0))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel() ymtick() ytitle("") ///
legend(order(1 "Mean" 5 "Individual") off) name(ars_global, replace)
graph export "bias_panel.pdf", replace
*/


********** Role of enumerator
label define usercode 1"Enum: 1" 2"Enum: 2" 3"Enum: 3" 4"Enum: 4" 5"Enum: 5" 6"Enum: 6" 7"Enum: 7" 8"Enum: 8"
label values username_neemsis1 usercode
label values username_neemsis2 usercode
fre username_neemsis1 username_neemsis2

*** 2016-17
reg ars32016 i.sex i.caste ib(1).age_cat ib(0).educode i.villageid2016, allbase
est store ars1_1

reg ars32016 i.sex i.caste ib(1).age_cat ib(0).educode i.villageid2016 ib(4).username_neemsis1, allbase
est store ars1_2


*** 2020-21
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
* Desc p1
****************************************
use "panel_stab_wide_v5", clear

tab age25
keep if age25==1
* 740 individuals on 835


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
ta sex diff_fa_ES_cat5, col nofreq chi2
ta caste diff_fa_ES_cat5, col nofreq chi2
ta age_cat diff_fa_ES_cat5, col nofreq chi2
ta educode diff_fa_ES_cat5, col nofreq chi2
ta moc_indiv diff_fa_ES_cat5, col nofreq chi2
ta annualincome_indiv2016_q diff_fa_ES_cat5, col nofreq chi2
ta dummydemonetisation2016 diff_fa_ES_cat5, col nofreq chi2
ta covsellland2020 diff_fa_ES_cat5, col nofreq chi2

ta villageid2016 diff_fa_ES_cat5, col nofreq chi2
ta diff_ars3_cat5 diff_fa_ES_cat5, col nofreq chi2
ta username_neemsis2 diff_fa_ES_cat5, col nofreq chi2

tabstat age2016 annualincome_indiv2016 assets2016 diff_ars3 ars32016 ars32020, stat(n mean sd p50) by(diff_fa_ES_cat5)


*** How much the bias explain?
reg abs_diff_fa_ES_cat5 i.sex i.caste ib(1).age_cat ib(0).educode i.villageid2020, allbase
* R2 --> 3.85
reg abs_diff_fa_ES_cat5 diff_ars3 i.sex i.caste ib(1).age_cat ib(0).educode i.villageid2020, allbase
* R2 --> 3.74


reg abs_diff_fa_ES i.sex i.caste ib(1).age_cat ib(0).educode i.villageid2020, allbase
* R2 --> 7.40
reg abs_diff_fa_ES diff_ars3 i.sex i.caste ib(1).age_cat ib(0).educode i.villageid2020, allbase
* R2 --> 13.89





****************************************
* END














****************************************
* ECON on abs var
****************************************
use "panel_stab_wide_v5", clear
keep if age25==1

recode pathabs_diff_fa_cat5 (1=0) (2=1)
label define pathabs_diff_fa_cat5 0"Decreasing" 1"Increasing"
label values pathabs_diff_fa_cat5 pathabs_diff_fa_cat5


*** Naïve taxonomy
* No interraction
reg abs_diff_fa_ES ///
i.female ///
ib(1).caste ///
i.educode ///
i.age_cat ///
ib(2).moc_indiv ///
i.marital ///
ib(2).annualincome_indiv2016_q ///
i.dummydemonetisation2016 ///
i.covsellland2020 ///
ib(2).assets2016_q ///
i.villageid2016 ///
ib(2).diff_ars3_cat5 ///
i.username_neemsis2 ///
, cluster(cluster) allbase
est store abs_diff


* Interaction
reg abs_diff_fa_ES ///
i.female##pathabs_diff_fa_cat5 ///
ib(1).caste##pathabs_diff_fa_cat5 ///
i.educode##pathabs_diff_fa_cat5 ///
i.age_cat##pathabs_diff_fa_cat5 ///
ib(2).moc_indiv##pathabs_diff_fa_cat5 ///
i.marital##pathabs_diff_fa_cat5 ///
ib(2).annualincome_indiv2016_q##pathabs_diff_fa_cat5 ///
i.dummydemonetisation2016 ///
i.covsellland2020 ///
ib(2).assets2016_q ///
i.villageid2016 ///
ib(2).diff_ars3_cat5 ///
i.username_neemsis2 ///
, cluster(cluster)
est store abs_diff_int

margins, dydx(female caste age_cat educode moc_indiv marital annualincome_indiv2016_q) at(pathabs_diff_fa_cat5=(0 1)) atmeans allbase saving(margin, replace)


esttab abs_diff using "_reg.csv", ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star) se(fmt(2)par)") /// 
	drop() ///	
	legend label varlabels(_cons constant) ///
	stats(N r2 F, fmt(0 3 3) labels(`"Observations"' `"\$R^2$"' `"F"')) ///
	replace


fre female caste educode age_cat moc_indiv marital annualincome_indiv2016_q

****************************************
* END













****************************************
* Format
****************************************
use"margin", clear

label define cat 2"Sex: Female" 4"Caste: Middle" 5"Caste: Upper" 7"Edu: Primary" 8"Edu: High school" 9"Edu: HSC-Diploma or more" 11"Age: [35;45[" 12"Age: [45;55[" 13"Age: [55;+[" 14"Occ: No occupation" 15"Occ: Agriculture" 17"Occ: Coolie" 18"Occ: Regular" 19"Occ: SE" 20"Occ: NREGA" 22"Married: No" 23"Income: T1" 25"Income: T3", replace
label values _deriv cat
decode _deriv, gen(deriv)
tostring _at, gen(at)
replace at="1" if _at==1
replace at="2" if _at==2
keep _deriv at _margin _se _statistic _pvalue _ci_lb _ci_ub
foreach y in margin se statistic pvalue ci_lb ci_ub {
gen `y'=_`y'
}
keep _deriv margin se pvalue at

gen margin_str=strofreal(margin, "%9.2f")
gen se_str=strofreal(se, "%9.2f")
gen pvalue_str=strofreal(pvalue, "%9.2f")
foreach x in margin se pvalue {
drop `x'
rename `x'_str `x'
}

gen xo="("
gen xc=")"
egen se_par=concat(xo se xc)
drop se xo xc
rename se_par se
order se, after(margin)
reshape wide margin se pvalue, i(_deriv) j(at) string
decode _deriv, gen(cat)
drop _deriv
order cat

gen nstr=""
order nstr, after(pvalue1)

gen n=_n
set obs `=_N+1'
recode n (.=0)
sort n
replace cat="Sex: Male (ref.)" if cat==""
drop n

gen n=_n
set obs `=_N+1'
recode n (.=2.5)
sort n
replace cat="Caste: Dalit (ref.)" if cat==""
drop n

gen n=_n
set obs `=_N+1'
recode n (.=5.5)
sort n
replace cat="Edu: Below primary (ref.)" if cat==""
drop n

gen n=_n
set obs `=_N+1'
recode n (.=9.5)
sort n
replace cat="Age: [25;35[ (ref.)" if cat==""
drop n

gen n=_n
set obs `=_N+1'
recode n (.=15.5)
sort n
replace cat="Occ: Agri coolie (ref.)" if cat==""
drop n

gen n=_n
set obs `=_N+1'
recode n (.=20.5)
sort n
replace cat="Married: Yes (ref.)" if cat==""
drop n

gen n=_n
set obs `=_N+1'
recode n (.=23.5)
sort n
replace cat="Income: T2 (ref.)" if cat==""
drop n

gen n=_n
set obs `=_N+1'
recode n (.=0)
sort n
forvalues i=1(1)2 {
replace margin`i'="ME" if margin`i'=="" & n==0
replace se`i'="Std. Err." if se`i'=="" & n==0
replace pvalue`i'="p-value" if pvalue`i'=="" & n==0
}
drop n

gen n=_n
set obs `=_N+1'
recode n (.=0)
sort n
replace margin1="Average decreasing indiv." if n==0
replace margin2="Average increasing indiv." if n==0
drop n
replace margin1="." if margin1==""
replace margin2="." if margin2==""

export excel "margin.xlsx", replace
****************************************
* END
