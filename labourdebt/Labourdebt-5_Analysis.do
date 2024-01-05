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
* Descriptive statistics
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14
sort HHID_panel INDID_panel year



********** Variables
global nonvar i.caste i.villageid
global econ remittnet_HH assets_total dummymarriage 
global compo HHsize HH_count_child sexratio nonworkersratio
global indiv age i.edulevel i.relation2 i.sex
global indiv2 age i.edulevel i.relation2 i.sex i.mainocc_occupation_indiv

global xvar DSR_lag
global yvar work multipleoccup hoursayear_indiv


********** Var of interest
preserve
keep HHID_panel year caste DSR
duplicates drop
tabstat DSR, stat(n mean cv q) by(year)
tabstat DSR if caste==1, stat(n mean cv q) by(year)
tabstat DSR if caste==2, stat(n mean cv q) by(year)
tabstat DSR if caste==3, stat(n mean cv q) by(year)
restore


********** Dependant variables
/*
Bien vérifier la sélection de l'échantillon : combien de personnes travaillent ?
Regarder selection Heckman
*/
ta work year, col nofreq
ta work year if sex==1, col nofreq
ta work year if sex==2, col nofreq

ta multipleoccup year, col nofreq
ta multipleoccup year if sex==1, col nofreq
ta multipleoccup year if sex==2, col nofreq

tabstat hoursayear_indiv, stat(n mean cv p50) by(year)
tabstat hoursayear_indiv if sex==1, stat(n mean cv p50) by(year)
tabstat hoursayear_indiv if sex==2, stat(n mean cv p50) by(year)


********** Controls
*** Indiv level
foreach x in edulevel relation2 mainocc_occupation_indiv {
ta `x' year, col nofreq
ta `x' year if sex==1, col nofreq
ta `x' year if sex==2, col nofreq
}

*** HH level
preserve
keep HHID_panel year caste villageid remittnet_HH assets_total dummymarriage HHsize HH_count_child sexratio nonworkersratio
duplicates drop
tabstat remittnet_HH assets_total HHsize HH_count_child sexratio nonworkersratio, stat(n mean cv p50) by(year) long
tabstat remittnet_HH assets_total HHsize HH_count_child sexratio nonworkersratio if caste==1, stat(n mean cv p50) by(year) long
tabstat remittnet_HH assets_total HHsize HH_count_child sexratio nonworkersratio if caste==2, stat(n mean cv p50) by(year) long
tabstat remittnet_HH assets_total HHsize HH_count_child sexratio nonworkersratio if caste==3, stat(n mean cv p50) by(year) long
restore

****************************************
* END












****************************************
* Heckman
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14


********** Panel
sort HHID_panel INDID_panel year
xtset panelvar year


********** Controls brut
global rawnonvar i.caste i.villageid
global rawecon remittnet_HH assets_total dummymarriage 
global rawcompo HHsize HH_count_child sexratio nonworkersratio
global rawindiv c.age##c.age i.edulevel i.relation2 i.sex i.marital


********** Exclusion restriction
global excl1 i.landowner i.relation2 c.monthlyexpenses // Abraham 2017, The Indian Journal of Labour Economics
global excl2 i.marital c.HH_count_child c.HH_count_adult // Beam 2020, EDCC
global excl3 i.dummyremrec // Test


********** Controls according to exclusion
global excl $excl2

global nonvar i.caste i.villageid
global econ remittnet_HH assets_total dummymarriage 
global compo HHsize HH_count_child sexratio nonworkersratio
global indiv c.age##c.age i.edulevel i.sex

global xvar DSR_lag




********** Total
* Multiple occupations
foreach x in $xvar {
xtheckmanfe multipleoccup `x' $indiv $econ $compo $nonvar, selection(work = $excl) id(panelvar) time(year) reps(100)
est store mult_`x'
}
* Hours a year
foreach x in $xvar {
xtheckmanfe hoursayear_indiv `x' $indiv $econ $compo, selection(work = $excl) id(panelvar) time(year) reps(100)
est store hour_`x'
}
* Tables
esttab mult_* hour_* using "Heckman_Total.csv", replace ///
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
* Multiple occupations
foreach x in $xvar {
xtheckmanfe multipleoccup `x' $indiv $econ $compo, selection(work = $excl) id(panelvar) time(year) reps(100)
est store mult_`x'
}
* Hours a year
foreach x in $xvar {
xtheckmanfe hoursayear_indiv `x' $indiv $econ $compo, selection(work = $excl) id(panelvar) time(year) reps(100)
est store hour_`x'
}
* Tables
esttab mult_* hour_* using "Heckman_Males.csv", replace ///
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
* Multiple occupations
foreach x in $xvar {
xtheckmanfe multipleoccup `x' $indiv $econ $compo, selection(work = $excl) id(panelvar) time(year) reps(100)
est store mult_`x'
}
* Hours a year
foreach x in $xvar {
xtheckmanfe hoursayear_indiv `x' $indiv $econ $compo, selection(work = $excl) id(panelvar) time(year) reps(100)
est store hour_`x'
}
* Tables
esttab mult_* hour_* using "Heckman_Females.csv", replace ///
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
* Multiple occupations
foreach x in $xvar {
xtheckmanfe multipleoccup `x' $indiv $econ $compo, selection(work = $excl) id(panelvar) time(year) reps(100)
est store mult_`x'
}
* Hours a year
foreach x in $xvar {
xtheckmanfe hoursayear_indiv `x' $indiv $econ $compo, selection(work = $excl) id(panelvar) time(year) reps(100)
est store hour_`x'
}
* Tables
esttab mult_* hour_* using "Heckman_Old.csv", replace ///
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
