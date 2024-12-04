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

replace totalmarriagegiftamount_alt=totalmarriagegiftamount_alt/1000

********** Desc

tab caste abs_lowgift, col nofreq chi2
ta educ_attainment2 abs_lowgift, col nofreq chi2
ta sex abs_lowgift, col nofreq chi2
ta working_pop abs_lowgift, col nofreq chi2
ta mainocc_occupation_indiv abs_lowgift, col nofreq chi2


tab caste rel_lowgift, col nofreq chi2
ta educ_attainment2 rel_lowgift, col nofreq chi2
ta sex rel_lowgift, col nofreq chi2
ta working_pop rel_lowgift, col nofreq chi2
ta mainocc_occupation_indiv rel_lowgift, col nofreq chi2


tabstat totalmarriagegiftamount_alt, stat(n mean) by(assets_q)
tabstat totalmarriagegiftamount_alt, stat(n mean) by(caste)


********** OLS

*** Absolut
reg abs_lowgift i.caste i.educ_attainment2 i.sex i.working_pop i.assets_q i.ownland i.divHH10, baselevel
reg totalmarriagegiftamount_alt i.caste i.educ_attainment2 i.sex i.working_pop i.assets_q i.ownland i.divHH10, baselevel


*** Relative to cost
reg rel_lowgift i.caste i.educ_attainment2 i.sex i.working_pop i.assets_q i.ownland i.divHH10, baselevel
reg gifttocost i.caste i.educ_attainment2 i.sex i.working_pop i.assets_q i.ownland i.divHH10, baselevel











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

pwcorr marriagedowry1000 educexp_female_HH
pwcorr marriagedowry1000 educexp_female_HH if caste==1
pwcorr marriagedowry1000 educexp_female_HH if caste==2
pwcorr marriagedowry1000 educexp_female_HH if caste==3


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
********** Determinants of absolut dowry from the male side STD
use"NEEMSIS-marriage.dta", clear

* Selection
keep if sex==1

* Std assets et educ pour comparer les coefficients
ta educexp_female_HH
replace educexp_female_HH=educexp_female_HH/1000

* Sans educ. R2=.2203 (.1592) = +4.06 (+3.98)
reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.intercaste c.nbmarr_male c.nbmarr_female i.ownland, baselevel

* Sans la terre. R2=.2365 (.1766) = +2.44 (+2.24)
reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.intercaste c.nbmarr_male c.nbmarr_female c.educexp_female_HH, baselevel

* Avec les deux. R2=.2609 (.1990)
reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.intercaste c.nbmarr_male c.nbmarr_female i.ownland c.educexp_female_HH, baselevel



	
	
	
	
	
	
	
	





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
pwcorr educexp_female_HH marrdow_male_HH, star(0.01)
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

* By sex
tabstat marriagenetcost1000 MNCI, stat(n mean) by(sex)

* By sex and status
tabstat marriagenetcost1000 MNCI if sex==1, stat(n mean) by(cat_cost)
tabstat marriagenetcost1000 MNCI if sex==2, stat(n mean) by(cat_cost)

cls
* By sex, status and land
ta cat_cost sex if year==2020, col

tabstat marriagenetcost1000 MNCI if sex==1 & cat_cost==1, stat(n mean) by(ownland)

tabstat marriagenetcost1000 MNCI if sex==2 & cat_cost==3, stat(n mean) by(ownland)


ta MNCI if sex==2 & cat_cost==3 & year==2020

****************************************
* END





