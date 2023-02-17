*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*January 12, 2023
*-----
gl link = "labourdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
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


********** Variables

*** X
global nonvar caste_2 caste_3 village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10
global head head_female head_age head_educ
global econ remittnet_HH assets_total annualincome_HH shareform

global compo1 stem log_HHsize share_female share_children share_young share_old share_stock

global compo2 stem log_HHsize share_children sexratio dependencyratio share_stock


*** Y
global yvar ind_total ind_female ind_male ind_agri ind_nona occ_total occ_female occ_male occ_agri occ_nona




********** Spec 1
log using "Labourdebt_spec1.log", replace

foreach y in $yvar {
capture noisily reg `y' fvi $compo1 $econ $head $nonvar
est store ols_`y'

capture noisily xtreg `y' fvi $compo1 $econ $head $nonvar, fe
est store fe_`y'

capture noisily xtreg `y' fvi $compo1 $econ $head $nonvar, re
est store re_`y'

capture noisily xtdpdml `y' $compo1 $econ $head, inv($nonvar) predetermined(L.fvi) fiml
est store mlsem_`y'

esttab ols_`y' fe_`y' re_`y' mlsem_`y' using "reg_spec1_`y'.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N r2 r2_a F p, fmt(0 2 2 2) ///
	labels(`"Observations"' `"\(R^{2}\)"' `"Adjusted \(R^{2}\)"' `"F-stat"' `"p-value"'))
}

log close





********** Spec 2
log using "Labourdebt_spec2.log", replace

foreach y in $yvar {
capture noisily reg `y' fvi $compo2 $econ $head $nonvar
est store ols_`y'

capture noisily xtreg `y' fvi $compo2 $econ $head $nonvar, fe
est store fe_`y'

capture noisily xtreg `y' fvi $compo2 $econ $head $nonvar, re
est store re_`y'

capture noisily xtdpdml `y' $compo2 $econ $head, inv($nonvar) predetermined(L.fvi) fiml
est store mlsem_`y'

esttab ols_`y' fe_`y' re_`y' mlsem_`y' using "reg_spec2_`y'.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N r2 r2_a F p, fmt(0 2 2 2) ///
	labels(`"Observations"' `"\(R^{2}\)"' `"Adjusted \(R^{2}\)"' `"F-stat"' `"p-value"'))
}

log close



****************************************
* END
