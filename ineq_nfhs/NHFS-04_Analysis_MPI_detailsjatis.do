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













