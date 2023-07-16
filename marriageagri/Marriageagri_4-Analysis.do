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
* Check
****************************************
/*
Vérification des unoccupied male car il y en a beaucoup..
*/
use"NEEMSIS1-marriage_v2.dta", clear
keep if sex==1
keep if married==1
keep if working_pop==2
keep HHID2016 INDID2016 name age sex caste
save"check", replace

use"raw/NEEMSIS1-occupations", clear
keep HHID2016 INDID2016 occupationname kindofwork annualincome
sort annualincome
bysort HHID2016 INDID2016: egen sum_income=sum(annualincome)
keep HHID2016 INDID2016 sum_income
duplicates drop
merge 1:1 HHID2016 INDID2016 using "check"

****************************************
* END







****************************************
* Who's married?
****************************************
cls

********** NEEMSIS-1 (2016-17)
use"NEEMSIS1-marriage_v2.dta", clear
keep if married==1

* Socio-demo
ta sex
tabstat age, stat(n mean q) by(sex)
ta caste sex, col nofreq

* Edu
ta canread sex, col nofreq
ta everattendedschool sex, col nofreq
ta currentlyatschool sex
ta edulevel sex, col nofreq

* Labour
ta working_pop sex
recode mainocc_occupation_indiv (.=0)
ta mainocc_occupation_indiv sex, col nofreq



********** NEEMSIS-2 (2020-21)
use"NEEMSIS2-marriage_v5.dta", clear

* Socio-demo
ta sex
tabstat age, stat(n mean q) by(sex)
ta caste sex, col nofreq

* Edu
ta canread sex
ta everattendedschool sex
ta currentlyatschool sex
ta edulevel sex, col nofreq

* Labour
ta working_pop sex
recode mainocc_occupation_indiv (.=0)
ta mainocc_occupation_indiv sex, col nofreq

****************************************
* END

















****************************************
* Whith whom? -1
****************************************
cls

********** NEEMSIS-1 (2016-17)
use"NEEMSIS1-marriage_v3", clear
keep if married==1

* Global
ta intercaste
ta marrtype
ta interjatis
ta interjatis intercaste, cell nofreq

* Details castes
ta caste hwcaste
ta caste hwcaste, row nofreq

* Details marrtype
sort marrtype sex caste
list sex caste hwcaste marrtype if marrtype!=., clean noobs


********** NEEMSIS-2 (2020-21)
use"NEEMSIS2-marriage_v5", clear
keep if married==1

* Global
ta intercaste
ta marrtype
ta interjatis
ta interjatis intercaste, cell nofreq

* Details castes
ta caste hwcaste
ta caste hwcaste, row nofreq

* Details marrtype
sort marrtype sex caste
list sex caste hwcaste marrtype if marrtype!=., clean noobs

****************************************
* END










****************************************
* Whith whom? -2
****************************************
cls

********** NEEMSIS-2 (2020-21)
use"NEEMSIS2-marriage_v5", clear
keep if married==1

* Economic
ta marriagespousefamily
ta sex 				marriagespousefamily, row nofreq
ta caste 			marriagespousefamily, row nofreq
ta intercaste 		marriagespousefamily, row nofreq
ta interjatis 		marriagespousefamily, row nofreq
ta marriagearranged	marriagespousefamily, row nofreq

* Type
ta marriagetype2
ta sex 				marriagetype2, row nofreq
ta caste 			marriagetype2, row nofreq
ta intercaste 		marriagetype2, row nofreq
ta interjatis 		marriagetype2, row nofreq
ta marriagearranged	marriagetype2, row nofreq

* Arranged
ta marriagearranged
ta sex 				marriagearranged, row nofreq
ta caste 			marriagearranged, row nofreq
ta intercaste 		marriagearranged, row nofreq
ta interjatis 		marriagearranged, row nofreq
/*
C'est drôle, les mariages d'amour ne sont pas intercastes et quasi par interjatis
*/

****************************************
* END











****************************************
* At what cost?
****************************************
cls
use"NEEMSIS-marriage.dta", clear

* Total cost
replace marriagetotalcost=marriagetotalcost/1000
tabstat marriagetotalcost, stat(n mean cv q) by(year) long

tabstat marriagetotalcost if year==2016, stat(n mean cv q) by(intercaste) long
tabstat marriagetotalcost if year==2016, stat(n mean cv q) by(marrtype) long

tabstat marriagetotalcost if year==2020, stat(n mean cv q) by(intercaste) long
tabstat marriagetotalcost if year==2020, stat(n mean cv q) by(marrtype) long

* Total expenses
replace MEIR=MEIR*100
replace MEAR=MEAR*100
replace marriageexpenses=marriageexpenses/1000

cls
foreach x in marriageexpenses MEIR MEAR {
tabstat `x', stat(n mean cv q) by(year) long

tabstat `x' if year==2016, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2016, stat(n mean cv q) by(marrtype) long

tabstat `x' if year==2020, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2020, stat(n mean cv q) by(marrtype) long
}


* Gift
foreach x in gifttoexpenses GAR GIR gifttocost {
replace `x'=`x'*100
}
replace totalmarriagegiftamount=totalmarriagegiftamount/1000

cls
foreach x in totalmarriagegiftamount gifttoexpenses GAR GIR gifttocost {
tabstat `x', stat(n mean cv q) by(year) long

tabstat `x' if year==2016, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2016, stat(n mean cv q) by(marrtype) long

tabstat `x' if year==2020, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2020, stat(n mean cv q) by(marrtype) long
}

****************************************
* END














****************************************
* Dowry?
****************************************
use"NEEMSIS-marriage.dta", clear

* Clean
replace DAIR=DAIR*100
replace DMC=DMC*100
replace DAAR=DAAR*100
replace marriagedowry=marriagedowry/1000


* Females
keep if sex==2
fre sex
cls
foreach x in marriagedowry DAIR DAAR DMC {
tabstat `x', stat(n mean cv q) by(year) long

tabstat `x' if year==2016, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2016, stat(n mean cv q) by(marrtype) long

tabstat `x' if year==2020, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2020, stat(n mean cv q) by(marrtype) long
}



****************************************
* END

















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



