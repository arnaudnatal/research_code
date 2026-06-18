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
*cd"C:\Users\anatal\Documents\id"
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

/*
b3q8  -- Does any member have any bank account?
b3q12 -- Receive any remittance during last 365 days?

b4q1  -- Person serial no.
b4q3  -- Relationship to head
b4q4  -- Sex
b4q5  -- Age
b4q6  -- General education
b4q7  -- Worker as per usual principal activity status
b4q8  -- Usual activity-principal status
b4q9  -- Usual activity-NIC-2008 code
*/

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

/*
block 3 -- 77th_V_I_Final.pdf (p. 185)
31  -- Person serial no.
33  -- Relationship to head
34  -- Sex
35  -- Age
36  -- General education
37  -- Worker as per usual principal activity status
  -- Usual activity-principal status
  -- Usual activity-NIC-2008 code


Column 7: whether holding deposit account in Commercial bank/ RRB/Co-operative
bank: 
*/


****************************************
* END








****************************************
* Harmonization
****************************************

********** Lenders
* 1992
use"_temp1992", clear
gen lender2=.
label define lender2 1"Lender: Institutional" 2"Lender: Landlord" 3"Lender: Moneylender" 4"Lender: Friends/Relatives" 77"Lender: Other"
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
label define lender2 1"Lender: Institutional" 2"Lender: Landlord" 3"Lender: Moneylender" 4"Lender: Friends/Relatives" 77"Lender: Other"
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
label define lender2 1"Lender: Institutional" 2"Lender: Landlord" 3"Lender: Moneylender" 4"Lender: Friends/Relatives" 77"Lender: Other"
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
label define lender2 1"Lender: Institutional" 2"Lender: Landlord" 3"Lender: Moneylender" 4"Lender: Friends/Relatives" 77"Lender: Other"
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
label define scheme2 0"Scheme: No" 1"Scheme: Yes"
label values scheme2 scheme2
replace scheme2=0 if scheme==9
replace scheme2=1 if scheme>=1 & scheme<=8
replace scheme2=0 if scheme==.
save"_temp1992_v3", replace

* 2002
use"_temp2002_v2", clear
gen scheme2=.
label define scheme2 0"Scheme: No" 1"Scheme: Yes"
label values scheme2 scheme2
replace scheme2=0 if scheme==9
replace scheme2=1 if scheme>=1 & scheme<=8
replace scheme2=0 if scheme==.
save"_temp2002_v3", replace

* 2012
use"_temp2012_v2", clear
gen scheme2=.
label define scheme2 0"Scheme: No" 1"Scheme: Yes"
label values scheme2 scheme2
replace scheme2=0 if scheme==9
replace scheme2=1 if scheme>=1 & scheme<=8
replace scheme2=1 if scheme>=10 & scheme<=11
replace scheme2=0 if scheme==.
save"_temp2012_v3", replace

* 2019
use"_temp2019_v2", clear
gen scheme2=.
label define scheme2 0"Scheme: No" 1"Scheme: Yes"
label values scheme2 scheme2
replace scheme2=0 if scheme==9
replace scheme2=1 if scheme>=1 & scheme<=8
replace scheme2=0 if scheme==.
save"_temp2019_v3", replace


********** Tenure
* 1992
use"_temp1992_v3", clear
gen duration2=.
label define duration2 1"Duration: Short-term" 2"Duration: Medium-term" 3"Duration: Long-term"
label values duration2 duration2
replace duration2=1 if duration==1
replace duration2=1 if duration==2
replace duration2=2 if duration==3
replace duration2=3 if duration==4
save"_temp1992_v4", replace

* 2002
use"_temp2002_v3", clear
gen duration2=.
label define duration2 1"Duration: Short-term" 2"Duration: Medium-term" 3"Duration: Long-term"
label values duration2 duration2
replace duration2=1 if duration==1
replace duration2=1 if duration==2
replace duration2=2 if duration==3
replace duration2=3 if duration==4
save"_temp2002_v4", replace

* 2012
use"_temp2012_v3", clear
gen duration2=.
label define duration2 1"Duration: Short-term" 2"Duration: Medium-term" 3"Duration: Long-term"
label values duration2 duration2
replace duration2=1 if duration==1
replace duration2=1 if duration==2
replace duration2=2 if duration==3
replace duration2=3 if duration==4
save"_temp2012_v4", replace

* 2019
use"_temp2019_v3", clear
gen duration2=.
label define duration2 1"Duration: Short-term" 2"Duration: Medium-term" 3"Duration: Long-term"
label values duration2 duration2
replace duration2=1 if duration==1
replace duration2=2 if duration==2
replace duration2=3 if duration==3
save"_temp2019_v4", replace


********** Interest
* 1992
use"_temp1992_v4", clear
gen interest2=.
label define interest2 0"Interest: No" 1"Interest: Yes"
label values interest2 interest2
replace interest2=0 if interest==1
replace interest2=1 if interest==2
replace interest2=1 if interest==3
replace interest2=1 if interest==4
save"_temp1992_v5", replace

* 2002
use"_temp2002_v4", clear
gen interest2=.
label define interest2 0"Interest: No" 1"Interest: Yes"
label values interest2 interest2
replace interest2=0 if interest==1
replace interest2=1 if interest==2
replace interest2=1 if interest==3
replace interest2=1 if interest==4
save"_temp2002_v5", replace

* 2012
use"_temp2012_v4", clear
gen interest2=.
label define interest2 0"Interest: No" 1"Interest: Yes"
label values interest2 interest2
replace interest2=0 if interest==1
replace interest2=1 if interest==2
replace interest2=1 if interest==3
replace interest2=1 if interest==4
save"_temp2012_v5", replace

* 2019
use"_temp2019_v4", clear
gen interest2=.
label define interest2 0"Interest: No" 1"Interest: Yes"
label values interest2 interest2
replace interest2=0 if interest==1
replace interest2=1 if interest==2
replace interest2=1 if interest==3
replace interest2=0 if interest==.
save"_temp2019_v5", replace


********** Purpose
* 1992
use"_temp1992_v5", clear
gen reason2=.
label define reason2 1"Reason: Investment" 2"Reason: Litigation" 3"Reason: Repayment" 4"Reason: Household" 77"Reason: Other"
label values reason2 reason2
replace reason2=1 if reason==1
replace reason2=1 if reason==2
replace reason2=4 if reason==3
save"_temp1992_v6", replace


* 2002
use"_temp2002_v5", clear
gen reason2=.
label define reason2 1"Reason: Investment" 2"Reason: Litigation" 3"Reason: Repayment" 4"Reason: Household" 77"Reason: Other"
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
label define reason2 1"Reason: Investment" 2"Reason: Litigation" 3"Reason: Repayment" 4"Reason: Household" 77"Reason: Other"
label values reason2 reason2
replace reason2=1 if reason>=1 & reason<=4
replace reason2=1 if reason==7
replace reason2=2 if reason==5
replace reason2=3 if reason==6
replace reason2=4 if reason==8
replace reason2=4 if reason==10
replace reason2=4 if reason==11
replace reason2=4 if reason==12
replace reason2=77 if reason==9
save"_temp2012_v6", replace

* 2019
use"_temp2019_v5", clear
gen reason2=.
label define reason2 1"Reason: Investment" 2"Reason: Litigation" 3"Reason: Repayment" 4"Reason: Household" 77"Reason: Other"
label values reason2 reason2
replace reason2=1 if reason>=1 & reason<=4
replace reason2=1 if reason==7
replace reason2=2 if reason==5
replace reason2=3 if reason==6
replace reason2=4 if reason==8
replace reason2=4 if reason==10
replace reason2=4 if reason==11
replace reason2=4 if reason==12
replace reason2=77 if reason==9
save"_temp2019_v6", replace

****************************************
* END
















****************************************
* Append
****************************************

* 1992
use"_temp1992_v6", clear
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
replace amount2=amount2/1000

*
foreach i in 1992 2002 2012 2019 {
xtile ca`i'=amount if year==`i', n(5)
}
gen cat5amount=.
foreach i in 1992 2002 2012 2019 {
replace cat5amount=ca`i' if year==`i'
}
drop ca1992 ca2002 ca2012 ca2019
label define cat5amount 1"Amount: Vlow" 2"Amount: Low" 3"Amount: Medium" 4"Amount: High" 5"Amount: Vhigh"
label values cat5amount cat5amount
*
foreach i in 1992 2002 2012 2019 {
xtile ca`i'=amount if year==`i', n(3)
}
gen cat3amount=.
foreach i in 1992 2002 2012 2019 {
replace cat3amount=ca`i' if year==`i'
}
drop ca1992 ca2002 ca2012 ca2019
label define cat3amount 1"Amount: Low" 2"Amount: Medium" 3"Amount: High"
label values cat3amount cat3amount
*
foreach i in 1992 2002 2012 2019 {
xtile ca`i'=amount if year==`i', n(10)
}
gen cat10amount=.
foreach i in 1992 2002 2012 2019 {
replace cat10amount=ca`i' if year==`i'
}
drop ca1992 ca2002 ca2012 ca2019
*
ta cat10amount
gen catamount1=.
replace catamount1=1 if cat10amount==1
replace catamount1=2 if cat10amount==2
replace catamount1=2 if cat10amount==3
replace catamount1=2 if cat10amount==4
replace catamount1=2 if cat10amount==5
replace catamount1=2 if cat10amount==6
replace catamount1=2 if cat10amount==7
replace catamount1=2 if cat10amount==8
replace catamount1=2 if cat10amount==9
replace catamount1=3 if cat10amount==10
label values catamount1 cat3amount 

gen catamount2=.
replace catamount2=1 if cat10amount==1
replace catamount2=1 if cat10amount==2
replace catamount2=2 if cat10amount==3
replace catamount2=2 if cat10amount==4
replace catamount2=2 if cat10amount==5
replace catamount2=2 if cat10amount==6
replace catamount2=2 if cat10amount==7
replace catamount2=2 if cat10amount==8
replace catamount2=3 if cat10amount==9
replace catamount2=3 if cat10amount==10
label values catamount2 cat3amount 

gen catamount3=.
replace catamount3=1 if cat10amount==1
replace catamount3=2 if cat10amount==2
replace catamount3=2 if cat10amount==3
replace catamount3=3 if cat10amount==4
replace catamount3=3 if cat10amount==5
replace catamount3=3 if cat10amount==6
replace catamount3=3 if cat10amount==7
replace catamount3=4 if cat10amount==8
replace catamount3=4 if cat10amount==9
replace catamount3=5 if cat10amount==10
label values catamount3 cat5amount 

ta catamount3

* Security
gen security2=.
label define security2 0"Security: No" 1"Security: Yes"
label values security2 security2
replace security2=0 if security==1 & year==1992
replace security2=1 if security>=2 & security<=10 & year==1992
replace security2=0 if security==1 & year==2002
replace security2=1 if security>=2 & security<=10 & year==2002
replace security2=0 if security==10 & year==2012
replace security2=1 if security>=1 & security<=9 & year==2012
replace security2=0 if security==2 & year==2019
replace security2=1 if security==1 & year==2019
replace security2=0 if security==.

* Cleaning
drop HHtype
bys HHID year: gen loanid=_n

* Reason
fre reason2
recode reason2 (2=77) (3=4)
ta reason2 year, col nofreq

* Lender
recode lender2 (2=77)

* Reason3
fre reason2
ta reason if year==2012 | year==2019
gen reason3=.
label values reason3 reason3
replace reason3=reason if year==2012
replace reason3=reason if year==2019
label define reason3 1"Reason: Capital (farm)" 2"Reason: Current (farm)" 3"Reason: Capital (non-farm)" 4"Reason: Current (non-farm)" 5"Reason: Litigation" 6"Reason: Repay" 7"Reason: Fin invest" 8"Reason: Education" 9"Reason: Other" 10"Reason: Health" 11"Reason: Housing" 12"Reason: Other household"
label values reason3 reason3
ta reason3

* Reason4
fre reason3
gen reason4=.
replace reason4=1 if reason3==1
replace reason4=1 if reason3==2
replace reason4=2 if reason3==3
replace reason4=2 if reason3==4
replace reason4=77 if reason3==5
replace reason4=5 if reason3==6
replace reason4=77 if reason3==7
replace reason4=3 if reason3==8
replace reason4=77 if reason3==9
replace reason4=3 if reason3==10
replace reason4=4 if reason3==11
replace reason4=5 if reason3==12
label define reason4 ///
1"Reason: Farm inv" ///
2"Reason: Non-farm inv" ///
3"Reason: Human capital" ///
4"Reason: Housing" ///
5"Reason: Household" ///
77"Reason: Other"
label values reason4 reason4
ta reason3 reason4

* Reason5
fre reason4
gen reason5=.
replace reason5=1 if reason4==1
replace reason5=1 if reason4==2
replace reason5=2 if reason4==3
replace reason5=3 if reason4==4
replace reason5=4 if reason4==5
replace reason5=5 if reason4==6
replace reason5=77 if reason4==77
label define reason5 ///
1"Reason: Investment" ///
2"Reason: Human capital" ///
3"Reason: Housing" ///
4"Reason: Household" ///
77"Reason: Other"
label values reason5 reason5
ta reason4 reason5

* Interest
label define interest 1"Interest: Free" 2"Interest: Simple" 3"Interest: Compound"
label values interest interest
recode interest (.=1) (4=99) (9=99)
ta interest

* Lender3
ta lender if year==2012
ta lender if year==2019

* Indiv id
egen uniqueid=group(HHID loanid)
order uniqueid, first

save "Loans_v1", replace
****************************************
* END



