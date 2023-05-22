*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*November 19, 2022
*-----
gl link = "measuringdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\measuringdebt.do"
*-------------------------











****************************************
* Stat desc
****************************************
use"panel_v6", clear

xtset panelvar time

*** Verif dummies
ta head_mocc_occupation
sum head_occ1 head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7

ta head_edulevel
sum head_educ1 head_educ2 head_educ3



*** Stat quali
cls
ta caste year, col nofreq
ta dalits year, col nofreq
ta stem year, col nofreq
ta head_female year, col nofreq
ta head_mocc_occupation year, col nofreq
ta head_edulevel year, col nofreq
ta head_nonmarried year, col nofreq
ta ownland year, col nofreq
ta dummymarriage year, col nofreq
ta dummydemonetisation year, col nofreq
ta vill year, col nofreq
ta house year, col nofreq
ta housetitle year, col nofreq


*** Stat quanti
cls
replace assets_total=assets_total/1000
replace annualincome_HH=annualincome_HH/1000
replace loanamount_HH=loanamount_HH/1000
replace shareform=shareform/100

tabstat HHsize HH_count_child head_age, stat(mean) long by(year)

tabstat assets_total annualincome_HH shareform loanamount_HH if year==2010, stat(mean cv p50) long
tabstat assets_total annualincome_HH shareform loanamount_HH if year==2016, stat(mean cv p50) long
tabstat assets_total annualincome_HH shareform loanamount_HH if year==2020, stat(mean cv p50) long



****************************************
* END












****************************************
* Drivers
****************************************
use"panel_v6", clear


*** Gen var
ta house, gen(house_)

recode secondlockdownexposure (.=1)
ta secondlockdownexposure, gen(lock_)
label var lock_1 "Sec. lockdown: Before"
label var lock_2 "Sec. lockdown: During"
label var lock_3 "Sec. lockdown: After"
label var dummydemonetisation "Demonetisation: Yes"


* Class
foreach x in assets_total annualincome_HH {
foreach i in 2010 2016 2020 {
gen `x'_`i'=.
replace `x'_`i'=`x' if year==`i'
xtile cat_`x'_`i'=`x'_`i', n(5)
}
gen `x'_class=.
foreach i in 2010 2016 2020 {
replace `x'_class=cat_`x'_`i' if year==`i'
drop `x'_`i' cat_`x'_`i'
}
}

rename annualincome_HH_class income_class
rename assets_total_class assets_class

ta income_class, gen(income_cl)

label var income_cl1 "Income: Very low"
label var income_cl2 "Income: Low"
label var income_cl3 "Income: Middle"
label var income_cl4 "Income: High"
label var income_cl5 "Income: Very high"

ta assets_class, gen(assets_cl)
label var assets_cl1 "Assets: Very low"
label var assets_cl2 "Assets: Low"
label var assets_cl3 "Assets: Middle"
label var assets_cl4 "Assets: High"
label var assets_cl5 "Assets: Very high"


* Log
foreach x in assets_total annualincome_HH loanamount_HH {
replace `x'=1 if `x'<1
gen log_`x'=log(`x')
}



********** Macro
global livelihood income_cl1 income_cl2 income_cl4 income_cl5 assets_cl1 assets_cl2 assets_cl4 assets_cl5 log_annualincome_HH log_assets_total

global family HHsize HH_count_child stem housetitle ownland 

global head head_female head_age head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried

global shock dummymarriage dummydemonetisation lock_2 lock_3

global debt shareform loanamount_HH_std log_loanamount_HH

global invar caste_2 caste_3 dalits village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10


********** Miss?
mdesc $family
mdesc $livelihood
mdesc $head
mdesc $shock
mdesc $invar
mdesc $debt



********* To keep
keep HHID_panel panelvar year time fvi $family $livelihood $head $shock $debt $invar




********** Mean over time
foreach x in $family $livelihood $head $shock $debt {
bysort HHID_panel: egen mean_`x'=mean(`x')
}


global livelihood ///
log_annualincome_HH mean_log_annualincome_HH ///
log_assets_total mean_log_assets_total

/*
income_cl1 mean_income_cl1 ///
income_cl2 mean_income_cl2 ///
income_cl4 mean_income_cl4 ///
income_cl5 mean_income_cl5 ///
assets_cl1 mean_assets_cl1 ///
assets_cl2 mean_assets_cl2 ///
assets_cl4 mean_assets_cl4 ///
assets_cl5 mean_assets_cl5 
*/

global family ///
HHsize mean_HHsize ///
HH_count_child mean_HH_count_child ///
stem mean_stem ///
housetitle mean_housetitle ///
ownland mean_ownland 

global head ///
head_female mean_head_female ///
head_age mean_head_age ///
head_occ1 mean_head_occ1 ///
head_occ2 mean_head_occ2 ///
head_occ4 mean_head_occ4 ///
head_occ5 mean_head_occ5 ///
head_occ6 mean_head_occ6 ///
head_occ7 mean_head_occ7 ///
head_educ2 mean_head_educ2 ///
head_educ3 mean_head_educ3 ///
head_nonmarried mean_head_nonmarried

global shock ///
dummymarriage mean_dummymarriage ///
dummydemonetisation mean_dummydemonetisation 
*lock_2 mean_lock_2 ///
*lock_3 mean_lock_3

global debt ///
shareform mean_shareform

global debt2 ///
log_loanamount_HH mean_log_loanamount_HH


global invar ///
caste_2 caste_3 ///
village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10


********** Other var
bysort HHID_panel: gen nobs=_N

gen nobs1=nobs==1
gen nobs2=nobs==2
gen nobs3=nobs==3

gen year2010=year==2010
gen year2016=year==2016
gen year2020=year==2020

foreach x in year2010 year2016 year2020 {
bysort HHID_panel: egen mean_`x'=mean(`x')
}

*** Label
label var nobs1 "Nb obs: 1"
label var nobs2 "Nb obs: 2"
label var nobs3 "Nb obs: 3"

label var year2010 "Year: 2010"
label var year2016 "Year: 2016-17"
label var year2020 "Year: 2020-21"

label var mean_year2010 "Within year: 2010"
label var mean_year2016 "Within year: 2016-17"
label var mean_year2020 "Within year: 2020-21"

label var log_annualincome_HH "Annual income (log)"
label var log_assets_total "Assets (log)"
label var log_loanamount_HH "Loan amount (log)"

*** Macro
global time ///
year2016 mean_year2016 ///
year2020 mean_year2020 ///
nobs2 nobs3


********** Multicollinerarity
corr $livelihood $family $head $shock shareform mean_shareform loanamount_HH_std mean_loanamount_HH_std $invar $time




********** Reg
*** Spec 1
glm fvi ///
$livelihood ///
$invar ///
$time ///
, family(binomial) link(probit) cluster(panelvar)
est store spec1
margins, dydx($livelihood $invar) post
est store marg1


*** Spec 2
glm fvi ///
$livelihood ///
$family ///
$invar ///
$time ///
, family(binomial) link(probit) cluster(panelvar)
est store spec2
margins, dydx($livelihood $family $invar) post
est store marg2

*** Spec 3
glm fvi ///
$livelihood ///
$family ///
$head ///
$invar ///
$time ///
, family(binomial) link(probit) cluster(panelvar)
est store spec3
margins, dydx($livelihood $family $head $invar) post
est store marg3


*** Spec 4
glm fvi ///
$livelihood ///
$family ///
$head ///
$shock ///
$invar ///
$time ///
, family(binomial) link(probit) cluster(panelvar)
est store spec4
margins, dydx($livelihood $family $head $shock $invar) post
est store marg4


*** Spec 5
glm fvi ///
$livelihood ///
$family ///
$head ///
$shock ///
$debt ///
$invar ///
$time ///
, family(binomial) link(probit) cluster(panelvar)
est store spec5
margins, dydx($livelihood $family $head $shock $debt $invar) post
est store marg5


*** Spec 6
glm fvi ///
$livelihood ///
$family ///
$head ///
$shock ///
$debt ///
$debt2 ///
$invar ///
$time ///
, family(binomial) link(probit) cluster(panelvar)
est store spec6
margins, dydx($livelihood $family $head $shock $debt $debt2 $invar) post
est store marg6




********** Margin
esttab marg1 marg2 marg3 marg4 marg5 marg6, ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(mean_* village_*) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel)

esttab marg1 marg2 marg3 marg4 marg5 marg6 using "margin.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(mean_* village_*) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel)


	
********** Specifications
esttab spec1 spec2 spec3 spec4 spec5 spec6 using "reg_full.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N N_clust, fmt(0 0)	labels(`"Observations"' `"Number of clust"'))





********** Overfitting

overfit: glm fvi ///
$livelihood ///
$invar ///
$time ///
, family(binomial) link(probit) cluster(panelvar)

overfit: glm fvi ///
$livelihood ///
$family ///
$invar ///
$time ///
, family(binomial) link(probit) cluster(panelvar)

overfit: glm fvi ///
$livelihood ///
$family ///
$head ///
$invar ///
$time ///
, family(binomial) link(probit) cluster(panelvar)

overfit: glm fvi ///
$livelihood ///
$family ///
$head ///
$shock ///
$invar ///
$time ///
, family(binomial) link(probit) cluster(panelvar)

overfit: glm fvi ///
$livelihood ///
$family ///
$head ///
$shock ///
$debt ///
$invar ///
$time ///
, family(binomial) link(probit) cluster(panelvar)

overfit: glm fvi ///
$livelihood ///
$family ///
$head ///
$shock ///
$debt ///
$debt2 ///
$invar ///
$time ///
, family(binomial) link(probit) cluster(panelvar)


****************************************
* END
