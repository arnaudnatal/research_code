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
set scheme plotplain

********** Path to folder "data" folder.
*** PC
global directory = "C:\Users\Arnaud\Documents\_Thesis\Research-Stability_skills\Analysis"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

*** Fac
*global directory = "C:\Users\anatal\Downloads\_Thesis\Research-Stability_skills\Analysis"
*cd "$directory"
*global git "C:\Users\anatal\Downloads\GitHub"

********** Name of the NEEMSIS2 questionnaire version to clean
global wave2 "NEEMSIS1-HH"
global wave3 "NEEMSIS2-HH"
****************************************
* END










****************************************
* ECON on bias
****************************************
use "panel_stab_wide_v6", clear

fre moc_indiv

fre pathabs_delta_fa_cat5 pathabs_delta_fa_cat10

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

/*
esttab ars1_1 ars1_2 ars2_1 ars2_2 using "_reg.csv", ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)) t(fmt(2)par)") /// 
	drop() ///	
	legend label varlabels(_cons constant) ///
	stats(N r2 F, fmt(0 3 3) labels(`"Observations"' `"\$R^2$"' `"F"')) ///
	replace
*/
	
****************************************
* END







****************************************
* Reliability
****************************************
use "panel_stab_wide_v6", clear

canon (fa_ES2016) (fa_ES2020), lc(1)
*0.0307

pwcorr fa_ES2016 fa_ES2020

****************************************
* END












****************************************
* Desc p1
****************************************
use "panel_stab_wide_v6", clear

tab age25
*keep if age25==1
* 740 individuals on 835


/*
*** Scatter
twoway ///
(scatter diff_fa_ES diff_cr_ES, xline(-.5 .5) yline(-.5 .5) msymbol() msize(vsmall)) ///
(lfit diff_fa_ES diff_cr_ES, lpattern(solid)), ///
xtitle("ΔES - Naïve appr.") ytitle("ΔES - Factor app.") ///
xlabel(-4"0" -2"-2" 0"0" 2"2", gmax gmin grid) ylabel(-4"" -2"-2" 0"0" 2"2" 4"4", gmin gmax grid) ///
plotregion(margin(none)) ///
legend(order(1 "Indiv." 2 "Fit.") pos(11) col(2) off) name(scatter_cent, replace) ysc(alt) xsc(alt)


*** histo x
twoway__histogram_gen diff_cr_ES, percent bin(71) gen(h x, replace)
twoway ///
(bar h x if x<-.5, color() barwidth(0.08)) ///
(bar h x if x>=-.5 & x<=.5, color() barwidth(0.08)) ///
(bar h x if x>.5, color() barwidth(0.08)) ///
, ///
xtitle("ΔES - Naïve app.") ytitle("Percent") ///
ylabel(0" 0" 1"1" 2"2" 3"3" 4"4" 5"5", nogrid gmax gmin labsize(small)) xlabel(, grid gmax gmin) ///
plotregion(margin(none)) legend(order(1 "Stab." 2 "Instab.") pos(6) col(2) off) name(histo_x, replace) ysc(reverse alt)


*** histo y
twoway__histogram_gen diff_fa_ES, percent bin(70) gen(h x, replace)
twoway ///
(bar h x if x<-.5, color() barwidth(0.1) horizontal) ///
(bar h x if x>=-.5 & x<=.5, color() barwidth(0.1) horizontal) ///
(bar h x if x>.5, color() barwidth(0.1) horizontal) ///
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



********** Over items
graph drop _all
set graph off
foreach x in easilyupset nervous worryalot feeldepressed changemood easilydistracted shywithpeople putoffduties rudetoother repetitivetasks {
preserve
replace cr_`x'2016=0 if cr_`x'2016<0 & cr_`x'2016!=.
replace cr_`x'2020=0 if cr_`x'2020<0 & cr_`x'2020!=.
set graph off
twoway (scatter cr_`x'2020 cr_`x'2016) (function y=x, range(0 6)), xtitle("Score in 2016-17") ytitle("Score in 2020-21") title("`x'") name(s_`x') legend(order(1 "Individual" 2 "First bisector") pos(6) col(2))
restore
}
set graph on
grc1leg s_easilyupset s_nervous s_worryalot s_feeldepressed s_changemood s_easilydistracted s_shywithpeople s_putoffduties s_rudetoother s_repetitivetasks, col(5)
graph export "sub_ES.pdf", as(pdf) replace 
graph save "sub_ES.gph", replace


********** Difference over trajectory
*** Descriptive statistics for factor Big-5
cls
ta diff_fa_ES_cat10
ta sex diff_fa_ES_cat10, row nofreq chi2
ta caste diff_fa_ES_cat10, row nofreq chi2
ta age_cat diff_fa_ES_cat10, row nofreq chi2
ta educode diff_fa_ES_cat10, row nofreq chi2
ta moc_indiv diff_fa_ES_cat10, row nofreq chi2
ta annualincome_indiv2016_q diff_fa_ES_cat10, row nofreq chi2
ta dummydemonetisation2016 diff_fa_ES_cat10, row nofreq chi2
ta covsellland2020 diff_fa_ES_cat10, row nofreq chi2

ta villageid2016 diff_fa_ES_cat10, row nofreq chi2
ta diff_ars3_cat5 diff_fa_ES_cat10, row nofreq chi2
ta username_neemsis2 diff_fa_ES_cat10, row nofreq chi2

tabstat age2016 annualincome_indiv2016 assets2016 diff_ars3 ars32016 ars32020, stat(n mean sd p50) by(diff_fa_ES_cat10)

ta caste diff_fa_ES_cat10, cchi2 exp chi2
ta age_cat diff_fa_ES_cat10, cchi2 exp chi2
ta educode diff_fa_ES_cat10, cchi2 exp chi2
ta moc_indiv diff_fa_ES_cat10, cchi2 exp chi2
ta dummydemonetisation2016 diff_fa_ES_cat10, cchi2 exp chi2
ta covsellland2020 diff_fa_ES_cat10, cchi2 exp chi2

ta diff_ars3_cat5 diff_fa_ES_cat10, cchi2 exp chi2
ta diff_ars3_cat5 diff_fa_ES_cat10, nofreq row

ta username_neemsis2 diff_fa_ES_cat10, cchi2 exp

********** How much the bias explain?
reg abs_diff_fa_ES_cat5 i.sex i.caste ib(1).age_cat ib(0).educode i.villageid2020, allbase
* R2 --> 3.85
reg abs_diff_fa_ES_cat5 diff_ars3 i.sex i.caste ib(1).age_cat ib(0).educode i.villageid2020, allbase
* R2 --> 3.74


reg abs_diff_fa_ES i.sex i.caste ib(1).age_cat ib(0).educode i.villageid2020, allbase
* R2 --> 7.40
reg abs_diff_fa_ES diff_ars3 i.sex i.caste ib(1).age_cat ib(0).educode i.villageid2020, allbase
* R2 --> 13.89






********** Contribution of enumerator in score of personality traits

***** 2016-17
reg fa_ES2016 i.female ib(1).caste i.educode i.age_cat ib(2).moc_indiv i.marital ib(2).annualincome_indiv2016_q, allbase
*R2a=0.0892
reg fa_ES2016 i.username_neemsis1 i.female ib(1).caste i.educode i.age_cat ib(2).moc_indiv i.marital ib(2).annualincome_indiv2016_q, allbase
*R2a=0.3036
dis (30.36-8.92)*100/8.92

***** 2020-21
reg fa_ES2020 i.female ib(1).caste i.educode i.age_cat ib(2).moc_indiv i.marital ib(2).annualincome_indiv2016_q, allbase
*R2a=0.0285
reg fa_ES2020 i.username_neemsis2 i.female ib(1).caste i.educode i.age_cat ib(2).moc_indiv i.marital ib(2).annualincome_indiv2016_q, allbase
*R2a=0.4093
dis (40.93-2.85)*100/2.85



****************************************
* END














****************************************
* ECON on abs var
****************************************
use "panel_stab_wide_v6", clear
*keep if age25==1


********** Recode before reg
recode pathabs_diff_fa_cat10 (1=0) (2=1)
label define pathabs_diff_fa_cat10 0"Decreasing" 1"Increasing"
label values pathabs_diff_fa_cat10 pathabs_diff_fa_cat10

ta pathabs_diff_fa_cat10

gen abs_diff_fa_ES_cat10_cont_dec=abs_diff_fa_ES_cat10_cont if pathabs_diff_fa_cat10==0
gen abs_diff_fa_ES_cat10_cont_inc=abs_diff_fa_ES_cat10_cont if pathabs_diff_fa_cat10==1

ta abs_diff_fa_ES_cat10_cont_dec
ta abs_diff_fa_ES_cat10_cont_inc

codebook caste
label define castecat2 1"Caste: Dalits" 2"Caste: Middle" 3"Caste: Upper", modify

/*
********** INC + DEC = FULL SAMPLE WITHOUT INT
reg abs_diff_fa_ES_cat10_cont ///
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
est store full
*/

********** INC
reg abs_diff_fa_ES_cat10_cont_inc ///
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
ib(1).diff_ars3_cat5 ///
i.username_neemsis2 ///
i.villageid2016 ///
, cluster(cluster) allbase
est store inc


********** DEC
reg abs_diff_fa_ES_cat10_cont_dec ///
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
ib(1).diff_ars3_cat5 ///
i.username_neemsis2 ///
i.villageid2016 ///
, cluster(cluster) allbase
est store dec
return list
ereturn list

	
esttab inc dec using "reg.tex", replace f ///
	label booktabs b(3) p(3) eqlabels(none) alignment(S S) collabels("\multicolumn{1}{c}{$\beta$}" "\multicolumn{1}{c}{Std. Err.}") ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star) se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N r2 r2_a F p, fmt(0 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"\(R^{2}\)"' `"Adjusted \(R^{2}\)"' `"F-stat"' `"p-value"'))

****************************************
* END	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
****************************************
* QUANTILE REG
****************************************
use "panel_stab_wide_v6", clear
*keep if age25==1


********** Recode before reg
recode pathabs_diff_fa_cat10 (1=0) (2=1)
label define pathabs_diff_fa_cat10 0"Decreasing" 1"Increasing"
label values pathabs_diff_fa_cat10 pathabs_diff_fa_cat10

ta pathabs_diff_fa_cat10

gen abs_diff_fa_ES_cat10_cont_dec=abs_diff_fa_ES_cat10_cont if pathabs_diff_fa_cat10==0
gen abs_diff_fa_ES_cat10_cont_inc=abs_diff_fa_ES_cat10_cont if pathabs_diff_fa_cat10==1

ta abs_diff_fa_ES_cat10_cont_dec
ta abs_diff_fa_ES_cat10_cont_inc


********** Qreg diff
sqreg abs_diff_fa_ES female caste_2 caste_3 educode_2 educode_3 educode_4 age_cat_1 age_cat_3 age_cat_4 age_cat_5 moc_indiv_1 moc_indiv_2 moc_indiv_4 moc_indiv_5 moc_indiv_6 moc_indiv_7 moc_indiv_8 marital annualincome_indiv2016_q_2 annualincome_indiv2016_q_3 dummydemonetisation2016 covsellland2020, quantile(.1 .2 .3 .4 .5 .6 .7 .8 .9) reps(100)

preserve
gen q = _n*10 in 1/9

foreach var of varlist female caste_2 caste_3 educode_2 educode_3 educode_4 age_cat_1 age_cat_3 age_cat_4 age_cat_5 moc_indiv_1 moc_indiv_2 moc_indiv_4 moc_indiv_5 moc_indiv_6 moc_indiv_7 moc_indiv_8 marital annualincome_indiv2016_q_2 annualincome_indiv2016_q_3 dummydemonetisation2016 covsellland2020 {
    gen _b_`var'  = .
    gen _lb_`var' = .
    gen _ub_`var' = .

    local i = 1
    foreach q of numlist 10(10)90 {
        replace _b_`var' = _b[q`q':`var'] in `i'
        replace _lb_`var' = _b[q`q':`var'] - _se[q`q':`var']*invnormal(.95) in `i'
        replace _ub_`var' = _b[q`q':`var'] + _se[q`q':`var']*invnormal(.95) in `i++'
    }
}
keep q _b_* _lb_* _ub_*
keep in 1/9
reshape long _b_ _lb_ _ub_, i(q) j(var) string
twoway rarea _lb_ _ub_ q, astyle(ci) yline(0) acolor(%90) || ///
   line _b_ q,                                               ///
   by(var, yrescale xrescale note("") legend(at(4) pos(0)))  ///
   legend(order(2 "effect"                                   ///      
                1 "95% confidence" "interval")               ///
          cols(1))                                           ///
   ytitle("")                       ///
   ylab(,angle(0) format(%7.0gc))                            ///    
   xlab(10(10)90) xtitle("")
restore

****************************************
* END
