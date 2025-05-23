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
* Two step heterophily for debt
****************************************

foreach var in caste gender {

********** Step 1: Probit
foreach y in dum_debt_EI {

qui probit `y'_`var' $perso i.female i.caste $cont c.netsize_debt, vce(cl HHFE)
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
}



********** Step 2: OLS
foreach y in debt {

preserve
keep if dum_`y'_EI_`var'==1

qui reg `y'_EI_`var' $perso i.female i.caste $cont c.netsize_debt, cluster(HHFE)
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
restore
}
}
	
****************************************
* END



















****************************************
* Two step heterophily for talk
****************************************

foreach var in caste gender {

********** Step 1: Probit
foreach y in dum_talk_EI {

qui probit `y'_`var' $perso i.female i.caste $cont c.netsize_talk, vce(cl HHFE)
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
}



********** Step 2: OLS
foreach y in talk {

preserve
keep if dum_`y'_EI_`var'==1

qui reg `y'_EI_`var' $perso i.female i.caste $cont c.netsize_talk, cluster(HHFE)
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

qui probit `y'_`var' $perso i.female i.caste $cont c.netsize_relative, vce(cl HHFE)
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
}



********** Step 2: OLS
foreach y in relative {

preserve
keep if dum_`y'_EI_`var'==1

qui reg `y'_EI_`var' $perso i.female i.caste $cont c.netsize_relative, cluster(HHFE)
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
restore
}
}
	
****************************************
* END




