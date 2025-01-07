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
* Who are the egos? Socio-demo
****************************************
cls
use"Analysis/Main_analyses_v5", clear

ta egoid
ta sex
ta caste


*** Age
tabstat age, stat(n mean median) by(sex)
tabstat age, stat(n mean median) by(caste)

*** Education
ta educ sex, col nofreq
ta educ caste, col nofreq

*** Occupation
ta occup sex, col nofreq
ta occup caste, col nofreq

****************************************
* END










****************************************
* Who are the egos? Networks
****************************************
cls
use"Analysis/Main_analyses_v5", clear


*** Taille
tabstat netsize_all, stat(n mean med) by(sex)
tabstat netsize_all, stat(n mean med) by(caste)

*** Durée des relations
tabstat duration_corr, stat(n mean med) by(sex)
tabstat duration_corr, stat(n mean med) by(caste)

*** Force
tabstat strength_mca, stat(n mean med) by(sex)
tabstat strength_mca, stat(n mean med) by(caste)

*** Homo caste
tabstat IQV_caste, stat(mean) by(sex)
tabstat IQV_caste, stat(mean) by(caste)
ta hetero_caste sex, col nofreq
ta hetero_caste caste, col nofreq

*** Homo sexe
tabstat IQV_gender, stat(mean) by(sex)
tabstat IQV_gender, stat(mean) by(caste)
ta hetero_gender sex, col nofreq
ta hetero_gender caste, col nofreq

*** Homo age
tabstat IQV_age, stat(mean) by(sex)
tabstat IQV_age, stat(mean) by(caste)
ta hetero_age sex, col nofreq
ta hetero_age caste, col nofreq

*** Homo educ
tabstat IQV_educ, stat(mean) by(sex)
tabstat IQV_educ, stat(mean) by(caste)
ta hetero_educ sex, col nofreq
ta hetero_educ caste, col nofreq

*** Homo occup
tabstat IQV_occup, stat(mean) by(sex)
tabstat IQV_occup, stat(mean) by(caste)
ta hetero_occup sex, col nofreq
ta hetero_occup caste, col nofreq


*** Homophily caste
tabstat same_caste_pct, stat(mean) by(sex)
tabstat same_caste_pct, stat(mean) by(caste)
ta same_caste sex, col nofreq
ta same_caste caste, col nofreq

*** Homophily sex
tabstat same_gender_pct, stat(mean) by(sex)
tabstat same_gender_pct, stat(mean) by(caste)
ta same_gender sex, col nofreq
ta same_gender caste, col nofreq

*** Nombre d'amis
tabstat friend_pct, stat(mean) by(sex)
tabstat friend_pct, stat(mean) by(caste)

*** Multiplexity
tabstat multiplexityF_pct, stat(mean) by(sex)
tabstat multiplexityF_pct, stat(mean) by(caste)


****************************************
* END









****************************************
* Who are the alters? Socio-demo
****************************************
cls
use"Analysis/Alters_v4", clear

ta egoid

* Sex
ta sex, m
ta caste, m

ta educ
ta occup


****************************************
* END















****************************************
* Who are the alters? Networks
****************************************
cls
use"Analysis/Alters_v4", clear

* Homophily caste
ta caste ego_caste, exp cchi2 chi2
ta caste ego_caste, row nofreq

* Homphily sex
ta sex ego_sex, exp cchi2 chi2
ta sex ego_sex, row nofreq

* Homophily education
ta educ ego_educ, exp cchi2 chi2
ta educ ego_educ, row nofreq

* Homophily occupation
ta occup ego_occup, exp cchi2 chi2
ta occup ego_occup, row nofreq

****************************************
* END











****************************************
* Networks and personality
****************************************
use"Analysis/Main_analyses_v5", clear


*** Continuous
cls
pwcorr fES fOPEX fCO locus netsize_all duration_corr strength_mca IQV_caste IQV_gender IQV_age IQV_occup IQV_educ  same_caste_pct same_gender_pct friend_pct multiplexityF_pct, sig

* By sex
pwcorr fES fOPEX fCO locus netsize_all duration_corr strength_mca IQV_caste IQV_gender IQV_age IQV_occup IQV_educ  same_caste_pct same_gender_pct friend_pct multiplexityF_pct if sex==1, sig

pwcorr fES fOPEX fCO locus netsize_all duration_corr strength_mca IQV_caste IQV_gender IQV_age IQV_occup IQV_educ  same_caste_pct same_gender_pct friend_pct multiplexityF_pct if sex==2, sig


* By caste
pwcorr fES fOPEX fCO locus netsize_all duration_corr strength_mca IQV_caste IQV_gender IQV_age IQV_occup IQV_educ  same_caste_pct same_gender_pct friend_pct multiplexityF_pct if caste==1, sig

pwcorr fES fOPEX fCO locus netsize_all duration_corr strength_mca IQV_caste IQV_gender IQV_age IQV_occup IQV_educ  same_caste_pct same_gender_pct friend_pct multiplexityF_pct if caste==2, sig

pwcorr fES fOPEX fCO locus netsize_all duration_corr strength_mca IQV_caste IQV_gender IQV_age IQV_occup IQV_educ  same_caste_pct same_gender_pct friend_pct multiplexityF_pct if caste==3, sig



*** Categorical
cls
tab1 hetero_caste hetero_gender hetero_age hetero_educ hetero_occup same_caste same_gender
cls
foreach x in hetero_caste hetero_gender hetero_age hetero_educ hetero_occup same_caste same_gender {
tabstat fES fOPEX fCO locus, stat(mean) by(`x')
}


****************************************
* END










****************************************
* Networks and personality (corr cont)
****************************************
use"Analysis/Main_analyses_v5", clear

/*
Regression

Regarder la littérature pour voir comment les autres font
*/






****************************************
* END
