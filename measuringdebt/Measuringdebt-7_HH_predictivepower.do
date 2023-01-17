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


*** Last minute var crea
gen head_educ=head_edulevel
recode head_educ (2=1)

foreach x in remittnet_HH assets_total {
drop `x'
rename `x'_std `x'
}

ta villageid, gen(village_)


*** Fafchamps and Quisumbing, 1998
gen log_HHsize=log(HHsize)
gen share_children=HH_count_child/HHsize


*** Y-var
global yvar ind_total ind_female ind_male ind_dep ind_agriself ind_agricasual ind_casual ind_regnonquali ind_regquali ind_selfemp ind_nrega ind_agri ind_nona ind_regu ind_casu ind_self ind_othe ind_agri_male ind_agri_female ind_nona_male ind_nona_female ind_regu_male ind_regu_female ind_casu_male ind_casu_female ind_self_male ind_self_female ind_othe_male ind_othe_female ind_agri_dep ind_nona_dep occ_total occ_female occ_male occ_dep occ_agriself occ_agricasual occ_casual occ_regnonquali occ_regquali occ_selfemp occ_nrega occ_agri occ_nona occ_regu occ_casu occ_self occ_othe occ_agri_male occ_agri_female occ_nona_male occ_nona_female occ_regu_male occ_regu_female occ_casu_male occ_casu_female occ_self_male occ_self_female occ_othe_male occ_othe_female occ_agri_dep occ_nona_dep 

*global yvar share_ind_total share_ind_female share_ind_male share_ind_agri share_ind_nona share_ind_regu share_ind_casu share_ind_self share_ind_othe share_ind_agri_male share_ind_agri_female share_ind_nona_male share_ind_nona_female share_ind_regu_male share_ind_regu_female share_ind_casu_male share_ind_casu_female share_ind_self_male share_ind_self_female share_ind_othe_male share_ind_othe_female share_ind_dep

*global yvar occ_total occ_female occ_male occ_dep occ_agriself occ_agricasual occ_casual occ_regnonquali occ_regquali occ_selfemp occ_nrega occ_agri occ_nona occ_regu occ_casu occ_self occ_othe occ_agri_male occ_agri_female occ_nona_male occ_nona_female occ_regu_male occ_regu_female occ_casu_male occ_casu_female occ_self_male occ_self_female occ_othe_male occ_othe_female occ_agri_dep occ_nona_dep 



*** X-var
global interestvar pca2index pcaindex dsr_std dar_std tdr_std lpc_std rfm_std

global xinvar dalit village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10

global xvar1 log_HHsize share_children sexratio dependencyratio

global xvar2 head_female head_age head_educ

global xvar3 remittnet_HH assets_total


*** ML-SEM
log using "C:\Users\Arnaud\Downloads\MLSEM_spec2new.log", replace

foreach y in $yvar {
foreach x in $interestvar {
capture noisily xtdpdml `y' $xvar1 $xvar2 $xvar3, inv($xinvar) predetermined(L.`x')
*est store `y'_`x'
}
}
log close

****************************************
* END









/*




****************************************
* Prediction power with ML-SEM
****************************************
cls
use"panel_v9", clear


*** Panel declaration
xtset panelvar time
set matsize 10000, perm


*** Last minute var crea
gen head_educ=head_edulevel
recode head_educ (2=1)

foreach x in remittnet_HH assets_total {
drop `x'
rename `x'_std `x'
}

ta villageid, gen(village_)


*** Fafchamps and Quisumbing, 1998
gen log_HHsize=log(HHsize)
gen share_children=HH_count_child/HHsize


*** Y-var
*global yvar ind_total ind_female ind_male ind_dep ind_agriself ind_agricasual ind_casual ind_regnonquali ind_regquali ind_selfemp ind_nrega ind_agri ind_nona ind_regu ind_casu ind_self ind_othe ind_agri_male ind_agri_female ind_nona_male ind_nona_female ind_regu_male ind_regu_female ind_casu_male ind_casu_female ind_self_male ind_self_female ind_othe_male ind_othe_female ind_agri_dep ind_nona_dep 

global yvar occ_total occ_female occ_male occ_dep occ_agriself occ_agricasual occ_casual occ_regnonquali occ_regquali occ_selfemp occ_nrega occ_agri occ_nona occ_regu occ_casu occ_self occ_othe occ_agri_male occ_agri_female occ_nona_male occ_nona_female occ_regu_male occ_regu_female occ_casu_male occ_casu_female occ_self_male occ_self_female occ_othe_male occ_othe_female occ_agri_dep occ_nona_dep 



*** X-var
global interestvar pca2index 

global xinvar dalit village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10

global xvar1 log_HHsize share_children sexratio dependencyratio

global xvar2 head_female head_age head_educ

global xvar3 remittnet_HH assets_total


*** ML-SEM
log using "C:\Users\Arnaud\Downloads\MLSEM_spec2new.log", replace

foreach y in $yvar {
foreach x in $interestvar {
xtdpdml `y' $xvar1 $xvar2 $xvar3, inv($xinvar) predetermined(L.`x')
est store `y'_`x'
}
}
log close

****************************************
* END
