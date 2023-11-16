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
