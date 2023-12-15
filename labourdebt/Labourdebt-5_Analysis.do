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
* Panel
****************************************
use"panel_laboursupplyindiv_v2", clear

/*
Pas de quantile car effets fixes pas possibles
*/


********** Panel
sort HHID_panel INDID_panel year
xtset panelvar year


********** Controls
global nonvar i.caste i.villageid
global econ remittnet_HH assets_total dummymarriage 
global compo HHsize HH_count_child sexratio nonworkersratio
global indiv age i.edulevel i.relationshiptohead i.sex
global indiv2 age i.edulevel i.relationshiptohead i.sex i.mainocc_occupation_indiv

*global xvar DSR_lag ISR_lag TDR_lag
global xvar DSR_lag


********** Total
* Work
foreach x in $xvar {
qui xtreg work `x' $indiv $econ $compo, fe cluster(HHFE)
est store work_`x'
}
* Multiple occupations
foreach x in $xvar {
qui xtreg multipleoccup `x' $indiv2 $econ $compo, fe cluster(HHFE)
est store mult_`x'
}
* Hours a year
foreach x in $xvar {
qui xtreg hoursayear_indiv `x' $indiv2 $econ $compo, fe cluster(HHFE)
est store hour_`x'
}
* Tables
esttab work_* mult_* hour_* using "Total.csv", replace ///
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
foreach x in $xvar {
qui xtreg work `x' $indiv $econ $compo, fe cluster(HHFE)
est store work_`x'
}
* Multiple occupations
foreach x in $xvar {
qui xtreg multipleoccup `x' $indiv2 $econ $compo, fe cluster(HHFE)
est store mult_`x'
}
* Hours a year
foreach x in $xvar {
qui xtreg hoursayear_indiv `x' $indiv2 $econ $compo, fe cluster(HHFE)
est store hour_`x'
}
* Tables
esttab work_* mult_* hour_* using "Males.csv", replace ///
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
foreach x in $xvar {
qui xtreg work `x' $indiv $econ $compo, fe cluster(HHFE)
est store work_`x'
}
* Multiple occupations
foreach x in $xvar {
qui xtreg multipleoccup `x' $indiv2 $econ $compo, fe cluster(HHFE)
est store mult_`x'
}
* Hours a year
foreach x in $xvar {
qui xtreg hoursayear_indiv `x' $indiv2 $econ $compo, fe cluster(HHFE)
est store hour_`x'
}
* Tables
esttab work_* mult_* hour_* using "Females.csv", replace ///
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
foreach x in $xvar {
qui xtreg work `x' $indiv $econ $compo, fe cluster(HHFE)
est store work_`x'
}
* Multiple occupations
foreach x in $xvar {
qui xtreg multipleoccup `x' $indiv2 $econ $compo, fe cluster(HHFE)
est store mult_`x'
}
* Hours a year
foreach x in $xvar {
qui xtreg hoursayear_indiv `x' $indiv2 $econ $compo, fe cluster(HHFE)
est store hour_`x'
}
* Tables
esttab work_* mult_* hour_* using "Old.csv", replace ///
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

