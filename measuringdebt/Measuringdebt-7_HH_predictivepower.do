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





/*
Maximum Likelihood Structural Equation Model
Same as cross-lagged panel model with fixed effect 

Our simulation results also show that ML-SEM may help researchers to overcome the problem of misspecified temporal lags. 
Whereas ML-SEM falls prey to precisely the same lag specification problem as other models, our simulations show that this problem only occurs if ML-SEM includes either a contemporaneous or a lagged effect of X on Y.
If both effects are specified, by contrast, ML-SEM provides correct estimates of both effects in all scenarios.

In short, ML-SEM including both a contemporaneous and a lagged effect of X on Y provides correct estimates of both effects, even in case of reverse causality. 
If the contemporaneous effect in ML-SEM is negligible, this approach can also serve to justify the application of the LFD model or the AB estimator.

*/








****************************************
* Prediction power with ML-SEM
****************************************
cls
use"panel_v9", clear


*** Panel declaration
xtset panelvar time
set matsize 10000, perm


*** Last minute clean
sum loanamount_HH
replace loanamount_HH=loanamount_HH/10000
replace loanamount_HH=loanamount_HH*(100/158) if year==2016
replace loanamount_HH=loanamount_HH*(100/184) if year==2020


*** X-var
global interestvar loanamount_HH

global xinvar dalits village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10

global xvar1 log_HHsize share_children sexratio dependencyratio

global xvar2 head_female head_age head_educ

global xvar3 remittnet_HH assets_total


*** Y-var
global yvar ind_total ind_female ind_male ind_dep ind_agri ind_nona ind_regu ind_casu ind_self ind_othe ind_agri_male ind_agri_female ind_nona_male ind_nona_female ind_regu_male ind_regu_female ind_casu_male ind_casu_female ind_self_male ind_self_female ind_othe_male ind_othe_female ind_agri_dep ind_nona_dep ind_regu_dep ind_casu_dep ind_self_dep ind_othe_dep 
///
*occ_total occ_female occ_male occ_dep occ_agri occ_nona occ_regu occ_casu occ_self occ_othe occ_agri_male occ_agri_female occ_nona_male occ_nona_female occ_regu_male occ_regu_female occ_casu_male occ_casu_female occ_self_male occ_self_female occ_othe_male occ_othe_female occ_agri_dep occ_nona_dep occ_regu_dep occ_casu_dep occ_self_dep occ_othe_dep


*** Analysis
/*
log using "C:\Users\Arnaud\Downloads\MLSEM.log", replace

foreach y in $yvar {
foreach x in $interestvar {
* LEV
capture noisily xtreg `y' L.`x' $xvar1 $xvar2 $xvar3 $xinvar, fe
* ML-SEM
capture noisily xtdpdml `y' $xvar1 $xvar2 $xvar3, inv($xinvar) predetermined(L.`x') fiml
}
}

log close
*/


****************************************
* END












****************************************
* Hours a year
****************************************
cls
use"panel_v9", clear

*** Panel declaration
xtset panelvar time
set matsize 10000, perm



*** Last minute clean
sum loanamount_HH
replace loanamount_HH=loanamount_HH/10000
replace loanamount_HH=loanamount_HH*(100/158) if year==2016
replace loanamount_HH=loanamount_HH*(100/184) if year==2020


*** X-var
global interestvar loanamount_HH

global xinvar dalits village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10

global xvar1 log_HHsize share_children sexratio dependencyratio

global xvar2 head_female head_age head_educ

global xvar3 remittnet_HH assets_total


*** Y-var
global yvar hoursayear hoursayear_female hoursayear_male hoursayear_dep hoursayear_agri hoursayear_nona hoursayear_regu hoursayear_casu hoursayear_self hoursayear_othe hoursayear_agri_male hoursayear_agri_female hoursayear_nona_male hoursayear_nona_female hoursayear_regu_male hoursayear_regu_female hoursayear_casu_male hoursayear_casu_female hoursayear_self_male hoursayear_self_female hoursayear_othe_male hoursayear_othe_female



*** Analysis
log using "C:\Users\Arnaud\Downloads\LEV.log", replace

foreach y in $yvar {
foreach x in $interestvar {
* LEV
capture noisily xtreg `y' L.`x' $xvar1 $xvar2 $xvar3 $xinvar, fe
}
}

log close


****************************************
* END













****************************************
* CPLM
****************************************
cls
use"panel_v9", clear

*** Panel declaration
xtset panelvar time
set matsize 10000, perm
drop if time==1

*** Last minute clean
sum loanamount_HH
replace loanamount_HH=loanamount_HH/10000
replace loanamount_HH=loanamount_HH*(100/158) if year==2016
replace loanamount_HH=loanamount_HH*(100/184) if year==2020


*** 
keep hoursayear_agriself hoursayear_agricasual hoursayear_casual hoursayear_regnonquali hoursayear_regquali hoursayear_selfemp hoursayear_nrega hoursayear_agri hoursayear_nona hoursayear_regu hoursayear_casu hoursayear_self hoursayear_othe hoursayear hoursayear_male hoursayear_female hoursayear_dep hoursayear_agri_male hoursayear_agri_female hoursayear_nona_male hoursayear_nona_female hoursayear_regu_male hoursayear_regu_female hoursayear_casu_male hoursayear_casu_female hoursayear_self_male hoursayear_self_female hoursayear_othe_male hoursayear_othe_female pca2index HHID_panel year loanamount_HH nbloans_HH 

reshape wide hoursayear_agriself hoursayear_agricasual hoursayear_casual hoursayear_regnonquali hoursayear_regquali hoursayear_selfemp hoursayear_nrega hoursayear_agri hoursayear_nona hoursayear_regu hoursayear_casu hoursayear_self hoursayear_othe hoursayear hoursayear_male hoursayear_female hoursayear_dep hoursayear_agri_male hoursayear_agri_female hoursayear_nona_male hoursayear_nona_female hoursayear_regu_male hoursayear_regu_female hoursayear_casu_male hoursayear_casu_female hoursayear_self_male hoursayear_self_female hoursayear_othe_male hoursayear_othe_female nbloans_HH loanamount_HH pca2index, i(HHID_panel) j(year)

drop if hoursayear2016==.
drop if hoursayear2020==.


********** CPLM
/*
log using "C:\Users\Arnaud\Downloads\CLPM.log", replace
cls
*** Cross lagged panel model
foreach y in hoursayear hoursayear_female hoursayear_male hoursayear_dep hoursayear_agri hoursayear_nona hoursayear_regu hoursayear_casu hoursayear_self hoursayear_othe hoursayear_agri_male hoursayear_agri_female hoursayear_nona_male hoursayear_nona_female hoursayear_regu_male hoursayear_regu_female hoursayear_casu_male hoursayear_casu_female hoursayear_self_male hoursayear_self_female hoursayear_othe_male hoursayear_othe_female hoursayear_agri_dep hoursayear_nona_dep hoursayear_regu_dep hoursayear_casu_dep hoursayear_self_dep hoursayear_othe_dep {
foreach x in pca2index nbloans_HH loanamount_HH {
sem ///
(`x'2016 -> `x'2020, ) ///
(`x'2016 -> `y'2020, ) ///
(`y'2016 -> `x'2020, ) ///
(`y'2016 -> `y'2020, ) ///
, cov( `x'2016*`y'2016 e.`x'2020*e.`y'2020) ///
nocapslatent
}
}
log close
*/


****************************************
* END
*/
