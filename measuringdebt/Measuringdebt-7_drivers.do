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
use"panel_v7", clear

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
use"panel_v7", clear


*** Gen dummies
ta house, gen(house_)


********** Macro
global finance assets_total_std ownland shareform annualincome_HH_std loanamount_HH_std

global family HHsize HH_count_child stem housetitle

global head head_female head_age head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried

global other dummymarriage dummydemonetisation

global invar caste_2 caste_3 village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10


********** Miss?
mdesc $family
mdesc $finance
mdesc $head
mdesc $other
mdesc $invar



********* To keep
keep HHID_panel panelvar year time fvi $family $finance $head $other $invar




********** Mean over time
foreach x in $family $finance $head $other {
bysort HHID_panel: egen mean_`x'=mean(`x')
}


global finance ///
shareform mean_shareform 
*loanamount_HH_std mean_loanamount_HH_std
*annualincome_HH_std mean_annualincome_HH_std ///

global family ///
HHsize mean_HHsize ///
HH_count_child mean_HH_count_child ///
stem mean_stem ///
housetitle mean_housetitle ///
assets_total_std mean_assets_total_std ///
ownland mean_ownland ///

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

global other ///
dummymarriage mean_dummymarriage ///
dummydemonetisation mean_dummydemonetisation

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




********** CRE fractional probit
*** Spec 1
glm fvi ///
$family ///
$invar ///
, family(binomial) link(probit) cluster(panelvar)
est store spec1



*** Spec 2
glm fvi ///
$family ///
$head ///
$invar ///
, family(binomial) link(probit) cluster(panelvar)
est store spec2



*** Spec 3
glm fvi ///
$family ///
$head ///
$finance ///
$invar ///
, family(binomial) link(probit) cluster(panelvar)
est store spec3



*** Spec 4
glm fvi ///
$family ///
$head ///
$finance ///
$other ///
$invar ///
, family(binomial) link(probit) cluster(panelvar)
est store spec4





********** Table
esttab spec1 spec2 spec3, ///
label b(3) p(3) ///
star(* 0.10 ** 0.05 *** 0.01) ///
drop(_cons mean* village*) ///
stats(N N_clust aic bic, fmt(0 0 2 2))

esttab spec1 spec2 spec3 using "reg.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $var) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N N_clust aic bic, fmt(0 0 2 2)	labels(`"Observations"' `"Number of clust"' `"AIC"' `"BIC"'))

****************************************
* END
