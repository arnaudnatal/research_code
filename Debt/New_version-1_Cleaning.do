cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
19 avril 2021
-----
TITLE: CLEANING OVERINDEBTEDNESS


-------------------------
*/


clear all
global name "Arnaud"
set scheme plottig

global directory "D:\Documents\_Thesis\Research-Overindebtedness\New_version_with2020"
cd"$directory"


****************************************
* HH in panel
****************************************
*RUME
use "$directory\Data\RUME-HH_v8.dta", clear
bysort HHID_panel: gen n=_n
keep if n==1
rename year year2010
keep HHID_panel year2010
save"$directory\_paneldata\RUME-HH.dta", replace

use "$directory\Data\NEEMSIS1-HH_v7.dta", clear
bysort HHID_panel: gen n=_n
keep if n==1
gen year2016=2016
keep HHID_panel year2016
save"$directory\_paneldata\NEEMSIS1-HH.dta", replace

use "$directory\Data\NEEMSIS2-HH_v17.dta", clear
keep if version_HH!=.
bysort HHID_panel: gen n=_n
keep if n==1
tab version_HH
gen year2020=2020
keep HHID_panel year2020
save"$directory\_paneldata\NEEMSIS2-HH.dta", replace

use"$directory\_paneldata\RUME-HH.dta", clear
merge 1:1 HHID_panel using "$directory\_paneldata\NEEMSIS1-HH.dta"
rename _merge RUME_NEEMSIS1

merge 1:1 HHID_panel using "$directory\_paneldata\NEEMSIS2-HH.dta"
rename _merge RUME_NEEMSIS2

tab year2010
*405
tab year2016
*492
tab year2020
*491

gen panel_2010_2016=0
replace panel_2010_2016=1 if year2010!=. & year2016!=.
tab panel_2010_2016
*388

gen panel_2010_2020=0
replace panel_2010_2020=1 if year2010!=. & year2020!=.
tab panel_2010_2020
*389

gen panel_2016_2020=0
replace panel_2016_2020=1 if year2016!=. & year2020!=.
tab panel_2016_2020
*481

gen panel_2010_2016_2020=0
replace panel_2010_2016_2020=1 if year2010!=. & year2016!=. & year2020!=.
tab panel_2010_2016_2020
*379	

drop RUME_NEEMSIS1 RUME_NEEMSIS2
drop year2010 year2016 year2020
save"$directory\_paneldata\panel_comp.dta", replace
****************************************
* END










****************************************
* ALL LOANS in same db
****************************************

********** Cleaning loans before append
*2010
use"$directory\Data\RUME-loans_v10.dta", clear
merge m:m HHID2010 using "$directory\_paneldata\unique_identifier_panel.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename loaneffectivereason loaneffectivereason2010
rename guarantorloanrelation guarantorloanrelation2010
rename lenderrelation lenderrelation2010
tab loansettled // 156
save"$directory\Data\RUME-loans_v10_new.dta", replace

*2016
use"$directory\Data\NEEMSIS1-loans_v11.dta", clear
rename parent_key HHID
merge m:m HHID using "$directory\_paneldata\unique_identifier_panel.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename HHID parent_key
rename loaneffectivereason loaneffectivereason2016
rename guarantorloanrelation guarantorloanrelation2016
rename lenderrelation lenderrelation2016
tab loansettled  // 15
save"$directory\Data\NEEMSIS1-loans_v11_new.dta", replace

*2020
use"$directory\Data\NEEMSIS2-loans_v13.dta", clear
rename loaneffectivereason loaneffectivereason2020
rename guarantorloanrelation guarantorloanrelation2020
rename lenderrelation lenderrelation2020
tab loansettled  // 
save"$directory\Data\NEEMSIS2-loans_v13_new.dta", replace


********** Append
use"$directory\Data\RUME-loans_v10_new.dta", clear
append using "$directory\Data\NEEMSIS1-loans_v11_new.dta"
append using "$directory\Data\NEEMSIS2-loans_v13_new.dta"

tab HHID_panel, m
keep if loanamount!=.
tab loanreasongiven year, m
tab year
/*
       year |      Freq.     Percent        Cum.
------------+-----------------------------------
       2010 |      2,396       28.17       28.17
       2016 |      2,349       27.61       55.78
       2020 |      3,762       44.22      100.00
------------+-----------------------------------
      Total |      8,507      100.00
*/
save"$directory\_paneldata\panel-all_loans.dta", replace
****************************************
* END












****************************************
* CLEANING
****************************************
use"$directory\_paneldata\panel-all_loans.dta", clear

*Merge les HH en panel
merge m:1 HHID_panel using"$directory\_paneldata\panel_comp.dta"
drop _merge

order HHID_panel, first

tab loansettled

save"$directory\_paneldata\panel-all_loans_v2.dta", replace
****************************************
* END









****************************************
* Panel dim?
****************************************
use"$directory\Data\RUME-HH_v8.dta", clear
drop panel_2010_2016 panel_2010_2020 panel_2016_2020 panel_2010_2016_2020
merge m:1 HHID_panel using "$directory\_paneldata\panel_comp.dta"
keep if _merge==3
drop _merge
preserve
duplicates drop HHID_panel, force
tab1 panel_2010_2016 panel_2010_2020 panel_2016_2020 panel_2010_2016_2020
restore
*Garder HH charact + assets, debt, hh size, housetype
foreach x in sex edulevel mainoccupation_indiv age nboccupation_indiv {
gen _head_`x'=`x' if relationshiptohead==1
bysort HHID_panel: egen head_`x'=max(_head_`x')
drop _head_`x'
}
keep if livinghome==1
bysort HHID_panel: egen hhsize=sum(1)
keep HHID_panel address villageid villagearea comefrom ///
head_* ///
mainoccupation_HH annualincome_HH nboccupation_HH imp1_ds_tot_HH imp1_is_tot_HH informal_HH semiformal_HH formal_HH economic_HH current_HH humancap_HH social_HH house_HH incomegen_HH noincomegen_HH economic_amount_HH current_amount_HH humancap_amount_HH social_amount_HH house_amount_HH incomegen_amount_HH noincomegen_amount_HH informal_amount_HH formal_amount_HH semiformal_amount_HH marriageloan_HH marriageloanamount_HH dummyproblemtorepay_HH dummyinterest_HH loans_HH loanamount_HH loanbalance_HH mean_yratepaid_HH mean_monthlyinterestrate_HH ///
jatis caste religion house howbuyhouse housevalue housetitle housetype ///
landowndry landownwet amountownlanddry amountownlandwet amountownland ///
assets assets_noland hhsize goldquantity goldquantityamount electricity water ///
panel_2016_2020 panel_2010_2020 panel_2010_2016_2020 panel_2010_2016
foreach x in *{
rename `x' `x'_2010
}
rename HHID_panel_2010 HHID_panel
duplicates drop HHID_panel, force
save"$directory\_paneldata\RUME-HH.dta", replace
keep if panel_2010_2016_2020==1
duplicates drop HHID_panel, force
save"$directory\_paneldata\RUME-HH_panel.dta", replace


use "$directory\Data\NEEMSIS1-HH_v7.dta", clear
drop panel_2010_2016 panel_2010_2020 panel_2016_2020 panel_2010_2016_2020
merge m:1 HHID_panel using "$directory\_paneldata\panel_comp.dta"
keep if _merge==3
drop _merge
preserve
duplicates drop HHID_panel, force
tab1 panel_2010_2016 panel_2010_2020 panel_2016_2020 panel_2010_2016_2020
restore
*Garder HH charact + assets, debt, hh size, housetype
foreach x in sex edulevel mainoccupation_indiv age nboccupation_indiv {
gen _head_`x'=`x' if relationshiptohead==1
bysort HHID_panel: egen head_`x'=max(_head_`x')
drop _head_`x'
}
keep if livinghome==1 | livinghome==2
bysort HHID_panel: egen hhsize=sum(1)
keep HHID_panel address villageid villagearea comefrom ///
head_* ///
mainoccupation_HH annualincome_HH nboccupation_HH imp1_ds_tot_HH imp1_is_tot_HH informal_HH semiformal_HH formal_HH economic_HH current_HH humancap_HH social_HH house_HH incomegen_HH noincomegen_HH economic_amount_HH current_amount_HH humancap_amount_HH social_amount_HH house_amount_HH incomegen_amount_HH noincomegen_amount_HH informal_amount_HH formal_amount_HH semiformal_amount_HH marriageloan_HH marriageloanamount_HH dummyproblemtorepay_HH dummyinterest_HH loans_HH loanamount_HH loanbalance_HH mean_yratepaid_HH mean_monthlyinterestrate_HH ///
jatis caste religion house howbuyhouse housevalue housetitle housetype ///
sizeownland ownland landpurchasedhowbuy landpurchasedamount landpurchasedacres landpurchased landlostreason landlost drywetownland amountownlandwet amountownlanddry amountownland ///
assets assets_noland hhsize goldquantity goldquantityamount electricity water ///
panel_2016_2020 panel_2010_2020 panel_2010_2016_2020 panel_2010_2016 dummydemonetisation dummynewHH loanamount_wm_HH
foreach x in *{
rename `x' `x'_2016
}
rename HHID_panel_2016 HHID_panel
duplicates drop HHID_panel, force
save"$directory\_paneldata\NEEMSIS1-HH.dta", replace
keep if panel_2010_2016_2020==1
duplicates drop HHID_panel, force
save"$directory\_paneldata\NEEMSIS1-HH_panel.dta", replace


use"$directory\Data\NEEMSIS2-HH_v17.dta", clear
merge m:1 HHID_panel using "$directory\_paneldata\panel_comp.dta"
keep if _merge==3
drop _merge
preserve
duplicates drop HHID_panel, force
tab1 panel_2010_2016 panel_2010_2020 panel_2016_2020 panel_2010_2016_2020
restore
*Garder HH charact + assets, debt, hh size, housetype
foreach x in sex edulevel mainoccupation_indiv age nboccupation_indiv {
gen _head_`x'=`x' if relationshiptohead==1
bysort HHID_panel: egen head_`x'=max(_head_`x')
drop _head_`x'
}
keep if livinghome==1 | livinghome==2
bysort HHID_panel: egen hhsize=sum(1)
keep HHID_panel address villageid villagearea comefrom ///
head_* ///
mainoccupation_HH annualincome_HH nboccupation_HH imp1_ds_tot_HH imp1_is_tot_HH informal_HH semiformal_HH formal_HH economic_HH current_HH humancap_HH social_HH house_HH incomegen_HH noincomegen_HH economic_amount_HH current_amount_HH humancap_amount_HH social_amount_HH house_amount_HH incomegen_amount_HH noincomegen_amount_HH informal_amount_HH formal_amount_HH semiformal_amount_HH marriageloan_HH marriageloanamount_HH dummyproblemtorepay_HH dummyinterest_HH loans_HH loanamount_HH loanbalance_HH mean_yratepaid_HH mean_monthlyinterestrate_HH ///
jatis caste religion house howbuyhouse housevalue housetitle housetype ///
covsellland ownland sizeownland landpurchased landpurchasedacres landpurchasedamount landpurchasedhowbuy landlost landlostreason sizedryownland sizewetownland amountownlanddry amountownlandwet amountownland ///
assets assets_noland hhsize goldquantity goldquantityamount electricity water ///
panel_2016_2020 panel_2010_2020 panel_2010_2016_2020 panel_2010_2016
foreach x in *{
rename `x' `x'_2020
}
rename HHID_panel_2020 HHID_panel
duplicates drop HHID_panel, force
save"$directory\_paneldata\NEEMSIS2-HH.dta", replace
keep if panel_2010_2016_2020==1
duplicates drop HHID_panel, force
save"$directory\_paneldata\NEEMSIS2-HH_panel.dta", replace
****************************************
* END





****************************************
* Formation panel
****************************************
use"$directory\_paneldata\RUME-HH.dta", clear
merge 1:1 HHID_panel using "$directory\_paneldata\NEEMSIS1-HH.dta"
drop _merge
merge 1:1 HHID_panel using "$directory\_paneldata\NEEMSIS2-HH.dta"
drop _merge
save"$directory\_paneldata\RUME-NEEMSIS-HH.dta", replace
****************************************
* END



****************************************
* Preli
****************************************
use"$directory\_paneldata\RUME-NEEMSIS-HH.dta", clear
foreach x in 2010 2016 2020 {
gen DAR_`x'=loanamount_HH_`x'*100/assets_`x'
gen DSR_`x'=imp1_ds_tot_HH_`x'*100/annualincome_HH_`x'
gen ISR_`x'=imp1_is_tot_HH_`x'*100/annualincome_HH_`x'
}

fsum DAR_2010 DAR_2016 DAR_2020, stat(p1 p5 p10 p25 p50 p75 p90 p95 p99)
fsum DSR_2010 DSR_2016 DSR_2020, stat(p1 p5 p10 p25 p50 p75 p90 p95 p99)
fsum ISR_2010 ISR_2016 ISR_2020, stat(p1 p5 p10 p25 p50 p75 p90 p95 p99)

********** Land issue
* 2010
tab1 landowndry_2010 landownwet_2010 amountownlanddry_2010 amountownlandwet_2010 amountownland_2010
rename landowndry_2010 sizedryownland_2010
rename landownwet_2010 sizewetownland_2010
gen sizeownland_2010=sizedryownland_2010+sizewetownland_2010

foreach x in DAR DSR ISR loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH annualincome_HH assets assets_noland loans_HH nboccupation_HH sizeownland amountownland amountownlanddry amountownlandwet {
gen d1_`x'=(`x'_2016-`x'_2010)*100/`x'_2010
gen d2_`x'=(`x'_2020-`x'_2016)*100/`x'_2016
gen dg_`x'=(`x'_2020-`x'_2010)*100/`x'_2010
}


foreach x in sizedryownland sizewetownland {
gen dg_`x'=(`x'_2020-`x'_2010)*100/`x'_2010
}



*Mini verif
tabstat DAR_2010 DAR_2016 DAR_2020, stat(n mean sd p50) by(caste_2016)

tabstat d1_DAR d2_DAR dg_DAR, stat(n mean sd p50) by(caste_2010)

save"$directory\_paneldata\RUME-NEEMSIS-HH_v2.dta", replace
****************************************
* END
