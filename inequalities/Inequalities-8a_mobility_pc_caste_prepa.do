*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 8, 2024
*-----
gl link = "inequalities"
*Assets mobility by caste
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\inequalities.do"
*-------------------------








****************************************
* Assets 2010 to 2016-17
****************************************

* Dalits
use"panel_v3", clear
keep if caste==1
keep HHID_panel year assets_total_pc
rename assets_total_pc ass
replace ass=ass*1000
replace year=1 if year==2010
replace year=2 if year==2016
replace year=3 if year==2020
reshape wide ass, i(HHID_panel) j(year)
rename HHID_panel hhid
drop ass3
drop if ass1==.
drop if ass2==.
drop if ass1==0
drop if ass2==0
rename ass1 var1
rename ass2 var2
export delimited using "C:\Users\Arnaud\Documents\GitHub\research_code\inequalities\wealthpc1_dal.txt", delimiter(tab) replace


* Middle
use"panel_v3", clear
keep if caste==2
keep HHID_panel year assets_total_pc
rename assets_total_pc ass
replace ass=ass*1000
replace year=1 if year==2010
replace year=2 if year==2016
replace year=3 if year==2020
reshape wide ass, i(HHID_panel) j(year)
rename HHID_panel hhid
drop ass3
drop if ass1==.
drop if ass2==.
drop if ass1==0
drop if ass2==0
rename ass1 var1
rename ass2 var2
export delimited using "C:\Users\Arnaud\Documents\GitHub\research_code\inequalities\wealthpc1_mid.txt", delimiter(tab) replace


* Upper
use"panel_v3", clear
keep if caste==3
keep HHID_panel year assets_total_pc
rename assets_total_pc ass
replace ass=ass*1000
replace year=1 if year==2010
replace year=2 if year==2016
replace year=3 if year==2020
reshape wide ass, i(HHID_panel) j(year)
rename HHID_panel hhid
drop ass3
drop if ass1==.
drop if ass2==.
drop if ass1==0
drop if ass2==0
rename ass1 var1
rename ass2 var2
export delimited using "C:\Users\Arnaud\Documents\GitHub\research_code\inequalities\wealthpc1_upp.txt", delimiter(tab) replace


****************************************
* END


















****************************************
* Assets 2016-17 to 2020-21
****************************************

* Dalits
use"panel_v3", clear
keep if caste==1
keep HHID_panel year assets_total_pc
rename assets_total_pc ass
replace ass=ass*1000
replace year=1 if year==2010
replace year=2 if year==2016
replace year=3 if year==2020
reshape wide ass, i(HHID_panel) j(year)
rename HHID_panel hhid
drop ass1
drop if ass2==.
drop if ass3==.
rename ass2 ass1
rename ass3 ass2
drop if ass1==0
drop if ass2==0
rename ass1 var1
rename ass2 var2
export delimited using "C:\Users\Arnaud\Documents\GitHub\research_code\inequalities\wealthpc2_dal.txt", delimiter(tab) replace


* Middle
use"panel_v3", clear
keep if caste==2
keep HHID_panel year assets_total_pc
rename assets_total_pc ass
replace ass=ass*1000
replace year=1 if year==2010
replace year=2 if year==2016
replace year=3 if year==2020
reshape wide ass, i(HHID_panel) j(year)
rename HHID_panel hhid
drop ass1
drop if ass2==.
drop if ass3==.
rename ass2 ass1
rename ass3 ass2
drop if ass1==0
drop if ass2==0
rename ass1 var1
rename ass2 var2
export delimited using "C:\Users\Arnaud\Documents\GitHub\research_code\inequalities\wealthpc2_mid.txt", delimiter(tab) replace


* Upper
use"panel_v3", clear
keep if caste==3
keep HHID_panel year assets_total_pc
rename assets_total_pc ass
replace ass=ass*1000
replace year=1 if year==2010
replace year=2 if year==2016
replace year=3 if year==2020
reshape wide ass, i(HHID_panel) j(year)
rename HHID_panel hhid
drop ass1
drop if ass2==.
drop if ass3==.
rename ass2 ass1
rename ass3 ass2
drop if ass1==0
drop if ass2==0
rename ass1 var1
rename ass2 var2
export delimited using "C:\Users\Arnaud\Documents\GitHub\research_code\inequalities\wealthpc2_upp.txt", delimiter(tab) replace

****************************************
* END












****************************************
* Income 2010 to 2016-17
****************************************

* Dalits
use"panel_v3", clear
keep if caste==1
keep HHID_panel year monthlyincome_pc
rename monthlyincome_pc inc
replace inc=inc*1000
replace year=1 if year==2010
replace year=2 if year==2016
replace year=3 if year==2020
reshape wide inc, i(HHID_panel) j(year)
rename HHID_panel hhid
drop inc3
drop if inc1==.
drop if inc2==.
drop if inc1==0
drop if inc2==0
rename inc1 var1
rename inc2 var2
export delimited using "C:\Users\Arnaud\Documents\GitHub\research_code\inequalities\incomepc1_dal.txt", delimiter(tab) replace



* Middle
use"panel_v3", clear
keep if caste==2
keep HHID_panel year monthlyincome_pc
rename monthlyincome_pc inc
replace inc=inc*1000
replace year=1 if year==2010
replace year=2 if year==2016
replace year=3 if year==2020
reshape wide inc, i(HHID_panel) j(year)
rename HHID_panel hhid
drop inc3
drop if inc1==.
drop if inc2==.
drop if inc1==0
drop if inc2==0
rename inc1 var1
rename inc2 var2
export delimited using "C:\Users\Arnaud\Documents\GitHub\research_code\inequalities\incomepc1_mid.txt", delimiter(tab) replace




* Upper
use"panel_v3", clear
keep if caste==3
keep HHID_panel year monthlyincome_pc
rename monthlyincome_pc inc
replace inc=inc*1000
replace year=1 if year==2010
replace year=2 if year==2016
replace year=3 if year==2020
reshape wide inc, i(HHID_panel) j(year)
rename HHID_panel hhid
drop inc3
drop if inc1==.
drop if inc2==.
drop if inc1==0
drop if inc2==0
rename inc1 var1
rename inc2 var2
export delimited using "C:\Users\Arnaud\Documents\GitHub\research_code\inequalities\incomepc1_upp.txt", delimiter(tab) replace


****************************************
* END


















****************************************
* Income 2016-17 to 2020-21
****************************************

* Dalits
use"panel_v3", clear
keep if caste==1
keep HHID_panel year monthlyincome_pc
rename monthlyincome_pc inc
replace inc=inc*1000
replace year=1 if year==2010
replace year=2 if year==2016
replace year=3 if year==2020
reshape wide inc, i(HHID_panel) j(year)
rename HHID_panel hhid
drop inc1
drop if inc2==.
drop if inc3==.
rename inc2 inc1
rename inc3 inc2
drop if inc1==0
drop if inc2==0
rename inc1 var1
rename inc2 var2
export delimited using "C:\Users\Arnaud\Documents\GitHub\research_code\inequalities\incomepc2_dal.txt", delimiter(tab) replace


* Middle
use"panel_v3", clear
keep if caste==2
keep HHID_panel year monthlyincome_pc
rename monthlyincome_pc inc
replace inc=inc*1000
replace year=1 if year==2010
replace year=2 if year==2016
replace year=3 if year==2020
reshape wide inc, i(HHID_panel) j(year)
rename HHID_panel hhid
drop inc1
drop if inc2==.
drop if inc3==.
rename inc2 inc1
rename inc3 inc2
drop if inc1==0
drop if inc2==0
rename inc1 var1
rename inc2 var2
export delimited using "C:\Users\Arnaud\Documents\GitHub\research_code\inequalities\incomepc2_mid.txt", delimiter(tab) replace


* Upper
use"panel_v3", clear
keep if caste==3
keep HHID_panel year monthlyincome_pc
rename monthlyincome_pc inc
replace inc=inc*1000
replace year=1 if year==2010
replace year=2 if year==2016
replace year=3 if year==2020
reshape wide inc, i(HHID_panel) j(year)
rename HHID_panel hhid
drop inc1
drop if inc2==.
drop if inc3==.
rename inc2 inc1
rename inc3 inc2
drop if inc1==0
drop if inc2==0
rename inc1 var1
rename inc2 var2
export delimited using "C:\Users\Arnaud\Documents\GitHub\research_code\inequalities\incomepc2_upp.txt", delimiter(tab) replace

****************************************
* END

