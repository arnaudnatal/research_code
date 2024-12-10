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
* Stability of factors
****************************************
use "panel_stab_v2_pooled_wide", clear
est clear
graph drop _all

***** Mean level
sum fES2016 fES2020
ttest fES2016==fES2020
label var fES2016 "2016-17" 
label var fES2020 "2020-21" 
violinplot fES2016 fES2020, vert mean title("Emotional stability score") ylabel(0(1)6) ymtick(0(.5)6) yscale(range(-.5 .)) nowhiskers name(es, replace) scale(1.2)

sum fOPEX2016 fOPEX2020
ttest fOPEX2016==fOPEX2020
label var fOPEX2016 "2016-17" 
label var fOPEX2020 "2020-21" 
violinplot fOPEX2016 fOPEX2020, vert mean title("Plasticity score") ylabel(0(1)6) ymtick(0(.5)6) yscale(range(-.5 .)) nowhiskers name(opex, replace) scale(1.2)

sum fCO2016 fCO2020
ttest fCO2016==fCO2020
label var fCO2016 "2016-17" 
label var fCO2020 "2020-21" 
violinplot fCO2016 fCO2020, vert mean title("Conscientiousness score") ylabel(0(1)6) ymtick(0(.5)6) yscale(range(-.5 .)) nowhiskers name(co, replace) scale(1.2)

* Combine
graph combine es opex co, name(comb, replace) col(3) note("{it:Note:} The grey box is the interquartile range, the white circle is the median, the small horizontal line is the mean.", size(vsmall))
graph save "new/violins.gph", replace
graph export "new/violins.pdf", as(pdf) replace
graph export "new/violins.png", as(png) replace
graph export "new/violins.eps", as(eps) replace




***** Rank order stability using Spearman's rank correlation coefficients
corr fES2016 fES2020
spearman fES2016 fES2020, stats(rho p)
label var fES2016 "Score in 2016-17" 
label var fES2020 "Score 2020-21" 
twoway (scatter fES2020 fES2016, mcolor(black%30)) ///
, ///
xlabel(0(1)6) xmtick(0(.5)6) ///
ylabel(0(1)6) ymtick(0(.5)6) ///
title("Emotional stability") aspectratio(1.5) ///
note("Pearson's {it:p} = 0.03" "Spearman's {it:p} = 0.05", size(small)) ///
name(es, replace) scale(1.2)

corr fOPEX2016 fOPEX2020
spearman fOPEX2016 fOPEX2020, stats(rho p)
label var fOPEX2016 "Score in 2016-17" 
label var fOPEX2020 "Score 2020-21" 
twoway (scatter fOPEX2020 fOPEX2016, mcolor(black%30)) ///
, ///
xlabel(0(1)6) xmtick(0(.5)6) ///
ylabel(0(1)6) ymtick(0(.5)6) ///
title("Plasticity") aspectratio(1.5) ///
note("Pearson's {it:p} = -0.01" "Spearman's {it:p} = 0.01", size(small)) ///
name(opex, replace) scale(1.2)

corr fCO2016 fCO2020
spearman fCO2016 fCO2020, stats(rho p)
label var fCO2016 "Score in 2016-17" 
label var fCO2020 "Score 2020-21" 
twoway (scatter fCO2020 fCO2016, mcolor(black%30)) ///
, ///
xlabel(0(1)6) xmtick(0(.5)6) ///
ylabel(0(1)6) ymtick(0(.5)6) ///
title("Conscientiousness") aspectratio(1.5) ///
note("Pearson's {it:p} = -0.08" "Spearman's {it:p} = -0.09", size(small)) ///
name(co, replace) scale(1.2)

* Combine
graph combine es opex co, name(comb2, replace) col(3)
graph save "new/scatters.gph", replace
graph export "new/scatters.pdf", as(pdf) replace
graph export "new/scatters.png", as(png) replace
graph export "new/scatters.eps", as(eps) replace


****************************************
* END












****************************************
* Stability of factor scores
****************************************
use "panel_stab_v2_pooled_wide", clear
est clear
graph drop _all

***** Mean level
label var fsES2016 "2016-17" 
label var fsES2020 "2020-21" 
violinplot fsES2016 fsES2020, vert mean title("Emotional stability fscore") ylabel(0(1)6) ymtick(0(.5)6) yscale(range(-.5 .)) nowhiskers name(fses, replace) scale(1.2)

label var fsOPEX2016 "2016-17" 
label var fsOPEX2020 "2020-21" 
violinplot fsOPEX2016 fsOPEX2020, vert mean title("Plasticity fscore") ylabel(0(1)6) ymtick(0(.5)6) yscale(range(-.5 .)) nowhiskers name(fsopex, replace) scale(1.2)

label var fsCO2016 "2016-17" 
label var fsCO2020 "2020-21" 
violinplot fsCO2016 fsCO2020, vert mean title("Conscientiousness fscore") ylabel(0(1)6) ymtick(0(.5)6) yscale(range(-.5 .)) nowhiskers name(fsco, replace) scale(1.2)

* Combine
graph combine fses fsopex fsco, name(comb, replace) col(3) note("{it:Note:} The grey box is the interquartile range, the white circle is the median, the small horizontal line is the mean.", size(vsmall))
graph save "new/violins_fs.gph", replace
graph export "new/violins_fs.pdf", as(pdf) replace
graph export "new/violinsfs.png", as(png) replace

****************************************
* END



















****************************************
* Stability of Big Five
****************************************
use "panel_stab_v2_pooled_wide", clear
est clear
graph drop _all

***** Mean level
label var crOP2016 "2016-17" 
label var crOP2020 "2020-21" 
violinplot crOP2016 crOP2020, vert mean title("OP score") ylabel(0(1)6) ymtick(0(.5)6) yscale(range(-.5 .)) nowhiskers name(op, replace)

label var crCO2016 "2016-17" 
label var crCO2020 "2020-21" 
violinplot crCO2016 crCO2020, vert mean title("CO score") ylabel(0(1)6) ymtick(0(.5)6) yscale(range(-.5 .)) nowhiskers name(co, replace)

label var crEX2016 "2016-17" 
label var crEX2020 "2020-21" 
violinplot crEX2016 crEX2020, vert mean title("EX score") ylabel(0(1)6) ymtick(0(.5)6) yscale(range(-.5 .)) nowhiskers name(ex, replace)

label var crAG2016 "2016-17" 
label var crAG2020 "2020-21" 
violinplot crAG2016 crAG2020, vert mean title("AG score") ylabel(0(1)6) ymtick(0(.5)6) yscale(range(-.5 .)) nowhiskers name(ag, replace)

label var crES2016 "2016-17" 
label var crES2020 "2020-21" 
violinplot crES2016 crES2020, vert mean title("ES score") ylabel(0(1)6) ymtick(0(.5)6) yscale(range(-.5 .)) nowhiskers name(es, replace)


* Combine
graph combine op co ex ag es, name(comb, replace) col(3) note("{it:Note:} The grey box is the interquartile range, the white circle is the median, the small horizontal line is the mean.", size(vsmall))
graph save "new/violins_b5.gph", replace
graph export "new/violins_b5.pdf", as(pdf) replace
graph export "new/violins_b5.png", as(png) replace
graph export "new/violins_b5.eps", as(eps) replace

****************************************
* END























****************************************
* Graphs score
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



***** Tabplot
keep HHID_panel INDID_panel catdiff_fES catdiff_fOPEX catdiff_fCO
rename catdiff_fES cat1
rename catdiff_fOPEX cat2
rename catdiff_fCO cat3
reshape long cat, i(HHID_panel INDID_panel) j(trait)
label define trait 1"Emotional stability" 2"Plasticity" 3"Conscientiousness"
label values trait trait
*
ta trait cat, row nofreq
*
tabplot cat trait, note("") title("") subtitle("Percent given trait", size(small)) xtitle("") ytitle("") xlabel(,angle()) percent(trait) showval(mlabsize(vsmall)) frame(100) name(cat, replace)
graph save "new/traitstab.gph", replace
graph export "new/traitstab.pdf", as(pdf) replace
graph export "new/traitstab.png", as(png) replace
graph export "new/traitstab.eps", as(eps) replace

****************************************
* END










****************************************
* Intensity of instability
****************************************
use "panel_stab_pooled_wide_v3", clear
est clear
graph drop _all


***** Stat
tabstat abs_diff_fES if catdiff_fES!=2, stat(n mean sd p10 q p90) by(catdiff_fES)
tabstat abs_diff_fOPEX if catdiff_fOPEX!=2, stat(n mean sd p10 q p90) by(catdiff_fOPEX)
tabstat abs_diff_fCO if catdiff_fCO!=2, stat(n mean sd p10 q p90) by(catdiff_fCO)


****************************************
* END















****************************************
* Over items
****************************************
use "panel_stab_pooled_wide_v3", clear
est clear
graph drop _all




***** Cleaning
global fvES enjoypeople rudetoother shywithpeople repetitivetasks putoffduties feeldepressed changemood easilyupset nervous worryalot
global fvOPEX interestedbyart liketothink inventive newideas curious talkative expressingthoughts sharefeelings
global fvCO organized enthusiastic appointmentontime workhard completeduties makeplans 
foreach x in $fvES $fvOPEX $fvCO {
replace `x'2016=0 if `x'2016<0 & `x'2016!=.
replace `x'2020=0 if `x'2020<0 & `x'2020!=.
gen diff_`x'=`x'2020-`x'2016
gen catdiff_`x'=.
}
foreach x in $fvES $fvOPEX $fvCO {
replace catdiff_`x'=1 if diff_`x'<-0.6 & diff_`x'!=.
replace catdiff_`x'=2 if diff_`x'>=-0.6 & diff_`x'<=0.6 & diff_`x'!=.
replace catdiff_`x'=3 if diff_`x'>=0.6 & diff_`x'!=.
label values catdiff_`x' catvar2
}
*
keep HHID_panel INDID_panel catdiff_*
drop catdiff_fES catdiff_fOPEX catdiff_fCO
*
reshape long catdiff_, i(HHID_panel INDID_panel) j(item) string
rename catdiff_ cat
gen trait=.
foreach x in $fvES {
replace trait=1 if item=="`x'"
}
foreach x in $fvOPEX {
replace trait=2 if item=="`x'"
}
foreach x in $fvCO {
replace trait=3 if item=="`x'"
}
label define trait 1"Emotional stability" 2"Plasticity" 3"Conscientiousness"
label values trait trait
order HHID_panel INDID_panel trait item cat
replace item=substr(item,1,13)
replace item="appointmento" if item=="appointmenton"


***** Graphs
set graph off
tabplot cat item if trait==1, note("") title("Emotional stability") subtitle("Percent given item", size(small)) xtitle("") ytitle("") xlabel(,angle(90)) percent(item) showval(mlabsize(tiny)) frame(100) name(g1, replace)

tabplot cat item if trait==2, note("") title("Plasticity") subtitle("Percent given item", size(small)) xtitle("") ytitle("") xlabel(,angle(90)) percent(item) showval(mlabsize(tiny)) frame(100) name(g2, replace)

tabplot cat item if trait==3, note("") title("Conscientiousness") subtitle("Percent given item", size(small)) xtitle("") ytitle("") xlabel(,angle(90)) percent(item) showval(mlabsize(tiny)) frame(100) name(g3, replace)
set graph on


***** Combine
graph combine g1 g2 g3, col(3) name(comb1, replace)
graph export "new/evo_items.pdf", as(pdf) replace 
graph save "new/evo_items.gph", replace
graph export "new/evo_items.png", as(png) replace 
graph export "new/evo_items.eps", as(eps) replace 


****************************************
* END
