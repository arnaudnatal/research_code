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
*cd"C:\Users\anatal\Documents\id"
*-------------------------








****************************************
* Export
****************************************
use"Loans_v3", clear

********** All
preserve
global var amount3cat3 lender4 reason7 interest duration2 security2 scheme2
keep uniqueid $var
egen nbmiss=rowmiss($var)
ta nbmiss
keep if nbmiss==0
drop nbmiss
foreach x in $var {
decode `x', gen(dec_`x')
drop `x'
rename dec_`x' `x'
}
export delimited using "Allloans_all.csv", replace
restore


********** All recent
preserve
keep if year==2012 | year==2019
global var amount3cat3 lender4 reason5 interest duration2 security2 scheme2
keep uniqueid $var
egen nbmiss=rowmiss($var)
ta nbmiss
keep if nbmiss==0
drop nbmiss
foreach x in $var {
decode `x', gen(dec_`x')
drop `x'
rename dec_`x' `x'
}
export delimited using "Allloans_allrecent.csv", replace
restore




****************************************
* END







****************************************
* Indiandebt-02_HCPC.R
****************************************










****************************************
* Import
****************************************

***** All
import delimited using "Allloans_all_res.csv", clear
keep uniqueid cluster
ta cluster
rename cluster clust_all
save"_tempall", replace

***** All recent
import delimited using "Allloans_allrecent_res.csv", clear
keep uniqueid cluster
ta cluster
rename cluster clust_allrecent
save"_tempallrecent", replace

***** Merge
use"Loans_v3", clear

merge 1:1 uniqueid using"_tempall"
drop _merge
merge 1:1 uniqueid using"_tempallrecent"
drop _merge

save"Loans_v4", replace
****************************************
* Import







****************************************
* Definition
****************************************
use"Loans_v4", clear

*** All
ta clust_all
ta clust_all year, col nofreq

ta amount3cat3 clust_all, row nofreq
ta lender4 clust_all, row nofreq
ta reason7 clust_all, row nofreq
ta interest clust_all, row nofreq
ta security2 clust_all, row nofreq
ta duration2 clust_all, row nofreq
ta scheme2 clust_all, row nofreq

ta amount3cat3 clust_all, col nofreq
ta lender4 clust_all, col nofreq
ta reason7 clust_all, col nofreq
ta interest clust_all, col nofreq
ta security2 clust_all, col nofreq
ta duration2 clust_all, col nofreq
ta scheme2 clust_all, col nofreq

label define clust_all ///
1"RelaFriends" ///
2"Moneylenders" ///
3"Other infor" ///
4"Other lender" ///
5"Formal business" ///
6"Other reason" ///
7"Formal farm and HH"
label values clust_all clust_all
ta clust_all


*** All recent
ta clust_allrecent
ta clust_allrecent year, col nofreq

ta amount3cat3 clust_allrecent, row nofreq
ta lender4 clust_allrecent, row nofreq
ta reason5 clust_allrecent, row nofreq
ta interest clust_allrecent, row nofreq
ta security2 clust_allrecent, row nofreq
ta duration2 clust_allrecent, row nofreq
ta scheme2 clust_allrecent, row nofreq

ta amount3cat3 clust_allrecent, col nofreq
ta lender4 clust_allrecent, col nofreq
ta reason5 clust_allrecent, col nofreq
ta interest clust_allrecent, col nofreq
ta security2 clust_allrecent, col nofreq
ta duration2 clust_allrecent, col nofreq
ta scheme2 clust_allrecent, col nofreq

ta clust_allrecent year, col nofreq

label define clust_allrecent ///
1"Other lender - HH" ///
2"Other info" ///
3"Info - HumCap" ///
4"Other form" ///
5"Form"  
label values clust_allrecent clust_allrecent
ta clust_allrecent



save"Loans_v4", replace
****************************************
* END







****************************************
* Stats
****************************************
use"Loans_v4", clear

* N
ta clusters1
tabstat amount2, stat(mean) by(clusters1)

* Evolution over time
ta clusters1 year, col nofreq
ta clusters1 year, chi2 cchi2 exp

* Rural / urban
ta clusters1 Sector, col nofreq
ta Sector clusters1, row nofreq
ta clusters1 Sector, chi2 cchi2 exp

* Caste
ta clusters1 caste2 if caste2!=1, col nofreq
ta caste2 clusters1 if caste2!=1, row nofreq
ta clusters1 caste2 if caste2!=1, chi2 cchi2 exp

* Religion
ta clusters1 religion2 if religion2!=1, col nofreq
ta religion2 clusters1 if religion2!=1, row nofreq
ta clusters1 religion2 if religion2!=1, chi2 cchi2 exp

* State
ta clusters1 State, col nofreq
ta State clusters1, row nofreq
ta clusters1 State, chi2 cchi2 exp

****************************************
* END




