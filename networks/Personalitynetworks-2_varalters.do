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
* Alter-level vars
****************************************
use "Analysis\NEEMSIS2-alters_subclean.dta", replace

********** Cleaning and selection
label define jatis 1 "Vanniyar" 2 "SC" 3 "Arunthathiyar" 4 "Rediyar" 5 "Gramani" 6 "Naidu" 7 "Navithar" 8 "Asarai" 9 "Settu" 10 "Nattar" 11 "Mudaliar" 12 "Kulalar" 13 "Chettiyar" 14 "Marwari" 15 "Muslims" 16 "Padayachi" 88 "D/K" 17 "Yathavar", replace
label value jatis_ego jatis
*
drop if dummyhh==1
drop if sex==.
* Si relative_network==1 & talk_network=1 => replace relative_network=0
replace relative_network=0 if relative_network==1 & talk_network==1



********** Network size 
***** Kin and non kin
ta relative_network
ta talk_network
gen kinnonkin_network=talk_network+relative_network
replace kinnonkin_network=1 if kinnonkin_network>1
ta kinnonkin_network
bys HHINDID : egen netsize_kinnonkin=total(kinnonkin_network)


***** Debt
bys HHINDID : egen netsize_debt=total(debt_network)
***** Close relative
bys HHINDID : egen netsize_relative=total(relative_network)
***** Talk the most
bys HHINDID : egen netsize_talk=total(talk_network)
***** Labour
bys HHINDID : egen netsize_labour=total(labour_network)
*
gen debt=debt_network
gen relative=relative_network
gen talk=talk_network
gen labour=labour_network
global type_network debt relative talk labour


********** Multiplexity 
*** Number of distinct types of ties by alters
egen multiplexity_alter=rowtotal(debt_network relative_network talk_network labour_network)
gen  multiplexity_dum=cond(multiplexity_alter>1,1,0)
foreach var in $type_network {
bys HHINDID : egen `var'_multiplexity_n=total(multiplexity_dum) if `var'==1
}


********** Tie strenght
***** Meet frequency : 
gen meetfrequency_weekly=cond(meetfrequency==1,1,0)
foreach var in $type_network {
bys HHINDID : egen `var'_meetweekly_n=total(meetfrequency_weekly) if `var'_network==1
}

***** Meet frequency bis
codebook meetfrequency
gen meetfrequencybis=meetfrequency
recode meetfrequencybis 6=3 5=3 4=3
tab meetfrequencybis
label define meetfrequencybis 1"At least once a week" 2"At least once a month" 3"Less often"
label value meetfrequencybis meetfrequencybis
tab meetfrequencybis



***** Intimacy
tab	 intimacy
gen very_intimate=cond(intimacy==3,1,0)
foreach var in $type_network {
bys HHINDID : egen `var'_veryintimate_n=total(very_intimate) if `var'_network==1
}

***** Invitation
tab	invite  reciprocity1 
gen invite_reciprocity=cond(invite==1 & reciprocity1==1,1,0)
foreach var in $type_network  {
bys HHINDID : egen `var'_reciprocity_n=total(invite_reciprocity) if `var'_network==1
}

***** Duration (How to deal with measurment errors ?)
gen duration_corr=cond(duration<=age_ego,duration,.) 
gen duration_cat=1 if duration<5
replace duration_cat=2 if duration>=5 & duration<10
replace duration_cat=3 if duration>=10 & duration<15
replace duration_cat=4 if duration>=15 & duration<20
replace duration_cat=5 if duration>=20 & duration<25
replace duration_cat=6 if duration>=25 & duration<30
replace duration_cat=7 if duration>=30 
tab duration_cat
*
foreach var in $type_network  {
bys HHINDID : egen `var'_duration=mean(duration_corr) if `var'_network==1
}

***** Duration bis
gen duration_catbis=1 if duration<10
replace duration_catbis=2 if duration>=10 & duration<20
replace duration_catbis=3 if duration>=20 & duration<30
replace duration_catbis=4 if duration>=30
tab duration_catbis
label define duration_catbis 1"0-9" 2"10-19" 3"20-29" 4">=30"
label value duration_catbis duration_catbis
tab duration_catbis

***** Exchange money
tab money
gen money_often=cond(money==1 | money==2,1,0)
foreach var in $type_network  {
bys HHINDID : egen `var'_moneyoften_n=total(money_often) if `var'_network==1
}


***** MCA 
*
* mca meetfrequencybis intimacy invite_reciprocity duration_catbis, method (indicator) normal(princ)
*
mca meetfrequencybis intimacy invite_reciprocity duration_catbis 
predict dim1
sum dim1
gen strength_mca=(dim1-`r(min)')/(`r(max)'-`r(min)')
gen debt_strength=strength_mca if debt_network==1
gen talk_strength=strength_mca if talk_network==1
gen relative_strength=strength_mca if relative_network==1
gen labour_strength=strength_mca if labour_network==1


********** Ego-alter similarity
***** Gender
gen same_gender=cond(sex==sex_ego,1,0)
foreach var in $type_network  {
bys HHINDID : egen `var'_samegender_n=total(same_gender) if `var'_network==1
}

***** Caste (si caste=Don't know alors on part du principe que ce n'est pas la même caste)
gen samecaste=cond(caste==caste_ego,1,0)
foreach var in $type_network  {
bys HHINDID : egen `var'_samecaste_n=total(samecaste) if `var'_network==1
}
tab caste, gen(caste)
*Si caste=Don't know, on part du principe que c'est l'inférieur
replace caste1=1 if caste4==1
foreach var in $type_network  {
bys HHINDID : egen `var'_lowcaste_n=total(caste1) if `var'_network==1
bys HHINDID : egen `var'_midcaste_n=total(caste2) if `var'_network==1
bys HHINDID : egen `var'_upcaste_n=total(caste3) if `var'_network==1
}

***** Jatis
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

***** Living place 
gen same_location=cond(inlist(living,1,2),1,0)
replace same_location=1 if relative_network==1 & living==.
foreach var in $type_network  {
bys HHINDID : egen `var'_sameloc_n=total(same_location) if `var'_network==1
}


*
save "Analysis\Alters_sub.dta", replace
****************************************
* END














****************************************
* Ego-level vars
****************************************
use "Analysis\Alters_sub.dta", clear

********* Collapse
collapse (first) HHID2020 INDID2020 (mean) ///
netsize_debt netsize_relative netsize_talk netsize_labour netsize_kinnonkin ///
debt_multiplexity_n relative_multiplexity_n talk_multiplexity_n labour_multiplexity_n ///
debt_meetweekly_n relative_meetweekly_n talk_meetweekly_n labour_meetweekly_n ///
debt_veryintimate_n relative_veryintimate_n talk_veryintimate_n labour_veryintimate_n ///
debt_reciprocity_n relative_reciprocity_n talk_reciprocity_n labour_reciprocity_n ///
debt_duration relative_duration talk_duration labour_duration ///
debt_moneyoften_n relative_moneyoften_n talk_moneyoften_n labour_moneyoften_n ///
debt_samegender_n relative_samegender_n talk_samegender_n labour_samegender_n ///
debt_samecaste_n relative_samecaste_n talk_samecaste_n labour_samecaste_n ///
debt_lowcaste_n debt_midcaste_n debt_upcaste_n relative_lowcaste_n relative_midcaste_n relative_upcaste_n talk_lowcaste_n talk_midcaste_n talk_upcaste_n labour_lowcaste_n labour_midcaste_n labour_upcaste_n ///
debt_samejatis_n relative_samejatis_n talk_samejatis_n labour_samejatis_n ///
debt_jatis1_n debt_jatis2_n debt_jatis3_n debt_jatis4_n debt_jatis5_n debt_jatis6_n debt_jatis7_n debt_jatis8_n debt_jatis9_n debt_jatis10_n debt_jatis11_n debt_jatis12_n debt_jatis13_n debt_jatis14_n debt_jatis15_n debt_jatis16_n relative_jatis1_n relative_jatis2_n relative_jatis3_n relative_jatis4_n relative_jatis5_n relative_jatis6_n relative_jatis7_n relative_jatis8_n relative_jatis9_n relative_jatis10_n relative_jatis11_n relative_jatis12_n relative_jatis13_n relative_jatis14_n relative_jatis15_n relative_jatis16_n talk_jatis1_n talk_jatis2_n talk_jatis3_n talk_jatis4_n talk_jatis5_n talk_jatis6_n talk_jatis7_n talk_jatis8_n talk_jatis9_n talk_jatis10_n talk_jatis11_n talk_jatis12_n talk_jatis13_n talk_jatis14_n talk_jatis15_n talk_jatis16_n labour_jatis1_n labour_jatis2_n labour_jatis3_n labour_jatis4_n labour_jatis5_n labour_jatis6_n labour_jatis7_n labour_jatis8_n labour_jatis9_n labour_jatis10_n labour_jatis11_n labour_jatis12_n labour_jatis13_n labour_jatis14_n labour_jatis15_n labour_jatis16_n ///
debt_sameloc_n relative_sameloc_n talk_sameloc_n labour_sameloc_n ///
debt_strength relative_strength talk_strength labour_strength ///
, by (HHINDID) 	

********** Selection
keep HHINDID HHID2020 INDID2020 netsize_debt netsize_relative netsize_kinnonkin netsize_talk debt_meetweekly_n relative_meetweekly_n talk_meetweekly_n debt_duration relative_duration talk_duration debt_samegender_n relative_samegender_n talk_samegender_n debt_samecaste_n relative_samecaste_n talk_samecaste_n debt_strength relative_strength talk_strength
		
save "Analysis\Subnetwork_traits.dta", replace




********** Construction
use "Analysis\Subnetwork_traits.dta", replace

***** Heterophily = EI index
gen debt_EI_gender=((netsize_debt-debt_samegender_n)-debt_samegender_n)/netsize_debt
gen relative_EI_gender=((netsize_relative-relative_samegender_n)-relative_samegender_n)/netsize_relative 
gen talk_EI_gender=((netsize_talk-talk_samegender_n)-talk_samegender_n)/netsize_talk

gen debt_EI_caste=((netsize_debt-debt_samecaste_n)-debt_samecaste_n)/netsize_debt
gen relative_EI_caste=((netsize_relative-relative_samecaste_n)-relative_samecaste_n)/netsize_relative 
gen talk_EI_caste=((netsize_talk-talk_samecaste_n)-talk_samecaste_n)/netsize_talk

***** Dummy fo EI
label define dum 0"Perfect homophily" 1"Heterophily"
foreach x in debt_EI_gender debt_EI_caste talk_EI_gender talk_EI_caste relative_EI_gender relative_EI_caste {
gen dum_`x'=.
}
foreach x in debt_EI_gender debt_EI_caste talk_EI_gender talk_EI_caste relative_EI_gender relative_EI_caste {
replace dum_`x'=1 if `x'>-1 & `x'!=.
replace dum_`x'=0 if `x'==-1 & `x'!=.
label values dum_`x' dum
}
tab1 dum_debt_EI_gender dum_debt_EI_caste dum_talk_EI_gender dum_talk_EI_caste dum_relative_EI_gender dum_relative_EI_caste



***** Strenght
gen debt_meetweekly_pct = debt_meetweekly_n/netsize_debt
gen relative_meetweekly_pct = relative_meetweekly_n/netsize_relative
gen talk_meetweekly_pct = talk_meetweekly_n/netsize_talk


save "Analysis\Subnetwork_traits.dta", replace

keep  HHINDID HHID2020 INDID2020 netsize_debt netsize_relative netsize_kinnonkin netsize_talk debt_duration relative_duration talk_duration debt_strength relative_strength talk_strength debt_EI_gender relative_EI_gender talk_EI_gender debt_EI_caste relative_EI_caste talk_EI_caste dum_debt_EI_gender dum_debt_EI_caste dum_talk_EI_gender dum_talk_EI_caste dum_relative_EI_gender dum_relative_EI_caste debt_meetweekly_pct relative_meetweekly_pct talk_meetweekly_pct

save "Analysis\Subnetwork_traits_tomerge.dta", replace
****************************************
* END










****************************************
* Merging to datasets
****************************************
use "Analysis\Main_analyses.dta"

*Merge Subnetworks traits
merge m:1 HHID2020 INDID2020 using "Analysis\Subnetwork_traits_tomerge.dta"
drop _merge

save "Analysis\Main_analyses_network.dta", replace
****************************************
* END
