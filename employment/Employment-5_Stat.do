*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*September 11, 2024
*-----
gl link = "employment"
*Création des variables
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------




/*
Réunion avec Sébastien :
prendre les 15-65 ans
les étudiants sont inactifs
les autres actifs
mettre le chomage avec les occupations
*/









****************************************
* Réunion Jalil le 16 sept 2024: Taux d'activité
****************************************
log using "Tosend/Tauxactivite.smcl", replace

use"Tosend/Panel-individuals-occupations.dta", clear

/*
pop_active1

Sont actifs :
	- les 15 ans ou plus qui ne sont pas étudiants.
Sont inactifs :
	- les moins de 15 ans,
	- les étudiants.

Comparaison 2010-2016-2020.
*/
gen pop_active1=.
replace pop_active1=1 if age>=15 & student==0
replace pop_active1=0 if age<15
replace pop_active1=0 if student==1


/*
pop_active2

Sont actifs :
	- les 15 ans ou plus qui ne sont pas étudiants,
	- les chomeurs.
Sont inactifs :
	- les moins de 15 ans,
	- les étudiants,
	- les malades, les retraités,
	- les femmes au foyer.

Comparaison 2010-2020 délicate, mais comparaison "parfaite" pour 2016-2020.
*/
gen pop_active2=.
replace pop_active2=1 if age>=15 & student==0
replace pop_active2=1 if nonworkertype_cat==3 & nonworkertype_cat!=.
replace pop_active2=0 if age<15
replace pop_active2=0 if student==1
replace pop_active2=0 if nonworkertype_cat==1 & nonworkertype_cat!=.
replace pop_active2=0 if nonworkertype_cat==2 & nonworkertype_cat!=.



********** Tout le monde
preserve
ta pop_active1 year, col
ta pop_active2 year, col
restore





********** Gender

***** Men
preserve
keep if sex==1
ta pop_active1 year, col
ta pop_active2 year, col
restore

***** Women
preserve
keep if sex==2
ta pop_active1 year, col
ta pop_active2 year, col
restore




********** Caste

***** Dalits
preserve
keep if caste==1
ta pop_active1 year, col
ta pop_active2 year, col
restore

***** Middle castes
preserve
keep if caste==2
ta pop_active1 year, col
ta pop_active2 year, col
restore

***** Upper castes
preserve
keep if caste==3
ta pop_active1 year, col
ta pop_active2 year, col
restore








********** Gender X Caste

***** Men X Dalits
preserve
keep if sex==1
keep if caste==1
ta pop_active1 year, col
ta pop_active2 year, col
restore

***** Men X Middle castes
preserve
keep if sex==1
keep if caste==2
ta pop_active1 year, col
ta pop_active2 year, col
restore

***** Men X Upper castes
preserve
keep if sex==1
keep if caste==3
ta pop_active1 year, col
ta pop_active2 year, col
restore

***** Women X Dalits
preserve
keep if sex==2
keep if caste==1
ta pop_active1 year, col
ta pop_active2 year, col
restore

***** Women X Middle castes
preserve
keep if sex==2
keep if caste==2
ta pop_active1 year, col
ta pop_active2 year, col
restore

***** Women X Upper castes
preserve
keep if sex==2
keep if caste==3
ta pop_active1 year, col
ta pop_active2 year, col
restore

log close
translate "Tosend/Tauxactivite.smcl" "Tosend/Tauxactivite.pdf", translator(smcl2pdf)
****************************************
* END













****************************************
* Réunion Jalil le 16 sept 2024: Changement occupation principale
****************************************
log using "Tosend/Occupationprincipale.smcl", replace

use"Tosend/Panel-individuals-occupations.dta", clear

/*
Parmi les travailleurs, quels sont les changements que l'on observe dans la structure de l'emploi ?
*/

********** Tout le monde
preserve
keep if occupation_mainocc!=.
ta occupation_mainocc year, col
restore





********** Gender

***** Men
preserve
keep if sex==1
keep if occupation_mainocc!=.
ta occupation_mainocc year, col
restore

***** Women
preserve
keep if sex==2
keep if occupation_mainocc!=.
ta occupation_mainocc year, col
restore




********** Caste

***** Dalits
preserve
keep if caste==1
keep if occupation_mainocc!=.
ta occupation_mainocc year, col
restore

***** Middle castes
preserve
keep if caste==2
keep if occupation_mainocc!=.
ta occupation_mainocc year, col
restore

***** Upper castes
preserve
keep if caste==3
keep if occupation_mainocc!=.
ta occupation_mainocc year, col
restore








********** Gender X Caste

***** Men X Dalits
preserve
keep if sex==1
keep if caste==1
keep if occupation_mainocc!=.
ta occupation_mainocc year, col
restore

***** Men X Middle castes
preserve
keep if sex==1
keep if caste==2
keep if occupation_mainocc!=.
ta occupation_mainocc year, col
restore

***** Men X Upper castes
preserve
keep if sex==1
keep if caste==3
keep if occupation_mainocc!=.
ta occupation_mainocc year, col
restore

***** Women X Dalits
preserve
keep if sex==2
keep if caste==1
keep if occupation_mainocc!=.
ta occupation_mainocc year, col
restore

***** Women X Middle castes
preserve
keep if sex==2
keep if caste==2
keep if occupation_mainocc!=.
ta occupation_mainocc year, col
restore

***** Women X Upper castes
preserve
keep if sex==2
keep if caste==3
keep if occupation_mainocc!=.
ta occupation_mainocc year, col
restore

log close
translate "Tosend/Occupationprincipale.smcl" "Tosend/Occupationprincipale.pdf", translator(smcl2pdf)
****************************************
* END




























****************************************
* Réunion Sébastien
****************************************
use"Tosend/Panel-individuals-occupations.dta", clear


********** Selection
fre occupation_mainocc

drop if age<15
drop if age>65
drop if student==1

clonevar occupation_new=occupation_mainocc
replace occupation_new=0 if occupation_new==.

label define occupation_new 0"No occupation" 1"Agri SE" 2"Agri casual" 3"Casual" 4"Reg non-quali" 5"Reg quali" 6"SE" 7"MGNREGA"
label values occupation_new occupation_new

ta occupation_new

log using "Tosend/Occupationprincipale_new.smcl", replace
********** Gender

***** Men
preserve
keep if sex==1
ta occupation_new year, col
restore

***** Women
preserve
keep if sex==2
ta occupation_new year, col
restore




********** Caste

***** Dalits
preserve
keep if caste==1
ta occupation_new year, col
restore

***** Middle castes
preserve
keep if caste==2
ta occupation_new year, col
restore

***** Upper castes
preserve
keep if caste==3
ta occupation_new year, col
restore








********** Gender X Caste

***** Men X Dalits
preserve
keep if sex==1
keep if caste==1
ta occupation_new year, col
restore

***** Men X Middle castes
preserve
keep if sex==1
keep if caste==2
ta occupation_new year, col
restore

***** Men X Upper castes
preserve
keep if sex==1
keep if caste==3
ta occupation_new year, col
restore

***** Women X Dalits
preserve
keep if sex==2
keep if caste==1
ta occupation_new year, col
restore

***** Women X Middle castes
preserve
keep if sex==2
keep if caste==2
ta occupation_new year, col
restore

***** Women X Upper castes
preserve
keep if sex==2
keep if caste==3
ta occupation_new year, col
restore

log close
translate "Tosend/Occupationprincipale_new.smcl" "Tosend/Occupationprincipale_new.pdf", translator(smcl2pdf)
****************************************
* END
