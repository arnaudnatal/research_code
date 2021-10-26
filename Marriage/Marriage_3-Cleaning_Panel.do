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
*keep if livinghome==1
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

keep HHID_panel livinghome INDID_panel sex caste jatis age relationshiptohead name panel_2010_2016 panel_2010_2020 panel_2016_2020 panel_2010_2016_2020 village villageid living religion edulevel currentlyatschool goldquantity goldquantityamount house howbuyhouse housevalue houseroom housetitle housetype  $tokeep

*keep if panel_2010_2016_2020==1

*bysort HHID_panel: gen n=_n
*keep if n==1
*drop n

*Cleaning de dernière minute
tostring howbuyhouse, replace

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
restore

*gift amount
egen marriagegiftamount_indiv=rowtotal(marriagegiftamount_wellknown marriagegiftamount_shg marriagegiftamount_relatives marriagegiftamount_employer marriagegiftamount_maistry marriagegiftamount_colleagues marriagegiftamount_shopkeeper marriagegiftamount_friends)
bysort HHID_panel: egen marriagegiftamount_HH=sum(marriagegiftamount_indiv)

*hh size
*keep if livinghome==1 | livinghome==2
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
povertyline povertyline_HH diff_pov_indiv below_pov_indiv diff_pov_HH below_pov_HH nbworker year maritalstatus

keep HHID_panel livinghome INDID_panel sex caste jatis age relationshiptohead name panel_2010_2016 panel_2010_2020 panel_2016_2020 panel_2010_2016_2020 villageid livinghome religion edulevel currentlyatschool goldquantity goldquantityamount house howbuyhouse housevalue houseroom housetitle housetype  $tokeep

*keep if panel_2010_2016_2020==1

*bysort HHID_panel: gen n=_n
*keep if n==1
*drop n

*Cleaning de dernière minute
decode howpaymarriage, gen(howpay)
drop howpaymarriage
rename howpay howpaymarriage


save"NEEMSIS1-panel_v1.dta", replace
****************************************
* END









****************************************
* NEEMSIS 2
****************************************
use"NEEMSIS2-HH_v18.dta", replace

*merge panelHH
merge m:1 HHID_panel using "C:\Users\Arnaud\Documents\GitHub\RUME-NEEMSIS\Individual_panel\panel_HH"
keep if _merge==3
drop _merge


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
restore

*hh size
*keep if livinghome==1 | livinghome==2
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
povertyline povertyline_HH diff_pov_indiv below_pov_indiv diff_pov_HH below_pov_HH nbworker year maritalstatusdate marriagedate maritalstatus

keep HHID_panel livinghome INDID_panel sex caste jatis age relationshiptohead name panel_2010_2016 panel_2010_2020 panel_2016_2020 panel_2010_2016_2020 villageid livinghome religion edulevel currentlyatschool goldquantity goldquantityamount house howbuyhouse housevalue houseroom housetitle housetype  $tokeep version_HH


*keep if panel_2010_2016_2020==1

*bysort HHID_panel: gen n=_n
*keep if n==1
*drop n

*Cleaning de dernière minute
foreach x in house housetitle religion howbuyhouse housetype{
destring `x', replace
}


save"NEEMSIS2-panel_v1.dta", replace


append using "NEEMSIS1-panel_v1.dta"
append using "RUME-panel_v1.dta"

order HHID_panel INDID_panel year name sex age jatis caste
sort HHID_panel INDID_panel year

save"RUME_NEEMSIS1_NEEMSIS2.dta", replace
****************************************
* END









****************************************
* Cleaning
****************************************
use"RUME_NEEMSIS1_NEEMSIS2.dta", clear

*Marriage
gen dummy_marriage=0
replace dummy_marriage=1 if marriagedowry!=.

order maritalstatus dummy_marriage maritalstatusdate marriagedate, after(caste)

bysort HHID_panel INDID_panel: egen datemarriage=max(maritalstatusdate)
format datemarriage %td

order maritalstatus version_HH dummy_marriage maritalstatusdate marriagedate datemarriage, after(caste)
*br


*Land
replace sizeownland=land1acres_own+land2acres_own+land3acres_own if year==2010
drop land1acres_own land2acres_own land3acres_own

replace sizeownland=. if sizeownland==0

preserve
egen HHIDyear=concat(HHID_panel year), p(/)
order HHIDyear
duplicates drop HHIDyear, force
tab year
tab sizeownland year
restore

*Order
order HHID_panel INDID_panel year name sex age jatis caste version_HH panel_2010_2016 panel_2016_2020 panel_2010_2020 panel_2010_2016_2020

*Reshape
egen HHINDID=concat(HHID_panel INDID_panel), p(/)
drop panel_2010_2016 panel_2016_2020 panel_2010_2020 panel_2010_2016_2020

replace year=1 if year==2010
replace year=2 if year==2016
replace year=3 if year==2020

rename livinghome2 livinghome_2010_
rename effectcrisisjoblocation2 effectcrisisjoblocation_2010_

reshape wide name sex age jatis caste version_HH maritalstatus dummy_marriage maritalstatusdate marriagedate datemarriage villageid dummymarriage businessexpenses livinghome relationshiptohead currentlyatschool educationexpenses goldquantity religion husbandwifecaste marriagetype marriageblood marriagearranged marriagedecision marriagespousefamily marriagedowry howpaymarriage marriageexpenses dummymarriagegift marriagepb sizeownland foodexpenses healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses covgenexpenses covexpensesdecrease covexpensesincrease covexpensesstable house howbuyhouse housevalue housetype houseroom housetitle mainoccupation_hours_indiv mainoccupation_income_indiv mainoccupation_indiv annualincome_indiv nboccupation_indiv labourincome_indiv_agri labourincome_indiv_selfemp labourincome_indiv_sjagri labourincome_indiv_sjnonagri labourincome_indiv_uwhhnonagri labourincome_indiv_uwnonagri labourincome_indiv_uwhhagri labourincome_indiv_uwagri mainoccupation_HH annualincome_HH nboccupation_HH labourincome_HH_agri labourincome_HH_selfemp labourincome_HH_sjagri labourincome_HH_sjnonagri labourincome_HH_uwhhnonagri labourincome_HH_uwnonagri labourincome_HH_uwhhagri labourincome_HH_uwagri edulevel goldquantityamount assets assets_noland marriageloan_indiv marriageloanamount_indiv loans_indiv loanamount_indiv marriageloan_HH marriageloanamount_HH loans_HH loanamount_HH marriagegiftamount_indiv marriagegiftamount_HH marriageexpenses_HH nbworker povertyline povertyline_HH diff_pov_indiv below_pov_indiv diff_pov_HH below_pov_HH dummydemonetisation demoexpenses loanamount_wm_indiv loanamount_wm_HH village living livinghome_2010_ dummylivestockexpenses mainoccupationname_indiv labourincome_indiv_coolie labourincome_indiv_agricoolie labourincome_indiv_nregs labourincome_indiv_investment labourincome_indiv_employee labourincome_indiv_pension labourincome_indiv_nooccup labourincome_HH_coolie labourincome_HH_agricoolie labourincome_HH_nregs labourincome_HH_investment labourincome_HH_employee labourincome_HH_pension labourincome_HH_nooccup effectcrisislostjob effectcrisislesswork effectcrisiskindofwork effectcrisisjoblocation effectcrisisjoblocation_2010_, i(HHINDID) j(year)

dropmiss, force

order HHINDID HHID_panel INDID_panel

*merge panelHH
merge m:1 HHID_panel using "C:\Users\Arnaud\Documents\GitHub\RUME-NEEMSIS\Individual_panel\panel_HH"
keep if _merge==3
drop _merge

save"RUME_NEEMSIS1_NEEMSIS2_v1.dta", replace

keep if panel_2010_2016_2020==1

tab1 dummy_marriage1 dummy_marriage2 dummy_marriage3
bysort HHID_panel: egen dummy_marriage_2016_HH=sum(dummy_marriage2)
bysort HHID_panel: egen dummy_marriage_2020_HH=sum(dummy_marriage3)

egen todrop=rowtotal(dummy_marriage_2016_HH dummy_marriage_2020_HH)
rename todrop marriage

gen dummy_marriage_HH=0
replace dummy_marriage_HH=1 if marriage!=0

clonevar dummy_marriage2_2016_HH=dummy_marriage_2016_HH
replace dummy_marriage2_2016_HH=1 if dummy_marriage2_2016_HH>1

preserve
duplicates drop HHID_panel, force
tab dummy_marriage_HH
tab dummy_marriage2_2016_HH
tabstat annualincome_HH1 annualincome_HH2 annualincome_HH3, stat(n mean sd p50) by(dummy_marriage_HH)
tabstat assets1 assets2 assets3, stat(n mean sd p50) by(dummy_marriage_HH)
restore




***Life cycle test
tab relationshiptohead1, gen(relationshiptohead2010_)
fre relationshiptohead1

foreach x in relationshiptohead2010_5 relationshiptohead2010_6 relationshiptohead2010_7 relationshiptohead2010_8 {
bysort HHID_panel: egen `x'_HH=sum(`x')
}

/*
Les filles sont forcément célib car une fois mariées elles vont vivre dans la famille du mec
Par contre, comment savoir si les fils le sont ?
Je peux faire le ratio de son et de daughter in law !
*/
fre relationshiptohead1
gen unmarriedson_HH=relationshiptohead2010_5_HH-relationshiptohead2010_8_HH
replace unmarriedson_HH=0 if unmarriedson_HH<0

preserve
duplicates drop HHID_panel, force
tab unmarriedson_HH
restore

*Les filles du coup?
gen daughterage=.
replace daughterage=1 if relationshiptohead2010_6==1 & age1<14
replace daughterage=2 if relationshiptohead2010_6==1 & age1>=12 & age1<18
replace daughterage=3 if relationshiptohead2010_6==1 & age1>=18 & age1<25
replace daughterage=4 if relationshiptohead2010_6==1 & age1>=25 & age1<35
replace daughterage=5 if relationshiptohead2010_6==1 & age1>=35

tab daughterage
tab relationshiptohead2010_6

tab daughterage, gen(daughterage_)

foreach x in daughterage_1 daughterage_2 daughterage_3 daughterage_4 daughterage_5 {
bysort HHID_panel: egen `x'_HH=sum(`x')
}


***Tout en relatif au cas où
foreach i in 1 2 3{
gen ok`i'=0
}
foreach i in 1 2 3{
replace ok`i'=1 if name`i'!="" 
}

foreach i in 1 2 3{
bysort HHID_panel: egen largeHHsize`i'=sum(ok`i')
}

foreach x in unmarriedson_HH daughterage_1_HH daughterage_2_HH daughterage_3_HH daughterage_4_HH daughterage_5_HH {
gen rel_`x'=`x'*100/largeHHsize1
}

***Vision 
foreach x in unmarriedson_HH daughterage_1_HH daughterage_2_HH daughterage_3_HH daughterage_4_HH daughterage_5_HH {
tab `x' dummy_marriage_HH, col nofreq
}

preserve
duplicates drop HHID_panel, force
*tabstat rel_unmarriedson_HH rel_daughterage_1_HH rel_daughterage_2_HH rel_daughterage_3_HH rel_daughterage_4_HH rel_daughterage_5_HH, stat(min p1 p5 p10 q p90 p95 p99 max) by(dummy_marriage_HH) long

tabstat rel_unmarriedson_HH rel_daughterage_1_HH rel_daughterage_2_HH rel_daughterage_3_HH rel_daughterage_4_HH rel_daughterage_5_HH, stat(min p1 p5 p10 q p90 p95 p99 max) by(dummy_marriage2_2016_HH) long


/*
Bon, ce n'est vraiment pas du tout la même structure au départ :
Ceux qui n'ont pas vécu de mariage entre 2010 et 2016 ont un poil moins de fils non mariés que les autres (la part que les fils non mariés rpz dans le HH total): dans 25% des HH, ils rpz au max 17% des mb alors que dans les 25% des HH de ceux ayant eu un mariage, ils rpz au max 20%.

Les petites filles (-14) sont un poil plus nombreuses chez ceux n'ayant pas vécu de mariage

Les filles qui ont presque l'age de se marier (14-18), sont plus nombreuses chez les HH ayant vécu un mariage

Les filles qui ont l'age de se marier (18-25), elles sont plus nombreuses 

*/

*Boxplot?
/*
set graph off
foreach x in rel_unmarriedson_HH rel_daughterage_1_HH rel_daughterage_2_HH rel_daughterage_3_HH rel_daughterage_4_HH rel_daughterage_5_HH {
stripplot `x', over(dummy_marriage_HH) separate() ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(10)100) ymtick(0(5)100) ytitle() ///
msymbol(oh oh) ///
name(g_`x', replace)
}
set graph on
grc1leg g_rel_unmarriedson_HH g_rel_daughterage_1_HH g_rel_daughterage_2_HH g_rel_daughterage_3_HH g_rel_daughterage_4_HH g_rel_daughterage_5_HH, name(g_comb, replace)
*/

*Kernel?
/*
set graph off
foreach x in rel_unmarriedson_HH rel_daughterage_1_HH rel_daughterage_2_HH rel_daughterage_3_HH rel_daughterage_4_HH rel_daughterage_5_HH {
twoway ///
(kdensity `x' if dummy_marriage_HH==0, bwidth(1)) ///
(kdensity `x' if dummy_marriage_HH==1, bwidth(1)) ///
, legend(order(1 "No marriage" 2 "Marriage"))name(g_`x', replace)
}
set graph on
grc1leg g_rel_unmarriedson_HH g_rel_daughterage_1_HH g_rel_daughterage_2_HH g_rel_daughterage_3_HH g_rel_daughterage_4_HH g_rel_daughterage_5_HH, name(g_comb, replace)
*/

restore

save"RUME_NEEMSIS1_NEEMSIS2_v2.dta", replace
****************************************
* END









****************************************
* Cleaning
****************************************
use"RUME_NEEMSIS1_NEEMSIS2_v2", clear
*keep if dummy_marriage_HH==1
duplicates drop HHID_panel, force

foreach x in annualincome_HH1 annualincome_HH2 annualincome_HH3 assets1 assets2 assets3 loanamount_HH1 loanamount_HH2 loanamount_HH3 {
gen `x'_1000=`x'/1000
}

*CPI WB: 2016=100/155, 2020=184/100
foreach x in annualincome_HH assets loanamount_HH {
replace `x'2_1000=`x'2_1000*0.644405
replace `x'3_1000=`x'3_1000*0.542508
}

tabstat annualincome_HH1_1000 annualincome_HH2_1000 annualincome_HH3_1000 assets1_1000 assets2_1000 assets3_1000 loanamount_HH1_1000 loanamount_HH2_1000 loanamount_HH3_1000, stat(n mean sd p50) by(dummy_marriage2_2016_HH)
****************************************
* END









****************************************
* Cleaning
****************************************
use"RUME_NEEMSIS1_NEEMSIS2_v1", clear

*Cleaning
tab1 dummy_marriage1 dummy_marriage2 dummy_marriage3
bysort HHID_panel: egen dummy_marriage_2016_HH=sum(dummy_marriage2)
bysort HHID_panel: egen dummy_marriage_2020_HH=sum(dummy_marriage3)

egen todrop=rowtotal(dummy_marriage_2016_HH dummy_marriage_2020_HH)
rename todrop marriage

gen dummy_marriage_HH=0
replace dummy_marriage_HH=1 if marriage!=0

clonevar dummy_marriage2_2016_HH=dummy_marriage_2016_HH
replace dummy_marriage2_2016_HH=1 if dummy_marriage2_2016_HH>1

keep if dummy_marriage_HH==1

tab marriagedowry2

*Expeses ratio
gen expensestoincome2=marriageexpenses2/annualincome_HH2
gen expensestoincome3=marriageexpenses3/annualincome_HH3
gen expensestoassets2=marriageexpenses2/assets2
gen expensestoassets3=marriageexpenses3/assets3


*howpaymarriage
/*
1 Loan
2 Own capital
3 Gift
4 Both
*/
tab howpaymarriage3
replace howpaymarriage3="4" if howpaymarriage3=="1 2"
replace howpaymarriage3="4" if howpaymarriage3=="1 2 3"
replace howpaymarriage3="4" if howpaymarriage3=="2 3"
replace howpaymarriage3="4" if howpaymarriage3=="2 4"
destring howpaymarriage3, replace
recode howpaymarriage3 (4=3)
tab howpaymarriage3
label define howpaymarriage 1"Loan" 2"Capital" 3"Both"
label values howpaymarriage3 howpaymarriage

tab howpaymarriage2
replace howpaymarriage2="1" if howpaymarriage2=="Loan"
replace howpaymarriage2="2" if howpaymarriage2=="Own capital / Savings"
replace howpaymarriage2="3" if howpaymarriage2=="Both"
destring howpaymarriage2, replace
label values howpaymarriage2 howpaymarriage

fre howpaymarriage2 howpaymarriage3

*Deflater les montants
gen loanstoincome2=marriageloanamount_HH2/annualincome_HH2
gen loanstoincome3=marriageloanamount_HH3/annualincome_HH3
gen loanstoassets2=marriageloanamount_HH2/assets2
gen loanstoassets3=marriageloanamount_HH3/assets3



**********Analysis
*Howpaymarriage?
tab1 howpaymarriage2 howpaymarriage3

*Expenses
tabstat expensestoincome2 expensestoincome3 expensestoassets2 expensestoassets3, stat(n mean sd p50) by(caste2)

*Loans 2016
preserve
duplicates drop HHID_panel, force
keep if dummy_marriage_2016_HH==1
tabstat loanstoincome2 loanstoassets2, stat(n mean sd p50) by(caste2)
restore

*Loans 2020
preserve
duplicates drop HHID_panel, force
keep if dummy_marriage_2020_HH==1
tabstat loanstoincome3 loanstoassets3, stat(n mean sd p50) by(caste2)
restore






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
