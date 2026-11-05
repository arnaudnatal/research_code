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
* Intra/inter Jatis sur score censuré
****************************************
/*
Theil, GE(1)=Within+Between
*/

cls
********** Caste nationale
use"Indiv_mpi.dta", clear

* Censuré
theildeco mpi_cens12 [w=wgt], by(head_caste)


ineqdeco mpi_cens12 [pw=wgt], by(head_caste)
*
elmo mpi_cens12 [aweight=wgt], by(head_jatis)
matrix list r(R)

* Non censuré
ineqdeco dp_score12 [pw=wgt], by(head_caste)
*
elmo dp_score12 [aweight=wgt], by(head_caste)
matrix list r(R)
*/






/*
********** Caste par Etat
use"Indiv_mpi.dta", clear

*
fre loc_state
* 
log using "theil_state_caste.log"
tempfile results
postfile handle loc_state within between using `results', replace
forvalues i=1/36 {
qui capture ineqdeco mpi_cens12 if loc_state==`i' [pw=wgt], by(head_caste)
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


/*
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
*/

/*
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
*/

/*
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
*/

/*
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
*/

****************************************
* END

