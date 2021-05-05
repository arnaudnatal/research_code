/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
20 avril 2021
-----
TITLE: CLEANING MARRIAGE NEEMSIS2


-------------------------
*/

clear all
global directory "D:\Documents\_Thesis\Research-Marriage\Data"
cd"$directory\NEEMSIS2"




****************************************
* HH database cleaning
****************************************

********** First: recreate the old one
use "$directory\NEEMSIS2\NEEMSIS2-HH_v16.dta", clear
split setofmarriagegroup, p([)
gen cro1="["
gen cro2="]"
rename setofmarriagegroup setofmarriagegroup_new
egen setofmarriagegroup=concat(setofmarriagegroup1 cro1 old_marriedid cro2)
drop setofmarriagegroup1 setofmarriagegroup2 cro1 cro2
order setofmarriagegroup setofmarriagegroup_new, last
replace setofmarriagegroup="" if substr(setofmarriagegroup,strlen(setofmarriagegroup)-1,1)=="."
preserve
keep if setofmarriagegroup!=""
sort setofmarriagegroup
restore



********** How much HH concern?
preserve
bysort HHID2010: gen n=_n
keep if n==1
tab dummymarriage  // 90 HH face one marriage or more between 2016 and 2020
tab marriedlist if marriedlist!="." & marriedlist!=""
restore




********** 2010 maybe?
gen m2010=0
replace m2010=1 if maritalstatusdate>td(01jan2010) & maritalstatusdate<td(01jan2017)
bysort HHID2010: egen dummymarriage2010=max(m2010)
drop m2010



********** Keep the HH
keep if dummymarriage==1 | dummymarriage2010==1


********** Intermediate saving
save"NEEMSIS2-marriage.dta", replace


/*
********** Marriage "panel"
preserve
keep if husbandwifecaste!=.
save"$directory\complet\NEEMSIS2-marriage_v1.dta", replace
save"$directory\NEEMSIS2\NEEMSIS2-marriage_v1.dta", replace
restore
*/



********* Merge gift
use "$directory\NEEMSIS2\NEEMSIS_APPEND-marriagegift.dta", clear
* Clean
rename parent_key setofmarriagegroup
split key,p(/)
rename key1 parent_key
drop key2 key3 key
drop if parent_key=="uuid:2cca6f5f-3ecb-4088-b73f-1ecd9586690d"
drop if parent_key=="uuid:1ea7523b-cad1-44da-9afa-8c4f96189433"
drop if parent_key=="uuid:b283cb62-a316-418a-80b5-b8fe86585ef8"
drop if parent_key=="uuid:5a19b036-4004-4c71-9e2a-b4efd3572cf3"
drop if parent_key=="uuid:7fc65842-447f-4b1d-806a-863556d03ed3"
drop if parent_key=="uuid:9b931ac2-ef49-43e9-90cd-33ae0bf1928f"
drop if parent_key=="uuid:d0cd220f-bec1-49b8-a3ff-d70f82a3b231"
keep if marriagegiftsourcenb!=.
* Merge
merge m:m setofmarriagegroup using "$directory\NEEMSIS2\NEEMSIS2-marriage.dta", keepusing(INDID2010 householdid2020 INDID age sex egoid caste jatis marriagedate marriedid setofmarriagegroup_new)
drop if _merge==2
drop _merge
* CLeaning
egen INDID2020=concat(householdid2020 INDID), p(/)
rename marriagegifttype_1 marriagegifttype_gold
rename marriagegifttype_2 marriagegifttype_cash
rename marriagegifttype_3 marriagegifttype_clothes
rename marriagegifttype_4 marriagegifttype_furniture
rename marriagegifttype_5 marriagegifttype_vessels
rename marriagegifttype_77 marriagegifttype_other
drop marriagegiftsourcename
destring marriagegiftsourceid, gen(marriagegiftsource)
label define giftsource 1"WKP" 2"Relatives" 3"Employer" 4"Maistry" 5"Colleague" 6"Paw broker" 7"Shop keeper" 8"Finance" 9"Friends" 10"SHG" 11"Banks" 12"Coop bank" 13"Sugar mill loan" 14"Group finance"
label values marriagegiftsource giftsource
drop marriagegiftsourceid
order householdid2020 INDID INDID2020 INDID2010 egoid jatis sex age caste married marriagedate marriagegiftsource marriagegiftsourcenb marriagegifttype marriagegifttype_gold marriagegifttype_cash marriagegifttype_clothes marriagegifttype_furniture marriagegifttype_vessels marriagegifttype_other marriagegiftamount marriagegoldquantityasgift, first
drop setofmarriagegift forauto

save"$directory\NEEMSIS2\NEEMSIS_APPEND-marriagegift_v2.dta", replace
*Indiv level
bysort INDID2020: egen totalmarriagegiftamount=sum(marriagegiftamount)
bysort INDID2020: gen n=_n
keep if n==1
keep INDID2020 totalmarriagegiftamount
save"$directory\NEEMSIS2\NEEMSIS_APPEND-marriagegift_v2_indiv.dta", replace


use"$directory\NEEMSIS2\NEEMSIS2-marriage.dta", clear
egen INDID2020=concat(householdid2020 INDID), p(/)

merge 1:m INDID2020 using "$directory\NEEMSIS2\NEEMSIS_APPEND-marriagegift_v2_indiv.dta"
drop if _merge==2
drop _merge


save"$directory\NEEMSIS2\NEEMSIS2-marriage_v2.dta", replace
*save"$directory\complet\NEEMSIS2-marriage_v3.dta", replace
****************************************
* END















****************************************
* Cleaning
****************************************
use"$directory\NEEMSIS2\NEEMSIS2-marriage_v2.dta", clear

********** Husband wife caste
tab husbandwifecaste
gen hwcaste_group=.
foreach x in 2 3{
replace hwcaste_group=1 if husbandwifecaste==`x'
}
foreach x in 1 5 7 8 10 12 15 16{
replace hwcaste_group=2 if husbandwifecaste==`x'
}
foreach x in 4 6 11 13 17{
replace hwcaste_group=3 if husbandwifecaste==`x'
}
label values hwcaste_group castecat
rename hwcaste_group hwcaste
tab hwcaste caste, m






********** How pay marriage?
tab howpaymarriage
replace howpaymarriage="Loan" if howpaymarriage=="1"
replace howpaymarriage="Own capital / Savings" if howpaymarriage=="2"
replace howpaymarriage="Both" if howpaymarriage=="4"
replace howpaymarriage="Both" if howpaymarriage=="1 2"
replace howpaymarriage="Both & gift" if howpaymarriage=="1 2 3"
replace howpaymarriage="Both & gift" if howpaymarriage=="2 3"
replace howpaymarriage="Both" if howpaymarriage=="2 4"
tab howpaymarriage
gen howpaymarriage_loan=0
gen howpaymarriage_capital=0
gen howpaymarriage_gift=0
replace howpaymarriage_loan=1 if howpaymarriage=="Loan"
replace howpaymarriage_loan=1 if howpaymarriage=="Both"
replace howpaymarriage_loan=1 if howpaymarriage=="Both & gift"
replace howpaymarriage_capital=1 if howpaymarriage=="Own capital / Savings"
replace howpaymarriage_capital=1 if howpaymarriage=="Both"
replace howpaymarriage_capital=1 if howpaymarriage=="Both & gift"
replace howpaymarriage_gift=1 if howpaymarriage=="Both & gift"
tab1 howpaymarriage_loan howpaymarriage_capital howpaymarriage_gift
drop howpaymarriage



********** Date
gen datecovid=.
replace datecovid=1 if marriagedate<td(24mar2020)  // before lockdown
replace datecovid=2 if marriagedate>=td(24mar2020) & marriagedate<=td(31may2020)  // during lockdown
replace datecovid=3 if marriagedate>td(31may2020) & marriagedate<=td(01sep2020) // post 1
replace datecovid=4 if marriagedate>td(01sep2020) & marriagedate!=.
tab marriagedate datecovid




********** Age at marriage
tab age
gen yearborn1=yofd(dofc(submissiondate))
gen yearborn=yearborn1-age
gen yearmarriage=year(marriagedate)
gen ageatmarriage=yearmarriage-yearborn
drop yearborn1 yearborn yearmarriage
order marriagedowry marriagedate age sex ageatmarriage, last
tab ageatmarriage
sort ageatmarriage


********** Decision making
fre marriagedecision
gen marriagedecision_rec=.
replace marriagedecision_rec=1 if marriagedecision==1
replace marriagedecision_rec=2 if marriagedecision==2
replace marriagedecision_rec=3 if marriagedecision>=3 & marriagedecision!=.
fre marriagedecision_rec





********** Marriage decision
/*
forvalues i=1(1)19{
gen _todrop_relation_INDID_`i'=.
}

forvalues i=1(1)19{
replace _todrop_relation_INDID_`i'=relationshiptohead if INDID==`i'
}
forvalues i=1(1)19{
bysort HHID2010: egen relation_INDID_`i'=max(_todrop_relation_INDID_`i')
}
drop _todrop_*

gen marriagedecisionrelation=.
forvalues i=1(1)19{
replace marriagedecisionrelation=relation_INDID_`i' if marriagedecision==`i'
}
tab marriagedecisionrelation
tab marriagedecision
label values marriagedecisionrelation relationshiptohead
tab marriagedecisionrelation relationshiptohead
fre marriagedecisionrelation
gen marriagedecision_cat=1 if marriagedecisionrelation==1
foreach x in 2 3 4{
replace marriagedecision_cat=2 if marriagedecisionrelation==`x'
}
foreach x in 5 8 13{
replace marriagedecision_cat=3 if marriagedecisionrelation==`x'
}
label define marriagedecision_cat 1"Head" 2"Wife, grand parents" 3"Personal choice"
label values marriagedecision_cat marriagedecision_cat
fre marriagedecision_cat
*/



save"$directory\NEEMSIS2\NEEMSIS2-marriage_v3.dta", replace
****************************************
* END


























****************************************
* Coherence
****************************************
use"$directory\NEEMSIS2\NEEMSIS2-marriage_v3.dta", clear
drop INDID2010
egen INDID2010=concat(HHID2010 INDID), p(/)


********** Coherence amount
tab marriagetotalcost 
*plot marriagetotalcost1000 peoplewedding
/*
    1800 +  
    m    |                                                *
    a    |  
    r    |  
    r    |  
    i    |  
    a    |  
    g    |  
    e    |                                                *
    t    |  
    o    |                   *
    t    |                      *         *
    a    |                                *               *                *
    l    |      *         *     *         *               *
    c    |      *               *                                          *
    o    |           *    *                               *
    s    |    * **
    t    | ** * *  *  *                   *
    1    | ** * **
    0    |  * *
      10 + ** * ** *
          +----------------------------------------------------------------+
               40    How many people attended the ${marriedna        2000
*/
*twoway (scatter marriagetotalcost1000 peoplewedding, legend(off) ytitle("Marriage total cost (1,000 INR)")) (lfit marriagetotalcost1000 peoplewedding)







********** Coherence husband--wife
gen husbandwifecost=marriagetotalcost-(marriagewifecost+marriagehusbandcost)
tab husbandwifecost
*18 case to check here

list HHID2010 INDID old_marriedid sex caste hwcaste marriagewifecost marriagehusbandcost marriagetotalcost marriageexpenses if husbandwifecost!=0, clean noobs
/*
     HHID2010   INDID   old_ma~d      sex    caste   hwcaste       wife    husband      total   expenses  
           26       3         31   Female   Dalits    Dalits      50000      50000     250000          .  pb somme ?
           71       3         31   Female   Dalits    Dalits     550000     500000    1000000      50000  pb somme ?
      ANTMP37       3         31   Female   Middle    Middle      30000      50000      50000          .  pb somme ?
      ANTMP39       3          3     Male   Middle    Middle      50000      75000     150000          .  pb somme ?
    PSKARU262       3          3     Male   Dalits    Dalits      90000      30000     200000     100000  pb somme & husband ?
     PSKOR200       3          3     Male   Middle    Middle     100000      75000     100000      35000  pb somme ?
      PSKU134      16         16   Female   Dalits    Dalits     100000     150000     400000          .  pb somme ?
      PSOR390      16         16   Female   Dalits    Dalits      15800     100000     100000          .  pb somme ?
       RAEP69       4         31   Female   Dalits    Dalits     100000     100000     250000          .  pb somme ?
    RAKARU258       3         31   Female   Dalits    Dalits     250000     100000     250000     150000  pb somme ?
     RAKOR211       4          4     Male   Dalits    Dalits     100000     250000     250000          .  pb somme ?
      RAOR379       4         31     Male   Dalits    Dalits      50000      50000     200000          .  pb somme ?
     SIKOR217       3          3     Male    Upper    Middle     500000     500000     500000     500000  pb somme ?
      SIKU155       3          3     Male   Dalits    Dalits      50000      75000     150000          .  pb somme ?
      SIKU158       3          3     Male   Dalits    Dalits      50000     100080     200000          .  pb somme ?
    VENKOR219       2         31   Female   Dalits    Dalits     200000     150000     200000       5000  pb somme ?
    VENMTP315      16         16   Female   Dalits    Dalits      20000      50000     300000     200000  pb wife & pb husband ? 
    VENSEM115       3          3     Male   Dalits    Dalits     100000      50000     200000      50000  pb somme ?
*/

foreach x in 26/3 71/3 ANTMP37/3 ANTMP39/3 PSKOR200/3 PSKU134/16 PSOR390/16 RAEP69/4 RAKARU258/3 RAKOR211/4 RAOR379/4 SIKOR217/3 SIKU155/3 SIKU158/3 VENKOR219/2 VENSEM115/3{
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if INDID2010=="`x'"
}

replace marriagehusbandcost=marriageexpenses if INDID2010=="PSKARU262/3"
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if INDID2010=="PSKARU262/3"

replace marriagewifecost=marriageexpenses if INDID2010=="VENMTP315/16"
replace marriagetotalcost=marriagewifecost+marriagehusbandcost if INDID2010=="VENMTP315/16"

drop husbandwifecost
gen husbandwifecost=marriagetotalcost-(marriagewifecost+marriagehusbandcost)
tab husbandwifecost
drop husbandwifecost






********** Coherence expenses--cost for male
fre sex
gen husb_expensescost=marriageexpenses-marriagehusbandcost if sex==1
tab husb_expensescost
*4 case to check here

list HHID2010 INDID old_marriedid sex caste hwcaste marriagewifecost marriagehusbandcost marriagetotalcost marriageexpenses if husb_expensescost>0 & husb_expensescost!=., clean noobs
/*
    HHID2010   INDID   old_ma~d    sex    caste   hwcaste       wife    husband      total   expenses  
    ANTGP162       3         31   Male    Upper    Middle      50000      50000     100000     100000  
     PSSEM93       3         31   Male   Middle    Middle     200000     100000     300000     300000  
    RAMTP302       3          3   Male   Dalits    Dalits      50000      50000     100000     100000  
    SIMTP293       3          3   Male    Upper     Upper      50000      50000     100000     100000  
*/
foreach x in ANTGP162/3 PSSEM93/3 RAMTP302/3 SIMTP293/3{
replace marriageexpenses=marriagehusbandcost if INDID2010=="`x'"
}

drop husb_expensescost
gen husb_expensescost=marriageexpenses-marriagehusbandcost if sex==1
tab husb_expensescost
drop husb_expensescost




********** Coherence expenses--cost for female
gen wife_expensescost=marriageexpenses-marriagewifecost if sex==2
tab wife_expensescost
*5 case to check here

list HHID2010 INDID old_marriedid sex caste hwcaste marriagewifecost marriagehusbandcost marriagetotalcost marriageexpenses if wife_expensescost>0 & wife_expensescost!=., clean noobs
/*
    HHID2010   INDID   old_ma~d      sex    caste   hwcaste       wife    husband      total   expenses  
          55       3         31   Female   Middle    Middle       5000       5000      10000      10000  
           7       4         31   Female   Middle    Middle          0     600000     600000     600000  
    RAMTP298       3         31   Female   Dalits    Middle          0     200000     200000     190000  
    RANAT342      16         16   Female   Dalits    Dalits     100000     100000     200000     200000 
*/
foreach x in 55/3 7/4 RAMTP298/3 RANAT342/16{
replace marriageexpenses=marriagewifecost if INDID2010=="`x'"
}

drop wife_expensescost
gen wife_expensescost=marriageexpenses-marriagewifecost if sex==2
tab wife_expensescost
drop wife_expensescost






********** Engagement wife--husband
gen husbandwifeenga=engagementtotalcost-(engagementwifecost+engagementhusbandcost)
tab husbandwifeenga
*13 case to check here

list HHID2010 INDID old_marriedid sex caste hwcaste engagementwifecost engagementhusbandcost engagementtotalcost if husbandwifeenga!=0, clean noobs
/*
     HHID2010   INDID   old_ma~d      sex    caste   hwcaste   en~ecost   en~dcost   en~lcost  
           26       3         31   Female   Dalits    Dalits      50000     100000     100000  pb somme ?
           29      16         16   Female   Dalits    Dalits      80000      10000      80000  pb somme ?
      ANTMP37       3         31   Female   Middle    Middle     100000      75000     200000  pb somme ?
      ANTMP39       3          3     Male   Middle    Middle      50000      50000     200000  pb somme ?
     PSKOR200       3          3     Male   Middle    Middle      20000      25000      30000  pb somme ?
       RAEP69       4         31   Female   Dalits    Dalits      50000      25000      50000  pb somme ?
    RAKARU258       3         31   Female   Dalits    Dalits      50000      35000     200000  pb somme ?
     RAKOR211       4          4     Male   Dalits    Dalits     100000     100000     150000  pb somme ?
     SIKOR217       3          3     Male    Upper    Middle     200000     200000     200000  pb somme ?
      SIKU155       3          3     Male   Dalits    Dalits      65000      50000     175000  pb somme ?
      SIKU158       3          3     Male   Dalits    Dalits      50000      50000      50000  pb somme ?
    VENKOR219       2         31   Female   Dalits    Dalits      30000      50000      50000  pb somme ?
    VENMTP315      16         16   Female   Dalits    Dalits      20000      25000      25000  pb somme ?
*/
foreach x in 26/3 29/16 ANTMP37/3 ANTMP39/3 PSKOR200/3 RAEP69/4 RAKARU258/3 RAKOR211/4 SIKOR217/3 SIKU155/3 SIKU158/3 VENKOR219/2 VENMTP315/16{
replace engagementtotalcost=engagementwifecost+engagementhusbandcost if INDID2010=="`x'"
}

drop husbandwifeenga
gen husbandwifeenga=engagementtotalcost-(engagementwifecost+engagementhusbandcost)
tab husbandwifeenga
drop husbandwifeenga

save"$directory\NEEMSIS2\NEEMSIS2-marriage_v4.dta", replace
****************************************
* END






****************************************
* Network for marriage
****************************************
use"$directory\NEEMSIS2\NEEMSIS2-marriage_v4.dta", clear

********** Egoid var
preserve
keep if egoid>0
keep assodegreeparticip_shg assodegreeparticip_trade assodegreeparticip_farmer assodegreeparticip_village assodegreeparticip_politic assodegreeparticip_profess assodegreeparticip_hobby assodegreeparticip_other assosize_shg assosize_trade assosize_farmer assosize_village assosize_politic assosize_profess assosize_hobby assosize_other nbcontact_headbusiness nbcontact_policeman nbcontact_civilserv nbcontact_bankemployee nbcontact_panchayatcommittee nbcontact_peoplecouncil nbcontact_recruiter nbcontact_headunion nbercontactphone nberpersonfamilyevent dummycontactleaders contactleaders parent_key egoid
reshape wide assodegreeparticip_shg assodegreeparticip_trade assodegreeparticip_farmer assodegreeparticip_village assodegreeparticip_politic assodegreeparticip_profess assodegreeparticip_hobby assodegreeparticip_other assosize_shg assosize_trade assosize_farmer assosize_village assosize_politic assosize_profess assosize_hobby assosize_other nbcontact_headbusiness nbcontact_policeman nbcontact_civilserv nbcontact_bankemployee nbcontact_panchayatcommittee nbcontact_peoplecouncil nbcontact_recruiter nbcontact_headunion nbercontactphone nberpersonfamilyevent dummycontactleaders contactleaders, i(parent_key) j(egoid)
save"$directory\NEEMSIS2\NEEMSIS2-asso_contact_HH.dta", replace
restore

merge m:1 parent_key using "$directory\NEEMSIS2\NEEMSIS2-asso_contact_HH.dta"
keep if _merge==3
drop _merge
keep if husbandwifecaste!=.
dropmiss, force

save"$directory\NEEMSIS2\NEEMSIS2-marriage_v5.dta", replace
****************************************
* END











****************************************
* Creation
****************************************
use"$directory\NEEMSIS2\NEEMSIS2-marriage_v5.dta", clear


********* 1000 var
foreach x in marriagedowry engagementtotalcost engagementhusbandcost engagementwifecost marriagetotalcost marriagehusbandcost marriagewifecost marriageexpenses{
gen `x'1000=`x'/1000
}







********** On assets
*
gen MEAR=marriageexpenses/assets
*
gen MCAR=.
replace MCAR=marriagehusbandcost/assets if sex==1
replace MCAR=marriagewifecost/assets if sex==2
*
gen ECAR=.
replace ECAR=engagementhusbandcost/assets if sex==1
replace ECAR=engagementwifecost/assets if sex==2
*
gen DAAR=.
replace DAAR=marriagedowry/assets if sex==2






********** On income
*
gen MEIR=marriageexpenses/totalincome_HH
*
gen MCIR=.
replace MCIR=marriagehusbandcost/totalincome_HH if sex==1
replace MCIR=marriagewifecost/totalincome_HH if sex==2
*
gen ECIR=.
replace ECIR=engagementhusbandcost/totalincome_HH if sex==1
replace ECIR=engagementwifecost/totalincome_HH if sex==2
*
gen DAIR=.
replace DAIR=marriagedowry/totalincome_HH if sex==2







********** On cost
*
gen MEMC=.
replace MEMC=marriageexpenses/marriagehusbandcost if sex==1
replace MEMC=marriageexpenses/marriagewifecost if sex==2
*
gen DMC=.
replace DMC=marriagedowry/marriagetotalcost







********** Total cost
*Total cost of marriage: engagement, marriage and dowry
gen husbtotalcost1000=.
gen wifetotalcost1000=.
gen totalcost1000=.
replace husbtotalcost1000=(engagementhusbandcost+marriagehusbandcost)/1000
replace wifetotalcost1000=(engagementwifecost+marriagewifecost+marriagedowry)/1000
replace totalcost1000=(engagementtotalcost+marriagetotalcost+marriagedowry)/1000
*Total cost on assets and income
gen TCAR=.
replace TCAR=(husbtotalcost1000*1000)/assets if sex==1
replace TCAR=(wifetotalcost1000*1000)/assets if sex==2

gen TCIR=.
replace TCIR=(husbtotalcost1000*1000)/totalincome_HH if sex==1
replace TCIR=(wifetotalcost1000*1000)/totalincome_HH if sex==2







********* Share
gen husbandsharemarriage=marriagehusbandcost/marriagetotalcost
gen wifesharemarriage=marriagewifecost/marriagetotalcost
gen husbandshareengagement=engagementhusbandcost/engagementtotalcost
gen wifeshareengagement=engagementwifecost/engagementtotalcost

gen testmar=husbandsharemarriage+wifesharemarriage
gen testenga=husbandshareengagement+wifeshareengagement

tab1 testmar testenga
drop testmar testenga

gen husbandsharetotal=husbtotalcost1000/totalcost1000
gen wifesharetotal=wifetotalcost1000/totalcost1000

gen testtotal=husbandsharetotal+wifesharetotal
tab testtotal
drop testtotal








********** Total cost and dowry
gen DWTC=.
replace DWTC=marriagedowry1000/wifetotalcost1000

gen DWTCnodowry=.
replace DWTCnodowry=marriagedowry1000/(engagementwifecost1000+marriagewifecost1000)









********** Intercaste marriage
gen intercaste=0 if hwcaste==caste
replace intercaste=1 if hwcaste!=caste






********** Gift
gen gifttoexpenses=totalmarriagegiftamount/marriageexpenses
gen gifttocost=.
replace gifttocost=totalmarriagegiftamount/marriagehusbandcost if sex==1
replace gifttocost=totalmarriagegiftamount/marriagewifecost if sex==2


gen benefitscost=0
replace benefitscost=1 if gifttocost>1 & gifttocost!=.
tab1 gifttocost benefitscost

gen benefitsexpenses=0
replace benefitsexpenses=1 if gifttoexpenses>1 & gifttoexpenses!=.
tab1 gifttoexpenses benefitsexpenses





********** Net benefits of marriage
clonevar totalmarriagegiftamount_recode=totalmarriagegiftamount
recode totalmarriagegiftamount_recode (.=0)
gen netbenefitsmarriage1000=.
replace netbenefitsmarriage1000=(marriagedowry+totalmarriagegiftamount_recode-marriagehusbandcost)/1000 if sex==1
replace netbenefitsmarriage1000=(totalmarriagegiftamount_recode-marriagewifecost-marriagedowry)/1000 if sex==2
*Benefits on assets and income
gen BAR=netbenefitsmarriage1000*1000/assets
gen BIR=netbenefitsmarriage1000*1000/totalincome_HH




********** Gift on income and assets
gen GAR=totalmarriagegiftamount/assets
gen GIR=totalmarriagegiftamount/totalincome_HH



save"$directory\NEEMSIS2\NEEMSIS2-marriage_v6.dta", replace
****************************************
* END
