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
global rawindiv c.age i.edulevel i.relation2 i.sex i.marital



********** Exclusion 4
est clear
capture noisily xtheckmanfe hoursamonth_indiv c.DSR_lag##i.caste ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(200)
est store excl_4


********** Tables
esttab excl_4 using "Caste_Heckman_total.csv", replace ///
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
global rawindiv c.age i.edulevel i.relation2 i.sex i.marital


********** Exclusion 4
est clear
capture noisily xtheckmanfe hoursamonth_indiv c.DSR_lag##i.caste ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(500)
est store excl_4



********** Tables
esttab excl_4 using "Caste_Heckman_males.csv", replace ///
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
global rawindiv c.age i.edulevel i.relation2 i.sex i.marital


********** Exclusion 4
est clear
capture noisily xtheckmanfe hoursamonth_indiv c.DSR_lag##i.caste ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(500)
est store excl_4


********** Tables
esttab excl_4 using "Caste_Heckman_females.csv", replace ///
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


********** Controls brut
global rawnonvar i.caste i.villageid
global rawecon remittnet_HH assets_total dummymarriage 
global rawcompo HHsize HH_count_child sexratio nonworkersratio
global rawindiv c.age i.edulevel i.relation2 i.sex i.marital



********** Exclusion 4
est clear
foreach x in hours_agri hours_nonagri hours_selfemp hours_casu {
capture noisily xtheckmanfe `x' c.DSR_lag##i.caste ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(500)
est store excl_`x'
}


********** Tables
esttab excl_* using "Caste_Heckman_jobs.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END

