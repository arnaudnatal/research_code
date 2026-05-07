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
cd"C:\Users\Arnaud\Documents\MEGA\Research\Ongoing_Debttrap\Analysis"
*-------------------------




****************************************
* HH level
****************************************
use"panel_HH_v0", clear


********** Debt
* Indebted?
gen dummyloans_HH=0
replace dummyloans_HH=1 if nbloans_HH!=. & nbloans_HH>0
label values dummyloans_HH yesno
ta dummyloans_HH year, col

* Stock
corr loanbalance_HH imp1_ds_tot_HH imp1_is_tot_HH
count if loanbalance_HH==0
count if imp1_ds_tot_HH==0
count if imp1_is_tot_HH==0
rename loanbalance_HH balance
rename imp1_ds_tot_HH debtserv
rename imp1_is_tot_HH intserv

* Income
gen income_HH=annualincome_HH+remreceived_HH

* DSR
gen dsr=(debtserv*100)/income_HH
replace dsr=0 if dsr==.

* ISR
gen isr=(intserv*100)/income_HH
replace isr=0 if isr==.

* DAR
gen dar=(balance*100)/(assets_total1000*1000)
replace dar=0 if dar==.

* DIR
gen dir=(balance*100)/income_HH
replace dir=0 if dir==.

* Log
foreach x in balance debtserv intserv dsr isr dar dir {
gen log_`x'=log(`x')
}


********** Controls
* panelvar
encode HHID_panel, gen(panelvar)

* Head sex
gen head_female=.
replace head_female=0 if head_sex==1
replace head_female=1 if head_sex==2
label define head_female 0"Male" 1"Female"
label values head_female head_female

* Head occupation
recode head_mocc_occupation (5=4)
ta head_mocc_occupation, gen(head_occ)

* Head edulevel
recode head_edulevel (3=2) (4=2) (5=2)
ta head_edulevel, gen(head_educ)

* Head age
tabstat head_age, stat(n mean sd q)
gen head_agesq=head_age*head_age
gen head_agecat=0
replace head_agecat=1 if head_age<40
replace head_agecat=2 if head_age>=40 & head_age<50
replace head_agecat=3 if head_age>=50 & head_age<60
replace head_agecat=4 if head_age>=60
label define head_agecat 1"Less 40" 2"40-50" 3"50-60" 4"60 or more"
label values head_agecat head_agecat
ta head_agecat, gen(head_agecat)

* Head maritalstatus
gen head_nonmarried=head_maritalstatus
recode head_nonmarried (1=0) (2=1) (3=1) (4=1) (.=0)
label define head_nonmarried 0"Married" 1"Non-married"
label values head_nonmarried head_nonmarried

* Dalits
gen dalits=.
replace dalits=1 if caste==1
replace dalits=1 if caste2025==2
replace dalits=0 if caste==2
replace dalits=0 if caste==3
replace dalits=0 if caste2025!=2 & caste2025!=.
label define dalits 1"Dalits" 0"Non-dalits"
label values dalits dalits

ta caste2025 dalits
drop caste caste2025

* Vars
encode HHID_panel, gen(HHFE)
order HHFE, after(HHID_panel)
gen log_wealth=log(assets_totalnoland1000)
gen log_income=log(income_HH)
rename secondlockdownexposure dummylock
recode dummylock (1=0) (2=1) (3=1)
ta villageid
drop village
replace villageid="ELA" if villageid=="ELANTHALMPATTU"
replace villageid="GOV" if villageid=="GOVULAPURAM"
replace villageid="KAR" if villageid=="KARUMBUR"
replace villageid="KOR" if villageid=="KORATTORE"
replace villageid="KUV" if villageid=="KUVAGAM"
replace villageid="MANAM" if villageid=="MANAMTHAVIZHINTHAPUTHUR"
replace villageid="MAN" if villageid=="MANAPAKKAM"
replace villageid="NAT" if villageid=="NATHAM"
replace villageid="ORA" if villageid=="ORAIYURE"
replace villageid="SEM" if villageid=="SEMAKOTTAI"
ta villageid
rename villageid village
encode village, gen(villageid)
drop village

********** Drop
drop nbloans_HH loanamount_HH



********** Order
order HHID_panel year
sort HHID_panel year


save"panel_HH_v1", replace
****************************************
* END













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
keep HHID_panel year villageid HHFE log_wealth log_income dummylock landstatus drywetownland crops_cat sizeownland sizeleaseland nbcrops
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
* HH construct
****************************************
use"panel_HH_v1", clear

* Niveau
recode balance debtserv intserv dsr (.=0)
foreach x in balance debtserv intserv dsr {
gen `x'_r=`x'
sum `x'_r, det
replace `x'_r=`r(p99)' if `x'_r>`r(p99)' & `x'_r!=.
}

* Var
global var balance debtserv intserv dsr log_dsr dummyloans_HH ///
balance_r debtserv_r intserv_r dsr_r

* Time period 1: 2010 to 2016
preserve
rename assets_total1000 wealth
rename annualincome_HH income
keep HHID_panel time wealth income $var
keep if time==1 | time==2
bys HHID_panel: gen n=_N
keep if n==2
ta time
reshape wide wealth income $var, i(HHID_panel) j(time)
gen timeperiod=1
gen year=2010
order HHID_panel timeperiod year
drop n
save"_temp_tp1", replace
restore

* Time period 2: 2016 to 2020
preserve
rename assets_total1000 wealth
rename annualincome_HH income
keep HHID_panel time wealth income $var
keep if time==2 | time==3
bys HHID_panel: gen n=_N
keep if n==2
ta time
reshape wide wealth income $var, i(HHID_panel) j(time)
gen timeperiod=2
gen year=2016
order HHID_panel timeperiod year
foreach x in $var income wealth {
rename `x'2 `x'1
rename `x'3 `x'2
}
drop n
save"_temp_tp2", replace
restore

* Time period 3: 2020 to 2026
preserve
rename assets_total1000 wealth
rename annualincome_HH income
keep HHID_panel time wealth income $var
keep if time==3 | time==4
bys HHID_panel: gen n=_N
keep if n==2
ta time
reshape wide wealth income $var, i(HHID_panel) j(time)
gen timeperiod=3
gen year=2020
order HHID_panel timeperiod year
foreach x in $var income wealth {
rename `x'3 `x'1
rename `x'4 `x'2
}
drop n
save"_temp_tp3", replace
restore

* Append
use"_temp_tp1", clear

append using "_temp_tp2"
append using "_temp_tp3"

save"_temp_tp", replace

* Merge
use"panel_HH_v1", clear

merge 1:1 HHID_panel year using"_temp_tp"
drop _merge

* Terciles
foreach x in income wealth {
drop `x'2
xtile `x'_t1=`x'1 if timeperiod==1, n(3)
xtile `x'_t2=`x'1 if timeperiod==2, n(3)
xtile `x'_t3=`x'1 if timeperiod==3, n(3)
}
foreach x in income wealth {
gen `x'_t=.
}
foreach x in income wealth {
replace `x'_t=`x'_t1 if timeperiod==1
replace `x'_t=`x'_t2 if timeperiod==2
replace `x'_t=`x'_t3 if timeperiod==3
}
ta wealth_t timeperiod, m


save"panel_HH_v2", replace
****************************************
* END











****************************************
* Indiv construct
****************************************
use"panel_indiv_v1", clear

* Niveau
recode balance debtserv intserv dsr (.=0)
foreach x in balance debtserv intserv dsr {
gen `x'_r=`x'
sum `x'_r, det
replace `x'_r=`r(p99)' if `x'_r>`r(p99)' & `x'_r!=.
}

* Var
global var balance debtserv intserv dsr log_dsr dummyloans ///
balance_r debtserv_r intserv_r dsr_r ///
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


