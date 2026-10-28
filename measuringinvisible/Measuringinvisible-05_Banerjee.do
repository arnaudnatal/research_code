*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*February 16, 2026
*-----
gl link = "measuringinvisible"
*Banerjee et al. (2014), AEJ
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
cd"C:\Users\Arnaud\Documents\MEGA\Research\Ongoing_Measuringinvisible\Analysis"
*-------------------------







****************************************
* Banerjee et al.
****************************************
use"Hyderabad/2013-0533_data_baseline.dta", replace
cls

* Any loan
fre anyloan

* Loan amount
tabstat anyloan_amt if anyloan==1, stat(n mean sd p50)

* Informal
fre informal

* Informal loan amount
tabstat informal_amt if informal==1, stat(n mean sd p50)

****************************************
* END








****************************************
* IHDS
****************************************
use"raw/IHDS-I-22626-0002-Data.dta", replace
cls

*Andhra Pradesh
*Hyderabad 2805
keep if DISTNAME==2805

gen outstanding=0
replace outstanding=1 if DB4>0 & DB4!=.

* Any loan
ta outstanding
ta outstanding [iweight=SWEIGHT]

* Loan amount
tabstat DB4 if outstanding==1, stat(n mean sd p50)
tabstat DB4 if outstanding==1 [weight=SWEIGHT], stat(n mean sd p50)

****************************************
* END








****************************************
* AIDIS
****************************************
use"NSSO2003-Outstanding_HH.dta", replace
cls

keep if Hyderabad==1

ta sborrowed
ta sborrowed [aweight=Weight]

tabstat samount if sborrowed==1 [aweight=Weight], stat(n mean sd p50)

ta slender_relafrien [aweight=Weight]

****************************************
* END




