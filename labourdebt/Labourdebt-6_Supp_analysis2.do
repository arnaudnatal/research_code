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
c.remitt_std c.assets_std dummymarriage i.caste ///
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
c.remitt_std c.assets_std dummymarriage i.caste ///
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
c.remitt_std c.assets_std dummymarriage i.caste ///
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
c.remitt_std c.assets_std dummymarriage i.caste ///
HHsize HH_count_child sexratio ///
, select(work = c.nonworkersratio) ///
clust(HHFE)
est store reg4

set maxiter 56
heckman hoursamonth_indiv lag_share_dsr ///
c.age i.edulevel i.relation2 i.marital ///
c.remitt_std c.assets_std dummymarriage i.caste ///
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





















****************************************
* Caractéristiques de l'emploi des femmes
****************************************


********** Type of employment
cls
use"panel_laboursupplyindiv_v2", clear
drop if age<14
keep if work==1
rename mainocc_occupation_indiv occupation
rename mainocc_annualincome_indiv income
rename mainocc_hoursayear_indiv hoursayear

ta occupation sex, col nofreq
ta occupation sex, cchi2 exp chi2
/*
Femmes sur-représentés dans les activités agri casual et MGNREGA.
*/



********** Hourly income
cls
use"panel_laboursupplyindiv_v2", clear
drop if age<14
keep if work==1
rename mainocc_occupation_indiv occupation
*
rename mainocc_annualincome_indiv income
rename mainocc_hoursayear_indiv hoursayear
gen hourlyincome=income/hoursayear
fre occupation
ta occupation year
*
tabstat hourlyincome, stat(n mean q) by(occupation)
reg hourlyincome ib(2).occupation, clust(HHFE) baselevel
*
margins, dydx(occupation) atmeans post
*marginsplot, yline(0)

***** Graph
collapse (mean) hourlyincome, by(occupation year)
drop if occupation==.

*
graph bar hourlyincome, over(year) over(occupation, lab(angle(45)) relabel(1 "Agri self-emp" 2 "Agri casual" 3 "Casual" 4 "Reg non-quali" 5 "Reg quali" 6 "Self-emp" 7 "MGNREGA"))	ytitle("Mean") ylabel(0(10)90) asyvars legend(order(1 "2016-17" 2 "2020-21") pos(6) col(2)) name(inc, replace)
graph export "Hourlyincome.pdf", as(pdf) replace








********** WEC
cls
use"panel_laboursupplyindiv_v2", clear

* verif des couples
preserve
keep if year==2020
keep if executionwork!=.
fre relationshiptohead
keep if relationshiptohead==1 | relationshiptohead==2
keep HHID_panel INDID_panel
gen couple=1
bysort HHID_panel: gen n=_n
drop INDID_panel
reshape wide couple, i(HHID_panel) j(n)
keep if couple1!=. & couple2!=.
restore

drop if age<14
keep if work==1
rename mainocc_occupation_indiv occupation
*
keep if year==2020
fre occupation
ta executionwork
global var executionwork problemwork workexposure wec
*
foreach x in $var {
tabstat `x', stat(n mean q) by(occupation)
reg `x' ib(2).occupation, clust(HHFE) baselevel
margins, dydx(occupation) atmeans post
*marginsplot, yline(0) name(`x',replace)
}

***** Graph
collapse (mean) executionwork problemwork workexposure, by(occupation)
drop if occupation==.

set graph off
* Execution
twoway ///
(bar executionwork occupation, barwidth(.5)) ///
, ///
xlab(1 "Agri self-emp" 2 "Agri casual" 3 "Casual" 4 "Reg non-quali" 5 "Reg quali" 6 "Self-emp" 7 "MGNREGA", angle(45)) xtitle("") ///
ylab(.3(.1)1) ytitle("Mean") ///
title("Execution score") name(exe, replace)

* Problem
twoway ///
(bar problemwork occupation, barwidth(.5)) ///
, ///
xlab(1 "Agri self-emp" 2 "Agri casual" 3 "Casual" 4 "Reg non-quali" 5 "Reg quali" 6 "Self-emp" 7 "MGNREGA", angle(45)) xtitle("") ///
ylab(.3(.1)1) ytitle("Mean") ///
title("Problem score") name(pb, replace)

* Work exposure
twoway ///
(bar workexposure occupation, barwidth(.5)) ///
, ///
xlab(1 "Agri self-emp" 2 "Agri casual" 3 "Casual" 4 "Reg non-quali" 5 "Reg quali" 6 "Self-emp" 7 "MGNREGA", angle(45)) xtitle("") ///
ylab(.3(.1)1) ytitle("Mean") ///
title("Exposition score") name(work, replace)
set graph on


* Combine
graph combine exe pb work, col(3) name(comb, replace)
graph export "Workingcond.pdf", as(pdf) replace








********** Discrimination
cls
use"panel_laboursupplyindiv_v2", clear
drop if age<14
keep if work==1
rename mainocc_occupation_indiv occupation
*
keep if year==2020
fre occupation
global var respect workmate agreementatwork1 agreementatwork2 agreementatwork3 agreementatwork4 happywork verbalaggression physicalaggression sexualharassment discrimination discrimination_dummy
*
foreach x in $var {
tabstat `x', stat(n mean q) by(occupation)
reg `x' ib(2).occupation, clust(HHFE) baselevel
margins, dydx(occupation) atmeans post
marginsplot, yline(0) name(`x',replace)
}

****************************************
* END


