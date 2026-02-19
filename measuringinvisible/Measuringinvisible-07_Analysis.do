*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*February 16, 2026
*-----
gl link = "measuringinvisible"
*NSSO 2019
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------






****************************************
* Import + clean data
****************************************
* Import
import excel "_data.xlsx", sheet("Sheet1") firstrow clear
dropmiss, force

* Label
foreach x in source area rural level timeperiod {
encode `x', gen(n_`x')
drop `x'
rename n_`x' `x'
}
order source year area rural level timeperiod samplesize indebted

save"IndianHHdebt_v01.dta", replace
****************************************
* END






****************************************
* Verif lecture
****************************************
use"IndianHHdebt_v01.dta", clear

fre source
fre area
fre rural
fre timeperiod

ta indebted if source==3 & year==2019 & area==2 & rural==2 & timeperiod==3

****************************************
* END










****************************************
* All Indian households
****************************************
use"IndianHHdebt_v01.dta", clear

* Selection
fre area
keep if area==1
fre rural
keep if rural==1
fre source
drop if source==3 & year==2019

fre source

fre timeperiod

ta indebted if source==3 & year==2019 & area==2 & rural==2 & timeperiod==3

****************************************
* END
