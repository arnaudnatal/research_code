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










****************************************
* Gifts and cost
****************************************
use"NEEMSIS-marriage.dta", clear

replace totalmarriagegiftamount_alt=totalmarriagegiftamount_alt/1000
replace marriagehusbandcost=marriagehusbandcost/1000
replace marriagewifecost=marriagewifecost/1000
replace marriagewifecost2=marriagewifecost2/1000

* Husband
pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1
ta marriagehusbandcost if sex==1
twoway (scatter totalmarriagegiftamount_alt marriagehusbandcost if sex==1) , ///
xtitle("Marriage cost (INR 1k)") ytitle("Amount of gift received (INR 1k)") ///
ylabel(0(100)800) ymtick(0(50)800) ///
xlabel(0(100)500) xmtick(0(50)500) ///
title("Husband's side") note("r=0.16, pvalue<0.20" "n=110", size(vsmall)) ///
name(gift_cost_male, replace)

* Wife
pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2
ta marriagewifecost2 if sex==2
twoway (scatter totalmarriagegiftamount_alt marriagewifecost2 if sex==2) , ///
xtitle("Marriage cost (INR 1k)") ytitle("Amount of gift received (INR 1k)") ///
ylabel(0(100)800) ymtick(0(50)800) ///
xlabel(0(200)1400) xmtick(0(100)1400) ///
title("Wife's side") note("r=0.37, pvalue<0.01" "n=66", size(vsmall)) ///
name(gift_cost_female, replace)

* Comb
graph combine gift_cost_male gift_cost_female, name(gift_cost, replace)
graph export "graph/Gift_cost_sex.png", as(png) replace

****************************************
* END


















****************************************
* Gifts and assets
****************************************
use"NEEMSIS-marriage.dta", clear

replace totalmarriagegiftamount_alt=totalmarriagegiftamount_alt/1000
replace assets_total=assets_total/1000



********** Assets with land
* Total
pwcorr totalmarriagegiftamount_alt assets_total, star(.01)
tabstat assets_total, stat(n mean q p95 p99 max)
twoway (scatter totalmarriagegiftamount_alt assets_total) , ///
xtitle("Assets (INR 1k)") ytitle("Amount of gift received (INR 1k)") ///
ylabel(0(100)800) ymtick(0(50)800) ///
xlabel(0(2000)20000) xmtick(0(1000)20000) ///
note("r=0.26, pvalue<0.01" "n=416", size(vsmall)) ///
name(gift_assets, replace)
graph export "graph/Gift_asset_total.png", as(png) replace

* Husband
pwcorr totalmarriagegiftamount_alt assets_total if sex==1, star(.01)
tabstat assets_total if sex==1, stat(n mean q p95 p99 max)
twoway (scatter totalmarriagegiftamount_alt assets_total if sex==1) , ///
xtitle("Assets (INR 1k)") ytitle("Amount of gift received (INR 1k)") ///
ylabel(0(100)800) ymtick(0(50)800) ///
xlabel(0(4000)20000) xmtick(0(2000)20000) ///
title("Husband's side") note("r=0.31, pvalue<0.01" "n=222", size(vsmall)) ///
name(gift_assets_male, replace)

* Wife
pwcorr totalmarriagegiftamount_alt assets_total if sex==2, star(.2)
tabstat assets_total if sex==2, stat(n mean q p95 p99 max)
twoway (scatter totalmarriagegiftamount_alt assets_total if sex==2) , ///
xtitle("Assets (INR 1k)") ytitle("Amount of gift received (INR 1k)") ///
ylabel(0(100)800) ymtick(0(50)800) ///
xlabel(0(1000)8000) xmtick(0(500)8000) ///
title("Wife's side") note("r=0.10, pvalue<0.20" "n=194", size(vsmall)) ///
name(gift_assets_female, replace)

* Comb
graph combine gift_assets_male gift_assets_female, name(gift_assets, replace)
graph export "graph/Gift_assets_sex.png", as(png) replace





********** Assets without land
* Total
pwcorr totalmarriagegiftamount_alt assets_totalnoland1000, star(.01)
tabstat assets_totalnoland1000, stat(n mean q p95 p99 max)
twoway (scatter totalmarriagegiftamount_alt assets_totalnoland1000) , ///
xtitle("Assets without land (INR 1k)") ytitle("Amount of gift received (INR 1k)") ///
ylabel(0(100)800) ymtick(0(50)800) ///
xlabel(0(500)4000) xmtick(0(250)4000) ///
note("r=0.37, pvalue<0.01" "n=416", size(vsmall)) ///
name(gift_assets, replace)
graph export "graph/Gift_assetsnoland_total.png", as(png) replace


* Husband
pwcorr totalmarriagegiftamount_alt assets_totalnoland1000 if sex==1, star(.01)
tabstat assets_totalnoland1000 if sex==1, stat(n mean q p95 p99 max)
twoway (scatter totalmarriagegiftamount_alt assets_totalnoland1000 if sex==1) , ///
xtitle("Assets without land (INR 1k)") ytitle("Amount of gift received (INR 1k)") ///
ylabel(0(100)800) ymtick(0(50)800) ///
xlabel(0(1000)4000) xmtick(0(500)4000) ///
title("Husband's side") note("r=0.44, pvalue<0.01" "n=222", size(vsmall)) ///
name(gift_assets_male, replace)

* Wife
pwcorr totalmarriagegiftamount_alt assets_totalnoland1000 if sex==2, star(.2)
tabstat assets_totalnoland1000 if sex==2, stat(n mean q p95 p99 max)
twoway (scatter totalmarriagegiftamount_alt assets_totalnoland1000 if sex==2) , ///
xtitle("Assets without land (INR 1k)") ytitle("Amount of gift received (INR 1k)") ///
ylabel(0(100)800) ymtick(0(50)800) ///
xlabel(0(500)2000) xmtick(0(250)2000) ///
title("Wife's side") note("r=0.16, pvalue<0.01" "n=194", size(vsmall)) ///
name(gift_assets_female, replace)

* Comb
graph combine gift_assets_male gift_assets_female, name(gift_assetsnoland, replace)
graph export "graph/Gift_assetsnoland_sex.png", as(png) replace

****************************************
* END

















****************************************
* Nets gains from marriage
****************************************
use"NEEMSIS-marriage.dta", clear


* Net cost
tabstat marriagenetcost_alt1000, stat(min p1 p5 q p95 p99 max)
replace marriagenetcost_alt1000=. if marriagenetcost_alt1000<-700
replace marriagenetcost_alt1000=. if marriagenetcost_alt1000>700

twoway ///
(kdensity marriagenetcost_alt1000 if sex==1, bwidth(39) xline(0)) ///
(kdensity marriagenetcost_alt1000 if sex==2, bwidth(39)) ///
, ytitle("Density") xtitle("Net cost of marriage (INR 1k)") ///
xlabel(-800(200)800) xmtick(-800(100)800) ///
note("Kernel: Epanechnikov, bandwidth=39", size(vsmall)) ///
legend(order(1 "Husband's family" 2 "Wife's family") pos(6) col(2)) name(netcost, replace)
graph export "graph/netcost_sex.png", as(png) replace


* Net cost to income
tabstat MNCI_alt, stat(min p1 p5 q p95 p99 max)
replace MNCI_alt=. if MNCI_alt<-700
replace MNCI_alt=. if MNCI_alt>700

twoway ///
(kdensity MNCI_alt if sex==1, bwidth(29) xline(0)) ///
(kdensity MNCI_alt if sex==2, bwidth(29)) ///
, ytitle("Density") xtitle("Net cost of marriage to annual income (%)") ///
xlabel(-800(200)800) xmtick(-800(100)800) ///
note("Kernel: Epanechnikov, bandwidth=29", size(vsmall)) ///
legend(order(1 "Husband's family" 2 "Wife's family") pos(6) col(2)) name(netcostoincome, replace)
graph export "graph/netcosttoincome_sex.png", as(png) replace


****************************************
* END


















****************************************
* Dowry and agriculture
****************************************

********* Dowry sent
use"NEEMSIS-marriage.dta", clear
keep if sex==2

twoway ///
(kdensity marriagedowry1000 if ownland==0, bwidth(39)) ///
(kdensity marriagedowry1000 if ownland==1, bwidth(39)) ///
, ///
xtitle("Amount of dowry sent (INR 1k)") ytitle("Density") ///
xlabel(0(100)800) xmtick(0(50)800) ///
title("Wife's side") ///
note("Kernel: Epanechnikov, bandwidth=39", size(vsmall)) ///
legend(order(1 "No land" 2 "Land owner") pos(6) col(2)) name(gph1, replace)



********* Dowry received
use"NEEMSIS-marriage.dta", clear
keep if sex==1

twoway ///
(kdensity marriagedowry1000 if ownland==0, bwidth(49)) ///
(kdensity marriagedowry1000 if ownland==1, bwidth(49)) ///
, ///
xtitle("Amount of dowry received (INR 1k)") ytitle("Density") ///
xlabel(0(100)1000) xmtick(0(50)1000) ///
title("Husband's side") ///
note("Kernel: Epanechnikov, bandwidth=49", size(vsmall)) ///
legend(order(1 "No land" 2 "Land owner") pos(6) col(2)) name(gph2, replace)


* One graph
grc1leg gph1 gph2, name(gph_comb, replace)
graph export "graph/Dowry_agri.png", as(png) replace



********** Dowry to income sent
use"NEEMSIS-marriage.dta", clear
keep if sex==2

tabstat DAIR, stat(min q max)

*
twoway ///
(kdensity DAIR if ownland==0 & DAIR<800, bwidth(39)) ///
(kdensity DAIR if ownland==1 & DAIR<800, bwidth(39)) ///
, ///
xtitle("Dowry to income (%)") ytitle("Density") ///
xlabel(0(100)800) xmtick(0(50)800) ///
title("Dowry paid by wives' families") ///
note("Kernel: Epanechnikov, bandwidth=39", size(vsmall)) ///
legend(order(1 "No land" 2 "Land owner") pos(6) col(2)) name(dti, replace)
graph export "graph/Dowry_income.png", as(png) replace

****************************************
* END
















****************************************
* Cost and agriculture
****************************************

********* Husband cost
use"NEEMSIS-marriage.dta", clear
keep if sex==1
replace marriagehusbandcost=marriagehusbandcost/1000

twoway ///
(kdensity marriagehusbandcost if ownland==0, bwidth(49)) ///
(kdensity marriagehusbandcost if ownland==1, bwidth(49)) ///
, ///
xtitle("Marriage cost (INR 1k)") ytitle("Density") ///
xlabel(0(100)600) xmtick(0(50)600) ///
title("Husband's side") ///
note("Kernel: Epanechnikov, bandwidth=49", size(vsmall)) ///
legend(order(1 "No land" 2 "Land owner") pos(6) col(2)) name(gph1, replace)



********* Wife cost
use"NEEMSIS-marriage.dta", clear
keep if sex==2
replace marriagewifecost2=marriagewifecost2/1000

twoway ///
(kdensity marriagewifecost2 if ownland==0, bwidth(69)) ///
(kdensity marriagewifecost2 if ownland==1, bwidth(69)) ///
, ///
xtitle("Marriage cost (INR 1k)") ytitle("Density") ///
xlabel(0(200)1400) xmtick(0(100)1000) ///
title("Wife's side") ///
note("Kernel: Epanechnikov, bandwidth=69", size(vsmall)) ///
legend(order(1 "No land" 2 "Land owner") pos(6) col(2)) name(gph2, replace)


* One graph
grc1leg gph1 gph2, name(gph_comb, replace)
graph export "graph/Cost_agri.png", as(png) replace

****************************************
* END













****************************************
* Dowry and assets
****************************************

********** Dowry sent
use"NEEMSIS-marriage.dta", clear
keep if sex==2
replace assets_totalnoland=assets_totalnoland/1000
pwcorr assets_totalnoland marriagedowry1000, star(.05)
tabstat assets_totalnoland marriagedowry1000, stat(n)

twoway ///
(scatter marriagedowry1000 assets_totalnoland) ///
, ///
ytitle("Amount of dowry sent (INR 1k)") xtitle("Assets without land (INR 1k)") ///
xlabel(0(500)2000) xmtick(0(250)2000) ///
ylabel(0(100)800) ymtick(0(50)800) ///
title("Wife's side") note("r=0.37, pvalue<0.01" "n=194", size(vsmall)) ///
legend(off) name(gph1, replace)


********** Dowry received
use"NEEMSIS-marriage.dta", clear
keep if sex==1
replace assets_totalnoland=assets_totalnoland/1000
pwcorr assets_totalnoland marriagedowry1000, star(.05)
tabstat assets_totalnoland marriagedowry1000, stat(n)

twoway ///
(scatter marriagedowry1000 assets_totalnoland) ///
, ///
ytitle("Amount of dowry received (INR 1k)") xtitle("Assets without land (INR 1k)") ///
xlabel(0(1000)4000) xmtick(0(500)4000) ///
ylabel(0(100)1000) ymtick(0(50)1000) ///
title("Husband's side") note("r=0.27, pvalue<0.01" "n=222", size(vsmall)) ///
legend(off) name(gph2, replace)



* One graph
graph combine gph1 gph2, name(gph_comb, replace)
graph export "graph/Dowry_assets_sex.png", as(png) replace

****************************************
* END
























****************************************
* Dowry asked and education expenses
****************************************
use"panel_HH.dta", clear

* Selection
drop if year==2010
drop if dummymarriage_male==0

replace educexp_HH=educexp_HH/1000
replace educexp_male_HH=educexp_male_HH/1000
replace educexp_female_HH=educexp_female_HH/1000
replace marrdow_male_HH=marrdow_male_HH/1000
fre caste


* Total expenses
pwcorr marrdow_male_HH educexp_HH, star(0.1)
tabstat marrdow_male_HH educexp_HH, stat(n)
twoway (scatter marrdow_male_HH educexp_HH) ///
, ///
xtitle("Education expenses (INR 1k)") ytitle("Amount of dowry received (INR 1k)") ///
title("Education of boys and girls") ///
xlabel(0(10)80) xmtick(0(5)80) ///
ylabel(0(100)1000) ymtick(0(50)1000) ///
note("r=0.13, pvalue<0.01" "n=193", size(vsmall)) ///
legend(off) name(gph1, replace)


* Male expenses
pwcorr marrdow_male_HH educexp_male_HH, star(0.7)
tabstat marrdow_male_HH educexp_male_HH, stat(n)
twoway (scatter marrdow_male_HH educexp_male_HH) ///
, ///
xtitle("Education expenses (INR 1k)") ytitle("Amount of dowry received (INR 1k)") ///
title("Boy's education") ///
xlabel(0(10)80) xmtick(0(5)80) ///
ylabel(0(100)1000) ymtick(0(50)1000) ///
note("r=0.02, pvalue<0.80" "n=193", size(vsmall)) ///
legend(off) name(gph2, replace)


* Female expenses
pwcorr marrdow_male_HH educexp_female_HH, star(0.01)
tabstat marrdow_male_HH educexp_female_HH, stat(n)
twoway (scatter marrdow_male_HH educexp_female_HH) ///
, ///
xtitle("Education expenses (INR 1k)") ytitle("Amount of dowry received (INR 1k)") ///
title("Girl's education") ///
xlabel(0(10)50) xmtick(0(5)50) ///
ylabel(0(100)1000) ymtick(0(50)1000) ///
note("r=0.22, pvalue<0.01" "n=193", size(vsmall)) ///
legend(off) name(gph3, replace)


* Combine
graph combine gph1 gph2 gph3, name(dowryeduc, replace) col(3)
graph export "graph/Dowry_educ.png", as(png) replace



********** By caste
cls
pwcorr marrdow_male_HH educexp_HH educexp_male_HH educexp_female_HH if caste==1, star(0.01)
pwcorr marrdow_male_HH educexp_HH educexp_male_HH educexp_female_HH if caste==2, star(0.01)
pwcorr marrdow_male_HH educexp_HH educexp_male_HH educexp_female_HH if caste==3, star(0.01)



****************************************
* END























****************************************
* Dowry asked and education expenses 2
****************************************
use"panel_HH.dta", clear

* Selection
drop if year==2010
drop if dummymarriage_male==0

replace educexp_HH=educexp_HH/1000
replace educexp_male_HH=educexp_male_HH/1000
replace educexp_female_HH=educexp_female_HH/1000
replace marrdow_male_HH=marrdow_male_HH/1000
fre caste


* Total expenses
pwcorr marrdow_male_HH educexp_HH if educexp_HH!=0, star(0.05)
tabstat marrdow_male_HH educexp_HH if educexp_HH!=0, stat(n)
twoway (scatter marrdow_male_HH educexp_HH if educexp_HH!=0) ///
, ///
xtitle("Education expenses (INR 1k)") ytitle("Amount of dowry received (INR 1k)") ///
title("Education of boys and girls") ///
xlabel(0(10)80) xmtick(0(5)80) ///
ylabel(0(100)800) ymtick(0(50)800) ///
note("r=0.25, pvalue<0.05" "n=71", size(vsmall)) ///
legend(off) name(gph1, replace)


* Male expenses
pwcorr marrdow_male_HH educexp_male_HH if educexp_male_HH!=0,star(0.3)
tabstat marrdow_male_HH educexp_male_HH if educexp_male_HH!=0, stat(n)
twoway (scatter marrdow_male_HH educexp_male_HH if educexp_male_HH!=0) ///
, ///
xtitle("Education expenses (INR 1k)") ytitle("Amount of dowry received (INR 1k)") ///
title("Boy's education") ///
xlabel(0(10)80) xmtick(0(5)80) ///
ylabel(0(100)600) ymtick(0(50)600) ///
note("r=0.16, pvalue<0.30" "n=54", size(vsmall)) ///
legend(off) name(gph2, replace)


* Female expenses
pwcorr marrdow_male_HH educexp_female_HH if educexp_female_HH!=0, star(0.01)
tabstat marrdow_male_HH educexp_female_HH if educexp_female_HH!=0, stat(n)
twoway (scatter marrdow_male_HH educexp_female_HH if educexp_female_HH!=0) ///
, ///
xtitle("Education expenses (INR 1k)") ytitle("Amount of dowry received (INR 1k)") ///
title("Girl's education") ///
xlabel(0(10)50) xmtick(0(5)50) ///
ylabel(0(100)800) ymtick(0(50)800) ///
note("r=0.47, pvalue<0.01" "n=3", size(vsmall)) ///
legend(off) name(gph3, replace)


* Combine
graph combine gph1 gph2 gph3, name(dowryeduc, replace) col(3)
graph export "graph/Dowry_educ2.png", as(png) replace



********** By caste
cls
pwcorr marrdow_male_HH educexp_HH educexp_male_HH educexp_female_HH if caste==1, star(0.01)
pwcorr marrdow_male_HH educexp_HH educexp_male_HH educexp_female_HH if caste==2, star(0.01)
pwcorr marrdow_male_HH educexp_HH educexp_male_HH educexp_female_HH if caste==3, star(0.01)



****************************************
* END



