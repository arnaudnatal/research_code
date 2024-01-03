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
* Alternative restrictions
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

global xvar DSR_lag
global yvar work multipleoccup hoursayear_indiv

global excl c.HH_count_child c.HH_count_adult 





********** Total
* Multiple occupations
foreach x in $xvar {
xtheckmanfe multipleoccup `x' $indiv $econ $compo, selection(work = $excl)
est store mult_`x'
}
* Hours a year
foreach x in $xvar {
xtheckmanfe hoursayear_indiv `x' $indiv $econ $compo, selection(work = $excl)
est store hour_`x'
}
* Tables
esttab work_* mult_* hour_* using "Heckman2_Total.csv", replace ///
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
xtheckmanfe multipleoccup `x' $indiv $econ $compo, selection(work = $excl)
est store mult_`x'
}
* Hours a year
foreach x in $xvar {
xtheckmanfe hoursayear_indiv `x' $indiv $econ $compo, selection(work = $excl)
est store hour_`x'
}
* Tables
esttab work_* mult_* hour_* using "Heckman2_Males.csv", replace ///
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
xtheckmanfe multipleoccup `x' $indiv $econ $compo, selection(work = $excl)
est store mult_`x'
}
* Hours a year
foreach x in $xvar {
xtheckmanfe hoursayear_indiv `x' $indiv $econ $compo, selection(work = $excl)
est store hour_`x'
}
* Tables
esttab work_* mult_* hour_* using "Heckman2_Females.csv", replace ///
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
xtheckmanfe multipleoccup `x' $indiv $econ $compo, selection(work = $excl)
est store mult_`x'
}
* Hours a year
foreach x in $xvar {
xtheckmanfe hoursayear_indiv `x' $indiv $econ $compo, selection(work = $excl)
est store hour_`x'
}
* Tables
esttab work_* mult_* hour_* using "Heckman2_Old.csv", replace ///
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

global xvar DSR_lag
global yvar work multipleoccup hoursayear_indiv

global excl c.HH_count_child c.HH_count_adult 


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
xtreg hoursayear_indiv `x' $indiv2 $econ $compo, fe cluster(HHFE)
est store hour_`x'
}
* Tables
esttab work_* mult_* hour_* using "Craggs_Total.csv", replace ///
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
esttab work_* mult_* hour_* using "Craggs_Males.csv", replace ///
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
esttab work_* mult_* hour_* using "Craggs_Females.csv", replace ///
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
esttab work_* mult_* hour_* using "Craggs_Old.csv", replace ///
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
















****************************************
* Lag Share dsr
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Check year
ta share_dsr year
ta lag_share_dsr year


********** Selection
drop if age<14
keep if year==2020


********** Sort
sort HHID_panel INDID_panel year



********** Controls
global nonvar i.caste i.villageid
global econ remittnet_HH assets_total dummymarriage 
global compo HHsize HH_count_child sexratio nonworkersratio
global indiv c.age##c.age i.edulevel i.relation2 i.sex
global indiv2 c.age##c.age i.edulevel i.relation2 i.sex i.mainocc_occupation_indiv

global xvar lag_share_dsr
global yvar work multipleoccup hoursayear_indiv


********** Total
* Work
foreach x in $xvar {
qui reg work `x' $indiv $econ $compo, cluster(HHFE)
est store work_`x'
}
* Multiple occupations
foreach x in $xvar {
qui reg multipleoccup `x' $indiv2 $econ $compo, cluster(HHFE)
est store mult_`x'
}
* Hours a year
foreach x in $xvar {
qui reg hoursayear_indiv `x' $indiv2 $econ $compo, cluster(HHFE)
est store hour_`x'
}
* Tables
esttab work_* mult_* hour_* using "Sharedsr_Total.csv", replace ///
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
qui reg work `x' $indiv $econ $compo, cluster(HHFE)
est store work_`x'
}
* Multiple occupations
foreach x in $xvar {
qui reg multipleoccup `x' $indiv2 $econ $compo, cluster(HHFE)
est store mult_`x'
}
* Hours a year
foreach x in $xvar {
qui reg hoursayear_indiv `x' $indiv2 $econ $compo, cluster(HHFE)
est store hour_`x'
}
* Tables
esttab work_* mult_* hour_* using "Sharedsr_Males.csv", replace ///
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
qui reg work `x' $indiv $econ $compo, cluster(HHFE)
est store work_`x'
}
* Multiple occupations
foreach x in $xvar {
qui reg multipleoccup `x' $indiv2 $econ $compo, cluster(HHFE)
est store mult_`x'
}
* Hours a year
foreach x in $xvar {
qui reg hoursayear_indiv `x' $indiv2 $econ $compo, cluster(HHFE)
est store hour_`x'
}
* Tables
esttab work_* mult_* hour_* using "Sharedsr_Females.csv", replace ///
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
qui reg work `x' $indiv $econ $compo, cluster(HHFE)
est store work_`x'
}
* Multiple occupations
foreach x in $xvar {
qui reg multipleoccup `x' $indiv2 $econ $compo, cluster(HHFE)
est store mult_`x'
}
* Hours a year
foreach x in $xvar {
qui reg hoursayear_indiv `x' $indiv2 $econ $compo, cluster(HHFE)
est store hour_`x'
}
* Tables
esttab work_* mult_* hour_* using "Sharedsr_Old.csv", replace ///
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


