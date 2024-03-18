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
use "panel_stab_pooled_wide_v3", clear
est clear
graph drop _all


********** Histo + kdensity
***** ES
twoway__histogram_gen diff_fES, percent bin(70) gen(h x, replace)
twoway ///
(bar h x if x<-.5, color() barwidth(0.1)) ///
(bar h x if x>=-.5 & x<=.5, color() barwidth(0.1)) ///
(bar h x if x>.5, color() barwidth(0.1)) ///
(kdensity diff_fES, yaxis(2) lpattern(solid) bwidth(0.2)ytitle("Density", axis(2))) ///
, ///
ytitle("Percent") xtitle("ΔES") ///
ylabel(, grid gmax gmin) xlabel(, nogrid gmax gmin) ///
plotregion(margin(none)) legend(order(1 "Decreasing" 2 "Stable" 3 "Increasing") pos(6) col(3)) note("Kernel: epanechnikov" "Bandwidth=0.2", size(vsmall))
graph save "histo_fES.gph", replace
graph export "histo_fES.pdf", as(pdf) replace

***** OP
twoway__histogram_gen diff_fOP, percent bin(70) gen(h x, replace)
twoway ///
(bar h x if x<-.5, color() barwidth(0.1)) ///
(bar h x if x>=-.5 & x<=.5, color() barwidth(0.1)) ///
(bar h x if x>.5, color() barwidth(0.1)) ///
(kdensity diff_fOP, yaxis(2) lpattern(solid) bwidth(0.2)ytitle("Density", axis(2))) ///
, ///
ytitle("Percent") xtitle("ΔOP") ///
ylabel(, grid gmax gmin) xlabel(, nogrid gmax gmin) ///
plotregion(margin(none)) legend(order(1 "Decreasing" 2 "Stable" 3 "Increasing") pos(6) col(3)) note("Kernel: epanechnikov" "Bandwidth=0.2", size(vsmall))
graph save "histo_fES.gph", replace
graph export "histo_fES.pdf", as(pdf) replace

***** CO
twoway__histogram_gen diff_fCO, percent bin(70) gen(h x, replace)
twoway ///
(bar h x if x<-.5, color() barwidth(0.1)) ///
(bar h x if x>=-.5 & x<=.5, color() barwidth(0.1)) ///
(bar h x if x>.5, color() barwidth(0.1)) ///
(kdensity diff_fCO, yaxis(2) lpattern(solid) bwidth(0.2)ytitle("Density", axis(2))) ///
, ///
ytitle("Percent") xtitle("ΔCO") ///
ylabel(, grid gmax gmin) xlabel(, nogrid gmax gmin) ///
plotregion(margin(none)) legend(order(1 "Decreasing" 2 "Stable" 3 "Increasing") pos(6) col(3)) note("Kernel: epanechnikov" "Bandwidth=0.2", size(vsmall))
graph save "histo_fES.gph", replace
graph export "histo_fES.pdf", as(pdf) replace





********** Over items
***** ES
/*
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
*/





********** Difference stable/unstable
***** ES
cls
ta dumdiff_fES
ta sex dumdiff_fES, col nofreq chi2
ta caste dumdiff_fES, col nofreq chi2
ta age_cat dumdiff_fES, col nofreq chi2
ta educode dumdiff_fES, col nofreq chi2
ta moc_indiv dumdiff_fES, col nofreq chi2
ta annualincome_indiv2016_q dumdiff_fES, col nofreq chi2
ta dummydemonetisation2016 dumdiff_fES, col nofreq chi2
ta dummysell2020 dumdiff_fES, col nofreq chi2
ta diff_ars3_cat5 dumdiff_fES, col nofreq chi2

probit dumdiff_fES i.sex i.caste c.age2016 i.educode i.moc_indiv c.annualincome_HH2016 c.assets_total10002016 i.dummydemonetisation2016 i.dummysell2020 i.diff_ars3_cat5 i.villageid2016, cluster(cluster)


***** OP
cls
ta dumdiff_fOP
ta sex dumdiff_fOP, col nofreq chi2
ta caste dumdiff_fOP, col nofreq chi2
ta age_cat dumdiff_fOP, col nofreq chi2
ta educode dumdiff_fOP, col nofreq chi2
ta moc_indiv dumdiff_fOP, col nofreq chi2
ta annualincome_indiv2016_q dumdiff_fOP, col nofreq chi2
ta dummydemonetisation2016 dumdiff_fOP, col nofreq chi2
ta dummysell2020 dumdiff_fOP, col nofreq chi2
ta diff_ars3_cat5 dumdiff_fOP, col nofreq chi2

probit dumdiff_fOP i.sex i.caste c.age2016 i.educode i.moc_indiv c.annualincome_HH2016 c.assets_total10002016 i.dummydemonetisation2016 i.dummysell2020 i.diff_ars3_cat5 i.villageid2016, cluster(cluster)



***** CO
cls
ta dumdiff_fCO
ta sex dumdiff_fCO, col nofreq chi2
ta caste dumdiff_fCO, col nofreq chi2
ta age_cat dumdiff_fCO, col nofreq chi2
ta educode dumdiff_fCO, col nofreq chi2
ta moc_indiv dumdiff_fCO, col nofreq chi2
ta annualincome_indiv2016_q dumdiff_fCO, col nofreq chi2
ta dummydemonetisation2016 dumdiff_fCO, col nofreq chi2
ta dummysell2020 dumdiff_fCO, col nofreq chi2
ta diff_ars3_cat5 dumdiff_fCO, col nofreq chi2

probit dumdiff_fCO i.sex i.caste c.age2016 i.educode i.moc_indiv c.annualincome_HH2016 c.assets_total10002016 i.dummydemonetisation2016 i.dummysell2020 i.diff_ars3_cat5 i.villageid2016, cluster(cluster)





********** Difference over trajectory
***** ES
cls
ta catdiff_fES
ta sex catdiff_fES, col nofreq chi2
ta caste catdiff_fES, col nofreq chi2
ta age_cat catdiff_fES, col nofreq chi2
ta educode catdiff_fES, col nofreq chi2
ta moc_indiv catdiff_fES, col nofreq chi2
ta annualincome_indiv2016_q catdiff_fES, col nofreq chi2
ta dummydemonetisation2016 catdiff_fES, col nofreq chi2
ta dummysell2020 catdiff_fES, col nofreq chi2
ta diff_ars3_cat5 catdiff_fES, col nofreq chi2

mprobit catdiff_fES i.sex i.caste c.age2016 i.educode i.moc_indiv c.annualincome_HH2016 c.assets_total10002016 i.dummydemonetisation2016 i.dummysell2020 i.diff_ars3_cat5 i.villageid2016, cluster(cluster)


***** OP
cls
ta catdiff_fOP
ta sex catdiff_fOP, col nofreq chi2
ta caste catdiff_fOP, col nofreq chi2
ta age_cat catdiff_fOP, col nofreq chi2
ta educode catdiff_fOP, col nofreq chi2
ta moc_indiv catdiff_fOP, col nofreq chi2
ta annualincome_indiv2016_q catdiff_fOP, col nofreq chi2
ta dummydemonetisation2016 catdiff_fOP, col nofreq chi2
ta dummysell2020 catdiff_fOP, col nofreq chi2
ta diff_ars3_cat5 catdiff_fOP, col nofreq chi2

mprobit catdiff_fOP i.sex i.caste c.age2016 i.educode i.moc_indiv c.annualincome_HH2016 c.assets_total10002016 i.dummydemonetisation2016 i.dummysell2020 i.diff_ars3_cat5 i.villageid2016, cluster(cluster)



***** CO
cls
ta catdiff_fCO
ta sex catdiff_fCO, col nofreq chi2
ta caste catdiff_fCO, col nofreq chi2
ta age_cat catdiff_fCO, col nofreq chi2
ta educode catdiff_fCO, col nofreq chi2
ta moc_indiv catdiff_fCO, col nofreq chi2
ta annualincome_indiv2016_q catdiff_fCO, col nofreq chi2
ta dummydemonetisation2016 catdiff_fCO, col nofreq chi2
ta dummysell2020 catdiff_fCO, col nofreq chi2
ta diff_ars3_cat5 catdiff_fCO, col nofreq chi2

mprobit catdiff_fCO i.sex i.caste c.age2016 i.educode i.moc_indiv c.annualincome_HH2016 c.assets_total10002016 i.dummydemonetisation2016 i.dummysell2020 i.diff_ars3_cat5 i.villageid2016, cluster(cluster)



****************************************
* END














****************************************
* ECON on abs var
****************************************
use "panel_stab_pooled_wide_v3", clear
est clear
graph drop _all


foreach x in ES OP CO {

***** Unstable
qui glm abs_diff_rec_f`x' ///
i.female ///
i.educode ///
i.age_cat ///
ib(2).moc_indiv ///
i.marital ///
ib(2).annualincome_HH2016_q ///
ib(2).assets2016_q ///
ib(1).caste ///
ib(1).diff_ars3_cat5 ///
i.username_neemsis2 ///
i.villageid2016 ///
i.dummydemonetisation2016 ///
i.dummysell2020 ///
if catdiff_f`x'==1 | catdiff_f`x'==3 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store all_`x'


***** Increasing
qui glm abs_diff_rec_f`x' ///
i.female ///
i.educode ///
i.age_cat ///
ib(2).moc_indiv ///
i.marital ///
ib(2).annualincome_HH2016_q ///
ib(2).assets2016_q ///
ib(1).caste ///
ib(1).diff_ars3_cat5 ///
i.username_neemsis2 ///
i.villageid2016 ///
i.dummydemonetisation2016 ///
i.dummysell2020 ///
if catdiff_f`x'==3 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store inc_`x'


***** Decreasing
qui glm abs_diff_rec_f`x' ///
i.female ///
i.educode ///
i.age_cat ///
ib(2).moc_indiv ///
i.marital ///
ib(2).annualincome_HH2016_q ///
ib(2).assets2016_q ///
ib(1).caste ///
ib(1).diff_ars3_cat5 ///
i.username_neemsis2 ///
i.villageid2016 ///
i.dummydemonetisation2016 ///
i.dummysell2020 ///
if catdiff_f`x'==1 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store dec_`x'
}



********** Format
esttab all_ES inc_ES dec_ES all_OP inc_OP dec_OP all_CO inc_CO dec_CO using "reg.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N ll, fmt(0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Log-pseudo likelihood"'))

****************************************
* END


