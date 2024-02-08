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
totalmarriagegiftamount hwcaste ageatmarriage marriagedowry1000 marriagetotalcost1000 marriageexpenses1000 MEAR DAAR MEIR DAIR DMC intercaste interjatis marrtype gifttoexpenses benefitsexpenses GAR GIR divHH0 divHH5 divHH10 incomeagri_HH incomenonagri_HH educationexpenses

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
engagementhusbandcost marriagehusbandcost engagementwifecost marriagewifecost

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

* Deflate
global rupees marriagedowry marriagetotalcost marriageexpenses totalmarriagegiftamount marriagedowry1000 marriagetotalcost1000 marriageexpenses1000 assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland assets_totalnoprop incomeagri_HH incomenonagri_HH annualincome_HH engagementtotalcost engagementhusbandcost engagementwifecost marriagehusbandcost marriagewifecost engagementhusbandcost marriagehusbandcost engagementwifecost marriagewifecost
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



save"NEEMSIS-marriage", replace
****************************************
* END
