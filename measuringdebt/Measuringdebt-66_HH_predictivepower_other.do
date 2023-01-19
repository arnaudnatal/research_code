*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*January 12, 2023
*-----
gl link = "measuringdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\measuringdebt.do"
*-------------------------










****************************************
* Effect of increase in debt
****************************************
cls
use"panel_v9", clear


********** Clean
drop if year==2010
xtset panelvar year

********** Variables
global yvarind ind_total ind_female ind_male ind_dep ind_agriself ind_agricasual ind_casual ind_regnonquali ind_regquali ind_selfemp ind_nrega ind_agri_male ind_agri_female ind_nona_male ind_nona_female ind_regu_male ind_regu_female ind_casu_male ind_casu_female ind_self_male ind_self_female ind_othe_male ind_othe_female

global yvarocc occ_total occ_female occ_male occ_dep occ_agriself occ_agricasual occ_casual occ_regnonquali occ_regquali occ_selfemp occ_nrega occ_agri_male occ_agri_female occ_nona_male occ_nona_female occ_regu_male occ_regu_female occ_casu_male occ_casu_female occ_self_male occ_self_female occ_othe_male occ_othe_female

global yvarhours hoursayear hoursayear_male hoursayear_female hoursayear_dep hoursayear_agriself hoursayear_agricasual hoursayear_casual hoursayear_regnonquali hoursayear_regquali hoursayear_selfemp hoursayear_nrega hoursayear_agri_male hoursayear_agri_female hoursayear_nona_male hoursayear_nona_female hoursayear_regu_male hoursayear_regu_female hoursayear_casu_male hoursayear_casu_female hoursayear_self_male hoursayear_self_female hoursayear_othe_male hoursayear_othe_female

global xinvar dalits village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10

global xvar1 log_HHsize share_children sexratio dependencyratio

global xvar2 head_female head_age head_educ

global xvar3 remittnet_HH assets_total

global xtotal $xinvar $xvar1 $xvar2 $xvar3


********** Desc
/*
foreach x in $yvarhours {
histogram `x', name(`x', replace)
}
*/


********** Individual at work
cls
log using "C:\Users\Arnaud\Downloads\poisson_indiv.log", replace
set maxiter 50
cls
foreach y in $yvarind {
capture noisily: xtpoisson `y' trendlong, fe base
capture noisily: xtpoisson `y' trendlong $xtotal, fe base
}
log close


********** Number of occupations
cls
log using "C:\Users\Arnaud\Downloads\poisson_occ.log", replace
set maxiter 50
cls
foreach y in $yvarocc {
capture noisily: xtpoisson `y' trendlong, fe base
capture noisily: xtpoisson `y' trendlong $xtotal, fe base
}
log close


********** Labour supply
cls
log using "C:\Users\Arnaud\Downloads\reg_hours.log", replace
set maxiter 50
cls
foreach y in $yvarhours {
*capture noisily: reg `y' trendlong $xtotal
*capture noisily: xthybrid `y' trendlong $xtotal, cre clusterid(panelvar) full
capture noisily: xtnbreg `y' trendlong $xtotal, fe
}
log close


tabstat $yvarhours, stat(n mean cv p50 p75 p90 p95 p99 max)


****************************************
* END














****************************************
* Diff in diff idea
****************************************
cls
use"panel_v9", clear


********** Clean
drop if year==2010
xtset panelvar year


********** Variables
global yvarind ind_total ind_female ind_male ind_dep ind_agriself ind_agricasual ind_casual ind_regnonquali ind_regquali ind_selfemp ind_nrega ind_agri_male ind_agri_female ind_nona_male ind_nona_female ind_regu_male ind_regu_female ind_casu_male ind_casu_female ind_self_male ind_self_female ind_othe_male ind_othe_female

global yvarocc occ_total occ_female occ_male occ_dep occ_agriself occ_agricasual occ_casual occ_regnonquali occ_regquali occ_selfemp occ_nrega occ_agri_male occ_agri_female occ_nona_male occ_nona_female occ_regu_male occ_regu_female occ_casu_male occ_casu_female occ_self_male occ_self_female occ_othe_male occ_othe_female

global yvarhours hoursayear hoursayear_male hoursayear_female hoursayear_dep hoursayear_agriself hoursayear_agricasual hoursayear_casual hoursayear_regnonquali hoursayear_regquali hoursayear_selfemp hoursayear_nrega hoursayear_agri_male hoursayear_agri_female hoursayear_nona_male hoursayear_nona_female hoursayear_regu_male hoursayear_regu_female hoursayear_casu_male hoursayear_casu_female hoursayear_self_male hoursayear_self_female hoursayear_othe_male hoursayear_othe_female

global xinvar dalits village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10

global xvar1 log_HHsize share_children sexratio dependencyratio

global xvar2 head_female head_age head_educ

global xvar3 remittnet_HH assets_total

global xtotal $xinvar $xvar1 $xvar2 $xvar3

*** Baseline
foreach y in $yvarhours {
reg `y' trendn2 $xtotal if year==2016
}

*** After
foreach y in $yvarhours {
reg `y' trendn2 $xtotal if year==2020
}


****************************************
* END



















****************************************
* Var labour
****************************************
cls
use"panel_v9", clear

keep HHID_panel year hoursayear* 
reshape wide hoursayear*, i(HHID_panel) j(year)

*** 
global all agriself agricasual casual regnonquali regquali selfemp nrega agri nona regu casu self othe male female dep agri_male agri_female nona_male nona_female regu_male regu_female casu_male casu_female self_male self_female othe_male othe_female

foreach x in $all {
gen diffhay_`x'_1=hoursayear_`x'2016-hoursayear_`x'2010
gen diffhay_`x'_2=hoursayear_`x'2020-hoursayear_`x'2016
}

gen diff_hay_all_1=hoursayear2016-hoursayear2010
gen diff_hay_all_2=hoursayear2020-hoursayear2016


*** Bin
foreach x in $all {
gen dhay1_`x'=.
gen dhay2_`x'=.
}

foreach x in $all {
replace dhay1_`x'=0 if diffhay_`x'_1<=0
replace dhay1_`x'=1 if diffhay_`x'_1>0
replace dhay2_`x'=0 if diffhay_`x'_1<=0
replace dhay2_`x'=1 if diffhay_`x'_1>0
}

save"diffhay", replace

********** Merge
use"panel_v9", clear

merge m:1 HHID_panel using "diffhay", keepusing(diffhay_agriself_1 diffhay_agriself_2 diffhay_agricasual_1 diffhay_agricasual_2 diffhay_casual_1 diffhay_casual_2 diffhay_regnonquali_1 diffhay_regnonquali_2 diffhay_regquali_1 diffhay_regquali_2 diffhay_selfemp_1 diffhay_selfemp_2 diffhay_nrega_1 diffhay_nrega_2 diffhay_agri_1 diffhay_agri_2 diffhay_nona_1 diffhay_nona_2 diffhay_regu_1 diffhay_regu_2 diffhay_casu_1 diffhay_casu_2 diffhay_self_1 diffhay_self_2 diffhay_othe_1 diffhay_othe_2 diffhay_male_1 diffhay_male_2 diffhay_female_1 diffhay_female_2 diffhay_dep_1 diffhay_dep_2 diffhay_agri_male_1 diffhay_agri_male_2 diffhay_agri_female_1 diffhay_agri_female_2 diffhay_nona_male_1 diffhay_nona_male_2 diffhay_nona_female_1 diffhay_nona_female_2 diffhay_regu_male_1 diffhay_regu_male_2 diffhay_regu_female_1 diffhay_regu_female_2 diffhay_casu_male_1 diffhay_casu_male_2 diffhay_casu_female_1 diffhay_casu_female_2 diffhay_self_male_1 diffhay_self_male_2 diffhay_self_female_1 diffhay_self_female_2 diffhay_othe_male_1 diffhay_othe_male_2 diffhay_othe_female_1 diffhay_othe_female_2 diff_hay_all_1 diff_hay_all_2 dhay1_agriself dhay2_agriself dhay1_agricasual dhay2_agricasual dhay1_casual dhay2_casual dhay1_regnonquali dhay2_regnonquali dhay1_regquali dhay2_regquali dhay1_selfemp dhay2_selfemp dhay1_nrega dhay2_nrega dhay1_agri dhay2_agri dhay1_nona dhay2_nona dhay1_regu dhay2_regu dhay1_casu dhay2_casu dhay1_self dhay2_self dhay1_othe dhay2_othe dhay1_male dhay2_male dhay1_female dhay2_female dhay1_dep dhay2_dep dhay1_agri_male dhay2_agri_male dhay1_agri_female dhay2_agri_female dhay1_nona_male dhay2_nona_male dhay1_nona_female dhay2_nona_female dhay1_regu_male dhay2_regu_male dhay1_regu_female dhay2_regu_female dhay1_casu_male dhay2_casu_male dhay1_casu_female dhay2_casu_female dhay1_self_male dhay2_self_male dhay1_self_female dhay2_self_female dhay1_othe_male dhay2_othe_male dhay1_othe_female dhay2_othe_female)


save"panel_v10", replace

****************************************
* END
















****************************************
* Test
****************************************
cls
use"panel_v10", clear

keep if year==2016

foreach y in dhay1_agriself dhay1_agricasual dhay1_casual dhay1_regnonquali dhay1_regquali dhay1_selfemp dhay1_nrega dhay1_agri dhay1_nona dhay1_regu dhay1_casu dhay1_self dhay1_othe dhay1_male dhay1_female dhay1_dep dhay1_agri_male dhay1_agri_female dhay1_nona_male dhay1_nona_female dhay1_regu_male dhay1_regu_female dhay1_casu_male dhay1_casu_female dhay1_self_male dhay1_self_female dhay1_othe_male dhay1_othe_female {
probit `y' trendn1
}

****************************************
* END
