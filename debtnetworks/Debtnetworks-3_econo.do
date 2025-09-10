*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*September 2, 2025
*-----
gl link = "debtnetworks"
*Econo
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\debtnetworks.do"
*-------------------------

cd"C:\Users\anatal\Documents\Ongoing_Networks_debt\Analysis"




****************************************
* Analysis at indiv level sans interactions
****************************************
use"Main_analyses_v5", clear

***** Selection
drop if nbloan_indiv==.
drop if nbloan_indiv==0
replace dsr_indiv=dsr_indiv*100
replace isr_indiv=isr_indiv*100


***** Macro
global controls i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid

global coef 1.sex 2.sex age 1.caste 2.caste 3.caste 1.educ 2.educ 3.educ 4.educ 5.educ 6.educ 1.occupation 2.occupation 3.occupation 4.occupation 5.occupation 6.occupation 7.occupation assets_total annualincome_HH 1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid


***** Quanti
global yvars loanamount_indiv isr_indiv share_pb
foreach y in $yvars {
foreach x in sn_size sn_dura sn_sgende sn_scaste sn_socc sn_sloc sn_family {
qui reg `y' `x' $controls, cluster(HHFE)
est store `y'_`x'
}
}
*
foreach y in $yvars {
esttab `y'_sn_size `y'_sn_dura `y'_sn_sgende `y'_sn_scaste `y'_sn_socc `y'_sn_sloc `y'_sn_family using "`y'.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $coef) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
}	


***** Quali
global yvars dpbtorepay_indiv
foreach y in $yvars {
foreach x in sn_size sn_dura sn_sgende sn_scaste sn_socc sn_sloc sn_family {
qui probit `y' `x' $controls, cluster(HHFE)
est store `y'_`x'
}
}
*
foreach y in $yvars {
esttab `y'_sn_size `y'_sn_dura `y'_sn_sgende `y'_sn_scaste `y'_sn_socc `y'_sn_sloc `y'_sn_family using "`y'.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $coef) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
}	

****************************************
* END
























****************************************
* Analysis at indiv level gender interaction
****************************************
use"Main_analyses_v5", clear

***** Selection
drop if nbloan_indiv==.
drop if nbloan_indiv==0
replace dsr_indiv=dsr_indiv*100
replace isr_indiv=isr_indiv*100


***** Macro
global controls i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid

global coef 1.sex 2.sex age 1.caste 2.caste 3.caste 1.educ 2.educ 3.educ 4.educ 5.educ 6.educ 1.occupation 2.occupation 3.occupation 4.occupation 5.occupation 6.occupation 7.occupation assets_total annualincome_HH 1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid


***** Quanti
global yvars loanamount_indiv isr_indiv share_pb
foreach y in $yvars {
foreach x in sn_size sn_dura sn_sgende sn_scaste sn_socc sn_sloc sn_family {
qui reg `y' c.`x'##i.sex $controls, cluster(HHFE)
est store `y'_`x'
}
}
*
foreach y in $yvars {
esttab `y'_sn_size `y'_sn_dura `y'_sn_sgende `y'_sn_scaste `y'_sn_socc `y'_sn_sloc `y'_sn_family using "`y'_gender.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $coef) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
}	


***** Quali
global yvars dpbtorepay_indiv
foreach y in $yvars {
foreach x in sn_size sn_dura sn_sgende sn_scaste sn_socc sn_sloc sn_family {
qui probit `y' c.`x'##i.sex $controls, cluster(HHFE)
est store `y'_`x'
}
}
*
foreach y in $yvars {
esttab `y'_sn_size `y'_sn_dura `y'_sn_sgende `y'_sn_scaste `y'_sn_socc `y'_sn_sloc `y'_sn_family using "`y'_gender.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $coef) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
}		


****************************************
* END












****************************************
* Analysis at indiv level caste interaction
****************************************
use"Main_analyses_v5", clear

***** Selection
drop if nbloan_indiv==.
drop if nbloan_indiv==0
replace dsr_indiv=dsr_indiv*100
replace isr_indiv=isr_indiv*100


***** Macro
global controls i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid

global coef 1.sex 2.sex age 1.caste 2.caste 3.caste 1.educ 2.educ 3.educ 4.educ 5.educ 6.educ 1.occupation 2.occupation 3.occupation 4.occupation 5.occupation 6.occupation 7.occupation assets_total annualincome_HH 1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid


***** Quanti
global yvars loanamount_indiv isr_indiv share_pb
foreach y in $yvars {
foreach x in sn_size sn_dura sn_sgende sn_scaste sn_socc sn_sloc sn_family {
qui reg `y' c.`x'##i.caste $controls, cluster(HHFE)
est store `y'_`x'
}
}
*
foreach y in $yvars {
esttab `y'_sn_size `y'_sn_dura `y'_sn_sgende `y'_sn_scaste `y'_sn_socc `y'_sn_sloc `y'_sn_family using "`y'_caste.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $coef) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
}	


***** Quali
global yvars dpbtorepay_indiv
foreach y in $yvars {
foreach x in sn_size sn_dura sn_sgende sn_scaste sn_socc sn_sloc sn_family {
qui probit `y' c.`x'##i.caste $controls, cluster(HHFE)
est store `y'_`x'
}
}
*
foreach y in $yvars {
esttab `y'_sn_size `y'_sn_dura `y'_sn_sgende `y'_sn_scaste `y'_sn_socc `y'_sn_sloc `y'_sn_family using "`y'_caste.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $coef) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
}	


****************************************
* END
























****************************************
* Analysis at indiv level sans interactions avec tous les X
****************************************
use"Main_analyses_v5", clear

***** Selection
drop if nbloan_indiv==.
drop if nbloan_indiv==0
replace dsr_indiv=dsr_indiv*100
replace isr_indiv=isr_indiv*100


***** Macro
global controls i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid

global coef 1.sex 2.sex age 1.caste 2.caste 3.caste 1.educ 2.educ 3.educ 4.educ 5.educ 6.educ 1.occupation 2.occupation 3.occupation 4.occupation 5.occupation 6.occupation 7.occupation assets_total annualincome_HH 1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid


***** 
qui reg loanamount_indiv sn_size sn_dura sn_sgende sn_scaste sn_socc sn_sloc sn_family $controls, cluster(HHFE)
est store loanamount
qui reg isr_indiv sn_size sn_dura sn_sgende sn_scaste sn_socc sn_sloc sn_family $controls, cluster(HHFE)
est store isr
qui probit dpbtorepay_indiv sn_size sn_dura sn_sgende sn_scaste sn_socc sn_family sn_sloc $controls, cluster(HHFE)
est store dpbtorepay
qui probit share_pb sn_size sn_dura sn_sgende sn_scaste sn_socc sn_family sn_sloc $controls, cluster(HHFE)
est store share_pb

*
esttab loanamount isr dpbtorepay share_pb using "allX.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $coef) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END














****************************************
* Analysis at loan level sans interactions
****************************************
use"Analysesloan_v2", clear

***** Selection
keep if dummymainloan==1

***** Controls
global controls i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid


***** Pb to repay
probit dummyproblemtorepay ///
i.samecaste i.samesex i.dummymultipleloan duration_cat ///
i.sameoccup i.samevillage ///
$controls loanamount i.loanreasongiven, cluster(hhindiv)

***** Help to settle
probit dummyhelptosettleloan ///
i.samecaste i.samesex i.dummymultipleloan duration_cat ///
i.sameoccup i.samevillage ///
$controls loanamount i.loanreasongiven, cluster(hhindiv)

***** Dummy interest
probit dummyinterest ///
i.samecaste i.samesex i.dummymultipleloan duration_cat ///
i.sameoccup i.samevillage ///
$controls loanamount i.loanreasongiven, cluster(hhindiv)

***** Interest rate
reg monthlyinterestrate ///
i.samecaste i.samesex i.dummymultipleloan duration_cat ///
i.sameoccup i.samevillage ///
$controls loanamount i.loanreasongiven, cluster(hhindiv)


****************************************
* END
