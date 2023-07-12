*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*February 22, 2023
*-----
gl link = "marriageagri"
*Analysis NEEMSIS-2 marriage
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\marriageagri.do"
*-------------------------








****************************************
* NEEMSIS-1 - Only marriage sample
****************************************

use"NEEMSIS1-marriage_v2.dta", clear

*** Recode
destring ownland, replace
recode ownland (.=0)

*** To keep
keep if marriagedowry!=.
keep HHID2016 INDID2016 ownland caste age sex egoid name marriagedowry marriagetotalcost marriageexpenses MEAR DAAR MEIR DAIR DMC intercaste gifttoexpenses benefitsexpenses GAR GIR assets_total assets_totalnoland annualincome_HH
gen year=2016

*** Panel
merge m:m HHID2016 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2016, replace
merge m:m HHID_panel INDID2016 using "raw/ODRIIS-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge
destring INDID2016, replace

save "NEEMSIS1-marriage_tm.dta", replace
****************************************
* END










****************************************
* NEEMSIS-2 - Only marriage sample
****************************************
use"NEEMSIS2-marriage_v3.dta", clear

*** Recode
destring ownland, replace
recode ownland (.=0)


*** To keep
keep HHID2020 INDID2020 ownland caste age sex egoid name marriagedowry marriagetotalcost marriageexpenses MEAR DAAR MEIR DAIR DMC intercaste gifttoexpenses benefitsexpenses GAR GIR assets_total assets_totalnoland annualincome_HH
gen year=2020

*** Panel
merge m:m HHID2020 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw/ODRIIS-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge
destring INDID2020, replace

save "NEEMSIS2-marriage_tm.dta", replace
****************************************
* END











****************************************
* Append - Only marriage sample
****************************************
use"NEEMSIS1-marriage_tm.dta", clear

append using "NEEMSIS2-marriage_tm.dta"
order HHID_panel INDID_panel year name

save"NEEMSIS-marriage", replace
****************************************
* END
