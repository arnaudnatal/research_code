*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*March 28, 2023
*-----
gl link = "basicneeds"
*Prepa database for education
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\basicneeds.do"
*-------------------------








****************************************
* NEEMSIS-1
****************************************
use "raw\NEEMSIS1-HH.dta", clear

keep HHID2016 INDID2016 sex currentlyatschool educationexpenses amountschoolfees bookscost transportcost
sort HHID2016 INDID2016
tab currentlyatschool sex
foreach x in currentlyatschool educationexpenses amountschoolfees bookscost transportcost {
bysort HHID2016 : egen s_`x'=sum(`x')
}
tabstat educationexpenses, stat(n mean p50) by(sex)
keep HHID2016 s_currentlyatschool s_educationexpenses s_amountschoolfees s_bookscost s_transportcost
duplicates drop
ta s_currentlyatschool

* Merge panel
merge m:m HHID2016 using "raw/keypanel-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge

gen year=2016
order HHID_panel HHID2016 year


save"NEEMSIS1-edu.dta", replace
****************************************
* END







****************************************
* NEEMSIS-2
****************************************
use "raw\NEEMSIS2-HH.dta", clear

keep HHID2020 INDID2020 sex currentlyatschool educationexpenses amountschoolfees bookscost transportcost
sort HHID2020 INDID2020
tab currentlyatschool sex
foreach x in currentlyatschool educationexpenses amountschoolfees bookscost transportcost {
bysort HHID2020 : egen s_`x'=sum(`x')
}
tabstat educationexpenses, stat(n mean p50) by(sex)
keep HHID2020 s_currentlyatschool s_educationexpenses s_amountschoolfees s_bookscost s_transportcost
duplicates drop
ta s_currentlyatschool

* Merge panel
merge m:m HHID2020 using "raw/keypanel-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge

gen year=2020
order HHID_panel HHID2020 year

save"NEEMSIS2-edu.dta", replace
****************************************
* END








****************************************
* Append
****************************************
use"NEEMSIS1-edu.dta", clear

append using "NEEMSIS2-edu.dta"

ta year
drop HHID2016 HHID2020

save"panel-edu.dta", replace
****************************************
* END




