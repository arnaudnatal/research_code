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
foreach y in ///
strength_mca_glm duration_afe_reg ///
talk_strength_glm talk_duration_afe_reg ///
debt_strength_glm debt_duration_afe_reg ///
relative_strength_glm relative_duration_afe_reg ///
ddiffcaste_probit diffcaste_glm diffcaste_frac ///
ddiffjatis_probit diffjatis_glm diffjatis_frac ///
ddiffgender_probit diffgender_glm diffgender_frac ///
ddifflocation_probit difflocation_glm difflocation_frac ///
talk_ddiffcaste_probit talk_diffcaste_glm talk_diffcaste_frac ///
talk_ddiffjatis_probit talk_diffjatis_glm talk_diffjatis_frac ///
talk_ddiffgender_probit talk_diffgender_glm talk_diffgender_frac ///
talk_ddifflocation_probit talk_difflocation_glm talk_difflocation_frac ///
debt_ddiffcaste_probit debt_diffcaste_glm debt_diffcaste_frac ///
debt_ddiffjatis_probit debt_diffjatis_glm debt_diffjatis_frac ///
debt_ddiffgender_probit debt_diffgender_glm debt_diffgender_frac ///
debt_ddifflocation_probit debt_difflocation_glm debt_difflocation_frac ///
relative_ddiffcaste_probit relative_diffcaste_glm relative_diffcaste_frac ///
relative_ddiffjatis_probit relative_diffjatis_glm relative_diffjatis_frac ///
relative_ddiffgender_probit relative_diffgender_glm relative_diffgender_frac ///
relative_ddifflocation_probit relative_difflocation_glm relative_difflocation_frac ///
hetero_caste_probit IQV_caste_glm ///
hetero_jatis_probit IQV_jatis_glm ///
hetero_gender_probit IQV_gender_glm ///
hetero_location_probit IQV_location_glm ///
talk_hetero_caste_probit talk_IQV_caste_glm ///
talk_hetero_jatis_probit talk_IQV_jatis_glm ///
talk_hetero_gender_probit talk_IQV_gender_glm ///
talk_hetero_location_probit talk_IQV_location_glm ///
debt_hetero_caste_probit debt_IQV_caste_glm ///
debt_hetero_jatis_probit debt_IQV_jatis_glm ///
debt_hetero_gender_probit debt_IQV_gender_glm ///
debt_hetero_location_probit debt_IQV_location_glm ///
 {

local yvar `y'



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
insobs 1
replace n=0 if n==.
sort n
replace v2="All" if n==0

replace v3="Man" if n==0
replace nstr3="Woman" if n==0

replace v4="Dalits" if n==0
replace nstr41="Middle castes" if n==0
replace nstr42="Upper castes" if n==0

replace v5="Dalits man" if n==0
replace nstr51="Middle castes man" if n==0
replace nstr52="Upper castes man" if n==0
replace nstr53="Dalits woman" if n==0
replace nstr54="Middle castes woman" if n==0
replace nstr55="Upper castes woman" if n==0

***
export excel using "Margins.xlsx", sheet("`yvar'") sheetmodify cell(A7) nolabel

erase"marg1.dta"
erase"trait1.dta"
erase"trait2.dta"
erase"trait3.dta"
erase"trait4.dta"
erase"`yvar'_margin.csv"

}

*************************************
* END
