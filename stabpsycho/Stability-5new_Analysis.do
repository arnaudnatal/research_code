*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*March 19, 2024
*-----
gl link = "stabpsycho"
*Stab
*-----
do "C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------






****************************************
* Scatter scores
****************************************
use "panel_stab_pooled_wide_v3", clear
est clear
graph drop _all

***** ES
preserve
tabstat fES2016 fES2020, stat(n min max)
replace fES2016=0 if fES2016<0 & fES2016!=.
replace fES2020=0 if fES2020<0 & fES2020!=.
twoway ///
(scatter fES2020 fES2016, mcolor(black%30)) ///
(function y=x, range(1 5)) ///
, xtitle("Score in 2016-17") ytitle("Score in 2020-21") ///
title(" 'Emotional stability' factor") name(s_fES, replace) legend(order(1 "Individual" 2 "First bisector") pos(6) col(2))
graph export "distri_fES.pdf", as(pdf) replace 
graph save "distri_fES.gph", replace
restore


***** OP
preserve
tabstat fOP2016 fOP2020, stat(n min max)
replace fOP2016=0 if fOP2016<0 & fOP2016!=.
replace fOP2020=0 if fOP2020<0 & fOP2020!=.
twoway ///
(scatter fOP2020 fOP2016, mcolor(black%30)) ///
(function y=x, range(1 5)) ///
, xtitle("Score in 2016-17") ytitle("Score in 2020-21") ///
title(" 'Openness to experience' factor") name(s_fOP, replace) legend(order(1 "Individual" 2 "First bisector") pos(6) col(2))
graph export "distri_fOP.pdf", as(pdf) replace 
graph save "distri_fOP.gph", replace
restore


***** CO
preserve
tabstat fCO2016 fCO2020, stat(n min max)
replace fCO2016=0 if fCO2016<0 & fCO2016!=.
replace fCO2020=0 if fCO2020<0 & fCO2020!=.
twoway ///
(scatter fCO2020 fCO2016, mcolor(black%30)) ///
(function y=x, range(1 5)) ///
, xtitle("Score in 2016-17") ytitle("Score in 2020-21") ///
title(" 'Conscientiousness' factor") name(s_fCO, replace) legend(order(1 "Individual" 2 "First bisector") pos(6) col(2))
graph export "distri_fCO.pdf", as(pdf) replace 
graph save "distri_fCO.gph", replace
restore


****************************************
* END



















****************************************
* Diff graphs
****************************************
use "panel_stab_pooled_wide_v3", clear
est clear
graph drop _all


***** ES
twoway__histogram_gen diff_fES, percent bin(70) gen(h x, replace)
twoway ///
(bar h x if x<-.5, color() barwidth(0.1)) ///
(bar h x if x>=-.5 & x<=.5, color() barwidth(0.1)) ///
(bar h x if x>.5, color() barwidth(0.1)) ///
(kdensity diff_fES, yaxis(2) lpattern(solid) bwidth(0.2)ytitle("Density", axis(2))) ///
, ///
ytitle("Percent") xtitle("ES_2020 - ES_2016") ///
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
ytitle("Percent") xtitle("OP_2020 - OP_2016") ///
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
ytitle("Percent") xtitle("CO_2020 - CO_2016") ///
ylabel(, grid gmax gmin) xlabel(, nogrid gmax gmin) ///
plotregion(margin(none)) legend(order(1 "Decreasing" 2 "Stable" 3 "Increasing") pos(6) col(3)) note("Kernel: epanechnikov" "Bandwidth=0.2", size(vsmall))
graph save "histo_fES.gph", replace
graph export "histo_fES.pdf", as(pdf) replace


****************************************
* END















/*
****************************************
* Over items
****************************************
use "panel_stab_pooled_wide_v3", clear
est clear
graph drop _all


***** ES
global fvES enjoypeople rudetoother shywithpeople repetitivetasks putoffduties feeldepressed changemood nervous easilyupset easilydistracted worryalot

graph drop _all
set graph off
foreach x in $fvES {
preserve
replace imcr_`x'2016=0 if imcr_`x'2016<0 & imcr_`x'2016!=.
replace imcr_`x'2020=0 if imcr_`x'2020<0 & imcr_`x'2020!=.
set graph off
twoway (scatter imcr_`x'2020 imcr_`x'2016, mcolor(black%30)) (function y=x, range(0 6)), xtitle("Score in 2016-17") ytitle("Score in 2020-21") title("`x'") name(s_`x') legend(order(1 "Individual" 2 "First bisector") pos(6) col(2))
restore
}
set graph on
grc1leg s_enjoypeople s_rudetoother s_shywithpeople s_repetitivetasks s_putoffduties s_feeldepressed s_changemood s_nervous s_easilyupset s_easilydistracted s_worryalot, col(4) title("Items of the 'Emotional stability' factor")
graph export "sub_fES.pdf", as(pdf) replace 
graph save "sub_fES.gph", replace





***** OP
global fvOP interestedbyart liketothink activeimagination inventive newideas curious

graph drop _all
set graph off
foreach x in $fvOP {
preserve
replace imcr_`x'2016=0 if imcr_`x'2016<0 & imcr_`x'2016!=.
replace imcr_`x'2020=0 if imcr_`x'2020<0 & imcr_`x'2020!=.
set graph off
twoway (scatter imcr_`x'2020 imcr_`x'2016, mcolor(black%30)) (function y=x, range(0 6)), xtitle("Score in 2016-17") ytitle("Score in 2020-21") title("`x'") name(s_`x') legend(order(1 "Individual" 2 "First bisector") pos(6) col(2))
restore
}
set graph on
grc1leg s_interestedbyart s_liketothink s_activeimagination s_inventive s_newideas s_curious, col(3) title("Items of the 'Openness to experience' factor")
graph export "sub_fOP.pdf", as(pdf) replace 
graph save "sub_fOP.gph", replace




***** CO
global fvCO workwithother organized appointmentontime workhard makeplans completeduties enthusiastic

graph drop _all
set graph off
foreach x in $fvCO {
preserve
replace imcr_`x'2016=0 if imcr_`x'2016<0 & imcr_`x'2016!=.
replace imcr_`x'2020=0 if imcr_`x'2020<0 & imcr_`x'2020!=.
set graph off
twoway (scatter imcr_`x'2020 imcr_`x'2016, mcolor(black%30)) (function y=x, range(0 6)), xtitle("Score in 2016-17") ytitle("Score in 2020-21") title("`x'") name(s_`x') legend(order(1 "Individual" 2 "First bisector") pos(6) col(2))
restore
}
set graph on
grc1leg s_workwithother s_organized s_appointmentontime s_workhard s_makeplans s_completeduties s_enthusiastic, col(4) title("Items of the 'Conscientiousness' factor")
graph export "sub_fCO.pdf", as(pdf) replace 
graph save "sub_fCO.gph", replace

****************************************
* END
*/
























****************************************
* Probit stable vs unstable
****************************************
use "panel_stab_pooled_wide_v3", clear
est clear
graph drop _all


***** Macro
global indiv c.age2016 i.sex i.educode i.moc_indiv i.marital
global cogni fES2016 fOP2016 fCO2016 num_tt2016 lit_tt2016 raven_tt2016
global house i.caste i.assets2016_q i.annualincome_HH2016_q c.HHsize2016 i.typeoffamily2016
global contr i.username_neemsis1 i.username_neemsis2 c.ars32016 i.diff_ars3_cat5 i.villageid2016
global shock dummysell2020 dummydemonetisation2016 dummyshockland dummyshockdebt dummyshockhealth dummyshockemployment


***** ES
probit dumdiff_fES $indiv $cogni $house $shock $contr, cluster(cluster) baselevel
est store reg1
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar1



***** OP
probit dumdiff_fOP $indiv $cogni $house $shock $contr, cluster(cluster) baselevel
est store reg2
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar2

***** CO
probit dumdiff_fCO $indiv $cogni $house $shock $contr, cluster(cluster) baselevel
est store reg3
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar3


***** Tables
esttab reg1 mar1 reg2 mar2 reg3 mar3 using "probit.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N r2_p, fmt(0 2) ///
	labels(`"Observations"' `"Pseudo R2"'))

****************************************
* END




















****************************************
* Multi probit stable vs dec vs inc
****************************************
use "panel_stab_pooled_wide_v3", clear
est clear
graph drop _all


***** Macro
global indiv c.age2016 i.sex i.educode i.moc_indiv i.marital
global cogni fES2016 fOP2016 fCO2016 num_tt2016 lit_tt2016 raven_tt2016
global house i.caste i.assets2016_q i.annualincome_HH2016_q c.HHsize2016 i.typeoffamily2016
global contr i.username_neemsis1 i.username_neemsis2 c.ars32016 i.diff_ars3_cat5 i.villageid2016
global shock dummysell2020 dummydemonetisation2016 dummyshockland dummyshockdebt dummyshockhealth dummyshockemployment


***** ES
cls
mprobit catdiff_fES $indiv $cogni $house $shock $contr, cluster(cluster) baselevel baseoutcome(2)
est store reg1
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar1


***** OP
mprobit catdiff_fOP $indiv $cogni $house $shock $contr, cluster(cluster) baselevel baseoutcome(2)
est store reg2
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar2


***** CO
mprobit catdiff_fCO $indiv $cogni $house $shock $contr, cluster(cluster) baselevel baseoutcome(2)
est store reg3
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar3



***** Tables
esttab reg1 reg2 reg3 using "mprobit.xlsx", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
	
esttab mar1 mar2 mar3 using "mprobit_margins.xlsx", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END
















****************************************
* Degree of instability
****************************************
use "panel_stab_pooled_wide_v3", clear
est clear
graph drop _all


***** Macro
global indiv c.age2016 i.sex i.educode i.moc_indiv i.marital
global cogni fES2016 fOP2016 fCO2016 num_tt2016 lit_tt2016 raven_tt2016
global house i.caste i.assets2016_q i.annualincome_HH2016_q c.HHsize2016 i.typeoffamily2016
global contr i.username_neemsis1 i.username_neemsis2 c.ars32016 i.diff_ars3_cat5 i.villageid2016
global shock dummysell2020 dummydemonetisation2016 dummyshockland dummyshockdebt dummyshockhealth dummyshockemployment



***** ES
* Unstable
glm abs_diff_rec_fES $indiv $cogni $house $shock $contr ///
if catdiff_fES==1 | catdiff_fES==3 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store reg1ES
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar1ES

* Increasing
glm abs_diff_rec_fES $indiv $cogni $house $shock $contr ///
if catdiff_fES==3 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store reg2ES
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar2ES

* Decreasing
glm abs_diff_rec_fES $indiv $cogni $house $shock $contr ///
if catdiff_fES==1 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store reg3ES
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar3ES





***** OP
* Unstable
glm abs_diff_rec_fOP $indiv $cogni $house $shock $contr ///
if catdiff_fOP==1 | catdiff_fOP==3 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store reg1OP
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar1OP

* Increasing
glm abs_diff_rec_fOP $indiv $cogni $house $shock $contr ///
if catdiff_fOP==3 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store reg2OP
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar2OP

* Decreasing
glm abs_diff_rec_fOP $indiv $cogni $house $shock $contr ///
if catdiff_fOP==1 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store reg3OP
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar3OP




***** CO
* Unstable
glm abs_diff_rec_fCO $indiv $cogni $house $shock $contr ///
if catdiff_fCO==1 | catdiff_fCO==3 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store reg1CO
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar1CO

* Increasing
glm abs_diff_rec_fCO $indiv $cogni $house $shock $contr ///
if catdiff_fCO==3 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store reg2CO
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar2CO

* Decreasing
glm abs_diff_rec_fCO $indiv $cogni $house $shock $contr ///
if catdiff_fCO==1 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store reg3CO
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar3CO



********** Format
esttab ///
reg1ES mar1ES reg2ES mar2ES reg3ES mar3ES ///
reg1OP mar1OP reg2OP mar2OP reg3OP mar3OP ///
reg1CO mar1CO reg2CO mar2CO reg3CO mar3CO ///
using "glm.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N ll, fmt(0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Log-pseudo likelihood"'))
****************************************
* END












