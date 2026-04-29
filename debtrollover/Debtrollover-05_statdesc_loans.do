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
ta lender4 year if loanreasongiven==4
ta lender4 year if loanreasongiven==4, col nofreq

* Lender cat

ta lender4cat year, col 
ta lender4cat year if loanreasongiven==4, col nofreq

* Amount by lender
tabstat loanamount if loanreasongiven==4 & year==2010, stat(mean) by(lender4)
tabstat loanamount if loanreasongiven==4 & year==2016, stat(mean) by(lender4)
tabstat loanamount if loanreasongiven==4 & year==2020, stat(mean) by(lender4)

* Amount by lender cat
tabstat loanamount if loanreasongiven==4 & year==2010, stat(mean) by(lender4cat)
tabstat loanamount if loanreasongiven==4 & year==2016, stat(mean) by(lender4cat)
tabstat loanamount if loanreasongiven==4 & year==2020, stat(mean) by(lender4cat)


* Test
gen repa=0
replace repa=1 if loanreasongiven==4
ta lender4 repa, chi2 cchi2 exp


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


***** Graph
import excel "_statgraph.xlsx", sheet("repa_reason") firstrow clear

label define mod 1"Agriculture" 2"Family" 3"Health" 4"Repay previous loan" 5"House expenses" 6"Investment" 7"Ceremonies" 8"Marriage" 9"Education" 10"Relatives" 11"Death" 77"Other"
label values mod mod
drop lab

graph bar y1 y2 y3, over(mod, lab(angle(45)) gap(100)) legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3))

****************************************
* END
















****************************************
* Stat desc 2, mieux catégoriser les prêts trappe
****************************************
use"panel_loans_v1", replace

keep HHID_panel year caste loanreasongiven imp1_debt_service imp1_interest_service

rename imp1_debt_service ds
rename imp1_interest_service is

fre loanreasongiven
gen ds_repa=ds if loanreasongiven==4
gen is_repa=is if loanreasongiven==4

gen trap=1 if loanreasongiven==4

collapse (sum) ds is ds_repa is_repa trap, by(HHID_panel year)

replace trap=1 if trap>1
recode trap (.=0)

ta trap year

gen dssharerepa=ds_repa*100/ds
gen issharerepa=is_repa*100/is

tabstat dssharerepa issharerepa if trap==1, stat(n mean q) by(year)

****************************************
* END
