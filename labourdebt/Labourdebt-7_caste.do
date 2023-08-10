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
global econ remittnet_HH assets_total annualincome_HH dummymarriage
*dummydemonetisation lockdown2 lockdown3

global compo1 log_HHsize share_children sexratio dependencyratio share_stock
global compo2 log_HHsize share_female share_children share_young share_old share_stock


*** Y
global yvar snbo snbo_male snbo_female


*** X
global xvar fvi 

****************************************
* END













log using "Caste.log", replace

****************************************
* Specification 1
****************************************

foreach x in $xvar {
foreach y in $yvar {
capture noisily xtdpdml `y' $compo1 $econ $head, inv($nonvar) predetermined(L.`x' L.dal_fvi L.upp_fvi) fiml
est store mlsem_`y'
}
}


esttab mlsem_snbo mlsem_snbo_male mlsem_snbo_female using "Caste.csv", replace ///
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




