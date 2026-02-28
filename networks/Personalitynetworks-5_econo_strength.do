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

* Rename
rename debt_meetweekly_pct debt_week
rename relative_meetweekly_pct relative_week
rename talk_meetweekly_pct talk_week

rename debt_duration_afe debt_durafe
rename relative_duration_afe relative_durafe
rename talk_duration_afe talk_durafe

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
* Referee: PL on network size for kin and non-kin
****************************************

* Kin
reg netsize_relative $perso i.female i.caste $cont, cluster(HHFE)

* Non-kin
reg netsize_talk $perso i.female i.caste $cont, cluster(HHFE)

* Kin and non-kin
reg netsize_kinnonkin $perso i.female i.caste $cont, cluster(HHFE)
est store reg1

esttab reg1 using "netwsize.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	replace		


****************************************
* END
















****************************************
* Debt strength
****************************************


*
glm debt_strength $perso i.female i.caste $cont c.netsize_debt, family(binomial) link(probit) cluster(HHFE)

glm debt_week $perso i.female i.caste $cont c.netsize_debt, family(binomial) link(probit) cluster(HHFE)



foreach y in debt_strength {
*debt_week

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
esttab reg1`y' reg2`y' reg3`y' reg4`y' using "R_`y'_glm.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	replace		
}

****************************************
* END








****************************************
* Debt duration
****************************************

reg debt_durafe $perso i.female i.caste $cont c.netsize_debt, cluster(HHFE)


foreach y in debt_durafe {

qui reg `y' $perso i.female i.caste $cont c.netsize_debt, cluster(HHFE)
est store reg1`y'
qui margins, dydx($perso) atmeans post
est store marg1`y'

qui reg `y' $persoXsex $cont c.netsize_debt, cluster(HHFE)
est store reg2`y'
qui margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

qui reg `y' $persoXcaste $cont c.netsize_debt, cluster(HHFE)
est store reg3`y'
qui margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

qui reg `y' $persoXsexXcaste $cont c.netsize_debt, cluster(HHFE)
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

glm relative_strength $perso i.female i.caste $cont c.netsize_relative, family(binomial) link(probit) cluster(HHFE)

glm relative_week $perso i.female i.caste $cont c.netsize_relative, family(binomial) link(probit) cluster(HHFE)



foreach y in relative_strength {
*relative_week

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
esttab reg1`y' reg2`y' reg3`y' reg4`y' using "R_`y'_glm.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	replace		
}

****************************************
* END









****************************************
* Relative duration
****************************************

reg relative_durafe $perso i.female i.caste $cont c.netsize_relative, cluster(HHFE)

foreach y in relative_durafe {

qui reg `y' $perso i.female i.caste $cont c.netsize_relative, cluster(HHFE)
est store reg1`y'
qui margins, dydx($perso) atmeans post
est store marg1`y'

qui reg `y' $persoXsex $cont c.netsize_relative, cluster(HHFE)
est store reg2`y'
qui margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

qui reg `y' $persoXcaste $cont c.netsize_relative, cluster(HHFE)
est store reg3`y'
qui margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

qui reg `y' $persoXsexXcaste $cont c.netsize_relative, cluster(HHFE)
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

glm talk_strength $perso i.female i.caste $cont c.netsize_talk, family(binomial) link(probit) cluster(HHFE)

glm talk_week $perso i.female i.caste $cont c.netsize_talk, family(binomial) link(probit) cluster(HHFE)


foreach y in talk_strength {
*talk_week

glm `y' $perso i.female i.caste $cont c.netsize_talk, family(binomial) link(probit) cluster(HHFE)
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
esttab reg1`y' reg2`y' reg3`y' reg4`y' using "R_`y'_glm.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	replace	
}

****************************************
* END










****************************************
* Talk duration
****************************************

reg talk_durafe $perso i.female i.caste $cont c.netsize_talk, cluster(HHFE)


foreach y in talk_durafe {

qui reg `y' $perso i.female i.caste $cont c.netsize_talk, cluster(HHFE)
est store reg1`y'
qui margins, dydx($perso) atmeans post
est store marg1`y'

qui reg `y' $persoXsex $cont c.netsize_talk, cluster(HHFE)
est store reg2`y'
qui margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2`y'

qui reg `y' $persoXcaste $cont c.netsize_talk, cluster(HHFE)
est store reg3`y'
qui margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3`y'

qui reg `y' $persoXsexXcaste $cont c.netsize_talk, cluster(HHFE)
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
