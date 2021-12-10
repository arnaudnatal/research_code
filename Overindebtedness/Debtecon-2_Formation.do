cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
September 30, 2021
-----
Panel for indebtedness and over-indebtedness
-----

-------------------------
*/









****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
********** Path to folder "data" folder.
global directory = "D:\Documents\_Thesis\Research-Overindebtedness\Persistence_over"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
set scheme plotplain

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH_v8"
global wave3 "NEEMSIS2-HH_v19"

global loan1 "RUME-loans_v8"
global loan2 "NEEMSIS1-loans_v4"
global loan3 "NEEMSIS2-all_loans"



********** Deflate
*https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
*(100/158) if year==2016
*(100/184) if year==2020



****************************************
* END








****************************************
* PANEL
***************************************
use"$directory\\$wave1", clear
duplicates drop HHID_panel, force
keep HHID_panel year
rename year year2010
save"$directory\_temp$wave1", replace

use"$directory\\$wave2", clear
duplicates drop HHID_panel, force
keep HHID_panel year
rename year year2016
save"$directory\_temp$wave2", replace

use"$directory\\$wave3", clear
duplicates drop HHID_panel, force
keep HHID_panel year
rename year year2020
save"$directory\_temp$wave3", replace


*Merge all
use"_temp$wave1", clear
merge 1:1 HHID_panel using "_temp$wave2"
drop _merge
merge 1:1 HHID_panel using "_temp$wave3"
drop _merge



*One var
gen panel=0
replace panel=1 if year2010!=. & year2016!=. & year2020!=.
tab panel


keep HHID_panel year2010 year2016 year2020 panel

foreach x in 2010 2016 2020{
recode year`x' (.=0) (`x'=1)
}

sort HHID_panel

save"panel", replace
erase "$directory\_temp$wave1.dta"
erase "$directory\_temp$wave2.dta"
erase "$directory\_temp$wave3.dta"
****************************************
* END









****************************************
* Base panel
****************************************
use"$wave1-_temp", clear


*Append
append using "$wave2-_temp"
append using "$wave3-_temp"


*Panel
*merge m:1 HHID_panel using "panel"
*keep if _merge==3
*drop _merge


*Only keep full panel
tab panel
dis 1146/3
*keep if panel==1
*drop year2010 year2016 year2020 panel

* 1000
foreach x in loanamount_HH annualincome_HH amountownland {
gen `x'1000=`x'/1000
}

drop if year==.
ta year

save"panel_v2", replace
****************************************
* END























****************************************
* Var creation
****************************************
use"panel_v2", clear


********** Assets
/*
Thanks to analysis that i have already done, i observe that assets are strange
Indeed, very big increasing (2010-2016) and then very big decreasing (2016-2020).
Pb with the amount of house for a number of HH
Pb with the amount of gold for a number of HH
Because of *3 between 2010 and 2016 then /2
45 HH concerned
*/
egen livestock_2010=rowtotal(livestockamount_goat_2010 livestockamount_cow_2010)
egen livestock_2016=rowtotal(livestockamount_cow_2016 livestockamount_goat_2016 livestockamount_chicken_2016 livestockamount_bullock_2016)
egen livestock_2020=rowtotal(livestockamount_cow_2020 livestockamount_goat_2020 livestockamount_chicken_2020 livestockamount_bullock_2020 livestockamount_bull_2020)
drop livestockamount_goat_2010 livestockamount_cow_2010 livestockamount_cow_2016 livestockamount_goat_2016 livestockamount_chicken_2016 livestockamount_bullock_2016 livestockamount_cow_2020 livestockamount_goat_2020 livestockamount_chicken_2020 livestockamount_bullock_2020 livestockamount_bull_2020

global asse2010 livestock_2010 housevalue_2010 goldquantityamount_2010 goodtotalamount_2010
global asse2016 livestock_2016 housevalue_2016 goldquantityamount_2016 goodtotalamount_2016
global asse2020 livestock_2020 housevalue_2020 goldquantityamount_2020 goodtotalamount_2020

foreach x in livestock housevalue goldquantityamount goodtotalamount {
gen `x'=.
}
foreach x in livestock housevalue goldquantityamount goodtotalamount {
foreach i in 2010 2016 2020 {
replace `x'=`x'_`i' if year==`i'
}
}
drop $asse2010 $asse2016 $asse2020
global asse livestock housevalue goldquantityamount goodtotalamount
foreach x in $asse {
recode `x' (.=0)
}




********** Land
cls
foreach x in amountownlanddry_2010 amountownlandwet_2010 amountownland amountownland_2016 amountownland_2020 amountownland1000 {
ta `x' year
}
drop amountownlanddry_2010 amountownlandwet_2010 amountownland1000
rename amountownland amountownland_2010
gen amountownland=.
foreach i in 2010 2016 2020 {
replace amountownland=amountownland_`i' if year==`i'
}
drop amountownland_2010 amountownland_2016 amountownland_2020
global asse amountownland livestock housevalue goldquantityamount goodtotalamount
foreach x in $asse {
recode `x' (.=0)
}




********** Nature assets
ta housetitle
ta houseroom
ta housesize, m

ta goldquantity, m




********** Time
fre year
gen time=0
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020

label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time

fre time


********** Panel var
encode HHID_panel, gen(panelvar)


********** Caste
replace caste=. if year==2010
replace caste=. if year==2020

bysort HHID_panel: egen max_caste=max(caste)
drop caste
rename max_caste caste
label values caste castecat
fre caste


********** Shock
recode dummydemonetisation dummymarriage (.=0)


********** Occupation
preserve
egen test=rowtotal(occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega)
gen test2=test-annualincome_HH
ta test2
restore


**********Agri income
egen agri_HH=rowtotal(occinc_HH_agri occinc_HH_agricasual)
egen nagri_HH=rowtotal(occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega)
preserve
egen income_HH=rowtotal(agri_HH nagri_HH)
gen test=income_HH-annualincome_HH
ta test
restore

gen shareagri_HH=agri_HH/annualincome_HH
gen sharenagri_HH=nagri_HH/annualincome_HH
preserve
egen test=rowtotal(shareagri_HH sharenagri_HH)
ta test
restore


********** 1000
foreach x in amountownland livestock housevalue goldquantityamount goodtotalamount loanamount_g_HH loanamount_gm_HH{
replace `x'=`x'/1000
rename `x' `x'1000
}


order HHID_panel panelvar year time panel
sort HHID_panel year 

save"panel_v3", replace
****************************************
* END
