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
twoway (scatter totalmarriagegiftamount_alt assets_total, mcolor(gs4%50)) , ///
xtitle("Assets (INR 1k)") ytitle("Amount of gift received (INR 1k)") ///
ylabel(0(100)800) ymtick(0(50)800) ///
xlabel(0(2000)20000) xmtick(0(1000)20000) ///
note("r=0.26, pvalue<0.01" "n=416", size(vsmall)) ///
name(gift_assets, replace)
graph export "graph/Gift_asset_total.png", as(png) replace

* Husband
pwcorr totalmarriagegiftamount_alt assets_total if sex==1, star(.01)
tabstat assets_total if sex==1, stat(n mean q p95 p99 max)
twoway (scatter totalmarriagegiftamount_alt assets_total if sex==1, mcolor(gs4%50)) , ///
xtitle("Assets (INR 1k)") ytitle("Amount of gift received (INR 1k)") ///
ylabel(0(100)800) ymtick(0(50)800) ///
xlabel(0(4000)20000) xmtick(0(2000)20000) ///
title("Husband's side") note("r=0.31, pvalue<0.01" "n=222", size(vsmall)) ///
name(gift_assets_male, replace)

* Wife
pwcorr totalmarriagegiftamount_alt assets_total if sex==2, star(.2)
tabstat assets_total if sex==2, stat(n mean q p95 p99 max)
twoway (scatter totalmarriagegiftamount_alt assets_total if sex==2, mcolor(gs4%50)) , ///
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
twoway (scatter totalmarriagegiftamount_alt assets_totalnoland1000, mcolor(gs4%50)) , ///
xtitle("Assets without land (INR 1k)") ytitle("Amount of gift received (INR 1k)") ///
ylabel(0(100)800) ymtick(0(50)800) ///
xlabel(0(500)4000) xmtick(0(250)4000) ///
note("r=0.37, pvalue<0.01" "n=416", size(vsmall)) ///
name(gift_assets, replace)
graph export "graph/Gift_assetsnoland_total.png", as(png) replace


* Husband
pwcorr totalmarriagegiftamount_alt assets_totalnoland1000 if sex==1, star(.01)
tabstat assets_totalnoland1000 if sex==1, stat(n mean q p95 p99 max)
twoway (scatter totalmarriagegiftamount_alt assets_totalnoland1000 if sex==1, mcolor(gs4%50)) , ///
xtitle("Assets without land (INR 1k)") ytitle("Amount of gift received (INR 1k)") ///
ylabel(0(100)800) ymtick(0(50)800) ///
xlabel(0(1000)4000) xmtick(0(500)4000) ///
title("Husband's side") note("r=0.44, pvalue<0.01" "n=222", size(vsmall)) ///
name(gift_assets_male, replace)

* Wife
pwcorr totalmarriagegiftamount_alt assets_totalnoland1000 if sex==2, star(.2)
tabstat assets_totalnoland1000 if sex==2, stat(n mean q p95 p99 max)
twoway (scatter totalmarriagegiftamount_alt assets_totalnoland1000 if sex==2, mcolor(gs4%50)) , ///
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
* Gifts and assets
****************************************
use"NEEMSIS-marriage.dta", clear

replace totalmarriagegiftamount_alt=totalmarriagegiftamount_alt/1000

tabstat totalmarriagegiftamount_alt, stat(n mean) by(educ_attainment2)

reg totalmarriagegiftamount_alt i.educ_attainment2 i.sex
reg totalmarriagegiftamount_alt i.educ_attainment2 if sex==1
reg totalmarriagegiftamount_alt i.educ_attainment2 if sex==2

***** Rename
rename totalmarriagegiftamount_alt total

fre assets_q

***** By categories
gen totalq1=total if assets_q==1
gen totalq2=total if assets_q==2
gen totalq3=total if assets_q==3



***** Macro for formatting database
global var total totalq1 totalq2 totalq3
local i=1
foreach x in $var {
preserve
rename `x' cost
keep cost
collapse (mean) m_cost=cost (sd) sd_cost=cost (count) n_cost=cost
gen sample=`i'
order sample
* M
gen max_cost=m_cost+invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
gen min_cost=m_cost-invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
save"_temp`i'", replace
restore
local i=`i'+1
}

***** Append
use "_temp1", clear

forvalues i=2/4 {
append using "_temp`i'"
}

label define sample 1"Total" 2"Terc. 1" 3"Terc. 2" 4"Terc. 3"
label values sample sample

***** Graph
twoway ///
(bar m_cost sample, barwidth(.8)) ///
(rspike max_cost min_cost sample) ///
, ylabel(0(10)150) ymtick(0(5)150) ///
xlabel(1/4,valuelabel angle(45)) ///
ytitle("INR 1k") xtitle("") ///
title("By tercile of assets") ///
legend(off) /// 
name(gphassets, replace)
graph export "graph/Gifts_assets.png", as(png) replace


****************************************
* END














****************************************
* Gifts and educ
****************************************
use"NEEMSIS-marriage.dta", clear

replace totalmarriagegiftamount_alt=totalmarriagegiftamount_alt/1000

tabstat totalmarriagegiftamount_alt, stat(n mean) by(educ_attainment2)

reg totalmarriagegiftamount_alt i.educ_attainment2 i.sex
reg totalmarriagegiftamount_alt i.educ_attainment2 if sex==1
reg totalmarriagegiftamount_alt i.educ_attainment2 if sex==2

***** Rename
rename totalmarriagegiftamount_alt total

fre educ_attainment2

***** By categories
gen total1=total if educ_attainment2==0
gen total2=total if educ_attainment2==2
gen total3=total if educ_attainment2==3
gen total4=total if educ_attainment2==4



***** Macro for formatting database
global var total total1 total2 total3 total4
local i=1
foreach x in $var {
preserve
rename `x' cost
keep cost
collapse (mean) m_cost=cost (sd) sd_cost=cost (count) n_cost=cost
gen sample=`i'
order sample
* M
gen max_cost=m_cost+invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
gen min_cost=m_cost-invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
save"_temp`i'", replace
restore
local i=`i'+1
}

***** Append
use "_temp1", clear

forvalues i=2/5 {
append using "_temp`i'"
}

label define sample 1"Total" 2"No educ" 3"Primary" 4"Second" 5"Tertiary"
label values sample sample

***** Graph
twoway ///
(bar m_cost sample, barwidth(.8)) ///
(rspike max_cost min_cost sample) ///
, ylabel(0(10)150) ymtick(0(5)150) ///
xlabel(1/5,valuelabel angle(45)) ///
ytitle("INR 1k") xtitle("") ///
title("By level of education") ///
legend(off) /// 
name(gpheduc, replace)
graph export "graph/Gifts_educ.png", as(png) replace


****************************************
* END








****************************************
* Gifts and caste
****************************************
use"NEEMSIS-marriage.dta", clear

replace totalmarriagegiftamount_alt=totalmarriagegiftamount_alt/1000

tabstat totalmarriagegiftamount_alt, stat(n mean) by(caste)

***** Rename
rename totalmarriagegiftamount_alt total

fre caste

***** By categories
gen total1=total if caste==1
gen total2=total if caste==2
gen total3=total if caste==3



***** Macro for formatting database
global var total total1 total2 total3
local i=1
foreach x in $var {
preserve
rename `x' cost
keep cost
collapse (mean) m_cost=cost (sd) sd_cost=cost (count) n_cost=cost
gen sample=`i'
order sample
* M
gen max_cost=m_cost+invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
gen min_cost=m_cost-invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
save"_temp`i'", replace
restore
local i=`i'+1
}

***** Append
use "_temp1", clear

forvalues i=2/4 {
append using "_temp`i'"
}

label define sample 1"Total" 2"Dalits" 3"Middle" 4"Upper"
label values sample sample

***** Graph
twoway ///
(bar m_cost sample, barwidth(.8)) ///
(rspike max_cost min_cost sample) ///
, ylabel(0(10)150) ymtick(0(5)150) ///
xlabel(1/4,valuelabel angle(45)) ///
ytitle("INR 1k") xtitle("") ///
title("By caste") ///
legend(off) /// 
name(gphcaste, replace)
graph export "graph/Gifts_caste.png", as(png) replace



********** Combine
graph combine gpheduc gphassets gphcaste, col(3) name(comb, replace)
graph export "graph/Gifts_educassetscaste.png", as(png) replace


****************************************
* END


















****************************************
* Nets gains from marriage
****************************************
use"NEEMSIS-marriage.dta", clear

tabstat marriagenetcost_alt1000 MNCI_alt, stat(n mean) by(sex)


* Net cost
replace marriagenetcost_alt1000=. if marriagenetcost_alt1000<-700
replace marriagenetcost_alt1000=. if marriagenetcost_alt1000>700
replace marriagenetcost_alt1000=marriagenetcost_alt1000*(-1)

twoway ///
(kdensity marriagenetcost_alt1000 if sex==1 & ownland==0, bwidth(69) xline(0, lcolor(gs14)) lpattern(dash) lcolor(gs6)) ///
(kdensity marriagenetcost_alt1000 if sex==1 & ownland==1, bwidth(69) lpattern(solid) lcolor(gs6)) ///
(kdensity marriagenetcost_alt1000 if sex==2 & ownland==0, bwidth(69) lpattern(shortdash) lcolor(gs10)) ///
(kdensity marriagenetcost_alt1000 if sex==2 & ownland==1, bwidth(69) lpattern(solid) lcolor(gs12)) ///
, ytitle("Density") xtitle("Net cost of marriage (INR 1k)") ///
xlabel(-800(200)800) xmtick(-800(100)800) ///
note("Kernel: Epanechnikov, bandwidth=69", size(vsmall)) ///
legend(order(1 "Husband - No land" 2 "Husband - Land owner" 3 "Wife - No land" 4 "Wife - Land owner") pos(6) col(2)) name(gph1, replace)



* Net cost to income
replace MNCI_alt=. if MNCI_alt<-700
replace MNCI_alt=. if MNCI_alt>700
replace MNCI_alt=MNCI_alt*(-1)

twoway ///
(kdensity MNCI_alt if sex==1 & ownland==0, bwidth(69) xline(0, lcolor(gs14)) lpattern(dash) lcolor(gs6)) ///
(kdensity MNCI_alt if sex==1 & ownland==1, bwidth(69) lpattern(solid) lcolor(gs6)) ///
(kdensity MNCI_alt if sex==2 & ownland==0, bwidth(69) lpattern(shortdash) lcolor(gs10)) ///
(kdensity MNCI_alt if sex==2 & ownland==1, bwidth(69) lpattern(solid) lcolor(gs12)) ///
, ytitle("Density") xtitle("Net cost of marriage to annual income (%)") ///
xlabel(-800(200)800) xmtick(-800(100)800) ///
note("Kernel: Epanechnikov, bandwidth=69", size(vsmall)) ///
legend(order(1 "Husband - No land" 2 "Husband - Land owner" 3 "Wife - No land" 4 "Wife - Land owner") pos(6) col(2)) name(gph2, replace)


* Combine
grc1leg gph1 gph2, name(comb, replace)
graph export "graph/Netgains.png", as(png) replace

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
* Net loss
****************************************

********** Males - absolut
use"NEEMSIS-marriage.dta", clear
keep if sex==1
keep if year==2020
drop if marriagenetcost1000>=0
replace marriagenetcost1000=marriagenetcost1000*(-1)

***** Rename
rename marriagenetcost1000 total

***** By categories
gen totalno=total if ownland==0
gen totalown=total if ownland==1

***** Macro for formatting database
global var total totalno totalown
local i=1
foreach x in $var {
preserve
rename `x' cost
keep cost
collapse (mean) m_cost=cost (sd) sd_cost=cost (count) n_cost=cost
gen sample=`i'
order sample
* M
gen max_cost=m_cost+invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
gen min_cost=m_cost-invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
save"_temp`i'", replace
restore
local i=`i'+1
}

***** Append
use "_temp1", clear

forvalues i=2/3 {
append using "_temp`i'"
}

label define sample 1"Total" 2"No land" 3"Land owner"
label values sample sample

***** Graph
twoway ///
(bar m_cost sample, barwidth(.8)) ///
(rspike max_cost min_cost sample) ///
, ylabel(0(50)350) ymtick(0(25)350) ///
xlabel(1/3,valuelabel angle(45)) ///
ytitle("INR 1k") xtitle("Household characteristics") ///
title("Absolut gain") ///
legend(off) /// 
name(gph1, replace)









********** Females - absolut
use"NEEMSIS-marriage.dta", clear
keep if sex==2
keep if year==2020
drop if marriagenetcost1000<0

***** Rename
rename marriagenetcost1000 total

***** By categories
gen totalno=total if ownland==0
gen totalown=total if ownland==1

***** Macro for formatting database
global var total totalno totalown
local i=1
foreach x in $var {
preserve
rename `x' cost
keep cost
collapse (mean) m_cost=cost (sd) sd_cost=cost (count) n_cost=cost
gen sample=`i'
order sample
* M
gen max_cost=m_cost+invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
gen min_cost=m_cost-invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
save"_temp`i'", replace
restore
local i=`i'+1
}

***** Append
use "_temp1", clear

forvalues i=2/3 {
append using "_temp`i'"
}

label define sample 1"Total" 2"No land" 3"Land owner"
label values sample sample

***** Graph
twoway ///
(bar m_cost sample, barwidth(.8)) ///
(rspike max_cost min_cost sample) ///
, ylabel(0(50)500) ymtick(0(25)500) ///
xlabel(1/3,valuelabel angle(45)) ///
ytitle("INR 1k") xtitle("Household characteristics") ///
title("Absolut loss") ///
legend(off) /// 
name(gph2, replace)





********** Males - relative
use"NEEMSIS-marriage.dta", clear
keep if sex==1
keep if year==2020
replace MNCI=MNCI*(-1)
drop if MNCI<=0

***** Rename
rename MNCI total

***** By categories
gen totalno=total if ownland==0
gen totalown=total if ownland==1

***** Macro for formatting database
global var total totalno totalown
local i=1
foreach x in $var {
preserve
rename `x' cost
keep cost
collapse (mean) m_cost=cost (sd) sd_cost=cost (count) n_cost=cost
gen sample=`i'
order sample
* M
gen max_cost=m_cost+invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
gen min_cost=m_cost-invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
save"_temp`i'", replace
restore
local i=`i'+1
}

***** Append
use "_temp1", clear

forvalues i=2/3 {
append using "_temp`i'"
}

label define sample 1"Total" 2"No land" 3"Land owner"
label values sample sample

***** Graph
twoway ///
(bar m_cost sample, barwidth(.8)) ///
(rspike max_cost min_cost sample) ///
, ylabel(0(50)300) ymtick(0(25)300) ///
xlabel(1/3,valuelabel angle(45)) ///
ytitle("Percent") xtitle("Household characteristics") ///
title("Gain to income") ///
legend(off) /// 
name(gph3, replace)










********** Females - relative
use"NEEMSIS-marriage.dta", clear
keep if sex==2
keep if year==2020
drop if MNCI<=0

***** Rename
rename MNCI total

***** By categories
gen totalno=total if ownland==0
gen totalown=total if ownland==1

***** Macro for formatting database
global var total totalno totalown
local i=1
foreach x in $var {
preserve
rename `x' cost
keep cost
collapse (mean) m_cost=cost (sd) sd_cost=cost (count) n_cost=cost
gen sample=`i'
order sample
* M
gen max_cost=m_cost+invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
gen min_cost=m_cost-invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
save"_temp`i'", replace
restore
local i=`i'+1
}

***** Append
use "_temp1", clear

forvalues i=2/3 {
append using "_temp`i'"
}

label define sample 1"Total" 2"No land" 3"Land owner"
label values sample sample

***** Graph
twoway ///
(bar m_cost sample, barwidth(.8)) ///
(rspike max_cost min_cost sample) ///
, ylabel(0(50)300) ymtick(0(25)300) ///
xlabel(1/3,valuelabel angle(45)) ///
ytitle("Percent") xtitle("Household characteristics") ///
title("Loss to income") ///
legend(off) /// 
name(gph4, replace)



********** 
graph combine gph1 gph3, title("Average net gain from marriage for husbands' families") name(comb1, replace)




********** 
graph combine gph2 gph4, title("Average net loss from marriage for wives' families") name(comb2, replace)



********** Combine
graph combine comb1 comb2, col(2) name(comb, replace)
graph export "graph/Netgains.png", as(png) replace


****************************************
* END

































****************************************
* Cost and agriculture
****************************************

********* Husband absolut cost
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



********* Wife absolut cost
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





********* Husband relative cost
use"NEEMSIS-marriage.dta", clear
sum annualincome_HH
keep if sex==1
tabstat marriagehusbandcost annualincome_HH, stat(n mean q)
replace marriagehusbandcost=marriagehusbandcost*100/annualincome_HH
ta marriagehusbandcost
replace marriagehusbandcost=600 if marriagehusbandcost>600 & marriagehusbandcost!=.

twoway ///
(kdensity marriagehusbandcost if ownland==0, bwidth(29)) ///
(kdensity marriagehusbandcost if ownland==1, bwidth(29)) ///
, ///
xtitle("Marriage cost to income (%)") ytitle("Density") ///
xlabel(0(100)600) xmtick(0(50)600) ///
title("Husband's side") ///
note("Kernel: Epanechnikov, bandwidth=29", size(vsmall)) ///
legend(order(1 "No land" 2 "Land owner") pos(6) col(2)) name(gph3, replace)



********* Wife relative cost
use"NEEMSIS-marriage.dta", clear
keep if sex==2
tabstat marriagewifecost2 annualincome_HH, stat(n mean q)
replace marriagewifecost2=marriagewifecost2*100/annualincome_HH
ta marriagewifecost2
replace marriagewifecost2=1000 if marriagewifecost2>1000 & marriagewifecost2!=.

twoway ///
(kdensity marriagewifecost2 if ownland==0, bwidth(69)) ///
(kdensity marriagewifecost2 if ownland==1, bwidth(69)) ///
, ///
xtitle("Marriage cost to income (%)") ytitle("Density") ///
xlabel(0(100)1000) xmtick(0(50)1000) ///
title("Wife's side") ///
note("Kernel: Epanechnikov, bandwidth=69", size(vsmall)) ///
legend(order(1 "No land" 2 "Land owner") pos(6) col(2)) name(gph4, replace)



* One graph
grc1leg gph1 gph2 gph3 gph4, col(2) name(gph_comb, replace)
graph export "graph/Cost_agri.png", as(png) replace

****************************************
* END










****************************************
* Cost and gender
****************************************

********* Absolut cost
use"NEEMSIS-marriage.dta", clear

replace marriagehusbandcost=marriagehusbandcost/1000
replace marriagewifecost2=marriagewifecost2/1000

tabstat marriagetotalcost2 marriagetotalcost, stat(n mean) by(year)
tabstat sharemales sharefemales, stat(n mean)
tabstat marriagehusbandcost marriagewifecost2, stat(n mean)
tabstat costtoincome2, stat(n mean) by(sex)

twoway ///
(kdensity marriagehusbandcost, bwidth(69)) ///
(kdensity marriagewifecost2, bwidth(69)) ///
, ///
xtitle("INR 1k") ytitle("Density") ///
xlabel(0(200)1400) xmtick(0(100)1400) ///
title("Marriage cost") ///
note("Kernel: Epanechnikov, bandwidth=69", size(vsmall)) ///
legend(order(1 "Husband" 2 "Wife") pos(6) col(2)) name(gph1, replace)



********* Relative cost
use"NEEMSIS-marriage.dta", clear

twoway ///
(kdensity costtoincome2 if sex==1, bwidth(49)) ///
(kdensity costtoincome2 if sex==2, bwidth(49)) ///
, ///
xtitle("Percent") ytitle("Density") ///
xlabel(0(100)1000) xmtick(0(50)1000) ///
title("Marriage cost to annual income") ///
note("Kernel: Epanechnikov, bandwidth=49", size(vsmall)) ///
legend(order(1 "Husband" 2 "Wife") pos(6) col(2)) name(gph2, replace)


* One graph
grc1leg gph1 gph2, col(2) name(gph_comb, replace)
graph export "graph/Cost_gender.png", as(png) replace

****************************************
* END











****************************************
* Cost, gender, and agricultural
****************************************

********** Absolut amount
use"NEEMSIS-marriage.dta", clear
drop if year==2016

***** 1000
replace marriagetotalcost2=marriagetotalcost2/1000
replace marriagehusbandcost=marriagehusbandcost/1000
replace marriagewifecost2=marriagewifecost2/1000



***** Rename
rename marriagetotalcost2 total
rename marriagehusbandcost husband
rename marriagewifecost2 wife


***** By categories
gen totalno=total if ownland==0
gen totalown=total if ownland==1

gen husbandno=husband if ownland==0 & sex==1
gen husbandown=husband if ownland==1 & sex==1

gen wifeno=wife if ownland==0 & sex==2
gen wifeown=wife if ownland==1 & sex==2



***** Macro for formatting database
*global var total totalno totalown husband husbandno husbandown wife wifeno wifeown
global var total husband wife
local i=1
foreach x in $var {
preserve
rename `x' cost
keep cost
collapse (mean) m_cost=cost (sd) sd_cost=cost (count) n_cost=cost
gen sample=`i'
order sample
* M
gen max_cost=m_cost+invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
gen min_cost=m_cost-invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
save"_temp`i'", replace
restore
local i=`i'+1
}

***** Append
use "_temp1", clear

forvalues i=2/3 {
append using "_temp`i'"
}

*label define sample 1"Total" 2"Total - No land" 3"Total - Own land" 4"Husband" 5"Husband - No land" 6"Husband - Own land" 7"Wife" 8"Wife - No land" 9"Wife - Own land"
label define sample 1"Total" 2"Husband" 3"Wife"
label values sample sample



***** Graph
twoway ///
(bar m_cost sample, barwidth(.8)) ///
(rspike max_cost min_cost sample) ///
, ylabel(0(100)600) ymtick(0(50)600) ///
xlabel(1/3,valuelabel angle(0)) ///
ytitle("INR 1k") xtitle("") ///
title("Average marriage cost") ///
legend(off) /// 
name(cost1, replace)





********** Relative amount
use"NEEMSIS-marriage.dta", clear
drop if year==2016

***** Rename
rename costtoincome2 total
gen husband=total if sex==1
gen wife=total if sex==2


***** By categories
gen totalno=total if ownland==0
gen totalown=total if ownland==1

gen husbandno=husband if ownland==0 & sex==1
gen husbandown=husband if ownland==1 & sex==1

gen wifeno=wife if ownland==0 & sex==2
gen wifeown=wife if ownland==1 & sex==2



***** Macro for formatting database
*global var total totalno totalown husband husbandno husbandown wife wifeno wifeown
global var total husband wife
local i=1
foreach x in $var {
preserve
rename `x' cost
keep cost
collapse (mean) m_cost=cost (sd) sd_cost=cost (count) n_cost=cost
gen sample=`i'
order sample
* M
gen max_cost=m_cost+invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
gen min_cost=m_cost-invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
save"_temp`i'", replace
restore
local i=`i'+1
}

***** Append
use "_temp1", clear

forvalues i=2/3 {
append using "_temp`i'"
}

*label define sample 1"Total" 2"Total - No land" 3"Total - Own land" 4"Husband" 5"Husband - No land" 6"Husband - Own land" 7"Wife" 8"Wife - No land" 9"Wife - Own land"
label define sample 1"Total" 2"Husband" 3"Wife"
label values sample sample



***** Graph
drop if sample==1
twoway ///
(bar m_cost sample, barwidth(.8)) ///
(rspike max_cost min_cost sample) ///
, ylabel(0(50)350) ymtick(0(25)350) ///
xlabel(2/3,valuelabel angle(0)) ///
ytitle("Percent") xtitle("") ///
title("Average marriage cost to annual income") ///
legend(off) /// 
name(cost2, replace)




********** Combine
graph combine cost1 cost2, name(comb, replace)
graph export "graph/Cost_gender.png", as(png) replace



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
* Dowry and agriculture
****************************************



********** Absolut amount
use"NEEMSIS-marriage.dta", clear
keep if sex==2

*
drop DAIR
rename marriagedowry1000 DAIR

***** By categories
gen DAIRno=DAIR if ownland==0
gen DAIRown=DAIR if ownland==1

gen DAIRagr=DAIR if divHH10==1
gen DAIRnag=DAIR if divHH10==2
gen DAIRdiv=DAIR if divHH10==3



***** Macro for formatting database
global var DAIR DAIRno DAIRown DAIRagr DAIRnag DAIRdiv
local i=1
foreach x in $var {
preserve
rename `x' cost
keep cost
collapse (mean) m_cost=cost (sd) sd_cost=cost (count) n_cost=cost
gen sample=`i'
order sample
* M
gen max_cost=m_cost+invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
gen min_cost=m_cost-invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
save"_temp`i'", replace
restore
local i=`i'+1
}

***** Append
use "_temp1", clear

forvalues i=2/6 {
append using "_temp`i'"
}

recode sample (2=3) (3=4) (4=6) (5=7) (6=8)
label define sample 1"Total" 2" " 3"No land" 4"Own land" 5" " 6"Agricultural" 7"Non-agricultural" 8"Diversified"
label values sample sample

fre sample


***** Graph
twoway ///
(bar m_cost sample, barwidth(.8)) ///
(rspike max_cost min_cost sample) ///
, ylabel(0(50)300) ymtick(0(25)300) ///
xlabel(1/8,valuelabel angle(45)) ///
ytitle("INR 1k") xtitle("Characteristics of the wife's household") ///
title("Average dowry paid") ///
legend(off) /// 
name(cost1, replace)











********** Relative amount
use"NEEMSIS-marriage.dta", clear
keep if sex==2


***** By categories
gen DAIRno=DAIR if ownland==0
gen DAIRown=DAIR if ownland==1

gen DAIRagr=DAIR if divHH10==1
gen DAIRnag=DAIR if divHH10==2
gen DAIRdiv=DAIR if divHH10==3



***** Macro for formatting database
global var DAIR DAIRno DAIRown DAIRagr DAIRnag DAIRdiv
local i=1
foreach x in $var {
preserve
rename `x' cost
keep cost
collapse (mean) m_cost=cost (sd) sd_cost=cost (count) n_cost=cost
gen sample=`i'
order sample
* M
gen max_cost=m_cost+invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
gen min_cost=m_cost-invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
save"_temp`i'", replace
restore
local i=`i'+1
}

***** Append
use "_temp1", clear

forvalues i=2/6 {
append using "_temp`i'"
}

recode sample (2=3) (3=4) (4=6) (5=7) (6=8)
label define sample 1"Total" 2" " 3"No land" 4"Own land" 5" " 6"Agricultural" 7"Non-agricultural" 8"Diversified"
label values sample sample

fre sample


***** Graph
twoway ///
(bar m_cost sample, barwidth(.8)) ///
(rspike max_cost min_cost sample) ///
, ylabel(0(50)450) ymtick(0(25)450) ///
xlabel(1/8,valuelabel angle(45)) ///
ytitle("Percent") xtitle("Characteristics of the wife's household") ///
title("Average dowry paid to annual income") ///
legend(off) /// 
name(cost2, replace)






********** Combine
graph combine cost1 cost2, name(comb, replace)
graph export "graph/Dowry_agri.png", as(png) replace

****************************************
* END

















****************************************
* Gift and gender
****************************************



********** Absolut amount
use"NEEMSIS-marriage.dta", clear
*
replace totalmarriagegiftamount_alt=totalmarriagegiftamount_alt/1000
rename totalmarriagegiftamount_alt gift

***** By categories
gen gifthusband=gift if sex==1
gen giftwife=gift if sex==2


***** Macro for formatting database
global var gift gifthusband giftwife
local i=1
foreach x in $var {
preserve
rename `x' cost
keep cost
collapse (mean) m_cost=cost (sd) sd_cost=cost (count) n_cost=cost
gen sample=`i'
order sample
* M
gen max_cost=m_cost+invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
gen min_cost=m_cost-invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
save"_temp`i'", replace
restore
local i=`i'+1
}

***** Append
use "_temp1", clear

forvalues i=2/3 {
append using "_temp`i'"
}

*recode sample (2=3) (3=4) (4=6) (5=7) (6=8)
label define sample 1"Total" 2"Husband" 3"Wife"
label values sample sample


***** Graph
twoway ///
(bar m_cost sample, barwidth(.8)) ///
(rspike max_cost min_cost sample) ///
, ylabel(0(20)140) ymtick(0(10)140) ///
xlabel(1/3,valuelabel angle(0)) ///
ytitle("INR 1k") xtitle("") ///
title("Average value of gifts received") ///
legend(off) /// 
name(cost1, replace)










********** Relative amount
use"NEEMSIS-marriage.dta", clear
*
gen gift=totalmarriagegiftamount_alt
keep if year==2020
***** By categories
gen gifthusband=totalmarriagegiftamount_alt*100/marriagehusbandcost if sex==1
gen giftwife=totalmarriagegiftamount_alt*100/marriagewifecost2 if sex==2

tabstat gifthusband giftwife, stat(n mean) by(sex)

***** Macro for formatting database
global var gifthusband giftwife
local i=1
foreach x in $var {
preserve
rename `x' cost
keep cost
collapse (mean) m_cost=cost (sd) sd_cost=cost (count) n_cost=cost
gen sample=`i'
order sample
* M
gen max_cost=m_cost+invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
gen min_cost=m_cost-invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
save"_temp`i'", replace
restore
local i=`i'+1
}

***** Append
use "_temp1", clear

forvalues i=2/2 {
append using "_temp`i'"
}

*recode sample (2=3) (3=4) (4=6) (5=7) (6=8)
label define sample 1"Husband" 2"Wife"
label values sample sample


***** Graph
twoway ///
(bar m_cost sample, barwidth(.8)) ///
(rspike max_cost min_cost sample) ///
, ylabel(0(20)160) ymtick(0(10)160) ///
xlabel(1/2,valuelabel angle(0)) ///
ytitle("Percent") xtitle("") ///
title("Average value of gifts received to marriage cost") ///
legend(off) /// 
name(cost2, replace)



********** Combine
graph combine cost1 cost2, name(comb, replace)
graph export "graph/Gift_gender.png", as(png) replace

****************************************
* END





















****************************************
* Gift and gender
****************************************



********** Absolut amount
use"NEEMSIS-marriage.dta", clear
*
replace totalmarriagegiftamount_alt=totalmarriagegiftamount_alt/1000
rename totalmarriagegiftamount_alt gift

***** By categories
gen gifthusband=gift if sex==1
gen giftwife=gift if sex==2


***** Macro for formatting database
global var gift gifthusband giftwife
local i=1
foreach x in $var {
preserve
rename `x' cost
keep cost
collapse (mean) m_cost=cost (sd) sd_cost=cost (count) n_cost=cost
gen sample=`i'
order sample
* M
gen max_cost=m_cost+invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
gen min_cost=m_cost-invttail(n_cost-1,0.025)*(sd_cost/sqrt(n_cost))
save"_temp`i'", replace
restore
local i=`i'+1
}

***** Append
use "_temp1", clear

forvalues i=2/3 {
append using "_temp`i'"
}

*recode sample (2=3) (3=4) (4=6) (5=7) (6=8)
label define sample 1"Total" 2"Husband" 3"Wife"
label values sample sample


***** Graph
twoway ///
(bar m_cost sample, barwidth(.8)) ///
(rspike max_cost min_cost sample) ///
, ylabel(0(20)140) ymtick(0(10)140) ///
xlabel(1/3,valuelabel angle(0)) ///
ytitle("INR 1k") xtitle("") ///
title("Average value of gifts received") ///
legend(off) /// 
name(cost1, replace)





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
ylabel(0(100)900) ymtick(0(50)900) ///
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
ylabel(0(100)900) ymtick(0(50)900) ///
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
ylabel(0(100)900) ymtick(0(50)900) ///
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
recode educexp_HH educexp_male_HH educexp_female_HH (0=.)
replace educexp_HH=educexp_HH/1000
replace educexp_male_HH=educexp_male_HH/1000
replace educexp_female_HH=educexp_female_HH/1000

gen dumeducexp_HH=.
replace dumeducexp_HH=1 if educexp_HH>0 & educexp_HH!=.
replace dumeducexp_HH=0 if educexp_HH==.

* Stat
tabstat dumeducexp_HH dumeducexp_male_HH dumeducexp_female_HH educexp_male_HH educexp_female_HH, stat(n mean) by(year)
tabstat educexp_HH educexp_male_HH educexp_female_HH, stat(n mean) by(year)

tabstat dumeducexp_HH dumeducexp_male_HH dumeducexp_female_HH educexp_male_HH educexp_female_HH, stat(n mean) by(caste)
tabstat educexp_HH educexp_male_HH educexp_female_HH, stat(n mean) by(caste)


* Collapse for total
preserve
collapse (mean) dumeducexp_HH dumeducexp_male_HH dumeducexp_female_HH educexp_HH educexp_male_HH educexp_female_HH, by(time)
gen caste=0
save"_temp", replace
restore

* Collapse by caste
collapse (mean) dumeducexp_HH dumeducexp_male_HH dumeducexp_female_HH educexp_HH educexp_male_HH educexp_female_HH, by(caste time)

* Append total
append using "_temp"

* Clean
label define caste 0"Total" 1"Dalits" 2"Middle castes" 3"Upper castes"
label values caste caste
sort caste time

rename dumeducexp_HH dumeducexp0
rename dumeducexp_male_HH dumeducexp1
rename dumeducexp_female_HH dumeducexp2
rename educexp_HH educexp0
rename educexp_male_HH educexp1
rename educexp_female_HH educexp2

* Reshape
reshape long dumeducexp educexp, i(caste time) j(sex)
label define sex 0"Total" 1"Boys" 2"Girls"
label values sex sex
replace dumeducexp=dumeducexp*100

* Share
graph bar (mean) dumeducexp, over(time) over(sex, lab(angle(45))) over(caste, lab(angle(45))) ///
ytitle("Percent") ylabel(0(10)80) ymtick(0(5)80) ///
title("Share of households investing in education") ///
legend(pos(6) col(2)) name(share, replace)

* Amount invested
graph bar (mean) educexp, over(time) over(sex, lab(angle(45))) over(caste, lab(angle(45))) ///
ytitle("INR 1k") ylabel(0(5)30) ymtick(0(2.5)30) ///
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
ta jatis year, col nofreq
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

ta divHH10 time, col nofreq

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


