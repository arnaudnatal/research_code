*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*February 22, 2023
*-----
gl link = "marriageagri"
*Prepa database for NEEMSIS-2
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\marriageagri.do"
*-------------------------








****************************************
* HH database cleaning
****************************************
use "raw\NEEMSIS2-HH.dta", clear

sort HHID2020 INDID2020

ta marriedname


********** How much HH concern?
preserve
bysort HHID2020: gen n=_n
keep if n==1
tab dummymarriage  // 168 HH face one marriage or more between 2016 and 2020
tab marriedlist if marriedlist!="." & marriedlist!=""
restore
*185 marriages



********** 2010 maybe?
gen m2010=0
replace m2010=1 if maritalstatusdate>td(01jan2010) & maritalstatusdate<td(01jan2017)
bysort HHID2020: egen dummymarriage2010=max(m2010)
drop m2010



********** Keep the HH
keep if dummymarriage==1 | dummymarriage2010==1

ta dummy_marriedlist

save"NEEMSIS2-marriage.dta", replace
****************************************
* END












****************************************
* Gift
****************************************
use "raw\NEEMSIS2-HH.dta", clear

keep if dummymarriage==1
ta marriedname

keep if marriedname!=""

keep HHID2020 INDID2020 egoid jatis sex age name dummymarriage dummy_marriedlist marriedname marriedid marriagesomeoneelse marriagedate dummymarriagegift marriagegiftsource marriagegiftsourcename1 marriagegiftsourcenb_WKP marriagegifttype_WKP marriagegiftamount_WKP marriagegiftsourcename2 marriagegiftsourcenb_rela marriagegifttype_rela marriagegiftamount_rela marriagegiftsourcename3 marriagegiftsourcenb_empl marriagegifttype_empl marriagegiftamount_empl marriagegiftsourcename4 marriagegiftsourcenb_mais marriagegifttype_mais marriagegiftamount_mais marriagegiftsourcename5 marriagegiftsourcenb_coll marriagegifttype_coll marriagegiftamount_coll marriagegiftsourcename9 marriagegiftsourcenb_frie marriagegifttype_frie marriagegiftamount_frie marriagegiftsourcename10 marriagegiftsourcenb_SHG marriagegifttype_SHG marriagegiftamount_SHG

foreach x in marriagegiftsourcenb marriagegifttype marriagegiftamount {
rename `x'_WKP `x'1
rename `x'_rela `x'2
rename `x'_emp `x'3
rename `x'_mais `x'4
rename `x'_coll `x'5
*rename `x'_pawn `x'6
*rename `x'_shop `x'7
*rename `x'_fina `x'8
rename `x'_frie `x'9
rename `x'_SHG `x'10
*rename `x'_banks `x'11
*rename `x'_coop `x'12
*rename `x'_sugar `x'13
*rename `x'_groupe `x'14
*rename `x'_thandal `x'15
}

reshape long marriagegiftsourcename marriagegiftsourcenb marriagegifttype marriagegiftamount, i(HHID2020 INDID2020) j(num)
drop if marriagegiftsourcename==""


*** totalmarriagegiftamount
preserve
bysort HHID2020 INDID2020: egen totalmarriagegiftamount=sum(marriagegiftamount)
keep HHID2020 INDID2020 totalmarriagegiftamount
duplicates drop
save"NEEMSIS2-marriagegiftHH.dta", replace
restore


save"NEEMSIS2-marriagegift.dta", replace
****************************************
* END















****************************************
* Cleaning
****************************************
use"raw/NEEMSIS2-HH.dta", clear

********** Gift
merge 1:1 HHID2020 INDID2020 using "NEEMSIS2-marriagegiftHH"
drop _merge
*keep if marriedname!=""
gen married=0
replace married=1 if marriedname!=""

********** Husband wife caste
tab husbandwifecaste
decode husbandwifecaste, gen(huwicaste)
ta huwicaste
gen hwcaste=.
replace hwcaste=1 if huwicaste=="Arunthathiyar"
replace hwcaste=2 if huwicaste=="Asarai"
replace hwcaste=3 if huwicaste=="Chettiyar"
replace hwcaste=2 if huwicaste=="Gramani"
replace hwcaste=2 if huwicaste=="Kulalar"
replace hwcaste=3 if huwicaste=="Mudaliar"
replace hwcaste=2 if huwicaste=="Muslims"
replace hwcaste=3 if huwicaste=="Naidu"
replace hwcaste=2 if huwicaste=="Nattar"
replace hwcaste=2 if huwicaste=="Navithar"
replace hwcaste=2 if huwicaste=="Padayachi"
replace hwcaste=3 if huwicaste=="Rediyar"
replace hwcaste=1 if huwicaste=="SC"
replace hwcaste=3 if huwicaste=="Settu"
replace hwcaste=2 if huwicaste=="Vanniyar"
replace hwcaste=3 if huwicaste=="Yathavar"
replace hwcaste=88 if huwicaste=="Don't know"
label define hwcaste 1"Dalits" 2"Middle castes" 3"Upper castes" 88"DK"
label values hwcaste hwcaste
drop huwicaste
ta husbandwifecaste hwcaste, m



********** How pay marriage?
tab howpaymarriage
*replace howpaymarriage="Loan" if howpaymarriage=="1"
*replace howpaymarriage="Own capital / Savings" if howpaymarriage=="2"
*replace howpaymarriage="Both" if howpaymarriage=="4"
*replace howpaymarriage="Both" if howpaymarriage=="1 2"
*replace howpaymarriage="Both & gift" if howpaymarriage=="1 2 3"
*replace howpaymarriage="Both & gift" if howpaymarriage=="2 3"
*replace howpaymarriage="Both" if howpaymarriage=="2 4"
*tab howpaymarriage
*gen howpaymarriage_loan=0
*gen howpaymarriage_capital=0
*gen howpaymarriage_gift=0
*replace howpaymarriage_loan=1 if howpaymarriage=="Loan"
*replace howpaymarriage_loan=1 if howpaymarriage=="Both"
*replace howpaymarriage_loan=1 if howpaymarriage=="Both & gift"
*replace howpaymarriage_capital=1 if howpaymarriage=="Own capital / Savings"
*replace howpaymarriage_capital=1 if howpaymarriage=="Both"
*replace howpaymarriage_capital=1 if howpaymarriage=="Both & gift"
*replace howpaymarriage_gift=1 if howpaymarriage=="Both & gift"
tab1 howpaymarriage_loan howpaymarriage_capi howpaymarriage_gift howpaymarriage_both
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



********** Drop
*keep if dummymarriage==1
*keep if marriagetype!=.


save"NEEMSIS2-marriage.dta", replace
****************************************
* END


















****************************************
* Coherence
****************************************
use"NEEMSIS2-marriage.dta", clear




********** Coherence amount
tab marriagetotalcost 
plot marriagetotalcost peoplewedding



********** Coherence husband--wife
gen husbandwifecost=marriagetotalcost-(marriagewifecost+marriagehusbandcost)
tab husbandwifecost
*18 case to check here

list HHID2020 INDID2020 sex caste hwcaste marriagewifecost marriagehusbandcost marriagetotalcost marriageexpenses if husbandwifecost!=0, clean noobs
/*
HHID2020	IND~2020	sex	caste	hwcaste	ma~ecost	ma~dcost	ma~lcost	marri~es
uuid:f6765a2a-2a6d-45c3-a8e2-af3ff0777b98	3	Female	Dalits	Dalits	50000	50000	250000	.       // somme
uuid:08805e55-b049-4379-8677-fccd5372fb7d	2	Female	Dalits	Dalits	200000	150000	200000	5000    // somme
uuid:a9c75fcf-6a0a-4731-bf42-1e80752fcc73	4	Male	Dalits	Dalits	100000	250000	250000	.       // somme
uuid:e5908184-fba6-4106-bf80-fcd3972a1d8c	3	Male	Middle	Middle	100000	75000	100000	35000   // somme
uuid:30965eab-e285-48ce-9a2e-bedef927d3ac	2	Male	Dalits	Dalits	50000	200000	200000	.       // somme
uuid:f238747c-1918-4a7c-a7ed-0f508f756e4f	4	Male	Dalits	Dalits	50000	50000	200000	.       // somme
uuid:9e2d228c-9b26-4e9c-aabb-89711ec2c3c7	3	Male	Dalits	Dalits	50000	100080	200000	.       // somme
uuid:9a3b8049-d4b8-46ad-89e9-d11877fe88be	3	Male	Middle	Middle	200000	350000	500000	.       // somme
uuid:83db958d-b1ad-4544-a3d9-5f582dd900c8	1	Female	Middle	Middle	200000	250000	400000	.       // somme
uuid:3d04313d-f28c-40c0-8e54-a21a96e9113e	16	Female	Dalits	Dalits	100000	150000	400000	.       // somme
uuid:aba029f6-b4c8-4507-a922-cfb3731fcecc	1	Male	Middle	Middle	200000	10000	300000	.       // somme
uuid:6eff992e-a90e-461d-b8af-3eb37a798fea	4	Female	Dalits	Dalits	100000	100000	250000	.       // somme
uuid:92ad6585-9e3f-4b0f-85be-1160a8b80161	3	Female	Dalits	Dalits	250000	100000	250000	150000  // somme
uuid:7bdc7481-f2a3-4071-8cfe-ebf798fc6878	3	Female	Dalits	Dalits	550000	500000	1000000	50000   // somme
uuid:4e527146-6844-4e21-8f32-f1f9cfedad2a	16	Female	Dalits	Dalits	15800	100000	100000	.       // somme
uuid:3cdde5f7-0440-4194-936f-5bcd3984d644	3	Male	Upper	Middle	500000	500000	500000	500000  // somme
uuid:51a42395-d52d-4af0-905a-60dd9b168a9a	3	Female	Middle	Middle	30000	50000	50000	.       // somme
uuid:69694844-ee5e-450a-80cb-81d85c7d7e7e	16	Female	Dalits	Dalits	20000	50000	300000	200000  // wife and husband
uuid:a459cae1-9e19-4143-8c1f-2b537f105a4f	3	Male	Dalits	Dalits	90000	30000	200000	100000  // somme and husband
uuid:6e71d156-2fa8-411b-85bf-42129aaa5e95	3	Male	Middle	Middle	50000	50000	50000	.       // somme  
uuid:4636a314-9b75-4dec-8fea-05335cb99b24	3	Male	Middle	Middle	50000	75000	150000	.       // somme
uuid:8a0af2f0-d483-4b03-a2ea-2bd30c774749	3	Male	Dalits	Dalits	50000	75000	150000	.       // somme
uuid:b0107e4c-25f9-4f65-a264-d2e5869ddef7	3	Male	Dalits	Dalits	100000	50000	200000	50000   // somme
*/

*** Pb somme
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if HHID2020=="uuid:f6765a2a-2a6d-45c3-a8e2-af3ff0777b98" & INDID2020==3
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if HHID2020=="uuid:08805e55-b049-4379-8677-fccd5372fb7d" & INDID2020==2
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if HHID2020=="uuid:a9c75fcf-6a0a-4731-bf42-1e80752fcc73" & INDID2020==4
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if HHID2020=="uuid:e5908184-fba6-4106-bf80-fcd3972a1d8c" & INDID2020==3
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if HHID2020=="uuid:30965eab-e285-48ce-9a2e-bedef927d3ac" & INDID2020==2
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if HHID2020=="uuid:f238747c-1918-4a7c-a7ed-0f508f756e4f" & INDID2020==4
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if HHID2020=="uuid:9e2d228c-9b26-4e9c-aabb-89711ec2c3c7" & INDID2020==3
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if HHID2020=="uuid:9a3b8049-d4b8-46ad-89e9-d11877fe88be" & INDID2020==3
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if HHID2020=="uuid:83db958d-b1ad-4544-a3d9-5f582dd900c8" & INDID2020==1
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if HHID2020=="uuid:3d04313d-f28c-40c0-8e54-a21a96e9113e" & INDID2020==16
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if HHID2020=="uuid:aba029f6-b4c8-4507-a922-cfb3731fcecc" & INDID2020==1
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if HHID2020=="uuid:6eff992e-a90e-461d-b8af-3eb37a798fea" & INDID2020==4
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if HHID2020=="uuid:92ad6585-9e3f-4b0f-85be-1160a8b80161" & INDID2020==3
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if HHID2020=="uuid:7bdc7481-f2a3-4071-8cfe-ebf798fc6878" & INDID2020==3
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if HHID2020=="uuid:4e527146-6844-4e21-8f32-f1f9cfedad2a" & INDID2020==16
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if HHID2020=="uuid:3cdde5f7-0440-4194-936f-5bcd3984d644" & INDID2020==3
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if HHID2020=="uuid:51a42395-d52d-4af0-905a-60dd9b168a9a" & INDID2020==3
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if HHID2020=="uuid:6e71d156-2fa8-411b-85bf-42129aaa5e95" & INDID2020==3
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if HHID2020=="uuid:4636a314-9b75-4dec-8fea-05335cb99b24" & INDID2020==3
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if HHID2020=="uuid:8a0af2f0-d483-4b03-a2ea-2bd30c774749" & INDID2020==3
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if HHID2020=="uuid:b0107e4c-25f9-4f65-a264-d2e5869ddef7" & INDID2020==3

*** Pb husband
replace marriagehusbandcost=marriageexpenses if HHID2020=="uuid:a459cae1-9e19-4143-8c1f-2b537f105a4f" & INDID2020==3
replace marriagetotalcost=marriagehusbandcost+marriagewifecost if HHID2020=="uuid:a459cae1-9e19-4143-8c1f-2b537f105a4f" & INDID2020==3

*** Pb husband and wife
replace marriagewifecost=marriageexpenses if HHID2020=="uuid:69694844-ee5e-450a-80cb-81d85c7d7e7e" & INDID2020==16
replace marriagetotalcost=marriagewifecost+marriagehusbandcost if HHID2020=="uuid:69694844-ee5e-450a-80cb-81d85c7d7e7e" & INDID2020==16

*** Clean
drop husbandwifecost
gen husbandwifecost=marriagetotalcost-(marriagewifecost+marriagehusbandcost)
tab husbandwifecost
drop husbandwifecost






********** Coherence expenses--cost for male
fre sex
gen husb_expensescost=marriageexpenses-marriagehusbandcost if sex==1
tab husb_expensescost
*5 case to check here

list HHID2020 INDID2020 sex caste hwcaste marriagewifecost marriagehusbandcost marriagetotalcost marriageexpenses if husb_expensescost>0 & husb_expensescost!=., clean noobs
/*
                                 HHID2020   IND~2020    sex    caste   hwcaste   ma~ecost   ma~dcost   ma~lcost   marri~es  
uuid:0e75c80d-e953-475e-b5bd-4a5f3b9755e6          3   Male    Upper    Middle      50000      50000     100000     100000  
uuid:e9f06e5a-ed16-4fb4-97cf-7578ba9c7ab9          3   Male   Middle    Middle     200000     100000     300000     300000  
uuid:2b25f8fa-25c5-4d27-b6ea-f3c919ffbb61          3   Male    Upper     Upper      50000      50000     100000     100000  
uuid:ceaa4296-408d-4a63-bc59-f24d8fd7c7c0          3   Male   Dalits    Dalits      50000      50000     100000     100000  
uuid:bcfe8f96-597e-4e8c-b875-47971b3414b6          4   Male   Dalits    Dalits      50000      50000     100000     100000  
*/

replace marriageexpenses=marriagehusbandcost if HHID2020=="uuid:0e75c80d-e953-475e-b5bd-4a5f3b9755e6" & INDID2020==3
replace marriageexpenses=marriagehusbandcost if HHID2020=="uuid:e9f06e5a-ed16-4fb4-97cf-7578ba9c7ab9" & INDID2020==3
replace marriageexpenses=marriagehusbandcost if HHID2020=="uuid:2b25f8fa-25c5-4d27-b6ea-f3c919ffbb61" & INDID2020==3
replace marriageexpenses=marriagehusbandcost if HHID2020=="uuid:ceaa4296-408d-4a63-bc59-f24d8fd7c7c0" & INDID2020==3
replace marriageexpenses=marriagehusbandcost if HHID2020=="uuid:bcfe8f96-597e-4e8c-b875-47971b3414b6" & INDID2020==4

drop husb_expensescost
gen husb_expensescost=marriageexpenses-marriagehusbandcost if sex==1
tab husb_expensescost
drop husb_expensescost




********** Coherence expenses--cost for female
gen wife_expensescost=marriageexpenses-marriagewifecost if sex==2
tab wife_expensescost
*5 case to check here

list HHID2020 INDID2020 sex caste hwcaste marriagewifecost marriagehusbandcost marriagetotalcost marriageexpenses if wife_expensescost>0 & wife_expensescost!=., clean noobs
/*
                                 HHID2020   IND~2020      sex    caste   hwcaste   ma~ecost   ma~dcost   ma~lcost   marri~es  
uuid:e0070a7a-e763-4c3b-9fa1-5b3a18f6b45e          3   Female   Middle    Middle       5000       5000      10000      10000  
uuid:35993b22-46eb-4ec9-9fca-1156d21ff8a6         16   Female   Dalits    Dalits     100000     100000     200000     200000  
uuid:521d316a-3324-4bf7-b4c6-471e58e42962          4   Female   Middle    Middle          0     600000     600000     600000  
*/

*** Replace
replace marriageexpenses=marriagewifecost if HHID2020=="uuid:e0070a7a-e763-4c3b-9fa1-5b3a18f6b45e" & INDID2020==3
replace marriageexpenses=marriagewifecost if HHID2020=="uuid:35993b22-46eb-4ec9-9fca-1156d21ff8a6" & INDID2020==16
replace marriageexpenses=marriagewifecost if HHID2020=="uuid:521d316a-3324-4bf7-b4c6-471e58e42962" & INDID2020==4


drop wife_expensescost
gen wife_expensescost=marriageexpenses-marriagewifecost if sex==2
tab wife_expensescost
drop wife_expensescost






********** Engagement wife--husband
gen husbandwifeenga=engagementtotalcost-(engagementwifecost+engagementhusbandcost)
tab husbandwifeenga
*13 case to check here

list HHID2020 INDID2020 sex caste hwcaste engagementwifecost engagementhusbandcost engagementtotalcost if husbandwifeenga!=0, clean noobs
/*

                                 HHID2020   IND~2020      sex    caste   hwcaste   en~ecost   en~dcost   en~lcost  
uuid:f6765a2a-2a6d-45c3-a8e2-af3ff0777b98          3   Female   Dalits    Dalits      50000     100000     100000  // somme
uuid:08805e55-b049-4379-8677-fccd5372fb7d          2   Female   Dalits    Dalits      30000      50000      50000  // somme  
uuid:a9c75fcf-6a0a-4731-bf42-1e80752fcc73          4     Male   Dalits    Dalits     100000     100000     150000  // somme
uuid:30965eab-e285-48ce-9a2e-bedef927d3ac          2     Male   Dalits    Dalits      50000      40000      50000  // somme
uuid:6bd1eaa0-9117-47c2-8c61-29d5102daf1f         16   Female   Dalits    Dalits      80000      10000      80000  // somme
uuid:9e2d228c-9b26-4e9c-aabb-89711ec2c3c7          3     Male   Dalits    Dalits      50000      50000      50000  // somme
uuid:e5908184-fba6-4106-bf80-fcd3972a1d8c          3     Male   Middle    Middle      20000      25000      30000  // somme
uuid:9ecbdaca-ffce-4bbc-a69d-455ea0411977          7     Male   Dalits    Dalits      25000      25000     500000  // somme
uuid:92ad6585-9e3f-4b0f-85be-1160a8b80161          3   Female   Dalits    Dalits      50000      35000     200000  // somme
uuid:6eff992e-a90e-461d-b8af-3eb37a798fea          4   Female   Dalits    Dalits      50000      25000      50000  // somme
uuid:3cdde5f7-0440-4194-936f-5bcd3984d644          3     Male    Upper    Middle     200000     200000     200000  // somme
uuid:51a42395-d52d-4af0-905a-60dd9b168a9a          3   Female   Middle    Middle     100000      75000     200000  // somme
uuid:69694844-ee5e-450a-80cb-81d85c7d7e7e         16   Female   Dalits    Dalits      20000      25000      25000  // somme
uuid:6e71d156-2fa8-411b-85bf-42129aaa5e95          3     Male   Middle    Middle      35000      50000      50000  // somme
uuid:8a0af2f0-d483-4b03-a2ea-2bd30c774749          3     Male   Dalits    Dalits      65000      50000     175000  // somme
uuid:4636a314-9b75-4dec-8fea-05335cb99b24          3     Male   Middle    Middle      50000      50000     200000  // somme
*/

*** Somme
replace engagementtotalcost=engagementwifecost+engagementhusbandcost if HHID2020=="uuid:f6765a2a-2a6d-45c3-a8e2-af3ff0777b98" & INDID2020==3
replace engagementtotalcost=engagementwifecost+engagementhusbandcost if HHID2020=="uuid:08805e55-b049-4379-8677-fccd5372fb7d" & INDID2020==2
replace engagementtotalcost=engagementwifecost+engagementhusbandcost if HHID2020=="uuid:a9c75fcf-6a0a-4731-bf42-1e80752fcc73" & INDID2020==4
replace engagementtotalcost=engagementwifecost+engagementhusbandcost if HHID2020=="uuid:30965eab-e285-48ce-9a2e-bedef927d3ac" & INDID2020==2
replace engagementtotalcost=engagementwifecost+engagementhusbandcost if HHID2020=="uuid:6bd1eaa0-9117-47c2-8c61-29d5102daf1f" & INDID2020==16
replace engagementtotalcost=engagementwifecost+engagementhusbandcost if HHID2020=="uuid:9e2d228c-9b26-4e9c-aabb-89711ec2c3c7" & INDID2020==3
replace engagementtotalcost=engagementwifecost+engagementhusbandcost if HHID2020=="uuid:e5908184-fba6-4106-bf80-fcd3972a1d8c" & INDID2020==3
replace engagementtotalcost=engagementwifecost+engagementhusbandcost if HHID2020=="uuid:9ecbdaca-ffce-4bbc-a69d-455ea0411977" & INDID2020==7
replace engagementtotalcost=engagementwifecost+engagementhusbandcost if HHID2020=="uuid:92ad6585-9e3f-4b0f-85be-1160a8b80161" & INDID2020==3
replace engagementtotalcost=engagementwifecost+engagementhusbandcost if HHID2020=="uuid:6eff992e-a90e-461d-b8af-3eb37a798fea" & INDID2020==4
replace engagementtotalcost=engagementwifecost+engagementhusbandcost if HHID2020=="uuid:3cdde5f7-0440-4194-936f-5bcd3984d644" & INDID2020==3
replace engagementtotalcost=engagementwifecost+engagementhusbandcost if HHID2020=="uuid:51a42395-d52d-4af0-905a-60dd9b168a9a" & INDID2020==3
replace engagementtotalcost=engagementwifecost+engagementhusbandcost if HHID2020=="uuid:69694844-ee5e-450a-80cb-81d85c7d7e7e" & INDID2020==16
replace engagementtotalcost=engagementwifecost+engagementhusbandcost if HHID2020=="uuid:6e71d156-2fa8-411b-85bf-42129aaa5e95" & INDID2020==3
replace engagementtotalcost=engagementwifecost+engagementhusbandcost if HHID2020=="uuid:8a0af2f0-d483-4b03-a2ea-2bd30c774749" & INDID2020==3
replace engagementtotalcost=engagementwifecost+engagementhusbandcost if HHID2020=="uuid:4636a314-9b75-4dec-8fea-05335cb99b24" & INDID2020==3



drop husbandwifeenga
gen husbandwifeenga=engagementtotalcost-(engagementwifecost+engagementhusbandcost)
tab husbandwifeenga
drop husbandwifeenga


save"NEEMSIS2-marriage_v2.dta", replace
****************************************
* END


















****************************************
* Creation
****************************************
use"NEEMSIS2-marriage_v2.dta", clear


********* 1000 var
foreach x in marriagedowry engagementtotalcost engagementhusbandcost engagementwifecost marriagetotalcost marriagehusbandcost marriagewifecost marriageexpenses{
gen `x'1000=`x'/1000
}



********** Merge with assets, income, etc.
merge m:1 HHID2020 using "raw/NEEMSIS2-assets", keepusing(assets*)
keep if _merge==3
drop _merge

merge m:1 HHID2020 using "raw/NEEMSIS2-family"
keep if _merge==3
drop _merge

merge m:1 HHID2020 using "raw/NEEMSIS2-occup_HH"
keep if _merge==3
drop _merge

merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-occup_indiv"
keep if _merge==3
drop _merge

merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-caste", keepusing(jatiscorr caste)
keep if _merge==3
drop _merge

merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-education", keepusing(edulevel)
keep if _merge==3
drop _merge

********** Indicator
*
clonevar totalmarriagegiftamount_recode=totalmarriagegiftamount
recode totalmarriagegiftamount_recode (.=0)
*
gen MEAR=marriageexpenses/assets_total
*
gen DAAR=.
replace DAAR=marriagedowry/assets_total if sex==2
*
gen MEIR=marriageexpenses/annualincome_HH
*
gen DAIR=.
replace DAIR=marriagedowry/annualincome_HH if sex==2
*
gen DMC=.
replace DMC=marriagedowry/marriagetotalcost
*
gen gifttoexpenses=totalmarriagegiftamount/marriageexpenses
*
gen benefitsexpenses=0
replace benefitsexpenses=1 if gifttoexpenses>1 & gifttoexpenses!=.
*
gen GAR=.
replace GAR=totalmarriagegiftamount/assets_total if totalmarriagegiftamount!=.
gen GIR=.
replace GIR=totalmarriagegiftamount/annualincome_HH if totalmarriagegiftamount!=.
*
gen gifttocost=.
replace gifttocost=totalmarriagegiftamount/marriagehusbandcost if sex==1
replace gifttocost=totalmarriagegiftamount/marriagewifecost if sex==2


********** Net benefits of marriage
gen netbenefitsmarriage1000=.
replace netbenefitsmarriage1000=(marriagedowry+totalmarriagegiftamount_recode-marriagehusbandcost)/1000 if sex==1
replace netbenefitsmarriage1000=(totalmarriagegiftamount_recode-marriagewifecost-marriagedowry)/1000 if sex==2
*Benefits on assets and income
gen BAR=netbenefitsmarriage1000*1000/assets_total
gen BIR=netbenefitsmarriage1000*1000/annualincome_HH


save"NEEMSIS2-marriage_v3.dta", replace
****************************************
* END














****************************************
* Respondent, age and assets
****************************************
use"NEEMSIS2-marriage_v3.dta", clear


********** Identify respondent amount
gen respondent_engagementcost1000=.
gen respondent_marriagecost1000=.
gen respondent_sharemarriage=.
gen respondent_shareengagement=.

replace respondent_engagementcost1000=engagementhusbandcost1000 if sex==1
replace respondent_engagementcost1000=engagementwifecost1000 if sex==2

replace respondent_marriagecost1000=marriagehusbandcost1000 if sex==1
replace respondent_marriagecost1000=marriagewifecost1000 if sex==2


********** Age as cat
fsum ageatmarriage
fre sex
gen female_agecat=.
replace female_agecat=1 if ageatmarriage<18 & ageatmarriage!=. & sex==2
replace female_agecat=2 if ageatmarriage>=18 & ageatmarriage<25 & ageatmarriage!=. & sex==2
replace female_agecat=3 if ageatmarriage>=25 & ageatmarriage<30 & ageatmarriage!=. & sex==2
replace female_agecat=4 if ageatmarriage>=30 & ageatmarriage<40 & ageatmarriage!=. & sex==2
replace female_agecat=5 if ageatmarriage>=40 & ageatmarriage!=. & sex==2

label define agecat 1"];18[" 2"[18;25[" 3"[25;30[" 4"[30;40[" 5"[40;["
label values female_agecat agecat

tab female_agecat sex, m



********** Quantile income and assets
xtile annualincome_q=annualincome_HH, n(4)
xtile assets_q=assets_total, n(4)

label define inc_q 1"Income - Q1" 2"Income - Q2" 3"Income - Q3" 4"Income - Q4", replace
label define ass_q 1"Assets - Q1" 2"Assets - Q2" 3"Assets - Q3" 4"Assets - Q4", replace

label values annualincome_q inc_q
label values assets_q ass_q


********** Type 2
fre marriagetype
fre marriageblood

gen marriagetype2=.
replace marriagetype2=1 if marriagetype==2
replace marriagetype2=2 if marriagetype==1 & marriageblood==1
replace marriagetype2=3 if marriagetype==1 & marriageblood==2

label define marriagetype2 1"Outside the family" 2"Father's side" 3"Mother's side"
label values marriagetype2 marriagetype2

ta marriagetype2 marriagetype, m
ta marriagetype2 marriageblood, m


save"NEEMSIS2-marriage_v4.dta", replace
****************************************
* END












****************************************
* Mobility
****************************************
use"NEEMSIS2-marriage_v4.dta", clear


***** Inter
*
gen intercaste=0 if married==1
replace intercaste=0 if hwcaste==caste & married==1
replace intercaste=1 if hwcaste!=caste & married==1
ta intercaste
*
gen interjatis=0 if married==1
replace interjatis=0 if husbandwifecaste==jatis & married==1
replace interjatis=1 if husbandwifecaste!=jatis & married==1
ta interjatis

***** Type
/*
Pratiloma --> lower dowry  --> downward mobility
caste femme > caste homme
--> condamné

Anuloma --> higher dowry --> upward mobility for female
caste homme > caste femme
--> toléré
*/

tab jatis caste
tab hwcaste caste
ta intercaste
ta interjatis

label define marrtype 1"Anuloma" 2"Patriloma"
gen marrtype=.
replace marrtype=1 if sex==1 & caste>hwcaste & married==1
replace marrtype=1 if sex==2 & caste<hwcaste & married==1
replace marrtype=2 if sex==1 & caste<hwcaste & married==1
replace marrtype=2 if sex==2 & caste>hwcaste & married==1
label values marrtype marrtype
ta marrtype
list sex caste hwcaste if marrtype==1, clean noobs
list sex caste hwcaste if marrtype==2, clean noobs

ta intercaste
ta interjatis
list sex jatis husbandwifecaste if interjatis==1 & intercaste==1, clean noobs
list sex jatis husbandwifecaste if interjatis==1 & intercaste==0, clean noobs


save"NEEMSIS2-marriage_v5.dta", replace
****************************************
* END
