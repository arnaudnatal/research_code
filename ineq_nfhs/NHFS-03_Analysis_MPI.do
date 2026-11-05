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








/*
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
*/








/*
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
*/










/*
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
*/











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










****************************************
* Stat by states: boxplot
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





















****************************************
* Stat by states: CV
****************************************
use"Indiv_mpi.dta", clear

*
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

* CV 
drop if head_jatis==1
drop if head_jatis==.
drop if head_jatis==1895


bysort loc_state: egen w_jatis=total(wgt)
gen mpi_wgt=mpi*wgt
bysort loc_state: egen mpi_sum=total(mpi_wgt)
gen mpi_retained=mpi_sum/w_jatis
gen var_contrib=(wgt/w_jatis)*(mpi-mpi_retained)^2
bysort loc_state: egen var_jatis=total(var_contrib)
gen sd_jatis_wgt=sqrt(var_jatis)
gen cv_jatis_wgt=sd_jatis_wgt/mpi_retained if mpi_retained>0

bysort loc_state: keep if _n == 1
list loc_state mpi_state mpi_retained sd_jatis_wgt cv_jatis_wgt, noobs

keep loc_state mpi_state mpi_retained sd_jatis_wgt cv_jatis_wgt
duplicates drop

****************************************
* END








