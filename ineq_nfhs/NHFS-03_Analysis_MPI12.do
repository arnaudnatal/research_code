*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*June 5, 2026
*-----
*MPI
*-----

********** Clear
clear all
macro drop _all

********** Path to working directory directory
global directory = "C:\Users\Arnaud\Documents\MEGA\Research\Ongoing_JatisInequalities\Analysis"
cd"$directory"
*-------------------------









****************************************
* Benchmark
****************************************
use"Indiv_mpi.dta", clear

********** Global MPI
mpi ///
d1(d_cm d_nutr d_anc) w1(0.08333 0.1667 0.08333) ///
d2(d_satt d_educ) w2(0.1667 0.1667) ///
d3(d_elct d_wtr d_sani d_hsg d_ckfl d_asst d_bank) w3(0.04762 0.04762 0.04762 0.04762 0.04762 0.04762 0.04762) ///
[pw=wgt], cutoff(0.33)


log using "MPI_area.log"
********** By area
forvalues i=1/2 {
mpi ///
d1(d_cm d_nutr d_anc) w1(0.08333 0.1667 0.08333) ///
d2(d_satt d_educ) w2(0.1667 0.1667) ///
d3(d_elct d_wtr d_sani d_hsg d_ckfl d_asst d_bank) w3(0.04762 0.04762 0.04762 0.04762 0.04762 0.04762 0.04762) ///
[pw=wgt] if loc_rururb==`i', cutoff(0.33) nod
}
log close


log using "MPI_caste.log"
********** By social groups
forvalues i=1/4 {
mpi ///
d1(d_cm d_nutr d_anc) w1(0.08333 0.1667 0.08333) ///
d2(d_satt d_educ) w2(0.1667 0.1667) ///
d3(d_elct d_wtr d_sani d_hsg d_ckfl d_asst d_bank) w3(0.04762 0.04762 0.04762 0.04762 0.04762 0.04762 0.04762) ///
[pw=wgt] if head_caste==`i', cutoff(0.33) nod
}
log close

****************************************
* END









****************************************
* Complementary analysis
****************************************
use"Indiv_mpi.dta", clear


********** By States
mpi ///
d1(d_cm d_nutr d_anc) w1(0.08333 0.1667 0.08333) ///
d2(d_satt d_educ) w2(0.1667 0.1667) ///
d3(d_elct d_wtr d_sani d_hsg d_ckfl d_asst d_bank) w3(0.04762 0.04762 0.04762 0.04762 0.04762 0.04762 0.04762) ///
[pw=wgt], cutoff(0.33) by(loc_state) nosummary nodecomposition
*matlist e(by_mpi)
*putexcel set "_states.xlsx", replace
*putexcel A1=matrix(e(by_mpi)), names




********** By jatis
preserve
keep if jatis5000==1
*
mpi ///
d1(d_cm d_nutr d_anc) w1(0.08333 0.1667 0.08333) ///
d2(d_satt d_educ) w2(0.1667 0.1667) ///
d3(d_elct d_wtr d_sani d_hsg d_ckfl d_asst d_bank) w3(0.04762 0.04762 0.04762 0.04762 0.04762 0.04762 0.04762) ///
[pw=wgt], cutoff(0.33) by(head_jatis) nosummary nodecomposition
*matlist e(by_mpi)
*putexcel set "_jatis.xlsx", replace
*putexcel A1=matrix(e(by_mpi)), names
restore


****************************************
* END





















****************************************
* Intra/inter sur score censuré
****************************************
use"Indiv_mpi.dta", clear

/*
Theil, GE(1)=Within+Between
*/

* Par groupe de caste et par Etats
fre head_caste
fre loc_state

gen tokeep=0
replace tokeep=1 if loc_state==33
replace tokeep=1 if loc_state==5
replace tokeep=1 if loc_state==20
replace tokeep=1 if loc_state==35
replace tokeep=1 if loc_state==19
replace tokeep=1 if loc_state==31
replace tokeep=1 if loc_state==29
replace tokeep=1 if loc_state==16
replace tokeep=1 if loc_state==11
replace tokeep=1 if loc_state==2
keep if tokeep==1
ta loc_state

egen statecaste=group(loc_state head_caste), label
fre statecaste

* Between/Within jatis for each State x Caste
log using "theil_statecaste.log"
tempfile results
postfile handle statecaste within between using `results', replace
forvalues i=1/40 {
qui capture ineqdeco mpi_cens12 if statecaste==`i', by(head_jatis)
if _rc==0 {
post handle (`i') (r(within_ge1)) (r(between_ge1))
}
else {
post handle (`i') (.) (.)
}
}
postclose handle
use `results', clear
list
log close



****************************************
* END






