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






****************************************
* Prepa
****************************************
cls
use"panel_v3", clear


********** Panel declaration
xtset panelvar time
set matsize 10000, perm



********** Interaction
fre dalits
gen dal_fvi=caste_1*fvi
gen mid_fvi=caste_2*fvi
gen upp_fvi=caste_3*fvi



********** Variables

*** X
global nonvar caste_1 caste_3 village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10
global head head_female head_age head_educ
global econ remittnet_HH assets_total annualincome_HH 
*dummydemonetisation lockdown2 lockdown3

global compo1 log_HHsize share_female share_children share_young share_old share_stock
global compo2 log_HHsize share_children sexratio dependencyratio share_stock


*** Y
global yvar ///
snbo snbo_female snbo_male snbo_young snbo_middle snbo_old 
*socc_agri socc_nagr socc_casu socc_ncas socc_self socc_nsel socc_agse socc_agca socc_naca socc_nare socc_nase socc_nreg


*** X
global xvar fvi 


****************************************
* END













log using "C_Rob_spec2.log", replace

****************************************
* Rob: Specification 2
****************************************

foreach x in $xvar {
foreach y in $yvar {
capture noisily xtdpdml `y' $compo2 $econ $head, inv($nonvar) predetermined(L.`x' L.dal_fvi L.upp_fvi) fiml
est store mlsem_`y'
}
}

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

****************************************
* END

log close















log using "Rob_outliers.log", replace

****************************************
* Rob: outliers
****************************************

tabstat snbo snbo_female snbo_middle, stat(n mean p90 p95 p99 max)


********** Total
preserve
drop if snbo>7

foreach x in $xvar {
capture noisily xtdpdml snbo $compo1 $econ $head, inv($nonvar) predetermined(L.`x') fiml
est store mlsem_snbo
}
restore



********** Females
preserve
drop if snbo_female>4

foreach x in $xvar {
capture noisily xtdpdml snbo_female $compo1 $econ $head, inv($nonvar) predetermined(L.`x') fiml
est store mlsem_snbo_female
}


restore




********** Middle
preserve
drop if snbo_middle>6

foreach x in $xvar {
capture noisily xtdpdml snbo_middle $compo1 $econ $head, inv($nonvar) predetermined(L.`x') fiml
est store mlsem_snbo_middle
}

restore




********** Table

/*
esttab mlsem_snbo mlsem_snbo_female mlsem_snbo_middle using "robout_snbo.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
*/

****************************************
* END
	
log close
	
	
	
	
	
	
	
	
	
	
	
log using "C_Rob_VCE.log", replace

****************************************
* Rob: VCE
****************************************

foreach x in $xvar {
foreach y in $yvar {
capture noisily xtdpdml `y' $compo1 $econ $head, inv($nonvar) predetermined(L.`x' L.dal_fvi L.upp_fvi) fiml vce(rob)
est store mlsem_`y'
}
}

/*
esttab mlsem_snbo mlsem_snbo_male mlsem_snbo_female mlsem_snbo_young mlsem_snbo_middle mlsem_snbo_old  using "robvce_snbo.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
*/

****************************************
* END
	
log close






	


	

log using "C_Rob_nodomwork.log", replace

****************************************
* Rob: no dom work
****************************************

global yvar2 ///
snbo2 snbo2_female snbo2_male snbo2_young snbo2_middle snbo2_old 

foreach x in $xvar {
foreach y in $yvar2 {
capture noisily xtdpdml `y' $compo1 $econ $head, inv($nonvar) predetermined(L.`x' L.dal_fvi L.upp_fvi) fiml
est store mlsem_`y'
}
}

/*
esttab mlsem_snbo mlsem_snbo_male mlsem_snbo_female mlsem_snbo_young mlsem_snbo_middle mlsem_snbo_old  using "nodom_snbo.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
*/
	
****************************************
* END

log close





	

	
	
log using "C_Rob_onlyincomegen.log", replace

****************************************
* Rob: only income gen
****************************************

global yvar3 ///
snbo3 snbo3_female snbo3_male snbo3_young snbo3_middle snbo3_old 
	
foreach x in $xvar {
foreach y in $yvar3 {
capture noisily xtdpdml `y' $compo1 $econ $head, inv($nonvar) predetermined(L.`x' L.dal_fvi L.upp_fvi) fiml
est store mlsem_`y'
}
}


/*
esttab mlsem_snbo mlsem_snbo_male mlsem_snbo_female mlsem_snbo_young mlsem_snbo_middle mlsem_snbo_old  using "oincogen_snbo.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
*/
	
****************************************
* END

log close
