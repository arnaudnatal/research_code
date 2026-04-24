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
global dofile = "C:\Users\Arnaud\Desktop\NFHS"


********** Path to working directory directory
*global directory = "C:\Users\Arnaud\Desktop\NFHS"
global directory = "C:\Users\Arnaud\Desktop\NFHS"
cd"$directory"

********** Scheme
*set scheme plotplain_v2
*grstyle init
*grstyle set plain, box nogrid
*-------------------------






****************************************
* Obs caste
****************************************
use"raw/new9 caste", clear

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
merge 1:1 idhh using "raw/new9 caste", keepusing(NEW9)
keep if _merge==3
drop _merge

* Missings
* ssc install mdesc
mdesc NEW9

* MPI
merge 1:1 hhid using "raw/mpivars"
rename _merge merge_mpivars


*
save"HH_caste.dta", replace
****************************************
* END
