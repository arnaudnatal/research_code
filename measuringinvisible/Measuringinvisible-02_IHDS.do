*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*February 16, 2026
*-----
gl link = "measuringinvisible"
*IHDS
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*cd"C:\Users\anatal\Documents\invisible\Analysis"
cd"C:\Users\Arnaud\Documents\MEGA\Research\Ongoing_Measuringinvisible\Analysis"
*-------------------------






****************************************
* IHDS-II: Only Rural Tamil Nadu
****************************************
use"raw/IHDS-II-36151-0002-Data.dta", replace
cls
keep if STATEID==33
keep if URBAN2011==0

* Outstanding amount
* How much in total does your household currently owe to others
gen dummyout=0
replace dummyout=1 if DB5>0 & DB5!=.
*
ta dummyout
ta dummyout [iweight=WT]
*
tabstat DB5 if dummyout==1 [weight=WT], stat(n mean sd p50)

****************************************
* END










****************************************
* IHDS-I: Only Rural Tamil Nadu
****************************************
use"raw/IHDS-I-22626-0002-Data.dta", replace
cls
keep if STATEID==33
keep if URBAN==0

* Outstanding amount
* How much in total does your household currently owe to others
gen dummyout=0
replace dummyout=1 if DB4>0 & DB4!=.
*
ta dummyout
ta dummyout [iweight=SWEIGHT]
*
tabstat DB4 if dummyout==1 [weight=SWEIGHT], stat(n mean sd p50)

****************************************
* END








****************************************
* IHDS-II: Only Rural Dist
****************************************
use"raw/IHDS-II-36151-0002-Data.dta", replace
cls
keep if STATEID==33
keep if URBAN2011==0
fre DISTRICT

***************************************
* END









****************************************
* IHDS-I: Only Rural Dist
****************************************
use"raw/IHDS-I-22626-0002-Data.dta", replace
cls
keep if STATEID==33
keep if URBAN==0
fre DISTNAME


****************************************
* END

