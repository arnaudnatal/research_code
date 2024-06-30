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
graph save "new/violins.gph", replace
graph export "new/violins.pdf", as(pdf) replace



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
*
ta catdiff_fES
*
ta sex catdiff_fES, col nofreq chi2
ta age_cat catdiff_fES, col nofreq chi2
ta educode catdiff_fES, col nofreq chi2
ta moc_indiv catdiff_fES, col nofreq chi2
ta marital catdiff_fES, col nofreq chi2
*
ta caste catdiff_fES, col nofreq chi2
ta assets2016_q catdiff_fES, col nofreq chi2
ta annualincome_HH2016_q catdiff_fES, col nofreq chi2
ta typeoffamily2016 catdiff_fES, col nofreq chi2
*
ta dummysell2020 catdiff_fES, col nofreq chi2
ta dummydemonetisation2016 catdiff_fES, col nofreq chi2
ta dummyshockdebt2 catdiff_fES, col nofreq chi2
ta dummyshockhealth2 catdiff_fES, col nofreq chi2
ta dummyshockincome2 catdiff_fES, col nofreq chi2
ta dummyshockland catdiff_fES, col nofreq chi2



***** OPEX
cls
*
ta catdiff_fOPEX
*
ta sex catdiff_fOPEX, col nofreq chi2
ta age_cat catdiff_fOPEX, col nofreq chi2
ta educode catdiff_fOPEX, col nofreq chi2
ta moc_indiv catdiff_fOPEX, col nofreq chi2
ta marital catdiff_fOPEX, col nofreq chi2
*
ta caste catdiff_fOPEX, col nofreq chi2
ta assets2016_q catdiff_fOPEX, col nofreq chi2
ta annualincome_HH2016_q catdiff_fOPEX, col nofreq chi2
ta typeoffamily2016 catdiff_fOPEX, col nofreq chi2
*
ta dummysell2020 catdiff_fOPEX, col nofreq chi2
ta dummydemonetisation2016 catdiff_fOPEX, col nofreq chi2
ta dummyshockdebt2 catdiff_fOPEX, col nofreq chi2
ta dummyshockhealth2 catdiff_fOPEX, col nofreq chi2
ta dummyshockincome2 catdiff_fOPEX, col nofreq chi2
ta dummyshockland catdiff_fOPEX, col nofreq chi2



***** CO
cls
*
ta catdiff_fCO
*
ta sex catdiff_fCO, col nofreq chi2
ta age_cat catdiff_fCO, col nofreq chi2
ta educode catdiff_fCO, col nofreq chi2
ta moc_indiv catdiff_fCO, col nofreq chi2
ta marital catdiff_fCO, col nofreq chi2
*
ta caste catdiff_fCO, col nofreq chi2
ta assets2016_q catdiff_fCO, col nofreq chi2
ta annualincome_HH2016_q catdiff_fCO, col nofreq chi2
ta typeoffamily2016 catdiff_fCO, col nofreq chi2
*
ta dummysell2020 catdiff_fCO, col nofreq chi2
ta dummydemonetisation2016 catdiff_fCO, col nofreq chi2
ta dummyshockdebt2 catdiff_fCO, col nofreq chi2
ta dummyshockhealth2 catdiff_fCO, col nofreq chi2
ta dummyshockincome2 catdiff_fCO, col nofreq chi2
ta dummyshockland catdiff_fCO, col nofreq chi2

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


****************************************
* END
