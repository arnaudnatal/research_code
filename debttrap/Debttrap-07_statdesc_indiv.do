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
use"panel_indiv_v2", clear

*** Share
ta dummyloans_indiv year, m
ta dummyloans_indiv year, col
keep if dummyloans_indiv==1

*** Total
ta dummytrap_indiv year, col
tabstat trapamount_indiv if dummytrap_indiv==1, stat(n mean med) by(year)
tabstat gtdr_indiv if dummytrap_indiv==1, stat(n mean med) by(year)
tabstat gtir_indiv if dummytrap_indiv==1, stat(n mean med) by(year)
tabstat share_giventrap if dummytrap_indiv==1, stat(n mean med) by(year)

*** Men
ta dummytrap_indiv year if sex==1, col
tabstat trapamount_indiv if dummytrap_indiv==1 & sex==1, stat(n mean med) by(year)
tabstat gtdr_indiv if dummytrap_indiv==1 & sex==1, stat(n mean med) by(year)
tabstat gtir_indiv if dummytrap_indiv==1 & sex==1, stat(n mean med) by(year)
tabstat share_giventrap if dummytrap_indiv==1 & sex==1, stat(n mean med) by(year)

*** Women
ta dummytrap_indiv year if sex==2, col
tabstat trapamount_indiv if dummytrap_indiv==1 & sex==2, stat(n mean med) by(year)
tabstat gtdr_indiv if dummytrap_indiv==1 & sex==2, stat(n mean med) by(year)
tabstat gtir_indiv if dummytrap_indiv==1 & sex==2, stat(n mean med) by(year)
tabstat share_giventrap if dummytrap_indiv==1 & sex==2, stat(n mean med) by(year)


****************************************
* END


