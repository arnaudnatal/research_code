*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*July 25, 2025
*-----
gl link = "labourdebt"
*Econo rob avec DAR
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
sort HHID_panel INDID_panel year
br HHID_panel INDID_panel year dummypanel


********** Panel
sort HHID_panel INDID_panel year
xtset panelvar year
est clear



**********
/*
Garder 'seed(4)' car c'est le seed qui va le plus vite à converger.
*/
capture noisily xtheckmanfe hoursamonth_indiv DAR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste  i.villageid ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(200) seed(4)
est store m1


********** Tables
esttab m1 using "RobDAR_Heckman_total.csv", replace ///
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


********** 
capture noisily xtheckmanfe hoursamonth_indiv DAR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste  i.villageid ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(200) seed(4)
est store m1


********** Tables
esttab m1 using "RobDAR_Heckman_males.csv", replace ///
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



********** 
capture noisily xtheckmanfe hoursamonth_indiv DAR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste  i.villageid ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(200) seed(4)
est store m1


********** Tables
esttab m1 using "RobDAR_Heckman_females.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END
