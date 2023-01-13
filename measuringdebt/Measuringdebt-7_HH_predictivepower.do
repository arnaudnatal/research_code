*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*November 19, 2022
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

xtset panelvar time

global x pca2index

/*
pcaindex rfm dsr tdr lpc dar
*/

*** Y as dummy dep per HH
foreach y in dep dep_female dep_male {
qui xtdpdml dummy_`y' stem, inv(dalits) predetermined(L.$x)
est store d_`y'_$x
}

*** Y as nb indiv per HH
foreach y in all female male agri nonagri female_agri female_nonagri male_agri male_nonagri dep dep_female dep_male {
qui xtdpdml nbindiv_`y' stem, inv(dalits) predetermined(L.$x)
est store i_`y'_$x
}

*** Y as nb occ per HH
foreach y in all female male agri nonagri female_agri female_nonagri male_agri male_nonagri dep dep_female dep_male {
qui xtdpdml nbocc_`y' stem, inv(dalits) predetermined(L.$x)
est store o_`y'_$x
}



/*
Time invariant:
caste
village

Time variant:
HHsize
assets_total
remittnet_HH
sexratio
dependencyratio
HH_count_child
head_sex
head_age
head_edulevel

*/

****************************************
* END












