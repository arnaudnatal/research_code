cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
June 14, 2022
-----
Impact study of shocks
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

* Scheme
set scheme plotplain_v2
grstyle init
grstyle set plain, box nogrid compact

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


********** Deflate
*https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
*(100/158) if year==2016
*(100/184) if year==2020

****************************************
* END








/*
****************************************
* SHOCK AND DEBT
****************************************

********** Keep 2016-17
preserve 
use "NEEMSIS1-HH.dta", clear
keep HHID_panel dummydemonetisation
duplicates drop
save "NEEMSIS1-HH_temp", replace
restore

preserve
keep if year==2016
merge 1:1 HHID_panel using "NEEMSIS1-HH_temp.dta"
drop _merge
erase "NEEMSIS1-HH_temp.dta"

ta cl_vuln dummydemonetisation, m
ta cl_vuln dummydemonetisation

tabstat DSR ISR DAR_without DAR_with, stat(n mean sd p50) by(dummydemonetisation)

restore


********** Keep 2020-21
preserve 
use "NEEMSIS2-HH.dta", clear
gen tos=dofc(start_HH_quest)
format tos %td
*
gen swt=.
replace swt=1 if tos<d(05apr2021)
replace swt=2 if tos>=d(05apr2021) & tos<=d(15jun2021)
replace swt=3 if tos>d(15jun2021)
*
gen treat=.
replace treat=0 if tos<d(05apr2021)
replace treat=1 if tos>d(15jun2021)
*
keep HHID_panel start_HH_quest tos swt treat
duplicates drop
save "NEEMSIS2-HH_temp", replace
restore

preserve
keep if year==2020
merge 1:1 HHID_panel using "NEEMSIS2-HH_temp.dta"
drop _merge
erase "NEEMSIS2-HH_temp.dta"

ta cl_vuln treat, m
ta cl_vuln treat

tabstat DSR ISR DAR_without DAR_with, stat(n mean sd p50) by(treat)
restore
****************************************
* END
