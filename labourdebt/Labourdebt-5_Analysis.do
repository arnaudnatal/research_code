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
* Heckman total sample
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



********** Exclusion 1
xtheckmanfe hoursayear_indiv DSR_lag ///
c.age##c.age i.edulevel i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio nonworkersratio ///
, selection(work = i.landowner i.relation2 c.monthlyexpenses) ///
id(panelvar) time(year) reps(50)
est store excl_1


********** Exclusion 2
xtheckmanfe hoursayear_indiv DSR_lag ///
c.age##c.age i.edulevel i.sex i.relation2 ///
remittnet_HH assets_total dummymarriage ///
HHsize sexratio nonworkersratio ///
, selection(work = i.marital c.HH_count_child c.HH_count_adult) ///
id(panelvar) time(year) reps(50)
est store excl_2


********** Exclusion 3
xtheckmanfe hoursayear_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio nonworkersratio ///
, selection(work = i.dummyremrec) ///
id(panelvar) time(year) reps(50)
est store excl_3



********** Exclusion 4
xtheckmanfe hoursayear_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(50)
est store excl_4



********** Exclusion 5
xtheckmanfe hoursayear_indiv DSR_lag ///
i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio nonworkersratio ///
, selection(work = c.age##c.age) ///
id(panelvar) time(year) reps(50)
est store excl_5



********** Exclusion 6
xtheckmanfe hoursayear_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize sexratio nonworkersratio ///
, selection(work = i.head_edulevel HH_count_child annualincome_HH) ///
id(panelvar) time(year) reps(50)
est store excl_6




********** Tables
esttab excl_1 excl_2 excl_3 excl_4 excl_5 excl_6 using "Heckman_total.csv", replace ///
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
* Heckman males
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14
keep if sex==1


********** Panel
sort HHID_panel INDID_panel year
xtset panelvar year


********** Controls brut
global rawnonvar i.caste i.villageid
global rawecon remittnet_HH assets_total dummymarriage 
global rawcompo HHsize HH_count_child sexratio nonworkersratio
global rawindiv c.age##c.age i.edulevel i.relation2 i.sex i.marital



********** Exclusion 1
xtheckmanfe hoursayear_indiv DSR_lag ///
c.age##c.age i.edulevel i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio nonworkersratio ///
, selection(work = i.landowner i.relation2 c.monthlyexpenses) ///
id(panelvar) time(year) reps(50)
est store excl_1


********** Exclusion 2
xtheckmanfe hoursayear_indiv DSR_lag ///
c.age##c.age i.edulevel i.sex i.relation2 ///
remittnet_HH assets_total dummymarriage ///
HHsize sexratio nonworkersratio ///
, selection(work = i.marital c.HH_count_child c.HH_count_adult) ///
id(panelvar) time(year) reps(50)
est store excl_2


********** Exclusion 3
xtheckmanfe hoursayear_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio nonworkersratio ///
, selection(work = i.dummyremrec) ///
id(panelvar) time(year) reps(50)
est store excl_3



********** Exclusion 4
xtheckmanfe hoursayear_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(50)
est store excl_4



********** Exclusion 5
xtheckmanfe hoursayear_indiv DSR_lag ///
i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio nonworkersratio ///
, selection(work = c.age##c.age) ///
id(panelvar) time(year) reps(50)
est store excl_5



********** Exclusion 6
xtheckmanfe hoursayear_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize sexratio nonworkersratio ///
, selection(work = i.head_edulevel HH_count_child annualincome_HH) ///
id(panelvar) time(year) reps(50)
est store excl_6




********** Tables
esttab excl_1 excl_2 excl_3 excl_4 excl_5 excl_6 using "Heckman_males.csv", replace ///
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
* Heckman females
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14
keep if sex==2


********** Panel
sort HHID_panel INDID_panel year
xtset panelvar year


********** Controls brut
global rawnonvar i.caste i.villageid
global rawecon remittnet_HH assets_total dummymarriage 
global rawcompo HHsize HH_count_child sexratio nonworkersratio
global rawindiv c.age##c.age i.edulevel i.relation2 i.sex i.marital



********** Exclusion 1
xtheckmanfe hoursayear_indiv DSR_lag ///
c.age##c.age i.edulevel i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio nonworkersratio ///
, selection(work = i.landowner i.relation2 c.monthlyexpenses) ///
id(panelvar) time(year) reps(50)
est store excl_1


********** Exclusion 2
xtheckmanfe hoursayear_indiv DSR_lag ///
c.age##c.age i.edulevel i.sex i.relation2 ///
remittnet_HH assets_total dummymarriage ///
HHsize sexratio nonworkersratio ///
, selection(work = i.marital c.HH_count_child c.HH_count_adult) ///
id(panelvar) time(year) reps(50)
est store excl_2


********** Exclusion 3
xtheckmanfe hoursayear_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio nonworkersratio ///
, selection(work = i.dummyremrec) ///
id(panelvar) time(year) reps(50)
est store excl_3



********** Exclusion 4
xtheckmanfe hoursayear_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(50)
est store excl_4



********** Exclusion 5
xtheckmanfe hoursayear_indiv DSR_lag ///
i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio nonworkersratio ///
, selection(work = c.age##c.age) ///
id(panelvar) time(year) reps(50)
est store excl_5



********** Exclusion 6
xtheckmanfe hoursayear_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize sexratio nonworkersratio ///
, selection(work = i.head_edulevel HH_count_child annualincome_HH) ///
id(panelvar) time(year) reps(50)
est store excl_6




********** Tables
esttab excl_1 excl_2 excl_3 excl_4 excl_5 excl_6 using "Heckman_females.csv", replace ///
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
* Heckman old
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14
drop if age<58

********** Panel
sort HHID_panel INDID_panel year
xtset panelvar year


********** Controls brut
global rawnonvar i.caste i.villageid
global rawecon remittnet_HH assets_total dummymarriage 
global rawcompo HHsize HH_count_child sexratio nonworkersratio
global rawindiv c.age##c.age i.edulevel i.relation2 i.sex i.marital



********** Exclusion 1
xtheckmanfe hoursayear_indiv DSR_lag ///
c.age##c.age i.edulevel i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio nonworkersratio ///
, selection(work = i.landowner i.relation2 c.monthlyexpenses) ///
id(panelvar) time(year) reps(50)
est store excl_1


********** Exclusion 2
xtheckmanfe hoursayear_indiv DSR_lag ///
c.age##c.age i.edulevel i.sex i.relation2 ///
remittnet_HH assets_total dummymarriage ///
HHsize sexratio nonworkersratio ///
, selection(work = i.marital c.HH_count_child c.HH_count_adult) ///
id(panelvar) time(year) reps(50)
est store excl_2


********** Exclusion 3
xtheckmanfe hoursayear_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio nonworkersratio ///
, selection(work = i.dummyremrec) ///
id(panelvar) time(year) reps(50)
est store excl_3



********** Exclusion 4
xtheckmanfe hoursayear_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(50)
est store excl_4



********** Exclusion 5
xtheckmanfe hoursayear_indiv DSR_lag ///
i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio nonworkersratio ///
, selection(work = c.age##c.age) ///
id(panelvar) time(year) reps(50)
est store excl_5



********** Exclusion 6
xtheckmanfe hoursayear_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize sexratio nonworkersratio ///
, selection(work = i.head_edulevel HH_count_child annualincome_HH) ///
id(panelvar) time(year) reps(50)
est store excl_6




********** Tables
esttab excl_1 excl_2 excl_3 excl_4 excl_5 excl_6 using "Heckman_old.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $econ $compo) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END
