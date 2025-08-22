*-------------------------
cls
*XXXX XXXX
*XXXX@XXXX
*March 19, 2024
*-----
gl link = "stabpsycho"
*-----
*do "C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------

cd"C:\Users\anatal\Downloads\JDS_Stability\Analysis"





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

*** Villagenew
encode villagename2016_club, gen(newvillage)
ta newvillage, gen(newvillage)


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
caste occupation edulevel villageid username_code

global varstep1 age ib(1).caste female unmarried ib(3).occupation ib(1).edulevel HHsize assetsstd incomeHHstd debtstd

global varstep2 $varstep1 ib(1).villageid ib(1).username_code



********** Balance test
psweight balance treat $varstep1
mdesc
psweight cbpsoid treat $varstep1
mdesc
psweight call balanceresults()



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
	keep(treat) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "t(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

esttab fESws fOPEXws fCOws using "new/reg_s.csv", replace ///
	b(3) p(3) eqlabels(none) alignment(S) ///
	keep(1.treat 1.female 1.treat#1.female) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "t(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

esttab fESwc fOPEXwc fCOwc using "new/reg_c.csv", replace ///
	b(3) p(3) eqlabels(none) alignment(S) ///
	keep(1.treat 2.caste 3.caste 1.treat#2.caste 1.treat#3.caste) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "t(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

esttab fESwsc fOPEXwsc fCOwsc using "new/reg_sc.csv", replace ///
	b(3) p(3) eqlabels(none) alignment(S) ///
	keep(1.treat 1.female 1.treat#1.female 2.caste 3.caste 1.treat#2.caste 1.treat#3.caste 1.female#2.caste 1.female#3.caste 1.treat#1.female#2.caste 1.treat#1.female#3.caste) ///
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
age caste female unmarried occupation edulevel HHsize assetsstd incomeHHstd debtstd villageid username_code 

global varstep1 age ib(1).caste female unmarried ib(3).occupation ib(1).edulevel HHsize assetsstd incomeHHstd debtstd
global varstep2 $varstep1 ib(1).username_code ib(1).villageid



********** Balance test
psweight balance treat $varstep1
psweight cbpsoid treat $varstep1
psweight call balanceresults()



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
	keep(treat) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "t(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

esttab fESws fOPEXws fCOws using "new/reg_s.csv", replace ///
	b(3) p(3) eqlabels(none) alignment(S) ///
	keep(1.treat 1.female 1.treat#1.female) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "t(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

esttab fESwc fOPEXwc fCOwc using "new/reg_c.csv", replace ///
	b(3) p(3) eqlabels(none) alignment(S) ///
	keep(1.treat 2.caste 3.caste 1.treat#2.caste 1.treat#3.caste) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "t(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

esttab fESwsc fOPEXwsc fCOwsc using "new/reg_sc.csv", replace ///
	b(3) p(3) eqlabels(none) alignment(S) ///
	keep(1.treat 1.female 1.treat#1.female 2.caste 3.caste 1.treat#2.caste 1.treat#3.caste 1.female#2.caste 1.female#3.caste 1.treat#1.female#2.caste 1.treat#1.female#3.caste) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "t(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
	
****************************************
* END
































****************************************
* Demonetisation with income interaction
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

*** Villagenew
encode villagename2016_club, gen(newvillage)
ta newvillage, gen(newvillage)


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
caste occupation edulevel villageid username_code

*** Income dummy
xtile catincome=incomeHHstd, n(2)
fre catincome
replace catincome=catincome-1
fre catincome
rename catincome rich
tabstat incomeHHstd, stat(mean median) by(rich)

global varstep1 age ib(1).caste female unmarried ib(3).occupation ib(1).edulevel HHsize assetsstd incomeHHstd debtstd

global varstep2 $varstep1 ib(1).villageid ib(1).username_code



********** Balance test
psweight balance treat $varstep1
mdesc
psweight cbpsoid treat $varstep1
mdesc
psweight call balanceresults()



********** Reg
cls
foreach x in fES fOPEX fCO {

* Income continuous
glm `x' i.treat##c.incomeHHstd $varstep2 [pw=_weight], link(log) family(igaussian) vce(cl HHFE)
est store `x'cont

* Dummy income
glm `x' i.treat##i.rich $varstep2 [pw=_weight], link(log) family(igaussian) vce(cl HHFE)
est store `x'cat
}


esttab fEScont fOPEXcont fCOcont fEScat fOPEXcat fCOcat using "new/reg_demoinc.csv", replace ///
	b(3) p(3) eqlabels(none) alignment(S) ///
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
age caste female unmarried occupation edulevel HHsize assetsstd incomeHHstd debtstd villageid username_code 

*** Income dummy
xtile catincome=incomeHHstd, n(2)
fre catincome
replace catincome=catincome-1
fre catincome
rename catincome rich
tabstat incomeHHstd, stat(mean median) by(rich)


global varstep1 age ib(1).caste female unmarried ib(3).occupation ib(1).edulevel HHsize assetsstd incomeHHstd debtstd
global varstep2 $varstep1 ib(1).username_code ib(1).villageid



********** Balance test
psweight balance treat $varstep1
psweight cbpsoid treat $varstep1
psweight call balanceresults()



********** Reg
cls
foreach x in fES fOPEX fCO {

* Income continuous
glm `x' i.treat##c.incomeHHstd $varstep2 [pw=_weight], link(log) family(igaussian) vce(cl HHFE)
est store `x'cont

* Dummy income
glm `x' i.treat##i.rich $varstep2 [pw=_weight], link(log) family(igaussian) vce(cl HHFE)
est store `x'cat
}


esttab fEScont fOPEXcont fCOcont fEScat fOPEXcat fCOcat using "new/reg_lockinc.csv", replace ///
	b(3) p(3) eqlabels(none) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "t(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
	
****************************************
* END
