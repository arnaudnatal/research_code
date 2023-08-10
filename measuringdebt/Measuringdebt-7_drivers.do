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

*** Verif caste
preserve
keep HHID_panel year caste
reshape wide caste, i(HHID_panel) j(year)
ta caste2010 caste2016
ta caste2016 caste2020
ta caste2010 caste2020
restore

*** Verif dummies
ta head_mocc_occupation
sum head_occ1 head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7

ta head_edulevel
sum head_educ1 head_educ2 head_educ3

ta caste year

*** Stat quali
cls
ta head_female year, col nofreq
ta head_female year if caste==1, col nofreq
ta head_female year if caste==2, col nofreq
ta head_female year if caste==3, col nofreq

ta head_mocc_occupation year, col nofreq
ta head_mocc_occupation year if caste==1, col nofreq
ta head_mocc_occupation year if caste==2, col nofreq
ta head_mocc_occupation year if caste==3, col nofreq

ta head_edulevel year, col nofreq
ta head_edulevel year if caste==1, col nofreq
ta head_edulevel year if caste==2, col nofreq
ta head_edulevel year if caste==3, col nofreq

ta head_nonmarried year, col nofreq
ta head_nonmarried year if caste==1, col nofreq
ta head_nonmarried year if caste==2, col nofreq
ta head_nonmarried year if caste==3, col nofreq

ta ownland year, col nofreq
ta ownland year if caste==1, col nofreq
ta ownland year if caste==2, col nofreq
ta ownland year if caste==3, col nofreq

ta dummymarriage year, col nofreq
ta dummymarriage year if caste==1, col nofreq
ta dummymarriage year if caste==2, col nofreq
ta dummymarriage year if caste==3, col nofreq

ta dummydemonetisation year, col nofreq
ta dummydemonetisation year if caste==1, col nofreq
ta dummydemonetisation year if caste==2, col nofreq
ta dummydemonetisation year if caste==3, col nofreq

ta vill year, col nofreq
ta vill year if caste==1, col nofreq
ta vill year if caste==2, col nofreq
ta vill year if caste==3, col nofreq

*** Stat quanti
cls
replace assets_total=assets_total/1000
replace assets_totalnoland=assets_totalnoland/1000
replace annualincome_HH=annualincome_HH/1000
replace loanamount_HH=loanamount_HH/1000
replace shareform=shareform/100

tabstat HHsize HH_count_child head_age, stat(mean) long by(year)
tabstat HHsize HH_count_child head_age if caste==1, stat(mean) long by(year)
tabstat HHsize HH_count_child head_age if caste==2, stat(mean) long by(year)
tabstat HHsize HH_count_child head_age if caste==3, stat(mean) long by(year)


tabstat assets_total assets_totalnoland annualincome_HH shareform loanamount_HH if year==2010, stat(mean cv p50) long
tabstat assets_total assets_totalnoland annualincome_HH shareform loanamount_HH if year==2016, stat(mean cv p50) long
tabstat assets_total assets_totalnoland annualincome_HH shareform loanamount_HH if year==2020, stat(mean cv p50) long

tabstat assets_total assets_totalnoland annualincome_HH shareform loanamount_HH if year==2010 & caste==1, stat(mean cv p50) long
tabstat assets_total assets_totalnoland annualincome_HH shareform loanamount_HH if year==2016 & caste==1, stat(mean cv p50) long
tabstat assets_total assets_totalnoland annualincome_HH shareform loanamount_HH if year==2020 & caste==1, stat(mean cv p50) long

tabstat assets_total assets_totalnoland annualincome_HH shareform loanamount_HH if year==2010 & caste==2, stat(mean cv p50) long
tabstat assets_total assets_totalnoland annualincome_HH shareform loanamount_HH if year==2016 & caste==2, stat(mean cv p50) long
tabstat assets_total assets_totalnoland annualincome_HH shareform loanamount_HH if year==2020 & caste==2, stat(mean cv p50) long

tabstat assets_total assets_totalnoland annualincome_HH shareform loanamount_HH if year==2010 & caste==3, stat(mean cv p50) long
tabstat assets_total assets_totalnoland annualincome_HH shareform loanamount_HH if year==2016 & caste==3, stat(mean cv p50) long
tabstat assets_total assets_totalnoland annualincome_HH shareform loanamount_HH if year==2020 & caste==3, stat(mean cv p50) long


****************************************
* END












****************************************
* Drivers
****************************************
use"panel_v6", clear


*** Gen var
ta house, gen(house_)

recode secondlockdownexposure dummysell(.=1)
ta secondlockdownexposure, gen(lock_)
label var lock_1 "Sec. lockdown: Before"
label var lock_2 "Sec. lockdown: During"
label var lock_3 "Sec. lockdown: After"
label var dummysell "Sell assets to face lockdown: Yes"

label var dummydemonetisation "Demonetisation: Yes"


* Clean assets
sum assets_housevalue assets_livestock assets_goods assets_ownland assets_gold
foreach x in assets_housevalue assets_livestock assets_goods assets_ownland assets_gold {
replace `x'=1 if `x'==. | `x'<1
}


* Log
foreach x in assets_total assets_totalnoland assets_housevalue assets_livestock assets_goods assets_ownland assets_gold annualincome_HH loanamount_HH assets_totalnoprop {
replace `x'=1 if `x'<1 | `x'==.
gen log_`x'=log(`x')
}



********** Macro
global livelihood log_annualincome_HH log_assets_total log_assets_totalnoland remittnet_HH assets_total assets_totalnoland annualincome_HH log_assets_housevalue log_assets_livestock log_assets_goods log_assets_ownland log_assets_gold log_assets_totalnoprop

global family HHsize HH_count_child stem housetitle ownland sexratio dependencyratio

global head head_female head_age head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried

global shock dummymarriage dummydemonetisation lock_1 lock_2 lock_3 dummysell dummyexposure

global debt shareform loanamount_HH_std log_loanamount_HH loanamount_HH

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

*remittnet_HH mean_remittnet_HH




global family ///
HHsize mean_HHsize ///
HH_count_child mean_HH_count_child

/*
ownland mean_ownland 
housetitle mean_housetitle ///
sexratio mean_sexratio ///
dependencyratio mean_dependencyratio ///
stem mean_stem 
*/

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
dummydemonetisation mean_dummydemonetisation ///
lock_2 mean_lock_2 ///
lock_3 mean_lock_3

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
*/

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
