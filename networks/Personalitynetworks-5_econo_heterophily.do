*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*January 8, 2025
*-----
gl link = "networks"
*Correction base alters et bases couples
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\networks.do"
*-------------------------








****************************************
* Macro
****************************************
use"Analysis/Main_analyses_v3", clear

* Durée nette de l'age
foreach y in debt_duration relative_duration talk_duration {
reg `y' age
predict `y'_afe, res
egen `y'_afe_std=std(`y'_afe)
drop `y'_afe
rename `y'_afe_std `y'_afe
}



* Controls
global cont c.age i.married i.occupation i.educ i.villageid c.stdincome c.stdassets
global contdrop age *occupation *educ *villageid *married stdincome stdassets

global perso fES fOPEX fCO locus
global persoXsex c.fES##i.female c.fOPEX##i.female c.fCO##i.female c.locus##i.female
global persoXcaste c.fES##i.caste c.fOPEX##i.caste c.fCO##i.caste c.locus##i.caste
global persoXsexXcaste c.fES##i.female##i.caste c.fOPEX##i.female##i.caste c.fCO##i.female##i.caste c.locus##i.female##i.caste


/*
tabstat age annualincome_HH assets_total, stat(n mean) by(sex)
tabstat age annualincome_HH assets_total, stat(n mean) by(caste)

*
foreach x in married occupation educ {
ta `x' sex, col nofreq
}
*
foreach x in married occupation educ {
ta `x' caste, col nofreq
}
*/
****************************************
* END





/*
****************************************
* Evo R-squared
****************************************

********** Debt
***** Debt, step 1
foreach var in caste gender {
* Without
probit dum_debt_EI_`var' i.female i.caste $cont c.netsize_debt, vce(cl HHFE)
est store s1without_debt_`var'
* With
probit dum_debt_EI_`var' $perso i.female i.caste $cont c.netsize_debt, vce(cl HHFE)
est store s1with_debt_`var'
}

***** Debt, step 2
foreach var in caste gender {
preserve
keep if dum_debt_EI_`var'==1
* Without
reg debt_EI_`var' i.female i.caste $cont c.netsize_debt, cluster(HHFE)
est store s2without_debt_`var'
* With
reg debt_EI_`var' $perso i.female i.caste $cont c.netsize_debt, cluster(HHFE)
est store s2with_debt_`var'
restore
}


********** Talk
***** Talk, step 1
foreach var in caste gender {
* Without
probit dum_talk_EI_`var' i.female i.caste $cont c.netsize_talk, vce(cl HHFE)
est store s1without_talk_`var'
* With
probit dum_talk_EI_`var' $perso i.female i.caste $cont c.netsize_talk, vce(cl HHFE)
est store s1with_talk_`var'
}

***** Talk, step 2
foreach var in caste gender {
preserve
keep if dum_talk_EI_`var'==1
* Without
reg talk_EI_`var' i.female i.caste $cont c.netsize_talk, cluster(HHFE)
est store s2without_talk_`var'
* With
reg talk_EI_`var' $perso i.female i.caste $cont c.netsize_talk, cluster(HHFE)
est store s2with_talk_`var'
restore
}


********** Relative
***** Relative, step 1
foreach var in caste gender {
* Without
probit dum_relative_EI_`var' i.female i.caste $cont c.netsize_relative, vce(cl HHFE)
est store s1without_relative_`var'
* With
probit dum_relative_EI_`var' $perso i.female i.caste $cont c.netsize_relative, vce(cl HHFE)
est store s1with_relative_`var'
}

***** Relative, step 2
foreach var in caste gender {
preserve
keep if dum_relative_EI_`var'==1
* Without
reg relative_EI_`var' i.female i.caste $cont c.netsize_relative, cluster(HHFE)
est store s2without_relative_`var'
* With
reg relative_EI_`var' $perso i.female i.caste $cont c.netsize_relative, cluster(HHFE)
est store s2with_relative_`var'
restore
}



********** Table probit
esttab ///
s1without_debt_caste 		s1with_debt_caste ///
s1without_debt_gender 		s1with_debt_gender ///
s1without_talk_caste 		s1with_talk_caste ///
s1without_talk_gender 		s1with_talk_gender ///
s1without_relative_caste 	s1with_relative_caste ///
s1without_relative_gender 	s1with_relative_gender ///
using "pseudoR2_hetero_s1.csv", ///
	stats(N r2_p, fmt(0 2) ///
	labels(`"Observations"' `"Pseudo R-squared"')) replace

esttab ///
s2without_debt_caste 		s2with_debt_caste ///
s2without_debt_gender 		s2with_debt_gender ///
s2without_talk_caste 		s2with_talk_caste ///
s2without_talk_gender 		s2with_talk_gender ///
s2without_relative_caste 	s2with_relative_caste ///
s2without_relative_gender 	s2with_relative_gender ///
using "pseudoR2_hetero_s2.csv", ///
	stats(N r2_a, fmt(0 2) ///
	labels(`"Observations"' `"Adj R2-squared"')) replace

****************************************
* END
*/
















****************************************
* Two step heterophily for debt
****************************************

foreach var in caste gender {


********** Step 1: Probit
foreach y in dum_debt_EI {

probit `y'_`var' $perso i.female i.caste $cont c.netsize_debt, vce(cl HHFE)
est store reg1`y'
qui margins, dydx($perso) atmeans post
est store marg1`y'

qui probit `y'_`var' $persoXsex $cont c.netsize_debt, vce(cl HHFE)
est store reg2`y'
qui margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

qui probit `y'_`var' $persoXcaste $cont c.netsize_debt, vce(cl HHFE)
est store reg3`y'
qui margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

qui probit `y'_`var' $persoXsexXcaste $cont c.netsize_debt, vce(cl HHFE)
est store reg4`y'
qui margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

esttab marg1`y' marg2`y' marg3`y' marg4`y' using "`y'`var'_pr.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		

esttab reg1`y' reg2`y' reg3`y' reg4`y' using "R_`y'`var'_pr.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	replace	
}



********** Step 2: OLS
foreach y in debt {

preserve
keep if dum_`y'_EI_`var'==1

reg `y'_EI_`var' $perso i.female i.caste $cont c.netsize_debt, cluster(HHFE)
est store reg1`y'
qui margins, dydx($perso) atmeans post
est store marg1`y'

qui reg `y'_EI_`var' $persoXsex $cont c.netsize_debt, cluster(HHFE)
est store reg2`y'
qui margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

qui reg `y'_EI_`var' $persoXcaste $cont c.netsize_debt, cluster(HHFE)
est store reg3`y'
qui margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

qui reg `y'_EI_`var' $persoXsexXcaste $cont c.netsize_debt, cluster(HHFE)
est store reg4`y'
qui margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

esttab marg1`y' marg2`y' marg3`y' marg4`y' using "`y'`var'_ol.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace
esttab reg1`y' reg2`y' reg3`y' reg4`y' using "R_`y'`var'_ol.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	replace		
restore
}
}
	
****************************************
* END



















****************************************
* Two step heterophily for talk
****************************************

foreach var in caste gender  {

********** Step 1: Probit
foreach y in dum_talk_EI {

probit `y'_`var' $perso i.female i.caste $cont c.netsize_talk, vce(cl HHFE)
est store reg1`y'
qui margins, dydx($perso) atmeans post
est store marg1`y'

qui probit `y'_`var' $persoXsex $cont c.netsize_talk, vce(cl HHFE)
est store reg2`y'
qui margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

qui probit `y'_`var' $persoXcaste $cont c.netsize_talk, vce(cl HHFE)
est store reg3`y'
qui margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

qui probit `y'_`var' $persoXsexXcaste $cont c.netsize_talk, vce(cl HHFE)
est store reg4`y'
qui margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'


esttab marg1`y' marg2`y' marg3`y' marg4`y' using "`y'`var'_pr.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace
esttab reg1`y' reg2`y' reg3`y' reg4`y' using "R_`y'`var'_pr.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	replace	
}



********** Step 2: OLS
foreach y in talk {

preserve
keep if dum_`y'_EI_`var'==1

reg `y'_EI_`var' $perso i.female i.caste $cont c.netsize_talk, cluster(HHFE)
est store reg1`y'
qui margins, dydx($perso) atmeans post
est store marg1`y'

qui reg `y'_EI_`var' $persoXsex $cont c.netsize_talk, cluster(HHFE)
est store reg2`y'
qui margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

qui reg `y'_EI_`var' $persoXcaste $cont c.netsize_talk, cluster(HHFE)
est store reg3`y'
qui margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

qui reg `y'_EI_`var' $persoXsexXcaste $cont c.netsize_talk, cluster(HHFE)
est store reg4`y'
qui margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

esttab marg1`y' marg2`y' marg3`y' marg4`y' using "`y'`var'_ol.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace
esttab reg1`y' reg2`y' reg3`y' reg4`y' using "R_`y'`var'_ol.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	replace		
restore
}
}
	
****************************************
* END
















****************************************
* Two step heterophily for relative
****************************************

foreach var in caste gender {

********** Step 1: Probit
foreach y in dum_relative_EI {

probit `y'_`var' $perso i.female i.caste $cont c.netsize_relative, vce(cl HHFE)
est store reg1`y'
qui margins, dydx($perso) atmeans post
est store marg1`y'

qui probit `y'_`var' $persoXsex $cont c.netsize_relative, vce(cl HHFE)
est store reg2`y'
qui margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

qui probit `y'_`var' $persoXcaste $cont c.netsize_relative, vce(cl HHFE)
est store reg3`y'
qui margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

qui probit `y'_`var' $persoXsexXcaste $cont c.netsize_relative, vce(cl HHFE)
est store reg4`y'
qui margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'


esttab marg1`y' marg2`y' marg3`y' marg4`y' using "`y'`var'_pr.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace
esttab reg1`y' reg2`y' reg3`y' reg4`y' using "R_`y'`var'_pr.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	replace		
}



********** Step 2: OLS
foreach y in relative {

preserve
keep if dum_`y'_EI_`var'==1

reg `y'_EI_`var' $perso i.female i.caste $cont c.netsize_relative, cluster(HHFE)
est store reg1`y'
qui margins, dydx($perso) atmeans post
est store marg1`y'

qui reg `y'_EI_`var' $persoXsex $cont c.netsize_relative, cluster(HHFE)
est store reg2`y'
qui margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

qui reg `y'_EI_`var' $persoXcaste $cont c.netsize_relative, cluster(HHFE)
est store reg3`y'
qui margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

qui reg `y'_EI_`var' $persoXsexXcaste $cont c.netsize_relative, cluster(HHFE)
est store reg4`y'
qui margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

esttab marg1`y' marg2`y' marg3`y' marg4`y' using "`y'`var'_ol.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace
esttab reg1`y' reg2`y' reg3`y' reg4`y' using "R_`y'`var'_ol.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	replace		
restore
}
}
	
****************************************
* END




