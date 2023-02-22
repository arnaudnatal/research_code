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




********** HAC graph
rename fvi index
tabstat index, stat(min max range)
keep if dummypanel==1
keep HHID_panel year index

reshape wide index, i(HHID_panel) j(year)
cluster wardslinkage index2010 index2016 index2020, measure(Euclidean)
set graph off
cluster dendrogram, cutnumber(50) xlab(,ang(90)) title("") ytitle("Height") yline(8) name(dendro, replace)
graph export "graph/Cluster_dendro.pdf", as(pdf) replace
set graph on





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
ylabel(0(.2)1) ymtick(0(.1)1) ytitle("FVI") ///
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
rename cl1 clt_fvi

label define cl1 ///
1"Trans. non-vuln." ///
2"Vuln." ///
3"Non-vuln." ///
4"Trans. vuln.", modify


save"panel_v7", replace
****************************************
* END













****************************************
* Characteristics
****************************************
cls
use"panel_v7", clear


********** Mean and Median each year for cluster
preserve
keep HHID_panel year time clt_fvi fvi
drop if clt_fvi==.

* Stat
tabstat fvi if clt_fvi==1, stat(mean cv q) by(year)
tabstat fvi if clt_fvi==2, stat(mean cv q) by(year)
tabstat fvi if clt_fvi==3, stat(mean cv q) by(year)
tabstat fvi if clt_fvi==4, stat(mean cv q) by(year)

* Stripplot
forvalues i=1/4 {
set graph off
stripplot fvi if clt_fvi==`i', over(time) ///
stack width(0.01) jitter(1) refline(lp(dash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh oh) msize(small) mc(black%30) ///
xla(0(.1)1, ang(h)) yla(, noticks) ///
title("Cluster `i'") ///
legend(order(1 "Mean" 4 "Whisker from 5% to 95%") pos(6) col(2) on) ///
xtitle("FVI") ytitle("") name(sp_cl`i', replace)
set graph on
}

set graph off
grc1leg sp_cl1 sp_cl2 sp_cl3 sp_cl4, col(2) name(splclus, replace)
graph export "graph/Trends_strip.pdf", as(pdf) replace
set graph on
restore


********** Graph line: name
set graph off
graph display cl1_gph
graph export "graph/Trends_cluster.pdf", as(pdf) replace
set graph on


********** Construction
*** Social class of 2010
gen wealth2010=.
replace wealth2010=assets_total if year==2010
xtile wealthclass_2010=wealth2010, n(5)
bysort HHID_panel: egen socialclass=max(wealthclass_2010)


*** Rich of 2010
gen rich2010=.
replace rich2010=annualincome_HH if year==2010
xtile incomeclass_2010=rich2010, n(5)
bysort HHID_panel: egen incomeclass=max(incomeclass_2010)

*** Land
gen l2010=.
replace l2010=ownland if year==2010
drop ownland
bysort HHID_panel: egen ownland=max(l2010)






********** Clean
sort HHID_panel year
keep HHID_panel clt_fvi caste vill socialclass incomeclass ownland
duplicates drop
drop if clt_fvi==.

label define socialclass 1"Wealth: Very low" 2"Wealth: Low" 3"Wealth: Middle" 4"Wealth: High" 5"Wealth: Very high"
label values socialclass socialclass

label define incomeclass 1"Income: Very low" 2"Income: Low" 3"Income: Middle" 4"Income: High" 5"Income: Very high"
label values incomeclass incomeclass

label define ownland 0"Land owner: No" 1"Land owner: Yes", replace
label values ownland ownland

label define caste 1"Caste: Dalits" 2"Caste: Middle" 3"Caste: Upper"
label values caste caste



********* Desc of trend
ta clt_fvi

*** Caste
ta caste clt_fvi, col nofreq chi2

*** Location
ta vill clt_fvi, col nofreq chi2

*** Social class
ta socialclass clt_fvi, col nofreq chi2

*** Income
ta incomeclass clt_fvi, col nofreq chi2

*** Land owner
ta ownland clt_fvi, col nofreq chi2


****************************************
* END
