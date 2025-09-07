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
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\debtnetworks.do"
*-------------------------

*cd"D:\Ongoing_Networks_debt\Analysis"




****************************************
* Analysis at indiv level sans interactions
****************************************
use"Main_analyses_v5", clear

***** Selection
drop if nbloan_indiv==.
drop if nbloan_indiv==0


***** Macro
global controls i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid

global coef 1.sex 2.sex age 1.caste 2.caste 3.caste 1.educ 2.educ 3.educ 4.educ 5.educ 6.educ 1.occupation 2.occupation 3.occupation 4.occupation 5.occupation 6.occupation 7.occupation assets_total annualincome_HH 1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid


***** Quanti
global yvars loanamount_indiv dsr_indiv isr_indiv
foreach y in $yvars {
foreach x in sn_size sn_dura sn_stre sn_sgende sn_scaste sn_sjatis sn_sage sn_sstat sn_socc sn_sedu sn_sloc sn_sweal {
qui reg `y' `x' $controls, cluster(HHFE)
est store `y'_`x'
}
}
*
foreach y in $yvars {
esttab `y'_sn_size `y'_sn_dura `y'_sn_stre `y'_sn_sgende `y'_sn_scaste `y'_sn_sjatis `y'_sn_sage `y'_sn_sstat `y'_sn_socc `y'_sn_sedu `y'_sn_sloc `y'_sn_sweal using "`y'.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $coef) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
}	


***** Quali
global yvars dpbtorepay_indiv dhelpsettle_indiv dgrepa_indiv
foreach y in $yvars {
foreach x in sn_size sn_dura sn_stre sn_sgende sn_scaste sn_sjatis sn_sage sn_sstat sn_socc sn_sedu sn_sloc sn_sweal {
qui probit `y' `x' $controls, cluster(HHFE)
est store `y'_`x'
}
}
*
foreach y in $yvars {
esttab `y'_sn_size `y'_sn_dura `y'_sn_stre `y'_sn_sgende `y'_sn_scaste `y'_sn_sjatis `y'_sn_sage `y'_sn_sstat `y'_sn_socc `y'_sn_sedu `y'_sn_sloc `y'_sn_sweal using "`y'.csv", replace ///
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


***** Macro
global controls i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid

global coef 1.sex 2.sex age 1.caste 2.caste 3.caste 1.educ 2.educ 3.educ 4.educ 5.educ 6.educ 1.occupation 2.occupation 3.occupation 4.occupation 5.occupation 6.occupation 7.occupation assets_total annualincome_HH 1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid


***** Quanti
global yvars loanamount_indiv isr_indiv dsr_indiv isr_indiv
foreach y in $yvars {
foreach x in sn_size sn_dura sn_stre sn_sgende sn_scaste sn_sjatis sn_sage sn_sstat sn_socc sn_sedu sn_sloc sn_sweal {
qui reg `y' c.`x'##i.sex $controls, cluster(HHFE)
est store `y'_`x'
}
}
*
foreach y in $yvars {
esttab `y'_sn_size `y'_sn_dura `y'_sn_stre `y'_sn_sgende `y'_sn_scaste `y'_sn_sjatis `y'_sn_sage `y'_sn_sstat `y'_sn_socc `y'_sn_sedu `y'_sn_sloc `y'_sn_sweal using "`y'_gender.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $coef) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
}	


***** Quali
global yvars dpbtorepay_indiv dhelpsettle_indiv dgrepa_indiv
foreach y in $yvars {
foreach x in sn_size sn_dura sn_stre sn_sgende sn_scaste sn_sjatis sn_sage sn_sstat sn_socc sn_sedu sn_sloc sn_sweal {
qui probit `y' c.`x'##i.sex $controls, cluster(HHFE)
est store `y'_`x'
}
}
*
foreach y in $yvars {
esttab `y'_sn_size `y'_sn_dura `y'_sn_stre `y'_sn_sgende `y'_sn_scaste `y'_sn_sjatis `y'_sn_sage `y'_sn_sstat `y'_sn_socc `y'_sn_sedu `y'_sn_sloc `y'_sn_sweal using "`y'_gender.csv", replace ///
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


***** Macro
global controls i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid

global coef 1.sex 2.sex age 1.caste 2.caste 3.caste 1.educ 2.educ 3.educ 4.educ 5.educ 6.educ 1.occupation 2.occupation 3.occupation 4.occupation 5.occupation 6.occupation 7.occupation assets_total annualincome_HH 1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid


***** Quanti
global yvars loanamount_indiv isr_indiv dsr_indiv isr_indiv
foreach y in $yvars {
foreach x in sn_size sn_dura sn_stre sn_sgende sn_scaste sn_sjatis sn_sage sn_sstat sn_socc sn_sedu sn_sloc sn_sweal {
qui reg `y' c.`x'##i.caste $controls, cluster(HHFE)
est store `y'_`x'
}
}
*
foreach y in $yvars {
esttab `y'_sn_size `y'_sn_dura `y'_sn_stre `y'_sn_sgende `y'_sn_scaste `y'_sn_sjatis `y'_sn_sage `y'_sn_sstat `y'_sn_socc `y'_sn_sedu `y'_sn_sloc `y'_sn_sweal using "`y'_caste.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $coef) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
}	


***** Quali
global yvars dpbtorepay_indiv dhelpsettle_indiv dgrepa_indiv
foreach y in $yvars {
foreach x in sn_size sn_dura sn_stre sn_sgende sn_scaste sn_sjatis sn_sage sn_sstat sn_socc sn_sedu sn_sloc sn_sweal {
qui probit `y' c.`x'##i.caste $controls, cluster(HHFE)
est store `y'_`x'
}
}
*
foreach y in $yvars {
esttab `y'_sn_size `y'_sn_dura `y'_sn_stre `y'_sn_sgende `y'_sn_scaste `y'_sn_sjatis `y'_sn_sage `y'_sn_sstat `y'_sn_socc `y'_sn_sedu `y'_sn_sloc `y'_sn_sweal using "`y'_caste.csv", replace ///
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
* Analysis at HH level test 1
****************************************
use"Main_analyses_v5", clear

***** Selection
drop if nbloan_indiv==.
drop if nbloan_indiv==0


***** Macro
global controls i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid

global coef 1.sex 2.sex age 1.caste 2.caste 3.caste 1.educ 2.educ 3.educ 4.educ 5.educ 6.educ 1.occupation 2.occupation 3.occupation 4.occupation 5.occupation 6.occupation 7.occupation assets_total annualincome_HH 1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid


***** Quanti
global yvars loanamount_HH isr_HH dsr_HH isr_HH
foreach y in $yvars {
foreach x in sn_size sn_dura sn_stre sn_sgende sn_scaste sn_sjatis sn_sage sn_sstat sn_socc sn_sedu sn_sloc sn_sweal {
qui reg `y' `x' $controls, cluster(HHFE)
est store `y'_`x'
}
}
*
foreach y in $yvars {
esttab `y'_sn_size `y'_sn_dura `y'_sn_stre `y'_sn_sgende `y'_sn_scaste `y'_sn_sjatis `y'_sn_sage `y'_sn_sstat `y'_sn_socc `y'_sn_sedu `y'_sn_sloc `y'_sn_sweal using "`y'_HH.csv", replace ///
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












/*
****************************************
* Analysis at HH level test 2
****************************************
use"Main_analyses_v5", clear

***** Reshape
drop if nbloan_indiv==.
drop if nbloan_indiv==0

* 
keep HHID2020 INDID2020 relationshiptohead sn_size sn_dura sn_stre sn_sgende sn_scaste sn_sjatis
drop if relationshiptohead>2
drop INDID2020
reshape wide sn_size sn_dura sn_stre sn_sgende sn_scaste sn_sjatis, i(HHID2020) j(relationshiptohead)
ta sn_size1
ta sn_size2




***** Macro
global controls i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid

global coef 1.sex 2.sex age 1.caste 2.caste 3.caste 1.educ 2.educ 3.educ 4.educ 5.educ 6.educ 1.occupation 2.occupation 3.occupation 4.occupation 5.occupation 6.occupation 7.occupation assets_total annualincome_HH 1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid


***** Quanti
global yvars loanamount_HH isr_HH dsr_HH
foreach y in $yvars {
foreach x in sn_size sn_dura sn_stre sn_sgende sn_scaste sn_sjatis sn_sage sn_sstat sn_socc sn_sedu sn_sloc sn_sweal {
qui reg `y' `x' $controls, cluster(HHFE)
est store `y'_`x'
}
}
*
foreach y in $yvars {
esttab `y'_sn_size `y'_sn_dura `y'_sn_stre `y'_sn_sgende `y'_sn_scaste `y'_sn_sjatis `y'_sn_sage `y'_sn_sstat `y'_sn_socc `y'_sn_sedu `y'_sn_sloc `y'_sn_sweal using "`y'_HH.csv", replace ///
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
* Analysis at HH level test 3
****************************************
use"Main_analyses_v5", clear

***** Reshape
drop if nbloan_indiv==.
drop if nbloan_indiv==0

*
keep HHID2020 INDID2020 relationshiptohead sn_size sn_dura sn_stre sn_sgende sn_scaste sn_sjatis
bysort HHID2020: gen n=_n
drop INDID2020
reshape wide relationshiptohead sn_size sn_dura sn_stre sn_sgende sn_scaste sn_sjatis, i(HHID2020) j(n)
ta relationshiptohead1





***** Macro
global controls i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid

global coef 1.sex 2.sex age 1.caste 2.caste 3.caste 1.educ 2.educ 3.educ 4.educ 5.educ 6.educ 1.occupation 2.occupation 3.occupation 4.occupation 5.occupation 6.occupation 7.occupation assets_total annualincome_HH 1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid


***** Quanti
global yvars loanamount_HH isr_HH dsr_HH
foreach y in $yvars {
foreach x in sn_size sn_dura sn_stre sn_sgende sn_scaste sn_sjatis sn_sage sn_sstat sn_socc sn_sedu sn_sloc sn_sweal {
qui reg `y' `x' $controls, cluster(HHFE)
est store `y'_`x'
}
}
*
foreach y in $yvars {
esttab `y'_sn_size `y'_sn_dura `y'_sn_stre `y'_sn_sgende `y'_sn_scaste `y'_sn_sjatis `y'_sn_sage `y'_sn_sstat `y'_sn_socc `y'_sn_sedu `y'_sn_sloc `y'_sn_sweal using "`y'_HH.csv", replace ///
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



