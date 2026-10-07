*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*June 6, 2026
*-----
gl link = "indiandebt"
*Herfindahl-Hirschman index
*-----
*do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
cd"C:\Users\anatal\Documents\indiandebt"
*-------------------------





****************************************
* Level
****************************************

foreach x in caste3 religion3 sex agecat educ2 occ maritalstatus Sector {

********** Level
use"Loans_v6", clear

keep HHID year `x'  ///
amount2 clust_all
mdesc
drop if `x'==.
drop if clust_all==.

* Var for each clust
ta clust_all, gen(clust)
forvalues i=1/6 {
gen amount_clust`i'=amount2 if clust`i'==1
}

* N
bys `x' year: egen nbloan=sum(1)
*
forvalues i=1/6 {
bys `x' year: egen nbloan_clust`i'=sum(clust`i')
}

* Vol
bys `x' year: egen totalamount=sum(amount2)
*
forvalues i=1/6 {
bys `x' year: egen totalamount_clust`i'=sum(amount_clust`i')
}

* Clean
drop amount2 clust_all clust1 clust2 clust3 clust4 clust5 clust6 amount_clust1 amount_clust2 amount_clust3 amount_clust4 amount_clust5 amount_clust6
drop HHID

* 
duplicates drop
ta year

********** Herfindahl-Hirschmann index
/*
- Varie entre 1/n et 1 où n=nb cluster
- hhi faible --> le portefeuille de prêts de l'État est diversifié entre plusieurs catégories
- hhi élevé --> une ou quelques catégories dominent très fortement
*/
* 
forvalues i=1/6 {
gen share_nb_clust`i'=nbloan_clust`i'/nbloan
gen share_vol_clust`i'=totalamount_clust`i'/totalamount
}
*
gen hhi_n= ///
share_nb_clust1*share_nb_clust1+ ///
share_nb_clust2*share_nb_clust2+ ///
share_nb_clust3*share_nb_clust3+ ///
share_nb_clust4*share_nb_clust4+ ///
share_nb_clust5*share_nb_clust5+ ///
share_nb_clust6*share_nb_clust6

* HHI volume
gen hhi_vol= ///
share_vol_clust1*share_vol_clust1+ ///
share_vol_clust2*share_vol_clust2+ ///
share_vol_clust3*share_vol_clust3+ ///
share_vol_clust4*share_vol_clust4+ ///
share_vol_clust5*share_vol_clust5+ ///
share_vol_clust6*share_vol_clust6

sort year `x'

save"Loans_`x'", replace
}
****************************************
* END



















****************************************
* State level
****************************************

**********
use"Loans_v6", clear

keep State
duplicates drop
gen id=.
replace id=17 if State=="Andaman & Nicober Islands"
replace id=29 if State=="Andhra Pradesh"
replace id=9 if State=="Arunachal Pradesh"
replace id=10 if State=="Assam"
replace id=30 if State=="Bihar"
replace id=22 if State=="Chandigarh"
replace id=20 if State=="Chhattisgarh"
replace id=1 if State=="Dadra & Nagar Haveli"
replace id=1 if State=="Daman & Diu"
replace id=23 if State=="Delhi"
replace id=31 if State=="Goa"
replace id=24 if State=="Gujarat"
replace id=25 if State=="Haryana"
replace id=8 if State=="Himanchal Pradesh"
replace id=6 if State=="Jammu & Kashmir"
replace id=32 if State=="Jharkhand"
replace id=28 if State=="Karnataka"
replace id=19 if State=="Kerala"
replace id=16 if State=="Lakshadweep"
replace id=33 if State=="Madhya Pradesh"
replace id=34 if State=="Maharastra"
replace id=11 if State=="Manipur"
replace id=12 if State=="Meghalaya"
replace id=13 if State=="Mizoram"
replace id=14 if State=="Nagaland"
replace id=21 if State=="Orissa"
replace id=35 if State=="Puducherry"
replace id=26 if State=="Punjab"
replace id=36 if State=="Rajasthan"
replace id=15 if State=="Sikkim"
replace id=37 if State=="Tamil Nadu"
replace id=38 if State=="Telengana"
replace id=39 if State=="Tripura"
replace id=27 if State=="Uttar Pradesh"
replace id=40 if State=="Uttarakhand"
replace id=18 if State=="West Bengal"

save"_temp", replace


********** Level
use"Loans_v6", clear

* Merge id
merge m:1 State using "_temp"
order id, after(State)
drop _merge


keep HHID year State id ///
amount2 clust_all
mdesc
drop if clust_all==.

* Var for each clust
ta clust_all, gen(clust)
forvalues i=1/6 {
gen amount_clust`i'=amount2 if clust`i'==1
}

* N
bys State year: egen nbloan=sum(1)
*
forvalues i=1/6 {
bys State year: egen nbloan_clust`i'=sum(clust`i')
}

* Vol
bys State year: egen totalamount=sum(amount2)
*
forvalues i=1/6 {
bys State year: egen totalamount_clust`i'=sum(amount_clust`i')
}

* Clean
drop amount2 clust_all clust1 clust2 clust3 clust4 clust5 clust6 amount_clust1 amount_clust2 amount_clust3 amount_clust4 amount_clust5 amount_clust6
drop HHID

* 
duplicates drop
ta year

*save"Loans_State_v1", replace


**********Boudaries
*** Dadra & Daman together
preserve
keep if id==1
foreach x in $var {
bys year: egen `x'_n=sum(`x')
}
foreach x in $var {
drop `x'
rename `x'_n `x'
}
replace State="Dadra & Nagar Haveli & Daman & Diu"
duplicates drop
save"_temp", replace
restore
drop if State=="Dadra & Nagar Haveli"
drop if State=="Daman & Diu"
append using "_temp"
sort id year
erase "_temp.dta"

*** Telengana part of AP in 1992
preserve
keep if year==1992
keep if State=="Andhra Pradesh"
expand 2
gen n=_n
replace State="Telengana" if n==2
replace id=38 if n==2
drop if n==1
drop n
save"_temp", replace
restore
append using "_temp"
sort id year
erase "_temp.dta"

*** Telengana part of AP in 2002
preserve
keep if year==2002
keep if State=="Andhra Pradesh"
expand 2
gen n=_n
replace State="Telengana" if n==2
replace id=38 if n==2
drop if n==1
drop n
save"_temp", replace
restore
append using "_temp"
sort id year
erase "_temp.dta"


*** Chhattisgarh part of MP in 1992
preserve
keep if year==1992
keep if State=="Madhya Pradesh"
expand 2
gen n=_n
replace State="Chhattisgarh" if n==2
replace id=20 if n==2
drop if n==1
drop n
save"_temp", replace
restore
append using "_temp"
sort id year
erase "_temp.dta"


*** Jharkhand part of Bihar in 1992
preserve
keep if year==1992
keep if State=="Bihar"
expand 2
gen n=_n
replace State="Jharkhand" if n==2
replace id=32 if n==2
drop if n==1
drop n
save"_temp", replace
restore
append using "_temp"
sort id year
erase "_temp.dta"


********** Herfindahl-Hirschmann index
/*
- Varie entre 1/n et 1 où n=nb cluster
- hhi faible --> le portefeuille de prêts de l'État est diversifié entre plusieurs catégories
- hhi élevé --> une ou quelques catégories dominent très fortement
*/
* 
forvalues i=1/6 {
gen share_nb_clust`i'=nbloan_clust`i'/nbloan
gen share_vol_clust`i'=totalamount_clust`i'/totalamount
}
*
gen hhi_n= ///
share_nb_clust1*share_nb_clust1+ ///
share_nb_clust2*share_nb_clust2+ ///
share_nb_clust3*share_nb_clust3+ ///
share_nb_clust4*share_nb_clust4+ ///
share_nb_clust5*share_nb_clust5+ ///
share_nb_clust6*share_nb_clust6

* HHI volume
gen hhi_vol= ///
share_vol_clust1*share_vol_clust1+ ///
share_vol_clust2*share_vol_clust2+ ///
share_vol_clust3*share_vol_clust3+ ///
share_vol_clust4*share_vol_clust4+ ///
share_vol_clust5*share_vol_clust5+ ///
share_vol_clust6*share_vol_clust6

save"Loans_State", replace
****************************************
* END













****************************************
* Append all
****************************************
use"Loans_caste3", clear

foreach x in religion3 sex agecat educ2 occ maritalstatus Sector State {
append using "Loans_`x'"
}

*
order caste3 religion3 sex agecat educ2 occ maritalstatus Sector State id year

save"Loans_HHI", replace

foreach x in caste3 religion3 sex agecat educ2 occ maritalstatus Sector State {
erase "Loans_`x'.dta"
}
****************************************
* END















****************************************
* Graph
****************************************
use"Loans_HHI", clear

keep if State==""
drop State id
drop nbloan nbloan_clust1 nbloan_clust2 nbloan_clust3 nbloan_clust4 nbloan_clust5 nbloan_clust6 totalamount totalamount_clust1 totalamount_clust2 totalamount_clust3 totalamount_clust4 totalamount_clust5 totalamount_clust6 share_nb_clust1 share_vol_clust1 share_nb_clust2 share_vol_clust2 share_nb_clust3 share_vol_clust3 share_nb_clust4 share_vol_clust4 share_nb_clust5 share_vol_clust5 share_nb_clust6 share_vol_clust6 hhi_vol

*export excel using "HHI.xlsx", firstrow(variables) replace

/*
HHI :
Plus c'est élevé, plus c'est concentré dans certains clusters.
Plus c'est faible, plus la dette est "dispersée" dans plusieurs clusters.
*/

* Graph
set graph off
foreach x in caste3 religion3 sex agecat educ2 occ maritalstatus Sector {
graph bar hhi_n, over(`x', label(angle(90))) over(year) ///
title("`x'") ytitle("Herfindahl-Hirschmann index")
graph export "graph/hhi_`x'.png", as(png) replace
}
set graph on

****************************************
* END










****************************************
* Check
****************************************
use"Loans_HHI", clear

fre occ
keep if occ==2 | occ==4
ta year
keep if year==2012
dropmiss, force
drop share_vol_clust1 share_vol_clust2 share_vol_clust3 share_vol_clust4 share_vol_clust5 share_vol_clust6 hhi_vol
drop totalamount totalamount_clust1 totalamount_clust2 totalamount_clust3 totalamount_clust4 totalamount_clust5 totalamount_clust6

****************************************
* END

