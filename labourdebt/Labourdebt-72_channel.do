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
* Prepa
****************************************
cls
use"panel_v3", clear


********** Test caste
preserve
keep HHID_panel year caste
reshape wide caste, i(HHID_panel) j(year)
ta caste2010 caste2016
ta caste2016 caste2020
ta caste2010 caste2020
restore

********** Panel declaration
xtset panelvar time
set matsize 10000, perm



********** Interaction
fre dalits
gen dal_fvi=caste_1*fvi
gen mid_fvi=caste_2*fvi
gen upp_fvi=caste_3*fvi



********** Variables

*** Shock
gen shock=dummydemonetisation+dummysell
*replace shock=1 if shock>1
ta shock

*** X
global nonvar caste_1 caste_3 village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10
global head head_female head_age head_educ
global econ remittnet_HH assets_total annualincome_HH dummymarriage 
*shock

global compo1 log_HHsize share_children sexratio dependencyratio share_stock
global compo2 log_HHsize share_female share_children share_young share_old share_stock

*** Y
global yvar snbo snbo_male snbo_female

*** X
global xvar fvi_noinv 
*isr tdr rrgpl2
 
****************************************
* END






****************************************
* Test caste
****************************************
preserve
keep HHID_panel year caste caste_*
reshape wide caste caste_1 caste_2 caste_3, i(HHID_panel) j(year)

ta caste_12010 caste_12016
ta caste_12016 caste_12020
ta caste_12010 caste_12020

ta caste_22010 caste_22016
ta caste_22016 caste_22020
ta caste_22010 caste_22020

ta caste_32010 caste_32016
ta caste_32016 caste_32020
ta caste_32010 caste_32020

ta caste2010 caste2016
ta caste2016 caste2020
ta caste2010 caste2020
restore
****************************************
* END





log using "Channel.log", replace

****************************************
* Specification 1
****************************************

foreach x in $xvar {
foreach y in $yvar {
capture noisily xtdpdml `y' $compo1 $econ $head, inv($nonvar) predetermined(L.`x') fiml 
est store mlsem_`y'
}
}


esttab mlsem_snbo mlsem_snbo_male mlsem_snbo_female using "Channel.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))


****************************************
* END

log close




