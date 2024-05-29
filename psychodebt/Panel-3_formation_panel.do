*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*May 13, 2021
*-----
gl link = "psychodebt"
*New var
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------






****************************************
* Formation base indiv 2016
****************************************
use"NEEMSIS1-HH~panel", clear

* Merge with debt
merge 1:1 HHID_panel INDID_panel using "NEEMSIS1-HH~debt"
drop _merge

* Keep egos
drop if egoid==0
drop if egoid==.

* Label
label var indebt_indiv "Indebted in 2016-17"
label var female "Female"
label var dalits "Dalits"

* Miss
fre s_indebt
recode s_indebt (.=0)

* Cluster
drop HHID
encode HHID_panel, gen(HHID)

save "base2016.dta", replace
****************************************
* END







****************************************
* Formation base indiv 2020
****************************************
use"NEEMSIS2-HH~panel", clear

* Merge with debt
merge 1:1 HHID_panel INDID_panel using "NEEMSIS2-HH~debt"
drop _merge

* Keep egos
drop if egoid==0
drop if egoid==.

* Label
label var indebt_indiv "Indebted in 2016-17"
label var female "Female"
label var dalits "Dalits"

* Cluster
drop HHID
encode HHID_panel, gen(HHID)

save "base2020.dta", replace
****************************************
* END












****************************************
* Formation base panel
****************************************
use"base2016", clear

* Append
append using "base2020"

* Panel
drop panel_indiv
bysort HHID_panel INDID_panel: gen n=_N

* Order
order HHID_panel INDID_panel egoid year n
ta n year

* Cleaning PT
foreach x in OP CO EX AG ES Grit {
gen `x'=.
}
foreach x in OP CO EX AG ES Grit {
replace `x'=`x'_2016 if year==2016
replace `x'=`x'_2020 if year==2020
}

* Cleaning debt measures
foreach x in s_indebt s_borrservices_none s_dummyproblemtorepay {
gen `x'=.
}
foreach x in s_indebt s_borrservices_none s_dummyproblemtorepay {
replace `x'=`x'2016 if year==2016
replace `x'=`x'2020 if year==2020
}


ta s_indebt year, m
ta s_borrservices_none year, m
ta s_dummyproblemtorepay year, m

* Panel var
drop INDID
egen INDID=concat(HHID_panel INDID_panel)
encode INDID, gen(INDID2)
drop INDID
rename INDID2 INDID
ta INDID

save"base_panel", replace



* Gen income and assets chocs
use"base_panel", clear

keep HHID_panel year incomeHH1000 assets1000
rename incomeHH1000 income
rename assets1000 assets
duplicates drop
reshape wide income assets, i(HHID_panel) j(year)

replace assets2016=assets2016*(100/158)
replace assets2020=assets2020*(100/184)
replace income2016=income2016*(100/158)
replace income2020=income2020*(100/184)

foreach x in income assets {
gen dummyshock_`x'=0
}
foreach x in income assets {
replace dummyshock_`x'=1 if `x'2020<`x'2016 & `x'2020!=. & `x'2020!=0 & `x'2016!=. & `x'2016!=0
}

fre dummyshock*

keep HHID_panel dummy*

label define yesno 0"No" 1"Yes"
label values dummyshock_income yesno
label values dummyshock_assets yesno

fre dummyshock*

save"base_shock", replace
****************************************
* END







****************************************
* Formation base indiv lag
****************************************
use"NEEMSIS1-HH~panel", clear

* Merge with debt in 2020-21
merge 1:1 HHID_panel INDID_panel using "NEEMSIS2-HH~debt"
drop _merge

* Keep egos
drop if egoid2020==0
drop if egoid2020==.
drop if egoid==0
drop if egoid==.

* Label
label var indebt_indiv "Indebted in 2016-17"
label var female "Female"
label var dalits "Dalits"

* Merge shock
merge m:1 HHID_panel using "base_shock"
keep if _merge==3
drop _merge

save "base_panel_lag", replace
****************************************
* END










****************************************
* Formation base lag loan level
****************************************
use"base_loanlevel_2020", clear


*** Merge with 2016-17
merge m:1 HHID_panel INDID_panel using "NEEMSIS1-HH~panel"
keep if _merge==3
drop _merge

* Merge shock
merge m:1 HHID_panel using "base_shock"
keep if _merge==3
drop _merge

* Label
label var age "Age"
label var indebt_indiv "Indebted in 2016-17 (=1)"
label var borrservices_none "No need to provide service (=1)"
label var dummyproblemtorepay "Problem to repay (=1)"
label var imp1_interest_service "Interest rate (%)"
label var loanamount "Loan amount (INR)"
label var sloanamount "Individual's total debt (INR)"

fre dummyinterest
label define dummyinterest 0"Interest: No" 1"Interest: Yes", replace
label values dummyinterest dummyinterest

fre reason_cat
label define reason_cat 1"Reason: Economic" 2"Reason: Current" 3"Reason: Human capital" 4"Reason: Social" 5"Reason: Housing", replace
label values reason_cat reason_cat

fre lender4
label define lender4 1"Lender: WKP" 2"Lender: Relatives" 3"Lender: Labour" 4"Lender: Pawn broker" 6"Lender: Moneylenders" 7"Lender: Friends" 8"Lender: Microcredit" 9"Lender: Bank" , replace
label values lender4 lender4

fre lender_cat
recode lender_cat (2=1) (3=2)
label define lender_cat 1"Lender: Informal" 2"Lender: Formal", replace
label values lender_cat lender_cat

fre dummyguarantee
label define dummyguarantee 0"Guarantee: No" 1"Guarantee: Yes", replace
label values dummyguarantee dummyguarantee

fre dummyssex 
label define dummyssex 1"Same sex: No" 2"Same sex: Yes" 3"Same sex: N/A", replace
label values dummyssex dummyssex

fre dummyscaste
label define dummyscaste 1"Same caste: No" 2"Same caste: Yes" 3"Same caste: N/A", replace
label values dummyscaste dummyscaste

fre borrservices_none
label define borrservices_none 0"Services" 1"No services", replace
label values borrservices_none borrservices_none


********** Recode
recode annualincome_indiv (.=0)

gen annualincome_indiv10000=annualincome_indiv/10000
label var annualincome_indiv10000 "Individual income (10k rupees)"

gen loanamount1000=loanamount/1000
label var loanamount1000 "Loan amount (1k rupees)"

replace sloanamount=sloanamount/10000
label var sloanamount "Sum loan amount (10k rupees)"

gen assets10000=assets_total/10000
label var assets10000 "Assets (10k rupees)"

gen incomeHH10000=incomeHH1000/10
label var incomeHH10000 "Total income (10k rupees)"


* Passer en log pour faire augmente d'un pourcent dans l'interpretation
foreach x in annualincome_indiv loanamount sloanamount assets_total annualincome_HH {
recode `x' (0=1)
gen log_`x'=log(`x')
}
label var log_annualincome_indiv "Individual income (log)"
label var log_loanamount "Loan amount (log)"
label var log_sloanamount "Total amount of debt (log)"
label var log_assets_total "Assets (log)"
label var log_annualincome_HH "Annual income (log)"

save"base_loanlevel_lag", replace
****************************************
* END











****************************************
* Formation base loan level 2016
****************************************
use"base_loanlevel_2016", clear

drop INDID2016

*** Merge with 2016-17
merge m:1 HHID_panel INDID_panel using "NEEMSIS1-HH~panel"
keep if _merge==3
drop _merge

save"base_loanlevel_2016_comp", replace
****************************************
* END











****************************************
* Formation base loan level 2020
****************************************
use"base_loanlevel_2020", clear

drop INDID2020

*** Merge with 2020-21
merge m:1 HHID_panel INDID_panel using "NEEMSIS2-HH~panel"
keep if _merge==3
drop _merge

save"base_loanlevel_2020_comp", replace
****************************************
* END




