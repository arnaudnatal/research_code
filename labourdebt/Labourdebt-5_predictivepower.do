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
global econ remittnet_HH assets_total annualincome_HH

global compo1 log_HHsize share_female share_children share_young share_old share_stock
global compo2 log_HHsize share_children sexratio dependencyratio share_stock


*** Y
global yvar ///
snbo snbo_female snbo_male snbo_young snbo_middle snbo_old socc_agri socc_nagr socc_casu socc_ncas socc_self socc_nsel socc_agse socc_agca socc_naca socc_nare socc_nase socc_nreg




log using "Toutwithnew.log", replace
ta year


********** Spec 1
foreach y in $yvar {
capture noisily xtdpdml `y' $compo1 $econ $head, inv($nonvar) predetermined(fvi L.fvi) fiml
capture noisily xtdpdml `y' $compo1 $econ $head, inv($nonvar) predetermined(fvi L.fvi)
est store mlsem_`y'
}

/*
esttab mlsem_snbo mlsem_snbo_male mlsem_snbo_female mlsem_snbo_young mlsem_snbo_middle mlsem_snbo_old  using "spec1_snbo.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
*/
	
	
	
	



********** Rob: Spec 2
foreach y in $yvar {
capture noisily xtdpdml `y' $compo2 $econ $head, inv($nonvar) predetermined(fvi L.fvi) fiml
capture noisily xtdpdml `y' $compo2 $econ $head, inv($nonvar) predetermined(fvi L.fvi)
est store mlsem_`y'
}

log close
/*
esttab mlsem_snbo mlsem_snbo_male mlsem_snbo_female mlsem_snbo_young mlsem_snbo_middle mlsem_snbo_old  using "spec2_snbo.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
*/


	
	
********** Rob: Outliers
preserve
tabstat snbo_female, stat(n mean p90 p95 p99 max)
drop if snbo_female>4


foreach y in $yvar {
capture noisily xtdpdml `y' $compo1 $econ $head, inv($nonvar) predetermined(L.fvi) fiml
est store mlsem_`y'
}


esttab mlsem_snbo_female using "robout_snbo.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

restore
	
	
	
	
********** Rob: vce
foreach y in $yvar {
capture noisily xtdpdml `y' $compo1 $econ $head, inv($nonvar) predetermined(L.fvi) fiml vce(rob)
est store mlsem_`y'
}



esttab mlsem_snbo mlsem_snbo_male mlsem_snbo_female mlsem_snbo_young mlsem_snbo_middle mlsem_snbo_old  using "robvce_snbo.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

	

	

********** Rob: no domestic work
global yvar2 ///
snbo2 snbo2_female snbo2_male snbo2_young snbo2_middle snbo2_old 
	
foreach y in $yvar2 {
capture noisily xtdpdml `y' $compo1 $econ $head, inv($nonvar) predetermined(L.fvi) fiml
est store mlsem_`y'
}


esttab mlsem_snbo mlsem_snbo_male mlsem_snbo_female mlsem_snbo_young mlsem_snbo_middle mlsem_snbo_old  using "nodom_snbo.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

	
	
	
	
********** Rob: only income gen work
global yvar3 ///
snbo3 snbo3_female snbo3_male snbo3_young snbo3_middle snbo3_old 
	
foreach y in $yvar3 {
capture noisily xtdpdml `y' $compo1 $econ $head, inv($nonvar) predetermined(L.fvi) fiml
est store mlsem_`y'
}


esttab mlsem_snbo mlsem_snbo_male mlsem_snbo_female mlsem_snbo_young mlsem_snbo_middle mlsem_snbo_old  using "oincogen_snbo.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

	

	
	
********** Rob: balanced panel
foreach y in $yvar {
capture noisily xtdpdml `y' $compo1 $econ $head, inv($nonvar) predetermined(L.fvi) vce(sbentler)
est store mlsem_`y'
}


esttab mlsem_snbo mlsem_snbo_male mlsem_snbo_female mlsem_snbo_young mlsem_snbo_middle mlsem_snbo_old  using "robben_snbo.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

	
log close
****************************************
* END
