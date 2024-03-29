*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*February 22, 2023
*-----
gl link = "marriageagri"
*Analysis NEEMSIS-2 marriage
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\marriageagri.do"
*-------------------------








****************************************
* NEEMSIS-1 - Only marriage sample
****************************************
use"NEEMSIS1-marriage_v3.dta", clear

*** Recode
recode ownland (.=0)

*** To keep
keep if married==1
keep HHID2016 INDID2016 ownland caste age sex name canread everattendedschool currentlyatschool edulevel working_pop mainocc_occupation_indiv annualincome_HH shareincomeagri_HH shareincomenonagri_HH assets_sizeownland assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland assets_totalnoprop HHsize HH_count_child HH_count_adult typeoffamily nbmale nbfemale nbgeneration dummypolygamous head_age head_sex head_working_pop head_mocc_occupation head_nboccupation head_edulevel dependencyratio dummyheadfemale sexratio nonworkersratio ///
married husbandwifecaste marriagedowry marriagetotalcost marriageexpenses dummymarriagegift howpaymarriage_loan howpaymarriage_capi howpaymarriage_gift ///
totalmarriagegiftamount hwcaste ageatmarriage marriagedowry1000 marriagetotalcost1000 marriageexpenses1000 MEAR DAAR MEIR DAIR DMC intercaste interjatis marrtype gifttoexpenses benefitsexpenses GAR GIR divHH0 divHH5 divHH10 incomeagri_HH incomenonagri_HH educationexpenses ///
relationshiptohead relation_head relation_wife relation_mother relation_father relation_son relation_daughter relation_soninlaw relation_daughterinlaw relation_sister relation_brother relation_motherinlaw relation_fatherinlaw relation_grandchildren relation_cousin relation_other agegrp_0_13 agegrp_14_17 agegrp_18_24 agegrp_25_29 agegrp_30_34 agegrp_35_39 agegrp_40_49 agegrp_50_59 agegrp_60_69 agegrp_70_79 agegrp_80_100 male_agegrp_0_13 female_agegrp_0_13 male_agegrp_14_17 female_agegrp_14_17 male_agegrp_18_24 female_agegrp_18_24 male_agegrp_25_29 female_agegrp_25_29 male_agegrp_30_34 female_agegrp_30_34 male_agegrp_35_39 female_agegrp_35_39 male_agegrp_40_49 female_agegrp_40_49 male_agegrp_50_59 female_agegrp_50_59 male_agegrp_60_69 female_agegrp_60_69 male_agegrp_70_79 female_agegrp_70_79 male_agegrp_80_100 female_agegrp_80_100 ///
unmarried married_male unmarried_male married_female unmarried_female married_male_1824 unmarried_male_1824 married_female_1824 unmarried_female_1824 married_male_2530 unmarried_male_2530 married_female_2530 unmarried_female_2530 married_male_more30 unmarried_male_more30 married_female_more30 unmarried_female_more30 married_male_more18 unmarried_male_more18 married_female_more18 unmarried_female_more18 married_1824 unmarried_1824 married_2530 unmarried_2530 married_more30 unmarried_more30 married_more18 unmarried_more18 ///
maritalstatus family unmarried_son unmarried_daughter married_son married_daughter ///
educexp_male_HH educexp_female_HH educexp_HH

gen year=2016

*** Panel
merge m:m HHID2016 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2016, replace
merge m:m HHID_panel INDID2016 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge
destring INDID2016, replace

save "NEEMSIS1-marriage_tm.dta", replace
****************************************
* END








****************************************
* NEEMSIS-2 - Only marriage sample
****************************************
use"NEEMSIS2-marriage_v5.dta", clear

*** Recode
destring ownland, replace
recode ownland (.=0)

*** To keep
keep if married==1
keep HHID2020 INDID2020 ownland caste age sex name canread everattendedschool currentlyatschool edulevel working_pop mainocc_occupation_indiv annualincome_HH shareincomeagri_HH shareincomenonagri_HH assets_sizeownland assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland assets_totalnoprop HHsize HH_count_child HH_count_adult typeoffamily nbmale nbfemale nbgeneration dummypolygamous head_age head_sex head_working_pop head_mocc_occupation head_nboccupation head_edulevel dependencyratio dummyheadfemale sexratio nonworkersratio ///
married marriagesomeoneelse peoplewedding husbandwifecaste marriagetype marriageblood marriagearranged marriagedecision marriagespousefamily engagementtotalcost engagementhusbandcost engagementwifecost marriagetotalcost marriagehusbandcost marriagewifecost marriageloannb marriageexpenses dummymarriagegift howpaymarriage_loan howpaymarriage_capi howpaymarriage_gift ///
totalmarriagegiftamount hwcaste ageatmarriage marriagedowry1000 marriagetotalcost1000 marriageexpenses1000 MEAR DAAR MEIR DAIR DMC intercaste interjatis marrtype gifttoexpenses benefitsexpenses GAR GIR marriagetype2 marriagedowry gifttocost divHH0 divHH5 divHH10 incomeagri_HH incomenonagri_HH educationexpenses ///
engagementhusbandcost marriagehusbandcost engagementwifecost marriagewifecost ///
relationshiptohead relation_head relation_wife relation_mother relation_father relation_son relation_daughter relation_soninlaw relation_daughterinlaw relation_sister relation_brother relation_motherinlaw relation_fatherinlaw relation_grandchildren relation_cousin relation_other agegrp_0_13 agegrp_14_17 agegrp_18_24 agegrp_25_29 agegrp_30_34 agegrp_35_39 agegrp_40_49 agegrp_50_59 agegrp_60_69 agegrp_70_79 agegrp_80_100 male_agegrp_0_13 female_agegrp_0_13 male_agegrp_14_17 female_agegrp_14_17 male_agegrp_18_24 female_agegrp_18_24 male_agegrp_25_29 female_agegrp_25_29 male_agegrp_30_34 female_agegrp_30_34 male_agegrp_35_39 female_agegrp_35_39 male_agegrp_40_49 female_agegrp_40_49 male_agegrp_50_59 female_agegrp_50_59 male_agegrp_60_69 female_agegrp_60_69 male_agegrp_70_79 female_agegrp_70_79 male_agegrp_80_100 female_agegrp_80_100 ///
unmarried married_male unmarried_male married_female unmarried_female married_male_1824 unmarried_male_1824 married_female_1824 unmarried_female_1824 married_male_2530 unmarried_male_2530 married_female_2530 unmarried_female_2530 married_male_more30 unmarried_male_more30 married_female_more30 unmarried_female_more30 married_male_more18 unmarried_male_more18 married_female_more18 unmarried_female_more18 married_1824 unmarried_1824 married_2530 unmarried_2530 married_more30 unmarried_more30 married_more18 unmarried_more18 ///
maritalstatus family unmarried_son unmarried_daughter married_son married_daughter ///
educexp_male_HH educexp_female_HH educexp_HH

gen year=2020


*** Panel
merge m:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge
destring INDID2020, replace

save "NEEMSIS2-marriage_tm.dta", replace
****************************************
* END











****************************************
* Append - Only marriage sample
****************************************
use"NEEMSIS1-marriage_tm.dta", clear

append using "NEEMSIS2-marriage_tm.dta"
order HHID_panel INDID_panel year name

tabstat totalmarriagegiftamount marriagehusbandcost marriagewifecost if year==2020, stat(n mean cv q) by(sex) long


* Deflate
global rupees marriagedowry marriagetotalcost marriageexpenses totalmarriagegiftamount marriagedowry1000 marriagetotalcost1000 marriageexpenses1000 assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland assets_totalnoprop incomeagri_HH incomenonagri_HH annualincome_HH engagementtotalcost engagementhusbandcost engagementwifecost marriagehusbandcost marriagewifecost
foreach x in $rupees {
replace `x'=`x'*(100/116) if year==2020
}



* Time
gen time=1 if year==2016
replace time=2 if year==2020
label define time 1"2016-17" 2"2020-21"
label values time time
fre time



********** New variables
gen totalmarriagegiftamount_alt=totalmarriagegiftamount
replace totalmarriagegiftamount_alt=0 if totalmarriagegiftamount==.
********** Cout net du mariage
* hommes : gift+dowry-expenses
* femmes : gift-dowry-expenses
gen marriagenetcost=.
replace marriagenetcost=totalmarriagegiftamount_alt+marriagedowry-marriageexpenses if sex==1 & marriageexpenses!=.
replace marriagenetcost=totalmarriagegiftamount_alt-marriagedowry-marriageexpenses if sex==2 & marriageexpenses!=.
*
gen marriagenetcost1000=marriagenetcost/1000 if marriagenetcost!=.
*
gen MNCI=marriagenetcost*100/annualincome


********** Cout net du mariage alt
* hommes : gift+dowry-expenses (ou cost)
* femmes : gift-dowry-expenses (ou cost)

/*
*J'estime le % du cout qu'ils ont en expenses puis je l'impute
gen _tempmale=marriageexpenses*100/marriagehusbandcost if sex==1
gen _tempfemale=marriageexpenses*100/marriagewifecost if sex==2
sum _tempmale _tempfemale
*
    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
   _tempmale |         25    96.66667    34.24056       23.2        116
 _tempfemale |         13    67.98709    45.66061        2.9        116
*/


gen marriagenetcost_alt=marriagenetcost
replace marriagenetcost_alt=totalmarriagegiftamount_alt+marriagedowry-(marriagehusbandcost*0.97) if sex==1 & marriageexpenses==.
replace marriagenetcost_alt=totalmarriagegiftamount_alt-marriagedowry-(marriagewifecost*0.68) if sex==2 & marriageexpenses==.
*
gen marriagenetcost_alt1000=marriagenetcost_alt/1000 if marriagenetcost_alt!=.
*
gen MNCI_alt=marriagenetcost_alt*100/annualincome


tabstat marriagenetcost1000 marriagenetcost_alt1000, stat(n mean q) by(sex)

label define cat_cost 1"Net loss" 2"Balanced" 3"Net gain"
gen cat_cost=.
replace cat_cost=1 if marriagenetcost_alt1000<0
replace cat_cost=2 if marriagenetcost_alt1000==0
replace cat_cost=3 if marriagenetcost_alt1000>0
label values cat_cost cat_cost

* Recode
fre maritalstatus
clonevar maritalstatus_backup=maritalstatus
replace maritalstatus=1
ta maritalstatus_backup maritalstatus, m



********** Low gift
gen lowgift=.
replace lowgift=1 if totalmarriagegiftamount_alt<=60000 & year==2016 & totalmarriagegiftamount_alt!=. & totalmarriagegiftamount_alt!=0
replace lowgift=1 if totalmarriagegiftamount_alt<=68965.52 & year==2020 & totalmarriagegiftamount_alt!=. & totalmarriagegiftamount_alt!=0

replace lowgift=0 if totalmarriagegiftamount_alt>60000 & year==2016 & totalmarriagegiftamount_alt!=. & totalmarriagegiftamount_alt!=0
replace lowgift=0 if totalmarriagegiftamount_alt>68965.52 & year==2020 & totalmarriagegiftamount_alt!=. & totalmarriagegiftamount_alt!=0

label define lowgift 0"Norm-High gift" 1"Low gift"
label values lowgift lowgift

ta lowgift year, col nofreq


********** Cost for females with dowry
gen marriagewifecost2=marriagedowry+marriagewifecost if sex==2


********** Assets "high" and "low"
xtile status2016=assets_total if year==2016, n(3)
ta status2016
xtile status2020=assets_total if year==2020, n(3)
ta status2020
gen status=.
replace status=status2016 if year==2016
replace status=status2020 if year==2020
label define status 1"Low" 2"Middle" 3"High"
label values status status
drop status2016 status2020

tabstat assets_total, stat(n mean q) by(status)
tabstat assets_total if year==2016, stat(n mean q) by(status)
tabstat assets_total if year==2020, stat(n mean q) by(status)


********** 1000
foreach x in totalmarriagegiftamount assets_totalnoland annualincome_HH {
gen `x'1000=`x'/1000
}

foreach x in MEAR MEIR gifttoexpenses GAR GIR DAIR DMC DAAR {
replace `x'=`x'*100
}



********** Nb of marriages
gen male=1 if sex==1
gen female=1 if sex==2
bysort HHID_panel year: egen nbmarr_male=sum(male)
bysort HHID_panel year: egen nbmarr_female=sum(female)
bysort HHID_panel year: gen nbmarr=_N





********** Cost to income
gen CTI=(marriagetotalcost/annualincome_HH)*100



*********** Unmarried cat
global var unmarried_female_1824 unmarried_female_2530 unmarried_female unmarried_daughter unmarried_male_1824 unmarried_male_2530 unmarried_male unmarried_son married_female_1824 married_female_2530 married_female married_daughter married_male_1824 married_male_2530 married_male married_son

foreach x in $var {
gen cat_`x'=`x'
}
foreach x in $var {
replace cat_`x'=1 if cat_`x'>1 & cat_`x'!=. & cat_`x'!=0
}

foreach x in $var {
ta cat_`x'
}



save"NEEMSIS-marriage", replace
****************************************
* END
