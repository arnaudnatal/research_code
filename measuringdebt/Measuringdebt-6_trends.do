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
cluster dendrogram, cutnumber(50) xlab(,ang(90)) title("") ytitle("Height") yline(800) name(dendro, replace)
graph export "graph/Cluster_dendro.pdf", as(pdf) replace
cluster stop





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
stripplot fvi if clt_fvi==`i', over(time) ///
stack width(0.01) jitter(1) refline(lp(dash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh oh) msize(small) mc(black%30) ///
xla(0(.1)1, ang(h)) yla(, noticks) ///
title("Cluster `i'") ///
legend(order(1 "Mean" 4 "Whisker from 5% to 95%") pos(6) col(2) on) ///
xtitle("FVI") ytitle("") name(sp_cl`i', replace)
}

grc1leg sp_cl1 sp_cl2 sp_cl3 sp_cl4, col(2) name(splclus, replace)
graph export "graph/Trends_strip.pdf", as(pdf) replace
restore


********** Graph line: name
graph display cl1_gph
graph export "graph/Trends_cluster.pdf", as(pdf) replace



********** Construction
*** Social class of 2010
gen w2010=.
replace w2010=assets_total if year==2010
xtile sc3_2010=w2010, n(3)
xtile sc5_2010=w2010, n(5)

bysort HHID_panel: egen sc3=max(sc3_2010)
bysort HHID_panel: egen sc5=max(sc5_2010)


*** Rich of 2010
gen r2010=.
replace r2010=annualincome_HH if year==2010
xtile i3_2010=w2010, n(3)
xtile i5_2010=w2010, n(5)

bysort HHID_panel: egen i3=max(i3_2010)
bysort HHID_panel: egen i5=max(i5_2010)

*** Land
gen l2010=.
replace l2010=ownland if year==2010
bysort HHID_panel: egen ol=max(l2010)






********** Clean
sort HHID_panel year
keep HHID_panel clt_fvi caste vill sc3 sc5 i3 i5 ol
duplicates drop
drop if clt_fvi==.

label define sc3 1"Class: Low" 2"Class: Middle" 3"Class: High"
label values sc3 sc3

label define sc5 1"Class: Very low" 2"Class: Low" 3"Class: Middle" 4"Class: High" 5"Class: Very high"
label values sc5 sc5

label define i3 1"Income: Low" 2"Income: Middle" 3"Income: High"
label values i3 i3

label define i5 1"Income: Very low" 2"Income: Low" 3"Income: Middle" 4"Income: High" 5"Income: Very high"
label values i5 i5

label define ol 0"Land owner: No" 1"Land owner: Yes"
label values ol ol

label define caste 1"Caste: Dalits" 2"Caste: Middle" 3"Caste: Upper"
label values caste caste



********* Desc of trend
ta clt_fvi

*** Caste
*ta caste clt_fvi, exp cchi2 chi2
ta caste clt_fvi, col nofreq
*ta caste clt_fvi, row nofreq


*** Location
*ta vill clt_fvi, exp cchi2 chi2
ta vill clt_fvi, col nofreq
*ta vill clt_fvi, row nofreq


*** Social class (3)
*ta sc3 clt_fvi, exp cchi2 chi2
*ta sc3 clt_fvi, col nofreq
*ta sc3 clt_fvi, row nofreq


*** Social class (5)
*ta sc5 clt_fvi, exp cchi2 chi2
ta sc5 clt_fvi, col nofreq
*ta sc5 clt_fvi, row nofreq


*** Income (3)
*ta i3 clt_fvi, exp cchi2 chi2
*ta i3 clt_fvi, col nofreq
*ta i3 clt_fvi, row nofreq


*** Income (5)
*ta i5 clt_fvi, exp cchi2 chi2
ta i5 clt_fvi, col nofreq
*ta i5 clt_fvi, row nofreq


*** Land owner
*ta ol clt_fvi, exp cchi2 chi2
ta ol clt_fvi, col nofreq
*ta ol clt_fvi, row nofreq


****************************************
* END
