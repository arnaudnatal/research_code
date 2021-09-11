/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
20 avril 2021
-----
TITLE: CLEANING MARRIAGE NEEMSIS1


-------------------------
*/

clear all

global directory "D:\Documents\_Thesis\Research-Marriage\Data"


****************************************
* GIFT cleaning
****************************************
*Marriage gift with old marriedid (with 31)
*First: recreate the old one
use "$directory\NEEMSIS1\NEEMSIS1-HH_v7.dta", clear

preserve
bysort HHID2010: gen n=_n
keep if n==1
tab dummymarriage  // 190 HH face one marriage or more between 2010 and 2016
tab marriedlist if marriedlist!="." & marriedlist!=""
restore

*List
split marriedlist
destring marriedlist1 marriedlist2 marriedlist3 marriedlist4, replace
gen married=0
replace married=1 if INDID==marriedlist1
replace married=1 if INDID==marriedlist2
replace married=1 if INDID==marriedlist3
replace married=1 if INDID==marriedlist4
drop marriedlist1 marriedlist2 marriedlist3 marriedlist4

keep INDID2010 dummydemonetisation age sex egoid caste jatis married dummymarriagegift marriagegiftsource marriagegiftnb_wellknown marriagegiftnb_shg marriagegiftnb_relatives marriagegiftnb_employer marriagegiftnb_maistry marriagegiftnb_colleagues marriagegiftnb_shopkeeper marriagegiftnb_friends marriagegifttype_wellknown marriagegifttype_shg marriagegifttype_relatives marriagegifttype_employer marriagegifttype_maistry marriagegifttype_colleagues marriagegifttype_shopkeeper marriagegifttype_friends marriagegiftamount_wellknown marriagegiftamount_shg marriagegiftamount_relatives marriagegiftamount_employer marriagegiftamount_maistry marriagegiftamount_colleagues marriagegiftamount_shopkeeper marriagegiftamount_friends marriagegoldamount_wellknown marriagegoldamount_relatives marriagegoldamount_employer marriagegoldamount_friends

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
reshape long marriagegiftnb marriagegifttype marriagegiftamount marriagegiftsource marriagegoldquantityasgift, i(INDID2010)  j(num)
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

order INDID2010 egoid jatis sex age caste married dummymarriagegift marriagegiftsource marriagegiftsourcenb marriagegifttype marriagegifttype_gold marriagegifttype_cash marriagegifttype_clothes marriagegifttype_furniture marriagegifttype_vessels marriagegiftamount marriagegoldquantityasgift


save"$directory\NEEMSIS1\NEEMSIS1-marriagegift.dta", replace
****************************************
* END















****************************************
* MARRIAGE HH cleaning
****************************************
use "$directory\NEEMSIS1\NEEMSIS1-HH_v7.dta", clear

preserve
bysort HHID2010: gen n=_n
keep if n==1
tab dummymarriage  // 190 HH face one marriage or more between 2010 and 2016
tab marriedlist if marriedlist!="." & marriedlist!=""
restore

/*
********** Structure du HH
keep if livinghome==1 | livinghome==2
fre relationshiptohead
fre maritalstatus
fre livinghome
*Unmarried married
gen _nbmarried=0
gen _nbunmarried=0
gen _nbson=0
gen _nbdaughter=0
gen _nbmarriedson=0
gen _nbmarrieddaughter=0
gen _nbunmarriedson=0
gen _nbunmarrieddaughter=0

replace _nbmarried=1 if maritalstatus==1
replace _nbunmarried=1 if maritalstatus==2 | maritalstatus==5
replace _nbson=1 if relationshiptohead==5
replace _nbdaughter=1 if relationshiptohead==6
replace _nbmarriedson=1 if maritalstatus==1 & relationshiptohead==5
replace _nbmarrieddaughter=1 if maritalstatus==1 & relationshiptohead==6
replace _nbunmarriedson=1 if (maritalstatus==2 | maritalstatus==5) & relationshiptohead==5
replace _nbunmarrieddaughter=1 if (maritalstatus==2 | maritalstatus==5) & relationshiptohead==6

foreach x in nbmarried nbunmarried nbson nbdaughter nbmarriedson nbmarrieddaughter nbunmarriedson nbunmarrieddaughter{
bysort HHID2010: egen `x'=sum(_`x')
drop _`x'
}

*Gender
fre sex
gen _nbmale=0
gen _nbfemale=0

replace _nbmale=1 if sex==1
replace _nbfemale=1 if sex==2

foreach x in nbmale nbfemale{
bysort HHID2010: egen `x'=sum(_`x')
drop _`x'
}


********** Sex ratios and unmarried married ratio
bysort HHID2010: gen n=_n
keep if n==1

gen sexratio=nbmale/nbfemale
gen femaleunmarriedratio=nbunmarrieddaughter/nbdaughter
gen maleunmarriedratio=nbunmarriedson/nbson
tab1 femaleunmarriedratio maleunmarriedratio
*/

*Keep the HH
keep if dummymarriage==1

*Keep the individuals
*keep if husbandwifecaste!=.

decode howpaymarriage, gen(howpaymarriage_n)
drop howpaymarriage
rename howpaymarriage_n howpaymarriage

*Gen totalgiftamount
egen totalmarriagegiftamount=rowtotal(marriagegiftamount_wellknown marriagegiftamount_shg marriagegiftamount_relatives marriagegiftamount_employer marriagegiftamount_maistry marriagegiftamount_colleagues marriagegiftamount_shopkeeper marriagegiftamount_friends)

keep HHID_panel HHID2010 villageid villagearea jatis caste INDID egoid name sex age edulevel submissiondate relationshiptohead dummynewHH dummydemonetisation ///
married dummymarriagegift dummymarriage marriedlist husbandwifecaste marriagedowry marriagetotalcost howpaymarriage marriageexpenses dummymarriagegift totalmarriagegiftamount ///
 semiformal_indiv formal_indiv economic_indiv current_indiv humancap_indiv social_indiv house_indiv incomegen_indiv noincomegen_indiv economic_amount_indiv current_amount_indiv humancap_amount_indiv social_amount_indiv house_amount_indiv incomegen_amount_indiv noincomegen_amount_indiv informal_amount_indiv formal_amount_indiv semiformal_amount_indiv marriageloan_indiv marriageloanamount_indiv marriageloan_mar_indiv marriageloanamount_mar_indiv marriageloan_fin_indiv marriageloanamount_fin_indiv dummyproblemtorepay_indiv dummyhelptosettleloan_indiv dummyinterest_indiv loans_indiv loanamount_indiv loanbalance_indiv imp1_ds_tot_HH imp1_is_tot_HH informal_HH semiformal_HH formal_HH economic_HH current_HH humancap_HH social_HH house_HH incomegen_HH noincomegen_HH economic_amount_HH current_amount_HH humancap_amount_HH social_amount_HH house_amount_HH incomegen_amount_HH noincomegen_amount_HH informal_amount_HH formal_amount_HH semiformal_amount_HH marriageloan_HH marriageloanamount_HH marriageloan_mar_HH marriageloanamount_mar_HH marriageloan_fin_HH marriageloanamount_fin_HH dummyproblemtorepay_HH dummyhelptosettleloan_HH dummyinterest_HH loans_HH loanamount_HH loanbalance_HH mainoccupation_hours_indiv mainoccupation_income_indiv mainoccupation_indiv mainoccupationname_indiv totalincome_indiv nboccupation_indiv mainoccupation_HH totalincome_HH nboccupation_HH assets assets_noland contactlist nbcontact_headbusiness nbcontact_policeman nbcontact_civilserv nbcontact_bankemployee nbcontact_panchayatcommittee nbcontact_peoplecouncil nbcontact_recruiter nbcontact_headunion dummycontactleaders contactleaders associationlist associationid1 associationid2 associationid3 associationname1 associationname2 associationname3 assodegreeparticip1 assodegreeparticip2 assodegreeparticip3 assosize1 assosize2 assosize3 dummyassorecommendation1 dummyassorecommendation2 dummyassorecommendation3 nbercontactphone nberpersonfamilyevent schemerecipient_cashmarriage schemerecipient_goldmarriage schemeamount_cashmarriage marriagegoldamount_wellknown marriagegoldamount_relatives marriagegoldamount_employer marriagegoldamount_friends schemeamount_goldmarriage

 
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
tab hwcaste caste, m


*Age at marriage
tab age
gen yearborn1=yofd(dofc(submissiondate))
gen yearborn=yearborn1-age
gen yearmarriage=2013
gen ageatmarriage=yearmarriage-yearborn if husbandwifecaste!=.
drop yearborn1 yearborn yearmarriage
tab ageatmarriage
sort ageatmarriage



save "$directory\complet\NEEMSIS1-marriage.dta", replace
****************************************
* END









****************************************
* Network for marriage
****************************************
use"$directory\complet\NEEMSIS1-marriage.dta", replace

********** Egoid var
preserve
keep if egoid>0
keep contactlist nbcontact_headbusiness nbcontact_policeman nbcontact_civilserv nbcontact_bankemployee nbcontact_panchayatcommittee nbcontact_peoplecouncil nbcontact_recruiter nbcontact_headunion dummycontactleaders contactleaders associationlist associationid1 associationid2 associationid3 associationname1 associationname2 associationname3 assodegreeparticip1 assodegreeparticip2 assodegreeparticip3 assosize1 assosize2 assosize3 dummyassorecommendation1 dummyassorecommendation2 dummyassorecommendation3 nbercontactphone nberpersonfamilyevent egoid HHID2010
reshape wide contactlist nbcontact_headbusiness nbcontact_policeman nbcontact_civilserv nbcontact_bankemployee nbcontact_panchayatcommittee nbcontact_peoplecouncil nbcontact_recruiter nbcontact_headunion dummycontactleaders contactleaders associationlist associationid1 associationid2 associationid3 associationname1 associationname2 associationname3 assodegreeparticip1 assodegreeparticip2 assodegreeparticip3 assosize1 assosize2 assosize3 dummyassorecommendation1 dummyassorecommendation2 dummyassorecommendation3 nbercontactphone nberpersonfamilyevent, i(HHID2010) j(egoid)
save"$directory\NEEMSIS1\NEEMSIS1-asso_contact_HH.dta", replace
restore

merge m:1 HHID2010 using "$directory\NEEMSIS1\NEEMSIS1-asso_contact_HH.dta"
keep if _merge==3
drop _merge
keep if husbandwifecaste!=.
dropmiss, force



********** Cleaning
tab1 associationid11 associationid21 associationid31 associationid12
tab1 assodegreeparticip11 assodegreeparticip21 assodegreeparticip31 assodegreeparticip12


gen dummyasso=0
foreach x in associationid11 associationid21 associationid31 associationid12{
replace dummyasso=1 if `x'!=.
}
tab dummyasso
label define asso 0"No asso" 1"Asso"
label values dummyasso asso


********** Cleaning size network & qualityt
tab1 nbercontactphone1 nbercontactphone2
fre nbercontactphone1

gen contactphone=. 
replace contactphone=1 if nbercontactphone1==7
replace contactphone=2 if nbercontactphone1==1
replace contactphone=2 if nbercontactphone1==2
replace contactphone=3 if nbercontactphone1==3
replace contactphone=4 if nbercontactphone1==4
replace contactphone=4 if nbercontactphone1==5
replace contactphone=4 if nbercontactphone1==6
tab nbercontactphone1 contactphone

*Quality
tab1 dummycontactleaders1 dummycontactleaders2
tab contactleaders1
gen leaders=0
replace leaders=1 if contactleaders1=="ADMK"
replace leaders=1 if contactleaders1=="ADMK district chairman"
replace leaders=1 if contactleaders1=="ADMK organization"
replace leaders=1 if contactleaders1=="AIADMK"
replace leaders=1 if contactleaders1=="Admk"
replace leaders=3 if contactleaders1=="Agriculture department"
replace leaders=3 if contactleaders1=="Appar"
replace leaders=3 if contactleaders1=="Jamath"
replace leaders=3 if contactleaders1=="Kulalar sangam"
replace leaders=3 if contactleaders1=="Lorry owner association"
replace leaders=3 if contactleaders1=="PMK"
replace leaders=4 if contactleaders1=="DMK"
replace leaders=4 if contactleaders1=="Dmk"
replace leaders=4 if contactleaders1=="Dmk, Arasan"

tab leaders

label define leaders 1"ADMK" 2"Panchayat" 3"Other" 4"DMK"
label values leaders leaders
tab leaders



save"$directory\NEEMSIS1\NEEMSIS1-marriage_v2.dta", replace
****************************************
* END











****************************************
* Creation
****************************************
use"$directory\NEEMSIS1\NEEMSIS1-marriage_v2.dta", clear


********* 1000 var
foreach x in marriagedowry marriagetotalcost marriageexpenses{
gen `x'1000=`x'/1000
}


********** On assets
*
gen MEAR=marriageexpenses/assets
*
gen DAAR=.
replace DAAR=marriagedowry/assets if sex==2






********** On income
*
gen MEIR=marriageexpenses/totalincome_HH
*
gen DAIR=.
replace DAIR=marriagedowry/totalincome_HH if sex==2







********** On cost
*
gen DMC=.
replace DMC=marriagedowry/marriagetotalcost





********** Intercaste marriage
gen intercaste=0 if hwcaste==caste
replace intercaste=1 if hwcaste!=caste






********** Gift
gen gifttoexpenses=totalmarriagegiftamount/marriageexpenses
gen gifttocost=.

gen benefitsexpenses=0
replace benefitsexpenses=1 if gifttoexpenses>1 & gifttoexpenses!=.
tab1 gifttoexpenses benefitsexpenses






********** Gift on income and assets
gen GAR=totalmarriagegiftamount/assets
gen GIR=totalmarriagegiftamount/totalincome_HH



save"$directory\NEEMSIS1\NEEMSIS1-marriage_v3.dta", replace
****************************************
* END




********** Analysis

gen totalmarriagegiftamount1000=totalmarriagegiftamount/1000

*Dummy asso
tabstat totalmarriagegiftamount1000 marriageexpenses1000, stat(n mean sd q max) by(dummyasso) 

*Nbercontact
tabstat totalmarriagegiftamount1000 marriageexpenses1000, stat(n mean sd q max) by(contactphone)

*Leaders
tabstat totalmarriagegiftamount1000 marriageexpenses1000, stat(n mean sd q max) by(dummycontactleaders1)





********** Anumola Parimola
tab husbandwifecaste intercaste
tab hwcaste caste if intercaste==1
tab husbandwifecaste jatis
tab intercaste

tab husbandwifecaste jatis if sex==1 & intercaste==1
tab husbandwifecaste jatis if sex==2 & intercaste==1

