*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*December 5, 2023
*-----
gl link = "labourdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------







****************************************
* Craggs
****************************************
use"panel_laboursupplyindiv_v2", clear



********** Selection
drop if age<14


********** Panel
sort HHID_panel INDID_panel year
xtset panelvar year


********** Controls
global nonvar i.caste i.villageid
global econ remittnet_HH assets_total dummymarriage 
global compo HHsize HH_count_child sexratio nonworkersratio
global indiv c.age##c.age i.edulevel i.relation2 i.sex i.marital


********** Total
* Work
qui xtreg work DSR_lag $indiv $econ $compo, fe cluster(HHFE)
est store work
* Hours a year
xtreg hoursayear_indiv DSR_lag $indiv $econ $compo, fe cluster(HHFE)
est store hour
* Tables
esttab work hour using "Craggs_Total.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $econ $compo) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

	

********** Males
preserve
fre sex
keep if sex==1
* Work
qui xtreg work DSR_lag $indiv $econ $compo, fe cluster(HHFE)
est store work
* Hours a year
xtreg hoursayear_indiv DSR_lag $indiv $econ $compo, fe cluster(HHFE)
est store hour
* Tables
esttab work hour using "Craggs_Males.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $econ $compo) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
restore



********** Females
preserve
fre sex
keep if sex==2
* Work
qui xtreg work DSR_lag $indiv $econ $compo, fe cluster(HHFE)
est store work
* Hours a year
xtreg hoursayear_indiv DSR_lag $indiv $econ $compo, fe cluster(HHFE)
est store hour
* Tables
esttab work hour using "Craggs_Females.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $econ $compo) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
restore




********** More than 58
preserve
drop if age<58
* Work
qui xtreg work DSR_lag $indiv $econ $compo, fe cluster(HHFE)
est store work
* Hours a year
xtreg hoursayear_indiv DSR_lag $indiv $econ $compo, fe cluster(HHFE)
est store hour
* Tables
esttab work hour using "Craggs_Old.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $econ $compo) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
restore


****************************************
* END
