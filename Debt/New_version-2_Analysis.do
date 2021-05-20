cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
19 avril 2021
-----
TITLE: ANALYSIS OVERINDEBTEDNESS


-------------------------
*/

clear all
global name "Arnaud"
set scheme plottig

global directory "D:\Documents\_Thesis\Research-Overindebtedness\New_version_with2020"
cd"$directory"



****************************************
* STATS 2020 : loss in assets
****************************************
use"$directory\_paneldata\NEEMSIS2-HH.dta", clear


bysort HHID_panel : gen n=_n
keep if n==1
dropmiss, force
keep if orga_HHagri==3

**********Loan at HH with refusal
tab covrefusalloan caste, col nofreq

**********Agri
*Land
destring covsellland, replace
recode covsellland (66=0) (2=0)
tab covsellland caste, col nofreq

*Crops
/*
tab1 covsubsistence covsubsistencereason covsubsistencesize covsubsistencenext covsubsistencereasonother covharvest covselfconsumption covharvestquantity covharvestprices
*/

*Livestock
foreach x in covselllivestock_cow covselllivestock_goat covselllivestock_chicken covselllivestock_bullock covselllivestock_bullforploughin covselllivestock_none {
tab `x' caste, col nofreq
}
egen covselllivestock_total=rowtotal(covselllivestock_cow covselllivestock_goat covselllivestock_chicken covselllivestock_bullock covselllivestock_bullforploughin)
replace covselllivestock_total=1 if covselllivestock_total>=1
tab covselllivestock_total caste, col nofreq

*Equipment
foreach x in covsellequipment_tractor covsellequipment_bullockcar covsellequipment_harvester covsellequipment_plowingmac covsellequipment_none {
tab `x' caste, col nofreq
}
egen covsellequipment_total=rowtotal(covsellequipment_tractor covsellequipment_bullockcar covsellequipment_harvester covsellequipment_plowingmac)
replace covsellequipment_total=1 if covsellequipment_total>=1
tab covsellequipment_total caste, col nofreq


*Food
/*
tab1 covfoodenough covfoodquality covgenexpenses covexpensesdecrease covexpensesincrease covexpensesstable covplacepurchase covsick 
*/


**********Goods
foreach x in covsellgoods_car covsellgoods_bike covsellgoods_fridge covsellgoods_furniture covsellgoods_tailormach covsellgoods_phone covsellgoods_landline covsellgoods_DVD covsellgoods_camera covsellgoods_cookgas covsellgoods_computer covsellgoods_antenna covsellgoods_other covsellgoods_none {
tab `x' caste, col nofreq
}
egen covsellgoods_total=rowtotal(covsellgoods_car covsellgoods_bike covsellgoods_fridge covsellgoods_furniture covsellgoods_tailormach covsellgoods_phone covsellgoods_landline covsellgoods_DVD covsellgoods_camera covsellgoods_cookgas covsellgoods_computer covsellgoods_antenna covsellgoods_other)
replace covsellgoods_total=1 if covsellgoods_total>=1
tab covsellgoods_total caste, col nofreq



**********House
destring covsellhouse, replace
recode covsellhouse (66=0) (2=0)
tab covsellhouse caste, col nofreq

destring covsellplot, replace
recode covsellplot (66=0) (2=0)
tab covsellplot caste, col nofreq


**********Gold
destring covsoldgold, replace
tab covsoldgold caste, col nofreq

**********Total
recode covsellland covselllivestock_total covsellequipment_total covsellgoods_total covsellhouse covsellplot covsoldgold (.=0)
egen covsell_total=rowtotal(covsellland covselllivestock_total covsellequipment_total covsellgoods_total covsellhouse covsellplot covsoldgold)
replace covsell_total=1 if covsell_total>1

tab covsell_total caste, col
****************************************
* END













****************************************
* STATS
****************************************
use"$directory\_paneldata\panel-all_loans_v2.dta", clear

gen loanamount1000=loanamount/1000

foreach x in 2010 2016 2020 {
tabstat loanamount1000 if year==`x' & panel_2010_2016_2020==1, stat(n mean) by(loanreasongiven)
}

*Share of total clientele using it
fre loanreasongiven
forvalues i=1(1)13{
gen reason`i'=0
}

forvalues i=1(1)12{
replace reason`i'=1 if loanreasongiven==`i'
}
replace reason13=1 if loanreasongiven==77

cls
preserve 
keep if year==2010
forvalues i=1(1)13{
bysort HHID2010: egen reasonHH_`i'=max(reason`i')
} 
bysort HHID2010: gen n=_n
keep if n==1
forvalues i=1(1)13{
tab reasonHH_`i', m
}
restore
cls
preserve 
keep if year==2016
forvalues i=1(1)13{
bysort HHID2010: egen reasonHH_`i'=max(reason`i')
} 
bysort HHID2010: gen n=_n
keep if n==1
forvalues i=1(1)13{
tab reasonHH_`i', m
}
restore
cls
preserve 
keep if year==2020
forvalues i=1(1)13{
bysort HHID2010: egen reasonHH_`i'=max(reason`i')
} 
bysort HHID2010: gen n=_n
keep if n==1
forvalues i=1(1)13{
tab reasonHH_`i', m
}
restore

****************************************
* END








****************************************
* Table 1
****************************************

********** 2010
use"$directory\_paneldata\RUME-HH.dta", clear
tab relationshiptohead
preserve
keep if relationshiptohead==1
duplicates tag HHID_panel, gen(tag)
tab HHID_panel if tag==1
tab edulevel if tag==1
restore


*DAR
*Tab
tab caste year
label define caste 1"Dalits (n=153)" 2"Middle (n=116)" 3"Upper (n=44)", replace
label values caste caste
tabstat DAR, stat(n mean sd p50 p90 p95 p99 max) by(time) long

*Change the scale of outliers
forvalues i=2(1)5{
tabstat DAR if DAR>`i', stat(n mean sd p50 max) by(time) long
clonevar DAR`i'=DAR
replace DAR`i'=`i' if DAR>`i' & year==2010
replace DAR`i'=`i' if DAR>`i' & year==2016
replace DAR`i'=`i' if DAR>`i' & year==2020
}
tabstat DAR DAR5 DAR4 DAR3 DAR2, stat(n mean sd p50 p90 p95 p99 max) by(time) long

*Boxplot
set graph off
forvalues i=2(1)5{
stripplot DAR`i', over(time) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(0.5)`i') ymtick(0(0.25)`i') ytitle() ///
msymbol(oh oh oh) mcolor(plr1 ply1 plg1) 
graph export "$directory\_paneldata\_graph\DAR`i'.pdf", replace
}


**********DIR

*Tab
tabstat DIR, stat(n mean sd p50 p90 p95 p99 max) by(time) long
tabstat DIR if DIR>100, stat(n mean) by(time) long


*Change the scale of outliers
forvalues i=2(1)5{
tabstat DIR if DIR>`i', stat(n mean sd p50 max) by(time) long
clonevar DIR`i'=DIR
replace DIR`i'=`i' if DIR>`i' & year==2010
replace DIR`i'=`i' if DIR>`i' & year==2016
replace DIR`i'=`i' if DIR>`i' & year==2020
}
tabstat DIR , stat(n mean sd p50 p90 p95 p99 max) by(time) long

*Boxplot
set graph off
forvalues i=2(1)5{
stripplot DAR`i', over(time) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(0.5)`i') ymtick(0(0.25)`i') ytitle() ///
msymbol(oh oh oh) mcolor(plr1 ply1 plg1) 
graph export "$directory\_paneldata\_graph\DAR`i'.pdf", replace
}



****************************************
* END








****************************************
* Test panel wide
****************************************
use"$directory\_paneldata\panel_ratio_wide.dta", clear

tabstat DAR2010 DAR2016 DAR2020, stat(n mean sd p50 p90 p95 p99 max) by(caste)
sort DAR2016
gen out2016=1 if DAR2016>999
replace out2016=0 if DAR2016<=999


foreach x in 2010 2016 2020{
gen DAR`x'=totalloanamount`x'/assets`x'
gen DIR`x'=totalloanamount`x'/totalincome_HH`x'
}


kdensity DAR2016 if (caste_group==1 & out2016==0), plot(kdensity DAR2016 if (caste_group==2 & out2016==0)|| kdensity DAR2016 if (caste_group==3 & out2016==0)) legend(label(1 "Dalits") label(2 "Middle") label(3 "Upper")) bw(15)
****************************************
* END
