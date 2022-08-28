*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*June 1, 2022
*-----
gl link = "psychodebt"
*Poster
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------









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

gen n=_n
drop if n==2
drop n

sort grp ptcs
gen n=_n
replace n=n+1 if grp==2
replace n=n+2 if grp==3
replace n=n+3 if grp==4

*replace waypond=-2.7 if n==7
replace labpos=3 if n==5
replace labpos=3 if n==9
replace labpos=9 if n==12
replace labpos=10 if n==14

twoway ///
(function y=0, lstyle(solid) range(0 15) xline(3 7 11)) ///
(dropline waypond n if way==-1, lw(thick) color(red) ms(o) mlabel(ptcs) mlabvpos(labpos)) ///
(dropline waypond n if way==1, lw(thick) color(green) ms(o) mlabel(ptcs) mlabvpos(labpos)) ///
, ///
xlabel(1.5 `""Non-dalits" "male""' 5 `""Non-dalits" "female""' 9 `""Dalits" "male""' 13 `""Dalits" "female""') ylabel(1 "Advantage" -1.5 "Disadvantage", ang(90)) ///
yscale(lstyle(none)) xscale(lstyle(none)) ///
legend(off)  graphregion(fcolor(255 255 255)) ///
aspectratio(0.5) ///
title("(b) Negotiation") name(nego, replace)
*scale(2)
graph export "$dropbox\nego.eps", as(eps) replace
restore


********** Graph: Mana
preserve
keep if aspect=="mana"

drop if trait=="co" & var=="borrow" & coef==.1
drop if trait=="num"
drop if trait=="raven" & way==-1
drop if trait=="raven" & var=="borrow" & coef==-.14

sort grp ptcs
gen n=_n
replace n=n+1 if grp==2
replace n=n+2 if grp==3
replace n=n+3 if grp==4

replace labpos=3 if n==6
replace labpos=3 if n==7

twoway ///
(function y=0, lstyle(solid) range(0 14) xline(4 9 11)) ///
(dropline waypond n if way==-1, lw(thick) color(red) ms(o) mlabel(ptcs) mlabvpos(labpos)) ///
(dropline waypond n if way==1, lw(thick) color(green) ms(o) mlabel(ptcs) mlabvpos(labpos)) ///
, ///
xlabel(2 `""Non-dalits" "male""' 6.5 `""Non-dalits" "female""' 10 `""Dalits" "male""' 12.5 `""Dalits" "female""') ylabel(1 "Advantage" -0.95 "Disadvantage", ang(90)) ///
yscale(lstyle(none)) xscale(lstyle(none)) ///
legend(off)  graphregion(fcolor(255 255 255)) ///
aspectratio(0.5) ///
title("(c) Management") name(mana, replace)
*scale(2)
graph export "$dropbox\mana.eps", as(eps) replace
restore


********** Combine
graph combine nego mana, scale(1.2)
graph export "$dropbox\comb.eps", as(eps) replace
****************************************
* END
