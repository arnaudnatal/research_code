*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*April 23, 2021
*-----
gl link = "stabpsycho"
*Stab
*-----
do "C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------











****************************************
* Desc p1
****************************************
use "panel_stab_wide_v5", clear

ta age25

*keep if age25==1
* 740 individuals on 835

ta diff_fa_ES


********** Histo + kdensity
twoway__histogram_gen diff_fa_ES, percent bin(70) gen(h x, replace)
twoway ///
(bar h x if x<-.5, color() barwidth(0.1)) ///
(bar h x if x>=-.5 & x<=.5, color() barwidth(0.1)) ///
(bar h x if x>.5, color() barwidth(0.1)) ///
(kdensity diff_fa_ES, yaxis(2) lpattern(solid) bwidth(0.2)ytitle("Density", axis(2))) ///
, ///
xtitle("Percent") ytitle("ΔES") ///
ylabel(, grid gmax gmin) xlabel(, nogrid gmax gmin) ///
plotregion(margin(none)) legend(order(1 "Decreasing" 2 "Stable" 3 "Increasing") pos(6) col(3)) note("Kernel: epanechnikov" "Bandwidth=0.2", size(vsmall))
graph save "histo_ES.gph", replace
graph export "histo_ES.pdf", as(pdf) replace




********** Over items
graph drop _all
set graph off
foreach x in easilyupset nervous worryalot feeldepressed changemood easilydistracted shywithpeople putoffduties rudetoother repetitivetasks {
preserve
replace cr_`x'2016=0 if cr_`x'2016<0 & cr_`x'2016!=.
replace cr_`x'2020=0 if cr_`x'2020<0 & cr_`x'2020!=.
set graph off
twoway (scatter cr_`x'2020 cr_`x'2016, mcolor(black%30)) (function y=x, range(0 6)), xtitle("Score in 2016-17") ytitle("Score in 2020-21") title("`x'") name(s_`x') legend(order(1 "Individual" 2 "First bisector") pos(6) col(2))
restore
}
set graph on
grc1leg s_easilyupset s_nervous s_worryalot s_feeldepressed s_changemood s_easilydistracted s_shywithpeople s_putoffduties s_rudetoother s_repetitivetasks, col(5)
graph export "sub_ES.pdf", as(pdf) replace 
graph save "sub_ES.gph", replace



********** Difference over trajectory
cls
ta diff_fa_ES_cat10
ta sex diff_fa_ES_cat10, col nofreq chi2
ta caste diff_fa_ES_cat10, col nofreq chi2
ta age_cat diff_fa_ES_cat10, col nofreq chi2
ta educode diff_fa_ES_cat10, col nofreq chi2
ta moc_indiv diff_fa_ES_cat10, col nofreq chi2
ta annualincome_indiv2016_q diff_fa_ES_cat10, col nofreq chi2
ta dummydemonetisation2016 diff_fa_ES_cat10, col nofreq chi2
ta dummysell2020 diff_fa_ES_cat10, col nofreq chi2
ta diff_ars3_cat5 diff_fa_ES_cat10, col nofreq chi2


****************************************
* END














****************************************
* ECON on abs var
****************************************
use "panel_stab_wide_v5", clear
*keep if age25==1
estimates clear



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

ta abs_diff_fa_ES_cat10_cont



********** ALL
glm abs_diff_fa_ES_cat10_cont ///
i.female ///
i.educode ///
i.age_cat ///
ib(2).moc_indiv ///
i.marital ///
ib(2).annualincome_indiv2016_q ///
ib(2).assets2016_q ///
ib(1).caste ///
ib(1).diff_ars3_cat5 ///
i.username_neemsis2 ///
i.villageid2016 ///
i.dummydemonetisation2016 ///
i.dummysell2020 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store all
return list
ereturn list


/*
ols: 				AIC=1273.521 BIC=1456.313
glm, log-gaussian: 	AIC=1.982975 BIC=-3616.999
glm, log-igaussian: AIC=2.837847 BIC=-3756.35
glm, log-gamma: 	AIC=2.79641  BIC=-3733.987
*/



********** INC
glm abs_diff_fa_ES_cat10_cont_inc ///
i.female ///
i.educode ///
i.age_cat ///
ib(2).moc_indiv ///
i.marital ///
ib(2).annualincome_indiv2016_q ///
ib(2).assets2016_q ///
ib(1).caste ///
ib(1).diff_ars3_cat5 ///
i.username_neemsis2 ///
i.villageid2016 ///
i.dummydemonetisation2016 ///
i.dummysell2020 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store inc


/*
ols: 				AIC=202.0701 BIC=304.2251
glm, log-gaussian: 	AIC=1.977412 BIC=-233.1528
glm, log-igaussian: AIC=2.633504 BIC=-237.7469
glm, log-gamma: 	AIC=2.864126 BIC=-236.9501
*/




********** DEC
glm abs_diff_fa_ES_cat10_cont_dec ///
i.female ///
i.educode ///
i.age_cat ///
ib(2).moc_indiv ///
i.marital ///
ib(2).annualincome_indiv2016_q ///
ib(2).assets2016_q ///
ib(1).caste ///
ib(1).diff_ars3_cat5 ///
i.username_neemsis2 ///
i.villageid2016 ///
i.dummydemonetisation2016 ///
i.dummysell2020 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store dec



/*
ols: 				AIC=1086.89  BIC=1263.072
glm, log-gaussian: 	AIC=1.993537 BIC=-2960.46
glm, log-igaussian: AIC=2.998632 BIC=-3086.693
glm, log-gamma: 	AIC=2.907795 BIC=-3066.106
*/


********** Format
esttab all inc dec using "reg.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N ll, fmt(0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Log-pseudo likelihood"'))	

****************************************
* END








/*
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
ylabel(0" 0" 1"1" 2"2" 3"3" 4"4" 5"5", nogrid gmax gmin labsize(small)) xlabel(, grid gmax gmin) ///
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
