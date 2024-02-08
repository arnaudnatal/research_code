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




/*****************************************************

TITLE:
The political and sexual economies of marriages. Two decades of change in South-Arcot, South India

AUTHORS:
I. Guérin, A. Natal, C. J. Nordman, and G. Venkatasubramanian

JOURNAL:
Contemporary South Asia

ABSTRACT:
This chapter explores the multifaceted role of marriages in the south-Arcot region of central Tamil Nadu.
There are cases of forced celibacy, but they remain isolated.
By mobilising twenty years of ethnographic survey, and three household surveys conducted in 2010, 2016-17 and 2020-21, including questions on marriages (who marries whom? at what cost? with a dowry and if so how much?), this paper will examine how marriages are both shaped by and constitutive of local political and sexual economies. 
By local political and sexual economies, we mean the intertwining of access to material resources, norms of kinship and deviant sexuality.
As feminist anthropology has long shown, modes of accumulation, kinship and sexuality are inseparable and mutually constructed.
The drastic and interconnected changes observed over the last two decades in modes of production, marital alliances and the control of female sexuality are a clear illustration of this.
Our data suggest two main findings, which explains the reasons behind low prevalence of forced celibacy, while highlighting the intensification of patriarchal norms: First, marriages and marital transfers (primarily dowry) play a crucial role in compensating for a volatile economy, whether it is agricultural decline (with the exception of the pandemic period, agricultural incomes are declining, both in absolute and relative terms), a precarious and uncertain non-farm labour market, and costly and risky investments in education (of boys in particular) and expensive housing expenditures.
In turn, and this is our second argument, the dowry, which is a recent practice among the lower castes and classes, strongly devalues the economic value of young girls and is accompanied by increasing control over women's bodies and sexuality as a symbol of upward mobility.
The paper will also examine the differences between families that remained solely peasant and those that diversified, exploring the role of marriages and marriage payments in these differentiated strategies.

KEYWORDS:
Marriage, kinship, sexuality, economy, Tamil Nadu

STATISTICAL ANALYSIS:
1. Who maries whom?
2. At what cost?
3. What about dowry?
4. Marital transfers (primarily dowry) play a crucial role in compensating for a volatile economy, i.e. agricultural decline, uncertain non-farm labour market, risky investment in education of boys, expensive housing expenditures
5. Dowry as a symbol of upward mobility
6. Differences between families that remained solely peasant and those that diversified, exploring the role of marriages and marriage payments in these differentiated strategies

PLAN D'ANALYSE:
1. Statistiques des variables de mariage sans hétérogéneité pour 2016-17 et 2020-21
2. Statistiques qui montrent le déclin de l'agriculture
3. Statistiques qui montrent la volatilité des revenus non-agricoles
4. Statistiques qui montrent les montants d'investissement dans l'éducation en séparant les hommes et femmes
5. Statistiques qui montrent les dépenses d'habitations
6. Dowry par type de mariage pour upward mobility
7. Classer les ménages en fonction des types de revenus qu'ils ont : que agri, que non-agri, les deux
8. Faire une part de agri/non agri aussi


*****************************************************/













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
cls
use"NEEMSIS-marriage.dta", clear

* Total cost
preserve
replace marriagetotalcost=marriagetotalcost/1000
tabstat marriagetotalcost, stat(n mean cv q) by(year) long

tabstat marriagetotalcost if year==2016, stat(n mean cv q) by(intercaste) long
tabstat marriagetotalcost if year==2016, stat(n mean cv q) by(marrtype) long
tabstat marriagetotalcost if year==2016, stat(n mean cv q) by(sex) long

tabstat marriagetotalcost if year==2020, stat(n mean cv q) by(intercaste) long
tabstat marriagetotalcost if year==2020, stat(n mean cv q) by(marrtype) long
tabstat marriagetotalcost if year==2020, stat(n mean cv q) by(sex) long
restore

* Cost to income to have an idea
gen CTI=(marriagetotalcost/annualincome_HH)*100
cls
foreach x in CTI {
tabstat `x', stat(n mean cv q) by(year) long

tabstat `x' if year==2016, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2016, stat(n mean cv q) by(marrtype) long
tabstat `x' if year==2016, stat(n mean cv q) by(sex) long

tabstat `x' if year==2020, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2020, stat(n mean cv q) by(marrtype) long
tabstat `x' if year==2020, stat(n mean cv q) by(sex) long
}


* Total expenses
replace MEIR=MEIR*100
replace MEAR=MEAR*100
replace marriageexpenses=marriageexpenses/1000

cls
foreach x in marriageexpenses MEIR MEAR {
tabstat `x', stat(n mean cv q) by(year) long

tabstat `x' if year==2016, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2016, stat(n mean cv q) by(marrtype) long
tabstat `x' if year==2016, stat(n mean cv q) by(sex) long

tabstat `x' if year==2020, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2020, stat(n mean cv q) by(marrtype) long
tabstat `x' if year==2020, stat(n mean cv q) by(sex) long

tabstat `x', stat(n mean cv q) by(sex) long
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
tabstat `x' if year==2016, stat(n mean cv q) by(sex) long

tabstat `x' if year==2020, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2020, stat(n mean cv q) by(marrtype) long
tabstat `x' if year==2020, stat(n mean cv q) by(sex) long
}

cls
foreach x in totalmarriagegiftamount gifttoexpenses GIR {
tabstat `x', stat(n mean cv q) by(sex) long
}

reg totalmarriagegiftamount i.sex, baselevel

****************************************
* END









****************************************
* Dowry
****************************************
use"NEEMSIS-marriage.dta", clear

* Clean
replace DAIR=DAIR*100
replace DMC=DMC*100
replace DAAR=DAAR*100
replace marriagedowry=marriagedowry/1000


* Total
cls
foreach x in marriagedowry DAIR DAAR DMC {
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
keep if sex==2
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


























****************************************
* Expenses and dowry
****************************************
cls
use"NEEMSIS-marriage.dta", clear



********** By sex
tabstat marriagenetcost1000 MNCI marriagenetcost_alt1000 MNCI_alt, stat(n mean q) by(sex)


********** By sex and caste
tabstat marriagenetcost_alt1000 MNCI_alt if sex==1, stat(n mean q) by(caste) long
tabstat marriagenetcost_alt1000 MNCI_alt if sex==2, stat(n mean q) by(caste) long


********** By sex and land
tabstat marriagenetcost_alt1000 MNCI_alt if sex==1, stat(n mean q) by(ownland) long
tabstat marriagenetcost_alt1000 MNCI_alt if sex==2, stat(n mean q) by(ownland) long

tabstat marriagenetcost_alt1000 MNCI_alt if sex==1, stat(n mean q) by(divHH10) long
tabstat marriagenetcost_alt1000 MNCI_alt if sex==2, stat(n mean q) by(divHH10) long




****************************************
* END







/*
C'est normal que la dot déclarée par les hommes soit plus faible car argent en plus pour eux
Pour les femmes, normalement, c'est un peu sous estimé

Bien faire des commentaires sur les deux graphiques où je calcule le prix net du mariage
+ Une fois ce commentaire et ces graphiques fait
+ Dire que le mariage s'est aussi de la dette et faire des stat sur la dette pour mariage

Mettre en relation MNCI + la dette du mariage avec le statut agricole.
*/


