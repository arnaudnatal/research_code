*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*April 14, 2025
*-----
gl link = "labourdebt"
*Rob days worked
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
est clear




**********
capture noisily xtheckmanfe daysayear_max DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste  i.villageid ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(50) seed(4)
est store m1

capture noisily xtheckmanfe daysayear_mean DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste  i.villageid ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(50) seed(4)
est store m2


********** Tables
esttab m1 m2 using "Heckman_total_days.csv", replace ///
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
capture noisily xtheckmanfe daysayear_max DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste  i.villageid ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(50) seed(4)
est store m1

capture noisily xtheckmanfe daysayear_mean DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste  i.villageid ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(50) seed(4)
est store m2


********** Tables
esttab m1 m2 using "Heckman_males_days.csv", replace ///
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
capture noisily xtheckmanfe daysayear_max DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste  i.villageid ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(50) seed(4)
est store m1

capture noisily xtheckmanfe daysayear_mean DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste  i.villageid ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(50) seed(4)
est store m2


********** Tables
esttab m1 m2 using "Heckman_females_days.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END
