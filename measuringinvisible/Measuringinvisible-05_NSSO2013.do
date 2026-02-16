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
Tamil Nadu	State=="33"
Viluppuram	State_District=="3307"
Cuddalore	State_District=="3318"
Rural		Sector=="1"
*/



****************************************
* Number of households
****************************************
use"raw/NSSO2013/Visit_1_Block_3_Household_Characteristics.dta", replace


***** How many households in India?
preserve
keep HHID Sector State State_District MLT Weight_SS Weight_SC
destring Sector, replace
label define Sector 1"Rural" 2"Urban"
label values Sector Sector
duplicates drop
count
save"_temp", replace
restore
*110,800 households in 2013


***** How many in Tamil Nadu?
count if State=="33"
* 6,842 households in Tamil Nadu


***** How many in rural Tamil Nadu?
count if State=="33" & Sector=="1"
* 3,429 households in rural Tamil Nadu


***** How many in rural Cuddalore and Viluppuram?
preserve
keep if State_District=="3307" | State_District=="3318"
keep if Sector=="1"
count
restore
* 364 households in rural Cuddalore or Viluppuram districts


****************************************
* END







****************************************
* Cash loans
****************************************
use"raw/NSSO2013/Visit_1_Block_14_cashloans.dta", replace

replace b14_q5=. if b14_q1=="99"
replace b14_q16=. if b14_q1=="99"
replace b14_q17=. if b14_q1=="99"

* Borrowed
gen borrowed=0
replace borrowed=1 if b14_q17!=. & b14_q17!=0
bys HHID: egen sborrowed=sum(borrowed)

keep HHID sborrowed
rename sborrowed borrowed
replace borrowed=1 if borrowed>1
duplicates drop
ta borrowed

merge 1:1 HHID using "_temp"
drop _merge
recode borrowed (.=0)

ta borrowed Sector
ta borrowed Sector, col
ta borrowed Sector [iweight=MLT], col 
ta borrowed Sector [iweight=Weight_SS], col
ta borrowed Sector [iweight=Weight_SC], col

/*
Ca c'est ok, c'est exactement comme dans le rapport
*/

* All India
ta borrowed Sector [iweight=MLT], col 
ta borrowed Sector [iweight=Weight_SS], col
ta borrowed Sector [iweight=Weight_SC], col

* Tamil Nadu
keep if State=="33"
ta borrowed Sector [iweight=MLT], col 
ta borrowed Sector [iweight=Weight_SS], col
ta borrowed Sector [iweight=Weight_SC], col

****************************************
* END






