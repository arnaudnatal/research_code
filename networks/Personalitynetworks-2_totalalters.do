*-------------------------
cls
*Damien GIROLLET
*damien.girollet@u-bordeaux.fr
*January 8, 2025
*-----
gl link = "networks"
*Var alters
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\networks.do"
*-------------------------




****************************************
* Var alters
****************************************
use "Analysis\Alters_v2.dta", replace

***** Merger les caracteristiques des Egos
preserve
use "Analysis\Main_analyses.dta", replace
keep HHID2020 INDID2020 villageid villagearea name religion sex age jatis caste educ mainocc_occupation_indiv 
foreach var in villageid villagearea name religion sex age jatis caste educ mainocc_occupation_indiv  {
rename `var' `var'_ego
}
rename mainocc_occupation_indiv_ego occup_ego
save "Analysis\Infosegos.dta", replace
restore
merge m:1 HHID2020 INDID2020 using "Analysis\Infosegos.dta"
keep if _merge==3
drop _merge

save "Analysis\Alters_DG.dta", replace


***** Multiplexité
fre networkpurpose1
recode networkpurpose1 networkpurpose2 networkpurpose3 networkpurpose4 networkpurpose5 networkpurpose6 networkpurpose7 networkpurpose8 networkpurpose9 (2=1) (5=3) (6=3) (7=3) (8=3) (13=12)

foreach i in 1 3 4 9 10 11 12 {
gen net`i'=cond( ///
networkpurpose1==`i' | ///
networkpurpose2==`i' | ///
networkpurpose3==`i' | ///
networkpurpose4==`i' | ///
networkpurpose5==`i' | ///
networkpurpose6==`i' | ///
networkpurpose7==`i' | ///
networkpurpose8==`i' | ///
networkpurpose9==`i' ///
,1,0)
}

*
egen multiplexityR_nb=rowtotal(net1 net3 net4 net9 net10 net11 net12)
tab multiplexityR_nb
gen multiplexityR_dum=cond(multiplexityR_nb>1,1,0)


***** Network size 
bys HHID2020 INDID2020 : egen netsize_all=sum(1)




***** Meet frequency
tab	meetfrequency
gen meetfrequency_weekly=cond(meetfrequency==1,1,0)
bys HHID2020 INDID2020 : egen meetweekly_n=total(meetfrequency_weekly)


***** Intimacy
tab	 intimacy
gen very_intimate=cond(intimacy==3,1,0)
bys HHID2020 INDID2020 : egen veryintimate_n=total(very_intimate)

***** Invitation
tab	invite reciprocity1 
gen invite_reciprocity=cond(invite==1 & reciprocity1==1,1,0)
bys HHID2020 INDID2020 : egen reciprocity_n=total(invite_reciprocity)

***** Duration 
gen duration_cat=1 if duration<5
replace duration_cat=2 if duration>=5 & duration<10
replace duration_cat=3 if duration>=10 & duration<15
replace duration_cat=4 if duration>=15 & duration<20
replace duration_cat=5 if duration>=20 & duration<25
replace duration_cat=6 if duration>=25 & duration<30
replace duration_cat=7 if duration>=30 
tab duration_cat
gen duration_corr=cond(duration<100,duration,.) 
bys HHID2020 INDID2020 : egen duration_n=mean(duration_corr)

***** Exchange money
tab money
gen money_often=cond(money==1 | money==2,1,0)
bys HHID2020 INDID2020 : egen money_often_n=total(money_often)

**** Strenght 
mca meetfrequency intimacy invite_reciprocity duration_cat money 
predict dim1
sum dim1
gen strength_mca=(dim1-`r(min)')/(`r(max)'-`r(min)')
sum strength_mca


save "Analysis\Alters_DG.dta", replace
****************************************
* END












****************************************
* Similarity
****************************************
use "Analysis\Alters_DG.dta", clear


***** Gender 
gen same_gender=cond(sex==sex_ego,1,0)
bys HHID2020 INDID2020 : egen same_gender_n=total(same_gender)

***** Caste / jatis
gen same_caste=cond(caste==caste_ego,1,0)
bys HHID2020 INDID2020 : egen same_caste_n=total(same_caste)

tab caste, gen(caste)
*Si caste=Don't know, on part du principe que c'est l'inférieur
replace caste1=1 if caste4==1
bys HHID2020 INDID2020 : egen lowcaste_n=total(caste1)
bys HHID2020 INDID2020 : egen midcaste_n=total(caste2)
bys HHID2020 INDID2020 : egen upcaste_n=total(caste3)

label values jatis_ego castes
gen same_jatis=cond(jatis==jatis_ego,1,0)
bys HHID2020 INDID2020 : egen samejatis_n=total(same_jatis)

tab jatis, gen(jatis)
replace jatis18=1 if jatis17==1
drop jatis17
foreach var in jatis1 jatis2 jatis3 jatis4 jatis5 jatis6 jatis7 jatis8 jatis9 jatis10 jatis11 jatis12 jatis13 jatis14 jatis15 jatis16 jatis18 {
bys HHID2020 INDID2020 : egen `var'_n=total(`var')
}


***** Age
tab age 
tab age_ego
gen age_ego_tranche=1 if age_ego>=15 & age_ego<26
replace age_ego_tranche=2 if age_ego>=26 & age_ego<36
replace age_ego_tranche=3 if age_ego>=36 & age_ego<46
replace age_ego_tranche=4 if age_ego>=46 & age_ego<56
replace age_ego_tranche=5 if age_ego>=56 & age_ego<66
replace age_ego_tranche=6 if age_ego>=66
gen same_age=cond(age==age_ego_tranche,1,0)
bys HHID2020 INDID2020 : egen sameage_n=total(same_age)

tab age, gen(age)
foreach var in age1 age2 age3 age4 age5 age6 {
bys HHID2020 INDID2020 : egen `var'_n=total(`var')
}


***** Occupation
tab occup_ego 
gen occup_ego_type=1 if occup_ego==. 
replace occup_ego_type=2 if occup_ego==1 
replace occup_ego_type=3 if occup_ego==6 
replace occup_ego_type=4 if inlist(occup_ego,2,3,4,5,7)
label define occup_ego_type 1"No job" 2"Self-employed - Agri" 3"Self-employed - Non-Agri" 4"Wage worker", replace
label value occup_ego_type occup_ego_type
tab occup_ego_type

gen occup_alter_type=1 if inlist(occup,77,9,10,11,12,8,7,6,5)
replace occup_alter_type=2 if occup==1 
replace occup_alter_type=3 if occup==2 
replace occup_alter_type=4 if inlist(occup,3,4)
label define occup_alter_type 1"No job" 2"Self-employed - Agri" 3"Self-employed - Non-Agri" 4"Wage worker", replace
label value occup_alter_type occup_alter_type
tab occup_alter_type

gen same_jobstatut=cond( (occup_ego_type==1 & occup_alter_type>1) | (occup_alter_type==1 & occup_ego_type>1),0,1)
tab same_jobstatut
gen same_occup=cond(occup_ego_type==occup_alter_type,1,0)
tab same_occup

bys HHID2020 INDID2020 : egen samejobstatut_n=total(same_jobstatut)
bys HHID2020 INDID2020 : egen sameoccup_n=total(same_occup)

tab occup_alter_type, gen(occup_alter_type)

rename occup_alter_type1 alteroccup1
rename occup_alter_type2 alteroccup2
rename occup_alter_type3 alteroccup3
rename occup_alter_type4 alteroccup4

foreach var in alteroccup1 alteroccup2 alteroccup3 alteroccup4 {
bys HHID2020 INDID2020 : egen `var'_n=total(`var')
}



***** Educ
codebook educ educ_ego
gen same_educ=cond(educ==5 & (educ_ego==4 | educ_ego==5),1,.)
replace same_educ=cond((educ==6 | educ==1) & (educ_ego==0 | educ_ego==1),1,same_educ)
replace same_educ=cond((educ==6 | educ==1 | educ==2 ) & (educ_ego==0 | educ_ego==1),1,same_educ)
replace same_educ=cond((educ==3 ) & (educ_ego==2),1,same_educ)
replace same_educ=cond((educ==4 ) & (educ_ego==3),1,same_educ)
replace same_educ=cond(same_educ==. | educ==88 ,0,same_educ)
tab same_educ
bys HHID2020 INDID2020 : egen sameeduc_n=total(same_educ)

tab educ,gen(educ)
foreach var in educ1 educ2 educ3 educ4 educ5 educ6 educ7 {
bys HHID2020 INDID2020 : egen `var'_n=total(`var')
}

***** Living place
gen same_location=cond(inlist(living,1,2),1,0)
bys HHID2020 INDID2020 : egen sameloc_n=total(same_location)


***** Comparison of living standard
tab compared
gen same_situation=cond(compared==2,1,0)
bys HHID2020 INDID2020 : egen samesituation_n=total(same_situation)
gen better_situation=cond(compared==1,1,0)



********** Cleaning
drop net1 net3 net4 net9 net10 net11 net12 very_intimate invite_reciprocity duration_cat dim1 meetfrequency_weekly money_often same_gender same_caste caste1 caste2 caste3 caste4 same_jatis jatis1 jatis2 jatis3 jatis4 jatis5 jatis6 jatis7 jatis8 jatis9 jatis10 jatis11 jatis12 jatis13 jatis14 jatis15 jatis16 jatis18 age_ego_tranche same_age age1 age2 age3 age4 age5 age6 age7 age8 age9 age10 age11 age12 age13 age14 age15 age16 age17 age18 age19 age20 age21 age22 age23 age24 age25 age26 age27 age28 age29 age30 age31 age32 age33 age34 age35 age36 age37 age38 age39 age40 age41 age42 age43 age44 age45 age46 age47 age48 age49 age50 age51 age52 age53 age54 age55 age56 same_jobstatut same_occup alteroccup1 alteroccup2 alteroccup3 alteroccup4 same_educ educ1 educ2 educ3 educ4 educ5 educ6 educ7 same_location same_situation better_situation


save "Analysis\Alters_DG.dta", replace
****************************************
* END













****************************************
* Var alters
****************************************
use "Analysis\Alters_DG.dta", replace

*Whole network characteristics 
collapse (mean) ///
netsize_all debt_multiplexity_n debt_multiplexityR_n talk_multiplexityR_n close_multiplexityR_n talk_family_n relative_family_n debt_family_n talk_same_gender_n relative_same_gender_n debt_same_gender_n talk_same_caste_n relative_same_caste_n debt_same_caste_n talk_lowcaste_n talk_midcaste_n talk_upcaste_n relative_lowcaste_n relative_midcaste_n relative_upcaste_n debt_lowcaste_n debt_midcaste_n debt_upcaste_n talk_samejatis_n relative_samejatis_n debt_samejatis_n talk_sameage_n relative_sameage_n debt_sameage_n talk_jatis1_n talk_jatis2_n talk_jatis3_n talk_jatis4_n talk_jatis5_n talk_jatis6_n talk_jatis7_n talk_jatis8_n talk_jatis9_n talk_jatis10_n talk_jatis11_n talk_jatis12_n talk_jatis13_n talk_jatis14_n talk_jatis15_n talk_jatis16_n talk_jatis18_n relative_jatis1_n relative_jatis2_n relative_jatis3_n relative_jatis4_n relative_jatis5_n relative_jatis6_n relative_jatis7_n relative_jatis8_n relative_jatis9_n relative_jatis10_n relative_jatis11_n relative_jatis12_n relative_jatis13_n relative_jatis14_n relative_jatis15_n relative_jatis16_n relative_jatis18_n debt_jatis1_n debt_jatis2_n debt_jatis3_n debt_jatis4_n debt_jatis5_n debt_jatis6_n debt_jatis7_n debt_jatis8_n debt_jatis9_n debt_jatis10_n debt_jatis11_n debt_jatis12_n debt_jatis13_n debt_jatis14_n debt_jatis15_n debt_jatis16_n debt_jatis18_n talk_age1_n talk_age2_n talk_age3_n talk_age4_n talk_age5_n talk_age6_n relative_age1_n relative_age2_n relative_age3_n relative_age4_n relative_age5_n relative_age6_n debt_age1_n debt_age2_n debt_age3_n debt_age4_n debt_age5_n debt_age6_n talk_samejobstatut_n talk_sameoccup_n relative_samejobstatut_n relative_sameoccup_n debt_samejobstatut_n debt_sameoccup_n talk_alteroccup1_n talk_alteroccup2_n talk_alteroccup3_n talk_alteroccup4_n relative_alteroccup1_n relative_alteroccup2_n relative_alteroccup3_n relative_alteroccup4_n debt_alteroccup1_n debt_alteroccup2_n debt_alteroccup3_n debt_alteroccup4_n talk_sameeduc_n relative_sameeduc_n debt_sameeduc_n talk_educ1_n talk_educ2_n talk_educ3_n talk_educ4_n talk_educ5_n talk_educ6_n talk_educ7_n relative_educ1_n relative_educ2_n relative_educ3_n relative_educ4_n relative_educ5_n relative_educ6_n relative_educ7_n debt_educ1_n debt_educ2_n debt_educ3_n debt_educ4_n debt_educ5_n debt_educ6_n debt_educ7_n talk_sameloc_n relative_sameloc_n debt_sameloc_n  ///
, by (HHID2020 INDID2020) 	
		
save "Analysis\Fullnetwork_traits_DG.dta", replace

****************************************
* END













****************************************
* Homophily
****************************************
use "Analysis\Fullnetwork_traits_DG.dta", clear

* Homophily

foreach var in talk relative debt {
bys HHID2020 INDID2020 : gen `var'_samegender_pct=`var'_same_gender_n/netsize_`var' 
}

foreach var in talk relative debt {
bys HHID2020 INDID2020 : gen `var'_samecaste_pct=`var'_same_caste_n/netsize_`var' 
}

foreach var in talk relative debt {
bys HHID2020 INDID2020 : gen `var'_samejatis_pct=`var'_samejatis_n/netsize_`var' 
}

foreach var in talk relative debt {
bys HHID2020 INDID2020 : gen `var'_sameage_pct=`var'_sameage_n/netsize_`var' 
}

foreach var in talk relative debt {
bys HHID2020 INDID2020 : gen `var'_samejobstatut_pct=`var'_samejobstatut_n/netsize_`var' 
}

foreach var in talk relative debt {
bys HHID2020 INDID2020 : gen `var'_sameoccup_pct=`var'_sameoccup_n/netsize_`var' 
}

foreach var in talk relative debt {
bys HHID2020 INDID2020 : gen `var'_sameeduc_pct=`var'_sameeduc_n/netsize_`var' 
}

foreach var in talk relative debt {
bys HHID2020 INDID2020 : gen `var'_samelocation_pct=`var'_sameloc_n/netsize_`var' 
}

/*
foreach var in talk relative debt {
bys HHID2020 INDID2020 : gen `var'_samewealth_pct=`var'_samesituation_n/netsize_`var' 
}
*/


*Heterogeneity (Index of qualitative variation)
foreach var in talk relative debt {
bys HHID2020 INDID2020 : gen `var'_lowcaste_pct=`var'_lowcaste_n/netsize_`var' 
bys HHID2020 INDID2020 : gen `var'_midcaste_pct=`var'_midcaste_n/netsize_`var' 
bys HHID2020 INDID2020 : gen `var'_upcaste_pct=`var'_upcaste_n/netsize_`var' 
}

foreach var in talk relative debt {
forvalues i = 1/18 {
 if `i' != 17 {
bys HHID2020 INDID2020 : gen `var'_jatis`i'_pct=`var'_jatis`i'_n/netsize_`var' 
}
}
}

foreach var in talk relative debt {
forvalues i = 1/6 {
bys HHID2020 INDID2020 : gen `var'_age`i'_pct=`var'_age`i'_n/netsize_`var' 
}
}

foreach var in talk relative debt {
forvalues i = 1/4 {
bys HHID2020 INDID2020 : gen `var'_occup`i'_pct=`var'_alteroccup`i'_n/netsize_`var' 
}
}

foreach var in talk relative debt {
forvalues i = 1/7 {
bys HHID2020 INDID2020 : gen `var'_educ`i'_pct=`var'_educ`i'_n/netsize_`var' 
}
}


*IQV - 
foreach var in talk_educ1_pct talk_educ2_pct talk_educ3_pct talk_educ4_pct talk_educ5_pct talk_educ6_pct talk_educ7_pct relative_educ1_pct relative_educ2_pct relative_educ3_pct relative_educ4_pct relative_educ5_pct relative_educ6_pct relative_educ7_pct debt_educ1_pct debt_educ2_pct debt_educ3_pct debt_educ4_pct debt_educ5_pct debt_educ6_pct debt_educ7_pct talk_lowcaste_pct talk_midcaste_pct talk_upcaste_pct relative_lowcaste_pct relative_midcaste_pct relative_upcaste_pct debt_lowcaste_pct debt_midcaste_pct debt_upcaste_pct talk_jatis1_pct talk_jatis2_pct talk_jatis3_pct talk_jatis4_pct talk_jatis5_pct talk_jatis6_pct talk_jatis7_pct talk_jatis8_pct talk_jatis9_pct talk_jatis10_pct talk_jatis11_pct talk_jatis12_pct talk_jatis13_pct talk_jatis14_pct talk_jatis15_pct talk_jatis16_pct talk_jatis18_pct relative_jatis1_pct relative_jatis2_pct relative_jatis3_pct relative_jatis4_pct relative_jatis5_pct relative_jatis6_pct relative_jatis7_pct relative_jatis8_pct relative_jatis9_pct relative_jatis10_pct relative_jatis11_pct relative_jatis12_pct relative_jatis13_pct relative_jatis14_pct relative_jatis15_pct relative_jatis16_pct relative_jatis18_pct debt_jatis1_pct debt_jatis2_pct debt_jatis3_pct debt_jatis4_pct debt_jatis5_pct debt_jatis6_pct debt_jatis7_pct debt_jatis8_pct debt_jatis9_pct debt_jatis10_pct debt_jatis11_pct debt_jatis12_pct debt_jatis13_pct debt_jatis14_pct debt_jatis15_pct debt_jatis16_pct debt_jatis18_pct talk_age1_pct talk_age2_pct talk_age3_pct talk_age4_pct talk_age5_pct talk_age6_pct relative_age1_pct relative_age2_pct relative_age3_pct relative_age4_pct relative_age5_pct relative_age6_pct debt_age1_pct debt_age2_pct debt_age3_pct debt_age4_pct debt_age5_pct debt_age6_pct talk_occup1_pct talk_occup2_pct talk_occup3_pct talk_occup4_pct relative_occup1_pct relative_occup2_pct relative_occup3_pct relative_occup4_pct debt_occup1_pct debt_occup2_pct debt_occup3_pct debt_occup4_pct {
gen `var'2=`var'^2
}


foreach var in talk_samegender_pct relative_samegender_pct debt_samegender_pct talk_samelocation_pct relative_samelocation_pct debt_samelocation_pct {
gen `var'2=`var'^2
gen `var'invert2=(1-`var')^2
}



foreach var1 in talk relative debt {
    bys HHID2020 INDID2020: gen `var1'_sumcaste_pct2 = 0
        foreach var2 in lowcaste_pct2 midcaste_pct2 upcaste_pct2 {
        bys HHID2020 INDID2020 : replace `var1'_sumcaste_pct2 = `var1'_sumcaste_pct2 + `var1'_`var2'
    }
}

foreach var1 in talk relative debt {
    bys HHID2020 INDID2020: gen `var1'_sumjatis_pct2 = 0
        foreach var2 in jatis1_pct2 jatis2_pct2 jatis3_pct2 jatis4_pct2 jatis5_pct2 jatis6_pct2 jatis7_pct2 jatis8_pct2 jatis9_pct2 jatis10_pct2 jatis11_pct2 jatis12_pct2 jatis13_pct2 jatis14_pct2 jatis15_pct2 jatis16_pct2 jatis18_pct2 {
        bys HHID2020 INDID2020 : replace `var1'_sumjatis_pct2 = `var1'_sumjatis_pct2 + `var1'_`var2'
    }
}

foreach var1 in talk relative debt {
    bys HHID2020 INDID2020: gen `var1'_sumage_pct2 = 0
        foreach var2 in age1_pct2 age2_pct2 age3_pct2 age4_pct2 age5_pct2 age6_pct2 {
        bys HHID2020 INDID2020 : replace `var1'_sumage_pct2 = `var1'_sumage_pct2 + `var1'_`var2'
    }
}

foreach var1 in talk relative debt {
    bys HHID2020 INDID2020: gen `var1'_sumoccup_pct2 = 0
        foreach var2 in occup1_pct2 occup2_pct2 occup3_pct2 occup4_pct2 {
        bys HHID2020 INDID2020 : replace `var1'_sumoccup_pct2 = `var1'_sumoccup_pct2 + `var1'_`var2'
    }
}

foreach var1 in talk relative debt {
    bys HHID2020 INDID2020: gen `var1'_sumeduc_pct2 = 0
        foreach var2 in educ1_pct2 educ2_pct2 educ3_pct2 educ4_pct2 educ5_pct2 educ6_pct2 educ7_pct2 {
        bys HHID2020 INDID2020 : replace `var1'_sumeduc_pct2 = `var1'_sumeduc_pct2 + `var1'_`var2'
    }
}

foreach var1 in talk relative debt {
    bys HHID2020 INDID2020: gen `var1'_sumgender_pct2 = 0
        foreach var2 in samegender_pct2 samegender_pctinvert2 {
        bys HHID2020 INDID2020 : replace `var1'_sumgender_pct2 = `var1'_sumgender_pct2 + `var1'_`var2'
    }
}

foreach var1 in talk relative debt {
    bys HHID2020 INDID2020: gen `var1'_sumloc_pct2 = 0
        foreach var2 in samelocation_pct2 samelocation_pctinvert2 {
        bys HHID2020 INDID2020 : replace `var1'_sumloc_pct2 = `var1'_sumloc_pct2 + `var1'_`var2'
    }
}


foreach var1 in talk relative debt {
 bys HHID2020 INDID2020: gen `var1'_IQV_caste = (1-`var1'_sumcaste_pct2)/(1-(1/3))
 bys HHID2020 INDID2020: gen `var1'_IQV_jatis=(1-`var1'_sumjatis_pct2)/(1-(1/17))
 bys HHID2020 INDID2020: gen `var1'_IQV_age=(1-`var1'_sumage_pct2)/(1-(1/6))	
 bys HHID2020 INDID2020: gen `var1'_IQV_occup=(1-`var1'_sumoccup_pct2)/(1-(1/4))	
 bys HHID2020 INDID2020: gen `var1'_IQV_educ=(1-`var1'_sumeduc_pct2)/(1-(1/7))
 bys HHID2020 INDID2020: gen `var1'_IQV_gender=(1-`var1'_sumgender_pct2)/(1-(1/2))						
 bys HHID2020 INDID2020: gen `var1'_IQV_location=(1-`var1'_samelocation_pct2)/(1-(1/2))						
}

*Perfect homogeneity : IQV=0	

*Multiplexity

gen debt_multiplex_pct=debt_multiplexity_n/netsize_debt
gen debt_multiplexR_pct=debt_multiplexityR_n/netsize_debt
gen talk_multiplexR_pct=talk_multiplexityR_n/netsize_talk
gen relative_multiplexR_pct=close_multiplexityR_n/netsize_relative

foreach var in talk relative debt {
bys HHID2020 INDID2020 : gen `var'_family_pct=`var'_family_n/netsize_`var' 
}

/*
*Strenght
foreach var1 in talk relative debt {
 bys HHID2020 INDID2020: gen `var1'_meetweekly_pct = `var1'_meetweekly_n/netsize_`var1'
 bys HHID2020 INDID2020: gen `var1'_veryintimate_pct=`var1'_veryintimate_n/netsize_`var1'
 bys HHID2020 INDID2020: gen `var1'_reciprocity_pct=`var1'_reciprocity_n/netsize_`var1'	
 bys HHID2020 INDID2020: gen `var1'_money_pct=`var1'_money_often_n/netsize_`var1'
}
*/


save "Analysis\Fullnetwork_traits_DG.dta", replace

****************************************
* END






****************************************
* Var alters
****************************************
use "Analysis\Fullnetwork_traits_DG.dta", clear

keep HHID2020 INDID2020 netsize_debt netsize_relative netsize_talk       talk_family_pct relative_family_pct debt_family_pct talk_samegender_pct relative_samegender_pct debt_samegender_pct talk_samecaste_pct relative_samecaste_pct debt_samecaste_pct talk_samejatis_pct relative_samejatis_pct debt_samejatis_pct talk_sameage_pct relative_sameage_pct debt_sameage_pct talk_samejobstatut_pct relative_samejobstatut_pct debt_samejobstatut_pct talk_sameoccup_pct relative_sameoccup_pct debt_sameoccup_pct talk_sameeduc_pct relative_sameeduc_pct debt_sameeduc_pct talk_samelocation_pct relative_samelocation_pct debt_samelocation_pct talk_IQV_caste talk_IQV_jatis talk_IQV_age talk_IQV_occup talk_IQV_educ talk_IQV_gender talk_IQV_location relative_IQV_caste relative_IQV_jatis relative_IQV_age relative_IQV_occup relative_IQV_educ relative_IQV_gender relative_IQV_location debt_IQV_caste debt_IQV_jatis debt_IQV_age debt_IQV_occup debt_IQV_educ debt_IQV_gender debt_IQV_location debt_multiplex_pct debt_multiplexR_pct talk_multiplexR_pct relative_multiplexR_pct

save "Analysis\Fullnetwork_traits_DG_tomerge.dta", replace
****************************************
* END
