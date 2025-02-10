*-------------------------
cls
*Damien GIROLLET
*damien.girollet@u-bordeaux.fr
*February 7, 2025
*-----
gl link = "networks"
*Création des variables sur les alters
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\networks.do"
*-------------------------




****************************************
* Pooled networks
****************************************
use "Analysis\NEEMSIS2-alters_clean.dta", replace

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
gen strength_mca=(dim1-`r(min)')/(`r(max)'-`r(min)')
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

save "Analysis\Alters_full.dta", replace

*********************************

*Whole network characteristics 
collapse (first) HHID2020 INDID2020 (mean) ///
netsize_all multiplexity_alter multiplexity_n meetweekly_n veryintimate_n reciprocity_n duration_corr moneyoften_n strength_mca samegender_n samecaste_n lowcaste_n midcaste_n upcaste_n samejatis_n jatis1_n jatis2_n jatis3_n jatis4_n jatis5_n jatis6_n jatis7_n jatis8_n jatis9_n jatis10_n jatis11_n jatis12_n jatis13_n jatis14_n jatis15_n jatis16_n sameloc_n ///
, by (HHINDID) 	
		
save "Analysis\Fullnetwork_traits.dta", replace

*********************************
use "Analysis\Fullnetwork_traits.dta", replace

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

*br samelocation_pct samelocation_pct2 samelocation_pctinvert2 sumloc_pct2

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

save "Analysis\Fullnetwork_traits.dta", replace

keep  HHINDID HHID2020 INDID2020  netsize_all multiplexity_alter samegender_pct samecaste_pct samejatis_pct samelocation_pct IQV_caste IQV_jatis IQV_gender IQV_location multiplex_pct meetweekly_pct veryintimate_pct reciprocity_pct money_pct duration_corr strength_mca

save "Analysis\Fullnetwork_traits_tomerge.dta", replace
****************************************
* END






















****************************************
* Subgroups networks
****************************************
use "Analysis\NEEMSIS2-alters_subclean.dta", replace

label define jatis 1 "Vanniyar" 2 "SC" 3 "Arunthathiyar" 4 "Rediyar" 5 "Gramani" 6 "Naidu" 7 "Navithar" 8 "Asarai" 9 "Settu" 10 "Nattar" 11 "Mudaliar" 12 "Kulalar" 13 "Chettiyar" 14 "Marwari" 15 "Muslims" 16 "Padayachi" 88 "D/K" 17 "Yathavar", replace
label value jatis_ego jatis

drop if dummyhh==1
* 26obs
drop if sex==.
* 9 obs

*Si relative_network==1 & talk_network=1 => replace relative_network=0
replace relative_network=0 if relative_network==1 & talk_network==1

***Network size 
	*Debt
bys HHINDID : egen netsize_debt=total(debt_network)
	*Close relative
bys HHINDID : egen netsize_relative=total(relative_network)
	*Talk the most
bys HHINDID : egen netsize_talk=total(talk_network)
	*Labour
bys HHINDID : egen netsize_labour=total(labour_network)

gen debt=debt_network
gen relative=relative_network
gen talk=talk_network
gen labour=labour_network
global type_network debt relative talk labour

***Multiplexity 
	*Number of distinct types of ties by alters
egen multiplexity_alter=rowtotal(debt_network relative_network talk_network labour_network)
gen  multiplexity_dum=cond(multiplexity_alter>1,1,0)
foreach var in $type_network {
bys HHINDID : egen `var'_multiplexity_n=total(multiplexity_dum) if `var'==1
}

***Tie strenght
	*Meet frequency : 
gen meetfrequency_weekly=cond(meetfrequency==1,1,0)
foreach var in $type_network {
bys HHINDID : egen `var'_meetweekly_n=total(meetfrequency_weekly) if `var'_network==1
}

	*Intimacy
tab	 intimacy
gen very_intimate=cond(intimacy==3,1,0)
foreach var in $type_network {
bys HHINDID : egen `var'_veryintimate_n=total(very_intimate) if `var'_network==1
}

	*Invitation
tab	invite  reciprocity1 
gen invite_reciprocity=cond(invite==1 & reciprocity1==1,1,0)
foreach var in $type_network  {
bys HHINDID : egen `var'_reciprocity_n=total(invite_reciprocity) if `var'_network==1
}

	*Duration 
	*How to deal with measurment errors ? 
gen duration_corr=cond(duration<=age_ego,duration,.) 
gen duration_cat=1 if duration<5
replace duration_cat=2 if duration>=5 & duration<10
replace duration_cat=3 if duration>=10 & duration<15
replace duration_cat=4 if duration>=15 & duration<20
replace duration_cat=5 if duration>=20 & duration<25
replace duration_cat=6 if duration>=25 & duration<30
replace duration_cat=7 if duration>=30 
tab duration_cat

foreach var in $type_network  {
bys HHINDID : egen `var'_duration=mean(duration_corr) if `var'_network==1
}

*Exchange money
tab money
gen money_often=cond(money==1 | money==2,1,0)
foreach var in $type_network  {
bys HHINDID : egen `var'_moneyoften_n=total(money_often) if `var'_network==1
}

* Strenght 
mca meetfrequency intimacy invite_reciprocity duration_cat money 
predict dim1
sum dim1
gen strength_mca=(dim1-`r(min)')/(`r(max)'-`r(min)')
sum strength_mca
foreach var in $type_network  {
gen `var'_strenght=strength_mca if `var'_network==1
}

*****************
***Ego-alter similarity :

*1) Homophily / Heterophily + Homogeneity / Heterogeneity
	*Gender 
gen same_gender=cond(sex==sex_ego,1,0)
foreach var in $type_network  {
bys HHINDID : egen `var'_samegender_n=total(same_gender) if `var'_network==1
}

	*Caste 
* Si caste=Don't know alors on part du principe que ce n'est pas la même caste
gen same_caste=cond(caste==caste_ego,1,0)
foreach var in $type_network  {
bys HHINDID : egen `var'_same_caste_n=total(same_caste) if `var'_network==1
}

tab caste, gen(caste)
*Si caste=Don't know, on part du principe que c'est l'inférieur
replace caste1=1 if caste4==1
foreach var in $type_network  {
bys HHINDID : egen `var'_lowcaste_n=total(caste1) if `var'_network==1
bys HHINDID : egen `var'_midcaste_n=total(caste2) if `var'_network==1
bys HHINDID : egen `var'_upcaste_n=total(caste3) if `var'_network==1
}

	*Jatis
gen same_jatis=cond(jatis==jatis_ego,1,0)
foreach var in $type_network  {
bys HHINDID : egen `var'_samejatis_n=total(same_jatis) if `var'_network==1
}

tab jatis, gen(jatis)
*Si jatis=Don't know, on part du principe que c'est l'inférieur (SC)
replace jatis2=1 if jatis17==1
drop jatis17
foreach var1 in $type_network  {
	foreach var2 in jatis1 jatis2 jatis3 jatis4 jatis5 jatis6 jatis7 jatis8 jatis9 jatis10 jatis11 jatis12 jatis13 jatis14 jatis15 jatis16 {
	bys HHINDID : egen `var1'_`var2'_n=total(`var2') if `var1'_network==1
	}
}
	*Living place :
gen same_location=cond(inlist(living,1,2),1,0)
replace same_location=1 if relative_network==1 & living==.
foreach var in $type_network  {
bys HHINDID : egen `var'_sameloc_n=total(same_location) if `var'_network==1
}

save "Analysis\Alters_sub.dta", replace

*********************************

*Whole network characteristics 
collapse (first) HHID2020 INDID2020 (mean) ///
netsize_debt netsize_relative netsize_talk netsize_labour debt_multiplexity_n relative_multiplexity_n talk_multiplexity_n labour_multiplexity_n debt_meetweekly_n relative_meetweekly_n talk_meetweekly_n labour_meetweekly_n debt_veryintimate_n relative_veryintimate_n talk_veryintimate_n labour_veryintimate_n debt_reciprocity_n relative_reciprocity_n talk_reciprocity_n labour_reciprocity_n debt_duration relative_duration talk_duration labour_duration debt_moneyoften_n relative_moneyoften_n talk_moneyoften_n labour_moneyoften_n debt_samegender_n relative_samegender_n talk_samegender_n labour_samegender_n debt_same_caste_n relative_same_caste_n talk_same_caste_n labour_same_caste_n debt_lowcaste_n debt_midcaste_n debt_upcaste_n relative_lowcaste_n relative_midcaste_n relative_upcaste_n talk_lowcaste_n talk_midcaste_n talk_upcaste_n labour_lowcaste_n labour_midcaste_n labour_upcaste_n debt_samejatis_n relative_samejatis_n talk_samejatis_n labour_samejatis_n debt_jatis1_n debt_jatis2_n debt_jatis3_n debt_jatis4_n debt_jatis5_n debt_jatis6_n debt_jatis7_n debt_jatis8_n debt_jatis9_n debt_jatis10_n debt_jatis11_n debt_jatis12_n debt_jatis13_n debt_jatis14_n debt_jatis15_n debt_jatis16_n relative_jatis1_n relative_jatis2_n relative_jatis3_n relative_jatis4_n relative_jatis5_n relative_jatis6_n relative_jatis7_n relative_jatis8_n relative_jatis9_n relative_jatis10_n relative_jatis11_n relative_jatis12_n relative_jatis13_n relative_jatis14_n relative_jatis15_n relative_jatis16_n talk_jatis1_n talk_jatis2_n talk_jatis3_n talk_jatis4_n talk_jatis5_n talk_jatis6_n talk_jatis7_n talk_jatis8_n talk_jatis9_n talk_jatis10_n talk_jatis11_n talk_jatis12_n talk_jatis13_n talk_jatis14_n talk_jatis15_n talk_jatis16_n labour_jatis1_n labour_jatis2_n labour_jatis3_n labour_jatis4_n labour_jatis5_n labour_jatis6_n labour_jatis7_n labour_jatis8_n labour_jatis9_n labour_jatis10_n labour_jatis11_n labour_jatis12_n labour_jatis13_n labour_jatis14_n labour_jatis15_n labour_jatis16_n debt_sameloc_n relative_sameloc_n talk_sameloc_n labour_sameloc_n debt_strenght relative_strenght talk_strenght labour_strenght ///
, by ( HHINDID) 	
		
save "Analysis\Subnetwork_traits.dta", replace

*************************
use "Analysis\Subnetwork_traits.dta", replace

* Homophily
foreach var in $type_network  {
gen `var'_samegender_pct=`var'_samegender_n/netsize_`var' 
}

foreach var in $type_network  {
gen `var'_samecaste_pct=`var'_same_caste_n/netsize_`var' 
}

foreach var in $type_network  {
gen `var'_samejatis_pct=`var'_samejatis_n/netsize_`var' 
}

foreach var in $type_network  {
 gen `var'_samelocation_pct=`var'_sameloc_n/netsize_`var' 
}

*Heterogeneity (Index of qualitative variation)
foreach var in $type_network  {
 gen `var'_lowcaste_pct=`var'_lowcaste_n/netsize_`var' 
 gen `var'_midcaste_pct=`var'_midcaste_n/netsize_`var' 
 gen `var'_upcaste_pct=`var'_upcaste_n/netsize_`var' 
}

foreach var in $type_network  {
forvalues i = 1/16 {
 gen `var'_jatis`i'_pct=`var'_jatis`i'_n/netsize_`var' 
}
}

*IQV - 
foreach var in debt_lowcaste_pct debt_midcaste_pct debt_upcaste_pct relative_lowcaste_pct relative_midcaste_pct relative_upcaste_pct talk_lowcaste_pct talk_midcaste_pct talk_upcaste_pct labour_lowcaste_pct labour_midcaste_pct labour_upcaste_pct debt_jatis1_pct debt_jatis2_pct debt_jatis3_pct debt_jatis4_pct debt_jatis5_pct debt_jatis6_pct debt_jatis7_pct debt_jatis8_pct debt_jatis9_pct debt_jatis10_pct debt_jatis11_pct debt_jatis12_pct debt_jatis13_pct debt_jatis14_pct debt_jatis15_pct debt_jatis16_pct relative_jatis1_pct relative_jatis2_pct relative_jatis3_pct relative_jatis4_pct relative_jatis5_pct relative_jatis6_pct relative_jatis7_pct relative_jatis8_pct relative_jatis9_pct relative_jatis10_pct relative_jatis11_pct relative_jatis12_pct relative_jatis13_pct relative_jatis14_pct relative_jatis15_pct relative_jatis16_pct talk_jatis1_pct talk_jatis2_pct talk_jatis3_pct talk_jatis4_pct talk_jatis5_pct talk_jatis6_pct talk_jatis7_pct talk_jatis8_pct talk_jatis9_pct talk_jatis10_pct talk_jatis11_pct talk_jatis12_pct talk_jatis13_pct talk_jatis14_pct talk_jatis15_pct talk_jatis16_pct labour_jatis1_pct labour_jatis2_pct labour_jatis3_pct labour_jatis4_pct labour_jatis5_pct labour_jatis6_pct labour_jatis7_pct labour_jatis8_pct labour_jatis9_pct labour_jatis10_pct labour_jatis11_pct labour_jatis12_pct labour_jatis13_pct labour_jatis14_pct labour_jatis15_pct labour_jatis16_pct {
gen `var'2=`var'^2
}

foreach var in debt_samegender_pct relative_samegender_pct talk_samegender_pct labour_samegender_pct debt_samecaste_pct relative_samecaste_pct talk_samecaste_pct labour_samecaste_pct debt_samejatis_pct relative_samejatis_pct talk_samejatis_pct labour_samejatis_pct debt_samelocation_pct relative_samelocation_pct talk_samelocation_pct labour_samelocation_pct {
gen `var'2=`var'^2
gen `var'invert2=(1-`var')^2
}

foreach var1 in $type_network  {
    gen `var1'_sumcaste_pct2 = 0
        foreach var2 in lowcaste_pct2 midcaste_pct2 upcaste_pct2 {
         replace `var1'_sumcaste_pct2 = `var1'_sumcaste_pct2 + `var1'_`var2'
    }
}

foreach var1 in $type_network  {
     gen `var1'_sumjatis_pct2 = 0
        foreach var2 in jatis1_pct2 jatis2_pct2 jatis3_pct2 jatis4_pct2 jatis5_pct2 jatis6_pct2 jatis7_pct2 jatis8_pct2 jatis9_pct2 jatis10_pct2 jatis11_pct2 jatis12_pct2 jatis13_pct2 jatis14_pct2 jatis15_pct2 jatis16_pct2 {
         replace `var1'_sumjatis_pct2 = `var1'_sumjatis_pct2 + `var1'_`var2'
    }
}

foreach var1 in $type_network  {
     gen `var1'_sumgender_pct2 = 0
        foreach var2 in samegender_pct2 samegender_pctinvert2 {
         replace `var1'_sumgender_pct2 = `var1'_sumgender_pct2 + `var1'_`var2'
    }
}

foreach var1 in $type_network  {
     gen `var1'_sumloc_pct2 = 0
        foreach var2 in samelocation_pct2 samelocation_pctinvert2 {
         replace `var1'_sumloc_pct2 = `var1'_sumloc_pct2 + `var1'_`var2'
    }
}

foreach var1 in $type_network  {
  gen `var1'_IQV_caste = (1-`var1'_sumcaste_pct2)/(1-(1/3))
  gen `var1'_IQV_jatis=(1-`var1'_sumjatis_pct2)/(1-(1/17))
  gen `var1'_IQV_gender=(1-`var1'_sumgender_pct2)/(1-(1/2))						
  gen `var1'_IQV_location=(1-`var1'_sumloc_pct2)/(1-(1/2))						
}

*Multiplexity
foreach var in $type_network  {
gen `var'_multiplex_pct=`var'_multiplexity_n/netsize_`var'
}

*Strenght
foreach var1 in $type_network  {
  gen `var1'_meetweekly_pct = `var1'_meetweekly_n/netsize_`var1'
  gen `var1'_veryintimate_pct=`var1'_veryintimate_n/netsize_`var1'
  gen `var1'_reciprocity_pct=`var1'_reciprocity_n/netsize_`var1'	
  gen `var1'_money_pct=`var1'_moneyoften_n/netsize_`var1'
}

save "Analysis\Subnetwork_traits.dta", replace

keep  HHINDID HHID2020 INDID2020 netsize_debt netsize_relative netsize_talk netsize_labour debt_duration relative_duration talk_duration labour_duration debt_strenght relative_strenght talk_strenght labour_strenght debt_samegender_pct relative_samegender_pct talk_samegender_pct labour_samegender_pct debt_samecaste_pct relative_samecaste_pct talk_samecaste_pct labour_samecaste_pct debt_samejatis_pct relative_samejatis_pct talk_samejatis_pct labour_samejatis_pct debt_samelocation_pct relative_samelocation_pct talk_samelocation_pct labour_samelocation_pct debt_IQV_caste debt_IQV_jatis debt_IQV_gender debt_IQV_location relative_IQV_caste relative_IQV_jatis relative_IQV_gender relative_IQV_location talk_IQV_caste talk_IQV_jatis talk_IQV_gender talk_IQV_location labour_IQV_caste labour_IQV_jatis labour_IQV_gender labour_IQV_location debt_multiplex_pct relative_multiplex_pct talk_multiplex_pct labour_multiplex_pct

save "Analysis\Subnetwork_traits_tomerge.dta", replace
****************************************
* END










****************************************
* Merging to datasets
****************************************
use "Analysis\Main_analyses.dta"
* Merge FullNetwork traits
merge m:1 HHID2020 INDID2020 using "Analysis\Fullnetwork_traits_tomerge.dta"
drop if _merge==1
drop _merge
*Merge Subnetworks traits
merge m:1 HHID2020 INDID2020 using "Analysis\Subnetwork_traits_tomerge.dta"
drop _merge

save "Analysis\Main_analyses_network.dta", replace
****************************************
* END
