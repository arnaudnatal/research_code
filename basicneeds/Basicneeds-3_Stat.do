*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*March 22, 2024
*-----
gl link = "basicneeds"
*Stat
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\basicneeds.do"
*-------------------------





****************************************
* Desc
****************************************
use"all_loans", clear

drop if s_currentlyatschool==0
drop if s_currentlyatschool==.

*
ta loanreasongiven year
ta loanreasongiven year, col nofreq
*tabstat loanamount2 if year==2010, stat(mean) by(loanreasongiven)
tabstat loanamount2 if year==2016, stat(mean) by(loanreasongiven)
tabstat loanamount2 if year==2020, stat(mean) by(loanreasongiven)

cls
* % of household using it
fre loanreasongiven
forvalues i=1/12 {
preserve
bysort HHID_panel year: gen n=1 if loanreasongiven==`i'
keep HHID_panel year n
duplicates drop
ta n year
restore
}
preserve
bysort HHID_panel year: gen n=1 if loanreasongiven==77
keep HHID_panel year n
duplicates drop
ta n year
restore


* % of the dsr
bysort HHID_panel year: egen imp1_debt_service_HH=sum(imp1_debt_service)
recode loanreasongiven (77=13)
forvalues i=1/13 {
gen dsr_`i'=imp1_debt_service if loanreasongiven==`i'
bysort HHID_panel year : egen sum_dsr_`i'=sum(dsr_`i')
gen share_dsr_`i'=sum_dsr_`i'*100/imp1_debt_service_HH
drop dsr_`i' sum_dsr_`i'
}
egen test=rowtotal(share_dsr_1 share_dsr_2 share_dsr_3 share_dsr_4 share_dsr_5 share_dsr_6 share_dsr_7 share_dsr_8 share_dsr_9 share_dsr_10 share_dsr_11 share_dsr_12 share_dsr_13)
ta test
sort test
drop test

tabstat share_dsr_1 share_dsr_2 share_dsr_3 share_dsr_4 share_dsr_5 share_dsr_6 share_dsr_7 share_dsr_8 share_dsr_9 share_dsr_10 share_dsr_11 share_dsr_12 share_dsr_13, stat(mean) by(year)


***** Qui finance ?
fre loanreasongiven
keep if loanreasongiven==9

ta lender_cat
ta lender4

*************************************
* END






