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
*cd"C:\Users\anatal\Documents\nfhs"
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


********** By area
forvalues i=1/2 {
mpi ///
d1(d_cm d_nutr d_anc) w1(0.08333 0.1667 0.08333) ///
d2(d_satt d_educ) w2(0.1667 0.1667) ///
d3(d_elct d_wtr d_sani d_hsg d_ckfl d_asst d_bank) w3(0.04762 0.04762 0.04762 0.04762 0.04762 0.04762 0.04762) ///
[pw=wgt] if loc_rururb==`i', cutoff(0.33) nod
}



********** By social groups
forvalues i=1/4 {
mpi ///
d1(d_cm d_nutr d_anc) w1(0.08333 0.1667 0.08333) ///
d2(d_satt d_educ) w2(0.1667 0.1667) ///
d3(d_elct d_wtr d_sani d_hsg d_ckfl d_asst d_bank) w3(0.04762 0.04762 0.04762 0.04762 0.04762 0.04762 0.04762) ///
[pw=wgt] if head_caste==`i', cutoff(0.33) nod
}


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
[pw=wgt], cutoff(0.33) by(loc_state)
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
* Intra/inter Jatis sur score censuré
****************************************
/*
Theil, GE(1)=Within+Between
*/

/*
********** Par Etat
use"Indiv_mpi.dta", clear
*
fre loc_state
* 
log using "theil_state.log"
tempfile results
postfile handle loc_state within between using `results', replace
forvalues i=1/36 {
qui capture ineqdeco mpi_cens12 if loc_state==`i' [pw=wgt], by(head_jatis)
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
*/



********** Pour SC et par Etat
use"Indiv_mpi.dta", clear
*
fre loc_state
keep if head_caste==1
* 
log using "theil_state_sc.log"
tempfile results
postfile handle loc_state within between using `results', replace
forvalues i=1/36 {
capture ineqdeco mpi_cens12 if loc_state==`i' [pw=wgt], by(head_jatis)
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


********** Pour ST et par Etat
use"Indiv_mpi.dta", clear
*
fre loc_state
keep if head_caste==2
* 
log using "theil_state_st.log"
tempfile results
postfile handle loc_state within between using `results', replace
forvalues i=1/36 {
capture ineqdeco mpi_cens12 if loc_state==`i' [pw=wgt], by(head_jatis)
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


********** Pour OBC et par Etat
use"Indiv_mpi.dta", clear
*
fre loc_state
keep if head_caste==3
* 
log using "theil_state_obc.log"
tempfile results
postfile handle loc_state within between using `results', replace
forvalues i=1/36 {
capture ineqdeco mpi_cens12 if loc_state==`i' [pw=wgt], by(head_jatis)
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




********** Pour other et par Etat
use"Indiv_mpi.dta", clear
*
fre loc_state
keep if head_caste==4
* 
log using "theil_state_oth.log"
tempfile results
postfile handle loc_state within between using `results', replace
forvalues i=1/36 {
capture ineqdeco mpi_cens12 if loc_state==`i' [pw=wgt], by(head_jatis)
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
