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




********** By jatis
preserve
keep if jatis5000==1
*
mpi ///
d1(d_cm d_nutr d_anc) w1(0.08333 0.1667 0.08333) ///
d2(d_satt d_educ) w2(0.1667 0.1667) ///
d3(d_elct d_wtr d_sani d_hsg d_ckfl d_asst d_bank) w3(0.04762 0.04762 0.04762 0.04762 0.04762 0.04762 0.04762) ///
[pw=wgt], cutoff(0.33) by(head_jatis)
*matlist e(by_mpi)
*putexcel set "_jatis.xlsx", replace
*putexcel A1=matrix(e(by_mpi)), names

*matlist e(by_dom)
*putexcel set "_jatis.xlsx", replace
*putexcel A1=matrix(e(by_dom)), names

matlist e(by_ind)
putexcel set "_jatis.xlsx", replace
putexcel A1=matrix(e(by_ind)), names

restore


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
encode jatis, gen(jatis_enc)
drop jatis
rename jatis_enc jatis
order jatis, first
*
replace m0=m0/100

*
save"data_jatis.dta", replace


****************************************
* END












****************************************
* Graph jatis
****************************************
use"data_jatis", clear

set scheme white_tableau


********** H
graph bar h, over(jatis, sort(1) descending label(angle(45))) ///
ytitle("H") ///
title("Headcount ratio (H) by Jatis") ///
note("Source: NFHS-4 (2015-2016); author's calculcations.", size(vsmall))
graph export "graph/jatis_headcount.png", as(png) replace





********** MPI
graph bar m0, over(jatis, sort(1) descending label(angle(45))) ///
ytitle("MPI") ///
title("Multidimensional poverty index (MPI) by Jatis") ///
note("Source: NFHS-4 (2015-2016); author's calculcations.", size(vsmall))
graph export "graph/jatis_mpi.png", as(png) replace




********** Contribution of dimensions
gen scontrib1=contrib_d1+contrib_d2
gen scontrib2=scontrib1+contrib_d3
*
twoway ///
(bar contrib_d1 jatis) ///
(rbar contrib_d1 scontrib1 jatis) ///
(rbar scontrib1 scontrib2 jatis) ///
(function y=33, range(0 20) lcolor(black) lpattern(dash)) ///
(function y=66, range(0 20) lcolor(black) lpattern(dash)) ///
, xlabel(1/20, valuelabel angle(45)) xtitle("") ///
ylabel(0(20)100) ytitle("Percent") ///
legend(order(1 "Health" 2 "Education" 3 "Standard of living") pos(6) col(3)) ///
title("Contribution of the dimensions to the MPI by Jatis") ///
note("Source: NFHS-4 (2015-2016); author's calculcations.", size(vsmall)) ///
name(dim, replace)
graph export "graph/jatis_contribdim.png", as(png) replace
drop scontrib1 scontrib2




********** Contribution of indic for health
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
(function y=25, range(0 20) lcolor(black) lpattern(dash)) ///
(function y=75, range(0 20) lcolor(black) lpattern(dash)) ///
, xlabel(1/20, valuelabel angle(45)) xtitle("") ///
ylabel(0(20)100) ytitle("Percent") ///
legend(order(1 "Child mortality" 2 "Nutrition" 3 "Maternal health") pos(6) col(3)) ///
title("Contribution of the indicators to health dimension by Jatis") ///
note("Source: NFHS-4 (2015-2016); author's calculcations.", size(vsmall)) ///
name(health, replace)
graph export "graph/jatis_contrib_health.png", as(png) replace
drop alt_contrib_i1 alt_contrib_i2 alt_contrib_i3
drop scontrib1 scontrib2
drop contribtot





********** Contribution of indic for education
gen contribtot=contrib_i4+contrib_i5
forvalues i=4/5 {
gen alt_contrib_i`i'=100*(contrib_i`i'/contribtot)
}
gen scontrib1=alt_contrib_i4+alt_contrib_i5
*
twoway ///
(bar alt_contrib_i4 jatis) ///
(rbar alt_contrib_i4 scontrib1 jatis) ///
(function y=50, range(0 20) lcolor(black) lpattern(dash)) ///
, xlabel(1/20, valuelabel angle(45)) xtitle("") ///
ylabel(0(20)100) ytitle("Percent") ///
legend(order(1 "School attendance" 2 "Years of schooling") pos(6) col(2)) ///
title("Contribution of the indicators to education dimension by Jatis") ///
note("Source: NFHS-4 (2015-2016); author's calculcations.", size(vsmall)) ///
name(educ, replace)
graph export "graph/jatis_contrib_educ.png", as(png) replace
drop alt_contrib_i4 alt_contrib_i5
drop scontrib1
drop contribtot




********** Contribution of indic for std liv
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
(function y=14.2857, range(0 20) lcolor(black) lpattern(dash)) ///
(function y=28.5714, range(0 20) lcolor(black) lpattern(dash)) ///
(function y=42.8571, range(0 20) lcolor(black) lpattern(dash)) ///
(function y=57.1429, range(0 20) lcolor(black) lpattern(dash)) ///
(function y=71.4286, range(0 20) lcolor(black) lpattern(dash)) ///
(function y=85.7143, range(0 20) lcolor(black) lpattern(dash)) ///
, xlabel(1/20, valuelabel angle(45)) xtitle("") ///
ylabel(0(20)100) ytitle("Percent") ///
legend(order(1 "Electricity" 2 "Water" 3 "Sanitation" 4 "Housing" 5 "Cooking fuel" 6 "Assets" 7 "Bank account") pos(6) col(4)) ///
title("Contribution of the indicators to std of living dimension by Jatis") ///
note("Source: NFHS-4 (2015-2016); author's calculcations.", size(vsmall)) ///
name(stdliv, replace)
graph export "graph/jatis_contrib_stdliv.png", as(png) replace
drop alt_contrib_i6 alt_contrib_i7 alt_contrib_i8 alt_contrib_i9 alt_contrib_i10 alt_contrib_i11 alt_contrib_i12
drop scontrib1 scontrib2 scontrib3 scontrib4 scontrib5 scontrib6
drop contribtot


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
ylabel(0(20)100) ytitle("Percent") ///
legend(order(1 "Health" 2 "Education" 3 "Standard of living") pos(6) col(3)) ///
title("Contribution of the dimensions to the MPI by State") ///
note("Source: NFHS-4 (2015-2016); author's calculcations.", size(vsmall)) ///
name(dim, replace)
graph export "graph/state_contribdim.png", as(png) replace
drop scontrib1 scontrib2

****************************************
* END









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
* Boxplot
****************************************

********** MPI by caste
use"Indiv_mpi.dta", clear
* Weighted score
gen mpi_cens12_wgt=mpi_cens12*wgt
* Collapse
collapse (sum) mpi_cens12_wgt wgt (count) n_indiv=mpi_cens12, by(head_caste)
* MPI
gen mpi_caste=mpi_cens12_wgt/wgt

*
preserve
keep if n_indiv>1000
graph bar mpi_caste, over(head_caste, sort(1))
restore





********** MPI by jatis
use"Indiv_mpi.dta", clear

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


* MPI par jatis
gen mpi_jatis=depriv_wgt/wgt

* Score moyen parmi les pauvres (intensité A)
gen A_jatis=depriv_wgt/wgt_poor if wgt_poor>0

* Variance des scores parmi les pauvres
gen var_poor=depriv2_wgt/wgt_poor-A_jatis^2 if wgt_poor>0

* Variance total
gen double var_all=depriv2_wgt/wgt-mpi_jatis^2

* Scatter : Figure 11 : MPI x Variance parmi les pauvres https://hdr.undp.org/system/files/documents/mpi2019publication.pdf
keep if n_poor>100
twoway (scatter var_poor mpi_jatis)

* Bar
preserve
keep if n_indiv>1000
graph bar mpi_jatis, over(head_jatis, sort(1))
restore

* Box
preserve
drop if n_indiv<100
graph hbox mpi_jatis, noout
restore

tabstat mpi_jatis, stat(p10 p25 p75 p90)


********** MPI by jatis and state
use"Indiv_mpi.dta", clear

drop if head_jatis==.
drop if head_jatis==1895
rename mpi_cens12 depriv

* Weighted score
gen depriv_wgt=depriv*wgt

* Collapse
collapse (sum) depriv_wgt wgt (count) n_indiv=depriv, by(loc_state head_jatis)

* MPI jatis state
gen mpi_jatis_state=depriv_wgt/wgt

* MPI state
bysort loc_state: egen sum_wgt=total(wgt)
bysort loc_state: egen sum_mpi_wgt=total(depriv_wgt)
gen mpi_state=sum_mpi_wgt/sum_wgt

* Part pop jatis
gen pop_share=wgt/sum_wgt


* Variance
gen contribution=pop_share*(mpi_jatis_state-mpi_state)^2
bysort loc_state: egen var_between=total(contribution)

* SD
gen sd_between=sqrt(var_between)

* CV
gen cv_between=sd_between/mpi_state if mpi_state>0

* Res
preserve
bysort loc_state: keep if _n == 1
list loc_state mpi_state sd_between cv_between, noobs
restore


*** Boxplot
preserve
drop if n_indiv<100
graph hbox mpi_jatis_state, over(loc_state, sort(1)) noout
restore

*** Scatter
drop if n_indiv<100
twoway (scatter cv_jatis_state mpi_jatis_state)


****************************************
* END







