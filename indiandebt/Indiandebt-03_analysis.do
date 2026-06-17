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
use"Loans_v2", clear

* How many loans?
ta year

* How many households?
preserve
keep HHID year
duplicates drop
ta year
restore

* Amount
tabstat amount2, stat(mean p50 sd) by(year)

* Reason given
ta reason2 year, col nofreq

* Lender
ta lender2 year, col nofreq

* Duration
ta duration2 year, col nofreq

* Interest
ta interest2 year, col nofreq

* Security
ta security2 year, col nofreq

* Scheme
ta scheme2 year, col nofreq

****************************************
* END















****************************************
* Export
****************************************
use"Loans_v2", clear

********** Preparation base 1992/2019
preserve
global var cat3amount cat5amount lender2 reason2 interest interest2 duration2 security2 scheme2
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
export delimited using "Allloans_9219.csv", replace
restore

********** Preparation base 2012/2019
preserve
global var cat3amount lender2 reason2 reason3 interest duration2 security2 scheme2
keep if year==2012 | year==2019
drop if interest==99
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
export delimited using "Allloans_1219.csv", replace
restore

****************************************
* END







****************************************
* Indiandebt-02_HCHCPCP.R
****************************************







****************************************
* Import
****************************************

***** 9219
import delimited using "Allloans_9219_res.csv", clear
keep uniqueid clusters1
save"_temp9219", replace

***** 1219
import delimited using "Allloans_1219_res.csv", clear
keep uniqueid clusters2
save"_temp1219", replace

***** Merge
use"Loans_v2", clear

merge 1:1 uniqueid using"_temp9219"
drop _merge
merge 1:1 uniqueid using"_temp1219"
drop _merge

save"Loans_v3", replace
****************************************
* Import








****************************************
* Definition
****************************************
use"Loans_v3", clear

*** Verif N
ta clusters1
ta clusters2

*** 1992 à 2019
ta lender2 clusters1, row nofreq
ta reason2 clusters1, row nofreq
ta cat3amount clusters1, row nofreq
ta interest2 clusters1, row nofreq
ta security2 clusters1, row nofreq
ta duration2 clusters1, row nofreq
ta scheme2 clusters1, row nofreq

ta lender2 clusters1, col nofreq
ta reason2 clusters1, col nofreq
ta cat3amount clusters1, col nofreq
ta interest2 clusters1, col nofreq
ta security2 clusters1, col nofreq
ta duration2 clusters1, col nofreq
ta scheme2 clusters1, col nofreq


label define clusters1 ///
1"Family investment" ///
2"Investment" ///
3"Survival" ///
4"Other purpose" ///
5"Moneylenders" ///
6"Other lender" ///
7"Informal" 
label values clusters1 clusters1
ta clusters1

*** 2012 à 2019
ta reason3 clusters2, row nofreq
ta lender2 clusters2, row nofreq
ta duration2 clusters2, row nofreq
ta interest clusters2, row nofreq
ta scheme2 clusters2, row nofreq
ta security2 clusters2, row nofreq
ta cat3amount clusters2, row nofreq

ta reason3 clusters2, col nofreq
ta lender2 clusters2, col nofreq
ta duration2 clusters2, col nofreq
ta interest clusters2, col nofreq
ta scheme2 clusters2, col nofreq
ta security2 clusters2, col nofreq
ta cat3amount clusters2, col nofreq

label define clusters2 ///
1"Formal agri investment" ///
2"Housing" ///
3"Non-agri investment" ///
4"Other purpose" ///
5"Health" ///
6"Moneylenders" ///
7"Other lender" ///
8"Informal"
label values clusters2 clusters2
ta clusters2

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




