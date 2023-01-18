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


*** Y-var
*global yvar ind_total ind_female ind_male ind_dep ind_agriself ind_agricasual ind_casual ind_regnonquali ind_regquali ind_selfemp ind_nrega ind_agri_male ind_agri_female ind_nona_male ind_nona_female ind_regu_male ind_regu_female ind_casu_male ind_casu_female ind_self_male ind_self_female ind_othe_male ind_othe_female ind_agri_dep ind_nona_dep occ_total occ_female occ_male occ_dep occ_agriself occ_agricasual occ_casual occ_regnonquali occ_regquali occ_selfemp occ_nrega occ_agri_male occ_agri_female occ_nona_male occ_nona_female occ_regu_male occ_regu_female occ_casu_male occ_casu_female occ_self_male occ_self_female occ_othe_male occ_othe_female occ_agri_dep occ_nona_dep 

global yvar ind_total ind_female ind_male ind_dep ind_agriself ind_agricasual ind_casual ind_regnonquali ind_regquali ind_selfemp ind_nrega occ_total occ_female occ_male occ_dep occ_agriself occ_agricasual occ_casual occ_regnonquali occ_regquali occ_selfemp occ_nrega


*** X-var
global interestvar pca2index pcaindex

global xinvar dalits village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10

global xvar1 log_HHsize share_children sexratio dependencyratio

global xvar2 head_female head_age head_educ

global xvar3 remittnet_HH assets_total


/*
*** FE classic
log using "C:\Users\Arnaud\Downloads\poisson.log", replace

cls
foreach y in occ_total occ_female occ_male occ_dep occ_agriself occ_agricasual occ_casual occ_regnonquali occ_regquali occ_selfemp occ_nrega {
foreach x in pca2index pcaindex {
xtreg `y' `x' $xvar1 $xvar2 $xvar3, fe
}
}

log close
*/


/*
*** ML-SEM non-dalits
log using "C:\Users\Arnaud\Downloads\MLSEM_nocont.log", replace

foreach y in $yvar {
foreach x in $interestvar {
* No
capture noisily xtdpdml `y', predetermined(L.`x') fiml
* Yes
capture noisily xtdpdml `y' $xvar1 $xvar2 $xvar3, inv($xinvar) predetermined(L.`x') fiml
}
}

log close
*/


****************************************
* END













****************************************
* Prediction power with ML-SEM
****************************************
cls
use"panel_v9", clear


*** Panel declaration
drop if time==1
keep hoursayear_agriself hoursayear_agricasual hoursayear_casual hoursayear_regnonquali hoursayear_regquali hoursayear_selfemp hoursayear_nrega hoursayear_agri hoursayear_nona hoursayear_regu hoursayear_casu hoursayear_self hoursayear_othe hoursayear hoursayear_male hoursayear_female hoursayear_dep hoursayear_agri_male hoursayear_agri_female hoursayear_nona_male hoursayear_nona_female hoursayear_regu_male hoursayear_regu_female hoursayear_casu_male hoursayear_casu_female hoursayear_self_male hoursayear_self_female hoursayear_othe_male hoursayear_othe_female dsr_std dar_std pcaindex pca2index HHID_panel year

reshape wide hoursayear_agriself hoursayear_agricasual hoursayear_casual hoursayear_regnonquali hoursayear_regquali hoursayear_selfemp hoursayear_nrega hoursayear_agri hoursayear_nona hoursayear_regu hoursayear_casu hoursayear_self hoursayear_othe hoursayear hoursayear_male hoursayear_female hoursayear_dep hoursayear_agri_male hoursayear_agri_female hoursayear_nona_male hoursayear_nona_female hoursayear_regu_male hoursayear_regu_female hoursayear_casu_male hoursayear_casu_female hoursayear_self_male hoursayear_self_female hoursayear_othe_male hoursayear_othe_female dsr_std dar_std pcaindex pca2index, i(HHID_panel) j(year)

drop if hoursayear2016==.
drop if hoursayear2020==.


/*
log using "C:\Users\Arnaud\Downloads\CLPM.log", replace
cls
*** Cross lagged panel model
foreach y in hoursayear_agriself hoursayear_agricasual hoursayear_casual hoursayear_regnonquali hoursayear_regquali hoursayear_selfemp hoursayear_nrega hoursayear_agri hoursayear_nona hoursayear_regu hoursayear_casu hoursayear_self hoursayear_othe hoursayear hoursayear_male hoursayear_female hoursayear_dep hoursayear_agri_male hoursayear_agri_female hoursayear_nona_male hoursayear_nona_female hoursayear_regu_male hoursayear_regu_female hoursayear_casu_male hoursayear_casu_female hoursayear_self_male hoursayear_self_female hoursayear_othe_male hoursayear_othe_female {
foreach x in pcaindex pca2index dsr_std dar_std {
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


********** Individual at work
cls
log using "C:\Users\Arnaud\Downloads\poisson_indiv.log", replace
set maxiter 50
cls
foreach y in $yvarind {
capture noisily: xtpoisson `y' i.trendlong $xvar1 $xvar2 $xvar3 $xinvar, base
}
log close


********** Number of occupations
cls
log using "C:\Users\Arnaud\Downloads\poisson_occ.log", replace
set maxiter 50
cls
foreach y in $yvarocc {
capture noisily: xtpoisson `y' i.trendlong $xvar1 $xvar2 $xvar3 $xinvar, base
}
log close


********** Number of occupations
cls
log using "C:\Users\Arnaud\Downloads\poisson_hours.log", replace
set maxiter 50
cls
foreach y in $yvarhours {
capture noisily: xtreg `y' i.trendlong $xvar1 $xvar2 $xvar3 $xinvar, base
}
log close


****************************************
* END
