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

* Combien de prêts ?
ta year

* Par type de prêts
ta loanreasongiven year, col nofreq

* Montant des prêts
tabstat loanamount, stat(mean) by(loanreasongiven)

fre loanreasongiven
ta lender_cat year if loanreasongiven==4, col nofreq


ta loanreasongiven effective_repa, row nofreq
ta loanreasongiven effective_repa, col nofreq

****************************************
* END
