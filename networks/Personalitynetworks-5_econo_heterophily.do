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
use"Analysis/Main_analyses_v6", clear

* Durée nette de l'age
foreach y in duration debt_duration relative_duration talk_duration labour_duration {
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


****************************************
* END












****************************************
* One step heterophily for pooled sample
****************************************

foreach y in caste jatis gender location {

qui glm diff`y' $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg1`y'
qui margins, dydx($perso) atmeans post
est store marg1`y'

qui glm diff`y' $persoXsex $cont, family(binomial) link(probit) cluster(HHFE)
est store reg2`y'
qui margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

qui glm diff`y' $persoXcaste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg3`y'
qui margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

qui glm diff`y' $persoXsexXcaste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg4`y'
qui margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

/*
esttab reg1`y' reg2`y' reg3`y' reg4`y' using "`y'`var'_frac.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
*/

esttab marg1`y' marg2`y' marg3`y' marg4`y' using "diff`y'_frac_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		
}

****************************************
* END













****************************************
* Two step heterophily for pooled sample
****************************************

foreach y in caste gender jatis location {

********** Step 1: Probit
qui probit ddiff`y' $perso i.female i.caste $cont, vce(cl HHFE)
est store reg1`y'
qui margins, dydx($perso) atmeans post
est store marg1`y'

qui probit ddiff`y' $persoXsex $cont, vce(cl HHFE)
est store reg2`y'
qui margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

qui probit ddiff`y' $persoXcaste $cont, vce(cl HHFE)
est store reg3`y'
qui margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

qui probit ddiff`y' $persoXsexXcaste $cont, vce(cl HHFE)
est store reg4`y'
qui margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

/*
esttab reg1`y' reg2`y' reg3`y' reg4`y' using "`y'`var'_probit.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
*/

esttab marg1`y' marg2`y' marg3`y' marg4`y' using "ddiff`y'_probit_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		
}



********** Step 2: GLM
foreach y in caste gender jatis location {

preserve
keep if ddiff`y'==1

qui glm diff`y' $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg1`y'
qui margins, dydx($perso) atmeans post
est store marg1`y'

qui glm diff`y' $persoXsex $cont, family(binomial) link(probit) cluster(HHFE)
est store reg2`y'
qui margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

qui glm diff`y' $persoXcaste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg3`y'
qui margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

qui glm diff`y' $persoXsexXcaste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg4`y'
qui margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

/*
esttab reg1`y' reg2`y' reg3`y' reg4`y' using "`y'_diff`var'_glm.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
*/

esttab marg1`y' marg2`y' marg3`y' marg4`y' using "diff`y'_glm_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		
restore
}

****************************************
* END

















****************************************
* One step heterophily for sub generators
****************************************

foreach var in caste gender jatis location {

foreach y in debt_diff talk_diff relative_diff labour_diff {

qui glm `y'`var' $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg1`y'
qui margins, dydx($perso) atmeans post
est store marg1`y'

qui glm `y'`var' $persoXsex $cont, family(binomial) link(probit) cluster(HHFE)
est store reg2`y'
qui margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

qui glm `y'`var' $persoXcaste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg3`y'
qui margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

qui glm `y'`var' $persoXsexXcaste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg4`y'
qui margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

/*
esttab reg1`y' reg2`y' reg3`y' reg4`y' using "`y'`var'_frac.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
*/

esttab marg1`y' marg2`y' marg3`y' marg4`y' using "`y'`var'_frac_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		
}
}

****************************************
* END












****************************************
* Two step heterophily for sub generators
****************************************

foreach var in caste gender jatis location {

********** Step 1: Probit
foreach y in debt_ddiff talk_ddiff relative_ddiff {

qui probit `y'`var' $perso i.female i.caste $cont, vce(cl HHFE)
est store reg1`y'
qui margins, dydx($perso) atmeans post
est store marg1`y'

qui probit `y'`var' $persoXsex $cont, vce(cl HHFE)
est store reg2`y'
qui margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

qui probit `y'`var' $persoXcaste $cont, vce(cl HHFE)
est store reg3`y'
qui margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

qui probit `y'`var' $persoXsexXcaste $cont, vce(cl HHFE)
est store reg4`y'
qui margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

/*
esttab reg1`y' reg2`y' reg3`y' reg4`y' using "`y'`var'_probit.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
*/

esttab marg1`y' marg2`y' marg3`y' marg4`y' using "`y'`var'_probit_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		
}



********** Step 2: GLM
foreach y in debt talk relative {

preserve
keep if `y'_ddiff`var'==1

qui glm `y'_diff`var' $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg1`y'
qui margins, dydx($perso) atmeans post
est store marg1`y'

qui glm `y'_diff`var' $persoXsex $cont, family(binomial) link(probit) cluster(HHFE)
est store reg2`y'
qui margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

qui glm `y'_diff`var' $persoXcaste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg3`y'
qui margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

qui glm `y'_diff`var' $persoXsexXcaste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg4`y'
qui margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

/*
esttab reg1`y' reg2`y' reg3`y' reg4`y' using "`y'_diff`var'_glm.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
*/

esttab marg1`y' marg2`y' marg3`y' marg4`y' using "`y'_diff`var'_glm_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		
restore
}
}
	
****************************************
* END



