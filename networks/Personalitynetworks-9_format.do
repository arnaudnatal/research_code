*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*January 8, 2027
*-----
*Format tables
*-----
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\networks.do"
*-------------------------







*************************************
* Format
*************************************

* Size

* IQVcaste_probit IQVcaste_glm
* IQVgender_probit IQVgender_glm
* IQVage_probit IQVage_glm
* IQVoccup_probit IQVoccup_glm
* IQVeduc_probit IQVeduc_glm

* diffcaste_probit diffcaste_glm
* diffgender_probit diffgender_glm
* diffage_probit diffage_glm
* difflocation_probit difflocation_glm


local yvar difflocation_glm



********** Import
import delimited "`yvar'_margin.csv", clear stripquote(yes)
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
keep if n<=8
gen bl0=""
order bl0, after(v2)
replace v1="Emotional stability (std)" if v1=="fES"
replace v1="Plasticity (std)" if v1=="fOPEX"
replace v1="Conscientiousness (std)" if v1=="fCO"
replace v1="Locus of control (std)" if v1=="locus"
save"marg1.dta", replace
restore



********** Trait 1
preserve
keep if n>=9 & n<=20
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
gen nstr41=""
gen nstr42=""
order nstr41 nstr42, after(v4)
replace nstr41=v4[_n+2]
replace nstr42=nstr41[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
gen nstr54=""
gen nstr55=""
order nstr51 nstr52 nstr53 nstr54 nstr55, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=nstr51[_n+2]
replace nstr53=nstr52[_n+2]
replace nstr54=nstr53[_n+2]
replace nstr55=nstr54[_n+2]

* Drop
drop n
gen n=_n
keep if n<=2

save"trait1.dta", replace
restore



********** Trait 2
preserve
keep if n>=22 & n<=33
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
gen nstr41=""
gen nstr42=""
order nstr41 nstr42, after(v4)
replace nstr41=v4[_n+2]
replace nstr42=nstr41[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
gen nstr54=""
gen nstr55=""
order nstr51 nstr52 nstr53 nstr54 nstr55, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=nstr51[_n+2]
replace nstr53=nstr52[_n+2]
replace nstr54=nstr53[_n+2]
replace nstr55=nstr54[_n+2]

* Drop
drop n
gen n=_n
keep if n<=2

save"trait2.dta", replace
restore









********** Trait 3
preserve
keep if n>=35 & n<=46
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
gen nstr41=""
gen nstr42=""
order nstr41 nstr42, after(v4)
replace nstr41=v4[_n+2]
replace nstr42=nstr41[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
gen nstr54=""
gen nstr55=""
order nstr51 nstr52 nstr53 nstr54 nstr55, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=nstr51[_n+2]
replace nstr53=nstr52[_n+2]
replace nstr54=nstr53[_n+2]
replace nstr55=nstr54[_n+2]

* Drop
drop n
gen n=_n
keep if n<=2

save"trait3.dta", replace
restore








********** Trait 4
preserve
keep if n>=48 & n<=59
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
gen nstr41=""
gen nstr42=""
order nstr41 nstr42, after(v4)
replace nstr41=v4[_n+2]
replace nstr42=nstr41[_n+2]

* Sex and caste
gen nstr51=""
gen nstr52=""
gen nstr53=""
gen nstr54=""
gen nstr55=""
order nstr51 nstr52 nstr53 nstr54 nstr55, after(v5)
replace nstr51=v5[_n+2]
replace nstr52=nstr51[_n+2]
replace nstr53=nstr52[_n+2]
replace nstr54=nstr53[_n+2]
replace nstr55=nstr54[_n+2]

* Drop
drop n
gen n=_n
keep if n<=2

save"trait4.dta", replace
restore




********** Append
use"trait1", clear
append using "trait2"
append using "trait3"
append using "trait4"

drop n
gen n=_n

merge 1:1 n using "marg1"
order n v1 v2 bl0
drop _merge

***
export excel using "Margins.xlsx", sheet("`yvar'") sheetmodify cell(A7) nolabel

erase"marg1.dta"
erase"trait1.dta"
erase"trait2.dta"
erase"trait3.dta"
erase"trait4.dta"
erase"`yvar'_margin.csv"

*************************************
* END