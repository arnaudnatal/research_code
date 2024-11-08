*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 8, 2024
*-----
gl link = "inequalities"
*Trends
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\inequalities.do"
*-------------------------









****************************************
* Trends with R
****************************************
use"panel_v5", clear

* Prepa database
rename diffav index
tabstat index, stat(min max range)
keep if dummypanel==1
keep HHID_panel year index
reshape wide index, i(HHID_panel) j(year)
corr index2010 index2016 index2020
drop if index2010==.
drop if index2016==.
drop if index2020==.


* Export pour R
export delimited "index.csv", replace


* HAC
cluster wardslinkage index2010 index2016 index2020, measure(Euclidean)
set graph off
cluster dendrogram, cutnumber(50) xlab(,ang(90)) title("") ytitle("Height") yline(10) name(dendro, replace)
*graph export "graph/Cluster_dendro.pdf", as(pdf) replace

****************************************
* END











****************************************
* Results
****************************************

* Import R results
import delimited "indextrend.csv", clear

* Clean
drop v1
rename hhid_panel HHID_panel
rename cluster1 cl1
rename cluster2 cl2
rename cluster3 cl3


* Reshape
reshape long index, i(HHID_panel) j(year)

save"indextrend.dta", replace


* Merge
use"panel_v5", clear

merge 1:1 HHID_panel year using "indextrend"
drop _merge



save "panel_v5_trends", replace
****************************************
* END












****************************************
* Graph 
****************************************
cls
use"panel_v5_trends", clear


********** Graph line
*** Cl 1
sort HHID_panel year
twoway (line absdiffshare year if cl2==1, c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel(0(.2)1) ymtick(0(.1)1) ytitle("FVI") ///
title("Cluster 1: Vulnerable") aspectratio() ///
name(cl_1, replace)

*** Cl 2
sort HHID_panel year
twoway (line absdiffshare year if cl2==2, c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel(0(.2)1) ymtick(0(.1)1) ytitle("FVI") ///
title("Cluster 2: Transitory vulnerable") aspectratio() ///
name(cl_2, replace)

*** Cl 3
sort HHID_panel year
twoway (line absdiffshare year if cl2==3, c(L) lcolor(black%10)) ///
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
ta caste
ta clt_fvi

ta caste clt_fvi, col nofreq
ta caste clt_fvi, col nofreq chi2
ta caste clt_fvi, col nofreq chi2 cchi2


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
