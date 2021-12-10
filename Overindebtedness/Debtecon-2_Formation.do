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
global wave3 "NEEMSIS2-HH"

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



*panel complet
gen panel=0
replace panel=1 if year2010!=. & year2016!=. & year2020!=.
tab panel

*panel 2010-2020
gen panel2=0
replace panel2=1 if panel==0 & year2010!=. & year2020!=.
ta panel2

*panel 2010-2016
gen panel3=0
replace panel3=1 if panel==0 & year2010!=. & year2016!=.
ta panel3

*panel 2016-2020
gen panel4=0
replace panel4=1 if panel==0 & year2016!=. & year2020!=.
ta panel4



keep HHID_panel year2010 year2016 year2020 panel panel2 panel3 panel4

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
use"$wave3-_temp", clear


*Append
append using "$wave2-_temp"
append using "$wave1-_temp"
drop _merge



*Panel
merge m:1 HHID_panel using "panel", keepusing(panel2 panel3 panel4)
drop if _merge==2
drop _merge


*Only keep full panel
tab panel
dis 1146/3
ta panel2
ta panel3
ta panel4

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



********** Religion
bysort HHID_panel: egen max_religion=max(religion)
order max_religion, after(religion)
drop religion
rename max_religion religion



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
recode `x' (0=.)
}

tab1 amountownland livestock housevalue goldquantityamount goodtotalamount


********** Nature assets
ta housetitle
ta houseroom
ta housesize, m

ta goldquantity, m




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
drop annualincome_HH loanamount_HH
foreach x in amountownland livestock housevalue goldquantityamount goodtotalamount loanamount_g_HH loanamount_gm_HH foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses marriageexpenses_HH occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega imp1_ds_tot_HH imp1_is_tot_HH agri_HH nagri_HH{
replace `x'=`x'/1000
rename `x' `x'1000
}



********** Rename for easier reading
*** drop 1000
foreach x in foodexpenses1000 educationexpenses1000 healthexpenses1000 ceremoniesexpenses1000 deathexpenses1000 assets1000 assets_noland1000 occinc_HH_agri1000 occinc_HH_agricasual1000 occinc_HH_nonagricasual1000 occinc_HH_nonagriregnonqual1000 occinc_HH_nonagriregqual1000 occinc_HH_selfemp1000 occinc_HH_nrega1000 imp1_ds_tot_HH1000 imp1_is_tot_HH1000 loanamount_g_HH1000 loanamount_gm_HH1000 marriageexpenses_HH1000 loanamount_HH1000 annualincome_HH1000 livestock1000 housevalue1000 goldquantityamount1000 goodtotalamount1000 amountownland1000 agri_HH1000 nagri_HH1000 {
local x2=substr("`x'",1,strlen("`x'")-4)
rename `x' `x2'
}


*** drop hh1
foreach x in mainocc_occupation_HH nboccupation_HH imp1_ds_tot_HH imp1_is_tot_HH loans_HH nbchildren_HH nontoworkers_HH femtomale_HH loanamount_g_HH loanamount_gm_HH marriageexpenses_HH loanamount_HH annualincome_HH agri_HH nagri_HH shareagri_HH sharenagri_HH {
local x2=substr("`x'",1,strlen("`x'")-3)
rename `x' `x2'
}


*** drop hh2
foreach x in occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega {
local x2=substr("`x'",11,strlen("`x'"))
rename `x' occinc_`x2'
}



********** Macro amt
global amt foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses assets assets_noland occinc_agri occinc_agricasual occinc_nonagricasual occinc_nonagriregnonqual occinc_nonagriregqual occinc_selfemp occinc_nrega imp1_ds_tot imp1_is_tot loanamount_g loanamount_gm marriageexpenses loanamount annualincome livestock housevalue goldquantityamount goodtotalamount amountownland agri nagri



**********Deflate: all in 2010 value 
***https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
foreach x in  $amt {
clonevar `x'_raw=`x'
replace `x'=`x'*(100/158) if year==2016 & `x'!=.
replace `x'=`x'*(100/184) if year==2020 & `x'!=.
}



********** Label
foreach x in $amt {
label variable `x' `"INR1k-deflate `: variable label `v''"'
}


********** Recode land
replace amountownland=. if amountownland==0

order HHID_panel panelvar year time panel villageid caste
sort HHID_panel year 


save"panel_v3", replace
****************************************
* END











****************************************
* Test caste
****************************************
use"panel_v3", clear

*** Initialization
xtset time panelvar


*** Select+reshape
keep HHID_panel year caste
reshape wide caste, i(HHID_panel) j(year)

fre caste*

*** Panel
forvalues i=1(1)4 {
gen panel`i'=0
}

replace panel1=1 if caste2010!=. & caste2016!=. & caste2020!=.
replace panel2=1 if caste2010!=. & caste2016!=. & panel1==0
replace panel3=1 if caste2010!=. & caste2020!=. & panel1==0
replace panel4=1 if caste2016!=. & caste2020!=. & panel1==0
fre panel*
egen panel=rowtotal(panel1 panel2 panel3 panel4)
order panel, before(panel1)

*** Changement
forvalues i=1(1)4 {
gen ok`i'=0 if panel`i'==1
}

replace ok1=1 if caste2010==caste2016 & caste2016==caste2020 & panel1==1
replace ok2=1 if caste2010==caste2016 & panel2==1
replace ok3=1 if caste2010==caste2020 & panel3==1
replace ok4=1 if caste2016==caste2020 & panel4==1

egen pb=rowtotal(ok1 ok2 ok3 ok4)
recode pb (0=1) (1=0)
replace pb=0 if panel==0
ta pb
sort HHID_panel
list HHID_panel if pb==1, clean noobs
/*
GOV10 GOV19 GOV2 GOV47 GOV5 GOV9 KAR48 KUV10 MAN18 MAN22 MANAM18 MANAM28 MANAM40 SEM1 SEM16 SEM26 SEM28 SEM35 SEM40 SEM43
*/
ta HHID_panel caste2010 if pb==1
*MANAM18
ta caste2016 caste2020 if HHID_panel=="MANAM18"
****************************************
* END







****************************************
* Clean caste
****************************************
use"panel_v3", clear

********** Caste
*** panel complet
ta caste year, m
ta caste year if panel==1, m

replace caste=3 if HHID_panel=="GOV10"
replace caste=3 if HHID_panel=="GOV19"
replace caste=3 if HHID_panel=="GOV2"
replace caste=3 if HHID_panel=="GOV47"
replace caste=3 if HHID_panel=="GOV5"
replace caste=3 if HHID_panel=="GOV9"
replace caste=2 if HHID_panel=="KAR48"
replace caste=3 if HHID_panel=="KUV10"
replace caste=3 if HHID_panel=="MAN18"
replace caste=2 if HHID_panel=="MAN22"
replace caste=2 if HHID_panel=="MANAM18"
replace caste=2 if HHID_panel=="MANAM28"
replace caste=3 if HHID_panel=="MANAM40"
replace caste=3 if HHID_panel=="SEM1"
replace caste=3 if HHID_panel=="SEM16"
replace caste=3 if HHID_panel=="SEM26"
replace caste=3 if HHID_panel=="SEM28"
replace caste=3 if HHID_panel=="SEM35"
replace caste=3 if HHID_panel=="SEM40"
replace caste=3 if HHID_panel=="SEM43"

save"panel_v4", replace
****************************************
* END
