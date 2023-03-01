*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 1, 2022
*-----
gl link = "datacontextodriis"
*Prepa database
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------









****************************************
* Debt
****************************************
cls
use"panel_loans", clear

*** Number of loans
ta loansettled year

*** Clean
drop if loansettled==1
ta year

*** Deflate and 1000
foreach x in loanamount loanbalance interestpaid totalrepaid principalpaid {
replace `x'=`x'*(100/158) if year==2016
replace `x'=`x'*(100/184) if year==2020
replace `x'=`x'/1000
}


*** %
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

*2016
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

*2016
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












/*
stripplot assets_totalnoland if assets_totalnoland<100, over(time) vert ///
stack width(.5) jitter(0) ///
box(barw(.2)) boffset(-0.15) pctile(25) ///
ms(oh oh oh) msize(small) mc(black%30) ///
yla(0(10)100, ang(h)) xla(, noticks) ///
ymtick(0(5)100) ///
xtitle("") ytitle("Monetary value of assets (INR 10k)") ///
name(wealth, replace)
graph export "Wealth.pdf", as(pdf) replace
