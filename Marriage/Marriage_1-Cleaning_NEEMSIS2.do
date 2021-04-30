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




****************************************
* HH database cleaning
****************************************

********** First: recreate the old one
use "$directory\NEEMSIS2\NEEMSIS2-HH_v15.dta", clear
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


/*
********** Matching
*Composition par sexe et par age
*keep if livinghome==1 | livinghome==2
replace maritalstatus=1 if husbandwifecaste!=.
fre sex

gen male_married=.
gen male_unmarried=.
gen female_married=.
gen female_unmarried=.

replace male_married=1 if sex==1 & maritalstatus==1
replace male_unmarried=1 if sex==1 & maritalstatus>1
replace female_married=1 if sex==2 & maritalstatus==1
replace female_unmarried=1 if sex==2 & maritalstatus>1

gen male_00_18=0
gen male_18_30=0
gen male_30_45=0
gen male_45_99=0

gen female_00_18=0
gen female_18_30=0
gen female_30_45=0
gen female_45_99=0

replace male_00_18=1 if sex==1 & age<18
replace male_18_30=1 if sex==1 & age>18 & age<30
replace male_30_45=1 if sex==1 & age>30 & age<45
replace male_45_99=1 if sex==1 & age>45

replace female_00_18=1 if sex==2 & age<18
replace female_18_30=1 if sex==2 & age>18 & age<30
replace female_30_45=1 if sex==2 & age>30 & age<45
replace female_45_99=1 if sex==2 & age>45


*Richesse
tab assets
tab totalincome_HH

*Worker composition
gen nbemployment=.
gen nbunemployment=.

replace nbemployment=1 if totalincome_indiv>0
replace nbunemployment=1 if totalincome_indiv==0

*HH size
gen size=1

*HH level
foreach x in male_00_18 male_18_30 male_30_45 male_45_99 female_00_18 female_18_30 female_30_45 female_45_99 male_married male_unmarried female_married female_unmarried nbemployment nbunemployment size{
bysort HHID2010: egen HH_`x'=sum(`x') 
drop `x'
}


psmatch2 dummymarriage HH_male_00_18 HH_male_18_30 HH_male_30_45 HH_male_45_99 HH_female_00_18 HH_female_18_30 HH_female_30_45 HH_female_45_99, kernel bwidth(0.0001) common
*Good
pstest HH_male_00_18 HH_male_18_30 HH_male_30_45 HH_male_45_99 HH_female_00_18 HH_female_18_30 HH_female_30_45 HH_female_45_99, treated(dummymarriage) both graph
*/


********** Keep the HH
keep if dummymarriage==1 | dummymarriage2010==1









********** Keep variables
keep parent_key HHID_panel egoid HHID2010 householdid2020 villageid villagearea jatis caste INDID INDID_total INDID_former INDID_new INDID_left egoid name sex age edulevel submissiondate livinghome lefthomereason lefthomedestination relationshiptohead relationshiptoheadother maritalstatus maritalstatusdate dummycastespouse comefromspouse dummyreligionspouse castespouse otheroriginspouse religion everattendedschool reasonneverattendedschool reasondropping currentlyatschool marriedlist_ marriedname peoplewedding husbandwifecaste marriagetype marriageblood marriagearranged marriagedecision marriagespousefamily marriagedowry engagementtotalcost engagementhusbandcost engagementwifecost marriagetotalcost marriagehusbandcost marriagewifecost howpaymarriage marriageloannb marriagefinance_count setofmarriagefinance marriageexpenses dummymarriagegift marriagegiftsource marriagegift_count setofmarriagegift marriagedate marriagesomeoneelse old_marriedid dummy_marriageindivnew schemeslist schemeslist_ cashassistancemarriagegroup_coun setofcashassistancemarriagegroup setofgoldmarriagegroup schemerecipientlist3 schemerecipientlist3_ schemerecipientlist4 schemerecipientlist4_ schemeyearbenefited7 schemeyearbenefited8 schemeamount7 schemeamount8 semiformal_indiv formal_indiv economic_indiv current_indiv humancap_indiv social_indiv house_indiv incomegen_indiv noincomegen_indiv economic_amount_indiv current_amount_indiv humancap_amount_indiv social_amount_indiv house_amount_indiv incomegen_amount_indiv noincomegen_amount_indiv informal_amount_indiv formal_amount_indiv semiformal_amount_indiv marriageloan_indiv marriageloanamount_indiv marriageloan_mar_indiv marriageloanamount_mar_indiv marriageloan_fin_indiv marriageloanamount_fin_indiv dummyproblemtorepay_indiv dummyhelptosettleloan_indiv dummyinterest_indiv loans_indiv loanamount_indiv loanbalance_indiv imp1_ds_tot_HH imp1_is_tot_HH informal_HH semiformal_HH formal_HH economic_HH current_HH humancap_HH social_HH house_HH incomegen_HH noincomegen_HH economic_amount_HH current_amount_HH humancap_amount_HH social_amount_HH house_amount_HH incomegen_amount_HH noincomegen_amount_HH informal_amount_HH formal_amount_HH semiformal_amount_HH marriageloan_HH marriageloanamount_HH marriageloan_mar_HH marriageloanamount_mar_HH marriageloan_fin_HH marriageloanamount_fin_HH dummyproblemtorepay_HH dummyhelptosettleloan_HH dummyinterest_HH loans_HH loanamount_HH loanbalance_HH mainoccupation_hours_indiv mainoccupation_income_indiv mainoccupation_indiv mainoccupationname_indiv totalincome_indiv nboccupation_indiv mainoccupation_HH totalincome_HH nboccupation_HH setofmarriagegroup setofmarriagegroup_new marriedid old_marriedid assets assets_noland
egen INDID2010=concat(HHID2010 INDID), p(/)
save"$directory\NEEMSIS2\NEEMSIS2-HH_v15_temp.dta", replace



********** Marriage "panel"
preserve
keep if husbandwifecaste!=.
save"$directory\complet\NEEMSIS2-marriage_v1.dta", replace
save"$directory\NEEMSIS2\NEEMSIS2-marriage_v1.dta", replace
restore









********* Merge gift
use "$directory\NEEMSIS2\NEEMSIS_APPEND-marriagegift.dta", clear
rename parent_key setofmarriagegroup
keep if marriagegiftsourcenb!=.
merge m:m setofmarriagegroup using "$directory\NEEMSIS2\NEEMSIS2-marriage_v1.dta", keepusing(INDID2010 age sex egoid caste jatis marriagedate marriedid setofmarriagegroup_new)
drop if _merge==2
drop _merge
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
order INDID2010 egoid jatis sex age caste married marriagedate marriagegiftsource marriagegiftsourcenb marriagegifttype marriagegifttype_gold marriagegifttype_cash marriagegifttype_clothes marriagegifttype_furniture marriagegifttype_vessels marriagegifttype_other marriagegiftamount marriagegoldquantityasgift, first
drop setofmarriagegift key forauto

save"$directory\NEEMSIS2\NEEMSIS_APPEND-marriagegift_v2.dta", replace
*Indiv level
preserve
bysort INDID2010: egen totalmarriagegiftamount=sum(marriagegiftamount)
bysort INDID2010: gen n=_n
keep if n==1
keep INDID2010 totalmarriagegiftamount
save"$directory\NEEMSIS2\NEEMSIS_APPEND-marriagegift_v2_indiv.dta", replace
restore

use"$directory\NEEMSIS2\NEEMSIS2-marriage_v1.dta", clear
merge 1:m INDID2010 using "$directory\NEEMSIS2\NEEMSIS_APPEND-marriagegift_v2_indiv.dta"
drop if _merge==2
drop _merge


save"$directory\NEEMSIS2\NEEMSIS2-marriage_v3.dta", replace
save"$directory\complet\NEEMSIS2-marriage_v3.dta", replace
****************************************
* END















****************************************
* Cleaning
****************************************
use"$directory\NEEMSIS2\NEEMSIS2-marriage_v3.dta", clear

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



********* 1000 var
foreach x in marriagedowry engagementtotalcost engagementhusbandcost engagementwifecost marriagetotalcost marriagehusbandcost marriagewifecost marriageexpenses{
gen `x'1000=`x'/1000
}


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

save"$directory\NEEMSIS2\NEEMSIS2-marriage_v4.dta", replace
****************************************
* END







****************************************
* Coherence
****************************************
use"$directory\NEEMSIS2\NEEMSIS2-marriage_v4.dta", clear
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

save"$directory\NEEMSIS2\NEEMSIS2-marriage_v5.dta", replace
****************************************
* END







****************************************
* Preliminary analysis
****************************************
use"$directory\NEEMSIS2\NEEMSIS2-marriage_v5.dta", clear

********** Gift as form of saving?
fre dummymarriagegift
fre sex
*
gen giftexp=.
replace giftexp=totalmarriagegiftamount-marriageexpenses
tab giftexp
*40% have benefits
drop giftexp
*
gen giftcost=.
replace giftcost=totalmarriagegiftamount-marriagehusbandcost if sex==1 & dummymarriagegift==1
replace giftcost=totalmarriagegiftamount-marriagewifecost if sex==2 & dummymarriagegift==1
tab giftcost sex
gen giftbenefits=.
replace giftbenefits=-1 if giftcost<0
replace giftbenefits=0 if giftcost==0
replace giftbenefits=1 if giftcost>0
tab giftbenefits sex
*Less than half had benefits from marriage
drop giftcost giftbenefits


********** Gift and people wedding
plot totalmarriagegiftamount peoplewedding
/*
  790000 +  
    t    |       *
    o    |  
    t    |  
    a    |  
    l    |  
    m    |  
    a    |  
    r    |  
    r    |  
    i    |  
    a    |  
    g    |       *    *
    e    |      *    *
    g    |  
    i    |      *            *                            *
    f    |    * *  *            *         *               *
    t    |  * * *                         *               *                *
    a    | ** * ** *      *     *         *               *                *
    m    | ** *  *        *     *                         *
    9000 + ** * **
          +----------------------------------------------------------------+
               40    How many people attended the ${marriedna        2000
*/
*twoway (scatter totalmarriagegiftamount peoplewedding, legend(off) ytitle("Total gift amount")) (lfit totalmarriagegiftamount peoplewedding)


****************************************
* END


cls
****************************************
* Loans verif
****************************************
use"$directory\NEEMSIS2\NEEMSIS2-loans_v13.dta", clear
drop _merge

********** Check les HH who face one marriage since 2016
preserve
use"$directory\NEEMSIS2\NEEMSIS2-HH_v15.dta", clear
keep HHID2010 dummymarriage
duplicates drop
save"$directory\NEEMSIS2\NEEMSIS2-HH_marriage.dta", replace
restore
merge m:1 HHID2010 using "$directory\NEEMSIS2\NEEMSIS2-HH_marriage.dta", nogen keep(3)



**********  Amount of reason
gen loanamount1000=loanamount/1000
gen loanbalance1000=loanbalance/1000

tabstat loanamount1000, stat(n mean sd q) by(loanreasongiven)
tab loanlender if loanreasongiven==8
tabstat loanbalance1000, stat(n mean sd q) by(loanreasongiven)




********** Share of total clientele using it
fre loanreasongiven
forvalues i=1(1)13{
gen reason`i'=0
}

forvalues i=1(1)12{
replace reason`i'=1 if loanreasongiven==`i'
}
replace reason13=1 if loanreasongiven==77

preserve 
forvalues i=1(1)13{
bysort HHID2010: egen reasonHH_`i'=max(reason`i')
} 
bysort HHID2010: gen n=_n
keep if n==1
forvalues i=1(1)13{
tab reasonHH_`i', m
}
restore


********** Source of marriage loan
tab loanlender if loanreasongiven==8


********** % in total loaned
gen loanamountmarriage=loanamount if loanreasongiven==8
bysort HHID2010: egen totalloanamount=sum(loanamount)
bysort HHID2010: egen totalmarriageloanamount=sum(loanamountmarriage)
gen marriageintotalloaned=totalmarriageloanamount/totalloanamount

*For whom who faced marriage
tabstat marriageintotalloaned if n==1 & dummymarriage==1, stat(n mean sd p50) by(caste)













* Date
gen datecovid=.
replace datecovid=1 if marriagedate<td(24mar2020)  // before lockdown
replace datecovid=2 if marriagedate>=td(24mar2020) & marriagedate<=td(31may2020)  // during lockdown
replace datecovid=3 if marriagedate>td(31may2020) & marriagedate<=td(01sep2020) // post 1
replace datecovid=4 if marriagedate>td(01sep2020) & marriagedate!=.
tab marriagedate datecovid


* Decision making
fre marriagedecision
gen marriagedecision_rec=.
replace marriagedecision_rec=1 if marriagedecision==1
replace marriagedecision_rec=2 if marriagedecision==2
replace marriagedecision_rec=3 if marriagedecision>=3 & marriagedecision!=.
fre marriagedecision_rec

* Age at marriage
destring age, replace
replace age=age_p16+4 if age==. & age_p16!=.
tab age
gen yearborn1=yofd(dofc(startquestionnaire))
gen yearborn=yearborn1-age
gen yearmarriage=year(marriagedate)
gen ageatmarriage=yearmarriage-yearborn
drop yearborn1 yearborn yearmarriage
order marriagedowry marriagedate age_new age sex ageatmarriage, last
tab ageatmarriage
sort ageatmarriage



* Marriage decision
keep if dummymarriage==1
tab INDID
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

*new setof
gen cro1="["
gen cro2="]"
egen setofmarriagegroup_newold=concat(setofmarriagegroup_o cro1 marriedid_o cro2)
