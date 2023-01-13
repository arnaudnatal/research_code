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

*** Last minute var crea: educ
fre head_edulevel
gen head_educ=head_edulevel
recode head_educ (2=1)
fre head_educ


*** Last minute var crea: child
ta HHsize
ta HH_count_child


*** X-var
global xvar pca2index
/*
pcaindex rfm dsr tdr lpc dar
*/


*** Y-var
global yvar ind_total ind_female ind_male ind_dep ind_agriself ind_agricasual ind_casual ind_regnonquali ind_regquali ind_selfemp ind_nrega ind_agri ind_nona ind_regu ind_casu ind_self ind_othe ind_agri_male ind_agri_female ind_nona_male ind_nona_female ind_regu_male ind_regu_female ind_casu_male ind_casu_female ind_self_male ind_self_female ind_othe_male ind_othe_female ind_agri_dep ind_nona_dep ind_regu_dep ind_casu_dep ind_self_dep ind_othe_dep


/*
*** Without control variables
foreach y in $yvar {
foreach x in $xvar {
di in white "`y' = `x'"
qui xtdpdml `y', predetermined(L.`x')
est store `y'_`x'
}
}
*/


*** With control variables
ta villageid, gen(village_)

* Spec 1
global tinvarying dalit village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10

global tvarying stem HHsize assets_total remittnet_HH sexratio dependencyratio HH_count_child head_female head_age head_educ1 head_educ2 head_educ3

* Spec 2
global tinvarying2 dalit village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10
global tvarying2 stem sexratio dependencyratio remittnet_HH head_female head_age head_educ

foreach y in ind_female {
foreach x in $xvar {
di in white "`y' = `x'"
qui xtdpdml `y' $tvarying2, inv($tinvarying2) predetermined(L.`x')
est store `y'_`x'
}
}





****************************************
* END












