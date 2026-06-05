*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*June 5, 2026
*-----
*Wealth
*-----

********** Clear
clear all
macro drop _all

********** Path to working directory directory
global directory = "C:\Users\Arnaud\Documents\MEGA\Research\Ongoing_JatisInequalities\Analysis"
cd"$directory"
*-------------------------







****************************************
* Lorenz
****************************************
use"HH_caste.dta", clear

* Gini
lorenz est hh_wealthpos [iweight=wgt], gini
lorenz graph

****************************************
* END











****************************************
* Theil by caste
****************************************
use"HH_caste.dta", clear

* Selection
keep if jatis1000==1

***** Theil by group
cls
ineqdeco hh_wealthpos, by(head_caste)
ineqdeco hh_wealthpos, by(head_jatis)


***** Theil decompo for SC
preserve
fre head_caste
keep if head_caste==1
ineqdeco hh_wealthpos, by(head_jatis)
restore


***** Theil decompo for ST
preserve
fre head_caste
keep if head_caste==2
ineqdeco hh_wealthpos, by(head_jatis)
restore



***** Theil decompo for OBC
preserve
fre head_caste
keep if head_caste==3
ineqdeco hh_wealthpos, by(head_jatis)
restore

****************************************
* END












****************************************
* Gini by jatis
****************************************
use"HH_caste.dta", clear

* Jatis with more than 1000 households
keep if jatis1000==1

* Mean wealth by jatis
bysort head_jatis: egen mean_wealth=mean(hh_wealth)
sort head_jatis

* Gini by jatis
decode head_jatis, gen(jatis)
encode jatis, gen(n)
gen gini=.
forvalues i=1/120 {
preserve
keep if n==`i'
qui lorenz est hh_wealthpos [iweight=wgt], gini
matrix m=e(G)
matrix list m
local g=m[1,1]
replace gini=`g'
keep head_jatis mean_wealth gini
duplicates drop
save"_temp`i'", replace
restore
}
use"_temp1", clear
forvalues i=2/120 {
append using "_temp`i'"
erase "_temp`i'.dta"
}
save"stat/gini_jatis", replace
****************************************
* END












****************************************
* Gini by State
****************************************
use"HH_caste.dta", clear

* Mean wealth by state
bysort loc_state: egen mean_wealth=mean(hh_wealth)
sort loc_state

* Gini by state
gen gini=.
forvalues i=1/36 {
preserve
keep if loc_state==`i'
qui lorenz est hh_wealthpos [iweight=wgt], gini
matrix m=e(G)
matrix list m
local g=m[1,1]
replace gini=`g'
keep loc_state mean_wealth gini
duplicates drop
save"_temp`i'", replace
restore
}
use"_temp1", clear
forvalues i=2/36 {
append using "_temp`i'"
erase "_temp`i'.dta"
}
save"stat/gini_state", replace
****************************************
* END















****************************************
* Gini by District
****************************************
use"HH_caste.dta", clear

* Mean wealth by district
bysort loc_district: egen mean_wealth=mean(hh_wealth)
sort loc_district

* Gini by district
gen gini=.
forvalues i=1/640 {
preserve
keep if loc_district==`i'
qui lorenz est hh_wealthpos [iweight=wgt], gini
matrix m=e(G)
matrix list m
local g=m[1,1]
replace gini=`g'
keep loc_district mean_wealth gini
duplicates drop
save"_temp`i'", replace
restore
}
use"_temp1", clear
forvalues i=2/640 {
append using "_temp`i'"
erase "_temp`i'.dta"
}
save"stat/gini_district", replace
****************************************
* END








****************************************
* Graph des gini
****************************************

* By jatis
use"stat/gini_jatis", clear
decode head_jatis, gen(label)
sort mean_wealth
gen n=_n
sum n, det
replace label="" if n>`r(min)' & n<`r(max)'
drop n
*
scatter gini mean_wealth, mlabel(label) title("Gini by jatis") msymbol(oh) mcolor(black%30) msize(medium)
graph export "graph/gini_jatis.png", as(png) replace


* By State
use"stat/gini_state", clear
decode loc_state, gen(label)
sort mean_wealth
gen n=_n
sum n, det
replace label="" if n>`r(min)' & n<`r(max)'
drop n
*
scatter gini mean_wealth, mlabel(label) title("Gini by state") msymbol(oh) mcolor(black%30) msize(medium)
graph export "graph/gini_state.png", as(png) replace


* By district
use"stat/gini_district", clear
decode loc_district, gen(label)
sort mean_wealth
gen n=_n
sum n, det
replace label="" if n>`r(min)' & n<`r(max)'
drop n
*
scatter gini mean_wealth, mlabel(label) title("Gini by district") msymbol(oh) mcolor(black%30) msize(medium)
graph export "graph/gini_district.png", as(png) replace

****************************************
* END











****************************************
* McKenzie J of Pop Eco: Jatis
****************************************
use"HH_caste.dta", clear


* Jatis with more than 1000 households
keep if jatis1000==1

* Mean wealth by jatis
bysort head_jatis: egen mean_wealth=mean(hh_wealth)
sort head_jatis

* Index of McKenzie
bysort head_jatis: egen sd_grp_wealth=sd(hh_wealth)
egen sd_wealth=sd(hh_wealth)
gen i_wealth=sd_grp_wealth/sd_wealth

* Selection
keep i_wealth head_jatis mean_wealth
duplicates drop
save"stat/mckenzie_jatis", replace

****************************************
* END








****************************************
* McKenzie J of Pop Eco: State
****************************************
use"HH_caste.dta", clear


* Mean wealth by state
bysort loc_state: egen mean_wealth=mean(hh_wealth)
sort loc_state

* Index of McKenzie
bysort loc_state: egen sd_grp_wealth=sd(hh_wealth)
egen sd_wealth=sd(hh_wealth)
gen i_wealth=sd_grp_wealth/sd_wealth

* Selection
keep i_wealth loc_state mean_wealth
duplicates drop
save"stat/mckenzie_state", replace

****************************************
* END

















****************************************
* McKenzie J of Pop Eco: District
****************************************
use"HH_caste.dta", clear

* Mean wealth by state
bysort loc_district: egen mean_wealth=mean(hh_wealth)
sort loc_district

* Index of McKenzie
bysort loc_district: egen sd_grp_wealth=sd(hh_wealth)
egen sd_wealth=sd(hh_wealth)
gen i_wealth=sd_grp_wealth/sd_wealth

* Selection
keep i_wealth loc_district mean_wealth
duplicates drop
save"stat/mckenzie_district", replace

****************************************
* END












****************************************
* Gini and McKenzie
****************************************

* jatis
use"gini_jatis", clear
merge 1:1 head_jatis using "mckenzie_jatis"
keep if _merge==3
drop _merge
save"stat/ineq_jatis", replace


* state
use"gini_state", clear
merge 1:1 loc_state using "mckenzie_state"
keep if _merge==3
drop _merge
save"stat/ineq_state", replace


* district
use"gini_district", clear
merge 1:1 loc_district using "mckenzie_district"
keep if _merge==3
drop _merge
save"stat/ineq_district", replace

****************************************
* END










****************************************
* Gini and McKenzie : corr
****************************************

* jatis
use"stat/ineq_jatis", clear
spearman gini i_wealth
corr gini i_wealth
twoway ///
(scatter gini i_wealth) ///
, title("By jatis") xtitle("Mckenzie index") ytitle("Gini") ///
note("Spearman=.55, Pearson=.56")
graph export "graph/gini_mckenzie_jatis.png", as(png) replace


* state
use"stat/ineq_state", clear
spearman gini i_wealth
corr gini i_wealth
twoway ///
(scatter gini i_wealth) ///
, title("By State") xtitle("Mckenzie index") ytitle("Gini") ///
note("Spearman=.81, Pearson=.81")
graph export "graph/gini_mckenzie_state.png", as(png) replace

* district
use"stat/ineq_district", clear
spearman gini i_wealth
corr gini i_wealth
twoway ///
(scatter gini i_wealth) ///
, title("By District") xtitle("Mckenzie index") ytitle("Gini") ///
note("Spearman=.61, Pearson=.62")
graph export "graph/gini_mckenzie_district.png", as(png) replace


****************************************
* END

