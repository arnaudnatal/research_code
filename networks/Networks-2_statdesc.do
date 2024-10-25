*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*October 8, 2024
*-----
gl link = "networks"
*Correction base alters et bases couples
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\networks.do"
*-------------------------







****************************************
* Relier les couples et les alters
****************************************

********** Base couples chef(fe) / épouse(x)
use"NEEMSIS2-couples_v3", replace

* Merger egoid
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-HH", keepusing(egoid)
keep if _merge==3
drop _merge

* Supprimer les polygames pour le moment
drop if polygamous==1

* Selection des variables
keep HHID2020 INDID2020 egoid coupleid couplegender name age sex relationshiptohead
order HHID2020 INDID2020 egoid
drop if coupleid==.
sort HHID2020 INDID2020

* Reshape pour avoir un couple par ligne
reshape wide INDID2020 egoid name age sex relationshiptohead, i(HHID2020 coupleid) j(couplegender)

* Vérification du nombre de ménage
bysort HHID2020: gen n=_N
ta n
dis 402+(310/2)+(66/3)+(12/4)
/*
Il y a un total de 790 couples pour 582 ménages.
*/

* Selection des couples avec chef(fe) et épouse(x) uniquement
keep if relationshiptohead1==1 | relationshiptohead1==2
/*
528 ménages avec couple entre le chef(fe) et l'épouse(x)
*/

* Identifier les couples egos
gen coupleego=0
replace coupleego=1 if egoid1!=0 & egoid2!=0

* Selection des variables et reshape pour avoir un individu par ligne et permettre le merging avec la base alter
keep HHID2020 INDID20201 INDID20202 egoid1 egoid2 coupleego
reshape long INDID2020 egoid, i(HHID2020) j(couplegender)
gen selection=1
ta coupleego
dis 724/2
/*
362 couples ego
*/

* 
save "_tempN2", replace



********** Merger les alters
use"NEEMSIS2-alters_networkpurpose_v6", clear

keep HHID2020 INDID2020 egoid alterid namealter networkpurpose*
merge m:1 HHID2020 INDID2020 egoid using "_tempN2"
keep if _merge==3
drop _merge selection
order HHID2020 INDID2020 egoid couplegender coupleego
sort HHID2020 INDID2020 couplegender alterid

save"NEEMSIS2-egoalter_v0", replace


********** Merger leurs caractérisitiques
use"NEEMSIS2-egoalter_v0", clear

merge 1:1 HHID2020 INDID2020 alterid using "NEEMSIS2-alters_networkpurpose_v6", keepusing(dummyfam friend wkp labourrelation sex age labourtype castes educ occup employertype occupother living ruralurban district livingname compared duration meet meetother meetfrequency invite reciprocity1 intimacy dummyhh hhmember money nbloanperalter loanid)
keep if _merge==3
drop _merge

save"NEEMSIS2-egoalter_v1", replace

****************************************
* END





****************************************
* Superposition des réseaux
****************************************
use"NEEMSIS2-egoalter_v1", clear

bysort HHID2020 namealter sex age castes educ occup: gen n=_N
ta n


****************************************
* END











****************************************
* Stat desc
****************************************
use"NEEMSIS2-egoalter_v0", clear

* Combien d'alters par individu ?
bysort HHID2020 INDID2020: gen nbalterindiv=_n
tabstat nbalterindiv, stat(n mean q)

* Combien d'alters par ménage ?
bysort HHID2020: gen nbalterHH=_n
tabstat nbalterHH, stat(n mean q)

* Raison
ta networkpurpose1
ta networkpurpose2

****************************************
* END
