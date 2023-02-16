*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*November 19, 2022
*-----
gl link = "measuringdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\measuringdebt.do"
*-------------------------








****************************************
* Trends with R
****************************************
use"panel_v6", clear


********** Prepa database
preserve
rename fvi index
tabstat index, stat(min max range)
keep if dummypanel==1
keep HHID_panel year index

reshape wide index, i(HHID_panel) j(year)
corr index2010 index2016 index2020
export delimited "C:\Users\Arnaud\Documents\GitHub\research_code\measuringdebt\debtnew.csv", replace
restore



********** Import R results
import delimited "C:\Users\Arnaud\Documents\GitHub\research_code\measuringdebt\indextrend.csv", clear

* Clean
drop v1
rename hhid_panel HHID_panel
rename cluster1 cl1
rename cluster2 cl2
rename cluster3 cl3
rename cluster4 cl4

* Reshape
reshape long index, i(HHID_panel) j(year)

save"indextrend.dta", replace



********** Merge
use"panel_v6", clear

merge 1:1 HHID_panel year using "indextrend"
drop _merge


*** Clean
gen test=fvi-index
ta test
drop index
drop test



********** Draw lines

xtset panelvar year

*** Graph line
forvalues i=1/4 {
forvalues j=1/4 {
set graph off
sort HHID_panel year
twoway (line fvi year if cl`i'==`j', c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel(0(20)100) ymtick(0(10)100) ytitle("FVI") ///
title("Cluster `j'") ///
name(cl`i'_`j', replace)
set graph on
}
}

* Combine
forvalues i=1/4 {
set graph off
graph combine cl`i'_1 cl`i'_2 cl`i'_3 cl`i'_4, col(2) name(cl`i'_gph, replace)
set graph on
}

* Display
/*
graph display cl1_gph
graph display cl2_gph
graph display cl3_gph
graph display cl4_gph
*/

* Label 
label define cl1 ///
1"Transitory non-vulnerable" ///
2"Vulnerable" ///
3"Non-vulnerable" ///
4"Transitory vulnerable"

label define cl2 ///
1"Non-vulnerable" ///
2"Decreasing vulnerable" ///
3"Transitory non-vulnerable" ///
4"Vulnerable"

label define cl3 ///
1"Vulnerable" ///
2"Highly vulnerable" ///
3"Transitory vulnerability" ///
4"Non-vulnerable"

label define cl4 ///
1"Transitory vulnerable" ///
2"Non-vulnerable" ///
3"Vulnerable" ///
4"Transitory non-vulnerable"

label values cl1 cl1
label values cl2 cl2
label values cl3 cl3
label values cl4 cl4



********** Which one to retain?
/*
Choose between 1 and 4
Keep the first
*/

*graph display cl1_gph
*graph display cl2_gph
*graph display cl3_gph
*graph display cl4_gph
drop cl2 cl3 cl4



********** Clean
rename cl1 cluster_trend_fvi


save"panel_v7", replace
****************************************
* END













****************************************
* Characteristics
****************************************
cls
use"panel_v7", clear


********** Display trends
*graph display cl1_gph


********** Clean
keep HHID_panel dalits caste vill cluster_trend_fvi
duplicates drop
drop if cluster_trend_fvi==.


********* Desc
ta cluster_trend_fvi

*** Dalits
ta cluster_trend_fvi dalits, exp cchi2 chi2
ta cluster_trend_fvi dalits, col nofreq

*** Caste
ta cluster_trend_fvi caste, exp cchi2 chi2
ta cluster_trend_fvi caste, col nofreq

*** Dalits
ta cluster_trend_fvi vill, exp cchi2 chi2
ta cluster_trend_fvi vill, col nofreq



****************************************
* END










