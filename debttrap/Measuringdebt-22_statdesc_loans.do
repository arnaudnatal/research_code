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
* Stat desc
****************************************
use"panel_loans", replace

ta loanreasongiven year, col nofreq

fre loanreasongiven
ta lender4 year if loanreasongiven==4, col nofreq


ta loanreasongiven loaneffectivereason

****************************************
* END








****************************************
* Stat desc
****************************************
use"panel_loans", replace


ta loanreasongiven effective_repa, row nofreq
ta loanreasongiven effective_repa, col nofreq
ta loanreasongiven effective_repa, m
ta loanreasongiven effective_repa if year==2010, m
ta loanreasongiven effective_repa if year==2016, m
ta loanreasongiven effective_repa if year==2020, m






****************************************
* END
