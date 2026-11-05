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
* Graph state prepa
****************************************
import excel "Statistics.xlsx", sheet("data") firstrow clear
drop if state==""

rename share_d1 contrib_d1
rename share_d2 contrib_d2
rename share_d3 contrib_d3

*
forvalues i=1/3 {
replace contrib_d`i'=contrib_d`i'*100
}
*
encode state, gen(state_enc)
drop state
rename state_enc state
label define state_enc 1"Andaman & Nicobar" 8"Dadra & nagar", modify
order state, first
*
replace m0=m0/100

*
save"data_state.dta", replace
****************************************
* END










****************************************
* Graph State
****************************************
use"data_state", clear

set scheme white_tableau

********** Contribution of dimensions
gen scontrib1=contrib_d1+contrib_d2
gen scontrib2=scontrib1+contrib_d3
*
twoway ///
(bar contrib_d1 state) ///
(rbar contrib_d1 scontrib1 state) ///
(rbar scontrib1 scontrib2 state) ///
(function y=33, range(0 36) lcolor(black) lpattern(dash)) ///
(function y=66, range(0 36) lcolor(black) lpattern(dash)) ///
, xlabel(1/36, valuelabel angle(45)) xtitle("") ///
ylabel(0(20)100) ytitle("Per cent") ///
legend(order(1 "Health" 2 "Education" 3 "Standard of living") pos(6) col(3)) ///
name(dim, replace)
graph export "graph/state_contribdim.png", as(png) replace
drop scontrib1 scontrib2

****************************************
* END









****************************************
* Test mpi
****************************************
use"data_state", clear

gen test=m0-mpi_state
ta test
drop test

gen test=m0-mpi_retained
ta test
drop test


****************************************
* END
