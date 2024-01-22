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
* Instruments
****************************************


/*
********** Exclusion 1
capture noisily xtheckmanfe hoursaweek_indiv DSR_lag ///
c.age##c.age i.edulevel i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio nonworkersratio ///
, selection(work = i.landowner i.relation2 c.monthlyexpenses) ///
id(panelvar) time(year) reps(30)
est store excl_1
*/

/*
********** Exclusion 2
capture noisily xtheckmanfe hoursaweek_indiv DSR_lag ///
c.age##c.age i.edulevel i.sex i.relation2 ///
remittnet_HH assets_total dummymarriage ///
HHsize sexratio nonworkersratio ///
, selection(work = i.marital c.HH_count_child c.HH_count_adult) ///
id(panelvar) time(year) reps(30)
est store excl_2
*/

/*
********** Exclusion 3
capture noisily xtheckmanfe hoursaweek_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio nonworkersratio ///
, selection(work = i.dummyremrec) ///
id(panelvar) time(year) reps(30)
est store excl_3
*/


/*
********** Exclusion 5
capture noisily xtheckmanfe hoursaweek_indiv DSR_lag ///
i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio nonworkersratio ///
, selection(work = c.age##c.age) ///
id(panelvar) time(year) reps(30)
est store excl_5
*/


/*
********** Exclusion 6
capture noisily xtheckmanfe hoursaweek_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize sexratio nonworkersratio ///
, selection(work = i.head_edulevel HH_count_child annualincome_HH) ///
id(panelvar) time(year) reps(30)
est store excl_6
*/

/*
********** Exclusion 7
capture noisily xtheckmanfe hoursaweek_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize sexratio nonworkersratio ///
, selection(work = c.HH_count_child) ///
id(panelvar) time(year) reps(30)
est store excl_7
*/

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



********** Exclusion 4
capture noisily xtheckmanfe hoursaweek_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(30)
est store excl_4

*3210 individus

********** Tables
esttab excl_4 using "Heckman_Total.csv", replace ///
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


********** Controls brut
global rawnonvar i.caste i.villageid
global rawecon remittnet_HH assets_total dummymarriage 
global rawcompo HHsize HH_count_child sexratio nonworkersratio
global rawindiv c.age##c.age i.edulevel i.relation2 i.sex i.marital


********** Exclusion 4
capture noisily xtheckmanfe hoursaweek_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(30)
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


********** Exclusion 4
capture noisily xtheckmanfe hoursaweek_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(30)
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



********** Exclusion 4
capture noisily xtheckmanfe hoursaweek_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(30)
est store excl_4



********** Tables
esttab excl_4 using "Heckman_old.csv", replace ///
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
* Heckman type of jobs
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



********** Exclusion 4
foreach x in hours_agri hours_nonagri hours_selfemp hours_casu {
capture noisily xtheckmanfe `x' DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(30)
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

