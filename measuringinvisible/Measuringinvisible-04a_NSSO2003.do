*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*February 16, 2026
*-----
gl link = "measuringinvisible"
*NSSO 2013
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------


/*
Tamil Nadu	State==33
Viluppuram	State_District==3307
Cuddalore	State_District==3318
Rural		Sector==1
*/



****************************************
* Number of households
****************************************
use"raw/NSSO2003/Visit_1_2_Block_3_Household_Characteristics.dta", replace

* Cleaning
destring State District Sector, replace
label define Sector 1"Rural" 2"Urban"
label values Sector Sector

***** How many households in India?
preserve
keep HHID Sector State District Weight
duplicates drop
count
ta Sector
gen totmaster=1
save"totHH", replace
restore
*139,041 households in 2003


***** How many in Tamil Nadu?
count if State==33
* 10,727 households in Tamil Nadu in 2003


***** How many in rural Tamil Nadu?
count if State==33 & Sector==1
* 5,496 households in rural Tamil Nadu in 2003


****************************************
* END









****************************************
* Merge les deux bases de données
****************************************
use"raw/NSSO2003/Visit_1_2_Block_15_part_1_cashloans.dta", clear

* Unique?
duplicates tag HHID B15_2_q1, gen(tag)
ta tag
drop tag

* Merge
merge 1:m HHID B15_2_q1 using "raw/NSSO2003/Visit_1_2_Block_15_part_2_cashloans.dta", keepusing(B15_2_q17 B15_2_q18 B15_2_q19 B15_2_q20 B15_2_q21 B15_2_q22 B15_2_q23 B15_2_q24)
drop if _merge==2
drop _merge

* Unique?
duplicates tag HHID B15_2_q1, gen(tag)
bys HHID: egen stag=sum(tag)
drop tag
sort stag HHID
drop if stag!=0
drop stag

save"raw/NSSO2003/Visit_1_2_Block_15_cashloans.dta", replace

****************************************
* END






****************************************
* Outstanding debt at the time of the survey
* Comme dans les rapports NSSO
****************************************
use"raw/NSSO2003/Visit_1_2_Block_15_cashloans.dta", clear

* Cleaning 1
drop if B15_2_q1=="99"

* Cleaning 2
drop if B15_2_q24==.

* To keep
keep HHID Sector State District B15_2_q6 B15_2_q11 B15_2_q24 Weight
destring Sector State District, replace
destring B15_2_q6 B15_2_q11, replace

* Label  sources + recat
fre B15_2_q6
label define B15_2_q6 1"Gov" 2"Coop bank" 3"Bank" 4"Insur" 5"Provident fund" 6"Finan instit" 7"Finan comp" 8"other instit agenc" 9"Landlord" 10"Agri moneylender" 11"Pro moneylender" 12"trader" 13"Relatives and friends" 14"Doctors, lawyers, other pro" 99"others"
label values B15_2_q6 B15_2_q6
fre B15_2_q6
gen lender=0
label define lender 0"Other" 1"Bank" 2"Moneylender" 3"Relatives/friends" 4"Fin instit"
label values lender lender
replace lender=1 if B15_2_q6==2
replace lender=1 if B15_2_q6==3
replace lender=2 if B15_2_q6==10
replace lender=2 if B15_2_q6==11
replace lender=3 if B15_2_q6==13
replace lender=4 if B15_2_q6==6
replace lender=4 if B15_2_q6==7
ta lender

* Label purposes
fre B15_2_q11
label define B15_2_q11 1"Cap exp farm" 2"Current exp farm" 3"Cap exp non-farm" 4"Current exp non-farm" 5"Household expenditure" 6"Litige" 7"Repay debt" 8"Finan invest"
label values B15_2_q11 B15_2_q11
fre B15_2_q11
gen purpose=0
label define purpose 0"Other" 1"Housing" 2"Education" 3"Health" 4"Farm/business"
label values purpose purpose
replace purpose=4 if B15_2_q11==1
replace purpose=4 if B15_2_q11==2
replace purpose=4 if B15_2_q11==3
replace purpose=4 if B15_2_q11==4
ta purpose

* Borrowed
gen borrowed=0
replace borrowed=1 if B15_2_q24!=. & B15_2_q24!=0
bys HHID: egen sborrowed=sum(borrowed)

* Number of loans
gen loan=1
bys HHID: egen sloan=sum(loan)

* Amount borrowed
bys HHID: egen samount=sum(B15_2_q24)

* Details by sources
ta lender, gen(lender_)
forvalues i=1/5 {
bys HHID: egen slender_`i'=sum(lender_`i')
}
drop lender_1-lender_5
rename slender_1 slender_other
rename slender_2 slender_bank
rename slender_3 slender_moneylender
rename slender_4 slender_relafrien
rename slender_5 slender_fininstit

* Details by reason
ta purpose, gen(purpose_)
forvalues i=1/2 {
bys HHID: egen spurpose_`i'=sum(purpose_`i')
}
drop purpose_1-purpose_2
rename spurpose_1 spurpose_other
rename spurpose_2 spurpose_farmbusi

* Selections
global dummies sborrowed slender_other slender_bank slender_moneylender slender_relafrien slender_fininstit spurpose_other spurpose_farmbusi
keep HHID samount sloan $dummies

* Recode dummies
foreach x in $dummies {
replace `x'=1 if `x'>1
}

* One obs per HH
duplicates drop

* Merge other HH
merge 1:1 HHID using "totHH"
drop if _merge==1
drop _merge

* Recode dummies
recode $dummies (.=0)

* Order
order HHID State District Sector Weight

* Save
save"NSSO2003-Outstanding_HH", replace
****************************************
* END











****************************************
* Any debt in the last 5 years
****************************************
use"raw/NSSO2003/Visit_1_2_Block_15_cashloans.dta", clear

* Cleaning 1
drop if B15_2_q1=="99"

* Cleaning 2
destring B15_2_q3, replace
drop if B15_2_q3<1998
drop if B15_2_q3>2003
ta B15_2_q3

* To keep
keep HHID Sector State District B15_2_q6 B15_2_q11 B15_2_q5 Weight
destring Sector State District, replace
destring B15_2_q6 B15_2_q11, replace

* Label  sources + recat
fre B15_2_q6
label define B15_2_q6 1"Gov" 2"Coop bank" 3"Bank" 4"Insur" 5"Provident fund" 6"Finan instit" 7"Finan comp" 8"other instit agenc" 9"Landlord" 10"Agri moneylender" 11"Pro moneylender" 12"trader" 13"Relatives and friends" 14"Doctors, lawyers, other pro" 99"others"
label values B15_2_q6 B15_2_q6
fre B15_2_q6
gen lender=0
label define lender 0"Other" 1"Bank" 2"Moneylender" 3"Relatives/friends" 4"Fin instit"
label values lender lender
replace lender=1 if B15_2_q6==2
replace lender=1 if B15_2_q6==3
replace lender=2 if B15_2_q6==10
replace lender=2 if B15_2_q6==11
replace lender=3 if B15_2_q6==13
replace lender=4 if B15_2_q6==6
replace lender=4 if B15_2_q6==7
ta lender

* Label purposes
fre B15_2_q11
label define B15_2_q11 1"Cap exp farm" 2"Current exp farm" 3"Cap exp non-farm" 4"Current exp non-farm" 5"Household expenditure" 6"Litige" 7"Repay debt" 8"Finan invest"
label values B15_2_q11 B15_2_q11
fre B15_2_q11
gen purpose=0
label define purpose 0"Other" 1"Housing" 2"Education" 3"Health" 4"Farm/business"
label values purpose purpose
replace purpose=4 if B15_2_q11==1
replace purpose=4 if B15_2_q11==2
replace purpose=4 if B15_2_q11==3
replace purpose=4 if B15_2_q11==4
ta purpose

* Borrowed
gen borrowed=0
replace borrowed=1 if B15_2_q5!=. & B15_2_q5!=0
bys HHID: egen sborrowed=sum(borrowed)

* Number of loans
gen loan=1
bys HHID: egen sloan=sum(loan)

* Details by sources
ta lender, gen(lender_)
forvalues i=1/5 {
bys HHID: egen slender_`i'=sum(lender_`i')
}
drop lender_1-lender_5
rename slender_1 slender_other
rename slender_2 slender_bank
rename slender_3 slender_moneylender
rename slender_4 slender_relafrien
rename slender_5 slender_fininstit

* Details by reason
ta purpose, gen(purpose_)
forvalues i=1/2 {
bys HHID: egen spurpose_`i'=sum(purpose_`i')
}
drop purpose_1-purpose_2
rename spurpose_1 spurpose_other
rename spurpose_2 spurpose_farmbusi

* Selections
global dummies sborrowed slender_other slender_bank slender_moneylender slender_relafrien slender_fininstit spurpose_other spurpose_farmbusi
keep HHID sloan $dummies

* Recode dummies
foreach x in $dummies {
replace `x'=1 if `x'>1
}

* One obs per HH
duplicates drop

* Merge other HH
merge 1:1 HHID using "totHH"
drop if _merge==1
drop _merge

* Recode dummies
recode $dummies (.=0)

* Order
order HHID State District Sector Weight

* Save
save"NSSO2003-Debt5years_HH", replace
****************************************
* END














****************************************
* Any debt in the last year
****************************************
use"raw/NSSO2003/Visit_1_2_Block_15_cashloans.dta", clear

* Cleaning 1
drop if B15_2_q1=="99"

* Cleaning 2
destring B15_2_q3, replace
drop if B15_2_q3<2002
drop if B15_2_q3>2003
ta B15_2_q3

* To keep
keep HHID Sector State District B15_2_q6 B15_2_q11 B15_2_q5 Weight
destring Sector State District, replace
destring B15_2_q6 B15_2_q11, replace

* Label  sources + recat
fre B15_2_q6
label define B15_2_q6 1"Gov" 2"Coop bank" 3"Bank" 4"Insur" 5"Provident fund" 6"Finan instit" 7"Finan comp" 8"other instit agenc" 9"Landlord" 10"Agri moneylender" 11"Pro moneylender" 12"trader" 13"Relatives and friends" 14"Doctors, lawyers, other pro" 99"others"
label values B15_2_q6 B15_2_q6
fre B15_2_q6
gen lender=0
label define lender 0"Other" 1"Bank" 2"Moneylender" 3"Relatives/friends" 4"Fin instit"
label values lender lender
replace lender=1 if B15_2_q6==2
replace lender=1 if B15_2_q6==3
replace lender=2 if B15_2_q6==10
replace lender=2 if B15_2_q6==11
replace lender=3 if B15_2_q6==13
replace lender=4 if B15_2_q6==6
replace lender=4 if B15_2_q6==7
ta lender

* Label purposes
fre B15_2_q11
label define B15_2_q11 1"Cap exp farm" 2"Current exp farm" 3"Cap exp non-farm" 4"Current exp non-farm" 5"Household expenditure" 6"Litige" 7"Repay debt" 8"Finan invest"
label values B15_2_q11 B15_2_q11
fre B15_2_q11
gen purpose=0
label define purpose 0"Other" 1"Housing" 2"Education" 3"Health" 4"Farm/business"
label values purpose purpose
replace purpose=4 if B15_2_q11==1
replace purpose=4 if B15_2_q11==2
replace purpose=4 if B15_2_q11==3
replace purpose=4 if B15_2_q11==4
ta purpose

* Borrowed
gen borrowed=0
replace borrowed=1 if B15_2_q5!=. & B15_2_q5!=0
bys HHID: egen sborrowed=sum(borrowed)

* Number of loans
gen loan=1
bys HHID: egen sloan=sum(loan)

* Details by sources
ta lender, gen(lender_)
forvalues i=1/5 {
bys HHID: egen slender_`i'=sum(lender_`i')
}
drop lender_1-lender_5
rename slender_1 slender_other
rename slender_2 slender_bank
rename slender_3 slender_moneylender
rename slender_4 slender_relafrien
rename slender_5 slender_fininstit

* Details by reason
ta purpose, gen(purpose_)
forvalues i=1/2 {
bys HHID: egen spurpose_`i'=sum(purpose_`i')
}
drop purpose_1-purpose_2
rename spurpose_1 spurpose_other
rename spurpose_2 spurpose_farmbusi

* Selections
global dummies sborrowed slender_other slender_bank slender_moneylender slender_relafrien slender_fininstit spurpose_other spurpose_farmbusi
keep HHID sloan $dummies

* Recode dummies
foreach x in $dummies {
replace `x'=1 if `x'>1
}

* One obs per HH
duplicates drop

* Merge other HH
merge 1:1 HHID using "totHH"
drop if _merge==1
drop _merge

* Recode dummies
recode $dummies (.=0)

* Order
order HHID State District Sector Weight

* Save
save"NSSO2003-Debtlastyear_HH", replace
****************************************
* END




















****************************************
* Stat NSSO 2013
****************************************

********** OUTSTANDING
use"NSSO2003-Outstanding_HH", clear
cls
* Incidence of indebtedness in All India
ta sborrowed Sector [aweight=Weight], col
ta slender_bank Sector [aweight=Weight], col nofreq
ta slender_moneylender Sector [aweight=Weight], col nofreq
ta slender_relafrien Sector [aweight=Weight], col nofreq
ta slender_fininstit Sector [aweight=Weight], col nofreq
ta spurpose_farmbusi Sector [aweight=Weight], col nofreq
tabstat samount if sborrowed==1 [aweight=Weight], stat(n mean) by(Sector)
tabstat sloan if sborrowed==1 [aweight=Weight], stat(n mean) by(Sector)
cls
* In Tamil Nadu
keep if State==33
ta sborrowed Sector [aweight=Weight], col nofreq
ta slender_bank Sector [aweight=Weight], col nofreq
ta slender_moneylender Sector [aweight=Weight], col nofreq
ta slender_relafrien Sector [aweight=Weight], col nofreq
ta slender_fininstit Sector [aweight=Weight], col nofreq
ta spurpose_farmbusi Sector [aweight=Weight], col nofreq
tabstat samount if sborrowed==1 [aweight=Weight], stat(n mean) by(Sector)
tabstat sloan if sborrowed==1 [aweight=Weight], stat(n mean) by(Sector)


********** LAST 5 YEARS
use"NSSO2003-Debt5years_HH", clear
cls
* Incidence of indebtedness in All India
ta sborrowed Sector [aweight=Weight], col nofreq
ta slender_bank Sector [aweight=Weight], col nofreq
ta slender_moneylender Sector [aweight=Weight], col nofreq
ta slender_relafrien Sector [aweight=Weight], col nofreq
ta slender_fininstit Sector [aweight=Weight], col nofreq
ta spurpose_farmbusi Sector [aweight=Weight], col nofreq
tabstat sloan if sborrowed==1 [aweight=Weight], stat(n mean) by(Sector)

cls
* In Tamil Nadu
keep if State==33
ta sborrowed Sector [aweight=Weight], col nofreq
ta slender_bank Sector [aweight=Weight], col nofreq
ta slender_moneylender Sector [aweight=Weight], col nofreq
ta slender_relafrien Sector [aweight=Weight], col nofreq
ta slender_fininstit Sector [aweight=Weight], col nofreq
ta spurpose_farmbusi Sector [aweight=Weight], col nofreq
tabstat sloan if sborrowed==1 [aweight=Weight], stat(n mean) by(Sector)


********** LAST YEAR
use"NSSO2003-Debtlastyear_HH", clear
cls
* Incidence of indebtedness in All India
ta sborrowed Sector [aweight=Weight], col nofreq
ta slender_bank Sector [aweight=Weight], col nofreq
ta slender_moneylender Sector [aweight=Weight], col nofreq
ta slender_relafrien Sector [aweight=Weight], col nofreq
ta slender_fininstit Sector [aweight=Weight], col nofreq
ta spurpose_farmbusi Sector [aweight=Weight], col nofreq
tabstat sloan if sborrowed==1 [aweight=Weight], stat(n mean) by(Sector)

cls
* In Tamil Nadu
keep if State==33
ta sborrowed Sector [aweight=Weight], col nofreq
ta slender_bank Sector [aweight=Weight], col nofreq
ta slender_moneylender Sector [aweight=Weight], col nofreq
ta slender_relafrien Sector [aweight=Weight], col nofreq
ta slender_fininstit Sector [aweight=Weight], col nofreq
ta spurpose_farmbusi Sector [aweight=Weight], col nofreq
tabstat sloan if sborrowed==1 [aweight=Weight], stat(n mean) by(Sector)

****************************************
* END






