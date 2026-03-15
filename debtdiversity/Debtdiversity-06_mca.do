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
* CA
****************************************
use"panel_loans_v1", clear

ta loanreasongiven lender4

fre loanreasongiven
fre lender4

ca loanreasongiven lender4
* 3 dimensions
ca loanreasongiven lender4, dim(3)
estat coordinates
predict d1, rowscore(1)
predict d2, rowscore(2)
predict d3, rowscore(3)
*predict d1, colscore(1)
*predict d2, colscore(2)
*predict d3, colscore(3)

preserve
collapse (first) d1 d2 d3, by(loanreasongiven)
cluster wardslinkage d1 d2 d3, measure(Euclidean)
cluster dendrogram, cutnumber(9)
cluster gen clust=groups(4)

****************************************
* END











****************************************
* MCA all loans 1 (with 2010)
****************************************
use"panel_loans_v1", clear

* Add repay debt
fre loanreasongiven
fre reason_cat
ta loanreasongiven reason

fre reason_cat
replace reason_cat=6 if loanreasongiven==4
replace reason_cat=7 if loanreasongiven==3
label define reason_cat 1"R_eco" 2"R_cur" 3"R_edu" 4"R_cer" 5"R_hou" 6"R_rep" 7"R_hea", modify
fre reason

ta loanreasongiven reason_cat

*
ta year

* Selection
keep HHID_panel INDID_panel loanid year ///
lender4 reason_cat catloanamount

* Rename
rename lender4 lender
rename reason_cat reason
rename catloanamount amount

fre lender
fre reason
fre amount

* Export pour R
foreach x in lender reason amount {
decode `x', gen(`x'_dec)
drop `x'
rename `x'_dec `x'
}
export delimited using "Allloans.csv", replace

* Analyses sous R

* Import R
import delimited using "Allloans_res.csv", clear
rename hhid_panel HHID_panel
rename indid_panel INDID_panel

* 10 clusters
ta clust10
/*
ta lender clust10, col nofreq
ta reason clust10, col nofreq
ta amount clust10, col nofreq
ta clust10 year, col nofreq
*/

* 9 clusters
ta clust9
/*
ta lender clust9, col nofreq
ta reason clust9, col nofreq
ta amount clust9, col nofreq
ta clust9 year, col nofreq
*/

* 8 clusters
ta clust8
ta lender clust8, col nofreq
ta reason clust8, col nofreq
ta amount clust8, col nofreq
ta clust8 year, col nofreq

* 7 clusters
ta clust7
/*
ta lender clust7, col nofreq
ta reason clust7, col nofreq
ta amount clust7, col nofreq
ta clust7 year, col nofreq
*/

save"clustloan1", replace
****************************************
* END













****************************************
* MCA all loans 2 (without 2010)
****************************************
use"panel_loans_v1", clear

drop if year==2010

* Add repay debt
fre loanreasongiven
fre reason_cat
ta loanreasongiven reason

fre reason_cat
replace reason_cat=6 if loanreasongiven==4
replace reason_cat=7 if loanreasongiven==3
label define reason_cat 1"R_eco" 2"R_cur" 3"R_edu" 4"R_cer" 5"R_hou" 6"R_rep" 7"R_hea", modify
fre reason

ta loanreasongiven reason_cat

*
ta year

* Selection
keep HHID_panel INDID_panel loanid year loanamount ///
lender4 reason_cat catloanamount

* Rename
rename lender4 lender
rename reason_cat reason
rename catloanamount amount

fre lender
fre reason
fre amount

* Export pour R
foreach x in lender reason amount {
decode `x', gen(`x'_dec)
drop `x'
rename `x'_dec `x'
}
export delimited using "Allloans.csv", replace

* Analyses sous R

* Import R
import delimited using "Allloans_res.csv", clear
rename hhid_panel HHID_panel
rename indid_panel INDID_panel

* Merger les caractéristiques inviduelles
merge m:1 HHID_panel INDID_panel year using "panel_indiv_v0", keepusing(age sex relationshiptohead maritalstatus ownland house housetitle villageid edulevel working_pop mainocc_occupation_indiv annualincome_indiv nboccupation_indiv hoursayear_indiv nbloans_indiv loanamount_indiv imp1_ds_tot_indiv imp1_is_tot_indiv remreceived_indiv remsent_indiv remittnet_indiv dummydemonetisation time dummypanel dummysavingaccount HHsize typeoffamily assets_total1000 annualincome_HH shareincomeagri_HH secondlockdownexposure)
keep if _merge==3
drop _merge

save"clustloan1", replace
****************************************
* END





****************************************
* Stat desc indiv level
****************************************
use"clustloan1", clear


fre lender reason amount 

tabstat loanamount, stat(n min max mean) by(amount)

* 10 clusters
ta clust10
/*
ta lender clust10, col nofreq
ta reason clust10, col nofreq
ta amount clust10, col nofreq
ta clust10 year, col nofreq
*/

* 8 clusters
ta clust8
ta lender clust8, col nofreq
ta reason clust8, col nofreq
ta amount clust8, col nofreq
ta clust8 year, col nofreq

ta clust8 sex, exp cchi2 chi2
tabstat age, stat(mean) by(clust8)



****************************************
* END











****************************************
* MCA mains loans
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
mca $var, method (indicator) normal(princ) dim(16)
predict a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 a16
cluster wardslinkage a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 a16, measure(Euclidean)
cluster dendrogram, cutnumber(50)
cluster gen clustloan2=groups(11)

*
ta clustloan2
ta clustloan2 year, col nofreq
foreach x in $var {
ta `x' clustloan2, col nofreq
}

save"clustloan2", replace
****************************************
* END








