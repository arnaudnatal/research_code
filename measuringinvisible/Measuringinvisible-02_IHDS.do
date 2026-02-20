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
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------







****************************************
* IHDS-I: All India
****************************************
use"raw/IHDS-I-22626-0002-Data.dta", replace
cls

* Borrowed
gen borrowed=.
replace borrowed=0 if DB1==0 & DB1!=.
replace borrowed=1 if DB1>0 & DB1!=.
ta borrowed
ta borrowed [iweight=SWEIGHT]

* Number of loans
sum DB1 if borrowed==1 [iweight=SWEIGHT]

****************************************
* END











****************************************
* IHDS-II: All India
****************************************
use"raw/IHDS-II-36151-0002-Data.dta", replace
cls

* Borrowed
ta DB1
ta DB1 [iweight=WT]

* Sources
ta DB1A [iweight=WT]
ta DB1B [iweight=WT]
ta DB1C [iweight=WT]
ta DB1D [iweight=WT]
ta DB1E [iweight=WT]
ta DB1F [iweight=WT]

* Number
sum DB2 if DB1==1 [iweight=WT]

****************************************
* END






****************************************
* IHDS-II: All Rural India
****************************************
use"raw/IHDS-II-36151-0002-Data.dta", replace
cls
keep if URBAN2011==0

* Borrowed
ta DB1
ta DB1 [iweight=WT]

* Sources
ta DB1A [iweight=WT]
ta DB1B [iweight=WT]
ta DB1C [iweight=WT]
ta DB1D [iweight=WT]
ta DB1E [iweight=WT]
ta DB1F [iweight=WT]

* Number
sum DB2 if DB1==1 [iweight=WT]

****************************************
* END






****************************************
* IHDS-I: All Rural India
****************************************
use"raw/IHDS-I-22626-0002-Data.dta", replace
cls
keep if URBAN==0

* Borrowed
gen borrowed=.
replace borrowed=0 if DB1==0 & DB1!=.
replace borrowed=1 if DB1>0 & DB1!=.
ta borrowed
ta borrowed [iweight=SWEIGHT]

* Number of loans
sum DB1 if borrowed==1 [iweight=SWEIGHT]

****************************************
* END









****************************************
* IHDS-II: Only Rural Tamil Nadu
****************************************
use"raw/IHDS-II-36151-0002-Data.dta", replace
cls
keep if STATEID==33
keep if URBAN2011==0

* Borrowed
ta DB1
ta DB1 [iweight=WT]

* Sources
ta DB1A [iweight=WT]
ta DB1B [iweight=WT]
ta DB1C [iweight=WT]
ta DB1D [iweight=WT]
ta DB1E [iweight=WT]
ta DB1F [iweight=WT]

* Number
sum DB2 if DB1==1 [iweight=WT]

****************************************
* END










****************************************
* IHDS-I: Only Rural Tamil Nadu
****************************************
use"raw/IHDS-I-22626-0002-Data.dta", replace
cls
keep if STATEID==33
keep if URBAN==0

* Borrowed
gen borrowed=.
replace borrowed=0 if DB1==0 & DB1!=.
replace borrowed=1 if DB1>0 & DB1!=.
ta borrowed
ta borrowed [iweight=SWEIGHT]

* Number of loans
sum DB1 if borrowed==1 [iweight=SWEIGHT]

****************************************
* END

