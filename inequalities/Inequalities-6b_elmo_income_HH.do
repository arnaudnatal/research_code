*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 8, 2024
*-----
gl link = "inequalities"
*Desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\inequalities.do"
*-------------------------




****************************************
* Size
****************************************
use"panel_v3", clear

ta jatis year if caste==1
ta jatis year if caste==2
ta jatis year if caste==3



****************************************
* END










****************************************
* INCOME decomposition GE by caste
****************************************
use"panel_v3", clear


***** Stat
cls
* 2010
ineqdeco monthlyincome if year==2010, by(caste)

cls
* 2016
ineqdeco monthlyincome if year==2016, by(caste)

cls
* 2020
ineqdeco monthlyincome if year==2020, by(caste)


***** Std Err.
/*
ineqerr monthlyincome if year==2010, reps(200)
ineqerr monthlyincome if year==2016, reps(200)
ineqerr monthlyincome if year==2020, reps(200)
*/


/*
GE(0)=déviation logarithmique moyenne
GE(1)=Theil
GE(2)=Demi coeff de variation au carré

between + within = overall pour GE, peut être passé en % ?

L’interprétation du coefficient de Gini est très intuitive. En multipliant le coefficient par deux et par le revenu moyen, on obtient l’écart de revenu attendu entre deux individus choisis au hasard au sein de la population.
*/

****************************************
* END


























****************************************
* INCOME - ELMO (2008) : avec 3 groupes (les trois castes)
****************************************
use"panel_v3", clear

********** Pour 3 groupes
* Prepa orga
foreach year in 2010 2016 2020 {
preserve
keep if year==`year'
sort monthlyincome
gen n=_n
local maxge0=0
local maxge1=0
local maxge2=0

* Création des groupes
foreach x in 123 132 213 231 312 321 {
quietly {
gen comb`x'=.
local c=0
forvalues i=1/3 {
local n`i'=substr("`x'",`i',1)
}
local j=1
foreach i in `n1' `n2' `n3' {
count if caste==`i'
local c=r(N)+`c'
dis `c'
replace comb`x'=`j' if n<=`c' & comb`x'==.
local j=`j'+1
}
}

* Ineqdeco pour chaque groupe
qui ineqdeco monthlyincome, by(comb`x')
local ge0=r(between_ge0)
if `ge0'>`maxge0' {
	local maxge0=`ge0'
}
local ge1=r(between_ge1)
if `ge1'>`maxge1' {
	local maxge1=`ge1'
}
local ge2=r(between_ge2)
if `ge2'>`maxge2' {
	local maxge2=`ge2'
}
}
*dis `maxge0'
dis `maxge1'
*dis `maxge2'
restore
}
****************************************
* END













/*
****************************************
* INCOME - Decomposition GE by jatis for Dalits
****************************************
macro drop _all 
use"panel_v3", clear


* Selection
keep if caste==1
ta year

***** Stat
cls
* 2010
ineqdeco monthlyincome if year==2010, by(jatis)

cls
* 2016
ineqdeco monthlyincome if year==2016, by(jatis)

cls
* 2020
ineqdeco monthlyincome if year==2020, by(jatis)


********** Pour 2 groupes
* Prepa orga
fre jatis
recode jatis (1=1) (11=2)
fre jatis
foreach year in 2010 2016 2020 {
preserve
keep if year==`year'
sort monthlyincome
gen n=_n
local maxge0=0
local maxge1=0
local maxge2=0

* Création des groupes
foreach x in 12 21 {
quietly {
gen comb`x'=.
local c=0
forvalues i=1/2 {
local n`i'=substr("`x'",`i',1)
}
local j=1
foreach i in `n1' `n2' {
count if jatis==`i'
local c=r(N)+`c'
dis `c'
replace comb`x'=`j' if n<=`c' & comb`x'==.
local j=`j'+1
}
}

* Ineqdeco pour chaque groupe
qui ineqdeco monthlyincome, by(comb`x')
local ge0=r(between_ge0)
if `ge0'>`maxge0' {
	local maxge0=`ge0'
}
local ge1=r(between_ge1)
if `ge1'>`maxge1' {
	local maxge1=`ge1'
}
local ge2=r(between_ge2)
if `ge2'>`maxge2' {
	local maxge2=`ge2'
}
}
*dis `maxge0'
dis `maxge1'
*dis `maxge2'
restore
}
****************************************
* END
*/
















****************************************
* INCOME - Decomposition GE by jatis for Middle
****************************************
macro drop _all 
use"panel_v3", clear


* Selection
keep if caste==2
ta year

***** Stat
cls
* 2010
ineqdeco monthlyincome if year==2010, by(jatis)

cls
* 2016
ineqdeco monthlyincome if year==2016, by(jatis)

cls
* 2020
ineqdeco monthlyincome if year==2020, by(jatis)


********** Pour 2 groupes
* Prepa orga
fre jatis
recode jatis (3=1) (4=2) (5=3) (6=4) (7=5)
fre jatis
foreach year in 2010 2016 2020 {
preserve
keep if year==`year'
sort monthlyincome
gen n=_n
local maxge0=0
local maxge1=0
local maxge2=0

* Création des groupes
foreach x in ///
12345 12354 12435 12453 12534 12543 13245 13254 13425 13452 13524 13542 14235 14253 14325 14352 14523 14532 15234 15243 15324 15342 15423 15432 21345 21354 21435 21453 21534 21543 23145 23154 23415 23451 23514 23541 24135 24153 24315 24351 24513 24531 25134 25143 25314 25341 25413 25431 31245 31254 31425 31452 31524 31542 32145 32154 32415 32451 32514 32541 34125 34152 34215 34251 34512 34521 35124 35142 35214 35241 35412 35421 41235 41253 41325 41352 41523 41532 42135 42153 42315 42351 42513 42531 43125 43152 43215 43251 43512 43521 45123 45132 45213 45231 45312 45321 51234 51243 51324 51342 51423 51432 52134 52143 52314 52341 52413 52431 53124 53142 53214 53241 53412 53421 54123 54132 54213 54231 54312 54321 {
quietly {
gen comb`x'=.
local c=0
forvalues i=1/5 {
local n`i'=substr("`x'",`i',1)
}
local j=1
foreach i in `n1' `n2' `n3' `n4' `n5' {
count if jatis==`i'
local c=r(N)+`c'
dis `c'
replace comb`x'=`j' if n<=`c' & comb`x'==.
local j=`j'+1
}
}

* Ineqdeco pour chaque groupe
qui ineqdeco monthlyincome, by(comb`x')
local ge0=r(between_ge0)
if `ge0'>`maxge0' {
	local maxge0=`ge0'
}
local ge1=r(between_ge1)
if `ge1'>`maxge1' {
	local maxge1=`ge1'
}
local ge2=r(between_ge2)
if `ge2'>`maxge2' {
	local maxge2=`ge2'
}
}
*dis `maxge0'
dis `maxge1'
*dis `maxge2'
restore
}
****************************************
* END
























****************************************
* INCOME - Decomposition GE by jatis for Upper
****************************************
macro drop _all 
use"panel_v3", clear

* Selection
keep if caste==3
ta year

***** Stat
cls
* 2010
ineqdeco monthlyincome if year==2010, by(jatis)

cls
* 2016
ineqdeco monthlyincome if year==2016, by(jatis)

cls
* 2020
ineqdeco monthlyincome if year==2020, by(jatis)


********** Pour 2 groupes
* Prepa orga
fre jatis
recode jatis (8=1) (9=2) (10=3) (11=4) (12=5)
fre jatis
foreach year in 2010 2016 2020 {
preserve
keep if year==`year'
sort monthlyincome
gen n=_n
local maxge0=0
local maxge1=0
local maxge2=0

* Création des groupes
foreach x in ///
12345 12354 12435 12453 12534 12543 13245 13254 13425 13452 13524 13542 14235 14253 14325 14352 14523 14532 15234 15243 15324 15342 15423 15432 21345 21354 21435 21453 21534 21543 23145 23154 23415 23451 23514 23541 24135 24153 24315 24351 24513 24531 25134 25143 25314 25341 25413 25431 31245 31254 31425 31452 31524 31542 32145 32154 32415 32451 32514 32541 34125 34152 34215 34251 34512 34521 35124 35142 35214 35241 35412 35421 41235 41253 41325 41352 41523 41532 42135 42153 42315 42351 42513 42531 43125 43152 43215 43251 43512 43521 45123 45132 45213 45231 45312 45321 51234 51243 51324 51342 51423 51432 52134 52143 52314 52341 52413 52431 53124 53142 53214 53241 53412 53421 54123 54132 54213 54231 54312 54321 {
quietly {
gen comb`x'=.
local c=0
forvalues i=1/5 {
local n`i'=substr("`x'",`i',1)
}
local j=1
foreach i in `n1' `n2' `n3' `n4' `n5' {
count if jatis==`i'
local c=r(N)+`c'
dis `c'
replace comb`x'=`j' if n<=`c' & comb`x'==.
local j=`j'+1
}
}

* Ineqdeco pour chaque groupe
qui ineqdeco monthlyincome, by(comb`x')
local ge0=r(between_ge0)
if `ge0'>`maxge0' {
	local maxge0=`ge0'
}
local ge1=r(between_ge1)
if `ge1'>`maxge1' {
	local maxge1=`ge1'
}
local ge2=r(between_ge2)
if `ge2'>`maxge2' {
	local maxge2=`ge2'
}
}
*dis `maxge0'
dis `maxge1'
*dis `maxge2'
restore
}
****************************************
* END


