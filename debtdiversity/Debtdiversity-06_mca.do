*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*January 21, 2025
*-----
gl link = "debtdiversity"
*Stat loan
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------







****************************************
* MCA
****************************************
cls
use"panel_loans_v1", replace



mca catloanamount loanreasongiven lender4, method (indicator) normal(princ) dim(5)
/*
mcacontrib
matrix list NewContrib
*/
mcaplot, overlay legend(off) xline(0) yline(0) scale(.8)



****************************************
* END
