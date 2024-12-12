*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*March 19, 2024
*-----
gl link = "stabpsycho"
*Stab
*-----
do "C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------







****************************************
* Demonetisation
****************************************
cls
use "panel_stab_v2_pooled_long", clear

********** Preparation données
*** HHFE
encode HHID_panel, gen(HHFE)

*** Username
encode username, gen(username_code)
ta username_code

*** Occupations
fre mainocc_occupation_indiv
recode mainocc_occupation_indiv (.=0)
*recode mainocc_occupation_indiv (5=4)
rename mainocc_occupation_indiv occupation
fre occupation

*** Income
recode annualincome_indiv (.=0)
egen incomestd=std(annualincome_indiv)

recode annualincome_HH (.=0)
egen incomeHHstd=std(annualincome_HH)

*** Assets
egen assetsstd=std(assets_total1000)

*** Loan
recode loanamount_HH (.=0)
egen debtstd=std(loanamount_HH)

*** Education
fre edulevel
*recode edulevel (4=3)

*** Marital status
recode maritalstatus (1=0) (2=1) (3=1) (4=1)
label define maritalstatus 0"Married" 1"Non-married", replace
label values maritalstatus maritalstatus
fre maritalstatus
rename maritalstatus unmarried

*** Caste
fre caste
gen dalits=caste
recode dalits (2=0) (3=0)
ta dalits
label values dalits yesno

*** Sex
fre sex
recode sex (2=1) (1=0)
rename sex female
fre female
label values female yesno

*** Treatment
rename dummydemonetisation treat 


*** Var creation
global quali caste occupation edulevel villageid username_code
foreach x in $quali {
ta `x', gen(`x'_)
}


*** Clean Database
keep if year==2016
keep HHID_panel HHFE INDID_panel fES fOPEX fCO treat ///
age caste female unmarried occupation edulevel HHsize assetsstd incomeHHstd debtstd villageid username_code ///
caste_1 caste_2 caste_3 occupation_1 occupation_2 occupation_3 occupation_4 occupation_5 occupation_6 occupation_7 occupation_8 edulevel_1 edulevel_2 edulevel_3 edulevel_4 edulevel_5 villageid_1 villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 username_code_1 username_code_2 username_code_3 username_code_4 username_code_5 username_code_6 username_code_7 username_code_8 username_code_9 username_code_10 username_code_11 username_code_12


global varstep1 age caste_2 caste_3 female unmarried occupation_1 occupation_2 occupation_4 occupation_5 occupation_6 occupation_7 occupation_8 edulevel_2 edulevel_3 edulevel_4 edulevel_5 HHsize assetsstd incomeHHstd debtstd
global varstep2 $varstep1 villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 username_code_2 username_code_3 username_code_4 username_code_5 username_code_6 username_code_7 username_code_8 username_code_9 username_code_10 username_code_11 username_code_12



********** Balance test
psweight balance treat $varstep1
psweight cbpsoid treat $varstep1
psweight call balanceresults()

cls
foreach x in $varstep1 {
reg `x' i.treat, noheader
}

cls
foreach x in $varstep1 {
reg `x' i.treat [pw=_weight], noheader
}



********** Reg
cls
foreach x in fES fOPEX fCO {

* Total
glm `x' treat $varstep2 [pw=_weight], link(log) family(igaussian) vce(cl HHFE)
est store `x'w

* Sex
glm `x' i.treat##i.female $varstep2 [pw=_weight], link(log) family(igaussian) vce(cl HHFE)
est store `x'ws

* Caste
glm `x' i.treat##i.caste $varstep2 [pw=_weight], link(log) family(igaussian) vce(cl HHFE)
est store `x'wc

* Both
glm `x' i.treat##i.female##i.caste $varstep2 [pw=_weight], link(log) family(igaussian) vce(cl HHFE)
est store `x'wsc
}

esttab fESw fOPEXw fCOw using "new/reg.csv", replace ///
	b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $varstep2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "t(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

esttab fESws fOPEXws fCOws using "new/reg_s.csv", replace ///
	b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $varstep2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "t(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

esttab fESwc fOPEXwc fCOwc using "new/reg_c.csv", replace ///
	b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $varstep2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "t(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

esttab fESwsc fOPEXwsc fCOwsc using "new/reg_sc.csv", replace ///
	b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $varstep2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "t(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))


****************************************
* END


























****************************************
* Lockdown
****************************************
cls
use "panel_stab_v2_pooled_long", clear

********** Preparation données

*** HHFE
encode HHID_panel, gen(HHFE)

*** Username
encode username, gen(username_code)
ta username_code

*** Occupations
fre mainocc_occupation_indiv
recode mainocc_occupation_indiv (.=0)
*recode mainocc_occupation_indiv (5=4)
rename mainocc_occupation_indiv occupation
fre occupation

*** Income
recode annualincome_indiv (.=0)
egen incomestd=std(annualincome_indiv)

recode annualincome_HH (.=0)
egen incomeHHstd=std(annualincome_HH)

*** Assets
egen assetsstd=std(assets_total1000)

*** Loan
recode loanamount_HH (.=0)
egen debtstd=std(loanamount_HH)

*** Education
fre edulevel
*recode edulevel (4=3)

*** Marital status
recode maritalstatus (1=0) (2=1) (3=1) (4=1)
label define maritalstatus 0"Married" 1"Non-married", replace
label values maritalstatus maritalstatus
fre maritalstatus
rename maritalstatus unmarried

*** Caste
fre caste
gen dalits=caste
recode dalits (2=0) (3=0)
ta dalits
label values dalits yesno

*** Sex
fre sex
recode sex (2=1) (1=0)
rename sex female
fre female
label values female yesno

*** Treatment
rename dummyexposure treat 


*** Var creation
global quali caste occupation edulevel villageid username_code
foreach x in $quali {
ta `x', gen(`x'_)
}


*** Clean Database
keep if year==2020
keep HHID_panel HHFE INDID_panel fES fOPEX fCO treat ///
age caste female unmarried occupation edulevel HHsize assetsstd incomeHHstd debtstd villageid username_code ///
caste_1 caste_2 caste_3 occupation_1 occupation_2 occupation_3 occupation_4 occupation_5 occupation_6 occupation_7 occupation_8 edulevel_1 edulevel_2 edulevel_3 edulevel_4 edulevel_5 villageid_1 villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 username_code_1 username_code_2 username_code_3 username_code_4 username_code_5 username_code_6 username_code_7 username_code_8 username_code_9 username_code_10 username_code_11 username_code_12


global varstep1 age caste_2 caste_3 female unmarried occupation_1 occupation_2 occupation_4 occupation_5 occupation_6 occupation_7 occupation_8 edulevel_2 edulevel_3 edulevel_4 edulevel_5 HHsize assetsstd incomeHHstd debtstd
global varstep2 $varstep1 villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 username_code_2 username_code_3 username_code_4 username_code_5 username_code_6 username_code_7 username_code_8 username_code_9 username_code_10 username_code_11 username_code_12



********** Balance test
psweight balance treat $varstep1
psweight cbpsoid treat $varstep1
psweight call balanceresults()

cls
foreach x in $varstep1 {
reg `x' i.treat, noheader
}

cls
foreach x in $varstep1 {
reg `x' i.treat [pw=_weight], noheader
}



********** Reg
cls
foreach x in fES fOPEX fCO {

* Total
glm `x' treat $varstep2 [pw=_weight], link(log) family(igaussian) vce(cl HHFE)
est store `x'w

* Sex
glm `x' i.treat##i.female $varstep2 [pw=_weight], link(log) family(igaussian) vce(cl HHFE)
est store `x'ws

* Caste
glm `x' i.treat##i.caste $varstep2 [pw=_weight], link(log) family(igaussian) vce(cl HHFE)
est store `x'wc

* Both
glm `x' i.treat##i.female##i.caste $varstep2 [pw=_weight], link(log) family(igaussian) vce(cl HHFE)
est store `x'wsc
}

esttab fESw fOPEXw fCOw using "new/reg.csv", replace ///
	b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $varstep2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "t(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

esttab fESws fOPEXws fCOws using "new/reg_s.csv", replace ///
	b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $varstep2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "t(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

esttab fESwc fOPEXwc fCOwc using "new/reg_c.csv", replace ///
	b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $varstep2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "t(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

esttab fESwsc fOPEXwsc fCOwsc using "new/reg_sc.csv", replace ///
	b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $varstep2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "t(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

	
****************************************
* END

