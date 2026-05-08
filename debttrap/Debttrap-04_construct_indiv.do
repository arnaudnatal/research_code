*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*April 29, 2026
*-----
gl link = "debttrap"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*cd"C:\Users\anatal\Documents\DT\Analysis"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------





****************************************
* Indiv level
****************************************
use"panel_indiv_v0", clear

********** Debt

* Dummyloans
gen dummyloans=0
replace dummyloans=1 if nbloans_indiv!=. & nbloans_indiv>0
label values dummyloans yesno
ta dummyloans year, col

* Stock
corr loanbalance_indiv imp1_ds_tot_indiv imp1_is_tot_indiv
count if loanbalance_indiv==0
count if imp1_ds_tot_indiv==0
count if imp1_is_tot_indiv==0
rename loanbalance_indiv balance
rename imp1_ds_tot_indiv debtserv
rename imp1_is_tot_indiv intserv

* Income
gen income_indiv=annualincome_indiv+remreceived_indiv

* DSR
gen dsr=(debtserv*100)/income_indiv
replace dsr=0 if dsr==.
replace dsr=. if dummyloans==0

* ISR
gen isr=(intserv*100)/income_indiv
replace isr=0 if isr==.
replace isr=. if dummyloans==0

* DIR
gen dir=(balance*100)/income_indiv
replace dir=0 if dir==.
replace dir=. if dummyloans==0

* Log
foreach x in balance debtserv intserv dsr isr dir {
gen log_`x'=log(`x')
}


********** Controls
* Panelvar
egen INDIVFE=group(HHID_panel INDID_panel)

* Dalits
gen dalits=.
replace dalits=1 if caste==1
replace dalits=0 if caste==2
replace dalits=0 if caste==3
label define dalits 0"Non-dalits" 1"Dalits"
label values dalits dalits

* Gender
fre sex
gen female=0 if sex==1
replace female=1 if sex==2
order female, after(sex)
ta female sex
drop sex

* Marital status
fre maritalstatus
gen nonmarried=1
replace nonmarried=0 if maritalstatus==1 & maritalstatus!=.
ta nonmarried maritalstatus, m
drop maritalstatus

* Education
fre edulevel
recode edulevel (4=3) (5=3)
fre edulevel

* Occupation
fre mainocc_occupation_indiv
rename mainocc_occupation_indiv occupation
recode occupation (5=4)
fre occupation

* Agri vs non-agri
gen agri=.
replace agri=0 if occupation>2 & occupation!=.
replace agr=1 if occupation<=2 & occupation!=.
ta occupation agri, m

********** Order
order HHID_panel year
sort HHID_panel year


*** Caste
fre caste
drop dalits
gen dalits=.
replace dalits=1 if caste==1
replace dalits=1 if caste2025==2
replace dalits=0 if caste==2
replace dalits=0 if caste==3
replace dalits=0 if caste2025!=2 & caste2025!=.
label define dalits 1"Dalits" 0"Non-dalits", replace
label values dalits dalits

ta caste2025 dalits
drop caste caste2025

*
drop if HHID_panel=="KAR23" & INDID_panel=="Ind_2" & year==2025 & working_pop==3

* Merge
preserve
use"panel_HH_v1", clear
keep HHID_panel year villageid HHFE log_wealth log_income dummylock landstatus drywetownland crops_cat sizeownland sizeleaseland nbcrops assets_nolandnogold
duplicates drop
save"_temp", replace
restore
merge m:1 HHID_panel year using "_temp"
keep if _merge==3
drop _merge
drop secondlockdownexposure

save"panel_indiv_v1", replace
****************************************
* END










****************************************
* Indiv construct
****************************************
use"panel_indiv_v1", clear

* Niveau
recode dsr isr (.=0)
foreach x in dsr isr {
gen w1_`x'=`x'
sum w1_`x', det
replace w1_`x'=`r(p99)' if w1_`x'>`r(p99)' & w1_`x'!=.
}

foreach x in dsr isr {
gen w5_`x'=`x'
sum w5_`x', det
replace w5_`x'=`r(p95)' if w5_`x'>`r(p95)' & w5_`x'!=.
}

* Var
global var dummyloans dsr w1_dsr w5_dsr isr w1_isr w5_isr ///
edulevel occupation age agri nonmarried

* Time period 1: 2016 to 2020
preserve
keep HHID_panel INDID_panel time $var
keep if time==1 | time==2
bys HHID_panel INDID_panel: gen n=_N
keep if n==2
ta time
reshape wide $var, i(HHID_panel INDID_panel) j(time)
gen timeperiod=1
gen year=2016
order HHID_panel INDID_panel timeperiod year
drop n
save"_temp_tp1", replace
restore

* Time period 2: 2020 to 2026
preserve
keep HHID_panel INDID_panel time $var
keep if time==2 | time==3
bys HHID_panel INDID_panel: gen n=_N
keep if n==2
ta time
reshape wide $var, i(HHID_panel INDID_panel) j(time)
gen timeperiod=2
gen year=2020
order HHID_panel INDID_panel timeperiod year
foreach x in $var {
rename `x'2 `x'1
rename `x'3 `x'2
}
drop n
save"_temp_tp2", replace
restore


* Append
use"_temp_tp1", clear

append using "_temp_tp2"

save"_temp_tp", replace

* Merge
use"panel_indiv_v1", clear

merge m:1 HHID_panel INDID_panel year using"_temp_tp"
drop _merge

save"panel_indiv_v2", replace
****************************************
* END








****************************************
* Dummies
****************************************
use"panel_indiv_v2", clear

* Selection
/*
drop if timeperiod==.
keep if dummyloans1==1
keep if dummyloans2==1
drop if year==2020
*/

*
keep HHID_panel INDID_panel HHFE INDIVFE year ///
timeperiod dummyloans1 dummyloans2 ///
dsr1 dsr2 ///
w1_dsr1 w1_dsr2 ///
w5_dsr1 w5_dsr2 ///
isr1 isr2 ///
w1_isr1 w1_isr2 ///
w5_isr1 w5_isr2 ///
log_wealth log_income ///
HHsize HH_count_child nbworker_HH nbnonworker_HH ///
female age nonmarried edulevel occupation ///
dummylock dummydemonetisation dummymarriage ///
ownland villageid dalits ///
assets_nolandnogold goldquantity_HH saving goldquantity

* Vars
gen log_saving=log(saving)
drop saving

ta occupation, m
recode occupation (.=0)
ta occupation, gen(occ)
drop occupation

ta edulevel, m
ta edulevel, gen(educ)
drop edulevel

ta villageid, m
ta villageid, gen(village)
drop villageid

ta HHFE, m
ta HHFE, gen(HH)

* First diff
gen diff_isr=isr2-isr1
gen diff_w1_isr=w1_isr2-w1_isr1
gen diff_w5_isr=w5_isr2-w5_isr1

gen diff_dsr=dsr2-dsr1
gen diff_w1_dsr=w1_dsr2-w1_dsr1
gen diff_w5_dsr=w5_dsr2-w5_dsr1

* Quadratic terms
gen dsr1_2=dsr1*dsr1
gen dsr1_3=dsr1*dsr1*dsr1
gen dsr1_4=dsr1*dsr1*dsr1*dsr1

gen w1_dsr1_2=w1_dsr1*w1_dsr1
gen w1_dsr1_3=w1_dsr1*w1_dsr1*w1_dsr1
gen w1_dsr1_4=w1_dsr1*w1_dsr1*w1_dsr1*w1_dsr1

gen w5_dsr1_2=w5_dsr1*w5_dsr1
gen w5_dsr1_3=w5_dsr1*w5_dsr1*w5_dsr1
gen w5_dsr1_4=w5_dsr1*w5_dsr1*w5_dsr1*w5_dsr1

gen isr1_2=isr1*isr1
gen isr1_3=isr1*isr1*isr1
gen isr1_4=isr1*isr1*isr1*isr1

gen w1_isr1_2=w1_isr1*w1_isr1
gen w1_isr1_3=w1_isr1*w1_isr1*w1_isr1
gen w1_isr1_4=w1_isr1*w1_isr1*w1_isr1*w1_isr1

gen w5_isr1_2=w5_isr1*w5_isr1
gen w5_isr1_3=w5_isr1*w5_isr1*w5_isr1
gen w5_isr1_4=w5_isr1*w5_isr1*w5_isr1*w5_isr1


* Age
gen age2=age*age

* Caste X Lands
gen dalitsXland=dalits*ownland

* Female X Lands
gen femaleXland=female*ownland

* Dalits X Female X Lands
gen dalitsXfemaleXland=dalits*female*ownland

* Female X Dalits
gen femaleXdalits=female*dalits

* Var pour CRE à la main
foreach x in ///
dsr1 dsr1_2 dsr1_3 dsr1_4 ///
w1_dsr1 w1_dsr1_2 w1_dsr1_3 w1_dsr1_4 ///
w5_dsr1 w5_dsr1_2 w5_dsr1_3 w5_dsr1_4 ///
isr1 isr1_2 isr1_3 isr1_4 ///
w1_isr1 w1_isr1_2 w1_isr1_3 w1_isr1_4 ///
w5_isr1 w5_isr1_2 w5_isr1_3 w5_isr1_4 ///
female age age2 nonmarried occ1 occ2 occ4 occ5 occ6 occ7 educ2 educ3 educ4 HHsize HH_count_child ownland log_wealth log_income dummylock dummydemonetisation dummymarriage dalitsXland femaleXland dalitsXfemaleXland femaleXdalits {
bys HHID_panel INDID_panel: egen m_`x'=mean(`x')
}
bys HHID_panel INDID_panel: gen nby=_N
ta year, gen(y)

save"panel_indiv_v3", replace
****************************************
* END
