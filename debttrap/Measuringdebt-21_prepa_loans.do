*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*November 20, 2023
*-----
gl link = "debttrap"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------













****************************************
* RUME (2010)
****************************************
use"raw/RUME-loans_mainloans_new.dta", replace

keep HHID2010 loanreasongiven loanlender loansettled loanamount lender_cat reason_cat lender4 dummyml loanamount2 loanbalance2 interestpaid2 totalrepaid2 principalpaid2

merge m:m HHID2010 using "raw/keypanel-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2010

save"RUME-loans.dta", replace
****************************************
* END













****************************************
* NEEMSIS-1 (2016-17)
****************************************
use"raw/NEEMSIS1-loans_mainloans_new.dta", replace

ta loan_database
drop if loan_database=="MARRIAGE"
keep HHID2016 loanreasongiven loanlender loansettled loanamount lender_cat reason_cat lender4 dummyml loanamount2 loanbalance2 interestpaid2 totalrepaid2 principalpaid2

merge m:m HHID2016 using "raw/keypanel-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2016

save"NEEMSIS1-loans.dta", replace
****************************************
* END













****************************************
* NEEMSIS-2 (2020-21)
****************************************
use"raw/NEEMSIS2-loans_mainloans_new.dta", replace

keep HHID2020 loanreasongiven loanlender loansettled loanamount lender_cat reason_cat lender4 dummyml loanamount2 loanbalance2 interestpaid2 totalrepaid2 principalpaid2

merge m:m HHID2020 using "raw/keypanel-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2020

save"NEEMSIS2-loans.dta", replace
****************************************
* END











****************************************
* Append
****************************************
use"RUME-loans.dta", replace

append using "NEEMSIS1-loans"
append using "NEEMSIS2-loans"

gen test=loanamount-loanamount2
ta test
drop test loanamount

foreach x in loanamount loanbalance interestpaid totalrepaid principalpaid {
rename `x'2 `x'
}

drop HHID2010 HHID2016 HHID2020

order HHID_panel year loanamount loansettled loanreasongiven loanlender 


********** Selection of the 6 households
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV67" & year==2020
drop if HHID_panel=="GOV65" & year==2020

save"panel_loans", replace
****************************************
* END
