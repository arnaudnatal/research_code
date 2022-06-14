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

global user "Arnaud"
global folder "Documents"

********** Path to folder "data" folder.
global directory = "C:\Users\\$user\\$folder\_Thesis\Research-Overindebtedness\Persistence_over"
cd"$directory"
global git "C:\Users\\$user\\$folder\GitHub"

*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
*set scheme plotplain

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH"
global wave2 "NEEMSIS1-HH"
global wave3 "NEEMSIS2-HH"

global loan1 "RUME-all_loans"
global loan2 "NEEMSIS1-all_loans"
global loan3 "NEEMSIS2-all_loans"

* Scheme
set scheme plotplain_v2
grstyle init
grstyle set plain, box nogrid

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

* Expenses per year
gen food_expHH=foodexpenses*52
 
egen yearly_expenses=rowtotal(food_expHH educationexpenses healthexpenses)
egen yearly_expenses_bis=rowtotal(food_expHH educationexpenses healthexpenses ceremoniesexpenses deathexpenses)

replace yearly_expenses=yearly_expenses*(100/158) if year==2016
replace yearly_expenses=yearly_expenses*(100/184) if year==2020

replace yearly_expenses_bis=yearly_expenses*(100/158) if year==2016
replace yearly_expenses_bis=yearly_expenses*(100/184) if year==2020


* Povertyline
*Tendulkar Expert Group (2009): In 2005, another expert group chaired by Suresh Tendulkar was constituted to review the methodology for poverty estimation.
* --> food education and health: 2010INR 816 pm pc 
gen plphhpy=816*AEU_weight_HH*12
gen plphhpy1=816*AEU_weight1_HH*12
gen plphhpy2=816*AEU_weight2_HH*12

* ExpPLU
gen expPLU=yearly_expenses*100/plphhpy
gen expPLU1=yearly_expenses*100/plphhpy1
gen expPLU2=yearly_expenses*100/plphhpy2

gen below=.
gen below1=.
gen below2=.

replace below=0 if expPLU>=100
replace below1=0 if expPLU1>=100
replace below2=0 if expPLU2>=100

replace below=1 if expPLU<100
replace below1=1 if expPLU1<100
replace below2=1 if expPLU2<100

ta below caste if year==2010, col nofreq
ta below caste if year==2016, col nofreq
ta below caste if year==2020, col nofreq

* 1000
foreach x in loanamount_HH annualincome_HH amountownland assets assets_noland {
gen `x'1000=`x'/1000
drop `x'
}

drop if year==.
ta year

********** caste recode
drop jatis caste villagearea
merge 1:1 HHID_panel year using "C:\Users\Arnaud\Documents\GitHub\odriis\_Miscellaneous\Individual_panel\ODRIIS-HH_long", keepusing(jatis caste villagearea)
keep if _merge==3
drop _merge
encode caste, gen(caste_code)
fre caste_code
drop caste
rename caste_code caste


save"panel_v2", replace
****************************************
* END













****************************************
* Var creation
****************************************
use"panel_v2", clear


********** Replace
replace annualincome_HH1000=1 if annualincome_HH1000==0
replace annualincome_HH1000=1 if annualincome_HH1000==.

*sort annualincome
*br annualincome

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


global asse amountownland livestock housevalue goldquantityamount goodtotalamount
foreach x in $asse {
recode `x' (0=.)
}

ta amountownland year
tab1 amountownland livestock housevalue goldquantityamount goodtotalamount


replace assets1000=1 if assets1000==0
replace assets_noland1000=1 if assets_noland1000==0


*sort assets1000
*br HHID_panel amountownland livestock housevalue goldquantityamount goodtotalamount assets1000 assets_noland1000 if year==2016 & caste==2
*KOR22

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
gen test2=test/1000
gen test3=test2-annualincome_HH1000
ta test3
restore


**********Agri income
egen agri_HH=rowtotal(occinc_HH_agri occinc_HH_agricasual)
egen nagri_HH=rowtotal(occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega)
preserve
egen income_HH=rowtotal(agri_HH nagri_HH)
gen test=income_HH/1000
gen test2=test-annualincome_HH1000
ta test2
restore


gen shareagri_HH=agri_HH/(annualincome_HH1000*1000)
gen sharenagri_HH=nagri_HH/(annualincome_HH1000*1000)
preserve
egen test=rowtotal(shareagri_HH sharenagri_HH)
ta test
restore


cls
tabstat shareagri_HH, stat(n mean sd p50) by(year)
tabstat shareagri_HH if caste==1, stat(n mean sd p50) by(year)
tabstat shareagri_HH if caste==2, stat(n mean sd p50) by(year)
tabstat shareagri_HH if caste==3, stat(n mean sd p50) by(year)

cls
tabstat sharenagri_HH, stat(n mean sd p50) by(year)
tabstat sharenagri_HH if caste==1, stat(n mean sd p50) by(year)
tabstat sharenagri_HH if caste==2, stat(n mean sd p50) by(year)
tabstat sharenagri_HH if caste==3, stat(n mean sd p50) by(year)



********** 1000
foreach x in livestock housevalue goldquantityamount goodtotalamount foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses marriageexpenses_HH occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega imp1_ds_tot_HH imp1_is_tot_HH agri_HH nagri_HH{
replace `x'=`x'/1000
rename `x' `x'1000
}



********** Rename for easier reading
*** drop 1000
foreach x in foodexpenses1000 healthexpenses1000 ceremoniesexpenses1000 deathexpenses1000 occinc_HH_agri1000 occinc_HH_agricasual1000 occinc_HH_nonagricasual1000 occinc_HH_nonagriregnonqual1000 occinc_HH_nonagriregqual1000 occinc_HH_selfemp1000 occinc_HH_nrega1000 imp1_ds_tot_HH1000 imp1_is_tot_HH1000 marriageexpenses_HH1000 educationexpenses1000 loanamount_HH1000 annualincome_HH1000 amountownland1000 assets1000 assets_noland1000 livestock1000 housevalue1000 goldquantityamount1000 goodtotalamount1000 agri_HH1000 nagri_HH1000 {
local x2=substr("`x'",1,strlen("`x'")-4)
rename `x' `x2'
}


*** drop hh1
foreach x in nboccupation_HH loans_HH imp1_ds_tot_HH imp1_is_tot_HH nbchildren_HH nontoworkers_HH femtomale_HH marriageexpenses_HH mainocc_occupation_HH loanamount_HH annualincome_HH agri_HH nagri_HH shareagri_HH sharenagri_HH {
local x2=substr("`x'",1,strlen("`x'")-3)
rename `x' `x2'
}


*** drop hh2
foreach x in occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega {
local x2=substr("`x'",11,strlen("`x'"))
rename `x' occinc_`x2'
}



********** Macro amt
global amt foodexpenses healthexpenses ceremoniesexpenses deathexpenses occinc_agri occinc_agricasual occinc_nonagricasual occinc_nonagriregnonqual occinc_nonagriregqual occinc_selfemp occinc_nrega imp1_ds_tot imp1_is_tot marriageexpenses educationexpenses loanamount annualincome amountownland assets assets_noland livestock housevalue goldquantityamount goodtotalamount agri nagri



**********Deflate: all in 2010 value 
***https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
foreach x in  $amt {
clonevar `x'_raw=`x'
replace `x'=`x'*(100/158) if year==2016 & `x'!=.
replace `x'=`x'*(100/184) if year==2020 & `x'!=.
}

*rename loanamount_g_HH loanamount_g
*replace loanamount_g=loanamount_g*(100/158) if year==2016 & loanamount_g!=.


********** Label
foreach x in $amt {
label variable `x' `"INR1k-deflate `: variable label `v''"'
}


********** Recode land
replace amountownland=. if amountownland==0

order HHID_panel panelvar year time panel villageid caste
sort HHID_panel year 



********** Prepa loan
merge 1:1 HHID_panel year using "HH_newvar_temp.dta"
drop _merge

label var loanamount_HH "Without marriage in 2016-17"
*gen ok=1 if loanamount==loanamount_HH
*replace ok=1 if loanamount_HH==.
*fre ok
*sort ok HHID_panel year
*order HHID_panel year ok loanamount loanamount_HH  formal_HH informal_HH loanamount_raw
*sort ok year HHID_panel
*keep if panel==1

recode loanamount_HH (.=0)

rename loanamount loanamount_HH_withmarriagein2016
rename loanamount_HH loanamount



********** Label occupations
fre head_occupation
fre wifehusb_occupation
fre mainocc_occupation

codebook mainocc_occupation
label define occupcode 0"No occupation", modify
label values head_occupation occupcode
label values wifehusb_occupation occupcode

fre head_occupation
fre wifehusb_occupation


********** Label time year
codebook time
codebook year


save"panel_v3", replace
****************************************
* END








****************************************
* Ratio
****************************************
use"panel_v3", clear


********** Loan for repayment
rename loanforrepayment_nb_HH repay_nb_HH
rename loanforrepayment_amt_HH repay_amt_HH
rename rel_loanforrepayment_amt_HH rel_repay_amt_HH


********** Replace assets
/*
egen assetsnew=rowtotal(amountownland livestock housevalue_new goldquantityamount_new goodtotalamount)
egen assetsnew_noland=rowtotal(livestock housevalue_new goldquantityamount_new goodtotalamount)
gen assetsnew1000=assetsnew/1000
gen assetsnew_noland1000=assetsnew_noland/1000
drop assetsnew assetsnew_noland

tabstat assets1000 assetsnew1000 assets_noland1000 assetsnew_noland1000, stat(n mean sd p50) by(year)

global assecalc assets1000 assetsnew1000 assets_noland1000 assetsnew_noland1000
*/



**********Debt measure
tabstat loanamount, stat(mean sd p50) by(year)
forvalues i=1(1)3{
tabstat loanamount if caste==`i', stat(mean sd p50) by(year)
}

*Continuous
gen DIR=loanamount/annualincome

order HHID_panel year loanamount annualincome DIR
sort HHID_panel year

gen DAR_without=loanamount/assets_noland
gen DAR_with=loanamount/assets

*gen DAR_with_new=loanamount/assetsnew
*gen DAR_without_new=loanamount/assetsnew_noland

gen DSR=imp1_ds_tot/annualincome
gen ISR=imp1_is_tot/annualincome

order HHID_panel year imp1_ds_tot annualincome DSR
sort DSR

*Dummy for overindebtedness
foreach x in DSR DAR_with DAR_without { //DAR_with_new DAR_without_new {
forvalues i=30(10)50{
gen `x'`i'=0
}
}

foreach x in DSR DAR_with DAR_without { //DAR_with_new DAR_without_new {
forvalues i=30(10)50{
replace `x'`i'=1 if `x'>=.`i' & `x'!=.
}
}


*** Recode for extreme
foreach x in DIR DAR_with DAR_without DSR ISR {
clonevar `x'_r=`x'
}

tabstat DIR DAR_with DAR_without DSR ISR, stat(n mean sd p50 p95 p99 max) by(year) long
tabstat DIR DAR_with DAR_without DSR ISR if panel==1, stat(n mean sd p50 p95 p99 max) by(year) long


replace DIR_r=9.5 if DIR>=10 & year==2010
replace DIR_r=25.51 if DIR>=26 & year==2016
replace DIR_r=50 if DIR>=51 & year==2020

replace DAR_with_r=2 if DAR_with>=2.2 & year==2010
replace DAR_with_r=10.41 if DAR_with>=11 & year==2016
replace DAR_with_r=2.32 if DAR_with>=2.5 & year==2020

replace DAR_without_r=2 if DAR_without>=2.2 & year==2010
replace DAR_without_r=10.41 if DAR_without>=11 & year==2016
replace DAR_without_r=2.32 if DAR_without>=2.5 & year==2020

replace DSR_r=6 if DSR>=6 & year==2010
replace DSR_r=6 if DSR>=6 & year==2016
replace DSR_r=6 if DSR>=6 & year==2020

replace DSR_r=DSR_r*100

replace ISR_r=ISR_r*100

replace ISR_r=0.74 if ISR>=0.75 & year==2010
replace ISR_r=2.34 if ISR>=2.35 & year==2016
replace ISR_r=3.11 if ISR>=3.13 & year==2020

replace DIR_r=DIR_r*100
replace DAR_with_r=DAR_with_r*100
replace DAR_without_r=DAR_without_r*100

replace DAR_with=DAR_with*100
replace DAR_without=DAR_without*100

replace DSR=DSR*100
replace ISR=ISR*100
replace DIR=DIR*100



********** Wealth panel
xtile assets2010panel_q3=assets_noland if year==2010 & panel==1, n(3)
xtile assets2010panel_q4=assets_noland if year==2010 & panel==1, n(4)

bysort HHID_panel: egen assetspanel_q3=max(assets2010panel_q3) if panel==1
bysort HHID_panel: egen assetspanel_q4=max(assets2010panel_q4) if panel==1

ta assetspanel_q3 year
ta assetspanel_q4 year


********** Income panel
xtile income2010panel_q3=annualincome if year==2010 & panel==1, n(3)
xtile income2010panel_q4=annualincome if year==2010 & panel==1, n(4)

bysort HHID_panel: egen incomepanel_q3=max(income2010panel_q3) if panel==1
bysort HHID_panel: egen incomepanel_q4=max(income2010panel_q4) if panel==1

ta incomepanel_q3 year
ta incomepanel_q4 year

save"panel_v4", replace
****************************************
* END














****************************************
* Var creation for log, cro, etc.
****************************************
use"panel_v4", clear

********** Panel
keep if panel==1


********** Nb of missings for transformation
foreach x in assets_noland annualincome loanamount DSR DAR_without DAR_with yearly_expenses {
ta year if `x'==0
}


********** Rename
rename assetspanel_q3 assetsq
rename incomepanel_q3 incomeq


********** Back to N values
foreach x in annualincome assets_noland loanamount {
replace `x'=`x'*1000
}
foreach x in DSR DAR_without DAR_with DIR ISR {
replace `x'=`x'/100
}



***** CRO
foreach x in annualincome assets_noland loanamount DSR DAR_without DIR ISR DAR_with yearly_expenses {
gen cro_`x'=`x'^(1/3)
}


***** Log
* Replace . or 0 with 1
foreach x in loanamount {
replace `x'=1 if `x'==0
replace `x'=1 if `x'==.
}

foreach x in yearly_expenses annualincome assets_noland assets loanamount {
gen log_`x'=log(`x')
}


rename DAR_without DAR


***** Check IHS consistency
foreach x in ISR DAR DSR DIR {
g `x'10=`x'*10
g `x'100=`x'*100
g `x'1000=`x'*1000
g `x'10000=`x'*10000

foreach m in 10 100 1000 10000 {
g log_`x'`m'=log(`x'`m')
}
g log_`x'=log(`x')
}


********** IHS creation
foreach x in ISR DAR DSR DIR {
gen ihs_`x'=asinh(`x')
foreach m in 10 100 1000 10000 {
gen ihs_`x'`m'=asinh(`x'`m')
}
}

foreach x in loanamount annualincome assets_noland yearly_expenses  {
gen ihs_`x'=asinh(`x')
}


foreach x in informal_HH formal_HH eco_HH current_HH humank_HH social_HH home_HH repay_amt_HH {
replace `x'=`x'*1000
gen ihs_`x'=asinh(`x')
gen rel_`x'_10=rel_`x'*10
gen ihs_rel_`x'=asinh(rel_`x'_10)
drop rel_`x'_10
}


foreach x in informal_HH formal_HH eco_HH current_HH humank_HH social_HH home_HH repay_amt_HH {
count if `x'<=1 & `x'!=0
count if rel_`x'<=1 & rel_`x'!=0
}


rename DAR DAR_without

save"panel_v5", replace
****************************************
* END













****************************************
* Wide data
****************************************
use"panel_v5", clear

********** Initialization
xtset panelvar time
keep if panel==1

********** Rename for size
foreach x in IMF_nb_HH IMF_amt_HH bank_nb_HH bank_amt_HH moneylender_nb_HH moneylender_amt_HH {
rename loanfrom`x' lf_`x'
}

foreach x in IMF_amt_HH bank_amt_HH moneylender_amt_HH {
rename rel_loanfrom`x' rel_lf_`x'
}

********** Macro
global quanti DIR DAR_with DAR_without DSR ISR loanamount annualincome assets_noland assets sizeownland yearly_expenses formal_HH informal_HH rel_formal_HH rel_informal_HH eco_HH current_HH humank_HH social_HH home_HH other_HH rel_eco_HH rel_current_HH rel_humank_HH rel_social_HH rel_home_HH rel_other_HH sum_loans_HH lf_IMF_nb_HH lf_IMF_amt_HH lf_bank_nb_HH lf_bank_amt_HH lf_moneylender_nb_HH lf_moneylender_amt_HH repay_nb_HH repay_amt_HH MLborrowstrat_nb_HH MLborrowstrat_amt_HH MLgooddebt_nb_HH MLgooddebt_amt_HH MLbaddebt_nb_HH MLbaddebt_amt_HH mainloan_HH mainloan_amt_HH rel_lf_IMF_amt_HH rel_lf_bank_amt_HH rel_lf_moneylender_amt_HH rel_mainloan_amt_HH rel_repay_amt_HH rel_MLborrowstrat_amt_HH rel_MLbaddebt_amt_HH rel_MLgooddebt_amt_HH ihs_informal_HH ihs_formal_HH ihs_eco_HH ihs_current_HH ihs_humank_HH ihs_social_HH ihs_home_HH ihs_repay_amt_HH ihs_rel_informal_HH ihs_rel_formal_HH ihs_rel_eco_HH ihs_rel_current_HH ihs_rel_humank_HH ihs_rel_social_HH ihs_rel_home_HH ihs_rel_repay_amt_HH MLstrat_asse_nb_HH MLstrat_asse_amt_HH MLstrat_migr_nb_HH MLstrat_migr_amt_HH rel_MLstrat_asse_amt_HH rel_MLstrat_migr_amt_HH dummymigrstrat dummyassestrat

global quali DSR30 DSR40 DSR50 dummyIMF dummybank dummymoneylender dummyrepay dummyborrowstrat mainocc_occupation head_* wifehusb_*

global var $quanti $quali ihs_ISR ihs_ISR10 ihs_ISR100 ihs_ISR1000 ihs_ISR10000 ihs_DAR ihs_DAR10 ihs_DAR100 ihs_DAR1000 ihs_DAR10000 ihs_DSR ihs_DSR10 ihs_DSR100 ihs_DSR1000 ihs_DSR10000 log_yearly_expenses log_annualincome log_assets_noland log_assets log_loanamount log_ISR10 log_ISR100 log_ISR1000 log_ISR10000 log_ISR log_DAR10 log_DAR100 log_DAR1000 log_DAR10000 log_DAR log_DSR10 log_DSR100 log_DSR1000 log_DSR10000 log_DSR cro_annualincome cro_assets_noland cro_loanamount cro_DSR cro_DAR_without cro_DIR cro_ISR cro_DAR_with ihs_annualincome ihs_assets_noland ihs_loanamount shareagri sharenagri nagri agri ihs_yearly_expenses cro_yearly_expenses ihs_DIR ihs_DIR10 ihs_DIR100 ihs_DIR1000 ihs_DIR10000

sort HHID_panel year


********** Select+reshape
keep HHID_panel year panel caste $var dummyIMF dummybank dummymoneylender dummyrepay villageid villagearea jatis
reshape wide $var villageid villagearea , i(HHID_panel) j(year)


********* xtile income assets
xtile cat_income=annualincome2010, n(3)
xtile cat_assets=assets_noland2010, n(3)

label define cat_income 1"T1 in." 2"T2 in." 3"T3 in."
label define cat_assets 1"T1 as." 2"T2 as." 3"T3 as."

label values cat_income cat_income
label values cat_assets cat_assets


********** Overindebtedness path
tab1 DSR302010 DSR402010 DSR502010 DSR302016 DSR402016 DSR502016 DSR302020 DSR402020 DSR502020

label define overpath 1"Always" 2"Become" 3"Exit" 4"Never"
forvalues i=30(10)50{
gen over`i'path_d1=.
gen over`i'path_d2=.
}

forvalues i=30(10)50{
replace over`i'path_d1=1 if DSR`i'2010==1 & DSR`i'2016==1
replace over`i'path_d1=2 if DSR`i'2010==0 & DSR`i'2016==1
replace over`i'path_d1=3 if DSR`i'2010==1 & DSR`i'2016==0
replace over`i'path_d1=4 if DSR`i'2010==0 & DSR`i'2016==0

label values over`i'path_d1 overpath
}

forvalues i=30(10)50{
replace over`i'path_d2=1 if DSR`i'2016==1 & DSR`i'2020==1
replace over`i'path_d2=2 if DSR`i'2016==0 & DSR`i'2020==1
replace over`i'path_d2=3 if DSR`i'2016==1 & DSR`i'2020==0
replace over`i'path_d2=4 if DSR`i'2016==0 & DSR`i'2020==0

label values over`i'path_d2 overpath
}


***** Panel
forvalues i=30(10)50{
gen path_`i'=.
}

label define completepath 1"Always" 2"Lasting entrance" 3"Temporary exit" 4"New over-indebted" 5"New not over-indebted" 6"Temporary entrance" 7"Lasting exit" 8"Never"

forvalues i=30(10)50{
replace path_`i'=1 if DSR`i'2010==1 & DSR`i'2016==1 & DSR`i'2020==1
replace path_`i'=2 if DSR`i'2010==0 & DSR`i'2016==1 & DSR`i'2020==1
replace path_`i'=3 if DSR`i'2010==1 & DSR`i'2016==0 & DSR`i'2020==1
replace path_`i'=4 if DSR`i'2010==0 & DSR`i'2016==0 & DSR`i'2020==1
replace path_`i'=5 if DSR`i'2010==1 & DSR`i'2016==1 & DSR`i'2020==0
replace path_`i'=6 if DSR`i'2010==0 & DSR`i'2016==1 & DSR`i'2020==0
replace path_`i'=7 if DSR`i'2010==1 & DSR`i'2016==0 & DSR`i'2020==0
replace path_`i'=8 if DSR`i'2010==0 & DSR`i'2016==0 & DSR`i'2020==0

label values path_`i' completepath
}


********** Debt trap
tab1 dummyrepay2010 dummyrepay2016 dummyrepay2020 dummyborrowstrat2010 dummyborrowstrat2020
foreach x in repay borrowstrat{
gen path_`x'_d1=.
gen path_`x'_d2=.
}

foreach x in repay borrowstrat{
replace path_`x'_d1=1 if dummy`x'2010==1 & dummy`x'2016==1
replace path_`x'_d1=2 if dummy`x'2010==0 & dummy`x'2016==1
replace path_`x'_d1=3 if dummy`x'2010==1 & dummy`x'2016==0
replace path_`x'_d1=4 if dummy`x'2010==0 & dummy`x'2016==0

label values path_`x'_d1 overpath
}

foreach x in repay borrowstrat{
replace path_`x'_d2=1 if dummy`x'2016==1 & dummy`x'2020==1
replace path_`x'_d2=2 if dummy`x'2016==0 & dummy`x'2020==1
replace path_`x'_d2=3 if dummy`x'2016==1 & dummy`x'2020==0
replace path_`x'_d2=4 if dummy`x'2016==0 & dummy`x'2020==0

label values path_`x'_d2 overpath
}


***** Panel
label define pathtrap 1"Always in trap" 2"Lasting entrance" 3"Temporary exit" 4"New trapped" 5"New not trapped" 6"Temporary entrance" 7"Lasting exit" 8"Never"

foreach x in repay borrowstrat{
gen path_`x'=.
}

foreach x in repay borrowstrat{
replace path_`x'=1 if dummy`x'2010==1 & dummy`x'2016==1 & dummy`x'2020==1
replace path_`x'=2 if dummy`x'2010==0 & dummy`x'2016==1 & dummy`x'2020==1
replace path_`x'=3 if dummy`x'2010==1 & dummy`x'2016==0 & dummy`x'2020==1
replace path_`x'=4 if dummy`x'2010==0 & dummy`x'2016==0 & dummy`x'2020==1
replace path_`x'=5 if dummy`x'2010==1 & dummy`x'2016==1 & dummy`x'2020==0
replace path_`x'=6 if dummy`x'2010==0 & dummy`x'2016==1 & dummy`x'2020==0
replace path_`x'=7 if dummy`x'2010==1 & dummy`x'2016==0 & dummy`x'2020==0
replace path_`x'=8 if dummy`x'2010==0 & dummy`x'2016==0 & dummy`x'2020==0

label values path_`x' pathtrap
}


ta path_borrowstrat caste, col nofreq


********** Change occupation head and husb
fre head_occupation2010 wifehusb_occupation2010 head_occupation2016 wifehusb_occupation2016 head_occupation2020 wifehusb_occupation2020

foreach x in head wifehusb {
gen `x'_changeocc_1=.
gen `x'_changeocc_2=.

replace `x'_changeocc_1=0 if `x'_occupation2010==`x'_occupation2016
replace `x'_changeocc_2=0 if `x'_occupation2016==`x'_occupation2020

replace `x'_changeocc_1=1 if `x'_occupation2010!=`x'_occupation2016
replace `x'_changeocc_2=1 if `x'_occupation2016!=`x'_occupation2020
}

foreach x in head wifehusb {
gen `x'_changeocc_gl=.

replace `x'_changeocc_gl=0 if `x'_changeocc_1==0 & `x'_changeocc_2==0

replace `x'_changeocc_gl=1 if `x'_changeocc_1==1 & `x'_changeocc_2==0
replace `x'_changeocc_gl=1 if `x'_changeocc_1==0 & `x'_changeocc_2==1

replace `x'_changeocc_gl=1 if `x'_changeocc_1==1 & `x'_changeocc_2==1
}



********** Increase in formal / informal
foreach x in formal informal eco current social humank repay_amt {
gen dummyinc_`x'=.
replace dummyinc_`x'=0 if `x'_HH2010>=`x'_HH2020
replace dummyinc_`x'=1 if `x'_HH2010<`x'_HH2020

gen dummyincrel_`x'=.
replace dummyincrel_`x'=0 if rel_`x'_HH2010>=rel_`x'_HH2020
replace dummyincrel_`x'=1 if rel_`x'_HH2010<rel_`x'_HH2020
}


********** Evo agri
foreach x in agri nagri {
gen dummyinc_`x'=.
replace dummyinc_`x'=0 if share`x'2010>=share`x'2020
replace dummyinc_`x'=1 if share`x'2010<share`x'2020
}

drop assets2010 assets2016 assets2020
replace assets_noland2010=assets_noland2010/1000
replace assets_noland2016=assets_noland2016/1000
replace assets_noland2020=assets_noland2020/1000


save"panel_v5_wide", replace
clear all
****************************************
* END