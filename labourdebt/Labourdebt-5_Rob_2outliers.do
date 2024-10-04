*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*December 5, 2023
*-----
gl link = "labourdebt"
*Rob outliers
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


********** 1% outliers
foreach i in 2016 2020 {
gen todrop`i'=1 if year==`i'
qui sum hoursamonth_indiv if year==`i', det
replace todrop`i'=0 if inrange(hoursamonth_indiv, r(p5), r(p95)) & year==`i'
replace todrop`i'=0 if work==0 & year==`i'
drop if todrop`i'==1
drop todrop`i'
}



**********
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste  i.villageid ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(200) seed(4)
est store m1


********** Tables
esttab m1 using "Heckman_total_noout.csv", replace ///
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

********** 1% outliers
foreach i in 2016 2020 {
gen todrop`i'=1 if year==`i'
qui sum hoursamonth_indiv if year==`i', det
replace todrop`i'=0 if inrange(hoursamonth_indiv, r(p5), r(p95)) & year==`i'
replace todrop`i'=0 if work==0 & year==`i'
drop if todrop`i'==1
drop todrop`i'
}


********** 
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste  i.villageid ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(200) seed(4)
est store m1


********** Tables
esttab m1 using "Heckman_males_noout.csv", replace ///
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


********** 1% outliers
foreach i in 2016 2020 {
gen todrop`i'=1 if year==`i'
qui sum hoursamonth_indiv if year==`i', det
replace todrop`i'=0 if inrange(hoursamonth_indiv, r(p5), r(p95)) & year==`i'
replace todrop`i'=0 if work==0 & year==`i'
drop if todrop`i'==1
drop todrop`i'
}


********** 
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste  i.villageid ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(200) seed(3)
est store m1


********** Tables
esttab m1 using "Heckman_females_noout.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END
