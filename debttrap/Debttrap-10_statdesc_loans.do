*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*October 07, 2024
*-----
gl link = "debttrap"
*Stat loan
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------









****************************************
* Stat desc
****************************************

*********** Effective
use"panel_loans", replace

ta effective_repa year, col 
ta effective_repa year if sex==1, col 
ta effective_repa year if sex==2, col 

keep if sex==2
fre sex
ta effective_repa year, col 




*********** Plan to repay
use"panel_loans", replace

ta plantorep_borr year, col 
ta plantorep_borr year if sex==1, col 
ta plantorep_borr year if sex==2, col 

keep if sex==2
fre sex
ta plantorep_borr year, col 



*********** Settle loan strat
use"panel_loans", replace

ta settlestrat_borr year, col 
ta settlestrat_borr year if sex==1, col 
ta settlestrat_borr year if sex==2, col 

keep if sex==2
fre sex
ta settlestrat_borr year, col 




****************************************
* END














****************************************
* Stat desc
****************************************
use"panel_loans", replace


********** Given
*
ta loanreasongiven year
ta loanreasongiven year, col nofreq

*
tabstat loanamount if year==2010, stat(mean) by(loanreasongiven)
tabstat loanamount if year==2016, stat(mean) by(loanreasongiven)
tabstat loanamount if year==2020, stat(mean) by(loanreasongiven)

*
ta year if loanreasongiven==4
ta lender4 year if loanreasongiven==4, col nofreq
tabstat loanamount if loanreasongiven==4 & year==2010, stat(mean) by(lender4)
tabstat loanamount if loanreasongiven==4 & year==2016, stat(mean) by(lender4)
tabstat loanamount if loanreasongiven==4 & year==2020, stat(mean) by(lender4)


tabstat loanamount if loanreasongiven==4 & year==2010, stat(mean) by(lender4cat)
tabstat loanamount if loanreasongiven==4 & year==2016, stat(mean) by(lender4cat)
tabstat loanamount if loanreasongiven==4 & year==2020, stat(mean) by(lender4cat)


********** Effective
*
global cat repa agri fami heal hous inve cere marr educ rela deat
*ta effective_agri year, col
cls
foreach x in $cat {
ta effective_`x' year, col nofreq
}

*
cls
foreach x in $cat {
*tabstat loanamount if year==2010 & effective_`x'==1
*tabstat loanamount if year==2016 & effective_`x'==1
*tabstat loanamount if year==2020 & effective_`x'==1
}
tabstat loanamount if dummyml==1 & year==2010, stat(n mean)

*
ta year if effective_repa==1
ta lender4 year if effective_repa==1, col nofreq
ta lender4cat year if effective_repa==1, col nofreq

tabstat loanamount if effective_repa==1 & year==2010, stat(mean) by(lender4)
tabstat loanamount if effective_repa==1 & year==2016, stat(mean) by(lender4)
tabstat loanamount if effective_repa==1 & year==2020, stat(mean) by(lender4)


tabstat loanamount if effective_repa==1 & year==2010, stat(mean) by(lender4cat)
tabstat loanamount if effective_repa==1 & year==2016, stat(mean) by(lender4cat)
tabstat loanamount if effective_repa==1 & year==2020, stat(mean) by(lender4cat)


****************************************
* END
