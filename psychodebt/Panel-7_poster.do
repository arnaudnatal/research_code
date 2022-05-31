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
global dropbox "C:\Users\Arnaud\Documents\Dropbox\Arnaud\Thesis_Debt_skills\Poster"

***
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
import excel "$dropbox\res.xlsx", firstrow clear

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

drop if signi==10

sort grp ptcs
gen n=_n
replace n=n+1 if grp==2
replace n=n+2 if grp==4

replace waypond=-2.7 if n==7
replace labpos=3 if n==3
replace labpos=3 if n==7

twoway ///
(function y=0, lstyle(solid) range(0 8) xline(2 5)) ///
(dropline waypond n if way==-1, lw(thick) color(red) ms(o) mlabel(ptcs) mlabvpos(labpos)) ///
(dropline waypond n if way==1, lw(thick) color(green) ms(o) mlabel(ptcs) mlabvpos(labpos)) ///
, ///
xlabel(1 `""Non-dalits" "male""' 3.5 `""Non-dalits" "female""' 6.5 `""Dalits" "female""') ylabel(1 "Advantage" -1.5 "Disadvantage", ang(90)) ///
yscale(lstyle(none)) xscale(lstyle(none)) ///
legend(off)  graphregion(fcolor(255 255 255)) ///
aspectratio(0.5) ///
title("(b) Negotiation") name(nego, replace)
*scale(2)
*graph export "$dropbox\nego.eps", as(eps) replace
restore


********** Graph: Mana
preserve
keep if aspect=="mana"

sum waypond

drop if signi==10

sort grp ptcs
gen n=_n
replace n=n+1 if grp==2
replace n=n+2 if grp==3
replace n=n+3 if grp==4

replace labpos=3 if n==4
replace labpos=9 if n==5

twoway ///
(function y=0, lstyle(solid) range(0 12) xline(3 7 10)) ///
(dropline waypond n if way==-1, lw(thick) color(red) ms(o) mlabel(ptcs) mlabvpos(labpos)) ///
(dropline waypond n if way==1, lw(thick) color(green) ms(o) mlabel(ptcs) mlabvpos(labpos)) ///
, ///
xlabel(1.5 `""Non-dalits" "male""' 5 `""Non-dalits" "female""' 8.5 `""Dalits" "male""' 11 `""Dalits" "female""') ylabel(1 "Advantage" -0.95 "Disadvantage", ang(90)) ///
yscale(lstyle(none)) xscale(lstyle(none)) ///
legend(off)  graphregion(fcolor(255 255 255)) ///
aspectratio(0.5) ///
title("(c) Management") name(mana, replace)
*scale(2)
*graph export "$dropbox\mana.eps", as(eps) replace
restore


********** Combine
graph combine nego mana, scale(1.2)
graph export "$dropbox\comb.eps", as(eps) replace
****************************************
* END
