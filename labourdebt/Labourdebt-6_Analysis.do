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











/*
****************************************
* Test instruments
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14



********** Panel
sort HHID_panel INDID_panel year
xtset panelvar year
est clear



********** Exclusion 1
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.sex i.marital ///
remitt_std assets_std dummymarriage ///
HHsize HH_count_child sexratio nonworkersratio ///
, selection(work = i.landowner i.relation2 c.monthlyexpenses) ///
id(panelvar) time(year) reps(500)
est store excl_1



********** Exclusion 2
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.sex i.relation2 ///
remitt_std assets_std dummymarriage ///
HHsize sexratio nonworkersratio ///
, selection(work = i.marital c.HH_count_child c.HH_count_adult) ///
id(panelvar) time(year) reps(500)
est store excl_2



********** Exclusion 3
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std dummymarriage ///
HHsize HH_count_child sexratio nonworkersratio ///
, selection(work = i.dummyremrec) ///
id(panelvar) time(year) reps(500)
est store excl_3




********** Exclusion 5
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std dummymarriage ///
HHsize HH_count_child sexratio nonworkersratio ///
, selection(work = c.age) ///
id(panelvar) time(year) reps(500)
est store excl_5




********** Exclusion 6
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std dummymarriage ///
HHsize sexratio nonworkersratio ///
, selection(work = i.head_edulevel HH_count_child annualincome_HH) ///
id(panelvar) time(year) reps(500)
est store excl_6



********** Exclusion 7
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std dummymarriage ///
HHsize sexratio nonworkersratio ///
, selection(work = c.HH_count_child) ///
id(panelvar) time(year) reps(500)
est store excl_7


********** Tables
esttab excl_1 excl_2 excl_3 excl_5 excl_6 excl_7 using "IMR_test.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))


****************************************
* END
*/









****************************************
* Heckman total sample
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14


********** Panel
sort HHID_panel INDID_panel year
xtset panelvar year
est clear


********** Controls brut
mdesc hoursamonth_indiv DSR_lag age edulevel relation2 sex marital remitt_std assets_std dummymarriage HHsize HH_count_child sexratio work nonworkersratio

********** Exclusion 4
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(500)
est store excl_4


********** Tables
esttab excl_4 using "Heckman_total.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
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
est clear



********** Exclusion 4
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(500)
est store excl_4


********** Tables
esttab excl_4 using "Heckman_females.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
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
est clear


********** Exclusion 4
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(500)
est store excl_4



********** Tables
esttab excl_4 using "Heckman_males.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END






/*










****************************************
* Heckman type of jobs
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14

********** Panel
sort HHID_panel INDID_panel year
xtset panelvar year
est clear



********** Exclusion 4
foreach x in hours_agri hours_nonagri hours_selfemp hours_casu {
capture noisily xtheckmanfe `x' DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(500)
est store excl_`x'
}


********** Tables
esttab excl_* using "Heckman_jobs.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END
















****************************************
* Heckman type of jobs for females
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14
keep if sex==2


********** Panel
sort HHID_panel INDID_panel year
xtset panelvar year
est clear

gen hours_reg=hours_regnonqu+hours_regquali



********** Exclusion 4
*foreach x in hours_agri hours_nonagri hours_selfemp hours_casu {
foreach x in hours_self hours_agriself hours_casua hours_reg hours_nrega hours_agricasu {
capture noisily xtheckmanfe `x' DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(500)
est store excl_`x'
}


********** Tables
esttab excl_* using "Heckman_jobs_females.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END


do"$dofile\\Labourdebt-6_Supp_analysis1.do"
