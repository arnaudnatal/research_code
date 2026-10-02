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
* Loan amount
****************************************
use"Loans_v4", clear

ta year
gen time=.
replace time=1 if year==1992
replace time=2 if year==2002
replace time=3 if year==2012
replace time=4 if year==2019
label define time 1"1992" 2"2002" 3"2012" 4"2019"
label values time time
ta time year, m

bys time: egen med = median(amount2)
bys time: egen lqt = pctile(amount2), p(25)
bys time: egen uqt = pctile(amount2), p(75)
bys time: egen iqr = iqr(amount2)
bys time: egen mean = mean(amount2)
gen l = amount2 if(amount2 >= lqt-1.5*iqr)
bys time: egen ls = min(l)
gen u = amount2 if(amount2 <= uqt+1.5*iqr)
bys time: egen us = max(u)
*
twoway rbar lqt med time, fcolor(gs12) lcolor(black) barw(.5) || ///
       rbar med uqt time, fcolor(gs12) lcolor(black) barw(.5) || ///
       rspike lqt ls time, lcolor(black) || ///
       rspike uqt us time, lcolor(black) || ///
       rcap ls ls time, msize(*6) lcolor(black) || ///
       rcap us us time, msize(*6) pstyle(p1) || ///
       scatter mean time, msymbol(Oh) msize(*1) mcolor(black) ///
       legend(off)  xlabel( 1 "1992" 2 "2002" 3 "2012" 4 "2019") ///
	   ylabel(0(50)350) ///
       ytitle("1,000 rupees") xtitle("") title("Loan amount (1,000 rupees)") scale(1.2) name(rel, replace)
graph export "loanamount.png", as(png) replace



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

* Share of household using it over time
ta clust_all, gen(clust)
forvalues i=1/6 {
bys HHID year: egen sclust`i'=sum(clust`i')
}
forvalues i=1/6 {
gen dclust`i'=0
} 
forvalues i=1/6 {
replace dclust`i'=1 if sclust`i'>0 & sclust`i'!=.
} 
*
keep HHID year sclust1 sclust2 sclust3 sclust4 sclust5 sclust6 dclust1 dclust2 dclust3 dclust4 dclust5 dclust6
duplicates drop
*
forvalues i=1/6 {
ta dclust`i' year, col nofreq
}

****************************************
* END









