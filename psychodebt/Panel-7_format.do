*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*March 29, 2023
*-----
gl link = "psychodebt"
*Format
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------













*************************************
* Recourse
*************************************

********** Import
import delimited "Reco_margin.csv", clear stripquote(yes)
gen n=_n
drop if n<=4
replace n=n-4
replace v1=substr(v1,2,.)
replace v2=substr(v2,2,.)
replace v3=substr(v3,2,.)
replace v4=substr(v4,2,.)
replace v5=substr(v5,2,.)


********** All
preserve
keep v1 v2 n
keep if n<=14
gen bl0=""
order bl0, after(v2)
save"marg1.dta", replace
restore



********** Trait 1
preserve
keep if n>=15 & n<=22
drop v1 v2

* Space
gen bl1=""
gen bl2=""
order v3 bl1 v4 bl2

* Sex
gen nstr3=""
order nstr3, after(v3)
replace nstr3=v3[_n+2]

* Caste
gen nstr4=""
order nstr4, after(v4)
replace nstr4=v4[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
order nstr51 nstr52 nstr53, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=v5[_n+4]
replace nstr53=v5[_n+6]

* Drop
keep if n==15 | n==16
replace n=n-14

save"trait1.dta", replace
restore



********** Trait 2
preserve
keep if n>=24 & n<=31
drop v1 v2

* Space
gen bl1=""
gen bl2=""
order v3 bl1 v4 bl2

* Sex
gen nstr3=""
order nstr3, after(v3)
replace nstr3=v3[_n+2]

* Caste
gen nstr4=""
order nstr4, after(v4)
replace nstr4=v4[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
order nstr51 nstr52 nstr53, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=v5[_n+4]
replace nstr53=v5[_n+6]

* Drop
keep if n==24 | n==25
replace n=n-21

save"trait2.dta", replace
restore



********** Trait 3
preserve
keep if n>=33 & n<=40
drop v1 v2

* Space
gen bl1=""
gen bl2=""
order v3 bl1 v4 bl2

* Sex
gen nstr3=""
order nstr3, after(v3)
replace nstr3=v3[_n+2]

* Caste
gen nstr4=""
order nstr4, after(v4)
replace nstr4=v4[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
order nstr51 nstr52 nstr53, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=v5[_n+4]
replace nstr53=v5[_n+6]

* Drop
keep if n==33 | n==34
replace n=n-28

save"trait3.dta", replace
restore



********** Trait 4
preserve
keep if n>=42 & n<=49
drop v1 v2

* Space
gen bl1=""
gen bl2=""
order v3 bl1 v4 bl2

* Sex
gen nstr3=""
order nstr3, after(v3)
replace nstr3=v3[_n+2]

* Caste
gen nstr4=""
order nstr4, after(v4)
replace nstr4=v4[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
order nstr51 nstr52 nstr53, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=v5[_n+4]
replace nstr53=v5[_n+6]

* Drop
keep if n==42 | n==43
replace n=n-35

save"trait4.dta", replace
restore



********** Cog 1
preserve
keep if n>=51 & n<=58
drop v1 v2

* Space
gen bl1=""
gen bl2=""
order v3 bl1 v4 bl2

* Sex
gen nstr3=""
order nstr3, after(v3)
replace nstr3=v3[_n+2]

* Caste
gen nstr4=""
order nstr4, after(v4)
replace nstr4=v4[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
order nstr51 nstr52 nstr53, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=v5[_n+4]
replace nstr53=v5[_n+6]

* Drop
keep if n==51 | n==52
replace n=n-42

save"cog1.dta", replace
restore



********** Cog 2
preserve
keep if n>=60 & n<=67
drop v1 v2

* Space
gen bl1=""
gen bl2=""
order v3 bl1 v4 bl2

* Sex
gen nstr3=""
order nstr3, after(v3)
replace nstr3=v3[_n+2]

* Caste
gen nstr4=""
order nstr4, after(v4)
replace nstr4=v4[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
order nstr51 nstr52 nstr53, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=v5[_n+4]
replace nstr53=v5[_n+6]

* Drop
keep if n==60 | n==61
replace n=n-49

save"cog2.dta", replace
restore



********** Cog3
preserve
keep if n>=69 & n<=76
drop v1 v2

* Space
gen bl1=""
gen bl2=""
order v3 bl1 v4 bl2

* Sex
gen nstr3=""
order nstr3, after(v3)
replace nstr3=v3[_n+2]

* Caste
gen nstr4=""
order nstr4, after(v4)
replace nstr4=v4[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
order nstr51 nstr52 nstr53, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=v5[_n+4]
replace nstr53=v5[_n+6]

* Drop
keep if n==69 | n==70
replace n=n-56

save"cog3.dta", replace
restore



********** Append
use"trait1", clear
append using "trait2"
append using "trait3"
append using "trait4"
append using "cog1"
append using "cog2"
append using "cog3"
save"hetero", replace



********** Merge
use"marg1", clear

merge 1:1 n using "hetero"
order n
drop _merge

***
export excel using "Margins.xlsx", sheet("Recourse") sheetmodify cell(A6) nolabel
*************************************
* END











*************************************
* Negotiation
*************************************

********** Import
import delimited "Nego_margin.csv", clear stripquote(yes)
gen n=_n
drop if n<=4
replace n=n-4
replace v1=substr(v1,2,.)
replace v2=substr(v2,2,.)
replace v3=substr(v3,2,.)
replace v4=substr(v4,2,.)
replace v5=substr(v5,2,.)


********** All
preserve
keep v1 v2 n
keep if n<=14
gen bl0=""
order bl0, after(v2)
save"marg1.dta", replace
restore



********** Trait 1
preserve
keep if n>=15 & n<=22
drop v1 v2

* Space
gen bl1=""
gen bl2=""
order v3 bl1 v4 bl2

* Sex
gen nstr3=""
order nstr3, after(v3)
replace nstr3=v3[_n+2]

* Caste
gen nstr4=""
order nstr4, after(v4)
replace nstr4=v4[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
order nstr51 nstr52 nstr53, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=v5[_n+4]
replace nstr53=v5[_n+6]

* Drop
keep if n==15 | n==16
replace n=n-14

save"trait1.dta", replace
restore



********** Trait 2
preserve
keep if n>=24 & n<=31
drop v1 v2

* Space
gen bl1=""
gen bl2=""
order v3 bl1 v4 bl2

* Sex
gen nstr3=""
order nstr3, after(v3)
replace nstr3=v3[_n+2]

* Caste
gen nstr4=""
order nstr4, after(v4)
replace nstr4=v4[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
order nstr51 nstr52 nstr53, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=v5[_n+4]
replace nstr53=v5[_n+6]

* Drop
keep if n==24 | n==25
replace n=n-21

save"trait2.dta", replace
restore



********** Trait 3
preserve
keep if n>=33 & n<=40
drop v1 v2

* Space
gen bl1=""
gen bl2=""
order v3 bl1 v4 bl2

* Sex
gen nstr3=""
order nstr3, after(v3)
replace nstr3=v3[_n+2]

* Caste
gen nstr4=""
order nstr4, after(v4)
replace nstr4=v4[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
order nstr51 nstr52 nstr53, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=v5[_n+4]
replace nstr53=v5[_n+6]

* Drop
keep if n==33 | n==34
replace n=n-28

save"trait3.dta", replace
restore



********** Trait 4
preserve
keep if n>=42 & n<=49
drop v1 v2

* Space
gen bl1=""
gen bl2=""
order v3 bl1 v4 bl2

* Sex
gen nstr3=""
order nstr3, after(v3)
replace nstr3=v3[_n+2]

* Caste
gen nstr4=""
order nstr4, after(v4)
replace nstr4=v4[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
order nstr51 nstr52 nstr53, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=v5[_n+4]
replace nstr53=v5[_n+6]

* Drop
keep if n==42 | n==43
replace n=n-35

save"trait4.dta", replace
restore



********** Cog 1
preserve
keep if n>=51 & n<=58
drop v1 v2

* Space
gen bl1=""
gen bl2=""
order v3 bl1 v4 bl2

* Sex
gen nstr3=""
order nstr3, after(v3)
replace nstr3=v3[_n+2]

* Caste
gen nstr4=""
order nstr4, after(v4)
replace nstr4=v4[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
order nstr51 nstr52 nstr53, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=v5[_n+4]
replace nstr53=v5[_n+6]

* Drop
keep if n==51 | n==52
replace n=n-42

save"cog1.dta", replace
restore



********** Cog 2
preserve
keep if n>=60 & n<=67
drop v1 v2

* Space
gen bl1=""
gen bl2=""
order v3 bl1 v4 bl2

* Sex
gen nstr3=""
order nstr3, after(v3)
replace nstr3=v3[_n+2]

* Caste
gen nstr4=""
order nstr4, after(v4)
replace nstr4=v4[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
order nstr51 nstr52 nstr53, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=v5[_n+4]
replace nstr53=v5[_n+6]

* Drop
keep if n==60 | n==61
replace n=n-49

save"cog2.dta", replace
restore



********** Cog3
preserve
keep if n>=69 & n<=76
drop v1 v2

* Space
gen bl1=""
gen bl2=""
order v3 bl1 v4 bl2

* Sex
gen nstr3=""
order nstr3, after(v3)
replace nstr3=v3[_n+2]

* Caste
gen nstr4=""
order nstr4, after(v4)
replace nstr4=v4[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
order nstr51 nstr52 nstr53, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=v5[_n+4]
replace nstr53=v5[_n+6]

* Drop
keep if n==69 | n==70
replace n=n-56

save"cog3.dta", replace
restore



********** Append
use"trait1", clear
append using "trait2"
append using "trait3"
append using "trait4"
append using "cog1"
append using "cog2"
append using "cog3"
save"hetero", replace



********** Merge
use"marg1", clear

merge 1:1 n using "hetero"
order n
drop _merge

***
export excel using "Margins.xlsx", sheet("Negotiation") sheetmodify cell(A6) nolabel
*************************************
* END














*************************************
* Management
*************************************

********** Import
import delimited "Mana_margin.csv", clear stripquote(yes)
gen n=_n
drop if n<=4
replace n=n-4
replace v1=substr(v1,2,.)
replace v2=substr(v2,2,.)
replace v3=substr(v3,2,.)
replace v4=substr(v4,2,.)
replace v5=substr(v5,2,.)


********** All
preserve
keep v1 v2 n
keep if n<=14
gen bl0=""
order bl0, after(v2)
save"marg1.dta", replace
restore



********** Trait 1
preserve
keep if n>=15 & n<=22
drop v1 v2

* Space
gen bl1=""
gen bl2=""
order v3 bl1 v4 bl2

* Sex
gen nstr3=""
order nstr3, after(v3)
replace nstr3=v3[_n+2]

* Caste
gen nstr4=""
order nstr4, after(v4)
replace nstr4=v4[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
order nstr51 nstr52 nstr53, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=v5[_n+4]
replace nstr53=v5[_n+6]

* Drop
keep if n==15 | n==16
replace n=n-14

save"trait1.dta", replace
restore



********** Trait 2
preserve
keep if n>=24 & n<=31
drop v1 v2

* Space
gen bl1=""
gen bl2=""
order v3 bl1 v4 bl2

* Sex
gen nstr3=""
order nstr3, after(v3)
replace nstr3=v3[_n+2]

* Caste
gen nstr4=""
order nstr4, after(v4)
replace nstr4=v4[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
order nstr51 nstr52 nstr53, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=v5[_n+4]
replace nstr53=v5[_n+6]

* Drop
keep if n==24 | n==25
replace n=n-21

save"trait2.dta", replace
restore



********** Trait 3
preserve
keep if n>=33 & n<=40
drop v1 v2

* Space
gen bl1=""
gen bl2=""
order v3 bl1 v4 bl2

* Sex
gen nstr3=""
order nstr3, after(v3)
replace nstr3=v3[_n+2]

* Caste
gen nstr4=""
order nstr4, after(v4)
replace nstr4=v4[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
order nstr51 nstr52 nstr53, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=v5[_n+4]
replace nstr53=v5[_n+6]

* Drop
keep if n==33 | n==34
replace n=n-28

save"trait3.dta", replace
restore



********** Trait 4
preserve
keep if n>=42 & n<=49
drop v1 v2

* Space
gen bl1=""
gen bl2=""
order v3 bl1 v4 bl2

* Sex
gen nstr3=""
order nstr3, after(v3)
replace nstr3=v3[_n+2]

* Caste
gen nstr4=""
order nstr4, after(v4)
replace nstr4=v4[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
order nstr51 nstr52 nstr53, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=v5[_n+4]
replace nstr53=v5[_n+6]

* Drop
keep if n==42 | n==43
replace n=n-35

save"trait4.dta", replace
restore



********** Cog 1
preserve
keep if n>=51 & n<=58
drop v1 v2

* Space
gen bl1=""
gen bl2=""
order v3 bl1 v4 bl2

* Sex
gen nstr3=""
order nstr3, after(v3)
replace nstr3=v3[_n+2]

* Caste
gen nstr4=""
order nstr4, after(v4)
replace nstr4=v4[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
order nstr51 nstr52 nstr53, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=v5[_n+4]
replace nstr53=v5[_n+6]

* Drop
keep if n==51 | n==52
replace n=n-42

save"cog1.dta", replace
restore



********** Cog 2
preserve
keep if n>=60 & n<=67
drop v1 v2

* Space
gen bl1=""
gen bl2=""
order v3 bl1 v4 bl2

* Sex
gen nstr3=""
order nstr3, after(v3)
replace nstr3=v3[_n+2]

* Caste
gen nstr4=""
order nstr4, after(v4)
replace nstr4=v4[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
order nstr51 nstr52 nstr53, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=v5[_n+4]
replace nstr53=v5[_n+6]

* Drop
keep if n==60 | n==61
replace n=n-49

save"cog2.dta", replace
restore



********** Cog3
preserve
keep if n>=69 & n<=76
drop v1 v2

* Space
gen bl1=""
gen bl2=""
order v3 bl1 v4 bl2

* Sex
gen nstr3=""
order nstr3, after(v3)
replace nstr3=v3[_n+2]

* Caste
gen nstr4=""
order nstr4, after(v4)
replace nstr4=v4[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
order nstr51 nstr52 nstr53, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=v5[_n+4]
replace nstr53=v5[_n+6]

* Drop
keep if n==69 | n==70
replace n=n-56

save"cog3.dta", replace
restore



********** Append
use"trait1", clear
append using "trait2"
append using "trait3"
append using "trait4"
append using "cog1"
append using "cog2"
append using "cog3"
save"hetero", replace



********** Merge
use"marg1", clear

merge 1:1 n using "hetero"
order n
drop _merge

***
export excel using "Margins.xlsx", sheet("Management") sheetmodify cell(A6) nolabel
*************************************
* END























*************************************
* Clean
*************************************

erase"trait1.dta"
erase"trait2.dta"
erase"trait3.dta"
erase"trait4.dta"
erase"cog1.dta"
erase"cog2.dta"
erase"cog3.dta"
erase"hetero.dta"
erase"marg1.dta"

erase"Reco_margin.csv"
erase"Nego_margin.csv"
erase"Mana_margin.csv"


*************************************
* END







