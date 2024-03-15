*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*March 15, 2024
*-----
gl link = "marriageagri"
*Analysis NEEMSIS-2 marriage
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\marriageagri.do"
*-------------------------









***** Gifts and cost
use"NEEMSIS-marriage.dta", clear

* Husband
twoway (scatter totalmarriagegiftamount_alt marriagehusbandcost if sex==1) ///
, ///
xtitle("Total cost for the husband") ytitle("Total gift amount received") ///
title("Corr at 0.16 but at 11%") ///
name(gift_cost_male, replace)
graph export "Gift_cost_male.png", as(png) replace

* Wife
twoway (scatter totalmarriagegiftamount_alt marriagewifecost2 if sex==2) ///
, ///
xtitle("Total cost for the wife (with dowry)") ytitle("Total gift amount received") ///
title("Corr 0.37 at 1%") ///
name(gift_cost_female, replace)
graph export "Gift_cost_female.png", as(png) replace















***** Gifts and assets, income
use"NEEMSIS-marriage.dta", clear

twoway (scatter totalmarriagegiftamount_alt assets_totalnoland) ///
, ///
xtitle("Assets (no land)") ytitle("Total gift amount received") ///
title("Corr at 0.37 at 1%") ///
name(gift_assets, replace)
graph export "Gift_assets.png", as(png) replace

twoway (scatter totalmarriagegiftamount_alt annualincome_HH) ///
, ///
xtitle("Annual income") ytitle("Total gift amount received") ///
title("Corr at 0.32 at 1%") ///
name(gift_income, replace)
graph export "Gift_income.png", as(png) replace















***** Dowry and agriculture
cls
* Dowry sent
use"NEEMSIS-marriage.dta", clear
keep if sex==2

twoway ///
(kdensity marriagedowry1000 if ownland==0) ///
(kdensity marriagedowry1000 if ownland==1) ///
, ///
xtitle("Amount of dowry (Rs. 1k)") ytitle("Density") ///
title("Dowry sent by the bride's family") ///
legend(order(1 "No land" 2 "Land owner") pos(6) col(2)) ///
name(gph1, replace)


* Dowry received
use"NEEMSIS-marriage.dta", clear
keep if sex==1

twoway ///
(kdensity marriagedowry1000 if ownland==0) ///
(kdensity marriagedowry1000 if ownland==1) ///
, ///
xtitle("Amount of dowry (Rs. 1k)") ytitle("Density") ///
title("Dowry received by the groom's family") ///
legend(order(1 "No land" 2 "Land owner")) ///
name(gph2, replace)


* One graph
grc1leg gph1 gph2, name(gph_comb, replace)
graph export "Dowry_agri.png", as(png) replace











***** Dowry and assets
cls
* Dowry sent
use"NEEMSIS-marriage.dta", clear
keep if sex==2

twoway ///
(scatter assets_totalnoland marriagedowry1000) ///
, ///
ytitle("Amount of dowry (Rs. 1k)") xtitle("Assets (no land)") ///
title("Dowry sent by the bride's family" "Corr at 0.37 at 1%") ///
name(gph1, replace)


* Dowry received
use"NEEMSIS-marriage.dta", clear
keep if sex==1

twoway ///
(scatter assets_totalnoland marriagedowry1000) ///
, ///
ytitle("Amount of dowry (Rs. 1k)") xtitle("Assets (no land)") ///
title("Dowry received by the groom's family" "Corr at 0.27 at 1%") ///
name(gph2, replace)



* One graph
grc1leg gph1 gph2, name(gph_comb, replace)
graph export "Dowry_assets.png", as(png) replace







cls
********** Cost and assets
* Dowry sent
use"NEEMSIS-marriage.dta", clear
keep if sex==2

twoway ///
(scatter assets_totalnoland marriagedowry1000) ///
, ///
ytitle("Amount of dowry (Rs. 1k)") xtitle("Assets (no land)") ///
title("Dowry sent by the bride's family" "Corr at 0.37 at 1%") ///
name(gph1, replace)


* Dowry received
use"NEEMSIS-marriage.dta", clear
keep if sex==1

twoway ///
(scatter assets_totalnoland marriagedowry1000) ///
, ///
ytitle("Amount of dowry (Rs. 1k)") xtitle("Assets (no land)") ///
title("Dowry received by the groom's family" "Corr at 0.27 at 1%") ///
name(gph2, replace)



* One graph
grc1leg gph1 gph2, name(gph_comb, replace)
graph export "Dowry_assets.png", as(png) replace











cls
********** Agricultural status and dowry received
use"NEEMSIS-marriage.dta", clear

* Prepa
fre sex
keep if sex==1

* Agricultural status
foreach x in ownland divHH10 {
tabstat marriagedowry1000, stat(n mean q) by(`x') long
}

* Share agri
cpcorr marriagedowry \ incomenonagri_HH shareincomeagri_HH





















***** Dowry asked and expenses
use"panel_HH.dta", clear

* Selection
drop if marrdow_male_HH==0
drop if marrdow_male_HH==.
fre caste
ta year


* Total expenses
twoway (scatter marrdow_male_HH educexp_HH if caste==2) ///
, ///
xtitle("Education expenses") ytitle("Dowry asked") ///
title("For middle castes corr at 0.46 at 1%") ///
name(dowry_educ, replace)
graph export "Dowry_education_middle.png", as(png) replace


* Girls expenses
twoway (scatter marrdow_male_HH educexp_HH if educexp_HH!=0) ///
, ///
xtitle("Education expenses") ytitle("Dowry asked") ///
title("Female education expenses corr at 0.47 at 1%") ///
name(dowry_educ, replace)
graph export "Dowry_education_female.png", as(png) replace


pwcorr educexp_HH marrdow_male_HH, star(0.05)
pwcorr educexp_HH marrdow_male_HH if caste==1, star(0.05)
pwcorr educexp_HH marrdow_male_HH if caste==2, star(0.05)
pwcorr educexp_HH marrdow_male_HH if caste==3, star(0.05)
pwcorr educexp_HH marrdow_male_HH if educexp_HH!=0, star(0.05)

