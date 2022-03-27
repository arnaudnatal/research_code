cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
December 07, 2021
-----
Stat for indebtedness and over-indebtedness
-----

-------------------------
*/



****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all

global user "Arnaud"
global folder "Documents"

********** Path to folder "data" folder.
global directory = "C:\Users\\$user\\$folder\_Thesis\Research-Overindebtedness\Persistence_over"
cd"$directory"
global git "C:\Users\\$user\\$folder\GitHub"


*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"

* Scheme
*net install schemepack, from("https://raw.githubusercontent.com/asjadnaqvi/Stata-schemes/main/schemes/") replace
*set scheme plotplain
set scheme white_tableau
*set scheme plotplain
grstyle init
grstyle set plain, nogrid

*set scheme black_tableau
*set scheme swift_red


*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH"
global wave2 "NEEMSIS1-HH"
global wave3 "NEEMSIS2-HH"

global loan1 "RUME-all_loans"
global loan2 "NEEMSIS1-all_loans"
global loan3 "NEEMSIS2-all_loans"



********** Deflate
*https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
*(100/158) if year==2016
*(100/184) if year==2020

****************************************
* END








****************************************
* How much in debt?
****************************************
use"panel_v5_wide", clear

tab1 sum_loans_HH2010 sum_loans_HH2016 sum_loans_HH2020

****************************************
* END








****************************************
* SCATTER PATH
****************************************
use"panel_v5_wide", clear

********** OUTLIERS
foreach x in loanamount {
gen todrop_`x'=0

qui sum d1_`x', det
replace todrop_`x'=1 if d1_`x'<r(p5)
replace todrop_`x'=1 if d1_`x'>r(p95)

qui sum d2_`x', det
replace todrop_`x'=1 if d1_`x'<r(p5)
replace todrop_`x'=1 if d1_`x'>r(p95)
}

********** OVER CASTE
foreach x in loanamount {
preserve
drop if todrop_`x'==1
set graph off
twoway ///
(scatter d2_`x' d1_`x' if caste==1, xline(0) yline(0) msymbol(oh) msize(medsmall)) ///
(scatter d2_`x' d1_`x' if caste==2, xline(0) yline(0) msymbol(oh) msize(medsmall)) ///
(scatter d2_`x' d1_`x' if caste==3, xline(0) yline(0) msymbol(oh) msize(medsmall)) ///
(function y=-x, range(d1_`x')) ///
, ///
xtitle("Δ 2010 / 2016-17") ytitle("Δ 2016-17 / 2020-21") ///
title("`cat' `i'") ///
legend(pos(6) col(3) order(1 "Dalits" 2 "Middle" 3 "Upper")) name(`x'_`i', replace)
set graph on
restore
}
/*
graph display loanamount_
*/

********** OVER WEALTH AND INCOME
graph drop _all
foreach x in loanamount {
preserve
drop if todrop_`x'==1
set graph off
twoway ///
(scatter d2_`x' d1_`x' if cat_assets==1, xline(0) yline(0) msymbol(oh) msize(medsmall)) ///
(scatter d2_`x' d1_`x' if cat_assets==2, xline(0) yline(0) msymbol(oh) msize(medsmall)) ///
(scatter d2_`x' d1_`x' if cat_assets==3, xline(0) yline(0) msymbol(oh) msize(medsmall)) ///
(function y=-x, range(d1_`x')) ///
, ///
xtitle("Δ 2010 / 2016-17") ytitle("Δ 2016-17 / 2020-21") ///
title("`cat' `i'") ///
legend(pos(6) col(3) order(1 "T1 assets" 2 "T2 assets" 3 "T3 assets")) name(`x'_`i', replace)
set graph on
restore
}
graph dir
/*
graph display loanamount_
*/
****************************************
* END













****************************************
* Debt trap
****************************************
use"panel_v5_wide", clear


tabplot path_repay caste, percent(caste) showval(format(%3.0f)) frame(100) ///
xtitle("") ytitle("") ///
xlab(,ang(0)) ///
title("") subtitle("")


****************************************
* END











****************************************
* TABPLOT PATH
****************************************
use"panel_v5_wide", clear

********** DEBT, WEALTH, INCOME, EXPENSES PATH over INCOME, WEALTH AND CASTE
graph drop _all
global yvar income assetsnl loanamount sum_loans DSR ISR
global xvar caste cat_income cat_assets
foreach y in $yvar {
foreach x in $xvar {
set graph off
preserve 
rename `x' over
rename ce_`y' path
tabplot path over, percent(over) showval(format(%3.0f)) frame(100) ///
xtitle("") ytitle("") ///
xlab(,ang(0)) ///
title("") subtitle("") ///
name(`y'_`x', replace)
restore
set graph on
}
}
foreach y in $yvar {
set graph off
graph combine `y'_caste `y'_cat_income `y'_cat_assets, col(3) title("`y'") name(comb_`y', replace)
set graph on
}
graph dir
/*
graph display comb_assets_noland
graph display comb_loanamount
graph display comb_DSR
graph display comb_ISR
*/



********** OVERINDEBTEDNESS over INCOME, WEALTH AND CASTE
graph drop _all
global yvar path_30 path_40 path_50
global xvar caste ce_income cat_income ce_assetsnl cat_assets
foreach y in $yvar {
foreach x in $xvar {
set graph off
preserve 
rename `x' over
rename `y' path
tabplot path over, percent(over) showval(format(%3.0f)) frame(100) ///
xtitle("") ytitle("") ///
title("") subtitle("") ///
name(`y'_`x', replace)
restore
set graph on
}
}
foreach y in $yvar {
set graph off
graph combine `y'_caste `y'_cat_income `y'_cat_assets, col(3) title("`y'") name(comb_`y', replace)
set graph on
}
graph dir
/*
graph display path_30_caste
graph display path_30_ce_assetsnl
graph display path_30_ce_income
graph display path_30_cat_income
graph display path_30_cat_assets
*/



********** SOURCE OF DEBT over INCOME, WEALTH AND CASTE
graph drop _all
global yvar ce_formal ce_informal ce_rel_formal ce_rel_informal
global xvar caste ce_income cat_income ce_assetsnl cat_assets
foreach y in $yvar {
foreach x in $xvar {
set graph off
preserve 
rename `x' over
rename `y' path
tabplot path over, percent(over) showval(format(%3.0f)) frame(100) ///
xtitle("") ytitle("") ///
xlab(,ang(0)) ///
title("") subtitle("") ///
name(`y'_`x', replace)
restore
set graph on
}
}
}
foreach y in $yvar {
set graph off
graph combine `y'_caste `y'_cat_income `y'_cat_assets, col(3) title("`y'") name(comb_`y', replace)
set graph on
}
graph dir
/*
graph display ce_formal_caste
graph display ce_formal_cat_income
graph display ce_formal_cat_assets
graph display ce_informal_caste
graph display ce_informal_cat_income
graph display ce_informal_cat_assets
*/


********** USING OF DEBT over INCOME, WEALTH AND CASTE
graph drop _all
global yvar ce_eco ce_current ce_humank ce_social ce_home ce_other  ce_rel_eco ce_rel_current ce_rel_humank ce_rel_social ce_rel_home ce_rel_other
global xvar caste ce_income cat_income ce_assetsnl cat_assets
foreach y in $yvar {
foreach x in $xvar {
set graph off
preserve 
rename `x' over
rename `y' path
tabplot path over, percent(over) showval(format(%3.0f)) frame(100) ///
xtitle("") ytitle("") ///
xlab(,ang(0)) ///
title("") subtitle("") ///
name(`y'_`x', replace)
restore
set graph on
}
}
foreach y in $yvar {
set graph off
graph combine `y'_caste `y'_cat_income `y'_cat_assets, col(3) title("`y'") name(comb_`y', replace)
set graph on
}
graph dir
/*
graph display ce_eco_caste
graph display ce_eco_cat_income
graph display ce_eco_cat_assets
graph display ce_current_caste
graph display ce_current_cat_income
graph display ce_current_cat_assets
graph display ce_humank_caste
graph display ce_humank_cat_income
graph display ce_humank_cat_assets
graph display ce_social_caste
graph display ce_social_cat_income
graph display ce_social_cat_assets
graph display ce_home_caste
graph display ce_home_cat_income
graph display ce_home_cat_assets
graph display ce_other_caste
graph display ce_other_cat_income
graph display ce_other_cat_assets
*/
****************************************
* END














****************************************
* SPINEPLOT PATH
****************************************
use"panel_v5_wide", clear

********** COLOR
qui colorpalette hue, hue(0 200) chroma(70) luminance(50) n(6) globals


********** DEBT, WEALTH, INCOME, EXPENSES PATH over INCOME, WEALTH AND CASTE
graph drop _all
global yvar ce_income ce_assetsnl ce_yearly_expenses ce_loanamount ce_sum_loans ce_DSR ce_ISR
global xvar caste cat_income cat_assets
foreach y in $yvar {
foreach x in $xvar {
set graph off
preserve 
rename `x' over
rename `y' path
bysort over path: gen n=_N
bysort over: gen N=_N
gen perc=round(n*100/N,1)
spineplot path over, ///
bar1(bcolor($p1)) bar2(bcolor($p2)) bar3(bcolor($p3)) bar4(bcolor($p4)) bar5(bcolor($p5)) bar6(bcolor($p6)) ///
text(perc) percent ///
xtitle("", axis(1)) ///
xtitle("", axis(2)) ytitle("") ///
xlab(,ang(0) axis(2)) ///
title("") subtitle("") ///
legend(pos(6) col(3)) ///
name(`y'_`x', replace)
restore
set graph on
}
}
foreach y in $yvar {
set graph off
grc1leg `y'_caste `y'_cat_income `y'_cat_assets, col(3) title("`y'") name(comb_`y', replace)
set graph on
}
graph dir
/*
graph display comb_ce_assetsnl
graph display comb_ce_loanamount
graph display comb_DSR
graph display comb_ISR
*/



********** SOURCE OF DEBT over INCOME, WEALTH AND CASTE
graph drop _all
global yvar ce_formal ce_informal ce_rel_formal ce_rel_informal
global xvar caste cat_income cat_assets ce_income ce_assetsnl
foreach y in $yvar {
foreach x in $xvar {
set graph off
preserve 
rename `x' over
rename `y' path
bysort over path: gen n=_N
bysort over: gen N=_N
gen perc=round(n*100/N,1)
spineplot path over, ///
bar1(bcolor($p1)) bar2(bcolor($p2)) bar3(bcolor($p3)) bar4(bcolor($p4)) bar5(bcolor($p5)) bar6(bcolor($p6)) ///
text(perc) percent ///
xtitle("", axis(1)) ///
xtitle("", axis(2)) ytitle("") ///
xlab(,ang(0) axis(2)) ///
title("") subtitle("") ///
legend(pos(6) col(3)) ///
name(`y'_`x', replace)
restore
set graph on
}
}
foreach y in $yvar {
set graph off
grc1leg `y'_caste `y'_cat_income `y'_cat_assets `y'_ce_income `y'_ce_assetsnl, col(3) title("`y'") name(comb_`y', replace)
set graph on
}
graph dir
/*
graph display comb_formal_HH
graph display comb_informal_HH
graph display comb_rel_formal_HH
graph display comb_rel_informal_HH
*/




********** USING OF DEBT over INCOME, WEALTH AND CASTE
graph drop _all
global yvar ce_eco ce_current ce_humank ce_social ce_home ce_other ce_rel_eco ce_rel_current ce_rel_humank ce_rel_social ce_rel_home ce_rel_other
global xvar caste cat_income cat_assets ce_income ce_assetsnl
foreach y in $yvar {
foreach x in $xvar {
set graph off
preserve 
rename `x' over
rename `y' path
bysort over path: gen n=_N
bysort over: gen N=_N
gen perc=round(n*100/N,1)
spineplot path over, ///
bar1(bcolor($p1)) bar2(bcolor($p2)) bar3(bcolor($p3)) bar4(bcolor($p4)) bar5(bcolor($p5)) bar6(bcolor($p6)) ///
text(perc) percent ///
xtitle("", axis(1)) ///
xtitle("", axis(2)) ytitle("") ///
xlab(,ang(0) axis(2)) ///
title("") subtitle("") ///
legend(pos(6) col(3)) ///
name(`y'_`x', replace)
restore
set graph on
}
}
foreach y in $yvar {
set graph off
grc1leg `y'_caste `y'_cat_income `y'_cat_assets `y'_ce_income `y'_ce_assetsnl, col(3) title("`y'") name(comb_`y', replace)
set graph on
}
graph dir
/*
graph display comb_eco_HH
graph display comb_current_HH
graph display comb_humank_HH
graph display comb_social_HH
graph display comb_home_HH
graph display comb_other_HH
graph display comb_rel_eco_HH
graph display comb_rel_current_HH
graph display comb_rel_humank_HH
graph display comb_rel_social_HH
graph display comb_rel_home_HH
graph display comb_rel_other_HH
*/




********** OVERINDEBTEDNESS over INCOME, WEALTH AND CASTE
qui colorpalette hue, hue(0 200) chroma(70) luminance(50) n(8) globals

graph drop _all
global yvar path_30 path_40 path_50
global xvar caste cat_income cat_assets ce_income ce_assetsnl
foreach y in $yvar {
foreach x in $xvar {
set graph off
preserve 
rename `x' over
rename `y' path
bysort over path: gen n=_N
bysort over: gen N=_N
gen perc=round(n*100/N,1)
spineplot path over, ///
bar1(bcolor($p1)) bar2(bcolor($p2)) bar3(bcolor($p3)) bar4(bcolor($p4)) bar5(bcolor($p5)) bar6(bcolor($p6)) bar7(bcolor($p7)) bar8(bcolor($p8)) ///
text(perc) percent ///
xtitle("", axis(1)) ///
xtitle("", axis(2)) ytitle("") ///
xlab(,ang(45) axis(2)) ///
title("") subtitle("") ///
legend(pos(6) col(4)) ///
name(`y'_`x', replace)
restore
set graph on
}
}
foreach y in $yvar {
set graph off
grc1leg `y'_caste `y'_cat_income `y'_cat_assets `y'_ce_income `y'_ce_assetsnl, col(3) title("`y'") name(comb_`y', replace)
set graph on
}
graph dir
/*
graph display comb_path_30
*/

****************************************
* END








cluster wardslinkage ih1_annualincome ih1_assets_noland ih1_loanamount ih2_annualincome ih2_assets_noland ih2_loanamount
cluster dendrogram, horizontal cutnumber(15) countinline showcount 
cluster gen clust=groups(8)

tabstat d1_loanamount d1_assets_noland d1_annualincome d2_loanamount d2_assets_noland d2_annualincome, stat(n mean sd p50) by(clust)




****************************************
* HCA for time trends
****************************************
/*
One drawback of the HAC is the minimum algorithm complexity in O (N²), N being the number of observations which are too high for computational purposes (Murtagh and Contreras, 2012). Therefore, this is one of the reasons why the K-means algorithm is preferred for the full sample exercise, and HAC is used to determine the number of clusters.

Murtagh, F., and Contreras, P. (2012). “Algorithms for hierarchical clustering: an overview”. Wiley Interdisciplinary Reviews: Data Mining and Knowledge Discovery, 2(1), 86-97.
*/

cls
graph drop _all
use"panel_v5_wide", clear

********** Step1: Std
forvalues j=1(1)2{
foreach x in DSR DAR_without annualincome assets_noland yearly_expenses ISR loanamount {
egen d`j'_`x'_std=std(d`j'_`x')
replace d`j'_`x'_std=3 if d`j'_`x'_std>3
replace d`j'_`x'_std=-3 if d`j'_`x'_std<-3
}
}

global var d1_DSR_std d2_DSR_std d1_DAR_without_std d2_DAR_without_std 


********** Step2: HCA
***** Over caste
forvalues i=1(1)3{
set graph off
cluster wardslinkage $var if caste==`i', name(cl_caste`i')
cluster dendrogram, horizontal cutnumber(15) countinline showcount name(gph_cl_caste`i') 
*cluster gen clust=groups(4)
*ta clust
set graph on
}

***** Over class
forvalues i=1(1)3{
set graph off
cluster wardslinkage $var if cat_assets==`i', name(cl_class`i')
cluster tree, horizontal cutnumber(15) countinline showcount name(gph_cl_class`i')
*cluster gen clust=groups(4)
*ta clust
set graph on
}

set graph off
graph combine gph_cl_caste1 gph_cl_caste2 gph_cl_caste3, col(3) name(gph_cl_caste)
graph combine gph_cl_class1 gph_cl_class2 gph_cl_class3, col(3) name(gph_cl_class)
set graph on


ta caste
ta cat_assets
*graph display gph_cl_caste
*graph display gph_cl_class


***** To retain
*** Caste 1
cluster wardslinkage $var if caste==1
cluster gen cl_caste1=groups(5)
*** Caste 2
cluster wardslinkage $var if caste==2
cluster gen cl_caste2=groups(4)
*** Caste 3
cluster wardslinkage $var if caste==3
cluster gen cl_caste3=groups(4)

*** Class 1
cluster wardslinkage $var if cat_assets==1
cluster gen cl_class1=groups(3)
*** Class 1
cluster wardslinkage $var if cat_assets==2
cluster gen cl_class2=groups(4)
*** Class 1
cluster wardslinkage $var if cat_assets==3
cluster gen cl_class3=groups(3)




********** Step3: Common trends
***** Stat over caste
cls
forvalues i=1(1)3{
tabstat $var, stat(mean p50) by(cl_caste`i')
}

***** Stat over class
cls
forvalues i=1(1)3{
tabstat $var, stat(mean p50) by(cl_class`i')
}


********** Recode class cat and caste cat in the same var
gen cl_class=.
forvalues i=1(1)3{
replace cl_class=cl_class`i' if cat_assets==`i'
}

gen cl_caste=.
forvalues i=1(1)3{
replace cl_caste=cl_caste`i' if caste==`i'
}


fre cl_class
fre cl_caste


********** Gen desc trend
foreach x in $var {
foreach stat in min max mean {
bysort cl_class: egen `x'_`stat'=`stat'(`x')
}
foreach n in 10 25 50 75 90 {
bysort cl_class: egen `x'_p`n'=pctile(`x'), p(`n')
}
}

preserve
duplicates drop cl_class, force
keep cl_class d1_DSR_std_min d1_DSR_std_max d1_DSR_std_mean d1_DSR_std_p10 d1_DSR_std_p25 d1_DSR_std_p50 d1_DSR_std_p75 d1_DSR_std_p90 d2_DSR_std_min d2_DSR_std_max d2_DSR_std_mean d2_DSR_std_p10 d2_DSR_std_p25 d2_DSR_std_p50 d2_DSR_std_p75 d2_DSR_std_p90 d1_DAR_without_std_min d1_DAR_without_std_max d1_DAR_without_std_mean d1_DAR_without_std_p10 d1_DAR_without_std_p25 d1_DAR_without_std_p50 d1_DAR_without_std_p75 d1_DAR_without_std_p90 d2_DAR_without_std_min d2_DAR_without_std_max d2_DAR_without_std_mean d2_DAR_without_std_p10 d2_DAR_without_std_p25 d2_DAR_without_std_p50 d2_DAR_without_std_p75 d2_DAR_without_std_p90


********** Step4: Graph trend
keep HHID_panel caste cat_assets cl_* annualincome* assets_noland* loanamount* DSR2010 DSR2016 DSR2020 DAR_without2010 DAR_without2016 DAR_without2020
reshape long annualincome assets_noland loanamount DAR_without DSR, i(HHID_panel) j(year)
encode HHID_panel, gen(panelvar)
xtset panelvar year

label var year "Year"

linkplot DSR year if caste==1 & cl_caste1==1, link(panelvar) lcolor(red%5) msymbol(p) mcolor(red%5) legend(off) 

****************************************
* END





















/*
****************************************
* Trends clustering test
****************************************
cls
clear all

***** Var creation
set obs 6
gen n=_n
forvalues i=1(1)4 {
gen v`i'=.
}
replace v1=2
replace v2=v1-4 if n==1
replace v2=v1-2 if n==3
replace v2=v1-2 if n==5
replace v2=v1+4 if n==2
replace v2=v1+2 if n==4
replace v2=v1+2 if n==6
replace v3=v2+6 if n==1
replace v3=v2+3 if n==3
replace v3=v2-2 if n==5
replace v3=v2+6 if n==2
replace v3=v2+4 if n==4
replace v3=v2+3 if n==6
replace v4=v3-2 if n==1
replace v4=v3-2 if n==3
replace v4=v3-2 if n==5
replace v4=v3+2 if n==2
replace v4=v3+4 if n==4
replace v4=v3+3 if n==6

***** Diff gen
gen d1=v2-v1
gen d2=v3-v2
gen d3=v4-v3
egen d1_std=std(d1)
egen d2_std=std(d2)
egen d3_std=std(d3)

***** Trend projection
reshape long v, i(n) j(t)
xtset n t
xtline v, overlay
/*
3 groups:
2.4.6
1.3
5

2 groups:
2.4.6
1.3.5
*/
reshape wide v, i(n) j(t)

***** Test clustering
cluster averagelinkage d1_std d2_std d3_std, name(average)
cluster tree, showcount cutnumber(6)
cluster gen clust=groups(2/3), name(average)
ta n clust2
/*
1.3.5
2.4.6
*/
ta n clust3
/*
1.3
5
2.4.6
*/
****************************************
* END


















****************************************
* Stacked bar chart over
****************************************

********** Stacked bar chart of over debt path
preserve
rename caste over
rename path_30 path
contract path over
bysort over (path): replace _freq=sum(_freq)
bysort over (path): replace _freq=_freq/_freq[_N]*100
twoway ///
(bar _freq over if path==8, barw(.5)) ///
(bar _freq over if path==7, barw(.5)) ///
(bar _freq over if path==6, barw(.5)) ///
(bar _freq over if path==5, barw(.5)) ///
(bar _freq over if path==4, barw(.5)) ///
(bar _freq over if path==3, barw(.5)) ///
(bar _freq over if path==2, barw(.5)) ///	   
(bar _freq over if path==1, barw(.5)) ///
, ///
legend(order(1 "Always" 2 "Lasting entrance" 3 "Temporary exit" 4 "New over-indebted" 5 "New not over-indebted" 6 "Temporary entrance" 7 "Lasting exit" 8 "Never")) ///
ytitle(percent) 
restore
****************************************
* END
