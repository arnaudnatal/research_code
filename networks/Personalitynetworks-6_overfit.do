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

****************************************
* END







log using "Samplesize.log", replace
****************************************
* Sample size
****************************************

********** Pooled sample
sum strength_mca
fre ddiffcaste ddiffjatis ddiffgender
sum diffcaste if ddiffcaste==1
sum diffjatis if ddiffjatis==1
sum diffgender if ddiffgender==1


********** Debt
sum debt_strength
fre debt_ddiffcaste debt_ddiffjatis debt_ddiffgender
sum debt_diffcaste if debt_ddiffcaste==1
sum debt_diffjatis if debt_ddiffjatis==1
sum debt_diffgender if debt_ddiffgender==1


********** Talk the most
sum talk_strength
fre talk_ddiffcaste talk_ddiffjatis talk_ddiffgender
sum talk_diffcaste if talk_ddiffcaste==1
sum talk_diffjatis if talk_ddiffjatis==1
sum talk_diffgender if talk_ddiffgender==1


********** Relatives
sum relative_strength
fre relative_ddiffcaste relative_ddiffjatis relative_ddiffgender
sum relative_diffcaste if relative_ddiffcaste==1
sum relative_diffjatis if relative_ddiffjatis==1
sum relative_diffgender if relative_ddiffgender==1


****************************************
* END
log close














log using "Overfit.log", replace
****************************************
* Overfit
****************************************

********** Force
*
overfit: glm strength_mca $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
*
overfit: glm debt_strength $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
*
overfit: glm talk_strength $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
*
overfit: glm relative_strength $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)




********** Homophily pooled
*
overfit: probit ddiffcaste $perso i.female i.caste $cont, vce(cl HHFE)
preserve
keep if ddiffcaste==1
overfit: glm diffcaste $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
restore
*
overfit: probit ddiffjatis $perso i.female i.caste $cont, vce(cl HHFE)
preserve
keep if ddiffjatis==1
overfit: glm diffjatis $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
restore
*
overfit: probit ddiffgender $perso i.female i.caste $cont, vce(cl HHFE)
preserve
keep if ddiffgender==1
overfit: glm diffgender $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
restore




********** Homophily debt
*
overfit: probit debt_ddiffcaste $perso i.female i.caste $cont, vce(cl HHFE)
preserve
keep if debt_ddiffcaste==1
overfit: glm debt_diffcaste $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
restore
*
overfit: probit debt_ddiffjatis $perso i.female i.caste $cont, vce(cl HHFE)
preserve
keep if debt_ddiffjatis==1
overfit: glm debt_diffjatis $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
restore
*
overfit: probit debt_ddiffgender $perso i.female i.caste $cont, vce(cl HHFE)
preserve
keep if debt_ddiffgender==1
overfit: glm debt_diffgender $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
restore




********** Homophily talk
*
overfit: probit talk_ddiffcaste $perso i.female i.caste $cont, vce(cl HHFE)
preserve
keep if talk_ddiffcaste==1
overfit: glm talk_diffcaste $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
restore
*
overfit: probit talk_ddiffjatis $perso i.female i.caste $cont, vce(cl HHFE)
preserve
keep if talk_ddiffjatis==1
overfit: glm talk_diffjatis $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
restore
*
overfit: probit talk_ddiffgender $perso i.female i.caste $cont, vce(cl HHFE)
preserve
keep if talk_ddiffgender==1
overfit: glm talk_diffgender $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
restore




********** Homophily relatives
*
overfit: probit relative_ddiffcaste $perso i.female i.caste $cont, vce(cl HHFE)
preserve
keep if relative_ddiffcaste==1
overfit: glm relative_diffcaste $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
restore
*
overfit: probit relative_ddiffjatis $perso i.female i.caste $cont, vce(cl HHFE)
preserve
keep if relative_ddiffjatis==1
overfit: glm relative_diffjatis $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
restore
*
overfit: probit relative_ddiffgender $perso i.female i.caste $cont, vce(cl HHFE)
preserve
keep if relative_ddiffgender==1
overfit: glm relative_diffgender $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
restore


****************************************
* END
log close
