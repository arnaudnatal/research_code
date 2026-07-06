*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*June 6, 2026
*-----
gl link = "indiandebt"
*MCA
*-----
*do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
cd"C:\Users\anatal\Documents\id"
*-------------------------




****************************************
* Loan level to HH level
****************************************
use"Loans_v6", clear

* Selection
keep HHID year Sector State District Weight caste3 religion3 HHsize age agecat sex maritalstatus educ2 occ ///
amount2 clust_all
mdesc
drop if clust_all==.

* Var for each clust
ta clust_all, gen(clust)
forvalues i=1/6 {
gen amount_clust`i'=amount2 if clust`i'==1
}

* Loan to HH: N
bys HHID year: egen nbloan=sum(1)
*
forvalues i=1/6 {
bys HHID year: egen nbloan_clust`i'=sum(clust`i')
}

* Loan to HH: amount
bys HHID year: egen totalamount=sum(amount2)
*
forvalues i=1/6 {
bys HHID year: egen totalamount_clust`i'=sum(amount_clust`i')
}

* Drop loan level var
drop amount2 clust_all clust1 clust2 clust3 clust4 clust5 clust6 amount_clust1 amount_clust2 amount_clust3 amount_clust4 amount_clust5 amount_clust6

* HH level
duplicates drop
ta year

save"Loans_HH_v1", replace
****************************************
* END











****************************************
* New var at HH level
****************************************
use"Loans_HH_v1", clear

* Share of nb and volume
forvalues i=1/6 {
gen share_nb_clust`i'=nbloan_clust`i'/nbloan
gen share_vol_clust`i'=totalamount_clust`i'/totalamount
}

* Check
egen _test1=rowtotal(share_nb_clust1 share_nb_clust2 share_nb_clust3 share_nb_clust4 share_nb_clust5 share_nb_clust6)
ta _test1
drop _test1
egen _test2=rowtotal(share_vol_clust1 share_vol_clust2 share_vol_clust3 share_vol_clust4 share_vol_clust5 share_vol_clust6)
ta _test2
drop if _test2==0
drop _test2


save"Loans_HH_v2", replace
****************************************
* END



















****************************************
* Loan level to State level
****************************************
use"Loans_v6", clear

* Selection
keep HHID year id State ///
amount2 clust_all
mdesc
drop if clust_all==.

* Var for each clust
ta clust_all, gen(clust)
forvalues i=1/6 {
gen amount_clust`i'=amount2 if clust`i'==1
}

* Loan to State: N
bys State year: egen nbloan=sum(1)
*
forvalues i=1/6 {
bys State year: egen nbloan_clust`i'=sum(clust`i')
}

* Loan to State: amount
bys State year: egen totalamount=sum(amount2)
*
forvalues i=1/6 {
bys State year: egen totalamount_clust`i'=sum(amount_clust`i')
}

* Drop loan level var
drop amount2 clust_all clust1 clust2 clust3 clust4 clust5 clust6 amount_clust1 amount_clust2 amount_clust3 amount_clust4 amount_clust5 amount_clust6
drop HHID

* State level
duplicates drop
ta year

save"Loans_State_v1", replace
****************************************
* END










****************************************
* Correction of State boundaries
****************************************
use"Loans_State_v1", clear

list id State, clean noobs

global var nbloan nbloan_clust1 nbloan_clust2 nbloan_clust3 nbloan_clust4 nbloan_clust5 nbloan_clust6 totalamount totalamount_clust1 totalamount_clust2 totalamount_clust3 totalamount_clust4 totalamount_clust5 totalamount_clust6


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


save"Loans_State_v2", replace
****************************************
* END











****************************************
* Variables supp
****************************************
use"Loans_State_v2", clear


* Share of nb and volume
forvalues i=1/6 {
gen share_nb_clust`i'=nbloan_clust`i'/nbloan
gen share_vol_clust`i'=totalamount_clust`i'/totalamount
}

* Check
egen _test1=rowtotal(share_nb_clust1 share_nb_clust2 share_nb_clust3 share_nb_clust4 share_nb_clust5 share_nb_clust6)
ta _test1
drop _test1
egen _test2=rowtotal(share_vol_clust1 share_vol_clust2 share_vol_clust3 share_vol_clust4 share_vol_clust5 share_vol_clust6)
ta _test2
drop if _test2==0
drop _test2

* Herfindahl-Hirschmann index
/*
- Varie entre 1/n et 1 où n=nb cluster
- hhi faible --> le portefeuille de prêts de l'État est diversifié entre plusieurs catégories
- hhi élevé --> une ou quelques catégories dominent très fortement
*/
gen hhi_n= ///
share_nb_clust1*share_nb_clust1+ ///
share_nb_clust2*share_nb_clust2+ ///
share_nb_clust3*share_nb_clust3+ ///
share_nb_clust4*share_nb_clust4+ ///
share_nb_clust5*share_nb_clust5+ ///
share_nb_clust6*share_nb_clust6

xtile cat_hhi_n=hhi_n, n(5)
tabstat hhi_n, stat(mean) by(cat_hhi_n)
label define cat_hhi_n 1"Quintile 1" 2"Quintile 2" 3"Quintile 3" 4"Quintile 4" 5"Quintile 5"
label values cat_hhi_n cat_hhi_n

* HHI volume
gen hhi_vol= ///
share_vol_clust1*share_vol_clust1+ ///
share_vol_clust2*share_vol_clust2+ ///
share_vol_clust3*share_vol_clust3+ ///
share_vol_clust4*share_vol_clust4+ ///
share_vol_clust5*share_vol_clust5+ ///
share_vol_clust6*share_vol_clust6

xtile cat_hhi_vol=hhi_vol, n(5)
tabstat hhi_vol, stat(mean) by(cat_hhi_vol)
label define cat_hhi_vol 1"Quintile 1" 2"Quintile 2" 3"Quintile 3" 4"Quintile 4" 5"Quintile 5"
label values cat_hhi_vol cat_hhi_vol

corr hhi_n hhi_vol
twoway (scatter hhi_n hhi_vol)

save"Loans_State_v3", replace
****************************************
* END











****************************************
* Creation
****************************************
/*
********** Shape file to dta
shp2dta using "shapefile/STATE_BOUNDARY.shp", database(india_state) coordinates(india_coord) gencentroids(coord) genid(id) replace 
*/

********** Polygons and data in the same dataset
use"india_state", clear
*
merge 1:m id using "Loans_State_v3"
keep if _merge==3
drop _merge
*
save"Loans_State_v4", replace

****************************************
* END








****************************************
* Maps
****************************************
use"Loans_State_v4", clear


*** HHI n
set graph off
foreach y in 1992 2002 2012 2018 {
preserve
keep if year==`y'
colorpalette viridis, n(5) nograph reverse
local colors `r(p)'
*
spmap cat_hhi_n using india_coord, id(id) ///
clmethod(unique) ///
fcolor("`colors'") ///
ocolor(white ..) osize(0.05 ..)  ///
title("`y'", size(medium)) ///
legstyle(2) legend(pos(5) size(2) col(5) region(fcolor(gs15)))   ///
name(g`y', replace)
restore
}
set graph on
*
grc1leg g1992 g2002 g2012 g2018, col(2) ///
title("Herfindahl–Hirschman index (n)") ///
note("Source: NSSO-AIDIS; author's calculations.", size(vsmall)) 
graph export "maps_hhi_n_state.png", as(png) replace



*** HHI n
set graph off
foreach y in 1992 2002 2012 2018 {
preserve
keep if year==`y'
colorpalette viridis, n(5) nograph reverse
local colors `r(p)'
*
spmap cat_hhi_vol using india_coord, id(id) ///
clmethod(unique) ///
fcolor("`colors'") ///
ocolor(white ..) osize(0.05 ..)  ///
title("`y'", size(medium)) ///
legstyle(2) legend(pos(5) size(2) col(5) region(fcolor(gs15)))   ///
name(g`y', replace)
restore
}
set graph on
*
grc1leg g1992 g2002 g2012 g2018, col(2) ///
title("Herfindahl–Hirschman index (vol)") ///
note("Source: NSSO-AIDIS; author's calculations.", size(vsmall)) 
graph export "maps_hhi_vol_state.png", as(png) replace



****************************************
* END





