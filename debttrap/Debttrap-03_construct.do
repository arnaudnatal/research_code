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
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------












****************************************
* Indiv level
****************************************
use"panel_indiv_v0", clear

********** Debt

* Dummyloans
gen dummyloans_indiv=0
replace dummyloans_indiv=1 if nbloans_indiv!=. & nbloans_indiv>0
label values dummyloans_indiv yesno
ta dummyloans_indiv year, col

* Loan amount
replace loanbalance_indiv=0 if loanbalance_indiv==.
replace loanbalance_indiv=. if dummyloans_indiv==0

* DSR
gen dsr_indiv=(imp1_ds_tot_indiv*100)/annualincome_indiv
replace dsr_indiv=0 if dsr_indiv==.
replace dsr_indiv=. if dummyloans_indiv==0

* ISR
gen isr_indiv=(imp1_is_tot_indiv*100)/annualincome_indiv
replace isr_indiv=0 if isr_indiv==.
replace isr_indiv=. if dummyloans_indiv==0

* DIR
gen dir_indiv=(loanbalance_indiv*100)/annualincome_indiv
replace dir_indiv=0 if dir_indiv==.
replace dir_indiv=. if dummyloans_indiv==0

* Log
foreach x in loanbalance_indiv dsr_indiv isr_indiv dir_indiv {
gen log_`x'=log(`x')
}


********** Controls
* Panelvar
egen panelvar=group(HHID_panel INDID_panel)

* Dalits
gen dalits=.
replace dalits=1 if caste==1
replace dalits=0 if caste==2
replace dalits=0 if caste==3
label define dalits 0"Non-dalits" 1"Dalits"
label values dalits dalits

* 
fre sex
gen female=0 if sex==1
replace female=1 if sex==2
order female, after(sex)
ta female sex
drop sex

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

save"panel_indiv_v1", replace
****************************************
* END
















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

* DSR
gen dsr=(imp1_ds_tot_HH*100)/annualincome_HH
replace dsr=0 if dsr==.

* ISR
gen isr=(imp1_is_tot_HH*100)/annualincome_HH
replace isr=0 if isr==.

* DAR
gen dar=(loanbalance_HH*100)/(assets_total1000*1000)
replace dar=0 if dar==.

* DIR
gen dir=(loanbalance_HH*100)/annualincome_HH
replace dir=0 if dir==.

* Log
foreach x in dsr isr dar dir {
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

********** Drop
drop nbloans_HH loanamount_HH



********** Order
order HHID_panel year
sort HHID_panel year


save"panel_HH_v1", replace
****************************************
* END


















****************************************
* Indiv construct
****************************************
use"panel_indiv_v1", clear

* Rename
rename log_loanbalance_indiv log_loan
rename log_dsr_indiv log_dsr
rename log_isr_indiv log_isr
rename log_dir_indiv log_dir

* Time period 1: 2016 to 2020
preserve
keep HHID_panel INDID_panel time log_dsr log_isr log_loan log_dir
keep if time==1 | time==2
bys HHID_panel INDID_panel: gen n=_N
keep if n==2
ta time
reshape wide log_dsr log_isr log_loan log_dir, i(HHID_panel INDID_panel) j(time)
gen timeperiod=1
gen year=2016
order HHID_panel INDID_panel timeperiod year
drop n
save"_temp_tp1", replace
restore

* Time period 2: 2020 to 2026
preserve
keep HHID_panel INDID_panel time log_dsr log_isr log_loan log_dir
keep if time==2 | time==3
bys HHID_panel INDID_panel: gen n=_N
keep if n==2
ta time
reshape wide log_dsr log_isr log_loan log_dir, i(HHID_panel INDID_panel) j(time)
gen timeperiod=2
gen year=2020
order HHID_panel INDID_panel timeperiod year
foreach x in dsr isr loan dir {
rename log_`x'2 log_`x'1
rename log_`x'3 log_`x'2
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
* HH construct
****************************************
use"panel_HH_v1", clear

* Time period 1: 2010 to 2016
preserve
rename assets_total1000 wealth
rename annualincome_HH income
keep HHID_panel time log_dsr log_isr log_dar log_dir wealth income
keep if time==1 | time==2
bys HHID_panel: gen n=_N
keep if n==2
ta time
reshape wide log_dsr log_isr log_dar log_dir wealth income, i(HHID_panel) j(time)
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
keep HHID_panel time log_dsr log_isr log_dar log_dir wealth income
keep if time==2 | time==3
bys HHID_panel: gen n=_N
keep if n==2
ta time
reshape wide log_dsr log_isr log_dar log_dir wealth income, i(HHID_panel) j(time)
gen timeperiod=2
gen year=2016
order HHID_panel timeperiod year
foreach x in dsr isr dar dir {
rename log_`x'2 log_`x'1
rename log_`x'3 log_`x'2
}
rename income2 income1
rename wealth2 wealth1
rename income3 income2
rename wealth3 wealth2
drop n
save"_temp_tp2", replace
restore

* Time period 3: 2020 to 2026
preserve
rename assets_total1000 wealth
rename annualincome_HH income
keep HHID_panel time log_dsr log_isr log_dar log_dir wealth income
keep if time==3 | time==4
bys HHID_panel: gen n=_N
keep if n==2
ta time
reshape wide log_dsr log_isr log_dar log_dir wealth income, i(HHID_panel) j(time)
gen timeperiod=3
gen year=2020
order HHID_panel timeperiod year
foreach x in dsr isr dar dir {
rename log_`x'3 log_`x'1
rename log_`x'4 log_`x'2
}
rename income3 income1
rename wealth3 wealth1
rename income4 income2
rename wealth4 wealth2
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


