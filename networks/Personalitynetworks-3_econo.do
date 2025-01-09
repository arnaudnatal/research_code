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
use"Analysis/Main_analyses_v5", clear

global cont c.age i.occupation i.educ i.villageid
global contdrop age *occupation *educ *villageid

global perso fES fOPEX fCO locus
global persoXsex c.fES##i.female c.fOPEX##i.female c.fCO##i.female c.locus##i.female
global persoXcaste c.fES##i.caste c.fOPEX##i.caste c.fCO##i.caste c.locus##i.caste
global persoXsexXcaste c.fES##i.female##i.caste c.fOPEX##i.female##i.caste c.fCO##i.female##i.caste c.locus##i.female##i.caste

****************************************
* END

















****************************************
* Taille du réseau
****************************************

poisson netsize_all $perso i.female i.caste $cont, vce(cl HHFE)
est store reg1
margins, dydx($perso) atmeans post
est store marg1

poisson netsize_all $persoXsex $cont, vce(cl HHFE)
est store reg2
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2

poisson netsize_all $persoXcaste $cont, vce(cl HHFE)
est store reg3
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3

poisson netsize_all $persoXsexXcaste $cont, vce(cl HHFE)
est store reg4
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4

esttab reg1 reg2 reg3 reg4 using "Size.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "Size_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		


	
****************************************
* END

















****************************************
* Diversité du réseau
****************************************

********** Diversité de caste

*** Step 1: Probit
probit hetero_caste $perso i.female i.caste $cont, vce(cl HHFE)
est store reg1
margins, dydx($perso) atmeans post
est store marg1

probit hetero_caste $persoXsex $cont, vce(cl HHFE)
est store reg2
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2

probit hetero_caste $persoXcaste $cont, vce(cl HHFE)
est store reg3
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3

probit hetero_caste $persoXsexXcaste $cont, vce(cl HHFE)
est store reg4
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4

esttab reg1 reg2 reg3 reg4 using "IQVcaste_probit.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "IQVcaste_probit_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		



*** Step 2: GLM
glm IQV_caste $perso i.female i.caste $cont if IQV_caste!=0, family(binomial) link(probit) cluster(HHFE)
est store reg1
margins, dydx($perso) atmeans post
est store marg1

glm IQV_caste $persoXsex $cont if IQV_caste!=0, family(binomial) link(probit) cluster(HHFE)
est store reg2
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2

glm IQV_caste $persoXcaste $cont if IQV_caste!=0, family(binomial) link(probit) cluster(HHFE)
est store reg3
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3

glm IQV_caste $persoXsexXcaste $cont if IQV_caste!=0, family(binomial) link(probit) cluster(HHFE)
est store reg4
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4

esttab reg1 reg2 reg3 reg4 using "IQVcaste_glm.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "IQVcaste_glm_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		






********** Diversité de genre

*** Step 1: Probit
probit hetero_gender $perso i.female i.caste $cont, vce(cl HHFE)
est store reg1
margins, dydx($perso) atmeans post
est store marg1

probit hetero_gender $persoXsex $cont, vce(cl HHFE)
est store reg2
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2

probit hetero_gender $persoXcaste $cont, vce(cl HHFE)
est store reg3
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3

probit hetero_gender $persoXsexXcaste $cont, vce(cl HHFE)
est store reg4
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4

esttab reg1 reg2 reg3 reg4 using "IQVgender_probit.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "IQVgender_probit_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		



*** Step 2: GLM
glm IQV_gender $perso i.female i.caste $cont if IQV_gender!=0, family(binomial) link(probit) cluster(HHFE)
est store reg1
margins, dydx($perso) atmeans post
est store marg1

glm IQV_gender $persoXsex $cont if IQV_gender!=0, family(binomial) link(probit) cluster(HHFE)
est store reg2
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2

glm IQV_gender $persoXcaste $cont if IQV_gender!=0, family(binomial) link(probit) cluster(HHFE)
est store reg3
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3

glm IQV_gender $persoXsexXcaste $cont if IQV_gender!=0, family(binomial) link(probit) cluster(HHFE)
est store reg4
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4

esttab reg1 reg2 reg3 reg4 using "IQVgender_glm.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "IQVgender_glm_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		










********** Diversité d'age

*** Step 1: Probit
probit hetero_age $perso i.female i.caste $cont, vce(cl HHFE)
est store reg1
margins, dydx($perso) atmeans post
est store marg1

probit hetero_age $persoXsex $cont, vce(cl HHFE)
est store reg2
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2

probit hetero_age $persoXcaste $cont, vce(cl HHFE)
est store reg3
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3

probit hetero_age $persoXsexXcaste $cont, vce(cl HHFE)
est store reg4
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4

esttab reg1 reg2 reg3 reg4 using "IQVage_probit.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "IQVage_probit_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		



*** Step 2: GLM
glm IQV_age $perso i.female i.caste $cont if IQV_age!=0, family(binomial) link(probit) cluster(HHFE)
est store reg1
margins, dydx($perso) atmeans post
est store marg1

glm IQV_age $persoXsex $cont if IQV_age!=0, family(binomial) link(probit) cluster(HHFE)
est store reg2
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2

glm IQV_age $persoXcaste $cont if IQV_age!=0, family(binomial) link(probit) cluster(HHFE)
est store reg3
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3

glm IQV_age $persoXsexXcaste $cont if IQV_age!=0, family(binomial) link(probit) cluster(HHFE)
est store reg4
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4

esttab reg1 reg2 reg3 reg4 using "IQVage_glm.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "IQVage_glm_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		

	
	
	
	
	
	
	
	
	


********** Diversité d'occupation

*** Step 1: Probit
probit hetero_occup $perso i.female i.caste $cont, vce(cl HHFE)
est store reg1
margins, dydx($perso) atmeans post
est store marg1

probit hetero_occup $persoXsex $cont, vce(cl HHFE)
est store reg2
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2

probit hetero_occup $persoXcaste $cont, vce(cl HHFE)
est store reg3
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3

probit hetero_occup $persoXsexXcaste $cont, vce(cl HHFE)
est store reg4
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4

esttab reg1 reg2 reg3 reg4 using "IQVoccup_probit.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "IQVoccup_probit_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		



*** Step 2: GLM
glm IQV_occup $perso i.female i.caste $cont if IQV_occup!=0, family(binomial) link(probit) cluster(HHFE)
est store reg1
margins, dydx($perso) atmeans post
est store marg1

glm IQV_occup $persoXsex $cont if IQV_occup!=0, family(binomial) link(probit) cluster(HHFE)
est store reg2
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2

glm IQV_occup $persoXcaste $cont if IQV_occup!=0, family(binomial) link(probit) cluster(HHFE)
est store reg3
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3

glm IQV_occup $persoXsexXcaste $cont if IQV_occup!=0, family(binomial) link(probit) cluster(HHFE)
est store reg4
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4

esttab reg1 reg2 reg3 reg4 using "IQVoccup_glm.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "IQVoccup_glm_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		

	
	


	

	
	
	
	
	
	
********** Diversité d'education

*** Step 1: Probit
probit hetero_educ $perso i.female i.caste $cont, vce(cl HHFE)
est store reg1
margins, dydx($perso) atmeans post
est store marg1

probit hetero_educ $persoXsex $cont, vce(cl HHFE)
est store reg2
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2

probit hetero_educ $persoXcaste $cont, vce(cl HHFE)
est store reg3
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3

probit hetero_educ $persoXsexXcaste $cont, vce(cl HHFE)
est store reg4
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4

esttab reg1 reg2 reg3 reg4 using "IQVeduc_probit.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "IQVeduc_probit_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		



*** Step 2: GLM
glm IQV_educ $perso i.female i.caste $cont if IQV_educ!=0, family(binomial) link(probit) cluster(HHFE)
est store reg1
margins, dydx($perso) atmeans post
est store marg1

glm IQV_educ $persoXsex $cont if IQV_educ!=0, family(binomial) link(probit) cluster(HHFE)
est store reg2
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2

glm IQV_educ $persoXcaste $cont if IQV_educ!=0, family(binomial) link(probit) cluster(HHFE)
est store reg3
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3

glm IQV_educ $persoXsexXcaste $cont if IQV_educ!=0, family(binomial) link(probit) cluster(HHFE)
est store reg4
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4

esttab reg1 reg2 reg3 reg4 using "IQVeduc_glm.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "IQVeduc_glm_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
****************************************
* END

















****************************************
* Hétérophilie du réseau
****************************************

********** Hétérophilie de caste

*** Step 1: Probit
probit ddiffcaste $perso i.female i.caste $cont, vce(cl HHFE)
est store reg1
margins, dydx($perso) atmeans post
est store marg1

probit ddiffcaste $persoXsex $cont, vce(cl HHFE)
est store reg2
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2

probit ddiffcaste $persoXcaste $cont, vce(cl HHFE)
est store reg3
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3

probit ddiffcaste $persoXsexXcaste $cont, vce(cl HHFE)
est store reg4
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4

esttab reg1 reg2 reg3 reg4 using "diffcaste_probit.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "diffcaste_probit_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		



*** Step 2: GLM
glm diffcaste $perso i.female i.caste $cont if ddiffcaste==1, family(binomial) link(probit) cluster(HHFE)
est store reg1
margins, dydx($perso) atmeans post
est store marg1

glm diffcaste $persoXsex $cont if ddiffcaste==1, family(binomial) link(probit) cluster(HHFE)
est store reg2
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2

glm diffcaste $persoXcaste $cont if ddiffcaste==1, family(binomial) link(probit) cluster(HHFE)
est store reg3
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3

glm diffcaste $persoXsexXcaste $cont if ddiffcaste==1, family(binomial) link(probit) cluster(HHFE)
est store reg4
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4

esttab reg1 reg2 reg3 reg4 using "diffcaste_glm.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "diffcaste_glm_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		




********** Hétérophilie de genre

*** Step 1: Probit
probit ddiffgender $perso i.female i.caste $cont, vce(cl HHFE)
est store reg1
margins, dydx($perso) atmeans post
est store marg1

probit ddiffgender $persoXsex $cont, vce(cl HHFE)
est store reg2
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2

probit ddiffgender $persoXcaste $cont, vce(cl HHFE)
est store reg3
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3

probit ddiffgender $persoXsexXcaste $cont, vce(cl HHFE)
est store reg4
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4

esttab reg1 reg2 reg3 reg4 using "diffgender_probit.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "diffgender_probit_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		



*** Step 2: GLM
glm diffgender $perso i.female i.caste $cont if ddiffgender==1, family(binomial) link(probit) cluster(HHFE)
est store reg1
margins, dydx($perso) atmeans post
est store marg1

glm diffgender $persoXsex $cont if ddiffgender==1, family(binomial) link(probit) cluster(HHFE)
est store reg2
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2

glm diffgender $persoXcaste $cont if ddiffgender==1, family(binomial) link(probit) cluster(HHFE)
est store reg3
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3

glm diffgender $persoXsexXcaste $cont if ddiffgender==1, family(binomial) link(probit) cluster(HHFE)
est store reg4
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4

esttab reg1 reg2 reg3 reg4 using "diffgender_glm.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "diffgender_glm_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		



	

	
	
********** Hétérophilie de age

*** Step 1: Probit
probit ddiffage $perso i.female i.caste $cont, vce(cl HHFE)
est store reg1
margins, dydx($perso) atmeans post
est store marg1

probit ddiffage $persoXsex $cont, vce(cl HHFE)
est store reg2
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2

probit ddiffage $persoXcaste $cont, vce(cl HHFE)
est store reg3
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3

probit ddiffage $persoXsexXcaste $cont, vce(cl HHFE)
est store reg4
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4

esttab reg1 reg2 reg3 reg4 using "diffage_probit.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "diffage_probit_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		



*** Step 2: GLM
glm diffage $perso i.female i.caste $cont if ddiffage==1, family(binomial) link(probit) cluster(HHFE)
est store reg1
margins, dydx($perso) atmeans post
est store marg1

glm diffage $persoXsex $cont if ddiffage==1, family(binomial) link(probit) cluster(HHFE)
est store reg2
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2

glm diffage $persoXcaste $cont if ddiffage==1, family(binomial) link(probit) cluster(HHFE)
est store reg3
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3

glm diffage $persoXsexXcaste $cont if ddiffage==1, family(binomial) link(probit) cluster(HHFE)
est store reg4
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4

esttab reg1 reg2 reg3 reg4 using "diffage_glm.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "diffage_glm_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		

	
	
	



	

	
	
********** Hétérophilie de location

*** Step 1: Probit
probit ddifflocation $perso i.female i.caste $cont, vce(cl HHFE)
est store reg1
margins, dydx($perso) atmeans post
est store marg1

probit ddifflocation $persoXsex $cont, vce(cl HHFE)
est store reg2
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2

probit ddifflocation $persoXcaste $cont, vce(cl HHFE)
est store reg3
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3

probit ddifflocation $persoXsexXcaste $cont, vce(cl HHFE)
est store reg4
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4

esttab reg1 reg2 reg3 reg4 using "difflocation_probit.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "difflocation_probit_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		



*** Step 2: GLM
glm difflocation $perso i.female i.caste $cont if ddifflocation==1, family(binomial) link(probit) cluster(HHFE)
est store reg1
margins, dydx($perso) atmeans post
est store marg1

glm difflocation $persoXsex $cont if ddifflocation==1, family(binomial) link(probit) cluster(HHFE)
est store reg2
margins, dydx($perso) at(female=(0 1)) atmeans post
est store marg2

glm difflocation $persoXcaste $cont if ddifflocation==1, family(binomial) link(probit) cluster(HHFE)
est store reg3
margins, dydx($perso) at(caste=(1 2 3)) atmeans post
est store marg3

glm difflocation $persoXsexXcaste $cont if ddifflocation==1, family(binomial) link(probit) cluster(HHFE)
est store reg4
margins, dydx($perso) at(female=(0 1) caste=(1 2 3)) atmeans post
est store marg4

esttab reg1 reg2 reg3 reg4 using "difflocation_glm.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($contdrop _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N, fmt(0) labels(`"Observations"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "difflocation_glm_margin.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		


****************************************
* END








