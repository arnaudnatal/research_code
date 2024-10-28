*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*October 8, 2024
*-----
gl link = "networks"
*Correction base alters et bases couples
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\networks.do"
*-------------------------







****************************************
* Réseaux de dette
****************************************
cls
use"NEEMSIS2-alters_networkpurpose_v6", clear

*
fre networkpurpose*
keep if networkpurpose1==1
compress

save"Debtnetworks", replace
****************************************
* END






****************************************
* Réseaux de dette
****************************************

*
bysort HHID2020 namealter: gen n=_N
ta n
sort n HHID2020 INDID2020


****************************************
* END



