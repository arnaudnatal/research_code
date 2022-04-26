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






/*
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
