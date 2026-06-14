*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*June 6, 2026
*-----
gl link = "indiandebt"
*Cleaning AIDIS
*-----
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------









****************************************
* Cleaning 1992 - Visit 1 comme rapport et papiers EPW
****************************************
use"raw/NSSO1992/Block 17pt2_Visit 1_cashloans.dta", clear

* Serial selection
rename B17_2_q1 serial
destring serial, replace
drop if serial==99
drop if serial==.

* Rename
rename B17_2_q5 amount
rename B17_2_q6 lender
rename B17_2_q7 scheme
rename B17_2_q8 duration
rename B17_2_q9 interest
rename B17_2_q11 reason
rename B17_2_q13 security

* Selection
keep HHID ///
Sector State ///
amount lender scheme duration interest reason security

* Destring
destring lender scheme duration interest reason security, replace

* Merge
merge m:1 HHID using "raw/NSSO1992/Blocks 1,2,3,4,5_Visit 1_Household characteristics.dta", keepusing(B5_q1 B5_q3 B5_q5 Informant_Reln_Head)
keep if _merge==3
drop _merge

* Rename HH
rename B5_q1 HHsize
rename B5_q3 HHtype
rename B5_q5 caste
rename Informant_Reln_Head religion

destring HHsize HHtype caste religion, replace

* Order
order HHID Sector State caste HHsize HHtype


save"_temp1992", replace
****************************************
* END











****************************************
* Cleaning 2002 - Visit 1 comme rapport et papiers EPW
****************************************
use"raw/NSSO2003/Visit_1_2_Block_15_cashloans.dta", clear

* Serial selection
rename B15_2_q1 serial
destring serial, replace
drop if serial==99
drop if serial==.

* Visit selection
ta Visit_no
drop if Visit_no=="2"

* Rename
rename B15_2_q5 amount
rename B15_2_q6 lender
rename B15_2_q7 scheme
rename B15_2_q8 duration
rename B15_2_q9 interest
rename B15_2_q11 reason
rename B15_2_q12 security

* Selection
keep HHID ///
Sector State District ///
amount lender scheme duration interest reason security

* Destring
destring lender scheme duration interest reason security, replace

* Merge
merge m:1 HHID using "raw/NSSO2003/Visit_1_2_Block_3_Household_Characteristics.dta", keepusing(B3_q1 B3_q4 B3_q5 B3_q6 Weight)
keep if _merge==3
drop _merge

* Rename HH
rename B3_q1 HHsize
rename B3_q4 HHtype
rename B3_q5 religion
rename B3_q6 caste

destring HHsize HHtype religion caste, replace

* Order
order HHID Sector State District Weight caste religion HHsize HHtype


save"_temp2002", replace
****************************************
* END











****************************************
* Cleaning 2012 - Visit 1 comme rapport et papiers EPW
****************************************
use"raw/NSSO2013/Visit_1_Block_14_cashloans.dta", clear

* Serial selection
rename b14_q1 serial
destring serial, replace
drop if serial==99
drop if serial==.

* Rename
rename b14_q5 amount
rename b14_q6 lender
rename b14_q7 scheme
rename b14_q8 duration
rename b14_q9 interest
rename b14_q11 reason
rename b14_q12 security

rename District_id District

* Selection
keep HHID ///
Sector State District ///
amount lender scheme duration interest reason security

* Destring
destring lender scheme duration interest reason security, replace

* Merge
merge m:1 HHID using "raw/NSSO2013/Visit_1_Block_3_Household_Characteristics.dta", keepusing(b3q1 HH_type b3q7 b3q6 Weight_SC)
keep if _merge==3
drop _merge

* Rename HH
rename b3q1 HHsize
rename HH_type HHtype
rename b3q6 religion
rename b3q7 caste
rename Weight_SC Weight

destring HHsize HHtype religion caste, replace

* Order
order HHID Sector State District Weight caste religion HHsize HHtype


save"_temp2012", replace
****************************************
* END













****************************************
* Cleaning 2019 - Visit 1 comme rapport et papiers EPW
****************************************
use"raw/NSSO2019/Visit_1_Block_12_cashloans.dta", clear

* Serial selection
rename b12q1 serial
destring serial, replace
drop if serial==99
drop if serial==.

* Rename
rename b12q4 amount
rename b12q5 lender
rename b12q6 scheme
rename b12q7 duration
rename b12q8 interest
rename b12q10 reason
rename b12q11 security

* Selection
keep HHID ///
Sector State District ///
amount lender scheme duration interest reason security

* Destring
destring lender scheme duration interest reason security, replace

* Merge
merge m:1 HHID using "raw/NSSO2019/Visit_1_Block_4_Household_Characteristics.dta", keepusing(b4q1 b4q2 b4q3 b4q4 MLT)
keep if _merge==3
drop _merge

* Rename HH
rename b4q1 HHsize
rename b4q4 HHtype
rename b4q2 religion
rename b4q3 caste
rename MLT Weight

destring HHsize HHtype religion caste, replace

* Order
order HHID Sector State District Weight caste religion HHsize HHtype


save"_temp2019", replace
****************************************
* END








****************************************
* Harmonization
****************************************

********** Lenders
* 1992
use"_temp1992", clear
gen lender2=.
label define lender2 1"Institutional" 2"Landlord" 3"Moneylender" 4"Friends/Relatives" 77"Other"
label values lender2 lender2
replace lender2=1 if lender>=1 & lender<=6
replace lender2=2 if lender==7
replace lender2=3 if lender==8 | lender==9
replace lender2=4 if lender==11
replace lender2=77 if lender2==. & lender!=.
save"_temp1992_v2", replace

* 2002
use"_temp2002", clear
gen lender2=.
label define lender2 1"Institutional" 2"Landlord" 3"Moneylender" 4"Friends/Relatives" 77"Other"
label values lender2 lender2
replace lender2=1 if lender>=1 & lender<=8
replace lender2=2 if lender==9
replace lender2=3 if lender==10 | lender==11
replace lender2=4 if lender==13
replace lender2=77 if lender2==. & lender!=.
save"_temp2002_v2", replace

* 2012
use"_temp2012", clear
gen lender2=.
label define lender2 1"Institutional" 2"Landlord" 3"Moneylender" 4"Friends/Relatives" 77"Other"
label values lender2 lender2
replace lender2=1 if lender>=1 & lender<=8
replace lender2=1 if lender==10 | lender==11
replace lender2=2 if lender==12
replace lender2=3 if lender==13 | lender==14
replace lender2=4 if lender==16
replace lender2=77 if lender2==. & lender!=.
save"_temp2012_v2", replace

* 2019
use"_temp2019", clear
gen lender2=.
label define lender2 1"Institutional" 2"Landlord" 3"Moneylender" 4"Friends/Relatives" 77"Other"
label values lender2 lender2
replace lender2=1 if lender>=1 & lender<=8
replace lender2=1 if lender>=10 & lender<=13
replace lender2=2 if lender==14
replace lender2=3 if lender==15 | lender==16
replace lender2=4 if lender==18
replace lender2=77 if lender2==. & lender!=.
save"_temp2019_v2", replace


********** Scheme
* 1992
use"_temp1992_v2", clear
gen scheme2=.
label define scheme2 0"No scheme" 1"Scheme"
label values scheme2 scheme2
replace scheme2=0 if scheme==9
replace scheme2=1 if scheme>=1 & scheme<=8
replace scheme2=0 if scheme==.
save"_temp1992_v3", replace

* 2002
use"_temp2002_v2", clear
gen scheme2=.
label define scheme2 0"No scheme" 1"Scheme"
label values scheme2 scheme2
replace scheme2=0 if scheme==9
replace scheme2=1 if scheme>=1 & scheme<=8
replace scheme2=0 if scheme==.
save"_temp2002_v3", replace

* 2012
use"_temp2012_v2", clear
gen scheme2=.
label define scheme2 0"No scheme" 1"Scheme"
label values scheme2 scheme2
replace scheme2=0 if scheme==9
replace scheme2=1 if scheme>=1 & scheme<=8
replace scheme2=1 if scheme>=10 & scheme<=11
replace scheme2=0 if scheme==.
save"_temp2012_v3", replace

* 2019
use"_temp2019_v2", clear
gen scheme2=.
label define scheme2 0"No scheme" 1"Scheme"
label values scheme2 scheme2
replace scheme2=0 if scheme==9
replace scheme2=1 if scheme>=1 & scheme<=8
replace scheme2=0 if scheme==.
save"_temp2019_v3", replace


********** Tenure
* 1992
use"_temp1992_v3", clear
gen duration2=.
label define duration2 1"Short" 2"Med" 3"Long"
label values duration2 duration2
replace duration2=1 if duration==1
replace duration2=1 if duration==2
replace duration2=2 if duration==3
replace duration2=3 if duration==4
save"_temp1992_v4", replace

* 2002
use"_temp2002_v3", clear
gen duration2=.
label define duration2 1"Short" 2"Med" 3"Long"
label values duration2 duration2
replace duration2=1 if duration==1
replace duration2=1 if duration==2
replace duration2=2 if duration==3
replace duration2=3 if duration==4
save"_temp2002_v4", replace

* 2012
use"_temp2012_v3", clear
gen duration2=.
label define duration2 1"Short" 2"Med" 3"Long"
label values duration2 duration2
replace duration2=1 if duration==1
replace duration2=1 if duration==2
replace duration2=2 if duration==3
replace duration2=3 if duration==4
save"_temp2012_v4", replace

* 2019
use"_temp2019_v3", clear
gen duration2=.
label define duration2 1"Short" 2"Med" 3"Long"
label values duration2 duration2
replace duration2=1 if duration==1
replace duration2=2 if duration==2
replace duration2=3 if duration==3
save"_temp2019_v4", replace


********** Interest
* 1992
use"_temp1992_v4", clear
gen interest2=.
label define interest2 0"No interest" 1"Interest"
label values interest2 interest2
replace interest2=0 if interest==1
replace interest2=1 if interest==2
replace interest2=1 if interest==3
replace interest2=1 if interest==4
save"_temp1992_v5", replace

* 2002
use"_temp2002_v4", clear
gen interest2=.
label define interest2 0"No interest" 1"Interest"
label values interest2 interest2
replace interest2=0 if interest==1
replace interest2=1 if interest==2
replace interest2=1 if interest==3
replace interest2=1 if interest==4
save"_temp2002_v5", replace

* 2012
use"_temp2012_v4", clear
gen interest2=.
label define interest2 0"No interest" 1"Interest"
label values interest2 interest2
replace interest2=0 if interest==1
replace interest2=1 if interest==2
replace interest2=1 if interest==3
replace interest2=1 if interest==4
save"_temp2012_v5", replace

* 2019
use"_temp2019_v4", clear
gen interest2=.
label define interest2 0"No interest" 1"Interest"
label values interest2 interest2
replace interest2=0 if interest==1
replace interest2=1 if interest==2
replace interest2=1 if interest==3
replace interest2=0 if interest2==.
save"_temp2019_v5", replace


********** Purpose
* 2002
use"_temp2002_v5", clear
gen reason2=.
label define reason2 1"Investment" 2"Litigation" 3"Repayment" 4"Household" 77"Other"
label values reason2 reason2
replace reason2=1 if reason>=1 & reason<=4
replace reason2=1 if reason==8
replace reason2=2 if reason==6
replace reason2=3 if reason==7
replace reason2=4 if reason==5
replace reason2=77 if reason==9
save"_temp2002_v6", replace

* 2012
use"_temp2012_v5", clear
gen reason2=.
label define reason2 1"Investment" 2"Litigation" 3"Repayment" 4"Household" 77"Other"
label values reason2 reason2
replace reason2=1 if reason>=1 & reason<=4
replace reason2=1 if reason==7
replace reason2=2 if reason==5
replace reason2=3 if reason==6
replace reason2=4 if reason==8
replace reason2=4 if reason==10
replace reason2=4 if reason==12
replace reason2=77 if reason==9
replace reason2=77 if reason==11
save"_temp2012_v6", replace

* 2019
use"_temp2019_v5", clear
gen reason2=.
label define reason2 1"Investment" 2"Litigation" 3"Repayment" 4"Household" 77"Other"
label values reason2 reason2
replace reason2=1 if reason>=1 & reason<=4
replace reason2=1 if reason==7
replace reason2=2 if reason==5
replace reason2=3 if reason==6
replace reason2=4 if reason==8
replace reason2=4 if reason==10
replace reason2=4 if reason==12
replace reason2=77 if reason==9
replace reason2=77 if reason==11
save"_temp2019_v6", replace

****************************************
* END
















****************************************
* Append
****************************************

* 1992
use"_temp1992_v5", clear
gen year=1992
order year, after(HHID)
save"_tempw1", replace

* 2002
use"_temp2002_v6", clear
gen year=2002
order year, after(HHID)
save"_tempw2", replace

* 2012
use"_temp2012_v6", clear
gen year=2012
order year, after(HHID)
save"_tempw3", replace

* 2019
use"_temp2019_v6", clear
gen year=2019
order year, after(HHID)
save"_tempw4", replace

* Append
use"_tempw1", clear

append using "_tempw2"
append using "_tempw3"
append using "_tempw4"

save "Loans_v0", replace
****************************************
* END









****************************************
* Cleaning
****************************************
use "Loans_v0", clear


* Amount
/*
CPI base 100 en 2010: https://databank.worldbank.org/source/world-development-indicators/Series/FP.CPI.TOTL
1992	 29.2
2002	 58.8
2012	119.2
2019	171.6
Donc pour avoir base 100 en 2019 (x/171.6)*100
1992	 17.0
2002	 34.3
2012	 69.5
2019	100.0
*/
gen amount2=amount
replace amount2=amount*(100/17.0) if year==1992
replace amount2=amount*(100/34.3) if year==2002
replace amount2=amount*(100/69.5) if year==2012

xtile catamount=amount2, n(5)
label define catamount 1"V.low" 2"Low" 3"Med" 4"High" 5"V.high"
label values catamount catamount

* Caste
tostring caste, replace

replace caste="ST" if caste=="1" & year==1992
replace caste="SC" if caste=="2" & year==1992
replace caste="Others" if caste=="9" & year==1992

replace caste="ST" if caste=="1" & year==2002
replace caste="SC" if caste=="2" & year==2002
replace caste="OBC" if caste=="3" & year==2002
replace caste="Others" if caste=="9" & year==2002

replace caste="ST" if caste=="1" & year==2012
replace caste="SC" if caste=="2" & year==2012
replace caste="OBC" if caste=="3" & year==2012
replace caste="Others" if caste=="9" & year==2012

replace caste="ST" if caste=="1" & year==2019
replace caste="SC" if caste=="2" & year==2019
replace caste="OBC" if caste=="3" & year==2019
replace caste="Others" if caste=="9" & year==2019

encode caste, gen(caste2)

* Religion
tostring religion, replace

replace religion="." if year==1992

replace religion="Hindu" if religion=="1" & year==2002
replace religion="Muslim" if religion=="2" & year==2002
replace religion="Christian" if religion=="3" & year==2002
replace religion="Sikh" if religion=="4" & year==2002
replace religion="Jain" if religion=="5" & year==2002
replace religion="Buddhist" if religion=="6" & year==2002
replace religion="Zoro" if religion=="7" & year==2002
replace religion="Others" if religion=="9" & year==2002

replace religion="Hindu" if religion=="1" & year==2012
replace religion="Muslim" if religion=="2" & year==2012
replace religion="Christian" if religion=="3" & year==2012
replace religion="Sikh" if religion=="4" & year==2012
replace religion="Jain" if religion=="5" & year==2012
replace religion="Buddhist" if religion=="6" & year==2012
replace religion="Zoro" if religion=="7" & year==2012
replace religion="Others" if religion=="9" & year==2012

replace religion="Hindu" if religion=="1" & year==2019
replace religion="Muslim" if religion=="2" & year==2019
replace religion="Christian" if religion=="3" & year==2019
replace religion="Sikh" if religion=="4" & year==2019
replace religion="Jain" if religion=="5" & year==2019
replace religion="Buddhist" if religion=="6" & year==2019
replace religion="Zoro" if religion=="7" & year==2019
replace religion="Others" if religion=="9" & year==2019

encode religion, gen(religion2)

* Cleaning
drop HHtype
bys HHID year: gen loanid=_n

* Reason
recode reason2 (2=77) (3=4)

* Lender
recode lender2 (2=77)


save "Loans_v1", replace
****************************************
* END


















****************************************
* Selection
****************************************
use "Loans_v1", clear

drop amount lender scheme duration interest reason security religion caste

foreach x in caste religion lender scheme duration interest reason amount {
rename `x'2 `x'
}

order HHID year Sector State District Weight caste religion HHsize loanid amount catamount reason lender duration interest scheme

ta year

save "Loans_v2", replace
****************************************
* END
