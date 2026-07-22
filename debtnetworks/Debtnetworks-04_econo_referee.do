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






****************************************
* With / without loan amount
****************************************
use"Analysesloan_v2", clear


***** Controls
global mainX samecaste samesex sameoccup samevillage dummymultipleloan snduration invite_reciprocity sndummyfam snfriend snlabourrelation


********** With loan amount
global controlswith i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid loanamount i.loanreasongiven c.loanduration_month i.married c.HHsize i.covidexpo

* No int
qui probit dummyinterest ///
i.samecaste i.samesex i.sameoccup i.samevillage i.dummymultipleloan c.snduration i.invite_reciprocity i.sndummyfam i.snfriend i.snlabourrelation ///
$controlswith, cluster(hhindiv)
est store with_n
qui margins, dydx($mainX) atmeans post
est store with_n_marg

* Gender
qui probit dummyinterest ///
i.samecaste##i.sex i.samesex##i.sex i.sameoccup##i.sex i.samevillage##i.sex i.dummymultipleloan##i.sex c.snduration##i.sex i.invite_reciprocity##i.sex i.sndummyfam##i.sex i.snfriend##i.sex i.snlabourrelation##i.sex ///
$controlswith, cluster(hhindiv)
est store with_g
qui margins, dydx($mainX) at(sex=(1 2)) atmeans post
est store with_g_marg

* Caste
probit dummyinterest ///
i.samecaste##ib(2).caste i.samesex##ib(2).caste i.sameoccup##ib(2).caste i.samevillage##ib(2).caste i.dummymultipleloan##ib(2).caste c.snduration##ib(2).caste i.invite_reciprocity##ib(2).caste i.sndummyfam##ib(2).caste i.snfriend##ib(2).caste i.snlabourrelation##ib(2).caste ///
$controlswith, cluster(hhindiv)
est store with_c
qui margins, dydx($mainX) at(caste=(1 2)) atmeans post
est store with_c_marg


********** Without loan amount
global controlswithout i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid i.loanreasongiven c.loanduration_month i.married c.HHsize i.covidexpo

* No int
qui probit dummyinterest ///
i.samecaste i.samesex i.sameoccup i.samevillage i.dummymultipleloan c.snduration i.invite_reciprocity i.sndummyfam i.snfriend i.snlabourrelation ///
$controlswithout, cluster(hhindiv)
est store without_n
qui margins, dydx($mainX) atmeans post
est store without_n_marg

* Gender
qui probit dummyinterest ///
i.samecaste##i.sex i.samesex##i.sex i.sameoccup##i.sex i.samevillage##i.sex i.dummymultipleloan##i.sex c.snduration##i.sex i.invite_reciprocity##i.sex i.sndummyfam##i.sex i.snfriend##i.sex i.snlabourrelation##i.sex ///
$controlswithout, cluster(hhindiv)
est store without_g
qui margins, dydx($mainX) at(sex=(1 2)) atmeans post
est store without_g_marg

* Caste
probit dummyinterest ///
i.samecaste##ib(2).caste i.samesex##ib(2).caste i.sameoccup##ib(2).caste i.samevillage##ib(2).caste i.dummymultipleloan##ib(2).caste c.snduration##ib(2).caste i.invite_reciprocity##ib(2).caste i.sndummyfam##ib(2).caste i.snfriend##ib(2).caste i.snlabourrelation##ib(2).caste ///
$controlswithout, cluster(hhindiv)
est store without_c
qui margins, dydx($mainX) at(caste=(1 2)) atmeans post
est store without_c_marg


***** Table reg
esttab ///
without_n with_n ///
without_g with_g ///
without_c with_c ///
using "Interest-without_with.csv", replace ///
	b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $coef) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
	
	
***** Table margins
*** 1: No int
esttab ///
without_n_marg with_n_marg ///
using "marg_int_noint.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop(0.samecaste 0.samesex 0.dummymultipleloan 0.sameoccup 0.samevillage 0.sndummyfam 0.snfriend 0.snlabourrelation) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace

*** 2: Gender
esttab ///
without_g_marg with_g_marg ///
using "marg_int_gender.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace


*** 3: Caste	
esttab ///
without_c_marg with_c_marg ///
using "marg_int_caste.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace
	
	
****************************************
* END



















****************************************
* 2SLS
****************************************
use"Analysesloan_v2", clear


***** Controls
global mainX samecaste samesex sameoccup samevillage dummymultipleloan snduration invite_reciprocity sndummyfam snfriend snlabourrelation


********** Without loan amount but with lender
fre lender4
gen lender5=lender4
recode lender5 (5=4) (6=4) (8=4)
label define lender5 1"Lender: WKP" 2"Lender: Relatives" 3"Lender: Labour" 4"Lender: Other" 7"Lender: Friends"
label values lender5 lender5
ta lender4 lender5

global controlsalt i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid i.lender5 i.loanreasongiven c.loanduration_month i.married c.HHsize i.covidexpo

* No int
ivregress 2sls dummyinterest ///
i.samecaste i.samesex i.sameoccup i.samevillage i.dummymultipleloan c.snduration i.invite_reciprocity i.sndummyfam i.snfriend i.snlabourrelation ///
i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid i.loanreasongiven c.loanduration_month i.married c.HHsize i.covidexpo (c.loanamount=i.lender5), cluster(hhindiv) first
est store withoutalt_n
qui margins, dydx($mainX) atmeans post
est store withoutalt_n_marg

* Other command to obtain complementary statistics
ivreg2 dummyinterest ///
i.samecaste i.samesex i.sameoccup i.samevillage i.dummymultipleloan c.snduration i.invite_reciprocity i.sndummyfam i.snfriend i.snlabourrelation ///
i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid i.loanreasongiven c.loanduration_month i.married c.HHsize i.covidexpo (c.loanamount=i.lender5), cluster(hhindiv)
est store withoutalt_n
qui margins, dydx($mainX) atmeans post
est store withoutalt_n_marg


* Gender
ivregress 2sls dummyinterest ///
i.samecaste##i.sex i.samesex##i.sex i.sameoccup##i.sex i.samevillage##i.sex i.dummymultipleloan##i.sex c.snduration##i.sex i.invite_reciprocity##i.sex i.sndummyfam##i.sex i.snfriend##i.sex i.snlabourrelation##i.sex ///
i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid i.loanreasongiven c.loanduration_month i.married c.HHsize i.covidexpo (c.loanamount=i.lender5), cluster(hhindiv)
est store withoutalt_g
qui margins, dydx($mainX) at(sex=(1 2)) atmeans post
est store withoutalt_g_marg

* Caste
ivregress 2sls dummyinterest ///
i.samecaste##ib(2).caste i.samesex##ib(2).caste i.sameoccup##ib(2).caste i.samevillage##ib(2).caste i.dummymultipleloan##ib(2).caste c.snduration##ib(2).caste i.invite_reciprocity##ib(2).caste i.sndummyfam##ib(2).caste i.snfriend##ib(2).caste i.snlabourrelation##ib(2).caste ///
i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid i.loanreasongiven c.loanduration_month i.married c.HHsize i.covidexpo (c.loanamount=i.lender5), cluster(hhindiv)
est store withoutalt_c
qui margins, dydx($mainX) at(caste=(1 2)) atmeans post
est store withoutalt_c_marg



***** Table reg
esttab ///
withoutalt_n ///
withoutalt_g ///
withoutalt_c ///
using "Interest-withoutalt.csv", replace ///
	b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $coef) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
	
	
***** Table margins
*** 1: No int
esttab ///
withoutalt_n_marg ///
using "marg_intalt_noint.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop(0.samecaste 0.samesex 0.dummymultipleloan 0.sameoccup 0.samevillage 0.sndummyfam 0.snfriend 0.snlabourrelation) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace

*** 2: Gender
esttab ///
withoutalt_g_marg ///
using "marg_intalt_gender.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace


*** 3: Caste	
esttab ///
withoutalt_c_marg ///
using "marg_intalt_caste.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace


****************************************
* END






