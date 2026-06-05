*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*June 24, 2025
*-----
*MPI
*-----

********** Clear
clear all
macro drop _all

********** Path to working directory directory
global directory = "C:\Users\Arnaud\Documents\Research\_Data\NFHS"
cd"$directory"
*-------------------------






****************************************
* MPI OPHDI (10 dimensions)
****************************************
use"HH_caste.dta", clear


********** Global MPI
mpi ///
d1(d_cm d_nutr) w1(0.1667 0.1667) ///
d2(d_satt d_educ) w2(0.1667 0.1667) ///
d3(d_elct d_wtr d_sani d_hsg d_ckfl d_asst) w3(0.0556 0.0556 0.0556 0.0556 0.0556 0.0556) ///
[pw=wgt], cutoff(0.33)


********** By States
mpi ///
d1(d_cm d_nutr) w1(0.1667 0.1667) ///
d2(d_satt d_educ) w2(0.1667 0.1667) ///
d3(d_elct d_wtr d_sani d_hsg d_ckfl d_asst) w3(0.0556 0.0556 0.0556 0.0556 0.0556 0.0556) ///
[pw=wgt], cutoff(0.33) by(head_state)


********** By jatis
preserve
bysort head_jatis: gen n=_N
sort n
drop if n<5000
drop n
drop if head_jatis==1895
label define head_jatis 196"BENGALI", modify
label define head_jatis 1386"NISHAD", modify
*
mpi ///
d1(d_cm d_nutr) w1(0.1667 0.1667) ///
d2(d_satt d_educ) w2(0.1667 0.1667) ///
d3(d_elct d_wtr d_sani d_hsg d_ckfl d_asst) w3(0.0556 0.0556 0.0556 0.0556 0.0556 0.0556) ///
[pw=wgt], cutoff(0.33) by(head_jatis)
restore

****************************************
* END











****************************************
* MPI Niti Ayog (12 dimensions)
****************************************
use"HH_caste.dta", clear


********** Global MPI
mpi ///
d1(d_cm d_nutr d_anc) w1(0.08333 0.1667 0.08333) ///
d2(d_satt d_educ) w2(0.1667 0.1667) ///
d3(d_elct d_wtr d_sani d_hsg d_ckfl d_asst d_bank) w3(0.04762 0.04762 0.04762 0.04762 0.04762 0.04762 0.04762) ///
[pw=wgt], cutoff(0.33)


********** By States
mpi ///
d1(d_cm d_nutr d_anc) w1(0.08333 0.1667 0.08333) ///
d2(d_satt d_educ) w2(0.1667 0.1667) ///
d3(d_elct d_wtr d_sani d_hsg d_ckfl d_asst d_bank) w3(0.04762 0.04762 0.04762 0.04762 0.04762 0.04762 0.04762) ///
[pw=wgt], cutoff(0.33) by(head_state)


********** By jatis
preserve
bysort head_jatis: gen n=_N
sort n
drop if n<5000
drop n
drop if head_jatis==1895
label define head_jatis 196"BENGALI", modify
label define head_jatis 1386"NISHAD", modify
*
mpi ///
d1(d_cm d_nutr d_anc) w1(0.08333 0.1667 0.08333) ///
d2(d_satt d_educ) w2(0.1667 0.1667) ///
d3(d_elct d_wtr d_sani d_hsg d_ckfl d_asst d_bank) w3(0.04762 0.04762 0.04762 0.04762 0.04762 0.04762 0.04762) ///
[pw=wgt], cutoff(0.33) by(head_jatis)
restore

****************************************
* END
















****************************************
* MPI by jatis (10 dim)
****************************************
use"HH_caste.dta", clear


***** Selection
keep if jatis1000==1

***** Incidence by jatis (H)
*
preserve
gen poor10=0 if d_mpoor10==0
replace poor10=hh_size if d_mpoor10==1
*
collapse (sum) poor10 hh_size, by(head_jatis)
gen H=poor10/hh_size
sort H
drop poor10 hh_size
/*
H*100% of the pop are multidimensional poors.
*/
save"_tempH", replace
restore


***** Intensity of the poverty (A)
*
preserve
gen poor10=0 if d_mpoor10==0
replace poor10=hh_size if d_mpoor10==1
*
gen A=dp_score10*hh_size if d_mpoor10==1
*
collapse (sum) A poor10, by(head_jatis)
gen A2=A/poor10
drop A poor10
rename A2 A
save"_tempA", replace
restore


***** MPI
use"_tempH", clear
merge 1:1 head_jatis using "_tempA"
drop _merge
gen MPI=H*A
sort MPI
save"stat/MPI10_jatis", replace

****************************************
* END










****************************************
* MPI by jatis (12 dim)
****************************************
use"HH_caste.dta", clear


***** Selection
keep if jatis1000==1

***** Incidence by jatis (H)
*
preserve
gen poor12=0 if d_mpoor12==0
replace poor12=hh_size if d_mpoor12==1
*
collapse (sum) poor12 hh_size, by(head_jatis)
gen H=poor12/hh_size
sort H
drop poor12 hh_size
/*
H*100% of the pop are multidimensional poors.
*/
save"_tempH", replace
restore


***** Intensity of the poverty (A)
*
preserve
gen poor12=0 if d_mpoor12==0
replace poor12=hh_size if d_mpoor12==1
*
gen A=dp_score12*hh_size if d_mpoor12==1
*
collapse (sum) A poor12, by(head_jatis)
gen A2=A/poor12
drop A poor12
rename A2 A
save"_tempA", replace
restore


***** MPI
use"_tempH", clear
merge 1:1 head_jatis using "_tempA"
drop _merge
gen MPI=H*A
sort MPI
save"stat/MPI12_jatis", replace

****************************************
* END












****************************************
* MPI by states (10 dim)
****************************************
use"HH_caste.dta", clear


***** Incidence by jatis (H)
*
preserve
gen poor10=0 if d_mpoor10==0
replace poor10=hh_size if d_mpoor10==1
*
collapse (sum) poor10 hh_size, by(loc_state)
gen H=poor10/hh_size
sort H
drop poor10 hh_size
/*
H*100% of the pop are multidimensional poors.
*/
save"_tempH", replace
restore


***** Intensity of the poverty (A)
*
preserve
gen poor10=0 if d_mpoor10==0
replace poor10=hh_size if d_mpoor10==1
*
gen A=dp_score10*hh_size if d_mpoor10==1
*
collapse (sum) A poor10, by(loc_state)
gen A2=A/poor10
drop A poor10
rename A2 A
save"_tempA", replace
restore


***** MPI
use"_tempH", clear
merge 1:1 loc_state using "_tempA"
drop _merge
gen MPI=H*A
sort H
save"stat/MPI10_state", replace

****************************************
* END











****************************************
* MPI by states (12 dim)
****************************************
use"HH_caste.dta", clear


***** Incidence by jatis (H)
*
preserve
gen poor12=0 if d_mpoor12==0
replace poor12=hh_size if d_mpoor12==1
*
collapse (sum) poor12 hh_size, by(loc_state)
gen H=poor12/hh_size
sort H
drop poor12 hh_size
/*
H*100% of the pop are multidimensional poors.
*/
save"_tempH", replace
restore


***** Intensity of the poverty (A)
*
preserve
gen poor12=0 if d_mpoor12==0
replace poor12=hh_size if d_mpoor12==1
*
gen A=dp_score12*hh_size if d_mpoor12==1
*
collapse (sum) A poor12, by(loc_state)
gen A2=A/poor12
drop A poor12
rename A2 A
save"_tempA", replace
restore


***** MPI
use"_tempH", clear
merge 1:1 loc_state using "_tempA"
drop _merge
gen MPI=H*A
sort H
save"stat/MPI12_state", replace

****************************************
* END

