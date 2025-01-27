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
reg talk_duration age
predict talk_duration_afe, res

reg debt_duration age
predict debt_duration_afe, res


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
* Reg retenus
****************************************


********** Force 1 (mca)
foreach y in strength_debt strength_talk {

glm `y' $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg1`y'
margins, dydx($perso) atmeans post
est store marg1`y'

glm `y' $persoXsex $cont, family(binomial) link(probit) cluster(HHFE)
est store reg2`y'
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

glm `y' $persoXcaste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg3`y'
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

glm `y' $persoXsexXcaste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg4`y'
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

esttab reg1`y' reg2`y' reg3`y' reg4`y' using "`y'_glm.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1`y' marg2`y' marg3`y' marg4`y' using "`y'_glm_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		

}





********** Force 2 (duration)
foreach y in debt_duration_afe talk_duration_afe {

reg `y' $perso i.female i.caste $cont, cluster(HHFE)
est store reg1`y'
margins, dydx($perso) atmeans post
est store marg1`y'

reg `y' $persoXsex $cont, cluster(HHFE)
est store reg2`y'
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

reg `y' $persoXcaste $cont, cluster(HHFE)
est store reg3`y'
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

reg `y' $persoXsexXcaste $cont, cluster(HHFE)
est store reg4`y'
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

esttab reg1`y' reg2`y' reg3`y' reg4`y' using "`y'_reg.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1`y' marg2`y' marg3`y' marg4`y' using "`y'_reg_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		

}













********** Homophily en une étape
foreach var in caste gender location {

foreach y in debt_diff talk_diff {

glm `y'`var' $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg1`y'
margins, dydx($perso) atmeans post
est store marg1`y'

glm `y'`var' $persoXsex $cont, family(binomial) link(probit) cluster(HHFE)
est store reg2`y'
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

glm `y'`var' $persoXcaste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg3`y'
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

glm `y'`var' $persoXsexXcaste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg4`y'
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

esttab reg1`y' reg2`y' reg3`y' reg4`y' using "`y'`var'_frac.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1`y' marg2`y' marg3`y' marg4`y' using "`y'`var'_frac_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		

}
}







********** Homophily en deux étapes
foreach var in caste gender location {

********** Step 1: Probit
foreach y in debt_ddiff talk_ddiff {

probit `y'`var' $perso i.female i.caste $cont, vce(cl HHFE)
est store reg1`y'
margins, dydx($perso) atmeans post
est store marg1`y'

probit `y'`var' $persoXsex $cont, vce(cl HHFE)
est store reg2`y'
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

probit `y'`var' $persoXcaste $cont, vce(cl HHFE)
est store reg3`y'
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

probit `y'`var' $persoXsexXcaste $cont, vce(cl HHFE)
est store reg4`y'
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

esttab reg1`y' reg2`y' reg3`y' reg4`y' using "`yar'`var'_probit.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1`y' marg2`y' marg3`y' marg4`y' using "`y'`var'_probit_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		
}


********** Step 2: GLM
foreach y in debt_diff talk_diff {

preserve
keep if ddiff`var'==1

glm `y'`var' $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg1`y'
margins, dydx($perso) atmeans post
est store marg1`y'

glm `y'`var' $persoXsex $cont, family(binomial) link(probit) cluster(HHFE)
est store reg2`y'
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

glm `y'`var' $persoXcaste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg3`y'
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

glm `y'`var' $persoXsexXcaste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg4`y'
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

esttab reg1`y' reg2`y' reg3`y' reg4`y' using "`y'`var'_glm.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1`y' marg2`y' marg3`y' marg4`y' using "`y'`var'_glm_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		

restore
}
}









	
****************************************
* END






















/*
****************************************
* Taille du réseau
****************************************

foreach y in all debt relative talk {

poisson netsize_`y' $perso i.female i.caste $cont, vce(cl HHFE)
est store reg1`y'
margins, dydx($perso) atmeans post
est store marg1`y'

poisson netsize_`y' $persoXsex $cont, vce(cl HHFE)
est store reg2`y'
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

poisson netsize_`y' $persoXcaste $cont, vce(cl HHFE)
est store reg3`y'
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

poisson netsize_`y' $persoXsexXcaste $cont, vce(cl HHFE)
est store reg4`y'
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

esttab reg1`y' reg2`y' reg3`y' reg4`y' using "Size_`y'.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1`y' marg2`y' marg3`y' marg4`y' using "Size_`y'_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace
	
}
	
****************************************
* END
*/


















/*
****************************************
* Diversité du réseau
****************************************
foreach var in caste gender age occup educ {

********** Step 1: Probit
foreach y in hetero debt_hetero relative_hetero talk_hetero {

probit `y'_`var' $perso i.female i.caste $cont, vce(cl HHFE)
est store reg1`y'
margins, dydx($perso) atmeans post
est store marg1`y'

probit `y'_`var' $persoXsex $cont, vce(cl HHFE)
est store reg2`y'
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

probit `y'_`var' $persoXcaste $cont, vce(cl HHFE)
est store reg3`y'
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

probit `y'_`var' $persoXsexXcaste $cont, vce(cl HHFE)
est store reg4`y'
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

esttab reg1`y' reg2`y' reg3`y' reg4`y' using "`y'_`var'_probit.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1`y' marg2`y' marg3`y' marg4`y' using "`y'_`var'_probit_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		
}



********** Step 2: GLM
foreach y in IQV debt_IQV relative_IQV talk_IQV {

preserve
keep if `y'_`var'!=0

glm `y'_`var' $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg1`y'
margins, dydx($perso) atmeans post
est store marg1`y'

glm `y'_`var' $persoXsex $cont, family(binomial) link(probit) cluster(HHFE)
est store reg2`y'
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

glm `y'_`var' $persoXcaste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg3`y'
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

glm `y'_`var' $persoXsexXcaste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg4`y'
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

esttab reg1`y' reg2`y' reg3`y' reg4`y' using "`y'_`var'_glm.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1`y' marg2`y' marg3`y' marg4`y' using "`y'_`var'_glm_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		

restore
}
}
	
****************************************
* END
*/















/*
****************************************
* Hétérophilie du réseau
****************************************
foreach var in caste gender age occup educ {

********** Step 1: Probit
foreach y in ddiff debt_ddiff relative_ddiff talk_ddiff {

probit `y'`var' $perso i.female i.caste $cont, vce(cl HHFE)
est store reg1`y'
margins, dydx($perso) atmeans post
est store marg1`y'

probit `y'`var' $persoXsex $cont, vce(cl HHFE)
est store reg2`y'
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

probit `y'`var' $persoXcaste $cont, vce(cl HHFE)
est store reg3`y'
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

probit `y'`var' $persoXsexXcaste $cont, vce(cl HHFE)
est store reg4`y'
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

esttab reg1`y' reg2`y' reg3`y' reg4`y' using "`yar'`var'_probit.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1`y' marg2`y' marg3`y' marg4`y' using "`y'`var'_probit_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		
}


********** Step 2: GLM
foreach y in diff debt_diff relative_diff talk_diff {

preserve
keep if ddiff`var'==1

glm `y'`var' $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg1`y'
margins, dydx($perso) atmeans post
est store marg1`y'

glm `y'`var' $persoXsex $cont, family(binomial) link(probit) cluster(HHFE)
est store reg2`y'
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

glm `y'`var' $persoXcaste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg3`y'
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

glm `y'`var' $persoXsexXcaste $cont, family(binomial) link(probit) cluster(HHFE)
est store reg4`y'
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

esttab reg1`y' reg2`y' reg3`y' reg4`y' using "`y'`var'_glm.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1`y' marg2`y' marg3`y' marg4`y' using "`y'`var'_glm_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		

restore
}
}

****************************************
* END
*/
