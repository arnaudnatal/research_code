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
* Ratio
****************************************
use"panel_v3", clear



********** Replace assets
egen assetsnew=rowtotal(amountownland livestock housevalue_new goldquantityamount_new goodtotalamount)
egen assetsnew_noland=rowtotal(livestock housevalue_new goldquantityamount_new goodtotalamount)
gen assetsnew1000=assetsnew/1000
gen assetsnew_noland1000=assetsnew_noland/1000
drop assetsnew assetsnew_noland

tabstat assets1000 assetsnew1000 assets_noland1000 assetsnew_noland1000, stat(n mean sd p50) by(year)

global assecalc assets1000 assetsnew1000 assets_noland1000 assetsnew_noland1000




**********Debt measure
*Continuous
gen DIR=loanamount_HH/annualincome_HH

gen DAR_without=loanamount_HH/(assets_noland1000*1000)
gen DAR_with=loanamount_HH/(assets1000*1000)

gen DAR_with_new=loanamount_HH/(assetsnew1000*1000)
gen DAR_without_new=loanamount_HH/(assetsnew_noland1000*1000)

gen DSR=imp1_ds_tot_HH/annualincome_HH
gen ISR=imp1_is_tot_HH/annualincome_HH


*Dummy for overindebtedness
foreach x in DSR DAR_with DAR_without DAR_with_new DAR_without_new {
forvalues i=30(10)50{
gen `x'`i'=0
}
}

foreach x in DSR DAR_with DAR_without DAR_with_new DAR_without_new {
forvalues i=30(10)50{
replace `x'`i'=1 if `x'>=.`i' & `x'!=.
}
}


*** Recode for extreme
tabstat DIR DAR_with DAR_without DAR_with_new DAR_without_new DSR ISR, stat(n mean sd p50 p75 p90 p95 p99 max) by(year) long

foreach x in DIR DAR_with DAR_without DAR_with_new DAR_without_new DSR ISR {
clonevar `x'_r=`x'
}

replace DIR_r=9.5 if DIR>=10 & year==2010
replace DIR_r=25.51 if DIR>=26 & year==2016
replace DIR_r=50 if DIR>=51 & year==2020

replace DAR_with_r=2 if DAR_with>=2.2 & year==2010
replace DAR_with_r=10.41 if DAR_with>=11 & year==2016
replace DAR_with_r=2.32 if DAR_with>=2.5 & year==2020

replace DAR_without_r=2 if DAR_without>=2.2 & year==2010
replace DAR_without_r=10.41 if DAR_without>=11 & year==2016
replace DAR_without_r=2.32 if DAR_without>=2.5 & year==2020

replace DAR_with_new_r=2 if DAR_with_new>=2.2 & year==2010
replace DAR_with_new_r=10.41 if DAR_with_new>=11 & year==2016
replace DAR_with_new_r=2.32 if DAR_with_new>=2.5 & year==2020

replace DAR_without_new_r=2 if DAR_without_new>=2.2 & year==2010
replace DAR_without_new_r=10.41 if DAR_without_new>=11 & year==2016
replace DAR_without_new_r=2.32 if DAR_without_new>=2.5 & year==2020

replace DSR_r=2.66 if DSR>=2.7 & year==2010
replace DSR_r=3.7 if DSR>=3.8 & year==2016
replace DSR_r=7.22 if DSR>=7.3 & year==2020

replace ISR_r=0.74 if ISR>=0.75 & year==2010
replace ISR_r=2.34 if ISR>=2.35 & year==2016
replace ISR_r=3.11 if ISR>=3.13 & year==2020





********* Desc
tabstat loanamount_HH1000 DAR_with_r DAR_with_new_r DAR_without_r DAR_without_new_r, stat(n mean sd p50) by(year)

ta caste year
forvalues i=1(1)3{
tabstat loanamount_HH1000 DAR_with_r DAR_with_new_r DAR_without_r DAR_without_new_r if caste==`i', stat(n mean sd p50) by(year)
}







**********Deflate: all in 2010 value 
***https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
foreach x in foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses annualincome_HH1000 imp1_ds_tot_HH imp1_is_tot_HH loanamount_HH1000 marriageexpenses_HH occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega annualincome_HH amountownland livestock housevalue housevalue_new goldquantityamount goldquantityamount_new goodtotalamount assets1000 assetsnew1000 assets_noland1000 assetsnew_noland1000 {
clonevar `x'_raw=`x'
replace `x'=`x'*(100/158) if year==2016 & `x'!=.
replace `x'=`x'*(100/184) if year==2020 & `x'!=.
}







save"panel_v3", replace
****************************************
* END
