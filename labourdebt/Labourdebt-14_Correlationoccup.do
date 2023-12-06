*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*December 5, 2023
*-----
gl link = "labourdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------






****************************************
* 2010 at individual level
****************************************
use"raw/RUME-occupnew", clear

* Merge sex, age
merge m:1 HHID2010 INDID2010 using "raw/RUME-HH", keepusing(name sex age relationshiptohead)
keep if _merge==3
drop _merge

order HHID2010 INDID2010 name sex age relationshiptohead

* Merge panel
merge m:m HHID2010 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2010, replace
merge m:m HHID_panel INDID2010 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

drop HHID2010 INDID2010

save "occn2010", replace
****************************************
* END








****************************************
* 2016-17 at individual level
****************************************
use"raw/NEEMSIS1-occupnew", clear

* Merge sex, age
merge m:1 HHID2016 INDID2016 using "raw/NEEMSIS1-HH", keepusing(name sex age relationshiptohead)
keep if _merge==3
drop _merge

order HHID2016 INDID2016 name sex age relationshiptohead

* Merge salariedjobtype
merge 1:1 HHID2016 INDID2016 occupationid using "raw/NEEMSIS1-occupations", keepusing(salariedjobtype salariedjobtype2)
drop _merge

* Merge panel
merge m:m HHID2016 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2016, replace
merge m:m HHID_panel INDID2016 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

drop HHID2016 INDID2016

save "occn2016", replace
****************************************
* END







****************************************
* 2020-21 at individual level
****************************************
use"raw/NEEMSIS2-occupnew", clear

* Merge sex, age
merge m:1 HHID2020 INDID2020 using "raw/NEEMSIS2-HH", keepusing(name sex age relationshiptohead)
keep if _merge==3
drop _merge

order HHID2020 INDID2020 name sex age relationshiptohead

* Merge salariedjobtype
merge 1:1 HHID2020 INDID2020 occupationid using "raw/NEEMSIS2-occupations", keepusing(salariedjobtype salariedjobtype2)
drop _merge

* Merge panel
merge m:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

drop HHID2020 INDID2020

save "occn2020", replace
****************************************
* END












****************************************
* Append indiv database
****************************************
use"occn2010", clear

append using "occn2016"
append using "occn2020"

* Merge caste
merge m:m HHID_panel year using "raw/Panel-Caste_HH_long", keepusing(jatiscorr caste)
drop _merge

rename jatiscorr jatis
order jatis caste, after(relationshiptohead)
label define caste 1"Dalits" 2"Middle castes" 3"Upper castes", replace
label values caste caste

* Clean
drop if occupation==0


save"totocc", replace
****************************************
* END









****************************************
* Stat by sex
****************************************
save"totocc", replace

tabstat hoursayear, stat(min p1 p5 p10 q p90 p95 p99 max)
ta hoursayear if hoursayear>4000

* Sex
ta occupation sex, col nofreq
ta occupation sex, chi2 cchi2 exp


****************************************
* END



