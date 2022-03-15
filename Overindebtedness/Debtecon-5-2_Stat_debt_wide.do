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
/*
graph display loanamount_
*/


****************************************
* END














****************************************
* TABPLOT PATH
****************************************
use"panel_v4_wide", clear


********** DEBT, WEALTH, INCOME, EXPENSES PATH over INCOME, WEALTH AND CASTE
global classic annualincome assets_noland yearly_expenses loanamount sum_loans_HH DSR ISR

foreach y in $classic {
foreach x in caste cat_income cat_assets {
set graph off
preserve 
rename `x' over
rename catevo_`y' path
tabplot path over, percent(over) showval(format(%3.0f)) frame(100) ///
xtitle("") ytitle("") ///
xlab(,ang(0)) ///
title("") subtitle("") ///
name(`y'_`x', replace)
restore
set graph on
}
}

foreach y in $classic {
set graph off
graph combine `y'_caste `y'_cat_income `y'_cat_assets, col(3) title("`y'") name(comb_`y', replace)
set graph on
}
/*
graph display comb_assets_noland
graph display comb_loanamount
graph display comb_DSR
graph display comb_ISR
*/



********** OVERINDEBTEDNESS over INCOME, WEALTH AND CASTE
foreach x in caste catevo_annualincome cat_income catevo_assets_noland cat_assets caste {
set graph off
preserve 
rename `x' over
rename path_30 path
tabplot path over, percent(over) showval(format(%3.0f)) frame(100) ///
xtitle("") ytitle("") ///
title("") subtitle("") ///
name(perc_`x', replace)
restore
set graph on
}
/*
graph display perc_caste
graph display perc_catevo_assets_noland
graph display perc_catevo_annualincome
graph display perc_cat_income
graph display perc_cat_assets
*/



********** SOURCE OF DEBT over INCOME, WEALTH AND CASTE
foreach y in formal_HH informal_HH {
foreach x in caste cat_income cat_assets {
set graph off
preserve 
rename `x' over
rename catevo_rel_`y' path
tabplot path over, percent(over) showval(format(%3.0f)) frame(100) ///
xtitle("") ytitle("") ///
xlab(,ang(0)) ///
title("") subtitle("") ///
name(`y'_`x', replace)
restore
set graph on
}
}
/*
graph display formal_HH_caste
graph display formal_HH_cat_income
graph display formal_HH_cat_assets
graph display informal_HH_caste
graph display informal_HH_cat_income
graph display informal_HH_cat_assets
*/


********** USING OF DEBT over INCOME, WEALTH AND CASTE
foreach y in eco_HH current_HH humank_HH social_HH home_HH other_HH {
foreach x in caste cat_income cat_assets {
set graph off
preserve 
rename `x' over
rename catevo_rel_`y' path
tabplot path over, percent(over) showval(format(%3.0f)) frame(100) ///
xtitle("") ytitle("") ///
xlab(,ang(0)) ///
title("") subtitle("") ///
name(`y'_`x', replace)
restore
set graph on
}
}
/*
graph display eco_HH_caste
graph display eco_HH_cat_income
graph display eco_HH_cat_assets
graph display current_HH_caste
graph display current_HH_cat_income
graph display current_HH_cat_assets
graph display humank_HH_caste
graph display humank_HH_cat_income
graph display humank_HH_cat_assets
graph display social_HH_caste
graph display social_HH_cat_income
graph display social_HH_cat_assets
graph display home_HH_caste
graph display home_HH_cat_income
graph display home_HH_cat_assets
graph display other_HH_caste
graph display other_HH_cat_income
graph display other_HH_cat_assets
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
global yvar annualincome assets_noland yearly_expenses loanamount sum_loans_HH DSR ISR
global xvar caste cat_income cat_assets
foreach y in $yvar {
foreach x in $xvar {
set graph off
preserve 
rename `x' over
rename catevo_`y' path
bysort over path: gen n=_N
bysort over: gen N=_N
gen perc=round(n*100/N,1)
spineplot path over, ///
bar1(bcolor($p1)) bar2(bcolor($p2)) bar3(bcolor($p3)) bar4(bcolor($p4)) bar5(bcolor($p5)) bar6(bcolor($p6)) ///
text(perc) percent ///
xtitle("") ytitle("") ///
xlab(,ang(0)) ///
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
/*
graph display comb_assets_noland
graph display comb_loanamount
graph display comb_DSR
graph display comb_ISR
*/



********** SOURCE OF DEBT over INCOME, WEALTH AND CASTE
global yvar formal_HH informal_HH rel_formal_HH rel_informal_HH
global xvar caste cat_income cat_assets
foreach y in $yvar {
foreach x in $xvar {
set graph off
preserve 
rename `x' over
rename catevo_`y' path
bysort over path: gen n=_N
bysort over: gen N=_N
gen perc=round(n*100/N,1)
spineplot path over, ///
bar1(bcolor($p1)) bar2(bcolor($p2)) bar3(bcolor($p3)) bar4(bcolor($p4)) bar5(bcolor($p5)) bar6(bcolor($p6)) ///
text(perc) percent ///
xtitle("") ytitle("") ///
xlab(,ang(0)) ///
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
/*
graph display comb_formal_HH
graph display comb_informal_HH
graph display comb_rel_formal_HH
graph display comb_rel_informal_HH
*/




********** USING OF DEBT over INCOME, WEALTH AND CASTE
global yvar eco_HH current_HH humank_HH social_HH home_HH other_HH rel_eco_HH rel_current_HH rel_humank_HH rel_social_HH rel_home_HH rel_other_HH
global xvar caste cat_income cat_assets
foreach y in $yvar {
foreach x in $xvar {
set graph off
preserve 
rename `x' over
rename catevo_`y' path
bysort over path: gen n=_N
bysort over: gen N=_N
gen perc=round(n*100/N,1)
spineplot path over, ///
bar1(bcolor($p1)) bar2(bcolor($p2)) bar3(bcolor($p3)) bar4(bcolor($p4)) bar5(bcolor($p5)) bar6(bcolor($p6)) ///
text(perc) percent ///
xtitle("") ytitle("") ///
xlab(,ang(0)) ///
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
