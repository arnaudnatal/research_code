*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*December 5, 2023
*-----
gl link = "labourdebt"
*Econo main
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------






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



********** Exclusion 1: Abraham 2017
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio nonworkersratio i.caste i.villageid ///
, selection(work = i.landowner i.relation2 c.monthlyexpenses) ///
id(panelvar) time(year) reps(200)
est store excl_1




********** Exclusion 2: Hussain & Mukhopadhyay 2023
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.sex i.relation2 ///
remitt_std assets_std ///
HHsize sexratio nonworkersratio i.caste i.villageid ///
, selection(work = i.marital c.HH_count_child c.HH_count_adult) ///
id(panelvar) time(year) reps(200)
est store excl_2


********** Exclusion 3: Hwang et al. 2019
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio nonworkersratio i.caste i.villageid ///
, selection(work = c.age) ///
id(panelvar) time(year) reps(200)
est store excl_5




********** Exclusion 4: Klasen & Pieters 2015
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize sexratio nonworkersratio  i.caste i.villageid ///
, selection(work = i.head_edulevel HH_count_child annualincome_HH) ///
id(panelvar) time(year) reps(200)
est store excl_6



********** Exclusion 5: Comola & Mello 2013
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize sexratio nonworkersratio i.caste i.villageid ///
, selection(work = c.HH_count_child) ///
id(panelvar) time(year) reps(200)
est store excl_7


********** Exclusion 6: Kuepie et al. 2009
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize sexratio nonworkersratio i.caste i.villageid ///
, selection(work = c.HH_count_child) ///
id(panelvar) time(year) reps(200)
est store excl_7


********** Tables
esttab excl_1 excl_2 excl_3 excl_4 excl_5 excl_6 excl_7 using "IMR_test.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))


****************************************
* END


