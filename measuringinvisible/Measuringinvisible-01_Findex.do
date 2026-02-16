*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*February 16, 2026
*-----
gl link = "measuringinvisible"
*Findex
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------





****************************************
* Findex 2011
****************************************
use"raw/Findex2011.dta", replace
cls
keep if economy=="India"

* Sources
ta q14a [iweight=wgt]
ta q14b [iweight=wgt]
ta q14c [iweight=wgt]
ta q14d [iweight=wgt]
ta q14e [iweight=wgt]

* Reasons
ta q15a [iweight=wgt]
ta q15b [iweight=wgt]
ta q15c [iweight=wgt]
ta q15d [iweight=wgt]
ta q15e [iweight=wgt]

* Total borrowed
gen borrowed=0
foreach x in q14a q14b q14c q14d q14e q15a q15b q15c q15d q15e {
replace borrowed=1 if `x'==1
}
ta borrowed [iweight=wgt]


****************************************
* END








****************************************
* Findex 2014
****************************************
use"raw/Findex2014.dta", replace
cls
keep if economy=="India"

ta borrowed [iweight=wgt]

* Sources
ta q21a [iweight=wgt]
ta q21b [iweight=wgt]
ta q21c [iweight=wgt]
ta q21d [iweight=wgt]

* Reasons
ta q22a [iweight=wgt]
ta q22b [iweight=wgt]
ta q22c [iweight=wgt]
ta q20 [iweight=wgt]


****************************************
* END






****************************************
* Findex 2017
****************************************
use"raw/Findex2017.dta", replace
cls
keep if economy=="India"

ta borrowed [iweight=wgt]

* Sources
ta fin22a [iweight=wgt]
ta fin22b [iweight=wgt]
ta fin22c [iweight=wgt]

* Reasons
ta fin20 [iweight=wgt]
ta fin21 [iweight=wgt]
ta fin19 [iweight=wgt]


****************************************
* END





  






****************************************
* Findex 2021
****************************************
use"raw/Findex2021.dta", replace
cls
keep if economy=="India"

ta borrowed [iweight=wgt]

* Sources
ta fin22a [iweight=wgt]
ta fin22b [iweight=wgt]
ta fin22c [iweight=wgt]

* Reasons
ta fin20 [iweight=wgt]

* Mobile money
ta fin13c [iweight=wgt]

* Not pay credit in full
gen carddebt=0
*fin8 used a credit card
*fin8b paid credit card balances in full
replace carddebt=1 if fin8==1 & fin8b==2
ta carddebt [iweight=wgt]

****************************************
* END














****************************************
* Findex 2024
****************************************
use"raw/Findex2024.dta", replace
cls
keep if economy=="India"

ta borrowed [iweight=wgt]
ta fin23 [iweight=wgt]

* Sources
ta fin22a [iweight=wgt]
ta fin22a_1 [iweight=wgt]
ta fin22b [iweight=wgt]
ta fin22c [iweight=wgt]
ta fin20 [iweight=wgt]

* Reasons
ta fin22d [iweight=wgt]
ta fin22e [iweight=wgt]
ta fin22f [iweight=wgt]

* Not pay credit in full
gen carddebt=0
*fin22g used a credit card
*fin22h paid credit card balances in full
replace carddebt=1 if fin22g==1 & fin22h==2
ta carddebt [iweight=wgt]

****************************************
* END
