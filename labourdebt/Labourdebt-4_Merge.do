*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*December 5, 2023
*-----
gl link = "labourdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------









****************************************
* Merge all the databases
****************************************
use"laboursupply_indiv", clear

ta year

* Controls
merge m:m HHID_panel year using "panel_cont_v1"
keep if _merge==3
drop _merge

* Debt HH
merge m:m HHID_panel year using "panel_debt_noinvest_v2"
drop if _merge==2
drop _merge

* Debt indiv
merge 1:1 HHID_panel INDID_panel year using "panel_sharedsr_v2"
drop if _merge==2
drop _merge

* Panel var
egen panelvar=group(HHID_panel INDID_panel)
order HHID_panel INDID_panel panelvar year

* FE
encode HHID_panel, gen(HHFE)
order HHID_panel HHFE INDID_panel panelvar year

* Clear
drop assets_total1000 assets_totalnoland1000 assets_totalnoprop1000


* Merge HH data
merge m:1 HHID_panel year using "laboursupply_HH"
drop _merge

ta year

save"panel_laboursupplyindiv", replace
****************************************
* END













****************************************
* Ratio
****************************************
use"panel_laboursupplyindiv", clear

preserve
keep HHID_panel year nbloans_HH
duplicates drop
ta nbloans_HH year
restore

* DAR
gen DAR=(loanamount_HH/assets_total)*100

* DAR lag
gen DAR_lag=(lag_loanamount_HH/lag_assets_total)*100

* DAR2
gen DAR2=(loanbalance_HH/assets_total)*100

* DAR2 lag
gen DAR2_lag=(lag_loanbalance_HH/lag_assets_total)*100

* DSR
gen DSR=(imp1_ds_tot_HH/annualincome_HH)*100
preserve
keep HHID_panel DSR year
duplicates drop
ta year
tabstat DSR, stat(n) by(year)
restore
recode DSR (.=0)

* DSR lag
gen DSR_lag=(lag_imp1_ds_tot_HH/lag_annualincome_HH)*100
preserve
keep HHID_panel DSR_lag year panel
duplicates drop
ta year panel
tabstat DSR_lag, stat(n) by(year)
restore
replace DSR_lag=0 if DSR_lag==. & panel==1
preserve
keep HHID_panel DSR_lag year panel
duplicates drop
ta year panel
tabstat DSR_lag, stat(n) by(year)
restore


* ISR
gen ISR=(imp1_is_tot_HH/annualincome_HH)*100

* ISR lag
gen ISR_lag=(lag_imp1_is_tot_HH/lag_annualincome_HH)*100

* TDR
gen TDR=(totHH_givenamt_repa/loanamount_HH)*100

* TDR lag
gen TDR_lag=(lag_totHH_givenamt_repa/lag_loanamount_HH)*100


* Panel
bysort HHID_panel INDID_panel: gen n=_N
rename n dummypanelindiv
ta dummypanelindiv
order HHID_panel HHID year dummypanel dummypanelindiv
sort HHID_panel year

* Recode edulevel
fre edulevel
recode edulevel (.=0) (4=3) (5=3)
fre edulevel
label define edulevel 0"Edu: Below prim" 1"Edu: Prim comp" 2"Edu: High school" 3"Edu: HSC or more", replace
fre edulevel

* Label age
label var age "Age"

* Label relationshiptohead
fre relationshiptohead
clonevar relation=relationshiptohead
fre relation
recode relation (4=3) (5=4) (6=4) (7=5) (8=5) (9=6) (10=6) (11=7) (12=7) (13=8) (15=9) (16=9) (17=10) (77=10)
label define relation 1"Rela: Head" 2"Rela: Wife/husband" 3"Rela: Parents" 4"Rela: Children" 5"Rela: Child-in-law" 6"Rela: Siblings" 7"Rela: Parents-in-law" 8"Rela: Grandchild" 9"Rela: Grand-parents" 10"Rela: Other" 
label values relation relation
ta relationshiptohead relation
fre relation
recode relation (9=10)

* Relation 2
clonevar relation2=relation
fre relation2
recode relation2 (6=10) (7=10)
recode relation2 (8=6) (10=7)
label define relation2 1"Rela: Head" 2"Rela: Wife/husband" 3"Rela: Parents" 4"Rela: Children" 5"Rela: Child-in-law" 6"Rela: Grandchild" 7"Rela: Other" 
label values relation2 relation2
fre relation2
ta relation relation2

* MOC
fre mainocc_occupation_indiv
label define mainocc_occupation_indiv 1"MOC: Agri SE" 2"MOC: Agri casual" 3"MOC: Casual" 4"MOC: Reg non-quali" 5"MOC: Reg quali" 6"MOC: SE" 7"MOC: MGNREGA"
label values mainocc_occupation_indiv mainocc_occupation_indiv

*
fre sex
label define sex 1"Sex: Male" 2"Sex: Female", replace
fre sex

* Land ownership
gen landowner=.
replace landowner=0 if assets_sizeownland==.
replace landowner=1 if assets_sizeownland!=.

label define landowner 0"Land: No" 1"Land: Yes"
label values landowner landowner
label var landowner "Does your household own land?"


* Average monthly expenses
gen monthlyexpenses=(expenses_total/12)/HHsize
label var monthlyexpenses "Monthly per capita expenses (INR)"

* Remittances received?
gen dummyremrec=.
replace dummyremrec=0 if remreceived_HH==0
replace dummyremrec=1 if remreceived_HH>1
label define dummyremrec 0"Rem. received: No" 1"Rem. received: Yes"
label values dummyremrec dummyremrec
label var dummyremrec "Does your household receive remittances?"


* Hours a week
tabstat hoursayear_indiv, stat(n mean q p90 p95 p99 max)

gen hoursaweek_indiv=hoursayear_indiv/52
gen hoursamonth_indiv=hoursayear_indiv/12

gen hoursaweek_HH=hoursayear_HH/52
gen hoursamonth_HH=hoursayear_HH/12

foreach x in male female old agriself agricasu casua regnonqu regquali self nrega agri nonagri selfemp casu {
gen hoursaweek_`x'_HH=hours_`x'_HH/52
gen hoursamonth_`x'_HH=hours_`x'_HH/12
}


* Edulevel HH head
fre head_edulevel
recode head_edulevel (4=3) (5=3)

* Caste dalits
fre caste
gen dalits=.
replace dalits=0 if caste==2
replace dalits=0 if caste==3
replace dalits=1 if caste==1
label define dalits 0"Dalits: No" 1"Dalits: Yes"
label values dalits dalits
order dalits, after(caste)


* Sex year for stat desc
egen sexyear=group(sex year), label


* Relationshiptohead2
clonevar relationshiptohead2=relationshiptohead
order relationshiptohead2, after(relationshiptohead)
fre relationshiptohead2
recode relationshiptohead2 (4=3) (11=3) (12=3)  // Parents + in-law
recode relationshiptohead2 (10=9)  // Siblings
recode relationshiptohead2 (15=77) (16=77) (17=77)  // Others
fre relationshiptohead2
recode relationshiptohead2 (5=4) (6=5) (7=6) (8=7) (9=8) (13=9) (77=10)
label define relationshiptohead2 1"Head" 2"Wife" 3"Parents" 4"Son" 5"Daughter" 6"Son-in-law" 7"Daughter-in-law" 8"Siblings" 9"Grandchild" 10"Others"
label values relationshiptohead2 relationshiptohead2

* Time
gen time=0
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time


* Std
egen assets_std=std(assets_total)
egen remitt_std=std(remittnet_HH)

* 1k remittances
replace remittnet_HH=remittnet_HH/1000 


* 10k assets
replace assets_total=assets_total/10000


* Label
label var remitt_std "Net remittances (std)"
label var assets_std "Assets (std)"
label var remittnet_HH "Net remittances"
label var assets_total "Assets"
label var dummymarriage "Experiencing marriage (% of yes)"
label var HHsize "HH size"
label var HH_count_child "No. of children" 
label var sexratio "Sex ratio"

* Age
tabstat age, stat(n mean q)
gen cat_age=.
replace cat_age=1 if age<25
replace cat_age=2 if age>=25 & age<35
replace cat_age=3 if age>=35 & age<50
replace cat_age=4 if age>=50
label define cat_age 1"Age: Below 25" 2"Age: 25-34" 3"Age: 35-49" 4"Age: 50 or more"
label values cat_age cat_age






save"panel_laboursupplyindiv_v2", replace
****************************************
* END


