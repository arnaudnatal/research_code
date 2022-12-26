*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*April 23, 2021
*-----
gl link = "psychodebt"
*Stab
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------







****************************************
* PANEL
***************************************
use"$directory\raw\\$wave2", clear
duplicates drop HHID2016, force
keep HHID2016 year
merge m:m HHID2016 using "raw\ODRIIS-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename year year2016
save"$wave2~hh", replace

use"$directory\raw\\$wave3", clear
duplicates drop HHID2020, force
gen year=2020
keep HHID2020 year
merge m:m HHID2020 using "raw\ODRIIS-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename year year2020
save"$wave3~hh", replace

*Merge all
use"$wave2~hh", clear
merge 1:1 HHID_panel using "$wave3~hh"
rename _merge merge_1620

*One var
gen panel=0
replace panel=2 if year2016!=. & year2020!=.
tab panel

keep HHID_panel year2016 year2020 panel

foreach x in 2016 2020{
recode year`x' (.=0) (`x'=1)
}

*
tab year2016
tab year2020
tab year2016 year2020   // 485 en panel 2016-2020

save"panel", replace
****************************************
* END
