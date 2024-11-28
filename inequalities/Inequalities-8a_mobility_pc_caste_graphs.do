*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 8, 2024
*-----
gl link = "inequalities"
*Desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\inequalities.do"
*-------------------------







****************************************
* Rank
****************************************

***** Assets 
import excel "CF_caste.xlsx", sheet("ass_rank") firstrow clear
label define timeframe 1"2010 - 2016-17" 2"2016-17 - 2020-21"
label values timeframe timeframe
label define sample 1"Overall" 2"Downward" 3"Upward"
label values sample sample
keep if sample==1
drop if alpha==-1
drop if alpha==-.5
drop if alpha==1.5
drop if alpha==2
*
preserve
keep if timeframe==1
twoway ///
(connected index_dal alpha, color(ply1)) ///
(rarea CI_upper_dal CI_lower_dal alpha, color(ply1%10)) ///
(connected index_mid alpha, color(plr1)) ///
(rarea CI_upper_mid CI_lower_mid alpha, color(plr1%10)) ///
(connected index_upp alpha, color(plg1)) ///
(rarea CI_upper_upp CI_lower_upp alpha, color(plg1%10)) ///
, title("Wealth per capita rank mobility" "2010 to 2016-17") ///
ytitle("") ylabel(.2(.2).6) ///
xtitle("α") xlabel(0(.5)1) ///
legend(order(1 "Dalits" 3 "Middle castes" 5 "Upper castes") pos(6) col(3)) ///
scale(1.2) name(assrank1, replace)
restore
*
preserve
keep if timeframe==2
twoway ///
(connected index_dal alpha, color(ply1)) ///
(rarea CI_upper_dal CI_lower_dal alpha, color(ply1%10)) ///
(connected index_mid alpha, color(plr1)) ///
(rarea CI_upper_mid CI_lower_mid alpha, color(plr1%10)) ///
(connected index_upp alpha, color(plg1)) ///
(rarea CI_upper_upp CI_lower_upp alpha, color(plg1%10)) ///
, title("Wealth per capita rank mobility" "2016-17 to 2020-21") ///
ytitle("") ylabel(.1(.2).5) ///
xtitle("α") xlabel(0(.5)1) ///
legend(order(1 "Dalits" 3 "Middle castes" 5 "Upper castes") pos(6) col(3)) ///
scale(1.2) name(assrank2, replace)
restore




***** Income 
import excel "CF_caste.xlsx", sheet("inc_rank") firstrow clear
label define timeframe 1"2010 - 2016-17" 2"2016-17 - 2020-21"
label values timeframe timeframe
label define sample 1"Overall" 2"Downward" 3"Upward"
label values sample sample
keep if sample==1
drop if alpha==-1
drop if alpha==-.5
drop if alpha==1.5
drop if alpha==2
*
preserve
keep if timeframe==1
twoway ///
(connected index_dal alpha, color(ply1)) ///
(rarea CI_upper_dal CI_lower_dal alpha, color(ply1%10)) ///
(connected index_mid alpha, color(plr1)) ///
(rarea CI_upper_mid CI_lower_mid alpha, color(plr1%10)) ///
(connected index_upp alpha, color(plg1)) ///
(rarea CI_upper_upp CI_lower_upp alpha, color(plg1%10)) ///
, title("Monthly income per capita rank mobility" "2010 to 2016-17") ///
ytitle("") ylabel(.2(.2).6) ///
xtitle("α") xlabel(0(.5)1) ///
legend(order(1 "Dalits" 3 "Middle castes" 5 "Upper castes") pos(6) col(3)) ///
scale(1.2) name(incrank1, replace)
restore
*
preserve
keep if timeframe==2
twoway ///
(connected index_dal alpha, color(ply1)) ///
(rarea CI_upper_dal CI_lower_dal alpha, color(ply1%10)) ///
(connected index_mid alpha, color(plr1)) ///
(rarea CI_upper_mid CI_lower_mid alpha, color(plr1%10)) ///
(connected index_upp alpha, color(plg1)) ///
(rarea CI_upper_upp CI_lower_upp alpha, color(plg1%10)) ///
, title("Monhtly income per capita rank mobility" "2016-17 to 2020-21") ///
ytitle("") ylabel(.2(.2).6) ///
xtitle("α") xlabel(0(.5)1) ///
legend(order(1 "Dalits" 3 "Middle castes" 5 "Upper castes") pos(6) col(3)) ///
scale(1.2) name(incrank2, replace)
restore



***** Combine
grc1leg incrank1 assrank1 incrank2 assrank2, col(2) name(combcomb, replace) note("{it:Note:} For 388 households in 2010 and 2016-17, and 485 in 2016-17 and 2020-21.", size(vsmall))
graph export "graph_pc/CFcasterank_pc.png", as(png) replace

****************************************
* END





















****************************************
* Level
****************************************

***** Assets 
import excel "CF_caste.xlsx", sheet("ass_level") firstrow clear
label define timeframe 1"2010 - 2016-17" 2"2016-17 - 2020-21"
label values timeframe timeframe
label define sample 1"Overall" 2"Downward" 3"Upward"
label values sample sample
keep if sample==1
drop if alpha==-1
drop if alpha==-.5
drop if alpha==1.5
drop if alpha==2
*
preserve
keep if timeframe==1
twoway ///
(connected index_dal alpha, color(ply1)) ///
(rarea CI_upper_dal CI_lower_dal alpha, color(ply1%10)) ///
(connected index_mid alpha, color(plr1)) ///
(rarea CI_upper_mid CI_lower_mid alpha, color(plr1%10)) ///
(connected index_upp alpha, color(plg1)) ///
(rarea CI_upper_upp CI_lower_upp alpha, color(plg1%10)) ///
, title("Wealth per capita mobility" "2010 to 2016-17") ///
ytitle("") ylabel(0(.6)2.4) ///
xtitle("α") xlabel(0(.5)1) ///
legend(order(1 "Dalits" 3 "Middle castes" 5 "Upper castes") pos(6) col(3)) ///
scale(1.2) name(ass1, replace)
restore
*
preserve
keep if timeframe==2
twoway ///
(connected index_dal alpha, color(ply1)) ///
(rarea CI_upper_dal CI_lower_dal alpha, color(ply1%10)) ///
(connected index_mid alpha, color(plr1)) ///
(rarea CI_upper_mid CI_lower_mid alpha, color(plr1%10)) ///
(connected index_upp alpha, color(plg1)) ///
(rarea CI_upper_upp CI_lower_upp alpha, color(plg1%10)) ///
, title("Wealth per capita mobility" "2016-17 to 2020-21") ///
ytitle("") ylabel(0(.3).9) ///
xtitle("α") xlabel(0(.5)1) ///
legend(order(1 "Dalits" 3 "Middle castes" 5 "Upper castes") pos(6) col(3)) ///
scale(1.2) name(ass2, replace)
restore




***** Income 
import excel "CF_caste.xlsx", sheet("inc_level") firstrow clear
label define timeframe 1"2010 - 2016-17" 2"2016-17 - 2020-21"
label values timeframe timeframe
label define sample 1"Overall" 2"Downward" 3"Upward"
label values sample sample
keep if sample==1
drop if alpha==-1
drop if alpha==-.5
drop if alpha==1.5
drop if alpha==2
*
preserve
keep if timeframe==1
twoway ///
(connected index_dal alpha, color(ply1)) ///
(rarea CI_upper_dal CI_lower_dal alpha, color(ply1%10)) ///
(connected index_mid alpha, color(plr1)) ///
(rarea CI_upper_mid CI_lower_mid alpha, color(plr1%10)) ///
(connected index_upp alpha, color(plg1)) ///
(rarea CI_upper_upp CI_lower_upp alpha, color(plg1%10)) ///
, title("Monthly income per capita mobility" "2010 to 2016-17") ///
ytitle("") ylabel(.0(.4)1.6) ///
xtitle("α") xlabel(0(.5)1) ///
legend(order(1 "Dalits" 3 "Middle castes" 5 "Upper castes") pos(6) col(3)) ///
scale(1.2) name(inc1, replace)
restore
*
preserve
keep if timeframe==2
twoway ///
(connected index_dal alpha, color(ply1)) ///
(rarea CI_upper_dal CI_lower_dal alpha, color(ply1%10)) ///
(connected index_mid alpha, color(plr1)) ///
(rarea CI_upper_mid CI_lower_mid alpha, color(plr1%10)) ///
(connected index_upp alpha, color(plg1)) ///
(rarea CI_upper_upp CI_lower_upp alpha, color(plg1%10)) ///
, title("Monthly income per capita mobility" "2016-17 to 2020-21") ///
ytitle("") ylabel(.2(.4)1.4) ///
xtitle("α") xlabel(0(.5)1) ///
legend(order(1 "Dalits" 3 "Middle castes" 5 "Upper castes") pos(6) col(3)) ///
scale(1.2) name(inc2, replace)
restore




***** Combine
grc1leg inc1 ass1 inc2 ass2, col(2) name(combcomb, replace) note("{it:Note:} For 388 households in 2010 and 2016-17, and 485 in 2016-17 and 2020-21.", size(vsmall))
graph export "graph_pc/CFcastelevel_pc.png", as(png) replace

****************************************
* END
