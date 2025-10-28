*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*October 27, 2025
*-----
gl link = "labourdebt"
*Rob share dsr
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------








****************************************
* Lag Share dsr total
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14
keep if year==2020


********** Recode
recode secondlockdownexposure (.=1)
recode marital (3=2)


********** Sort
sort HHID_panel INDID_panel year

********** 
heckman hoursamonth_indiv lag_share_dsr ///
c.age i.edulevel i.sex i.marital ///
remitt_std assets_std i.secondlockdownexposure ///
HHsize HH_count_child sexratio i.caste i.villageid i.dummymarriage i.secondlockdownexposure ///
, select(work = c.nonworkersratio)
est store m1


esttab m1 using "ShareDSR_Heckman_total.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	keep(lag_share_dsr) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))


****************************************
* END














****************************************
* Lag Share dsr males
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14
keep if year==2020
fre sex
keep if sex==1

********** Recode
recode secondlockdownexposure (.=1)
recode marital (3=2)

********** Sort
sort HHID_panel INDID_panel year

**********
/*
Pour que ca fonctionne, je dois enlever la variable de location et
soit l'éducation
soit le statut marital
*/
heckman hoursamonth_indiv lag_share_dsr ///
c.age i.edulevel ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste i.dummymarriage i.secondlockdownexposure ///
, select(work = c.nonworkersratio)
est store m1


esttab m1 using "ShareDSR_Heckman_males.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	keep(lag_share_dsr) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END












****************************************
* Lag Share dsr females
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14
keep if year==2020
fre sex
keep if sex==2


********** Recode
recode secondlockdownexposure (.=1)
recode marital (3=2)

********** Sort
sort HHID_panel INDID_panel year


********** 
/*
Pour que ca fonctionne, je dois enlever la variable de location et
soit l'éducation + relation
soit le statut marital + relation
soit statut + education
*/
heckman hoursamonth_indiv lag_share_dsr ///
c.age i.edulevel ///
remitt_std assets_std ///
HHsize HH_count_child sexratio i.caste i.secondlockdownexposure i.dummymarriage ///
, select(work = c.nonworkersratio)
est store m1


esttab m1 using "ShareDSR_Heckman_females.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	keep(lag_share_dsr) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END
