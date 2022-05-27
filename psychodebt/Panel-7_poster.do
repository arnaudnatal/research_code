cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
May 13, 2021
-----
Personality traits & debt AT INDIVIDUAL LEVEL in wide
-----
help fvvarlist
-------------------------
*/





****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all

* Scheme
set scheme plotplain_v2
grstyle init
grstyle set plain, box nogrid compact

********** Path to folder "data" folder.
global directory = "C:\Users\Arnaud\Documents\_Thesis\Research-Skills_and_debt\Analysis"
global git "C:\Users\Arnaud\Documents\GitHub"
global dropbox "C:\Users\Arnaud\Documents\Dropbox\Arnaud\Thesis_Debt_skills\INPUT"

***
set scheme plotplain
cd"$directory"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave2 "NEEMSIS1-HH"
global wave3 "NEEMSIS2-HH"


********** Stata package

*coefplot, horizontal xline(0) drop(_cons) levels(95 90 ) ciopts(recast(. rcap))mlabel mlabposition(12) mlabgap(*2)

/*
Pour avoir un box plot en colonne et 1 en ligne pour un nuage de points:
graph7 mpg weight, twoway oneway box xla yla
*/

*stripplot

****************************************
* END






****************************************
* Res
****************************************
import excel "C:\Users\Arnaud\Documents\Dropbox\Arnaud\Thesis_Debt_skills\Poster\res.xlsx", firstrow clear

********** Label
label define caste 0"Non-dalits" 1"Dalits"
label values dalit caste

label define sex 0"Male" 1"Female"
label values female sex

gen ptcs=.
replace ptcs=1 if trait=="es"
replace ptcs=2 if trait=="co"
replace ptcs=3 if trait=="opex"
replace ptcs=4 if trait=="ag"
replace ptcs=5 if trait=="lit"
replace ptcs=6 if trait=="num"
replace ptcs=7 if trait=="raven"

label define ptcs 1"ES" 2"CO" 3"OP-EX" 4"AG" 5"Lit." 6"Num." 7"Rav."
label values ptcs ptcs

order dalit female ptcs

egen grp=group(dalit female), label
order grp

gen abscoef10=abs(coef*10)
gen waypond=way*abscoef10

egen labpos=mlabvpos(waypond ptcs)
replace labpos=6	if waypond<0
replace labpos=12	if waypond>0



********** Graph: Nego
preserve
keep if aspect=="nego"

sum waypond

sort grp ptcs
gen n=_n
replace n=n+1 if grp==2
replace n=n+2 if grp==3
replace n=n+3 if grp==4

twoway ///
(function y=14,range(-3 0) recast(area) fc(red%20) lc(red%1) base(0)  hor) ///
(function y=14,range(0 3) recast(area) fc(green%20) lc(green%1) base(0) hor) ///
(function y=0, lstyle(solid) range(0 14) xline(4 8 11)) ///
(dropline waypond n if signi==1, lw(thick) color(gs0) ms(o)) ///
(dropline waypond n if signi==5, lw(medthick) color(gs0) ms(o)) ///
(dropline waypond n if signi==10, lw(medium) color(gs0) ms(o)) ///
(scatter waypond n, mlabel(ptcs) ms(p) mlabvpos(labpos) mcolor(gs0)) ///
, ///
title("Negotiation of debt") ///
xlabel(2 "Non-dalit male" 6 "Non-dalit female" 9.5 "Dalit male" 12.5 "Dalit female") ylabel(-1.5 "Liability" 1.5 "Assets", ang(90)) ///
yscale(lstyle(none)) xscale(lstyle(none)) ///
legend(off) plotregion(margin(zero)) 
restore



********** Graph: Mana
preserve
keep if aspect=="mana"
sum waypond
sort grp ptcs
gen n=_n
replace n=n+1 if grp==2
replace n=n+2 if grp==3
replace n=n+3 if grp==4

twoway ///
(function y=20,range(-3 0) recast(area) fc(red%20) lc(red%1) base(0)  hor) ///
(function y=20,range(0 3) recast(area) fc(green%20) lc(green%1) base(0) hor) ///
(function y=0, range(0 20)) ///
(dropline waypond n, xline(5 12 15) ms(o)) ///
(scatter waypond n, mlabel(ptcs) ms(p) mlabvpos(labpos)) ///
, ///
title("Management of debt") ///
xlabel(2.5 "Non-dalit male" 8.5 "Non-dalit female" 13.5 "Dalit male" 17.5 "Dalit female") ylabel(-1.5 "Liability" 1.5 "Assets", ang(90)) ///
yscale(lstyle(none)) xscale(lstyle(none)) ///
legend(off) plotregion(margin(zero)) graphregion(fcolor(164 204 76))
restore

*164 204 76
*ivory 255 250 240

****************************************
* END

