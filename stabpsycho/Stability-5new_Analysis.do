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
title(" 'Emotional stability' trait") name(s_fES, replace) legend(order(1 "Individual" 2 "First bisector") pos(6) col(2))
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
title(" 'Plasticity' trait") name(s_fOPEX, replace) legend(order(1 "Individual" 2 "First bisector") pos(6) col(2))
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
title(" 'Conscientiousness' trait") name(s_fCO, replace) legend(order(1 "Individual" 2 "First bisector") pos(6) col(2))
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


***** Stat
tabstat diff_fES diff_fOPEX diff_fCO, stat(min p1 p5 p10 q p90 p95 p99 max)
tab1 catdiff_fES catdiff_fOPEX catdiff_fCO
tab1 dumdiff_fES dumdiff_fOPEX dumdiff_fCO


***** Violin
violinplot diff_fES diff_fOPEX diff_fCO, xline(-.6 .6) b(s(p25 p75)) left xtitle("Difference in score between 2016-17 and 2020-21") name(violins, replace)
graph save "new/violins.gph", replace
graph export "new/violins.pdf", as(pdf) replace



***** Tabplot
preserve
keep HHID_panel INDID_panel catdiff_fES catdiff_fOPEX catdiff_fCO
rename catdiff_fES cat1
rename catdiff_fOPEX cat2
rename catdiff_fCO cat3
reshape long cat, i(HHID_panel INDID_panel) j(trait)
label define trait 1"Emotional stability" 2"Plasticity" 3"Conscientiousness"
label values trait trait
* 
tabplot trait cat, note("") subtitle("") xtitle("") ytitle("") percent(trait) showval frame(100) note("Percent given trait", size(vsmall)) name(tabplot, replace)
restore


***** Combine
graph combine violins tabplot



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

