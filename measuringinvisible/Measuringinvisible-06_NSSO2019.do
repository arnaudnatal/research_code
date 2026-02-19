*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*February 16, 2026
*-----
gl link = "measuringinvisible"
*NSSO 2019
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
use"raw/NSSO2019/Visit_1_Block_4_Household_Characteristics.dta", replace

* Cleaning
destring State State_District Sector, replace
label define Sector 1"Rural" 2"Urban"
label values Sector Sector

***** How many households in India?
preserve
keep HHID Sector State State_District MLT
duplicates drop
ta Sector
count
save"totHH", replace
restore
*116,461 households in 2019


***** How many in Tamil Nadu?
count if State==33
* 7,075 households in Tamil Nadu


***** How many in rural Tamil Nadu?
count if State==33 & Sector==1
* 3,529 households in rural Tamil Nadu


***** How many in rural Cuddalore and Viluppuram?
preserve
keep if State_District==3307 | State_District==3318
keep if Sector==1
count
restore
* 252 households in rural Cuddalore or Viluppuram districts
/*
Mais pas sûr car je ne trouve pas le code des variables
*/

****************************************
* END









****************************************
* Outstanding debt at the time of the survey
* Comme dans les rapports NSSO
****************************************
use"raw/NSSO2019/Visit_1_Block_12_cashloans.dta", replace

* Cleaning 1
/*
99 c'est quand il n'y a pas de prêts, alors pourquoi il y a quand même des montants ?
*/
drop if b12q1=="99"

* Cleaning 2
/*
pour les statistiques du rapport, NSSO utilise b14_q17 pour l'IOI et l'outstanding debt, donc je fais pareil.
Mais je ne comprends pas la diff avec la variable b14_q16 qui a moins de manquants.
*/
drop if b12q15==.

* To keep
keep HHID Sector State State_District b12q15 MLT b12q5 b12q10
destring Sector State State_District, replace
destring b12q5 b12q10, replace

* Label  sources + recat
fre b12q5
label define b12q5 1"scheduled comm bank" 2"region rural bank" 3"coop society" 4"coop bank" 5"insuran" 6"provident fund" 7"employer" 8"finan instit" 10"non bank finan comp" 11"SHG bank" 12"SHG non-bank" 13"other instit agen" 14"landlord" 15"Agri moneylender" 16"Pro moneylender" 17"Input supplier" 18"Relatives and friends" 19"chitfund" 20"market commission agent traders" 9"other"
label values b12q5 b12q5
fre b12q5
gen lender=0
label define lender 0"Other" 1"Bank" 2"Moneylender" 3"Relatives/friends" 4"Fin instit" 5"Employer"
label values lender lender
replace lender=1 if b12q5==1
replace lender=1 if b12q5==2
replace lender=1 if b12q5==4
replace lender=2 if b12q5==15
replace lender=2 if b12q5==16
replace lender=3 if b12q5==18
replace lender=4 if b12q5==8
replace lender=5 if b12q5==7
ta lender

* Label purposes
fre b12q10
label define b12q10 1"Cap exp farm" 2"Revenue exp farm" 3"Capital exp non farm" 4"Revenu exp non farm" 5"Litigation" 6"Debt repay" 7"Fin invest" 8"Education" 9"Medical" 10"Housing" 11"Other hh exp" 12"Others"
label values b12q10 b12q10
fre b12q10

gen purpose=0
label define purpose 0"Other" 1"Housing" 2"Education" 3"Health" 4"Farm/business"
label values purpose purpose
replace purpose=1 if b12q10==10
replace purpose=2 if b12q10==8
replace purpose=3 if b12q10==9
replace purpose=4 if b12q10==1
replace purpose=4 if b12q10==2
replace purpose=4 if b12q10==3
replace purpose=4 if b12q10==4
ta purpose

* Borrowed
gen borrowed=0
replace borrowed=1 if b12q15!=. & b12q15!=0
bys HHID: egen sborrowed=sum(borrowed)

* Amount borrowed
bys HHID: egen samount=sum(b12q15)

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
forvalues i=1/5 {
bys HHID: egen spurpose_`i'=sum(purpose_`i')
}
drop purpose_1-purpose_5
rename spurpose_1 spurpose_other
rename spurpose_2 spurpose_housing
rename spurpose_3 spurpose_education
rename spurpose_4 spurpose_health
rename spurpose_5 spurpose_farmbusi

* Selections
global dummies sborrowed slender_other slender_bank slender_moneylender slender_relafrien slender_fininstit spurpose_other spurpose_housing spurpose_education spurpose_health spurpose_farmbusi
keep HHID samount $dummies

* Recode dummies
foreach x in $dummies {
replace `x'=1 if `x'>1
}

* One obs per HH
duplicates drop

* Merge other HH
merge 1:1 HHID using "totHH"
drop _merge

* Recode dummies
recode $dummies (.=0)

* Order
order HHID State State_District Sector MLT

* Save
save"NSSO2019-Outstanding_HH", replace
****************************************
* END











****************************************
* Any debt in the last 5 years
****************************************
use"raw/NSSO2019/Visit_1_Block_12_cashloans.dta", replace

* Cleaning 1
/*
99 c'est quand il n'y a pas de prêts, alors pourquoi il y a quand même des montants ?
*/
drop if b12q1=="99"

* Cleaning 2
drop if b12q2<2014

* To keep
keep HHID Sector State State_District b12q4 MLT b12q5 b12q10
destring Sector State State_District, replace
destring b12q5 b12q10, replace

* Label  sources + recat
fre b12q5
label define b12q5 1"scheduled comm bank" 2"region rural bank" 3"coop society" 4"coop bank" 5"insuran" 6"provident fund" 7"employer" 8"finan instit" 10"non bank finan comp" 11"SHG bank" 12"SHG non-bank" 13"other instit agen" 14"landlord" 15"Agri moneylender" 16"Pro moneylender" 17"Input supplier" 18"Relatives and friends" 19"chitfund" 20"market commission agent traders" 9"other"
label values b12q5 b12q5
fre b12q5
gen lender=0
label define lender 0"Other" 1"Bank" 2"Moneylender" 3"Relatives/friends" 4"Fin instit" 5"Employer"
label values lender lender
replace lender=1 if b12q5==1
replace lender=1 if b12q5==2
replace lender=1 if b12q5==4
replace lender=2 if b12q5==15
replace lender=2 if b12q5==16
replace lender=3 if b12q5==18
replace lender=4 if b12q5==8
replace lender=5 if b12q5==7
ta lender

* Label purposes
fre b12q10
label define b12q10 1"Cap exp farm" 2"Revenue exp farm" 3"Capital exp non farm" 4"Revenu exp non farm" 5"Litigation" 6"Debt repay" 7"Fin invest" 8"Education" 9"Medical" 10"Housing" 11"Other hh exp" 12"Others"
label values b12q10 b12q10
fre b12q10

gen purpose=0
label define purpose 0"Other" 1"Housing" 2"Education" 3"Health" 4"Farm/business"
label values purpose purpose
replace purpose=1 if b12q10==10
replace purpose=2 if b12q10==8
replace purpose=3 if b12q10==9
replace purpose=4 if b12q10==1
replace purpose=4 if b12q10==2
replace purpose=4 if b12q10==3
replace purpose=4 if b12q10==4
ta purpose

* Borrowed
gen borrowed=0
replace borrowed=1 if b12q4!=. & b12q4!=0
bys HHID: egen sborrowed=sum(borrowed)

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
forvalues i=1/5 {
bys HHID: egen spurpose_`i'=sum(purpose_`i')
}
drop purpose_1-purpose_5
rename spurpose_1 spurpose_other
rename spurpose_2 spurpose_housing
rename spurpose_3 spurpose_education
rename spurpose_4 spurpose_health
rename spurpose_5 spurpose_farmbusi

* Selections
global dummies sborrowed slender_other slender_bank slender_moneylender slender_relafrien slender_fininstit spurpose_other spurpose_housing spurpose_education spurpose_health spurpose_farmbusi
keep HHID $dummies

* Recode dummies
foreach x in $dummies {
replace `x'=1 if `x'>1
}

* One obs per HH
duplicates drop

* Merge other HH
merge 1:1 HHID using "totHH"
drop _merge

* Recode dummies
recode $dummies (.=0)

* Order
order HHID State State_District Sector MLT

* Save
save"NSSO2019-Debt5years_HH", replace
****************************************
* END









****************************************
* Any debt in the last year
****************************************
use"raw/NSSO2019/Visit_1_Block_12_cashloans.dta", replace

* Cleaning 1
/*
99 c'est quand il n'y a pas de prêts, alors pourquoi il y a quand même des montants ?
*/
drop if b12q1=="99"

* Cleaning 2
drop if b12q2<2018

* To keep
keep HHID Sector State State_District b12q4 MLT b12q5 b12q10
destring Sector State State_District, replace
destring b12q5 b12q10, replace

* Label  sources + recat
fre b12q5
label define b12q5 1"scheduled comm bank" 2"region rural bank" 3"coop society" 4"coop bank" 5"insuran" 6"provident fund" 7"employer" 8"finan instit" 10"non bank finan comp" 11"SHG bank" 12"SHG non-bank" 13"other instit agen" 14"landlord" 15"Agri moneylender" 16"Pro moneylender" 17"Input supplier" 18"Relatives and friends" 19"chitfund" 20"market commission agent traders" 9"other"
label values b12q5 b12q5
fre b12q5
gen lender=0
label define lender 0"Other" 1"Bank" 2"Moneylender" 3"Relatives/friends" 4"Fin instit" 5"Employer"
label values lender lender
replace lender=1 if b12q5==1
replace lender=1 if b12q5==2
replace lender=1 if b12q5==4
replace lender=2 if b12q5==15
replace lender=2 if b12q5==16
replace lender=3 if b12q5==18
replace lender=4 if b12q5==8
replace lender=5 if b12q5==7
ta lender

* Label purposes
fre b12q10
label define b12q10 1"Cap exp farm" 2"Revenue exp farm" 3"Capital exp non farm" 4"Revenu exp non farm" 5"Litigation" 6"Debt repay" 7"Fin invest" 8"Education" 9"Medical" 10"Housing" 11"Other hh exp" 12"Others"
label values b12q10 b12q10
fre b12q10

gen purpose=0
label define purpose 0"Other" 1"Housing" 2"Education" 3"Health" 4"Farm/business"
label values purpose purpose
replace purpose=1 if b12q10==10
replace purpose=2 if b12q10==8
replace purpose=3 if b12q10==9
replace purpose=4 if b12q10==1
replace purpose=4 if b12q10==2
replace purpose=4 if b12q10==3
replace purpose=4 if b12q10==4
ta purpose

* Borrowed
gen borrowed=0
replace borrowed=1 if b12q4!=. & b12q4!=0
bys HHID: egen sborrowed=sum(borrowed)

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
forvalues i=1/5 {
bys HHID: egen spurpose_`i'=sum(purpose_`i')
}
drop purpose_1-purpose_5
rename spurpose_1 spurpose_other
rename spurpose_2 spurpose_housing
rename spurpose_3 spurpose_education
rename spurpose_4 spurpose_health
rename spurpose_5 spurpose_farmbusi

* Selections
global dummies sborrowed slender_other slender_bank slender_moneylender slender_relafrien slender_fininstit spurpose_other spurpose_housing spurpose_education spurpose_health spurpose_farmbusi
keep HHID $dummies

* Recode dummies
foreach x in $dummies {
replace `x'=1 if `x'>1
}

* One obs per HH
duplicates drop

* Merge other HH
merge 1:1 HHID using "totHH"
drop _merge

* Recode dummies
recode $dummies (.=0)

* Order
order HHID State State_District Sector MLT

* Save
save"NSSO2019-Debtlastyear_HH", replace
****************************************
* END














****************************************
* Stat NSSO 2019
****************************************

********** OUTSTANDING
use"NSSO2019-Outstanding_HH", clear
cls
* Incidence of indebtedness in All India
ta sborrowed Sector [aweight=MLT], col nofreq
ta slender_bank Sector [aweight=MLT], col nofreq
ta slender_moneylender Sector [aweight=MLT], col nofreq
ta slender_relafrien Sector [aweight=MLT], col nofreq
ta slender_fininstit Sector [aweight=MLT], col nofreq
ta spurpose_housing Sector [aweight=MLT], col nofreq
ta spurpose_education Sector [aweight=MLT], col nofreq
ta spurpose_health Sector [aweight=MLT], col nofreq
ta spurpose_farmbusi Sector [aweight=MLT], col nofreq
tabstat samount if sborrowed==1 [aweight=MLT], stat(n mean) by(Sector)
cls
* In Tamil Nadu
keep if State==33
ta sborrowed Sector [aweight=MLT], col nofreq
ta slender_bank Sector [aweight=MLT], col nofreq
ta slender_moneylender Sector [aweight=MLT], col nofreq
ta slender_relafrien Sector [aweight=MLT], col nofreq
ta slender_fininstit Sector [aweight=MLT], col nofreq
ta spurpose_housing Sector [aweight=MLT], col nofreq
ta spurpose_education Sector [aweight=MLT], col nofreq
ta spurpose_health Sector [aweight=MLT], col nofreq
ta spurpose_farmbusi Sector [aweight=MLT], col nofreq
tabstat samount if sborrowed==1 [aweight=MLT], stat(n mean) by(Sector)


********** LAST 5 YEARS
use"NSSO2019-Debt5years_HH", clear
cls
* Incidence of indebtedness in All India
ta sborrowed Sector [aweight=MLT], col nofreq
ta slender_bank Sector [aweight=MLT], col nofreq
ta slender_moneylender Sector [aweight=MLT], col nofreq
ta slender_relafrien Sector [aweight=MLT], col nofreq
ta slender_fininstit Sector [aweight=MLT], col nofreq
ta spurpose_housing Sector [aweight=MLT], col nofreq
ta spurpose_education Sector [aweight=MLT], col nofreq
ta spurpose_health Sector [aweight=MLT], col nofreq
ta spurpose_farmbusi Sector [aweight=MLT], col nofreq
cls
* In Tamil Nadu
keep if State==33
ta sborrowed Sector [aweight=MLT], col nofreq
ta slender_bank Sector [aweight=MLT], col nofreq
ta slender_moneylender Sector [aweight=MLT], col nofreq
ta slender_relafrien Sector [aweight=MLT], col nofreq
ta slender_fininstit Sector [aweight=MLT], col nofreq
ta spurpose_housing Sector [aweight=MLT], col nofreq
ta spurpose_education Sector [aweight=MLT], col nofreq
ta spurpose_health Sector [aweight=MLT], col nofreq
ta spurpose_farmbusi Sector [aweight=MLT], col nofreq


********** LAST YEAR
use"NSSO2019-Debtlastyear_HH", clear
cls
* Incidence of indebtedness in All India
ta sborrowed Sector [aweight=MLT], col nofreq
ta slender_bank Sector [aweight=MLT], col nofreq
ta slender_moneylender Sector [aweight=MLT], col nofreq
ta slender_relafrien Sector [aweight=MLT], col nofreq
ta slender_fininstit Sector [aweight=MLT], col nofreq
ta spurpose_housing Sector [aweight=MLT], col nofreq
ta spurpose_education Sector [aweight=MLT], col nofreq
ta spurpose_health Sector [aweight=MLT], col nofreq
ta spurpose_farmbusi Sector [aweight=MLT], col nofreq
cls
* In Tamil Nadu
keep if State==33
ta sborrowed Sector [aweight=MLT], col nofreq
ta slender_bank Sector [aweight=MLT], col nofreq
ta slender_moneylender Sector [aweight=MLT], col nofreq
ta slender_relafrien Sector [aweight=MLT], col nofreq
ta slender_fininstit Sector [aweight=MLT], col nofreq
ta spurpose_housing Sector [aweight=MLT], col nofreq
ta spurpose_education Sector [aweight=MLT], col nofreq
ta spurpose_health Sector [aweight=MLT], col nofreq
ta spurpose_farmbusi Sector [aweight=MLT], col nofreq

****************************************
* END






