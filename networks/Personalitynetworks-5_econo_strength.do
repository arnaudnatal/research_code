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
* Debt strength
****************************************

foreach y in debt_strength  {

qui glm `y' $perso i.female i.caste $cont c.netsize_debt, family(binomial) link(probit) cluster(HHFE)
est store reg1`y'
qui margins, dydx($perso) atmeans post
est store marg1`y'

qui glm `y' $persoXsex $cont c.netsize_debt, family(binomial) link(probit) cluster(HHFE)
est store reg2`y'
qui margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

qui glm `y' $persoXcaste $cont c.netsize_debt, family(binomial) link(probit) cluster(HHFE)
est store reg3`y'
qui margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

qui glm `y' $persoXsexXcaste $cont c.netsize_debt, family(binomial) link(probit) cluster(HHFE)
est store reg4`y'
qui margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

esttab marg1`y' marg2`y' marg3`y' marg4`y' using "`y'_glm_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		
}

****************************************
* END

















****************************************
* Relative strength
****************************************

foreach y in relative_strength {

qui glm `y' $perso i.female i.caste $cont c.netsize_relative, family(binomial) link(probit) cluster(HHFE)
est store reg1`y'
qui margins, dydx($perso) atmeans post
est store marg1`y'

qui glm `y' $persoXsex $cont c.netsize_relative, family(binomial) link(probit) cluster(HHFE)
est store reg2`y'
qui margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

qui glm `y' $persoXcaste $cont c.netsize_relative, family(binomial) link(probit) cluster(HHFE)
est store reg3`y'
qui margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

qui glm `y' $persoXsexXcaste $cont c.netsize_relative, family(binomial) link(probit) cluster(HHFE)
est store reg4`y'
qui margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

esttab marg1`y' marg2`y' marg3`y' marg4`y' using "`y'_glm_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		
}

****************************************
* END











****************************************
* Talk strength
****************************************

foreach y in talk_strength {

qui glm `y' $perso i.female i.caste $cont c.netsize_talk, family(binomial) link(probit) cluster(HHFE)
est store reg1`y'
qui margins, dydx($perso) atmeans post
est store marg1`y'

qui glm `y' $persoXsex $cont c.netsize_talk, family(binomial) link(probit) cluster(HHFE)
est store reg2`y'
qui margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

qui glm `y' $persoXcaste $cont c.netsize_talk, family(binomial) link(probit) cluster(HHFE)
est store reg3`y'
qui margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

qui glm `y' $persoXsexXcaste $cont c.netsize_talk, family(binomial) link(probit) cluster(HHFE)
est store reg4`y'
qui margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4`y'

esttab marg1`y' marg2`y' marg3`y' marg4`y' using "`y'_glm_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		
}

****************************************
* END
