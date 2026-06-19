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
global var amount3cat2 amount5cat1 lender4 reason2 reason7 interest interest2 duration2 security2 scheme2
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

/*
********** Rural
preserve
fre Sector
keep if Sector==1
global var amount3cat3 lender4 reason2 interest interest2 duration2 security2 scheme2
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
export delimited using "Allloans_rural.csv", replace
restore
*/

********** All recent
preserve
keep if year==2012 | year==2019
global var amount3cat3 lender4 reason5 interest interest2 duration2 security2 scheme2
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

/*
********** Rural recent
preserve
fre Sector
keep if Sector==1
keep if year==2012 | year==2019
global var amount3cat3 lender4 reason5 interest interest2 duration2 security2 scheme2
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
export delimited using "Allloans_ruralrecent.csv", replace
restore
*/

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

/*
***** Rural
import delimited using "Allloans_rural_res.csv", clear
keep uniqueid cluster
ta cluster
rename cluster clust_rural
save"_temprural", replace

***** Rural recent
import delimited using "Allloans_ruralrecent_res.csv", clear
keep uniqueid cluster
ta cluster
rename cluster clust_ruralrecent
save"_tempruralrecent", replace
*/

***** Merge
use"Loans_v3", clear

merge 1:1 uniqueid using"_tempall"
drop _merge
merge 1:1 uniqueid using"_tempallrecent"
drop _merge
/*
merge 1:1 uniqueid using"_temprural"
drop _merge
merge 1:1 uniqueid using"_tempruralrecent"
drop _merge
*/
save"Loans_v4", replace
****************************************
* Import







****************************************
* Definition
****************************************
use"Loans_v4", clear


*** All
ta clust_all
ta amount3cat3 clust_all, row nofreq
ta lender4 clust_all, row nofreq
ta reason2 clust_all, row nofreq
ta interest2 clust_all, row nofreq
ta security2 clust_all, row nofreq
ta duration2 clust_all, row nofreq
ta scheme2 clust_all, row nofreq

ta amount3cat3 clust_all, col nofreq
ta lender4 clust_all, col nofreq
ta reason2 clust_all, col nofreq
ta interest2 clust_all, col nofreq
ta security2 clust_all, col nofreq
ta duration2 clust_all, col nofreq
ta scheme2 clust_all, col nofreq

ta clust_all year, col nofreq


label define clust_all ///
1"Institutional" ///
2"Other reason" ///
3"Moneylenders" ///
4"Other lenders" ///
5"Informal"
label values clust_all clust_all
ta clust_all




*** All recent
ta amount3cat3 clust_allrecent, row nofreq
ta lender4 clust_allrecent, row nofreq
ta reason5 clust_allrecent, row nofreq
ta interest2 clust_allrecent, row nofreq
ta security2 clust_allrecent, row nofreq
ta duration2 clust_allrecent, row nofreq
ta scheme2 clust_allrecent, row nofreq

ta amount3cat3 clust_allrecent, col nofreq
ta lender4 clust_allrecent, col nofreq
ta reason5 clust_allrecent, col nofreq
ta interest2 clust_allrecent, col nofreq
ta security2 clust_allrecent, col nofreq
ta duration2 clust_allrecent, col nofreq
ta scheme2 clust_allrecent, col nofreq

ta clust_allrecent year, col nofreq

label define clust_allrecent ///
1"Institutional" ///
2"Non-farm inv" ///
3"Other reason" ///
4"Informal" ///
5"Other lender"
label values clust_allrecent clust_allrecent
ta clust_allrecent


*** Rural
ta lender2 clust_rural, row nofreq
ta reason2 clust_rural, row nofreq
ta catamount3 clust_rural, row nofreq
ta interest clust_rural, row nofreq
ta security2 clust_rural, row nofreq
ta duration2 clust_rural, row nofreq
ta scheme2 clust_rural, row nofreq

ta lender2 clust_rural, col nofreq
ta reason2 clust_rural, col nofreq
ta catamount3 clust_rural, col nofreq
ta interest clust_rural, col nofreq
ta security2 clust_rural, col nofreq
ta duration2 clust_rural, col nofreq
ta scheme2 clust_rural, col nofreq

label define clust_rural ///
1"Informal" ///
2"Other lenders" ///
3"Moneylenders" ///
4"Other reason" ///
5"Vhigh amount" ///
6"Institutional"
label values clust_rural clust_rural
ta clust_rural




*** Rural recent
ta lender2 clust_ruralrecent, row nofreq
ta reason4 clust_ruralrecent, row nofreq
ta catamount3 clust_ruralrecent, row nofreq
ta interest clust_ruralrecent, row nofreq
ta security2 clust_ruralrecent, row nofreq
ta duration2 clust_ruralrecent, row nofreq
ta scheme2 clust_ruralrecent, row nofreq

ta lender2 clust_ruralrecent, col nofreq
ta reason4 clust_ruralrecent, col nofreq
ta catamount3 clust_ruralrecent, col nofreq
ta interest clust_ruralrecent, col nofreq
ta security2 clust_ruralrecent, col nofreq
ta duration2 clust_ruralrecent, col nofreq
ta scheme2 clust_ruralrecent, col nofreq

label define clust_rural ///
1"Institutional" ///
2"Vhigh" ///
3"Non-farm inv" ///
4"Other reason" ///
5"Human capital" ///
6"Moneylenders" ///
7"Other lenders" ///
8"Friends"
label values clust_rural clust_rural
ta clust_rural







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




