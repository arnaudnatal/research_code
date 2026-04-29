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

* DIR
gen dir_indiv=(loanbalance_indiv*100)/annualincome_indiv
replace dir_indiv=0 if dir_indiv==.
replace dir_indiv=. if dummyloans_indiv==0



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
gen log_dsr=log(dsr)

* ISR
gen isr=(imp1_is_tot_HH*100)/annualincome_HH
replace isr=0 if isr==.
gen log_isr=log(isr)

* DAR
gen dar=(loanbalance_HH*100)/(assets_total1000*1000)
replace dar=0 if dar==.
gen log_dar=log(dar)

* DIR
gen dir=(loanbalance_HH*100)/annualincome_HH
replace dir=0 if dir==.
gen log_dir=log(dir)


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
replace dalits=0 if caste==2
replace dalits=0 if caste==3
label define dalits 1"Dalits" 0"Non-dalits"
label values dalits dalits

********** Drop
drop nbloans_HH loanamount_HH



********** Order
order HHID_panel year
sort HHID_panel year


save"panel_HH_v1", replace
****************************************
* END

