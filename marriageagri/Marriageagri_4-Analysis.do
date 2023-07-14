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
* Who's married?
****************************************

********** NEEMSIS-1 (2016-17)
use"NEEMSIS1-marriage_v2.dta", clear
gen dummyland=.
replace dummyland=0 if assets_sizeownland==.
replace dummyland=1 if assets_sizeownland!=. &  assets_sizeownland!=0

keep if married==1

* Socio-demo
ta sex
tabstat age, stat(n mean q) by(sex)
ta age sex
ta caste sex

* Edu
ta canread sex
ta everattendedschool sex
ta currentlyatschool sex
ta edulevel sex

* Labour
ta working_pop sex
ta mainocc_occupation_indiv sex

* HH characteristics
tabstat assets_totalnoland annualincome_HH, stat(n mean cv p50) by(sex)
ta dummyland sex


********** NEEMSIS-2 (2020-21)
use"NEEMSIS2-marriage_v5.dta", clear





****************************************
* END












****************************************
* Preliminary analysis
****************************************
use"NEEMSIS2-marriage_v5.dta", clear



********** Who marries?
tab caste sex, nofreq col
tab edulevel sex, nofreq col
tabstat ageatmarriage, stat(n mean p50) by(sex)




********** Type of marriage
tab caste
tab hwcaste caste, cell nofreq
tab hwcaste caste if sex==1
tab hwcaste caste if sex==2
tab marriagearranged caste, col nofreq
tab marriagetype caste, col nofreq
tab marriagespousefamily caste, col nofreq
tabstat peoplewedding, stat(mean sd p50 min max) by(caste)




********** % of expenses in capital
preserve
bysort HHID2020: egen sum_marriageexpenses=sum(marriageexpenses)
duplicates drop HHID2020, force
drop if sum_marriageexpenses==. | sum_marriageexpenses==0
tab caste
restore




********** How pay the marriage?
tab1 howpaymarriage_loan howpaymarriage_capital howpaymarriage_gift
/*
102/117 marriages were paid with loan
113/117 marriages were paid with capital
7/117 marriages were paid with gift 

pb bc i have only 38 values in marriageexpenses
*/
order howpaymarriage_capital marriageexpenses, last
sort howpaymarriage_capital marriageexpenses
*I have 75 missings


********** Cost of marriage
* Marriage
tabstat marriagetotalcost1000 husbandsharemarriage wifesharemarriage, stat(mean sd p50) by(caste)
* Engagement
tabstat engagementtotalcost1000 husbandshareengagement wifeshareengagement, stat(mean sd p50) by(caste)
* Dowry
tabstat marriagedowry1000 DWTC DWTCnodowry, stat(n mean sd p50) by(caste)
* Total
tabstat totalcost1000 husbandsharetotal wifesharetotal, stat(n mean sd p50) by(caste)



********** Relative cost of marriage
* Points
gen assets1000=assets/1000
gen totalincome1000_HH=totalincome_HH/1000
tabstat assets1000 totalincome1000_HH, stat(n mean sd p50) by(sex)
* Assets
tabstat MCAR ECAR DAAR TCAR, stat(n mean sd p50) by(sex)
* Income
tabstat MCIR ECIR DAIR TCIR, stat(n mean sd p50) by(sex)
* Expenses
tabstat marriageexpenses1000 MEAR MEIR MEMC, stat(n mean sd p50) by(sex)




********** Schemes
tab schemeamount7 intercaste
tab schemeamount8 intercaste
*Nothing





********** Gift as form of saving?
fre dummymarriagegift
fre sex
gen totalmarriagegiftamount1000=totalmarriagegiftamount/1000
* Gift and relative to cost 
tabstat totalmarriagegiftamount1000 gifttoexpenses gifttocost, stat(n mean sd p50) by(sex)
* Gift relative to assets and income
tabstat GAR GIR, stat(n mean sd p50) by(sex)
* Benefits on marriage ceremony
tab benefitscost sex, col
tab benefitsexpenses sex, col



********** Net benefits of marriage
tabstat netbenefitsmarriage, stat(n mean sd min q max) by(sex) 
tabstat BAR BIR, stat(n mean sd p50) by(sex)
tabstat BAR BIR if netbenefitsmarriage>1, stat(n mean sd p50) by(sex)
reg netbenefitsmarriage i.sex i.caste
/*
Est-ce que quand le HH est au placé, il dégage plus de profit?
Si jamais il appartient à un Panchayat, etc
*/



********** Gift and people wedding
plot totalmarriagegiftamount peoplewedding




********** If better situation is the cost higher ?
tabstat wifesharemarriage if sex==1, stat(n mean sd p50) by(marriagespousefamily)
tabstat husbandsharemarriage if sex==2, stat(n mean sd p50) by(marriagespousefamily)




********** Type of marriage
tabstat marriagetotalcost1000, stat(n min p50 max)

****************************************
* END
















****************************************
* Network
****************************************
use"$directory\NEEMSIS2\NEEMSIS2-marriage_v5.dta", clear


*Dummy asso
tabstat peoplewedding totalmarriagegiftamount1000 partycost1000, stat(n mean sd q max) by(dummyasso) 

*Nbercontact
tab contactphone sex, row nofreq
tabstat peoplewedding totalmarriagegiftamount1000 partycost1000, stat(n mean sd q max) by(contactphone)

*Leaders
tab dummycontactleaders1 sex
tabstat peoplewedding totalmarriagegiftamount1000 partycost1000, stat(n mean sd q max) by(dummycontactleaders1)


****************************************
* END














****************************************
* Aspiration and social mobility
****************************************
use"$directory\NEEMSIS2\NEEMSIS2-marriage_v6.dta", clear

********** Aspirations
twoway ///
|| scatter  marriagedowry1000 assets1000 if sex==2 ///
|| lfit  marriagedowry1000 assets1000 if sex==2 ///
|| scatter  marriagedowry1000 assets1000 if sex==1 & assets1000<1000 ///
|| lfit  marriagedowry1000 assets1000 if sex==1 & assets1000<1000

plot marriagedowry1000 assets1000 if sex==2
plot marriagedowry1000 assets1000 if sex==1



********** Intercaste
tab anuloma
tab pratiloma


stripplot marriagedowry1000, over(marriagemobility) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(100)1200) ymtick(0(50)1200) ytitle() ///
msymbol(oh oh oh) mcolor(plr1 ply1 plg1) 


********** Voir plus finement
* Dowry for middle wife without mobility
tab marriagedowry1000 if (caste==2 | hwcaste==2) & marriagemobility==2
* Dowry for middle wife with mobility
tab marriagedowry1000 if (caste==2 | hwcaste==2) & sex==2 & marriagemobility==3

****************************************
* END



