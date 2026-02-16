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
* IHDS-II: All India
****************************************
use"raw/IHDS-II-36151-0002-Data.dta", replace
cls

ta DB1
ta DB1 [iweight=WT]

* Sources
ta DB1A [iweight=WT]
ta DB1B [iweight=WT]
ta DB1C [iweight=WT]
ta DB1D [iweight=WT]
ta DB1E [iweight=WT]
ta DB1F [iweight=WT]

****************************************
* END






****************************************
* IHDS-II: Only Rural Tamil Nadu
****************************************
use"raw/IHDS-II-36151-0002-Data.dta", replace
cls
keep if STATEID==33
keep if URBAN2011==0

ta DB1
ta DB1 [iweight=WT]

* Sources
ta DB1A [iweight=WT]
ta DB1B [iweight=WT]
ta DB1C [iweight=WT]
ta DB1D [iweight=WT]
ta DB1E [iweight=WT]
ta DB1F [iweight=WT]


****************************************
* END
