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

foreach x in educexp_HH educexp_male_HH educexp_female_HH {
replace `x'=. if `x'==0
}

tabstat educexp_HH educexp_male_HH educexp_female_HH, stat(n mean p50)

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
note("r=0.47, pvalue<0.01" "n=33", size(vsmall)) ///
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
















****************************************
* Education expenses 
****************************************
cls
use"panel_HH.dta", clear

* Selection
drop if year==2010
recode educexp_male_HH educexp_female_HH (0=.)
replace educexp_male_HH=educexp_male_HH/1000
replace educexp_female_HH=educexp_female_HH/1000

* Format
collapse (mean) dumeducexp_male_HH dumeducexp_female_HH educexp_male_HH educexp_female_HH, by(caste time)

rename dumeducexp_male_HH dumeducexp1
rename dumeducexp_female_HH dumeducexp2
rename educexp_male_HH educexp1
rename educexp_female_HH educexp2

reshape long dumeducexp educexp, i(caste time) j(sex)
label define sex 1"Males" 2"Females"
label values sex sex

replace dumeducexp=dumeducexp*100

* Share
graph bar (mean) dumeducexp, over(time) over(sex) over(caste) ///
ytitle("Percent") ylabel(0(10)60) ymtick(0(5)60) ///
title("Share of households investing in education") ///
legend(pos(6) col(2)) name(share, replace)

* Amount invested
graph bar (mean) educexp, over(time) over(sex) over(caste) ///
ytitle("INR 1k") ylabel(0(2)22) ymtick(0(1)22) ///
title("Average amount invested in education last year") ///
legend(pos(6) col(2)) name(amount, replace)

* Comb
grc1leg share amount, name(comb, replace)
graph export "graph/Education_expenses.png", as(png) replace

****************************************
* END











****************************************
* Education level
****************************************
cls
use"panel_indiv_v0", clear

*** Initialization
keep if age>=25
ta sex year
keep HHID_panel INDID_panel year sex caste age educ_attainment2
gen time=.
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time
order time, after(year)

cls
*** Education KILM
ta educ_attainment2 year, col nofreq
ta educ_attainment2 year if sex==1, col nofreq
ta educ_attainment2 year if sex==2, col nofreq
ta educ_attainment2 year if caste==1, col nofreq
ta educ_attainment2 year if caste==2, col nofreq
ta educ_attainment2 year if caste==3, col nofreq


*** Graphs
* Global
catplot educ_attainment2 time, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs14)) bar(3, color(gs7))  bar(4, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("Total") ///
legend(pos(6) col(4)) name(tot, replace)



*****  Caste
set graph off
* Dalits
catplot educ_attainment2 time if caste==1, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs14)) bar(3, color(gs7))  bar(4, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("Dalits") ///
legend(pos(6) col(4)) name(dal, replace)

* Middle castes
catplot educ_attainment2 time if caste==2, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs14)) bar(3, color(gs7))  bar(4, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("Middle castes") ///
legend(pos(6) col(4)) name(mid, replace)

* Upper castes
catplot educ_attainment2 time if caste==3, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs14)) bar(3, color(gs7))  bar(4, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("Upper castes") ///
legend(pos(6) col(4)) name(upp, replace)



*****  Sex
* Males
catplot educ_attainment2 time if sex==1, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs14)) bar(3, color(gs7))  bar(4, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("Males") ///
legend(pos(6) col(4)) name(mal, replace)

* Females
catplot educ_attainment2 time if sex==2, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs14)) bar(3, color(gs7))  bar(4, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("Females") ///
legend(pos(6) col(4)) name(fem, replace)



***** Combine
set graph on
grc1leg tot mal fem dal mid upp, col(3) name(comb, replace)
graph export "graph/Education_level.png", as(png) replace

****************************************
* END














****************************************
* Land by caste
****************************************
cls
use"panel_HH.dta", clear

* Caste and jatis
ta jatis caste
clonevar jatis_str=jatis
encode jatis, gen(jatis_enc)
drop jatis
rename jatis_enc jatis

* Acre to hectar
replace assets_sizeownland=assets_sizeownland*0.404686
tabstat assets_sizeownland, stat(n mean) by(year)

* Collapse
gen n=1
collapse (sum) sizeownland n ownland (mean) assets_sizeownland, by(year jatis)

* Size by jatis and average size
bysort year: egen total_land=sum(sizeownland)
bysort year: egen total_n=sum(n)
bysort year: egen total_ownland=sum(ownland)
gen share_land=sizeownland*100/total_land
gen share_own=ownland*100/total_ownland
drop if ownland==0

* Graph share total land
ta share_land
graph bar (mean) share_land, over(year, lab(nolab)) over(jatis, lab(angle(45))) asyvars ///
bar(1, fcolor(gs0)) bar(2, fcolor(gs7)) bar(3, fcolor(gs14)) ///
ytitle("Percent") ylabel(0(10)60) ymtick(0(5)60) ///
title("Share of total land area held by each jati") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) name(area, replace)

* Graph average size
ta assets_sizeownland
graph bar (mean) assets_sizeownland, over(year, lab(nolab)) over(jatis, lab(angle(45))) asyvars ///
bar(1, fcolor(gs0)) bar(2, fcolor(gs7)) bar(3, fcolor(gs14)) ///
ytitle("Hectar") ylabel(0(0.5)3.5) ymtick(0(.25)3.5) ///
title("Average area of land held by each jati") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) name(average, replace)

* Comb
grc1leg area average, name(com, replace) col(2)
graph export "graph/land_jatis.png", as(png) replace

****************************************
* END
























****************************************
* Non-agricultural income
****************************************
cls
use"panel_HH.dta", clear


* Global
catplot divHH10 time, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("Total") ///
legend(pos(6) col(3)) name(tot, replace)


*****  Caste
set graph off
* Dalits
catplot divHH10 time if caste==1, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("Dalits") ///
legend(pos(6) col(3)) name(dal, replace)

* Middle
catplot divHH10 time if caste==2, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("Middle castes") ///
legend(pos(6) col(3)) name(mid, replace)

* Uppers
catplot divHH10 time if caste==3, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("Upper castes") ///
legend(pos(6) col(3)) name(upp, replace)

* Combine
set graph on
grc1leg tot dal mid upp, name(comb_caste, replace)
graph export "graph/diversification_caste.png", as(png) replace



***** Income
set graph off
* T1
catplot divHH10 time if income_q==1, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("T1 of income") ///
legend(pos(6) col(3)) name(inc1, replace)

* T2
catplot divHH10 time if income_q==2, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("T2 of income") ///
legend(pos(6) col(3)) name(inc2, replace)

* T3
catplot divHH10 time if income_q==3, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("T3 of income") ///
legend(pos(6) col(3)) name(inc3, replace)

* Combine
set graph on
grc1leg tot inc1 inc2 inc3, name(comb_inc, replace)
graph export "graph/diversification_income.png", as(png) replace




***** Assets
set graph off
* T1
catplot divHH10 time if assets_q==1, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("T1 of assets") ///
legend(pos(6) col(3)) name(ass1, replace)

* T2
catplot divHH10 time if assets_q==2, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("T2 of assets") ///
legend(pos(6) col(3)) name(ass2, replace)

* T3
catplot divHH10 time if assets_q==3, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("T3 of assets") ///
legend(pos(6) col(3)) name(ass3, replace)

* Combine
set graph on
grc1leg tot ass1 ass2 ass3, name(comb_ass, replace)
graph export "graph/diversification_assets.png", as(png) replace




********** Increasing share of non-agricultural income 2

***** Caste
use"panel_HH.dta", clear

collapse (mean) annualincome_HH incomenonagri_HH incomeagri_HH shareincomenonagri_HH shareincomeagri_HH, by(caste year)
replace incomenonagri_HH=incomenonagri_HH/10000

twoway ///
(line shareincomenonagri_HH year if caste==1) ///
(line shareincomenonagri_HH year if caste==2) ///
(line shareincomenonagri_HH year if caste==3) ///
, ytitle("Average share of non-agricultural income (%)") ylabel(.3(.1).9) ///
xtitle("") xlabel(2010 2016 2020) ///
title("By caste") ///
legend(order(1 "Dalits" 2 "Middle" 3 "Upper") pos(6) col(3)) name(line_caste, replace)

twoway ///
(line incomenonagri_HH year if caste==1) ///
(line incomenonagri_HH year if caste==2) ///
(line incomenonagri_HH year if caste==3) ///
, ytitle("Non-agricultural income (INR 10k)") ylabel(0(2)16) ///
xtitle("") xlabel(2010 2016 2020) ///
title("By caste") ///
legend(order(1 "Dalits" 2 "Middle" 3 "Upper") pos(6) col(3)) name(line_caste2, replace)




***** Income
use"panel_HH.dta", clear

collapse (mean) annualincome_HH incomenonagri_HH incomeagri_HH shareincomenonagri_HH shareincomeagri_HH, by(income_q year)
replace incomenonagri_HH=incomenonagri_HH/10000

twoway ///
(line shareincomenonagri_HH year if income_q==1) ///
(line shareincomenonagri_HH year if income_q==2) ///
(line shareincomenonagri_HH year if income_q==3) ///
, ytitle("Average share of non-agricultural income (%)") ylabel(.3(.1).9) ///
xtitle("") xlabel(2010 2016 2020) ///
title("By income") ///
legend(order(1 "Terc.1" 2 "Terc.2" 3 "Terc.3") pos(6) col(3)) name(line_income, replace)

twoway ///
(line incomenonagri_HH year if income_q==1) ///
(line incomenonagri_HH year if income_q==2) ///
(line incomenonagri_HH year if income_q==3) ///
, ytitle("Non-agricultural income (INR 10k)") ylabel(0(2)16) ///
xtitle("") xlabel(2010 2016 2020) ///
title("By income") ///
legend(order(1 "Terc.1" 2 "Terc.2" 3 "Terc.3") pos(6) col(3)) name(line_income2, replace)


***** Assets
use"panel_HH.dta", clear

collapse (mean) annualincome_HH incomenonagri_HH incomeagri_HH shareincomenonagri_HH shareincomeagri_HH, by(assets_q year)
replace incomenonagri_HH=incomenonagri_HH/10000

twoway ///
(line shareincomenonagri_HH year if assets_q==1) ///
(line shareincomenonagri_HH year if assets_q==2) ///
(line shareincomenonagri_HH year if assets_q==3) ///
, ytitle("Average share of non-agricultural income (%)") ylabel(.3(.1).9) ///
xtitle("") xlabel(2010 2016 2020) ///
title("By assets") ///
legend(order(1 "Terc.1" 2 "Terc.2" 3 "Terc.3") pos(6) col(3)) name(line_assets, replace)

twoway ///
(line incomenonagri_HH year if assets_q==1) ///
(line incomenonagri_HH year if assets_q==2) ///
(line incomenonagri_HH year if assets_q==3) ///
, ytitle("Non-agricultural income (INR 10k)") ylabel(0(2)16) ///
xtitle("") xlabel(2010 2016 2020) ///
title("By assets") ///
legend(order(1 "Terc.1" 2 "Terc.2" 3 "Terc.3") pos(6) col(3)) name(line_assets2, replace)

***** Comb
graph combine line_caste line_income line_assets, col(3) name(line_comb, replace)
graph export "graph/average_share_diversi.png", as(png) replace

graph combine line_caste2 line_income2 line_assets2, col(3) name(line_comb2, replace)
graph export "graph/average_amount_diversi.png", as(png) replace


****************************************
* END


