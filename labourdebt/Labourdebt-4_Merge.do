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

* DSR lag
gen DSR_lag=(lag_imp1_ds_tot_HH/lag_annualincome_HH)*100

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


save"panel_laboursupplyindiv_v2", replace
****************************************
* END


