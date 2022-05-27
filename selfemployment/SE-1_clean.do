cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
November 27, 2021
-----
TITLE: Cleaning for SE analysis

-------------------------
*/



****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
********** Path to folder "data" folder.
global directory = "D:\Documents\_Thesis\Research-Selfemployed\Data"
cd "$directory"

global wave2 "NEEMSIS1-HH_v9"
global wave3 "NEEMSIS2-HH_v22"
global occ2 "NEEMSIS-occupation_allwide_v4"
global occ3 "NEEMSIS_APPEND-occupations_v5"

****************************************
* END


/*
When individuals have SE activity, is it often the main occupation?
Income comparison between SE and other?
Maybe I need to concat Agri SE and Non-agri SE and compare with regular


*/




****************************************
* SE in 2016-17
****************************************
********** HH datasets
use"$wave2", clear

*** How much SE as ego?
tab mainocc_kindofwork_indiv egoid
/*
If I count well:
Agri SE: 90+11=101
SE: 79+27=106
*/


*** Occupations
use"$occ2", clear
tabstat annualincome hoursayear, stat(n mean sd p50) by(kindofwork)

fre datestartoccup
keep if kindofwork==2

*** SE general details
* Establishment
ta yearestablishment

* Caste-based
fre businesscastebased

* Skill
ta businessskill
forvalues i=1(1)4 {
gen businessskill_`i'=0
}
forvalues i=1(1)4 {
replace businessskill_`i'=1 if strpos(businessskill,"`i'")
}
rename businessskill_1 businessskill_family
rename businessskill_2 businessskill_friends
rename businessskill_3 businessskill_school
rename businessskill_4 businessskill_experience

fre businessskill_*

* Total investment
sum businessamountinvest

* Lost?
fre businesslossinvest
sum businesslossinvestamount


*** SE investment details
* Sources
fre businesssourceinvest
foreach i in 1 2 3 4 5 6 7 8 77{
gen businesssourceinvest_`i'=0
}
foreach i in 1 2 3 4 5 6 7 8 77 {
replace businesssourceinvest_`i'=1 if strpos(businesssourceinvest,"`i'")
}
rename businesssourceinvest_1 businesssourceinvest_loansrela
rename businesssourceinvest_2 businesssourceinvest_bank
rename businesssourceinvest_3 businesssourceinvest_infor
rename businesssourceinvest_4 businesssourceinvest_saving
rename businesssourceinvest_5 businesssourceinvest_inheritance
rename businesssourceinvest_6 businesssourceinvest_profits
rename businesssourceinvest_7 businesssourceinvest_inheritbusi
rename businesssourceinvest_8 businesssourceinvest_notmuch
rename businesssourceinvest_77 businesssourceinvest_other

fre businesssourceinvest_*

fre otherbusinesssourceinvestment
gen businesssourceinvest_jewel=0
replace businesssourceinvest_jewel=1 if otherbusinesssourceinvestment=="Own and Jewell pledged"
replace businesssourceinvest_jewel=1 if otherbusinesssourceinvestment=="Pledged jewells"

gen businesssourceinvest_gov=0
replace businesssourceinvest_gov=1 if otherbusinesssourceinvestment=="Government subsidy"
replace businesssourceinvest_gov=1 if otherbusinesssourceinvestment=="Govt scheme"
drop businesssourceinvest_other otherbusinesssourceinvestment
order(businesssourceinvest_jewel businesssourceinvest_gov), after(businesssourceinvest_notmuch)

* Loans
fre numberbusinessloan_rel numberbusinessloan_bank numberbusinessloan_inf
fre namebusinesslender1_rel namebusinesslender2_rel namebusinesslender3_rel namebusinesslender1_bank namebusinesslender2_bank namebusinesslender3_bank namebusinesslender1_inf namebusinesslender2_inf namebusinesslender3_inf

fre addressbusinesslender1_rel addressbusinesslender2_rel addressbusinesslender3_rel addressbusinesslender1_bank addressbusinesslender2_bank addressbusinesslender3_bank addressbusinesslender1_inf addressbusinesslender2_inf addressbusinesslender3_inf

fre businesslender1_rel businesslender2_rel businesslender3_rel businesslender1_bank businesslender2_bank businesslender3_bank businesslender1_inf businesslender2_inf businesslender3_inf

fre castebusinesslender1_rel castebusinesslender2_rel castebusinesslender3_rel castebusinesslender1_bank castebusinesslender2_bank castebusinesslender3_bank castebusinesslender1_inf castebusinesslender2_inf castebusinesslender3_inf

fre occupbusinesslender1_rel occupbusinesslender2_rel occupbusinesslender3_rel occupbusinesslender1_bank occupbusinesslender2_bank occupbusinesslender3_bank occupbusinesslender1_inf occupbusinesslender2_inf occupbusinesslender3_inf





********** Labourers
use"$occ2", clear
fre dummybusinesslabourers
fre nbbusinesslabourers
egen HHINDID=concat(parent_key INDID2016 occupationid), p(/)
reshape long namebusinesslabourer dummybusinesslabourerhhmember address businesslabourer relationshipbusinesslabourer castebusinesslabourer businesslabourerdate businesslabourertypejob businesslabourerwagetype businesslabourerbonus businesslabourerinsurance businesslabourerpension, j(num) i(HHINDID)
keep HHINDID num HHID2010 parent_key INDID2010 INDID2016 INDID egoid occupationid occupationname hoursayear kindofwork mainoccuptype annualincome classcompleted villageid villageareaid namebusinesslabourer dummybusinesslabourerhhmember address businesslabourer relationshipbusinesslabourer castebusinesslabourer businesslabourerdate businesslabourertypejob businesslabourerwagetype businesslabourerbonus businesslabourerinsurance businesslabourerpension
keep if namebusinesslabourer!=""
save "$occ2~labourer", replace









********** Indiv datasets
use"$wave2", clear
fre mainoccuptype
keep if mainoccuptype==2

fre dummypreviouswagejob
fre previousjobcontract
fre reasonstoppedwagejob
fre otherreasonstoppedjob

fre businessnbworkers
fre dummybusinessunpaidworkers
fre businessnbpaidworkers
fre businessnbfamilyworkers
fre dummybusinesspaidworkers

fre businessnbpaidworkers
fre businessworkersfrequencypayment
fre businesslaborcost

fre frequencygrossreceipt
fre amountgrossreceipt
fre businessfixedcosts
fre businessfixedcostamount
fre businessexpenses
fre businesssocialsecurity
fre businesspaymentinkind
fre businesspaymentinkindlist

fre businesspaymentinkindvalue



* Aspirations
fre readystartjob
fre methodfindjob
fre jobpreference
fre moveoutsideforjob
fre moveoutsideforjobreason
fre aspirationminimumwage

fre dummyaspirationmorehours
fre reasondontworkmore
fre aspirationminimumwage2 

* First job
fre kindofworkfirstjob
fre unpaidinbusinessfirstjob
fre agestartworking
fre agestartworkingpaidjob
fre methodfindfirstjob
fre othermethodfindfirstjob
fre monthstofindjob





****************************************
* END











****************************************
* Evolution mainocc
****************************************
use"$wave2", clear
keep HHID_panel INDID_panel caste jatis age sex relationshiptohead villageid working_pop annualincome_indiv annualincome_HH mainocc_occupation_indiv mainocc_profession_indiv mainocc_occupation_HH worker villageid livinghome
gen year=2016
save "$wave2-_temp", replace


use"$wave3", clear
keep HHID_panel INDID_panel caste jatis age sex relationshiptohead villageid working_pop annualincome_indiv annualincome_HH mainocc_occupation_indiv mainocc_profession_indiv mainocc_occupation_HH worker villageid livinghome INDID_left
gen dummyleft=0
replace dummyleft=1 if INDID_left!=.
drop INDID_left
gen year=2020

append using "$wave2-_temp"

sort year HHID_panel INDID_panel
order HHID_panel INDID_panel year


label define occupcode 0"No occ" 1"Agri SE" 2"Agri casual" 3"Casual" 4"Reg non-quali" 5"Reg quali" 6"SE" 7"NREGA", modify



********** Deflater les valeurs
foreach x in annualincome_indiv annualincome_HH {
clonevar `x'_raw=`x'
replace `x'=`x'/10000 if year==2010
replace `x'=(`x'*(100/158))/10000 if year==2016
replace `x'=(`x'*(100/184))/10000 if year==2020
label var `x' "₹10k "
}


********** Jatis et caste
tab jatis caste
label define castecat 1"Dalits" 2"Middle" 3"Upper" 77"Other", modify


save"panel_v1", replace
erase "$wave2-_temp.dta"
****************************************
* END





****************************************
* SE share
****************************************
use"panel_v1", clear

fre mainocc_occupation_indiv
drop if mainocc_occupation_indiv==0

ta mainocc_occupation_indiv year, m

****************************************
* END




