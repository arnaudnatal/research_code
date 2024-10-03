*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*December 5, 2023
*-----
gl link = "labourdebt"
*Rob share dsr
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------








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



********** Total
heckman hoursamonth_indiv lag_share_dsr ///
c.age i.edulevel i.relation2 i.sex i.marital ///
c.remitt_std c.assets_std i.caste ///
HHsize HH_count_child sexratio ///
, select(work = c.nonworkersratio) ///
clust(HHFE)
est store reg1



********** Males
*
preserve
fre sex
keep if sex==1
set maxiter 53
heckman hoursamonth_indiv lag_share_dsr ///
c.age i.edulevel i.relation2 i.marital ///
c.remitt_std c.assets_std i.caste ///
HHsize HH_count_child sexratio ///
, select(work = c.nonworkersratio) ///
clust(HHFE)
est store reg2
restore
*
preserve
fre sex
keep if sex==1
set maxiter 45
heckman hoursamonth_indiv lag_share_dsr ///
i.cat_age i.edulevel i.relation2 i.marital ///
c.remitt_std c.assets_std i.caste ///
HHsize HH_count_child sexratio ///
, select(work = c.nonworkersratio) ///
clust(HHFE)
est store reg3
restore



********** Females
preserve
fre sex
keep if sex==2
heckman hoursamonth_indiv lag_share_dsr ///
i.cat_age i.edulevel i.relation2 i.marital ///
c.remitt_std c.assets_std i.caste ///
HHsize HH_count_child sexratio ///
, select(work = c.nonworkersratio) ///
clust(HHFE)
est store reg4

set maxiter 56
heckman hoursamonth_indiv lag_share_dsr ///
c.age i.edulevel i.relation2 i.marital ///
c.remitt_std c.assets_std i.caste ///
HHsize HH_count_child sexratio ///
, select(work = c.nonworkersratio) ///
clust(HHFE)
est store reg5

restore


********** Table
esttab reg1 reg2 reg3 reg4 reg5 using "Indiv_Heckman.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	keep(lag_share_dsr) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
	
****************************************
* END

