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


* Debt
merge m:m HHID_panel year using "panel_debt_noinvest_v2"
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



save"panel_laboursupplyindiv_v2", replace
****************************************
* END


