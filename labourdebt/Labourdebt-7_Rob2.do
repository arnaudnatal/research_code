*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*December 5, 2023
*-----
gl link = "labourdebt"
*Outliers 5%
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


********** 10% outliers
foreach i in 2016 2020 {
gen todrop`i'=1 if year==`i'
qui sum hoursamonth_indiv if year==`i', det
replace todrop`i'=0 if inrange(hoursamonth_indiv, r(p1), r(p99)) & year==`i'
replace todrop`i'=0 if work==0 & year==`i'
drop if todrop`i'==1
drop todrop`i'
}

********** Exclusion 4
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(500)
est store excl_4


********** Tables
esttab excl_4 using "Heckman_total_noout.csv", replace ///
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


********** 10% outliers
foreach i in 2016 2020 {
gen todrop`i'=1 if year==`i'
qui sum hoursamonth_indiv if year==`i', det
replace todrop`i'=0 if inrange(hoursamonth_indiv, r(p1), r(p99)) & year==`i'
replace todrop`i'=0 if work==0 & year==`i'
drop if todrop`i'==1
drop todrop`i'
}


********** Exclusion 4
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(500)
est store excl_4


********** Tables
esttab excl_4 using "Heckman_females_noout.csv", replace ///
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


********** 10% outliers
foreach i in 2016 2020 {
gen todrop`i'=1 if year==`i'
qui sum hoursamonth_indiv if year==`i', det
replace todrop`i'=0 if inrange(hoursamonth_indiv, r(p1), r(p99)) & year==`i'
replace todrop`i'=0 if work==0 & year==`i'
drop if todrop`i'==1
drop todrop`i'
}



********** Exclusion 4
capture noisily xtheckmanfe hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.relation2 i.sex i.marital ///
remitt_std assets_std dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(500)
est store excl_4



********** Tables
esttab excl_4 using "Heckman_males_noout.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END
