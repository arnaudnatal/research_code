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
* State to id
****************************************
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
****************************************
* END











****************************************
* Loan level to State level by year
****************************************
use"Loans_v6", clear

* Merge id
merge m:1 State using "_temp"
order id, after(State)
drop _merge


* Selection
keep HHID year State id ///
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
* Loan level to State level
****************************************
use"Loans_v6", clear

* Merge id
merge m:1 State using "_temp"
order id, after(State)
drop _merge


* Selection
keep HHID State id ///
amount2 clust_all
mdesc
drop if clust_all==.

* Var for each clust
ta clust_all, gen(clust)
forvalues i=1/6 {
gen amount_clust`i'=amount2 if clust`i'==1
}

* Loan to State: N
bys State: egen nbloan=sum(1)
*
forvalues i=1/6 {
bys State: egen nbloan_clust`i'=sum(clust`i')
}

* Loan to State: amount
bys State: egen totalamount=sum(amount2)
*
forvalues i=1/6 {
bys State: egen totalamount_clust`i'=sum(amount_clust`i')
}

* Drop loan level var
drop amount2 clust_all clust1 clust2 clust3 clust4 clust5 clust6 amount_clust1 amount_clust2 amount_clust3 amount_clust4 amount_clust5 amount_clust6
drop HHID

* State level
duplicates drop
gen year=9999
ta year

save"Loans_State_v1_allyear", replace
****************************************
* END








****************************************
* Append both
****************************************
use"Loans_State_v1", clear

append using "Loans_State_v1_allyear"

save"Loans_State_v1_both", replace
****************************************
* END









****************************************
* Correction of State boundaries
****************************************
use"Loans_State_v1_both", clear

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
* Cat share
****************************************
use"Loans_State_v3", clear


********** NB
** Scale
forvalues i=1/6 {
replace share_nb_clust`i'=share_nb_clust`i'*100
}

* Cat1 
local v=3.3
local vminmin=`v'-10
local vmin=`v'-2.5
local vmax=`v'+2.5
local vmaxmax=`v'+10
gen catshare_nb_clust1=.
replace catshare_nb_clust1=1 if share_nb_clust1<=`vminmin'
replace catshare_nb_clust1=2 if share_nb_clust1>`vminmin' & share_nb_clust1<=`vmin'
replace catshare_nb_clust1=3 if share_nb_clust1>`vmin' & share_nb_clust1<`vmax'
replace catshare_nb_clust1=4 if share_nb_clust1>=`vmax' & share_nb_clust1<`vmaxmax'
replace catshare_nb_clust1=5 if share_nb_clust1>=`vmaxmax'

* Cat2
local v=44.48
local vminmin=`v'-10
local vmin=`v'-2.5
local vmax=`v'+2.5
local vmaxmax=`v'+10
gen catshare_nb_clust2=.
replace catshare_nb_clust2=1 if share_nb_clust2<=`vminmin'
replace catshare_nb_clust2=2 if share_nb_clust2>`vminmin' & share_nb_clust2<=`vmin'
replace catshare_nb_clust2=3 if share_nb_clust2>`vmin' & share_nb_clust2<`vmax'
replace catshare_nb_clust2=4 if share_nb_clust2>=`vmax' & share_nb_clust2<`vmaxmax'
replace catshare_nb_clust2=5 if share_nb_clust2>=`vmaxmax'

* Cat3
local v=8.15
local vminmin=`v'-10
local vmin=`v'-2.5
local vmax=`v'+2.5
local vmaxmax=`v'+10
gen catshare_nb_clust3=.
replace catshare_nb_clust3=1 if share_nb_clust3<=`vminmin'
replace catshare_nb_clust3=2 if share_nb_clust3>`vminmin' & share_nb_clust3<=`vmin'
replace catshare_nb_clust3=3 if share_nb_clust3>`vmin' & share_nb_clust3<`vmax'
replace catshare_nb_clust3=4 if share_nb_clust3>=`vmax' & share_nb_clust3<`vmaxmax'
replace catshare_nb_clust3=5 if share_nb_clust3>=`vmaxmax'

* Cat4
local v=9.49
local vminmin=`v'-10
local vmin=`v'-2.5
local vmax=`v'+2.5
local vmaxmax=`v'+10
gen catshare_nb_clust4=.
replace catshare_nb_clust4=1 if share_nb_clust4<=`vminmin'
replace catshare_nb_clust4=2 if share_nb_clust4>`vminmin' & share_nb_clust4<=`vmin'
replace catshare_nb_clust4=3 if share_nb_clust4>`vmin' & share_nb_clust4<`vmax'
replace catshare_nb_clust4=4 if share_nb_clust4>=`vmax' & share_nb_clust4<`vmaxmax'
replace catshare_nb_clust4=5 if share_nb_clust4>=`vmaxmax'

* Cat5
local v=18.58
local vminmin=`v'-10
local vmin=`v'-2.5
local vmax=`v'+2.5
local vmaxmax=`v'+10
gen catshare_nb_clust5=.
replace catshare_nb_clust5=1 if share_nb_clust5<=`vminmin'
replace catshare_nb_clust5=2 if share_nb_clust5>`vminmin' & share_nb_clust5<=`vmin'
replace catshare_nb_clust5=3 if share_nb_clust5>`vmin' & share_nb_clust5<`vmax'
replace catshare_nb_clust5=4 if share_nb_clust5>=`vmax' & share_nb_clust5<`vmaxmax'
replace catshare_nb_clust5=5 if share_nb_clust5>=`vmaxmax'

* Cat6
local v=15.99
local vminmin=`v'-10
local vmin=`v'-2.5
local vmax=`v'+2.5
local vmaxmax=`v'+10
gen catshare_nb_clust6=.
replace catshare_nb_clust6=1 if share_nb_clust6<=`vminmin'
replace catshare_nb_clust6=2 if share_nb_clust6>`vminmin' & share_nb_clust6<=`vmin'
replace catshare_nb_clust6=3 if share_nb_clust6>`vmin' & share_nb_clust6<`vmax'
replace catshare_nb_clust6=4 if share_nb_clust6>=`vmax' & share_nb_clust6<`vmaxmax'
replace catshare_nb_clust6=5 if share_nb_clust6>=`vmaxmax'

*
label define cat 1"]-inf,-10pp]" 2"]-10pp, -2.5pp]" 3"]-2.5pp, +2.5pp[" 4"[+2.5pp, +10pp[" 5"[+10pp, +inf["

label values catshare_nb_clust1 cat 
label values catshare_nb_clust2 cat 
label values catshare_nb_clust3 cat 
label values catshare_nb_clust4 cat 
label values catshare_nb_clust5 cat 
label values catshare_nb_clust6 cat 

fre catshare_nb_clust1 catshare_nb_clust2 catshare_nb_clust3 catshare_nb_clust4 catshare_nb_clust5 catshare_nb_clust6


save"Loans_State_v4", replace
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
merge 1:m id using "Loans_State_v4"
keep if _merge==3
drop _merge
*
save"Loans_State_v5", replace

****************************************
* END











****************************************
* Maps: Share of clusters by State
****************************************
use"Loans_State_v5", clear

*** Selection
*
keep if year==9999
*
keep id x_coord y_coord OBJECTID_1 OBJECTID STATE Shape_Leng Shape_Area  ///
catshare_nb_clust1 catshare_nb_clust2 catshare_nb_clust3 catshare_nb_clust4 catshare_nb_clust5 catshare_nb_clust6


 
*** % ligne (comme sur le fichier Excel)
forvalues i=1/6 {
colorpalette viridis, n(5) nograph reverse
local colors `r(p)'
*
spmap catshare_nb_clust`i' using india_coord, id(id) ///
clmethod(unique) ///
fcolor("`colors'") ///
ocolor(white ..) osize(0.05 ..)  ///
title("Cluster `i'", size(small)) ///
legstyle(2) legend(pos(5) size(2) col(5) region(fcolor(gs15)))   ///
name(g`i', replace)
}
grc1leg g1 g2 g3 g4 g5 g6, col(2) legendfrom(g6) title("Share of cluster by State") note("Note: Clust1=3.30%, Clust2=44.48%, Clust3=8.15%," "Clust4=9.49%, Clust5=18.58%, Clust6=15.99%." "Source: NSSO-AIDIS; author's calculations.", size(vsmall)) 
graph export "sharecluststate.png", as(png) replace

****************************************
* END











****************************************
* Maps: Concentration index
****************************************
use"Loans_State_v5", clear

***All year
colorpalette viridis, n(5) nograph reverse
local colors `r(p)'
*
preserve
keep if year==9999
spmap cat_hhi_n using india_coord, id(id) ///
clmethod(unique) ///
fcolor("`colors'") ///
ocolor(white ..) osize(0.05 ..)  ///
title("`y'", size(medium)) ///
legstyle(2) legend(pos(5) size(2) col(5) region(fcolor(gs15)))   ///
name(g`y', replace)
restore


*** HHI n
set graph off
foreach y in 1992 2002 2012 2019 {
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
grc1leg g1992 g2002 g2012 g2019, col(2) ///
title("Herfindahl–Hirschman index (n)") ///
note("Source: NSSO-AIDIS; author's calculations.", size(vsmall)) 
graph export "maps_hhi_n_state.png", as(png) replace



*** HHI vol
set graph off
foreach y in 1992 2002 2012 2019 {
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
grc1leg g1992 g2002 g2012 g2019, col(2) ///
title("Herfindahl–Hirschman index (vol)") ///
note("Source: NSSO-AIDIS; author's calculations.", size(vsmall)) 
graph export "maps_hhi_vol_state.png", as(png) replace



****************************************
* END





