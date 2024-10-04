*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*December 5, 2023
*-----
gl link = "labourdebt"
*Rob Craggs
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------







****************************************
* Craggs total
****************************************
use"panel_laboursupplyindiv_v2", clear



********** Selection
drop if age<14


********** Panel
sort HHID_panel INDID_panel year
xtset panelvar year


* Work
qui xtreg work DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste i.villageid ///
, fe
est store work



* Hours a month
xtreg hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste i.villageid ///
, fe
est store hour


* Tables
esttab work hour using "Craggs_total.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $econ $compo) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END















	
	
****************************************
* Craggs males
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14
fre sex
keep if sex==1


********** Panel
sort HHID_panel INDID_panel year
xtset panelvar year


* Work
qui xtreg work DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste i.villageid ///
, fe
est store work



* Hours a month
xtreg hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste i.villageid ///
, fe
est store hour


* Tables
esttab work hour using "Craggs_males.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $econ $compo) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END















	
	
****************************************
* Craggs females
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14
fre sex
keep if sex==2

********** Panel
sort HHID_panel INDID_panel year
xtset panelvar year


* Work
qui xtreg work DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste i.villageid ///
, fe
est store work



* Hours a month
xtreg hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste i.villageid ///
, fe
est store hour



* Tables
esttab work hour using "Craggs_females.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $econ $compo) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))


****************************************
* END
