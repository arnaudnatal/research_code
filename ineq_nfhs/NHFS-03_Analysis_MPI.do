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
global dofile = "C:\Users\Arnaud\Documents\GitHub\NFHS"


********** Path to working directory directory
global directory = "C:\Users\Arnaud\Desktop\Data\NFHS"
cd"$directory"

********** Scheme
*set scheme plotplain_v2
*grstyle init
*grstyle set plain, box nogrid
*-------------------------














****************************************
* MPI
****************************************
use"HH_caste.dta", clear

***** Weight
generate wgt=hv005/1000000

***** Rename
rename hv021 psu
rename hv022 stratum
rename hv024 state
rename shdistri district
rename NEW9 jatis
rename wgt weight
rename hv219 headsex
rename sh36 caste

keep hhid state jatis caste weight hhsize d_cm d_nutr d_satt d_educ d_elct d_wtr d_sani d_hsg d_ckfl d_asst d_mpoor dp_score


* Voir s'il ne faut pas multiplier les observations de sorte à avoir une ligne par individu plutôt qu'une ligne par ménage.

********** Global MPI
mpi ///
d1(d_cm d_nutr) w1(0.1667 0.1667) ///
d2(d_satt d_educ) w2(0.1667 0.1667) ///
d3(d_elct d_wtr d_sani d_hsg d_ckfl d_asst) w3(0.0556 0.0556 0.0556 0.0556 0.0556 0.0556) ///
[pw=weight], cutoff(0.33)



********** By States
mpi ///
d1(d_cm d_nutr) w1(0.1667 0.1667) ///
d2(d_satt d_educ) w2(0.1667 0.1667) ///
d3(d_elct d_wtr d_sani d_hsg d_ckfl d_asst) w3(0.0556 0.0556 0.0556 0.0556 0.0556 0.0556) ///
[pw=weight], cutoff(0.33) by(state)





********** By jatis
preserve
bysort jatis: gen n=_N
sort n
drop if n<5000
drop n
drop if jatis==1895
label define NEW9 196"BENGALI", modify
label define NEW9 1386"NISHAD", modify
*
mpi ///
d1(d_cm d_nutr) w1(0.1667 0.1667) ///
d2(d_satt d_educ) w2(0.1667 0.1667) ///
d3(d_elct d_wtr d_sani d_hsg d_ckfl d_asst) w3(0.0556 0.0556 0.0556 0.0556 0.0556 0.0556) ///
[pw=weight], cutoff(0.33) by(jatis)
restore


****************************************
* END





















****************************************
* Jatis ou caste pour deprivation
****************************************
use"HH_caste.dta", clear

***** Weight
generate wgt=hv005/1000000

***** Rename
rename hv021 psu
rename hv022 stratum
rename hv024 state
rename shdistri district
rename NEW9 jatis
rename wgt weight
rename hv219 headsex
rename sh36 caste


***** Reg
qui reg dp_score i.caste i.district hhsize i.headsex [w=weight]
dis "`e(r2_a)'"
qui reg dp_score i.jatis i.district hhsize i.headsex [w=weight]
dis "`e(r2_a)'"



****************************************
* END












****************************************
* MPI by jatis
****************************************
use"HH_caste.dta", clear

***** Weight
generate wgt=hv005/1000000

***** Rename
rename hv021 psu
rename hv022 stratum
rename hv024 state
rename shdistri district
rename NEW9 jatis
rename wgt weight
rename hv219 headsex

keep hhid weight state district jatis dp_score d_mpoor merge_mpivars hhsize headsex

***** Test econometrics
preserve
bysort jatis: gen n=_N
ta n
drop if n<1000
drop n
probit d_mpoor c.hhsize i.state i.jatis [iweight=weight]

***** Jatis selection for H and A
ta jatis
bysort jatis: gen n=_N
ta n
drop if n<1000
drop n

***** Incidence by jatis (H)
*
preserve
gen poor=0 if d_mpoor==0
replace poor=hhsize if d_mpoor==1
*
collapse (sum) poor hhsize, by(jatis)
gen H=poor/hhsize
sort H
drop poor hhsize
/*
H*100% of the pop are multidimensional poors.
*/
save"_tempH", replace
restore


***** Intensity of the poverty (A)
*
preserve
gen poor=0 if d_mpoor==0
replace poor=hhsize if d_mpoor==1
*
gen A=dp_score*hhsize if d_mpoor==1
*
collapse (sum) A poor, by(jatis)
gen A2=A/poor
drop A poor
rename A2 A
save"_tempA", replace
restore


***** MPI
use"_tempH", clear
merge 1:1 jatis using "_tempA"
drop _merge
gen MPI=H*A
sort MPI



****************************************
* END




















****************************************
* MPI by states
****************************************
use"HH_caste.dta", clear

***** Weight
generate wgt=hv005/1000000

***** Rename
rename hv021 psu
rename hv022 stratum
rename hv024 state
rename shdistri district
rename NEW9 jatis
rename wgt weight
rename hv219 headsex

keep hhid weight state district jatis dp_score d_mpoor merge_mpivars hhsize headsex

***** Incidence by jatis (H)
*
preserve
gen poor=0 if d_mpoor==0
replace poor=hhsize if d_mpoor==1
*
collapse (sum) poor hhsize, by(state)
gen H=poor/hhsize
sort H
drop poor hhsize
/*
H*100% of the pop are multidimensional poors.
*/
save"_tempH", replace
restore


***** Intensity of the poverty (A)
*
preserve
gen poor=0 if d_mpoor==0
replace poor=hhsize if d_mpoor==1
*
gen A=dp_score*hhsize if d_mpoor==1
*
collapse (sum) A poor, by(state)
gen A2=A/poor
drop A poor
rename A2 A
save"_tempA", replace
restore


***** MPI
use"_tempH", clear
merge 1:1 state using "_tempA"
drop _merge
gen MPI=H*A
sort H

****************************************
* END
