*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*October 8, 2024
*-----
gl link = "networks"
*Prepa Indiv
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\networks.do"
*-------------------------








****************************************
* 2016-17
****************************************
use"raw\NEEMSIS1-ego.dta", clear


cls
use"raw\NEEMSIS1-alters.dta", clear
fre networkpurpose1 networkpurpose2 networkpurpose3 networkpurpose4 networkpurpose5

/*
Trop peu d'alters pour la démonétisation
*/

****************************************
* END







****************************************
* 2020-21
****************************************

* Ne garder que les couples
use"raw\NEEMSIS2-ego.dta", clear
drop sex
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-HH", keepusing(relationshiptohead sex age name)
keep if _merge==3
drop _merge
global var HHID2020 INDID2020 egoid name age sex relationshiptohead 
keep $var
order $var
drop if relationshiptohead>=3
bysort HHID2020: gen n=_N
drop if n==1
drop n
bysort HHID2020: gen n=_N
ta n
sort n HHID2020
drop if n==3
drop n
save"_tempN2", replace
/*
315 ménages pour lesquelles nous avons l'homme ET la femme. Sûrement 317, mais je dois voir qui est la "vraie" femme.
*/


* Merger les alters
use"raw\NEEMSIS2-alters_networkpurpose", clear
keep HHID2020 INDID2020 egoid ALTERID namealter networkpurpose*
rename ALTERID alterid
merge m:1 HHID2020 INDID2020 egoid using "_tempN2"
keep if _merge==3
drop _merge
order $var
save"NEEMSIS2-egoalter_v0", replace

* Pour quelles raisons les alters sont-ils cités ? Ne garder que l'aide comme dans MAPNET
use"NEEMSIS2-egoalter_v0", clear
fre networkpurpose1
gen tokeep=0
replace tokeep=1 if networkpurpose1==1
replace tokeep=1 if networkpurpose1==11
replace tokeep=1 if networkpurpose1==13
save"NEEMSIS2-egoalter_v1", replace

* Combien de couples ont dvp un réseau pour l'aide ? 312
use"NEEMSIS2-egoalter_v1", clear
keep HHID2020 INDID2020 egoid relationshiptohead
duplicates drop
bysort HHID2020: gen n=_N
ta n
drop if n==1
dis 624/2

* Combien d'alters par individu et par ménage ? 
use"NEEMSIS2-egoalter_v1", clear
bysort HHID2020 INDID2020: gen nbalterindiv=_n
bysort HHID2020: gen nbalterHH=_n

tabstat nbalterindiv, stat(n mean q)
tabstat nbalterHH, stat(n mean q)


****************************************
* END
