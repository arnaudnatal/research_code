*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*June 6, 2026
*-----
gl link = "indiandebt"
*MCA
*-----
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------













****************************************
* MCA
****************************************
use"Loans_v2", replace

* Selection
mdesc catamount reason lender duration interest scheme
drop if year==1992

* MCA
mca catamount reason lender duration interest scheme, method (indicator) normal(princ) dim(8)
predict a1 a2 a3 a4 a5 a6 a7 a8


* Export pour R
foreach x in catamount lender scheme duration interest reason {
decode `x', gen(`x'_dec)
drop `x'
rename `x'_dec `x'
}
export delimited using "Allloans.csv", replace

****************************************
* END
