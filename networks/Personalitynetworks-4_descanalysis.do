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
use"Analysis/Main_analyses_v3", clear

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


*** Personality by gender
* ES
twoway ///
(kdensity fES if sex==1, bwidth(0.3)) ///
(kdensity fES if sex==2, bwidth(0.3)) ///
, title("") xlabel(-4(2)4) ///
xtitle("Emotional stability (std)") ytitle("Density") ///
legend(order(1 "Men" 2 "Women") pos(6) col(2)) ///
name(gES, replace)

* OPEX
twoway ///
(kdensity fOPEX if sex==1, bwidth(0.3)) ///
(kdensity fOPEX if sex==2, bwidth(0.3)) ///
, title("") xlabel(-4(2)4) ///
xtitle("Plasticity (std)") ytitle("Density") ///
legend(order(1 "Men" 2 "Women") pos(6) col(2)) ///
name(gOPEX, replace)

* CO
twoway ///
(kdensity fCO if sex==1, bwidth(0.3)) ///
(kdensity fCO if sex==2, bwidth(0.3)) ///
, title("") xlabel(-4(2)4) ///
xtitle("Conscientiousness (std)") ytitle("Density") ///
legend(order(1 "Men" 2 "Women") pos(6) col(2)) ///
name(gCO, replace)

* LOC
twoway ///
(kdensity locus if sex==1, bwidth(0.6)) ///
(kdensity locus if sex==2, bwidth(0.6)) ///
, title("") xlabel(-6(2)6) ///
xtitle("Locus of control (std)") ytitle("Density") ///
legend(order(1 "Men" 2 "Women") pos(6) col(2)) ///
name(gLOC, replace)


*** Personality by caste
* ES
twoway ///
(kdensity fES if caste==1, bwidth(0.3)) ///
(kdensity fES if caste==2, bwidth(0.3)) ///
(kdensity fES if caste==3, bwidth(0.3)) ///
, title("") xlabel(-4(2)4) ///
xtitle("Emotional stability (std)") ytitle("Density") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
name(cES, replace)

* OPEX
twoway ///
(kdensity fOPEX if caste==1, bwidth(0.3)) ///
(kdensity fOPEX if caste==2, bwidth(0.3)) ///
(kdensity fOPEX if caste==3, bwidth(0.3)) ///
, title("") xlabel(-4(2)4) ///
xtitle("Plasticity (std)") ytitle("Density") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
name(cOPEX, replace)

* CO
twoway ///
(kdensity fCO if caste==1, bwidth(0.3)) ///
(kdensity fCO if caste==2, bwidth(0.3)) ///
(kdensity fCO if caste==3, bwidth(0.3)) ///
, title("") xlabel(-4(2)4) ///
xtitle("Conscientiousness (std)") ytitle("Density") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
name(cCO, replace)

* LOC
twoway ///
(kdensity locus if caste==1, bwidth(0.6)) ///
(kdensity locus if caste==2, bwidth(0.6)) ///
(kdensity locus if caste==3, bwidth(0.6)) ///
, title("") xlabel(-6(2)6) ///
xtitle("Locus of control (std)") ytitle("Density") ///
legend(order(1 "Dalits" 2 "Middle castes" 3 "Upper castes") pos(6) col(3)) ///
name(cLOC, replace)


*** Combine
grc1leg gES gOPEX gCO gLOC, col(4) name(g, replace)
grc1leg cES cOPEX cCO cLOC, col(4) name(c, replace)

graph combine g c, col(1) name(comb, replace)
graph export "Perso.pdf", as(pdf) replace
graph export "Perso.png", replace

****************************************
* END









/*
****************************************
* Who are the egos? Networks
****************************************
cls
use"Analysis/Main_analyses_v6", clear

rename edulevel educ


*** Taille
tabstat netsize_all, stat(n mean med) by(sex)
tabstat netsize_all, stat(n mean med) by(caste)

*** Durée des relations
tabstat duration_corr, stat(n mean med) by(sex)
tabstat duration_corr, stat(n mean med) by(caste)

*** Force
tabstat strength_mca, stat(n mean med) by(sex)
tabstat strength_mca, stat(n mean med) by(caste)


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
*/








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
* Distribution des futurs Y
****************************************
use"Analysis/Main_analyses_v3", clear


********** Talk the most
ta sex if netsize_talk>0
ta caste if netsize_talk>0

* Size
tabstat netsize_talk if netsize_talk>0, stat(n mean) by(sex)
tabstat netsize_talk if netsize_talk>0, stat(n mean) by(caste)

* Strength
tabstat talk_strength if netsize_talk>0, stat(n mean) by(sex)
tabstat talk_strength if netsize_talk>0, stat(n mean) by(caste)

* Dummy caste heterophily
ta dum_talk_EI_caste
ta dum_talk_EI_caste sex, col nofreq
ta dum_talk_EI_caste caste, col nofreq

* Intensity of caste heterophily
tabstat talk_EI_caste if dum_talk_EI_caste==1, stat(n mean) by(sex)
tabstat talk_EI_caste if dum_talk_EI_caste==1, stat(n mean) by(caste)

* Dummy gender heterophily
ta dum_talk_EI_gender
ta dum_talk_EI_gender sex, col nofreq
ta dum_talk_EI_gender caste, col nofreq

* Intensity of gender heterophily
tabstat talk_EI_gender if dum_talk_EI_gender==1, stat(n mean) by(sex)
tabstat talk_EI_gender if dum_talk_EI_gender==1, stat(n mean) by(caste)




********** Lenders
ta sex if netsize_debt>0
ta caste if netsize_debt>0

* Size
tabstat netsize_debt if netsize_debt>0, stat(n mean) by(sex)
tabstat netsize_debt if netsize_debt>0, stat(n mean) by(caste)

* Strength
tabstat debt_strength if netsize_debt>0, stat(n mean) by(sex)
tabstat debt_strength if netsize_debt>0, stat(n mean) by(caste)

* Dummy caste heterophily
ta dum_debt_EI_caste
ta dum_debt_EI_caste sex, col nofreq
ta dum_debt_EI_caste caste, col nofreq

* Intensity of caste heterophily
tabstat debt_EI_caste if dum_debt_EI_caste==1, stat(n mean) by(sex)
tabstat debt_EI_caste if dum_debt_EI_caste==1, stat(n mean) by(caste)

* Dummy gender heterophily
ta dum_debt_EI_gender
ta dum_debt_EI_gender sex, col nofreq
ta dum_debt_EI_gender caste, col nofreq

* Intensity of gender heterophily
tabstat debt_EI_gender if dum_debt_EI_gender==1, stat(n mean) by(sex)
tabstat debt_EI_gender if dum_debt_EI_gender==1, stat(n mean) by(caste)





********** Kin
ta sex if netsize_relative>0
ta caste if netsize_relative>0

* Size
tabstat netsize_relative if netsize_relative>0, stat(n mean) by(sex)
tabstat netsize_relative if netsize_relative>0, stat(n mean) by(caste)

* Strength
tabstat relative_strength if netsize_relative>0, stat(n mean) by(sex)
tabstat relative_strength if netsize_relative>0, stat(n mean) by(caste)

* Dummy caste heterophily
ta dum_relative_EI_caste
ta dum_relative_EI_caste sex, col nofreq
ta dum_relative_EI_caste caste, col nofreq

* Intensity of caste heterophily
tabstat relative_EI_caste if dum_relative_EI_caste==1, stat(n mean) by(sex)
tabstat relative_EI_caste if dum_relative_EI_caste==1, stat(n mean) by(caste)

* Dummy gender heterophily
ta dum_relative_EI_gender
ta dum_relative_EI_gender sex, col nofreq
ta dum_relative_EI_gender caste, col nofreq

* Intensity of gender heterophily
tabstat relative_EI_gender if dum_relative_EI_gender==1, stat(n mean) by(sex)
tabstat relative_EI_gender if dum_relative_EI_gender==1, stat(n mean) by(caste)





****************************************
* END
