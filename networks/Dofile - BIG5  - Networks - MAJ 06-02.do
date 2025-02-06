* Dofile BIG5 / Network - 06/02/2025

********************
* 1. POOLED NETWORK*
********************

global main_path "C:\Users\Damien Girollet\Desktop\Post doc\Recherche post-thèse\Papier Arnaud Inde\Data NEEMSIS - INDE\Data clean - Arnaud"
use "$main_path\NEEMSIS2-alters_clean.dta", replace

label define jatis 1 "Vanniyar" 2 "SC" 3 "Arunthathiyar" 4 "Rediyar" 5 "Gramani" 6 "Naidu" 7 "Navithar" 8 "Asarai" 9 "Settu" 10 "Nattar" 11 "Mudaliar" 12 "Kulalar" 13 "Chettiyar" 14 "Marwari" 15 "Muslims" 16 "Padayachi" 88 "D/K" 17 "Yathavar", replace
label value jatis_ego jatis

drop if dummyhh==1
*drop 294 alters
drop if sex==.

*Identification networks type
codebook networkpurpose1, tabulate(13)
codebook networkpurpose3, tabulate(13)
*only 62 alters concerned by business loans : we regroup all types of loans
gen debt_network=cond( ///
networkpurpose1==1 | networkpurpose2==1 | networkpurpose3==1 | networkpurpose4==1 | ///
networkpurpose5==1 | networkpurpose6==1 | networkpurpose7==1 | networkpurpose8==1 | ///
networkpurpose9==1 | ///
networkpurpose1==2 | networkpurpose2==2 | networkpurpose3==2 | networkpurpose4==2 | ///
networkpurpose5==2 | networkpurpose6==2 | networkpurpose7==2 | networkpurpose8==2 | ///
networkpurpose9==3 ,1,0)
tab debt_network

gen relative_network=cond( ///
networkpurpose1==11 | networkpurpose2==11 | networkpurpose3==11 | ///
networkpurpose4==11 | networkpurpose5==11 | networkpurpose6==11 | ///
networkpurpose7==11 | networkpurpose8==11 | networkpurpose9==11  ,1,0)
tab relative_network 

gen talk_network=cond( ///
networkpurpose1==9 | networkpurpose2==9 | networkpurpose3==9 | ///
networkpurpose4==9 | networkpurpose5==9 | networkpurpose6==9 | ///
networkpurpose7==9 | networkpurpose8==9 | networkpurpose9==9  ,1,0)
tab talk_network

gen interperso_network=cond(relative_network==1 |talk_network==1,1,0) 
tab interperso_network

gen labor_network=cond(inlist(networkpurpose1,3,5,6,7,8) | ///
inlist(networkpurpose2,3,5,6,7,8) | inlist(networkpurpose3,3,5,6,7,8) | ///
inlist(networkpurpose4,3,5,6,7,8) | inlist(networkpurpose5,3,5,6,7,8) | ///
inlist(networkpurpose6,3,5,6,7,8) | inlist(networkpurpose7,3,5,6,7,8) | ///
inlist(networkpurpose8,3,5,6,7,8) | inlist(networkpurpose9,3,5,6,7,8) ,1,0)
tab labor_network

gen covid_network=cond(inlist(networkpurpose1,12,13) | ///
inlist(networkpurpose2,12,13) | inlist(networkpurpose3,12,13) | ///
inlist(networkpurpose4,12,13) | inlist(networkpurpose5,12,13) | ///
inlist(networkpurpose6,12,13) | inlist(networkpurpose7,12,13) | ///
inlist(networkpurpose8,12,13) | inlist(networkpurpose9,12,13) ,1,0)
tab covid_network

gen asso_network=cond(inlist(networkpurpose1,4) | ///
inlist(networkpurpose2,4) | inlist(networkpurpose3,4) | ///
inlist(networkpurpose4,4) | inlist(networkpurpose5,4) | ///
inlist(networkpurpose6,4) | inlist(networkpurpose7,4) | ///
inlist(networkpurpose8,4) | inlist(networkpurpose9,4) ,1,0)
tab asso_network

gen medical_network=cond(inlist(networkpurpose1,10) | ///
inlist(networkpurpose2,10) | inlist(networkpurpose3,10) | ///
inlist(networkpurpose4,10) | inlist(networkpurpose5,10) | ///
inlist(networkpurpose6,10) | inlist(networkpurpose7,10) | ///
inlist(networkpurpose8,10) | inlist(networkpurpose9,10) ,1,0)
tab medical_network

***Network size 
	*Overall
bys HHINDID : egen netsize_all=count(HHINDID)

***Multiplexity 
	*Number of distinct types of ties
egen multiplexity_alter=rowtotal(debt_network relative_network talk_network labor_network covid_network asso_network medical_network)
gen  multiplexity_dum=cond(multiplexity_alter>1,1,0)
bys HHINDID : egen multiplexity_n=total(multiplexity_dum)

***Tie strenght
	*Meet frequency : overall average + average by categories
gen meetfrequency_weekly=cond(meetfrequency==1,1,0)
bys HHINDID : egen meetweekly_n=total(meetfrequency_weekly)

	*Intimacy
gen very_intimate=cond(intimacy==3,1,0)
bys HHINDID : egen veryintimate_n=total(very_intimate) 

	*Invitation
gen invite_reciprocity=cond(invite==1 & reciprocity1==1,1,0)
bys HHINDID : egen reciprocity_n=total(invite_reciprocity)

	*Duration 
	*How to deal with measurment errors ? duration>100
gen duration_corr=cond(duration<=age_ego,duration,.) 
gen duration_cat=1 if duration<5
replace duration_cat=2 if duration>=5 & duration<10
replace duration_cat=3 if duration>=10 & duration<15
replace duration_cat=4 if duration>=15 & duration<20
replace duration_cat=5 if duration>=20 & duration<25
replace duration_cat=6 if duration>=25 & duration<30
replace duration_cat=7 if duration>=30 
tab duration_cat

	*Exchange money
gen money_often=cond(money==1 | money==2,1,0)
bys HHINDID : egen moneyoften_n=total(money_often) 

* Strenght 
mca meetfrequency intimacy invite_reciprocity duration_cat money 
predict dim1
sum dim1
gen strength_mca=(dim1-(-6.236828))/(.7511489-(-6.236828))
sum strength_mca

*****************
***Ego-alter similarity :

*1) Homophily / Heterophily + Homogeneity / Heterogeneity
	*Gender 
gen same_gender=cond(sex==sex_ego,1,0)
bys HHINDID : egen samegender_n=total(same_gender) 

	*Caste 
	* Si caste=Don't know alors on part du principe que ce n'est pas la même caste
gen same_caste=cond(caste==caste_ego,1,0)
bys HHINDID : egen samecaste_n=total(same_caste) 
tab caste, gen(caste)
*Si caste=Don't know, on part du principe que c'est l'inférieur
replace caste1=1 if caste4==1
bys HHINDID : egen lowcaste_n=total(caste1) 
bys HHINDID : egen midcaste_n=total(caste2) 
bys HHINDID : egen upcaste_n=total(caste3) 

	*Jatis
gen same_jatis=cond(jatis==jatis_ego,1,0)
bys HHINDID : egen samejatis_n=total(same_jatis) 
tab jatis, gen(jatis)
*Si jatis=Don't know, on part du principe que c'est l'inférieur (SC)
replace jatis2=1 if jatis17==1
drop jatis17
foreach var in jatis1 jatis2 jatis3 jatis4 jatis5 jatis6 jatis7 jatis8 jatis9 jatis10 jatis11 jatis12 jatis13 jatis14 jatis15 jatis16 {
bys HHINDID : egen `var'_n=total(`var')
}

	*Living place :
gen same_location=cond(inlist(living,1,2),1,0)
replace same_location=1 if relative_network==1 & living==.
bys HHINDID : egen sameloc_n=total(same_location)

*********************************

*Whole network characteristics 
collapse (first) HHID2020 INDID2020 (mean) ///
netsize_all multiplexity_alter multiplexity_n meetweekly_n veryintimate_n reciprocity_n duration_corr moneyoften_n strength_mca samegender_n samecaste_n lowcaste_n midcaste_n upcaste_n samejatis_n jatis1_n jatis2_n jatis3_n jatis4_n jatis5_n jatis6_n jatis7_n jatis8_n jatis9_n jatis10_n jatis11_n jatis12_n jatis13_n jatis14_n jatis15_n jatis16_n sameloc_n ///
, by (HHINDID) 	
		
save "$main_path\Fullnetwork_traits.dta", replace

*********************************
use "$main_path\Fullnetwork_traits.dta", replace

* Homophily
bys HHINDID : gen samegender_pct=samegender_n/netsize_all 
bys HHINDID : gen samecaste_pct=samecaste_n/netsize_all 
bys HHINDID : gen samejatis_pct=samejatis_n/netsize_all 
bys HHINDID : gen samelocation_pct=sameloc_n/netsize_all 

*Heterogeneity (Index of qualitative variation)
bys HHINDID : gen lowcaste_pct=lowcaste_n/netsize_all 
bys HHINDID : gen midcaste_pct=midcaste_n/netsize_all 
bys HHINDID : gen upcaste_pct=upcaste_n/netsize_all 

forvalues i = 1/16 {
bys HHINDID : gen jatis`i'_pct=jatis`i'_n/netsize_all 
}

*IQV - 
foreach var in lowcaste_pct midcaste_pct upcaste_pct jatis1_pct jatis2_pct jatis3_pct jatis4_pct jatis5_pct jatis6_pct jatis7_pct jatis8_pct jatis9_pct jatis10_pct jatis11_pct jatis12_pct jatis13_pct jatis14_pct jatis15_pct jatis16_pct {
gen `var'2=`var'^2
}

foreach var in samegender_pct samelocation_pct {
gen `var'2=`var'^2
gen `var'invert2=(1-`var')^2
}

bys HHINDID: gen sumcaste_pct2 = 0
foreach var2 in lowcaste_pct2 midcaste_pct2 upcaste_pct2 {
bys HHINDID : replace sumcaste_pct2 = sumcaste_pct2 +`var2'
}

bys HHINDID: gen sumjatis_pct2 = 0
foreach var2 in jatis1_pct2 jatis2_pct2 jatis3_pct2 jatis4_pct2 jatis5_pct2 jatis6_pct2 jatis7_pct2 jatis8_pct2 jatis9_pct2 jatis10_pct2 jatis11_pct2 jatis12_pct2 jatis13_pct2 jatis14_pct2 jatis15_pct2 jatis16_pct2 {
bys HHINDID : replace sumjatis_pct2 = sumjatis_pct2 + `var2'
}

bys HHINDID: gen sumgender_pct2 = 0
foreach var2 in samegender_pct2 samegender_pctinvert2 {
bys HHINDID : replace sumgender_pct2 = sumgender_pct2 + `var2'
}

bys HHINDID: gen sumloc_pct2 = 0
foreach var2 in samelocation_pct2 samelocation_pctinvert2 {
bys HHINDID : replace sumloc_pct2 = sumloc_pct2 +`var2'
}

br samelocation_pct samelocation_pct2 samelocation_pctinvert2 sumloc_pct2

 bys HHINDID: gen IQV_caste = (1-sumcaste_pct2)/(1-(1/3))
 bys HHINDID: gen IQV_jatis=(1-sumjatis_pct2)/(1-(1/17))
 bys HHINDID: gen IQV_gender=(1-sumgender_pct2)/(1-(1/2))						
 bys HHINDID: gen IQV_location=(1-sumloc_pct2)/(1-(1/2))						

*Multiplexity
gen multiplex_pct=multiplexity_n/netsize_all

*Strenght
 bys HHINDID: gen meetweekly_pct = meetweekly_n/netsize_all
 bys HHINDID: gen veryintimate_pct=veryintimate_n/netsize_all
 bys HHINDID: gen reciprocity_pct=reciprocity_n/netsize_all	
 bys HHINDID: gen money_pct=moneyoften_n/netsize_all

save "$main_path\Fullnetwork_traits.dta", replace

keep  HHINDID HHID2020 INDID2020  netsize_all multiplexity_alter samegender_pct samecaste_pct samejatis_pct samelocation_pct IQV_caste IQV_jatis IQV_gender IQV_location multiplex_pct meetweekly_pct veryintimate_pct reciprocity_pct money_pct duration_corr strength_mca

save "$main_path\Fullnetwork_traits_tomerge.dta", replace














