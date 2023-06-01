*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*June 1, 2023
*-----
gl link = "datadebt"
*Stat loan
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------









****************************************
* Desc
****************************************
use"panel_loans", clear

********** Prepa
drop if loansettled==1
ta year
ta loan_database year
drop if loan_database=="MARRIAGE"
ta year
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV65" & year==2020
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="KUV67" & year==2020

*** Backup
gen loanamount_bc=loanamount
replace loanamount=loanamount/1000


*** %
ta year
ta lender_cat year, col nofreq
ta reason_cat year, col nofreq


*** Amount
tabstat loanamount if year==2010, stat(mean) by(lender_cat)
tabstat loanamount if year==2016, stat(mean) by(lender_cat)
tabstat loanamount if year==2020, stat(mean) by(lender_cat)

tabstat loanamount if year==2010, stat(mean) by(reason_cat)
tabstat loanamount if year==2016, stat(mean) by(reason_cat)
tabstat loanamount if year==2020, stat(mean) by(reason_cat)


*** % of HH using it: lender_cat
fre lender_cat
ta lender_cat, gen(len)

*2010
cls
preserve 
keep if year==2010
forvalues i=1(1)3{
bysort HHID_panel: egen lenHH_`i'=max(len`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)3{
tab lenHH_`i', m
}
restore

*2016-17
cls
preserve 
keep if year==2016
forvalues i=1(1)3{
bysort HHID_panel: egen lenHH_`i'=max(len`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)3{
tab lenHH_`i', m
}
restore


*2020-21
cls
preserve 
keep if year==2020
forvalues i=1(1)3{
bysort HHID_panel: egen lenHH_`i'=max(len`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)3{
tab lenHH_`i', m
}
restore

drop len1 len2 len3


*** % of HH using it: reason_cat
fre reason_cat
recode reason_cat (77=7)
ta reason_cat, gen(rea)

*2010
cls
preserve 
keep if year==2010
forvalues i=1(1)7{
bysort HHID_panel: egen reaHH_`i'=max(rea`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)7{
tab reaHH_`i', m
}
restore

*2016-17
cls
preserve 
keep if year==2016
forvalues i=1(1)7{
bysort HHID_panel: egen reaHH_`i'=max(rea`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)7{
tab reaHH_`i', m
}
restore

*2020-21
cls
preserve 
keep if year==2020
forvalues i=1(1)7{
bysort HHID_panel: egen reaHH_`i'=max(rea`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)7{
tab reaHH_`i', m
}
restore



****************************************
* END



