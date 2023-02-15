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
use"panel_v3", clear


********** Panel declaration
xtset panelvar time
set matsize 10000, perm


********** X-var
global interestvar fvi 
*ampi

global xinvar dalits village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10

global xvar1 log_HHsize share_children sexratio dependencyratio

global xvar2 head_female head_age head_educ

global xvar3 remittnet_HH assets_total annualincome_HH




********** Ind occup
global yvar ind_total ind_female ind_male occ_total occ_female occ_male
*ind_agri ind_nona


********** Reg
log using "C:\Users\Arnaud\Downloads\MLSEM_mdo.log", replace

foreach y in $yvar {
foreach x in $interestvar {
*capture noisily xtreg `y' L.`x' i.dalits $xvar1 $xvar2 $xvar3 $xinvar, fe base
capture noisily xtdpdml `y' $xvar1 $xvar2 $xvar3, inv($xinvar) predetermined(L.`x') fiml
}
}

log close




********** Hours
/*
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
