*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*December 5, 2023
*-----
gl link = "labourdebt"
*Econo castes
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------




/*
Interaction avec la richesse
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



********** 
est clear
capture noisily xtheckmanfe hoursamonth_indiv c.DSR_lag##c.assets_std ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std i.caste ///
HHsize HH_count_child sexratio  i.villageid ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(200) seed(1)
est store m1



********** Tables
esttab m1  using "Wealth_Heckman_total.csv", replace ///
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


********** 
est clear
capture noisily xtheckmanfe hoursamonth_indiv c.DSR_lag##c.assets_std ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std i.caste ///
HHsize HH_count_child sexratio  i.villageid ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(200) seed(8)
est store m1



********** Tables
esttab m1 using "Wealth_Heckman_males.csv", replace ///
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



**********
est clear
capture noisily xtheckmanfe hoursamonth_indiv c.DSR_lag##c.assets_std ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std i.caste ///
HHsize HH_count_child sexratio  i.villageid ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(200) seed(27)
est store m1



********** Tables
esttab m1 using "Wealth_Heckman_females.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END
