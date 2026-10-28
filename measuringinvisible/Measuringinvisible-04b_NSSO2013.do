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
cd"C:\Users\Arnaud\Documents\MEGA\Research\Ongoing_Measuringinvisible\Analysis"
*-------------------------


/*
Tamil Nadu	State==33
Viluppuram	District==7
Cuddalore	District==18
Rural		Sector==1
*/



****************************************
* Number of households
****************************************
use"raw/NSSO2013/Visit_1_Block_3_Household_Characteristics.dta", replace

* Cleaning
destring State District Sector, replace
label define Sector 1"Rural" 2"Urban"
label values Sector Sector


*
gen totHH=1

*
gen ruralTN=0
replace ruralTN=1 if State==33 & Sector==1

*
gen ruralDist=.
replace ruralDist=0 if ruralTN==1
replace ruralDist=1 if State==33 & Sector==1 & District==7
replace ruralDist=1 if State==33 & Sector==1 & District==18

*
ta ruralTN
ta ruralDist

save"_temp", replace
****************************************
* END









****************************************
* Outstanding debt at the time of the survey
****************************************
use"raw/NSSO2013/Visit_1_Block_14_cashloans.dta", replace

* Vérification qu'il y ait bien tout les prêts
merge m:1 HHID using "_temp", keepusing(totHH ruralTN ruralDist)
keep if _merge==3
drop _merge totHH


* Cleaning 1
/*
99 c'est quand il n'y a pas de prêts, alors pourquoi il y a quand même des montants ?
*/
*replace b14_q5=. if b14_q1=="99"
*replace b14_q16=. if b14_q1=="99"
*replace b14_q17=. if b14_q1=="99"
drop if b14_q1=="99"

* Cleaning 2
/*
pour les statistiques du rapport, NSSO utilise b14_q17 pour l'IOI et l'outstanding debt, donc je fais pareil.
Mais je ne comprends pas la diff avec la variable b14_q16 qui a moins de manquants.
*/
drop if b14_q17==.

* Les prêts en cours datent de quand ?
ta b14_q3

* Cleaning 3
keep if b14_q5!=0
keep if b14_q5>0
keep if b14_q5!=.

* Stat
ta ruralTN
ta ruralDist
tabstat b14_q5 if ruralTN==1, stat(n mean sd p50)
tabstat b14_q5 if ruralDist==1, stat(n mean sd p50)

* To keep
keep HHID b14_q1 b14_q6 b14_q11 b14_q17 b14_q5 
destring b14_q1 b14_q6 b14_q11, replace

* Label  sources + recat
fre b14_q6
label define b14_q6 1"Gov" 2"Coop bank" 3"Bank" 4"Insur" 5"Provident fund" 6"Finan instit" 7"Finan comp" 8"SHG bank" 9"Others" 10"SHG non-bank" 11"Other instit agencies" 12"Landlord" 13"Agri moneylender" 14"Pro moneylender" 15"Input supplier" 16"Relatives and friends" 17"Doctors, lawyers, other pro"
label values b14_q6 b14_q6
fre b14_q6
gen lender=0
label define lender 0"Other" 1"Bank" 2"Moneylender" 3"Relatives/friends" 4"Fin instit"
label values lender lender
replace lender=1 if b14_q6==2
replace lender=1 if b14_q6==3
replace lender=2 if b14_q6==13
replace lender=2 if b14_q6==14
replace lender=3 if b14_q6==16
replace lender=4 if b14_q6==6
replace lender=4 if b14_q6==7
ta lender

* Label purposes
fre b14_q11
label define b14_q11 1"Cap exp farm" 2"Current exp farm" 3"Cap exp non-farm" 4"Current exp non-farm" 5"Exp litigation" 6"Debt repay" 7"Finan invest" 8"Education" 9"Others" 10"Medical treatment" 11"Housing" 12"Other exp"
label values b14_q11 b14_q11
fre b14_q11
gen purpose=0
label define purpose 0"Other" 1"Housing" 2"Education" 3"Health" 4"Farm/business"
label values purpose purpose
replace purpose=1 if b14_q11==11
replace purpose=2 if b14_q11==8
replace purpose=3 if b14_q11==10
replace purpose=4 if b14_q11==1
replace purpose=4 if b14_q11==2
replace purpose=4 if b14_q11==3
replace purpose=4 if b14_q11==4
ta purpose

* Borrowed
gen borrowed=0
replace borrowed=1 if b14_q17!=. & b14_q17!=0
bys HHID: egen sborrowed=sum(borrowed)

* Amount borrowed
bys HHID: egen samount=sum(b14_q17)

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
keep HHID samount sloan $dummies

* Recode dummies
foreach x in $dummies {
replace `x'=1 if `x'>1
}

* One obs per HH
duplicates drop

* Merge other HH
merge 1:1 HHID using "_temp", keepusing(ruralTN ruralDist Weight_SC)
drop if _merge==1
drop _merge


* Recode dummies
recode $dummies (.=0)

* Order
order HHID Weight_SC ruralTN ruralDist

* Save
save"NSSO2013-Outstanding_HH", replace
****************************************
* END



















****************************************
* TN 2012
****************************************
use"NSSO2013-Outstanding_HH", clear
cls
keep if ruralTN==1
ta sborrowed
ta sborrowed [aweight=Weight]
tabstat sloan if sborrowed==1 [aweight=Weight], stat(n mean sd p50)
tabstat samount if sborrowed==1 [aweight=Weight], stat(n mean sd p50)
ta slender_bank [aweight=Weight]
ta slender_moneylender [aweight=Weight]
ta slender_relafrien [aweight=Weight]
ta slender_fininstit [aweight=Weight]
ta spurpose_housing [aweight=Weight]
ta spurpose_education [aweight=Weight]
ta spurpose_health [aweight=Weight]
ta spurpose_farmbusi [aweight=Weight]

****************************************
* END







****************************************
* Dist 2012
****************************************
use"NSSO2013-Outstanding_HH", clear
cls
keep if ruralDist==1
ta sborrowed
ta sborrowed [aweight=Weight]
tabstat sloan if sborrowed==1 [aweight=Weight], stat(n mean sd p50)
tabstat samount if sborrowed==1 [aweight=Weight], stat(n mean sd p50)
ta slender_bank [aweight=Weight]
ta slender_moneylender [aweight=Weight]
ta slender_relafrien [aweight=Weight]
ta slender_fininstit [aweight=Weight]
ta spurpose_housing [aweight=Weight]
ta spurpose_education [aweight=Weight]
ta spurpose_health [aweight=Weight]
ta spurpose_farmbusi [aweight=Weight]

****************************************
* END






