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

ta marriedlistdummy


*List
rename marriedlistdummy married
ta married

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
rename marriedlistdummy married
ta married

*Keep the HH
keep if dummymarriage==1

*Keep the individuals
*keep if husbandwifecaste!=.

decode howpaymarriage, gen(howpaymarriage_n)
drop howpaymarriage
rename howpaymarriage_n howpaymarriage

*Gen totalgiftamount
egen totalmarriagegiftamount=rowtotal(marriagegiftamount_wellknown marriagegiftamount_shg marriagegiftamount_relatives marriagegiftamount_employer marriagegiftamount_maistry marriagegiftamount_colleagues marriagegiftamount_shopkeeper marriagegiftamount_friends)

keep HHID2016 INDID2016 villageid villagearea jatis egoid name sex age  relationshiptohead submissiondate ownland ///
married dummymarriagegift dummymarriage marriedlist husbandwifecaste marriagedowry marriagetotalcost howpaymarriage marriageexpenses dummymarriagegift totalmarriagegiftamount currentlyatschool everattendedschool canread educationexpenses

 
*Caste
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


*Age at marriage
tab age
gen yearborn1=yofd(dofc(submissiondate))
gen yearborn=yearborn1-age
gen yearmarriage=2013
gen ageatmarriage=yearmarriage-yearborn if husbandwifecaste!=.
drop yearborn1 yearborn yearmarriage
tab ageatmarriage
sort ageatmarriage


*How pay marriage?
fre howpaymarriage
gen howpaymarriage_loan=0 if howpaymarriage!=""
gen howpaymarriage_capi=0 if howpaymarriage!=""
gen howpaymarriage_gift=0 if howpaymarriage!=""

replace howpaymarriage_loan=1 if howpaymarriage=="Both"
replace howpaymarriage_loan=1 if howpaymarriage=="Loan"
replace howpaymarriage_capi=1 if howpaymarriage=="Both"
replace howpaymarriage_capi=1 if howpaymarriage=="Own capital / Savings"
replace howpaymarriage_gift=1 if dummymarriagegift==1

label define yesno 0"No" 1"Yes"
label values howpaymarriage_loan yesno
label values howpaymarriage_capi yesno
label values howpaymarriage_gift yesno


fre howpaymarriage_loan
fre howpaymarriage_capi
fre howpaymarriage_gift
order howpaymarriage_loan howpaymarriage_capi howpaymarriage_gift, after(howpaymarriage)

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

merge m:1 HHID2016 using "raw/NEEMSIS1-family"
keep if _merge==3
drop _merge

merge m:1 HHID2016 using "raw/NEEMSIS1-occup_HH"
keep if _merge==3
drop _merge

merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-occup_indiv"
keep if _merge==3
drop _merge

merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-caste", keepusing(jatiscorr caste)
keep if _merge==3
drop _merge
label define castegrp 1"Dalits" 2"Middles" 3"Uppers"
label values caste castegrp

merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-education", keepusing(edulevel)
keep if _merge==3
drop _merge



********** Indicator
* 
label define divHH 1"Agricultural household" 2"Non-agricultural household" 3"Diversified household"
gen divHH0=.
replace divHH0=1 if shareincomeagri_HH==1
replace divHH0=2 if shareincomeagri_HH==0
replace divHH0=3 if shareincomeagri_HH!=0 & shareincomeagri_HH!=1 & shareincomeagri_HH!=.
label values divHH0 divHH
fre divHH0
gen divHH5=.
replace divHH5=1 if shareincomeagri_HH>=0.95
replace divHH5=2 if shareincomeagri_HH<=0.05
replace divHH5=3 if shareincomeagri_HH>0.05 & shareincomeagri_HH<0.95 & shareincomeagri_HH!=.
label values divHH5 divHH
fre divHH5
gen divHH10=.
replace divHH10=1 if shareincomeagri_HH>=0.9
replace divHH10=2 if shareincomeagri_HH<=0.1
replace divHH10=3 if shareincomeagri_HH>0.1 & shareincomeagri_HH<0.9 & shareincomeagri_HH!=.
label values divHH10 divHH
fre divHH10
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


save"NEEMSIS1-marriage_v2.dta", replace
****************************************
* END














****************************************
* Mobility
****************************************
use"NEEMSIS1-marriage_v2.dta", clear


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
replace marrtype=2 if sex==2 & caste<hwcaste & married==1 & hwcaste==88
replace marrtype=1 if sex==1 & caste<hwcaste & married==1 & hwcaste==88
label values marrtype marrtype
ta marrtype
list sex caste hwcaste if marrtype==1, clean noobs
list sex caste hwcaste if marrtype==2, clean noobs

ta intercaste
ta interjatis
list sex jatis husbandwifecaste if interjatis==1 & intercaste==1, clean noobs
list sex jatis husbandwifecaste if interjatis==1 & intercaste==0, clean noobs


save"NEEMSIS1-marriage_v3.dta", replace
****************************************
* END

