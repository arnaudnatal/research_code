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
ta income_HH
*replace income_HH=5000 if income_HH<5000

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
* Worker ratio
gen worker=nbnonworker_HH/nbworker_HH
ta nbnonworker_HH if nbworker_HH==0
replace worker=nbnonworker_HH if nbworker_HH==0
ta worker

* Sexratio
gen sexratio=nbmale/nbfemale
replace sexratio=nbmale if nbfemale==0

* Agri
gen tot=incomeagri_HH+incomenonagri_HH
gen shareagri=incomeagri_HH*100/tot
replace shareagri=0 if incomeagri_HH==0
gen sharenonagri=incomenonagri_HH*100/tot
replace sharenonagri=0 if incomenonagri_HH==0
*
gen hhtype5=.
label define hhtype5 1"Agri" 2"Non-agri" 3"Mix"
label values hhtype5 hhtype5
replace hhtype5=1 if shareagri>95
replace hhtype5=2 if shareagri<5
replace hhtype5=3 if shareagri<=95 & shareagri>=5
ta hhtype5
*
gen hhtype10=.
label define hhtype10 1"Agri" 2"Non-agri" 3"Mix"
label values hhtype10 hhtype10
replace hhtype10=1 if shareagri>90
replace hhtype10=2 if shareagri<10
replace hhtype10=3 if shareagri<=90 & shareagri>=10
ta hhtype10
*
gen hhtype33=.
label define hhtype33 1"Agri" 2"Non-agri" 3"Mix"
label values hhtype33 hhtype33
replace hhtype33=1 if shareagri>66
replace hhtype33=2 if shareagri<33
replace hhtype33=3 if shareagri<=66 & shareagri>=33
ta hhtype33

* Agri 2
ta incagrise_HH
gen agriHH=0 if incagrise_HH==0 & incagrise_HH!=.
replace agriHH=1 if incagrise_HH>0 & incagrise_HH!=.
ta agriHH

ta ownland agriHH
ta landstatus agriHH 
ta hhtype5 agriHH
ta hhtype10 agriHH

* Agri 3
gen log_incagri=log(1+incomeagri_HH)
gen log_incnonagri=log(1+incomenonagri_HH)

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
gen log_wealth=log(assets_total1000)
gen log_wealthbis=log(assets_nolandnogold)
gen log_income=log(income_HH)
rename secondlockdownexposure dummylock
recode dummylock (1=0) (2=1) (3=1)
drop village
replace villageid="ELA" if villageid=="ELANTHALMPATTU"
replace villageid="GOV" if villageid=="GOVULAPURAM"
replace villageid="GOV" if villageid=="2"
replace villageid="KAR" if villageid=="KARUMBUR"
replace villageid="KOR" if villageid=="KORATTORE"
replace villageid="KUV" if villageid=="KUVAGAM"
replace villageid="MANAM" if villageid=="MANAMTHAVIZHINTHAPUTHUR"
replace villageid="MAN" if villageid=="MANAPAKKAM"
replace villageid="MAN" if villageid=="6"
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
gen w1_`x'=`x'
sum w1_`x', det
replace w1_`x'=`r(p99)' if w1_`x'>`r(p99)' & w1_`x'!=.
}


foreach x in dsr isr {
gen w5_`x'=`x'
sum w5_`x', det
replace w5_`x'=`r(p95)' if w5_`x'>`r(p95)' & w5_`x'!=.
}

gen w2_dsr=dsr
replace w2_dsr=267 if w2_dsr>267 & w2_dsr!=.
gen w2_isr=isr
replace w2_isr=104 if w2_isr>104 & w2_isr!=.


* Var
global var dummyloans_HH dsr w1_dsr w2_dsr w5_dsr isr w1_isr w2_isr w5_isr 

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
drop income_t1 income_t2 income_t3 wealth_t1 wealth_t2 wealth_t3

*
ta goldquantity_HH, m
recode goldquantity_HH (.=0)

save"panel_HH_v2", replace
****************************************
* END











****************************************
* Dummies
****************************************
use"panel_HH_v2", clear

* Selection
keep HHID_panel HHFE year ///
timeperiod dummyloans_HH1 dummyloans_HH2 ///
dsr1 dsr2 ///
w1_dsr1 w1_dsr2 ///
w2_dsr1 w2_dsr2 ///
w5_dsr1 w5_dsr2 ///
isr1 isr2 ///
w1_isr1 w1_isr2 ///
w2_isr1 w2_isr2 ///
w5_isr1 w5_isr2 ///
log_wealth log_income ///
HHsize HH_count_child ///
head_sex head_age head_mocc_occupation head_edulevel head_nonmarried ///
dummylock dummydemonetisation dummymarriage_m dummymarriage_f ///
dalits villageid ownland wealth_t income_t ///
assets_nolandnogold goldquantity_HH saving landstatus hhtype5 hhtype10 hhtype33 worker agriHH log_wealthbis sexratio log_incagri log_incnonagri shareagri sharenonagri

* Vars
ta villageid

ta saving
gen log_saving=log(1+saving)
drop saving

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

ta hhtype5, m
ta hhtype5, gen(hhtype5_)

ta hhtype10, m
ta hhtype10, gen(hhtype10_)

replace shareagri=shareagri/10
ta shareagri

* First diff
gen diff_isr=isr2-isr1
gen diff_w1_isr=w1_isr2-w1_isr1
gen diff_w2_isr=w2_isr2-w2_isr1
gen diff_w5_isr=w5_isr2-w5_isr1

gen diff_dsr=dsr2-dsr1
gen diff_w1_dsr=w1_dsr2-w1_dsr1
gen diff_w2_dsr=w2_dsr2-w2_dsr1
gen diff_w5_dsr=w5_dsr2-w5_dsr1

* Quadratic terms
gen dsr1_2=dsr1*dsr1
gen dsr1_3=dsr1*dsr1*dsr1
gen dsr1_4=dsr1*dsr1*dsr1*dsr1

gen w1_dsr1_2=w1_dsr1*w1_dsr1
gen w1_dsr1_3=w1_dsr1*w1_dsr1*w1_dsr1
gen w1_dsr1_4=w1_dsr1*w1_dsr1*w1_dsr1*w1_dsr1

gen w2_dsr1_2=w2_dsr1*w2_dsr1
gen w2_dsr1_3=w2_dsr1*w2_dsr1*w2_dsr1
gen w2_dsr1_4=w2_dsr1*w2_dsr1*w2_dsr1*w2_dsr1

gen w5_dsr1_2=w5_dsr1*w5_dsr1
gen w5_dsr1_3=w5_dsr1*w5_dsr1*w5_dsr1
gen w5_dsr1_4=w5_dsr1*w5_dsr1*w5_dsr1*w5_dsr1

gen isr1_2=isr1*isr1
gen isr1_3=isr1*isr1*isr1
gen isr1_4=isr1*isr1*isr1*isr1

gen w1_isr1_2=w1_isr1*w1_isr1
gen w1_isr1_3=w1_isr1*w1_isr1*w1_isr1
gen w1_isr1_4=w1_isr1*w1_isr1*w1_isr1*w1_isr1

gen w2_isr1_2=w2_isr1*w2_isr1
gen w2_isr1_3=w2_isr1*w2_isr1*w2_isr1
gen w2_isr1_4=w2_isr1*w2_isr1*w2_isr1*w2_isr1

gen w5_isr1_2=w5_isr1*w5_isr1
gen w5_isr1_3=w5_isr1*w5_isr1*w5_isr1
gen w5_isr1_4=w5_isr1*w5_isr1*w5_isr1*w5_isr1

* Age
gen head_age2=head_age*head_age

* Caste X Lands
gen dalitsXland=dalits*ownland

save"panel_HH_v3", replace
****************************************
* END
