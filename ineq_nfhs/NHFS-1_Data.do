*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*June 24, 2025
*-----
*Exploration data
*-----

********** Clear
clear all
macro drop _all

********** Path to do
*global dofile = "C:\Users\Arnaud\Desktop\NFHS"
global dofile = "C:\Users\anatal\Documents\NFHS"


********** Path to working directory directory
*global directory = "C:\Users\Arnaud\Desktop\NFHS"
global directory = "C:\Users\anatal\Documents\NFHS"
cd"$directory"

********** Scheme
*set scheme plotplain_v2
*grstyle init
*grstyle set plain, box nogrid
*-------------------------






****************************************
* Obs caste
****************************************
use"raw/comter_caste", clear

* Duplicates
duplicates report idhh

****************************************
* END








****************************************
* Merge base HH
****************************************
use"raw/HH.dta", clear

* Duplicates
duplicates report hhid

* Destring, rename
destring hhid, gen(idhh)

* Merge avec la variable idhh
merge 1:1 idhh using "raw/comter_caste", keepusing(NEW9)
keep if _merge==3

* Missings
* ssc install mdesc
mdesc NEW9

*
save"HH_caste.dta", replace
****************************************
* END





****************************************
* Merge base men
****************************************
use"raw/IAMR74FL_MEN.dta", clear

* mcaseid ?
sort mcaseid
split mcaseid, p(" ")
order mcaseid mcaseid1 mcaseid2
destring mcaseid1, gen(idhh)
drop mcaseid1 mcaseid2

* Duplicates
duplicates report mcaseid
duplicates report idhh

* Merge avec la variable idhh
merge m:1 idhh using "raw/comter_caste", keepusing(NEW9)
keep if _merge==3

* Missings
* ssc install mdesc
mdesc NEW9

*
save"Men_caste.dta", replace
****************************************
* END








****************************************
* Merge base women
****************************************
use"raw/IAIR74FL_WOMEN.dta", clear

* caseid ?
sort caseid
split caseid, p(" ")
order caseid caseid1 caseid2
destring caseid1, gen(idhh)
drop caseid1 caseid2

* Duplicates
duplicates report caseid
duplicates report idhh

* Merge avec la variable idhh
merge m:1 idhh using "raw/comter_caste", keepusing(NEW9)
keep if _merge==3

* Missings
* ssc install mdesc
mdesc NEW9

*
save"Women_caste.dta", replace
****************************************
* END

