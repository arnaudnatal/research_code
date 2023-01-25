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


********** Panel declaration
xtset panelvar time
set matsize 10000, perm


********** X-var
global interestvar newindex
ta $interestvar
*loanamount_HH dsr_std dar_std tdr_std rfm_std
*pcaindex pca2index

global xinvar dalits village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10

global xvar1 log_HHsize share_children sexratio dependencyratio

global xvar2 head_female head_age head_educ

global xvar3 remittnet_HH assets_total


********** Ind occup
global yvar occ_total occ_female occ_male occ_dep occ_agri occ_nona occ_casu occ_casu_male occ_casu_female

*global yvar ind_total ind_female ind_male ind_dep ind_agri ind_nona ind_regu ind_casu ind_self ind_othe ind_agri_male ind_agri_female ind_nona_male ind_nona_female ind_regu_male ind_regu_female ind_casu_male ind_casu_female ind_self_male ind_self_female ind_othe_male ind_othe_female ind_agri_dep ind_nona_dep ind_regu_dep ind_casu_dep ind_self_dep ind_othe_dep 
*///
*occ_total occ_female occ_male occ_dep occ_agri occ_nona occ_regu occ_casu occ_self occ_othe occ_agri_male occ_agri_female occ_nona_male occ_nona_female occ_regu_male occ_regu_female occ_casu_male occ_casu_female occ_self_male occ_self_female occ_othe_male occ_othe_female occ_agri_dep occ_nona_dep occ_regu_dep occ_casu_dep occ_self_dep occ_othe_dep
*///
*share_total share_female share_male share_dep share_agri share_nona share_regu share_casu share_self share_othe share_agri_male share_agri_female share_nona_male share_nona_female share_regu_male share_regu_female share_casu_male share_casu_female share_self_male share_self_female share_othe_male share_othe_female share_agri_dep share_nona_dep share_regu_dep share_casu_dep share_self_dep share_othe_dep 

log using "C:\Users\Arnaud\Downloads\MLSEM_mdo.log", replace

foreach y in $yvar {
foreach x in $interestvar {
*capture noisily xtreg `y' L.`x' i.dalits $xvar1 $xvar2 $xvar3 $xinvar, fe base
*capture noisily xtdpdml `y' $xvar1 $xvar2 $xvar3, inv($xinvar) predetermined(L.`x') fiml
}
}

log close




********** Hours
*global yvar hoursayear hoursayear_female hoursayear_male hoursayear_dep hoursayear_agri hoursayear_nona hoursayear_regu hoursayear_casu hoursayear_self hoursayear_othe hoursayear_agri_male hoursayear_agri_female hoursayear_nona_male hoursayear_nona_female hoursayear_regu_male hoursayear_regu_female hoursayear_casu_male hoursayear_casu_female hoursayear_self_male hoursayear_self_female hoursayear_othe_male hoursayear_othe_female
global yvar hoursayear hoursayear_female hoursayear_male hoursayear_dep hoursayear_agri hoursayear_nona hoursayear_regu hoursayear_casu hoursayear_casu_female hoursayear_casu_male

log using "C:\Users\Arnaud\Downloads\LEV_hours.log", replace

foreach y in $yvar {
foreach x in $interestvar {
capture noisily xtreg `y' L.`x' i.dalits $xvar1 $xvar2 $xvar3 $xinvar, fe base
}
}

log close


****************************************
* END
