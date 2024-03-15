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
* How pay marriage?
****************************************
use"NEEMSIS-marriage.dta", clear

********** Total
cls
ta year
* Loan
ta howpaymarriage_loan year, col nofreq
* Capital
ta howpaymarriage_capi year, col nofreq
* Gift
ta howpaymarriage_gift year, col nofreq


********** Dalits
cls
ta year if caste==1
* Loan
ta howpaymarriage_loan year if caste==1, col nofreq
* Capital
ta howpaymarriage_capi year if caste==1, col nofreq
* Gift
ta howpaymarriage_gift year if caste==1, col nofreq


********** Middle
cls
ta year if caste==2
* Loan
ta howpaymarriage_loan year if caste==2, col nofreq
* Capital
ta howpaymarriage_capi year if caste==2, col nofreq
* Gift
ta howpaymarriage_gift year if caste==2, col nofreq


********** Upper
cls
ta year if caste==3
* Loan
ta howpaymarriage_loan year if caste==3, col nofreq
* Capital
ta howpaymarriage_capi year if caste==3, col nofreq
* Gift
ta howpaymarriage_gift year if caste==3, col nofreq


********** Males
cls
fre sex
ta year if sex==1
* Loan
ta howpaymarriage_loan year if sex==1, col nofreq
* Capital
ta howpaymarriage_capi year if sex==1, col nofreq
* Gift
ta howpaymarriage_gift year if sex==1, col nofreq


********** Females
cls
fre sex
ta year if sex==2
* Loan
ta howpaymarriage_loan year if sex==2, col nofreq
* Capital
ta howpaymarriage_capi year if sex==2, col nofreq
* Gift
ta howpaymarriage_gift year if sex==2, col nofreq

****************************************
* END


















****************************************
* At what cost?
****************************************
/*
- What is the price of the marriage?
- What are the expenses of the marriage?
- Is the cost of marriage different depending on the agricultural status?
- Is the cost of marriage different depending on the agricultural status of the wife's family?
- Is the cost of marriage different depending on the agricultural status of the husband's family?
- Does the cost of the marriage depend on the number of children still to be married?
*/

cls
********** Total cost and expenses of the marriage
use"NEEMSIS-marriage.dta", clear

* Total cost
tabstat marriagetotalcost1000, stat(n mean cv q) by(year) long

tabstat marriagetotalcost1000 if year==2016, stat(n mean cv q) by(intercaste) long
tabstat marriagetotalcost1000 if year==2016, stat(n mean cv q) by(marrtype) long
tabstat marriagetotalcost1000 if year==2016, stat(n mean cv q) by(sex) long

tabstat marriagetotalcost1000 if year==2020, stat(n mean cv q) by(intercaste) long
tabstat marriagetotalcost1000 if year==2020, stat(n mean cv q) by(marrtype) long
tabstat marriagetotalcost1000 if year==2020, stat(n mean cv q) by(sex) long


* Cost to income to have an idea
cls
tabstat CTI, stat(n mean cv q) by(year) long

tabstat CTI if year==2016, stat(n mean cv q) by(intercaste) long
tabstat CTI if year==2016, stat(n mean cv q) by(marrtype) long
tabstat CTI if year==2016, stat(n mean cv q) by(sex) long

tabstat CTI if year==2020, stat(n mean cv q) by(intercaste) long
tabstat CTI if year==2020, stat(n mean cv q) by(marrtype) long
tabstat CTI if year==2020, stat(n mean cv q) by(sex) long


* Total expenses
cls
foreach x in marriageexpenses1000 MEIR MEAR {
tabstat `x', stat(n mean cv q) by(year) long

tabstat `x' if year==2016, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2016, stat(n mean cv q) by(marrtype) long
tabstat `x' if year==2016, stat(n mean cv q) by(sex) long

tabstat `x' if year==2020, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2020, stat(n mean cv q) by(marrtype) long
tabstat `x' if year==2020, stat(n mean cv q) by(sex) long

tabstat `x', stat(n mean cv q) by(sex) long
}





cls
********** Cost of the marriage and agricultural status
use"NEEMSIS-marriage.dta", clear

* Agricultural status
foreach x in ownland divHH10 {
tabstat marriageexpenses1000 MEIR MEAR, stat(n mean q) by(`x') long
}

* Share agri
cpcorr marriageexpenses1000 MEIR MEAR \ incomenonagri_HH shareincomeagri_HH





cls
********** Cost of the marriage and agricultural status of the male's family
use"NEEMSIS-marriage.dta", clear
keep if sex==1

* Agricultural status
foreach x in ownland divHH10 {
tabstat marriageexpenses1000 MEIR MEAR, stat(n mean q) by(`x') long
}

* Share agri
cpcorr marriageexpenses1000 MEIR MEAR \ incomenonagri_HH shareincomeagri_HH





cls
********** Cost of the marriage and agricultural status of the female's family
use"NEEMSIS-marriage.dta", clear
keep if sex==2

* Agricultural status
foreach x in ownland divHH10 {
tabstat marriageexpenses1000 MEIR MEAR, stat(n mean q) by(`x') long
}

* Share agri
cpcorr marriageexpenses1000 MEIR MEAR \ incomenonagri_HH shareincomeagri_HH






cls
********** Cost of the marriage and number of children still to be married
use"NEEMSIS-marriage.dta", clear

* Macro var
global var unmarried_female_1824 unmarried_female_2530 unmarried_female unmarried_daughter unmarried_male_1824 unmarried_male_2530 unmarried_male unmarried_son

* Total
cpcorr $var \ marriageexpenses1000 MEIR MEAR

foreach x in $var {
tabstat marriageexpenses1000 MEIR MEAR, stat(n mean) by(cat_`x')
}


cls
* Males
preserve
keep if sex==1
cpcorr $var \ marriageexpenses1000 MEIR MEAR
cpcorr $var \ marriagehusbandcost

foreach x in $var {
tabstat marriageexpenses1000 MEIR MEAR marriagehusbandcost, stat(n mean) by(cat_`x')
}
restore


cls
* Females
preserve
keep if sex==2
cpcorr $var \ marriageexpenses1000 MEIR MEAR
cpcorr $var \ marriagewifecost2

foreach x in $var {
tabstat marriageexpenses1000 MEIR MEAR marriagewifecost2, stat(n mean) by(cat_`x')
}
restore


****************************************
* END
















****************************************
* How much gifts?
****************************************
/*
- What are the amount of gifts?
- What are the characteristics of low gift group?
- What are the affects of marriage cost on gift received?
- Does the amount of gifts received depend on the number of children still to be married?
*/

cls
********** Amount of gifts
use"NEEMSIS-marriage.dta", clear

foreach x in totalmarriagegiftamount1000 gifttoexpenses GAR GIR gifttocost {
tabstat `x', stat(n mean cv q) by(year) long
tabstat `x', stat(n mean cv q) by(sex) long

tabstat `x' if year==2016, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2016, stat(n mean cv q) by(marrtype) long
tabstat `x' if year==2016, stat(n mean cv q) by(sex) long

tabstat `x' if year==2020, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2020, stat(n mean cv q) by(marrtype) long
tabstat `x' if year==2020, stat(n mean cv q) by(sex) long
}


********** Caractéristiques de low level of gift
* Caractéristiques de l'individu
tab caste lowgift, col nofreq chi2
tab caste lowgift, exp cchi2 chi2
ta edulevel lowgift, col nofreq chi2
ta edulevel lowgift, exp cchi2 chi2
tabstat totalmarriagegiftamount_alt, stat(n mean q) by(edulevel)
reg totalmarriagegiftamount_alt i.edulevel
reg totalmarriagegiftamount_alt i.edulevel if sex==1
reg totalmarriagegiftamount_alt i.edulevel if sex==2
reg totalmarriagegiftamount_alt c.educexp_female_HH
reg totalmarriagegiftamount_alt c.educexp_female_HH if sex==1
reg totalmarriagegiftamount_alt c.educexp_female_HH if sex==2
*ta edulevel lowgift if sex==1, exp cchi2 chi2
*ta edulevel lowgift if sex==2, exp cchi2 chi2
ta sex lowgift, col nofreq chi2
ta working_pop lowgift, col nofreq chi2
ta mainocc_occupation_indiv lowgift, col nofreq chi2

* Caractéristiques du mariage
ta intercaste lowgift, col nofreq chi2
ta interjatis lowgift, col nofreq chi2
reg marriagedowry c.lowgift if sex==1
reg marriagedowry c.lowgift if sex==2
tabstat marriagedowry if sex==2, stat(n mean) by(lowgift)

* Caractéristiques de la famille du/de la marié/e
tabstat assets_totalnoland annualincome_HH shareincomenonagri_HH, stat(n mean) by(lowgift)
reg assets_totalnoland lowgift
pwcorr assets_totalnoland totalmarriagegiftamount_alt, star(0.01)
reg annualincome_HH lowgift
ta status lowgift, col nofreq chi2
ta status lowgift, exp cchi2 chi2
reg shareincomenonagri_HH lowgift
ta divHH10 lowgift, col nofreq chi2
ta ownland lowgift, col nofreq chi2





********** Effects of costs on gift
* Selection
gen selection=marriagehusbandcost+marriagewifecost
drop if selection==.
drop if totalmarriagegiftamount_alt==.

* Stat gift and cost
pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1, star(0.05)
pwcorr totalmarriagegiftamount_alt marriagewifecost if sex==2, star(0.05)
pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2, star(0.05)

* By the level of wealth
pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1 & status==1, star(0.05)
pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1 & status==2, star(0.05)
pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1 & status==3, star(0.05)
pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2 & status==1, star(0.05)
pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2 & status==2, star(0.05)
pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2 & status==3, star(0.05)



* By the family composition
cls
pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1 & cat_unmarried_female==0, star(0.01)
pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1 & cat_unmarried_female==1, star(0.01)

pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1 & cat_unmarried_daughter==0, star(0.01)
pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1 & cat_unmarried_daughter==1, star(0.01)

pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1 & cat_unmarried_male==0, star(0.01)
pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1 & cat_unmarried_male==1, star(0.01)

pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1 & cat_unmarried_son==0, star(0.01)
pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1 & cat_unmarried_son==1, star(0.01)


cls
pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2 & cat_unmarried_female==0, star(0.05)
pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2 & cat_unmarried_female==1, star(0.05)

pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2 & cat_unmarried_daughter==0, star(0.05)
pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2 & cat_unmarried_daughter==1, star(0.05)

pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2 & cat_unmarried_male==0, star(0.05)
pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2 & cat_unmarried_male==1, star(0.05)

pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2 & cat_unmarried_son==0, star(0.05)
pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2 & cat_unmarried_son==1, star(0.05)






cls
********** Amount of the gifts received and number of children still to be married
use"NEEMSIS-marriage.dta", clear

* Macro var
global var unmarried_female_1824 unmarried_female_2530 unmarried_female unmarried_daughter unmarried_male_1824 unmarried_male_2530 unmarried_male unmarried_son

* Total
cpcorr $var \ totalmarriagegiftamount_alt

foreach x in $var {
tabstat totalmarriagegiftamount_alt, stat(n mean q) by(cat_`x')
}


cls
* Males
preserve
keep if sex==1
cpcorr $var \ totalmarriagegiftamount_alt

foreach x in $var {
tabstat totalmarriagegiftamount_alt, stat(n mean q) by(cat_`x')
}
restore


cls
* Females
preserve
keep if sex==2
cpcorr $var \ totalmarriagegiftamount_alt

foreach x in $var {
tabstat totalmarriagegiftamount_alt, stat(n mean q) by(cat_`x')
}
restore




****************************************
* END















****************************************
* Dowry
****************************************
/*
- What are the amount of dowry?
- What are the determinants of the dowry paid? 
- What are the determinants of the dowry received?
- Does the dowry asked by the male's family depend on the family's education expenses?
- Does the dowry sent differ according to the agricultural status of the wife's family?
- Does the dowry received differ according to the agricultural status of the husband's family?
- Does the amount of the dowry sent depend on the number of children still to be married?
- Does the amount of the dowry received depend on the number of children still to be married?
*/


cls
********** Amount
use"NEEMSIS-marriage.dta", clear

* Total
cls
foreach x in marriagedowry1000 DAIR DAAR DMC {
tabstat `x', stat(n mean cv q) by(year) long

tabstat `x' if year==2016, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2016, stat(n mean cv q) by(marrtype) long

tabstat `x' if year==2020, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2020, stat(n mean cv q) by(marrtype) long
}


* Males
preserve
keep if sex==1
cls
foreach x in marriagedowry DAIR DAAR DMC {
tabstat `x' if year==2016, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2020, stat(n mean cv q) by(intercaste) long
}
restore


* Females
preserve
keep if sex==2
cls
foreach x in marriagedowry DAIR DAAR DMC {
tabstat `x', stat(n mean cv q) by(year) long

tabstat `x' if year==2016, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2016, stat(n mean cv q) by(marrtype) long

tabstat `x' if year==2020, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2020, stat(n mean cv q) by(marrtype) long
}
restore







cls
********** Determinants of absolut dowry from the female side
use"NEEMSIS-marriage.dta", clear

* Selection
keep if sex==2

* Reg
reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.intercaste c.nbmarr_male c.nbmarr_female c.educexp_female_HH, baselevel
est store reg1

reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.interjatis c.nbmarr_male c.nbmarr_female c.educexp_female_HH, baselevel
est store reg2

reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.intercaste c.nbmarr_male c.nbmarr_female c.educexp_female_HH i.marriagespousefamily, baselevel
est store reg3

reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.interjatis c.nbmarr_male c.nbmarr_female c.educexp_female_HH i.marriagespousefamily, baselevel
est store reg4

esttab reg1 reg2 reg3 reg4 using "_reg.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
	
	
	
	

cls
********** Determinants of the relative dowry from the female side
use"NEEMSIS-marriage.dta", clear

* Selection
keep if sex==2

* Reg
reg DAIR i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.intercaste c.nbmarr_male c.nbmarr_female c.educexp_female_HH, baselevel
est store reg1

reg DAIR i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.interjatis c.nbmarr_male c.nbmarr_female c.educexp_female_HH, baselevel
est store reg2

reg DAIR i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.intercaste c.nbmarr_male c.nbmarr_female c.educexp_female_HH i.marriagespousefamily, baselevel
est store reg3

reg DAIR i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.interjatis c.nbmarr_male c.nbmarr_female c.educexp_female_HH i.marriagespousefamily, baselevel
est store reg4

esttab reg1 reg2 reg3 reg4 using "_reg.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))


	
	
cls
********** Determinants of absolut dowry from the male side
use"NEEMSIS-marriage.dta", clear

* Selection
keep if sex==1

* Reg
reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.intercaste c.nbmarr_male c.nbmarr_female c.educexp_male_HH, baselevel
est store reg1

reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.interjatis c.nbmarr_male c.nbmarr_female c.educexp_male_HH, baselevel
est store reg2

reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.intercaste c.nbmarr_male c.nbmarr_female c.educexp_male_HH i.marriagespousefamily, baselevel
est store reg3

reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.interjatis c.nbmarr_male c.nbmarr_female c.educexp_male_HH i.marriagespousefamily, baselevel
est store reg4

esttab reg1 reg2 reg3 reg4 using "_reg.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))







cls
********** Dowry asked and education expenses
use"panel_HH.dta", clear

* Selection
drop if marrdow_male_HH==0
drop if marrdow_male_HH==.
fre caste
ta year


* Total expenses
pwcorr educexp_HH marrdow_male_HH, star(0.05)
pwcorr educexp_HH marrdow_male_HH if caste==1, star(0.05)
pwcorr educexp_HH marrdow_male_HH if caste==2, star(0.05)
pwcorr educexp_HH marrdow_male_HH if caste==3, star(0.05)
pwcorr educexp_HH marrdow_male_HH if caste==1 | caste==2, star(0.05)

* Expenses in education of males
pwcorr educexp_male_HH marrdow_male_HH, star(0.05)
pwcorr educexp_male_HH marrdow_male_HH if caste==1, star(0.05)
pwcorr educexp_male_HH marrdow_male_HH if caste==2, star(0.05)
pwcorr educexp_male_HH marrdow_male_HH if caste==3, star(0.05)
pwcorr educexp_male_HH marrdow_male_HH if caste==1 | caste==2, star(0.05)



* Expenses in education of females
pwcorr educexp_female_HH marrdow_male_HH, star(0.05)
pwcorr educexp_female_HH marrdow_male_HH if caste==1, star(0.05)
pwcorr educexp_female_HH marrdow_male_HH if caste==2, star(0.05)
pwcorr educexp_female_HH marrdow_male_HH if caste==3, star(0.05)
pwcorr educexp_female_HH marrdow_male_HH if caste==1 | caste==2, star(0.05)





cls
********** Dowry asked and housing expenditures
use"panel_HH.dta", clear

* Selection
drop if marrdow_male_HH==0
drop if marrdow_male_HH==.
fre caste
ta year

* Credit reason given
pwcorr totHH_givenamt_hous marrdow_male_HH, star(0.05)
pwcorr totHH_givenamt_hous marrdow_male_HH if caste==1, star(0.05)
pwcorr totHH_givenamt_hous marrdow_male_HH if caste==2, star(0.05)
pwcorr totHH_givenamt_hous marrdow_male_HH if caste==3, star(0.05)
pwcorr totHH_givenamt_hous marrdow_male_HH if caste==1 | caste==2, star(0.05)


* Credit effective reason)
pwcorr totHH_effectiveamt_hous marrdow_male_HH, star(0.05)
pwcorr totHH_effectiveamt_hous marrdow_male_HH if caste==1, star(0.05)
pwcorr totHH_effectiveamt_hous marrdow_male_HH if caste==2, star(0.05)
pwcorr totHH_effectiveamt_hous marrdow_male_HH if caste==3, star(0.05)
pwcorr totHH_effectiveamt_hous marrdow_male_HH if caste==1 | caste==2, star(0.05)







cls
********** Agricultural status and dowry sent
use"NEEMSIS-marriage.dta", clear

* Prepa
fre sex
keep if sex==2

* Agricultural status
foreach x in ownland divHH10 {
tabstat marriagedowry1000 DAIR DAAR DMC, stat(n mean q) by(`x') long
}

* Share agri
cpcorr marriagedowry1000 DAIR DAAR DMC \ incomenonagri_HH shareincomeagri_HH







cls
********** Agricultural status and dowry received
use"NEEMSIS-marriage.dta", clear

* Prepa
fre sex
keep if sex==1

* Agricultural status
foreach x in ownland divHH10 {
tabstat marriagedowry1000, stat(n mean q) by(`x') long
}

* Share agri
cpcorr marriagedowry \ incomenonagri_HH shareincomeagri_HH





cls
********** Amount of the dowry sent and number of children still to be married
use"NEEMSIS-marriage.dta", clear

* Macro var
global var unmarried_female_1824 unmarried_female_2530 unmarried_female unmarried_daughter unmarried_male_1824 unmarried_male_2530 unmarried_male unmarried_son

fre sex
keep if sex==2
cpcorr $var \ marriagedowry1000

foreach x in $var {
tabstat marriagedowry1000, stat(n mean q) by(cat_`x')
}


/*
- La dot moyenne versé par les familles des épouses pour lesquelles il reste des femmes/filles célibataires/à marier est plus élevée que celle versé par les familles pour lesquelles il ne reste pas de célibataires.
- Les familles où il reste des fils non mariés versent une dot plus élevée que les familles où il ne reste pas de fils non mariés.
*/










cls
********** Amount of the dowry received and number of children still to be married
use"NEEMSIS-marriage.dta", clear

* Macro var
global var unmarried_female_1824 unmarried_female_2530 unmarried_female unmarried_daughter unmarried_male_1824 unmarried_male_2530 unmarried_male unmarried_son

fre sex
keep if sex==1
cpcorr $var \ marriagedowry1000

foreach x in $var {
tabstat marriagedowry1000, stat(n mean q) by(cat_`x')
}

/*
- Les familles où il reste des fils non mariés recoivent une dot plus élevée que les familles où il ne reste pas de fils non mariés.
*/



****************************************
* END















****************************************
* Marriage net cost (expenses + dowry)
****************************************
/*
- What is the net cost of the marriage? (expenses and dowry together)
*/

cls
use"NEEMSIS-marriage.dta", clear

ta cat_cost sex, col nofreq

fre cat_cost

* By sex
tabstat marriagenetcost1000 MNCI marriagenetcost_alt1000 MNCI_alt, stat(n mean q) by(sex)

* By sex and status
tabstat marriagenetcost_alt1000 MNCI_alt if sex==1, stat(n mean q) by(cat_cost)
tabstat marriagenetcost_alt1000 MNCI_alt if sex==2, stat(n mean q) by(cat_cost)

* By sex, status and land
tabstat marriagenetcost_alt1000 MNCI_alt if sex==1 & cat_cost==3, stat(n mean q) by(ownland)
tabstat marriagenetcost_alt1000 MNCI_alt if sex==2 & cat_cost==1, stat(n mean q) by(ownland)

tabstat marriagenetcost_alt1000 MNCI_alt if sex==1 & cat_cost==3, stat(n mean q) by(divHH10)
tabstat marriagenetcost_alt1000 MNCI_alt if sex==2 & cat_cost==1, stat(n mean q) by(divHH10)

* By sex and caste
tabstat marriagenetcost_alt1000 MNCI_alt if sex==1, stat(n mean q) by(caste) long
tabstat marriagenetcost_alt1000 MNCI_alt if sex==2, stat(n mean q) by(caste) long

* By sex and land
tabstat marriagenetcost_alt1000 MNCI_alt if sex==1, stat(n mean q) by(ownland) long
tabstat marriagenetcost_alt1000 MNCI_alt if sex==2, stat(n mean q) by(ownland) long

tabstat marriagenetcost_alt1000 MNCI_alt if sex==1, stat(n mean q) by(divHH10) long
tabstat marriagenetcost_alt1000 MNCI_alt if sex==2, stat(n mean q) by(divHH10) long


****************************************
* END





