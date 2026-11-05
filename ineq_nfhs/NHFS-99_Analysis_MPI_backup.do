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

* H
ta d_mpoor12 [aw=wgt]

* M0
sum mpi_cens12 [w=wgt]


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
* Asso castes/jatis
****************************************
use"Indiv_mpi.dta", clear

keep if jatis5000==1
keep head_jatis head_caste
duplicates drop
drop if head_jatis==1895
drop if head_jatis==.
duplicates drop
sort head_jatis
list, clean noobs

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

*matlist e(by_dom)
*putexcel set "_states.xlsx", replace
*putexcel A1=matrix(e(by_dom)), names


****************************************
* END











****************************************
* Graph jatis prepa
****************************************
import excel "Statistics.xlsx", sheet("data_jatis") firstrow clear
drop if jatis==""
*
forvalues i=1/3 {
replace contrib_d`i'=contrib_d`i'*100
}
*
forvalues i=1/12 {
replace contrib_i`i'=contrib_i`i'*100
}
*
save"data_jatis.dta", replace


****************************************
* END












****************************************
* Graph jatis: Numerous
****************************************
use"data_jatis", clear

set scheme white_tableau

keep if cat=="numerous"
sencode jatis, gen(jatis_enc) gsort(m0)
drop jatis
rename jatis_enc jatis
order jatis, first

* H
replace h=h*100
graph bar h, over(jatis, sort(1) label(angle(45))) ///
ytitle("Per cent") ///
title("Multidimensional poverty headcount", size(small)) name(h, replace)

* MPI
graph bar m0, over(jatis, sort(1) label(angle(45))) ///
ytitle("Multidimensional poverty index") ///
title("Multidimensional poverty index", size(small)) name(mpi, replace)

* Contribution of dimensions
gen scontrib1=contrib_d1+contrib_d2
gen scontrib2=scontrib1+contrib_d3
*
twoway ///
(bar contrib_d1 jatis) ///
(rbar contrib_d1 scontrib1 jatis) ///
(rbar scontrib1 scontrib2 jatis) ///
(function y=33, range(0 10) lcolor(black) lpattern(dash)) ///
(function y=66, range(0 10) lcolor(black) lpattern(dash)) ///
, xlabel(1/10, valuelabel angle(45)) xtitle("") ///
ylabel(0(20)100) ytitle("Per cent") ///
legend(order(1 "Health" 2 "Educ" 3 "Std liv") pos(6) col(3)) ///
title("Contributions to the multidimensional poverty index", size(small)) ///
name(dim, replace)
drop scontrib1 scontrib2

* Contribution of indic for health
gen contribtot=contrib_i1+contrib_i2+contrib_i3
forvalues i=1/3 {
gen alt_contrib_i`i'=100*(contrib_i`i'/contribtot)
}
gen scontrib1=alt_contrib_i1+alt_contrib_i2
gen scontrib2=scontrib1+alt_contrib_i3
*
twoway ///
(bar alt_contrib_i1 jatis) ///
(rbar alt_contrib_i1 scontrib1 jatis) ///
(rbar scontrib1 scontrib2 jatis) ///
(function y=25, range(0 10) lcolor(black) lpattern(dash)) ///
(function y=75, range(0 10) lcolor(black) lpattern(dash)) ///
, xlabel(1/10, valuelabel angle(45)) xtitle("") ///
ylabel(0(20)100) ytitle("Per cent") ///
legend(order(1 "Child mort" 2 "Nutr" 3 "Mat hea") pos(6) col(3)) ///
title("Contribution to the health dimension", size(small)) ///
name(health, replace)
drop alt_contrib_i1 alt_contrib_i2 alt_contrib_i3
drop scontrib1 scontrib2
drop contribtot

* Contribution of indic for education
gen contribtot=contrib_i4+contrib_i5
forvalues i=4/5 {
gen alt_contrib_i`i'=100*(contrib_i`i'/contribtot)
}
gen scontrib1=alt_contrib_i4+alt_contrib_i5
*
twoway ///
(bar alt_contrib_i4 jatis) ///
(rbar alt_contrib_i4 scontrib1 jatis) ///
(function y=50, range(0 10) lcolor(black) lpattern(dash)) ///
, xlabel(1/10, valuelabel angle(45)) xtitle("") ///
ylabel(0(20)100) ytitle("Per cent") ///
legend(order(1 "School att" 2 "Years of school") pos(6) col(2)) ///
title("Contribution to the education dimension", size(small)) ///
name(educ, replace)
drop alt_contrib_i4 alt_contrib_i5
drop scontrib1
drop contribtot

* Contribution of indic for std liv
gen contribtot=contrib_i6+contrib_i7+contrib_i8+contrib_i9+contrib_i10+contrib_i11+contrib_i12
forvalues i=6/12 {
gen alt_contrib_i`i'=100*(contrib_i`i'/contribtot)
}
gen scontrib1=alt_contrib_i6+alt_contrib_i7
gen scontrib2=scontrib1+alt_contrib_i8
gen scontrib3=scontrib2+alt_contrib_i9
gen scontrib4=scontrib3+alt_contrib_i10
gen scontrib5=scontrib4+alt_contrib_i11
gen scontrib6=scontrib5+alt_contrib_i12
*
twoway ///
(bar alt_contrib_i6 jatis) ///
(rbar alt_contrib_i6 scontrib1 jatis) ///
(rbar scontrib1 scontrib2 jatis) ///
(rbar scontrib2 scontrib3 jatis) ///
(rbar scontrib3 scontrib4 jatis) ///
(rbar scontrib4 scontrib5 jatis) ///
(rbar scontrib5 scontrib6 jatis) ///
(function y=14.2857, range(0 10) lcolor(black) lpattern(dash)) ///
(function y=28.5714, range(0 10) lcolor(black) lpattern(dash)) ///
(function y=42.8571, range(0 10) lcolor(black) lpattern(dash)) ///
(function y=57.1429, range(0 10) lcolor(black) lpattern(dash)) ///
(function y=71.4286, range(0 10) lcolor(black) lpattern(dash)) ///
(function y=85.7143, range(0 10) lcolor(black) lpattern(dash)) ///
, xlabel(1/10, valuelabel angle(45)) xtitle("") ///
ylabel(0(20)100) ytitle("Per cent") ///
legend(order(1 "Elec" 2 "Water" 3 "Sanit" 4 "Hous" 5 "Cook" 6 "Assets" 7 "Bank") pos(6) col(3)) ///
title("Contribution to the std liv dimension", size(small)) ///
name(stdliv, replace)
drop alt_contrib_i6 alt_contrib_i7 alt_contrib_i8 alt_contrib_i9 alt_contrib_i10 alt_contrib_i11 alt_contrib_i12
drop scontrib1 scontrib2 scontrib3 scontrib4 scontrib5 scontrib6
drop contribtot

* 
graph combine mpi h dim health educ stdliv, note("{it: Note:} Statistics for the 10 detailed caste groups with the largest populations.", size(vsmall))
graph export "graph/det_numerous.png", as(png) replace

****************************************
* END












****************************************
* Graph jatis: Highest
****************************************
use"data_jatis", clear

set scheme white_tableau

keep if cat=="highest"
sencode jatis, gen(jatis_enc) gsort(m0)
drop jatis
rename jatis_enc jatis
order jatis, first

* H
replace h=h*100
graph bar h, over(jatis, sort(1) label(angle(45))) ///
ytitle("Per cent") ///
title("Multidimensional poverty headcount", size(small)) name(h, replace)

* MPI
graph bar m0, over(jatis, sort(1) label(angle(45))) ///
ytitle("Multidimensional poverty index") ///
title("Multidimensional poverty index", size(small)) name(mpi, replace)

* Contribution of dimensions
gen scontrib1=contrib_d1+contrib_d2
gen scontrib2=scontrib1+contrib_d3
*
twoway ///
(bar contrib_d1 jatis) ///
(rbar contrib_d1 scontrib1 jatis) ///
(rbar scontrib1 scontrib2 jatis) ///
(function y=33, range(0 10) lcolor(black) lpattern(dash)) ///
(function y=66, range(0 10) lcolor(black) lpattern(dash)) ///
, xlabel(1/10, valuelabel angle(45)) xtitle("") ///
ylabel(0(20)100) ytitle("Per cent") ///
legend(order(1 "Health" 2 "Educ" 3 "Std liv") pos(6) col(3)) ///
title("Contributions to the multidimensional poverty index", size(small)) ///
name(dim, replace)
drop scontrib1 scontrib2

* Contribution of indic for health
gen contribtot=contrib_i1+contrib_i2+contrib_i3
forvalues i=1/3 {
gen alt_contrib_i`i'=100*(contrib_i`i'/contribtot)
}
gen scontrib1=alt_contrib_i1+alt_contrib_i2
gen scontrib2=scontrib1+alt_contrib_i3
*
twoway ///
(bar alt_contrib_i1 jatis) ///
(rbar alt_contrib_i1 scontrib1 jatis) ///
(rbar scontrib1 scontrib2 jatis) ///
(function y=25, range(0 10) lcolor(black) lpattern(dash)) ///
(function y=75, range(0 10) lcolor(black) lpattern(dash)) ///
, xlabel(1/10, valuelabel angle(45)) xtitle("") ///
ylabel(0(20)100) ytitle("Per cent") ///
legend(order(1 "Child mort" 2 "Nutr" 3 "Mat hea") pos(6) col(3)) ///
title("Contribution to the health dimension", size(small)) ///
name(health, replace)
drop alt_contrib_i1 alt_contrib_i2 alt_contrib_i3
drop scontrib1 scontrib2
drop contribtot

* Contribution of indic for education
gen contribtot=contrib_i4+contrib_i5
forvalues i=4/5 {
gen alt_contrib_i`i'=100*(contrib_i`i'/contribtot)
}
gen scontrib1=alt_contrib_i4+alt_contrib_i5
*
twoway ///
(bar alt_contrib_i4 jatis) ///
(rbar alt_contrib_i4 scontrib1 jatis) ///
(function y=50, range(0 10) lcolor(black) lpattern(dash)) ///
, xlabel(1/10, valuelabel angle(45)) xtitle("") ///
ylabel(0(20)100) ytitle("Per cent") ///
legend(order(1 "School att" 2 "Years of school") pos(6) col(2)) ///
title("Contribution to the education dimension", size(small)) ///
name(educ, replace)
drop alt_contrib_i4 alt_contrib_i5
drop scontrib1
drop contribtot

* Contribution of indic for std liv
gen contribtot=contrib_i6+contrib_i7+contrib_i8+contrib_i9+contrib_i10+contrib_i11+contrib_i12
forvalues i=6/12 {
gen alt_contrib_i`i'=100*(contrib_i`i'/contribtot)
}
gen scontrib1=alt_contrib_i6+alt_contrib_i7
gen scontrib2=scontrib1+alt_contrib_i8
gen scontrib3=scontrib2+alt_contrib_i9
gen scontrib4=scontrib3+alt_contrib_i10
gen scontrib5=scontrib4+alt_contrib_i11
gen scontrib6=scontrib5+alt_contrib_i12
*
twoway ///
(bar alt_contrib_i6 jatis) ///
(rbar alt_contrib_i6 scontrib1 jatis) ///
(rbar scontrib1 scontrib2 jatis) ///
(rbar scontrib2 scontrib3 jatis) ///
(rbar scontrib3 scontrib4 jatis) ///
(rbar scontrib4 scontrib5 jatis) ///
(rbar scontrib5 scontrib6 jatis) ///
(function y=14.2857, range(0 10) lcolor(black) lpattern(dash)) ///
(function y=28.5714, range(0 10) lcolor(black) lpattern(dash)) ///
(function y=42.8571, range(0 10) lcolor(black) lpattern(dash)) ///
(function y=57.1429, range(0 10) lcolor(black) lpattern(dash)) ///
(function y=71.4286, range(0 10) lcolor(black) lpattern(dash)) ///
(function y=85.7143, range(0 10) lcolor(black) lpattern(dash)) ///
, xlabel(1/10, valuelabel angle(45)) xtitle("") ///
ylabel(0(20)100) ytitle("Per cent") ///
legend(order(1 "Elec" 2 "Water" 3 "Sanit" 4 "Hous" 5 "Cook" 6 "Assets" 7 "Bank") pos(6) col(3)) ///
title("Contribution to the std liv dimension", size(small)) ///
name(stdliv, replace)
drop alt_contrib_i6 alt_contrib_i7 alt_contrib_i8 alt_contrib_i9 alt_contrib_i10 alt_contrib_i11 alt_contrib_i12
drop scontrib1 scontrib2 scontrib3 scontrib4 scontrib5 scontrib6
drop contribtot

* 
graph combine mpi h dim health educ stdliv, note("{it: Note:} Statistics for the 10 detailed caste groups with the largest populations amongst castes with the highest multidimensional poverty index.", size(vsmall))
graph export "graph/det_highest.png", as(png) replace

****************************************
* END












****************************************
* Graph jatis: Lowest
****************************************
use"data_jatis", clear

set scheme white_tableau

keep if cat=="lowest"
sencode jatis, gen(jatis_enc) gsort(m0)
drop jatis
rename jatis_enc jatis
order jatis, first

* H
replace h=h*100
graph bar h, over(jatis, sort(1) label(angle(45))) ///
ytitle("Per cent") ///
title("Multidimensional poverty headcount", size(small)) name(h, replace)

* MPI
graph bar m0, over(jatis, sort(1) label(angle(45))) ///
ytitle("Multidimensional poverty index") ///
title("Multidimensional poverty index", size(small)) name(mpi, replace)

* Contribution of dimensions
gen scontrib1=contrib_d1+contrib_d2
gen scontrib2=scontrib1+contrib_d3
*
twoway ///
(bar contrib_d1 jatis) ///
(rbar contrib_d1 scontrib1 jatis) ///
(rbar scontrib1 scontrib2 jatis) ///
(function y=33, range(0 10) lcolor(black) lpattern(dash)) ///
(function y=66, range(0 10) lcolor(black) lpattern(dash)) ///
, xlabel(1/10, valuelabel angle(45)) xtitle("") ///
ylabel(0(20)100) ytitle("Per cent") ///
legend(order(1 "Health" 2 "Educ" 3 "Std liv") pos(6) col(3)) ///
title("Contributions to the multidimensional poverty index", size(small)) ///
name(dim, replace)
drop scontrib1 scontrib2

* Contribution of indic for health
gen contribtot=contrib_i1+contrib_i2+contrib_i3
forvalues i=1/3 {
gen alt_contrib_i`i'=100*(contrib_i`i'/contribtot)
}
gen scontrib1=alt_contrib_i1+alt_contrib_i2
gen scontrib2=scontrib1+alt_contrib_i3
*
twoway ///
(bar alt_contrib_i1 jatis) ///
(rbar alt_contrib_i1 scontrib1 jatis) ///
(rbar scontrib1 scontrib2 jatis) ///
(function y=25, range(0 10) lcolor(black) lpattern(dash)) ///
(function y=75, range(0 10) lcolor(black) lpattern(dash)) ///
, xlabel(1/10, valuelabel angle(45)) xtitle("") ///
ylabel(0(20)100) ytitle("Per cent") ///
legend(order(1 "Child mort" 2 "Nutr" 3 "Mat hea") pos(6) col(3)) ///
title("Contribution to the health dimension", size(small)) ///
name(health, replace)
drop alt_contrib_i1 alt_contrib_i2 alt_contrib_i3
drop scontrib1 scontrib2
drop contribtot

* Contribution of indic for education
gen contribtot=contrib_i4+contrib_i5
forvalues i=4/5 {
gen alt_contrib_i`i'=100*(contrib_i`i'/contribtot)
}
gen scontrib1=alt_contrib_i4+alt_contrib_i5
*
twoway ///
(bar alt_contrib_i4 jatis) ///
(rbar alt_contrib_i4 scontrib1 jatis) ///
(function y=50, range(0 10) lcolor(black) lpattern(dash)) ///
, xlabel(1/10, valuelabel angle(45)) xtitle("") ///
ylabel(0(20)100) ytitle("Per cent") ///
legend(order(1 "School att" 2 "Years of school") pos(6) col(2)) ///
title("Contribution to the education dimension", size(small)) ///
name(educ, replace)
drop alt_contrib_i4 alt_contrib_i5
drop scontrib1
drop contribtot

* Contribution of indic for std liv
gen contribtot=contrib_i6+contrib_i7+contrib_i8+contrib_i9+contrib_i10+contrib_i11+contrib_i12
forvalues i=6/12 {
gen alt_contrib_i`i'=100*(contrib_i`i'/contribtot)
}
gen scontrib1=alt_contrib_i6+alt_contrib_i7
gen scontrib2=scontrib1+alt_contrib_i8
gen scontrib3=scontrib2+alt_contrib_i9
gen scontrib4=scontrib3+alt_contrib_i10
gen scontrib5=scontrib4+alt_contrib_i11
gen scontrib6=scontrib5+alt_contrib_i12
*
twoway ///
(bar alt_contrib_i6 jatis) ///
(rbar alt_contrib_i6 scontrib1 jatis) ///
(rbar scontrib1 scontrib2 jatis) ///
(rbar scontrib2 scontrib3 jatis) ///
(rbar scontrib3 scontrib4 jatis) ///
(rbar scontrib4 scontrib5 jatis) ///
(rbar scontrib5 scontrib6 jatis) ///
(function y=14.2857, range(0 10) lcolor(black) lpattern(dash)) ///
(function y=28.5714, range(0 10) lcolor(black) lpattern(dash)) ///
(function y=42.8571, range(0 10) lcolor(black) lpattern(dash)) ///
(function y=57.1429, range(0 10) lcolor(black) lpattern(dash)) ///
(function y=71.4286, range(0 10) lcolor(black) lpattern(dash)) ///
(function y=85.7143, range(0 10) lcolor(black) lpattern(dash)) ///
, xlabel(1/10, valuelabel angle(45)) xtitle("") ///
ylabel(0(20)100) ytitle("Per cent") ///
legend(order(1 "Elec" 2 "Water" 3 "Sanit" 4 "Hous" 5 "Cook" 6 "Assets" 7 "Bank") pos(6) col(3)) ///
title("Contribution to the std liv dimension", size(small)) ///
name(stdliv, replace)
drop alt_contrib_i6 alt_contrib_i7 alt_contrib_i8 alt_contrib_i9 alt_contrib_i10 alt_contrib_i11 alt_contrib_i12
drop scontrib1 scontrib2 scontrib3 scontrib4 scontrib5 scontrib6
drop contribtot

* 
graph combine mpi h dim health educ stdliv, note("{it: Note:} Statistics for the 10 detailed caste groups with the largest populations amongst castes with the lowest multidimensional poverty index.", size(vsmall))
graph export "graph/det_lowest.png", as(png) replace

****************************************
* END




















****************************************
* Graph jatis prepa
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








/*
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












****************************************
* Stat nation by caste
****************************************
use"Indiv_mpi.dta", clear

drop if head_jatis==1
drop if head_jatis==.
drop if head_jatis==1895
rename mpi_cens12 depriv
rename d_mpoor12 poor

* Weighted score
gen depriv_wgt=depriv*wgt
gen depriv2_wgt=depriv^2*wgt
gen wgt_poor=wgt*poor


* Collapse
collapse (sum) depriv_wgt depriv2_wgt wgt wgt_poor (count) n_indiv=depriv (sum) n_poor = poor, by(head_caste)

* MPI
gen mpi=depriv_wgt/wgt

* H
gen H=wgt_poor/wgt

* A
gen A=depriv_wgt/wgt_poor if wgt_poor>0

****************************************
* END















****************************************
* Stat nation by caste and jatis
****************************************
use"Indiv_mpi.dta", clear

drop if head_jatis==1
drop if head_jatis==.
drop if head_jatis==1895
rename mpi_cens12 depriv
rename d_mpoor12 poor

* Weighted score
gen depriv_wgt=depriv*wgt
gen depriv2_wgt=depriv^2*wgt
gen wgt_poor=wgt*poor

* MPI by caste
bysort head_caste: egen sum_wgt_caste=total(wgt)
bysort head_caste: egen sum_depriv_caste=total(depriv_wgt)
gen mpi_caste=sum_depriv_caste/sum_wgt_caste

* Collapse
collapse (sum) depriv_wgt depriv2_wgt wgt wgt_poor (count) n_indiv=depriv (sum) n_poor = poor (mean) mpi_caste, by(head_jatis head_caste)

* MPI
gen mpi=depriv_wgt/wgt

* H
gen H=wgt_poor/wgt

* A
gen A=depriv_wgt/wgt_poor if wgt_poor>0


***** Graph
keep if n_indiv>50

*** Box maison
bys head_caste: egen med=median(mpi)
bys head_caste: egen lqt=pctile(mpi), p(25)
bys head_caste: egen uqt=pctile(mpi), p(75)
bys head_caste: egen iqr=iqr(mpi)
gen l=mpi if mpi>=lqt-1.5*iqr
bys head_caste: egen ls=min(l)
gen u=mpi if mpi<=uqt+1.5*iqr
bys head_caste: egen us=max(u)
*
bysort head_caste: keep if _n==1
*
twoway ///
(rbar med uqt head_caste, horizontal fcolor(gs15) lcolor(gs4) barw(.2)) ///
(rbar lqt med head_caste, horizontal fcolor(gs15) lcolor(gs4) barw(.2)) ///
(rspike ls lqt head_caste, horizontal lcolor(gs4) lwidth(thin)) ///
(rspike uqt us head_caste, horizontal lcolor(gs4) lwidth(thin)) ///
(rcap ls ls head_caste, horizontal lcolor(gs4) lwidth(thin) msize(*1.5)) ///
(rcap us us head_caste, horizontal lcolor(gs4) lwidth(thin) msize(*1.5)) ///
(scatter head_caste mpi_caste, msymbol(X) msize(*1) mcolor(black)) ///
, ///
legend(off) ///
ylabel(1/4, valuelabel angle(0) nogrid notick) xlabel(0(.1).5) ///
xtitle("Multidimensional poverty index") ///
ytitle("") ///
scale(1.1) name(rel_h, replace) ///
note("{it:Note:} For detailed caste groups comprising more than 50 individuals. Detailed caste groups are not" "weighted: each caste, regardless of its population size, counts as one statistical individual.", size(vsmall))
graph export "graph/box_caste.png", as(png) replace

****************************************
* END















****************************************
* Stat nation by jatis
****************************************
use"Indiv_mpi.dta", clear

drop if head_jatis==1
drop if head_jatis==.
drop if head_jatis==1895
rename mpi_cens12 depriv
rename d_mpoor12 poor

* Weighted score
gen depriv_wgt=depriv*wgt
gen depriv2_wgt=depriv^2*wgt
gen wgt_poor=wgt*poor

* Collapse
collapse (sum) depriv_wgt depriv2_wgt wgt wgt_poor (count) n_indiv=depriv (sum) n_poor = poor, by(head_jatis)

* MPI
gen mpi=depriv_wgt/wgt

* H
gen H=wgt_poor/wgt

* A
gen A=depriv_wgt/wgt_poor if wgt_poor>0

* Test
gen _test=mpi-(H*A)
tabstat _test, stat(mean min max)
drop _test

* Variance des scores parmi les pauvres
gen var_poor=depriv2_wgt/wgt_poor-A^2 if wgt_poor>0

* Variance total
gen double var_all=depriv2_wgt/wgt-mpi^2


***** Graph
keep if n_indiv>50

*** Bar with MPI
cumul mpi, gen(cmpi)
*
twoway ///
(line cmpi mpi, sort lcolor(gs4)) ///
, xtitle("Multidimensional poverty index") xlabel(0(.1).6) ///
ytitle("Cumulative per cent of detailed caste groups") ylabel(0(.1)1) ///
scale(1.1) name(cdf, replace) ///
note("{it:Note:} For detailed caste groups comprising more than 50 individuals. Detailed caste groups are not" "weighted: each caste, regardless of its population size, counts as one statistical individual.", size(vsmall))
graph export "graph/cdf_jatis.png", as(png) replace


*** MPI x Variance parmi les pauvres 
* (Figure 11) https://hdr.undp.org/system/files/documents/mpi2019publication.pdf
twoway ///
(scatter var_poor mpi, msymbol(oh) mcolor(black%80)) ///
(qfit var_poor mpi, lcolor(gs12)) ///
, xlabel(0(.1).6) xtitle("Multidimensional poverty index") ///
ytitle("Inequality among multidimensionally poor people" "(variance of deprivation scores)") legend(off) ///
scale(1.1) name(fig11, replace) ///
note("{it:Note:} For detailed caste groups comprising more than 50 individuals. Detailed caste groups are not" "weighted: each caste, regardless of its population size, counts as one statistical individual.", size(vsmall))
graph export "graph/mpixvar_jatis.png", as(png) replace


*** A x H
twoway ///
(scatter A H, msymbol(oh) mcolor(black%80)) ///
(function y=0.05/x, range(0.05 .2) lcolor(gs12) lpattern(dash)) ///
(function y=0.10/x, range(0.10 .5) lcolor(gs12) lpattern(dash)) ///
(function y=0.20/x, range(0.20 1) lcolor(gs12) lpattern(dash)) ///
(function y=0.30/x, range(0.30 1) lcolor(gs12) lpattern(dash)) ///
, xlabel(0(.1)1) xtitle("Multidimensional poverty headcount (H)") ///
ytitle("Average deprivation intensity among the poor (A)") ///
legend(off) ///
scale(1.1) name(axh, replace) ///
note("{it:Note:} For detailed caste groups comprising more than 50 individuals. Detailed caste groups are not" "weighted: each caste, regardless of its population size, counts as one statistical individual.", size(vsmall))
graph export "graph/hxa_jatis.png", as(png) replace


***** Details for jatis with the highest MPI
preserve
ta mpi
keep if mpi>.4
sort wgt
tostring head_jatis, gen(_st)
list head_jatis _st n_indiv, noobs
restore
/*
Les 10 plus grosses jatis parmi les jatis qui ont un MPI>.4 (2.7% des jatis ont un MPI>.4 i.e. 28 jatis)
KABARIYA	692
PAHARIA		1419
KORWA		948
MANKAR		1158
GANJHU		506
GARASIA		507
SAHARIYA	1633
THAKORE		1851
KULHAIYA	997
MUSAHAR		1298
*/


***** Details for jatis with the lowest MPI
preserve
keep if mpi<.01
sort wgt
tostring head_jatis, gen(_st)
list head_jatis _st n_indiv, noobs

keep if mpi==0
sort wgt
tostring head_jatis, gen(_st)
list head_jatis _st n_indiv, noobs
restore
/*

57 jatis ont un MPI<.01 mais sup à 0
63 jatis ont un MPI==0

Parmi les jatis avec un MPI<.01 mais sup à 0, voici les 10 plus grosses : 
MARWARI				1187
NADAR (CHRISTIAN)	1304
JAIN VARIA			656
KOMATI				924
SENGUNTHAR			1700
LABBAI				1033
R/L CATHOLICS		1543
NAIR				1329
JAT (SIKH)			668
EZHAVA				461



Parmi les jatis avec un MPI==0, voici les trois plus grosses : 
CHIMBA				358	
MAPPILA				1167	
SYRIAN	CHRISTIANS	1808
*/


****************************************
* END











/*
****************************************
* Details for certains jatis
****************************************

********** Highest MPI
use"Indiv_mpi.dta", clear

gen highest=0
replace highest=1 if head_jatis==948
replace highest=1 if head_jatis==1158
replace highest=1 if head_jatis==1419
replace highest=1 if head_jatis==1851
replace highest=1 if head_jatis==507
replace highest=1 if head_jatis==506
replace highest=1 if head_jatis==997
replace highest=1 if head_jatis==1633
replace highest=1 if head_jatis==1298
replace highest=1 if head_jatis==692

preserve
*keep if highest==1
keep if head_jatis==692
mpi ///
d1(d_cm d_nutr d_anc) w1(0.08333 0.1667 0.08333) ///
d2(d_satt d_educ) w2(0.1667 0.1667) ///
d3(d_elct d_wtr d_sani d_hsg d_ckfl d_asst d_bank) w3(0.04762 0.04762 0.04762 0.04762 0.04762 0.04762 0.04762) ///
[pw=wgt], cutoff(0.33) by(head_jatis)
matlist e(by_ind)
putexcel set "_jatis.xlsx", replace
putexcel A1=matrix(e(by_ind)), names
restore


********** Lowest MPI
use"Indiv_mpi.dta", clear

gen lowest=0
replace lowest=1 if head_jatis==1187
replace lowest=1 if head_jatis==1304
replace lowest=1 if head_jatis==656
replace lowest=1 if head_jatis==924
replace lowest=1 if head_jatis==1700
replace lowest=1 if head_jatis==1033
replace lowest=1 if head_jatis==1543
replace lowest=1 if head_jatis==1329
replace lowest=1 if head_jatis==668
replace lowest=1 if head_jatis==461

keep if lowest==1
mpi ///
d1(d_cm d_nutr d_anc) w1(0.08333 0.1667 0.08333) ///
d2(d_satt d_educ) w2(0.1667 0.1667) ///
d3(d_elct d_wtr d_sani d_hsg d_ckfl d_asst d_bank) w3(0.04762 0.04762 0.04762 0.04762 0.04762 0.04762 0.04762) ///
[pw=wgt], cutoff(0.33) by(head_jatis)
matlist e(by_ind)
putexcel set "_jatis.xlsx", replace
putexcel A1=matrix(e(by_ind)), names
restore



********** Jatis with the highest n
use"Indiv_mpi.dta", clear

drop if head_jatis==1
drop if head_jatis==.
drop if head_jatis==1895

bys head_jatis: gen n=_N
*ta n
keep if n>=37744
ta head_jatis

mpi ///
d1(d_cm d_nutr d_anc) w1(0.08333 0.1667 0.08333) ///
d2(d_satt d_educ) w2(0.1667 0.1667) ///
d3(d_elct d_wtr d_sani d_hsg d_ckfl d_asst d_bank) w3(0.04762 0.04762 0.04762 0.04762 0.04762 0.04762 0.04762) ///
[pw=wgt], cutoff(0.33) by(head_jatis)
matlist e(by_ind)
putexcel set "_jatis.xlsx", replace
putexcel A1=matrix(e(by_ind)), names

****************************************
* END
*/





/*
****************************************
* Share tot
****************************************
use"Indiv_mpi.dta", clear

drop if head_jatis==1
drop if head_jatis==.
drop if head_jatis==1895

ta head_jatis [aw=wgt]

gen lowest=0
replace lowest=1 if head_jatis==1187
replace lowest=1 if head_jatis==1304
replace lowest=1 if head_jatis==656
replace lowest=1 if head_jatis==924
replace lowest=1 if head_jatis==1700
replace lowest=1 if head_jatis==1033
replace lowest=1 if head_jatis==1543
replace lowest=1 if head_jatis==1329
replace lowest=1 if head_jatis==668
replace lowest=1 if head_jatis==461

gen highest=0
replace highest=1 if head_jatis==948
replace highest=1 if head_jatis==1158
replace highest=1 if head_jatis==1419
replace highest=1 if head_jatis==1851
replace highest=1 if head_jatis==507
replace highest=1 if head_jatis==506
replace highest=1 if head_jatis==997
replace highest=1 if head_jatis==1633
replace highest=1 if head_jatis==1298
replace highest=1 if head_jatis==692

gen numerous=0
replace numerous=1 if head_jatis==292
replace numerous=1 if head_jatis==316
replace numerous=1 if head_jatis==556
replace numerous=1 if head_jatis==666
replace numerous=1 if head_jatis==1004
replace numerous=1 if head_jatis==1386
replace numerous=1 if head_jatis==1563
replace numerous=1 if head_jatis==1707
replace numerous=1 if head_jatis==1840
replace numerous=1 if head_jatis==1988

collapse (sum) wgt (mean) lowest highest numerous, by(head_jatis)

egen sum_wgt=sum(wgt)
gen share_wgt=wgt*100/sum_wgt

list head_jatis share_wgt if lowest==1
list head_jatis share_wgt if highest==1
list head_jatis share_wgt if numerous==1


****************************************
* END
*/









****************************************
* Stat by states
****************************************
use"Indiv_mpi.dta", clear

drop if head_jatis==1
drop if head_jatis==.
drop if head_jatis==1895
rename mpi_cens12 depriv
rename d_mpoor12 poor

* Weighted score
gen depriv_wgt=depriv*wgt
gen depriv2_wgt=depriv^2*wgt
gen wgt_poor=wgt*poor

* MPI by state
bysort loc_state: egen sum_wgt_state=total(wgt)
bysort loc_state: egen sum_depriv_state=total(depriv_wgt)
gen mpi_state=sum_depriv_state/sum_wgt_state

* Collapse
collapse (sum) depriv_wgt depriv2_wgt wgt wgt_poor (count) n_indiv=depriv (sum) n_poor = poor (mean) mpi_state, by(loc_state head_jatis)

* MPI
gen mpi=depriv_wgt/wgt

* H
gen H=wgt_poor/wgt

* A
gen A=depriv_wgt/wgt_poor if wgt_poor>0

***** Graph
drop if n_indiv<50

*** Box maison
bys loc_state: egen med=median(mpi)
bys loc_state: egen lqt=pctile(mpi), p(25)
bys loc_state: egen uqt=pctile(mpi), p(75)
bys loc_state: egen iqr=iqr(mpi)
gen l=mpi if mpi>=lqt-1.5*iqr
bys loc_state: egen ls=min(l)
gen u=mpi if mpi<=uqt+1.5*iqr
bys loc_state: egen us=max(u)
*
egen ordre=group(mpi_state loc_state)
egen ordre_max=max(ordre)
gen position=ordre_max+1-ordre
local vl : value label loc_state
capture label drop states_order
levelsof loc_state, local(states)
foreach s of local states {
    quietly summarize position if loc_state == `s', meanonly
    local p = r(min)
    local nom : label `vl' `s'
    label define states_order `p' `"`nom'"', add
}
label values position states_order
*
bysort loc_state: keep if _n==1
*
twoway ///
(rbar med uqt position, horizontal fcolor(gs15) lcolor(gs4) barw(.35)) ///
(rbar lqt med position, horizontal fcolor(gs15) lcolor(gs4) barw(.35)) ///
(rspike ls lqt position, horizontal lcolor(gs4) lwidth(vthin)) ///
(rspike uqt us position, horizontal lcolor(gs4) lwidth(vthin)) ///
(rcap ls ls position, horizontal lcolor(gs4) lwidth(vthin) msize(*1)) ///
(rcap us us position, horizontal lcolor(gs4) lwidth(vthin) msize(*1)) ///
(scatter position mpi_state, msymbol(X) msize(*1) mcolor(black)) ///
, ///
legend(off) ///
ylabel(1/35, valuelabel angle(0) nogrid notick) xlabel(0(.1).6) ///
xtitle("Multidimensional poverty index") ///
ytitle("") ///
note("{it:Note:} For detailed caste groups comprising more than 50 individuals. Detailed caste groups are not" "weighted: each caste, regardless of its population size, counts as one statistical individual.", size(vsmall)) ///
name(rel_h, replace)
graph export "graph/state_mpi.png", as(png) replace

****************************************
* END







