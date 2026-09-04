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
* Sensitivity
****************************************
use"Analysesloan_v2", clear


***** Vars
fre lender4
gen lender5=lender4
recode lender5 (5=4) (6=4) (8=4)
label define lender5 1"Lender: WKP" 2"Lender: Relatives" 3"Lender: Labour" 4"Lender: Other" 7"Lender: Friends"
label values lender5 lender5
ta lender4 lender5
*
bys HHID2020 INDID2020: egen loanamount_indiv=sum(loanamount)
gen iv_indiv=loanamount_indiv-loanamount
bys HHID2020: egen loanamount_hh=sum(loanamount)
gen iv_hh=loanamount_hh-loanamount
*
bys HHID2020 INDID2020: egen loan_indiv=sum(1)
gen iv_indiv2=loan_indiv-1
bys HHID2020: egen loan_hh=sum(1)
gen iv_hh2=loan_hh-1

***** With (baseline)
global controlswith i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid loanamount i.loanreasongiven c.loanduration_month i.married c.HHsize i.covidexpo
*
qui probit dummyinterest ///
i.samecaste i.samesex i.sameoccup i.samevillage i.dummymultipleloan c.snduration i.invite_reciprocity i.sndummyfam i.snfriend i.snlabourrelation ///
$controlswith, cluster(hhindiv)
est store withl


***** Without loan amout
global controlswithout i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid i.loanreasongiven c.loanduration_month i.married c.HHsize i.covidexpo
*
qui probit dummyinterest ///
i.samecaste i.samesex i.sameoccup i.samevillage i.dummymultipleloan c.snduration i.invite_reciprocity i.sndummyfam i.snfriend i.snlabourrelation ///
$controlswithout, cluster(hhindiv)
est store withoutl

***** Lenders
ivreg2 dummyinterest ///
i.samecaste i.samesex i.sameoccup i.samevillage i.dummymultipleloan c.snduration i.invite_reciprocity i.sndummyfam i.snfriend i.snlabourrelation ///
i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid i.loanreasongiven c.loanduration_month i.married c.HHsize i.covidexpo (c.loanamount=i.lender5), cluster(hhindiv)
est store lenders

***** HH
ivreg2 dummyinterest ///
i.samecaste i.samesex i.sameoccup i.samevillage i.dummymultipleloan c.snduration i.invite_reciprocity i.sndummyfam i.snfriend i.snlabourrelation ///
i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid i.loanreasongiven c.loanduration_month i.married c.HHsize i.covidexpo (c.loanamount=c.iv_hh), cluster(hhindiv)
est store hh

***** Indiv
ivreg2 dummyinterest ///
i.samecaste i.samesex i.sameoccup i.samevillage i.dummymultipleloan c.snduration i.invite_reciprocity i.sndummyfam i.snfriend i.snlabourrelation ///
i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid i.loanreasongiven c.loanduration_month i.married c.HHsize i.covidexpo (c.loanamount=c.iv_indiv), cluster(hhindiv)
est store indiv


***** HH2
ivreg2 dummyinterest ///
i.samecaste i.samesex i.sameoccup i.samevillage i.dummymultipleloan c.snduration i.invite_reciprocity i.sndummyfam i.snfriend i.snlabourrelation ///
i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid i.loanreasongiven c.loanduration_month i.married c.HHsize i.covidexpo (c.loanamount=c.iv_hh2), cluster(hhindiv)
est store hh2

***** Indiv2
ivreg2 dummyinterest ///
i.samecaste i.samesex i.sameoccup i.samevillage i.dummymultipleloan c.snduration i.invite_reciprocity i.sndummyfam i.snfriend i.snlabourrelation ///
i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid i.loanreasongiven c.loanduration_month i.married c.HHsize i.covidexpo (c.loanamount=c.iv_indiv2), cluster(hhindiv)
est store indiv2

***** Table reg
esttab ///
withl withoutl lenders hh indiv hh2 indiv2 ///
using "Interest-sensitivity.csv", replace ///
	b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $coef) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END






