*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*January 21, 2025
*-----
gl link = "debttrap"
*Stat desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------












****************************************
* Stat desc
****************************************


********** Total
use"panel_indiv_v2", clear
replace gbtir_indiv=gbtir_indiv*100
*
ta dummyloans_indiv year, m
ta dummyloans_indiv year, col
keep if dummyloans_indiv==1
*
ta dummytrap_indiv year, col
tabstat trapamount_indiv if dummytrap_indiv==1, stat(n mean med) by(year)
tabstat gtdr_indiv if dummytrap_indiv==1, stat(n mean med) by(year)
tabstat share_giventrap if dummytrap_indiv==1, stat(n mean med) by(year)


********** Men
use"panel_indiv_v2", clear
replace gbtir_indiv=gbtir_indiv*100
keep if sex==1
*
ta dummyloans_indiv year, m
ta dummyloans_indiv year, col
keep if dummyloans_indiv==1
*
ta dummytrap_indiv year, col
tabstat trapamount_indiv if dummytrap_indiv==1, stat(n mean med) by(year)
tabstat gtdr_indiv if dummytrap_indiv==1, stat(n mean med) by(year)
tabstat share_giventrap if dummytrap_indiv==1, stat(n mean med) by(year)


********** Women
use"panel_indiv_v2", clear
replace gbtir_indiv=gbtir_indiv*100
keep if sex==2
*
ta dummyloans_indiv year, m
ta dummyloans_indiv year, col
keep if dummyloans_indiv==1
*
ta dummytrap_indiv year, col
tabstat trapamount_indiv if dummytrap_indiv==1, stat(n mean med) by(year)
tabstat gtdr_indiv if dummytrap_indiv==1, stat(n mean med) by(year)
tabstat share_giventrap if dummytrap_indiv==1, stat(n mean med) by(year)



cls
********** Differences in 2016-17
use"panel_indiv_v2", clear
replace gbtir_indiv=gbtir_indiv*100
keep if year==2016
*
probit dummytrap_indiv i.sex
*
keep if dummytrap_indiv==1
reg trapamount_indiv i.sex
qreg trapamount_indiv i.sex
*
reg gtdr_indiv i.sex
qreg gtdr_indiv i.sex
*
reg share_giventrap i.sex
*qreg share_giventrap i.sex


cls
********** Differences in 2020-21
use"panel_indiv_v2", clear
replace gbtir_indiv=gbtir_indiv*100
keep if year==2020
*
probit dummytrap_indiv i.sex
*
keep if dummytrap_indiv==1
reg trapamount_indiv i.sex
qreg trapamount_indiv i.sex
*
reg gtdr_indiv i.sex
qreg gtdr_indiv i.sex
*
reg share_giventrap i.sex
qreg share_giventrap i.sex



****************************************
* END


