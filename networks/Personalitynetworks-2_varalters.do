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

*Identification networks type
codebook networkpurpose1, tabulate(13)

*only 62 alters concerned by business loans : we regroup all types of loans
gen debt_network=cond( ///
networkpurpose1==1 | ///
networkpurpose2==1 | ///
networkpurpose3==1 | ///
networkpurpose4==1 | ///
networkpurpose5==1 | ///
networkpurpose6==1 | ///
networkpurpose7==1 | ///
networkpurpose8==1 | ///
networkpurpose9==1 | ///
networkpurpose1==2 | ///
networkpurpose2==2 | ///
networkpurpose3==2 | ///
networkpurpose4==2 | ///
networkpurpose5==2 | ///
networkpurpose6==2 | ///
networkpurpose7==2 | ///
networkpurpose8==2 | ///
networkpurpose9==2 ///
,1,0)
tab debt_network

gen relative_network=cond( ///
networkpurpose1==11 | ///
networkpurpose2==11 | ///
networkpurpose3==11 | ///
networkpurpose4==11 | ///
networkpurpose5==11 | ///
networkpurpose6==11 | ///
networkpurpose7==11 | ///
networkpurpose8==11 | ///
networkpurpose9==11 ///
,1,0)
tab relative_network 

gen talk_network=cond( ///
networkpurpose1==9 | ///
networkpurpose2==9 | ///
networkpurpose3==9 | ///
networkpurpose4==9 | ///
networkpurpose5==9 | ///
networkpurpose6==9 | ///
networkpurpose7==9 | ///
networkpurpose8==9 | ///
networkpurpose9==9 ///
,1,0)
tab talk_network

gen interperso_network=cond(relative_network==1 |talk_network==1,1,0) 
tab interperso_network

gen labor_network=cond(inlist(networkpurpose1,3,5,6,7,8) | ///
inlist(networkpurpose2,3,5,6,7,8) | ///
inlist(networkpurpose3,3,5,6,7,8) | ///
inlist(networkpurpose4,3,5,6,7,8) | ///
inlist(networkpurpose5,3,5,6,7,8) | ///
inlist(networkpurpose6,3,5,6,7,8) | ///
inlist(networkpurpose7,3,5,6,7,8) | ///
inlist(networkpurpose8,3,5,6,7,8) | ///
inlist(networkpurpose9,3,5,6,7,8) ///
,1,0)
tab labor_network

gen covid_network=cond(inlist(networkpurpose1,12,13) | ///
inlist(networkpurpose2,12,13) | ///
inlist(networkpurpose3,12,13) | ///
inlist(networkpurpose4,12,13) | ///
inlist(networkpurpose5,12,13) | ///
inlist(networkpurpose6,12,13) | ///
inlist(networkpurpose7,12,13) | ///
inlist(networkpurpose8,12,13) | ///
inlist(networkpurpose9,12,13) ///
,1,0)
tab covid_network

gen asso_network=cond(inlist(networkpurpose1,4) | ///
inlist(networkpurpose2,4) | ///
inlist(networkpurpose3,4) | ///
inlist(networkpurpose4,4) | ///
inlist(networkpurpose5,4) | ///
inlist(networkpurpose6,4) | ///
inlist(networkpurpose7,4) | ///
inlist(networkpurpose8,4) | ///
inlist(networkpurpose9,4) ///
,1,0)
tab asso_network

gen medical_network=cond(inlist(networkpurpose1,10) | ///
inlist(networkpurpose2,10) | ///
inlist(networkpurpose3,10) | ///
inlist(networkpurpose4,10) | ///
inlist(networkpurpose5,10) | ///
inlist(networkpurpose6,10) | ///
inlist(networkpurpose7,10) | ///
inlist(networkpurpose8,10) | ///
inlist(networkpurpose9,10) ///
,1,0)
tab medical_network

*Focus sur quels name generators ? 
*	==> debt, relative, talk 

drop if interperso_network==0 & debt_network==0
* drop 642 alters seulement
tab interperso_network debt_network

	*Number of relationships types = missing values 
sum dummyfam friend labourrelation wkp

*Correction 09/12/24
tab relative_network friend
replace friend=0 if relative_network==1
*si close_relative alors famille_etendu==1
gen family=cond(dummyfam==1 | relative_network==1,1,0)

gen role=cond(family==0 & friend==0 & labourrelation==0 & wkp==0,1,0)
tab role

tab networkpurpose1 role
gen lender=cond(role==1 &  networkpurpose1==1,1,0)
replace role=0 if lender==1
tab meet if role==1 & networkpurpose1!=1
replace labourrelation=1 if role==1 & meet==1
replace role=0 if labourrelation==1 & role==1
replace friend=1 if networkpurpose1==10 & role==1
replace role=0 if friend==1 & role==1
drop if role==1
*Drop 19 observations

drop role
gen role=cond(lender==0 & (family==0 |  family==.) & (friend==0 | friend==.) & (labourrelation==0 | labourrelation==.) & (wkp==0 | wkp==.),1,0)
tab role

tab networkpurpose1 role
replace lender=1 if role==1 &  networkpurpose1==1
replace role=0 if lender==1
tab meet if role==1 & networkpurpose1!=1
replace labourrelation=1 if role==1 & meet==1
replace role=0 if labourrelation==1 & role==1
replace friend=1 if networkpurpose1==10 & role==1
replace role=0 if friend==1 & role==1
*drop if role==1
drop role
* Drop 207 obs

* Missing friend : 
replace friend=0 if friend==.
replace friend=0 if family==1
gen other_relation=cond(family==0 & friend==0,1,0)


***Network size 
	*Overall
bys HHID2020 INDID2020 : gen netsize_all=_N
	*Debt
bys HHID2020 INDID2020 : egen netsize_debt=total(debt_network)
	*Close relative
bys HHID2020 INDID2020 : egen netsize_relative=total(relative_network)
	*Talk the most
bys HHID2020 INDID2020 : egen netsize_talk=total(talk_network)

***Multiplexity (fonctions): comparaison réseaux interperso et debt 
	*Number of functions provided by alters / number of distinct types of ties
gen multiplexity_dum=cond(debt_network==1 & interperso_network==1,1,0)
replace multiplexity_dum=. if debt_network==0
*52.2% des alters des réseaux debt sont multiplexes = relations de dette et interpersonnelle combinées
bys HHID2020 INDID2020 : egen debt_multiplexity_n=total(multiplexity_dum)

***Multiplexity (nature de la relation) 
egen multiplexityR_nb=rowtotal(friend family other_relation labourrelation)
tab multiplexityR_nb
gen multiplexityR_dum=cond(multiplexityR_nb>1,1,0)

bys HHID2020 INDID2020 : egen debt_multiplexityR_n=total(multiplexityR_dum) if debt_network==1
bys HHID2020 INDID2020 : egen talk_multiplexityR_n=total(multiplexityR_dum) if talk_network==1
bys HHID2020 INDID2020 : egen close_multiplexityR_n=total(multiplexityR_dum) if relative_network==1

*Composition : 

foreach var in talk relative debt {
bys HHID2020 INDID2020 : egen `var'_family_n=total(family) if `var'_network==1
}


/*
***Tie strenght
	*Meet frequency : overall average + average by categories
tab	meetfrequency
gen meetfrequency_weekly=cond(meetfrequency==1,1,0)

gen talk=talk_network
gen relative=relative_network
gen debt=debt_network

foreach var in talk relative debt {
bys HHID2020 INDID2020 : egen `var'_meetweekly_n=total(meetfrequency_weekly) if `var'_network==1
}

	*Intimacy
tab	 intimacy
gen very_intimate=cond(intimacy==3,1,0)
foreach var in talk relative debt {
bys HHID2020 INDID2020 : egen `var'_veryintimate_n=total(very_intimate) if `var'_network==1
}

	*Invitation
tab	invite  reciprocity1 
gen invite_reciprocity=cond(invite==1 & reciprocity1==1,1,0)
foreach var in talk relative debt {
bys HHID2020 INDID2020 : egen `var'_reciprocity_n=total(invite_reciprocity) if `var'_network==1
}

	*Duration 
	*How to deal with measurment errors ? duration>100
kdensity duration if duration<100
gen duration_cat=1 if duration<5
replace duration_cat=2 if duration>=5 & duration<10
replace duration_cat=3 if duration>=10 & duration<15
replace duration_cat=4 if duration>=15 & duration<20
replace duration_cat=5 if duration>=20 & duration<25
replace duration_cat=6 if duration>=25 & duration<30
replace duration_cat=7 if duration>=30 
tab duration_cat

gen duration_corr=cond(duration<100,duration,.) 
foreach var in talk relative debt {
bys HHID2020 INDID2020 : egen `var'_duration=mean(duration_corr) if `var'_network==1
}

*Exchange money
tab money
gen money_often=cond(money==1 | money==2,1,0)
foreach var in talk relative debt {
bys HHID2020 INDID2020 : egen `var'_money_often_n=total(money_often) if `var'_network==1
}

* Strenght 
mca meetfrequency intimacy invite_reciprocity duration_cat money 
predict dim1
sum dim1
gen strength_mca=(dim1-(-6.226403))/(.7470417-(-6.226403))
sum strength_mca

gen strength_debt=strength_mca if debt_network==1
gen strength_talk=strength_mca if talk_network==1
gen strength_relative=strength_mca if relative_network==1
*/


save "Analysis\Alters_DG.dta", replace

****************************************
* END












****************************************
* Similarity
****************************************
use "Analysis\Alters_DG.dta", clear

*1) Homophily / Heterophily + Homogeneity / Heterogeneity
	*Gender 
gen same_gender=cond(sex==sex_ego,1,0)
foreach var in talk relative debt {
bys HHID2020 INDID2020 : egen `var'_same_gender_n=total(same_gender) if `var'_network==1
}

	*Caste / jatis
gen same_caste=cond(caste==caste_ego,1,0)
* Si caste=Don't know alors on part du principe que ce n'est pas la même caste
foreach var in talk relative debt {
bys HHID2020 INDID2020 : egen `var'_same_caste_n=total(same_caste) if `var'_network==1
}

tab caste, gen(caste)
*Si caste=Don't know, on part du principe que c'est l'inférieur
replace caste1=1 if caste4==1
foreach var in talk relative debt {
bys HHID2020 INDID2020 : egen `var'_lowcaste_n=total(caste1) if `var'_network==1
bys HHID2020 INDID2020 : egen `var'_midcaste_n=total(caste2) if `var'_network==1
bys HHID2020 INDID2020 : egen `var'_upcaste_n=total(caste3) if `var'_network==1
}

label values jatis_ego castes
gen same_jatis=cond(jatis==jatis_ego,1,0)
foreach var in talk relative debt {
bys HHID2020 INDID2020 : egen `var'_samejatis_n=total(same_jatis) if `var'_network==1
}

tab jatis, gen(jatis)
replace jatis18=1 if jatis17==1
drop jatis17
foreach var in jatis1 jatis2 jatis3 jatis4 jatis5 jatis6 jatis7 jatis8 jatis9 jatis10 jatis11 jatis12 jatis13 jatis14 jatis15 jatis16 jatis18 {
bys HHID2020 INDID2020 : egen `var'_n=total(`var')
}
foreach var1 in talk relative debt {
	foreach var2 in jatis1 jatis2 jatis3 jatis4 jatis5 jatis6 jatis7 jatis8 jatis9 jatis10 jatis11 jatis12 jatis13 jatis14 jatis15 jatis16 jatis18 {
	bys HHID2020 INDID2020 : egen `var1'_`var2'_n=total(`var2') if `var1'_network==1
	}
}
	* Age
tab age 
tab age_ego
gen age_ego_tranche=1 if age_ego>=15 & age_ego<26
replace age_ego_tranche=2 if age_ego>=26 & age_ego<36
replace age_ego_tranche=3 if age_ego>=36 & age_ego<46
replace age_ego_tranche=4 if age_ego>=46 & age_ego<56
replace age_ego_tranche=5 if age_ego>=56 & age_ego<66
replace age_ego_tranche=6 if age_ego>=66
gen same_age=cond(age==age_ego_tranche,1,0)
foreach var in talk relative debt {
bys HHID2020 INDID2020 : egen `var'_sameage_n=total(same_age) if `var'_network==1
}

tab age, gen(age)
foreach var1 in talk relative debt {
	foreach var2 in age1 age2 age3 age4 age5 age6 {
	bys HHID2020 INDID2020 : egen `var1'_`var2'_n=total(`var2') if `var1'_network==1
	}
}

	*Occupation : couper croiser les différentes modalités ? 
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

foreach var in talk relative debt {
bys HHID2020 INDID2020 : egen `var'_samejobstatut_n=total(same_jobstatut) if `var'_network==1
bys HHID2020 INDID2020 : egen `var'_sameoccup_n=total(same_occup) if `var'_network==1
}


tab occup_alter_type, gen(occup_alter_type)

rename occup_alter_type1 alteroccup1
rename occup_alter_type2 alteroccup2
rename occup_alter_type3 alteroccup3
rename occup_alter_type4 alteroccup4

foreach var1 in talk relative debt {
	foreach var2 in alteroccup1 alteroccup2 alteroccup3 alteroccup4 {
	bys HHID2020 INDID2020 : egen `var1'_`var2'_n=total(`var2') if `var1'_network==1
	}
}


	*Educ
codebook educ educ_ego
gen same_educ=cond(educ==5 & (educ_ego==4 | educ_ego==5),1,.)
replace same_educ=cond((educ==6 | educ==1) & (educ_ego==0 | educ_ego==1),1,same_educ)
replace same_educ=cond((educ==6 | educ==1 | educ==2 ) & (educ_ego==0 | educ_ego==1),1,same_educ)
replace same_educ=cond((educ==3 ) & (educ_ego==2),1,same_educ)
replace same_educ=cond((educ==4 ) & (educ_ego==3),1,same_educ)
replace same_educ=cond(same_educ==. | educ==88 ,0,same_educ)
tab same_educ
foreach var in talk relative debt {
bys HHID2020 INDID2020 : egen `var'_sameeduc_n=total(same_educ) if `var'_network==1
}


tab educ,gen(educ)
foreach var1 in talk relative debt {
	foreach var2 in educ1 educ2 educ3 educ4 educ5 educ6 educ7 {
	bys HHID2020 INDID2020 : egen `var1'_`var2'_n=total(`var2') if `var1'_network==1
	}
}

	*Living place :
gen same_location=cond(inlist(living,1,2),1,0)
replace same_location=1 if relative_network==1 & living==.
foreach var in talk relative debt {
bys HHID2020 INDID2020 : egen `var'_sameloc_n=total(same_location) if `var'_network==1
}

/*
	*Comparison of living standard
tab compared
gen same_situation=cond(compared==2,1,0)
foreach var in talk relative debt {
bys HHID2020 INDID2020 : egen `var'_samesituation_n=total(same_situation) if `var'_network==1
}
gen better_situation=cond(compared==1,1,0)
*/


save "Analysis\Alters_DG.dta", replace

****************************************
* END













****************************************
* Var alters
****************************************
use "Analysis\Alters_DG.dta", replace

*Whole network characteristics 
collapse (mean) ///
netsize_debt netsize_relative netsize_talk debt_multiplexity_n debt_multiplexityR_n talk_multiplexityR_n close_multiplexityR_n talk_family_n relative_family_n debt_family_n talk_same_gender_n relative_same_gender_n debt_same_gender_n talk_same_caste_n relative_same_caste_n debt_same_caste_n talk_lowcaste_n talk_midcaste_n talk_upcaste_n relative_lowcaste_n relative_midcaste_n relative_upcaste_n debt_lowcaste_n debt_midcaste_n debt_upcaste_n talk_samejatis_n relative_samejatis_n debt_samejatis_n talk_sameage_n relative_sameage_n debt_sameage_n talk_jatis1_n talk_jatis2_n talk_jatis3_n talk_jatis4_n talk_jatis5_n talk_jatis6_n talk_jatis7_n talk_jatis8_n talk_jatis9_n talk_jatis10_n talk_jatis11_n talk_jatis12_n talk_jatis13_n talk_jatis14_n talk_jatis15_n talk_jatis16_n talk_jatis18_n relative_jatis1_n relative_jatis2_n relative_jatis3_n relative_jatis4_n relative_jatis5_n relative_jatis6_n relative_jatis7_n relative_jatis8_n relative_jatis9_n relative_jatis10_n relative_jatis11_n relative_jatis12_n relative_jatis13_n relative_jatis14_n relative_jatis15_n relative_jatis16_n relative_jatis18_n debt_jatis1_n debt_jatis2_n debt_jatis3_n debt_jatis4_n debt_jatis5_n debt_jatis6_n debt_jatis7_n debt_jatis8_n debt_jatis9_n debt_jatis10_n debt_jatis11_n debt_jatis12_n debt_jatis13_n debt_jatis14_n debt_jatis15_n debt_jatis16_n debt_jatis18_n talk_age1_n talk_age2_n talk_age3_n talk_age4_n talk_age5_n talk_age6_n relative_age1_n relative_age2_n relative_age3_n relative_age4_n relative_age5_n relative_age6_n debt_age1_n debt_age2_n debt_age3_n debt_age4_n debt_age5_n debt_age6_n talk_samejobstatut_n talk_sameoccup_n relative_samejobstatut_n relative_sameoccup_n debt_samejobstatut_n debt_sameoccup_n talk_alteroccup1_n talk_alteroccup2_n talk_alteroccup3_n talk_alteroccup4_n relative_alteroccup1_n relative_alteroccup2_n relative_alteroccup3_n relative_alteroccup4_n debt_alteroccup1_n debt_alteroccup2_n debt_alteroccup3_n debt_alteroccup4_n talk_sameeduc_n relative_sameeduc_n debt_sameeduc_n talk_educ1_n talk_educ2_n talk_educ3_n talk_educ4_n talk_educ5_n talk_educ6_n talk_educ7_n relative_educ1_n relative_educ2_n relative_educ3_n relative_educ4_n relative_educ5_n relative_educ6_n relative_educ7_n debt_educ1_n debt_educ2_n debt_educ3_n debt_educ4_n debt_educ5_n debt_educ6_n debt_educ7_n talk_sameloc_n relative_sameloc_n debt_sameloc_n  ///
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
