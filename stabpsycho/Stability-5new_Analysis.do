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
(function y=x, range(0 6)) ///
, xtitle("Score in 2016-17") ytitle("Score in 2020-21") ///
title(" 'Emotional stability' factor") name(s_fES, replace) legend(order(1 "Individual" 2 "First bisector") pos(6) col(2))
graph export "new/distri_fES.pdf", as(pdf) replace 
graph save "new/distri_fES.gph", replace
restore


***** OPEX
preserve
tabstat fOPEX2016 fOPEX2020, stat(n min max)
replace fOPEX2016=0 if fOPEX2016<0 & fOPEX2016!=.
replace fOPEX2020=0 if fOPEX2020<0 & fOPEX2020!=.
twoway ///
(scatter fOPEX2020 fOPEX2016, mcolor(black%30)) ///
(function y=x, range(0 6)) ///
, xtitle("Score in 2016-17") ytitle("Score in 2020-21") ///
title(" 'Plasticity' factor") name(s_fOPEX, replace) legend(order(1 "Individual" 2 "First bisector") pos(6) col(2))
graph export "new/distri_fOPEX.pdf", as(pdf) replace 
graph save "new/distri_fOPEX.gph", replace
restore


***** CO
preserve
tabstat fCO2016 fCO2020, stat(n min max)
replace fCO2016=0 if fCO2016<0 & fCO2016!=.
replace fCO2020=0 if fCO2020<0 & fCO2020!=.
twoway ///
(scatter fCO2020 fCO2016, mcolor(black%30)) ///
(function y=x, range(0 6)) ///
, xtitle("Score in 2016-17") ytitle("Score in 2020-21") ///
title(" 'Conscientiousness' factor") name(s_fCO, replace) legend(order(1 "Individual" 2 "First bisector") pos(6) col(2))
graph export "new/distri_fCO.pdf", as(pdf) replace 
graph save "new/distri_fCO.gph", replace
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
graph save "new/histo_fES.gph", replace
graph export "new/histo_fES.pdf", as(pdf) replace

***** OP
twoway__histogram_gen diff_fOPEX, percent bin(70) gen(h x, replace)
twoway ///
(bar h x if x<-.5, color() barwidth(0.1)) ///
(bar h x if x>=-.5 & x<=.5, color() barwidth(0.1)) ///
(bar h x if x>.5, color() barwidth(0.1)) ///
(kdensity diff_fOPEX, yaxis(2) lpattern(solid) bwidth(0.2)ytitle("Density", axis(2))) ///
, ///
ytitle("Percent") xtitle("OPEX_2020 - OPEX_2016") ///
ylabel(, grid gmax gmin) xlabel(, nogrid gmax gmin) ///
plotregion(margin(none)) legend(order(1 "Decreasing" 2 "Stable" 3 "Increasing") pos(6) col(3)) note("Kernel: epanechnikov" "Bandwidth=0.2", size(vsmall))
graph save "new/histo_fOPEX.gph", replace
graph export "new/histo_fOPEX.pdf", as(pdf) replace

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
graph save "new/histo_fCO.gph", replace
graph export "new/histo_fCO.pdf", as(pdf) replace


****************************************
* END















****************************************
* Over items
****************************************
use "panel_stab_pooled_wide_v3", clear
est clear
graph drop _all


***** ES
global fvES enjoypeople rudetoother shywithpeople repetitivetasks putoffduties feeldepressed changemood easilyupset nervous worryalot

graph drop _all
set graph off
foreach x in $fvES {
preserve
replace `x'2016=0 if `x'2016<0 & `x'2016!=.
replace `x'2020=0 if `x'2020<0 & `x'2020!=.
set graph off
twoway (scatter `x'2020 `x'2016, mcolor(black%30)) (function y=x, range(0 6)), xtitle("Score in 2016-17") ytitle("Score in 2020-21") title("`x'") name(s_`x') legend(order(1 "Individual" 2 "First bisector") pos(6) col(2))
restore
}
set graph on
grc1leg s_enjoypeople s_rudetoother s_shywithpeople s_repetitivetasks s_putoffduties s_feeldepressed s_changemood s_easilyupset s_nervous s_worryalot, col(5) title("Items of the 'Emotional stability' factor")
graph export "new/sub_fES.pdf", as(pdf) replace 
graph save "new/sub_fES.gph", replace





***** OPEX
global fvOPEX interestedbyart liketothink inventive newideas curious talkative expressingthoughts sharefeelings   

graph drop _all
set graph off
foreach x in $fvOPEX {
preserve
replace `x'2016=0 if `x'2016<0 & `x'2016!=.
replace `x'2020=0 if `x'2020<0 & `x'2020!=.
set graph off
twoway (scatter `x'2020 `x'2016, mcolor(black%30)) (function y=x, range(0 6)), xtitle("Score in 2016-17") ytitle("Score in 2020-21") title("`x'") name(s_`x') legend(order(1 "Individual" 2 "First bisector") pos(6) col(2))
restore
}
set graph on
grc1leg s_interestedbyart s_liketothink s_inventive s_newideas s_curious s_talkative s_expressingthoughts s_sharefeelings, col(4) title("Items of the 'Plasticity' factor")
graph export "new/sub_fOPEX.pdf", as(pdf) replace 
graph save "new/sub_fOPEX.gph", replace




***** CO
global fvCO organized enthusiastic appointmentontime workhard completeduties makeplans

graph drop _all
set graph off
foreach x in $fvCO {
preserve
replace `x'2016=0 if `x'2016<0 & `x'2016!=.
replace `x'2020=0 if `x'2020<0 & `x'2020!=.
set graph off
twoway (scatter `x'2020 `x'2016, mcolor(black%30)) (function y=x, range(0 6)), xtitle("Score in 2016-17") ytitle("Score in 2020-21") title("`x'") name(s_`x') legend(order(1 "Individual" 2 "First bisector") pos(6) col(2))
restore
}
set graph on
grc1leg s_organized s_enthusiastic s_appointmentontime s_workhard s_completeduties s_makeplans, col(3) title("Items of the 'Conscientiousness' factor")
graph export "new/sub_fCO.pdf", as(pdf) replace 
graph save "new/sub_fCO.gph", replace

****************************************
* END


















****************************************
* Desc of path
****************************************
use "panel_stab_pooled_wide_v3", clear
est clear
graph drop _all



***** ES
cls
ta catdiff_fES
ta sex catdiff_fES, col nofreq chi2
ta caste catdiff_fES, col nofreq chi2
ta age_cat catdiff_fES, col nofreq chi2
ta educode catdiff_fES, col nofreq chi2
ta moc_indiv catdiff_fES, col nofreq chi2
ta annualincome_indiv2016_q catdiff_fES, col nofreq chi2
ta diff_ars3_cat5 catdiff_fES, col nofreq chi2



***** OPEX
cls
ta catdiff_fOPEX
ta sex catdiff_fOPEX, col nofreq chi2
ta caste catdiff_fOPEX, col nofreq chi2
ta age_cat catdiff_fOPEX, col nofreq chi2
ta educode catdiff_fOPEX, col nofreq chi2
ta moc_indiv catdiff_fOPEX, col nofreq chi2
ta annualincome_indiv2016_q catdiff_fOPEX, col nofreq chi2
ta diff_ars3_cat5 catdiff_fOPEX, col nofreq chi2



***** CO
cls
ta catdiff_fCO
ta sex catdiff_fCO, col nofreq chi2
ta caste catdiff_fCO, col nofreq chi2
ta age_cat catdiff_fCO, col nofreq chi2
ta educode catdiff_fCO, col nofreq chi2
ta moc_indiv catdiff_fCO, col nofreq chi2
ta annualincome_indiv2016_q catdiff_fCO, col nofreq chi2
ta diff_ars3_cat5 catdiff_fCO, col nofreq chi2

****************************************
* END
















****************************************
* Probit stable vs unstable
****************************************
use "panel_stab_pooled_wide_v3", clear
est clear
graph drop _all


***** Macro
global indiv c.age2016 i.sex ib(0).educode ib(3).moc_indiv i.marital
global cogni fES2016 fOPEX2016 fCO2016 num_tt2016 lit_tt2016 raven_tt2016
global house i.caste ib(2).assets2016_q ib(2).annualincome_HH2016_q c.HHsize2016 i.typeoffamily2016
global contr i.username_neemsis1 i.username_neemsis2 c.ars32016 i.diff_ars3_cat5 i.villageid2016
global shock dummysell2020 dummydemonetisation2016 dummyshockland dummyshockdebt dummyshockhealth dummyshockincome


***** ES
fre dumdiff_fES
probit dumdiff_fES $indiv $cogni $house $shock $contr, cluster(cluster) baselevel
est store reg1
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar1



***** OPEX
probit dumdiff_fOPEX $indiv $cogni $house $shock $contr, cluster(cluster) baselevel
est store reg2
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar2

***** CO
probit dumdiff_fCO $indiv $cogni $house $shock $contr, cluster(cluster) baselevel
est store reg3
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar3


***** Tables
esttab reg1 reg2 reg3 using "new/probit.csv", replace ///
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
global indiv c.age2016 i.sex ib(0).educode ib(3).moc_indiv i.marital
global cogni fES2016 fOPEX2016 fCO2016 num_tt2016 lit_tt2016 raven_tt2016
global house i.caste ib(2).assets2016_q ib(2).annualincome_HH2016_q c.HHsize2016 i.typeoffamily2016
global contr i.username_neemsis1 i.username_neemsis2 c.ars32016 i.diff_ars3_cat5 i.villageid2016
global shock dummysell2020 dummydemonetisation2016 dummyshockland dummyshockdebt dummyshockhealth dummyshockincome




***** ES
cls
mprobit catdiff_fES $indiv $cogni $house $shock $contr, cluster(cluster) baselevel baseoutcome(2)
est store reg1
*margins, dydx($indiv $cogni $house $shock) atmeans post
*est store mar1


***** OPEX
mprobit catdiff_fOPEX $indiv $cogni $house $shock $contr, cluster(cluster) baselevel baseoutcome(2)
est store reg2
*margins, dydx($indiv $cogni $house $shock) atmeans post
*est store mar2


***** CO
mprobit catdiff_fCO $indiv $cogni $house $shock $contr, cluster(cluster) baselevel baseoutcome(2)
est store reg3
*margins, dydx($indiv $cogni $house $shock) atmeans post
*est store mar3



***** Tables
esttab reg1 reg2 reg3 using "new/mprobit.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

/*
esttab mar1 mar2 mar3 using "mprobit_margins.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
*/
****************************************
* END
















****************************************
* Degree of instability
****************************************
use "panel_stab_pooled_wide_v3", clear
est clear
graph drop _all


***** Macro
global indiv i.sex ib(0).educode ib(2).age_cat ib(2).moc_indiv i.marital
global cogni fES2016 fOPEX2016 fCO2016 num_tt2016 lit_tt2016 raven_tt2016
global house i.caste ib(2).assets2016_q ib(2).annualincome_HH2016_q c.HHsize2016 i.typeoffamily2016
global contr i.username_neemsis1 i.username_neemsis2 c.ars32016 i.diff_ars3_cat5 i.villageid2016
global shock dummysell2020 dummydemonetisation2016 dummyshockland dummyshockdebt dummyshockhealth dummyshockincome



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





***** OPEX
* Unstable
glm abs_diff_rec_fOPEX $indiv $cogni $house $shock $contr ///
if catdiff_fOPEX==1 | catdiff_fOPEX==3 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store reg1OPEX
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar1OPEX

* Increasing
glm abs_diff_rec_fOPEX $indiv $cogni $house $shock $contr ///
if catdiff_fOPEX==3 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store reg2OPEX
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar2OPEX

* Decreasing
glm abs_diff_rec_fOPEX $indiv $cogni $house $shock $contr ///
if catdiff_fOPEX==1 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store reg3OPEX
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar3OPEX




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
/*
esttab ///
reg1ES mar1ES reg2ES mar2ES reg3ES mar3ES ///
reg1OPEX mar1OPEX reg2OPEX mar2OPEX reg3OPEX mar3OPEX ///
reg1CO mar1CO reg2CO mar2CO reg3CO mar3CO ///
*/

esttab ///
mar1ES mar2ES mar3ES ///
mar1OPEX mar2OPEX mar3OPEX ///
mar1CO mar2CO mar3CO ///
using "new/glm.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N ll, fmt(0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Log-pseudo likelihood"'))
****************************************
* END














/*



****************************************
* FE model
****************************************


********** Reshape
use "panel_stab_pooled_wide_v3", clear

drop age25 educode educode20

reshape long egoid age jatiscorr edulevel villageid panel dummydemonetisation relationshiptohead maritalstatus mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_occupationname_indiv annualincome_indiv annualincome_HH expenses_heal shareexpenses_heal assets_sizeownland ownland assets_total1000 assets_totalnoland1000 HHsize typeoffamily villagename villagename_club loanamount_HH raven_tt num_tt lit_tt aspirationminimumwage dummyaspirationmorehours aspirationminimumwage2 dummymarriage dummy_marriedlist dummyexposure secondlockdownexposure dummysell submissiondate ars ars2 ars3 username_backup edulevel_backup fES fOPEX fCO curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination organized makeplans workhard appointmentontime putoffduties easilydistracted completeduties enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople talkative expressingthoughts workwithother understandotherfeeling trustingofother rudetoother toleratefaults forgiveother helpfulwithothers managestress nervous changemood feeldepressed easilyupset worryalot staycalm, i(HHID_panel INDID_panel) j(year)

drop if egoid==.
ta year

egen HHINDID_panel=group(HHID_panel INDID_panel)
ta HHINDID_panel


save"_temp_FE", replace


********** Econometrics
use"_temp_FE", clear
est clear
graph drop _all
xtset HHINDID_panel year


***** Macro
global indiv c.age i.edulevel ib(2).mainocc_occupation_indiv i.maritalstatus
global house c.assets_total1000 c.annualincome_HH c.HHsize i.typeoffamily
global contr i.username_neemsis1 i.username_neemsis2 c.ars3 i.villageid
global shock dummyshockland dummyshockdebt dummyshockhealth dummyshockincome

***** ES
xtreg fES $indiv $house $shock $contr, fe
est store feES

***** OPEX
xtreg fOPEX $indiv $house $shock $contr, fe
est store feOPEX

***** CO
xtreg fCO $indiv $house $shock $contr, fe
est store feCO





********** Format
esttab ///
feES feOPEX feCO ///
using "new/fe.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N ll, fmt(0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Log-pseudo likelihood"'))

****************************************
* END



