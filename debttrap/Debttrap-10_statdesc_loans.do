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
ta lender4cat year if loanreasongiven==4, col nofreq



********** Effective
*
global cat agri fami heal repa hous inve cere marr educ rela deat
cls
foreach x in $cat {
ta effective_`x' year, col nofreq
}

*
cls
foreach x in $cat {
tabstat loanamount if year==2010, stat(mean) by(effective_`x')
tabstat loanamount if year==2016, stat(mean) by(effective_`x')
tabstat loanamount if year==2020, stat(mean) by(effective_`x')
}

*
ta year if effective_repa==1
ta lender4 year if effective_repa==1, col nofreq
ta lender4cat year if effective_repa==1, col nofreq


****************************************
* END


















****************************************
* Change in loan reason
****************************************
use"panel_loans", replace

* Selection
drop if year==2010

* Utilisation des prêts annoncé pour repayer
preserve
keep if loanreasongiven==4
ta year
global cat agri fami heal repa hous inve cere marr educ rela deat
cls
foreach x in $cat {
ta effective_`x' year if year==2016, m col nofreq
ta effective_`x' year if year==2020, m col nofreq
}
restore


* Raison des prêts utilisé pour repayer
preserve
keep if effective_repa==1
ta year
ta loanreasongiven year, col nofreq
restore



****************************************
* END




