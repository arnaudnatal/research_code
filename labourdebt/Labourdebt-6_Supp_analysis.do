*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*December 5, 2023
*-----
gl link = "labourdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------











****************************************
* Working environmental conditions
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Check year
ta share_dsr year
ta lag_share_dsr year


********** Selection
drop if age<14
keep if year==2020


********** Sort
sort HHID_panel INDID_panel year



********** Controls
global nonvar i.caste i.villageid
global econ remittnet_HH assets_total dummymarriage 
global compo HHsize HH_count_child sexratio nonworkersratio
global indiv c.age##c.age i.edulevel i.relation2 i.sex

********** Total
* Execution
qui reg executionwork DSR_lag $indiv $econ $compo, cluster(HHFE)
est store exe

* Problem
qui reg problemwork DSR_lag $indiv $econ $compo, cluster(HHFE)
est store pro

* Exposure
qui reg workexposure DSR_lag $indiv $econ $compo, cluster(HHFE)
est store exp

* WEC
qui reg wec DSR_lag $indiv $econ $compo, cluster(HHFE)
est store wec

* Tables
esttab exe pro exp wec using "Wec_Total.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $econ $compo) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

	
********** Males
preserve
fre sex
keep if sex==1
* Execution
qui reg executionwork DSR_lag $indiv $econ $compo, cluster(HHFE)
est store exe

* Problem
qui reg problemwork DSR_lag $indiv $econ $compo, cluster(HHFE)
est store pro

* Exposure
qui reg workexposure DSR_lag $indiv $econ $compo, cluster(HHFE)
est store exp

* WEC
qui reg wec DSR_lag $indiv $econ $compo, cluster(HHFE)
est store wec

* Tables
esttab exe pro exp wec using "Wec_Males.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $econ $compo) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
restore

	
	
********** Females
preserve
fre sex
keep if sex==2
* Execution
qui reg executionwork DSR_lag $indiv $econ $compo, cluster(HHFE)
est store exe

* Problem
qui reg problemwork DSR_lag $indiv $econ $compo, cluster(HHFE)
est store pro

* Exposure
qui reg workexposure DSR_lag $indiv $econ $compo, cluster(HHFE)
est store exp

* WEC
qui reg wec DSR_lag $indiv $econ $compo, cluster(HHFE)
est store wec

* Tables
esttab exe pro exp wec using "Wec_Females.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $econ $compo) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
restore


****************************************
* END


















****************************************
* Lag Share dsr
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Check year
ta share_dsr year
ta lag_share_dsr year


********** Selection
drop if age<14
keep if year==2020


********** Sort
sort HHID_panel INDID_panel year



********** Controls
global nonvar i.caste i.villageid
global econ remittnet_HH assets_total dummymarriage 
global compo HHsize HH_count_child sexratio nonworkersratio
global indiv c.age##c.age i.edulevel i.relation2 i.sex

********** Total
* Work
qui reg work lag_share_dsr $indiv $econ $compo, cluster(HHFE)
est store work
* Hours a year
qui reg hoursayear_indiv lag_share_dsr $indiv $econ $compo, cluster(HHFE)
est store hour
* Tables
esttab work hour using "Sharedsr_Total.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $econ $compo) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))


	
********** Males
preserve
fre sex
keep if sex==1
* Work
qui reg work lag_share_dsr $indiv $econ $compo, cluster(HHFE)
est store work
* Hours a year
qui reg hoursayear_indiv lag_share_dsr $indiv $econ $compo, cluster(HHFE)
est store hour
* Tables
esttab work hour using "Sharedsr_Males.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $econ $compo) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
restore



********** Females
preserve
fre sex
keep if sex==2
* Work
qui reg work lag_share_dsr $indiv $econ $compo, cluster(HHFE)
est store work
* Hours a year
qui reg hoursayear_indiv lag_share_dsr $indiv $econ $compo, cluster(HHFE)
est store hour
* Tables
esttab work hour using "Sharedsr_Females.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $econ $compo) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
restore




********** More than 58
preserve
drop if age<58
* Work
qui reg work lag_share_dsr $indiv $econ $compo, cluster(HHFE)
est store work
* Hours a year
qui reg hoursayear_indiv lag_share_dsr $indiv $econ $compo, cluster(HHFE)
est store hour
* Tables
esttab work hour using "Sharedsr_Old.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $econ $compo) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
restore
	
****************************************
* END






















****************************************
* Household level
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
global xvar DSR_lag caste dalits villageid remittnet_HH assets_total dummymarriage HHsize HH_count_child sexratio nonworkersratio head_sex head_age head_maritalstatus head_edulevel head_widowseparated head_mocc_occupation

global yvar expenses_educ hours_male_HH hours_female_HH hours_old_HH hours_agriself_HH hours_agricasu_HH hours_casua_HH hours_regnonqu_HH hours_regquali_HH hours_self_HH hours_nrega_HH hours_agri_HH hours_nonagri_HH hours_selfemp_HH hours_casu_HH

keep HHID_panel year $yvar $xvar
duplicates drop
ta year

********** Sort
sort HHID_panel year 
encode HHID_panel, gen(panelvar)
xtset panelvar year


********** Controls
global nonvar i.dalits i.villageid
global econ remittnet_HH assets_total dummymarriage 
global compo HHsize HH_count_child sexratio nonworkersratio
global indiv head_age i.head_edulevel i.head_sex i.head_widowseparated i.head_mocc_occupation


********** Regressions
foreach y in $yvar {
xtreg `y' c.DSR_lag $indiv $econ $compo, fe
est store hour_`y'
}


********** Tables
esttab hour_* using "FE_HH.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

	
********** Results
/*
Only females works to pay off the household debt.
*/

****************************************
* END
