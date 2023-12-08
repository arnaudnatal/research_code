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
use"panel_v5", clear


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
cluster dendrogram, cutnumber(50) xlab(,ang(90)) title("") ytitle("Height") yline(10) name(dendro, replace)
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
rename cluster5 cl5
rename cluster6 cl6

* Reshape
reshape long index, i(HHID_panel) j(year)

save"indextrend.dta", replace



********** Merge
use"panel_v5", clear

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
forvalues i=1/3 {
forvalues j=1/6 {
set graph off
sort HHID_panel year
twoway (line fvi year if cl`j'==`i', c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel(0(.2)1) ymtick(0(.1)1) ytitle("FVI") ///
title("Cluster `i'") aspectratio() ///
name(cl`j'_`i', replace)
set graph on
}
}

/*
* Combine
set graph off
graph combine cl1_1 cl1_2 cl1_3, col(2) name(cl1_gph, replace)
graph combine cl2_1 cl2_2 cl2_3, col(2) name(cl2_gph, replace)
graph combine cl3_1 cl3_2 cl3_3, col(2) name(cl3_gph, replace)
graph combine cl4_1 cl4_2 cl4_3, col(2) name(cl4_gph, replace)
graph combine cl5_1 cl5_2 cl5_3, col(2) name(cl5_gph, replace)
graph combine cl6_1 cl6_2 cl6_3, col(2) name(cl6_gph, replace)
set graph on
*/

/*
* Display
graph display cl1_gph
graph display cl2_gph
graph display cl3_gph
graph display cl4_gph
graph display cl5_gph
graph display cl6_gph
*/

/*
Je n'aime pas cl2
cl4 et cl6 sont identiques
cl3 et cl4 sont identiques
cl5 et cl3 sont mieux que cl1
5 parait mieux que 3
*/

ta cl3
ta cl5


* Label 
label define cl3 ///
1"Non-vuln." ///
2"Vuln." ///
3"Trans. vuln."


label define cl5 ///
1"Vuln." ///
2"Trans. vuln." ///
3"Non-vuln." 

label values cl3 cl3
label values cl5 cl5



*** Stat
tabstat fvi if year==2010, stat(n mean cv p50) by(cl3)
tabstat fvi if year==2016, stat(n mean cv p50) by(cl3)
tabstat fvi if year==2020, stat(n mean cv p50) by(cl3)

tabstat fvi if year==2010, stat(n mean cv p50) by(cl5)
tabstat fvi if year==2016, stat(n mean cv p50) by(cl5)
tabstat fvi if year==2020, stat(n mean cv p50) by(cl5)


/*
Je garde le 5
*/

drop cl1 cl2 cl3 cl4 cl6
rename cl5 clt_fvi


save"panel_v6", replace
****************************************
* END













****************************************
* Graph 
****************************************
cls
use"panel_v6", clear


**********
preserve
keep HHID_panel clt_fvi
duplicates drop
fre clt_fvi
restore

/*
1 Vuln
2 Trans vuln
3 Non-vuln
*/



********** Graph line
*** Cl 1
sort HHID_panel year
twoway (line fvi year if clt_fvi==1, c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel(0(.2)1) ymtick(0(.1)1) ytitle("FVI") ///
title("Cluster 1: Vulnerable") aspectratio() ///
name(cl_1, replace)

*** Cl 2
sort HHID_panel year
twoway (line fvi year if clt_fvi==2, c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel(0(.2)1) ymtick(0(.1)1) ytitle("FVI") ///
title("Cluster 2: Transitory vulnerable") aspectratio() ///
name(cl_2, replace)

*** Cl 3
sort HHID_panel year
twoway (line fvi year if clt_fvi==3, c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel(0(.2)1) ymtick(0(.1)1) ytitle("FVI") ///
title("Cluster 1: Non-vulnerable") aspectratio() ///
name(cl_3, replace)

*** Combine
graph combine cl_1 cl_2 cl_3, col(2) name(cl1_gph, replace)
graph export "graph/Trends_cluster.pdf", as(pdf) replace






********** Mean and Median each year for cluster
preserve
keep HHID_panel year time clt_fvi fvi
drop if clt_fvi==.

*** Cl 1
stripplot fvi if clt_fvi==1, over(time) ///
stack width(0.01) jitter(1) refline(lp(dash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh oh) msize(small) mc(black%30) ///
xla(0(.1)1, ang(h)) yla(, noticks) ///
title("Cluster 1: Vulnerable") ///
legend(order(1 "Mean" 4 "Whisker from 5% to 95%") pos(6) col(2) on) ///
xtitle("FVI") ytitle("") name(sp_cl1, replace)

*** Cl 2
stripplot fvi if clt_fvi==2, over(time) ///
stack width(0.01) jitter(1) refline(lp(dash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh oh) msize(small) mc(black%30) ///
xla(0(.1)1, ang(h)) yla(, noticks) ///
title("Cluster 2: Transitory vulnerable") ///
legend(order(1 "Mean" 4 "Whisker from 5% to 95%") pos(6) col(2) on) ///
xtitle("FVI") ytitle("") name(sp_cl2, replace)

*** Cl 3
stripplot fvi if clt_fvi==3, over(time) ///
stack width(0.01) jitter(1) refline(lp(dash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh oh) msize(small) mc(black%30) ///
xla(0(.1)1, ang(h)) yla(, noticks) ///
title("Cluster 3: Non-vulnerable") ///
legend(order(1 "Mean" 4 "Whisker from 5% to 95%") pos(6) col(2) on) ///
xtitle("FVI") ytitle("") name(sp_cl3, replace)



*** Combine
grc1leg sp_cl1 sp_cl2 sp_cl3, col(2) name(splclus, replace)
graph export "graph/Trends_strip.pdf", as(pdf) replace


restore

****************************************
* END











****************************************
* Desc 
****************************************
cls
use"panel_v6", clear

********** Clean
sort HHID_panel year
keep HHID_panel clt_fvi caste vill
duplicates drop
drop if clt_fvi==.

label define caste 1"Caste: Dalits" 2"Caste: Middle" 3"Caste: Upper"
label values caste caste


********* Desc of trend
ta clt_fvi

*** Caste
ta caste clt_fvi, expected cchi2 chi2


****************************************
* END











****************************************
* Reg 
****************************************
cls
use"panel_v6", clear


*** Gen var
ta house, gen(house_)

recode secondlockdownexposure dummysell(.=1)
ta secondlockdownexposure, gen(lock_)
label var lock_1 "Sec. lockdown: Before"
label var lock_2 "Sec. lockdown: During"
label var lock_3 "Sec. lockdown: After"
label var dummysell "Sell assets to face lockdown: Yes"

label var dummydemonetisation "Demonetisation: Yes"


* Clean assets
sum assets_housevalue assets_livestock assets_goods assets_ownland assets_gold
foreach x in assets_housevalue assets_livestock assets_goods assets_ownland assets_gold {
replace `x'=1 if `x'==. | `x'<1
}


* Log
foreach x in assets_total assets_totalnoland assets_housevalue assets_livestock assets_goods assets_ownland assets_gold annualincome_HH loanamount_HH assets_totalnoprop {
replace `x'=1 if `x'<1 | `x'==.
gen log_`x'=log(`x')
}


*** Clean
sort HHID_panel year
keep if year==2010
drop if clt_fvi==.

label define caste 1"Caste: Dalits" 2"Caste: Middle" 3"Caste: Upper"
label values caste caste


*** Desc of trend
ta clt_fvi


*** Macro
global livelihood log_annualincome_HH log_assets_total

global family HHsize HH_count_child

global head head_female head_age head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried

global shock dummymarriage dummydemonetisation lock_2 lock_3

global debt shareform

global debt2 log_loanamount_HH

global invar caste_2 caste_3 village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10


*** Reg
ta clt_fvi
mlogit clt_fvi $livelihood $family $head $shock $debt $debt2 $invar

****************************************
* END
