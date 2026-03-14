*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*March 12, 2026
*-----
gl link = "genderofdebt"
*Prepa database Smallholder Survey
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------




****************************************
* Mozambique
****************************************
*
use"raw\CGAP_Smallholder_Financial_Diaries\Mozambique_2014\CGAP Smallholder Diaries_Data Set MZO Member Data_18 Feb 16.dta", clear
*
use"raw\CGAP_Smallholder_Financial_Diaries\Mozambique_2014\CGAP Smallholder Diaries_Data Set MZO Cash Flows_18 Feb 16.dta", clear

merge m:1 household_code id_member using "raw\CGAP_Smallholder_Financial_Diaries\Mozambique_2014\CGAP Smallholder Diaries_Data Set MZO Member Data_18 Feb 16.dta"
keep if _merge==3
drop _merge

*
gen country=1
label define country 1"Mozambique" 2"Pakistan" 3"Tanzania
label values country country
*
gen year=2014

save"MOZ", replace
****************************************
* END






****************************************
* Pakistan
****************************************
*
use"raw\CGAP_Smallholder_Financial_Diaries\Pakistan_2014\CGAP Smallholder Diaries_Data Set PAK Member Data_18 Feb 16.dta", clear
*
use"raw\CGAP_Smallholder_Financial_Diaries\Pakistan_2014\CGAP Smallholder Diaries_Data Set PAK Cash Flows_18 Feb 16.dta", clear

merge m:1 household_code id_member using "raw\CGAP_Smallholder_Financial_Diaries\Pakistan_2014\CGAP Smallholder Diaries_Data Set PAK Member Data_18 Feb 16.dta"
keep if _merge==3
drop _merge


*
gen country=2
label define country 1"Mozambique" 2"Pakistan" 3"Tanzania
label values country country
*
gen year=2014

save"PAK", replace
****************************************
* END









****************************************
* Tanzania
****************************************
*
use"raw\CGAP_Smallholder_Financial_Diaries\Tanzania_2014\CGAP Smallholder Diaries_Data Set TAN Member Data_18 Feb 16.dta", clear
*
use"raw\CGAP_Smallholder_Financial_Diaries\Tanzania_2014\CGAP Smallholder Diaries_Data Set TAN Cash Flows_18 Feb 16.dta", clear

merge m:1 household_code id_member using "raw\CGAP_Smallholder_Financial_Diaries\Tanzania_2014\CGAP Smallholder Diaries_Data Set TAN Member Data_18 Feb 16.dta"
keep if _merge==3
drop _merge


*
gen country=3
label define country 1"Mozambique" 2"Pakistan" 3"Tanzania
label values country country
*
gen year=2014

save"TZN", replace
****************************************
* END












****************************************
* Append
****************************************
use"MOZ", clear

*
append using "PAK"
append using "TZN"

*
rename household_code HHID
rename id_member INDID
rename M1age age
rename M1gender gender
rename M1maritalstatus maritalstatus
rename M1enrolled enrolled
rename M1level level
rename M1highesteduc highesteduc
drop M1language M1read M1write M1speak 

*
order HHID INDID age gender maritalstatus enrolled level highesteduc country year

save"CGAP-FD", replace
erase "MOZ.dta"
erase "PAK.dta"
erase "TZN.dta"
****************************************
* END











****************************************
* Stat
****************************************
use"CGAP-FD", replace

fre cf_category cf_type cf_direction cf_bsheet_direction

ta cf_type

****************************************
* END
