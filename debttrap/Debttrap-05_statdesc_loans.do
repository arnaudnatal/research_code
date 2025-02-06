*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*January 21, 2025
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


* Reason given and effective reason
drop if year==2010
count

ta loanreasongiven effective_repa if year==2016, row nofreq
ta loanreasongiven effective_repa if year==2020, row nofreq

****************************************
* END













****************************************
* Stat main loans
****************************************
use"panel_loans_v1", replace

keep if dummymainloan==1
ta year

***** Plan to repay
cls
foreach x in plantorep_chit plantorep_work plantorep_migr plantorep_asse plantorep_inco plantorep_borr plantorep_othe plantorep_noth plantorep_nrep {
ta `x' year, col nofreq
}
* Which loans are repaid with debt?
ta loanreasongiven year if plantorep_borr==1, col nofreq
ta lender4 year if plantorep_borr==1, col nofreq


***** Settle
drop if year==2010 
cls
foreach x in settlestrat_inco settlestrat_sche settlestrat_borr settlestrat_sell settlestrat_land settlestrat_cons settlestrat_addi settlestrat_work settlestrat_supp settlestrat_harv settlestrat_othe {
ta `x' year, col nofreq
}
* Which loans are repaid with debt?
ta loanreasongiven year if settlestrat_borr==1, col nofreq
ta lender4 year if settlestrat_borr==1, col nofreq



* Plan vs settle stra
ta plantorep_borr settlestrat_borr if year==2016, row
ta plantorep_borr settlestrat_borr if year==2020, row

****************************************
* END
