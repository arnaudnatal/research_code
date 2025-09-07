*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*September 2, 2025
*-----
gl link = "debtnetworks"
*Desc analysis
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\debtnetworks.do"
*-------------------------

cd"D:\Ongoing_Networks_debt\Analysis"







****************************************
* Who are the egos? Socio-demo
****************************************
cls
use"Main_analyses_v5", clear

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
use"Main_analyses_v5", clear


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
use"Alters_v4", clear

fre networkpurpose1 networkpurpose2 networkpurpose3 networkpurpose4 networkpurpose5 networkpurpose6 networkpurpose7 networkpurpose8 networkpurpose9
keep if networkpurpose1==1
drop networkpurpose2 networkpurpose3 networkpurpose4 networkpurpose5 networkpurpose6 networkpurpose7 networkpurpose8 networkpurpose9


ta egoid

* Sex
ta sex, m
ta caste, m

ta educ
ta occup


* Alters by name generator
ta networkpurpose1, gen(purpose_)
forvalues i=1/13 {
forvalues j=1/9 {
replace purpose_`i'=1 if networkpurpose`j'==`i'
}
}
replace purpose_1=1 if purpose_2==1

drop purpose_2

fre networkpurpose1

rename purpose_1 purpose_loan
rename purpose_3 purpose_recruit
rename purpose_4 purpose_asso
rename purpose_5 purpose_current
rename purpose_6 purpose_future
rename purpose_7 purpose_recommend
rename purpose_8 purpose_hired
rename purpose_9 purpose_talkthemost
rename purpose_10 purpose_medical
rename purpose_11 purpose_closerela
rename purpose_12 purpose_receiveCOVID
rename purpose_13 purpose_giveCOVID


***
cls
tab1 purpose_loan purpose_recruit purpose_asso purpose_current purpose_future purpose_recommend purpose_hired purpose_talkthemost purpose_medical purpose_closerela purpose_receiveCOVID purpose_giveCOVID


****************************************
* END















****************************************
* Who are the alters? Networks
****************************************
cls
use"Alters_v4", clear

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
* Distribution des Y
****************************************
cls
use"Main_analyses_v5", clear

* 
drop if nbloan_indiv==0
drop if nbloan_indiv==.
foreach x in isr_indiv dsr_indiv share_isr share_dsr isr_HH dsr_HH {
replace `x'=`x'*100
}

* Indiv
tabstat loanamount_indiv isr_indiv dsr_indiv share_isr share_dsr, stat(n mean q p90 p95 p99 max)
ta dummyproblemtorepay_indiv
ta dummyhelptosettleloan_indiv
ta dummygiven_repa_indiv
ta dummyeffective_repa_indiv

* HH
tabstat isr_HH dsr_HH, stat(n mean q p90 p95 p99 max)
ta dummyproblemtorepay_HH
ta dummyhelptosettleloan_HH
ta dummygiven_repa_HH
ta dummyeffective_repa_HH


****************************************
* END
