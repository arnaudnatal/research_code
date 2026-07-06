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
use"Loans_v4", clear

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
use"Loans_v4", clear

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

***** Merge
use"Loans_v4", clear

merge 1:1 uniqueid using"_tempall"
drop _merge

save"Loans_v5", replace
****************************************
* Import











****************************************
* Definition + code State
****************************************
use"Loans_v5", clear

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

********** id des Etats pour merger avec les données geo
ta State
gen id=.
replace id=1 if State=="Dadra & Nagar Haveli"
replace id=1 if State=="Daman & Diu"
replace id=6 if State=="Jammu & Kashmir"
replace id=7 if State=="LADAKH"
replace id=8 if State=="Himanchal Pradesh"
replace id=9 if State=="Arunachal Pradesh"
replace id=10 if State=="Assam"
replace id=11 if State=="Manipur"
replace id=12 if State=="Meghalaya"
replace id=13 if State=="Mizoram"
replace id=14 if State=="Nagaland"
replace id=15 if State=="Sikkim"
replace id=16 if State=="Lakshadweep"
replace id=17 if State=="Andaman & Nicober Islands"
replace id=18 if State=="West Bengal"
replace id=19 if State=="Kerala"
replace id=20 if State=="Chhattisgarh"
replace id=21 if State=="Orissa"
replace id=22 if State=="Chandigarh"
replace id=23 if State=="Delhi"
replace id=24 if State=="Gujarat"
replace id=25 if State=="Haryana"
replace id=26 if State=="Punjab"
replace id=27 if State=="Uttar Pradesh"
replace id=28 if State=="Karnataka"
replace id=29 if State=="Andhra Pradesh"
replace id=30 if State=="Bihar"
replace id=31 if State=="Goa"
replace id=32 if State=="Jharkhand"
replace id=33 if State=="Madhya Pradesh"
replace id=34 if State=="Maharastra"
replace id=35 if State=="Puducherry"
replace id=36 if State=="Rajasthan"
replace id=37 if State=="Tamil Nadu"
replace id=38 if State=="Telengana"
replace id=39 if State=="Tripura"
replace id=40 if State=="Uttarakhand"

order id, after(State)

* Replace 
replace year=2018 if year==2019

save"Loans_v6", replace
****************************************
* END












****************************************
* Stats 1992 - 2019
****************************************
use"Loans_v6", clear

* N
ta clust_all
tabstat amount2, stat(mean) by(clust_all)

* N over year
ta clust_all year
ta clust_all year, col nofreq
tabstat amount2 if year==1992, stat(mean) by(clust_all)
tabstat amount2 if year==2002, stat(mean) by(clust_all)
tabstat amount2 if year==2012, stat(mean) by(clust_all)
tabstat amount2 if year==2018, stat(mean) by(clust_all)

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

* Sex
ta sex clust_all, col nofreq
ta sex clust_all, row nofreq
ta clust_all sex, chi2 cchi2 exp

* Age
ta agecat clust_all, col nofreq
ta agecat clust_all, row nofreq
ta clust_all agecat, chi2 cchi2 exp

* Educ
ta educ2 clust_all, col nofreq
ta educ2 clust_all, row nofreq
ta clust_all educ2, chi2 cchi2 exp

* Occupation
ta occ clust_all, col nofreq
ta occ clust_all, row nofreq
ta clust_all occ, chi2 cchi2 exp

* Maritalstatus
ta maritalstatus clust_all, col nofreq
ta maritalstatus clust_all, row nofreq
ta clust_all maritalstatus, chi2 cchi2 exp

* State
ta State clust_all, col nofreq
ta State clust_all, row nofreq
ta State clust_all, chi2 cchi2 exp

****************************************
* END









