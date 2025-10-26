*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*September 2, 2025
*-----
gl link = "debtnetworks"
*Econo at loan level
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\debtnetworks.do"
*-------------------------

*cd"C:\Users\anatal\Documents\Ongoing_Networks_debt\Analysis"




****************************************
* Analysis at loan level sans interactions
****************************************
use"Analysesloan_v2", clear


***** Controls
global controls i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid loanamount i.loanreasongiven c.loanduration_month i.married c.HHsize i.covidexpo

global coef 1.sex 2.sex age 1.caste 2.caste 1.educ 2.educ 3.educ 4.educ 5.educ 6.educ 1.occupation 2.occupation 3.occupation 4.occupation 5.occupation 6.occupation 7.occupation assets_total annualincome_HH 1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid loanamount 1.loanreasongiven 2.loanreasongiven 3.loanreasongiven 4.loanreasongiven 5.loanreasongiven 6.loanreasongiven 7.loanreasongiven 8.loanreasongiven 9.loanreasongiven 10.loanreasongiven 11.loanreasongiven 77.loanreasongiven 0.married 1.married HHsize

global mainX samecaste samesex sameoccup samevillage dummymultipleloan snduration invite_reciprocity sndummyfam snfriend snlabourrelation


***** Quali
foreach y in dummyinterest dummyguarantee dummylenderservices dummymainloan dummyproblemtorepay dummyborrowerservice {

* No int
qui probit `y' ///
i.samecaste i.samesex i.sameoccup i.samevillage i.dummymultipleloan c.snduration i.invite_reciprocity i.sndummyfam i.snfriend i.snlabourrelation ///
$controls, cluster(hhindiv)
est store `y'
margins, dydx($mainX) atmeans post
est store marg1`y'

* Gender
qui probit `y' ///
i.samecaste##i.sex i.samesex##i.sex i.sameoccup##i.sex i.samevillage##i.sex i.dummymultipleloan##i.sex c.snduration##i.sex i.invite_reciprocity##i.sex i.sndummyfam##i.sex i.snfriend##i.sex i.snlabourrelation##i.sex ///
$controls, cluster(hhindiv)
est store `y'_g
margins, dydx($mainX) at(sex=(1 2)) atmeans post
est store marg2`y'

* Caste
qui probit `y' ///
i.samecaste##i.caste i.samesex##i.caste i.sameoccup##i.caste i.samevillage##i.caste i.dummymultipleloan##i.caste c.snduration##i.caste i.invite_reciprocity##i.caste i.sndummyfam##i.caste i.snfriend##i.caste i.snlabourrelation##i.caste ///
$controls, cluster(hhindiv)
est store `y'_c
margins, dydx($mainX) at(caste=(1 2)) atmeans post
est store marg3`y'
}



***** Table reg
esttab ///
dummyinterest dummyinterest_g dummyinterest_c ///
dummyguarantee dummyguarantee_g dummyguarantee_c ///
dummylenderservices dummylenderservices_g dummylenderservices_c ///
dummymainloan dummymainloan_g dummymainloan_c ///
dummyproblemtorepay dummyproblemtorepay_g dummyproblemtorepay_c ///
dummyborrowerservice dummyborrowerservice_g dummyborrowerservice_c ///
using "Loanlevel.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $coef) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

	
***** Table margins
*** 1: No int
esttab ///
marg1dummyinterest marg1dummyguarantee marg1dummylenderservices marg1dummymainloan marg1dummyproblemtorepay marg1dummyborrowerservice ///
using "marg_all_noint.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop(0.samecaste 0.samesex 0.dummymultipleloan 0.sameoccup 0.samevillage 0.sndummyfam 0.snfriend 0.snlabourrelation) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace

*** 2: Gender
esttab ///
marg2dummyinterest marg2dummyguarantee marg2dummylenderservices marg2dummymainloan marg2dummyproblemtorepay marg2dummyborrowerservice ///
using "marg_all_gender.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace


*** 3: Caste	
esttab ///
marg3dummyinterest marg3dummyguarantee marg3dummylenderservices marg3dummymainloan marg3dummyproblemtorepay marg3dummyborrowerservice ///
using "marg_all_caste.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace
	
****************************************
* END





















****************************************
* Contribution R2
****************************************
use"Analysesloan_v2", clear


***** Controls
global controls i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid loanamount i.loanreasongiven c.loanduration_month i.married c.HHsize i.covidexpo

***** Without lenders-
foreach y in dummyinterest dummyguarantee dummylenderservices dummymainloan dummyproblemtorepay dummyborrowerservice {
probit `y' ///
$controls, cluster(hhindiv)
est store `y'_wo
}


***** With lenders-
foreach y in dummyinterest dummyguarantee dummylenderservices dummymainloan dummyproblemtorepay dummyborrowerservice {
probit `y' ///
i.samecaste i.samesex i.sameoccup i.samevillage i.dummymultipleloan c.snduration i.invite_reciprocity i.sndummyfam i.snfriend i.snlabourrelation ///
$controls, cluster(hhindiv)
est store `y'_wi
}



***** Table
esttab ///
dummyinterest_wo dummyinterest_wi ///
dummyguarantee_wo dummyguarantee_wi ///
dummylenderservices_wo dummylenderservices_wi ///
dummymainloan_wo dummymainloan_wi ///
dummyproblemtorepay_wo dummyproblemtorepay_wi ///
dummyborrowerservice_wo dummyborrowerservice_wi ///
using "EvoRsq.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	keep(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N r2_p, fmt(0 2) ///
	labels(`"Observations"' `"Pseudo R-squared"'))


****************************************
* END


















/*
****************************************
* Shapley decomposition
****************************************
use"Analysesloan_v2", clear

*
fre samecaste
recode samecaste (2=0)
fre samecaste

*
fre caste
recode caste (3=2)
fre caste

***** Controls
foreach x in sex caste educ occupation villageid loanreasongiven {
ta `x', gen(`x'_)
}


global controls age assets_total annualincome_HH loanamount sex_1 sex_2 caste_1 caste_2 educ_1 educ_2 educ_3 educ_4 educ_5 educ_6 occupation_1 occupation_2 occupation_3 occupation_4 occupation_5 occupation_6 occupation_7 occupation_8 villageid_1 villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 loanreasongiven_1 loanreasongiven_2 loanreasongiven_3 loanreasongiven_4 loanreasongiven_5 loanreasongiven_6 loanreasongiven_7 loanreasongiven_8 loanreasongiven_9 loanreasongiven_10 loanreasongiven_11 loanreasongiven_12


*****
probit dummyinterest ///
samecaste samesex dummymultipleloan duration_cat sameoccup samevillage sndummyfam snfriend snlabourrelation ///
$controls, cluster(hhindiv)
shapley2, stat(r2_p) force

reg dummyinterest ///
samecaste samesex dummymultipleloan duration_cat sameoccup samevillage sndummyfam snfriend snlabourrelation ///
$controls, cluster(hhindiv)
shapley2, stat(r2) force


probit dummyproblemtorepay ///
i.samecaste i.samesex i.dummymultipleloan c.duration_cat i.sameoccup i.samevillage i.sndummyfam i.snfriend i.snlabourrelation ///
$controls, cluster(hhindiv)

probit dummylenderservices ///
i.samecaste i.samesex i.dummymultipleloan c.duration_cat i.sameoccup i.samevillage i.sndummyfam i.snfriend i.snlabourrelation ///
$controls, cluster(hhindiv)





****************************************
* END

