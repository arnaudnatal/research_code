*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*April 14, 2025
*-----
gl link = "labourdebt"
*Rob no self employment activities
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



********** Without self act
ta lag_se_act se_act
ta lag_se_act year
ta se_act year
drop if lag_se_act==1



**********
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste  i.villageid ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(20) seed(4)
est store m1




********** Tables
esttab m1 using "Heckman_total_noself.csv", replace ///
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


********** Without self act
ta lag_se_act se_act
ta lag_se_act year
ta se_act year
drop if lag_se_act==1





********** 
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste  i.villageid ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(20) seed(4)
est store m1



********** Tables
esttab m1 using "Heckman_males_noself.csv", replace ///
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



********** Without self act
ta lag_se_act se_act
ta lag_se_act year
ta se_act year
drop if lag_se_act==1





********** 
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste  i.villageid ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(20) seed(4)
est store m1


********** Tables
esttab m1 using "Heckman_females_noself.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END
