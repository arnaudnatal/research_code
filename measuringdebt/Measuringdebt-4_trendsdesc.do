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




/*
FactomineR:
Linkage: Ward
Distance: L2squared  squared Euclidean distance 
*/














****************************************
* Clean name and overlap
****************************************
use"panel_v6", clear


********** Overlap
*graph matrix pcaindex pca2index m2index, half msize(vsmall) msymbol(oh) mcolor(black%30)

***
gen time=0
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020

label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time

save"panel_v7", replace
****************************************
* END












****************************************
* Over time, over caste
****************************************
use"panel_v7", clear


********** Time
tabstat newindex1, stat(n mean p50) by(caste)


********** Caste
cls
tabstat newindex1, stat(n mean cv q) by(caste) long
tabstat newindex2, stat(n mean cv q) by(caste) long



********** Time and caste
cls
tabstat newindex1 if year==2010, stat(n mean cv q) by(caste) long
tabstat newindex1 if year==2016, stat(n mean cv q) by(caste) long
tabstat newindex1 if year==2020, stat(n mean cv q) by(caste) long

tabstat newindex2 if year==2010, stat(n mean cv q) by(caste) long
tabstat newindex2 if year==2016, stat(n mean cv q) by(caste) long
tabstat newindex2 if year==2020, stat(n mean cv q) by(caste) long



********** Graph
/*
stripplot newindex1, over(time) vert ///
stack width(0.2) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(10) ///
ms(oh oh oh) msize(small) mc(blue%30) ///
yla(, ang(h)) xla(, noticks) name(sp`x', replace)
*/


****************************************
* END






















****************************************
* Trends
****************************************
use"panel_v7", clear


********** Trends
preserve
rename newindex1 index
tabstat index, stat(min max range)
keep if dummypanel==1
keep HHID_panel year index

reshape wide index, i(HHID_panel) j(year)
corr index2010 index2016 index2020
export delimited "C:\Users\Arnaud\Documents\GitHub\research_code\measuringdebt\debtnew.csv", replace
restore



********** Import
import delimited "C:\Users\Arnaud\Documents\GitHub\research_code\measuringdebt\indextrend.csv", clear

* Clean
drop v1
rename hhid_panel HHID_panel
rename clusts5 cl1
rename clusts6 cl2
rename clusts7 cl3

* Reshape
reshape long index, i(HHID_panel) j(year)

* Clean
rename index finindex

save"indextrend.dta", replace



********** Merge
use"panel_v7", clear

merge 1:1 HHID_panel year using "indextrend"
drop _merge

save"panel_v8", replace




********** Characteristics
use"panel_v8", clear

xtset panelvar year


*** Graph line
forvalues i=1/3 {
forvalues j=1/6 {
set graph off
sort HHID_panel year
twoway (line finindex year if cl`i'==`j', c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel(0(20)100) ymtick(0(10)100) ytitle("FVI") ///
title("Cluster `j'") ///
name(cl`i'_`j', replace)
set graph on
}
}

* Combine
forvalues i=1/3 {
set graph off
graph combine cl`i'_1 cl`i'_2 cl`i'_3 cl`i'_4 cl`i'_5 cl`i'_6, col(3) name(cl`i'_gph, replace)
set graph on
}

* Display
/*
graph display cl1_gph
graph display cl2_gph
graph display cl3_gph
*/


* Label 
label define cl1 ///
1"T. non-vuln" ///
2"T. v. vuln" ///
3"V. vuln" ///
4"Non-vuln" ///
5"Vuln" ///
6"T. vuln"

label define cl2 ///
1"T. non-vuln" ///
2"Non-vuln" ///
3"V. vuln" ///
4"T. vuln" ///
5"T. v. vuln" ///
6"Vuln"

label define cl3 ///
1"Non-vuln" ///
2"T. v. vuln" ///
3"T. non-vuln" ///
4"V. vuln" ///
5"Vuln" ///
6"T. vuln"


label values cl1 cl1
label values cl2 cl2
label values cl3 cl3


* Desc
ta cl1
ta cl2
ta cl3

ta cl1 cl2
ta cl1 cl3
ta cl2 cl3


* Caste
ta cl1 caste, exp cchi2 chi2
ta cl2 caste, exp cchi2 chi2
ta cl3 caste, exp cchi2 chi2

ta cl1 caste, col nofreq
ta cl2 caste, col nofreq
ta cl3 caste, col nofreq


****************************************
* END
