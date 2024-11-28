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
* Cleaning label et var
****************************************



********** Etape 3: J'enleve et je mets
use "Bases_Damien\NEEMSIS2-alters.dta", clear

* Enregistrer ceux qui sont supprimé
preserve
gen ok=1 if namealter=="No name" | namealter=="" 
gen okok=1 if sex==. & age==. & castes==.
keep if ok==1 | okok==1
save "Bases_Damien\ajouteralafincarsupprimerautoutdebut.dta", replace
restore

*Drop alters with missing name
drop if namealter=="No name" | namealter=="" 

*Drop if missing information about sex & age & caste
drop if sex==. & age==. & castes==.


* Supprimer les premiers
preserve
use "Bases_Damien\b1_1asupprimer.dta", clear
gen todrop=1
save "Bases_Damien\b1_1asupprimer_2.dta", replace
restore
merge 1:1 HHID2020 INDID2020 alterid using "Bases_Damien\b1_1asupprimer_2.dta", keepusing(todrop)
drop if _merge==3
drop _merge
drop todrop

* Supprimer les deuxièmes
preserve
use "Bases_Damien\b2_1asupprimer.dta", clear
gen todrop=1
save "Bases_Damien\b2_1asupprimer_2.dta", replace
restore
merge 1:1 HHID2020 INDID2020 alterid using "Bases_Damien\b2_1asupprimer_2.dta", keepusing(todrop)
drop if _merge==3
drop _merge
drop todrop

* Ajouter les premiers
append using "Bases_Damien\b1_2aajouter.dta"

* Ajouter les deuxièmes
append using "Bases_Damien\b2_2aajouter.dta"


save"Bases_Damien\NEEMSIS2-alters_v2.dta", replace
****************************************
* END




use"Bases_Damien\NEEMSIS2-alters_v2.dta", clear
drop groupe_id2 dupli2_alter groupe_id dupli_alter

append using "Bases_Damien\ajouteralafincarsupprimerautoutdebut.dta"
save"Bases_Damien\NEEMSIS2-alters_v3.dta", replace
