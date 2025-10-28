*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*October 27, 2025
*-----
gl link = "labourdebt"
*Econo main
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


********** Recode
recode secondlockdownexposure (.=1)
recode marital (3=2)



**********
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste i.villageid i.dummydemonetisation i.secondlockdownexposure i.dummymarriage ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(200) seed(1)
est store m1


********** Tables
esttab m1 using "Heckman_total.csv", replace ///
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


********** Recode
recode secondlockdownexposure (.=1)
recode marital (3=2)


********** 
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste i.villageid i.dummydemonetisation i.secondlockdownexposure i.dummymarriage ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(200) seed(1)
est store m1


********** Tables
esttab m1 using "Heckman_males.csv", replace ///
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


********** Recode
recode secondlockdownexposure (.=1)
recode marital (3=2)


********** 
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste i.villageid i.dummydemonetisation i.secondlockdownexposure i.dummymarriage ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(200) seed(1)
est store m1



********** Tables
esttab m1 using "Heckman_females.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END



do"C:\Users\Arnaud\Documents\GitHub\research_code\labourdebt\Labourdebt-4_Econo_2caste.do"
