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

********** Check sample size
count if strength_debt!=.
count if strength_talk!=. 

count if debt_duration_afe!=.
count if talk_duration_afe!=.

count if debt_diffcaste!=.
count if talk_diffcaste!=.
count if debt_diffgender!=.
count if talk_diffgender!=.

ta debt_ddiffcaste
ta talk_ddiffcaste
ta debt_ddiffgender
ta talk_ddiffgender

preserve
keep if debt_ddiffcaste==1
count if debt_diffcaste!=.
restore
preserve
keep if talk_ddiffcaste==1
count if talk_diffcaste!=.
restore
preserve
keep if debt_ddiffgender==1
count if debt_diffgender!=.
restore
preserve
keep if talk_ddiffgender==1
count if talk_diffgender!=.
restore


****************************************
* END














log using "Overfit.log", replace
****************************************
* Overfit
****************************************

********** Force 1 (mca)
overfit: glm strength_debt $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm strength_debt $persoXsex $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm strength_debt $persoXcaste $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm strength_debt $persoXsexXcaste $cont, family(binomial) link(probit) cluster(HHFE)

overfit: glm strength_talk $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm strength_talk $persoXsex $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm strength_talk $persoXcaste $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm strength_talk $persoXsexXcaste $cont, family(binomial) link(probit) cluster(HHFE)


********** Force 2 (duration)
overfit: reg debt_duration_afe $perso i.female i.caste $cont, cluster(HHFE)
overfit: reg debt_duration_afe $persoXsex $cont, cluster(HHFE)
overfit: reg debt_duration_afe $persoXcaste $cont, cluster(HHFE)
overfit: reg debt_duration_afe $persoXsexXcaste $cont, cluster(HHFE)

overfit: reg talk_duration_afe $perso i.female i.caste $cont, cluster(HHFE)
overfit: reg talk_duration_afe $persoXsex $cont, cluster(HHFE)
overfit: reg talk_duration_afe $persoXcaste $cont, cluster(HHFE)
overfit: reg talk_duration_afe $persoXsexXcaste $cont, cluster(HHFE)


********** Homophily en une étape
overfit: glm debt_diffcaste $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm debt_diffcaste $persoXsex $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm debt_diffcaste $persoXcaste $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm debt_diffcaste $persoXsexXcaste $cont, family(binomial) link(probit) cluster(HHFE)

overfit: glm talk_diffcaste $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm talk_diffcaste $persoXsex $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm talk_diffcaste $persoXcaste $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm talk_diffcaste $persoXsexXcaste $cont, family(binomial) link(probit) cluster(HHFE)

overfit: glm debt_diffgender $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm debt_diffgender $persoXsex $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm debt_diffgender $persoXcaste $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm debt_diffgender $persoXsexXcaste $cont, family(binomial) link(probit) cluster(HHFE)

overfit: glm talk_diffgender $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm talk_diffgender $persoXsex $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm talk_diffgender $persoXcaste $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm talk_diffgender $persoXsexXcaste $cont, family(binomial) link(probit) cluster(HHFE)





********** Homophily en deux étapes

*** Step 1: Probit
overfit: probit debt_ddiffcaste $perso i.female i.caste $cont, vce(cl HHFE)
overfit: probit debt_ddiffcaste $persoXsex $cont, vce(cl HHFE)
overfit: probit debt_ddiffcaste $persoXcaste $cont, vce(cl HHFE)
overfit: probit debt_ddiffcaste $persoXsexXcaste $cont, vce(cl HHFE)

overfit: probit talk_ddiffcaste $perso i.female i.caste $cont, vce(cl HHFE)
overfit: probit talk_ddiffcaste $persoXsex $cont, vce(cl HHFE)
overfit: probit talk_ddiffcaste $persoXcaste $cont, vce(cl HHFE)
overfit: probit talk_ddiffcaste $persoXsexXcaste $cont, vce(cl HHFE)

overfit: probit debt_ddiffgender $perso i.female i.caste $cont, vce(cl HHFE)
overfit: probit debt_ddiffgender $persoXsex $cont, vce(cl HHFE)
overfit: probit debt_ddiffgender $persoXcaste $cont, vce(cl HHFE)
overfit: probit debt_ddiffgender $persoXsexXcaste $cont, vce(cl HHFE)

overfit: probit talk_ddiffgender $perso i.female i.caste $cont, vce(cl HHFE)
overfit: probit talk_ddiffgender $persoXsex $cont, vce(cl HHFE)
overfit: probit talk_ddiffgender $persoXcaste $cont, vce(cl HHFE)
overfit: probit talk_ddiffgender $persoXsexXcaste $cont, vce(cl HHFE)



*** Step 2: GLM
preserve
keep if debt_ddiffcaste==1
overfit: glm debt_diffcaste $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm debt_diffcaste $persoXsex $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm debt_diffcaste $persoXcaste $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm debt_diffcaste $persoXsexXcaste $cont, family(binomial) link(probit) cluster(HHFE)
restore
preserve
keep if talk_ddiffcaste==1
overfit: glm talk_diffcaste $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm talk_diffcaste $persoXsex $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm talk_diffcaste $persoXcaste $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm talk_diffcaste $persoXsexXcaste $cont, family(binomial) link(probit) cluster(HHFE)
restore
preserve
keep if debt_ddiffgender==1
overfit: glm debt_diffgender $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm debt_diffgender $persoXsex $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm debt_diffgender $persoXcaste $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm debt_diffgender $persoXsexXcaste $cont, family(binomial) link(probit) cluster(HHFE)
restore
preserve
keep if talk_ddiffgender==1
overfit: glm talk_diffgender $perso i.female i.caste $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm talk_diffgender $persoXsex $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm talk_diffgender $persoXcaste $cont, family(binomial) link(probit) cluster(HHFE)
overfit: glm talk_diffgender $persoXsexXcaste $cont, family(binomial) link(probit) cluster(HHFE)
restore
****************************************
* END
log close
