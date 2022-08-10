*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*June 14, 2022
*-----
gl link = "evodebt"
*Matching demonetisation
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------














****************************************
* Demonetisation database preparation
****************************************
cls
use "panel_v4", clear

********** 2016-17
keep if year==2016


********** recode
***** sex
fre head_sex
recode head_sex (1=0) (2=1)
rename head_sex head_female
label define sex2 0"Male" 1"Female"
label values head_female sex2

fre wifehusb_sex
recode wifehusb_sex (1=0) (2=1)
rename wifehusb_sex wifehusb_female
label values wifehusb_female sex2

fre head_female wifehusb_female

***** occupation
fre head_occupation
recode head_occupation (5=4)

fre wifehusb_occupation
recode wifehusb_occupation (5=4)

***** education
fre head_edulevel
recode head_edulevel (3=2) (4=2) (5=2)

fre wifehusb_edulevel
recode wifehusb_edulevel (3=2) (4=2) (5=2)

***** marital status
fre head_maritalstatus
label define marital 1"Married" 2"Unmarried" 3"Widowed" 4"Separated/divorced"
label values head_maritalstatus marital
label values wifehusb_maritalstatus marital

fre head_maritalstatus
recode head_maritalstatus (2=0) (3=0) (4=0)

fre wifehusb_maritalstatus
recode wifehusb_maritalstatus (2=0) (3=0) (4=0)

rename head_maritalstatus head_married
rename wifehusb_maritalstatus wifehusb_married

***** house
fre housetype housetitle
label define housetype 1"Concrete house (non-govt)" 2"Government/green house" 3"Thatched roof house"
label values housetype housetype


***** villagearea
gen village_ur=.
replace village_ur=0 if villagearea=="Colony"
replace village_ur=1 if villagearea=="Ur"

***** vuln
gen static_vuln=.
replace static_vuln=0 if DSR<40 | DAR_without<50
replace static_vuln=1 if DSR>=40 | DAR_without>=50



********** var to keep
global id HHID_panel dummydemonetisation
global wealth assets_noland annualincome
global hhcharact HHsize nbchildren dummymarriage villageid village_ur caste jatis ownland nontoworkers femtomale housetype housetitle
global headwife head_* wifehusb_* 
global debt1 DSR DIR DSR30 DSR40 DSR50 ISR DAR_without loanamount static_vuln
global debt2 rel_repay_amt_HH rel_formal_HH rel_informal_HH rel_eco_HH rel_current_HH rel_humank_HH rel_social_HH rel_home_HH
global debt3 dummyIMF dummybank dummymoneylender dummyrepay dummyborrowstrat dummymigrstrat dummyassestrat

global var $id $wealth $hhcharact $headwife $debt1 $debt2 $debt3
keep $var 


********** cat to dummy
foreach x in villageid caste jatis housetype head_edulevel head_occupation wifehusb_edulevel wifehusb_occupation {
ta `x', gen(`x'_)
}

********** rename
rename dummydemonetisation treat 

saveold "N1_CBPS.dta", version(12) replace
****************************************
* END







/*
****************************************
* ADSM graph
****************************************
cls
use "adsm_n1_r.dta", clear

replace balanced=balanced*100
replace original=original*100

gen la=""
replace la="ORA" if covariate=="villageid_9"
replace la="SEM" if covariate=="villageid_10"

egen labpos=mlabvpos(balanced original)
replace labpos=11 if la=="ORA"
replace labpos=12 if la=="SEM"

*twoway ///
*(scatter balanced original, mlab(la) mlabvpos(labpos) yline(20) xline(20)) ///
*(function y=x, range(0 20) lpattern(shortdash) lcolor(gs8)), ///
*xlabel(0(10)60) xmtick(0(5)65) xtitle("ADSM before weighting (%)") ///
*ylabel(0(5)35) ymtick(0(2.5)35) ytitle("ADSM after weighting (%)") ///
*legend(off) name(adsm, replace)


twoway ///
(scatter balanced original, xline(20)) ///
(function y=x, range(0 10) lpattern(shortdash) lcolor(gs8)), ///
xlabel(0(10)60) xmtick(0(5)65) xtitle("ADSM before weighting (%)") ///
ylabel(0(5)10) ymtick(0(2.5)10) ytitle("ADSM after weighting (%)") ///
title("Demonetisation") ///
legend(off) name(adsm1, replace)

graph export "ADSM_demo.pdf", as(pdf) replace
graph save "ADSM_demo.gph", replace

****************************************
* END
*/












****************************************
* Mean test
****************************************
cls
use "neemsis1_r.dta", clear

global var head_age head_female head_married head_edulevel_2 head_edulevel_3 head_occupation_2 head_occupation_3 head_occupation_4 head_occupation_5 head_occupation_6 head_occupation_7 caste_2 caste_3 annualincome assets_noland HHsize nbchildren housetype_2 housetype_3 ownland villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10


********** Mean diff before weighting
local i=0
foreach x in $var {
local i=`i'+1
reg `x' treat
est store reg_`i'
}
estimates dir

***** Only constant
qui esttab reg_1 reg_2 reg_3 reg_4 reg_5 reg_6 reg_7 reg_8 reg_9 reg_10 reg_11 reg_12 reg_13 reg_14 reg_15 reg_16 reg_17 reg_18 reg_19 reg_20 reg_21 reg_22 reg_23 reg_24 reg_25 reg_26 reg_27 reg_28 reg_29, replace ///
	label b(3) p(3) eqlabels(none) ///
	drop(treat) ///
	cells("b(fmt(2))") ///
	refcat(, nolabel)
mat list r(coefs) 
mat rename r(coefs) tsp, replace
mat list tsp
qui esttab matrix(tsp, transpose), replace	///
	label b(3) p(3) eqlabels(none) 
mat list r(coefs)
mat rename r(coefs) cons, replace

***** Only treatment
qui esttab reg_1 reg_2 reg_3 reg_4 reg_5 reg_6 reg_7 reg_8 reg_9 reg_10 reg_11 reg_12 reg_13 reg_14 reg_15 reg_16 reg_17 reg_18 reg_19 reg_20 reg_21 reg_22 reg_23 reg_24 reg_25 reg_26 reg_27 reg_28 reg_29, replace ///
	label b(3) p(3) eqlabels(none) ///
	drop(_cons) ///
	cells("b(fmt(2))") ///
	refcat(, nolabel)
mat list r(coefs) 
mat rename r(coefs) tsp, replace
mat list tsp
qui esttab matrix(tsp, transpose), replace	///
	label b(3) p(3) eqlabels(none)
mat list r(coefs)
mat rename r(coefs) diff, replace

***** Only t-stat
qui esttab reg_1 reg_2 reg_3 reg_4 reg_5 reg_6 reg_7 reg_8 reg_9 reg_10 reg_11 reg_12 reg_13 reg_14 reg_15 reg_16 reg_17 reg_18 reg_19 reg_20 reg_21 reg_22 reg_23 reg_24 reg_25 reg_26 reg_27 reg_28 reg_29, replace ///
	label b(3) p(3) eqlabels(none) ///
	drop(_cons) ///
	cells("t(fmt(2))") ///
	refcat(, nolabel)
mat list r(coefs) 
mat rename r(coefs) tsp, replace
mat list tsp
qui esttab matrix(tsp, transpose), replace	///
	label b(3) p(3) eqlabels(none)
mat list r(coefs)
mat rename r(coefs) tstat, replace

***** Combine
matrix before=cons,diff,tstat






********** Mean diff after weighting
local i=0
foreach x in $var {
local i=`i'+1
reg `x' treat [pw=weights]
est store reg_`i'
}

***** Only constant
qui esttab reg_1 reg_2 reg_3 reg_4 reg_5 reg_6 reg_7 reg_8 reg_9 reg_10 reg_11 reg_12 reg_13 reg_14 reg_15 reg_16 reg_17 reg_18 reg_19 reg_20 reg_21 reg_22 reg_23 reg_24 reg_25 reg_26 reg_27 reg_28 reg_29, replace ///
	label b(3) p(3) eqlabels(none) ///
	drop(treat) ///
	cells("b(fmt(2))") ///
	refcat(, nolabel)
mat list r(coefs) 
mat rename r(coefs) tsp, replace
mat list tsp
qui esttab matrix(tsp, transpose), replace	///
	label b(3) p(3) eqlabels(none) 
mat list r(coefs)
mat rename r(coefs) cons, replace

***** Only treatment
qui esttab reg_1 reg_2 reg_3 reg_4 reg_5 reg_6 reg_7 reg_8 reg_9 reg_10 reg_11 reg_12 reg_13 reg_14 reg_15 reg_16 reg_17 reg_18 reg_19 reg_20 reg_21 reg_22 reg_23 reg_24 reg_25 reg_26 reg_27 reg_28 reg_29, replace ///
	label b(3) p(3) eqlabels(none) ///
	drop(_cons) ///
	cells("b(fmt(2))") ///
	refcat(, nolabel)
mat list r(coefs) 
mat rename r(coefs) tsp, replace
mat list tsp
qui esttab matrix(tsp, transpose), replace	///
	label b(3) p(3) eqlabels(none)
mat list r(coefs)
mat rename r(coefs) diff, replace

***** Only t-stat
qui esttab reg_1 reg_2 reg_3 reg_4 reg_5 reg_6 reg_7 reg_8 reg_9 reg_10 reg_11 reg_12 reg_13 reg_14 reg_15 reg_16 reg_17 reg_18 reg_19 reg_20 reg_21 reg_22 reg_23 reg_24 reg_25 reg_26 reg_27 reg_28 reg_29, replace ///
	label b(3) p(3) eqlabels(none) ///
	drop(_cons) ///
	cells("t(fmt(2))") ///
	refcat(, nolabel)
mat list r(coefs) 
mat rename r(coefs) tsp, replace
mat list tsp
qui esttab matrix(tsp, transpose), replace	///
	label b(3) p(3) eqlabels(none)
mat list r(coefs)
mat rename r(coefs) tstat, replace

***** Combine
matrix after=cons,diff,tstat





********** Before and after
matrix tot=before,after
matrix list tot

****************************************
* END


















****************************************
* Reg weight
****************************************
cls
use "neemsis1_r.dta", clear

global var head_age head_female head_married head_edulevel_2 head_edulevel_3 head_occupation_2 head_occupation_3 head_occupation_4 head_occupation_5 head_occupation_6 head_occupation_7 caste_2 caste_3 annualincome assets_noland HHsize nbchildren housetype_2 housetype_3 ownland villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10

***** Label
/*
label var treat "Demonetisation (T=1)"
label var age "Age"
label var caste_2 "Caste: Middle"
label var caste_3 "Caste: Upper"
label var sex_2 "Sex: Female"
label var mainocc_occupation_indiv_1 "Occ: No occupation"
label var mainocc_occupation_indiv_2 "Occ: Agri SE"
label var mainocc_occupation_indiv_4 "Occ: Non-agri casual"
label var mainocc_occupation_indiv_5 "Occ: Non-agri regular non-qualified"
label var mainocc_occupation_indiv_6 "Occ: Non-agri regular qualified"
label var mainocc_occupation_indiv_7 "Occ: Non-agri SE"
label var mainocc_occupation_indiv_8 "Occ: NREGA"
label var edulevel_2 "Edu: Primary completed"
label var edulevel_3 "Edu: High-School"
label var edulevel_4 "Edu: HSC/Diploma"
label var edulevel_5 "Edu: Bachelors"
label var edulevel_6 "Edu: Post graduate"
label var maritalstatus_2 "MS: Unmarried"
label var maritalstatus_3 "MS: Widowed"
label var maritalstatus_4 "MS: Divorce/separated"
label var annualincome_indiv "Income"
label var HHsize "HH size"
*/

***** Reg
cls
*foreach x in DSR loanamount DAR_without {
foreach x in static_vuln {
probit `x' treat $var [pw=weights]
est store regpw_`x'
probit `x' treat $var
est store reg_`x'
}


***** Before weighting
esttab reg_f1_2016 reg_f2_2016 reg_f3_2016 reg_f5_2016 reg_raven_tt reg_num_tt reg_lit_tt using "reg_demo_nopw.tex", replace f ///
	label booktabs b(3) p(3) eqlabels(none) alignment(S) collabels("\multicolumn{1}{c}{$\beta$ / Std. Err.}") ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N r2 r2_a F p, fmt(0 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"\(R^{2}\)"' `"Adjusted \(R^{2}\)"' `"F-stat"' `"p-value"'))


***** After weighting
esttab regpw_f1_2016 regpw_f2_2016 regpw_f3_2016 regpw_f5_2016 regpw_raven_tt regpw_num_tt regpw_lit_tt using "reg_demo_pw.tex", replace f ///
	label booktabs b(3) p(3) eqlabels(none) alignment(S) collabels("\multicolumn{1}{c}{$\beta$ / Std. Err.}") ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N r2 r2_a F p, fmt(0 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"\(R^{2}\)"' `"Adjusted \(R^{2}\)"' `"F-stat"' `"p-value"'))

****************************************
* END
