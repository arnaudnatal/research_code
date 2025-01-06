*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*October 8, 2024
*-----
gl link = "networks"
*Correction base alters et bases couples
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\networks.do"
*-------------------------








****************************************
* Who are the egos? Socio-eco
****************************************
cls
use"Analysis/Main_analyses_v3", clear

ta egoid
ta sex
ta caste


*** Age
tabstat age, stat(n mean median) by(sex)
tabstat age, stat(n mean median) by(caste)

*** Education
ta edulevel sex, col nofreq
ta edulevel caste, col nofreq

*** Occupation
ta occupation sex, col nofreq
ta occupation caste, col nofreq

****************************************
* END










****************************************
* Who are the egos? Networks
****************************************
cls
use"Analysis/Main_analyses_v3", clear


*** Taille
tabstat netsize_all, stat(n mean med) by(sex)
tabstat netsize_all, stat(n mean med) by(caste)


*** Durée des relations
tabstat duration_corr, stat(n mean med) by(sex)
tabstat duration_corr, stat(n mean med) by(caste)

*** Force
tabstat strength_mca, stat(n mean med) by(sex)
tabstat strength_mca, stat(n mean med) by(caste)



*** Homo/hétéro caste
ta IQV_caste
/*
- Pour la caste, envisager de faire une binaire : 0 = 100% homo, 1 = un peu d'hétéro ? Car 72 % de "0"
- Idem pour la jatis
- Pour le reste, il y a au max 30% de 0, donc ça passe je pense
*/


*** Homo/hétéro sexe
ta IQV_gender



*** Homo/hétéro educ
ta IQV_educ


*** Homo/hétéro occup
ta IQV_occup


*** Homophily caste
ta same_caste_pct


/*
Envisager une catégorielle car 2/3 de "1".
*/


*** Homophily sex
ta same_gender_pct


/*
Envisager une catégorielle car 1/3 de "1".
*/


*** Homophily occup
ta same_occup_pct



*** Nombre d'amis
ta friend_pct




*** Multiplexity
ta multiplexityF_pct





****************************************
* END









****************************************
* Who are the alters?
****************************************
cls
use"Analysis/Alters_v2", clear

ta egoid

* Sex
ta sex, m
ta caste, m

ta educ
ta occup


****************************************
* END


