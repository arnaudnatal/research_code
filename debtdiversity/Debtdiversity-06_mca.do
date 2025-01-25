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
* MCA 1
****************************************
use"panel_loans_v1", clear

* Selection
keep HHID_panel INDID_panel loanid year ///
lender4 reason_cat catloanamount

* Rename
rename lender4 lender
rename reason_cat reason
rename catloanamount amount

* Macro
global var lender reason amount

* MCA
mca $var, method (indicator) normal(princ)

* Cluster
mca $var, method (indicator) normal(princ) dim(10)
predict a1 a2 a3 a4 a5 a6 a7 a8 a9 a10
cluster wardslinkage a1 a2 a3 a4 a5 a6 a7 a8 a9 a10, measure(Euclidean)
cluster dendrogram, cutnumber(50)
cluster gen clustloan1=groups(10)

* Keep
keep HHID_panel INDID_panel loanid year clustloan1 _clus_*

save"clustloan1", replace
****************************************
* END










****************************************
* MCA 2
****************************************
use"panel_loans_v1", clear

* Selection
keep if dummymainloan==1
keep HHID_panel INDID_panel loanid year ///
lender4 reason_cat catmainloanamount dummyinterest guarantee otherlenderservice

* Rename
rename lender4 lender
rename reason_cat reason
rename catmainloanamount amount
rename dummyinterest interest
rename otherlenderservice services

* Macro
global var lender reason amount interest guarantee services

* MCA
mca $var, method (indicator) normal(princ)

* Cluster
mca $var, method (indicator) normal(princ) dim(11)
predict a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11
cluster wardslinkage a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11, measure(Euclidean)
*cluster dendrogram, cutnumber(50)
cluster gen clustloan2=groups(9)

* Keep
keep HHID_panel INDID_panel loanid year clustloan2 _clus_*

save"clustloan2", replace
****************************************
* END










****************************************
* Merge with main database
****************************************

********** Separer 2010 du reste
foreach i in 1 2 {
use"clustloan`i'", clear
keep if year==2010
drop INDID_panel
rename _clus_1_id _clus`i'_id
rename _clus_1_ord _clus`i'_ord
rename _clus_1_hgt _clus`i'_hgt
save"clustloan`i'_2010", replace

use"clustloan`i'", clear
drop if year==2010
rename _clus_1_id _clus`i'_id
rename _clus_1_ord _clus`i'_ord
rename _clus_1_hgt _clus`i'_hgt
save"clustloan`i'_reste", replace
}



********** Aussi sur la base "main"
use"panel_loans_v1", clear
keep if year==2010
drop INDID_panel
save"panel_loans_v1_2010", replace

use"panel_loans_v1", clear
drop if year==2010
save"panel_loans_v1_reste", replace


********** Merger 2010
use"panel_loans_v1_2010", clear
*
merge 1:1 HHID_panel loanid using "clustloan1_2010"
drop _merge
*
merge 1:1 HHID_panel loanid using "clustloan2_2010"
drop _merge

save"panel_loans_v1_clust_2010", replace


********** Merger reste
use"panel_loans_v1_reste", clear

*
merge 1:1 HHID_panel INDID_panel loanid year using "clustloan1_reste"
drop _merge
*
merge 1:1 HHID_panel INDID_panel loanid year using "clustloan2_reste"
drop _merge

save"panel_loans_v1_clust_reste", replace



********** Append 2010 avec le reste
use"panel_loans_v1_clust_2010", clear

append using "panel_loans_v1_clust_reste"

save"panel_loans_v1_clust", replace
****************************************
* END
