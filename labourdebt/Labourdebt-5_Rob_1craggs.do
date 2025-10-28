*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*October 27, 2025
*-----
gl link = "labourdebt"
*Rob Craggs
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------







****************************************
* Craggs total
****************************************
use"panel_laboursupplyindiv_v2", clear



********** Selection
drop if age<14


********** Panel
sort HHID_panel INDID_panel year
xtset panelvar year


********** Recode
recode secondlockdownexposure (.=1)
recode marital (3=2)


* Work
qui xtreg work DSR_lag ///
c.age i.edulevel i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste i.villageid i.dummydemonetisation i.secondlockdownexposure i.dummymarriage ///
, fe
est store work



* Hours a month
xtreg hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste i.villageid i.dummydemonetisation i.secondlockdownexposure i.dummymarriage ///
, fe
est store hour


* Tables
esttab work hour using "Craggs_total.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $econ $compo) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END















	

****************************************
* Craggs males
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14
fre sex
keep if sex==1


********** Panel
sort HHID_panel INDID_panel year
xtset panelvar year


********** Recode
recode secondlockdownexposure (.=1)
recode marital (3=2)


* Work
qui xtreg work DSR_lag ///
c.age i.edulevel i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste i.villageid i.dummydemonetisation i.secondlockdownexposure i.dummymarriage ///
, fe
est store work



* Hours a month
xtreg hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste i.villageid i.dummydemonetisation i.secondlockdownexposure i.dummymarriage ///
, fe
est store hour


* Tables
esttab work hour using "Craggs_males.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $econ $compo) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END















	
	
****************************************
* Craggs females
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14
fre sex
keep if sex==2

********** Panel
sort HHID_panel INDID_panel year
xtset panelvar year


********** Recode
recode secondlockdownexposure (.=1)
recode marital (3=2)


* Work
xtreg work DSR_lag ///
c.age i.edulevel i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste i.villageid i.dummydemonetisation i.secondlockdownexposure i.dummymarriage ///
, fe
est store work



* Hours a month
xtreg hoursamonth_indiv DSR_lag ///
c.age i.edulevel i.sex i.marital ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste i.villageid i.dummydemonetisation i.secondlockdownexposure i.dummymarriage ///
, fe
est store hour



* Tables
esttab work hour using "Craggs_females.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $econ $compo) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))


****************************************
* END


do"C:\Users\Arnaud\Documents\GitHub\research_code\labourdebt\Labourdebt-5_Rob_2outliers.do"
