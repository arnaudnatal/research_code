cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
September 23, 2021
-----
TITLE: Panel for marriage


-------------------------
*/

clear all

global directory "D:\Documents\_Thesis\Research-Marriage\Data\panel"
cd"$directory"


****************************************
* RUME
****************************************
use"RUME-HH_v8.dta", replace

*hh size
keep if livinghome==1
gen workingage=0
replace workingage=1 if age>=14
gen _nbworker=1 if workingage==1 & currentlyatschool==0
bysort HHID_panel: egen nbworker=sum(_nbworker)
drop _nbworker
bysort HHID_panel: egen hhsize=sum(1)
gen povertyline=816*12
gen povertyline_HH=povertyline*hhsize

gen diff_pov_indiv=annualincome_indiv-povertyline
gen below_pov_indiv=.
replace below_pov_indiv=1 if diff_pov_indiv<0
replace below_pov_indiv=0 if diff_pov_indiv>=0

gen diff_pov_HH=annualincome_HH-povertyline_HH
gen below_pov_HH=.
replace below_pov_HH=1 if diff_pov_HH<0
replace below_pov_HH=0 if diff_pov_HH>=0


*
global tokeep ///
 foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses dummylivestockexpenses ///
assets assets_noland labourincome_indiv_agri labourincome_indiv_coolie labourincome_indiv_agricoolie labourincome_indiv_nregs labourincome_indiv_investment labourincome_indiv_employee labourincome_indiv_selfemp labourincome_indiv_pension labourincome_indiv_nooccup labourincome_HH_agri labourincome_HH_coolie labourincome_HH_agricoolie labourincome_HH_nregs labourincome_HH_investment labourincome_HH_employee labourincome_HH_selfemp labourincome_HH_pension labourincome_HH_nooccup annualincome_indiv annualincome_HH ///
land1acres_own land2acres_own land3acres_own ///
loanamount_HH loans_HH marriageloan_HH marriageloanamount_HH ///
mainoccupation_income_indiv mainoccupation_indiv mainoccupationname_indiv nboccupation_indiv mainoccupation_HH nboccupation_HH ///
effectcrisislostjob effectcrisislesswork effectcrisiskindofwork effectcrisisjoblocation effectcrisisjoblocation2 ///
povertyline povertyline_HH diff_pov_indiv below_pov_indiv diff_pov_HH below_pov_HH nbworker year

keep HHID_panel INDID_panel sex caste jatis age relationshiptohead name panel_2010_2016 panel_2010_2020 panel_2016_2020 panel_2010_2016_2020 village villageid living religion edulevel currentlyatschool goldquantity goldquantityamount house howbuyhouse housevalue houseroom housetitle housetype  $tokeep

keep if panel_2010_2016_2020==1

*bysort HHID_panel: gen n=_n
*keep if n==1
*drop n

save"RUME-panel_v1.dta", replace
****************************************
* END






****************************************
* NEEMSIS 1
****************************************
use"NEEMSIS1-HH_v7.dta", replace

*marriage
bysort HHID_panel: egen marriageexpenses_HH=sum(marriageexpenses)
preserve
duplicates drop HHID_panel, force
tab marriageexpenses_HH

*gift amount
egen marriagegiftamount_indiv=rowtotal(marriagegiftamount_wellknown marriagegiftamount_shg marriagegiftamount_relatives marriagegiftamount_employer marriagegiftamount_maistry marriagegiftamount_colleagues marriagegiftamount_shopkeeper marriagegiftamount_friends)
bysort HHID_panel: egen marriagegiftamount_HH=sum(marriagegiftamount_indiv)

*hh size
keep if livinghome==1 | livinghome==2
gen workingage=0
replace workingage=1 if age>=14
gen _nbworker=1 if workingage==1 & currentlyatschool==0
bysort HHID2010: egen nbworker=sum(_nbworker)
drop _nbworker
bysort HHID2010: egen hhsize=sum(1)
gen povertyline=972*12
gen povertyline_HH=povertyline*hhsize

gen diff_pov_indiv=annualincome_indiv-povertyline
gen below_pov_indiv=.
replace below_pov_indiv=1 if diff_pov_indiv<0
replace below_pov_indiv=0 if diff_pov_indiv>=0

gen diff_pov_HH=annualincome_HH-povertyline_HH
gen below_pov_HH=.
replace below_pov_HH=1 if diff_pov_HH<0
replace below_pov_HH=0 if diff_pov_HH>=0

global tokeep ///
educationexpenses foodexpenses healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses demoexpenses businessexpenses ///
dummydemonetisation dummymarriage ///
assets assets_noland annualincome_indiv annualincome_HH ///
labourincome_indiv_agri labourincome_indiv_selfemp labourincome_indiv_sjagri labourincome_indiv_sjnonagri labourincome_indiv_uwhhnonagri labourincome_indiv_uwnonagri labourincome_indiv_uwhhagri labourincome_indiv_uwagri labourincome_HH_agri labourincome_HH_selfemp labourincome_HH_sjagri labourincome_HH_sjnonagri labourincome_HH_uwhhnonagri labourincome_HH_uwnonagri labourincome_HH_uwhhagri labourincome_HH_uwagri ///
mainoccupation_hours_indiv mainoccupation_income_indiv mainoccupation_indiv mainoccupation_HH nboccupation_indiv nboccupation_HH ///
loans_HH loanamount_HH loans_indiv loanamount_indiv marriageloan_indiv marriageloanamount_indiv marriageloan_HH marriageloanamount_HH loanamount_wm_indiv loanamount_wm_HH ///
dummymarriage marriagedowry howpaymarriage marriageexpenses dummymarriagegift husbandwifecaste marriagegiftamount_indiv marriagegiftamount_HH marriageexpenses_HH ///
sizeownland ///
povertyline povertyline_HH diff_pov_indiv below_pov_indiv diff_pov_HH below_pov_HH nbworker year


keep HHID_panel INDID_panel sex caste jatis age relationshiptohead name panel_2010_2016 panel_2010_2020 panel_2016_2020 panel_2010_2016_2020 villageid livinghome religion edulevel currentlyatschool goldquantity goldquantityamount house howbuyhouse housevalue houseroom housetitle housetype  $tokeep

keep if panel_2010_2016_2020==1

*bysort HHID_panel: gen n=_n
*keep if n==1
*drop n

save"NEEMSIS1-panel_v1.dta", replace
****************************************
* END









****************************************
* NEEMSIS 2
****************************************
use"NEEMSIS2-HH_v18.dta", replace

order marriedid old_marriedid setofmarriagegroup, last
clonevar setofmarriagegroup_o=setofmarriagegroup
split setofmarriagegroup_o,p([)
drop setofmarriagegroup_o setofmarriagegroup_o2

gen par1="["
gen par2="]"

egen setofmarriagegroup_o=concat(setofmarriagegroup_o par1 old_marriedid par2)
drop par1 par2 setofmarriagegroup_o1

replace setofmarriagegroup_o="" if substr(setofmarriagegroup_o,strlen(setofmarriagegroup_o)-2,3)=="[.]"
*replace setofmarriagegroup_o="" if strpos(setofmarriagegroup_o,"[.]")


*prepa gift
preserve
use"NEEMSIS_APPEND-marriagegift.dta", clear
bysort parent_key: egen marriagegiftamount_indiv=sum(marriagegiftamount)
split parent_key, p(/)

drop if parent_key1=="uuid:1ea7523b-cad1-44da-9afa-8c4f96189433"
drop if parent_key1=="uuid:b283cb62-a316-418a-80b5-b8fe86585ef8"
drop if parent_key1=="uuid:5a19b036-4004-4c71-9e2a-b4efd3572cf3"
drop if parent_key1=="uuid:7fc65842-447f-4b1d-806a-863556d03ed3"
drop if parent_key1=="uuid:2cca6f5f-3ecb-4088-b73f-1ecd9586690d"
drop if parent_key1=="uuid:9b931ac2-ef49-43e9-90cd-33ae0bf1928f"
drop if parent_key1=="uuid:d0cd220f-bec1-49b8-a3ff-d70f82a3b231"
drop if parent_key1=="uuid:73af0a16-d6f8-4389-b117-2c40d591b806"

keep parent_key marriagegiftamount_indiv
drop if parent_key==""
rename parent_key setofmarriagegroup_o
duplicates drop
save"NEEMSIS2-gift.dta", replace
restore

merge m:1 setofmarriagegroup_o using "NEEMSIS2-gift.dta"
drop if _merge==2
drop _merge

/*
uuid:54cafca1-f001-489b-ab93-c7752a13617a/householdquestionnaireold-hhquestionnaire-marriage-marriagegroup[31]
*/

bysort HHID_panel: egen marriagegiftamount_HH=sum(marriagegiftamount_indiv)

*marriage
bysort HHID_panel: egen marriageexpenses_HH=sum(marriageexpenses)
preserve
duplicates drop HHID_panel, force
tab marriageexpenses_HH


*hh size
keep if livinghome==1 | livinghome==2
gen workingage=0
replace workingage=1 if age>=14
gen _nbworker=1 if workingage==1 & currentlyatschool==0
bysort HHID_panel: egen nbworker=sum(_nbworker)
drop _nbworker
bysort HHID_panel: egen hhsize=sum(1)
gen povertyline=1059*12
gen povertyline_HH=povertyline*hhsize

gen diff_pov_indiv=annualincome_indiv-povertyline
gen below_pov_indiv=.
replace below_pov_indiv=1 if diff_pov_indiv<0
replace below_pov_indiv=0 if diff_pov_indiv>=0

gen diff_pov_HH=annualincome_HH-povertyline_HH
gen below_pov_HH=.
replace below_pov_HH=1 if diff_pov_HH<0
replace below_pov_HH=0 if diff_pov_HH>=0

*
global tokeep ///
businessexpenses educationexpenses marriageexpenses foodexpenses healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses covgenexpenses covexpensesdecrease covexpensesincrease covexpensesstable ///
assets assets_noland annualincome_indiv annualincome_HH ///
labourincome_indiv_agri labourincome_indiv_selfemp labourincome_indiv_sjagri labourincome_indiv_sjnonagri labourincome_indiv_uwhhnonagri labourincome_indiv_uwnonagri labourincome_indiv_uwhhagri labourincome_indiv_uwagri labourincome_HH_agri labourincome_HH_selfemp labourincome_HH_sjagri labourincome_HH_sjnonagri labourincome_HH_uwhhnonagri labourincome_HH_uwnonagri labourincome_HH_uwhhagri labourincome_HH_uwagri ///
mainoccupation_hours_indiv mainoccupation_income_indiv mainoccupation_indiv mainoccupation_HH nboccupation_indiv nboccupation_HH ///
loans_HH loanamount_HH loans_indiv loanamount_indiv marriageloan_indiv marriageloanamount_indiv marriageloan_HH marriageloanamount_HH ///
dummymarriage marriagedowry howpaymarriage marriageexpenses dummymarriagegift husbandwifecaste marriagegiftamount_indiv marriagegiftamount_HH marriageexpenses_HH ///
sizeownland marriagetype marriageblood marriagearranged marriagedecision marriagespousefamily marriagedate marriagepb ///
povertyline povertyline_HH diff_pov_indiv below_pov_indiv diff_pov_HH below_pov_HH nbworker year

keep HHID_panel INDID_panel sex caste jatis age relationshiptohead name panel_2010_2016 panel_2010_2020 panel_2016_2020 panel_2010_2016_2020 villageid livinghome religion edulevel currentlyatschool goldquantity goldquantityamount house howbuyhouse housevalue houseroom housetitle housetype  $tokeep



















save"NEEMSIS2-pov.dta", replace

append using "NEEMSIS1-pov.dta"
append using "RUME-pov.dta"
save"RUME_NEEMSIS1_NEEMSIS2-pov.dta", replace



********** Cleaning
use"RUME_NEEMSIS1_NEEMSIS2-pov.dta", replace

*Marriage using panel data
gen _dummymarriage16=dummymarriage if year==2016
bysort HHID2010: egen dummymarriage16=max(_dummymarriage16)
drop _dummymarriage16

gen _dummymarriage20=dummymarriage if year==2020
bysort HHID2010: egen dummymarriage20=max(_dummymarriage20)
drop _dummymarriage20

tab dummymarriage16 year
tab dummymarriage20 year

*Poverty line
gen poverty=totalincome_HH-povertyline_HH
order totalincome_HH povertyline_HH poverty, last
sort poverty
tab poverty if year==2010  // 22.22
tab poverty if year==2016  // 19.35
tab poverty if year==2020  // 18.92


*Total expenses
gen foodexpenses_annual=foodexpenses*52
foreach x in foodexpenses_annual healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses marriageexpenses_HH {
recode `x' (.=0)
}
egen totalexpenses=rowtotal(foodexpenses_annual healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses marriageexpenses_HH)
tabstat totalexpenses if year==2016, stat(n mean sd q) by(dummymarriage16)
tabstat totalexpenses if year==2020, stat(n mean sd q) by(dummymarriage)

*Delta expenses after marriage
egen expensesnomar=rowtotal(foodexpenses_annual healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses)
gen deltaexpensesmarriage=(totalexpenses-expensesnomar)/expensesnomar

tabstat totalexpenses deltaexpenses if year==2010, stat(n mean sd p50) by(dummymarriage16)
tabstat totalexpenses deltaexpenses if year==2016, stat(n mean sd p50) by(dummymarriage16)
tabstat totalexpenses deltaexpenses if year==2020, stat(n mean sd p50) by(dummymarriage16)


tabstat totalincome_HH if year==2010, stat(n mean sd q) by(dummymarriage16)
tabstat totalincome_HH if year==2016, stat(n mean sd q) by(dummymarriage16)
tabstat totalincome_HH if year==2020, stat(n mean sd q) by(dummymarriage16)

tabstat totalincome_HH if year==2010, stat(n mean sd q) by(dummymarriage20)
tabstat totalincome_HH if year==2016, stat(n mean sd q) by(dummymarriage20)
tabstat totalincome_HH if year==2020, stat(n mean sd q) by(dummymarriage20)


*Income
tabstat totalincome_HH, stat(n mean sd p50) by(year)


*Marriage impact
tabstat totalincome_HH totalexpenses if year==2016, stat(n mean sd q) by(dummymarriage)
tabstat totalincome_HH totalexpenses if year==2020, stat(n mean sd q) by(dummymarriage)
