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
* HH construct
****************************************
use"panel_HH_v1", clear

* Niveau
recode dsr isr (.=0)
foreach x in dsr isr {
gen `x'_r=`x'
sum `x'_r, det
replace `x'_r=`r(p99)' if `x'_r>`r(p99)' & `x'_r!=.
}

foreach x in dsr isr {
gen `x'_rb=`x'
sum `x'_rb, det
replace `x'_rb=`r(p95)' if `x'_rb>`r(p95)' & `x'_rb!=.
}

* Var
global var dummyloans_HH dsr dsr_r dsr_rb isr isr_r isr_rb

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
* Dummies
****************************************
use"panel_HH_v2", clear

* Selection
/*
drop if timeperiod==.
keep if dummyloans_HH1==1
keep if dummyloans_HH2==1
drop if year==2020
*/
ta year
drop if year==2010

keep HHID_panel HHFE year ///
timeperiod dummyloans_HH1 dummyloans_HH2 ///
dsr1 dsr2 ///
dsr_r1 dsr_r2 ///
dsr_rb1 dsr_rb2 ///
isr1 isr2 ///
isr_r1 isr_r2 ///
isr_rb1 isr_rb2 ///
log_wealth log_income ///
HHsize HH_count_child ///
head_sex head_age head_mocc_occupation head_edulevel head_nonmarried ///
dummylock dummydemonetisation dummymarriage ///
dalits villageid ownland wealth_t income_t

* Vars
gen head_female=0
replace head_female=1 if head_sex==2
ta head_sex head_female
drop head_sex

ta head_mocc_occupation, m
ta head_mocc_occupation, gen(head_occ)
drop head_mocc_occupation

ta head_edulevel, m
ta head_edulevel, gen(head_educ)
drop head_edulevel

ta villageid, m
ta villageid, gen(village)
drop villageid

* First diff
gen d_isr=isr2-isr1
gen d_isr_r=isr_r2-isr_r1
gen d_isr_rb=isr_rb2-isr_rb1

gen d_dsr=dsr2-dsr1
gen d_dsr_r=dsr_r2-dsr_r1
gen d_dsr_rb=dsr_rb2-dsr_rb1

* Quadratic terms
gen dsr_1=dsr1
gen dsr_2=dsr1*dsr1
gen dsr_3=dsr1*dsr1*dsr1
gen dsr_4=dsr1*dsr1*dsr1*dsr1
gen dsr_r_1=dsr_r1
gen dsr_r_2=dsr_r1*dsr_r1
gen dsr_r_3=dsr_r1*dsr_r1*dsr_r1
gen dsr_r_4=dsr_r1*dsr_r1*dsr_r1*dsr_r1
gen dsr_rb_1=dsr_rb1
gen dsr_rb_2=dsr_rb1*dsr_rb1
gen dsr_rb_3=dsr_rb1*dsr_rb1*dsr_rb1
gen dsr_rb_4=dsr_rb1*dsr_rb1*dsr_rb1*dsr_rb1

gen isr_1=isr1
gen isr_2=isr1*isr1
gen isr_3=isr1*isr1*isr1
gen isr_4=isr1*isr1*isr1*isr1
gen isr_r_1=isr_r1
gen isr_r_2=isr_r1*isr_r1
gen isr_r_3=isr_r1*isr_r1*isr_r1
gen isr_r_4=isr_r1*isr_r1*isr_r1*isr_r1
gen isr_rb_1=isr_rb1
gen isr_rb_2=isr_rb1*isr_rb1
gen isr_rb_3=isr_rb1*isr_rb1*isr_rb1
gen isr_rb_4=isr_rb1*isr_rb1*isr_rb1*isr_rb1

* Age
gen head_age2=head_age*head_age

* Caste X Lands
gen dalitsXland=dalits*ownland

* Var pour CRE à la main
foreach x in dsr_1 dsr_2 dsr_3 dsr_4 dsr_r_1 dsr_r_2 dsr_r_3 dsr_r_4 dsr_rb_1 dsr_rb_2 dsr_rb_3 dsr_rb_4 isr_1 isr_2 isr_3 isr_4 isr_r_1 isr_r_2 isr_r_3 isr_r_4 isr_rb_1 isr_rb_2 isr_rb_3 isr_rb_4 head_female head_age head_age2 head_nonmarried head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 HHsize HH_count_child ownland log_wealth log_income dummylock dummydemonetisation dummymarriage dalitsXland {
bys HHID_panel: egen m_`x'=mean(`x')
}
bys HHID_panel: gen nby=_N
ta year, gen(y)

save"panel_HH_v3", replace
****************************************
* END
