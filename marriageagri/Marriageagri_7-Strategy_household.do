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

*****************************************************/







****************************************
* Marriage, agriculture, education and housing
****************************************
use"panel_HH.dta", clear


********** Declining share of agriculture
* Share
ta caste year
ta ownland year, col nofreq
*ta ownland year if caste==1, col nofreq
*ta ownland year if caste==2, col nofreq
*ta ownland year if caste==3, col nofreq

* Amount
tabstat shareincomeagri_HH, stat(n mean p50) by(year)
*tabstat shareincomeagri_HH if caste==1, stat(n mean p50) by(year)
*tabstat shareincomeagri_HH if caste==2, stat(n mean p50) by(year)
*tabstat shareincomeagri_HH if caste==3, stat(n mean p50) by(year)


* Remarks
/*
54.3% des ménages ont de la terre en 2010. Ils sont 31.3% à en avoir en 2016-17 et 34.7% en 2020-21.
En moyenne, 43.2% du revenu des ménages provient de l'agriculturen contre 32.5% en 2016-17 et 34.6% en 2020-21.
*/



********** Volatility of non-agricultural income
preserve
replace incomenonagri_HH=incomenonagri_HH/1000
replace incomeagri_HH=incomeagri_HH/1000
tabstat incomenonagri_HH incomeagri_HH, stat(n mean cv) by(year) long
restore




********** Investment in education
* Share
ta dumeducexp_male_HH year, col nofreq
*ta dumeducexp_male_HH year if caste==1, col nofreq
*ta dumeducexp_male_HH year if caste==2, col nofreq
*ta dumeducexp_male_HH year if caste==3, col nofreq

ta dumeducexp_female_HH year, col nofreq
*ta dumeducexp_female_HH year if caste==1, col nofreq
*ta dumeducexp_female_HH year if caste==2, col nofreq
*ta dumeducexp_female_HH year if caste==3, col nofreq

* Amount
preserve
replace educexp_male_HH=educexp_male_HH/1000
tabstat educexp_male_HH if dumeducexp_male_HH==1, stat(n mean p50) by(year) long
restore
*tabstat educexp_male_HH if dumeducexp_male_HH==1 & caste==1, stat(n mean p50) by(year) long
*tabstat educexp_male_HH if dumeducexp_male_HH==1 & caste==2, stat(n mean p50) by(year) long
*tabstat educexp_male_HH if dumeducexp_male_HH==1 & caste==3, stat(n mean p50) by(year) long

preserve
replace educexp_female_HH=educexp_female_HH/1000
tabstat educexp_female_HH if dumeducexp_female_HH==1, stat(n mean p50) by(year) long
restore
*tabstat educexp_female_HH if dumeducexp_female_HH==1 & caste==1, stat(n mean p50) by(year) long
*tabstat educexp_female_HH if dumeducexp_female_HH==1 & caste==2, stat(n mean p50) by(year) long
*tabstat educexp_female_HH if dumeducexp_female_HH==1 & caste==3, stat(n mean p50) by(year) long

* Tests
ttest educexp_male_HH==educexp_female_HH
ttest educexp_male_HH==educexp_female_HH, unpaired
ttest educexp_male_HH==educexp_female_HH, unpaired unequal

* Remarks
/*
Les familles investissent plus dans l'éducation des garçons que des filles.
Les montants pour l'éducation des garçons sont plus élevés que les montants engagés pour les filles.
*/



********** Dépenses d'habitation
* Share
ta dumHH_given_hous year, col nofreq
*ta dumHH_given_hous year if caste==1, col nofreq
*ta dumHH_given_hous year if caste==2, col nofreq
*ta dumHH_given_hous year if caste==3, col nofreq

ta dumHH_effective_hous year, col nofreq
*ta dumHH_effective_hous year if caste==1, col nofreq
*ta dumHH_effective_hous year if caste==2, col nofreq
*ta dumHH_effective_hous year if caste==3, col nofreq


* Absolut
preserve
replace totHH_givenamt_hous=totHH_givenamt_hous/1000
tabstat totHH_givenamt_hous if totHH_givenamt_hous!=0, stat(n mean p50) by(year) long
restore
*tabstat totHH_givenamt_hous if totHH_givenamt_hous!=0 & caste==1, stat(n mean p50) by(year) long
*tabstat totHH_givenamt_hous if totHH_givenamt_hous!=0 & caste==2, stat(n mean p50) by(year) long
*tabstat totHH_givenamt_hous if totHH_givenamt_hous!=0 & caste==3, stat(n mean p50) by(year) long

preserve
replace totHH_effectiveamt_hous=totHH_effectiveamt_hous/1000
tabstat totHH_effectiveamt_hous if totHH_effectiveamt_hous!=0, stat(n mean p50) by(year) long
restore
*tabstat totHH_effectiveamt_hous if totHH_effectiveamt_hous!=0 & caste==1, stat(n mean p50) by(year) long
*tabstat totHH_effectiveamt_hous if totHH_effectiveamt_hous!=0 & caste==2, stat(n mean p50) by(year) long
*tabstat totHH_effectiveamt_hous if totHH_effectiveamt_hous!=0 & caste==3, stat(n mean p50) by(year) long


* Relative
preserve
replace totHH_givenamt_hous=(totHH_givenamt_hous/annualincome_HH)*100
tabstat totHH_givenamt_hous if totHH_givenamt_hous!=0, stat(n mean p50) by(year) long
restore
*tabstat totHH_givenamt_hous if totHH_givenamt_hous!=0 & caste==1, stat(n mean p50) by(year) long
*tabstat totHH_givenamt_hous if totHH_givenamt_hous!=0 & caste==2, stat(n mean p50) by(year) long
*tabstat totHH_givenamt_hous if totHH_givenamt_hous!=0 & caste==3, stat(n mean p50) by(year) long

preserve
replace totHH_effectiveamt_hous=(totHH_effectiveamt_hous/annualincome_HH)*100
tabstat totHH_effectiveamt_hous if totHH_effectiveamt_hous!=0, stat(n mean p50) by(year) long
restore
*tabstat totHH_effectiveamt_hous if totHH_effectiveamt_hous!=0 & caste==1, stat(n mean p50) by(year) long
*tabstat totHH_effectiveamt_hous if totHH_effectiveamt_hous!=0 & caste==2, stat(n mean p50) by(year) long
*tabstat totHH_effectiveamt_hous if totHH_effectiveamt_hous!=0 & caste==3, stat(n mean p50) by(year) long



* Remarks
/*
La part de ménage s'endettant pour la maison augmente : 29.4% en 2010, 28.1% en 2016-17, 39.4% en 2020-21.
La part de ménage utilisant au moins un prêt pour la maison augmente : 24.2% en 2010, 30.6% en 2016-17, 39.4% en 2020-21.

Les montants investi sont en cloche : forte augmentation entre 2010 et 2016-17, puis diminution entre 2016-17 et 2020-21.
*/

****************************************
* END
















****************************************
* Dowry and agriculture at the marriage level
****************************************

cls
********** Females
/*
Est-ce que la dot envoyé est différente selon le statut agricole de la femme ?
*/
use"NEEMSIS-marriage.dta", clear

*** Prepa
fre sex
keep if sex==2

global amoun marriagedowry
global ratio DAIR DAAR DMC
global total $amoun $ratio

foreach x in $amoun {
replace `x'=`x'/1000
}
foreach x in $ratio {
replace `x'=`x'*100
}

cls
*** Agricultural status
*divHH0 divHH5
foreach x in ownland divHH10 {
tabstat $total, stat(n mean q) by(`x') long
}

/*
Ceux qui sont propriétaire terrien ont des dots plus élevés en moyenne.
Ceux qui sont propriétaire terrien ont un ratio de dot/revenu plus élevé.
Ceux qui sont propriétaire terrien ont un ratio de dot/actifs plus faible.
*/


*** Share agri
cpcorr $total \ incomenonagri_HH shareincomeagri_HH







cls
********** Males
/*
Est-ce que la dot reçu est différente selon le statut agricole de l'homme ?
*/
use"NEEMSIS-marriage.dta", clear

*** Prepa
fre sex
keep if sex==1

replace marriagedowry=marriagedowry/1000

*** Agricultural status
*divHH0 divHH5
foreach x in ownland divHH10 {
tabstat marriagedowry, stat(n mean q) by(`x') long
}

/*
Ceux qui sont propriétaire terrien ont des dots plus élevés en moyenne.
Ceux qui sont propriétaire terrien ont un ratio de dot/revenu plus élevé.
Ceux qui sont propriétaire terrien ont un ratio de dot/actifs plus faible.
*/


*** Share agri
cpcorr marriagedowry \ incomenonagri_HH shareincomeagri_HH

****************************************
* END















****************************************
* Marriage and other investments at the HH level
****************************************
use"panel_HH.dta", clear

*4. Marital transfers (primarily dowry) play a crucial role in compensating for a volatile economy, i.e. agricultural decline, uncertain non-farm labour market, risky investment in education of boys, expensive housing expenditures

********** Selection
drop if year==2010
drop if dummymarriage_female==0
ta dummymarriage_female
ta year
replace marrdow_female_HH=marrdow_female_HH/1000


********** Stats

cls
*** Education dummies
foreach x in dumeducexp_male_HH dumeducexp_female_HH {
tabstat marrdow_female_HH, stat(n mean cv q) by(`x')
}

stripplot marrdow_female_HH, over(dumeducexp_male_HH) vert ///
stack width(0.01) jitter(1) /// //refline(lp(dash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh oh) msize(small) mc(black%30) ///
xla(, ang(h)) yla(, valuelabel noticks) ///
xmtick() ymtick() ///
legend(order(1 "Mean" 4 "Whisker from 5% to 95%" 5 "Individual") pos(6) col(3) on) ///
xtitle("") ytitle("")



cls
*** Education continuous
reg marrdow_female_HH educexp_male_HH
reg marrdow_female_HH educexp_female_HH


cls
*** Housing dummy
foreach x in dumHH_given_hous dumHH_effective_hous {
tabstat marrdow_female_HH, stat(n mean cv q) by(`x')
}


cls
*** Housing continuous
reg marrdow_female_HH totHH_givenamt_hous
reg marrdow_female_HH totHH_effectiveamt_hous


****************************************
* END










****************************************
* Cost of the marriage and agriculture at the marriage level
****************************************
use"NEEMSIS-marriage.dta", clear

*** Prepa

global amoun marriageexpenses marriagetotalcost
global ratio MEIR MEAR
global total $amoun $ratio

foreach x in $amoun {
replace `x'=`x'/1000
}
foreach x in $ratio {
replace `x'=`x'*100
}

cls
*** Agricultural status
foreach x in ownland divHH10 {
tabstat $total, stat(n mean q) by(`x') long
}


*** Share agri
cpcorr $total \ incomenonagri_HH shareincomeagri_HH




cls
********** Males
use"NEEMSIS-marriage.dta", clear
keep if sex==1

*** Prepa
global amoun marriageexpenses
global ratio MEIR MEAR
global total $amoun $ratio

foreach x in $amoun {
replace `x'=`x'/1000
}
foreach x in $ratio {
replace `x'=`x'*100
}

*** Agricultural status
foreach x in ownland divHH10 {
tabstat $total, stat(n mean q) by(`x') long
}

*** Share agri
cpcorr $total \ incomenonagri_HH shareincomeagri_HH





cls
********** Females
use"NEEMSIS-marriage.dta", clear
keep if sex==2

*** Prepa
global amoun marriageexpenses
global ratio MEIR MEAR
global total $amoun $ratio

foreach x in $amoun {
replace `x'=`x'/1000
}
foreach x in $ratio {
replace `x'=`x'*100
}

*** Agricultural status
foreach x in ownland divHH10 {
tabstat $total, stat(n mean q) by(`x') long
}

*** Share agri
cpcorr $total \ incomenonagri_HH shareincomeagri_HH







****************************************
* END

