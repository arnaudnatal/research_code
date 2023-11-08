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
married husbandwifecaste marriagedowry marriagetotalcost marriageexpenses dummymarriagegift howpaymarriage ///
totalmarriagegiftamount hwcaste ageatmarriage marriagedowry1000 marriagetotalcost1000 marriageexpenses1000 MEAR DAAR MEIR DAIR DMC intercaste interjatis marrtype gifttoexpenses benefitsexpenses GAR GIR 

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
totalmarriagegiftamount hwcaste ageatmarriage marriagedowry1000 marriagetotalcost1000 marriageexpenses1000 MEAR DAAR MEIR DAIR DMC intercaste interjatis marrtype gifttoexpenses benefitsexpenses GAR GIR marriagetype2 marriagedowry gifttocost

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

save"NEEMSIS-marriage", replace
****************************************
* END
