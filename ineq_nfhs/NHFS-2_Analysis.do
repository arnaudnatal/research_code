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
* Wealth
****************************************
use"HH_caste.dta", clear

* Weight
generate wgt = hv005/1000000
tab hv270 [iweight=wgt]

global var hhid wgt sh36 NEW9 shdistri hv024 hv025 hv270 hv271 sv270s sv270u sv271u sv270us sv270r sv271r sv270rs
keep $var
order $var

* Transfo
qui sum hv271, det
gen hv271_b=hv271+abs(`r(min)')

* Graph Guilmoto
*ssc install twoway__whistogram_gen
/*
twoway__whistogram_gen hv271 [iweight=wgt], bins(100) percent gen(percent wealth)
twoway bar percent wealth, barwidth(4800)
drop percent wealth
*/

* Gini
lorenz est hv271_b [iweight=wgt], gini
*lorenz graph

****************************************
* END









****************************************
* Theil by caste
****************************************
use"HH_caste.dta", clear

* Weight
generate wgt = hv005/1000000
tab hv270 [iweight=wgt]

global var hhid wgt sh36 NEW9 shdistri hv024 hv271
keep $var
order $var

* Transfo
qui sum hv271, det
gen hv271_b=hv271+abs(`r(min)')

* Selection
ta NEW9
bysort NEW9: gen n=_N
ta n
drop if n<1000
drop n


***** Theil by group
cls
ineqdeco hv271_b, by(sh36)
ineqdeco hv271_b, by(NEW9)



***** Theil decompo for SC
preserve
fre sh36
keep if sh36==1
ineqdeco hv271_b, by(NEW9)
restore


***** Theil decompo for ST
preserve
fre sh36
keep if sh36==2
ineqdeco hv271_b, by(NEW9)
restore



***** Theil decompo for OBC
preserve
fre sh36
keep if sh36==3
ineqdeco hv271_b, by(NEW9)
restore

****************************************
* END





















****************************************
* Gini by jatis
****************************************
use"HH_caste.dta", clear

* Weight
generate wgt = hv005/1000000
tab hv270 [iweight=wgt]

* Correct for negative values
qui sum hv271, det
gen hv271_b=hv271+abs(`r(min)')

* Cleaning
global var hhid wgt NEW9 hv271 hv271_b
keep $var
order $var

* Jatis with more than 1000 households
ta NEW9
bysort NEW9: gen n=_N
ta n
drop if n<1000
drop n

* Mean wealth by jatis
bysort NEW9: egen mean_wealth=mean(hv271)
sort NEW9

* Gini by jatis
decode NEW9, gen(jatis)
encode jatis, gen(n)
gen gini=.
forvalues i=1/120 {
preserve
keep if n==`i'
qui lorenz est hv271_b [iweight=wgt], gini
matrix m=e(G)
matrix list m
local g=m[1,1]
replace gini=`g'
keep NEW9 mean_wealth gini
duplicates drop
save"_temp`i'", replace
restore
}
use"_temp1", clear
forvalues i=2/120 {
append using "_temp`i'"
erase "_temp`i'.dta"
}
save"gini_jatis", replace
****************************************
* END












****************************************
* Gini by State
****************************************
use"HH_caste.dta", clear

* Weight
generate wgt = hv005/1000000
tab hv270 [iweight=wgt]

* Correct for negative values
qui sum hv271, det
gen hv271_b=hv271+abs(`r(min)')

* Cleaning
global var hhid wgt hv024 hv271 hv271_b
keep $var
order $var

* Mean wealth by state
bysort hv024: egen mean_wealth=mean(hv271)
sort hv024

* Gini by state
gen gini=.
forvalues i=1/36 {
preserve
keep if hv024==`i'
qui lorenz est hv271_b [iweight=wgt], gini
matrix m=e(G)
matrix list m
local g=m[1,1]
replace gini=`g'
keep hv024 mean_wealth gini
duplicates drop
save"_temp`i'", replace
restore
}
use"_temp1", clear
forvalues i=2/36 {
append using "_temp`i'"
erase "_temp`i'.dta"
}
save"gini_state", replace
****************************************
* END















****************************************
* Gini by District
****************************************
use"HH_caste.dta", clear

* Weight
generate wgt = hv005/1000000
tab hv270 [iweight=wgt]

* Correct for negative values
qui sum hv271, det
gen hv271_b=hv271+abs(`r(min)')

* Cleaning
global var hhid wgt shdistri hv271 hv271_b
keep $var
order $var

* Mean wealth by district
bysort shdistri: egen mean_wealth=mean(hv271)
sort shdistri

* Gini by district
gen gini=.
forvalues i=1/640 {
preserve
keep if shdistri==`i'
qui lorenz est hv271_b [iweight=wgt], gini
matrix m=e(G)
matrix list m
local g=m[1,1]
replace gini=`g'
keep shdistri mean_wealth gini
duplicates drop
save"_temp`i'", replace
restore
}
use"_temp1", clear
forvalues i=2/640 {
append using "_temp`i'"
erase "_temp`i'.dta"
}
save"gini_district", replace
****************************************
* END






****************************************
* Graph des gini
****************************************

* By jatis
use"gini_jatis", clear
decode NEW9, gen(label)
sort mean_wealth
gen n=_n
sum n, det
replace label="" if n>`r(min)' & n<`r(max)'
drop n
*
scatter gini mean_wealth, mlabel(label) title("Gini by jatis") msymbol(oh) mcolor(black%30) msize(medium)
graph export "gini_jatis.png", as(png) replace


* By State
use"gini_state", clear
decode hv024, gen(label)
sort mean_wealth
gen n=_n
sum n, det
replace label="" if n>`r(min)' & n<`r(max)'
drop n
*
scatter gini mean_wealth, mlabel(label) title("Gini by state") msymbol(oh) mcolor(black%30) msize(medium)
graph export "gini_state.png", as(png) replace


* By district
use"gini_district", clear
decode shdistri, gen(label)
sort mean_wealth
gen n=_n
sum n, det
replace label="" if n>`r(min)' & n<`r(max)'
drop n
*
scatter gini mean_wealth, mlabel(label) title("Gini by district") msymbol(oh) mcolor(black%30) msize(medium)
graph export "gini_district.png", as(png) replace

****************************************
* END











****************************************
* McKenzie J of Pop Eco: Jatis
****************************************
use"HH_caste.dta", clear

* Weight
generate wgt = hv005/1000000

* Jatis with more than 1000 households
ta NEW9
bysort NEW9: gen n=_N
ta n
drop if n<1000
drop n

* Cleaning
global var hhid wgt NEW9 hv271
keep $var
order $var

* Mean wealth by jatis
bysort NEW9: egen mean_wealth=mean(hv271)
sort NEW9

* Index of McKenzie
bysort NEW9: egen sd_grp_wealth=sd(hv271)
egen sd_wealth=sd(hv271)
gen i_wealth=sd_grp_wealth/sd_wealth

* Selection
keep i_wealth NEW9 mean_wealth
duplicates drop
save"mckenzie_jatis", replace

****************************************
* END








****************************************
* McKenzie J of Pop Eco: State
****************************************
use"HH_caste.dta", clear

* Weight
generate wgt = hv005/1000000


* Cleaning
global var hhid wgt hv024 hv271
keep $var
order $var

* Mean wealth by state
bysort hv024: egen mean_wealth=mean(hv271)
sort hv024

* Index of McKenzie
bysort hv024: egen sd_grp_wealth=sd(hv271)
egen sd_wealth=sd(hv271)
gen i_wealth=sd_grp_wealth/sd_wealth

* Selection
keep i_wealth hv024 mean_wealth
duplicates drop
save"mckenzie_state", replace

****************************************
* END

















****************************************
* McKenzie J of Pop Eco: District
****************************************
use"HH_caste.dta", clear

* Weight
generate wgt = hv005/1000000


* Cleaning
global var hhid wgt shdistri hv271
keep $var
order $var

* Mean wealth by state
bysort shdistri: egen mean_wealth=mean(hv271)
sort shdistri

* Index of McKenzie
bysort shdistri: egen sd_grp_wealth=sd(hv271)
egen sd_wealth=sd(hv271)
gen i_wealth=sd_grp_wealth/sd_wealth

* Selection
keep i_wealth shdistri mean_wealth
duplicates drop
save"mckenzie_district", replace

****************************************
* END












****************************************
* Gini and McKenzie
****************************************

* jatis
use"gini_jatis", clear
merge 1:1 NEW9 using "mckenzie_jatis"
keep if _merge==3
drop _merge
save"ineq_jatis", replace


* state
use"gini_state", clear
merge 1:1 hv024 using "mckenzie_state"
keep if _merge==3
drop _merge
save"ineq_state", replace


* district
use"gini_district", clear
merge 1:1 shdistri using "mckenzie_district"
keep if _merge==3
drop _merge
save"ineq_district", replace

****************************************
* END










****************************************
* Gini and McKenzie : corr
****************************************

* jatis
use"ineq_jatis", clear
spearman gini i_wealth
pwcorr gini i_wealth
scatter gini i_wealth

* state
use"ineq_state", clear
spearman gini i_wealth
pwcorr gini i_wealth
scatter gini i_wealth

* district
use"ineq_district", clear
spearman gini i_wealth
pwcorr gini i_wealth
scatter gini i_wealth

****************************************
* END
