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
use"panel_v4_wide", clear

tab1 sum_loans_HH2010 sum_loans_HH2016 sum_loans_HH2020



****************************************
* END












****************************************
* SCATTER PATH
****************************************
use"panel_v4_wide", clear

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
use"panel_v4_wide", clear

********** Debt for repayment
tab1 dummyrepay2010 dummyrepay2016 dummyrepay2020

***** Nb
tabstat loanforrepayment_nb_HH2010 loanforrepayment_nb_HH2016 loanforrepayment_nb_HH2020, stat(n mean sd q)

***** Amount
tabstat loanforrepayment_amt_HH2010 loanforrepayment_amt_HH2016 loanforrepayment_amt_HH2020, stat(n mean sd q)

tabstat rel_loanforrepayment_amt_HH2010 rel_loanforrepayment_amt_HH2016 rel_loanforrepayment_amt_HH2020, stat(n mean sd q)


********* Debt that need borrow elsewhere to repay
***** Nb
tabstat MLborrowstrat_nb_HH2010 MLborrowstrat_nb_HH2016 MLborrowstrat_nb_HH2020, stat(n mean sd q)

***** Amount
tabstat MLborrowstrat_amt_HH2010 MLborrowstrat_amt_HH2016   MLborrowstrat_amt_HH2020, stat(n mean sd q)

tabstat rel_MLborrowstrat_amt_HH2010 rel_MLborrowstrat_amt_HH2016 rel_MLborrowstrat_amt_HH2020, stat(n mean sd q)

****************************************
* END







****************************************
* Multiple borrowing
****************************************
use"panel_v4_wide", clear


********** Microcredit
***** Nb
tabstat lf_IMF_nb_HH2010 lf_IMF_nb_HH2016 lf_IMF_nb_HH2020, stat(n mean sd q)

***** Amount
tabstat lf_IMF_amt_HH2010 lf_IMF_amt_HH2016 lf_IMF_amt_HH2020, stat(n mean sd q)

tabstat rel_lf_IMF_amt_HH2010 rel_lf_IMF_amt_HH2016 rel_lf_IMF_amt_HH2020, stat(n mean sd q)



********** Bank
***** Nb
tabstat lf_bank_nb_HH2010 lf_bank_nb_HH2016 lf_bank_nb_HH2020, stat(n mean sd q)

***** Amount
tabstat lf_bank_amt_HH2010 lf_bank_amt_HH2016 lf_bank_amt_HH2020, stat(n mean sd q)

tabstat rel_lf_bank_amt_HH2010 rel_lf_bank_amt_HH2016 rel_lf_bank_amt_HH2020, stat(n mean sd q)



********** Moneylender
***** Nb
tabstat lf_moneylender_nb_HH2010 lf_moneylender_nb_HH2016 lf_moneylender_nb_HH2020, stat(n mean sd q)

***** Amount
tabstat lf_moneylender_amt_HH2010 lf_moneylender_amt_HH2016 lf_moneylender_amt_HH2020, stat(n mean sd q)

tabstat rel_lf_moneylender_amt_HH2010 rel_lf_moneylender_amt_HH2016 rel_lf_moneylender_amt_HH2020, stat(n mean sd q)

****************************************
* END









****************************************
* Good / Bad debt
****************************************
use"panel_v4_wide", clear

********** Good
tabstat MLgooddebt_nb_HH2010 MLgooddebt_nb_HH2016 MLgooddebt_nb_HH2020, stat(n mean sd q)

tabstat MLgooddebt_amt_HH2010 MLgooddebt_amt_HH2016 MLgooddebt_amt_HH2020, stat(n mean sd q)

tabstat rel_MLgooddebt_amt_HH2010 rel_MLgooddebt_amt_HH2016 rel_MLgooddebt_amt_HH2020, stat(n mean sd q)


********** Bad
tabstat MLbaddebt_nb_HH2010 MLbaddebt_nb_HH2016 MLbaddebt_nb_HH2020, stat(n mean sd q)

tabstat MLbaddebt_amt_HH2010 MLbaddebt_amt_HH2016 MLbaddebt_amt_HH2020, stat(n mean sd q)

tabstat rel_MLbaddebt_amt_HH2010 rel_MLbaddebt_amt_HH2016 rel_MLbaddebt_amt_HH2020, stat(n mean sd q)



****************************************
* END









****************************************
* TABPLOT PATH
****************************************
use"panel_v4_wide", clear

********** DEBT, WEALTH, INCOME, EXPENSES PATH over INCOME, WEALTH AND CASTE
graph drop _all
global yvar income assetsnl yearly_expenses loanamount sum_loans DSR ISR
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
use"panel_v4_wide", clear

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
graph display comb_assets_noland
graph display comb_loanamount
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















****************************************
* Hierarchical classification ascending with PCA before
****************************************
/*
One drawback of the HAC is the minimum algorithm complexity in O (N²), N being the number of observations which are too high for computational purposes (Murtagh and Contreras, 2012). Therefore, this is one of the reasons why the K-means algorithm is preferred for the full sample exercise, and HAC is used to determine the number of clusters.

Murtagh, F., and Contreras, P. (2012). “Algorithms for hierarchical clustering: an overview”. Wiley Interdisciplinary Reviews: Data Mining and Knowledge Discovery, 2(1), 86-97.
*/

cls
use"panel_v4_wide", clear


********** Step1: Std
foreach x in DSR DAR_without ISR annualincome assets_noland DIR loanamount {
foreach i in 2010 2016 2020 {
egen `x'`i'_std=std(`x'`i')
}
}


********** Step2: PCA
pca DSR2010_std DSR2016_std DSR2020_std DAR_without2010_std DAR_without2016_std DAR_without2020_std, vce(normal)

screeplot, ci mean

loadingplot , component(3) combined xline(0) yline(0) aspect(1)

scoreplot, component(3) combined xline(0) yline(0) aspect(1) mlabel()

predict pc1 pc2 pc3





********** Step3: HAC

cluster singlelinkage pc1 pc2 pc3, gen(clust)
*cluster averagelinkage 
*cluster completelinkage 
cluster wardslinkage  pc1 pc2 pc3
cluster tree, cutnumber(20) showcount


tabstat 


clust_id clust_ord clust_hgt



****************************************
* END
















****************************************
* MCA for debt path
****************************************
cls
use"panel_v4_wide", clear


ta ce_DAR_without, gen(ce_DAR_)
ta ce_DSR, gen(ce_DSR_)
ta ce_income, gen(ce_income_)

********** Test
local list2 "ce_DAR_1 ce_DAR_2 ce_DAR_3 ce_DAR_4 ce_DAR_5 ce_DAR_6 ce_DSR_1 ce_DSR_2 ce_DSR_3 ce_DSR_4 ce_DSR_5 ce_DSR_6 ce_income_1 ce_income_2 ce_income_3 ce_income_4 ce_income_5 ce_income_6"
forvalues k = 1(1)20 {
*cluster kmeans `list2', k(`k') measure(Gower2) name(cs`k')
cluster kmeans `list2', k(`k') measure(Jaccard) name(cs`k')
}


* WSS matrix
matrix WSS = J(20,5,.)
matrix colnames WSS = k WSS log(WSS) eta-squared PRE
* WSS for each clustering
forvalues k = 1(1)20 {
scalar ws`k' = 0
foreach v of varlist `list2' {
quietly anova `v' cs`k'
scalar ws`k' = ws`k' + e(rss)
}
matrix WSS[`k', 1] = `k'
matrix WSS[`k', 2] = ws`k'
matrix WSS[`k', 3] = log(ws`k')
matrix WSS[`k', 4] = 1 - ws`k'/WSS[1,2]
matrix WSS[`k', 5] = (WSS[`k'-1,2] - ws`k')/WSS[`k'-1,2]
}

matrix list WSS
_matplot WSS, columns(2 1) connect(l) xlabel(#10) name(plot1, replace) nodraw noname
_matplot WSS, columns(3 1) connect(l) xlabel(#10) name(plot2, replace) nodraw noname
_matplot WSS, columns(4 1) connect(l) xlabel(#10) name(plot3, replace) nodraw noname ytitle({&eta}`squared')
_matplot WSS, columns(5 1) connect(l) xlabel(#10) name(plot4, replace) nodraw noname

graph combine plot1 plot2 plot3 plot4, name(plot1to4, replace)







****************************************
* END








/*
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
