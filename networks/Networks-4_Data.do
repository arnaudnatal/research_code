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
* Alters
****************************************
use"NEEMSIS2-alters_networkpurpose_v6", clear

drop if HHID2020=="uuid:ff95bdde-6012-4cf6-b7e8-be866fbaa68b"


save"Bases_Damien/NEEMSIS2-alters", replace
****************************************
* END







****************************************
* Couples
****************************************
use"raw/NEEMSIS2-couples", clear

drop if HHID2020=="uuid:ff95bdde-6012-4cf6-b7e8-be866fbaa68b"
drop name

save"Bases_Damien/NEEMSIS2-couples", replace
****************************************
* END





