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
* Stat desc
****************************************
use"Loans_v3", clear

* How many loans?
ta year

* How many households?
preserve
keep HHID year
duplicates drop
ta year
restore

* Desc
cls
tabstat amount2, stat(mean median sd) by(year)
ta lender5 year, col nofreq
ta reason7 year, col nofreq
ta interest year, col nofreq
ta security2 year, col nofreq
ta duration2 year, col nofreq
ta scheme2 year, col nofreq

****************************************
* END

















****************************************
* Export
****************************************
use"Loans_v3", clear

********** All
preserve
global var amount3cat3 lender5 reason7 interest duration2 security2 scheme2
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
global var amount3cat3 lender5 reason5 interest duration2 security2 scheme2
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
/*
import delimited using "Allloans_all_res.csv", clear
keep uniqueid cluster
ta cluster
rename cluster clust_all
save"_tempall", replace
*/

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
ta lender5 clust_all, row nofreq
ta reason7 clust_all, row nofreq
ta interest clust_all, row nofreq
ta security2 clust_all, row nofreq
ta duration2 clust_all, row nofreq
ta scheme2 clust_all, row nofreq

cls
ta amount3cat3 clust_all, col nofreq
ta lender5 clust_all, col nofreq
ta reason7 clust_all, col nofreq
ta interest clust_all, col nofreq
ta security2 clust_all, col nofreq
ta duration2 clust_all, col nofreq
ta scheme2 clust_all, col nofreq

label define clust_all ///
1"OL - HH" ///
2"IN - HH" ///
3"FO/IN - OR" ///
4"FO - BU" ///
5"FO - HH" ///
6"FO - FA"
label values clust_all clust_all
ta clust_all


*** All recent
ta clust_allrecent
ta clust_allrecent year, col nofreq

ta amount3cat3 clust_allrecent, row nofreq
ta lender5 clust_allrecent, row nofreq
ta reason5 clust_allrecent, row nofreq
ta interest clust_allrecent, row nofreq
ta security2 clust_allrecent, row nofreq
ta duration2 clust_allrecent, row nofreq
ta scheme2 clust_allrecent, row nofreq

ta amount3cat3 clust_allrecent, col nofreq
ta lender5 clust_allrecent, col nofreq
ta reason5 clust_allrecent, col nofreq
ta interest clust_allrecent, col nofreq
ta security2 clust_allrecent, col nofreq
ta duration2 clust_allrecent, col nofreq
ta scheme2 clust_allrecent, col nofreq

ta clust_allrecent year, col nofreq

label define clust_allrecent ///
1"OL - HH" ///
2"IN - HH" ///
3"IN - HC" ///
4"FO/IN - OR" ///
5"FO - HH" ///
6"FO - HO" ///
7"FO - IN"
label values clust_allrecent clust_allrecent
ta clust_allrecent


save"Loans_v5", replace
****************************************
* END












****************************************
* Stats 1992 - 2019
****************************************
use"Loans_v5", clear

* N
ta clust_all
tabstat amount2, stat(mean) by(clust_all)

* Evolution over time
ta clust_all year, col nofreq
ta clust_all year, chi2 cchi2 exp

* Rural / urban
ta Sector clust_all, col nofreq
ta Sector clust_all, row nofreq
ta clust_all Sector, chi2 cchi2 exp

* Caste
ta caste3 clust_all, col nofreq
ta caste3 clust_all, row nofreq
ta clust_all caste3, chi2 cchi2 exp

* Religion
ta religion3 clust_all, col nofreq
ta religion3 clust_all, row nofreq
ta clust_all religion3, chi2 cchi2 exp

* State
ta State clust_all, col nofreq
ta State clust_all, row nofreq
ta clust_all State, chi2 cchi2 exp

****************************************
* END












/*
****************************************
* Stats 2012 - 2019
****************************************
use"Loans_v5", clear

* N
ta clust_allrecent
tabstat amount2, stat(mean) by(clust_allrecent)

* Evolution over time
ta clust_allrecent year, col nofreq
ta clust_allrecent year, chi2 cchi2 exp

* Rural / urban
ta clust_allrecent Sector, col nofreq
ta Sector clust_allrecent, row nofreq
ta clust_allrecent Sector, chi2 cchi2 exp

* Caste
ta clust_allrecent caste3, col nofreq
ta caste3 clust_allrecent, row nofreq
ta clust_allrecent caste3, chi2 cchi2 exp

* Religion
ta clust_allrecent religion3, col nofreq
ta religion3 clust_allrecent, row nofreq
ta clust_allrecent religion3, chi2 cchi2 exp

* State
ta clust_allrecent State, col nofreq
ta State clust_allrecent, row nofreq
ta clust_allrecent State, chi2 cchi2 exp

****************************************
* END
*/
