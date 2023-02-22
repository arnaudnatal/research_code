*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*February 22, 2023
*-----
gl link = "marriageagri"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\marriageagri.do"
*-------------------------








****************************************
* GIFT cleaning
****************************************
*Marriage gift with old marriedid (with 31)
*First: recreate the old one
use "raw\NEEMSIS1-HH.dta", clear

preserve
bysort HHID2016: gen n=_n
keep if n==1
tab dummymarriage  // 190 HH face one marriage or more between 2010 and 2016
tab marriedlist if marriedlist!="." & marriedlist!=""
restore

*List
split marriedlist
destring marriedlist1 marriedlist2 marriedlist3 marriedlist4, replace
gen married=0
replace married=1 if INDID2016==marriedlist1
replace married=1 if INDID2016==marriedlist2
replace married=1 if INDID2016==marriedlist3
replace married=1 if INDID2016==marriedlist4
drop marriedlist1 marriedlist2 marriedlist3 marriedlist4

keep HHID2016 INDID2016 age sex name egoid jatis married dummymarriagegift marriagegiftsource marriagegiftnb_wellknown marriagegiftnb_shg marriagegiftnb_relatives marriagegiftnb_employer marriagegiftnb_maistry marriagegiftnb_colleagues marriagegiftnb_shopkeeper marriagegiftnb_friends marriagegifttype_wellknown marriagegifttype_shg marriagegifttype_relatives marriagegifttype_employer marriagegifttype_maistry marriagegifttype_colleagues marriagegifttype_shopkeeper marriagegifttype_friends marriagegiftamount_wellknown marriagegiftamount_shg marriagegiftamount_relatives marriagegiftamount_employer marriagegiftamount_maistry marriagegiftamount_colleagues marriagegiftamount_shopkeeper marriagegiftamount_friends marriagegoldamount_wellknown marriagegoldamount_relatives marriagegoldamount_employer marriagegoldamount_friends

keep if married==1

gen marriagegiftnb1=marriagegiftnb_wellknown
gen marriagegifttype1=marriagegifttype_wellknown
gen marriagegiftamount1=marriagegiftamount_wellknown
gen marriagegiftsource1=1 if marriagegiftnb1!=.
gen marriagegoldquantityasgift1=marriagegoldamount_wellknown

gen marriagegiftnb2=marriagegiftnb_relatives
gen marriagegifttype2=marriagegifttype_relatives
gen marriagegiftamount2=marriagegiftamount_relatives
gen marriagegiftsource2=2 if marriagegiftnb2!=.
gen marriagegoldquantityasgift2=marriagegoldamount_relatives

gen marriagegiftnb3=marriagegiftnb_employer
gen marriagegifttype3=marriagegifttype_employer
gen marriagegiftamount3=marriagegiftamount_employer
gen marriagegiftsource3=3 if marriagegiftnb3!=.
gen marriagegoldquantityasgift3=marriagegoldamount_employer

gen marriagegiftnb4=marriagegiftnb_maistry
gen marriagegifttype4=marriagegifttype_maistry
gen marriagegiftamount4=marriagegiftamount_maistry
gen marriagegiftsource4=4 if marriagegiftnb4!=.

gen marriagegiftnb5=marriagegiftnb_colleagues
gen marriagegifttype5=marriagegifttype_colleagues
gen marriagegiftamount5=marriagegiftamount_colleagues
gen marriagegiftsource5=5 if marriagegiftnb5!=.

gen marriagegiftnb7=marriagegiftnb_shopkeeper
gen marriagegifttype7=marriagegifttype_shopkeeper
gen marriagegiftamount7=marriagegiftamount_shopkeeper
gen marriagegiftsource7=7 if marriagegiftnb7!=.

gen marriagegiftnb9=marriagegiftnb_friends
gen marriagegifttype9=marriagegifttype_friends
gen marriagegiftamount9=marriagegiftamount_friends
gen marriagegiftsource9=9 if marriagegiftnb9!=.
gen marriagegoldquantityasgift9=marriagegoldamount_friends

gen marriagegiftnb10=marriagegiftnb_shg
gen marriagegifttype10=marriagegifttype_shg
gen marriagegiftamount10=marriagegiftamount_shg
gen marriagegiftsource10=10 if marriagegiftnb10!=.

foreach x in marriagegifttype4 marriagegifttype7{
tostring `x', replace
}

drop marriagegiftsource
reshape long marriagegiftnb marriagegifttype marriagegiftamount marriagegiftsource marriagegoldquantityasgift, i(HHID2016 INDID2016)  j(num)
drop marriagegiftnb_wellknown marriagegiftnb_shg marriagegiftnb_relatives marriagegiftnb_employer marriagegiftnb_maistry marriagegiftnb_colleagues marriagegiftnb_shopkeeper marriagegiftnb_friends marriagegifttype_wellknown marriagegifttype_shg marriagegifttype_relatives marriagegifttype_employer marriagegifttype_maistry marriagegifttype_colleagues marriagegifttype_shopkeeper marriagegifttype_friends marriagegiftamount_wellknown marriagegiftamount_shg marriagegiftamount_relatives marriagegiftamount_employer marriagegiftamount_maistry marriagegiftamount_colleagues marriagegiftamount_shopkeeper marriagegiftamount_friends marriagegoldamount_wellknown marriagegoldamount_relatives marriagegoldamount_employer marriagegoldamount_friends

keep if marriagegiftnb!=.
label define giftsource 1"WKP" 2"Relatives" 3"Employer" 4"Maistry" 5"Colleague" 6"Paw broker" 7"Shop keeper" 8"Finance" 9"Friends" 10"SHG" 11"Banks" 12"Coop bank" 13"Sugar mill loan" 14"Group finance"
label values marriagegiftsource giftsource

rename marriagegiftnb marriagegiftsourcenb
split marriagegifttype
destring marriagegifttype1 marriagegifttype2 marriagegifttype3 marriagegifttype4 marriagegifttype5, replace

forvalues i=1(1)5{
gen marriagegifttype_`i'=0
}

forvalues j=1(1)5{
forvalues i=1(1)5{
replace marriagegifttype_`i'=1 if marriagegifttype`j'==`i'
}
}

drop marriagegifttype1 marriagegifttype2 marriagegifttype3 marriagegifttype4 marriagegifttype5

rename marriagegifttype_1 marriagegifttype_gold
rename marriagegifttype_2 marriagegifttype_cash
rename marriagegifttype_3 marriagegifttype_clothes
rename marriagegifttype_4 marriagegifttype_furniture
rename marriagegifttype_5 marriagegifttype_vessels

drop num

order HHID2016 INDID2016 egoid jatis sex age name married dummymarriagegift marriagegiftsource marriagegiftsourcenb marriagegifttype marriagegifttype_gold marriagegifttype_cash marriagegifttype_clothes marriagegifttype_furniture marriagegifttype_vessels marriagegiftamount marriagegoldquantityasgift


save"NEEMSIS1-marriagegift.dta", replace
****************************************
* END















****************************************
* MARRIAGE HH cleaning
****************************************
use "raw/NEEMSIS1-HH.dta", clear

preserve
bysort HHID2016: gen n=_n
keep if n==1
tab dummymarriage  // 190 HH face one marriage or more between 2010 and 2016
tab marriedlist if marriedlist!="." & marriedlist!=""
restore

*Keep the HH
keep if dummymarriage==1

*Keep the individuals
*keep if husbandwifecaste!=.

decode howpaymarriage, gen(howpaymarriage_n)
drop howpaymarriage
rename howpaymarriage_n howpaymarriage

*Gen totalgiftamount
egen totalmarriagegiftamount=rowtotal(marriagegiftamount_wellknown marriagegiftamount_shg marriagegiftamount_relatives marriagegiftamount_employer marriagegiftamount_maistry marriagegiftamount_colleagues marriagegiftamount_shopkeeper marriagegiftamount_friends)

keep HHID2016 INDID2016 villageid villagearea jatis egoid name sex age  relationshiptohead submissiondate ///
married dummymarriagegift dummymarriage marriedlist husbandwifecaste marriagedowry marriagetotalcost howpaymarriage marriageexpenses dummymarriagegift totalmarriagegiftamount

 
*Caste
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


*Age at marriage
tab age
gen yearborn1=yofd(dofc(submissiondate))
gen yearborn=yearborn1-age
gen yearmarriage=2013
gen ageatmarriage=yearmarriage-yearborn if husbandwifecaste!=.
drop yearborn1 yearborn yearmarriage
tab ageatmarriage
sort ageatmarriage

save "NEEMSIS1-marriage.dta", replace
****************************************
* END













****************************************
* Creation
****************************************
use"NEEMSIS1-marriage.dta", clear


********* 1000 var
foreach x in marriagedowry marriagetotalcost marriageexpenses{
gen `x'1000=`x'/1000
}




********** Merge with assets, income, etc.
merge m:1 HHID2016 using "raw/NEEMSIS1-assets", keepusing(assets*)
keep if _merge==3
drop _merge

merge m:1 HHID2016 using "raw/NEEMSIS1-occup_HH", keepusing(annualincome_HH)
keep if _merge==3
drop _merge

merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-caste", keepusing(jatiscorr caste)
keep if _merge==3
drop _merge


********** Indicator
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
gen intercaste=0 if hwcaste==caste
replace intercaste=1 if hwcaste!=caste
*
gen gifttoexpenses=totalmarriagegiftamount/marriageexpenses
gen gifttocost=.
*
gen benefitsexpenses=0
replace benefitsexpenses=1 if gifttoexpenses>1 & gifttoexpenses!=.
*
gen GAR=totalmarriagegiftamount/assets_total
gen GIR=totalmarriagegiftamount/annualincome_HH



save"NEEMSIS1-marriage_v2.dta", replace
****************************************
* END





/*
********** Anumola Parimola
tab husbandwifecaste intercaste
tab hwcaste caste if intercaste==1
tab husbandwifecaste jatis
tab intercaste

tab husbandwifecaste jatis if sex==1 & intercaste==1
tab husbandwifecaste jatis if sex==2 & intercaste==1

