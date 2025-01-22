*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*January 21, 2025
*-----
gl link = "debtdiversity"
*Stat loan
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------














****************************************
* Stat desc
****************************************
use"panel_loans_v1", replace

* Reason
ta loanreasongiven year
ta loanreasongiven year, col nofreq

* Amount by reason
tabstat loanamount if year==2010, stat(mean) by(loanreasongiven)
tabstat loanamount if year==2016, stat(mean) by(loanreasongiven)
tabstat loanamount if year==2020, stat(mean) by(loanreasongiven)

* Lender
ta year if loanreasongiven==4
ta lender4 year if loanreasongiven==4, col nofreq

* Lender cat
ta lender4cat year if loanreasongiven==4, col nofreq

* Amount by lender
tabstat loanamount if loanreasongiven==4 & year==2010, stat(mean) by(lender4)
tabstat loanamount if loanreasongiven==4 & year==2016, stat(mean) by(lender4)
tabstat loanamount if loanreasongiven==4 & year==2020, stat(mean) by(lender4)

* Amount by lender cat
tabstat loanamount if loanreasongiven==4 & year==2010, stat(mean) by(lender4cat)
tabstat loanamount if loanreasongiven==4 & year==2016, stat(mean) by(lender4cat)
tabstat loanamount if loanreasongiven==4 & year==2020, stat(mean) by(lender4cat)

****************************************
* END
