cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
June 17, 2021
-----
Short trends and static vuln
-----

-------------------------
*/





****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all

global user "Arnaud"
global folder "Documents"

********** Path to folder "data" folder.
global directory = "C:\Users\\$user\\$folder\_Thesis\Research-Overindebtedness\Persistence_over"
cd"$directory"
global git "C:\Users\\$user\\$folder\GitHub"


*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"

* Scheme
set scheme plotplain_v2
grstyle init
grstyle set plain, box nogrid compact

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH"
global wave2 "NEEMSIS1-HH"
global wave3 "NEEMSIS2-HH"

global loan1 "RUME-all_loans"
global loan2 "NEEMSIS1-all_loans"
global loan3 "NEEMSIS2-all_loans"


********** Deflate
*https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
*(100/158) if year==2016
*(100/184) if year==2020

****************************************
* END









****************************************
* Descriptive
****************************************
cls
use"panel_v13_period_wide", clear


********** Non-weak + Vulnerable trajectory = Weak?
ta clust1 sdvuln1
ta clust2 if clust1==0 & sdvuln1==1

ta clust2 sdvuln2
ta clust3 if clust2==0 & sdvuln2==1

*** Yes


********** Descriptive



****************************************
* END


















****************************************
* Econometrics
****************************************
cls
use"panel_v13_period_long", clear

order HHID_panel panelvar potimes sdclust sdvuln clust dummy_rel_formal_var dummy_rel_formal_varbis

xtset panelvar potimes

global head head_female head_age i.head_edulevel i.head_occupation
global wifehusb wifehusb_female wifehusb_age i.wifehusb_edulevel i.wifehusb_occupation
global wealth income assets
global HH HHsize nbchildren i.housetype ownland i.villageid
global shocks dummydemonetisation i.dummylock
global marglo dummymarriage
global marson dummymarriageson
global mardau dummymarriagedaughter
gen clust_lag=L1.clust
xtprobit clust clust_lag i.caste $head $HH dummy_rel_formal_varbis dummy_rel_repay_varbis dummy_rel_informal_varbis dummy_rel_eco_varbis dummy_rel_current_varbis dummy_rel_humank_varbis dummy_rel_social_varbis dummy_rel_home_varbis


drop if potimes==3



gen sdvuln_lag=L1.sdvuln


********** Macro
global head head_female head_age i.head_edulevel i.head_occupation
global wifehusb wifehusb_female wifehusb_age i.wifehusb_edulevel i.wifehusb_occupation
global wealth income assets
global HH HHsize nbchildren i.housetype ownland i.villageid
global shocks dummydemonetisation i.dummylock
global marglo dummymarriage
global marson dummymarriageson
global mardau dummymarriagedaughter

global varv dummy_rel_repay_var dummy_rel_formal_var i.ownland_var i.occupation_var

********** Cross section
cls
preserve
keep if potimes==1
probit sdvuln i.caste $head $HH $wealth $varv $shocks $marson $mardau, allbase
probit sdvuln i.caste $head $HH $wealth dummy_income_var dummy_assets_var dummy_rel_repay_var dummy_rel_formal_var dummy_rel_informal_var dummy_rel_eco_var dummy_rel_current_var dummy_rel_humank_var dummy_rel_social_var dummy_rel_home_var, allbase
restore

cls
preserve
keep if potimes==2
probit sdvuln i.caste $head $HH $wealth $varv $shocks $marson $mardau, allbase
probit sdvuln i.caste $head $HH $wealth dummy_income_var dummy_assets_var dummy_rel_repay_var dummy_rel_formal_var dummy_rel_informal_var dummy_rel_eco_var dummy_rel_current_var dummy_rel_humank_var dummy_rel_social_var dummy_rel_home_var, allbase
restore


********** Panel model
xtprobit sdvuln i.caste $head $HH $wealth $varv, allbase
xtprobit sdvuln i.caste $head $HH $wealth $varv $shocks $marson $mardau, allbase
xtprobit sdvuln i.caste $head $HH $wealth $varv $shocks $marson $mardau, allbase



*** CRE
/*
egen xbar=mean(x), by(HHID_panel)
xtprobit sdvuln , re  
*/
****************************************
* END









********** Step 1: Static analysis of financial vulnerability
/*
Why not CRO model for caste integration?
However, not take into account the fact that financial vulnerability is 
a dynamic phenomenon.
Thus, we investigate the dynamic of financial vulnerability in step 2
*/

********** Step 2: Dynamic analysis of financial vulnerability
/*
Same: CRE model with 2 obs/indv: d1 and d2
Vuln = a + b*change in occupation + c*change in income + e

Split the analysis between those who are financial vulnerable in t (with
static measure) and those who are not.
*/

********** Step bonus:
/*
Level of financial vulnerability in 2010;
Look at the dynamic over 10 years
Then look at the level of financial vulnerability in 2020.
*/