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
use"panel_v4", clear


********** Overlap
*graph matrix pcaindex pca2index m2index, half msize(vsmall) msymbol(oh) mcolor(black%30)



****************************************
* END








****************************************
* Over time, over caste
****************************************
use"panel_v4", clear


********** Time
tabstat fvi, stat(n mean p50) by(time)


********** Caste
cls
tabstat fvi, stat(n mean cv q) by(caste) long



********** Time and caste
cls
tabstat fvi if year==2010, stat(n mean cv q) by(caste) long
tabstat fvi if year==2016, stat(n mean cv q) by(caste) long
tabstat fvi if year==2020, stat(n mean cv q) by(caste) long




********** Graph
/*
stripplot fvi, over(time) vert ///
stack width(0.2) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(10) ///
ms(oh oh oh) msize(small) mc(blue%30) ///
yla(, ang(h)) xla(, noticks) name(sp`x', replace)
*/



******** Distribution
/*
twoway (histogram fvi if year==2010)
twoway (histogram fvi if year==2016)
twoway (histogram fvi if year==2020)
*/

/*
twoway ///
(kdensity fvi if year==2010) ///
(kdensity fvi if year==2016) ///
(kdensity fvi if year==2020) 
*/

****************************************
* END








****************************************
* Trends
****************************************
use"panel_v4", clear


********** Trends
preserve
rename fvi index
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
rename cluster1 cl1
rename cluster2 cl2
rename cluster3 cl3
rename cluster4 cl4

* Reshape
reshape long index, i(HHID_panel) j(year)

save"indextrend.dta", replace



********** Merge
use"panel_v4", clear

merge 1:1 HHID_panel year using "indextrend"
drop _merge


save"panel_v5", replace
****************************************
* END











****************************************
* Characteristics
****************************************
use"panel_v5", clear

xtset panelvar year


*** Graph line
forvalues i=1/4 {
forvalues j=1/4 {
set graph off
sort HHID_panel year
twoway (line index year if cl`i'==`j', c(L) lcolor(black%10)) ///
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
2"Non-vulnerable" ///
3"Vulnerable" ///
4"Transitory vulnerable"

label define cl2 ///
1"Vulnerable" ///
2"Transitory non-vulnerable" ///
3"Decreasing vulnerability" ///
4"Non-vulnerable"

label define cl3 ///
1"Vulnerable" ///
2"Transitory vulnerable" ///
3"Decreasing vulnerability" ///
4"Non-vulnerable"

label define cl4 ///
1"Transitory vulnerable" ///
2"Vulnerable dynamics" ///
3"V+ Vulnerable dynamics" ///
4"Non-vulnerable"

label values cl1 cl1
label values cl2 cl2
label values cl3 cl3
label values cl4 cl4


* Desc
tab1 cl1 cl2 cl3 cl4
ta cl1 cl2
ta cl1 cl3
ta cl2 cl3


* Caste
ta cl1 caste, exp cchi2 chi2
ta cl2 caste, exp cchi2 chi2
ta cl3 caste, exp cchi2 chi2
ta cl4 caste, exp cchi2 chi2


ta cl1 caste, col nofreq
ta cl2 caste, col nofreq
ta cl3 caste, col nofreq


********** Which one to retain?
/*
graph display cl1_gph
graph display cl2_gph
graph display cl3_gph
graph display cl4_gph
*/


/*
Choose between 2 and 3
*/


****************************************
* END